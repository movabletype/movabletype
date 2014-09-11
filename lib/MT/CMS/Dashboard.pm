# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Dashboard;

use strict;
use MT::Util qw( epoch2ts encode_html );
use MT::Stats qw(readied_provider);

sub dashboard {
    my $app = shift;
    my (%param) = @_;

    my $param = \%param;

    $param->{redirect}   ||= $app->param('redirect');
    $param->{permission} ||= $app->param('permission');
    $param->{saved}      ||= $app->param('saved');

    $param->{system_overview_nav} = defined $app->param('blog_id')
        && ( $app->param('blog_id') || 0 ) eq 0 ? 1 : 0;
    $param->{quick_search}   = 0;
    $param->{no_breadcrumbs} = 1;
    $param->{screen_class}   = "dashboard";
    $param->{screen_id}      = "dashboard";

    my $blog  = $app->blog;
    my $scope = $app->view;

    return $app->error(
        $app->translate('Error: This blog does not have a parent website.') )
        if $blog && $blog->is_blog && !$blog->website;

    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    if ( defined $blog_id && $blog_id ) {
        my $blog = MT->model('blog')->load($blog_id);
        my $trust;
        if ( $blog->is_blog ) {
            $trust = $user->has_perm( $blog->id );
        }
        else {
            my $ids;
            push @$ids, $blog->id;
            push @$ids, ( map { $_->id } @{ $blog->blogs } );
            foreach my $b (@$ids) {
                $trust = $user->has_perm($b);
                last if $trust;
            }
        }
        if ( !$trust ) {

            # Remove blog_id if it was found.
            if ( $blog && $blog->is_blog ) {
                my @current = grep { $_ != $blog_id }
                    @{ $user->favorite_blogs || [] };
                $user->favorite_blogs( \@current );
            }
            elsif ( $blog && !$blog->is_blog ) {
                my @current = grep { $_ != $blog_id }
                    @{ $user->favorite_websites || [] };
                $user->favorite_websites( \@current );
            }
            $user->save;

            return $app->return_to_user_dashboard(
                redirect   => 1,
                permission => 1
            );
        }
    }

    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    foreach my $subdir (qw( uploads userpics )) {
        $param->{support_path}
            = File::Spec->catdir( $app->support_directory_path, $subdir );
        if ( !$fmgr->exists( $param->{support_path} ) ) {
            $fmgr->mkpath( $param->{support_path} );
        }
    }
    unless ( $fmgr->exists( $param->{support_path} ) ) {

        # the path didn't exist - change the warning a little
        $param->{support_path} = $app->support_directory_path;
    }

    # We require that the determination of the 'single blog mode'
    # state be done PRIOR to the generation of the widgets
    $app->build_blog_selector($param);
    $app->load_widget_list( 'dashboard', $scope, $param );
    $param = $app->load_widgets( 'dashboard', $scope, $param );
    return $app->load_tmpl( "dashboard.tmpl", $param );
}

sub personal_stats_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    my $user = $app->user;

    # User profile data
    # Number of posts by this user
    require MT::Entry;
    $param->{publish_count} = MT::Entry->count(
        { author_id => $user->id, status => MT::Entry::RELEASE() } );
    $param->{draft_count} = MT::Entry->count(
        {   author_id => $user->id,
            status    => MT::Entry::HOLD(),
        }
    );

    my $page_class = $app->model('page');
    $param->{publish_page_count} = $page_class->count(
        { author_id => $user->id, status => MT::Entry::RELEASE() } );
    $param->{draft_page_count} = $page_class->count(
        {   author_id => $user->id,
            status    => MT::Entry::HOLD(),
        }
    );

    if ( $param->{publish_count} || $param->{publish_page_count} ) {
        my $iter = MT::Entry->sum_group_by(
            {   author_id => $user->id,
                class     => '*',
            },
            { sum => 'comment_count', group => ['author_id'] }
        );
        my ( $count, $author_id ) = $iter->();
        $param->{comment_count} = $count;
    }

    require MT::Permission;
    my @perm = MT::Permission->load( { author_id => $app->user->id } );
    my @blogs = map { $_->blog_id }
        grep {
               $_->can_create_post
            || $_->can_publish_post
            || $_->can_edit_all_posts
        } @perm;
    $param->{can_list_entries} = @blogs ? 1 : 0;
    @blogs = map { $_->blog_id }
        grep { $_->can_view_feedback } @perm;
    $param->{can_list_comments} = @blogs ? 1 : 0;
    @blogs = map { $_->blog_id }
        grep { $_->can_manage_pages } @perm;
    $param->{can_list_pages} = @blogs ? 1 : 0;

    my $last_post = MT::Entry->load(
        {   author_id => $user->id,
            status    => MT::Entry::RELEASE(),
        },
        {   sort      => 'created_on',
            direction => 'descend',
            limit     => 1,
        }
    );

    if ($last_post) {
        $param->{last_post_id}        = $last_post->id;
        $param->{last_post_blog_id}   = $last_post->blog_id;
        $param->{last_post_blog_name} = encode_html( $last_post->blog->name );
        $param->{last_post_ts}        = $last_post->created_on;
        my $perms = MT::Permission->load(
            { blog_id => $last_post->blog_id, author_id => $app->user->id } );
        $param->{last_post_can_edit}
            = $perms && $perms->can_edit_entry( $last_post, $app->user );
    }

    if ( my ($url) = $user->userpic_url( Width => 50, Height => 50 ) ) {
        $param->{author_userpic_url} = $url;
    }
    $param->{author_userpic_width}  = 50;
    $param->{author_userpic_height} = 50;
    my @num_vars = qw(
        comment_count draft_page_count publsh_page_count
        publish_count draft_count
    );
    map { $param->{$_} = 0 if !defined $param->{$_} } @num_vars;
}

sub favorite_blogs_widget {
    my $app  = shift;
    my $user = $app->user;
    my ( $tmpl, $param ) = @_;

    my %args;
    my %terms;

    # Load favorite websites data
    $param->{website_object_loop}
        = _build_favorite_websites_data( $app, { not_count => 1 } );

    require MT::Permission;
    require MT::Website;
    $args{join} = MT::Permission->join_on( 'blog_id',
        { author_id => $user->id, permissions => { not => "'comment'" } } );
    $terms{class} = 'website';
    my $count = MT::Website->count( \%terms, \%args );
    $param->{has_more_websites} = 1 if $count > 10;

    # Load favorite blogs data
    $param->{blog_object_loop}
        = _build_favorite_blogs_data( $app, { not_count => 1 } );

    require MT::Blog;
    %terms      = ();
    %args       = ();
    $args{join} = MT::Permission->join_on( 'blog_id',
        { author_id => $user->id, permissions => { not => "'comment'" } } );
    $terms{class} = 'blog';
    $count = MT::Blog->count( \%terms, \%args );
    $param->{has_more_blogs} = 1 if $count > 10;

    $param->{can_create_blog} = $user->can_do('create_blog');
}

sub recent_websites_widget {
    my $app  = shift;
    my $user = $app->user;
    my ( $tmpl, $param ) = @_;

    my %args;
    my %terms;

    # Load favorite websites data
    $param->{website_object_loop} = _build_favorite_websites_data($app);

    require MT::Permission;
    require MT::Website;
    $args{join} = MT::Permission->join_on( 'blog_id',
        { author_id => $user->id, permissions => { not => "'comment'" } } );
    $terms{class} = 'website';
    my $count = MT::Website->count( \%terms, \%args );
    $param->{has_more_websites} = 1 if $count > 10;

    $param->{can_create_blog} = $user->can_do('create_blog');
}

sub recent_blogs_widget {
    my $app  = shift;
    my $user = $app->user;
    my ( $tmpl, $param ) = @_;

    require MT::Permission;
    require MT::Blog;

    # Load favorite blogs data
    $param->{blog_object_loop} = _build_favorite_blogs_data($app);

    my %args;
    my %terms;
    $args{join} = MT::Permission->join_on( 'blog_id',
        { author_id => $user->id, permissions => { not => "'comment'" } } );
    $terms{class} = 'blog';
    my $count = MT::Blog->count( \%terms, \%args );
    $param->{has_more_blogs} = 1 if $count > 10;
}

sub mt_news_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    $param->{news_html} = get_newsbox_content($app) || '';
}

sub get_newsbox_content {
    my $app         = shift;
    my $newsbox_url = $app->config('NewsboxURL');
    if ( $newsbox_url && $newsbox_url ne 'disable' ) {
        return MT::Util::get_newsbox_html( $newsbox_url, 'NW' );
    }
    return q();
}

sub mt_blog_stats_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    # For stats shown on this page
    stats_generation_handler( $app, $param ) or return;

    my $tabs = $app->registry('blog_stats_tabs') or return;
    $tabs = $app->filter_conditional_list( $tabs, 'dashboard',
        ( $param->{widget_scope} || '' ) );

    $param->{tab_html_head} = '';
    {
        local $param->{main};
        local $param->{html_head};

        my %cfgs;
        my $stat_url = delete $param->{stat_url};
        while ( my ( $tab_id, $url ) = each %$stat_url ) {
            $param->{has_stat_urls} = 1;
            $cfgs{$tab_id} = { param => { stat_url => $url } };
        }
        $app->build_widgets(
            set         => 'blog_stats',
            param       => $param,
            widgets     => $tabs,
            widget_cfgs => \%cfgs,
            passthru_param =>
                [qw( html_head js_include tabs active_stats_panel_updates )],
        ) or return;

        $param->{blog_stats} = $param->{main};
        $param->{tab_html_head} .= $param->{html_head};
    }
}

sub stats_generation_handler {
    my $app = shift;
    my ($param) = @_;

    if ( lc( MT->config('StatsCachePublishing') ) eq 'off' ) {
        return;
    }

    my $cache_time = 60 * MT->config('StatsCacheTTL');   # cache for x minutes

    my $stats_static_path = create_stats_directory( $app, $param ) or return;

    my $tabs = $app->registry('blog_stats_tabs') or return;

    while ( my ( $tab_id, $tab ) = each %$tabs ) {
        next if !$tab->{stats};

        my $file = "${tab_id}.xml";
        $param->{stat_url}->{$tab_id} = $stats_static_path . '/' . $file;
        my $path = File::Spec->catfile( $param->{support_path}, $file );

        require MT::FileMgr;
        my $fmgr = MT::FileMgr->new('Local');
        my $time;
        $time = $fmgr->file_mod_time($path) if -f $path;

        if ( lc( MT->config('StatsCachePublishing') ) eq 'onload' ) {
            if ( !$time || ( time - $time > $cache_time ) ) {
                unless (
                    generate_dashboard_stats(
                        $app, $param, $tab, $tab_id, $path
                    )
                    )
                {
                    delete $param->{stat_url}->{$tab_id};
                }
            }
        }
        else {
            return;
        }
    }

    1;
}

sub create_stats_directory {
    my $app = shift;
    my ($param) = @_;

    my $blog_id
        = $app->blog        ? $app->blog->id
        : $param->{blog_id} ? $param->{blog_id}
        :                     0;
    my $user    = $app->user;
    my $user_id = $user->id;

    my $static_file_path = $app->static_file_path;

    if ( -f File::Spec->catfile( $static_file_path, "mt.js" ) ) {
        $param->{static_file_path} = $static_file_path;
    }
    else {
        return;
    }

    my $low_dir = sprintf( "%03d", $user_id % 1000 );
    my $sub_dir = sprintf( "%03d", $blog_id % 1000 );
    my $top_dir = $blog_id > $sub_dir ? $blog_id - $sub_dir : 0;
    $param->{support_path}
        = File::Spec->catdir( $app->support_directory_path(),
        'dashboard', 'stats', $top_dir, $sub_dir, $low_dir );

    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    unless ( $fmgr->exists( $param->{support_path} ) ) {
        $fmgr->mkpath( $param->{support_path} );
        unless ( $fmgr->exists( $param->{support_path} ) ) {

            # the path didn't exist - change the warning a little
            $param->{support_path} = $app->support_directory_path();
            return;
        }
    }

    return
          $app->support_directory_url()
        . 'dashboard/stats/'
        . $top_dir . '/'
        . $sub_dir . '/'
        . $low_dir;
}

sub mt_blog_stats_widget_entry_tab {
    my ( $app, $tmpl, $param ) = @_;

    my $user = $app->user;
    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id if $blog;

    $param->{editable} = $user->is_superuser;
    if ( $blog && !$param->{editable} ) {
        $param->{editable}
            = $user->permissions($blog_id)->can_do('edit_all_entries');
    }

    my $entries = sub {
        my $args = {
            limit     => 10,
            sort      => 'authored_on',
            direction => 'descend',
        };
        if ( !$user->is_superuser && !$blog_id ) {
            $args->{join} = MT::Permission->join_on(
                undef,
                {   blog_id   => \'= entry_blog_id',
                    author_id => $user->id
                },
            );
        }
        my @e = MT::Entry->load(
            { ( $blog_id ? ( blog_id => $blog_id ) : () ), }, $args );
        \@e;
    };

    require MT::Promise;
    my $ctx = $tmpl->context;
    $ctx->stash( 'entries', MT::Promise::delay($entries) );
}

sub generate_dashboard_stats {
    my $app = shift;
    my ( $param, $tab, $tab_id, $path ) = @_;

    my $gen_stats = $tab->{stats};
    $gen_stats = $app->handler_to_coderef($gen_stats);

    my %counts = $gen_stats->( $app, $tab );

    unless ( create_dashboard_stats_file( $app, $path, \%counts ) ) {
        delete $param->{stat_url}->{$tab_id};
    }

    1;
}

sub create_dashboard_stats_file {
    my $app = shift;
    my ( $file, $data ) = @_;

    my $support_dir = $app->support_directory_path;

    local *FOUT;
    if ( !open( FOUT, ">$file" ) ) {
        return;
    }

    print FOUT <<EOT;
<?xml version="1.0"?>
<rsp status_code="0" status_message="Success">
  <daily_counts>
EOT
    my $now = time;
    for ( my $i = 120; $i >= 1; $i-- ) {
        my $ds
            = substr(
            epoch2ts( $app->blog, $now - ( ( $i - 1 ) * 60 * 60 * 24 ) ),
            0, 8 )
            . 'T00:00:00';
        my $count = $data->{$ds} || 0;
        print FOUT qq{    <count date="$ds">$count</count>\n};
    }
    print FOUT <<EOT;
  </daily_counts>
</rsp>
EOT
    close FOUT;
}

sub generate_dashboard_stats_entry_tab {
    my $app = shift;
    my ($tab) = @_;

    my $blog_id = $app->blog ? $app->blog->id : 0;
    my $user    = $app->user;
    my $user_id = $user->id;

    my $entry_class = $app->model('entry');
    my $terms       = { status => MT::Entry::RELEASE() };
    my $args        = {
        group => [
            "extract(year from authored_on)",
            "extract(month from authored_on)",
            "extract(day from authored_on)"
        ],
    };

    require MT::Util;
    my @ts = MT::Util::offset_time_list( time - ( 121 * 24 * 60 * 60 ),
        $blog_id );
    my $earliest = sprintf(
        '%04d%02d%02d%02d%02d%02d',
        $ts[5] + 1900,
        $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ]
    );
    $terms->{authored_on} = [ $earliest, undef ];
    $args->{range_incl}{authored_on} = 1;

    $terms->{blog_id} = $blog_id if $blog_id;
    if ( !$user->is_superuser && !$blog_id ) {
        $args->{join} = MT::Permission->join_on(
            undef,
            {   blog_id   => \'= entry_blog_id',
                author_id => $user_id
            },
        );
    }

    my $entry_iter = $entry_class->count_group_by( $terms, $args );
    my %counts;
    while ( my ( $count, $y, $m, $d ) = $entry_iter->() ) {
        my $date = sprintf( "%04d%02d%02dT00:00:00", $y, $m, $d );
        $counts{$date} = $count;
    }

    %counts;
}

sub mt_blog_stats_tag_cloud_tab {
    my ( $app, $tmpl, $param ) = @_;

    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id if $blog;

    my $terms = {};
    my $args  = {};
    $terms->{blog_id}           = $blog_id if $blog_id;
    $terms->{object_datasource} = 'entry';
    $args->{group}              = ['tag_id'];
    $args->{sort}               = '1';                    # sort by count(*)
    $args->{direction}          = 'descend';
    $args->{limit}              = 100;
    $args->{join}               = MT::Tag->join_on(
        undef,
        { id => \'= objecttag_tag_id', is_private => 1 },
        { not => { is_private => 1 } }
    );

    my $iter = $app->model('objecttag')->count_group_by( $terms, $args );
    my @tag_loop;
    my @tag_ids;
    my $ntags = 0;
    my $min   = undef;
    my $max   = undef;
    while ( my ( $count, $tag_id ) = $iter->() ) {
        $ntags += $count;
        $min = defined $min ? ( $count < $min ? $count : $min ) : $count;
        $max = defined $max ? ( $count > $max ? $count : $max ) : $count;
        push @tag_loop, { id => $tag_id, count => $count };
        push @tag_ids, $tag_id;
    }

    if (@tag_ids) {
        my $iter = MT::Tag->load_iter( { id => \@tag_ids } );
        my %tags;
        while ( my $t = $iter->() ) {
            $tags{ $t->id } = $t->name;
        }
        $_->{name} = $tags{ $_->{id} } for @tag_loop;
    }

    $min ||= 0;
    $max ||= 0;
    my $factor;
    if ( $max - $min == 0 ) {
        $min -= 6;
        $factor = 1;
    }
    else {
        $factor = 5 / log( $max - $min + 1 );
    }
    $factor *= ( $ntags / 6 ) if $ntags < 6;

    foreach my $tag (@tag_loop) {

        # now calc rank
        my $rank;
        my $count = $tag->{count};
        if ( $count - $min + 1 == 0 ) {
            $rank = 0;
        }
        else {
            $rank = 6 - int( log( $count - $min + 1 ) * $factor );
        }
        $tag->{rank} = $rank;
    }

    @tag_loop = sort { $a->{name} cmp $b->{name} } @tag_loop;
    $param->{tag_loop} = \@tag_loop;
}

sub mt_blog_stats_widget_comment_tab {
    my ( $app, $tmpl, $param ) = @_;

    my $user = $app->user;
    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id if $blog;

    $param->{editable} = $user->is_superuser;
    if ( $blog && !$param->{editable} ) {
        $param->{editable}
            = $user->permissions($blog_id)->can_do('edit_all_entries');
        $param->{comment_editable}
            = $user->permissions($blog_id)->can_do('edit_all_comments');
    }

    my $comments = sub {
        my $args = {
            limit     => 10,
            sort      => 'created_on',
            direction => 'descend',
        };
        if ( !$user->is_superuser && !$blog_id ) {
            $args->{join} = MT::Permission->join_on(
                undef,
                {   blog_id   => \'= comment_blog_id',
                    author_id => $user->id
                },
            );
        }
        my @c = MT::Comment->load(
            {   ( $blog_id ? ( blog_id => $blog_id ) : () ), junk_status => 1,
            },
            $args
        );
        \@c;
    };

    require MT::Promise;
    my $ctx = $tmpl->context;
    $ctx->stash( 'comments', MT::Promise::delay($comments) );
}

sub generate_dashboard_stats_comment_tab {
    my $app = shift;
    my ($tab) = @_;

    my $blog_id = $app->blog ? $app->blog->id : 0;
    my $user    = $app->user;
    my $user_id = $user->id;

    my $cmt_class = $app->model('comment');
    my $terms = { visible => 1 };
    $terms->{blog_id} = $blog_id if $blog_id;
    my $args = {
        group => [
            "extract(year from created_on)",
            "extract(month from created_on)",
            "extract(day from created_on)"
        ],
    };

    require MT::Util;
    my @ts = MT::Util::offset_time_list( time - ( 121 * 24 * 60 * 60 ),
        $blog_id );
    my $earliest = sprintf(
        '%04d%02d%02d%02d%02d%02d',
        $ts[5] + 1900,
        $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ]
    );
    $terms->{created_on} = [ $earliest, undef ];
    $args->{range_incl}{created_on} = 1;

    if ( !$user->is_superuser && !$blog_id ) {
        $args->{join} = MT::Permission->join_on(
            undef,
            {   blog_id   => \'= comment_blog_id',
                author_id => $user_id
            },
        );
    }
    my $cmt_iter = $cmt_class->count_group_by( $terms, $args );

    my %counts;
    while ( my ( $count, $y, $m, $d ) = $cmt_iter->() ) {
        my $date = sprintf( "%04d%02d%02dT00:00:00", $y, $m, $d );
        $counts{$date} = $count;
    }

    %counts;
}

sub _build_favorite_websites_data {
    my $app     = shift;
    my ($param) = @_;
    my $user    = $app->user;

    # Load user's favorite websites.
    my $class        = $app->model('website');
    my @fav_websites = @{ $user->favorite_websites || [] };
    my $fav_count    = scalar @fav_websites;
    my %args;
    $args{join}
        = MT::Permission->join_on( 'blog_id',
        { author_id => $user->id, permissions => { not => "'comment'" } } )
        if !$user->is_superuser && $param->{remove_no_perms};
    my @websites;
    @websites
        = $class->load( { class => 'website', id => \@fav_websites }, \%args )
        if $fav_count;

    @websites = grep {
        my $website  = $_;
        my $has_perm = 0;
        foreach my $id ( $website->id, map { $_->id } @{ $website->blogs } ) {
            if ( $user->has_perm($id) ) {
                $has_perm = 1;
                last;
            }
        }
        $has_perm;
    } @websites;
    $fav_count = @websites;

    # Append accessible websites if user has 4 or more blogs.
    if ( scalar @websites < 10 ) {
        my $auth = $app->user or return;
        my %args;
        my %terms;
        $args{join} = MT::Permission->join_on( 'blog_id',
            { author_id => $user->id, permissions => { not => "'comment'" } }
            )
            if !$auth->is_superuser
            && !$auth->permissions(0)->can_do('edit_templates')
            && !$auth->permissions(0)->can_do('create_blog');
        $args{limit}  = 10 - $fav_count;
        $terms{class} = 'website';
        $terms{id}    = { not => \@fav_websites } if $fav_count;
        my @ws = $class->load( \%terms, \%args );
        push @websites, @ws if @ws;
    }
    return undef if !scalar @websites;

    my @website_ids = map { $_->id } @websites;

    # Object count
    my %data;
    if ( !$param->{not_count} ) {
        require MT::Blog;
        my $iter = MT::Blog->count_group_by(
            {   class     => 'blog',
                parent_id => \@website_ids,
            },
            {   group => ['parent_id'],
                join  => $app->model('permission')->join_on(
                    'blog_id',
                    {   author_id   => $user->id,
                        permissions => { not => "'comment'" }
                    }
                )
            }
        );
        while ( my ( $count, $parent_id ) = $iter->() ) {
            $data{$parent_id}->{blog_count} = $count;
        }

        require MT::Entry;
        my $entry_iter = MT::Entry->count_group_by(
            {   class   => 'entry',
                blog_id => \@website_ids,
                $param->{my_posts} ? ( author_id => $user->id ) : (),
            },
            { group => ['blog_id'], }
        );
        while ( my ( $count, $blog_id ) = $entry_iter->() ) {
            $data{$blog_id}->{entry_count} = $count;
        }

        require MT::Page;
        my $page_iter = MT::Page->count_group_by(
            {   class   => 'page',
                blog_id => \@website_ids,
                $param->{my_posts} ? ( author_id => $user->id ) : (),
            },
            { group => ['blog_id'], }
        );
        while ( my ( $count, $blog_id ) = $page_iter->() ) {
            $data{$blog_id}->{page_count} = $count;
        }

        require MT::Comment;
        my $commnet_iter = MT::Comment->count_group_by(
            { blog_id => \@website_ids, },
            {   group => ['blog_id'],
                join  => $app->model('entry')->join_on(
                    undef,
                    {   id => \'=comment_entry_id',
                        $param->{my_posts} ? ( author_id => $user->id ) : (),
                    },
                ),
            }
        );
        while ( my ( $count, $blog_id ) = $commnet_iter->() ) {
            $data{$blog_id}->{comment_count} = $count;
        }
    }

    # Make object_loop data
    require MT::Permission;

    # Sort by recently access
    my $i;
    my %sorted = map { $_ => $i++ } @fav_websites;
    foreach (@websites) {
        $sorted{ $_->id } = scalar @websites if !exists $sorted{ $_->id };
    }
    @websites
        = sort { ( $sorted{ $a->id } || 0 ) <=> ( $sorted{ $b->id } || 0 ) }
        @websites;

    my $blog_perms
        = MT::Permission->load_permissions_from_action('access_to_blog_list');
    my $blog_perms_terms = ();
    if ($blog_perms) {
        foreach my $perm (@$blog_perms) {
            $perm =~ m/\.(.*)/;
            push @$blog_perms_terms, '-or' if $blog_perms_terms;
            push @$blog_perms_terms, { permissions => { like => "%'$1'%" } };
        }
    }

    my @param;
    foreach my $website (@websites) {
        my $row;
        $row->{website_name}        = $website->name;
        $row->{website_id}          = $website->id;
        $row->{website_url}         = $website->site_url;
        $row->{website_description} = $website->description;

        require MT::Theme;
        ( $row->{website_theme_thumb} )
            = $website->theme
            ? $website->theme->thumbnail( size => 'small' )
            : MT::Theme->default_theme_thumbnail( size => 'small' );

        if ( !$param->{not_count} ) {
            $row->{website_blog_count} = $data{ $website->id }->{blog_count};
            $row->{website_entry_count}
                = $data{ $website->id }->{entry_count};
            $row->{website_page_count} = $data{ $website->id }->{page_count};
            $row->{website_comment_count}
                = $data{ $website->id }->{comment_count};
        }

        my $perms = $user->permissions( $website->id );
        $row->{can_access_to_entry_list} = 1
            if ( $perms && $perms->can_do('access_to_entry_list') );
        $row->{can_access_to_template_list} = 1
            if ( $perms && $perms->can_do('access_to_template_list') );
        $row->{can_access_to_page_list} = 1
            if ( $perms && $perms->can_do('access_to_page_list') );
        $row->{can_access_to_blog_setting_screen} = 1
            if ( $perms && $perms->can_do('access_to_blog_config_screen') );
        $row->{can_create_new_entry} = 1
            if ( $perms && $perms->can_do('create_new_entry') );
        $row->{can_create_new_page} = 1
            if ( $perms && $perms->can_do('create_new_page') );
        $row->{can_apply_theme} = 1
            if ( $perms && $perms->can_do('apply_theme') );
        $row->{can_access_to_comment_list} = 1
            if ( $user->is_superuser ) || $perms->can_do('view_feedback');
        $row->{can_use_tools_search} = 1
            if ( $perms && $perms->can_do('use_tools:search') );

        my $blog_perms_cnt = MT::Permission->count(
            [   {   blog_id => [
                        0, $website->id,
                        map { $_->id } @{ $website->blogs }
                    ],
                    author_id => $user->id,
                },
                '-and',
                $blog_perms_terms,
            ]
        );

        $row->{can_access_to_blog_list} = 1
            if $blog_perms_cnt;

        my @num_vars = qw(
            website_entry_count website_blog_count website_page_count website_comment_count
        );
        map { $row->{$_} = 0 if !defined $row->{$_} } @num_vars;
        push @param, $row;
    }

    return \@param;
}

sub _build_favorite_blogs_data {
    my $app     = shift;
    my ($param) = @_;
    my $user    = $app->user;

    my $permission_join_on = undef;
    if (   !$user->is_superuser
        && !$user->permissions(0)->can_do('edit_templates') )
    {
        $permission_join_on = MT::Permission->join_on(
            'blog_id',
            {   author_id   => $user->id,
                permissions => { not => "'comment'" }
            }
        );
    }

    # Load user's favorite blogs.
    my $class     = $app->model('blog');
    my @fav_blogs = @{ $user->favorite_blogs || [] };
    my $fav_count = scalar @fav_blogs;
    my @blogs;
    @blogs = $class->load(
        {   class => 'blog',
            id    => \@fav_blogs,
            (   $app->blog && !$app->blog->is_blog
                ? ( parent_id => $app->blog->id )
                : ()
            ),
        },
        { ( $permission_join_on ? ( 'join' => $permission_join_on ) : () ), },
    ) if $fav_count;

    # Append accessible blogs if favorite blogs is under 10;
    if ( scalar @blogs < 10 ) {
        my %args;
        my %terms;
        $args{join}       = $permission_join_on if $permission_join_on;
        $args{limit}      = 10 - @blogs;
        $terms{class}     = 'blog';
        $terms{parent_id} = $app->blog->id
            if $app->blog && !$app->blog->is_blog;
        $terms{id} = { not => \@fav_blogs } if $fav_count;
        my @tmp_blogs = $class->load( \%terms, \%args );
        push @blogs, @tmp_blogs if @tmp_blogs;
    }
    return undef if !scalar @blogs;

    my @blog_ids = map { $_->id } @blogs;

    # Object count
    my %data;
    if ( !$param->{not_count} ) {
        require MT::Entry;
        my $iter = MT::Entry->count_group_by(
            {   class   => 'entry',
                blog_id => \@blog_ids,
                $param->{my_posts} ? ( author_id => $user->id ) : (),
            },
            { group => ['blog_id'], }
        );
        while ( my ( $count, $blog_id ) = $iter->() ) {
            $data{$blog_id}->{entry_count} = $count;
        }

        require MT::Page;
        my $page_iter = MT::Page->count_group_by(
            {   class   => 'page',
                blog_id => \@blog_ids,
                $param->{my_posts} ? ( author_id => $user->id ) : (),
            },
            { group => ['blog_id'], }
        );
        while ( my ( $count, $blog_id ) = $page_iter->() ) {
            $data{$blog_id}->{page_count} = $count;
        }

        require MT::Comment;
        my $commnet_iter = MT::Comment->count_group_by(
            { blog_id => \@blog_ids, },
            {   group => ['blog_id'],
                $param->{my_posts}
                ? ( join => $app->model('entry')->join_on(
                        undef,
                        {   id        => \'=comment_entry_id',
                            author_id => $user->id,
                        },
                    )
                    )
                : (),
            }
        );
        while ( my ( $count, $blog_id ) = $commnet_iter->() ) {
            $data{$blog_id}->{comment_count} = $count;
        }
    }

    # Make object_loop data
    require MT::Permission;

    # Sort by recently access
    my $i;
    my %sorted = map { $_ => $i++ } @fav_blogs;
    foreach (@blogs) {
        $sorted{ $_->id } = scalar @blogs if !exists $sorted{ $_->id };
    }
    @blogs
        = sort { ( $sorted{ $a->id } || 0 ) <=> ( $sorted{ $b->id } || 0 ) }
        @blogs;

    my @param;
    foreach my $blog (@blogs) {
        next unless $blog->website;

        my $row;
        $row->{blog_name}        = $blog->name;
        $row->{blog_id}          = $blog->id;
        $row->{blog_url}         = $blog->site_url;
        $row->{blog_description} = $blog->description;

        require MT::Theme;
        ( $row->{blog_theme_thumb} )
            = $blog->theme
            ? $blog->theme->thumbnail( size => 'small' )
            : MT::Theme->default_theme_thumbnail( size => 'small' );

        if ( !$param->{not_count} ) {
            $row->{blog_entry_count}   = $data{ $blog->id }->{entry_count};
            $row->{blog_page_count}    = $data{ $blog->id }->{page_count};
            $row->{blog_comment_count} = $data{ $blog->id }->{comment_count};
        }

        my $website = $blog->website;
        $row->{website_name} = $website->name;
        $row->{website_id}   = $website->id;

        my $perms = $user->permissions( $blog->id );
        $row->{can_access_to_template_list} = 1
            if ( $perms && $perms->can_do('access_to_template_list') );
        $row->{can_create_new_entry} = 1
            if ( $perms && $perms->can_do('create_new_entry') );
        $row->{can_access_to_website} = 1
            if $user->permissions( $blog->parent_id );
        $row->{can_access_to_entry_list} = 1
            if ( $perms && $perms->can_do('access_to_entry_list') );
        $row->{can_access_to_page_list} = 1
            if ( $perms && $perms->can_do('access_to_page_list') );
        $row->{can_apply_theme} = 1
            if ( $perms && $perms->can_do('apply_theme') );
        $row->{can_access_to_comment_list} = 1
            if ( $user->is_superuser ) || $perms->can_do('view_feedback');
        $row->{can_access_to_blog_setting_screen} = 1
            if ( $perms && $perms->can_do('access_to_blog_config_screen') );
        $row->{can_use_tools_search} = 1
            if ( $perms && $perms->can_do('use_tools:search') );
        my @num_vars = qw(
            blog_entry_count blog_page_count blog_comment_count
        );
        map { $row->{$_} = 0 if !defined $row->{$_} } @num_vars;

        push @param, $row;
    }

    return \@param;
}

sub site_stats_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    if ( $param->{blog_id} ) {
        if ( !$app->user->is_superuser ) {
            my $perm = MT::Permission->load(
                {   author_id   => $app->user->id,
                    blog_id     => $param->{blog_id},
                    permissions => { not => "'comment'" }
                }
            );
            $param->{no_permission} = 1
                unless $perm;
        }
    }
    else {
        # Load favorite websites data
        my $websites = _build_favorite_websites_data( $app,
            { not_count => 1, remove_no_perms => 1 } );
        foreach my $website (@$websites) {
            my $row;
            $row->{id}   = $website->{website_id};
            $row->{name} = $website->{website_name};
            push @{ $param->{object_loop} }, $row;
        }

        # Load favorite blogs data
        my $blogs = _build_favorite_blogs_data( $app, { not_count => 1 } );
        foreach my $blog (@$blogs) {
            my $row;
            $row->{id}   = $blog->{blog_id};
            $row->{name} = $blog->{blog_name};
            push @{ $param->{object_loop} }, $row;
        }

        my $loop_count
            = defined $param->{object_loop} ? @{ $param->{object_loop} } : 0;
        if ( $loop_count > 1 ) {
            @{ $param->{object_loop} }
                = sort { $a->{name} cmp $b->{name} }
                @{ $param->{object_loop} };
            $param->{blog_id} = $param->{object_loop}->[0]->{id};
        }
        elsif ( $loop_count >= 1 ) {
            $param->{blog_id} = $param->{object_loop}->[0]->{id};
            $param->{name}    = $param->{object_loop}->[0]->{name};
            delete $param->{object_loop};
        }
        else {
            $param->{no_permission} = 1;
        }
    }

    generate_site_stats_data( $app, $param )
        or return
        unless $param->{no_permission};

    $param;
}

sub generate_site_stats_data {
    my $app     = shift;
    my ($param) = @_;
    my $user    = $app->user;
    my $blog_id = $param->{blog_id};
    my $perms   = $app->user->permissions($blog_id)
        or return $app->error( $app->translate("No permissions") );

    my $cache_time = 60 * MT->config('StatsCacheTTL');   # cache for x minutes
    my $stats_static_path = create_stats_directory( $app, $param ) or return;

    my $file = "data_" . $blog_id . ".json";
    $param->{stat_url} = $stats_static_path . '/' . $file;
    my $path = File::Spec->catfile( $param->{support_path}, $file );

    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    my $time;
    $time = $fmgr->file_mod_time($path) if -f $path;

    # Get readied provider
    require MT::App::DataAPI;
    my $blog = $app->model('blog')->load($blog_id);
    my $provider = readied_provider( $app, $blog );
    if ($provider) {
        $param->{provider} = $provider;
    }

    # Get Registry
    my $line_settings
        = $app->registry( 'applications', 'cms', 'site_stats_lines' );

    # Judge force purge cache
    my $force_purge_cache = 0;
    my $present_lines     = MT::Request->instance->cache('site_stats_lines');
    unless ($present_lines) {
        if ( $fmgr->exists($path) ) {
            my $file = $fmgr->get_data( $path, 'output' );
            $file =~ s/widget_site_stats_draw_graph\((.*)\);/$1/;
            my $data;
            eval { $data = MT::Util::from_json($file) };
            $present_lines = $data->{reg_keys} if $data;
            MT::Request->instance->cache( 'site_stats_lines', $present_lines )
                if $present_lines;
        }
    }
    if ($present_lines) {
        my $present_count = @$present_lines;
        my $reg_count     = keys %$line_settings;
        if ( $present_count != $reg_count ) {
            $force_purge_cache = 1;
        }
        else {
            foreach my $reg_key ( keys %$line_settings ) {
                my $match = grep { $_ eq $reg_key } @$present_lines;
                $force_purge_cache = 1 unless $match;
            }
        }
    }

    if (   $force_purge_cache
        || ( lc( MT->config('StatsCachePublishing') ) eq 'off' )
        || (   ( lc( MT->config('StatsCachePublishing') ) eq 'onload' )
            && ( !$time || ( time - $time > $cache_time ) ) )
        )
    {
        # Preparing dates of ten days ago.
        require MT::Util;
        my @ten_days_ago_tl
            = MT::Util::offset_time_list( time - ( 10 * 24 * 60 * 60 ),
            $blog_id );

        # Preparing date array
        my @dates;
        for ( my $i = 9; $i >= 0; $i-- ) {
            my @timelist
                = MT::Util::offset_time_list( time - ( $i * 24 * 60 * 60 ),
                $blog_id );
            my $date = sprintf( '%04d-%02d-%02d',
                $timelist[5] + 1900,
                $timelist[4] + 1,
                @timelist[ 3, 2, 1, 0 ] );
            push @dates, $date;
        }

        my @maxes;
        my @counts;
        my @labels;
        my $pv_today;
        my $pv_yesterday;
        my @reg_keys;

        foreach my $key ( keys %$line_settings ) {
            push @reg_keys, $key;

            my $sub          = @counts;
            my $line_setting = $line_settings->{$key};
            if ( my $condition = $line_setting->{condition} ) {
                $condition = MT->handler_to_coderef($condition);
                next unless $condition->( $app, $param );
            }
            my $handler = $line_setting->{handler} || $line_setting->{code};
            $handler = MT->handler_to_coderef($handler);
            if ($handler) {
                $counts[$sub] = $handler->( $app, \@ten_days_ago_tl, $param )
                    or return;
                $maxes[$sub] = 0;
                foreach my $key ( keys %{ $counts[$sub] } ) {
                    $maxes[$sub] = $counts[$sub]->{$key}
                        if $maxes[$sub] < $counts[$sub]->{$key};
                }
                $labels[$sub] = $line_setting->{hlabel}
                    || $app->translate('Not configured');

                if ( $counts[$sub] && $key eq 'count_pageviews' ) {
                    $pv_today     = $counts[$sub]->{ $dates[9] };
                    $pv_yesterday = $counts[$sub]->{ $dates[8] };
                }
            }
        }

        my $max_sub = 0;
        for ( my $i = 0; $i <= $#maxes; $i++ ) {
            $max_sub = $i if $maxes[$max_sub] < $maxes[$i];
        }
        my @rate;
        for ( my $i = 0; $i <= $#maxes; $i++ ) {
            if ( $i == $max_sub ) {
                push @rate, 1;
            }
            else {
                my $rate = $maxes[$i] ? $maxes[$max_sub] / $maxes[$i] : 1;
                push @rate, $rate;
            }
        }

        my $result;
        foreach my $date (@dates) {
            my %row1 = ( x => $date );
            my @row2;
            for ( my $i = 0; $i <= $#counts; $i++ ) {
                my $count
                    = $counts[$i]->{$date}
                    ? $counts[$i]->{$date} * $rate[$i]
                    : 0;
                my $sub = $i ? $i : '';
                $row1{ 'y' . $sub } = $count;

                my %row = (
                    label => $labels[$i],
                    count => defined $counts[$i]->{$date}
                    ? $counts[$i]->{$date}
                    : 0,
                );
                push @row2, \%row;
            }
            push @{ $result->{graph_data} }, \%row1;
            push @{ $result->{hover_data}{data} }, \@row2;
        }
        $result->{pv_today}        = $pv_today;
        $result->{pv_yesterday}    = $pv_yesterday;
        $result->{reg_keys}        = \@reg_keys;
        $result->{can_edit_config} = 1
            if $perms->can_do('edit_config')
            || $perms->can_do('set_publish_paths')
            || $perms->can_do('administer_blog')
            || $perms->can_do('administer');

        $fmgr->put_data(
            'widget_site_stats_draw_graph('
                . MT::Util::to_json($result) . ');',
            $path
        );
    }

    delete $param->{provider};

    1;
}

sub regenerate_site_stats_data {
    my $app = shift;
    $app->validate_magic() or return;

    my $param;
    $param->{blog_id} = $app->param('blog_id');

    generate_site_stats_data( $app, $param ) or return;

    my $result = { stat_url => $param->{stat_url} };
    return $app->json_result($result);
}

sub site_stats_widget_lines {
    my $app = shift;
    my $pkg = 'MT::CMS::Dashboard::';

    my $site_stats_lines = {
        count_entries => {
            hlabel  => 'Entry',
            handler => "${pkg}site_stats_widget_entrycount_lines",
        },
        count_pageviews => {
            hlabel    => 'Page Views',
            condition => "${pkg}site_stats_widget_pageview_condition",
            handler   => "${pkg}site_stats_widget_pageview_lines",
        },
    };

    return $site_stats_lines;
}

sub site_stats_widget_entrycount_lines {
    my $app = shift;
    my ( $ten_days_ago_tl, $param ) = @_;

    # Get Entry Counts
    my $entry_class = $app->model('entry');
    my $terms       = { status => MT::Entry::RELEASE() };
    my $args        = {
        group => [
            "extract(year from authored_on)",
            "extract(month from authored_on)",
            "extract(day from authored_on)"
        ],
    };

    my $earliest = sprintf(
        '%04d%02d%02d%02d%02d%02d',
        $ten_days_ago_tl->[5] + 1900, $ten_days_ago_tl->[4] + 1,
        $ten_days_ago_tl->[3],        $ten_days_ago_tl->[2],
        $ten_days_ago_tl->[1],        $ten_days_ago_tl->[0],
    );
    $terms->{authored_on} = [ $earliest, undef ];
    $args->{range_incl}{authored_on} = 1;

    $terms->{blog_id} = $param->{blog_id};

    my $entry_iter = $entry_class->count_group_by( $terms, $args );
    my %counts;
    while ( my ( $count, $y, $m, $d ) = $entry_iter->() ) {
        my $date = sprintf( "%04d-%02d-%02d", $y, $m, $d );
        $counts{$date} = $count;
    }
    return \%counts;
}

sub site_stats_widget_pageview_condition {
    my $app = shift;
    my ($param) = @_;

    return $param->{provider} ? 1 : 0;
}

sub site_stats_widget_pageview_lines {
    my $app = shift;
    my ( $ten_days_ago_tl, $param ) = @_;

    my $blog_id = $param->{blog_id};

    # Get readied provider
    my $provider = $param->{provider};

    # Get PVs
    my $ten_days_ago = sprintf( '%04d-%02d-%02d',
        $ten_days_ago_tl->[5] + 1900,
        $ten_days_ago_tl->[4] + 1,
        $ten_days_ago_tl->[3],
    );
    my @ts = MT::Util::offset_time_list( time, $blog_id );
    my $today = sprintf( '%04d-%02d-%02d',
        $ts[5] + 1900,
        $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ] );
    my $for_date = $provider->pageviews_for_date(
        $app,
        {   startDate => $ten_days_ago,
            endDate   => $today,
        }
    ) or return undef;

    my @items = @{ $for_date->{items} };
    my %counts;
    foreach my $item (@items) {
        $counts{ $item->{date} } = $item->{pageviews};
    }
    return \%counts;
}

1;
