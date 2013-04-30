# Movable Type (r) Open Source (C) 2006-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# Original Copyright (c) 2004-2006 David Raynes

package MT::Plugin::MultiBlog;

use strict;
use warnings;

use base qw( MT::Plugin );

our $VERSION = '2.3';
my $plugin;
$plugin = MT::Plugin::MultiBlog->new(
    {   id   => 'multiblog',
        name => 'MultiBlog',
        description =>
            '<MT_TRANS phrase="MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.">',
        version                => $VERSION,
        schema_version         => $VERSION,
        author_name            => 'Six Apart, Ltd.',
        author_link            => 'http://www.movabletype.org/',
        system_config_template => 'system_config.tmpl',
        doc_link =>
            'http://www.movabletype.org/documentation/appendices/tags/multiblog.html',
        blog_config_template => 'blog_config.tmpl',
        settings             => new MT::PluginSettings(
            [   [   'default_access_allowed',
                    { Default => 1, Scope => 'system' }
                ],
                [ 'rebuild_triggers', { Default => '', Scope => 'blog' } ],
                [   'blog_content_accessible',
                    { Default => '', Scope => 'blog' }
                ],
                [ 'other_triggers',            { Scope => 'blog' } ],
                [ 'blogs_in_website_triggers', { Scope => 'blog' } ],
                [ 'all_triggers',              { Scope => 'system' } ],
                [   'default_mtmultiblog_action',
                    { Default => 1, Scope => 'blog' }
                ],
                [   'default_mtmulitblog_blogs',
                    { Default => '', Scope => 'blog' }
                ],
            ]
        ),
        l10n_class => 'MultiBlog::L10N',
        registry   => {
            applications => {
                'cms' => {
                    methods => {
                        multiblog_add_trigger =>
                            '$multiblog::MT::Plugin::MultiBlog::add_trigger',
                    },
                },
            },
            tags => {
                help_url => sub {
                    MT->translate(
                        'http://www.movabletype.org/documentation/appendices/tags/%t.html'
                    );
                },
                block => {
                    Entries    => 'MultiBlog::preprocess_native_tags',
                    Categories => 'MultiBlog::preprocess_native_tags',
                    Comments   => 'MultiBlog::preprocess_native_tags',
                    Pages      => 'MultiBlog::preprocess_native_tags',
                    Folders    => 'MultiBlog::preprocess_native_tags',
                    Blogs      => 'MultiBlog::preprocess_native_tags',
                    Websites   => 'MultiBlog::preprocess_native_tags',
                    Assets     => 'MultiBlog::preprocess_native_tags',
                    Comments   => 'MultiBlog::preprocess_native_tags',
                    Pings      => 'MultiBlog::preprocess_native_tags',
                    Authors    => 'MultiBlog::preprocess_native_tags',
                    Tags       => 'MultiBlog::preprocess_native_tags',
                    MultiBlog  => 'MultiBlog::Tags::MultiBlog',
                    OtherBlog  => 'MultiBlog::Tags::MultiBlog',
                    MultiBlogLocalBlog =>
                        'MultiBlog::Tags::MultiBlogLocalBlog',
                    'MultiBlogIfLocalBlog?' =>
                        'MultiBlog::Tags::MultiBlogIfLocalBlog',
                },
                function => {
                    'Include' => 'MultiBlog::preprocess_native_tags',
                    'BlogCategoryCount' =>
                        'MultiBlog::preprocess_native_tags',
                    'BlogEntryCount' => 'MultiBlog::preprocess_native_tags',
                    'BlogPingCount'  => 'MultiBlog::preprocess_native_tags',
                    'TagSearchLink'  => 'MultiBlog::preprocess_native_tags',
                },
            },
            upgrade_functions => {
                'fix_broken_trigger_cache' => {
                    updater => {
                        type  => 'blog',
                        terms => { class => '*' },
                        label => "Updating trigger cache of MultiBlog...",
                        code  => sub {
                            my $scope = 'blog:' . $_[0]->id;
                            my $hash  = $plugin->get_config_hash($scope);
                            $plugin->update_trigger_cache( $hash, $scope );
                        },
                    },
                },
            },
        },
    }
);
MT->add_plugin($plugin);

# Register entry post-save callback for rebuild triggers
MT->add_callback( 'cms_post_save.entry', 10, $plugin,
    sub { $plugin->runner( 'post_entry_save', @_ ) } );
MT->add_callback( 'api_post_save.entry', 10, $plugin,
    sub { $plugin->runner( 'post_entry_save', @_ ) } );
MT->add_callback( 'cms_post_bulk_save.entries', 10, $plugin,
    sub { $plugin->runner( 'post_entries_bulk_save', @_ ) } );
MT->add_callback( 'scheduled_post_published', 10, $plugin,
    sub { $plugin->runner( 'post_entry_pub', @_ ) } );

# Register page post-save callback for rebuild triggers
MT->add_callback( 'cms_post_save.page', 10, $plugin,
    sub { $plugin->runner( 'post_entry_save', @_ ) } );
MT->add_callback( 'api_post_save.page', 10, $plugin,
    sub { $plugin->runner( 'post_entry_save', @_ ) } );
MT->add_callback( 'cms_post_bulk_save.pages', 10, $plugin,
    sub { $plugin->runner( 'post_entries_bulk_save', @_ ) } );

# Register Comment/TB post-save callbacks for rebuild triggers
MT->add_callback( 'MT::Comment::post_save', 10, $plugin,
    sub { $plugin->runner( 'post_feedback_save', 'comment_pub', @_ ) } );
MT->add_callback( 'MT::TBPing::post_save', 10, $plugin,
    sub { $plugin->runner( 'post_feedback_save', 'tb_pub', @_ ) } );

# Register restore callback to restore blog assciation of triggers
MT->add_callback( 'restore', 10, $plugin,
    sub { $plugin->runner( 'post_restore', @_ ) } );

sub instance {$plugin}

sub add_trigger {
    my $app = shift;

    return $plugin->translate("Permission denied.")
        unless $app->user->is_superuser()
            || (   $app->blog
                && $app->user->permissions( $app->blog->id )
                ->can_administer_blog() );

    my $blog_id = $app->blog->id;

    my $dialog_tmpl = $plugin->load_tmpl('dialog_create_trigger.tmpl');
    my $tmpl        = $app->listing(
        {   template => $dialog_tmpl,
            type     => 'blog',
            code     => sub {
                my ( $obj, $row ) = @_;
                if ($obj) {
                    $row->{label} = $obj->name;
                    $row->{link}  = $obj->site_url;
                }
            },
            terms => { id  => [$blog_id], },
            args  => { not => { id => 1 }, },
            params => {
                panel_type    => 'blog',
                dialog_title  => $plugin->translate('MultiBlog'),
                panel_title   => $plugin->translate('Create Trigger'),
                panel_label   => $plugin->translate("Website/Blog"),
                search_prompt => $plugin->translate("Search Weblogs") . ':',
                panel_description      => $plugin->translate("Description"),
                panel_multi            => 0,
                panel_first            => 1,
                panel_last             => 1,
                panel_searchable       => 1,
                multiblog_trigger_loop => trigger_loop(),
                multiblog_action_loop  => action_loop(),
                list_noncron           => 1,
                trigger_caption        => $plugin->translate('When this'),
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
                                label => $plugin->translate(
                                    '(All blogs in this website)'),
                                description => $plugin->translate(
                                    'Select to apply this trigger to all blogs in this website.'
                                ),
                                };
                        }
                        $count++;
                        unshift @$loop,
                            {
                            id    => '_all',
                            label => $plugin->translate(
                                '(All websites and blogs in this system)'),
                            description => $plugin->translate(
                                'Select to apply this trigger to all websites and blogs in this system.'
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
    [   {   trigger_key  => 'entry_save',
            trigger_name => $plugin->translate('saves an entry/page'),
        },
        {   trigger_key  => 'entry_pub',
            trigger_name => $plugin->translate('publishes an entry/page'),
        },
        {   trigger_key  => 'comment_pub',
            trigger_name => $plugin->translate('publishes a comment'),
        },
        {   trigger_key  => 'tb_pub',
            trigger_name => $plugin->translate('publishes a TrackBack'),
        },
    ];
}

sub action_loop {
    [   {   action_id   => 'ri',
            action_name => $plugin->translate('rebuild indexes.'),
        },
        {   action_id => 'rip',
            action_name =>
                $plugin->translate('rebuild indexes and send pings.'),
        },
    ];
}

sub load_config {
    my $plugin = shift;
    my ( $args, $scope ) = @_;

    $plugin->SUPER::load_config(@_);

    if ( $scope =~ /blog:(\d+)/ ) {
        my $blog_id = $1;

        require MT::Blog;

        $args->{multiblog_trigger_loop} = trigger_loop();
        my %triggers = map { $_->{trigger_key} => $_->{trigger_name} }
            @{ $args->{multiblog_trigger_loop} };

        $args->{multiblog_action_loop} = action_loop();
        my %actions = map { $_->{action_id} => $_->{action_name} }
            @{ $args->{multiblog_action_loop} };

        my $rebuild_triggers = $args->{rebuild_triggers};
        my @rebuilds         = map {
            my ( $action, $id, $trigger ) = split( /:/, $_ );
            if ( $id eq '_all' ) {
                {   action_name  => $actions{$action},
                    action_value => $action,
                    blog_name    => $plugin->translate(
                        '(All websites and blogs in this system)'),
                    blog_id       => $id,
                    trigger_name  => $triggers{$trigger},
                    trigger_value => $trigger,
                };
            }
            elsif ( $id eq '_blogs_in_website' ) {
                {   action_name  => $actions{$action},
                    action_value => $action,
                    blog_name =>
                        $plugin->translate('(All blogs in this website)'),
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
    my $app = MT->instance;
    if ( $app->isa('MT::App') ) {
        $args->{blog_id} = $app->blog->id if $app->blog;
    }
}

sub update_trigger_cache {
    my $plugin = shift;
    my ( $args, $scope ) = @_;

    my ($blog_id);
    if ( $scope =~ /blog:(\d+)/ ) {
        $blog_id = $1;

        # Save blog-level content aggregation policy to single
        # system config hash for easy lookup
        my ( $cfg_old, $cfg_new ) = 0;
        my $override
            = $plugin->get_config_value( 'access_overrides', "system" ) || {};
        $cfg_new = $args->{blog_content_accessible};
        if ( exists $override->{$blog_id} ) {
            $cfg_old = $override->{$blog_id};
        }
        if ( $cfg_old != $cfg_new ) {
            $override->{$blog_id} = $cfg_new
                or delete $override->{$blog_id};
            $plugin->set_config_value( 'access_overrides', $override,
                'system' );
        }

        # Fiddle with rebuild triggers...
        my $rebuild_triggers = $args->{rebuild_triggers};
        my $old_triggers     = $args->{old_rebuild_triggers};

        # Check to see if the triggers changed
        if ( $old_triggers ne $rebuild_triggers ) {

# If so, remove all references to the current blog from the triggers cached in other blogs
            foreach ( split( /\|/, $old_triggers ) ) {
                my ( $action, $id, $trigger ) = split( /:/, $_ );
                my $name
                    = $id eq '_all'              ? "all_triggers"
                    : $id eq '_blogs_in_website' ? 'blogs_in_website_triggers'
                    :                              "other_triggers";
                my $scope;
                if ( $id eq '_all' ) {
                    $scope = "system";
                }
                elsif ( $id eq '_blogs_in_website' ) {
                    my $app        = MT::instance;
                    my $website_id = $app->param('blog_id');
                    next unless $website_id;
                    if ( my $website
                        = $app->model('website')->load($website_id) )
                    {
                        $scope = "blog:" . $website->id;
                    }
                }
                else {
                    $scope = "blog:$id";
                }
                my $d = $plugin->get_config_value( $name, $scope );
                next unless exists $d->{$trigger}{$blog_id};
                delete $d->{$trigger}{$blog_id};
                $plugin->set_config_value( $name, $d, $scope );
            }
        }
        foreach ( split( /\|/, $rebuild_triggers ) ) {
            my ( $action, $id, $trigger ) = split( /:/, $_ );
            my $name
                = $id eq '_all'              ? "all_triggers"
                : $id eq '_blogs_in_website' ? 'blogs_in_website_triggers'
                :                              "other_triggers";
            my $scope;
            if ( $id eq '_all' ) {
                $scope = "system";
            }
            elsif ( $id eq '_blogs_in_website' ) {
                my $app        = MT::instance;
                my $website_id = $app->param('blog_id');
                next unless $website_id;
                if ( my $website = $app->model('website')->load($website_id) )
                {
                    $scope = "blog:" . $website->id;
                }
            }
            else {
                $scope = "blog:$id";
            }

            my $d = $plugin->get_config_value( $name, $scope ) || {};
            $d->{$trigger}{$blog_id}{$action} = 1;
            $plugin->set_config_value( $name, $d, $scope );
        }
    }
}

sub save_config {
    my $plugin = shift;
    my ( $args, $scope ) = @_;

    my $saved_hash = $plugin->get_config_hash($scope);

    $plugin->SUPER::save_config(@_);

    for my $k (qw(all_triggers blogs_in_website_triggers other_triggers)) {
        $plugin->set_config_value( $k, $saved_hash->{$k}, $scope )
            if exists $saved_hash->{$k};
    }

    $plugin->update_trigger_cache( $args, $scope );
}

sub reset_config {
    my $plugin = shift;
    my ($scope) = @_;

    if ( $scope =~ /blog:(\d+)/ ) {
        my $blog_id = $1;

        # Get the blogs this one triggers from and update them
        # And then save the triggers this blog runs
        my $other_triggers
            = $plugin->get_config_value( 'other_triggers', $scope );
        my $rebuild_triggers
            = $plugin->get_config_value( 'rebuild_triggers', $scope );
        my $all_triggers
            = $plugin->get_config_value( 'all_triggers', 'system' );

        foreach ( split( /\|/, $rebuild_triggers ) ) {
            my ( $action, $id, $trigger ) = split( /:/, $_ );
            next if $id eq '_all';
            my $d = $plugin->get_config_value( 'other_triggers', "blog:$id" );
            delete $d->{$trigger}{$blog_id}
                if exists $d->{$trigger}{$blog_id};
            $plugin->set_config_value( 'other_triggers', $d, "blog:$id" );
        }

        # remove this blog from the 'all_triggers'
        if ($all_triggers) {
            my $changed = 0;
            foreach my $trigger ( keys %$all_triggers ) {
                if ( exists $all_triggers->{$trigger}{$blog_id} ) {
                    delete $all_triggers->{$trigger}{$blog_id};
                    $changed = 1;
                }
            }
            if ($changed) {
                $plugin->set_config_value( 'all_triggers', $all_triggers,
                    'system' );
            }
        }
        $plugin->SUPER::reset_config(@_);
        $plugin->set_config_value( 'other_triggers', $other_triggers,
            "blog:$blog_id" )
            if ref($other_triggers) eq 'HASH';
    }
    else {

        # reset should not alter the 'all_triggers' element which is
        # configured through the blog-level settings
        my $all_triggers = $plugin->get_config_value('all_triggers');
        $plugin->SUPER::reset_config(@_);
        $plugin->set_config_value( 'all_triggers', $all_triggers, 'system' );
    }
}

# Run-time loading for MultiBlog core methods
sub runner {
    my $plugin = shift;
    my $method = shift;
    require MultiBlog;
    MultiBlog::init_rebuilt_cache( MT->instance );
    no strict 'refs';
    return $_->( $plugin, @_ ) if $_ = \&{"MultiBlog::$method"};
    die "Failed to find MultiBlog::$method";
}

1;
