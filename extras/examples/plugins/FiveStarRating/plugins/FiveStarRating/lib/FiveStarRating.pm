# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package FiveStarRating;

use strict;
use base 'MT::App';
use vars qw($VERSION);
use File::Basename qw(basename);

$VERSION = '0.1';

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        rate => \&rate,
    );
    $app->{default_mode} = 'rate';
#    $app->{requires_login} = 1;
    $app;
}

sub build_page {
    my $app = shift;
    my $plugin = $app->plugin;
    if ($plugin) {
        my $path = $app->static_path;
        $path .= '/' unless $path =~ m!/$!;
        $path .= $app->plugin->envelope . "/";
        $path = $app->base . $path if $path =~ m!^/!;
        $_[1]->{plugin_static_uri} = $path;
    }
    $app->SUPER::build_page(@_);
}

# passthru for L10N
sub translate_templatized {
    my $app = shift;
    $app->plugin->translate_templatized(@_);
}

sub rate {
    my $app = shift;

    my $type = $app->param('type');
    my $id = $app->param('id');
    my $score = $app->param('score');

    $app->send_http_header('text/plain');
    $app->{no_print_body} = 1;

    my $obj = $app->model($type)->load($id);
    $app->print(q()), return unless $obj;

    my $user = $app->user;
    unless ($user) {
        my %cookies = $app->cookies();
        if ($cookies{$app->COMMENTER_COOKIE_NAME()}) {
            my $session_key = $cookies{$app->COMMENTER_COOKIE_NAME()}->value() || "";
            $session_key =~ y/+/ /;
            my $cfg = $app->config;
            require MT::Session;
            my $sess_obj = MT::Session->load({ id => $session_key });
            my $timeout = $cfg->CommentSessionTimeout;
            if ($sess_obj) {
                $user = MT::Author->load({name => $sess_obj->name});
            }
        }
    }
    $app->print(q()), return unless $obj;

    my $key = 'FiveStarRating';
    my $overwrite = 1;

    $obj->set_score($key, $user, $score, $overwrite);
    $app->print($obj->score_avg($key));
}

1;

