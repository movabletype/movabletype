use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT::Test qw( :db );

use MT::ContentType;

subtest 'unique_key' => sub {
    my $ct = MT::ContentType->new;
    $ct->set_values( { blog_id => 1 } );

    $ct->unique_key('123');
    is( $ct->unique_key, undef, 'cannot set unique_key' );

    $ct->save or die $ct->errstr;
    ok( $ct->unique_key, 'set unique_key after save' );

    my $unique_key = $ct->unique_key;
    $ct->unique_key( $unique_key . '456' );
    is( $ct->unique_key, $unique_key, 'cannot set unique_key' );
};

done_testing;

