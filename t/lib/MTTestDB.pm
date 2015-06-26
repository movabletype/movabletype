package MTTestDB;
use strict;
use warnings;

# Set 'mysql_install_db' and 'mysqld' to Test::mysqld instance.
# These parameters cannot be set from App::Prove::Plugin::MySQLPool.
{
    use Test::mysqld;
    use Test::mysqld::Pool;
    my $new              = \&Test::mysqld::new;
    my $_launch_instance = \&Test::mysqld::Pool::_launch_instance;

    no warnings 'redefine';
    *Test::mysqld::Pool::_launch_instance = sub {
        local *Test::mysqld::new = sub {
            my ( $class, %args ) = @_;
            $args{mysql_install_db} = '/usr/bin/mysql_install_db';
            $args{mysqld}           = '/usr/bin/mysqld_safe';
            $new->( $class, %args );
        };

        $_launch_instance->(@_);
    };
}

sub prepare { }

1;
