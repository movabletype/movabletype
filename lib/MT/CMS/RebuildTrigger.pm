# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::RebuildTrigger;

use strict;

sub config {
    my $app     = shift;
    my $param   = {};
    my $blog_id = $app->param('blog_id') || 0;

    return $app->permission_denied()
        unless $app->can_do('administer_site');
    return $app->permission_denied()
        unless $app->can_do('edit_config');

    $param->{default_access_allowed} = $app->config('DefaultAccessAllowed');

    if ( my $blog = $app->blog ) {
        $param->{blog_content_accessible}
            = $blog->blog_content_accessible || 0;
        $param->{default_mt_sites_action}
            = $blog->default_mt_sites_action || 1;
        $param->{default_mt_sites_sites}
            = $blog->default_mt_sites_sites || '';
    }

    my @rebuild_triggers
        = MT->model('rebuild_trigger')->load( { blog_id => $blog_id } );

    foreach my $rt (@rebuild_triggers) {
        my $action
            = $rt->action == MT::RebuildTrigger::ACTION_RI() ? 'ri' : 'rip';
        my $target
            = $rt->target == MT::RebuildTrigger::TARGET_ALL() ? '_all'
            : $rt->target == MT::RebuildTrigger::TARGET_BLOGS_IN_WEBSITE()
            ? '_blogs_in_website'
            : $rt->target_blog_id;
        my $objct_type
            = $rt->object_type == MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE()
            ? 'entry'
            : $rt->object_type == MT::RebuildTrigger::TYPE_CONTENT_TYPE()
            ? 'content'
            : $rt->object_type == MT::RebuildTrigger::TYPE_COMMENT()
            ? 'comment'
            : 'ping';
        my $event
            = $rt->event == MT::RebuildTrigger::EVENT_SAVE()    ? 'save'
            : $rt->event == MT::RebuildTrigger::EVENT_PUBLISH() ? 'pub'
            :                                                     'unpub';
        my $new_trigger = join ':', $action, $target,
            $objct_type . '_' . $event, $rt->ct_id;
        $param->{rebuild_triggers}
            = $param->{rebuild_triggers}
            ? join '|', $param->{rebuild_triggers}, $new_trigger
            : $new_trigger;
    }

    if ( $param->{rebuild_triggers} ) {
        load_config( $app, $param,
            ( $blog_id ? "blog:$blog_id" : 'system' ) );
    }

    $param->{saved} = $app->param('saved');
    $app->load_tmpl( 'cfg_rebuild_trigger.tmpl', $param );
}

sub add {
    my $app = shift;

    return $app->permission_denied()
        unless $app->user->is_superuser()
        || ( $app->blog
        && $app->user->permissions( $app->blog->id )->can_administer_site() );

    my $blog_id = $app->blog->id;

    my @panels = (
        { type => 'blog',         'name' => 'site' },
        { type => 'content_type', 'name' => 'content_type' },
    );

    my $panel_info = {
        'blog' => {
            panel_title       => $app->translate("Select Trigger Site"),
            panel_label       => $app->translate("Site Name"),
            panel_description => $app->translate("Description"),
        },
        'content_type' => {
            panel_title => $app->translate("Select Trigger Content Type"),
            panel_label => $app->translate("Content Type Name"),
            panel_description => $app->translate("Description"),
        },
    };

    my $type = $app->param('_type') || '';

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        if ($obj) {
            $row->{label} = $obj->name;
            $row->{link}  = $obj->site_url
                if $type eq 'blog';
        }
    };

    my $terms = {};
    if ( $type eq 'site' ) {
        $terms->{id} = { not => [$blog_id] };
        $terms->{class} = [ 'website', 'blog' ];
    }
    elsif ( my $select_blog_id = $app->param('select_blog_id') ) {
        $terms->{blog_id} = $select_blog_id if $select_blog_id =~ m/\d+/;
    }

    if ( $app->param('search') || $app->param('json') ) {
        my $params = {
            panel_type      => $type,
            list_noncron    => 1,
            panel_multi     => 0,
            rebuild_trigger => 1,
        };
        $app->listing(
            {   terms    => $terms,
                args     => { sort => 'name' },
                type     => $type,
                code     => $hasher,
                params   => $params,
                template => 'include/listing_panel.tmpl',
                $app->param('search') ? ( no_limit => 1 ) : (),
            }
        );
    }
    else {
        my $params = {};
        $params->{panel_multi}     = 0;
        $params->{rebuild_trigger} = 1;
        $params->{blog_id}         = $blog_id;
        $params->{dialog_title} = $app->translate("Create Rebuild Trigger");
        $params->{panel_loop}   = [];

        for ( my $i = 0; $i <= $#panels; $i++ ) {
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
                    : $app->translate("Search Content Type")
                    )
                    . ':',
            };

            my $limit = $app->param('limit') || 25;
            my $terms = {};
            if ( $source eq 'blog' ) {
                $terms->{id} = { not => [$blog_id] };
                $terms->{class} = [ 'website', 'blog' ];
            }
            elsif ( $source eq 'content_type' ) {
                $terms->{blog_id} = $id if $id;
            }
            my $args = {};
            if ( $source eq 'blog' || $source eq 'content_type' ) {
                $args->{sort}  = 'name';
                $args->{limit} = $limit;
            }

            $app->listing(
                {   type      => $source,
                    code      => $hasher,
                    terms     => $terms,
                    args      => $args,
                    params    => $panel_params,
                    pre_build => sub {
                        my ($param) = @_;
                        my $offset = $app->param('offset') || 0;
                        my $limit  = $param->{limit};
                        my $count  = 0;
                        if ( $source eq 'blog' ) {
                            if ( !$app->param('search') ) {
                                if ( ( my $loop = $param->{object_loop} )
                                    && !$offset )
                                {
                                    if ( $app->blog && !$app->blog->is_blog )
                                    {
                                        $count++;
                                        unshift @$loop,
                                            {
                                            id    => '_blogs_in_website',
                                            label => $app->translate(
                                                '(All child sites in this site)'
                                            ),
                                            description => $app->translate(
                                                'Select to apply this trigger to all child sites in this site.'
                                            ),
                                            };
                                    }
                                    $count++;
                                    unshift @$loop,
                                        {
                                        id    => '_all',
                                        label => $app->translate(
                                            '(All sites and child sites in this system)'
                                        ),
                                        description => $app->translate(
                                            'Select to apply this trigger to all sites and child sites in this system.'
                                        ),
                                        };
                                    splice( @$loop, $limit )
                                        if scalar(@$loop) > $limit;
                                }
                            }
                        }
                        return $count;
                    },
                },
            );

            if ($source eq 'content_type'
                && (!$panel_params->{object_loop}
                    || ( $panel_params->{object_loop}
                        && @{ $panel_params->{object_loop} } < 1 )
                )
                )
            {
                $params->{"missing_$source"} = 1;
            }

            push @{ $params->{panel_loop} }, $panel_params;
        }
        $params->{return_args} = $app->return_args;

        $params->{confirm_js} = $app->param('confirm_js')
            if $app->param('confirm_js');

        $params->{build_compose_menus} = 0;
        $params->{build_user_menus}    = 0;

        require MT::RebuildTrigger;
        $params->{object_type_loop} = [
            {   id => MT::RebuildTrigger::type_text(
                    MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE()
                ),
                label => $app->translate("Entry or Page")
            },
            {   id => MT::RebuildTrigger::type_text(
                    MT::RebuildTrigger::TYPE_CONTENT_TYPE()
                ),
                label => $app->translate("Content Type")
            },
        ];
        my $plugin_switch = $app->config->PluginSwitch;
        my $comment_switch
            = defined($plugin_switch) ? $plugin_switch->{Comments} : 1;
        eval { require Comments; };

        if ( !$@ && ( !defined($comment_switch) || $comment_switch != 0 ) ) {
            push @{ $params->{object_type_loop} },
                {
                id => MT::RebuildTrigger::type_text(
                    MT::RebuildTrigger::TYPE_COMMENT()
                ),
                label => $app->translate("Comment")
                };
        }
        my $trackback_switch
            = defined($plugin_switch) ? $plugin_switch->{Trackback} : 1;
        eval { require Trackback; };
        if ( !$@
            && ( !defined($trackback_switch) || $trackback_switch != 0 ) )
        {
            push @{ $params->{object_type_loop} },
                {
                id => MT::RebuildTrigger::type_text(
                    MT::RebuildTrigger::TYPE_PING()
                ),
                label => $app->translate("Trackback")
                };
        }
        $params->{action_loop}  = action_loop($app);
        $params->{trigger_loop} = trigger_loop($app);
        $params->{site_name}    = $app->blog->name;

        # Does a site have the content type?
        my @sites = MT->model('blog')->load( { class => '*' } );
        my @site_has_content_type = map {
            my $site = $_;
            my @content_type
                = MT->model('content_type')->load( { blog_id => $site->id } );
            { id => $_->id, value => $#content_type + 1 };
        } @sites;
        $params->{site_has_content_type} = \@site_has_content_type;

        $app->load_tmpl( 'dialog/create_trigger.tmpl', $params );
    }
}

sub trigger_loop {
    my $app = shift;
    [   {   trigger_key    => 'entry_save',
            trigger_name   => $app->translate('saves an entry/page'),
            trigger_object => $app->translate('Entry/Page'),
            trigger_action => $app->translate('Save'),
        },
        {   trigger_key    => 'entry_pub',
            trigger_name   => $app->translate('publishes an entry/page'),
            trigger_object => $app->translate('Entry/Page'),
            trigger_action => $app->translate('Publish'),
        },
        {   trigger_key    => 'entry_unpub',
            trigger_name   => $app->translate('unpublishes an entry/page'),
            trigger_object => $app->translate('Entry/Page'),
            trigger_action => $app->translate('Unpublish'),
        },
        {   trigger_key    => 'content_save',
            trigger_name   => $app->translate('saves a content'),
            trigger_object => $app->translate('Content Type'),
            trigger_action => $app->translate('Save'),
        },
        {   trigger_key    => 'content_pub',
            trigger_name   => $app->translate('publishes a content'),
            trigger_object => $app->translate('Content Type'),
            trigger_action => $app->translate('Publish'),
        },
        {   trigger_key    => 'content_unpub',
            trigger_name   => $app->translate('unpublishes a content'),
            trigger_object => $app->translate('Content Type'),
            trigger_action => $app->translate('Unpublish'),
        },
        {   trigger_key    => 'comment_pub',
            trigger_name   => $app->translate('publishes a comment'),
            trigger_object => $app->translate('Comment'),
            trigger_action => $app->translate('Publish'),
        },
        {   trigger_key    => 'tb_pub',
            trigger_name   => $app->translate('publishes a TrackBack'),
            trigger_object => $app->translate('TrackBack'),
            trigger_action => $app->translate('Publish'),
        },
    ];
}

sub trigger_hash {
    my $app          = shift;
    my $trigger_hash = {};
    foreach my $trigger ( @{ trigger_loop($app) } ) {
        $trigger_hash->{ $trigger->{trigger_key} }
            = $trigger->{trigger_name};
    }
    return $trigger_hash;
}

sub action_loop {
    my $app = shift;
    [   {   action_id   => 'ri',
            action_name => $app->translate('rebuild indexes.'),
        },
        {   action_id   => 'rip',
            action_name => $app->translate('rebuild indexes and send pings.'),
        },
    ];
}

sub action_hash {
    my $app         = shift;
    my $action_hash = {};
    foreach my $action ( @{ action_loop($app) } ) {
        $action_hash->{ $action->{action_id} }
            = $action->{action_name};
    }
    return $action_hash;
}

sub load_config {
    my $app = shift;
    my ( $args, $scope ) = @_;

    if ( $scope =~ /blog:(\d+)/ ) {
        my $blog_id = $1;

        require MT::Blog;

        $args->{multiblog_trigger_loop} = trigger_loop($app);
        my %triggers = map {
            $_->{trigger_key} => {
                name   => $_->{trigger_name},
                object => $_->{trigger_object},
                action => $_->{trigger_action}
                }
        } @{ $args->{multiblog_trigger_loop} };

        $args->{multiblog_action_loop} = action_loop($app);
        my %actions = map { $_->{action_id} => $_->{action_name} }
            @{ $args->{multiblog_action_loop} };

        my $rebuild_triggers = $args->{rebuild_triggers};
        my @rebuilds         = map {
            my ( $action, $id, $trigger, $content_type_id )
                = split( /:/, $_ );
            my $content_type;
            $content_type = MT->model('content_type')->load($content_type_id)
                if $content_type_id;
            my $content_type_name = $content_type ? $content_type->name : '';
            if ( $id eq '_all' ) {
                {   action_name  => $actions{$action},
                    action_value => $action,
                    blog_name    => $app->translate(
                        '(All sites and child sites in this system)'
                    ),
                    blog_id        => $id,
                    trigger_name   => $triggers{$trigger}{name},
                    trigger_object => $content_type_id
                    ? $content_type_name
                    : $triggers{$trigger}{object},
                    trigger_action    => $triggers{$trigger}{action},
                    trigger_value     => $trigger,
                    content_type_name => $content_type_name,
                    content_type_id   => $content_type_id,
                };
            }
            elsif ( $id eq '_blogs_in_website' ) {
                {   action_name  => $actions{$action},
                    action_value => $action,
                    blog_name =>
                        $app->translate('(All child sites in this site)'),
                    blog_id        => $id,
                    trigger_name   => $triggers{$trigger}{name},
                    trigger_object => $content_type_id
                    ? $content_type_name
                    : $triggers{$trigger}{object},
                    trigger_action    => $triggers{$trigger}{action},
                    trigger_value     => $trigger,
                    content_type_name => $content_type_name,
                    content_type_id   => $content_type_id,
                };
            }
            elsif ( my $blog = MT::Blog->load( $id, { cached_ok => 1 } ) ) {
                {   action_name    => $actions{$action},
                    action_value   => $action,
                    blog_name      => $blog->name,
                    blog_id        => $id,
                    trigger_name   => $triggers{$trigger}{name},
                    trigger_object => $content_type_id
                    ? $content_type_name
                    : $triggers{$trigger}{object},
                    trigger_action    => $triggers{$trigger}{action},
                    trigger_value     => $trigger,
                    content_type_name => $content_type_name,
                    content_type_id   => $content_type_id,
                };
            }
            else {
                ();
            }
        } split( /\|/, $rebuild_triggers );
        $args->{rebuilds_loop} = \@rebuilds;
    }

    if ( $app->isa('MT::App') ) {
        $args->{blog_id} = $app->blog->id if $app->blog;
    }
}

sub save {
    my $app = shift;
    $app->validate_magic or return;
    my $blog_id = $app->blog ? $app->blog->id : 0;
    my @p = $app->multi_param;
    my %params;

    my @rebuild_triggers
        = MT->model('rebuild_trigger')->load( { blog_id => $blog_id } );
    my @new_triggers = ();

    for my $key (
        qw/ all_triggers blogs_in_website_triggers rebuild_triggers /)
    {
        if ( $app->multi_param($key) ) {
            my @triggers = split '\|', $app->multi_param($key);
            foreach my $trigger (@triggers) {
                my ( $action, $id, $event, $content_type_id )
                    = split ':',
                    $trigger;
                $content_type_id = 0 if $content_type_id eq 'undefined';
                $action
                    = $action eq 'ri'
                    ? MT::RebuildTrigger::ACTION_RI()
                    : MT::RebuildTrigger::ACTION_RIP();
                my $object_type
                    = $event =~ /^entry_.*/
                    ? MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE()
                    : $event =~ /^comment_.*/
                    ? MT::RebuildTrigger::TYPE_COMMENT()
                    : $event =~ /^tb_.*/ ? MT::RebuildTrigger::TYPE_PING()
                    :   MT::RebuildTrigger::TYPE_CONTENT_TYPE();
                $event
                    = $event =~ /.*_save$/ ? MT::RebuildTrigger::EVENT_SAVE()
                    : $event =~ /.*_pub$/
                    ? MT::RebuildTrigger::EVENT_PUBLISH()
                    : MT::RebuildTrigger::EVENT_UNPUBLISH();
                my $target
                    = $id eq '_all' ? MT::RebuildTrigger::TARGET_ALL()
                    : $id eq '_blogs_in_website'
                    ? MT::RebuildTrigger::TARGET_BLOGS_IN_WEBSITE()
                    : MT::RebuildTrigger::TARGET_BLOG();
                my $target_blog_id = $id =~ /\d+/ ? $id : 0;
                my ($rt) = grep {
                           $_->blog_id == $blog_id
                        && $_->object_type == $object_type
                        && $_->action == $action
                        && $_->event == $event
                        && $_->target == $target
                        && $_->target_blog_id == $target_blog_id
                        && $_->ct_id == $content_type_id
                } @rebuild_triggers;

                unless ($rt) {
                    $rt = MT->model('rebuild_trigger')->new;
                    $rt->blog_id($blog_id);
                    $rt->object_type($object_type);
                    $rt->action($action);
                    $rt->event($event);
                    $rt->target($target);
                    $rt->target_blog_id($target_blog_id);
                    $rt->ct_id($content_type_id);
                }
                push @new_triggers, $rt;
            }
        }
    }

    # Remove
    foreach my $rt (@rebuild_triggers) {
        my ($exist) = grep {
                   $_->blog_id == $rt->blog_id
                && $_->object_type == $rt->object_type
                && $_->action == $rt->action
                && $_->event == $rt->event
                && $_->target == $rt->target
                && $_->target_blog_id == $rt->target_blog_id
                && $_->ct_id == $rt->ct_id
        } @new_triggers;
        unless ($exist) {
            $rt->remove or return $app->error( $rt->errstr );
        }
    }

    # Save
    foreach my $rt (@new_triggers) {
        $rt->save or return $app->error( $rt->errstr );
    }

    $app->config( 'DefaultAccessAllowed',
        $app->multi_param('default_access_allowed'), 1 )
        if defined $app->multi_param('default_access_allowed');
    $app->config->save_config;

    if ( my $blog = $app->blog ) {
        $blog->blog_content_accessible(
            $app->multi_param('blog_content_accessible') );
        $blog->default_mt_sites_action(
            $app->multi_param('default_mt_sites_action') )
            if $app->multi_param('default_mt_sites_action');
        $blog->default_mt_sites_sites(
            $app->multi_param('default_mt_sites_sites') )
            if $app->multi_param('default_mt_sites_sites');
        $blog->save;
    }

    $app->add_return_arg( 'saved' => 1 );
    $app->call_return;
}

1;
