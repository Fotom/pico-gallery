#!/usr/local/bin/ruby18
require 'yaml'
require 'russian'
require 'getoptlong'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)

part_id = Part.first.id
picture_type = Picture::PICTURE

@files = Dir.glob(RAILS_ROOT + '/public/for_upload/*')

for f in @files

  next if f =~ /translit_files.rb/

  @picture = Picture.new()

  @picture.part_id = part_id
  @picture.type_id = picture_type
  file = File.open(f, 'r')
  @picture.photo = file
  @picture.subject = ''

  if @picture.save
    puts "Added"
    # delete file if success added
    file.close
    File.delete(f)
  else
    puts "Error from save: #{f}"
    file.close
  end

end



