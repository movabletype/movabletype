use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT::Test qw( :db );

use MT::ContentType;

subtest 'unique_id' => sub {
    my $ct = MT::ContentType->new;
    $ct->set_values( { blog_id => 1 } );

    $ct->unique_id('123');
    is( $ct->unique_id, undef, 'cannot set unique_id' );

    $ct->save or die $ct->errstr;
    ok( $ct->unique_id, 'set unique_id after save' );
    is( length $ct->unique_id, 40, 'length of unique_id is 40' );

    my $unique_id = $ct->unique_id;
    $ct->unique_id( $unique_id . '456' );
    is( $ct->unique_id, $unique_id, 'cannot set unique_id' );
};

done_testing;

