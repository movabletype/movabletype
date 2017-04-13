use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT;
use MT::Test qw( :db );

use MT::ContentField;

subtest 'unique_key' => sub {
    my $cf = MT::ContentField->new;
    $cf->set_values(
        {   blog_id         => 1,
            content_type_id => 1,
        }
    );

    $cf->unique_key('123');
    is( $cf->unique_key, undef, 'cannot set unique_key' );

    $cf->save or die $cf->errstr;
    ok( $cf->unique_key, 'set unique_key after save' );

    my $unique_key = $cf->unique_key;
    $cf->unique_key( $unique_key . '456' );
    is( $cf->unique_key, $unique_key, 'cannot set unique_key' );
};

done_testing;

