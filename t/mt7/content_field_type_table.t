use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test qw( :app );

use MT::ContentFieldType::Table;

my $one_one = MT::ContentFieldType::Table::_create_empty_table( 1, 1 );
is( $one_one, '<tr><td></td></tr>' );

my $two_two = MT::ContentFieldType::Table::_create_empty_table( 2, 2 );
is( $two_two, "<tr><td></td><td></td></tr>\n<tr><td></td><td></td></tr>" );

my $one_three = MT::ContentFieldType::Table::_create_empty_table( 1, 3 );
is( $one_three, "<tr><td></td><td></td><td></td></tr>" );

done_testing;

