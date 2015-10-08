FROM centos:centos6

RUN yum clean all
RUN yum -y update

RUN yum -y install httpd

RUN yum -y install mysql mysql-server mysql-devel
RUN yum -y install memcached

#### Perl
RUN yum -y install perl perl-core

# For installing XSS modules.
RUN yum -y install gcc

# For installing Net::SSLeay
RUN yum -y install openssl-devel

# Install GD from RPM.
RUN yum -y install perl-GD gd-devel

# Install Image::Magick from RPM.
RUN yum -y install ImageMagick-perl

# Enable Imager to manipulate GIF.
RUN yum -y install giflib-devel

# Install netpbm commands.
RUN yum -y install netpbm-progs

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
RUN cpanm Carton
WORKDIR /var/www/docker_build
ENV PERL_CPANM_OPT -L /var/www/docker_build/local

# Installation of Math::BigInt >=1.9994 is failed on CircleCI.
RUN cpanm Math::BigInt@1.9993

# Update for installing SOAP::Lite. Cannot install by cpanm and old Archive::Tar.
RUN cpanm Archive::Tar

# LWP::Protocol::https's test fails.
# https://rt.cpan.org/Public/Bug/Display.html?id=104150
RUN cpanm LWP::Protocol::https -n

# Term::ReadKey cannot be installed by "docker build".
RUN cpanm Term::ReadKey -n

# For installing Text::Aspell.
RUN yum -y install epel-release
RUN yum -y install aspell-en aspell-devel

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

# OpenLDAP
RUN cpanm Net::LDAP
RUN yum -y install openldap-clients openldap-servers
COPY t/ldif/cn=config.ldif /var/www/docker_build/cn=config.ldif
COPY t/ldif/example_com.ldif /var/www/docker_build/example_com.ldif
COPY t/ldif/example_jp.ldif /var/www/docker_build/example_jp.ldif
COPY t/ldif/domain1_example_jp.ldif /var/www/docker_build/domain1_example_jp.ldif
COPY t/ldif/domain2_example_jp.ldif /var/www/docker_build/domain2_example_jp.ldif
RUN mkdir /var/lib/ldap/jp
RUN chown ldap:ldap /var/lib/ldap/jp
RUN service slapd start & sleep 10 && \
    ldapmodify -Y EXTERNAL -H ldapi:// -f cn=config.ldif && \
    ldapadd -f example_com.ldif -x -D "cn=admin,dc=example,dc=com" -w secret && \
    ldapadd -f example_jp.ldif -x -D "cn=admin,dc=example,dc=jp" -w secret && \
    ldapadd -f domain1_example_jp.ldif -x -D "cn=admin,dc=example,dc=jp" -w secret && \
    ldapadd -f domain2_example_jp.ldif -x -D "cn=admin,dc=example,dc=jp" -w secret && \
    service slapd stop

# Install CPAN modules
COPY t/cpanfile /var/www/docker_build/cpanfile
RUN carton install

ENV PERL5LIB /var/www/docker_build/local/lib/perl5

