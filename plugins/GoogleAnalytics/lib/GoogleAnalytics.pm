# Movable Type (r) Open Source (C) 2006-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package GoogleAnalytics;

use strict;
use warnings;

our @EXPORT = qw( plugin translate new_ua );
use base qw(Exporter);

sub translate {
    MT->component('GoogleAnalytics')->translate(@_);
}

sub plugin {
    MT->component('GoogleAnalytics');
}

sub _find_current_plugindata {
    my ( $app, $blog ) = @_;

    my @keys = ( 'configuration:blog:' . $blog->id );
    if ( $blog->parent_id ) {
        push @keys, 'configuration:blog:' . $blog->parent_id;
    }

    my @objs = $app->model('plugindata')->load(
        {   plugin => plugin()->{name},
            key    => \@keys,
        }
    ) or return undef;

    # Blog's config has a priority higher than website's config.
    @objs = reverse @objs
        if ( scalar(@objs) == 2 && $objs[0]->key ne $keys[0] );

    for my $o (@objs) {
        my $data = $o->data();
        if (   $data
            && $data->{client_id}
            && $data->{client_secret}
            && $data->{profile_id} )
        {
            return $o;
        }
    }

    return undef;
}

sub current_plugindata {
    my ( $app, $blog ) = @_;

    my $hash = $app->request('ga_current_plugindata');
    defined($hash)
        ? $hash
        : $app->request( 'ga_current_plugindata',
        _find_current_plugindata(@_) );
}

sub extract_response_error {
    my ($res) = @_;

    my $message
        = MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );
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
