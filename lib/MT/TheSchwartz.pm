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
our $OBJECT_REPORT = 0;

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

sub default_logger {
    my ($msg, $job) = @_;
    # suppress TheSchwartz::Job's 'job completed'
    return if $msg eq 'job completed';

    $msg =~ s/\s+$//;
    print STDERR "$msg\n";
}

sub new {
    my $class = shift;
    $class->mt_schwartz_init();
    my (%param) = @_;
    my $workers = delete $param{workers} if exists $param{workers};
    $RANDOMIZE_JOBS = delete $param{randomize} if exists $param{randomize};

    # Reports object usage inbetween jobs if Devel::Leak::Object is loaded
    $OBJECT_REPORT = 1 if $Devel::Leak::Object::VERSION;

    $param{verbose} = \&default_logger
        if $param{verbose} && (ref $param{verbose} ne 'CODE');

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
    return $initialized = 1;
}

sub driver_for {
    my MT::TheSchwartz $client = shift;
    return MT::Object->dbi_driver;
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
    my $did_work = 0;

    # holds state of objects at start
    my %obj_start;
    if ($OBJECT_REPORT) {
        %obj_start = %Devel::Leak::Object::OBJECT_COUNT;
    }

    while (1) {
        my %obj_pre;
        if ($OBJECT_REPORT) {
            %obj_pre = %Devel::Leak::Object::OBJECT_COUNT;
        }

        if ($client->work_once) {
            $did_work = 1;
        }

        if ($last_task_run + 60 * 5 < time) {
            MT->run_tasks();
            $did_work = 1;
            $last_task_run = time;
        }

        if ($did_work) {
            my $driver = MT::Object->driver;
            $driver->clear_cache
                if $driver->can('clear_cache');
            MT->request->reset();
            $did_work = 0;
            if ($OBJECT_REPORT) {
                my $report = leak_report(\%obj_start, \%obj_pre, \%Devel::Leak::Object::OBJECT_COUNT);
                $client->debug($report) if $report ne '';
            }
        }

        sleep $delay;
    }
}

our %persistent;
BEGIN {
    %persistent = map { $_ => 1 } qw( MT::Callback MT::Task MT::Plugin MT::Component MT::ArchiveType MT::TaskMgr MT::WeblogPublisher MT::Serializer TheSchwartz::Job TheSchwartz::JobHandle );
}
sub leak_report {
    my ($start, $pre, $post) = @_;
    my $reported;
    my $report = '';
    foreach my $class (sort keys %$post) {
        # skip reporting classes that are persistent in nature
        next if exists $persistent{$class};

        my $post_count = $post->{$class};
        next if ! $post_count;
        my $pre_count = $pre->{$class} || 0;
        my $start_count = $start->{$class} || 0;
        next if $post_count == 1;  # ignores most singletons
        if (($pre_count != $post_count) || ($post_count != $start_count)) {
            $report .= "Leak report (class, total, delta from last job(s), delta since process start):\n" unless $reported;
            $report .= sprintf("%-40s %-10d %-10d %-10d\n", $class, $post_count, $post_count - $pre_count, $post_count - $start_count);
            $reported = 1;
        }
    }
    return $report;
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
