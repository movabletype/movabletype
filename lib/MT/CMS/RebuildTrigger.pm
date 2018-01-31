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
            : 'content';
        my $event
            = $rt->event == MT::RebuildTrigger::EVENT_SAVE()    ? 'save'
            : $rt->event == MT::RebuildTrigger::EVENT_PUBLISH() ? 'pub'
            :                                                     'unpub';
        my $new_trigger = join ':', $action, $target,
            $objct_type . '_' . $event;
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

    return $app->translate("Permission denied.")
        unless $app->user->is_superuser()
        || ( $app->blog
        && $app->user->permissions( $app->blog->id )->can_administer_site() );

    my $blog_id = $app->blog->id;

    my $dialog_tmpl = $app->load_tmpl(
        $app->param('json')
        ? 'include/listing_panel.tmpl'
        : 'dialog/create_trigger.tmpl'
    );
    my $tmpl = $app->listing(
        {   template => $dialog_tmpl,
            type     => 'blog',
            code     => sub {
                my ( $obj, $row ) = @_;
                if ($obj) {
                    $row->{label} = $obj->name;
                    $row->{link}  = $obj->site_url;
                }
            },
            terms => {
                id => { not => [$blog_id] },
                class => [ 'website', 'blog' ]
            },
            params => {
                panel_type   => 'blog',
                dialog_title => $app->translate('Rebuild Trigger'),
                panel_title  => $app->translate('Create Rebuild Trigger'),
                panel_label  => $app->translate("Site/Child Site"),
                search_prompt =>
                    $app->translate("Search Sites and Child Sites") . ':',
                panel_description      => $app->translate("Description"),
                panel_multi            => 0,
                panel_first            => 1,
                panel_last             => 1,
                panel_searchable       => 1,
                multiblog_trigger_loop => trigger_loop($app),
                multiblog_action_loop  => action_loop($app),
                list_noncron           => 1,
                trigger_caption        => $app->translate('When this'),
            },
            pre_build => sub {
                my ($param) = @_;
                my $offset = $app->param('offset') || 0;
                my $limit  = $param->{limit};
                my $count  = 0;
                if ( !$app->param('search') ) {
                    if ( ( my $loop = $param->{object_loop} ) && !$offset ) {
                        if ( $app->blog && !$app->blog->is_blog ) {
                            $count++;
                            unshift @$loop,
                                {
                                id    => '_blogs_in_website',
                                label => $app->translate(
                                    '(All child sites in this site)'),
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
                                '(All sites and child sites in this system)'),
                            description => $app->translate(
                                'Select to apply this trigger to all sites and child sites in this system.'
                            ),
                            };
                        splice( @$loop, $limit ) if scalar(@$loop) > $limit;
                    }
                }
                return $count;
            },
        }
    );
    return $app->build_page($tmpl);
}

sub trigger_loop {
    my $app = shift;
    [   {   trigger_key  => 'entry_save',
            trigger_name => $app->translate('saves an entry/page'),
        },
        {   trigger_key  => 'entry_pub',
            trigger_name => $app->translate('publishes an entry/page'),
        },
        {   trigger_key  => 'entry_unpub',
            trigger_name => $app->translate('unpublishes an entry/page'),
        },
        {   trigger_key  => 'comment_pub',
            trigger_name => $app->translate('publishes a comment'),
        },
        {   trigger_key  => 'tb_pub',
            trigger_name => $app->translate('publishes a TrackBack'),
        },
    ];
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

sub load_config {
    my $app = shift;
    my ( $args, $scope ) = @_;

    if ( $scope =~ /blog:(\d+)/ ) {
        my $blog_id = $1;

        require MT::Blog;

        $args->{multiblog_trigger_loop} = trigger_loop($app);
        my %triggers = map { $_->{trigger_key} => $_->{trigger_name} }
            @{ $args->{multiblog_trigger_loop} };

        $args->{multiblog_action_loop} = action_loop($app);
        my %actions = map { $_->{action_id} => $_->{action_name} }
            @{ $args->{multiblog_action_loop} };

        my $rebuild_triggers = $args->{rebuild_triggers};
        my @rebuilds         = map {
            my ( $action, $id, $trigger ) = split( /:/, $_ );
            if ( $id eq '_all' ) {
                {   action_name  => $actions{$action},
                    action_value => $action,
                    blog_name    => $app->translate(
                        '(All sites and child sites in this system)'),
                    blog_id       => $id,
                    trigger_name  => $triggers{$trigger},
                    trigger_value => $trigger,
                };
            }
            elsif ( $id eq '_blogs_in_website' ) {
                {   action_name  => $actions{$action},
                    action_value => $action,
                    blog_name =>
                        $app->translate('(All child sites in this site)'),
                    blog_id       => $id,
                    trigger_name  => $triggers{$trigger},
                    trigger_value => $trigger,
                };
            }
            elsif ( my $blog = MT::Blog->load( $id, { cached_ok => 1 } ) ) {
                {   action_name   => $actions{$action},
                    action_value  => $action,
                    blog_name     => $blog->name,
                    blog_id       => $id,
                    trigger_name  => $triggers{$trigger},
                    trigger_value => $trigger,
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
                my ( $action, $id, $event ) = split ':', $trigger;
                $action
                    = $action eq 'ri'
                    ? MT::RebuildTrigger::ACTION_RI()
                    : MT::RebuildTrigger::ACTION_RIP();
                my $object_type
                    = $event =~ /^entry_.*/
                    ? MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE()
                    : MT::RebuildTrigger::TYPE_CONTENT();
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
                } @rebuild_triggers;

                unless ($rt) {
                    $rt = MT->model('rebuild_trigger')->new;
                    $rt->blog_id($blog_id);
                    $rt->object_type($object_type);
                    $rt->action($action);
                    $rt->event($event);
                    $rt->target($target);
                    $rt->target_blog_id($target_blog_id);
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
        if $app->multi_param('default_access_allowed');
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
