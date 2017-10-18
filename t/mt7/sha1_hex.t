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

use Digest::SHA1 ();
use MT::Util ();

my @data = ( 123, 'abcdef', 'Welcome to Movable Type', );

for my $d (@data) {
    my $mt          = MT::Util::perl_sha1_digest_hex($d);
    my $digest_sha1 = Digest::SHA1::sha1_hex($d);
    is( $mt, $digest_sha1 );
}

done_testing;

