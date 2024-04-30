# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
package MT::Util::Request;

use strict;
use warnings;
use Exporter qw(import);

our @EXPORT_OK = qw(parse_init_cgi_error);

sub parse_init_cgi_error {
    my ($err) = shift;
    $err =~ m/malformed/i
        ? {
        code    => 400,
        message => 'Bad Request',
        }
        : {
        code    => 500,
        message => 'Internal Server Error',
        };
}

1;
