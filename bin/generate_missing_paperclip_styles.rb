#!/usr/local/bin/ruby18
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require "ftools"

photos_path = "#{RAILS_ROOT}/public/images/pictures/photos"

Dir.foreach(photos_path) do |e|
  next if e =~ /\./
  p e
  Dir.foreach(photos_path+"/#{e}") do |f|
    next if !File.file?(photos_path+"/#{e}/#{f}") || (f !~ /^original/)
    new_file_name = f.sub(/^original/, "resized")
    next if File.exists?(photos_path+"/#{e}/#{new_file_name}")
    File.copy(photos_path+"/#{e}/#{f}",photos_path+"/#{e}/#{new_file_name}")
    p new_file_name
  end
end