# WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
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

    return $ctx->error($plugin->translate(
        "No WidgetManager modules exist for blog '[_1]'.", $blog_id
    )) unless $modulesets;
    return $ctx->error($plugin->translate(
        "WidgetManager '[_1]' has no installed widgets.", $args->{name}
    )) unless $modulesets->{$args->{name}};

    my @selected = split(",",$modulesets->{$args->{name}});

    my $res = "";
    require MT::Template::ContextHandlers;
    foreach my $mid (@selected) {
        require MT::Template;
        my $tmpl = MT::Template->load({ id => $mid,
                                        blog_id => $blog_id })
            or return $ctx->error($plugin->translate(
                "Can't find included template module '[_1]'", $mid ));
        $args->{widget} = $tmpl->name;
        $res .= $ctx->tag('include', $args);
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
