module ApplicationHelper

  def custom_error_messages_for(object_name)
    object = instance_variable_get("@#{object_name}")
    return '' if !object  || object.errors.empty?
    res = ''
    object.errors.each { |k, v| res << '<li>' + v + "</li>\n" if v.to_s != '' }
    "<br /><div id=\"errorExplanation\"><h2>"+t("errors_on_create")+":</h2><ul>" + res + '</ul></div>'
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
    t("seo_pages." +
      (params[:controller] || '') + "." +
      (params[:action] || '') + "." +
      (params[:id] || 'first') + "." +
      ('title_' << (params[:page] || '1')),
    :default => t("not_here_title"))
  end

end
