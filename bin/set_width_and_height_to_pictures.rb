#!/usr/local/bin/ruby18
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)

Picture.find(:all, :conditions => ["photo_cached_width_original IS NULL OR photo_cached_width_resized IS NULL"]).each {|picture|
  picture.set_width_and_height
  picture.save!
}
