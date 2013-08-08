# Movable Type (r) (C) 2006-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package GoogleAnalytics;

use strict;
use warnings;

our @EXPORT = qw( plugin translate new_ua access_token_id );
use base qw(Exporter);

sub translate {
    MT->component('GoogleAnalytics')->translate(@_);
}

sub plugin {
    MT->component('GoogleAnalytics');
}

sub access_token_id {
    my ($data) = @_;
    if ( $data->{token_data} ) {
        $data = $data->{token_data};
    }
    ( $data->{client_id} || '' ) . ( $data->{username} || '' );
}

sub _find_current_plugindata {
    my ( $app, $blog ) = @_;

    my $result = {
        client  => undef,
        profile => undef,
        merged  => undef,
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
        my $o    = $objs[$i];
        my $data = $o->data()
            or next;

        if ( !$profile ) {
            if ( $data->{profile_id} ) {
                $profile = $o;
                if ( $data->{client_id} ) {
                    $client = $merged = $profile;
                }
            }
            elsif ( $data->{client_id} && $data->{token_data} ) {
                $client = $o;
            }
        }

        if ( $profile && !$client ) {
            for ( my $j = $i + 1; $j <= $#objs; $j++ ) {
                my $o    = $objs[$j];
                my $data = $o->data()
                    or next;

                my $profile_data = $profile->data;
                if (  !$profile_data->{client_id}
                    && $data->{client_id}
                    && access_token_id($data) eq
                    ( $profile_data->{parent_access_token_id} || '' ) )
                {
                    $client = $o;
                    $merged = $client->clone;

                    my @keys
                        = qw(profile_id profile_name profile_web_property_id);
                    @$data{@keys} = @$profile_data{@keys};
                    $merged->data($data);
                }
            }
        }

        if ($client) {
            $result = {
                client  => $client,
                profile => $profile,
                merged  => $merged,
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

    my $key = 'ga_current_plugindata:blog:' . $blog->id;

    my $hash = $app->request($key);
    defined($hash)
        ? $hash
        : $app->request( $key, _find_current_plugindata(@_)->{merged} );
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
