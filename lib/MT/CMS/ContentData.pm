# Movable Type (r) (C) 2007-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::CMS::ContentData;

use strict;
use warnings;

use File::Basename ();
use File::Spec;
use JSON ();

use MT;
use MT::Blog;
use MT::CMS::ContentType;
use MT::ContentStatus;
use MT::ContentType;
use MT::Log;
use MT::Session;
use MT::Template;
use MT::TemplateMap;
use MT::Util;

sub edit {
    my ( $app, $param ) = @_;
    my $blog = $app->blog;
    my $cfg  = $app->config;
    my $data;

    unless ($blog) {
        return $app->return_to_dashboard( redirect => 1 );
    }

    $param ||= {};

    my $content_type_id = $app->param('content_type_id')
        or return $app->errtrans("Invalid request.");
    my $content_type = MT::ContentType->load($content_type_id)
        or return $app->errtrans('Invalid request.');

    my $perm = $app->permissions;
    $param->{can_publish_post} = 1 if (
      $perm->can_do('publish_all_content_data')
      || $perm->can_do('edit_all_content_data')
      || $perm->can_do('publish_content_data_via_list_'.$content_type->unique_id));

    if ( $content_type->blog_id != $blog->id ) {
        return $app->return_to_dashboard( redirect => 1 );
    }

    if ( $app->param('_recover') && !$app->param('reedit') ) {
        $app->param( '_type', 'content_data' );
        my $sess_obj = $app->autosave_session_obj;
        if ($sess_obj) {
            my $autosave_data = $sess_obj->thaw_data;
            if ($autosave_data) {
                $app->param( $_, $autosave_data->{$_} )
                    for keys %$autosave_data;
                my $id = $app->param('id');
                $app->delete_param('id')
                    if defined $id && !$id;
                $data = $autosave_data->{data};
                $param->{'recovered_object'} = 1;
            }
            else {
                $param->{'recovered_failed'} = 1;
            }
        }
        else {
            $param->{'recovered_failed'} = 1;
        }
    }

    if ( $app->param('reedit') ) {
        $data = $app->param('serialized_data');
        unless ( ref $data ) {
            $data = JSON::decode_json($data);
        }
        if ($data) {
            $app->param( $_, $data->{$_} ) for keys %$data;
        }
    }
    else {
        $app->param( '_type', 'content_data' );
        if ( my $sess_obj = $app->autosave_session_obj ) {
            $param->{autosaved_object_exists} = 1;
            $param->{autosaved_object_ts}
                = MT::Util::epoch2ts( $blog, $sess_obj->start );
        }
    }

    $param->{autosave_frequency} = $app->config->AutoSaveFrequency;
    $param->{name}               = $content_type->name;
    $param->{has_multi_line_text_field}
        = $content_type->has_multi_line_text_field;

    my $array           = $content_type->fields;
    my $ct_unique_id    = $content_type->unique_id;
    my $content_data_id = $app->param('id');

    $param->{use_revision} = $blog->use_revision ? 1 : 0;

    my $content_data;
    if ($content_data_id) {
        $content_data = MT::ContentData->load(
            {   id              => $content_data_id,
                blog_id         => $content_type->blog_id,
                content_type_id => $content_type->id,
            }
            )
            or return $app->error(
            $app->translate(
                'Load failed: [_1]',
                MT::ContentData->errstr
                    || $app->translate('(no reason given)')
            )
            );

        if ( $blog->use_revision ) {

            my $original_revision = $content_data->revision;
            my $rn                = $app->param('r');
            if ( defined $rn && $rn != $content_data->current_revision ) {
                my $status_text
                    = MT::ContentStatus::status_text( $content_data->status );
                $param->{current_status_text} = $status_text;
                $param->{current_status_label}
                    = $app->translate($status_text);
                my $rev
                    = $content_data->load_revision( { rev_number => $rn } );
                if ( $rev && @$rev ) {
                    $content_data = $rev->[0];
                    my $values = $content_data->get_values;
                    $param->{$_} = $values->{$_} for keys %$values;
                    $param->{loaded_revision} = 1;
                }
                $param->{rev_number} = $rn;
                $param->{no_snapshot} = 1 if $app->param('no_snapshot');
            }
            $param->{rev_date} = MT::Util::format_ts(
                '%Y-%m-%d %H:%M:%S',
                $content_data->modified_on,
                $blog, $app->user ? $app->user->preferred_language : undef
            );
        }

        $param->{identifier}
            = $app->param('identifier') || $content_data->identifier;

        my $status = $app->param('status') || $content_data->status;
        $status =~ s/\D//g;
        $param->{status} = $status;
        $param->{ 'status_' . MT::ContentStatus::status_text($status) } = 1;

        $param->{content_data_permalink}
            = MT::Util::encode_html( $content_data->permalink );

        $param->{authored_on_date} = $app->param('authored_on_date')
            || MT::Util::format_ts( '%Y-%m-%d', $content_data->authored_on,
            $blog, $app->user ? $app->user->preferred_language : undef );
        $param->{authored_on_time} = $app->param('authored_on_time')
            || MT::Util::format_ts( '%H:%M:%S', $content_data->authored_on,
            $blog, $app->user ? $app->user->preferred_language : undef );
        $param->{unpublished_on_date} = $app->param('unpublished_on_date')
            || MT::Util::format_ts( '%Y-%m-%d', $content_data->unpublished_on,
            $blog, $app->user ? $app->user->preferred_language : undef );
        $param->{unpublished_on_time} = $app->param('unpublished_on_time')
            || MT::Util::format_ts( '%H:%M:%S', $content_data->unpublished_on,
            $blog, $app->user ? $app->user->preferred_language : undef );
    }
    else {
        my $def_status;
        if ( $def_status = $app->param('status') ) {
            $def_status =~ s/\D//g;
            $param->{status} = $def_status;
        }
        else {
            $def_status = $blog->status_default;
        }
        $param->{ "status_" . MT::ContentStatus::status_text($def_status) }
            = 1;

        my @now = MT::Util::offset_time_list( time, $blog );
        $param->{authored_on_date} = $app->param('authored_on_date')
            || POSIX::strftime( '%Y-%m-%d', @now );
        $param->{authored_on_time} = $app->param('authored_on_time')
            || POSIX::strftime( '%H:%M:%S', @now );
        $param->{unpublished_on_date} = $app->param('unpublished_on_date');
        $param->{unpublished_on_time} = $app->param('unpublished_on_time');
    }

    $data = $content_data->data if $content_data && !$data;
    my $convert_breaks
        = $content_data
        ? MT::Serialize->unserialize( $content_data->convert_breaks )
        : undef;
    my $blockeditor_data
        = $content_data
        ? $content_data->block_editor_data()
        : undef;
    my $content_field_types = $app->registry('content_field_types');
    @$array = map {
        my $e_unique_id = $_->{unique_id};
        my $can_edit_field
            = $app->permissions->can_do( 'content_type:'
                . $ct_unique_id
                . '-content_field:'
                . $e_unique_id );
        if (   $can_edit_field
            || $app->permissions->can_do('edit_all_content_data') )
        {
            $_->{can_edit} = 1;
        }
        $_->{content_field_id} = $_->{id};
        delete $_->{id};

        if ( $app->param( $_->{content_field_id} ) ) {
            $_->{value} = $app->param( $_->{content_field_id} );
        }
        elsif ( $content_data_id || $data ) {
            $_->{value} = $data->{ $_->{content_field_id} };
        }
        else {
            # TODO: fix after updating values option.
            if ( $_->{type} eq 'select_box' || $_->{type} eq 'checkboxes' ) {
                my $delimiter = quotemeta( $_->{options_delimiter} || ',' );
                my @values = split $delimiter,
                    ( $_->{options}{initial_value} || '' );
                $_->{value} = \@values;
            }
            else {
                $_->{value} = $_->{options}{initial_value};
            }
        }

        my $content_field_type = $content_field_types->{ $_->{type} };

        if ( my $field_html_params
            = $content_field_type->{field_html_params} )
        {
            if ( !ref $field_html_params ) {
                $field_html_params
                    = MT->handler_to_coderef($field_html_params);
            }
            if ( 'CODE' eq ref $field_html_params ) {
                $field_html_params = $field_html_params->( $app, $_ );
            }

            if ( ref $field_html_params eq 'HASH' ) {
                for my $key ( keys %{$field_html_params} ) {
                    unless ( exists $_->{$key} ) {
                        $_->{$key} = $field_html_params->{$key};
                    }
                }
            }
        }

        if ( my $field_html = $content_field_type->{field_html} ) {
            if ( !ref $field_html ) {
                if ( $field_html =~ /\.tmpl$/ ) {
                    my $plugin = $content_field_type->{plugin};
                    $field_html
                        = $plugin->id eq 'core'
                        ? $app->load_tmpl($field_html)
                        : $plugin->load_tmpl($field_html);
                    $field_html = $field_html->text if $field_html;
                }
                else {
                    $field_html = MT->handler_to_coderef($field_html);
                }
            }
            if ( 'CODE' eq ref $field_html ) {
                $_->{field_html} = $field_html->( $app, $_ );
            }
            else {
                $_->{field_html} = $field_html;
            }
        }

        $_->{data_type} = $content_field_types->{ $_->{type} }{data_type};
        if ( $_->{type} eq 'multi_line_text' ) {
            if ( $convert_breaks
                && exists $$convert_breaks->{ $_->{content_field_id} } )
            {
                $_->{convert_breaks}
                    = $$convert_breaks->{ $_->{content_field_id} };
            }
            else {
                $_->{convert_breaks} = $_->{options}{input_format};
            }
        }
        $_;
    } @$array;

    $param->{fields} = $array;
    if ($blockeditor_data) {
        $param->{block_editor_data} = $blockeditor_data;
    }

    foreach
        my $name (qw( saved_added saved_changes err_msg content_type_id id ))
    {
        $param->{$name} = $app->param($name) if $app->param($name);
    }

    $param->{new_object}          = $content_data_id ? 0 : 1;
    $param->{object_label}        = $content_type->name;
    $param->{sitepath_configured} = $blog && $blog->site_path ? 1 : 0;

    ## Load text filters if user displays them
    my $filters = MT->all_text_filters;
    $param->{text_filters} = [];
    for my $filter ( keys %$filters ) {
        if ( my $cond = $filters->{$filter}{condition} ) {
            $cond = MT->handler_to_coderef($cond) if !ref($cond);
            next unless $cond->('content-type');
        }
        push @{ $param->{text_filters} },
            {
            filter_key   => $filter,
            filter_label => $filters->{$filter}{label},
            filter_docs  => $filters->{$filter}{docs},
            };
    }
    $param->{text_filters} = [ sort { $a->{filter_key} cmp $b->{filter_key} }
            @{ $param->{text_filters} } ];
    unshift @{ $param->{text_filters} },
        {
        filter_key   => '0',
        filter_label => $app->translate('None'),
        };

    $app->setup_editor_param($param);

    $param->{basename_limit} = ( $blog ? $blog->basename_limit : 0 ) || 30;

    $app->build_page( $app->load_tmpl('edit_content_data.tmpl'), $param );
}

sub save {
    my ($app) = @_;
    my $blog  = $app->blog;
    my $cfg   = $app->config;
    my $param = {};

    $app->validate_magic
        or return $app->errtrans("Invalid request.");
    my $perms = $app->permissions or return $app->permission_denied();

    my $content_data_id = $app->param('id');
    if ( !$content_data_id ) {
        return $app->permission_denied()
            unless $perms->can_do('create_new_content_data');
    }
    else {
        return $app->permission_denied()
            unless $perms->can_edit_content_data( $content_data_id,
            $app->user );
    }

    my $blog_id = $app->param('blog_id')
        or return $app->errtrans("Invalid request.");
    my $content_type_id = $app->param('content_type_id')
        or return $app->errtrans("Invalid request.");

    my $content_type = MT::ContentType->load($content_type_id);
    my $field_data   = $content_type->fields;

    my $content_field_types = $app->registry('content_field_types');

    my $convert_breaks = {};
    my $data           = {};
    if ( $app->param('from_preview') ) {
        $data = JSON::decode_json( scalar $app->param('serialized_data') );
    }
    else {
        foreach my $f (@$field_data) {
            my $content_field_type = $content_field_types->{ $f->{type} };
            $data->{ $f->{id} }
                = _get_form_data( $app, $content_field_type, $f );
            if ( $f->{type} eq 'multi_line_text' ) {
                $convert_breaks->{ $f->{id} } = $app->param(
                    'content-field-' . $f->{id} . '_convert_breaks' );
            }
        }
    }

    if ( $app->param('_autosave') ) {
        return MT::CMS::ContentType::_autosave_content_data( $app, $data );
    }

    if ( my $errors = _validate_content_fields( $app, $content_type, $data ) )
    {
        $app->param( '_type',           'content_data' );
        $app->param( 'reedit',          1 );
        $app->param( 'serialized_data', $data );
        my %param;
        $param{err_msg} = $errors->[0]{error};
        return $app->forward( 'view_content_data', \%param );
    }

    my $content_data
        = $content_data_id
        ? MT::ContentData->load($content_data_id)
        : MT::ContentData->new();

    my $archive_type = '';

    my $orig      = $content_data->clone;
    my $orig_file = '';
    if ( $content_data->id ) {
        $archive_type = 'ContentType';
        $orig_file
            = MT::Util::archive_file_for( $orig, $blog, $archive_type );
    }
    my $status_old = $content_data_id ? $content_data->status : 0;

    if ( $content_data->id ) {
        $content_data->modified_by( $app->user->id );

        $archive_type = 'ContentType';
        $orig_file
            = MT::Util::archive_file_for( $orig, $blog, $archive_type );
    }
    else {
        $content_data->author_id( $app->user->id );
        $content_data->blog_id($blog_id);
    }
    $content_data->content_type_id($content_type_id);
    $content_data->data($data);

    $content_data->identifier( scalar $app->param('identifier') );

    if ( $app->param('scheduled') ) {
        $content_data->status( MT::ContentStatus::FUTURE() );
    }
    else {
        my $status = $app->param('status');
        $content_data->status($status);
    }
    if ( ( $content_data->status || 0 ) != MT::ContentStatus::HOLD() ) {
        if ( !$blog->site_path || !$blog->site_url ) {
            return $app->error(
                $app->translate(
                    "Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined."
                )
            );
        }
    }

    my $ao_d = $app->param('authored_on_date');
    my $ao_t = $app->param('authored_on_time');
    my $uo_d = $app->param('unpublished_on_date');
    my $uo_t = $app->param('unpublished_on_time');

    my ( $previous_old, $next_old );

    # TODO: permission check
    if ($ao_d) {
        my %param = ();
        my $ao    = $ao_d . ' ' . $ao_t;
        my $ts    = MT::Util::valid_date_time2ts($ao);
        if ( !$ts ) {
            $param{err_msg} = $app->translate(
                "Invalid date '[_1]'; 'Published on' dates must be in the format YYYY-MM-DD HH:MM:SS.",
                $ao
            );
        }
        $param{return_args} = $app->param('return_args');
        if ( $param{err_msg} ) {
            $app->param( '_type',           'content_data' );
            $app->param( 'reedit',          1 );
            $app->param( 'serialized_data', $data );
            return $app->forward( "view_content_data", \%param );
        }
        if ( $content_data->authored_on ) {
            $previous_old = $content_data->previous(1);
            $next_old     = $content_data->next(1);
        }
        $content_data->authored_on($ts);
    }

    # TODO: permission check
    if ( $content_data->status != MT::ContentStatus::UNPUBLISH() ) {
        if ( $uo_d || $uo_t ) {
            my %param = ();
            my $uo    = $uo_d . ' ' . $uo_t;
            my $ts    = MT::Util::valid_date_time2ts($uo);
            if ( !$ts ) {
                $param{err_msg} = $app->translate(
                    "Invalid date '[_1]'; 'Unpublished on' dates must be in the format YYYY-MM-DD HH:MM:SS.",
                    $uo
                );
            }
            unless ( $param{err_msg} ) {
                $param{err_msg} = $app->translate(
                    "Invalid date '[_1]'; 'Unpublished on' dates should be dates in the future.",
                    $uo
                    )
                    if (
                    MT::DateTime->compare(
                        blog => $blog,
                        a    => { value => time(), type => 'epoch' },
                        b    => $ts
                    ) > 0
                    );
            }
            if ( !$param{err_msg} && $content_data->authored_on ) {
                $param{err_msg} = $app->translate(
                    "Invalid date '[_1]'; 'Unpublished on' dates should be later than the corresponding 'Published on' date.",
                    $uo
                    )
                    if (
                    MT::DateTime->compare(
                        blog => $blog,
                        a    => $content_data->authored_on,
                        b    => $ts
                    ) > 0
                    );
            }
            $param{show_input_unpublished_on} = 1 if $param{err_msg};
            $param{return_args} = $app->param('return_args');
            if ( $param{err_msg} ) {
                $app->param( '_type',           'content_data' );
                $app->param( 'reedit',          1 );
                $app->param( 'serialized_data', $data );
                return $app->forward( "view_content_data", \%param );
            }
            if ( $content_data->unpublished_on ) {
                $previous_old = $content_data->previous(1);
                $next_old     = $content_data->next(1);
            }
            $content_data->unpublished_on($ts);
        }
        else {
            $content_data->unpublished_on(undef);
        }
    }

    my $is_new = $content_data->id ? 0 : 1;

    $content_data->convert_breaks(
        MT::Serialize->serialize( \$convert_breaks ) );

    my $block_editor_data = $app->param('blockeditor-data');
    $content_data->block_editor_data($block_editor_data);

    $app->run_callbacks( 'cms_pre_save.content_data',
        $app, $content_data, $orig );

    $content_data->save
        or return $app->error(
        $app->translate(
            "Saving [_1] failed: [_2]", $content_type->name,
            $content_data->errstr
        )
        );

    $app->run_callbacks( 'cms_post_save.content_data',
        $app, $content_data, $orig );

    # Delete old archive files.
    if ( $app->config('DeleteFilesAtRebuild') && $content_data_id ) {
        $app->request->cache( 'file', {} );    # clear cache
        my $file = MT::Util::archive_file_for( $content_data, $blog,
            $archive_type );
        if (   $file ne $orig_file
            || $content_data->status != MT::ContentStatus::RELEASE() )
        {
            $app->publisher->remove_content_data_archive_file(
                ContentData => $orig,
                ArchiveType => $archive_type,
            );
        }
    }

    ## If the saved status is RELEASE, or if the *previous* status was
    ## RELEASE, then rebuild content data archives and indexes.
    ## Otherwise the status was and is HOLD, and we don't have to do anything.
    if ( ( $content_data->status || 0 ) == MT::ContentStatus::RELEASE()
        || $status_old == MT::ContentStatus::RELEASE() )
    {
        if ( $blog->count_static_templates($archive_type) == 0
            || MT::Util->launch_background_tasks )
        {
            my $res = MT::Util::start_background_task(
                sub {
                    $app->run_callbacks('pre_build');

                    $app->rebuild_content_data(
                        ContentData       => $content_data,
                        BuildDependencies => 1,
                        OldPrevious       => $previous_old
                        ? $previous_old->id
                        : undef,
                        OldNext => $next_old ? $next_old->id : undef,
                    );

                    $app->run_callbacks( 'rebuild', $blog );
                    $app->run_callbacks('post_build');
                    1;
                }
            );
            return unless $res;
        }
        else {
            return $app->redirect(
                $app->uri(
                    mode => 'start_rebuild',
                    args => {
                        blog_id => $content_data->blog_id,
                        next    => 0,
                        type    => 'content_data-' . $content_data->id,
                        content_data_id => $content_data->id,
                        is_new          => $is_new,
                        old_status      => $status_old,
                        $previous_old
                        ? ( old_previous => $previous_old->id )
                        : (),
                        $next_old ? ( old_next => $next_old->id ) : (),
                    },
                )
            );
        }
    }
    return $app->redirect(
        $app->uri(
            mode => 'view',
            args => {
                blog_id         => $blog_id,
                content_type_id => $content_type_id,
                _type           => 'content_data',
                type            => 'content_data_' . $content_type_id,
                id              => $content_data->id,
                $is_new ? ( saved_added => 1 ) : ( saved_changes => 1 ),
            }
        )
    );
}

sub delete {
    my $app = shift;
    return unless $app->validate_magic;

    my $blog;
    if ( my $blog_id = $app->param('blog_id') ) {
        $blog = MT::Blog->load($blog_id)
            or return $app->error(
            $app->translate( 'Cannot load blog #[_1].', $blog_id || '(none' )
            );
    }

    my $content_type_id = $app->param('content_type_id');
    unless ($content_type_id) {
        my $type = $app->param('type') || '';
        if ( $type =~ /^content_data_(\d+)$/ ) {
            $content_type_id = $1;
        }
    }
    my $content_type;
    if ($content_type_id) {
        $content_type = MT::ContentType->load(
            { id => $content_type_id, blog_id => $blog->id } );
    }
    unless ($content_type) {
        return $app->errtrans(
            'Cannot load content_type #[_1]',
            $content_type_id || '(none)'
        );
    }

    my $can_background
        = ( ( $blog && $blog->count_static_templates('ContentType') == 0 )
            || MT::Util->launch_background_tasks() ) ? 1 : 0;

    $app->setup_filtered_ids
        if $app->param('all_selected');
    my %rebuild_recipe;
    for my $id ( $app->multi_param('id') ) {
        my $class = $app->model('content_data');
        my $obj   = $class->load($id);
        return $app->call_return unless $obj;

        $app->run_callbacks( 'cms_delete_permission_filter.content_data',
            $app, $obj )
            or return $app->permission_denied;

        my %recipe;
        %recipe = $app->publisher->rebuild_deleted_content_data(
            ContentData => $obj,
            Blog        => $obj->blog,
        ) if $obj->status eq MT::ContentStatus::RELEASE();

        # Remove object from database
        my $content_type_name
            = defined $content_type->name && $content_type->name ne ''
            ? $content_type->name
            : $app->translate('Content Data');
        $obj->remove()
            or return $app->errtrans( 'Removing [_1] failed: [_2]',
            $content_type_name, $obj->errstr );
        $app->run_callbacks( 'cms_post_delete.content_data', $app, $obj );

        my $child_hash = $rebuild_recipe{ $obj->blog_id } || {};
        MT::__merge_hash( $child_hash, \%recipe );
        $rebuild_recipe{ $obj->blog_id } = $child_hash;

        # Clear cache for site stats dashboard widget.
        require MT::Util;
        MT::Util::clear_site_stats_widget_cache( $obj->blog->id )
            or return $app->errtrans('Removing stats cache failed.');
    }

    $app->add_return_arg( saved_deleted => 1 );

    if ( $app->config('RebuildAtDelete') ) {
        $app->run_callbacks('pre_build');

        my $rebuild_func = sub {
            foreach my $b_id ( keys %rebuild_recipe ) {
                my $b   = MT::Blog->load($b_id);
                my $res = $app->rebuild_archives(
                    Blog   => $b,
                    Recipe => $rebuild_recipe{$b_id},
                ) or return $app->publish_error();
                $app->rebuild_indexes( Blog => $b )
                    or return $app->publish_error();
                $app->run_callbacks( 'rebuild', $b );
            }
        };

        if ($can_background) {
            MT::Util::start_background_task($rebuild_func);
        }
        else {
            $rebuild_func->();
        }

        $app->add_return_arg( no_rebuild => 1 );
        my %params = (
            is_full_screen  => 1,
            redirect_target => $app->base
                . $app->path
                . $app->script . '?'
                . $app->return_args,
        );
        return $app->load_tmpl( 'rebuilding.tmpl', \%params );
    }

    return $app->call_return;
}

sub post_save {
    my ( $eh, $app, $obj, $orig_obj ) = @_;

    if ( $app->can('autosave_session_obj') ) {
        my $sess_obj = $app->autosave_session_obj;
        $sess_obj->remove if $sess_obj;
    }

    my $ct = $obj->content_type or return;
    my $author = $app->user;
    my $message;
    if ( !$orig_obj->id ) {
        $message = $app->translate( "New [_1] (ID:[_2]) added by user '[_3]'",
            $ct->name, $obj->id, $author->name );
    }
    elsif ( $orig_obj->status ne $obj->status ) {
        $message = $app->translate(
            "[_1] (ID:[_2]) edited and its status changed from [_3] to [_4] by user '[_5]'",
            $ct->name,
            $obj->id,
            $app->translate(
                MT::ContentStatus::status_text( $orig_obj->status )
            ),
            $app->translate( MT::ContentStatus::status_text( $obj->status ) ),
            $author->name
        );

    }
    else {
        $message = $app->translate( "[_1] (ID:[_2]) edited by user '[_3]'",
            $ct->name, $obj->id, $author->name );
    }
    require MT::Log;
    $app->log(
        {   message => $message,
            level   => MT::Log::INFO(),
            class   => 'content_data_' . $ct->id,
            $orig_obj->id ? ( category => 'edit' ) : ( category => 'new' ),
            metadata => $obj->id
        }
    );

    1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    if ( $app->can('autosave_session_obj') ) {
        my $sess_obj = $app->autosave_session_obj;
        $sess_obj->remove if $sess_obj;
    }

    my $ct = $obj->content_type or return;
    my $author = $app->user;

    $app->log(
        {   message => $app->translate(
                "[_1] (ID:[_2]) deleted by '[_3]'",
                $ct->name, $obj->id, $author->name
            ),
            level    => MT::Log::INFO(),
            class    => 'content_data_' . $ct->id,
            category => 'delete'
        }
    );
}

sub data_convert_to_html {
    my $app     = shift;
    my $format  = $app->param('format') || '';
    my @formats = split /\s*,\s*/, $format;
    my $field   = $app->param('field') || return '';

    my $text = $app->param($field) || '';

    my $result = {
        $field => $app->apply_text_filters( $text, \@formats ),
        format => $formats[0],
        field  => $field,
    };
    return $app->json_result($result);
}

sub make_content_actions {
    my $iter            = MT::ContentType->load_iter;
    my $content_actions = {};
    while ( my $ct = $iter->() ) {
        my $key = 'content_data.content_data_' . $ct->id;
        $content_actions->{$key} = {
            new => {
                label => 'Create new ' . $ct->name,
                icon  => 'ic_add',
                order => 100,
                mode  => 'view',
                args  => {
                    blog_id         => $ct->blog_id,
                    content_type_id => $ct->id,
                },
                class => 'icon-create',
            }
        };
    }
    $content_actions;
}

sub make_list_actions {
    my $common_actions = {
        'publish' => {
            label      => 'Publish',
            code       => '$Core::MT::CMS::Blog::rebuild_new_phase',
            mode       => 'rebuild_new_phase',
            order      => 100,
            js_message => 'publish',
            button     => 1,
            condition  => sub {
                return 0 if MT->app->mode eq 'view';
                _check_permission(
                    'publish_content_data_via_list_',
                    'publish_all_content_data_',
                );
            },
        },
        delete => {
            label      => 'Delete',
            order      => 110,
            code       => '$Core::MT::CMS::ContentData::delete',
            button     => 1,
            js_message => 'delete',
        },
        'set_draft' => {
            label     => "Unpublish Contents",
            order     => 200,
            code      => '$Core::MT::CMS::ContentData::draft_content_data',
            condition => sub {
                return 0 if MT->app->mode eq 'view';
                return _check_permission('set_content_data_draft_via_list_');
            },
        },
    };
    my $iter         = MT::ContentType->load_iter;
    my $list_actions = {};
    while ( my $ct = $iter->() ) {
        my $key = 'content_data.content_data_' . $ct->id;
        $list_actions->{$key} = $common_actions;
    }
    $list_actions;
}

sub _check_permission {
    my (@actions) = @_;

    my $app     = MT->app;
    my $type    = $app->param('type');
    my ($ct_id) = $type =~ /^content_data_([0-9]+)$/;
    my $ct      = MT::ContentType->load( $ct_id || 0 );
    return 0 unless $ct;

    my $terms = {
        author_id   => $app->user->id,
        permissions => \'IS NOT NULL',
        blog_id     => $app->blog->id,
    };

    return 0 unless MT->model('permission')->count($terms);

    my $iter = MT->model('permission')->load_iter($terms);
    while ( my $p = $iter->() ) {
        for my $act (@actions) {
            if ( $p->can_do( $act . $ct->unique_id ) ) {
                return 1;
            }
        }
    }

    return 0;
}

sub make_menus {
    my $menus         = {};
    my $blog_order    = 100;
    my $website_order = 100;
    my $iter = MT::ContentType->load_iter( undef, { sort => 'name' } );
    while ( my $ct = $iter->() ) {
        my $blog = MT::Blog->load( $ct->blog_id ) or next;
        my $key = 'content_data:' . $ct->id;
        $menus->{$key} = {
            label => $ct->name,
            mode  => 'list',
            args  => {
                _type   => 'content_data',
                type    => 'content_data_' . $ct->id,
                blog_id => $ct->blog_id,
            },
            order => $blog->is_blog ? $blog_order : $website_order,
            view  => $blog->is_blog ? 'blog'      : 'website',
            condition => sub {

                return 0 if $ct->blog_id != MT->app->blog->id;

                my $app = MT->instance;
                return 1
                    if ( $app->user->is_superuser
                    || $app->user->can_manage_content_data );

                return 1 if $app->can_do('edit_all_content_data');

                my $blog = $app->blog;
                my $blog_ids
                    = !$blog         ? undef
                    : $blog->is_blog ? [ $blog->id ]
                    :   [ $blog->id, map { $_->id } @{ $blog->blogs } ];

                require MT::Permission;
                my $iter = MT::Permission->load_iter(
                    {   author_id => $app->user->id,
                        (   $blog_ids
                            ? ( blog_id => $blog_ids )
                            : ( blog_id => { not => 0 } )
                        ),
                    }
                );

                my $cond;
                while ( my $p = $iter->() ) {
                    $cond = 1, last
                        if $p->has( 'manage_content_data:' . $ct->unique_id );

                    $cond = 1, last
                        if $p->has( 'create_content_data:' . $ct->unique_id );
                }
                return $cond ? 1 : 0;

            },
        };
        if ( $blog->is_blog ) {
            $blog_order += 100;
        }
        else {
            $website_order += 100;
        }
    }
    $menus;
}

sub _validate_content_fields {
    my $app = shift;
    my ( $content_type, $data ) = @_;
    my $content_field_types = $app->registry('content_field_types');

    my @errors;

    foreach my $f ( @{ $content_type->fields } ) {
        my $content_field_type = $content_field_types->{ $f->{type} };
        my $param_name         = 'content-field-' . $f->{id};
        my $d                  = $data->{ $f->{id} };

        if ( exists $f->{options}{required}
            && $f->{options}{required} )
        {
            my $has_data;
            if ( ref $d eq 'ARRAY' ) {
                $has_data = @{$d} ? 1 : 0;
            }
            else {
                $has_data = ( defined $d && $d ne '' ) ? 1 : 0;
            }
            unless ($has_data) {
                my $label = $f->{options}{label};
                push @errors,
                    {
                    field_id => $f->{id},
                    error =>
                        $app->translate(qq{"${label}" field is required.}),
                    };
                next;
            }
        }

        if ( my $ss_validator = $content_field_type->{ss_validator} ) {
            if ( !ref $ss_validator ) {
                $ss_validator = MT->handler_to_coderef($ss_validator);
            }
            if ( 'CODE' eq ref $ss_validator ) {
                if ( my $error = $ss_validator->( $app, $f, $d ) ) {
                    push @errors,
                        {
                        field_id => $f->{id},
                        error    => $error,
                        };
                }
            }
        }
    }

    @errors ? \@errors : undef;
}

sub validate_content_fields {
    my $app = shift;

    # TODO: permission check

    my $blog_id = $app->blog ? $app->blog->id : undef;
    my $content_type_id = $app->param('content_type_id') || 0;
    my $content_type = MT::ContentType->load(
        { id => $content_type_id, blog_id => $blog_id } );

    return $app->json_error( $app->translate('Invalid request.') )
        unless $blog_id && $content_type;

    my $content_field_types = $app->registry('content_field_types');
    my $data                = {};
    foreach my $f ( @{ $content_type->fields } ) {
        my $content_field_type = $content_field_types->{ $f->{type} };
        $data->{ $f->{id} }
            = _get_form_data( $app, $content_field_type, $f );
    }

    my $invalid_count = 0;
    my %invalid_fields;
    if ( my $errors = _validate_content_fields( $app, $content_type, $data ) )
    {
        $invalid_count = scalar @{$errors};
        %invalid_fields = map { $_->{field_id} => $_->{error} } @{$errors};
    }

    $app->json_result(
        { invalidCount => $invalid_count, invalidFields => \%invalid_fields }
    );
}

sub _get_form_data {
    my ( $app, $content_field_type, $form_data ) = @_;

    if ( my $data_load_handler = $content_field_type->{data_load_handler} ) {
        if ( !ref $data_load_handler ) {
            $data_load_handler = MT->handler_to_coderef($data_load_handler);
        }
        if ( 'CODE' eq ref $data_load_handler ) {
            return $data_load_handler->( $app, $form_data );
        }
        else {
            return $data_load_handler;
        }
    }
    else {
        my $value = $app->param( 'content-field-' . $form_data->{id} );
        if ( defined $value && $value ne '' ) {
            $value;
        }
        else {
            undef;
        }
    }
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $terms = $load_options->{terms} || {};

    my $object_ds = $filter->object_ds;
    $object_ds =~ /content_data_(\d+)/;
    my $content_type_id = $1;
    unless ($content_type_id) {
        my $type = $app->param('type') || '';
        $type =~ /content_data_(\d+)/;
        $content_type_id = $1;
    }
    $terms->{content_type_id} = $content_type_id;
    my $content_type = MT::ContentType->load({ id => $content_type_id });

    my $user = $app->user;
    return if $user->is_superuser;

    my $blog_ids;
    $blog_ids = delete $terms->{blog_id}
        if exists $terms->{blog_id};
    delete $terms->{author_id}
        if exists $terms->{author_id};

    if ( !$blog_ids ) {
        my $blog_id = $app->param('blog_id') || 0;
        my $blog = $blog_id ? $app->blog : undef;
        $blog_ids
            = !$blog         ? undef
            : $blog->is_blog ? [$blog_id]
            :   [ $blog->id, map { $_->id } @{ $blog->blogs } ];
    }

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {   author_id => $user->id,
            (   $blog_ids
                ? ( blog_id => $blog_ids )
                : ( blog_id => { 'not' => 0 } )
            ),
        }
    );

    my $filters;
    while ( my $perm = $iter->() ) {
        my $user_filter;
        $user_filter->{blog_id} = $perm->blog_id;
        if (   !$perm->can_do('publish_all_content_data')
            && !$perm->can_do('edit_all_content_data'))
        {
            $user_filter->{author_id} = $user->id;
        }
        push @$filters, ( '-or', $user_filter );
    }

    my $new_terms;
    push @$new_terms, ($terms)
        if ( keys %$terms );
    push @$new_terms, ( '-and', $filters || { blog_id => 0 } );
    $load_options->{terms} = $new_terms;


}

sub start_import {
    my $app = shift;
    $app->add_breadcrumb( $app->translate('Import Site Content') );
    my $param = { page_title => $app->translate('Import Site Content'), };
    $app->load_tmpl( 'not_implemented_yet.tmpl', $param );
}

sub start_export {
    my $app = shift;
    $app->add_breadcrumb( $app->translate('Export Site Content') );
    my $param = { page_title => $app->translate('Export Site Content'), };
    $app->load_tmpl( 'not_implemented_yet.tmpl', $param );
}

sub preview {
    my $app = shift;
    if ( $app->config('PreviewInNewWindow') ) {
        $app->{hide_goback_button} = 1;
    }
    return unless $app->validate_magic;
    my $content_data = _create_temp_content_data($app);
    return _build_content_data_preview( $app, $content_data );
}

sub _create_temp_content_data {
    my $app             = shift;
    my $id              = $app->param('id');
    my $blog_id         = $app->param('blog_id');
    my $content_type_id = $app->param('content_type_id');

    return $app->errtrans('Invalid request.')
        unless $blog_id && $content_type_id;

    my $content_data;
    if ($id) {
        $content_data = MT::ContentData->load(
            {   id              => $id,
                blog_id         => $blog_id,
                content_type_id => $content_type_id
            }
        ) or return $app->errtrans('Invalid request.');
    }
    else {
        $content_data = MT::ContentData->new;
        $content_data->set_values(
            {   id              => -1,
                author_id       => $app->user->id,
                blog_id         => $blog_id,
                content_type_id => $content_type_id,
            }
        );
    }

    return $app->return_to_dashboard( permission => 1 )
        unless $app->permissions->can_edit_content_data( $content_data,
        $app->user );

    $content_data->status( scalar $app->param('status') );

    my $content_field_types = $app->registry('content_field_types');
    my $content_type        = $content_data->content_type;
    my $field_data          = $content_type->fields;
    my $data                = {};
    for my $f (@$field_data) {
        my $content_field_type = $content_field_types->{ $f->{type} };
        $data->{ $f->{id} }
            = _get_form_data( $app, $content_field_type, $f );
    }
    $content_data->data($data);

    return $content_data;
}

sub _build_content_data_preview {
    my $app = shift;
    my ( $content_data, %param ) = @_;
    my $content_type = $content_data->content_type;
    my $blog_id      = $app->param('blog_id');
    my $blog         = $app->blog;
    my $id           = $app->param('id');
    my $user_id      = $app->user->id;

    my $basename         = $app->param('identifier');
    my $preview_basename = $app->preview_object_basename;
    $content_data->identifier( $basename || $preview_basename );

    my @data = ( { data_name => 'author_id', data_value => $user_id } );
    $app->run_callbacks( 'cms_pre_preview.content_data',
        $app, $content_data, \@data );

    my $at       = 'ContentType';
    my $tmpl_map = MT::TemplateMap->load(
        {   archive_type => $at,
            is_preferred => 1,
            blog_id      => $blog_id,
        }
    );

    my $tmpl;
    my $fullscreen;
    my $archive_file = '';
    my $orig_file    = '';
    my $file_ext     = '';
    if ($tmpl_map) {
        $tmpl         = MT::Template->load( $tmpl_map->template_id );
        $file_ext     = $blog->file_extension || '';
        $archive_file = $content_data->archive_file;

        my $blog_path = $blog->archive_path || $blog->site_path;
        $archive_file = File::Spec->catfile( $blog_path, $archive_file );
        my $path;
        ( $orig_file, $path ) = File::Basename::fileparse($archive_file);
        $file_ext = '.' . $file_ext if $file_ext ne '';
        $archive_file
            = File::Spec->catfile( $path, $preview_basename . $file_ext );
    }
    else {
        $tmpl       = $app->load_tmpl('preview_content_data_content.tmpl');
        $fullscreen = 1;
    }
    return $app->error( $app->translate('Cannot load template.') )
        unless $tmpl;

    my $ctx = $tmpl->context;
    $ctx->stash( 'content',      $content_data );
    $ctx->stash( 'content_type', $content_type );
    $ctx->stash( 'blog',         $blog );
    $ctx->{current_timestamp}    = $content_data->authored_on;
    $ctx->{curernt_archive_type} = $at;
    $ctx->var( 'preview_template', 1 );

    my $archiver = MT->publisher->archiver($at);
    if ( my $params = $archiver->template_params ) {
        $ctx->var( $_, $params->{$_} ) for keys %$params;
    }

    my $html = $tmpl->output;

    unless ( defined $html ) {
        my $preview_error = $app->translate( "Publish error: [_1]",
            MT::Util::encode_html( $tmpl->errstr ) );
        $param{preview_error} = $preview_error;
        my $tmpl_plain = $app->load_tmpl('preview_content_data_content.tmpl');
        $tmpl->text( $tmpl_plain->text );
        $html = $tmpl->output;
        defined($html)
            or return $app->error(
            $app->translate( "Publish error: [_1]", $tmpl->errstr ) );
        $fullscreen = 1;
    }

    # If MT is configured to do 'local' previews, convert all
    # the normal blog URLs into the domain used by MT itself (ie,
    # blog is published to www.example.com, which is a different
    # server from where MT runs, mt.example.com; previews therefore
    # should occur locally, so replace all http://www.example.com/
    # with http://mt.example.com/).
    my ( $old_url, $new_url );
    if ( $app->config('LocalPreviews') ) {
        $old_url = $blog->site_url;
        $old_url =~ s!^(https?://[^/]+?/)(.*)?!$1!;
        $new_url = $app->base . '/';
        $html =~ s!\Q$old_url\E!$new_url!g;
    }

    if ( !$fullscreen ) {
        my $fmgr = $blog->file_mgr;

        ## Determine if we need to build directory structure,
        ## and build it if we do. DirUmask determines
        ## directory permissions.
        my $path = File::Basename::dirname($archive_file);
        $path =~ s!/$!!
            unless $path eq '/'; ## OS X doesn't like / at the end in mkdir().
        unless ( $fmgr->exists($path) ) {
            $fmgr->mkpath($path);
        }

        if ( $fmgr->exists($path) && $fmgr->can_write($path) ) {
            $fmgr->put_data( $html, $archive_file );
            $param{preview_file} = $preview_basename;
            my $preview_url = $content_data->archive_url;
            $preview_url
                =~ s! / \Q$orig_file\E ( /? ) $!/$preview_basename$file_ext$1!x;

            # We also have to translate the URL used for the
            # published file to be on the MT app domain.
            if ( defined $new_url ) {
                $preview_url =~ s!^\Q$old_url\E!$new_url!;
            }

            $param{preview_url} = $preview_url;

            # we have to make a record of this preview just in case it
            # isn't cleaned up by re-editing, saving or cancelling on
            # by the user.
            my $sess_obj = MT::Session->get_by_key(
                {   id   => $preview_basename,
                    kind => 'TF',                # TF = Temporary File
                    name => $archive_file,
                }
            );
            $sess_obj->start(time);
            $sess_obj->save;

        # In the preview screen, in order to use the site URL of the blog,
        # there is likely to be mixed-contents.(http and https)
        # If MT is configured to do 'PreviewInNewWindow', MT will open preview
        # screen on the new window/tab.
            if ( $app->config('PreviewInNewWindow') ) {
                return $app->redirect($preview_url);
            }
        }
        else {
            $fullscreen = 1;
            $param{preview_error}
                = $app->translate(
                "Unable to create preview files in this location: [_1]",
                $path );
            my $tmpl_plain
                = $app->load_tmpl('preview_content_data_content.tmpl');
            $tmpl->text( $tmpl_plain->text );
            $tmpl->reset_tokens;
            $html = $tmpl->output;
            $param{preview_body} = $html;
        }
    }
    else {
        $param{preview_body} = $html;
    }

    $param{id} = $id if $id;
    $param{new_object} = $param{id} ? 0 : 1;
    $param{status} = $content_data->status;

    my @cols = qw(
        author_id
        blog_id
        content_type_id
        convert_breaks
        ct_unique_id
        id
        identifier
        status
        week_number

        authored_on_date
        authored_on_time
        basename_manual
        basename_old
        revision-note
        save_revision
        unpublished_on_date
        unpublished_on_time
    );

    for my $col (@cols) {
        push @data,
            {
            data_name  => $col,
            data_value => scalar $app->param($col),
            };
    }

    push @data,
        {
        data_name  => 'serialized_data',
        data_value => $content_data->column('data'),
        };

    $param{content_data_loop} = \@data;

    my $list_title = $content_type->name;
    $app->add_breadcrumb(
        $app->translate($list_title),
        $app->uri(
            mode => 'list',
            args => {
                _type   => 'content_data',
                type    => 'content_data_' . $content_type->id,
                blog_id => $blog_id,
            },
        ),
    );
    if ($id) {
        $app->add_breadcrumb( $content_type->name
                || $app->translate('(untitled)') );
    }
    else {
        $app->add_breadcrumb(
            $app->translate(
                'New [_1]', $content_type->name || '(untitled)'
            )
        );
        $param{nav_new_content_data} = 1;
    }

    $param{object_type}  = 'content_data';
    $param{object_label} = $content_type->name;

    my $rev_numbers = $app->param('rev_numbers') || '';
    my $collision = $app->param('collision');
    $param{diff_view} = $rev_numbers || $collision;
    $param{collision} = 1;
    if ( my @rev_numbers = split /,/, $rev_numbers ) {
        $param{comparing_revisions} = 1;
        $param{rev_a}               = $rev_numbers[0];
        $param{rev_b}               = $rev_numbers[1];
    }

    $param{dirty} = $app->param('dirty') ? 1 : 0;

    if ($fullscreen) {
        return $app->load_tmpl( 'preview_content_data.tmpl', \%param );
    }
    else {
        $app->request( 'preview_object', $content_data );
        return $app->load_tmpl( 'preview_content_data_strip.tmpl', \%param );
    }
}

sub publish_content_data {
    my $app = shift;
    _update_content_data_status(
        $app,
        MT::ContentStatus::RELEASE(),
        $app->multi_param('id')
    );
}

sub draft_content_data {
    my $app = shift;
    _update_content_data_status( $app, MT::ContentStatus::HOLD(),
        $app->multi_param('id') );
}

sub _update_content_data_status {
    my $app = shift;
    my ( $new_status, @ids ) = @_;

    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->info('--- Start update_content_data_status.');

    return $app->errtrans('Need a status to update content data')
        unless $new_status;
    return $app->errtrans('Need content data to update status')
        unless @ids;

    my $app_author = $app->user;
    my $perms      = $app->permissions;

    MT::Util::Log->info(' Start load content data.');

    my ( @objects, %rebuild_these );
    require MT::ContentData;
    for my $id (@ids) {
        my $content_data = MT::ContentData->load( $id || 0 );
        return $app->errtrans( 'One of the content data ([_1]) did not exist',
            $id )
            unless $content_data;

        return $app->permission_denied
            unless $app_author->is_superuser
            || $app_author->permissions( $content_data->id )
            ->can_edit_content_data( $content_data, $app_author );

        if (   $app->config('DeleteFilesAtRebuild')
            && $content_data->status == MT::ContentStatus::RELEASE() )
        {
            $app->publisher->remove_content_data_archive_file(
                ContentData => $content_data,
                ArchiveType => 'ContentType',
                Force => $new_status != MT::ContentStatus::RELEASE() ? 1 : 0,
            );
        }

        my $original   = $content_data->clone;
        my $old_status = $content_data->status;
        $content_data->status($new_status);
        $content_data->save and $rebuild_these{$id} = 1;

        # Clear cache for site stats dashboard widget.
        if ((      $content_data->status == MT::ContentStatus::RELEASE()
                || $old_status == MT::ContentStatus::RELEASE()
            )
            && $old_status != $content_data->status
            )
        {
            require MT::Util;
            MT::Util::clear_site_stats_widget_cache( $content_data->blog_id )
                or return $app->errtrans('Removing stats cache failed.');
        }

        my $message = $app->translate(
            "[_1] (ID:[_2]) status changed from [_3] to [_4]",
            $content_data->class_label,
            $content_data->id,
            $app->translate( MT::ContentStatus::status_text($old_status) ),
            $app->translate( MT::ContentStatus::status_text($new_status) )
        );
        $app->log(
            {   message  => $message,
                level    => MT::Log::INFO(),
                class    => 'content_data_' . $content_data->content_type_id,
                category => 'edit',
                metadata => $content_data->id
            }
        );
        push( @objects, { current => $content_data, original => $original } );
    }

    MT::Util::Log->info(' End   load content data.');

    MT::Util::Log->info(' Start rebuild_these.');

    my $tmpl = $app->rebuild_these_content_data( \%rebuild_these,
        how => MT::App::CMS::NEW_PHASE() );

    MT::Util::Log->info(' End   rebuild_these.');

    if (@objects) {
        my $obj = $objects[0]{current};

        MT::Util::Log->info(' Start callbacks cms_post_bulk_save.');

        $app->run_callbacks( 'cms_post_bulk_save.content_data',
            $app, \@objects );

        MT::Util::Log->info(' End   callbacks cms_post_bulk_save.');
    }

    MT::Util::Log->info('--- End   update_entry_status.');

    $tmpl;
}

sub can_save {
    my ( $eh, $app, $id, $obj, $original ) = @_;

    return 0 unless $obj;

    my $perms = $app->permissions
        or return 0;

    if ($id) {
        $original ||= MT->model('content_data')->load($id)
            or return 0;

        return 0
            unless $perms->can_edit_content_data( $original, $app->user );
    }
    else {
        my $user         = $app->user         or return 0;
        my $content_type = $obj->content_type or return 0;

        return 0
            unless $user->can_do('create_new_content_data')
            || $perms->can_do('create_new_content_data')
            || $perms->can_do(
            'create_new_content_data_' . $content_type->unique_id );

        return 0
            unless $obj->status == MT::ContentStatus::HOLD()
            || $user->can_do('publish_all_content_data')
            || $perms->can_do('publish_all_content_data')
            || $perms->can_do(
            'publish_all_content_data_' . $content_type->unique_id )
            || (
            $obj->author_id == $user->id
            && $perms->can_do(
                'publish_own_content_data_' . $content_type->unique_id
            )
            );
    }

    1;
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $user = $app->user or return;
    $user->permissions(0)->can_edit_content_data( $obj, $user );
}

1;
