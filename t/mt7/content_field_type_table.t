use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT::Test qw( :app );

use MT::ContentFieldType::Table;

my $one_one = MT::ContentFieldType::Table::_create_empty_table( 1, 1 );
is( $one_one, '<tr><td></td></tr>' );

my $two_two = MT::ContentFieldType::Table::_create_empty_table( 2, 2 );
is( $two_two, "<tr><td></td><td></td></tr>\n<tr><td></td><td></td></tr>" );

my $one_three = MT::ContentFieldType::Table::_create_empty_table( 1, 3 );
is( $one_three, "<tr><td></td><td></td><td></td></tr>" );

done_testing;

