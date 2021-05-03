# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::RebuildTrigger;

use strict;
use warnings;

sub config {
    my $app     = shift;
    my $param   = {};
    my $blog_id = $app->param('blog_id') || 0;

    return $app->permission_denied() unless $app->can_do('administer_site');
    return $app->permission_denied() unless $app->can_do('edit_config');

    $param->{default_access_allowed} = $app->config('DefaultAccessAllowed');
    if ($app->config->is_readonly('DefaultAccessAllowed')) {
        $param->{config_warning_default_access_allowed} = $app->translate(
            "These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.",
            'DefaultAccessAllowed',
        );
    }

    if (my $blog = $app->blog) {
        $param->{blog_content_accessible} = $blog->blog_content_accessible || 0;
        $param->{default_mt_sites_action} = defined($blog->default_mt_sites_action) ? $blog->default_mt_sites_action : 1;
        $param->{default_mt_sites_sites}  = $blog->default_mt_sites_sites || '';
    }

    $param->{rebuilds_json} = load_config($app, $blog_id) if $blog_id;

    $param->{blog_id} = $app->blog->id if $app->isa('MT::App') && $app->blog;

    $app->add_breadcrumb($app->translate('Rebuild Trigger'));

    $param->{saved} = $app->param('saved');
    $app->load_tmpl('cfg_rebuild_trigger.tmpl', $param);
}

sub add {
    my $app = shift;

    return $app->permission_denied()
        unless $app->user->is_superuser()
        || ($app->blog
        && $app->user->permissions($app->blog->id)->can_administer_site());

    my $blog_id = $app->blog->id;

    my @panels = (
        { type => 'blog',         'name' => 'site' },
        { type => 'content_type', 'name' => 'content_type' },
    );

    my $panel_info = {
        'blog' => {
            panel_title       => $app->translate("Select Site"),
            panel_label       => $app->translate("Site Name"),
            panel_description => $app->translate("Description"),
        },
        'content_type' => {
            panel_title       => $app->translate("Select Content Type"),
            panel_label       => $app->translate("Name"),
            panel_description => $app->translate("Description"),
        },
    };

    my $type = $app->param('_type') || '';

    my $hasher = sub {
        my ($obj, $row) = @_;
        if ($obj) {
            $row->{label} = $obj->name;
            $row->{link}  = $obj->site_url if $type eq 'blog';
        }
    };

    my $terms = {};
    if ($type eq 'site') {
        $terms->{id}    = { not => [$blog_id] };
        $terms->{class} = ['website', 'blog'];
    } elsif (my $select_blog_id = $app->param('select_blog_id')) {
        $terms->{blog_id} = $select_blog_id if $select_blog_id =~ m/^[0-9]+$/;
    }

    if ($app->param('search') || $app->param('json')) {
        my $params = {
            panel_type      => $type,
            list_noncron    => 1,
            panel_multi     => 0,
            rebuild_trigger => 1,
        };
        $app->listing({
            terms    => $terms,
            args     => { sort => 'name' },
            type     => $type,
            code     => $hasher,
            params   => $params,
            template => 'include/listing_panel.tmpl',
            $app->param('search') ? (no_limit => 1) : (),
        });
    } else {
        my $params = {};
        $params->{panel_multi}     = 0;
        $params->{rebuild_trigger} = 1;
        $params->{blog_id}         = $blog_id;
        $params->{dialog_title}    = $app->translate("Create Rebuild Trigger");
        $params->{panel_loop}      = [];

        require MT::RebuildTrigger;

        for (my $i = 0; $i <= $#panels; $i++) {
            my $source       = $panels[$i]->{type};
            my $name         = $panels[$i]->{name};
            my $id           = $panels[$i]->{id};
            my $panel_params = {
                panel_type => $name,
                %{ $panel_info->{$source} },
                list_noncron => 1,

                panel_last       => 0,
                panel_first      => $i == 0,
                panel_number     => $i == 0 ? 1 : 3,
                panel_total      => 5,
                panel_has_steps  => 1,
                panel_searchable => 1,
                search_prompt    => (
                      $i == 0
                    ? $app->translate("Search Sites and Child Sites")
                    : $app->translate("Search Content Type"))
                    . ':',
            };

            my $limit = $app->param('limit') || 25;
            my $terms = {};
            if ($source eq 'blog') {
                $terms->{id}    = { not => [$blog_id] };
                $terms->{class} = ['website', 'blog'];
            } elsif ($source eq 'content_type') {
                $terms->{blog_id} = $id if $id;
            }
            my $args = {};
            if ($source eq 'blog' || $source eq 'content_type') {
                $args->{sort}  = 'name';
                $args->{limit} = $limit;
            }

            $app->listing({
                    type      => $source,
                    code      => $hasher,
                    terms     => $terms,
                    args      => $args,
                    params    => $panel_params,
                    pre_build => sub {
                        my ($param) = @_;
                        my $offset  = $app->param('offset') || 0;
                        my $limit   = $param->{limit};
                        my $count   = 0;
                        if ($source eq 'blog') {
                            if (!$app->param('search')) {
                                if ((my $loop = $param->{object_loop}) && !$offset) {
                                    if ($app->blog && !$app->blog->is_blog) {
                                        $count++;
                                        unshift @$loop, {
                                            id          => '_' . MT::RebuildTrigger::TARGET_BLOGS_IN_WEBSITE(),
                                            label       => $app->translate('(All child sites in this site)'),
                                            description => $app->translate('Select to apply this trigger to all child sites in this site.'),
                                        };
                                    }
                                    $count++;
                                    unshift @$loop, {
                                        id          => '_' . MT::RebuildTrigger::TARGET_ALL(),
                                        label       => $app->translate('(All sites and child sites in this system)'),
                                        description => $app->translate('Select to apply this trigger to all sites and child sites in this system.'),
                                    };
                                    splice(@$loop, $limit) if scalar(@$loop) > $limit;
                                }
                            }
                        }
                        return $count;
                    },
                },
            );

            push @{ $params->{panel_loop} }, $panel_params;
        }
        $params->{return_args}         = $app->return_args;
        $params->{build_compose_menus} = 0;
        $params->{build_user_menus}    = 0;
        $params->{object_type_loop}    = object_type_loop($app);

        my $plugin_switch  = $app->config->PluginSwitch;
        my $comment_switch = defined($plugin_switch) ? $plugin_switch->{Comments} : 1;
        eval { require Comments; };

        unless (!$@ && (!defined($comment_switch) || $comment_switch != 0)) {
            $params->{object_type_loop} =
                [grep { $_->{id} != MT::RebuildTrigger::TYPE_COMMENT() } @{ $params->{object_type_loop} }];
        }

        my $trackback_switch = defined($plugin_switch) ? $plugin_switch->{Trackback} : 1;
        eval { require Trackback; };

        unless (!$@ && (!defined($trackback_switch) || $trackback_switch != 0)) {
            $params->{object_type_loop} =
                [grep { $_->{id} != MT::RebuildTrigger::TYPE_PING() } @{ $params->{object_type_loop} }];
        }

        $params->{action_loop} = action_loop($app);
        $params->{event_loop}  = event_loop($app);
        $params->{site_name}   = $app->blog->name;

        my @site_has_content_type = ct_count();
        $params->{site_has_content_type}  = \@site_has_content_type;
        $params->{"missing_content_type"} = 1 unless (scalar @site_has_content_type);

        $app->load_tmpl('dialog/create_trigger.tmpl', $params);
    }
}

sub ct_count {
    my @ret;
    my $count_iter = MT->model('content_type')->count_group_by(undef, { group => ["blog_id"] });
    while (my ($count, $id) = $count_iter->()) {
        push @ret, { id => $id, value => $count };
    }
    return @ret;
}

sub action_loop {
    my $app = shift;
    return [
        { id => MT::RebuildTrigger::ACTION_RI(),  name => $app->translate('rebuild indexes.') },
        { id => MT::RebuildTrigger::ACTION_RIP(), name => $app->translate('rebuild indexes and send pings.') }];
}

sub event_loop {
    my $app = shift;
    return [
        { id => MT::RebuildTrigger::EVENT_SAVE(),      name => $app->translate('Save') },
        { id => MT::RebuildTrigger::EVENT_PUBLISH(),   name => $app->translate('Publish') },
        { id => MT::RebuildTrigger::EVENT_UNPUBLISH(), name => $app->translate('Unpublish') }];
}

sub object_type_loop {
    my $app = shift;
    return [
        { id => MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE(), name => $app->translate('Entry/Page') },
        { id => MT::RebuildTrigger::TYPE_CONTENT_TYPE(),  name => $app->translate('Content Type') },
        { id => MT::RebuildTrigger::TYPE_COMMENT(),       name => $app->translate('Comment') },
        { id => MT::RebuildTrigger::TYPE_PING(),          name => $app->translate('TrackBack') }];
}

sub load_config {
    my ($app, $blog_id) = @_;

    require MT::Blog;
    require MT::RebuildTrigger;
    require JSON;

    my %actions_hash = (map { $_->{id}, $_->{name} } @{ action_loop($app) });
    my %event_hash   = (map { $_->{id}, $_->{name} } @{ event_loop($app) });
    my %object_hash  = (map { $_->{id}, $_->{name} } @{ object_type_loop($app) });
    my @json_seed;

    for my $rt (MT->model('rebuild_trigger')->load({ blog_id => $blog_id })) {
        my $ct      = $rt->ct_id ? MT->model('content_type')->load($rt->ct_id) : undef;
        my $ct_name = $ct        ? $ct->name                                   : '';
        my $e       = {
            id             => $rt->id,
            action_label   => $actions_hash{ $rt->action },
            action         => $rt->action,
            object_label   => $rt->ct_id ? $ct_name : $object_hash{ $rt->object_type },
            event_label    => $event_hash{ $rt->event },
            object_type    => $rt->object_type,
            event          => $rt->event,
            ct_name        => $ct_name,
            ct_id          => $rt->ct_id,
            target         => $rt->target,
            target_blog_id => $rt->target_blog_id,
        };
        if ($rt->target == MT::RebuildTrigger::TARGET_ALL()) {
            $e->{blog_name} = $app->translate('(All sites and child sites in this system)');
        } elsif ($rt->target == MT::RebuildTrigger::TARGET_BLOGS_IN_WEBSITE()) {
            $e->{blog_name} = $app->translate('(All child sites in this site)');
        } elsif (my $blog = MT::Blog->load($rt->target_blog_id, { cached_ok => 1 })) {
            $e->{blog_name} = $blog->name;
        } else {
            $rt->remove() and next;    # never reach here
        }
        push @json_seed, $e;
    }

    return JSON->new->utf8(0)->encode(\@json_seed);
}

my @key_fields = ('object_type', 'action', 'event', 'target', 'target_blog_id', 'ct_id');

sub _rt_digest {
    my $rt = shift;
    return join(',', map { $rt->$_ } @key_fields);
}

sub save {
    my $app = shift;
    $app->validate_magic or return;

    return $app->permission_denied()
        unless $app->user->is_superuser()
        || ($app->blog && $app->user->permissions($app->blog->id)->can_administer_site());

    if (my $req_triggers = $app->multi_param('rebuild_triggers')) {

        my $blog_id = $app->blog ? $app->blog->id : return;
        my @db_rts  = MT->model('rebuild_trigger')->load({ blog_id => $blog_id });
        my %digests = map { _rt_digest($_), $_ } @db_rts;

        require JSON;
        my $triggers = JSON->new->utf8(0)->decode(MT::Util::decode_js($req_triggers));

        # delete
        {
            my %front_ids       = map { $_->{id}, 1 } grep { $_->{id} } @$triggers;
            my %db_id_to_digest = map { $digests{$_}->id, $_ } keys(%digests);
            for my $id (grep { !exists $front_ids{$_} } map { $_->id } @db_rts) {
                if (my $rt = $digests{ $db_id_to_digest{$id} }) {
                    $rt->remove or return $app->error($rt->errstr);
                    delete $digests{ $db_id_to_digest{$id} };
                }
            }
        }

        for my $t (@$triggers) {
            next if (grep { !exists($t->{$_}) } @key_fields);    # in case request is broken
            my $rt = MT->model('rebuild_trigger')->new;
            $rt->blog_id($blog_id);
            $rt->object_type($t->{object_type});
            $rt->action($t->{action});
            $rt->event($t->{event});
            $rt->target($t->{target});
            $rt->target_blog_id($t->{target_blog_id} || 0);
            $rt->ct_id($t->{ct_id}                   || 0);

            my $new_digest = _rt_digest($rt);
            next if (exists $digests{$new_digest});
            $digests{$new_digest} = 0;
            $rt->save or return $app->error($rt->errstr);
        }
    }

    $app->config('DefaultAccessAllowed', $app->multi_param('default_access_allowed'), 1)
        if defined $app->multi_param('default_access_allowed');
    $app->config->save_config;

    if (my $blog = $app->blog) {
        $blog->blog_content_accessible($app->multi_param('blog_content_accessible'));
        $blog->default_mt_sites_action($app->multi_param('default_mt_sites_action'))
            if defined($app->multi_param('default_mt_sites_action'));
        $blog->default_mt_sites_sites($app->multi_param('default_mt_sites_sites'))
            if $app->multi_param('default_mt_sites_sites');
        $blog->save;
    }

    $app->add_return_arg('saved' => 1);
    $app->call_return;
}

1;
