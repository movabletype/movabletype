# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Plugin::Diagnosis::App;
use strict;
use warnings;
use Module::Load '';
use MT::Plugin::Diagnosis;
use MT::Plugin::Diagnosis::RepairTask;

sub DEPARTMENTS { 'PluginData', 'Revision', 'OrphanSite' }

sub permitted {
    return MT->instance->user->is_superuser;
}

sub list_template_param {
    my ($cb, $app, $param, $tmpl) = @_;
    pop @{ $app->{breadcrumbs} };
    $app->add_breadcrumb(translate('Diagnosis'));
    $param->{page_title} = translate('Diagnosis');
    $param->{saved_task} = 1 if $app->param('saved_task');
    $app->{session}->set('scan_result', undef);
}

sub listing_screens {
    return {
        object_label       => 'Repair Tasks',
        primary            => 'label',
        default_sort_key   => 'created_on',
        default_sort_order => 'descend',
        condition          => \&permitted,
        template           => File::Spec->catfile(plugin()->{full_path}, 'tmpl', 'cms', 'list_repair_task.tmpl'),
    };
}

sub list_actions {
    return {
        delete => {
            label                   => 'Delete',
            order                   => 100,
            continue_prompt_handler => sub { translate('Are you sure you want to delete the selected boilerplates?') },
            mode                    => 'delete',
            button                  => 1,
            js_message              => 'delete',
        },
    };
}

sub content_actions {
    return {
        scanner => {
            mode  => 'diagnosis_scanner',
            icon  => 'ic_search',
            label => 'Scan Database',
        },
    };
}

sub scanner {
    my $app = shift;
    return                           unless $app->validate_magic;
    return $app->permission_denied() unless permitted();

    my @department_loop;

    for my $department_name (DEPARTMENTS()) {
        my $class = 'MT::Plugin::Diagnosis::Department::' . $department_name;
        Module::Load::load($class);
        push @department_loop, {
            id          => $department_name,
            description => $class->description(),
        };
    }

    pop @{ $app->{breadcrumbs} };
    $app->add_breadcrumb(translate('Diagnosis'));

    $app->build_page('cms/scanner.tmpl', { department_loop => \@department_loop });
}

sub scan {
    my $app = shift;
    return                           unless $app->validate_magic;
    return $app->permission_denied() unless permitted();

    my @departments = do {
        my @req        = $app->multi_param('departments');
        my %exist_hash = map { $_ => 1 } DEPARTMENTS();
        grep { $exist_hash{$_} } @req;
    };

    my @result;

    for my $department_name (@departments) {
        my $class = 'MT::Plugin::Diagnosis::Department::' . $department_name;
        Module::Load::load($class);
        push @result, $class->scan;
    }
    $app->{session}->set('scan_result', \@result);

    return MT::Util::to_json({ error => undef, result => \@result });
}

sub repair {
    my $app = shift;
    return                           unless $app->validate_magic;
    return $app->permission_denied() unless permitted();

    my @request_tasks = $app->multi_param('tasks');

    (grep { $_ !~ /^\d+$/ } @request_tasks) && die 'something has gone wrong';

    my $sess = $app->{session}->get('scan_result') || die 'Something has gone wrong';

    for my $t (@$sess[@request_tasks]) {
        my $task = MT::Plugin::Diagnosis::RepairTask->new;
        $task->$_($t->{$_}) for ('department', 'params', 'description');
        $task->status(0);
        $task->author_id($app->user->id);
        $task->save || die($@ ? $@ : 'Task could not saved.');
    }

    return $app->redirect($app->uri(mode => 'list', args => { blog_id => 0, _type => 'repair_task', saved_task => 1 }));
}

1;
