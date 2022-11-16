# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::Util::Digest::MD5;

use strict;
use warnings;

our ( @ISA, @EXPORT_OK );
BEGIN {
    if ( eval { require Digest::MD5 } ) {
        push @ISA, 'Digest::MD5';
        @EXPORT_OK = @Digest::MD5::EXPORT_OK;
        Digest::MD5->import(@EXPORT_OK);
    }
    else {
        require Digest::Perl::MD5;
        push @ISA, 'Digest::Perl::MD5';
        @EXPORT_OK = @Digest::Perl::MD5::EXPORT_OK;
        Digest::Perl::MD5->import(@EXPORT_OK);
    }
}

1;
