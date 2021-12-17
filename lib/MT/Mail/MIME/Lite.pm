# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Mail::MIME::Lite;

use strict;
use warnings;

use MT;
use base qw( MT::Mail::MIME );
use MIME::Lite;

sub MAX_LINE_OCTET { 998 }

1;
