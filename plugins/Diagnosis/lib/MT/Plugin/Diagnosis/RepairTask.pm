# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Plugin::Diagnosis::RepairTask;
use strict;
use warnings;
use Module::Load ''; # Don't import load function because it conflicts with MT::Object
use MT;
use MT::Util qw( ts2epoch epoch2ts offset_time );
use base qw( MT::Object );
use MT::Plugin::Diagnosis;

__PACKAGE__->install_properties({
    column_defs => {
        id          => 'integer not null auto_increment',
        author_id   => 'integer not null',
        status      => 'integer not null',
        department  => 'string(255) not null',
        params      => 'text not null',
        description => 'text not null',
        error       => 'text',
    },
    indexes => {
        created_on  => 1,
        modified_on => 1,
    },
    audit       => 1,
    datasource  => 'repair_task',
    primary_key => 'id',
});

sub STATUS_PENDING  { 0 }
sub STATUS_STARTED  { 1 }
sub STATUS_FINISHED { 2 }
sub STATUS_ABORTING { 3 }
sub STATUS_ABORTED  { 4 }

our $status_names = {
    STATUS_PENDING()  => 'Pending',
    STATUS_STARTED()  => 'Started',
    STATUS_FINISHED() => 'Finished',
    STATUS_ABORTING() => 'Aborting',
    STATUS_ABORTED()  => 'Aborted',
};

sub status_label {
    my $self = shift;
    return translate($status_names->{ $self->status || 0 });
}

sub ts_in_gmtime {
    my @ts = gmtime(time);
    return sprintf('%04d%02d%02d%02d%02d%02d', $ts[5] + 1900, $ts[4] + 1, @ts[3, 2, 1, 0]);
}

sub init {
    my $log = shift;
    $log->SUPER::init(@_);
    my $ts = ts_in_gmtime();
    $log->created_on($ts);
    $log->modified_on($ts);
    return $log;
}

sub save {
    my $self = shift;
    $self->modified_on(ts_in_gmtime());
    $self->SUPER::save(@_);
}

sub class_type {
    return 'repair_task';
}

sub class_label {
    return translate('Repair Task');
}

sub class_label_plural {
    return translate('Repair Tasks');
}

sub list_props {
    return {
        id => {
            base    => '__virtual.id',
            order   => 100,
            display => 'optional',
        },
        department => {
            auto  => 1,
            label => 'department',
            order => 200,
            display   => 'force',
        },
        status => {
            auto  => 1,
            label => 'status',
            order => 300,
            raw   => sub {
                my $prop = shift;
                my ($obj, $app, $opts) = @_;
                return $obj->status_label;
            },
            display   => 'default',
        },
        author_name => {
            base    => '__virtual.author_name',
            order   => 400,
            display => 'optional',
        },
        description => {
            auto      => 1,
            label     => 'description',
            use_blank => 1,
            order     => 500,
            display   => 'default',
        },
        params => {
            auto      => 1,
            label     => 'repair parameters',
            use_blank => 1,
            order     => 600,
            display   => 'default',
        },
        error => {
            auto      => 1,
            label     => 'error',
            use_blank => 1,
            order     => 700,
            raw   => sub {
                my $prop = shift;
                my ($obj, $app, $opts) = @_;
                return $obj->error ? $obj->error : translate('None'); # html escape is needed?
            },
            display   => 'optional',
        },
        created_on => {
            auto    => 1,
            base    => '__virtual.created_on',
            display => 'default',
            order   => 800,
            raw     => \&offset_time_of_field,
        },
        modified_on => {
            base  => '__virtual.modified_on',
            order => 900,
            raw   => \&offset_time_of_field,
        },
    };
}

sub offset_time_of_field {
    my $prop = shift;
    my ($obj, $app, $opts) = @_;
    my $field = $prop->id;
    my $epoch = ts2epoch(undef, $obj->$field, 1);
    $epoch = offset_time($epoch, undef);
    return epoch2ts(undef, $epoch, 1);
}

sub run_task {
    __PACKAGE__->count({ status => [STATUS_PENDING()] }) || return;
    my $start_time = time();
    my @ok_task_ids;
    my @failed_task_ids;
    my $iter = __PACKAGE__->load_iter({ status => [STATUS_PENDING()] });
    my $carry_over = 0;

    while (my $task = $iter->()) {
        if (time() - $start_time > 30) {
            $carry_over = 1;
            last ;
        }

        $task->status(STATUS_STARTED());
        $task->save;

        Module::Load::load(my $class = 'MT::Plugin::Diagnosis::Department::' . $task->department);
        my $success = eval { $class->repair($task) };

        if (my $error = $@) {
            push @failed_task_ids, $task->id;
            $task->status(STATUS_ABORTED());
            $task->error($error);
        } elsif ($success) {
            push @ok_task_ids, $task->id;
            $task->status(STATUS_FINISHED());
        }

        $task->save;
    }

    my $message;

    if ($carry_over) {
        $message = translate('Some Diagnosis and Repair tasks are finished. Some are remains.');
        $message .= translate('Some of finished tasks were failed.') if @failed_task_ids;
    } else {
        $message = translate('All Diagnosis and Repair tasks are finished.');
        $message .= translate('Some of them were failed.') if @failed_task_ids;
    }

    MT->log({
        message  => $message,
        level    => MT::Log::INFO(),
        metadata => sprintf(
            'Task IDs are as follows. Success: [%s], Failed: [%s]',
            join(',', @ok_task_ids), join(',', @failed_task_ids)
        ),
    });
}

1;
