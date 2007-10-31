# Copyright 2005-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.
#
# $Id$

package SimpleScorer;

use strict;
use base 'MT::App';
use vars qw($VERSION);
use File::Basename qw(basename);

$VERSION = '0.01';

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        score => \&score,
    );
    $app->{default_mode} = 'score';
    $app->{requires_login} = 1;
    $app;
}

sub init_request {
    my $app = shift;
    $app->SUPER::init_request(@_);
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

sub score {
    my $app = shift;

    my $entry_id = $app->param('entry_id');
    my $score = $app->param('score');
    my $user = $app->user;
    my $key = $app->plugin->key;
    my $overwrite = 1;

    my $entry = MT::Entry->load($entry_id);

    if ($entry->set_score($key, $user, $score, $overwrite)) {
        my %param = ();
        $param{'current'} = $entry->score_for($key);
        $app->build_page('scored.tmpl', \%param);
    } else {
        $app->errtrans('Error during scoring.');
    }
}

sub plugin {
    MT::Plugin::SimpleScorer->instance;
}

1;

