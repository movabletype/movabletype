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
    $param->{blog_id}       = $blog_id if $blog_id;
    $param->{saved}         = $app->param('saved');

    $app->add_breadcrumb($app->translate('Rebuild Trigger'));
    $app->load_tmpl('cfg_rebuild_trigger.tmpl', $param);
}

sub add {
    my $app = shift;

    return $app->permission_denied()
        unless $app->user->is_superuser()
        || ($app->blog
        && $app->user->permissions($app->blog->id)->can_administer_site());

    my $blog_id = $app->blog->id;

    my $type = $app->param('_type') || '';

    my $hasher = sub {
        my ($obj, $row) = @_;
        if ($obj) {
            $row->{label} = $obj->name;
            $row->{link}  = $obj->site_url if $type eq 'blog';
        }
    };

    require MT::RebuildTrigger;

    my $pre_build = sub {
        my ($param) = @_;
        my $count = 0;
        if ((my $loop = $param->{object_loop}) && !$app->param('offset')) {
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
            splice(@$loop, $param->{limit}) if scalar(@$loop) > $param->{limit};
        }
        return $count;
    };

    if ($app->param('search') || $app->param('json')) {
        my $listing_params = {
            args     => { sort => 'name' },
            type     => $type,
            code     => $hasher,
            params   => {
                panel_type      => $type,
                list_noncron    => 1,
                panel_multi     => 0,
                rebuild_trigger => 1,
            },
            template => 'include/listing_panel.tmpl',
            $app->param('search') ? (no_limit => 1) : (),
        };
        if ($type eq 'site') {
            $listing_params->{terms} = { id => { not => [$blog_id] }, class => ['website', 'blog'] };
            $listing_params->{pre_build} = $pre_build unless $app->param('search');
        } elsif (my $select_blog_id = $app->param('select_blog_id')) {
            $listing_params->{terms} = { blog_id => $select_blog_id } if $select_blog_id =~ m/^[0-9]+$/;
        }
        $app->listing($listing_params);
    } else {

        my $params = {};
        $params->{panel_multi}         = 0;
        $params->{rebuild_trigger}     = 1;
        $params->{blog_id}             = $blog_id;
        $params->{dialog_title}        = $app->translate("Create Rebuild Trigger");
        $params->{panel_loop}          = [];
        $params->{return_args}         = $app->return_args;
        $params->{build_compose_menus} = 0;
        $params->{build_user_menus}    = 0;
        $params->{object_type_loop}    = object_type_loop_plugin_reduced($app);
        $params->{action_loop}         = action_loop($app);
        $params->{event_loop}          = event_loop($app);
        $params->{site_name}           = $app->blog->name;

        my @panels = (
            {
                type => 'blog',
                name => 'site',
                panel_info => {
                    panel_title       => $app->translate("Select Site"),
                    panel_label       => $app->translate("Site Name"),
                    panel_description => $app->translate("Description"),
                    search_prompt     => $app->translate("Search Sites and Child Sites"). ':',
                    panel_number      => 1,
                    panel_first       => 1,
                },
            },
            {
                type => 'content_type',
                name => 'content_type',
                panel_info => {
                    panel_title       => $app->translate("Select Content Type"),
                    panel_label       => $app->translate("Name"),
                    panel_description => $app->translate("Description"),
                    search_prompt     => $app->translate("Search Content Type"). ':',
                    panel_number      => 3,
                },
            },
        );

        my $param_limit = $app->param('limit') || 25;

        for (my $i = 0; $i <= $#panels; $i++) {
            my $panel_params = {
                panel_type       => $panels[$i]->{name},
                list_noncron     => 1,
                panel_last       => 0,
                panel_total      => 5,
                panel_has_steps  => 1,
                panel_searchable => 1,
                %{ $panels[$i]->{panel_info} },
            };

            my $listing_params = {
                type   => $panels[$i]->{type},
                code   => $hasher,
                args   => { sort => 'name', limit => $param_limit },
                params => $panel_params,
            };

            if ($panels[$i]->{type} eq 'blog') {
                $listing_params->{terms} = { id => { not => [$blog_id] }, class => ['website', 'blog'] };
                $listing_params->{pre_build} = $pre_build;
            }

            $app->listing($listing_params);

            push @{ $params->{panel_loop} }, $panel_params;
        }

        my @site_has_content_type = ct_count();
        $params->{site_has_content_type}  = \@site_has_content_type;
        $params->{missing_content_type} = 1 unless (scalar @site_has_content_type);

        $app->load_tmpl('dialog/create_trigger.tmpl', $params);
    }
}

sub object_type_loop_plugin_reduced {
    my $app = shift;

    my $switch = $app->config->PluginSwitch;

    my $comment_switch = $switch ? $switch->{Comments} : 1;
    eval { require Comments; };
    my $comment_disabled = $@ || (defined($comment_switch) && $comment_switch == 0);

    my $trackback_switch = $switch ? $switch->{Trackback} : 1;
    eval { require Trackback; };
    my $trackback_disabled = $@ || (defined($trackback_switch) && $trackback_switch == 0);

    my @object_type_loop;
    for my $hash (@{ object_type_loop($app) }) {
        next if ($hash->{id} == MT::RebuildTrigger::TYPE_COMMENT() && $comment_disabled);
        next if ($hash->{id} == MT::RebuildTrigger::TYPE_PING()    && $trackback_disabled);
        push @object_type_loop, $hash;
    }
    return \@object_type_loop;
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
        { id => MT::RebuildTrigger::EVENT_UNPUBLISH(), name => $app->translate('__UNPUBLISHED') }];
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

sub unstringify {
    my ($app, $csv) = @_;

    if ($csv =~ /[^0-9,]/) {
        die $app->translate('Format Error: Trigger data include illegal characters.');
    }

    my @array = split(/,/, $csv);

    if (scalar @array != 7) {
        die $app->translate('Format Error: Comma-separated-values contains wrong number of fields.');
    }

    my $hash  = { id => shift @array };
    for (my $i = 0; $i <= $#key_fields; $i++) {
        $hash->{ $key_fields[$i] } = $array[$i] || 0;
    }
    return $hash;
}

sub save {
    my $app = shift;
    $app->validate_magic or return;

    return $app->permission_denied()
        unless $app->user->is_superuser()
        || ($app->blog && $app->user->permissions($app->blog->id)->can_administer_site());

    if ($app->param('blog_id')) {

        my $blog_id = $app->blog ? $app->blog->id : return;
        my @db_rts  = MT->model('rebuild_trigger')->load({ blog_id => $blog_id });
        my %digests = map { _rt_digest($_), $_ } @db_rts;

        my $triggers = eval {
            [map { unstringify($app, $_) } $app->multi_param('rebuild_trigger')];
        };
        return $app->error($@) if $@;

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

    if (defined(my $val = $app->param('default_access_allowed'))) {
        $app->config('DefaultAccessAllowed', $val, 1);
    }
    $app->config->save_config;

    if (my $blog = $app->blog) {
        $blog->blog_content_accessible(scalar $app->param('blog_content_accessible'));
        if (defined(my $val = $app->param('default_mt_sites_action'))) {
            $blog->default_mt_sites_action($val);
        }
        if (my $val = $app->param('default_mt_sites_sites')) {
            $blog->default_mt_sites_sites($val);
        }
        $blog->save;
    }

    $app->add_return_arg('saved' => 1);
    $app->call_return;
}

1;
