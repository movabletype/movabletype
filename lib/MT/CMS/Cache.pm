package MT::CMS::Cache;

use strict;
use MT::I18N qw( substr_text );
use MT::Util qw( epoch2ts format_ts );

sub list {
    my $app = shift;
    my $q   = $app->param;
    my ($param) = @_;
    $param ||= {};
    my $blog_id = $app->param('blog_id');
    return $app->errtrans("Permission denied.")
        if !$app->user->is_superuser;

    my $user  = $app->user;
    my $blog  = $app->blog;

    my $hasher = sub {
        my ( $obj, $row ) = @_;

        $row->{cache_key} = $obj->id;
        $row->{cache_value} = substr_text($obj->data(), 0, 100);

        my $ts = epoch2ts($blog, $obj->start);
        $row->{start_time_formatted} =
          format_ts( MT::App::CMS::LISTING_TIMESTAMP_FORMAT(),
            $ts, $blog,
            ( $user ? $user->preferred_language : undef ) );
    };

    my %terms;
    $terms{kind} = 'CO';
    $terms{id} = 'blog::' . $blog_id . '%' if $blog_id;

    my %args;
    $args{sort}      = 'id';
    $args{direction} = 'ascend';
    $args{like}      = { id => 1, } if $blog_id;

    my %param;
    $param{blog_id}       = $blog_id if $blog_id;
    $param{screen_id}     = 'list-cache';
    $param{screen_class}  = 'list-cache';
    $param{object_type}   = 'session';
    $param{search_label}  = $app->translate('Cache');
    $param{saved}         = $q->param('saved');
    $param{saved_deleted} = $q->param('saved_deleted');

    $app->listing(
        {
            type     => 'session',
            template => 'list_cache.tmpl',
            terms    => \%terms,
            args     => \%args,
            params   => \%param,
            code     => $hasher,
        }
    );
}

sub edit {
    my $app = shift;
    my %param  = $_[0] ? %{ $_[0] } : ();

    my $q     = $app->param;
    my $id    = $q->param('id');
    my $user  = $app->user;
    my $perms = $app->permissions;
    my $blog  = $app->blog;

    require MT::Permission;
    $app->return_to_dashboard( redirect => 1 ) if !$user->is_superuser;

    require MT::Session;
    my $cols = MT::Session->column_names;
    my $obj  = MT::Session->load($id);

    for my $col (@$cols) {
        $param{$col} =
          defined $q->param($col) ? $q->param($col) : $obj->$col();
    }

    $param{key}  = $obj->id;
    $param{body} = $obj->data;
    my $ts = epoch2ts($blog, $obj->start);
        $param{start_time_formatted} =
          format_ts( MT::App::CMS::LISTING_TIMESTAMP_FORMAT(),
            $ts, $blog,
            ( $user ? $user->preferred_language : undef ) );

    $app->load_list_actions( 'cache', \%param );

    $app->add_breadcrumb( $app->translate('Caches'),
        $app->uri( mode => 'list_cache' ) );
    $app->add_breadcrumb( $obj->id );

    if ($perms) {
        my $pref_param =
          $app->load_template_prefs( $perms->template_prefs );
        %param = ( %param, %$pref_param );
    }

    $param{template_lang}       = 'html';
    $param{saved}               = 1 if $q->param('saved');
    $param{search_label}        = $app->translate('Caches');
    $param{object_type}         = 'session';
    $param{object_label}        = MT::Session->class_label;
    $param{object_label_plural} = MT::Session->class_label_plural;

    $app->load_tmpl( 'edit_cache.tmpl', \%param );
}


sub save {
    my $app = shift;
    $app->validate_magic or return;

    my $user  = $app->user;
    return $app->error( $app->translate("Permission denied.") )
        if !$user->is_superuser;
    my $blog_id = $app->param('blog_id');

    my $filter_result = $app->run_callbacks( 'cms_save_filter.cache', $app );

    if ( !$filter_result ) {
        my %param = ();
        $param{_type}       = 'cache';
        $param{error}       = $app->errstr;
        $param{return_args} = $app->param('return_args');
        return $app->forward( "view", \%param );
    }

    require MT::Session;
    my $id = $app->param('id');
    my $obj = MT::Session->load($id)
        or return $app->error(
            $app->translate( "No such [_1].", MT::Session->class_label ) );
    my $orig_obj = $obj->clone;

    $obj->id($app->param('key'));
    $obj->data($app->param('cache-body'));

    $app->run_callbacks( 'cms_pre_save.cache', $app, $obj, $orig_obj )
      || return $app->error(
        $app->translate(
            "Saving [_1] failed: [_2]",
            MT::Session->class_label, $app->errstr
        )
      );

    $obj->save
      or return $app->error(
        $app->translate(
            "Saving [_1] failed: [_2]",
            MT::Session->class_label, $obj->errstr
        )
      );

    if ($obj->id ne $orig_obj->id) {
        $orig_obj->remove
          or return $app->error(
            $app->translate(
                "Saving [_1] failed: [_2]",
                MT::Session->class_label, $obj->errstr
            )
          );
    }

    require MT::Log;
    my $message =
        $app->translate( "[_1] '[_2]' (ID:[_3]) added by user '[_4]'",
        'Module cache', '', $obj->id, $user->name );

    $app->log(
        {
            message => $message,
            level   => MT::Log::INFO(),
            class   => 'cache',
            category => 'edit',
            metadata => $obj->data
        }
    );

    $app->run_callbacks( 'cms_post_save.cache', $app, $obj, $orig_obj );

    return $app->redirect(
        $app->uri(
            'mode' => 'view',
            args   => {
                '_type' => 'cache',
                ($blog_id ? (blog_id => $blog_id) : ()),
                id      => $obj->id,
                saved => 1,
            }
        )
    );
}

sub delete {
    my $app = shift;
    $app->validate_magic() or return;

    my $user  = $app->user;
    return $app->error( $app->translate("Permission denied.") )
        if !$user->is_superuser;

    require MT::Session;
    for my $id ($app->param('id')) {
        my $obj = MT::Session->load($id);
        return $app->call_return unless $obj;

        $app->run_callbacks( 'cms_delete_permission_filter.cache', $app, $obj )
          || return $app->error(
            $app->translate( "Permission denied: [_1]", $app->errstr() ) );


        $obj->remove()
            or return $app->errtrans(
                'Removing [_1] failed: [_2]',
                $app->translate('cache'),
                $obj->errstr
            );
        $app->run_callbacks( 'cms_post_delete.cache', $app, $obj );

        require MT::Log;
        $app->log(
            {
                message => $app->translate(
                    "Module Cache '[_1]' deleted by '[_2]'",
                    $obj->id, $user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'system',
                category => 'delete'
            }
        );
    }

    $app->add_return_arg( saved_deleted => 1 );
    return $app->call_return();
}

1;
