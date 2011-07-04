module Paperclip
  class Attachment
    def width(style = default_style)
      Paperclip::Geometry.from_file(to_file(style)).width
    end
    def height(style = default_style)
      Paperclip::Geometry.from_file(to_file(style)).height
    end
  end
end
