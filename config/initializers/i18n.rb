I18n.default_locale = 'ru-RU'

module I18n
  @@last_reload ||= Time.now - 1.hour
  @@logger = Logger.new(STDERR)

  class << self
    def reload_locales!( force = false )
      if ENV['RAILS_ENV'] == 'production' && !force && Time.now - @@last_reload < 1.minute
        false
      else
        logger.info "I18n: Reloading locales.."
        I18n.backend.load_translations(*find_locale_files)
        @@last_reload = Time.now
        true
      end
    end

    def find_locale_files
        locales_dir = File.join(RAILS_ROOT, 'config', 'locales')
        Dir["#{locales_dir}/*.{rb,yml}"].uniq
    end

    def logger=(logger)
      @@logger = logger
    end

    def logger
      @@logger
    end

    def locales
      ['ru-RU', 'en-US', 'ru']
    end
  end

  module Backend
    class SimpleRu < Simple
      def pluralize(locale, entry, count)
        return entry unless entry.is_a?(Hash) and count

        if locale == 'ru-RU'
          russian_pluralize(locale, entry, count)
        else
          default_pluralize(locale, entry, count)
        end
      end

      def default_pluralize(locale, entry, count)
        key = if count == 0 && entry.has_key?(:zero)
          :zero
        elsif count == 1
          :one
        else
          # для совместимости со старым форматом и между русскими и английскими локалями
          # для множественного числа в en-US можно использовать любой ключ из [:other, :two, :six]
          [:other, :two, :six].find{ |k| entry.has_key?(k) } || :other
        end
        raise InvalidPluralizationData.new(entry, count) unless entry.has_key?(key)
        entry[key]
      end

      def russian_pluralize(locale, entry, count)
        key = if count == 0 && entry.has_key?(:zero)
          :zero
        else
          # взято из rutils 0.2.5
          (count%10==1 && count%100!=11 ? :one : count%10>=2 && count%10<=4 && (count%100<10 || count%100>=20) ? :two : :six)
        end

        raise InvalidPluralizationData.new(entry, count) unless entry.has_key?(key)
        entry[key]
      end
    end
  end

  # класс-прокся для мест, в которых в оригинале стояли просто статические строки,
  # а нужно поставить динамические строки, генерящиеся в зависимости от локали.
  # используется через метод i18n_proxy класса Object
  # (пример - валидации в моделях)
  class Proxy
    def initialize(key, scope=nil, args={})
      @key = key
      @i18n_scope = scope
      @args = args
    end

    # <мимикрируем под обычную строку>
    def to_s
      t(@key, @args)
    end

    alias :to_str  :to_s

    def ==(arg)
      self.to_s == arg
    end

    def ===(arg)
      self.to_s === arg
    end

    def <=>(arg)
      self.to_s <=> arg
    end

    def inspect
      self.to_s.inspect
    end

#    def hash
#      self.to_s.hash
#    end

    def method_missing method, *args
      self.to_s.send(method,*args)
    end
    # </мимикрируем под обычную строку>
  end

end


module ActiveRecord
  module ConnectionAdapters
    module Quoting
      alias :quote_no_i18n :quote
      def quote *args
        if args.first.is_a?(I18n::Proxy)
          args[0] = args[0].to_s
        end
        quote_no_i18n(*args)
      end
    end
  end
end


I18n.logger  = RAILS_DEFAULT_LOGGER if defined?(RAILS_DEFAULT_LOGGER) && RAILS_DEFAULT_LOGGER
I18n.backend = I18n::Backend::SimpleRu.new
I18n.load_path = I18n.find_locale_files
I18n.reload_locales!

module Lady
  module SmartTranslate
    # функция для локализации строк
    #
    # расширение функционала I18n.t:
    #   1) подставляет в scope имя текущего контроллера (если он есть)
    #   2) подставляет в default ключ строки без scope, для fallback'a в глобально определенные строки
    #
    # ?? убрать или оставить ??
    #   3) если строка не найдена то вместо "translation missing: ru-RU, ..." возвращает key.to_s.humanize
    def translate *args
      if (args.size == 1 || ( args[1].is_a?(Hash) && !args[1][:scope] )) && !args.first.to_s['.']
        key = args.first
        params = args[1] || {}

        params[:default] ||= []
        params[:default] = [params[:default]] unless params[:default].is_a?(Array)
        params[:default] << key.to_sym
  #      params[:default] << key.to_s.humanize

        scope = if defined?(@i18n_scope) && @i18n_scope
          @i18n_scope
        elsif defined?(controller)
          controller.class.to_s.underscore
  #      elsif defined?(controller_name)
  #        controller_name
        elsif self.is_a?(Class)
          self.to_s.underscore
        else
          self.class.to_s.underscore
        end.to_s.tr('/','.')

        params[:raise] = true

        key = "#{scope}.#{key}" if scope

        begin
          # клонируем params потому что I18n.translate их портит и при повторном вызове (в случае промаха) получаем косяк
          I18n.translate( key, params.clone )
        rescue I18n::MissingTranslationData
          I18n.logger.warn "I18n: Translation missing: #{I18n.locale}, '#{key}' in #{caller[0].to_s.sub("#{RAILS_ROOT}/",'').split(':')[0..-2].join(':')}"
          if I18n.reload_locales!
            return( I18n.translate( key, params) ) rescue I18n::MissingTranslationData
          end
  #        "** translation missing: #{I18n.locale}, #{key} **"
          raise "** translation missing: #{I18n.locale}, #{key} **"
        end
      else
        I18n.translate *args
      end
    end

    alias :t :translate

    # глобальный метод для мест, в которых в оригинале стояли просто статические строки,
    # а нужно поставить динамические строки, генерящиеся в зависимости от локали
    # (пример - валидации в моделях)
    # пример: validates_presence_of :some_value, :message => i18n_proxy(:my_error_message_key)
    def i18n_proxy key, args = {}
      scope =
        if self.is_a?(Class)
          self.to_s.underscore
        else
          self.class.to_s.underscore
        end
      I18n::Proxy.new(key, scope, args)
    end

    def with_i18n_scope scope
      previous_scope, @i18n_scope = @i18n_scope, scope
      result = yield
      @i18n_scope = previous_scope
      result
    end

    def with_locale_scope locale
      previous_locale, I18n.locale = I18n.locale, locale
      result = yield
      I18n.locale = previous_locale
      result
    end

  end
end

# иначе в rails 2.2 будет использоваться встроенный translate()
ActionView::Base.send(:include, Lady::SmartTranslate)
ActionController::Base.send(:include, Lady::SmartTranslate)

# а это и для 2.0.2 и для 2.2
Object.send(:include, Lady::SmartTranslate)

