# Copyright 2004-2007 Six Apart. This code cannot be redistributed without
# permission from www.movabletype.org.
#
# $Id$

package Mirror;

use strict;

use MT::App;
@Mirror::ISA = qw(MT::App);

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;

    $app->add_methods( show_config => \&show_config );
    $app->{default_mode} = 'show_config';
    $app->{requires_login} = 1;

    $app;
}

sub show_config {
    my $app = shift;
    $app->build_page('mirror.tmpl', {var => 'Zaphod'});
}

1;

