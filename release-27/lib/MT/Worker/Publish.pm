# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Worker::Publish;

use strict;
use base qw( TheSchwartz::Worker );

use TheSchwartz::Job;
use Time::HiRes qw(gettimeofday tv_interval);
use MT::FileInfo;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;

    # Build this
    my $mt = MT->instance;

    # We got triggered to build; lets find coalescing jobs
    # and process them in one pass.

    my @jobs;
    push @jobs, $job;
    if (my $key = $job->coalesce) {
        while (my $job = MT::TheSchwartz->instance->find_job_with_coalescing_value($class, $key)) {
            push @jobs, $job;
        }
    }

    my $sync = MT->config('SyncTarget');

    my $throttles = $mt->{throttle} || {};
    MT::TheSchwartz->debug($mt->translate("Publishing: [quant,_1,file,files]...", scalar(@jobs)));

    my $start = [gettimeofday];
    my $rebuilt = 0;

    foreach $job (@jobs) {
        my $fi_id = $job->uniqkey;
        my $fi = MT::FileInfo->load($fi_id);

        # FileInfo record missing? Strange, but ignore and continue.
        unless ($fi) {
            $job->completed();
            next;
        }

        # Important: prevents requeuing!
        $fi->{from_queue} = 1;

        my $mtime = (stat($fi->file_path))[9];

        my $throttle = $throttles->{$fi->template_id}
                    || $throttles->{lc $fi->archive_type};

        # think about-- throttle by archive type or by template
        if ($throttle) {
            if (-f $fi->file_path) {
                my $time = time;
                if ($time - $mtime < $throttle) {
                    # ignore rebuilding this file now; not enough
                    # time has elapsed for rebuilding this file...
                    $job->failed("Not ready to publish file " . $fi->file_path . " based on throttle rules.");
                    next;
                }
            }
        }

        ## MT::TheSchwartz->debug("Publishing: " . RebuildQueue::Daemon::_summary($fi));
        MT::TheSchwartz->debug("Publishing file " . $fi->file_path . "...");
        my $res = $mt->publisher->rebuild_from_fileinfo($fi);
        if (defined $res) {
            if ( $sync ) {
                my $sync_job = TheSchwartz::Job->new();
                $sync_job->funcname('MT::Worker::Sync');
                $sync_job->uniqkey($fi_id);
                $sync_job->coalesce($job->coalesce) if $job->coalesce;
                $sync_job->priority($job->priority) if $job->priority;
                $job->replace_with($sync_job);
            } else {
                $job->completed();
            }
            $rebuilt++;
        } else {
            my $error = $mt->publisher->errstr;
            my $errmsg = $mt->translate("Error rebuilding file [_1]" . $fi->file_path . ": " . $error);
            MT::TheSchwartz->debug($errmsg);
            $job->permanent_failure($errmsg);
            require MT::Log;
            $mt->log({
                ($fi->blog_id ? ( blog_id => $fi->blog_id ) : () ),
                message => $errmsg,
                metadata => $errmsg . ":\n" . $error,
                category => "publish",
                level => MT::Log::ERROR(),
            });
        }
    }

    if ($rebuilt) {
        MT::TheSchwartz->debug($mt->translate("-- set complete ([quant,_1,file,files] in [_2] seconds)", $rebuilt, sprintf("%0.02f", tv_interval($start))));
    }

}

sub grab_for { 60 }
sub max_retries { 0 }
sub retry_delay { 60 }

1;
