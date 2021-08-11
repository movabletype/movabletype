# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::TheSchwartz;

use strict;
use warnings;
use base qw( TheSchwartz );
use MT::ObjectDriver::Driver::Cache::RAM;
use List::Util qw( shuffle );

my $instance;

our $OBJECT_REPORT  = 0;

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
    my ( $msg, $job ) = @_;

    # suppress TheSchwartz::Job's 'job completed'
    return if $msg eq 'job completed';
    return if $msg eq 'TheSchwartz::work_once found no jobs';
    return if $msg =~ /^TheSchwartz::work_once got job of/;
    return if $msg =~ /^Working on/;

    $msg =~ s/\s+$//;
    print STDERR "$msg\n";
}

sub new {
    my $class = shift;
    $class->mt_schwartz_init();
    my (%param) = @_;
    my $workers = [];
    $workers        = delete $param{workers}   if exists $param{workers};

    # Reports object usage inbetween jobs if Devel::Leak::Object is loaded
    $OBJECT_REPORT = 1 if $Devel::Leak::Object::VERSION;

    $param{verbose} = \&default_logger
        if $param{verbose} && ( ref $param{verbose} ne 'CODE' );

    my $client = $class->SUPER::new(%param) or return;
    $instance = $client;

    for my $c (@$workers) {
        if ( eval( 'require ' . $c ) ) {
            $client->can_do($c);
        } else {
            print STDERR "Failed to load worker class '$c': $@\n";
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
    require MT::TheSchwartz::Job;
    return MT::TheSchwartz::Job->dbi_driver;
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

sub _has_enough_swap {
    my $memory_module;
    eval {
        require Sys::MemInfo;
        $memory_module = q{Sys::MemInfo};
    };

    my ($mem_limit) = @_;
    if ( !defined($mem_limit) ) {
        $mem_limit = MT->config('SchwartzSwapMemoryLimit');
    }

    if ( $mem_limit && $memory_module ) {
        my $decoded_limit;
        if ( $mem_limit =~ /^\d+[KGM]B?$/ ) {
            my $multiplier = 1;
            ( $mem_limit =~ /GB?$/ )
                and $multiplier = 1048576000;    # 1024 * 1024 * 1000
            ( $mem_limit =~ /MB?$/ ) and $multiplier = 1024000;  # 1024 * 1000
            ( $mem_limit =~ /KB?$/ ) and $multiplier = 1024;
            $mem_limit =~ s/[KGM]B?$//;
            $mem_limit = $mem_limit * $multiplier;
        }
        if ( $mem_limit =~ /\d+/ ) {
            my $swap;
            if ( $memory_module eq q{Sys::MemInfo} ) {
                $swap = Sys::MemInfo::get("freeswap");
            }

            # not enough swap, lets get out of here!
            if ( $swap < $mem_limit ) {
                return 0;
            }
        }
    }

    # default to returning true
    # i.e., yes there is enough
    return 1;
}

sub _has_enough_memory {
    my $memory_module;
    eval {
        require Sys::MemInfo;
        $memory_module = q{Sys::MemInfo};
    };

    my ($mem_limit) = @_;
    if ( !defined($mem_limit) ) {
        $mem_limit = MT->config('SchwartzFreeMemoryLimit');
    }

    if ( $mem_limit && $memory_module ) {
        my $decoded_limit;
        if ( $mem_limit =~ /^\d+[KGM]B?$/ ) {
            my $multiplier = 1;
            ( $mem_limit =~ /GB?$/ )
                and $multiplier = 1048576000;    # 1024 * 1024 * 1000
            ( $mem_limit =~ /MB?$/ ) and $multiplier = 1024000;  # 1024 * 1000
            ( $mem_limit =~ /KB?$/ ) and $multiplier = 1024;
            $mem_limit =~ s/[KGM]B?$//;
            $mem_limit = $mem_limit * $multiplier;
        }
        if ( $mem_limit =~ /\d+/ ) {
            my $free;
            if ( $memory_module eq q{Sys::MemInfo} ) {
                $free = Sys::MemInfo::get("freemem");
            }

            # not enough free, lets get out of here!
            if ( $free < $mem_limit ) {
                return 0;
            }
        }
    }

    # default to returning true
    # i.e., yes there is enough
    return 1;
}

# Replacement for TheSchwartz::get_server_time
# to simply return value from dbd->sql_for_unixtime
# if it is a plain number (the driver has no function,
# it's just returning time())
sub get_server_time {
    my TheSchwartz $client = shift;
    my ($driver)           = @_;
    my $unixtime_sql       = $driver->dbd->sql_for_unixtime;
    return $unixtime_sql if $unixtime_sql =~ m/^\d+$/;
    return $driver->r_handle->selectrow_array("SELECT $unixtime_sql");
}

sub work_until_done {
    my TheSchwartz $client = shift;
    if ( !$client ) {
        return;
    }
    my $cap       = MT->config('SchwartzClientDeadline');    # in seconds
    my $mem_limit = MT->config('SchwartzFreeMemoryLimit');
    $mem_limit ||= 0;
    my $swap_limit = MT->config('SchwartzSwapMemoryLimit');
    $swap_limit ||= 0;
    my $deadline;
    if ($cap) {
        $deadline = time() + $cap;
        while ( time() < $deadline ) {
            $client->work_once or last;
            last unless _has_enough_memory($mem_limit);
            last unless _has_enough_swap($swap_limit);
        }
    }
    else {
        while (1) {
            $client->work_once or last;
            last unless _has_enough_memory($mem_limit);
            last unless _has_enough_swap($swap_limit);
        }
    }
}

sub work_periodically {
    my TheSchwartz $client = shift;
    my ($delay) = @_;
    $delay ||= 5;
    my $last_task_run = 0;
    my $did_work      = 0;

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

        if ( $client->work_once ) {
            $did_work = 1;
        }

        if ( $last_task_run + 60 * 5 < time ) {
            MT->run_tasks();
            $did_work      = 1;
            $last_task_run = time;
        }

        if ($did_work) {

            # Clear RAM cache
            MT::ObjectDriver::Driver::Cache::RAM->clear_cache;

            MT->request->reset();

            $did_work = 0;
            if ($OBJECT_REPORT) {
                my $report = leak_report( \%obj_start, \%obj_pre,
                    \%Devel::Leak::Object::OBJECT_COUNT );
                $client->debug($report) if $report ne '';
            }
        }

        sleep $delay;
    }
}

our %persistent;

BEGIN {
    %persistent = map { $_ => 1 }
        qw( MT::Callback MT::Task MT::Plugin MT::Component MT::ArchiveType MT::TaskMgr MT::WeblogPublisher MT::Serialize TheSchwartz::Job TheSchwartz::JobHandle );
}

sub leak_report {
    my ( $start, $pre, $post ) = @_;
    my $reported;
    my $report = '';
    foreach my $class ( sort keys %$post ) {

        # skip reporting classes that are persistent in nature
        next if exists $persistent{$class};

        my $post_count = $post->{$class};
        next if !$post_count;
        my $pre_count   = $pre->{$class}   || 0;
        my $start_count = $start->{$class} || 0;
        next if $post_count == 1;    # ignores most singletons
        if (   ( $pre_count != $post_count )
            || ( $post_count != $start_count ) )
        {
            $report
                .= "Leak report (class, total, delta from last job(s), delta since process start):\n"
                unless $reported;
            $report .= sprintf(
                "%-40s %-10d %-10d %-10d\n",
                $class, $post_count,
                $post_count - $pre_count,
                $post_count - $start_count
            );
            $reported = 1;
        }
    }
    return $report;
}

1;
__END__

=head1 NAME

MT::TheSchwartz - Movable Type

=head1 SYNOPSIS

    use MT;
    use MT::TheSchwartz;
    my $mt = MT->new;
    my $schwartz = MT::TheSchwartz->new(%cfg);
    $schwartz->work_until_done;

=head1 DESCRIPTION

A subclass of C<TheSchwartz>, a job queue system. The MT subclass is
responsible for configuring TheSchwartz to work with the MT database
configuration and supplies TheSchwartz worker classes from the MT
registry.

=head1 METHODS

=head2 MT::TheSchwartz->instance

Returns the singleton instance for the C<MT::TheSchwartz> class.

=head2 MT::TheSchwartz->debug

Static (or instance) method that simply forwards the parameters given on
to the singleton instance.

=head2 MT::TheSchwartz->insert

Static (or instance) method that simply forwards the parameters given on
to the singleton instance.

=head2 $schwartz->default_logger($msg, $job)

Handles logging messages for C<TheSchwartz>. When a log message is issued,
this method takes over. In this case, this subclass suppresses the
"job completed" messages issued by C<TheSchwartz>.

=head2 $schwartz->work_periodically([$delay])

Invokes C<TheSchwartz> to process available jobs, then queries the MT
session table for available MT registered tasks that may be ready to
run. MT tasks such as publishing scheduled posts, expiration of
spam comments and trackbacks, etc. This routine runs in an infinite
loop-- after scheduled tasks are run, it will delay C<$delay> seconds
(default of 5 seconds), then checks for more Schwartz jobs to process.

=cut
