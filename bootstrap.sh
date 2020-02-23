#!/usr/bin/env bash
# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

# function install_rbenv {
#     git clone git://github.com/sstephenson/rbenv.git .rbenv
#     echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
#     echo 'eval "$(rbenv init -)"' >> ~/.profile
#     exec $SHELL

#     git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
#     echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.profile
#     exec $SHELL
# }

echo adding swap file
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

# Prevents "Warning: apt-key output should not be parsed (stdout is not a terminal)".
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo -E apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

echo updating package information
apt-get -y update >/dev/null 2>&1

install Git git

install Ruby ruby-full
install 'development tools' build-essential autoconf libtool

# echo installing current RubyGems
gem update --system -N >/dev/null 2>&1

echo installing Bundler
gem install bundler -N >/dev/null 2>&1

# install_rbenv

install SQLite sqlite3 libsqlite3-dev
install memcached memcached
install Redis redis-server
install RabbitMQ rabbitmq-server

install PostgreSQL postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser vagrant
sudo -u postgres createdb -O vagrant -E UTF8 -T template0 activerecord_unittest
sudo -u postgres createdb -O vagrant -E UTF8 -T template0 activerecord_unittest2

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
install MySQL mysql-server libmysqlclient-dev
# Set the password in an environment variable to avoid the warning issued if set with `-p`.
MYSQL_PWD=root mysql -uroot <<SQL
CREATE USER 'rails'@'localhost';
CREATE DATABASE activerecord_unittest  DEFAULT CHARACTER SET utf8mb4;
CREATE DATABASE activerecord_unittest2 DEFAULT CHARACTER SET utf8mb4;
GRANT ALL PRIVILEGES ON activerecord_unittest.* to 'rails'@'localhost';
GRANT ALL PRIVILEGES ON activerecord_unittest2.* to 'rails'@'localhost';
GRANT ALL PRIVILEGES ON inexistent_activerecord_unittest.* to 'rails'@'localhost';
SQL

install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev
install 'Blade dependencies' libncurses5-dev
install 'ExecJS runtime' nodejs
install 'Yarn' yarn

# To generate guides in Kindle format.
install 'ImageMagick' imagemagick
echo installing KindleGen
kindlegen_tarball=kindlegen_linux_2.6_i386_v2_9.tar.gz
# wget -q http://kindlegen.s3.amazonaws.com/$kindlegen_tarball
# tar xzf $kindlegen_tarball kindlegen
# mv kindlegen /usr/local/bin
# rm $kindlegen_tarball

install 'MuPDF' mupdf mupdf-tools
install 'FFmpeg' ffmpeg
install 'Poppler' poppler-utils

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo 'all set, rock on!'
