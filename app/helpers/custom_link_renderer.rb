class CustomLinkRenderer < WillPaginate::LinkRenderer

  def page_link(page, text, attributes = {})
    current_path = @template.url_for(@url_params)
    return (@template.link_to text, "#{current_path}?page=#{page}", attributes) if current_path =~ /admin/
    if current_path == '/'
      @template.link_to text, "/page/#{page}", attributes
    else
      @template.link_to text, "#{current_path}/page/#{page}", attributes
    end
  end

end