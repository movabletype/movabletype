# Shared Secret plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package SharedSecret;

use strict;
use warnings;
use base qw(MT::ErrorHandler);

sub form_fields {
    my $self = shift;
    
    my $caption = MT->translate("DO YOU KNOW?  What is MT team's favorite brand of chocolate snack?");
    return <<FORM_FIELD;
<p>$caption</p>
<input name="secret_answer" size="50" />
FORM_FIELD
}

sub validate_captcha {
    my $self = shift;
    my ($app) = @_;

    my $answer = $app->param('secret_answer');
    require Digest::MD5;
    return 'f0bf97d2f85c040963f47c03888434c4' eq Digest::MD5::md5_hex($answer);
}
    
sub generate_captcha {
    #This won't be called since there is no link which requests to "generate_captcha" mode.
    my $self = shift;
    1;
}

1;
