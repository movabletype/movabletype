# $Id: Worker.pm 1104 2007-12-12 01:49:35Z hachi $

package TheSchwartz::Worker;
use strict;

use Carp qw( croak );
use Storable ();

sub grab_job {
    my $class = shift;
    my($client) = @_;
    return $client->find_job_for_workers([ $class ]);
}

sub keep_exit_status_for { 0 }
sub max_retries { 0 }
sub retry_delay { 0 }
sub grab_for { 60 * 60 }   ## 1 hour

sub work_safely {
    my ($class, $job) = @_;
    my $client = $job->handle->client;
    my $res;

    $job->debug("Working on $class ...");
    $job->set_as_current;
    $client->start_scoreboard;

    eval {
        $res = $class->work($job);
    };

    my $cjob = $client->current_job;
    if ($@) {
        $job->debug("Eval failure: $@");
        $cjob->failed($@);
    }
    unless ($cjob->did_something) {
        $cjob->failed('Job did not explicitly complete, fail, or get replaced');
    }

    $client->end_scoreboard;

    # FIXME: this return value is kinda useless/undefined.  should we even return anything?  any callers? -brad
    return $res;
}

1;

__END__

=head1 NAME

TheSchwartz::Worker - superclass for defining task behavior

=head1 SYNOPSIS

    package MyWorker;
    use base qw( TheSchwartz::Worker );

    sub work {
        my $class = shift;
        my TheSchwartz::Job $job = shift;

        print "Workin' hard or hardly workin'? Hyuk!!\n";

        $job->completed();
    }


    package main;
    
    my $client = TheSchwartz->new( databases => $DATABASE_INFO );
    $client->can_do('MyWorker');
    $client->work();

=head1 DESCRIPTION

I<TheSchwartz::Worker> objects are the salt of the reliable job queuing earth.
The behavior required to perform posted jobs are defined in subclasses of
I<TheSchwartz::Worker>. These subclasses are named for the ability required of
a C<TheSchwartz> client to do the job, so that the clients can dispatch
automatically to the approprate worker routine.

Because jobs can be performed by any machine running code for capable worker
classes, C<TheSchwartz::Worker>s are generally stateless. All mutable state is
stored in the C<TheSchwartz::Job> objects. This means all
C<TheSchwartz::Worker> methods are I<class> methods, and C<TheSchwartz::Worker>
classes are generally never instantiated.

=head1 SUBCLASSING

Define and customize how a job is performed by overriding these methods in your
subclass:

=head2 C<$class-E<gt>work( $job )>

Performs the job that required ability C<$class>. Override this method to
define how to do the job you're defining.

Note that will need to call C<$job-E<gt>completed()> or C<$job-E<gt>failed()>
as appropriate to indicate success or failure. See L<TheSchwartz::Job>.

=head2 C<$class-E<gt>max_retries( $job )>

Returns the number of times workers should attempt the given job. After this
many tries, the job is marked as completed with errors (that is, a
C<TheSchwartz::ExitStatus> is recorded for it) and removed from the queue. By
default, returns 0.

=head2 C<$class-E<gt>retry_delay( $num_failures )>

Returns the number of seconds after a failure workers should wait until
reattempting a job that has already failed C<$num_failures> times. By default,
returns 0.

=head2 C<$class-E<gt>keep_exit_status_for()>

Returns the number of seconds to allow a C<TheSchwartz::ExitStatus> record for
a job performed by this worker class to exist. By default, returns 0.

=head2 C<$class-E<gt>grab_for()>

Returns the number of seconds workers of this class will claim a grabbed a job.
That is, returns the length of the I<timeout> after which other workers will
decide a worker that claimed a job has crashed or faulted without marking the
job failed. Jobs that are marked as failed by a worker are also marked for
immediate retry after a delay indicated by C<retry_delay()>.

=head1 USAGE

=head2 C<$class-E<gt>grab_job( $client )>

Finds and claims a job for workers with ability C<$class>, using C<TheSchwartz>
client C<$client>. This job can then be passed to C<work()> or C<work_safely()>
to perform it.

=head2 C<$class-E<gt>work_safely( $job )>

Performs the job associated with the worker's class name. If an error is thrown
while doing the job, the job is appropriately marked as failed, unlike when
calling C<work()> directly.

=cut

