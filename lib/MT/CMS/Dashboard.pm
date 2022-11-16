# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Dashboard;

use strict;
use warnings;
use MT::version;
use MT::Util
    qw( ts2epoch epoch2ts encode_html relative_date offset_time format_ts );
use MT::Stats qw(readied_provider);
use MT::I18N qw( const );

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
        $app->translate(
            'Error: This child site does not have a parent site.')
    ) if $blog && $blog->is_blog && !$blog->website;

    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');

    if ( ( defined $blog_id && $blog_id eq '0' )
        && !( $user && $user->can_do('access_to_system_dashboard') ) )
    {
        return $app->return_to_user_dashboard( permission => 1 );
    }

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
    return $app->load_tmpl( 'dashboard/dashboard.tmpl', $param );
}

sub mt_news_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    my $content = get_newsbox_content($app) || '';
    my $json;
    eval { $json = MT::Util::from_json($content) };
    if ( !$content || $@ ) {

        # Maybe not a json
        $param->{news_html} = $content;
        $param->{news_html}
            =~ s/class="button"/class="button btn btn-default"/;
    }
    else {
        $param->{news_json}       = 1;
        $param->{news_json_news}  = $json->{news} if $json->{news};
        $param->{news_json_links} = $json->{links} if $json->{links};
    }
}

sub get_newsbox_content {
    my $app         = shift;
    my $newsbox_url = $app->config('NewsboxURL');
    if ( $newsbox_url && $newsbox_url ne 'disable' ) {
        return MT::Util::get_newsbox_html( $newsbox_url, 'NW' );
    }
    return q();
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

sub site_stats_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    my $user = $app->user;
    my $site = $app->blog;
    return unless $site;
    return
        unless $user->has_perm( $site->id )
        || $user->is_superuser;

    generate_site_stats_data( $app, $param );

    return $param;
}

sub generate_site_stats_data {
    my $app     = shift;
    my ($param) = @_;
    my $user    = $app->user;
    my $blog    = $app->blog;
    my $blog_id = $blog->id;
    my $perms   = $app->user->permissions($blog_id);

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
    my $provider = readied_provider( $app, $blog );
    $param->{provider} = $provider
        if $provider;

    # Load type of stats from registry
    my $line_settings
        = $app->registry( 'applications', 'cms', 'site_stats_lines' );

    # Reload stats data when type of stats was changed
    my $force_reload = 0;
    if ( scalar $app->param('reload') ) {
        $force_reload = 1;
    }
    else {
        my $present_lines = MT::Request->instance->cache('site_stats_lines');
        unless ($present_lines) {
            if ( $fmgr->exists($path) ) {
                my $file = $fmgr->get_data( $path, 'output' );
                $file =~ s/widget_site_stats_draw_graph\((.*)\);/$1/;
                my $data;
                eval { $data = MT::Util::from_json($file) };
                $present_lines = $data->{reg_keys} if $data;
                MT::Request->instance->cache( 'site_stats_lines',
                    $present_lines )
                    if $present_lines;
            }
        }
        if ($present_lines) {
            my $present_count = @$present_lines;
            my $reg_count     = keys %$line_settings;
            if ( $present_count != $reg_count ) {
                $force_reload = 1;
            }
            else {
                foreach my $reg_key ( keys %$line_settings ) {
                    my $match = grep { $_ eq $reg_key } @$present_lines;
                    $force_reload = 1 unless $match;
                }
            }
        }
    }

    if (   $force_reload
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
                $timelist[3] );
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
                my $temp_cnt = $handler->( $app, \@ten_days_ago_tl, $param )
                    or next;
                $counts[$sub] = $temp_cnt;
                $maxes[$sub]  = 0;
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
            || $perms->can_do('administer_site')
            || $perms->can_do('administer');
        $result->{error} = $app->errstr if $app->errstr;

        $fmgr->put_data(
            'widget_site_stats_draw_graph('
                . MT::Util::to_json($result) . ');',
            $path
        );
    }

    delete $param->{provider};
    $param->{stats_provider} = $provider->id if $provider;

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
        count_pageviews => {
            hlabel    => 'Page Views',
            condition => "${pkg}site_stats_widget_pageview_condition",
            handler   => "${pkg}site_stats_widget_pageview_lines",
        },
    };

    return $site_stats_lines;
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
    my $today
        = sprintf( '%04d-%02d-%02d', $ts[5] + 1900, $ts[4] + 1, $ts[3] );
    my $for_date = $provider->pageviews_for_date(
        $app,
        {   startDate => $ten_days_ago,
            endDate   => $today,
        }
    ) or return undef;

    my @items = @{ $for_date->{items} };
    my @headers = @{ $for_date->{headers} ? $for_date->{headers} : ['date', 'pageviews'] };
    my %counts;
    foreach my $item (@items) {
        $counts{ $item->{$headers[0]} } = $item->{$headers[1]};
    }
    return \%counts;
}

sub notification_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;
    my $user = $app->user;

    require MT::Session;
    if ( scalar $app->param('reload') ) {

        # Force reload, purge cache if exists
        my $cache = MT->model('session')->load(
            {   id   => 'Notification messages',
                kind => 'DW',
            }
        );
        $cache->remove if $cache;
    }
    else {
        # Check cache
        my $ttl   = MT->config('NotificationCacheTTL');
        my $cache = MT::Session::get_unexpired_value(
            $ttl,
            {   id   => 'Notification messages',
                kind => 'DW',
            }
        );

        if ($cache) {
            require MT::Serialize;
            my $data = MT::Serialize->unserialize( $cache->data() );
            $param->{loop_notification_dashboard} = $$data;
            return;
        }
    }

    my @messages = ();
    my $trail_msg
        = ' '
        . $app->translate(
        'Please contact your Movable Type system administrator.');

    # Verify write permission for support directory and its subdirectories.
    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    my $support_path;
    my $has_uploads_path;
    foreach my $subdir (qw( uploads userpics )) {
        $support_path
            = File::Spec->catdir( $app->support_directory_path, $subdir );
        if ( !$fmgr->exists($support_path) ) {
            $fmgr->mkpath($support_path);
        }
        if (   $fmgr->exists($support_path)
            && $fmgr->can_write($support_path) )
        {
            $has_uploads_path = 1;
        }
    }
    unless ( $has_uploads_path || $fmgr->exists($support_path) ) {

        # the path didn't exist - change the warning a little
        $support_path = $app->support_directory_path;
    }
    unless ($has_uploads_path) {
        my $message = {
            level => 'warning',
            text => $app->translate('The support directory is not writable.'),
        };
        if ( $user && $user->is_superuser ) {
            $message->{detail} = $app->translate(
                'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.',
                $support_path
            );
        }
        else {
            $message->{text} .= $trail_msg;
        }
        push @messages, $message;
    }

    # Verify an image driver can be used.
    if ( $app->request('image_driver_error') ) {
        my $message = {
            level => 'warning',
            text  => $app->translate('ImageDriver is not configured.'),
        };
        if ( $user && $user->is_superuser ) {
            $message->{detail}
                = $app->translate(
                'An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Graphics::Magick, Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.'
                );
        }
        else {
            $message->{text} .= $trail_msg;
        }
        push @messages, $message;
    }

    # Verify system email address.
    unless ( $app->config('EmailAddressMain') ) {
        my $message = {
            level => 'warning',
            text =>
                $app->translate('System Email Address is not configured.'),
        };
        if ( $user && $user->is_superuser ) {
            $message->{detail} = $app->translate(
                q{The System Email Address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events. Please confirm your <a href="[_1]">settings.</a>},
                $app->uri(
                    mode => 'cfg_system_general',
                    args => { blog_id => 0 }
                )
            );
        }
        else {
            $message->{text} .= $trail_msg;
        }
        push @messages, $message;
    }

    # Verify SSL verification mode.
    my $has_mozilla_ca = eval { require Mozilla::CA; 1 };
    unless ( $app->config('SSLVerifyNone') || $has_mozilla_ca ) {
        my $message = {
            level => 'warning',
            text  => $app->translate('Cannot verify SSL certificate.'),
        };
        if ( $user && $user->is_superuser ) {
            $message->{detail}
                = $app->translate(
                'Please install Mozilla::CA module. Writing "SSLVerifyNone 1" in mt-config.cgi can hide this warning, but this is not recommended.'
                );
        }
        else {
            $message->{text} .= $trail_msg;
        }
        push @messages, $message;
    }
    elsif ( $app->config('SSLVerifyNone') && $has_mozilla_ca ) {
        my $message = {
            level => 'warning',
            text  => $app->translate(
                'Can verify SSL certificate, but verification is disabled.'),
        };
        if ( $user && $user->is_superuser ) {
            $message->{detail}
                = $app->translate(
                'You should remove "SSLVerifyNone 1" in mt-config.cgi.');
        }
        else {
            $message->{text} .= $trail_msg;
        }
        push @messages, $message;
    }

    # Notification center callback
    $app->run_callbacks( 'set_notification_dashboard', \@messages );

    # Make a cache
    require MT::Serialize;
    my $ser   = MT::Serialize->serialize( \\@messages );
    my $cache = MT->model('session')->new;
    $cache->set_values(
        {   id    => 'Notification messages',
            kind  => 'DW',
            data  => $ser,
            start => time,
        }
    );
    $cache->save;

    $param->{loop_notification_dashboard} = \@messages;
}

sub system_information_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    require MT::Session;
    if ( scalar $app->param('reload') ) {

        # Force reload, purge cache if exists
        my $cache = MT->model('session')->load(
            {   id   => 'System Information',
                kind => 'DW',
            }
        );
        $cache->remove if $cache;
    }
    else {
        # Check cache
        my $ttl   = 24 * 60 * 60;                       # 24 hours
        my $cache = MT::Session::get_unexpired_value(
            $ttl,
            {   id   => 'System Information',
                kind => 'DW',
            }
        );

        if ($cache) {
            $param->{'active_users'} = $cache->get('active_users');
            $param->{'total_sites'}  = $cache->get('total_sites');
            $param->{'total_content_types'}
                = $cache->get('total_content_types');
            $param->{'server_model'} = $cache->get('server_model');
            return;
        }
    }

    # Count MT Native User
    my $author_class = $app->model('author');
    $param->{active_users} = $author_class->count(
        {   type   => MT::Author::AUTHOR(),
            status => MT::Author::ACTIVE(),
        }
    );

    # Count Sites (Parent and child)
    my $site_class = $app->model('blog');
    $param->{total_sites}
        = $site_class->count( { class => '*' } );

    # Count Content Types
    my $ct_class = $app->model('content_type');
    $param->{total_content_types} = $ct_class->count();

    # Server model
    if ( $ENV{MOD_PERL} ) {
        $param->{server_model} = 'mod_perl';
    }
    elsif ( $ENV{FAST_CGI} ) {
        $param->{server_model} = 'FastCGI';
    }
    elsif ( $ENV{'psgi.version'} ) {
        $param->{server_model} = 'PSGI';
    }
    else {
        $param->{server_model} = 'CGI';
    }

    # Make a cache
    my $cache = MT->model('session')->new;
    $cache->set_values(
        {   id    => 'System Information',
            kind  => 'DW',
            start => time,
        }
    );
    $cache->set( 'active_users',        $param->{active_users} );
    $cache->set( 'total_sites',         $param->{total_sites} );
    $cache->set( 'total_content_types', $param->{total_content_types} );
    $cache->set( 'server_model',        $param->{server_model} );
    $cache->save;
}

sub activity_log_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    my $blog    = $app->blog || undef;

    my $terms;
    my $args;
    if ($blog_id) {
        $param->{site_view} = 1;
        $terms->{blog_id}   = $blog_id;
        if ( !$user->permissions($blog_id)->can_do('view_blog_log') ) {
            $terms->{author_id} = $user->id;
        }
    }
    else {
        if ( !$user->permissions(0)->can_do('view_log') ) {
            $terms->{author_id} = $user->id;
        }
    }
    $terms->{class} = '*';
    $args = {
        limit => 5,
        sort  => [
            { column => 'created_on', desc => 'DESC', },
            { column => 'id',         desc => 'DESC' },
        ],
    };

    my $is_relative
        = ( $user->date_format || 'relative' ) eq 'relative' ? 1 : 0;
    my $site_view = $blog ? 1 : 0;

    my $log_class  = MT->model('log');
    my $blog_class = MT->model('blog');
    my $iter       = $log_class->load_iter( $terms, $args );
    my @logs;
    my %blogs;
    while ( my $log = $iter->() ) {
        my $row = {
            log_message => $log->message,
            id          => $log->id,
            blog_id     => $log->blog_id,
        };
        if ( $log->blog_id ) {
            $row->{can_view_site_log}
                = $user->permissions( $log->blog_id )->can_do('view_blog_log')
                ? 1
                : 0;
            if ( !$row->{can_view_site_log} ) {
                $row->{can_access_site}
                    = $user->permissions( $log->blog_id ) ? 1 : 0;
            }
        }
        if ( my $ts = $log->created_on ) {
            ## All Log records are saved with GMT, so do trick here.
            my $epoch = ts2epoch( undef, $ts, 1 )
                ;    # just get epoch with "no_offset" option
            $epoch = offset_time( $epoch, ( $blog || undef ) )
                ;    # from GMT to Blog( or system ) Timezone
            $ts = epoch2ts( ( $blog || undef ), $epoch, 1 )
                ;    # back to timestamp
            $row->{created_on_timestamp} = MT::Util::format_ts( '%Y-%m-%d %H:%M:%S', $ts );
            if ($site_view) {
                $row->{created_on_formatted}
                    = $is_relative
                    ? MT::Util::relative_date( $ts, time, $blog )
                    : format_ts(
                    MT::App::CMS::LISTING_DATETIME_FORMAT(),
                    epoch2ts( $blog, ts2epoch( undef, $ts ) ),
                    $blog,
                    $user ? $user->preferred_language : undef
                    );
            }
            else {
                $row->{created_on_formatted}
                    = $is_relative
                    ? MT::Util::relative_date( $ts, time, undef )
                    : format_ts(
                    MT::App::CMS::LISTING_DATETIME_FORMAT(),
                    $ts,
                    undef,
                    $user ? $user->preferred_language : undef
                    );
            }

            if ( $log->blog_id ) {
                $blog = $blogs{ $log->blog_id }
                    ||= $blog_class->load( $log->blog_id, { cache_ok => 1 } );
                $row->{site_name} = $blog ? $blog->name : '';
            }
            else {
                $row->{site_name} = $app->translate('System');
            }
        }

        push @logs, $row;
    }

    $param->{logs} = \@logs;
}

sub site_list_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    my $user = $app->user;
    my $blog = $app->blog || undef;

    my $site_builder = sub {
        my $site             = shift;
        my $user_permissions = $user->permissions($site);
        return if !$user->is_superuser and !$user_permissions;

        my $row;

        # basic information
        $row->{site_name} = $site->name;
        $row->{parent_site_name}
            = $site->is_blog && $site->website ? $site->website->name : '';
        $row->{site_url} = $site->site_url;
        $row->{blog_id}  = $site->id;

        # Action link
        $row->{can_edit_template} =
            $user->is_superuser                                  ? 1
          : $user_permissions->can_do('access_to_template_list') ? 1
          :                                                        0;
        $row->{can_edit_config} =
            $user->is_superuser                                  ? 1
          : $user_permissions->can_do('open_blog_config_screen') ? 1
          :                                                        0;

        $row->{can_create_post} =
            $user->is_superuser                      ? 1
          : $user_permissions->can_do('create_post') ? 1
          :                                            0;
        $row->{can_access_to_entry_list} =
            $user->is_superuser                               ? 1
          : $user_permissions->can_do('access_to_entry_list') ? 1
          :                                                     0;
        $row->{can_manage_pages} =
            $user->is_superuser                       ? 1
          : $user_permissions->can_do('manage_pages') ? 1
          :                                             0;

        if (   $row->{can_create_post} == 1
            || $row->{can_access_to_entry_list} == 1 )
        {
            $row->{permitted_entry} = 1;
        }

        # Recent post
        my $MAX_POSTS = 3;
        my @recent;
        my $terms = {
            author_id => $user->id,
            blog_id   => $site->id,
        };
        my $args = {
            limit     => $MAX_POSTS,
            sort      => 'created_on',
            direction => 'descend',
        };

        # Recent post - Content Data
        my $cd_class = MT->model('content_data');
        my $cd_args  = {
            %{$args},
            join => $app->model('content_type')
                ->join_on( undef, { id => \'= cd_content_type_id' }, ),
        };
        my $cd_iter = $cd_class->load_iter( $terms, $cd_args );
        my $is_relative
            = ( $app->user->date_format || 'relative' ) eq 'relative' ? 1 : 0;
        while ( my $p = $cd_iter->() ) {
            my $obj_name;
            if ( my $ct = $p->content_type ) {
                $obj_name = $ct->name;
            }
            else {
                $obj_name = MT->translate('Unknown Content Type');
            }

            my $item;
            $item->{site_id}         = $site->id;
            $item->{id}              = $p->id;
            $item->{object_type}     = 'content_data';
            $item->{subtype}         = 'content_data_' . $p->content_type_id;
            $item->{content_type_id} = $p->content_type_id;
            $item->{object_name}     = $obj_name;
            $item->{title}
                = $p->label || MT->translate( 'No Label (ID:[_1])', $p->id );

            if ( my $ts = $p->created_on ) {
                $item->{epochtime} = ts2epoch( undef, $ts );
                $item->{created_on_formatted}
                    = $is_relative
                    ? MT::Util::relative_date( $ts, time, $site )
                    : format_ts(
                    MT::App::CMS::LISTING_DATETIME_FORMAT(),
                    epoch2ts( $site, ts2epoch( undef, $ts ) ),
                    $site,
                    $user ? $user->preferred_language : undef
                    );
            }
            push @recent, $item;
        }

        # Recent post - Entry
        if ( $MAX_POSTS > scalar @recent ) {
            my $entry_class = MT->model('entry');
            $args->{limit} = $MAX_POSTS - scalar @recent;

            my $entry_iter = $entry_class->load_iter( $terms, $args );
            while ( my $p = $entry_iter->() ) {
                my $item;
                $item->{site_id}     = $site->id;
                $item->{id}          = $p->id;
                $item->{title}       = $p->title;
                $item->{object_name} = $p->class_label;
                $item->{object_type} = 'entry';

                if ( my $ts = $p->created_on ) {
                    $item->{epochtime} = ts2epoch( undef, $ts );
                    $item->{created_on_formatted}
                        = $is_relative
                        ? MT::Util::relative_date( $ts, time, $site )
                        : format_ts(
                        MT::App::CMS::LISTING_DATETIME_FORMAT(),
                        epoch2ts( $site, ts2epoch( undef, $ts ) ),
                        $site,
                        $user ? $user->preferred_language : undef
                        );
                }
                push @recent, $item;
            }
        }

        # Recent post - Page
        if ( $MAX_POSTS > scalar @recent ) {
            my $page_class = MT->model('page');
            $args->{limit} = $MAX_POSTS - scalar @recent;

            my $page_iter = $page_class->load_iter( $terms, $args );
            while ( my $p = $page_iter->() ) {
                my $item;
                $item->{site_id}     = $site->id;
                $item->{id}          = $p->id;
                $item->{title}       = $p->title;
                $item->{object_name} = $p->class_label;
                $item->{object_type} = 'page';

                if ( my $ts = $p->created_on ) {
                    $item->{epochtime} = ts2epoch( undef, $ts );
                    $item->{created_on_formatted}
                        = $is_relative
                        ? MT::Util::relative_date( $ts, time, $site )
                        : format_ts(
                        MT::App::CMS::LISTING_DATETIME_FORMAT(),
                        epoch2ts( $site, ts2epoch( undef, $ts ) ),
                        $site,
                        $user ? $user->preferred_language : undef
                        );
                }
                push @recent, $item;
            }
        }

        if (@recent) {
            @recent
                = reverse sort { $a->{epochtime} <=> $b->{epochtime} }
                @recent;
            $row->{recent_post} = \@recent;
        }

        # Content Type list
        my @content_types;
        my $ct_class = MT->model('content_type');
        my $ct_iter = $ct_class->load_iter(
            { blog_id => $site->id, },
            {
                sort      => 'name',
                direction => 'ascend',
                fetchonly => { id => 1, name => 1, unique_id => 1, }
            }
        );

        while ( my $ct = $ct_iter->() ) {
            my $item;
            $item->{name} = $ct->name;
            $item->{can_create}
                = $user_permissions->can_do( "create_new_content_data_" . $ct->unique_id )
                || $user_permissions->can_do('create_new_content_data')
                ? 1
                : 0;
            $item->{can_list}
                = $user_permissions->can_do(
                "access_to_content_data_list_" . $ct->unique_id )
                || $user_permissions->can_do('access_to_content_data_list')
                ? 1
                : 0;
            $item->{type_id}         = 'content_data_' . $ct->id;
            $item->{content_type_id} = $ct->id;

            push @content_types, $item
                if $item->{can_create} or $item->{can_list};
        }
        $row->{content_types} = \@content_types;

        return $row;
    };

    # Load sites
    my @sites;
    if ($blog) {
        if ( $blog->is_blog ) {
            my $row = $site_builder->($blog);
            push @sites, $row if $row;
        }
        else {
            # Parent site
            my $row = $site_builder->($blog);
            push @sites, $row if $row;

            # Children
            for my $child ( @{ $blog->blogs } ) {
                next
                  unless MT::Permission->count(
                    {
                        author_id => $user->id,
                        blog_id   => $child->id,
                    }
                  )
                  || $user->is_superuser
                  || $user->permissions(0)->can_do('edit_templates');

                my $row = $site_builder->($child);
                push @sites, $row if $row;
            }
        }
    }
    else {
        # from recent access
        if ( my @recent = @{ $user->favorite_sites || [] } ) {
            for my $site_id (@recent) {
                next
                  unless MT::Permission->count(
                    {
                        author_id   => $user->id,
                        blog_id     => $site_id,
                    }
                  )
                  || $user->is_superuser
                  || $user->permissions(0)->can_do('edit_templates');

                my $site = MT->model('website')->load($site_id);
                next unless $site;

                my $row = $site_builder->($site);
                push @sites, $row if $row;
            }
        }
        else {
            # User have no recent access list.
            # Try to load site list from permission table.
            my @accessible = MT->model('blog')->load(
                { class => '*', },
                {   join => MT::Permission->join_on(
                        'blog_id',
                        {   author_id   => $user->id,
                            permissions => { not => "'comment'" }
                        }
                    ),
                    sort => [
                        { column => 'class',      desc => 'DESC' },
                        { column => 'created_on', desc => 'DESC' }
                    ],
                }
            );

            if (!@accessible
                and (  $user->is_superuser
                    or $user->permissions(0)->can_do('edit_templates') )
                )
            {
                #  No permission record? Okay loading from blog table
                # if user is system administrator or having 'edit_template'
                # for system. Otherwise, shown message.
                @accessible = MT->model('blog')->load(
                    { class => '*', },
                    {   limit => 10,
                        sort  => [
                            { column => 'class',      desc => 'DESC' },
                            { column => 'created_on', desc => 'DESC' }
                        ],
                    }
                );
            }

            for my $site (@accessible) {
                my $row = $site_builder->($site);
                push @sites, $row if $row;
            }
        }
    }

    $param->{sites} = \@sites;
}

sub updates_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    if ( $app->config('DisableVersionCheck') ) {
        $param->{disable_version_check} = 1;
        return;
    }

    # Update check
    require MT::Session;
    my $version_info;
    my $use_cache;
    if ( $app->param('reload') ) {

        # Force reload, purge cache if exists
        my $cache = MT->model('session')->load(
            {   id   => 'Update Check',
                kind => 'DW',
            }
        );
        $cache->remove if $cache;
    }
    else {
        # Check cache
        my $ttl   = 4 * 60 * 60;                        # 4 hours
        my $cache = MT::Session::get_unexpired_value(
            $ttl,
            {   id   => 'Update Check',
                kind => 'DW',
            }
        );

        if ($cache) {
            $version_info->{version}  = $cache->get('version');
            $version_info->{news_url} = $cache->get('news_url');
            $use_cache                = 1;
        }
    }

    if ( !$version_info ) {

        # Read available version data from site.
        my $ua = MT->new_ua( { timeout => 10 } );
        if ( !$ua ) {
            $param->{update_check_failed} = 1;
            return;
        }

        my $version_url = const('LATEST_VERSION_URL');
        my $req         = new HTTP::Request( GET => $version_url );
        my $resp        = $ua->request($req);
        my $result      = $resp->content();
        if ( !$resp->is_success() || !$result ) {
            $param->{update_check_failed} = 1;
            return;
        }

        $version_info = MT::Util::from_json($result);
    }

    if ($version_info) {
        my $mt_version;
        my $latest_version;
        eval {
            $mt_version     = MT::version->parse( MT->version_id );
            $latest_version = MT::version->parse( $version_info->{version} );
        };
        if ( !$@ ) {
            if ( $latest_version > $mt_version ) {
                $param->{available_version} = $version_info->{version};
                $param->{available_release_version}
                    = $version_info->{release_version};
                $param->{news_url} = $version_info->{news_url};
            }

            if ( !$use_cache ) {

                # Make a cache
                my $cache = MT->model('session')->new;
                $cache->set_values(
                    {   id    => 'Update Check',
                        kind  => 'DW',
                        start => time,
                    }
                );
                $cache->set( 'version', $version_info->{version} );
                $cache->set( 'release_version',
                    $version_info->{release_version} );
                $cache->set( 'news_url', $version_info->{news_url} );
                $cache->save;
            }
        }
    }
}

1;
