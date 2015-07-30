package JSON::WebToken::Crypt;

use strict;
use warnings;

sub sign {
    my ($class, $algorithm, $message, $key) = @_;
    die 'sign method must be implements!';
}

sub verify {
    my ($class, $algorithm, $message, $key, $signature) = @_;
    die 'verify method must be implements!'
}

1;
__END__
