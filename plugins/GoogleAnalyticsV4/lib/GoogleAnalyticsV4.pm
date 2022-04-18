# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package GoogleAnalyticsV4;

use strict;
use warnings;

our @EXPORT = qw( plugin translate new_ua );
use base qw(Exporter);

sub translate {
    MT->component('GoogleAnalyticsV4')->translate(@_);
}

sub plugin {
    MT->component('GoogleAnalyticsV4');
}

sub _find_current_plugindata {
    my ($app, $blog) = @_;

    my $result = {
        client  => undef,
        profile => undef,
        merged  => undef,
    };

    my @keys = ();
    if ($blog) {
        push @keys, 'configuration:blog:' . $blog->id;
        if ($blog->parent_id) {
            push @keys, 'configuration:blog:' . $blog->parent_id;
        }
    }
    push @keys, 'configuration';

    my @tmp = $app->model('plugindata')->load({
        plugin => plugin()->{name},
        key    => \@keys,
    }) or return $result;

    my @objs = ();
    for my $k (@keys) {
        for my $o (@tmp) {
            if ($o->key eq $k) {
                push @objs, $o;
            }
        }
    }

    for (my $i = 0; $i <= $#objs; $i++) {
        my ($client, $profile, $merged);
        my $o    = $objs[$i];
        my $data = $o->data()
            or next;

        if (!$profile && !$client) {
            if ($data->{profile_id}) {
                $profile = $o;
                if ($data->{client_id}) {
                    $client = $merged = $profile;
                } else {
                    for (my $j = $i + 1; $j <= $#objs; $j++) {
                        my $o    = $objs[$j];
                        my $data = $o->data()
                            or next;

                        my $profile_data = $profile->data;
                        if ($data->{client_id} eq $profile_data->{parent_client_id}) {
                            $client = $o;
                            $merged = $profile->clone;

                            my @keys = qw(client_id client_secret);
                            @$profile_data{@keys} = @$data{@keys};
                            $merged->data($profile_data);
                            last;
                        }
                    }
                    next unless $client;
                }
            }
        }

        if (!$client && $data->{client_id}) {
            $client = $o;
            if ($data->{profile_id}) {
                $profile = $merged = $client;
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
    my ($app, $blog) = @_;
    _find_current_plugindata(@_);
}

sub current_plugindata {
    my ($app, $blog) = @_;

    my $key = 'ga4_current_plugindata:blog:' . $blog->id;

    my $hash = $app->request($key);
    defined($hash)
        ? $hash
        : $app->request($key, _find_current_plugindata(@_)->{merged});
}

sub extract_response_error {
    my ($res) = @_;

    my $message = eval { MT::Util::from_json(Encode::decode('utf-8', $res->content)); };
    if (ref $message) {
        $message = $message->{error};
    }
    if (ref $message) {
        $message = $message->{message};
    }

    $res->status_line, $message;
}

sub new_ua {
    my $ua = MT->new_ua({ max_size => undef });

    if (
        eval { require IO::Socket::SSL }
        && $IO::Socket::SSL::VERSION >= 1.79 &&
        $ua->can('ssl_opts'))
    {
        $ua->ssl_opts(SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_PEER());
    }

    $ua;
}

1;
