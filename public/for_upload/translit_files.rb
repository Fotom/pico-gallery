#!/usr/local/bin/ruby18
# for windows, ru -> en file name conversation
require 'russian'
require 'unicode'
require 'iconv'

$KCODE = 'u'

@files = Dir.glob('*')
utf8 = Iconv.new("utf-8","windows-1251")
cp866 = Iconv.new("cp866", "windows-1251")

for f in @files

  next if f == 'translit_files.rb'
  next if !File.file?(f)

  file_name_for_cmd = cp866.iconv(f)
  file_name_unicode = utf8.iconv(f)
  file_name_translit = Russian.translit(file_name_unicode)

  puts file_name_for_cmd + ' -> ' + file_name_translit

  File.rename(f, file_name_translit)

end



