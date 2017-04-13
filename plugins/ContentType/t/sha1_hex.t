use strict;
use warnings;

use Test::More;
use Digest::SHA1 ();

use lib qw( lib extlib );
use MT::Util ();

my @data = ( 123, 'abcdef', 'Welcome to Movable Type', );

for my $d (@data) {
    my $mt          = MT::Util::perl_sha1_digest_hex($d);
    my $digest_sha1 = Digest::SHA1::sha1_hex($d);
    is( $mt, $digest_sha1 );
}

done_testing;

