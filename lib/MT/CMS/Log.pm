# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Log;

use strict;
use warnings;

use MT::Util
    qw( format_ts epoch2ts ts2epoch relative_date offset_time encode_url dirify encode_url );
use MT::I18N qw( const );

sub view {
    my $app     = shift;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
PERMCHECK: {
        if ($blog_id) {
            last PERMCHECK
                if $app->can_do('open_blog_log_screen');
        }
        last PERMCHECK
            if $app->can_do('open_system_log_screen');
        return $app->permission_denied();
    }

    my $log_class  = $app->model('log');
    my $blog_class = $app->model('blog');
    my $list_pref  = $app->list_pref('log');
    my $limit      = $list_pref->{rows};
    my $offset     = $app->param('offset') || 0;
    my %terms;
    my %args;
    my $cfg = $app->config;

    # Filtering by blog_id
    my $blog;
    $blog = $blog_class->load($blog_id) if $blog_id;
    if ($blog_id) {
        my $blog_ids = $app->_load_child_blog_ids($blog_id);
        push @$blog_ids, $blog_id;
        $terms{blog_id} = $blog_ids;
    }

    $args{sort}      = 'id';
    $args{direction} = 'descend';
    $args{offset}    = $offset;
    $args{limit}     = $limit;

    my %param = (%$list_pref);
    my ( $filter_col, $val );
    $param{filter_args} = "";
    my $filter_key = $app->param('filter_key') || '';

    if (   ( $filter_col = $app->param('filter') )
        && ( $val = $app->param('filter_val') ) )
    {
        $param{filter}     = $filter_col;
        $param{filter_val} = $val;
        my %filter_arg = %{ apply_log_filter( $app, \%param ) };
        $terms{$_} = $filter_arg{$_} foreach keys %filter_arg;
        $param{filter_args}
            = "&filter="
            . encode_url($filter_col)
            . "&filter_val="
            . encode_url($val);
    }
    elsif ($filter_key) {
        my $filters = $app->registry( "list_filters", "log" ) || {};
        if ( my $filter = $filters->{$filter_key} ) {
            if ( my $code = $filter->{code}
                || $app->handler_to_coderef( $filter->{handler} ) )
            {
                $param{filter_key}   = $filter_key;
                $param{filter_label} = $filter->{label};
                $code->( \%terms, \%args );
            }
        }
    }

    # all classes of log objects
    unless ( exists $terms{class} ) {
        $terms{class} = '*';
    }

    my $iter = $log_class->load_iter( \%terms, \%args );

    my @class_loop;
    my $labels = MT::Log->class_labels;
    foreach ( keys %$labels ) {
        next if $_ eq 'log';
        my $name = $_;
        $name =~ s/log\.(\w)/$1/;
        next unless $name;
        push @class_loop,
            {
            class_name  => $name,
            class_label => $labels->{$_},
            };
    }
    push @class_loop,
        {
        class_name  => 'comment,ping',
        class_label => $app->translate("All Feedback"),
        },
        {
        class_name  => 'search',
        class_label => $app->translate("Search"),
        },
        {
        class_name  => 'publish',
        class_label => $app->translate("Publishing"),
        };
    @class_loop
        = sort { $a->{class_label} cmp $b->{class_label} } @class_loop;
    $param{class_loop} = \@class_loop;

    my $log = build_log_table( $app, iter => $iter, param => \%param );
    my ($so);
    if ($blog) {
        $so = $blog->server_offset;
    }
    else {
        $so = $app->current_time_offset;
    }
    if ($so) {
        my $partial_hour_offset = 60 * abs( $so - int($so) );
        my $tz                  = sprintf( "%s%02d:%02d",
            $so < 0 ? '-' : '+',
            abs($so), $partial_hour_offset );
        $param{time_offset} = $tz;
    }
    $param{object_type}     = 'log';
    $param{search_label}    = $app->translate('Activity Log');
    $param{list_start}      = $offset + 1;
    $param{list_total}      = MT::Log->count( \%terms );
    $param{list_end}        = $offset + ( scalar @$log );
    $param{offset}          = $offset;
    $param{next_offset_val} = $offset + ( scalar @$log );
    $param{next_offset}
        = $param{next_offset_val} < $param{list_total} ? 1 : 0;
    $param{next_max}
        = $param{next_offset}
        ? int( $param{list_total} / $limit ) * $limit
        : 0;

    if ( $offset > 0 ) {
        $param{prev_offset}     = 1;
        $param{prev_offset_val} = $offset - $limit;
        $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
    }
    $param{'reset'}        = $app->param('reset');
    $param{nav_log}        = 1;
    $param{feed_name}      = $app->translate("System Activity Feed");
    $param{screen_class}   = "list-log";
    $param{screen_id}      = "list-log";
    $param{listing_screen} = 1;
    $param{feed_url}       = $app->make_feed_link( 'system',
        $blog_id ? { blog_id => $blog_id } : undef );

    if ( $param{feed_url} && $param{filter_args} ) {
        $param{feed_url} .= $param{filter_args};
    }
    $app->add_breadcrumb( $app->translate('Activity Log') );
    unless ( $app->param('blog_id') ) {
        $param{system_overview_nav} = 1;
    }
    $param{list_filters} = $app->list_filters('log');
    $app->load_tmpl( 'view_log.tmpl', \%param );
}

sub build_log_table {
    my $app = shift;
    my (%args) = @_;

    my $blog       = $app->blog;
    my $blog_view  = $blog && $blog->is_blog ? 1 : 0;
    my $blog_class = $app->model('blog');
    my $i          = 1;
    my @log;
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('log');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
    }
    return [] unless $iter;
    my $param = $args{param};
    my %blogs;

    # reusing comment length constant for log view
    my $break_len = const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_SHORT');
    while ( my $log = $iter->() ) {
        my $row = {
            log_message => $log->message,
            log_ip      => $log->ip,
            id          => $log->id,
            blog_id     => $log->blog_id
        };
        if ( my $ts = $log->created_on ) {
            ## All Log records are saved with GMT, so do trick here.
            my $epoch = ts2epoch( undef, $ts, 1 );
            $epoch = offset_time( $epoch, ( $blog || undef ) );
            $ts = epoch2ts( ( $blog || undef ), $epoch, 1 );
            if ($blog_view) {
                $row->{created_on_formatted} = format_ts(
                    MT::App::CMS::LISTING_DATETIME_FORMAT(),
                    epoch2ts( $blog, ts2epoch( undef, $ts ) ),
                    $blog,
                    $app->user ? $app->user->preferred_language : undef
                );
            }
            else {
                $row->{created_on_formatted} = format_ts(
                    MT::App::CMS::LISTING_DATETIME_FORMAT(),
                    epoch2ts( undef, offset_time( ts2epoch( undef, $ts ) ) ),
                    undef,
                    $app->user ? $app->user->preferred_language : undef
                );
                if ( $log->blog_id ) {
                    $blog = $blogs{ $log->blog_id }
                        ||= $blog_class->load( $log->blog_id,
                        { cache_ok => 1 } );
                    $row->{weblog_name} = $blog ? $blog->name : '';
                }
                else {
                    $row->{weblog_name} = '';
                }
            }
            $row->{created_on_relative} = relative_date( $ts, time );
            $row->{log_detail} = $log->description;
        }
        if ( my $uid = $log->author_id ) {
            my $user_class = $app->model('author');
            my $user       = $user_class->load($uid);
            $row->{username}
                = defined $user
                ? $user->name
                : $app->translate('(user deleted)');
        }
        $row->{object} = $log;
        push @log, $row;
    }
    return [] unless @log;
    $param->{object_loop} = $param->{log_table}[0]{object_loop} = \@log;
    \@log;
}

sub reset {
    my $app = shift;
    $app->validate_magic() or return;
    my $author    = $app->user;
    my $log_class = $app->model('log');
    my $args      = { 'reset' => 1, '_type' => 'log' };
    if ( my $blog_id = $app->param('blog_id') ) {
        my $blog_class = $app->model('blog');
        my $blog       = $blog_class->load($blog_id)
            or return $app->errtrans("Invalid request.");

        my $blogs;
        push @$blogs, $blog
            if $author->permissions( $blog->id )->can_do('reset_blog_log');
        if ( !$blog->is_blog ) {
            foreach my $b ( @{ $blog->blogs } ) {
                push @$blogs, $b
                    if $author->permissions( $b->id )
                    ->can_do('reset_blog_log');
            }
        }
        return $app->permission_denied()
            unless $blogs;

        foreach my $blog (@$blogs) {
            if ($log_class->remove( { blog_id => $blog->id, class => '*' } ) )
            {
                $app->log(
                    {   message => $app->translate(
                            "Activity log for blog '[_1]' (ID:[_2]) reset by '[_3]'",
                            $blog->name, $blog->id, $author->name
                        ),
                        level    => MT::Log::INFO(),
                        class    => 'system',
                        category => 'reset_log',
                        blog_id  => $blog->id,
                    }
                );
            }
        }
        $args->{'blog_id'} = $blog_id;
    }
    else {
        if ( $app->can_do('reset_system_log') ) {
            if ( $log_class->remove( { class => '*' } ) ) {
                $app->log(
                    {   message => $app->translate(
                            "Activity log reset by '[_1]'",
                            $author->name
                        ),
                        level    => MT::Log::INFO(),
                        class    => 'system',
                        category => 'reset_log'
                    }
                );
            }
        }
        else {
            my $iter = MT->model('permission')
                ->load_iter( { author_id => $author->id, } );
            my $blogs;
            while ( my $p = $iter->() ) {
                if ( $p->can_do('reset_blog_log') ) {
                    push @$blogs, $p->blog;
                }
            }
            return $app->permission_denied()
                unless $blogs;

            foreach my $blog (@$blogs) {
                if ($log_class->remove(
                        { blog_id => $blog->id, class => '*' }
                    )
                    )
                {
                    $app->log(
                        {   message => $app->translate(
                                "Activity log for blog '[_1]' (ID:[_2]) reset by '[_3]'",
                                $blog->name, $blog->id, $author->name
                            ),
                            level    => MT::Log::INFO(),
                            class    => 'system',
                            category => 'reset_log'
                        }
                    );
                }
            }
        }
        $args->{'blog_id'} = 0;
    }
    my $log_url = $app->uri( mode => 'list', args => $args );
    $app->redirect($log_url);
}

sub export {
    my $app       = shift;
    my $user      = $app->user;
    my $blog      = $app->blog;
    my $blog_view = $blog ? 1 : 0;
    my $blog_ids;

PERMCHECK: {
        if ($blog_view) {
            push @$blog_ids, $blog->id
                if $user->permissions( $blog->id )->can_do('export_blog_log');
            if ( !$blog->is_blog ) {
                foreach my $b ( @{ $blog->blogs } ) {
                    push @$blog_ids, $b->id
                        if $user->permissions( $b->id )
                        ->can_do('export_blog_log');
                }
            }
            last PERMCHECK if $blog_ids;
        }
        last PERMCHECK
            if $app->can_do('export_system_log');
        last PERMCHECK
            if $user->can_do( 'export_blog_log', at_least_one => 1 );
        return $app->permission_denied();
    }

    $app->validate_magic() or return;
    local $| = 1;
    my $enc = $app->config('ExportEncoding');
    $enc = $app->config('LogExportEncoding') if ( !$enc );
    $enc = $app->charset || $app->config->PublishCharset unless $enc;

    my $q           = $app->param;
    my $filter_args = $q->param('filter_args');
    my %terms;
    if ($filter_args) {
        $q->parse_params($filter_args) if $filter_args;
        %terms = %{
            apply_log_filter(
                $app,
                {   filter     => $q->param('filter'),
                    filter_val => $q->param('filter_val')
                }
            )
        };
    }

    # all classes of log objects
    unless ( exists $terms{class} ) {
        $terms{class} = '*';
    }

    if ($blog) {
        $terms{blog_id} = $blog_ids;
    }
    else {
        if ( !$user->can_do('view_log') ) {
            my $iter = MT->model('permission')->load_iter(
                {   author_id   => $user->id,
                    permissions => { like => '%view_blog_log%' },
                }
            );
            my $blog_ids;
            while ( my $p = $iter->() ) {
                push @$blog_ids, $p->blog_id;
            }
            $terms{blog_id} = $blog_ids;
        }
    }
    my $log_class  = $app->model('log');
    my $blog_class = $app->model('blog');
    my $iter       = $log_class->load_iter( \%terms,
        { 'sort' => 'created_on', 'direction' => 'ascend' } );

    my $file = '';
    $file = dirify( $blog->name ) . '-' if $blog;
    $file = "Blog-" . $blog->id . '-'   if $file eq '-';
    my @ts = gmtime(time);
    my $ts = sprintf "%04d-%02d-%02d-%02d-%02d-%02d", $ts[5] + 1900,
        $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ];
    $file .= "log_$ts.csv";
    $app->{no_print_body} = 1;
    $app->set_header( "Content-Disposition" => "attachment; filename=$file" );
    $app->send_http_header(
        $enc
        ? "text/csv; charset=$enc"
        : 'text/csv'
    );

    my %seen;
    my $csv = "timestamp,ip,weblog,by,message\n";
    while ( my $log = $iter->() ) {

        # columns:
        # date, ip address, weblog, by, log message
        my @col;
        my $ts = $log->created_on;
        if ($blog_view) {
            push @col,
                format_ts(
                "%Y-%m-%d %H:%M:%S",
                epoch2ts( $blog, ts2epoch( undef, $ts, 1 ) ),
                $blog,
                $app->user ? $app->user->preferred_language : undef
                );
        }
        else {
            push @col,
                format_ts(
                "%Y-%m-%d %H:%M:%S",
                epoch2ts(
                    undef, offset_time( ts2epoch( undef, $log->created_on ) )
                ),
                undef,
                $app->user ? $app->user->preferred_language : undef
                );
        }
        push @col, $log->ip || '';
        my $blog;
        if ( $log->blog_id ) {
            $blog = $seen{blogs}{ $log->blog_id }
                ||= $blog_class->load( $log->blog_id );
        }
        if ($blog) {
            my $name = $blog->name;
            $name =~ s/"/\\"/gs;
            $name =~ s/[\r\n]+/ /gs;
            push @col, '"' . $name . '"';
        }
        else {
            push @col, '';
        }
        my $author_name;
        if (my $author_id = $log->author_id) {
            if (defined $seen{authors}{$author_id}) {
                $author_name = $seen{authors}{$author_id};
            } elsif (my $user = MT->model('author')->load($author_id)) {
                $author_name = $user->name;
                $seen{authors}{$author_id} = $author_name;
            } else {
                $author_name = MT->translate('*User deleted*');
            }
        }
        if (defined $author_name && $author_name ne '') {
            $author_name =~ s/"/\\"/gs;
            $author_name =~ s/[\r\n]+/ /gs;
            push @col, '"' . $author_name . '"';
        } else {
            push @col, '';
        }
        my $msg = $log->message;
        $msg = '' unless defined $msg;
        $msg =~ s/"/\\"/gs;
        $msg =~ s/[\r\n]+/ /gs;
        push @col, '"' . $msg . '"';
        $csv .= ( join ',', @col ) . "\n";
        $app->print( Encode::encode( $enc, $csv ) );
        $csv = '';
    }
}

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

sub template_param_list {
    my $cb = shift;
    my ( $app, $param, $tmpl ) = @_;
    my ($so);
    if ( my $blog = $app->blog ) {
        $so = $blog->server_offset;
    }
    else {
        $so = $app->current_time_offset;
    }
    if ($so) {
        my $partial_hour_offset = 60 * abs( $so - int($so) );
        my $tz                  = sprintf( "%s%02d:%02d",
            $so < 0 ? '-' : '+',
            abs($so), $partial_hour_offset );
        $param->{time_offset} = $tz;
    }

    pop @{ $app->{breadcrumbs} };
    $app->add_breadcrumb( $app->translate('Activity Log') );
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $args = $load_options->{args};
    $args->{no_class} = 1;

    my $user = $app->user;
    return if $user->is_superuser;

    my $options_blog_ids = $load_options->{blog_ids};

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {   author_id   => $user->id,
            permissions => { like => '%view_blog_log%' },
            (   $options_blog_ids
                ? ( blog_id => $options_blog_ids )
                : ( blog_id => { 'not' => 0 } )
            ),
        },
    );

    my $blog_ids;
    while ( my $perm = $iter->() ) {
        push @$blog_ids, $perm->blog_id;
    }

    my $terms = $load_options->{terms};
    $terms->{blog_id} = $blog_ids
        if $blog_ids;
    $load_options->{terms} = $terms;
}

1;
