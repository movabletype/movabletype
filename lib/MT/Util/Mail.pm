# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::Mail;
use strict;
use warnings;
use MT;
use base qw( MT::ErrorHandler );
use Carp;

sub load_class {
    my ($class, $mail_class) = @_;
    $mail_class ||= MT->config->MailClass || 'MT::Mail';

    eval "require $mail_class;";
    return $mail_class unless $@;

    Carp::croak($@) if $@;
    return $class->error(MT->translate('Error loading mail class: [_1].', $mail_class));
}

1;
