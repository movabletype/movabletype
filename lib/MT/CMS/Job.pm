package MT::CMS::Job;

use strict;
use MT::Util qw( format_ts relative_date );
use Data::Dumper;

sub list {
    my $app = shift;
    my ($param) = @_;
    $param ||= {};
    return $app->errtrans("Permission denied.")
      if !$app->user->is_superuser;

    require MT::TheSchwartz::FuncMap;
    my $type = $param->{type} || MT::TheSchwartz::FuncMap->class_type;

    my $user  = $app->user;
    my $blog  = $app->blog;
    my $q     = $app->param;
    my $perms = $app->permissions;

    # TODO: permissions check?

    # TODO: filtering
    my $filter_key = $q->param('filter_key') || '';
    my $filter_col = $q->param('filter')     || '';
    my $filter_val = $q->param('filter_val');
    if ( $filter_col && $filter_val ) {
        if ( 'power_edit' eq $filter_col ) {
            $filter_col = 'jobid';
            unless ( 'ARRAY' eq ref($filter_val) ) {
                my @values = $app->param('filter_val');
                $filter_val = \@values;
            }
        }
    }

    my $job_funcs = _get_job_funcs();

    my $is_power_edit = $q->param('is_power_edit');

    my $hasher = sub {
        my ( $obj, $row ) = @_;

        my $job_func = _get_job_func($obj);
        my $class    = $job_func->{class};
        eval "require $class;";
        $row->{name} = $job_func->{label};
        $row->{describe} = eval { $class->describe_job($obj); };

        my $ts = _ts_time( $obj->insert_time );
        $row->{insert_time_formatted} =
          format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(),
            $ts, $blog,
            ( $app->user ? $app->user->preferred_language : undef ) );
        $row->{insert_time_relative} = relative_date( $ts, time, $blog );

        $row->{error_loop} = _get_errors( $app, $obj->jobid );
    };

    my %terms;
    my %param;
    $param{is_power_edit} = $is_power_edit;
    if ($is_power_edit) {
        $terms{$filter_col} = $filter_val;
        $param{has_expanded_mode} = 0;
        delete $param{view_expanded};
        $param{screen_id} = "batch-edit-job";
        $param{screen_class} .= " batch-edit";
        $param{has_list_actions} = 0;
    }
    else {
        $param{has_expanded_mode} = 1;
        $param{screen_id}         = 'list-job';
        $param{screen_class}      = 'list-job';
    }
    $param{object_type}  = 'ts_job';
    $param{search_label} = $app->translate('Job');
    $param{jobfunc_loop} = $job_funcs;
    $param{saved}        = $q->param('saved');

    _set_jobqueue_status(\%param);

    return $app->listing(
        {
            type     => 'ts_job',
            template => 'list_job.tmpl',
            terms    => \%terms,
            args     => { sort => 'priority', 'direction' => 'descend' },
            params   => \%param,
            code     => $hasher,
        }
    );
}

sub save_jobs {
    my $app = shift;
    return $app->errtrans("Permission denied.")
      if !$app->user->is_superuser;

    $app->validate_magic or return;

    my $perms = $app->permissions;
    my $type  = $app->param('_type');
    my $q     = $app->param;
    my @p     = $q->param;
    require MT::TheSchwartz::Job;
    require MT::Log;
    for my $p (@p) {
        next unless $p =~ /^priority_(\d+)/;
        my $jobid    = $1;
        my $ts_job   = MT::TheSchwartz::Job->load( { jobid => $jobid } );
        my $orig_obj = $ts_job->clone;
        my $priority = $q->param( 'priority_' . $jobid );
        $ts_job->priority($priority);
        $app->run_callbacks( 'cms_pre_save.' . $type, $app, $ts_job, $orig_obj )
          || return $app->error(
            $app->translate(
                "Saving [_1] failed: [_2]", $ts_job->class_label,
                $app->errstr
            )
          );
        $ts_job->save
          or return $app->error(
            $app->translate(
                "Saving Job '[_1]' failed: [_2]", $ts_job->jobid,
                $ts_job->errstr
            )
          );
        my $job_func = _get_job_func($ts_job);
        my $class    = $job_func->{class};
        eval "require $class;";
        my $describe = eval { $class->describe_job($ts_job); };
        $describe ||= $job_func->{label};

        $app->log(
            {
                message => $app->translate(
                    "[_1] '[_2]' (ID:[_3]) edited by user '[_4]'",
                    $ts_job->class_label, $describe,
                    $ts_job->jobid,       $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'ts_job',
                category => 'edit',
            }
        );
    }
    $app->add_return_arg( 'saved' => 1, is_power_edit => 1 );
    $app->call_return;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    my $job_func = _get_job_func($obj);
    my $class    = $job_func->{class};
    eval "require $class;";
    my $describe = eval { $class->describe_job($obj); };
    $describe ||= $job_func->{label};

    $app->log(
        {
            message => $app->translate(
                "Job for '[_1]' (ID:[_2]) deleted by '[_3]'",
                $describe, $obj->jobid, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub change_priority {
    my $app = shift;
    my @ids = $app->param('id');

    $app->param( 'is_power_edit', 1 );
    $app->param( 'filter',        'power_edit' );
    $app->param( 'filter_val',    \@ids );
    $app->mode('list_job');
    $app->forward( "list_job", { type => $app->param('_type') } );
}

sub _get_errors {
    my ( $app, $jobid ) = @_;

    require MT::TheSchwartz::Error;
    my $iter = MT::TheSchwartz::Error->load_iter( { jobid => $jobid } );
    my @errors;
    while ( my $error = $iter->() ) {
        my $ts = _ts_time( $error->error_time );
        push @errors,
          {
            error_time_formatted => format_ts(
                MT::App::CMS::LISTING_TIMESTAMP_FORMAT(),
                $ts, $app->blog,
                ( $app->user ? $app->user->preferred_language : undef )
            ),
            error_message => $error->message,
          };
    }
    \@errors;
}

sub _ts_time {
    my ($time) = @_;
    my @tm = gmtime($time);
    sprintf "%04d%02d%02d%02d%02d%02d", $tm[5] + 1900, $tm[4] + 1,
      @tm[ 3, 2, 1, 0 ];
}

sub _get_job_func {
    my ($ts_job) = @_;
    my $job_funcs = _get_job_funcs();
    my @job_func = grep { $_->{id} == $ts_job->funcid } @$job_funcs;
    $job_func[0];
}

{
    my @job_funcs;

    sub _get_job_funcs {
        return \@job_funcs if @job_funcs;

        require MT::TheSchwartz::FuncMap;
        my $workers = MT->component('core')->registry('task_workers');
        for my $id ( keys %$workers ) {
            my $worker = $workers->{$id};
            my $funcmap =
              MT::TheSchwartz::FuncMap->load(
                { funcname => $worker->{class} } );

            push @job_funcs,
              {
                id    => $funcmap->funcid,
                class => $worker->{class},
                label => $worker->{label}->(),
              };
        }
        \@job_funcs;
    }
}

sub _set_jobqueue_status {
    my ($param) = @_;
    require MT::JobQueue;
    my $job_queue = MT::JobQueue->new;
    $param->{jq_is_running} = $job_queue->is_running;
    $param->{jq_cpu} = $job_queue->cpu;
    $param->{jq_memory} = $job_queue->memory;
    $param->{jq_uptime} = $job_queue->uptime;
}

1;
