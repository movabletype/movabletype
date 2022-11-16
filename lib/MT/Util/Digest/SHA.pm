# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::Util::Digest::SHA;

use strict;
use warnings;

our ( @ISA, @EXPORT_OK );
BEGIN {
    if ( eval { require Digest::SHA } ) {
        push @ISA, 'Digest::SHA';
        @EXPORT_OK = @Digest::SHA::EXPORT_OK;
        Digest::SHA->import(@EXPORT_OK);
    }
    else {
        require Digest::SHA::PurePerl;
        push @ISA, 'Digest::SHA::PurePerl';
        @EXPORT_OK = @Digest::SHA::PurePerl::EXPORT_OK;
        Digest::SHA::PurePerl->import(@EXPORT_OK);
    }
}

1;
