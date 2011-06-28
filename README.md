Summary
==================================================
Pico-galery is common pool of users photos and images. Anyone can load self images on site and after premoderation they appear in appropriate section.

Work on rails 2.3

Installation
--------------------------------------

This is complite rails application and it can be installed quite simply, like all similar.

	git clone git://github.com/Fotom/pico-gallery.git
	cd pico-gallery
	git checkout -b my-pico-gallery

	# ImageMagick, example for debian
	sudo apt-get install librmagick-ruby imagemagick

	# install missing gems
	rake gems:install

	cp config/database.example.yml config/database.yml
	# Edit config/database.yml, create database for new project

	rake db:migrate

	# replace locale "ru-RU" to "en" or another in files
	# config/initializers/i18n.rb
	# config/environment.rb

	ruby script/server
	# Open http://localhost:3000 in your browser

Users ability
--------------------------------------

All users can watch and upload photo.

Admins interface
--------------------------------------

Admin part is available at the following url http://localhost:3000/common_admins/login. Admin can upload photos and Approve/Edit/Delete users and existing photos.
Admin interface is extremely minimalistic at the moment.

to access as admin to create a database record:
insert into constants(name, value) values('admin_password', '********');

SEO
--------------------------------------

Project has great potential for SEO optimization. For any page you can set suitable  description and title, if local settings is not defined then they will be taken from common settings (in this case exists common title and description). After indexing search engine, you can get a fairly large number of relevant keywords. Texts are placed in config/locales/en.yml local file.

Localization
--------------------------------------

The site translated into Russian and English languages.

The sample site is available at [picolove](http://picolove.ru/en)

Authors
--------------------------------------

Personal blog author: [Malykh Oleg](http://malyh.com/) - blog in russian
