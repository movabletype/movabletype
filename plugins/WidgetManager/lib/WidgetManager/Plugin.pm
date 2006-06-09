# Widget Manager Movable Type Plugin Utility Package
# Copyright (C) 2005-2006 Six Apart, Ltd.
#
# $Id$

package WidgetManager::Plugin;
use strict;

use MT::Plugin;
use MT::PluginData;
use constant DEBUG => 0;

sub _hdlr_widget_manager {
    my $plugin = shift;
    my $ctx = shift;
    my $args = shift;

    my $blog_id = $ctx->stash('blog_id');

    my $modulesets = $plugin->load_selected_modules($blog_id);
    return unless $modulesets && $modulesets->{$args->{name}};                                                             
    my @selected = split(",",$modulesets->{$args->{name}});

    my $res = "";
    require MT::Template::ContextHandlers;
    foreach my $mid (@selected) {
        require MT::Template;
        my $tmpl = MT::Template->load({ id => $mid,
                                        blog_id => $blog_id })
            or return $ctx->error($plugin->translate(
                "Can't find included template module '[_1]'", $mid ));
        $args->{module} = $tmpl->name;
    	$res .= MT::Template::Context::_hdlr_include($ctx,$args);
    }
    return $res;
}

sub load_selected_modules {
    my ($plugin,$blog_id) = @_;
    if (DEBUG) {
        require WidgetManager::Util;
        WidgetManager::Util::debug("Loading data for blog #".$blog_id);
    }
    my $config = $plugin->get_config_hash('blog:'.$blog_id);
    return $config && $config->{modulesets} ? $config->{modulesets} : undef;
}

1;
