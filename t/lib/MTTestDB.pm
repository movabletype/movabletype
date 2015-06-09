package MTTestDB;
use strict;
use warnings;

sub prepare { }

sub my_cnf {
    +{  mysql_install_db => '/usr/bin/mysql_install_db',
        mysqld           => '/usr/bin/mysqld_safe',
    };
}

1;
