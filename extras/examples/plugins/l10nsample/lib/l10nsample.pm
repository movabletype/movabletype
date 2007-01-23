# Copyright 2005-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.
#
# $Id$

package l10nsample;

use strict;
use base 'MT::App';
use vars qw($VERSION);
use File::Basename qw(basename);

$VERSION = '0.01';

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        view => \&view,
    );
    $app->{default_mode} = 'view';
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

sub view {
    my $app = shift;

    my $blog_id = $app->param('blog_id');
    my $config = $app->plugin->get_config_hash();
    my %param = ();
    $param{'param1'} = $app->plugin->translate('This is localized in perl module');

    $app->build_page('view.tmpl', \%param);
}

sub plugin {
    MT::Plugin::l10nsample->instance;
}

1;
