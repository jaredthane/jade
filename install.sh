#Install ruby
sudo aptitude install ruby ruby1.8-dev irb

# Install Ruby Gems
wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
tar -xf rubygems-1.3.1.tgz
cd rubygems-1.3.1
sudo ruby setup.rb

# Install Rails
sudo gem install rails

sudo aptitude install mysql libmysqlclient-dev
sudo aptitude install git

sudo gem install prawn
sudo gem install will_paginate

# install ruby mysql gem
sudo gem install mysql

echo "You still need to configure mysql and add the database"

