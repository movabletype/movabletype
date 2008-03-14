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

    my @selected = split(/\s*,\s*/,$modulesets->{$args->{name}});

    my $res = "";
    foreach my $mid (@selected) {
        require MT::Template;
        my $tmpl = MT::Template->load({ id => $mid,
                                        blog_id => $blog_id })
            or return $ctx->error(MT->translate(
                "Can't find included template widget '[_1]'", $mid ));
        my $out = $ctx->tag('include', { widget => $tmpl->name })
            or return $ctx->error($ctx->errstr);
        $res .= $out if defined $out;
    }
    return $res;
}

sub load_selected_modules {
    my ($plugin, $blog_id) = @_;
    my $config = $plugin->get_config_hash('blog:'.$blog_id);
    return $config && $config->{modulesets} ? $config->{modulesets} : undef;
}

sub clone_blog_widgemanagers {
    my $cb      = shift;
    my (%params) = @_;
    my $plugin  = $cb->plugin;

    my $report = sub {};
    my $label = 'widgetmgr';

    if (my $callback = $params{callback}) {
        my $state;
        $report = sub { 
            my $msg;
            if ($state) {
                $msg = $state . ' ' . (+shift);
            } else {
                $msg = $state = shift;
            }
            $callback->($msg, $label)
        };
    }

    $report->($plugin->translate('Cloning Widgets for blog...'));

    my $modulesets = $plugin->load_selected_modules($params{old_blog_id});    
    if ( ! $modulesets or ! keys %$modulesets ) {
        return $report->($plugin->translate("[_1] records processed.", 0));
    }

    my @widgetmanagers;
    foreach my $key (sort keys %$modulesets) {
        # Collect the available widgets for this key.
        my @w = ();
        for my $w ( split /\s*,\s*/, $modulesets->{$key} ) {
            push @w, $params{template_map}{$w} if $params{template_map}{$w};
        }
        $modulesets->{$key} = join(',', @w);
    }

    my $vars = { modulesets => $modulesets, installed => 1 };
    my $pdata_obj = $plugin->get_config_obj('blog:'.$params{new_blog_id});
    my $configuration = $pdata_obj->data() || {};
    $configuration->{$_} = $vars->{$_} for keys %$vars;
    $pdata_obj->data($configuration);
    $pdata_obj->save();

    my $counter = scalar keys %$modulesets;
    $report->($plugin->translate("[_1] records processed.", $counter));
}

sub remove_blog_widgetmanager {
    my $cb      = shift;
    my $plugin  = $cb->plugin;

    my @pdata_objs;
    require MT::PluginData;
    # post_remove_all
    if (! ref($_[0]) and $_[0] eq 'MT::Blog') {
        @pdata_objs = MT::PluginData->load({ plugin => $plugin->key});
    }
    # post_remove
    elsif (ref($_[0]) eq 'MT::Blog') {
        @pdata_objs = 
            MT::PluginData->load({  plugin => $plugin->key,
                                    key    => 'configuration:blog:'.$_[0]->id });
    }
    $_->remove foreach @pdata_objs;
}

sub create_default_widgetsets {
    my ($cb, $blog, $tmpl_list) = @_;
    require WidgetManager::CMS;
    WidgetManager::CMS::create_default_widgetsets($blog->id);
    1;
}

1;
