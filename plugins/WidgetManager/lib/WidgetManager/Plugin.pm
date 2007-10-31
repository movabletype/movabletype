# WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package WidgetManager::Plugin;

use strict;

sub _hdlr_widget_manager {
    my $ctx = shift;
    my $args = shift;

    my $blog_id = $ctx->stash('blog_id');

    my $plugin = MT->component('WidgetManager');
    my $modulesets = load_selected_modules($plugin, $blog_id);

    return '' unless $modulesets;
    return '' unless $modulesets->{$args->{name}};

    my @selected = split(",",$modulesets->{$args->{name}});

    my $res = "";
    foreach my $mid (@selected) {
        require MT::Template;
        my $tmpl = MT::Template->load({ id => $mid,
                                        blog_id => $blog_id })
            or return $ctx->error(MT->translate(
                "Can't find included template widget '[_1]'", $mid ));
        $res .= $ctx->tag('include', { widget => $tmpl->name });
    }
    return $res;
}

sub load_selected_modules {
    my ($plugin, $blog_id) = @_;
    my $config = $plugin->get_config_hash('blog:'.$blog_id);
    return $config && $config->{modulesets} ? $config->{modulesets} : undef;
}

1;
