# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::ActivityFeeds;

use strict;
use warnings;
use base 'MT::App';
use MT::Author qw(AUTHOR);
use MT::ContentStatus;
use MT::Util qw(perl_sha1_digest_hex ts2epoch epoch2ts ts2iso iso2ts
    encode_html encode_url encode_xml);
use HTTP::Date qw(time2isoz str2time time2str);

sub id {'feeds'}

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->{template_dir} = 'feeds';
    $app->{is_admin}     = 1;
    $app->init_core_callbacks();
}

sub init_request {
    my $app = shift;
    $app->SUPER::init_request(@_);
    $app->{requires_login} = 1;
}

# Defines the basic MT activity feeds.
sub init_core_callbacks {
    my $app = shift;

    MT->_register_core_callbacks(
        {   'ActivityFeed.system' => \&_feed_system,
            'ActivityFeed.blog'   => \&_feed_blog,
            'ActivityFeed.debug'  => \&_feed_debug,
            'ActivityFeed.entry'  => \&_feed_entry,
            'ActivityFeed.page'   => \&_feed_page,

            # Alias
            'ActivityFeed.log' => \&_feed_system,

            # Filter
            'ActivityFeed.filter_object.entry' => \&_filter_entry,
            'ActivityFeed.filter_object.page'  => \&_filter_page,

            # Content Data
            $app->_generate_content_data_callbacks,
        }
    );
}

sub _generate_content_data_callbacks {
    require MT::ContentType;
    my %callbacks;
    my $iter = MT::ContentType->load_iter;
    while ( my $ct = $iter->() ) {
        my $cd_name = 'content_data_' . $ct->id;
        $callbacks{"ActivityFeed.${cd_name}"} = \&_feed_content_data;
        $callbacks{"ActivityFeed.filter_object.${cd_name}"}
            = \&_filter_content_data;
        $ct->generate_object_log_class;
    }
    %callbacks;
}

# authenticate with user package using the web services password instead
# of the normal user password. also note that we're not messing with user
# session records, since we aren't setting a login cookie for feeds.
sub login {
    my $app      = shift;
    my $username = $app->param('username');
    my $token    = $app->param('token');

    my $user_class = $app->{user_class};
    eval "use $user_class;";
    return $app->error(
        $app->translate( "Error loading [_1]: [_2]", $user_class, $@ ) )
        if $@;
    my $author = $user_class->load( { name => $username, type => AUTHOR } );
    if (   $author
        && $author->is_active
        && ( ( $author->api_password || '' ) ne '' ) )
    {
        my $auth_token
            = perl_sha1_digest_hex( 'feed:' . $author->api_password );
        if ( $token eq $auth_token ) {
            $app->user($author);
            return ($author);
        }
    }
    (undef);
}

# A place to store session data for activity feeds.
sub session {
    my $app  = shift;
    my $sess = $app->{session};
    if ( @_ && $sess ) {
        my $setting = shift;
        return @_ ? $sess->set( $setting, @_ ) : $sess->get($setting);
    }
    elsif ($sess) {
        return $sess;
    }

    my $user = $app->user;
    return undef unless $user;

    my $part1 = $user->id;
    my $part2 = $app->query_string;

    # creates an 80-character id that uniquely identifies an individual
    # feed in the session table.
    my $id = perl_sha1_digest_hex($part1) . perl_sha1_digest_hex($part2);

    require MT::Session;
    $sess = MT::Session->load( { id => $id, kind => 'AF' } );
    if ( !$sess ) {
        $sess = new MT::Session;
        $sess->id($id);
        $sess->start(time);
        $sess->kind('AF');
    }
    $app->{session} = $sess;

    if (@_) {
        my $setting = shift;
        return @_ ? $sess->set( $setting, @_ ) : $sess->get($setting);
    }

    return $sess;
}

# Default mode of MT::App::ActivityFeeds; uses the 'view' parameter to
# differentiate between the different types of feeds available. Feed
# data is populated by callback, so plugins can intercept the feed
# elements if so desired, or can append things to a feed as well.
sub mode_default {
    my $app = shift;
    my $view = $app->param('view') || 'system';

    eval {

        # clean up view parameter; simple ascii only
        $view =~ s/[^A-Za-z_0-9-]//g;

        # Give the Task Manager layer a chance to run.
        MT->run_tasks() if $app->config->ActivityFeedsRunTasks;

        my $feed = undef;
        MT->run_callbacks( "ActivityFeed.$view", $app, $view, \$feed );
        if ( defined $feed ) {
            my $last_update;
            if ( $feed
                =~ m!<updated>(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z)</updated>!
                )
            {
                $last_update = time2str( str2time($1) );
            }
            my $mod_since = $app->get_header('If-Modified-Since');
            $app->{no_print_body} = 1;
            if (   $last_update
                && $mod_since
                && ( str2time($last_update) <= str2time($mod_since) ) )
            {
                $app->response_code(304);
                $app->response_message('Not Modified');
                $app->send_http_header("application/atom+xml");
            }
            else {
                $app->set_header( 'Last-Modified', $last_update )
                    if $last_update;
                $app->send_http_header("application/atom+xml");
                $app->print_encode($feed);
            }
        }
        else {
            die MT->errstr;
        }
    };
    if ( my $err = $@ ) {
        return $app->error(
            $app->translate(
                "An error occurred while generating the activity feed: [_1].",
                $err
            )
        );
    }
}

# Generic log to feed; limit using $terms; returns the feed content
sub process_log_feed {
    my $app = shift;
    my ( $terms, $param ) = @_;

    my %templates;
    my $max_items = $app->config('ActivityFeedItemLimit');

    my $static_path = $app->static_path;
    if ( $static_path =~ m!^/! ) {
        $static_path = $app->base . $static_path;
    }
    my $last_mod = $app->get_header('If-Modified-Since');
    if ($last_mod) {
        $last_mod = epoch2ts( undef, str2time($last_mod) );
    }

    my $host = $app->base;
    $host =~ s!^https?://!!;
    my $path  = $app->mt_uri;
    my $token = $app->param('token');

    require MT::Log;
    my $cfg  = $app->config;
    my $iter = MT::Log->load_iter( $terms,
        { 'sort' => 'id', 'direction' => 'descend' } );
    my $count = 0;
    my $res   = '';
    my @entries;
    my $last_ts;
    my $last_ts_blog;
    my %blogs;
    my $blog;
    my $log_view_url = $app->base
        . $app->mt_uri( mode => 'list', args => { '_type' => 'log' } );

    while ( my $log = $iter->() ) {
        if ( $log->blog_id ) {
            $blog = $blogs{ $log->blog_id }
                ||= MT::Blog->load( $log->blog_id );
        }
        else {
            $blog = undef;
        }

        # establish blog for permission to_hash
        $app->blog($blog);
        my $item = $log->to_hash;

        # Filtering
        my $ret
            = MT->run_callbacks( "ActivityFeed.filter_object." . $log->class,
            $app, $item );
        next unless defined $ret && $ret;

        my $ts = $item->{'log.created_on'};
        last if $last_mod && ( $ts < $last_mod );

        if ( !defined($last_ts) or ( $ts gt $last_ts ) ) {
            $last_ts      = $ts;
            $last_ts_blog = $blog;
        }
        my $ts_iso = time2isoz( ts2epoch( undef, $ts ) );
        $ts_iso =~ s/ /T/;
        $item->{'log.created_on_iso'} = $ts_iso;
        my $id = $item->{'log.id'};
        my $year = substr( $ts, 0, 4 );
        $item->{'log.permalink'}
            = encode_xml( $log_view_url . '&filter=id&filter_val=' . $id );
        $item->{'log.atom_id'} = qq{tag:$host,$year:$path/$id};
        $item->{'log.message'}
            = entity_translate( encode_html( $item->{'log.message'}, 1 ) );
        my $class = $log->class || 'system';

        if ( $class =~ /^content_data_/ ) {
            $class = 'content_data';
        }

        if ( !$templates{$class} ) {
            $templates{$class} = $app->load_tmpl("feed_$class.tmpl")
                || $app->load_tmpl("feed_system.tmpl");
        }
        else {
            $templates{$class}->clear_params();
            $app->set_default_tmpl_params( $templates{$class} );
        }

        # make sure this is an absolute url
        $item->{mt_url}     = $app->base . $app->mt_uri;
        $item->{static_uri} = $static_path;
        $item->{feed_token} = $token;
        my $out = $app->build_page( $templates{$class}, $item )
            or die $app->errstr;
        push @entries, { entry => $out };
        $count++;
        last if $last_mod && ( $ts < $last_mod );
        last if $count == $max_items;
    }
    my $chrome_tmpl = $app->load_tmpl('feed_chrome.tmpl');
    $param->{loop_entries} = \@entries;
    my $str = qq();
    for my $key ( $app->multi_param ) {
        my $value = $app->param($key);
        $value = '' unless defined $value;
        $str .= "&amp;" . encode_url($key) . "=" . encode_url($value);
    }
    $str =~ s/^&amp;(.+)$/?$1/;
    $param->{feed_self}    = $app->base . $app->path . $app->script . $str;
    $param->{feed_atom_id} = $app->base . $app->uri;
    $param->{feed_updated_iso} = time2isoz( ts2epoch( undef, $last_ts ) );
    $param->{feed_updated_iso} =~ s/ /T/;
    $param->{mt_url}     = $app->base . $app->mt_uri;
    $param->{static_uri} = $static_path;
    $param->{feed_token} = $token;

    if ( !defined $last_ts ) {

        # set to current timestamp?
    }
    $app->build_page( $chrome_tmpl, $param );
}

sub entity_translate {
    my ($str) = @_;
    $str =~ s/&lt;/&#60;/g;
    $str =~ s/&gt;/&#62;/g;
    $str =~ s/&amp;/&#38;/g;
    $str =~ s/&quot;/&#34;/g;
    $str =~ s/&apos;/&#39;/g;
    $str;
}

# Takes the parameters given and translates them into MT::Log-compatible
# terms used to filter the dataset.
sub apply_log_filter {
    my $app = shift;
    my ($param) = @_;
    my %arg;
    if ($param) {
        my $filter_col = $param->{filter};
        my $val        = $param->{filter_val};
        if ( $filter_col && $val ) {
            if ( $filter_col eq 'level' ) {
                my @types;
                for ( 1, 2, 4, 8, 16 ) {
                    push @types, $_ if $val & $_;
                }
                if (@types) {
                    $arg{'level'} = \@types;
                }
            }
            elsif ( $filter_col eq 'class' ) {
                if ( $val eq 'publish' ) {
                    $arg{category} = 'publish';
                }
                else {
                    if ( $val =~ m/,/ ) {
                        $arg{class} = [ split /,/, $val ];
                    }
                    else {
                        $arg{class} = $val;
                    }
                }
            }
        }
        $arg{blog_id} = [ split /,/, $param->{blog_id} ]
            if $param->{blog_id};
    }
    \%arg;
}

sub _feed_entry {
    my ( $cb, $app, $view, $feed ) = @_;

    my $user = $app->user;

    require MT::Blog;
    my $blog;

    # verify user has permission to view entries for given weblog
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        if ( !$user->is_superuser ) {
            require MT::Permission;
            my $perm = MT::Permission->load(
                { author_id => $user->id, blog_id => $blog_id } );
            return $cb->error( $app->translate("No permissions.") )
                unless ( $perm && $perm->can_do('get_entry_feed') );
        }

        $blog = MT::Blog->load($blog_id) or return;
    }
    else {
        if ( !$user->is_superuser ) {

       # limit activity log view to only weblogs this user has permissions for
            my @perms = MT::Permission->load( { author_id => $user->id } );
            return $cb->error( $app->translate("No permissions.") )
                unless @perms;
            my @blog_list = map { $_->blog_id }
                grep { $_->can_do('get_entry_feed') } @perms;
            $blog_id = join ',', @blog_list;
        }
    }

    my $link = $app->base
        . $app->mt_uri(
        mode => 'list',
        args => {
            '_type' => 'entry',
            ( $blog ? ( blog_id => $blog_id ) : () )
        }
        );
    my $param = {
        feed_link  => $link,
        feed_title => $blog
        ? $app->translate( '[_1] Entries', $blog->name )
        : $app->translate("All Entries")
    };

    # user has permissions to view this type of feed... continue
    my $terms = $app->apply_log_filter(
        {   filter     => 'class',
            filter_val => 'entry',
            $blog_id ? ( blog_id => $blog_id ) : (),
        }
    );
    $$feed = $app->process_log_feed( $terms, $param );
}

sub _feed_blog {
    my ( $cb, $app, $view, $feed ) = @_;

    my $user = $app->user;

    # verify user has permission to view blogs for given weblog
    my $blog_id = $app->param('blog_id');

    require MT::Blog;
    my $blog;

    if ($blog_id) {
        if ( !$user->is_superuser ) {
            require MT::Permission;
            my $perm = MT::Permission->load(
                { author_id => $user->id, blog_id => $blog_id } );
            return $cb->error( $app->translate("No permissions.") )
                unless ( $perm && $perm->can_do('get_blog_feed') );
        }

        $blog = MT::Blog->load($blog_id) or return;
    }
    else {
        if ( !$user->is_superuser ) {

       # limit activity log view to only weblogs this user has permissions for
            my @perms = MT::Permission->load( { author_id => $user->id } );
            return $cb->error( $app->translate("No permissions.") )
                unless @perms;
            my @blog_list = map { $_->blog_id }
                grep { $_->can_do('get_blog_feed') } @perms;
            $blog_id = join ',', @blog_list;
        }
    }

    my $link;
    if ($blog) {
        $link = $app->base
            . $app->mt_uri(
            mode => 'show_menu',
            args => { blog_id => $blog_id }
            );
    }
    else {
        $link = $app->base . $app->mt_uri( mode => 'system_list_blogs' );
    }
    my $param = {
        feed_link  => $link,
        feed_title => $blog
        ? $app->translate( '[_1] Activity', $blog->name )
        : $app->translate("All Activity")
    };

    # user has permissions to view this type of feed... continue
    my $terms = $app->apply_log_filter(
        {   filter     => 'class',
            filter_val => 'entry,comment,ping',
            $blog_id ? ( blog_id => $blog_id ) : ()
        }
    );
    $$feed = $app->process_log_feed( $terms, $param );
}

sub _feed_system_check_permission {
    my ( $cb, $app, $blog_id_ref ) = @_;

    # verify user has permission to view logs for given weblog
    my $blog_id = $$blog_id_ref;
    my $user    = $app->user;

    return 1 if $user->is_superuser;
    return 1 if $app->can_do('get_all_system_feed');

    if ($blog_id) {
        my @blog_ids = ($blog_id);
        my $blog     = MT->model('blog')->load($blog_id)
            or return $cb->error( $app->translate("Invalid request.") );
        if ( !$blog->is_blog ) {
            push @blog_ids, map { $_->id } @{ $blog->blogs };
        }

        my $iter = MT->model('permission')
            ->load_iter( { author_id => $user->id, blog_id => \@blog_ids } );

        my @allowed_blog_ids;
        while ( my $p = $iter->() ) {
            push @allowed_blog_ids, $p->blog_id
                if $p->can_do('get_system_feed');
        }

        return $cb->error( $app->translate("No permissions.") )
            unless @allowed_blog_ids;

        $$blog_id_ref = join ',', @allowed_blog_ids;
    }
    elsif ( !$user->can_do( 'export_blog_log', at_least_one => 1 ) ) {
        return $cb->error( $app->translate("No permissions.") );
    }
    return 1;
}

sub _feed_system {
    my ( $cb, $app, $view, $feed ) = @_;

    my $user       = $app->user;
    my $blog_id    = $app->param('blog_id');
    my $filter     = $app->param('filter');
    my $filter_val = $app->param('filter_val');

    return unless _feed_system_check_permission( $cb, $app, \$blog_id );

    my $args = {};
    unless ( $filter && $filter_val ) {
        $filter     = 'class';
        $filter_val = '*';
    }
    $args->{filter}     = $filter;
    $args->{filter_val} = $filter_val;

    if ($blog_id) {
        $args->{blog_id} = $blog_id;
    }
    else {
        unless ( $app->can_do('get_all_system_feed') ) {
            my $iter = MT->model('permission')
                ->load_iter( { author_id => $user->id, } );
            my $blog_ids;
            while ( my $p = $iter->() ) {
                push @$blog_ids, $p->blog_id
                    if $p->can_do('export_blog_log');
            }
            $args->{blog_id} = join ',', @$blog_ids;
        }
    }
    $args->{_type} = 'log';
    my $link = $app->base . $app->mt_uri( mode => 'list', args => $args );
    my $param = {
        feed_link  => $link,
        feed_title => $app->translate('Movable Type System Activity')
    };
    my $terms = $app->apply_log_filter($args);
    $$feed = $app->process_log_feed( $terms, $param );
}

sub _feed_debug {
    my ( $cb, $app, $view, $feed ) = @_;

    my $user = $app->user;
    return unless $app->can_do('get_debug_feed');
    my $blog_id = $app->param('blog_id');
    my $args    = {
        'filter'     => 'class',
        'filter_val' => 'debug',
        $blog_id ? ( blog_id => $blog_id ) : (),
        '_type' => 'log',
    };
    my $terms = $app->apply_log_filter($args);
    my $link  = $app->base . $app->mt_uri( mode => 'list', args => $args );
    my $param = {
        feed_link  => $link,
        feed_title => $app->translate('Movable Type Debug Activity'),
    };
    $$feed = $app->process_log_feed( $terms, $param );
}

sub _feed_page {
    my ( $cb, $app, $view, $feed ) = @_;

    my $user = $app->user;

    require MT::Blog;
    my $blog;

    # verify user has permission to view pages for given weblog
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        my $blog_ids;
        $blog = MT->model('blog')->load($blog_id)
            or return $cb->error( $app->translate("Invalid request.") );
        if ( !$blog->is_blog ) {
            push @$blog_ids, map { $_->id } @{ $blog->blogs };
        }
        push @$blog_ids, $blog_id;

        my $iter = MT->model('permission')
            ->load_iter( { author_id => $user->id, blog_id => $blog_ids } );

        $blog_ids = ();
        while ( my $p = $iter->() ) {
            push @$blog_ids, $p->blog_id
                if $p->can_do('get_page_feed');
        }

        return $cb->error( $app->translate("No permissions.") )
            unless $blog_ids;

        $blog_id = join ',', @$blog_ids;
    }
    else {
        if ( !$user->is_superuser ) {

       # limit activity log view to only weblogs this user has permissions for
            my @perms = MT::Permission->load( { author_id => $user->id } );
            return $cb->error( $app->translate("No permissions.") )
                unless @perms;
            my @blog_list = map { $_->blog_id }
                grep { $_->can_do('get_page_feed') } @perms;
            $blog_id = join ',', @blog_list;
        }
    }

    my $link = $app->base
        . $app->mt_uri(
        mode => 'list',
        args => {
            '_type' => 'page',
            ( $blog ? ( blog_id => $blog_id ) : () )
        }
        );
    my $param = {
        feed_link  => $link,
        feed_title => $blog
        ? $app->translate( '[_1] Pages', $blog->name )
        : $app->translate("All Pages")
    };

    # user has permissions to view this type of feed... continue
    my $terms = $app->apply_log_filter(
        {   filter     => 'class',
            filter_val => 'page',
            $blog_id ? ( blog_id => $blog_id ) : (),
        }
    );
    $$feed = $app->process_log_feed( $terms, $param );
}

sub _feed_content_data {
    my ( $cb, $app, $view, $feed ) = @_;

    my $user = $app->user;

    my $blog;

    # verify user has permission to view content data for given site
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        if ( !$user->is_superuser ) {
            my $perm = MT->model('permission')
                ->load( { author_id => $user->id, blog_id => $blog_id } );
            return $cb->error( $app->translate("No permissions.") )
                unless ( $perm && $perm->can_do("get_${view}_feed") )
                ;    # TODO: fix permission
        }

        $blog = MT->model('blog')->load($blog_id) or return;
    }
    else {
        if ( !$user->is_superuser ) {

       # limit activity log view to only weblogs this user has permissions for
            my @perms
                = MT->model('permission')->load( { author_id => $user->id } );
            return $cb->error( $app->translate("No permissions.") )
                unless @perms;
            my @blog_list = map { $_->blog_id }
                grep { $_->can_do("get_${view}_feed") }
                @perms;    # TODO: fix permission
            $blog_id = join ',', @blog_list;
        }
    }

    my ($content_type_id) = $view =~ /content_data_(\d+)/;
    my $content_type = MT->model('content_type')->load($content_type_id);

    my $link = $app->base
        . $app->mt_uri(
        mode => 'list',
        args => {
            '_type' => $view,
            ( $blog ? ( blog_id => $blog_id ) : () )
        }
        );
    my $param = {
        feed_link  => $link,
        feed_title => $blog
        ? $app->translate( '[_1] "[_2]" Content Data',
            $blog->name, $content_type->name )
        : $app->translate( 'All "[_1]" Content Data', $content_type->name )
    };

    # user has permissions to view this type of feed... continue
    my $terms = $app->apply_log_filter(
        {   filter     => 'class',
            filter_val => $view,
            $blog_id ? ( blog_id => $blog_id ) : (),
        }
    );
    $$feed = $app->process_log_feed( $terms, $param );
}

sub _filter_entry {
    my ( $cb, $app, $item ) = @_;
    my $user = $app->user;

    return 0 if !exists $item->{'log.entry.id'};

    my $entry = MT->model('entry')->load( $item->{'log.entry.id'} )
        or return 0;

    my $own  = $entry->author_id == $user->id;
    my $perm = $user->permissions( $entry->blog_id )
        or return 0;

    if (   !$app->can_do('get_all_system_feed')
        && !$perm->can_do('get_system_feed') )
    {
        return 0
            if !$own && !$perm->can_do('edit_all_entries');
    }

    $item->{'log.entry.can_edit'} = $perm->can_edit_entry( $entry, $user,
        ( $entry->status eq MT::Entry::RELEASE() ? 1 : () ) ) ? 1 : 0;
    $item->{'log.entry.can_change_status'}
        = $perm->can_do('publish_all_entry') ? 1
        : $own && $perm->can_do('publish_own_entry') ? 1
        :                                              0;

    return 1;
}

sub _filter_page {
    my ( $cb, $app, $item ) = @_;
    my $user = $app->user;

    return 0 if !exists $item->{'log.entry.id'};

    my $perm = $user->permissions( $item->{'log.entry.blog.id'} )
        or return 0;

    if (   !$app->can_do('get_all_system_feed')
        && !$perm->can_do('get_system_feed') )
    {
        return 0
            if !$perm->can_do('manage_pages');
    }

    $item->{'log.entry.can_edit'} = $perm->can_do('manage_pages') ? 1 : 0;
    $item->{'log.entry.can_change_status'}
        = $perm->can_do('manage_pages') ? 1 : 0;

    return 1;
}

sub _filter_content_data {
    my ( $cb, $app, $item ) = @_;
    my $user = $app->user;
    my $view = $app->param('view');

    return 0 if !exists $item->{'log.content_data.id'};

    my $content_data
        = MT->model('content_data')->load( $item->{'log.content_data.id'} )
        or return 0;

    my $own  = $content_data->author_id == $user->id;
    my $perm = $user->permissions( $content_data->blog_id )
        or return 0;

    if (   !$app->can_do('get_all_system_feed')
        && !$perm->can_do('get_system_feed') )
    {
        return 0
            if !$own
            && !$perm->can_do("edit_all_${view}");    # TODO: fix permission
    }

    $item->{'log.content_data.can_edit'}
        = $perm->can_edit_content_data( $content_data, $user ) ? 1 : 0;

    # TODO: fix permission
    $item->{'log.content_data.can_change_status'}
        = $perm->can_do("publish_all_${view}") ? 1
        : $own && $perm->can_do("publish_own_${view}") ? 1
        :                                                0;

    return 1;
}

1;
__END__

=head1 NAME

MT::App::ActivityFeeds

=head1 DESCRIPTION

Movable Type application for producing activity feeds. Activity feeds
are typically produced from the user's log table, but the application
relies heavily on the MT callback architecture for generating the
feed content.

Plugins can hook into these callbacks to either alter or supplement feed
content.

=head1 CALLBACKS

=over 4

=item ActivityFeed

=item ActivityFeed <view>

    callback($eh, $app, $view, $feed)

The ActivityFeed callback drives the generation of the feed.  The default
handler for this callback executes with a callback priority of 5.  Plugins
can register with a priority lower than 5 to prepend content to the feed
or a priority higher than 5 to append content to the feed (and also
manage elements that have already been added to the feed).

=back

=head1 METHODS

=head2 $app->init

Sets up the Activity Feed application, specifying the template directory
and defining the core activity feed callbacks.

=head2 $app->init_core_callbacks

Registers the core callbacks for the standard activity feeds.

=head2 $app->login

Method to override L<MT::App>->login to do token based authentication
for feed clients.

=head2 $app->mode_default

Default application mode handler that handles all feed requests.

=head2 $app->process_log_feed

Method that provides the respones for all core feed types that are based
on L<MT::Log> records.

=head2 $app->session

Provides a L<MT::Session> record where session-based data can be kept
for activity feed requests.

=head2 $app->feed_entry(\%param)

=over 4

=item title

=item published

=item updated

=item id

=item content

=item link

=item link_title

=item link_rel

=item link_type

=back

=head2 $app->feed_link(\%param)

This method creates a new "link" feed element that is used to assign
to a particular feed entry. The parameters you can supply in the param hashref
are:

=over 4

=item type - The MIME type of the link (defaults to "text/html").

=item rel - The link relationship (defaults to "alternate").

=item href (or 'link') - The URL of the link (required).

=item title - The title to use for the link (required).

=back

=head2 $app->feed_person(\%param)

This method creates a new "person" feed element that is used to assign
to a particular feed entry. The parameters you can supply in the param hashref
are:

=over 4

=item name - The name for the person (required).

=item uri - The URI of the person.

=item email - The email address of the person.

=back


=head2 $app->feed_properties($feed, \%param)

This method is used to assign the various properties of the feed. This
method is provided to abstract the interface to the underlying feed
implementation. The parameters you can supply in the param hashref are:

=over 4

=item link - The URL to use for the feed link.

=item link_type - The 'type' to assign to the feed link.

=item link_rel - The link relationship of the feed link.

=item link_title - The title to assign to the feed link.

=item title - The title to assign for the feed itself.

=back

=head2 entity_translate($str)

Changes common HTML named entities into numeric equivalents ('&lt;', '&gt;',
'&amp;', '&quot;', '&apos') for the CDATA blocks produced by the activity
feeds.

=head2 $app->apply_log_filter(\%params)

Returns a set of MT::Log load terms appropriate for the request parameters
provided through the \%params.

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
