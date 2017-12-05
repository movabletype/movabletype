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

    my ($rebuild_trigger)
        = MT->model('rebuild_trigger')->load( { blog_id => $blog_id } );
    if ($rebuild_trigger) {
        my $data = MT::Util::from_json( $rebuild_trigger->data );
        for my $key (
            qw/ default_access_allowed all_triggers
            blog_content_accessible blogs_in_website_triggers
            default_mtmultiblog_action default_mtmulitblog_blogs
            rebuild_triggers /
            )
        {
            $param->{$key} = $data->{$key} if $data->{$key};
        }

        load_config( $app, $param,
            ( $blog_id ? "blog:$blog_id" : 'system' ) );
    }
    else {
        require MT::RebuildTrigger;
        MT::RebuildTrigger->apply_default_settings( $param, $blog_id );
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
    for my $key (
        qw/ default_access_allowed all_triggers
        blog_content_accessible blogs_in_website_triggers
        default_mtmultiblog_action default_mtmulitblog_blogs
        rebuild_triggers /
        )
    {
        $params{$key} = $app->multi_param($key) if $app->multi_param($key);
    }
    my $rebuild_trigger
        = MT->model('rebuild_trigger')->load( { blog_id => $blog_id } );
    unless ($rebuild_trigger) {
        $rebuild_trigger = MT->model('rebuild_trigger')->new();
        $rebuild_trigger->blog_id($blog_id);
    }
    $rebuild_trigger->data( MT::Util::to_json( \%params ) );
    $rebuild_trigger->save;

    $app->add_return_arg( 'saved' => 1 );
    $app->call_return;
}

1;
