# $Id: ErrorHandler.pm 1 2006-08-16 05:19:58Z miyagawa $

package XML::Atom::ErrorHandler;
use strict;

use vars qw( $ERROR );

sub new    { bless {}, shift }
sub error  {
    my $msg = $_[1] || '';
    $msg .= "\n" unless $msg =~ /\n$/;
    if (ref($_[0])) {
        $_[0]->{_errstr} = $msg;
    } else {
        $ERROR = $msg;
    }
    return;
 }
sub errstr { ref($_[0]) ? $_[0]->{_errstr} : $ERROR }

1;
