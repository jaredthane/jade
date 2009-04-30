#Install ruby
echo "Installing Ruby"
sudo aptitude install ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8 libopenssl-ruby sqlite3 libsqlite3-ruby1.8

# Install Ruby Gems
echo "Installing Ruby Gems"
wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
tar -xf rubygems-1.3.1.tgz
cd rubygems-1.3.1
sudo ruby setup.rb
cd ..


echo "Installing MySQL"
sudo aptitude install mysql libmysqlclient-dev

# Install Rails
echo "Installing Rails"
sudo gem install rails
echo "Installing Prawn"
sudo gem install prawn
echo "Installing Pagination"
sudo gem install will_paginate
echo "Installing MySQL Gem"
sudo gem install mysql
echo "Installing Jade database"
sudo mysql -p < clean.sql
