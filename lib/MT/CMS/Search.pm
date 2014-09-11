# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Search.pm 4464 2009-09-29 12:06:58Z fumiakiy $
package MT::CMS::Search;

use strict;
use MT::Util qw( is_valid_date encode_html );

sub core_search_apis {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');
    my $author  = $app->user;

    my $types = {
        'entry' => {
            'order'     => 100,
            'condition' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;

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
        'comment' => {
            'order'     => 200,
            'condition' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;

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
                            '-or',
                            {   permissions =>
                                    { like => "\%'manage_feedback'\%" }
                            },
                        ],
                    ]
                );

                return ( $cnt && $cnt > 0 ) ? 1 : 0;
            },
            'handler'    => '$Core::MT::CMS::Comment::build_comment_table',
            'label'      => 'Comments',
            'perm_check' => sub {
                my $author = MT->app->user;
                return 1
                    if $author->permissions( $_[0]->blog_id )
                    ->can_do('manage_feedback');

                my $entry = MT->model('entry')->load( $_[0]->entry_id );
                return 1
                    if $author->permissions( $entry->blog_id )
                    ->can_edit_entry( $entry, $author );

                return 0;
            },
            'search_cols' => {
                'url'    => sub { $app->translate('URL') },
                'text'   => sub { $app->translate('Comment Text') },
                'email'  => sub { $app->translate('Email Address') },
                'ip'     => sub { $app->translate('IP Address') },
                'author' => sub { $app->translate('Name') },
            },
            'replace_cols'       => [qw(text)],
            'can_replace'        => 1,
            'can_search_by_date' => 1,
            'setup_terms_args'   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                $args->{sort}      = 'created_on';
                $args->{direction} = 'descend';
                }
        },
        'ping' => {
            'order'     => 300,
            'condition' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;

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
                            '-or',
                            {   permissions =>
                                    { like => "\%'manage_feedback'\%" }
                            },
                        ],
                    ]
                );

                return ( $cnt && $cnt > 0 ) ? 1 : 0;
            },
            'label'      => 'TrackBacks',
            'handler'    => '$Core::MT::CMS::TrackBack::build_ping_table',
            'perm_check' => sub {
                my $author = MT->app->user;
                my $ping   = shift;
                require MT::Trackback;
                my $tb = MT::Trackback->load( $ping->tb_id )
                    or return undef;
                if ( $tb->entry_id ) {
                    my $entry = MT->model('entry')->load( $tb->entry_id );
                    return 1
                        if $author->permissions( $entry->blog_id )
                        ->can_do('manage_feedback')
                        || $author->permissions( $entry->blog_id )
                        ->can_edit_entry( $entry, $author );
                }
                elsif ( $tb->category_id ) {
                    return 1
                        if $author->permissions( $tb->blog_id )
                        ->can_do('search_category_trackbacks');
                }
                return 0;
            },
            'search_cols' => {
                'title'      => sub { $app->translate('Title') },
                'excerpt'    => sub { $app->translate('Excerpt') },
                'source_url' => sub { $app->translate('Source URL') },
                'ip'         => sub { $app->translate('IP Address') },
                'blog_name'  => sub { $app->translate('Blog Name') },
            },
            'replace_cols'       => [qw(title excerpt)],
            'can_replace'        => 1,
            'can_search_by_date' => 1,
            'setup_terms_args'   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                $args->{sort}      = 'created_on';
                $args->{direction} = 'descend';
                }
        },
        'page' => {
            'order'     => 400,
            'condition' => sub {
                my $author = MT->app->user;
                return 1 if $author->is_superuser;

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

                if (   $app->param('edit_field')
                    && $app->param('edit_field') =~ m/^customfield_.*$/ )
                {
                    !$perm->is_empty;
                }
                else {
                    $perm->can_do('search_assets');
                }
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
            'label'     => 'Blogs',
            'condition' => sub {
                my $author = MT->app->user;
                my $blog   = MT->app->blog;
                return 0 if $blog && $blog->is_blog;
                return 1 if $author->is_superuser;
                return 1 if $author->permissions(0)->can_do('administer');
                return 1 if $author->permissions(0)->can_do('edit_template');
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
            'can_replace'        => $author->is_superuser(),
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
                return 0 if $blog_id;
                return 1 if $author->is_superuser;
                return 1 if $author->permissions(0)->can_do('administer');
                return 1 if $author->permissions(0)->can_do('edit_template');
                return 0;
            },
            'label'      => 'Websites',
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
            'can_replace'        => $author->is_superuser(),
            'can_search_by_date' => 0,
            'view'               => 'system',
            'setup_terms_args'   => sub {
                my ( $terms, $args, $blog_id ) = @_;
                $args->{sort}      = 'name';
                $args->{direction} = 'ascend';
                }
        }
    };
    return $types;
}

sub can_search_replace {
    my $app = shift;

    return 1 if $app->user->is_superuser;
    return 1 if $app->user->permissions(0)->can_do('edit_templates');
    return 1 if $app->user->permissions(0)->can_do('view_log');
    if ( $app->param('blog_id') ) {
        my $perms = $app->user->permissions( $app->param('blog_id') );
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
            my $perms = $app->permissions;
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

    my $tmpl = $app->load_tmpl( 'search_replace.tmpl', $param );
    my $placeholder = $tmpl->getElementById('search_results');
    $placeholder->innerHTML( delete $param->{results_template} );
    return $tmpl;
}

sub do_search_replace {
    my $app     = shift;
    my ($param) = @_;
    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');
    my $author  = $app->user;

    my ($search,        $replace,     $do_replace,     $case,
        $is_regex,      $is_limited,  $type,           $is_junk,
        $is_dateranged, $ids,         $datefrom_year,  $datefrom_month,
        $datefrom_day,  $dateto_year, $dateto_month,   $dateto_day,
        $from,          $to,          $show_all,       $do_search,
        $orig_search,   $quicksearch, $publish_status, $my_posts,
        $search_type,   $filter,      $filter_val
        )
        = map scalar $q->param($_),
        qw( search replace do_replace case is_regex is_limited _type is_junk is_dateranged replace_ids datefrom_year datefrom_month datefrom_day dateto_year dateto_month dateto_day from to show_all do_search orig_search quicksearch publish_status my_posts search_type filter filter_val );

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
    my $search_api = $app->registry( "search_apis", $type );

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
    if ($is_limited) {
        @cols = $q->param('search_cols');
        my %search_api_cols
            = map { $_ => 1 } keys %{ $search_api->{search_cols} };
        if ( @cols && ( $cols[0] =~ /,/ ) ) {
            @cols = split /,/, $cols[0];
        }
        @cols = grep { $search_api_cols{$_} } @cols;
        $is_limited = 0 unless scalar @cols;
    }
    if ( !$is_limited ) {
        @cols = grep { $_ ne 'plugin' }
            keys %{ $search_api->{search_cols} };
    }
    my $quicksearch_id;
    if ( $quicksearch && ( $search || '' ) ne '' && $search !~ m{ \D }xms ) {
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
    elsif ( $is_dateranged && $from && $to ) {
        $is_dateranged = 1;
        s!\D!!g foreach ( $from, $to );
        $datefrom = substr( $from, 0, 8 );
        $dateto   = substr( $to,   0, 8 );
    }
    my $tab = $q->param('tab') || 'entry';
    ## Sometimes we need to pass in the search columns like 'title,text', so
    ## we look for a comma (not a valid character in a column name) and split
    ## on it if it's there.
    my $plain_search = $search;
    if ( ( $search || '' ) ne '' ) {
        $search = quotemeta($search) unless $is_regex;
        $search = '(?i)' . $search   unless $case;
    }
    my ( @to_save, @data );
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
    if ( $q->param('limit') && ( $q->param('limit') < $limit ) ) {
        $limit = $q->param('limit');
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
        if ( $app->param('__mode') eq 'dialog_grant_role' ) {
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
                            ->has('manage_member_blogs')
                            || $author->is_superuser )
                        )
                    {
                        my @blogs
                            = MT::Blog->load( { parent_id => $blog->id } );
                        my @blog_ids = map { $_->id } @blogs;
                        push @blog_ids, $blog_id;
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
                    && $author->permissions($blog_id)
                    ->has('manage_member_blogs') )
                {
                    my @blogs = MT::Blog->load( { parent_id => $blog->id } );
                    my @blog_ids = map { $_->id } @blogs;
                    push @blog_ids, $blog_id;
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
        if ( !$is_regex ) {

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
                    else {
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
            $iter = sub {
                if ( my $id = pop @ids ) {
                    $class->load($id);
                }
            };
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
        }

        my $re;
        if ( ( $search || '' ) ne '' ) {
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
            unless ($show_all) {
                for my $col (@cols) {
                    next if $do_replace && !$replace_cols{$col};
                    my $text = $obj->column($col);
                    $text = '' unless defined $text;
                    if ($do_replace) {
                        if ( $text =~ s!$re!$replace!g ) {
                            $match++;
                            $obj->$col($text);
                        }
                    }
                    else {
                        $match = $search ne '' ? $text =~ m!$re! : 1;
                        last if $match;
                    }
                }
            }
            if ( $match || $show_all ) {
                push @to_save, $obj if $do_replace && !$show_all;
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
        }
        else {
            $matches = 0;
        }
    }
    my $replace_count = 0;
    for my $obj (@to_save) {
        $replace_count++;
        $obj->save
            or return $app->error(
            $app->translate( "Saving object failed: [_1]", $obj->errstr ) );
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
        ( $datefrom_year, $datefrom_month, $datefrom_day )
            = $datefrom =~ m/^(\d\d\d\d)(\d\d)(\d\d)/;
        ( $dateto_year, $dateto_month, $dateto_day )
            = $dateto =~ m/^(\d\d\d\d)(\d\d)(\d\d)/;
        $from = sprintf "%s-%s-%s", $datefrom_year, $datefrom_month,
            $datefrom_day;
        $to = sprintf "%s-%s-%s", $dateto_year, $dateto_month, $dateto_day;
    }

    my %res = (
        error => $q->param('error') || '',
        limit => $limit,
        limit_all           => $limit eq 'all',
        count_matches       => $matches,
        replace_count       => $replace_count,
        "search_$type"      => 1,
        search_label        => $class->class_label_plural,
        object_label        => $class->class_label,
        object_label_plural => $class->class_label_plural,
        object_type         => $type,
        search              => (
              $do_replace ? $q->param('orig_search')
            : $q->param('search')
            )
            || '',
        searched => (
            $do_replace ? $q->param('orig_search')
            : (        $do_search
                    && $q->param('search')
                    && $q->param('search') ne '' )
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
        push @search_cols, \%search_field;
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
                id="no-$plural"
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
