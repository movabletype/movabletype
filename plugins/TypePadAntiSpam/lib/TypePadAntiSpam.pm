# TypePad AntiSpam Plugin for Movable Type
# Copyright (C) 2008-2013, Six Apart, Ltd.
# Derived from Tim Appnel's MT Akismet plugin for Movable Type.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: TypePadAntiSpam.pl 5151 2010-01-06 07:51:27Z takayama $

package TypePadAntiSpam;

use strict;

sub template_param_cfg_plugin {
    my ( $cb, $app, $param, $tmpl ) = @_;
    my $plugin = MT->component('TypePadAntiSpam');
    my $sig    = $plugin->{plugin_sig};
    my $blog   = $app->isa('MT::App::CMS') ? $app->blog : undef;

    my ($data) = grep( $_->{plugin_sig} eq $sig, @{ $param->{plugin_loop} } );
    $data->{plugin_desc} = '<p>' . $data->{plugin_desc} . '</p>';

    my $sys_blocked = &blocked();
    if ($blog) {
        my $blog_blocked = $blog ? &blocked($blog) : 0;
        $data->{plugin_desc} .= '<p>'
            . $plugin->translate(
            'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.',
            $blog_blocked, $sys_blocked
            ) . '</p>';
    }
    else {
        $data->{plugin_desc} .= '<p>'
            . $plugin->translate(
            'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.',
            $sys_blocked
            ) . '</p>';
    }
}

sub _hdlr_tpas_counter {
    my ( $ctx, $args, $cond ) = @_;
    my $blog = $ctx->stash('blog');
    if ( $ctx->can('count_format') ) {
        return $ctx->count_format( &blocked($blog), $args );
    }
    else {
        return &blocked($blog) || 0;
    }
}

sub plugin_data_pre_save {
    my $plugin = MT->component('TypePadAntiSpam');
    my ( $cb, $obj, $original ) = @_;
    my ( $args, $scope ) = ( $obj->data, $obj->key );

    return 1
        unless ( $obj->plugin eq $plugin->key )
        && ( $scope =~ m/^configuration/ );

    $scope =~ s/^configuration:?|:.*//g;

    my $app = MT->instance;

    $scope ||= 'system';
    if ( $scope eq 'system' ) {
        my $existing_api_key = '';
        if ( $app->can('param') ) {
            $existing_api_key = $app->param('existing_api_key') || '';
        }
        my $new_api_key = $args->{api_key} || '';
        if ( ( $new_api_key ne '' ) && ( $new_api_key ne $existing_api_key ) )
        {

            # user assigned a new API key
            &require_tpas;
            local $MT::TypePadAntiSpam::SERVICE_HOST = $args->{service_host}
                if $args->{service_host};
            my $url = $app->base . $app->mt_uri;
            my $res = MT::TypePadAntiSpam->verify( $new_api_key, $url );
            if ( $res->http_status >= 500 ) {
                return $plugin->error(
                    $plugin->translate(
                        "Failed to verify your TypePad AntiSpam API key: [_1]",
                        $res->http_response->message
                    )
                );
            }
            elsif ( $res->status != 1 ) {
                return $plugin->error(
                    $plugin->translate(
                        "The TypePad AntiSpam API key provided is invalid.")
                );
            }
        }
    }

    return 1 if MT->version_number < 4;

    my $user = $app->user;
    my $blog_id = $app->blog->id if $app->blog;

    return 1 unless $user;

    my $widget_store = $user->widgets();
    if ( $widget_store && %$widget_store ) {
        my $sys_db = $widget_store->{'dashboard:system'}
            ||= default_widgets();
        my $blog_db = $widget_store->{ 'dashboard:blog:' . $blog_id }
            ||= default_widgets()
            if $blog_id;

        my $changed = 0;
        if ( $blog_id && ( !exists $blog_db->{'typepadantispam'} ) ) {
            $blog_db->{'typepadantispam'} = {
                order => 2.1,        # following mt shortcuts, if shown
                set   => 'sidebar'
            };
            $changed++;
        }
        if ( !exists $sys_db->{'typepadantispam'} ) {
            $sys_db->{'typepadantispam'} = {
                order => 2.1,        # following mt shortcuts, if shown
                set   => 'sidebar'
            };
            $changed++;
        }
        if ($changed) {
            $user->widgets($widget_store);
            $user->save;
        }
    }

    return 1;
}

sub default_widgets {

    # FIXME: This should come from the app
    return {
        'blog_stats' =>
            { param => { tab => 'entry' }, order => 1, set => 'main' },
        'this_is_you-1' => { order => 1, set => 'sidebar' },
        'mt_shortcuts'  => { order => 2, set => 'sidebar' },
        'mt_news'       => { order => 3, set => 'sidebar' },
    };
}

sub stats_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;
    my $blog = $app->blog;
    if ($blog) {
        $param->{'blog_blocked'} = &blocked($blog) || 0;
    }
    $param->{'system_blocked'} = &blocked();
    $param->{'language'} = lc substr( MT->instance->current_language, 0, 2 );
    $param->{'use_ssl'}  = $app->is_secure;
    $param->{'api_key'}  = &api_key();
    return;
}

sub pre_save_obj {
    my ( $cb, $obj ) = @_;
    if (  !$obj->id
        && $obj->is_junk
        && ( $obj->junk_log =~ m/TypePad AntiSpam says spam/ ) )
    {

        # this was junked due in part to TypePad AntiSpam
        if ( my $blog = $obj->blog ) {
            &blocked( $blog, &blocked($blog) + 1 );
        }

        # now increment total block count:
        &blocked( undef, &blocked() + 1 );
    }
}

sub handle_junk {
    my ( $cb, $app, $thing ) = @_;
    &require_tpas;
    my $key = is_valid_key($thing)      or return;
    my $sig = package_signature($thing) or return;
    MT::TypePadAntiSpam->submit_spam( $sig, $key );
}

sub handle_not_junk {
    my ( $cb, $app, $thing ) = @_;
    &require_tpas;
    my $key = is_valid_key($thing)      or return;
    my $sig = package_signature($thing) or return;
    MT::TypePadAntiSpam->submit_ham( $sig, $key );
}

sub typepadantispam_score {
    my $plugin = MT->component('TypePadAntiSpam');
    my $thing  = shift;
    &require_tpas;
    my $key = is_valid_key($thing)
        or return MT::JunkFilter::ABSTAIN();
    my $sig = package_signature( $thing, 1 )
        or return MT::JunkFilter::ABSTAIN();
    my $res = MT::TypePadAntiSpam->check( $sig, $key );
    my $http_resp = $res->http_response;
    if ( $http_resp && !$http_resp->is_success ) {
        MT->log( "TypePad AntiSpam error: " . $http_resp->message );
    }
    elsif ( !$http_resp ) {
        if ( MT::TypePadAntiSpam->errstr ) {
            MT->log(
                "TypePad AntiSpam error: " . MT::TypePadAntiSpam->errstr );
        }
    }
    return MT::JunkFilter::ABSTAIN()
        unless $res && $res->http_response->is_success;
    my $weight
        = $plugin->get_config_value( 'weight', 'blog:' . $thing->blog_id )
        || 1;
    my ( $score, $grade )
        = $res->status
        ? ( $weight, 'ham' )
        : ( -$weight, 'spam' );
    ( $score, ["TypePad AntiSpam says $grade"] );
}

#--- utility

sub is_valid_key {
    my $thing = shift;
    my $r     = MT->request;
    unless ( $r->stash('MT::Plugin::TypePadAntiSpam::api_key') ) {
        my $key = &api_key() || return;
        $r->stash( 'MT::Plugin::TypePadAntiSpam::api_key', $key );
    }
    $r->stash('MT::Plugin::TypePadAntiSpam::api_key');
}

sub require_tpas {
    my $plugin = MT->component('TypePadAntiSpam');
    require MT::TypePadAntiSpam;

    my $host = $plugin->get_config_value('service_host');
    if ($host) {
        $MT::TypePadAntiSpam::SERVICE_HOST = $host;
    }
}

sub package_signature {
    my $thing              = shift;
    my ($include_referrer) = @_;
    my $sig                = MT::TypePadAntiSpam::Signature->new;
    if ($include_referrer) {
        $sig->user_agent( $ENV{HTTP_USER_AGENT} );
        $sig->referrer( $ENV{HTTP_REFERER} );
    }
    $sig->user_ip( $thing->ip );
    $sig->blog( cache( 'B' . $thing->blog_id ) );
    if ( ref $thing eq 'MT::Comment' ) {
        my $entry = $thing->entry;
        $sig->article_date(
            MT->version_number < 4
            ? $entry->created_on
            : $entry->authored_on
        );
        $sig->permalink( $entry->permalink );
        $sig->comment_type('comment');
        $sig->comment_author( $thing->author );
        $sig->comment_author_email( $thing->email );
        $sig->comment_author_url( $thing->url );
        $sig->comment_content( $thing->text );
    }
    elsif ( ref $thing eq 'MT::TBPing' ) {
        my $p = $thing->parent;
        if ( $p->isa('MT::Entry') ) {
            $sig->article_date(
                MT->version_number < 4 ? $p->created_on : $p->authored_on );
            $sig->permalink( $p->permalink );
        }
        $sig->comment_type('trackback');
        $sig->comment_author( $thing->blog_name );
        $sig->comment_author_url( $thing->source_url );
        $sig->comment_content( join "\n", $thing->title, $thing->excerpt );
    }
    else {
        return;    # don't know what this is.
    }
    $sig;
}

sub cache {
    my $id    = shift;
    my $cache = MT->request->stash('MT::Plugin::TypePadAntiSpam::permalinks');
    unless ($cache) {
        $cache = {};
        MT->request->stash( 'MT::Plugin::TypePadAntiSpam::permalinks',
            $cache );
    }
    unless ( $cache->{$id} ) {
        if ( $id =~ /^B/ ) {
            my $b = MT::Blog->load( substr( $id, 1 ) ) or return;
            $cache->{$id} = $b->site_url;
        }
        else {
            require MT::Entry;
            my $e = MT::Entry->load($id) or return;
            $cache->{$id} = $e->permalink;
        }
    }
    $cache->{$id};
}

sub has_api_key {
    &api_key();
}

sub api_key {
    my $plugin = MT->component('TypePadAntiSpam');
    my $blog   = shift;
    if (@_) {
        my $key = shift;
        $plugin->set_config_value( 'api_key', $key );
    }
    else {
        return $plugin->get_config_value('api_key');
    }
}

sub blocked {
    my $plugin = MT->component('TypePadAntiSpam');
    my $blog   = shift;
    my $blog_id
        = ( ref($blog) && $blog->isa('MT::Blog') ) ? $blog->id : $blog;
    my $blocked = $plugin->get_config_value( 'blocked',
        $blog_id ? 'blog:' . $blog_id : 'system' );
    return $blocked || 0 unless @_;
    my ($count) = @_;
    $plugin->set_config_value( 'blocked', $count,
        $blog_id ? 'blog:' . $blog_id : 'system' );
    return $count;
}

1;
