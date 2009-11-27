# $Id: Job.pm 1098 2007-12-12 01:47:58Z hachi $

package TheSchwartz::Job;
use strict;
use base qw( Data::ObjectDriver::BaseObject );

use Carp qw( croak );
use Storable ();
use TheSchwartz::Error;
use TheSchwartz::ExitStatus;
use TheSchwartz::JobHandle;

__PACKAGE__->install_properties({
               columns     => [qw(jobid funcid arg uniqkey insert_time
                                  run_after grabbed_until priority coalesce)],
               datasource  => 'job',
               column_defs => { arg => 'blob' },
               primary_key => 'jobid',
           });

__PACKAGE__->add_trigger(pre_save => sub {
    my ($job) = @_;
    my $arg = $job->arg
        or return;
    if (ref($arg)) {
        $job->arg(Storable::nfreeze($arg));
    }
});

__PACKAGE__->add_trigger(post_load => sub {
    my ($job) = @_;
    my $arg = $job->arg
        or return;
    $job->arg(_cond_thaw($job->arg))
});

sub new_from_array {
    my $class = shift;
    my(@arg) = @_;
    croak "usage: new_from_array(funcname, arg)" unless @arg == 2;
    return $class->new(
            funcname => $arg[0],
            arg      => $arg[1],
        );
}

sub new {
    my $class = shift;
    my(%param) = @_;
    my $job = $class->SUPER::new;
    if (my $arg = $param{arg}) {
        if (ref($arg) eq 'SCALAR') {
            $param{arg} = Storable::thaw($$arg);
        } elsif (!ref($arg)) {
            # if a regular scalar, test to see if it's a storable or not.
            $param{arg} = _cond_thaw($arg);
        }
    }
    $param{run_after} ||= time;
    $param{grabbed_until} ||= 0;
    for my $key (keys %param) {
        $job->$key($param{$key});
    }
    return $job;
}

sub funcname {
    my $job = shift;
    if (@_) {
        $job->{__funcname} = shift;
    }

    # lazily load,
    if (!$job->{__funcname}) {
        my $handle = $job->handle;
        my $client = $handle->client;
        my $driver = $client->driver_for($handle->dsn_hashed);
        my $funcname = $client->funcid_to_name($driver, $handle->dsn_hashed, $job->funcid)
            or die "Failed to lookup funcname of job $job";
        return $job->{__funcname} = $funcname;
    }
    return $job->{__funcname};
}

sub handle {
    my $job = shift;
    if (@_) {
        $job->{__handle} = $_[0];
    }
    return $job->{__handle};
}

sub driver {
    my $job = shift;
    unless (exists $job->{__driver}) {
        my $handle = $job->handle;
        $job->{__driver} = $handle->client->driver_for($handle->dsn_hashed);
    }
    return $job->{__driver};
}

sub add_failure {
    my $job = shift;
    my($msg) = @_;
    my $error = TheSchwartz::Error->new;
    $error->error_time(time());
    $error->jobid($job->jobid);
    $error->funcid($job->funcid);
    $error->message($msg || '');

    my $driver = $job->driver;
    $driver->insert($error);

    # and let's lazily clean some errors while we're here.
    my $unixtime = $driver->dbd->sql_for_unixtime;
    my $maxage   = $TheSchwartz::T_ERRORS_MAX_AGE || (86400*7);
    $driver->remove('TheSchwartz::Error', {
        error_time => \ "< $unixtime - $maxage",
    }, {
        nofetch => 1,
        limit   => $driver->dbd->can_delete_with_limit ? 1000 : undef,
    });

    return $error;
}

sub exit_status { shift->handle->exit_status }
sub failure_log { shift->handle->failure_log }
sub failures    { shift->handle->failures    }

sub set_exit_status {
    my $job = shift;
    my($exit) = @_;
    my $class = $job->funcname;
    my $secs = $class->keep_exit_status_for or return;
    my $status = TheSchwartz::ExitStatus->new;
    $status->jobid($job->jobid);
    $status->funcid($job->funcid);
    $status->completion_time(time);
    $status->delete_after($status->completion_time + $secs);
    $status->status($exit);

    my $driver = $job->driver;
    $driver->insert($status);

    # and let's lazily clean some exitstatus while we're here.  but
    # rather than doing this query all the time, we do it 1/nth of the
    # time, and deleting up to n*10 queries while we're at it.
    # default n is 10% of the time, doing 100 deletes.
    my $clean_thres = $TheSchwartz::T_EXITSTATUS_CLEAN_THRES || 0.10;
    if (rand() < $clean_thres) {
        my $unixtime = $driver->dbd->sql_for_unixtime;
        $driver->remove('TheSchwartz::ExitStatus', {
            delete_after => \ "< $unixtime",
        }, {
            nofetch => 1,
            limit   => $driver->dbd->can_delete_with_limit ? int(1 / $clean_thres * 100) : undef,
        });
    }

    return $status;
}

sub did_something {
    my $job = shift;
    if (@_) {
        $job->{__did_something} = shift;
    }
    return $job->{__did_something};
}

sub debug {
    my ($job, $msg) = @_;
    $job->handle->client->debug($msg, $job);
}

sub completed {
    my $job = shift;
    $job->debug("job completed");
    if ($job->did_something) {
        $job->debug("can't call 'completed' on already finished job");
        return 0;
    }
    $job->did_something(1);
    $job->set_exit_status(0);
    $job->driver->remove($job);
}

sub permanent_failure {
    my ($job, $msg, $ex_status) = @_;
    if ($job->did_something) {
        $job->debug("can't call 'permanent_failure' on already finished job");
        return 0;
    }
    $job->_failed($msg, $ex_status, 0);
}

sub failed {
    my ($job, $msg, $ex_status) = @_;
    if ($job->did_something) {
        $job->debug("can't call 'failed' on already finished job");
        return 0;
    }

    ## If this job class specifies that jobs should be retried,
    ## update the run_after if necessary, but keep the job around.

    my $class       = $job->funcname;
    my $failures    = $job->failures + 1;    # include this one, since we haven't ->add_failure yet
    my $max_retries = $class->max_retries($job);

    $job->debug("job failed.  considering retry.  is max_retries of $max_retries >= failures of $failures?");
    $job->_failed($msg, $ex_status, $max_retries >= $failures, $failures);
}

sub _failed {
    my ($job, $msg, $exit_status, $_retry, $failures) = @_;
    $job->did_something(1);
    $job->debug("job failed: " . ($msg || "<no message>"));

    ## Mark the failure in the error table.
    $job->add_failure($msg);

    if ($_retry) {
        my $class = $job->funcname;
        if (my $delay = $class->retry_delay($failures)) {
            $job->run_after(time() + $delay);
        }
        $job->grabbed_until(0);
        $job->driver->update($job);
    } else {
        $job->set_exit_status($exit_status || 1);
        $job->driver->remove($job);
    }
}

sub replace_with {
    my $job = shift;
    my(@jobs) = @_;

    if ($job->did_something) {
        $job->debug("can't call 'replace_with' on already finished job");
        return 0;
    }
    # Note: we don't set 'did_something' here because completed does it down below.

    ## The new jobs @jobs should be inserted into the same database as $job,
    ## which they're replacing. So get a driver for the database that $job
    ## belongs to.
    my $handle = $job->handle;
    my $client = $handle->client;
    my $hashdsn = $handle->dsn_hashed;
    my $driver = $job->driver;

    $job->debug("replacing job with " . (scalar @jobs) . " other jobs");

    ## Start a transaction.
    $driver->begin_work;

    ## Insert the new jobs.
    for my $j (@jobs) {
        $client->insert_job_to_driver($j, $driver, $hashdsn);
    }

    ## Mark the original job as completed successfully.
    $job->completed;

    # for testing
    if ($TheSchwartz::Job::_T_REPLACE_WITH_FAIL) {
        $driver->rollback;
        die "commit failed for driver: due to testing\n";
    }

    ## Looks like it's all ok, so commit.
    $driver->commit;
}

sub set_as_current {
    my $job = shift;
    my $client = $job->handle->client;
    $client->set_current_job($job);
}

sub _cond_thaw {
    my $data = shift;

    my $magic = eval { Storable::read_magic($data); };
    if ($magic && $magic->{major} && $magic->{major} >= 2 && $magic->{major} <= 5) {
        my $thawed = eval { Storable::thaw($data) };
        if ($@) {
            # false alarm... looked like a Storable, but wasn't.
            return $data;
        }
        return $thawed;
    } else {
        return $data;
    }
}

1;

__END__

=head1 NAME

TheSchwartz::Job - jobs for the reliable job queue

=head1 SYNOPSIS

    my $client = TheSchwartz->new( databases => $DATABASE_INFO );

    my $job = TheSchwartz::Job->new_from_array('MyWorker', foo => 'bar');
    $client->dispatch_async($job);

    $job = TheSchwartz::Job->new(
        funcname => 'MyWorker',
        uniqkey  => 7,
        arg      => [ foo => 'bar' ],
    );
    $client->dispatch_async($job);

=head1 DESCRIPTION

C<TheSchwartz::Job> models the jobs that are posted to the job queue by your
application, then grabbed and performed by your worker processes.

C<TheSchwartz::Job> is a C<Data::ObjectDriver> model class. See
L<Data::ObjectDriver::BaseObject>.

=head1 FIELDS

C<TheSchwartz::Job> objects have these possible fields:

=head2 C<jobid>

The unique numeric identifier for this job. Set automatically when saved.

=head2 C<funcid>

The numeric identifier for the type of job to perform. C<TheSchwartz> clients
map function names (also known as abilities and worker class names) to these
numbers using C<TheSchwartz::FuncMap> records.

=head2 C<arg>

Arbitrary state data to supply to the worker process for this job. If specified
as a reference, the data is frozen to a blob with the C<Storable> module.

=head2 C<uniqkey>

An arbitrary string identifier used to prevent applications from posting
duplicate jobs. At most one with the same C<uniqkey> value can be posted to a
single C<TheSchwartz> database.

=head2 C<insert_time>

The C<insert_time> field is not used.

=head2 C<run_after>

The UNIX system time after which the job can next be attempted by a worker
process. This timestamp is set when a job is first created or is released after
a failure.

=head2 C<grabbed_until>

The UNIX system time after which the job can next be available by a worker
process. This timestamp is set when a job is grabbed by a worker process, and
reset to C<0> when is released due to failure to complete the job.

=head2 C<priority>

The C<priority> field is not used.

=head2 C<coalesce>

A string used to discover jobs that can be efficiently pipelined with a given
job due to some shared resource. For example, for email delivery jobs, the
domain of an email address could be used as the C<coalesce> value. A worker
process could then deliver all the mail queued for a given mail host after
connecting to it once.

=head1 USAGE

=head2 C<TheSchwartz::Job-E<gt>new( %args )>

Returns a new job object with the given data. Members of C<%args> can be keyed
on any of the fields described above, or C<funcname>.

=head2 C<TheSchwartz::Job-E<gt>new_from_array( $funcname, $arg )>

Returns a new job with the given function name (also called I<ability> or
I<worker class>), and the scalar or reference C<$arg> for an argument.

=head2 C<$job-E<gt>funcname([ $funcname ])>

Returns the function name for the given job, after setting it to C<$funcname>,
if specified.

=head2 C<$job-E<gt>handle([ $handle ])>

Returns the C<TheSchwartz::JobHandle> object describing this job, after setting
it to C<$handle>, if specified. A I<job handle> is a convenience class for
accessing other records related to jobs; as its convenience methods are also
available directly from C<TheSchwartz::Job> instances, you will usually not
need to work directly with job handles.

=head2 C<$job-E<gt>driver()>

Returns the C<Data::ObjectDriver> object driver for accessing the database in
which C<$job> is stored. See L<Data::ObjectDriver>.

=head2 C<$job-E<gt>add_failure( $msg )>

Records and returns a new C<TheSchwartz::Error> object representing a failure
to perform C<$job>, for reason C<$msg>.

=head2 C<$job-E<gt>exit_status()>

Returns the I<exit status> specified by the worker that either completed the
job or declared it failed permanently. The exit status for a job will be
available for a period of time after the job has exited the queue. That time is
defined in the job's worker class's C<keep_exit_status_for()> method.

=head2 C<$job-E<gt>failure_log()>

Returns a list of the error messages specified to C<add_failure()> when a
worker failed to perform the given job.

=head2 C<$job-E<gt>failures()>

Returns the number of times a worker has grabbed this job, only to fail to
complete it.

=head2 C<$job-E<gt>set_exit_status( $status )>

Records the exit status of the given job as C<$status>.

=head2 C<$job-E<gt>did_something([ $value ])>

Returns whether the given job has been completed or failed since it was created
or loaded, setting whether it has to C<$value> first, if specified.

=head2 C<$job-E<gt>debug( $msg )>

Sends the given message to the job's C<TheSchwartz> client as debug output.

=head2 C<$job-E<gt>set_as_current()>

Set C<$job> as the current job being performed by its associated C<TheSchwartz>
client.

=head1 WORKING

C<TheSchwartz::Worker> classes should use these methods to update the status of
their jobs:

=head2 C<$job-E<gt>completed()>

Records that the given job has been fully performed and removes it from the job
queue. Completing a job records its exit status as C<0>.

=head2 C<$job-E<gt>failed( $msg, $exit_status )>

Records that the worker performing this job failed to complete it, for reason
C<$msg>.

If workers have not failed to complete the job more times than the maximum
number of retries for that type of job, the job will be reattempted after its
retry delay has elapsed. The maximum number of retries and the delay before a
retry are defined in the job's worker class definition as C<max_retries()> and
C<retry_delay()> respectively.

If workers I<have> exceeded the maximum number of reattempts for this job, the
job's exit status is recorded as C<$exit_status>, and the job is removed from
the queue. If C<$exit_status> is not defined or C<0>, the job will be recorded
with an exit status of C<1>, to indicate a failure.

=head2 C<$job-E<gt>permanent_failure( $msg, $exit_status )>

Records that the worker performing this job failed to complete it, as in
C<failed()>, but that the job should I<not> be reattempted, no matter how many
times the job has been attempted before. The job's exit status is thus recorded
as C<$exit_status> (or C<1>), and the job is removed from the queue.

=head2 C<$job-E<gt>replace_with( @jobs )>

Atomically replaces the single job C<$job> with the given set of jobs.

This can be used to decompose one "metajob" posted by your application into a
set of jobs workers can perform, or to post a job or jobs required to complete
the process already partly performed.

=head1 SEE ALSO

L<Data::ObjectDriver>, L<Data::ObjectDriver::BaseObject>, L<Storable>

=cut

