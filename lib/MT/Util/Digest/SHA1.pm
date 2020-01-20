# Movable Type (r) (C) 2001-2019 Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::Util::Digest::SHA1;

use strict;
use warnings;

our ( @ISA, @EXPORT_OK );
BEGIN {
    if ( eval { require Digest::SHA1 } ) {
        push @ISA, 'Digest::SHA1';
        @EXPORT_OK = @Digest::SHA1::EXPORT_OK;
        Digest::SHA1->import(@EXPORT_OK);
    }
    else {
        require Digest::SHA::PurePerl;
        push @ISA, 'Digest::SHA::PurePerl';
        @EXPORT_OK = qw/sha1 sha1_hex sha1_base64/;
        Digest::SHA::PurePerl->import(@EXPORT_OK);
    }
}

1;
