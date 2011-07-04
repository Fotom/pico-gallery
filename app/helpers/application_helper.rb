require 'jcode'
module ApplicationHelper

  def custom_error_messages_for(object_name)
    object = instance_variable_get("@#{object_name}")
    return '' if !object  || object.errors.empty?
    res = ''
    object.errors.each { |k, v| res << '<li>' + v + "</li>\n" if v.to_s != '' }
    "<br /><div id=\"errorExplanation\"><h2>"+t("errors_on_create")+":</h2><ul>" + res + '</ul></div>'
  end

  def fix_symbols(str, cnt = Constant::SHORT_DESCRIPTION_LENGTH)
    (str.jlength > cnt) ? str[/.{0,#{cnt}}/m] << '...' : str
  end

  def header_content
    (!@content_text.blank? ?
        @content_text :
        ((!params[:controller].blank? && (params[:controller] == 'pictures')) ?
          (build_header_content) :
          ''))
  end

  def page_title
    title build_page_title
  end

  def alt_for_picture(picture)
    picture_subject_for_default_locale(picture, {:with_comma => true}) +
      t("part_names.#{picture.part.id}", :default => picture.part.name)  + ', ' +
      t("common.general_keyword")
  end

  alias :title_for_picture :alt_for_picture

  def short_picture_description(picture)
    fix_symbols(picture.subject.blank? || !is_default_locale? ?
        (t("picture_view.show") + " " +
         t("part_names.#{picture.part.id}", :default => picture.part.name)) :
      picture.subject)
  end

  private

  def build_header_content
    t("seo_pages." +
      (params[:controller] || '') + "." +
      (params[:action] || '') + "." +
      (params[:id] || 'first') + "." +
      ('page_' << (params[:page] || '')),
    :default => t("not_here_content"))
  end

  def build_page_title
    build_page_element("title")
  end

  def build_page_element(name)
    t("seo_pages." + common_path_to_page_unique_elements(name+'_'), :default => t("not_here_#{name}"))
  end

  def common_path_to_page_unique_elements(name)
    (params[:controller] || '') + "." +
    (params[:action] || '') + "." +
    (params[:id] || 'first') + "." +
    (name + (params[:page] || '1'))
  end

end
