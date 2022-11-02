# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Search.pm 4464 2009-09-29 12:06:58Z fumiakiy $
package MT::CMS::Search;

use strict;
use warnings;
use MT::Util qw( is_valid_date encode_html first_n_words );

sub core_search_apis {
    my $app = shift;

    # use a different variable name not to be bound in closures by chance.
    # this user is used to determine if site-related values can be replaced or not.
    my $user_not_to_be_bound = $app->user;

    my $types = {
        content_data => {
            order     => 50,
            condition => sub {
                my $blog_id = MT->app->param('blog_id');
                return 0
                    unless $app->model('content_type')->exist(
                    {   (     ($blog_id)
                            ? ( blog_id => $blog_id )
                            : ( blog_id => \'> 0' )
                        )
                    }
                    );

                my $author = MT->app->user;
                return 1 if $author->is_superuser;

                my $cnt = MT->model('permission')->count(
                    [   [   {   (     ($blog_id)
                                    ? ( blog_id => $blog_id )
                                    : ( blog_id => \'> 0' )
                                ),
                                author_id => $author->id,
                            },
                            '-and',
                            [   {   permissions => {
                                        like => "\%'manage_content_data'\%"
                                    },
                                },
                                '-or',
                                {   permissions => {
                                        like => "\%'manage_content_data:\%'\%"
                                    },
                                },
                                '-or',
                                {   permissions => {
                                        like => "\%'create_content_data:\%'\%"
                                    },
                                },
                                '-or',
                                {   permissions => {
                                        like =>
                                            "\%'edit_all_content_data:\%'\%"
                                    },
                                },
                                '-or',
                                {   permissions => {
                                        like =>
                                            "\%'publish_content_data:\%'\%"
                                    },
                                },
                            ],
                        ],
                        '-or',
                        {   author_id => $author->id,
                            permissions =>
                                { like => "\%'manage_content_data'\%" },
                            blog_id => 0,
                        },
                    ]
                );

                return ( $cnt && $cnt > 0 ) ? 1 : 0;
            },
            handler =>
                '$Core::MT::CMS::ContentData::build_content_data_table',
            label      => 'Content Data',
            perm_check => sub {
                my ($content_data) = @_;
                my $author = $app->user;
                my $blog_perms
                    = $author->permissions( $content_data->blog_id );
                $blog_perms
                    && $blog_perms->can_edit_content_data( $content_data,
                    $author );
            },
            search_cols => {
                identifier => sub { MT->translate('Basename') },
                label      => sub { MT->translate('Data Label') },
            },
            replace_cols       => [],
            can_replace        => 1,
            can_search_by_date => 1,
            date_column        => 'authored_on',
            setup_terms_args   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                if ( $app->param('filter') && $app->param('filter_val') ) {
                    $terms->{ $app->param('filter') }
                        = $app->param('filter_val');
                }
                my $content_type_id = $app->param('content_type_id') || 0;
                my $content_type
                    = $app->model('content_type')
                    ->load( { id => $content_type_id } )
                    || $app->model('content_type')->load(
                    { blog_id => $blog_id || \'> 0' },
                    { sort => 'name', limit => 0 }
                    );
                if ($content_type) {
                    $terms->{content_type_id} = $content_type->id;
                    $app->param( 'content_type_id', $content_type->id );
                }
                $args->{sort}      = 'authored_on';
                $args->{direction} = 'descend';
            },
        },
        'entry' => {
            'order'     => 100,
            'condition' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;

                my $blog_id = MT->app->param('blog_id');
                my $cnt = MT->model('permission')->count(
                    [   {   (     ($blog_id)
                                ? ( blog_id => $blog_id )
                                : ( blog_id => \'> 0' )
                            ),
                            author_id => $author->id,
                        },
                        '-and',
                        [   {   permissions => { like => "\%'create_post'\%" }
                            },
                            '-or',
                            {   permissions =>
                                    { like => "\%'publish_post'\%" }
                            },
                            '-or',
                            {   permissions =>
                                    { like => "\%'edit_all_posts'\%" }
                            },
                        ],
                    ]
                );

                return ( $cnt && $cnt > 0 ) ? 1 : 0;
            },
            'handler'    => '$Core::MT::CMS::Entry::build_entry_table',
            'label'      => 'Entries',
            'perm_check' => sub {
                my ($entry) = @_;
                my $author = $app->user;
                $author->permissions( $entry->blog_id )
                    ->can_edit_entry( $entry, $author );
            },
            'search_cols' => {
                'title'     => sub { $app->translate('Title') },
                'text'      => sub { $app->translate('Entry Body') },
                'text_more' => sub { $app->translate('Extended Entry') },
                'keywords'  => sub { $app->translate('Keywords') },
                'excerpt'   => sub { $app->translate('Excerpt') },
                'basename'  => sub { $app->translate('Basename') },
            },
            'replace_cols' => [qw(title text text_more keywords excerpt)],
            'can_replace'  => 1,
            'can_search_by_date' => 1,
            'date_column'        => 'authored_on',
            'setup_terms_args'   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                if ( $app->param('filter') && $app->param('filter_val') ) {
                    $terms->{ $app->param('filter') }
                        = $app->param('filter_val');
                }
                $args->{sort}      = 'authored_on';
                $args->{direction} = 'descend';
            }
        },
        'page' => {
            'order'     => 400,
            'condition' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;

                my $blog_id = MT->app->param('blog_id');
                my $cnt = MT->model('permission')->count(
                    {   (     ($blog_id)
                            ? ( blog_id => $blog_id )
                            : ( blog_id => \'> 0' )
                        ),
                        author_id   => $author->id,
                        permissions => { like => "\%'manage_pages'\%" },
                    },
                );

                return ( $cnt && $cnt > 0 ) ? 1 : 0;
            },
            'label'      => 'Pages',
            'handler'    => '$Core::MT::CMS::Entry::build_entry_table',
            'perm_check' => sub {
                my ($page) = @_;
                my $author = MT->app->user;
                return $author->permissions( $page->blog_id )
                    ->can_manage_pages( $page, $author );
            },
            'search_cols' => {
                'title'     => sub { $app->translate('Title') },
                'text'      => sub { $app->translate('Page Body') },
                'text_more' => sub { $app->translate('Extended Page') },
                'keywords'  => sub { $app->translate('Keywords') },
                'excerpt'   => sub { $app->translate('Excerpt') },
                'basename'  => sub { $app->translate('Basename') },
            },
            'replace_cols' => [qw(title text text_more keywords excerpt)],
            'can_replace'  => 1,
            'can_search_by_date' => 1,
            'date_column'        => 'authored_on',
            'results_table_template' =>
                '<mt:include name="include/entry_table.tmpl">',
            'setup_terms_args' => sub {
                my ( $terms, $args, $blog_id ) = @_;
                if ( $app->param('filter') && $app->param('filter_val') ) {
                    $terms->{ $app->param('filter') }
                        = $app->param('filter_val');
                }
                $args->{sort}      = 'modified_on';
                $args->{direction} = 'descend';
            }
        },
        'template' => {
            'order'     => 500,
            'condition' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;

                my $blog_id = MT->app->param('blog_id');
                my $cnt = MT->model('permission')->count(
                    [   {   (     ($blog_id)
                                ? ( blog_id => $blog_id )
                                : ( blog_id => \'> 0' )
                            ),
                            author_id   => $author->id,
                            permissions => { like => "\%'edit_templates'\%" },
                        },
                        '-or',
                        {   author_id   => $author->id,
                            permissions => { like => "\%'edit_templates'\%" },
                            blog_id     => 0,
                        },
                    ]
                );

                return ( $cnt && $cnt > 0 ) ? 1 : 0;
            },
            'handler'    => '$Core::MT::CMS::Template::build_template_table',
            'label'      => 'Templates',
            'perm_check' => sub {
                my ($obj) = @_;
                my $author = MT->app->user;
                return 1
                    if $author->permissions(0)->can_do('search_templates');

                # are there any perms that match this object and
                # allow template editing?
                return 0
                    unless $obj->blog_id;
                return 1
                    if $author->permissions( $obj->blog_id )
                    ->can_do('search_templates');

                return 0;
            },
            'search_cols' => {
                'name'        => sub { $app->translate('Template Name') },
                'text'        => sub { $app->translate('Text') },
                'linked_file' => sub { $app->translate('Linked Filename') },
                'outfile'     => sub { $app->translate('Output Filename') },
            },
            'replace_cols'       => [qw(name text linked_file outfile)],
            'can_replace'        => 1,
            'can_search_by_date' => 0,
            'setup_terms_args'   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                $args->{sort}      = 'created_on';
                $args->{direction} = 'ascend';
            }
        },
        'asset' => {
            'order'     => 600,
            'condition' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;

                my $blog_id = MT->app->param('blog_id');
                my $cnt = MT->model('permission')->count(
                    {   (     ($blog_id)
                            ? ( blog_id => $blog_id )
                            : ( blog_id => \'> 0' )
                        ),
                        author_id   => $author->id,
                        permissions => { like => "\%'edit_assets'\%" },
                    }
                );

                return ( $cnt && $cnt > 0 ) ? 1 : 0;
            },
            'label'      => 'Assets',
            'handler'    => '$Core::MT::CMS::Asset::build_asset_table',
            'perm_check' => sub {
                my ($obj)  = @_;
                my $app    = MT->instance;
                my $author = $app->user;
                my $perm   = $author->permissions( $obj->blog_id );
                return 1 if $perm && $perm->can_do('search_assets');
                return 0;
            },
            'search_cols' => {
                'file_name'   => sub { $app->translate('Filename') },
                'description' => sub { $app->translate('Description') },
                'label'       => sub { $app->translate('Label') },
            },
            'replace_cols'       => [],
            'can_replace'        => 0,
            'can_search_by_date' => 1,
            'setup_terms_args'   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                $terms->{class}
                    = (    $app->param('filter')
                        && $app->param('filter_val')
                        && $app->param('filter') eq 'class'
                        && $app->param('filter_val') eq 'image' )
                    ? 'image'
                    : '*';
                if ( !$blog_id ) {
                    $terms->{blog_id} = { op => '>', value => '0' };
                }
                $args->{sort}      = 'created_on';
                $args->{direction} = 'descend';
            }
        },
        'log' => {
            'order'     => 700,
            'condition' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;

                my $blog_id = MT->app->param('blog_id');
                my $terms;
                push @$terms, { author_id => $author->id };
                if ($blog_id) {
                    push @$terms,
                        [
                        '-and',
                        {   blog_id     => $blog_id,
                            permissions => { like => "\%'view_blog_log'\%" },
                        }
                        ];
                }
                else {
                    push @$terms,
                        [
                        '-and',
                        [   {   blog_id     => 0,
                                permissions => { like => "\%'view_log'\%" },
                            },
                            '-or',
                            {   blog_id => \' > 0',
                                permissions =>
                                    { like => "\%'view_blog_log'\%" },
                            }
                        ]
                        ];
                }

                my $cnt = MT->model('permission')->count($terms);
                return ( $cnt && $cnt > 0 ) ? 1 : 0;
            },
            'handler'    => '$Core::MT::CMS::Log::build_log_table',
            'label'      => 'Activity Log',
            'perm_check' => sub {
                my ($obj) = @_;
                my $author = MT->app->user;
                return 1 if $author->can_do('search_log');
                my $perm = $author->permissions( $obj->blog_id );
                return $perm->can_do('search_blog_log');
            },
            'search_cols' => {
                'ip'      => sub { $app->translate('IP Address') },
                'message' => sub { $app->translate('Log Message') },
            },
            'can_replace'        => 0,
            'can_search_by_date' => 1,
            'setup_terms_args'   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                $terms->{class}    = '*';
                $args->{sort}      = 'created_on';
                $args->{direction} = 'descend';
            }
        },
        'author' => {
            'order'     => 800,
            'condition' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;
                return 1 if $author->can_manage_users_groups;

                my $blog_id = MT->app->param('blog_id');
                return 0 if !$blog_id;

                my $cnt = MT->model('permission')->count(
                    {   blog_id     => $blog_id,
                        author_id   => $author->id,
                        permissions => { like => "\%'manage_users'\%" },
                    },
                );

                return ( $cnt && $cnt > 0 ) ? 1 : 0;
            },
            'label'      => 'Users',
            'handler'    => '$Core::MT::CMS::User::build_author_table',
            'perm_check' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;
                return 1 if $author->can_manage_users_groups;

                my $blog_id = MT->app->param('blog_id');
                return 0 if !$blog_id;

                my $perm = $author->permissions($blog_id);
                return $perm->can_do('search_authors');
            },
            'search_cols' => {
                'name'     => sub { $app->translate('Username') },
                'nickname' => sub { $app->translate('Display Name') },
                'email'    => sub { $app->translate('Email Address') },
                'url'      => sub { $app->translate('URL') },
            },
            'can_replace'        => 0,
            'can_search_by_date' => 0,
            'setup_terms_args'   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                if ($blog_id) {
                    $args->{'join'} = MT::Permission->join_on( 'author_id',
                        { blog_id => $blog_id } );
                    delete $terms->{blog_id} if exists $terms->{blog_id};
                }
                else {
                    $terms->{'type'} = MT::Author::AUTHOR();
                }
                $args->{sort}      = 'created_on';
                $args->{direction} = 'ascend';
            },
            'results_table_template' => '
<mt:if name="blog_id">
    <mt:include name="include/member_table.tmpl">
<mt:else>
    <mt:include name="include/author_table.tmpl">
</mt:if>',
        },
        'blog' => {
            'order'     => 900,
            'label'     => 'Child Sites',
            'condition' => sub {
                my $author = MT->app->user;
                my $blog   = MT->app->blog;
                return 0 if $blog && $blog->is_blog;
                return 1 if $author->is_superuser;
                return 1 if $author->permissions(0)->can_do('administer');
                return 1 if $author->permissions(0)->can_do('edit_templates');
                return 0;
            },
            'handler'    => '$Core::MT::CMS::Blog::build_blog_table',
            'perm_check' => sub {
                my $author = MT->app->user;
                return 1
                    if $author->is_superuser
                    || $author->permissions(0)->can_do('edit_templates');
                my ($obj) = @_;
                my $perm = $author->permissions( $obj->id );
                return $perm && ( $perm->blog_id == $obj->id ) ? 1 : 0;
            },
            'search_cols' => {
                'name'        => sub { $app->translate('Name') },
                'site_url'    => sub { $app->translate('Site URL') },
                'site_path'   => sub { $app->translate('Site Root') },
                'description' => sub { $app->translate('Description') },
            },
            'replace_cols'       => [qw(name site_url site_path description)],
            'can_replace'        => $user_not_to_be_bound->is_superuser(),
            'can_search_by_date' => 0,
            'setup_terms_args'   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                $terms->{parent_id} = $blog_id if $blog_id;
                $args->{sort}       = 'name';
                $args->{direction}  = 'ascend';
            }
        },
        'website' => {
            'order'     => 1000,
            'condition' => sub {
                my $author = MT->app->user;
                my $blog_id = MT->app->param('blog_id');
                return 0 if $blog_id;
                return 1 if $author->is_superuser;
                return 1 if $author->permissions(0)->can_do('administer');
                return 1 if $author->permissions(0)->can_do('edit_templates');
                return 0;
            },
            'label'      => 'Sites',
            'handler'    => '$Core::MT::CMS::Website::build_website_table',
            'perm_check' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;
                return 1 if $author->permissions(0)->can_do('edit_templates');
                my ($obj) = @_;
                my $perm = $author->permissions( $obj->id );
                return $perm && ( $perm->blog_id == $obj->id ) ? 1 : 0;
            },
            'search_cols' => {
                'name'        => sub { $app->translate('Name') },
                'site_url'    => sub { $app->translate('Site URL') },
                'site_path'   => sub { $app->translate('Site Root') },
                'description' => sub { $app->translate('Description') },
            },
            'replace_cols'       => [qw(name site_url site_path description)],
            'can_replace'        => $user_not_to_be_bound->is_superuser(),
            'can_search_by_date' => 0,
            'view'               => 'system',
            'setup_terms_args'   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                $args->{sort}      = 'name';
                $args->{direction} = 'ascend';
            }
        },
        'content_type' => {
            'order'     => 1100,
            'condition' => sub {
                return 0;    # This line would be removed in MTC-26406.
                my $author = MT->app->user;
                return 1 if $author->is_superuser;
            },
            'handler' =>
                '$Core::MT::CMS::ContentType::build_content_type_table',
            'label'       => 'Content Types',
            'search_cols' => { 'name' => sub { $app->translate('Name') }, },
            'setup_terms_args' => sub {
                my ( $terms, $args, $blog_id ) = @_;
                $terms->{blog_id}  = $blog_id if $blog_id;
                $args->{sort}      = 'name';
                $args->{direction} = 'ascend';
            }
        },
        'site' => {
            'order'     => 1000,
            'condition' => sub {
                my $author = MT->app->user;
                my $blog_id = MT->app->param('blog_id');
                return 0 if $blog_id;
                return 1 if $author->is_superuser;
                return 1 if $author->permissions(0)->can_do('administer');
                return 1 if $author->permissions(0)->can_do('edit_templates');
                return 0;
            },
            'label'      => 'Sites',
            'handler'    => '$Core::MT::CMS::Website::build_website_table',
            'perm_check' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;
                return 1 if $author->permissions(0)->can_do('edit_templates');
                my ($obj) = @_;
                my $perm = $author->permissions( $obj->id );
                return $perm && ( $perm->blog_id == $obj->id ) ? 1 : 0;
            },
            'search_cols' => {
                'name'        => sub { $app->translate('Name') },
                'site_url'    => sub { $app->translate('Site URL') },
                'site_path'   => sub { $app->translate('Site Root') },
                'description' => sub { $app->translate('Description') },
            },
            'replace_cols'       => [],
            'can_replace'        => 0,
            'can_search_by_date' => 0,
            'view'               => 'none',
            'setup_terms_args'   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                $terms->{class}    = [ 'website', 'blog' ];
                $args->{sort}      = 'name';
                $args->{direction} = 'ascend';
            }
        },
        'group' => {
            'order'             => 850,
            'system_permission' => 'administer,manage_users_groups',
            'label'             => 'Groups',
            'perm_check'        => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;
                return 1 if $author->can_manage_users_groups;
                my $blog_id = MT->app->param('blog_id');
                if ($blog_id) {
                    my $perm = $author->permissions($blog_id);
                    return $perm->can_administer_site;
                }
                return 0;
            },
            'search_cols' => {
                'name'         => sub { $app->translate('Group Name') },
                'display_name' => sub { $app->translate('Display Name') },
                'description'  => sub { $app->translate('Description') },
            },
            'replace_cols'       => [],
            'can_replace'        => 0,
            'can_search_by_date' => 0,
            'setup_terms_args'   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                if ($blog_id) {
                    $args->{'join'} = MT->model('association')
                        ->join_on( 'group_id', { blog_id => $blog_id } );
                }
            },
            'handler' => '$Core::MT::CMS::Group::build_group_table',
            'results_table_template' =>
                '<mt:include name="include/group_table.tmpl">',
            'view' => 'system',
        },

    };
    return $types;
}

sub can_search_replace {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');

    return 1 if $app->user->is_superuser;
    return 1 if $app->user->permissions(0)->can_do('edit_templates');
    return 1 if $app->user->permissions(0)->can_do('view_log');
    return 1 if $app->user->permissions(0)->can_do('manage_users_groups');
    if ($blog_id) {
        my $perms = $app->user->permissions($blog_id);
        return 0 unless $perms;
        return 0 unless $perms->permissions;
        return 0 unless $perms->can_do('use_tools:search');
        return 1;
    }
    else {
        my $blog = $app->blog;
        my $blog_ids
            = !$blog         ? undef
            : $blog->is_blog ? [ $blog->id ]
            :   [ $blog->id, map { $_->id } @{ $blog->blogs } ];

        require MT::Permission;
        my $iter = MT::Permission->load_iter(
            {   author_id => $app->user->id,
                (   $blog_ids
                    ? ( blog_id => $blog_ids )
                    : ( blog_id => { not => 0 } )
                ),
            }
        );

        my $cond;

        # An user who has only 'manage_users' permission can't do search.
        my $restrict_manage_users = MT::Permission->new;
        $restrict_manage_users->restrictions('manage_users');
        while ( my $p = $iter->() ) {
            $p->add_restrictions($restrict_manage_users);
            $cond = 1, last
                if $p->can_do('use_tools:search');
        }
        return $cond ? 1 : 0;
    }
    return 0;
}

sub search_replace {
    my $app     = shift;

    $app->validate_param({
        _type           => [qw/OBJTYPE/],
        blog_id         => [qw/ID/],
        content_type_id => [qw/ID/],
        entry_type      => [qw/OBJTYPE/],
    }) or return;

    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');

    return $app->permission_denied()
        unless can_search_replace($app);

    return $app->return_to_dashboard( redirect => 1 )
        if !$app->can_do('use_tools:search') && $app->param('blog_id');

    my $param = do_search_replace( $app, @_ ) or return;
    $app->add_breadcrumb( $app->translate('Search & Replace') );
    $param->{nav_search}   = 1;
    $param->{screen_class} = "search-replace";
    $param->{screen_id}    = "search-replace";
    $param->{search_tabs} = $app->search_apis( $blog_id ? 'blog' : 'system' );
    $param->{entry_type}  = $app->param('entry_type');

    if (   $app->param('_type')
        && $app->param('_type') =~ /entry|page|comment|ping|template/ )
    {
        if ( $app->param('blog_id') ) {
            my $perms = $app->permissions
                or return $app->permission_denied();
            $param->{can_republish} = $perms->can_rebuild
                || $app->user->is_superuser;
            $param->{can_empty_junk} = $perms->can_rebuild
                || $app->user->is_superuser;
            $param->{state_editable} = $perms->can_rebuild
                || $app->user->is_superuser;
            $param->{publish_from_search} = $perms->can_rebuild
                || $app->user->is_superuser;
        }
        else {
            $param->{can_republish}       = 1;
            $param->{can_empty_junk}      = 1;
            $param->{state_editable}      = 1;
            $param->{publish_from_search} = 1;
        }
    }
    elsif ( $param->{object_type} eq 'content_data' ) {
        my $selected_content_type_id = $app->param('content_type_id');
        my $selected_content_type;
        my ( @content_types, @date_time_fields, @date_fields, @time_fields );
        my $iter
            = MT->model('content_type')
            ->load_iter( { blog_id => $blog_id || \'> 0' },
            { sort => 'name' } );
        my $perms = $user->permissions($blog_id);
        while ( my $content_type = $iter->() ) {

            next
                unless (
                   $user->is_superuser
                || $user->permissions(0)->can_do('manage_content_data')
                || $perms->can_do('manage_content_data')
                || $perms->can_do(
                    'search_content_data_' . $content_type->unique_id
                )
                );

            push @content_types,
                +{
                content_type_id   => $content_type->id,
                content_type_name => $content_type->name,
                (         !$selected_content_type_id
                        || $content_type->id == $selected_content_type_id
                    )
                ? ( selected => 1 )
                : (),
                };
            $selected_content_type_id ||= $content_type->id;
            if ( $content_type->id == $selected_content_type_id ) {
                $selected_content_type = $content_type;
            }

            my $mapper = sub {
                +{  date_time_field_id       => $_->{id},
                    date_time_field_label    => $_->{options}{label},
                    date_time_field_ct_id    => $content_type->id,
                    date_time_field_selected => (
                               $param->{date_time_field_id}
                            && $_->{id} == $param->{date_time_field_id}
                    ),
                };
            };
            push @date_time_fields, map { $mapper->($_) }
                grep { $_->{type} eq 'date_and_time' }
                @{ $content_type->fields };
            push @date_fields, map { $mapper->($_) }
                grep { $_->{type} eq 'date_only' } @{ $content_type->fields };
            push @time_fields, map { $mapper->($_) }
                grep { $_->{type} eq 'time_only' } @{ $content_type->fields };
        }
        $param->{content_types}    = \@content_types;
        $param->{date_time_fields} = \@date_time_fields;
        $param->{date_fields}      = \@date_fields;
        $param->{time_fields}      = \@time_fields;

        if ( $selected_content_type && $param->{date_time_field_id} ) {
            my $field_data = $selected_content_type->get_field(
                $param->{date_time_field_id} );
            if ( $field_data->{type} eq 'time_only' ) {
                $param->{show_datetime_fields_type} = 'time';
            }
            else {
                $param->{show_datetime_fields_type} = 'date';
            }
        }
        else {
            $param->{show_datetime_fields_type} = 'date';
        }

        my $blog_perms = $user->permissions($blog_id);
        if ( $user->is_superuser ) {
            $param->{can_republish} = 1;
        }
        elsif ( $selected_content_type && $blog_perms ) {
            my $unique_id = $selected_content_type->unique_id;
            $param->{can_republish}
                = $blog_perms->can_do(
                "publish_content_data_via_list_$unique_id")
                || $blog_perms->can_do("publish_all_content_data_$unique_id")
                ? 1
                : 0;
        }
    }

    my $tmpl = $app->load_tmpl( 'search_replace.tmpl', $param );
    my $placeholder = $tmpl->getElementById('search_results');
    $placeholder->innerHTML( delete $param->{results_template} );
    return $tmpl;
}

sub do_search_replace {
    my $app     = shift;
    my ($param) = @_;
    my $blog_id = $app->param('blog_id');
    my $author  = $app->user;

    my ($search,       $replace,            $do_replace,
        $case,         $is_regex,           $is_limited,
        $type,         $is_junk,            $is_dateranged,
        $ids,          $datefrom_year,      $datefrom_month,
        $datefrom_day, $dateto_year,        $dateto_month,
        $dateto_day,   $date_time_field_id, $from,
        $to,           $timefrom,           $timeto,
        $show_all,     $do_search,          $orig_search,
        $quicksearch,  $publish_status,     $my_posts,
        $search_type,  $filter,             $filter_val
        )
        = map scalar $app->param($_),
        qw( search replace do_replace case is_regex is_limited _type is_junk is_dateranged replace_ids datefrom_year datefrom_month datefrom_day dateto_year dateto_month dateto_day date_time_field_id from to timefrom timeto show_all do_search orig_search quicksearch publish_status my_posts search_type filter filter_val );

    # trim 'search' parameter
    $search = '' unless defined($search);
    $search =~ s/(^\s+|\s+$)//g;
    $app->param( 'search', $search );

    $type = $search_type if $search_type;
    if ( !$type ) {
        if ( my $api = $app->search_apis( $blog_id ? 'blog' : 'system' ) ) {
            $type = $api->[0]->{key};
        }
    }
    if ( !$type || ( 'category' eq $type ) || ( 'folder' eq $type ) ) {
        $type = 'entry';
    }
    if ( ( 'user' eq $type ) ) {
        $type = 'author';
    }
    foreach my $obj_type (qw( role association )) {
        if ( $type eq $obj_type ) {
            $type = 'author';
        }
    }

    $replace && ( $app->validate_magic() or return );
    $search = $orig_search if $do_replace;    # for safety's sake
    my $list_pref = $app->list_pref($type);
    my $search_api = $app->registry("search_apis")->{$type};

    $app->assert( $search_api, "Invalid request." ) or return;

    # force action bars to top and bottom
    $list_pref->{"bar"}                     = 'both';
    $list_pref->{"position_actions_both"}   = 1;
    $list_pref->{"position_actions_top"}    = 1;
    $list_pref->{"position_actions_bottom"} = 1;
    $list_pref->{"view"}                    = 'compact';
    $list_pref->{"view_compact"}            = 1;
    my ( @cols, $datefrom, $dateto, $date_col );
    $do_replace    = 0 unless $search_api->{can_replace};
    $is_dateranged = 0 unless $search_api->{can_search_by_date};
    my @ids;

    if ($ids) {
        @ids = split /,/, $ids;
    }
    my ( $content_type, @content_types );
    if ( $type eq 'content_data' ) {
        my $content_type_id = $app->param('content_type_id') || 0;
        $content_type
            = $app->model('content_type')->load( { id => $content_type_id } )
            || $app->model('content_type')->load(
            { blog_id => $blog_id || \'> 0' },
            { sort => 'name', limit => 1 },
            );

        my $iter = $app->model('content_type')
            ->load_iter( { blog_id => $blog_id || \'> 0' } );
        while ( my $ct = $iter->() ) {
            push @content_types, $ct;
        }
    }
    if ($is_limited) {
        @cols = $app->multi_param('search_cols');
        my %search_api_cols
            = map { $_ => 1 } keys %{ $search_api->{search_cols} };
        if ( $type eq 'content_data' ) {
            %search_api_cols = (
                %search_api_cols,
                map { '__field:' . $_->{id} => 1 }
                    map { @{ $_->searchable_fields } } @content_types,
            );
        }
        if ( @cols && ( $cols[0] =~ /,/ ) ) {
            @cols = split /,/, $cols[0];
        }
        @cols = grep { $search_api_cols{$_} } @cols;
        $is_limited = 0 unless scalar @cols;
    }
    if ( !$is_limited ) {
        @cols = grep { $_ ne 'plugin' }
            keys %{ $search_api->{search_cols} };
        if ( $type eq 'content_data' ) {
            push @cols, map { '__field:' . $_->{id} }
                map { @{ $_->searchable_fields } } @content_types;
        }
    }
    my $quicksearch_id;
    if (   $quicksearch
        && defined $search
        && $search ne ''
        && $search !~ m{ \D }xms )
    {
        $quicksearch_id = $search;
        unshift @cols, 'id';
    }
    foreach (
        $datefrom_year, $datefrom_month, $datefrom_day,
        $dateto_year,   $dateto_month,   $dateto_day
        )
    {
        s!\D!!g if $_;
    }
    if ( $is_dateranged && $datefrom_year ) {
        $datefrom = sprintf( "%04d%02d%02d",
            $datefrom_year, $datefrom_month, $datefrom_day );
        $dateto = sprintf( "%04d%02d%02d",
            $dateto_year, $dateto_month, $dateto_day );
        if ( ( $datefrom eq '00000000' ) && ( $dateto eq '00000000' ) ) {
            $is_dateranged = 0;
        }
        else {
            if (   !is_valid_date( $datefrom . '000000' )
                || !is_valid_date( $dateto . '000000' ) )
            {
                return $app->error(
                    $app->translate(
                        "Invalid date(s) specified for date range.")
                );
            }
        }
    }
    elsif ($is_dateranged) {
        if ( $from && $to ) {
            s!\D!!g foreach ( $from, $to );
            $datefrom = substr( $from, 0, 8 );
            $dateto   = substr( $to,   0, 8 );
        }
        if ( $timefrom && $timeto ) {
            s!\D!!g foreach ( $timefrom, $timeto );
            $timefrom = substr $timefrom, 0, 6;
            $timeto   = substr $timeto,   0, 6;
            $timefrom = "0$timefrom" if length $timefrom == 5;
            $timeto   = "0$timeto"   if length $timeto == 5;
        }
    }
    my $tab = $app->param('tab') || 'entry';
    ## Sometimes we need to pass in the search columns like 'title,text', so
    ## we look for a comma (not a valid character in a column name) and split
    ## on it if it's there.
    my $plain_search = $search;
    if ( defined $search && $search ne '' ) {
        $search = quotemeta($search) unless $is_regex;
        $search = '(?i)' . $search   unless $case;
    }
    my ( @to_save, @to_save_orig, @data );
    my $api   = $search_api;
    my $class = $app->model( $api->{object_type} || $type );
    my %param = %$list_pref;
    my $limit;

    # type-specific directives override global CMSSearchLimit
    my $directive = 'CMSSearchLimit' . ucfirst($type);
    $limit
        = MT->config->$directive
        || MT->config->CMSSearchLimit
        || MT->config->default('CMSSearchLimit');

    # don't allow passed limit to be higher than config limit
    my $param_limit = $app->param('limit');
    if ( $param_limit && ( $param_limit < $limit ) ) {
        $limit = $param_limit;
    }
    $limit =~ s/\D//g if $limit ne 'all';
    my $matches;
    $date_col = $api->{date_column} || 'created_on';
    if (   ( $do_search && $search ne '' )
        || $show_all
        || $do_replace
        || defined $publish_status
        || $my_posts
        || ( $filter && $filter_val ) )
    {
        my %terms;
        my %args;
        ## we need to search all user/group for 'grant permissions',
        ## if $blog_id is specified. it affects the setup_terms_args.
        my $mode = $app->param('__mode') || '';
        if ( $mode eq 'dialog_grant_role' ) {
            if ($blog_id) {
                my $perm = $author->permissions($blog_id);
                return $app->permission_denied()
                    unless $perm->can_do('search_members');
            }
            $blog_id = 0;
        }
        if ( exists $api->{setup_terms_args} ) {
            my $code = $app->handler_to_coderef( $api->{setup_terms_args} );
            $code->( \%terms, \%args, $blog_id );
            if (   !exists $terms{blog_id}
                && $type ne 'author'
                && $type ne 'blog' )
            {
                if ($blog_id) {
                    require MT::Blog;
                    my $blog;
                    $blog = MT::Blog->load($blog_id) if $blog_id;
                    if (   $blog
                        && !$blog->is_blog
                        && ( $author->permissions($blog_id)
                            ->has('administer_site')
                            || $author->is_superuser )
                        )
                    {
                        my @blogs
                            = MT::Blog->load( { parent_id => $blog->id } );
                        my @blog_ids = ( $blog->id );
                        foreach my $b (@blogs) {
                            push @blog_ids, $b->id
                                if $author->permissions( $b->id )
                                ->has('administer_site');
                        }
                        $terms{blog_id} = \@blog_ids;
                    }
                    else {
                        $terms{blog_id} = $blog_id;
                    }
                }
            }
        }
        else {
            if ($blog_id) {
                require MT::Blog;
                my $blog;
                $blog = MT::Blog->load($blog_id) if $blog_id;
                if (   $blog
                    && !$blog->is_blog
                    && $author->permissions($blog_id)->has('administer_site')
                    )
                {
                    my @blogs = MT::Blog->load( { parent_id => $blog->id } );
                    my @blog_ids = ( $blog->id );
                    foreach my $b (@blogs) {
                        push @blog_ids, $b->id
                            if $author->permissions( $b->id )
                            ->has('administer_site');
                    }
                    %terms = ( blog_id => \@blog_ids );
                }
                else {
                    %terms = ( blog_id => $blog_id );
                }
            }
            if ( $type ne 'template' ) {
                %args = ( 'sort' => $date_col, direction => 'descend' );
            }
        }
        if ( $class->has_column('junk_status') ) {
            require MT::Comment;
            if ($is_junk) {
                $terms{junk_status} = MT::Comment::JUNK();
            }
            else {
                $terms{junk_status} = MT::Comment::NOT_JUNK();
            }
        }
        if (   ( defined $publish_status && $publish_status =~ m/[\d]/ )
            && ( $type eq 'entry' || $type eq 'page' ) )
        {
            $terms{status} = $publish_status;
            $terms{class}  = $type;
        }
        if ($is_dateranged) {
            if ($content_type && $date_time_field_id) {
                my $field_data
                    = $content_type->get_field($date_time_field_id);
                my $datetime_term;
                if ( $field_data->{type} eq 'time_only' ) {
                    $datetime_term
                        = ( $timefrom gt $timeto )
                        ? [ "19700101${timeto}", "19700101${timefrom}" ]
                        : [ "19700101${timefrom}", "19700101${timeto}" ];
                }
                else {
                    $datetime_term
                        = ( $datefrom gt $dateto )
                        ? [ "${dateto}000000", "${datefrom}235959" ]
                        : [ "${datefrom}000000", "${dateto}235959" ];
                }
                my $join = $app->model('content_field_index')->join_on(
                    undef,
                    {   content_data_id  => \'= cd_id',
                        content_field_id => $date_time_field_id,
                        value_datetime   => $datetime_term,
                    },
                    { range_incl => { value_datetime => 1 } },
                );
                $args{joins} ||= [];
                push @{ $args{joins} }, $join;
            }
            else {
                $args{range_incl}{$date_col} = 1;
                if ( $datefrom gt $dateto ) {
                    $terms{$date_col}
                        = [ $dateto . '000000', $datefrom . '235959' ];
                }
                else {
                    $terms{$date_col}
                        = [ $datefrom . '000000', $dateto . '235959' ];
                }
            }
        }
        if ( defined $publish_status ) {
            if ( $type eq 'entry' || $type eq 'page' ) {
                $terms{status} = $publish_status;
            }
        }
        if ($my_posts) {
            if ( $type eq 'comment' ) {
                $args{join} = MT::Entry->join_on(
                    undef,
                    {   id        => \'= comment_entry_id',
                        author_id => $app->user->id
                    }
                );
            }
            elsif ( $type eq 'entry' || $type eq 'page' ) {
                $terms{author_id} = $app->user->id;
            }
        }

        my @terms;
        if ( !$is_regex && $type ne 'content_data' ) {

            # MT::Object doesn't like multi-term hashes within arrays
            if (%terms) {
                for my $key ( keys %terms ) {
                    push( @terms, { $key => $terms{$key} } );
                }
            }
            if ( scalar @cols ) {
                push( @terms, '-and' );
                my @col_terms;
                my $query_string = "%$plain_search%";
                for my $col (@cols) {
                    if ( 'id' eq $col ) {

                        # Direct ID search
                        push( @col_terms, { $col => $plain_search }, '-or' );
                    }
                    elsif ( $col !~ /^__field:\d+$/ ) {
                        push( @col_terms,
                            { $col => { like => $query_string } }, '-or' );
                    }
                }
                delete $col_terms[$#col_terms];
                push( @terms, \@col_terms );
            }
        }
        $args{limit} = $limit + 1 if $limit ne 'all';
        my $iter;
        if ($do_replace) {
            $iter = iter_for_replace($class, \@ids);
        }
        else {
            my $terms = $param->{terms};
            my $args  = $param->{args};
            if ( defined $terms && defined $args ) {
                $iter = $class->load_iter( $terms, $args )
                    or die $class->errstr;
            }
            elsif ($blog_id
                || ( $type eq 'blog' )
                || ( $app->mode eq 'dialog_grant_role' ) )
            {
                $iter
                    = $class->load_iter( @terms ? \@terms : \%terms, \%args )
                    or die $class->errstr;
            }
            else {

                my @streams;
                if ( $author->is_superuser ) {
                    @streams = (
                        {   iter => $class->load_iter(
                                @terms ? \@terms : \%terms, \%args
                            )
                        }
                    );
                }
                else {
                    if ( $class->has_column('blog_id') ) {

                        # Get an iter for each accessible blog
                        my @perms = $app->model('permission')->load(
                            {   blog_id   => { not => 0 },
                                author_id => $author->id
                            },
                        );
                        if (@perms) {
                            my @blog_terms;
                            push( @blog_terms,
                                { blog_id => $_->blog_id, }, '-or' )
                                foreach @perms;
                            push @terms, \@blog_terms if @blog_terms;
                        }
                    }
                    @streams = (
                        { iter => $class->load_iter( \@terms, \%args ) } );
                }

                # Pull out the head of each iterator
                # Next: effectively mergesort the various iterators
                # To call the iterator n times takes time in O(bn)
                #   with 'b' the number of blogs
                # we expect to hit the iterator l/p times where 'p' is the
                #   prob. of the search term appearing and 'l' is $limit
                $_->{head} = $_->{iter}->() foreach @streams;
                if ( $type ne 'template' ) {
                    $iter = sub {

                        # find the head with greatest created_on
                        my $which = \$streams[0];
                        foreach my $iter (@streams) {
                            next
                                if !exists $iter->{head}
                                || !$which
                                || !${$which}->{head}
                                || !defined( $iter->{head} );
                            if ( $iter->{head}->created_on
                                > ${$which}->{head}->created_on )
                            {
                                $which = \$iter;
                            }
                        }

                        # Advance the chosen one
                        my $result = ${$which}->{head};
                        ${$which}->{head} = ${$which}->{iter}->() if $result;
                        $result;
                    };
                }
                else {
                    $iter = sub {
                        return undef unless @streams;

                        # find the head with greatest created_on
                        my $which = \$streams[0];
                        while ( @streams && ( !defined ${$which}->{head} ) ) {
                            shift @streams;
                            last unless @streams;
                            $which = \$streams[0];
                        }
                        my $result = ${$which}->{head};
                        ${$which}->{head} = ${$which}->{iter}->() if $result;
                        $result;
                    };
                }
            }
        }
        my $i = 1;
        my %replace_cols;
        if ($do_replace) {
            %replace_cols = map { $_ => 1 } @{ $api->{replace_cols} };
            if ($content_type) {
                %replace_cols = (
                    %replace_cols,
                    map { '__field:' . $_->{id} => 1 }
                        @{ $content_type->replaceable_fields }
                );
            }
        }

        my $content_field_types = $app->registry('content_field_types');

        my $re;
        if ( defined $search && $search ne '' ) {
            $re = eval {qr/$search/};
            if ( my $err = $@ ) {
                return $app->error(
                    $app->translate( "Error in search expression: [_1]", $@ )
                );
            }
        }
        while ( my $obj = $iter->() ) {
            next
                unless $author->is_superuser
                || $app->handler_to_coderef( $api->{perm_check} )->($obj);
            my $match = 0;

            # For cms_pre_save callback and revisioning
            my $orig_obj;
            unless ($show_all) {
                for my $col (@cols) {
                    next if $do_replace && !$replace_cols{$col};
                    my $text;
                    my ( $content_field_id, $field_data, $field_registry );
                    if ( $col =~ /^__field:(\d+)$/ ) {
                        $content_field_id = $1;
                        $field_data
                            = $content_type->get_field($content_field_id)
                            or next;
                        $field_registry
                            = $content_field_types->{ $field_data->{type} };
                        $text = $obj->data->{$content_field_id};
                    }
                    else {
                        $text = $obj->column($col);
                    }
                    $text = '' unless defined $text;
                    my $replaced_text;
                    if ($do_replace) {
                        my $replaced;
                        my $replace_handler;
                        $orig_obj ||= $obj->clone();
                        if ( my $replace_handler
                            = $field_registry->{replace_handler} )
                        {
                            $replace_handler
                                = $app->handler_to_coderef($replace_handler);
                            unless ($replace_handler) {
                                my $error = $app->translate(
                                    'replace_handler of [_1] field is invalid',
                                    $field_data->{type}
                                );
                                $app->param( 'error', $error );
                            }
                            if ($replace_handler) {
                                ($replaced, $replaced_text) = $replace_handler->(
                                    $re, $replace, $field_data, $text, $obj
                                );
                                $text = $replaced_text if defined $replaced_text;
                            }
                        }
                        else {
                            $replaced = $text =~ s!$re!$replace!g;
                        }
                        if ($replaced) {
                            if ( $content_field_id && !$app->param('error') )
                            {
                                if ( $field_data->{options}{required} ) {
                                    my $is_empty = !ref $text
                                        && ( !defined $text || $text eq '' );
                                    if ($is_empty) {
                                        $app->param(
                                            'error',
                                            $app->translate(
                                                '"[_1]" field is required.',
                                                $field_data->{options}{label}
                                            )
                                        );
                                    }
                                }
                                unless ( $app->param('error') ) {
                                    my $ss_validator
                                        = $field_registry->{ss_validator};
                                    if ($ss_validator) {
                                        $ss_validator
                                            = $app->handler_to_coderef(
                                            $ss_validator);
                                        unless ($ss_validator) {
                                            my $error = $app->translate(
                                                'ss_validator of [_1] field is invalid',
                                                $field_data->{type}
                                            );
                                            $app->param( 'error', $error );
                                        }
                                    }
                                    if ($ss_validator) {
                                        my $error = $ss_validator->(
                                            $app, $field_data, $text
                                        );
                                        if ($error) {
                                            $error = $app->translate(
                                                '"[_1]" is invalid for "[_2]" field of "[_3]" (ID:[_4]): [_5]',
                                                $text,
                                                $field_data->{options}{label},
                                                $content_type->name,
                                                $obj->id,
                                                $error,
                                            );
                                            $app->param( 'error', $error );
                                        }
                                    }
                                }
                                unless ( $app->param('error') ) {
                                    my $data = $obj->data;
                                    $data->{$content_field_id} = $text;
                                    $obj->data($data);
                                }
                            }
                            elsif ( !$content_field_id ) {
                                $obj->$col($text);
                            }
                            $match++;
                        }
                    }
                    else {
                        if (   $search ne ''
                            && $field_registry
                            && $field_registry->{search_handler} )
                        {
                            my $search_handler = $app->handler_to_coderef(
                                $field_registry->{search_handler} );
                            $match = $search_handler && $search_handler->(
                                $re, $field_data, $text, $obj
                            );
                        }
                        else {
                            $match = $search ne '' ? $text =~ m!$re! : 1;
                        }
                        last if $match;
                    }
                }
            }
            if ( $match || $show_all ) {
                if ( $do_replace && !$show_all && !$app->param('error') ) {
                    push @to_save,      $obj;
                    push @to_save_orig, $orig_obj;
                }
                push @data, $obj;
            }
            last if ( $limit ne 'all' ) && @data > $limit;
        }
        if (@data) {
            $param{have_results} = 1;

            # We got one extra to see if there were more
            if ( ( $limit ne 'all' ) && @data > $limit ) {
                $param{have_more} = 1;
                pop @data;
            }
            $matches = @data;

            if ( $do_replace && !$show_all && $app->param('error') ) {
                @to_save      = ();
                @to_save_orig = ();
            }
        }
        else {
            $matches = 0;
        }
    }
    my $replace_count = 0;
    for my $obj (@to_save) {
        $replace_count++;

        # For cms_pre_save callback and revisioning
        my $orig_obj = shift @to_save_orig;

        $app->run_callbacks( 'cms_pre_save.' . $type, $app, $obj, $orig_obj )
            || return $app->error(
            $app->translate(
                "Saving [_1] failed: [_2]", $obj->class_label,
                $app->errstr
            )
            );

        # Setting modified_by updates modified_on which we want to do before
        # a save but after pre_save callbacks fire.
        $obj->modified_by( $author->id );

        $obj->save
            or return $app->error(
            $app->translate( "Saving object failed: [_1]", $obj->errstr ) );

        # Save revision
        if ( $obj->isa('MT::Revisable') ) {
            my $blog = $obj->blog;
            if ( $blog && $blog->use_revision ) {
                $obj->gather_changed_cols($orig_obj);
                if ( exists $obj->{changed_revisioned_cols} ) {
                    my $col = 'max_revisions_' . $obj->datasource;
                    my $max = $blog->$col;
                    $obj->handle_max_revisions($max);

                    my $msg
                        = $app->translate(
                        "Searched for: '[_1]' Replaced with: '[_2]'",
                        $plain_search, $replace );

                    my $revision = $obj->save_revision($msg);
                    $obj->current_revision($revision);

                    # call update to bypass instance save method
                    $obj->update or return $obj->error( $obj->errstr );
                    if ( $obj->has_meta('revision') ) {
                        $obj->revision($revision);

                        # hack to bypass instance save method
                        $obj->{__meta}->set_primary_keys($obj);
                        $obj->{__meta}->save;
                    }
                }
            }
        }

        my $obj_title = '';
        $obj_title = $obj->title
            if $obj->can('title');    # entries, pages, pings
        $obj_title = $obj->name
            if $obj->can('name');     # templates, blogs, websites
        $obj_title = first_n_words( $obj->text, 10 )    # comments
            if $type eq 'comment';

        my $message
            = $app->translate(
            "[_1] '[_2]' (ID:[_3]) updated by user '[_4]' using Search & Replace.",
            $obj->class_label, $obj_title, $obj->id, $author->name );

        $app->log(
            {   message  => $message,
                blog_id  => ( $obj->can('blog_id') ? $obj->blog_id : 0 ),
                level    => MT::Log::NOTICE(),
                class    => $type,
                category => 'edit',
                metadata => $obj->id
            }
        );

    }
    if (@data) {

        if (   $type eq 'comment'
            || $type eq 'ping'
            || $type eq 'asset'
            || $type eq 'log' )
        {
            @data = reverse @data;
        }

        if ($quicksearch) {
            my $obj;
            if ( 1 == scalar @data ) {
                ($obj) = @data;
            }
            elsif ( defined $quicksearch_id ) {
                ($obj) = grep { $_->id == $quicksearch_id } @data;
            }

            if ( $obj && $type ne 'log' ) {
                my %args = (
                    _type         => $type,
                    id            => $obj->id,
                    search_result => 1,
                );
                $args{blog_id} = $obj->blog_id
                    if $obj->has_column('blog_id');
                my $mode = 'view';
                if ( $type eq 'blog' || $type eq 'website' ) {
                    $args{blog_id} = delete $args{id};
                    $mode = 'cfg_prefs';
                }
                return $app->redirect(
                    $app->uri(
                        mode => $mode,
                        args => \%args,
                    )
                );
            }
        }

        if ( my $meth = $search_api->{handler} ) {
            $meth = $app->handler_to_coderef($meth);
            $meth->( $app, items => \@data, param => \%param, type => $type );
        }
        else {
            my $meth = 'build_' . $type . '_table';
            if ( $app->can($meth) ) {
                $app->$meth(
                    items => \@data,
                    param => \%param,
                    type  => $type
                );
            }
            else {
                my @objects;
                push @objects, { object => $_ } for @data;
                $param{object_loop} = \@objects;
            }
        }
        $param{object_type} = $type;
        if ( exists $api->{results_table_template} ) {
            my $tmpl = _load_template(
                $app,
                $api->{results_table_template},
                exists( $api->{plugin} ) ? $api->{plugin} : undef
            );
            $param{results_template} = $tmpl;
        }
        else {
            $param{results_template}
                = _default_results_table_template( $app, $type, 1,
                lc $class->class_label_plural );
        }
    }
    else {
        if ( exists $api->{no_results_template} ) {
            my $tmpl = _load_template(
                $app,
                $api->{no_results_template},
                exists( $api->{plugin} ) ? $api->{plugin} : undef
            );
            $param{results_template} = $tmpl;
        }
        else {
            $param{results_template}
                = _default_results_table_template( $app, $type, 0,
                lc $class->class_label_plural );
        }
    }
    if ($is_dateranged) {
        if ( $from && $to ) {
            ( $datefrom_year, $datefrom_month, $datefrom_day )
                = $datefrom =~ m/^(\d\d\d\d)(\d\d)(\d\d)/;
            ( $dateto_year, $dateto_month, $dateto_day )
                = $dateto =~ m/^(\d\d\d\d)(\d\d)(\d\d)/;
            $from = sprintf "%s-%s-%s", $datefrom_year, $datefrom_month,
                $datefrom_day;
            $to = sprintf "%s-%s-%s", $dateto_year, $dateto_month,
                $dateto_day;
        }
        if ( $timefrom && $timeto ) {
            $timefrom =~ s/^(\d{2})(\d{2})(\d{2})$/$1:$2:$3/;
            $timeto =~ s/^(\d{2})(\d{2})(\d{2})$/$1:$2:$3/;
        }
    }

    my $error = $app->param('error') || '';
    my $res_search
        = $do_replace ? $app->param('orig_search') : $app->param('search');
    $res_search = '' unless defined $res_search;
    my %res = (
        error               => $error,
        limit               => $limit,
        limit_all           => $limit eq 'all',
        count_matches       => $matches,
        replace_count       => $replace_count,
        "search_$type"      => 1,
        search_label        => $class->class_label_plural,
        object_label        => $class->class_label,
        object_label_plural => $class->class_label_plural,
        object_type         => $type,
        search              => $res_search,
        searched            => (
            $do_replace
            ? ( defined $app->param('orig_search')
                    && $app->param('orig_search') ne '' )
            : (        $do_search
                    && defined $app->param('search')
                    && $app->param('search') ne '' )
            )
            || $show_all
            || defined $publish_status
            || $my_posts
            || ( $filter && $filter_val ),
        replace            => $replace,
        do_replace         => $do_replace,
        case               => $case,
        from               => $from,
        datefrom_year      => $datefrom_year,
        datefrom_month     => $datefrom_month,
        datefrom_day       => $datefrom_day,
        to                 => $to,
        date_time_field_id => $date_time_field_id,
        timefrom           => $timefrom,
        timeto             => $timeto,
        dateto_year        => $dateto_year,
        dateto_month       => $dateto_month,
        dateto_day         => $dateto_day,
        is_regex           => $is_regex,
        is_limited         => $is_limited,
        is_dateranged      => $is_dateranged,
        is_junk            => $is_junk,
        can_search_junk    => ( $type eq 'comment' || $type eq 'ping' ),
        can_replace        => $search_api->{can_replace},
        can_search_by_date => $search_api->{can_search_by_date},
        quick_search       => 0,
        "tab_$tab"         => 1,
        filter             => $filter,
        filter_val         => $filter_val,
        %param
    );
    $res{'tab_junk'} = 1 if $is_junk;

    my $search_cols = $search_api->{search_cols};
    my %cols = map { $_ => 1 } @cols;
    my @search_cols;
    for my $field ( keys %$search_cols ) {
        next if $field eq 'plugin';
        my %search_field;
        $search_field{field} = $field;
        $search_field{selected} = 1 if exists( $cols{$field} );
        $search_field{label}
            = 'CODE' eq ref( $search_cols->{$field} )
            ? $search_cols->{$field}->()
            : exists( $search_api->{plugin} )
            ? $search_api->{plugin}->translate( $search_cols->{$field} )
            : $app->translate( $search_cols->{$field} );
        $search_field{replaceable}
            = ( grep { $_ eq $field } @{ $search_api->{replace_cols} || [] } )
            ? 1
            : 0;
        push @search_cols, \%search_field;
    }
    if ( $res{object_type} eq 'content_data' ) {
        for my $ct (@content_types) {
            for my $f ( @{ $ct->searchable_fields } ) {
                push @search_cols,
                    +{
                    field       => '__field:' . $f->{id},
                    label       => $f->{options}{label},
                    selected    => exists( $cols{ '__field:' . $f->{id} } ),
                    hidden      => ( $ct->id != $content_type->id ) ? 1 : 0,
                    field_ct_id => $ct->id,
                    replaceable => (
                        grep { $_->{id} == $f->{id} }
                            @{ $ct->replaceable_fields }
                        )
                    ? 1
                    : 0,
                    };
            }
        }
    }
    $res{'search_cols'} = \@search_cols;

    my $search_options;
    $search_options .= '&amp;case=' . encode_html($case) if defined $case;
    $search_options .= '&amp;is_regex=' . encode_html($is_regex)
        if defined $is_regex;
    $search_options .= '&amp;is_limited=' . encode_html($is_limited)
        if defined $is_limited;
    $search_options .= '&amp;is_junk=' . encode_html($is_junk)
        if defined $is_junk;
    $search_options .= '&amp;is_dateranged=' . encode_html($is_dateranged)
        if defined $is_dateranged;

    if ($is_dateranged) {
        $search_options .= '&amp;datefrom_year=' . encode_html($datefrom_year)
            if defined $datefrom_year;
        $search_options
            .= '&amp;datefrom_month=' . encode_html($datefrom_month)
            if defined $datefrom_month;
        $search_options .= '&amp;datefrom_day=' . encode_html($datefrom_day)
            if defined $datefrom_day;
        $search_options .= '&amp;dateto_year=' . encode_html($dateto_year)
            if defined $dateto_year;
        $search_options .= '&amp;dateto_month=' . encode_html($dateto_month)
            if defined $dateto_month;
        $search_options .= '&amp;dateto_day=' . encode_html($dateto_day)
            if defined $dateto_day;
    }
    if ($is_limited) {
        foreach (@cols) {
            $search_options .= '&amp;search_cols=' . encode_html($_);
        }
    }

    $res{search_options} = $search_options;

    \%res;
}

sub iter_for_replace {
    require MT::Meta::Proxy;
    my ($class, $ids) = @_;
    my @objs;
    my $capacity = MT->config->BulkLoadMetaObjectsLimit;
    my %idx = map { $ids->[$_] => $_ } 0 .. scalar(@$ids) - 1;
    return sub {
        unless (@objs) {
            my $len = @$ids or return;
            my @stock_ids = splice @$ids, $len > $capacity ? -$capacity : -$len;
            @objs = $class->load({ id => \@stock_ids });
            @objs = sort { $idx{ $b->id } <=> $idx{ $a->id } } @objs;
            MT::Meta::Proxy->bulk_load_meta_objects(\@objs) if @objs && $objs[0]->has_meta;
        }
        return shift(@objs);
    };
}

sub _default_results_table_template {
    my $app = shift;
    my ( $type, $results, $plural ) = @_;
    if ($results) {
        $type = 'blog' if $type eq 'website';
        return "<mt:include name=\"include/${type}_table.tmpl\">";
    }
    else {
        return <<TMPL;
        <mtapp:statusmsg
                id="no-$type"
                class="info"
                can_close="0">
                <__trans phrase="No [_1] were found that match the given criteria." params="$plural">
            </mtapp:statusmsg>
TMPL
    }
}

sub _load_template {
    my $app = shift;
    my ( $tmpl, $plugin ) = @_;

    my $meth;
    if ( ref $tmpl eq 'HASH' ) {
        $meth = $tmpl->{handler} || $tmpl->{code};
    }
    elsif ( $tmpl =~ m/^\$(\w+)::/ ) {
        $meth = $tmpl;
    }
    $tmpl = $app->handler_to_coderef($meth) if $meth;
    if ( ref $tmpl eq 'CODE' ) {
        $tmpl = $tmpl->( $plugin || $app, @_ );
    }
    if ( $tmpl !~ /\s/ ) {

        # no spaces in $tmpl; must be a filename...
        my $tmpl_obj;
        if ($plugin) {
            $tmpl_obj = $plugin->load_tmpl($tmpl);
        }
        else {
            $tmpl_obj = $app->load_tmpl($tmpl);
        }
        if ($tmpl_obj) {
            $tmpl = $tmpl_obj->text;
        }
    }
    return $tmpl;
}

1;
__END__
