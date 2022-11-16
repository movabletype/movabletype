# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Worker::Publish;

use strict;
use warnings;
use base qw( TheSchwartz::Worker );

use TheSchwartz::Job;
use Time::HiRes qw(gettimeofday tv_interval);
use MT::FileInfo;
use MT::PublishOption;
use MT::Util qw( log_time );

sub keep_exit_status_for {1}

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;

    # Build this
    my $mt = MT->instance;

    # reset publish timer; don't republish a file if it has
    # this or a later timestamp.
    $mt->publisher->start_time(time);

    # We got triggered to build; lets find coalescing jobs
    # and process them in one pass.

    my @jobs = ($job);
    my $job_iter;
    if ( my $key = $job->coalesce ) {
        $job_iter = sub {
            shift @jobs
                || MT::TheSchwartz->instance->find_job_with_coalescing_value(
                $class, $key );
        };
    }
    else {
        $job_iter = sub { shift @jobs };
    }

    my $sync = MT->config('SyncTarget');

    my $start   = [gettimeofday];
    my $rebuilt = 0;

    while ( my $job = $job_iter->() ) {
        my $fi_id = $job->uniqkey;
        my $fi    = MT::FileInfo->load($fi_id);

        # FileInfo record missing? Strange, but ignore and continue.
        unless ($fi) {
            $job->completed();
            next;
        }

        my $priority = $job->priority ? ", priority " . $job->priority : "";

        # Important: prevents requeuing!
        $fi->{from_queue} = 1;

        require MT::FileMgr;
        my $fmgr  = MT::FileMgr->new('Local');
        my $mtime = $fmgr->file_mod_time( $fi->file_path );

        my $throttle = MT::PublishOption::get_throttle($fi);

        # think about-- throttle by archive type or by template
        if ( $throttle->{type} == MT::PublishOption::SCHEDULED() ) {
            if ( -f $fi->file_path ) {
                my $time = time;
                if ( $time - $mtime < $throttle->{interval} ) {

                    # ignore rebuilding this file now; not enough
                    # time has elapsed for rebuilding this file...
                    $job->grabbed_until(0);
                    $job->driver->update($job);
                    next;
                }
            }
        }

        $job->debug( "Publishing " . $fi->file_path . $priority );

        my $res = $mt->publisher->rebuild_from_fileinfo($fi);
        if ( defined $res ) {
            if ($sync) {
                my $sync_job = TheSchwartz::Job->new();
                $sync_job->funcname('MT::Worker::Sync');
                $sync_job->uniqkey($fi_id);
                $sync_job->coalesce( $job->coalesce ) if $job->coalesce;
                $sync_job->priority( $job->priority ) if $job->priority;
                $job->replace_with($sync_job);
            }
            else {
                $job->completed();
            }
            $mt->log(
                {   ( $fi->blog_id ? ( blog_id => $fi->blog_id ) : () ),
                    message  => $mt->translate('Background Publishing Done'),
                    metadata => log_time() . ' '
                        . $mt->translate( 'Published: [_1]', $fi->file_path ),
                    category => "publish",
                    level    => MT::Log::INFO(),
                }
            );
            $rebuilt++;
        }
        else {
            my $error  = $mt->publisher->errstr;
            my $errmsg = $mt->translate( "Error rebuilding file [_1]:[_2]",
                $fi->file_path, $error );
            MT::TheSchwartz->debug($errmsg);
            $job->permanent_failure($errmsg);
            require MT::Log;
            $mt->log(
                {   ( $fi->blog_id ? ( blog_id => $fi->blog_id ) : () ),
                    message  => $errmsg,
                    metadata => log_time() . ' ' . $errmsg . ":\n" . $error,
                    category => "publish",
                    level    => MT::Log::ERROR(),
                }
            );
        }
    }

    if ($rebuilt) {
        $mt->publisher->remove_marked_files;

        MT::TheSchwartz->debug(
            $mt->translate(
                "-- set complete ([quant,_1,file,files] in [_2] seconds)",
                $rebuilt,
                sprintf( "%0.02f", tv_interval($start) )
            )
        );
    }

}

sub grab_for    {60}
sub max_retries {0}
sub retry_delay {60}

1;
