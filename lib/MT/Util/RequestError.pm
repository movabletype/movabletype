# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
package MT::Util::RequestError;

use strict;
use warnings;
use Exporter qw(import);

our @EXPORT_OK = qw(parse_init_cgi_error);

sub parse_init_cgi_error {
    my ($err) = shift;

    # CGI->new() throws an error if it fails to parse a POST request.
    # If the boundary is invalid, etc., the error message contains "malformed", so 400 is returned.
    # In other cases, return 500, most likely due to a bug in the web server or application.
    # MTC-29494
    $err =~ m/malformed/i
        ? {
        code    => 400,
        message => "Bad Request: $err",
        }
        : {
        code    => 500,
        message => 'Internal Server Error',
        };
}

1;
__END__

=head1 NAME

MT::Util::RequestError - Provide utility functions for request error

=head1 METHODS

=head2 parse_init_cgi_error($error)

Parse the error that occurred when `CGI->new` was called.
Return the response code and message for the error.

Example:

    my $cgi = eval { CGI->new };
    if (my $error = $@) {
        my $result = MT::Util::RequestError::parse_init_cgi_error($error);
        $mt->response_code($result->{code});
        $mt->print($result->{message});
    }
