# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
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

