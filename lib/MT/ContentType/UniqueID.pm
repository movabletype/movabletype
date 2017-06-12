package MT::ContentType::UniqueID;
use strict;
use warnings;

use Encode qw( encode_utf8 );
use MT::Util qw( perl_sha1_digest_hex );

sub generate_unique_id {
    my $name = shift;
    unless ( defined $name && $name ne '' ) {
        $name = 'basename';
    }
    my $key = join(
        $ENV{'REMOTE_ADDR'}     || '',
        $ENV{'HTTP_USER_AGENT'} || '',
        time, $$, rand(9999), encode_utf8($name)
    );
    return ( perl_sha1_digest_hex($key) );
}

1;

