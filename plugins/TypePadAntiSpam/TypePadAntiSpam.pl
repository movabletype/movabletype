# TypePad AntiSpam Plugin for Movable Type
# Copyright (C) 2008-2009, Six Apart, Ltd.
# Derived from Tim Appnel's MT Akismet plugin for Movable Type.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: TypePadAntiSpam.pl 82073 2008-05-29 02:58:04Z fyoshimatsu $

package MT::Plugin::TypePadAntiSpam;

use strict;

use base qw( MT::Plugin );
our $VERSION = '1.0';

my $plugin;
{
    my $settings = [
        ['api_key', { Scope => 'system'} ],
        ['weight',  { Default => 1, Scope => 'blog'}],
        ['service_host',  { Default => 'api.antispam.typepad.com', Scope => 'system'}],
    ];
    my $about = {
        name                   => 'TypePad AntiSpam',
        id                     => 'typepadantispam',
        key                    => __PACKAGE__,
        author_name            => 'Six Apart Ltd.',
        author_link            => 'http://www.sixapart.com/',
        version                => $VERSION,
        blog_config_template   => 'config.tmpl',
        system_config_template => 'system.tmpl',
        settings               => MT::PluginSettings->new($settings),
        l10n_class             => 'TypePadAntiSpam::L10N',
        registry => {
            callbacks => {
                handle_spam => \&handle_junk,
                handle_ham => \&handle_not_junk,
                'MT::Comment::pre_save' => \&pre_save_obj,
                'MT::TBPing::pre_save' => \&pre_save_obj,
            },
            junk_filters => {
                'TypePadAntiSpam' => {
                    label => 'TypePad AntiSpam',
                    code => \&typepadantispam_score,
                },
            },
            tags => {
                function => {
                    TypePadAntiSpamCounter => \&_hdlr_tpas_counter,
                },
            },
            widgets => {
                typepadantispam => {
                    label      => 'TypePad AntiSpam',
                    template   => 'stats_widget.tmpl',
                    handler    => \&stats_widget, 
                    set        => 'sidebar',
                    singular   => 1,
                    order      => 2.1,
                    condition  => sub {
                        return $plugin->api_key ? 1 : 0;
                    },
                },
            },
        },
    };
    $plugin = __PACKAGE__->new($about);
}
MT->add_plugin($plugin);
if (MT->version_number < 4) {
    MT->add_callback('HandleJunk',    5, $plugin, \&handle_junk);
    MT->add_callback('HandleNotJunk', 5, $plugin, \&handle_not_junk);
    MT->add_callback('MT::Comment::pre_save', 5, $plugin, \&pre_save_obj);
    MT->add_callback('MT::TBPing::pre_save', 5, $plugin, \&pre_save_obj);
    MT->register_junk_filter({
        name => 'TypePadAntiSpam',
        code => \&typepadantispam_score
    });
    require MT::Template::Context;
    MT::Template::Context->add_tag( TypePadAntiSpamCounter => \&_hdlr_tpas_counter );
}

#--- plugin handlers

sub instance {
    return $plugin;
}

sub description {
    my $plugin = shift;
    my $app = MT->instance;
    my $blog;
    if ($app->isa('MT::App::CMS')) {
        $blog = $app->blog;
    }
    my $sys_blocked = $plugin->blocked();
    my $desc = '<p>' . $plugin->translate('TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."') . '</p>';

    if ($blog) {
        my $blog_blocked = $blog ? $plugin->blocked($blog) : 0;
        $desc .= '<p>' . $plugin->translate('So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.', $blog_blocked, $sys_blocked) . '</p>';
    } else {
        $desc .= '<p>' . $plugin->translate('So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.', $sys_blocked) . '</p>';
    }
    return $desc;
}

sub _hdlr_tpas_counter {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    if ($ctx->can('count_format')) {
        return $ctx->count_format($plugin->blocked($blog), $args);
    } else {
        return $plugin->blocked($blog) || 0;
    }
}

sub save_config {
    my $plugin = shift;
    my ($args, $scope) = @_;

    my $app = MT->instance;

    $scope ||= 'system';
    if ( $scope eq 'system' ) {
        my $existing_api_key = $plugin->api_key || '';
        my $new_api_key = $args->{api_key} || '';
        if ( ($new_api_key ne '') && ( $new_api_key ne $existing_api_key ) ) {
            # user assigned a new API key
            $plugin->require_tpas;
            local $MT::TypePadAntiSpam::SERVICE_HOST = $args->{service_host}
                if $args->{service_host};
            my $url = $app->base . $app->mt_uri;
            my $res = MT::TypePadAntiSpam->verify( $new_api_key, $url );
            if ( $res->http_status >= 500 ) {
                return $plugin->error($plugin->translate("Failed to verify your TypePad AntiSpam API key: [_1]", $res->http_response->message));
            } elsif ( $res->status != 1 ) {
                return $plugin->error($plugin->translate("The TypePad AntiSpam API key provided is invalid."));
            }
        }
    }

    my $result = $plugin->SUPER::save_config(@_);
    return $result if MT->version_number < 4;

    my $user = $app->user;
    my $blog_id = $app->blog->id if $app->blog;

    my $widget_store = $user->widgets();
    if ($widget_store && %$widget_store) {
        my $sys_db = $widget_store->{'dashboard:system'} ||= default_widgets();
        my $blog_db = $widget_store->{'dashboard:blog:' . $blog_id} ||= default_widgets()
            if $blog_id;

        my $changed = 0;
        if ($blog_id && (!exists $blog_db->{'typepadantispam'})) {
            $blog_db->{'typepadantispam'} =
                { order => 2.1,  # following mt shortcuts, if shown
                    set => 'sidebar' };
            $changed++;
        }
        if (!exists $sys_db->{'typepadantispam'}) {
            $sys_db->{'typepadantispam'} =
                { order => 2.1,  # following mt shortcuts, if shown
                    set => 'sidebar' };
            $changed++;
        }
        if ($changed) {
            $user->widgets( $widget_store );
            $user->save;
        }
    }

    return $result;
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
        $param->{'blog_blocked'} = $plugin->blocked($blog) || 0;
    }
    $param->{'system_blocked'} = $plugin->blocked();
    $param->{'language'} = lc substr( MT->instance->current_language, 0, 2 );
    $param->{'use_ssl'} = $app->is_secure;
    $param->{'api_key'} = $plugin->api_key;
    return;
}

sub pre_save_obj {
    my ($cb, $obj) = @_;
    if (!$obj->id && $obj->is_junk && ($obj->junk_log =~ m/TypePad AntiSpam says spam/)) {
        # this was junked due in part to TypePad AntiSpam
        if (my $blog = $obj->blog) {
            $plugin->blocked( $blog, $plugin->blocked($blog) + 1 );
        }
        # now increment total block count:
        $plugin->blocked( undef, $plugin->blocked() + 1 );
    }
}

sub handle_junk {
    my ($cb, $app, $thing) = @_;
    $plugin->require_tpas;
    my $key    = is_valid_key($thing)       or return;
    my $sig    = package_signature($thing)  or return;
    MT::TypePadAntiSpam->submit_spam($sig, $key);
}

sub handle_not_junk {
    my ($cb, $app, $thing) = @_;
    $plugin->require_tpas;
    my $key    = is_valid_key($thing)       or return;
    my $sig    = package_signature($thing)  or return;
    MT::TypePadAntiSpam->submit_ham($sig, $key);
}

sub typepadantispam_score {
    my $thing = shift;
    $plugin->require_tpas;
    my $key    = is_valid_key($thing)
        or return MT::JunkFilter::ABSTAIN();
    my $sig    = package_signature($thing, 1)
        or return MT::JunkFilter::ABSTAIN();
    my $res = MT::TypePadAntiSpam->check($sig, $key);
    my $http_resp = $res->http_response;
    if ( $http_resp && ! $http_resp->is_success ) {
        MT->log("TypePad AntiSpam error: " . $http_resp->message);
    } elsif ( !$http_resp ) {
        if ( MT::TypePadAntiSpam->errstr ) {
            MT->log("TypePad AntiSpam error: " . MT::TypePadAntiSpam->errstr );
        }
    }
    return MT::JunkFilter::ABSTAIN()
        unless $res && $res->http_response->is_success;
    my $weight = $plugin->get_config_value('weight',
        'blog:' . $thing->blog_id) || 1;
    my ($score, $grade) = $res->status
                        ? ($weight, 'ham')
                        : (-$weight, 'spam');
    ($score, ["TypePad AntiSpam says $grade"]);
}

#--- utility

sub is_valid_key {
    my $thing = shift;
    my $r     = MT->request;
    unless ($r->stash('MT::Plugin::TypePadAntiSpam::api_key')) {
        my $key = $plugin->api_key || return;
        $r->stash('MT::Plugin::TypePadAntiSpam::api_key', $key);
    }
    $r->stash('MT::Plugin::TypePadAntiSpam::api_key');
}

sub require_tpas {
    my $plugin = shift;
    require MT::TypePadAntiSpam;

    my $host = $plugin->get_config_value('service_host');
    if ($host) {
        $MT::TypePadAntiSpam::SERVICE_HOST = $host;
    }
}

sub package_signature {
    my $thing = shift;
    my ($include_referrer) = @_;
    my $sig   = MT::TypePadAntiSpam::Signature->new;
    if ($include_referrer) {
        $sig->user_agent($ENV{HTTP_USER_AGENT});
        $sig->referrer($ENV{HTTP_REFERER});
    }
    $sig->user_ip($thing->ip);
    $sig->blog(cache('B' . $thing->blog_id));
    if (ref $thing eq 'MT::Comment') {
        my $entry = $thing->entry;
        $sig->article_date(MT->version_number < 4 ? $entry->created_on : $entry->authored_on);
        $sig->permalink($entry->permalink);
        $sig->comment_type('comment');
        $sig->comment_author($thing->author);
        $sig->comment_author_email($thing->email);
        $sig->comment_author_url($thing->url);
        $sig->comment_content($thing->text);
    } elsif (ref $thing eq 'MT::TBPing') {
        my $p = $thing->parent;
        if ($p->isa('MT::Entry')) {
            $sig->article_date(MT->version_number < 4 ? $p->created_on : $p->authored_on);
            $sig->permalink($p->permalink);
        }
        $sig->comment_type('trackback');
        $sig->comment_author($thing->blog_name);
        $sig->comment_author_url($thing->source_url);
        $sig->comment_content(join "\n", $thing->title, $thing->excerpt);
    } else {
        return;    # don't know what this is.
    }
    $sig;
}

sub cache {
    my $id    = shift;
    my $cache = MT->request->stash('MT::Plugin::TypePadAntiSpam::permalinks');
    unless ($cache) {
        $cache = {};
        MT->request->stash('MT::Plugin::TypePadAntiSpam::permalinks', $cache);
    }
    unless ($cache->{$id}) {
        if ($id =~ /^B/) {
            my $b = MT::Blog->load(substr($id, 1)) or return;
            $cache->{$id} = $b->site_url;
        } else {
            require MT::Entry;
            my $e = MT::Entry->load($id) or return;
            $cache->{$id} = $e->permalink;
        }
    }
    $cache->{$id};
}

sub api_key {
    my $plugin = shift;
    my $blog = shift;
    if (@_) {
        my $key = shift;
        $plugin->set_config_value('api_key', $key);
    } else {
        return $plugin->get_config_value('api_key');
    }
}

sub blocked {
    my $plugin = shift;
    my $blog = shift;
    my $blog_id = (ref($blog) && $blog->isa('MT::Blog')) ? $blog->id : $blog;
    my $blocked = $plugin->get_config_value('blocked', $blog_id ? 'blog:' . $blog_id : 'system');
    return $blocked || 0 unless @_;
    my ($count) = @_;
    $plugin->set_config_value('blocked', $count, $blog_id ? 'blog:' . $blog_id : 'system');
    return $count;
}

1;
