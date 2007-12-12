package MT::Worker::Publish;

use strict;
use base qw( TheSchwartz::Worker );

use TheSchwartz::Job;
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

    my $throttles = $mt->{throttle} || {};
    MT::TheSchwartz->debug("Publishing: " . scalar(@jobs) . " files...");

    foreach $job (@jobs) {
        my $fi_id = $job->uniqkey;
        my $fi = MT::FileInfo->load($fi_id);

        if ($fi) {
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
                        $job->failed("Not ready to rebuild file " . $fi->file_path . " based on throttle rules.");
                        next;
                    }
                }
            }

            ## MT::TheSchwartz->debug("Publishing: " . RebuildQueue::Daemon::_summary($fi));
            my $res = $mt->publisher->rebuild_from_fileinfo($fi);
            if ($res) {
                if ( MT->config('SyncTarget') ) {
                    my $sync_job = TheSchwartz::Job->new();
                    $sync_job->funcname('MT::Worker::Sync');
                    $sync_job->uniqkey($fi_id);
                    $sync_job->coalesce($job->coalesce) if $job->coalesce;
                    $sync_job->priority($job->priority) if $job->priority;
                    $job->replace_with($sync_job);
                } else {
                    $job->completed();
                }
            } else {
                my $error = $mt->publisher->errstr;
                $job->permanent_failure("Error during build: " . $error);
            }
        } else {
            $job->completed();
        }
    }
}

sub grab_for { 60 }
sub max_retries { 100000 }
sub retry_delay { 60 }

1;
