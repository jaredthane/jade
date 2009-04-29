#Install ruby
sudo aptitude install ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8 libopenssl-ruby sqlite3 libsqlite3-ruby1.8

# Install Ruby Gems
wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
tar -xf rubygems-1.3.1.tgz
cd rubygems-1.3.1
sudo ruby setup.rb

# Install Rails
sudo gem install rails

sudo aptitude install mysql libmysqlclient-dev

sudo gem install prawn
sudo gem install will_paginate

# install ruby mysql gem
sudo gem install mysql

echo "You still need to configure mysql and add the database"

