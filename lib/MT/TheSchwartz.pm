# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::TheSchwartz;

use strict;
use base qw( TheSchwartz );
use MT::ObjectDriver::Driver::DBI;
use List::Util qw( shuffle );

my $instance;

our $RANDOMIZE_JOBS = 0;

sub instance {
    $instance ||= MT::TheSchwartz->new();
    return $instance;
}

sub debug {
    my $class = shift;
    $class->instance->SUPER::debug(@_);
}

sub insert {
    my $class = shift;
    $class->instance->SUPER::insert(@_);
}

sub new {
    my $class = shift;
    $class->mt_schwartz_init();
    my (%param) = @_;
    my $workers = delete $param{workers} if exists $param{workers};
    $RANDOMIZE_JOBS = delete $param{randomize} if exists $param{randomize};

    my $client = $class->SUPER::new(%param);

    if ($client) {
        $instance = $client;
        unless ( $workers ) {
            $workers = [];

            my $all_workers ||= MT->registry("task_workers") || {};

            foreach my $id (keys %$all_workers) {
                my $w = $all_workers->{$id};
                my $c = $w->{class} or next;
                push @$workers, $c;
            }
        }

        if (@$workers) {
            # Can we do this?
            foreach my $c ( @$workers ) {
                if (eval('require ' . $c)) {
                    # Yes, we can do this.
                    $client->can_do( $c );
                } else {
                    # No, we can't. Here's why...
                    print STDERR "Failed to load worker class '$c': $@\n";
                }
            }
        }
    }

    return $client;
}

our $initialized;

sub mt_schwartz_init {
    return if $initialized;

    # Update the datasource for these, since MT adds an addition 'schwartz_'
    # prefix for them.
    require TheSchwartz::FuncMap;
    require TheSchwartz::Job;
    require TheSchwartz::Error;
    require TheSchwartz::ExitStatus;
    TheSchwartz::FuncMap->properties->{datasource}    = 'ts_funcmap';
    TheSchwartz::Job->properties->{datasource}        = 'ts_job';
    TheSchwartz::Error->properties->{datasource}      = 'ts_error';
    TheSchwartz::ExitStatus->properties->{datasource} = 'ts_exitstatus';

    my $job_set_exit_status = \&TheSchwartz::Job::set_exit_status;
    my $job_add_failure = \&TheSchwartz::Job::add_failure;

    my $driver = MT::Object->driver;
    no warnings 'redefine';
    *TheSchwartz::Job::set_exit_status = sub {
        $driver->Disabled(1);
        my $res = $job_set_exit_status->(@_);
        $driver->Disabled(0);
        return $res;
    };
    *TheSchwartz::Job::add_failure = sub {
        $driver->Disabled(1);
        my $res = $job_add_failure->(@_);
        $driver->Disabled(0);
        return $res;
    };

    return $initialized = 1;
}

sub driver_for {
    my MT::TheSchwartz $client = shift;
    return MT::Object->driver;
}

sub shuffled_databases {
    my TheSchwartz $client = shift;
    return '1';
}

sub hash_databases {
    return 1;
}

sub mark_database_as_dead {
    return 1;
}

sub is_database_dead {
    return 0;
}

# Replacement for TheSchwartz::get_server_time
# to simply return value from dbd->sql_for_unixtime
# if it is a plain number (the driver has no function,
# it's just returning time())
sub get_server_time {
    my TheSchwartz $client = shift;
    my($driver) = @_;
    my $unixtime_sql = $driver->dbd->sql_for_unixtime;
    return $unixtime_sql if $unixtime_sql =~ m/^\d+$/;
    return $driver->rw_handle->selectrow_array("SELECT $unixtime_sql");
}

sub work_periodically {
    my TheSchwartz $client = shift;
    my ($delay) = @_;
    $delay ||= 5;
    my $last_task_run = 0;
    while (1) {
        unless ($client->work_once) {
            my $driver = $client->driver_for();
            $driver->clear_cache
                if $driver->can('clear_cache');
            MT->request->reset();
            sleep $delay;

            if ($last_task_run + 60 * 5 < time) {
                MT->run_tasks();
                $last_task_run = time;
            }
        }
    }
}

sub _grab_a_job {
    my TheSchwartz $client = shift;
    my $hashdsn = shift;
    my $driver = $client->driver_for($hashdsn);

    ## Got some jobs! Randomize them to avoid contention between workers.
    my @jobs = $RANDOMIZE_JOBS ? shuffle(@_) : @_;

  JOB:
    while (my $job = shift @jobs) {
        ## Convert the funcid to a funcname, based on this database's map.
        $job->funcname( $client->funcid_to_name($driver, $hashdsn, $job->funcid) );

        ## Update the job's grabbed_until column so that
        ## no one else takes it.
        my $worker_class = $job->funcname;
        my $old_grabbed_until = $job->grabbed_until;

        my $server_time = $client->get_server_time($driver)
            or die "expected a server time";

        $job->grabbed_until($server_time + ($worker_class->grab_for || 1));

        ## Update the job in the database, and end the transaction.
        if ($driver->update($job, { grabbed_until => $old_grabbed_until }) < 1) {
            ## We lost the race to get this particular job--another worker must
            ## have got it and already updated it. Move on to the next job.
            $TheSchwartz::T_LOST_RACE->() if $TheSchwartz::T_LOST_RACE;
            next JOB;
        }

        ## Now prepare the job, and return it.
        my $handle = TheSchwartz::JobHandle->new({
            dsn_hashed => $hashdsn,
            jobid      => $job->jobid,
        });
        $handle->client($client);
        $job->handle($handle);
        return $job;
    }

    return undef;
}

1;
