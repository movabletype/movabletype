FROM centos:centos6

RUN yum clean all
RUN yum -y update

RUN yum -y install httpd

RUN yum -y install mysql mysql-server
RUN yum -y install memcached

#### Perl
RUN yum -y install perl perl-core

# For installing XSS modules.
RUN yum -y install gcc

# For installing Net::SSLeay
RUN yum -y install openssl-devel

# Install GD from RPM.
RUN yum -y install perl-GD

# Install Image::Magick from RPM.
RUN yum -y install ImageMagick-perl

# For installing Math::GMP.
RUN yum -y install gmp-devel

# For installing XML::Parser.
RUN yum -y install expat-devel perl-XML-Parser

# For installing XML::LibXML.
RUN yum -y install libxml2-devel

# For installing Archive::Zip.
RUN yum -y install zip unzip

RUN yum -y install wget
RUN wget -O - https://cpanmin.us | perl - App::cpanminus

# Update for installing SOAP::Lite. Cannot install by cpanm and old Archive::Tar.
RUN cpanm Archive::Tar

RUN wget https://raw.githubusercontent.com/movabletype/movabletype/develop/t/cpanfile
RUN cpanm --installdeps .
RUN cpanm DateTime DateTime::TimeZone Test::Pod::Coverage Clone

# PHP
RUN yum -y install php php-mysql php-gd
RUN sed 's/^;date\.timezone =/date\.timezone = "Asia\/Tokyo"/' -i /etc/php.ini

# PHPUnit
RUN yum -y install php-xml
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit

RUN service mysqld start & sleep 10 && \
    mysql -e "create database mt_test default character set utf8;" && \
    mysql -e "grant all privileges on mt_test.* to mt@localhost;" && \
    service mysqld stop

RUN yum clean all
RUN rm ./cpanfile
