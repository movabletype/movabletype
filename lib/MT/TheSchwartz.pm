# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::TheSchwartz;

use strict;
use base qw( TheSchwartz );
use MT::ObjectDriver::Driver::DBI;

my $instance;

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

sub work_periodically {
    my TheSchwartz $client = shift;
    my($delay) = @_;
    $delay ||= 5;
    my $last_task_run = 0;
    while (1) {
        unless ($client->work_once) {
            sleep $delay;
            if ($last_task_run + 60 * 5 < time) {
                MT->run_tasks();
                $last_task_run = time;
            }
        }
    }
}

1;
