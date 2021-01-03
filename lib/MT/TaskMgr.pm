# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::TaskMgr;

use strict;
use warnings;
use base qw( MT::ErrorHandler );

use MT::Task;
use Fcntl qw( :DEFAULT :flock );
use Symbol;
our ( %Tasks, $inst );

sub instance {
    $inst ||= new MT::TaskMgr;
}

sub new {
    my $mgr = bless {}, shift;
    $mgr->init();
    return $mgr;
}

sub init {
    my $mgr = shift;
    return if $mgr->{initialized};
    %Tasks = %{ MT->registry("tasks") || {} };
    MT->run_callbacks( 'tasks', \%Tasks );
    $mgr->{initialized} = 1;
}

sub run_tasks {
    my $mgr = shift;
    my (@tasks_to_run) = @_;

    if ( !ref($mgr) ) {
        $mgr = $mgr->instance;
    }

    @tasks_to_run = keys %Tasks unless @tasks_to_run;

    if ( $mgr->{running} ) {
        warn "Attempt to recursively invoke TaskMgr.";
        return;
    }

    local $mgr->{running} = 1;

    # Secure lock before running tasks
    my $unlock;
    unless ( $unlock = $mgr->_lock() ) {
        MT->log(
            {   class    => 'system',
                category => 'tasks',
                level    => MT::Log::ERROR(),
                message  => MT->translate(
                    "Unable to secure a lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.",
                    MT->config->TempDir
                )
            }
        );
        return;
    }

    eval {
        my $app = MT->instance;

        $app->run_callbacks('PeriodicTask');

        require MT::Log;
        require MT::Session;
        my @completed;

        foreach my $task_name (@tasks_to_run) {
            my $task = $Tasks{$task_name} or next;

            if ( ref $task eq 'HASH' ) {
                $task->{key} ||= $task_name;
                $task = $Tasks{$task_name} = MT::Task->new($task);
            }

            my $name = $task->label();
            my $sess = MT::Session->load(
                {   id   => 'Task:' . $task->key,
                    kind => 'PT'
                }
            );
            next if $sess && ( $sess->start + $task->frequency > time );
            if ( !$sess ) {
                $sess = MT::Session->new;
                $sess->id( 'Task:' . $task->key );
                $sess->kind('PT');
            }

            # Run this task
            my $status;
            eval {
                local $app->{session} = $sess;
                $status = $task->run;
            };
            if ($@) {
                my $err = $@;
                $app->log(
                    {   class    => 'system',
                        category => 'tasks',
                        level    => MT::Log::ERROR(),
                        message  => $app->translate(
                            "Error during task '[_1]': [_2]",
                            $name, $err
                        ),
                        metadata => MT::Util::log_time() . ' '
                            . $app->translate(
                            "Error during task '[_1]': [_2]",
                            $name, $err
                            )
                    }
                );
            }
            else {
                push @completed, $name
                    if ( defined $status )
                    && ( $status ne '' )
                    && ( $status > 0 );

            }

            $sess->start(time);
            $sess->save;
        }
        if (@completed) {
            $app->log(
                {   class    => 'system',
                    category => 'tasks',
                    level    => MT::Log::INFO(),
                    message  => $app->translate("Scheduled Tasks Update"),
                    metadata => MT::Util::log_time() . ' '
                        . $app->translate("The following tasks were run:")
                        . ' '
                        . join ", ",
                    @completed
                }
            );
        }
    };

    $unlock->();
}

sub _lock {
    my $mgr = shift;

    my $cfg = MT->config;

    # It's unwise to ignore locking for task manager; NoLocking should be
    # limited to the DBM driver.
    #if ($cfg->NoLocking) {
    #    ## If the user doesn't want locking, don't try to lock anything.
    #    ## Safe for tasks??
    #    return sub { };
    #}

    my $temp_dir = $cfg->TempDir;
    my $mt_dir   = MT->instance->{mt_dir};
    $mt_dir =~ s/[^A-Za-z0-9]+/_/g;
    my $lock_name = "mt-tasks-$mt_dir.lock";
    require File::Spec;
    $lock_name = File::Spec->catfile( $temp_dir, $lock_name );

    if ( $cfg->UseNFSSafeLocking ) {
        require Sys::Hostname;
        my $hostname = Sys::Hostname::hostname();
        my $lock_tmp = $lock_name . '.' . $hostname . '.' . $$;
        my $max_lock_age = 60;         ## no. of seconds til we break the lock
        my $tries        = 10;         ## no. of seconds to keep trying
        my $lock_fh      = gensym();
        open $lock_fh, ">", $lock_tmp or return;
        select( ( select($lock_fh), $| = 1 )[0] );    ## Turn off buffering
        my $got_lock = 0;

        for ( 0 .. $tries - 1 ) {
            print $lock_fh $$, "\n";    ## Update modified time on lockfile
            if ( link( $lock_tmp, $lock_name ) ) {
                $got_lock++;
                last;
            }
            elsif ( ( stat $lock_tmp )[3] > 1 ) {
                ## link() failed, but the file exists--we got the lock.
                $got_lock++;
                last;
            }
            else {
                ## Couldn't get a lock; if the lock is too old, break it.
                my $lock_age = ( stat $lock_name )[10];
                unlink $lock_name if time - $lock_age > $max_lock_age;
            }
            sleep 1;
        }
        close $lock_fh;
        unlink $lock_tmp;
        return unless $got_lock;
        return sub { unlink $lock_name };
    }
    else {
        my $lock_fh = gensym();
        sysopen $lock_fh, $lock_name, O_RDWR | O_CREAT, 0666
            or return;
        my $lock_flags = LOCK_EX;
        unless ( flock $lock_fh, $lock_flags ) {
            close $lock_fh;
            return;
        }
        return sub { close $lock_fh; unlink $lock_name };
    }
}

1;
__END__

=head1 NAME

MT::TaskMgr - MT class for controlling the execution of system tasks.

=head1 SYNOPSIS

    MT::TaskMgr->run_tasks;

=head1 DESCRIPTION

C<MT::TaskMgr> defines a simple framework for the execution of a group of
runnable tasks (individually declared as C<MT::Task> objects). Each task
is executed according to their defined frequency. Tasks that fail are logged
to MT's log table.

=head1 ABOUT TASKS

Movable Type, being a publishing framework, can benefit greatly by having
a system of tasks that can be run "offline". Unfortunately, many MT users
don't have the luxury of scheduling these tasks using "cron" or other similar
facilities some servers provide. To satisfy everyone, the task framework
introduced here allows MT and third-party plugins to register tasks that
can be executed whenever the task subsystem is invoked. This can happen
a number of ways:

=over 4

=item * By a script: tools/run-periodic-tasks

For those that do have a "cron" system, they can continue to run the
C<tools/run-periodic-tasks> script provided with Movable Type. This script
now invokes the task subsystem to execute B<all> available tasks instead of
just the one for publishing scheduled posts.

=item * By fetching an activity feed

With the activity feeds MT serves, it will invoke the task subsystem first,
then return the feed. This allows users without access to cron service to
run scheduled tasks. Note however, that this mode is reliant upon the feed
being pulled by some client. If the feed is not being accessed, then the
tasks won't run either. A user can utilize a feed-reading online service to
achieve "24x7" task service to keep their tasks running smoothly.

=item * Other requests

Some tasks, such as the expiration of junk records, may be conditionally
executed. Junk feedback record expiration is a MT-defined task that executes
when tasks are run, and also when a new feedback record is scored as junk.

=back

Tasks are an excellent way to maximize MT performance and user experience.
For example, a plugin that may need to retrieve or synchronize data with a
remote server may choose to operate from a cache that is periodically kept
up to date using a registered task.

=head1 METHODS

=head2 MT::TaskMgr->new

Constructs the MT::TaskMgr singleton instance.

=head2 MT::TaskMgr->init

Initializes the MT::TaskMgr instance, pulling tasks are defined in
the MT registry. It also runs a callback 'tasks' after gathering
this list.

=head2 MT::TaskMgr->run_tasks

Runs all available pending tasks. If an instance of the TaskMgr is already
found to be running (through use of a physical file lock mechanism), the
process will abort.

=head2 MT::TaskMgr->instance

Returns the TaskMgr singleton.

=head1 CALLBACKS

=head2 PeriodicTask

Prior to running any registered tasks, this callback is issued to allow
any registered MT plugins to add additional tasks to the list or simply
as a way to signal tasks are about to start. This callback sends no
parameters, but it is possible to retrieve the active I<MT::TaskMgr>
instance using the I<instance> method.

=head2 tasks(\%tasks)

Upon initialization of the TaskMgr instance, the list of MT tasks are
gathered from the MT registry. This hashref of tasks is then passed to
the 'tasks' callback, giving plugins a chance to manipulate the task
metadata before being used.

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
