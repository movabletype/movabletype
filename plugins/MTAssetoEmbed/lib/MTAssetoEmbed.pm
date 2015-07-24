# Movable Type (r) (C) 2006-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MTAssetoEmbed;

use strict;
use warnings;

our @EXPORT = qw( plugin translate new_ua );
use base qw(Exporter);

sub translate {
    MT->component('MTAssetoEmbed')->translate(@_);
}

sub plugin {
    MT->component('MTAssetoEmbed');
}

sub extract_response_error {
    my ($res) = @_;

    my $message = eval {
        MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );
    };
    if ( ref $message ) {
        $message = $message->{error};
    }
    if ( ref $message ) {
        $message = $message->{message};
    }

    $res->status_line, $message;
}

sub new_ua {
    my $ua = MT->new_ua;

    if (eval { require IO::Socket::SSL }
        && $IO::Socket::SSL::VERSION >= 1.79 &&
        $ua->can('ssl_opts')
        )
    {
        $ua->ssl_opts(
            SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_PEER() );
    }

    $ua;
}

1;
