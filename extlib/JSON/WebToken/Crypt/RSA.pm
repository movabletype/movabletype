package JSON::WebToken::Crypt::RSA;

use strict;
use warnings;
use parent 'JSON::WebToken::Crypt';

use Crypt::OpenSSL::RSA ();

our $ALGORITHM2SIGNING_METHOD_MAP = {
    RS256  => 'use_sha256_hash',
    RS384  => 'use_sha384_hash',
    RS512  => 'use_sha512_hash',
    RSA1_5 => 'use_pkcs1_padding',
};

sub sign {
    my ($class, $algorithm, $message, $key) = @_;

    my $private_key = Crypt::OpenSSL::RSA->new_private_key($key);
    my $method = $ALGORITHM2SIGNING_METHOD_MAP->{$algorithm};
    $private_key->$method;
    return $private_key->sign($message);
}

sub verify {
    my ($class, $algorithm, $message, $key, $signature) = @_;

    my $public_key = Crypt::OpenSSL::RSA->new_public_key($key);
    my $method = $ALGORITHM2SIGNING_METHOD_MAP->{$algorithm};
    $public_key->$method;
    return $public_key->verify($message, $signature) ? 1 : 0;
}

1;
__END__
