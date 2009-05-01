#Check that we received enough args
if [ "$#" -lt 2 ]
then 
    echo ""
    echo "Usage: ./install.sh home_site_name [root_mysql_passwd]"
    echo ""
    echo "Make sure the passwd you specify matches the one you give MySQL during its configuration"
    echo "If you do not specify the root mysql passwd, you will be prompted when the time comes"
    echo ""
else
    #Install Ruby
    echo "Installing Ruby"
    sudo aptitude install ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8 libopenssl-ruby sqlite3 libsqlite3-ruby1.8

    # Install Ruby Gems
    echo "Installing Ruby Gems"
    wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
    tar -xf rubygems-1.3.1.tgz
    cd rubygems-1.3.1
    sudo ruby setup.rb
    cd ..
    
    # Install MySQL
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
    sudo mysql -p$2 -e "create database Jade"
    sudo mysql -p$2 Jade < clean.sql
    sudo mysql -p$2 Jade -e "update entities set name = $1 where id=5"
    echo "Configuring Jade"
    cp database.yml.sample config/database.yml
    sed -i 's/pa$$word/$2/g' config/database.yml
    chmod 400 config/database.yml
fi