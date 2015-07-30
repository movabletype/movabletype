# Movable Type (r) (C) 2006-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package GoogleOpenIDConnect;

use strict;
use warnings;

our @EXPORT = qw( plugin translate new_ua );
use base qw(Exporter);

sub translate {
    MT->component('GoogleOpenIDConnect')->translate(@_);
}

sub plugin {
    MT->component('GoogleOpenIDConnect');
}
sub _find_current_plugindata {
    my ( $app, $blog ) = @_;

    my $result = {
        client  => undef,
    };

    my @keys = ();
    if ($blog) {
        push @keys, 'configuration:blog:' . $blog->id;
        if ( $blog->parent_id ) {
            push @keys, 'configuration:blog:' . $blog->parent_id;
        }
    }
    push @keys, 'configuration';

    my @tmp = $app->model('plugindata')->load(
        {   plugin => plugin()->{name},
            key    => \@keys,
        }
    ) or return $result;

    my @objs = ();
    for my $k (@keys) {
        for my $o (@tmp) {
            if ( $o->key eq $k ) {
                push @objs, $o;
            }
        }
    }

    for ( my $i = 0; $i <= $#objs; $i++ ) {
        my ( $client, $profile, $merged );
        my $o = $objs[$i];
        my $data = $o->data() or next;

        if ( !$client && $data->{client_id} ) {
            $client = $o;
        }

        if ($client) {
            $result = {
                client  => $client,
            };
            last;
        }
    }

    return $result;
}

sub current_plugindata_hash {
    my ( $app, $blog ) = @_;
    _find_current_plugindata(@_);
}

sub current_plugindata {
    my ( $app, $blog ) = @_;

    my $key = 'goidc_current_plugindata:blog:' . $blog->id;

    my $hash = $app->request($key);
    defined($hash)
        ? $hash
        : $app->request( $key, _find_current_plugindata(@_)->{merged} );
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

__END__

=head1 NAME

GoogleOpenIDConnect - Utility methods for Google Analytics.

=head1 METHODS

=head2 GoogleOpenIDConnect::plugin

    Returns a plugin object.

=head2 GoogleOpenIDConnect::translate(@params)

    Just call L<plugin()-E<gt>translate(@_)> internally.

=head2 GoogleOpenIDConnect::new_ua

    Returns new user ageent set with ssl_opts.

=head2 GoogleOpenIDConnect::current_plugindata($app, $blog)

    Returns current effective plugindata for C<$blog>.
    As for plugindata returned from this method, client_id and profile_id are set up. 

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
