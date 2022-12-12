# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
package MT::Util::BlessedString;

use strict;
use warnings;
use overload bool => sub {1}, '""' => sub { ${$_[0]} }, fallback => 1;

sub new {
    my ($class, $str) = @_;
    bless \$str, $class;
}

1;
