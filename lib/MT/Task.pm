# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Task;

use strict;
use warnings;
use base qw(MT::ErrorHandler);

sub new {
    my $class = shift;
    my ($this) = ref $_[0] ? @_ : {@_};
    bless $this, $class;
    $this->init();
    $this;
}

sub init {
}

sub key {
    my $task = shift;
    $task->{key} = shift if @_;
    $task->{key};
}

sub name {
    my $task = shift;
    $task->{name} = shift if @_;
    $task->{name} || $task->{key};
}

sub label {
    my $task  = shift;
    my $label = $task->{label};
    $label = $label->() if ref($label) eq 'CODE';
    return $label || $task->name();
}

sub frequency {
    my $task = shift;
    $task->{frequency} = shift if @_;

    # default to daily run
    my $freq = $task->{frequency} || 60 * 60 * 24;
    if ( $freq =~ m/^\s*sub\s*\{/s ) {
        $freq = MT->handler_to_coderef($freq);
        $freq = $freq->();
    }
    $freq;
}

sub run {
    my $task = shift;
    my $code = $task->{code} || $task->{handler};
    if ( ref $code ne 'CODE' ) {
        $code = $task->{code} = MT->handler_to_coderef($code);
    }
    if ( ref $code eq 'CODE' ) {
        return $code->($task);
    }
    0;
}

1;
__END__

=head1 NAME

MT::Task - Movable Type class for registering runnable tasks.

=head1 SYNOPSIS

    package MyPlugin;

    MT->add_task(new MT::Task({
        name => "My Task",
        key => "Task001",
        frequency => 3600, # at most, once per hour
        code => \&runner
    }));

=head1 DESCRIPTION

An I<MT::Task> object is used to define a runnable task that can be executed
by Movable Type. The base object defines common characteristics of all tasks
as well as the method to invoke it.

Normally, a plugin will construct an I<MT::Task> object and pass it
to the C<add_task> method of the I<MT> class:

    MT->add_task(new MT::Task({
        # arguments; see listing of arguments below
    }));

=head1 METHODS

=head2 MT::Task->new(\%params)

The following are a list of parameters that can be specified when constructing
an I<MT::Task> object.

=over 4

=item * key

Defines a unique string for the task. This is used to manage a session record
for the task. The task session record is kept to record the last time the
task was executed. Session records are stored in the C<mt_session> table with
a 'kind' column value of 'PT' (periodic task).

=item * name

The name of the task. This is optional, but is used in recording error log
records when the task fails.

=item * frequency

The frequency is a duration of time expressed in seconds. This defines how
often the task is to be run. There is no guarantee that the task will be
run this often; only that it will not be executed more than once for that
period of time.

=item * code

The code to be executed when the task is invoked by I<MT::TaskMgr>. This
is a code reference and the routine is given the I<MT::Task> instance
as a parameter.

=back

=head2 $task->init

Initializes a I<MT::Task> instance.

=head2 $task->run

Called when running the task.

=head2 $task->key([$key])

Gets or sets the unique key registered for the task.

=head2 $task->name([$name])

Gets or sets the name registered for the task.

=head2 $task->frequency([$frequency])

Gets or sets the execution frequency for the task (in seconds). The default frequency is 86400 which is daily.

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
