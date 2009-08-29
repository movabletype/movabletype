package MT::CMS::RptLog;

use strict;

use MT::Util qw( offset_time_list format_ts epoch2ts ts2epoch relative_date offset_time encode_url dirify encode_url );
use MT::I18N qw( const break_up_text encode_text );

sub view {
    my $app     = shift;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    my $perms   = $app->permissions;
    my $log_class  = $app->model('log');
    my $blog_class = $app->model('blog');
    my $list_pref  = $app->list_pref('rptlog');
    my $limit      = $list_pref->{rows};
    my $offset     = $app->param('offset') || 0;
    my $terms      = { $blog_id ? ( blog_id => $blog_id ) : () };
    my $cfg        = $app->config;
    my %param      = (%$list_pref);
    my ( $filter_col, $val );

    # can this user really view this shit?
    return $app->error( $app->translate("Permission denied.") ) unless $user->can_view_log;

    # all classes of log objects
    unless ( exists $terms->{class} ) {
        $terms->{class} = '*';
    }

    # get the iterator for the errorrs
    require MT::TheSchwartz::Error;
    my $iter_errors = MT::TheSchwartz::Error->load_iter();

    # get the iterator for the log messages
    my $iter_logs = $log_class->load_iter(
        $terms,
        {
            'sort'      => 'id',
            'direction' => 'descend',
            'offset'    => $offset,
            'limit'     => $limit
        }
    );

    # finally build the log table
    my $log = build_log_table( $app, iter_logs => $iter_logs, iter_errors => $iter_errors, param => \%param );

    # get the time offset based on the system settings
    my $so = $app->config('TimeOffset');
    if ($so) {
        my $partial_hour_offset = 60 * abs( $so - int($so) );
        my $tz = sprintf( "%s%02d:%02d", $so < 0 ? '-' : '+', abs($so), $partial_hour_offset );
        $param{time_offset} = $tz;
    }

    # this is for the pagination stuff (as much as I loathe that word!)
    $param{object_type}     = 'rptlog';
    $param{search_label}    = $app->translate('RPT Log');
    $param{list_start}      = $offset + 1;
    $param{list_total}      = scalar(@$log);
    $param{list_end}        = $offset + ( scalar @$log );
    $param{offset}          = $offset;
    $param{next_offset_val} = $offset + ( scalar @$log );
    $param{next_offset}     = $param{next_offset_val} < $param{list_total} ? 1 : 0;
    $param{next_max}        = $param{list_total} - $limit;
    $param{next_max}        = 0 if ( $param{next_max} || 0 ) < $offset + 1;
    $param{'reset'}             = $app->param('reset');
    $param{nav_log}             = 1;
    $param{feed_name}           = $app->translate("System RPT Feed");
    $param{screen_class}        = "list-log";
    $param{screen_id}           = "list-log";
    $param{listing_screen}      = 1;
    $param{system_overview_nav} = 1 unless ( $app->param('blog_id') );

    # dude, if this is not 0 then do pagination stuff
    if ( $offset > 0 ) {
        $param{prev_offset}     = 1;
        $param{prev_offset_val} = $offset - $limit;
        $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
    }

    # what the hell are breadcrumbs for?
    $app->add_breadcrumb( $app->translate('RPT Log') );

     # ahhh finally....
    $app->load_tmpl( 'view_rpt_log.tmpl', \%param );
}

sub build_log_table {
    my $app = shift;
    my (%args) = @_;
    my $i          = 1;
    my @log;
    my @error;

    # get the proper iterator of log messages
    my $iter_logs = $args{iter_logs};

    # get the proper iterator of error messages
    my $iter_errors = $args{iter_errors};

    # the param object used to pass stuff to the view later on in mother function
    my $param = $args{param};

    # reusing comment length constant for log view
    my $break_len = const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_SHORT');

    # iterate over the error messages
    while ( my $error = $iter_errors->() ) {
        my $msg = $error->message;
        $msg = break_up_text( $msg, $break_len );

        # create a new row for the log message
        my $row = {
            log_message => $msg,
        };

        # get the relative and formatted versions of the timestamps
        if ( my $error_time = $error->error_time ) {
            my @ts = offset_time_list($error_time);
            my $ts = sprintf '%04d%02d%02d%02d%02d%02d', $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
            $row->{created_on_formatted} = format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(),
                                                      $ts, 
                                                      undef, 
                                                      $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_relative} = relative_date( $ts, time );
        }

        # add this row to the final log list
        push @error, $row;
    }

    # return the logs to the object loop and calling function
    $param->{object_loop} = $param->{log_table}[0]{object_loop} = \@error;
    \@error;
}

sub reset {
    my $app    = shift;
    $app->validate_magic() or return;
    my $author = $app->user;
    my $log_class = $app->model('log');
    return $app->error( $app->translate("Permission denied.") ) unless $author->can_view_log;
    my $args = { 'reset' => 1 };
    $log_class->remove( { class => '*' } );
    my $log_url = $app->uri( mode => 'view_rpt_log' );
    $app->redirect( $log_url );
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
                if ($val eq 'publish') {
                    $arg{category} = 'publish';
                }
                else {
                    if ($val =~ m/,/) {
                        $arg{class} = [ split ",", $val ];
                    } else {
                        $arg{class} = $val;
                    }
                }
            }
        }
        $arg{blog_id} = [ split ",", $param->{blog_id} ] if $param->{blog_id};
    }
    \%arg;
}

1;
