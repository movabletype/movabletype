# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::CMS::Common;

use strict;

use MT::Util qw( format_ts offset_time_list relative_date remove_html);

sub save {
    my $app  = shift;
    my $q    = $app->param;
    my $type = $q->param('_type');

    return $app->errtrans("Invalid request.")
      unless $type;

    # being a general-purpose method, lets look for a mode handler
    # that is specifically for editing this type. if we find it,
    # reroute to it.

    my $save_mode = 'save_' . $type;
    if ( my $hdlrs = $app->handlers_for_mode($save_mode) ) {
        return $app->forward($save_mode);
    }

    my $id = $q->param('id');
    $q->param( 'allow_pings', 0 )
      if ( $type eq 'category' ) && !defined( $q->param('allow_pings') );

    $app->validate_magic() or return;
    my $author = $app->user;

    # Check permissions
    my $perms = $app->permissions;

    if ( !$author->is_superuser ) {
        if ( ($type ne 'author') && ($type ne 'template') )
        {    # for authors, blog-ctx $perms is not relevant
            return $app->errtrans("Permisison denied.")
              if !$perms && $id;
        }

        $app->run_callbacks( 'cms_save_permission_filter.' . $type, $app, $id )
          || return $app->error(
            $app->translate( "Permission denied: [_1]", $app->errstr() ) );
    }

    my $param = {};
    if ( $type eq 'author' ) {
        if ( my $delim = $q->param('tag_delim') ) {
            $param->{ 'auth_pref_tag_delim_' . $delim } = 1;
            $param->{'auth_pref_tag_delim'} = $delim;
        }
        $param->{languages} =
          MT::I18N::languages_list( $app, $q->param('preferred_language') )
          if $q->param('preferred_language');
        $param->{create_personal_weblog} =
          $q->param('create_personal_weblog') ? 1 : 0;
        require MT::Permission;
        my $sys_perms = MT::Permission->perms('system');
        foreach (@$sys_perms) {
            $param->{ 'perm_can_' . $_->[0] } = 1
              if $q->param( 'can_' . $_->[0] );
        }
    }

    my $filter_result = $app->run_callbacks( 'cms_save_filter.' . $type, $app );

    if ( !$filter_result ) {
        my %param = (%$param);
        $param{error}       = $app->errstr;
        $param{return_args} = $app->param('return_args');

        if ( ( $app->param('cfg_screen') || '' ) eq 'cfg_prefs' ) {
            return MT::CMS::Blog::cfg_prefs( $app, \%param );
        }
        elsif ( $app->param('forward_list') ) {
            return $app->json_error($param{error});
        }
        else {
            if ($type) {
                my $mode = 'view_' . $type;
                if ( $app->handlers_for_mode($mode) ) {
                    return $app->forward( $mode, \%param );
                }
            }
            return $app->forward( 'view', \%param );
        }
    }

    return $app->errtrans(
        'The Template Name and Output File fields are required.')
      if $type eq 'template' && !$q->param('name') && !$q->param('outfile');

    if ( $type eq 'template' ) {

        # check for autosave
        if ( $q->param('_autosave') ) {
            return $app->autosave_object();
        }
    }

    my $class = $app->model($type)
      or return $app->errtrans( "Invalid type [_1]", $type );
    my ($obj);
    if ($id) {
        $obj = $class->load($id)
            or return $app->error($app->translate("Invalid ID [_1]", $id));
    }
    else {
        $obj = $class->new;
    }

    my $original = $obj->clone();
    my $names    = $obj->column_names;
    my %values   = map { $_ => ( scalar $q->param($_) ) } @$names;
    if ($type eq 'blog'
        && $obj->class eq 'blog'
        && (!$app->param('cfg_screen')
            || ( $app->param('cfg_screen')
                && ( $app->param('cfg_screen') || '' ) eq 'cfg_prefs' )
        )
        )
    {
        unless ( $obj->id ) {
            my $subdomain = $q->param('site_url_subdomain');
            $subdomain = '' if !$q->param('use_subdomain');
            $subdomain .= '.' if $subdomain && $subdomain !~ /\.$/;
            $subdomain =~ s/\.{2,}/\./g;
            my $path = $q->param('site_url_path');
            $values{site_url} = "$subdomain/::/$path";

            $values{site_path} = $app->param( 'site_path_absolute' )
                if $app->param( 'use_absolute' ) && $app->param( 'site_path_absolute' );
        }

        unless ( $author->is_superuser
            || ( $perms && $perms->can_do('save_all_settings_for_blog') ) )
        {
            if ( $id && !( $perms->can_do('save_blog_pathinfo') ) ) {
                delete $values{site_url};
                delete $values{site_path};
                delete $values{archive_url};
                delete $values{archive_path};
                delete $values{site_path_absolute}
                    if $values{site_path_absolute};
            }
            if ( $id && !( $perms->can_do('save_blog_config') ) ) {
                delete $values{$_} foreach grep {
                           $_ ne 'site_path'
                        && $_ ne 'site_url'
                        && $_ ne 'archive_path'
                        && $_ ne 'archive_url'
                } @$names;
            }
        }
    }

    if ( $type eq 'website' || ( $type eq 'blog' && $obj->class eq 'website' ) ) {
        unless ( $author->is_superuser
            || ( $perms && $perms->can_do('save_all_settings_for_website') ) )
        {
            if ( $id && !( $perms->can_do('save_blog_pathinfo') ) ) {
                delete $values{site_url};
                delete $values{site_path};
            }
            if ( $id && !( $perms->can_do('save_blog_config') ) ) {
                delete $values{$_} foreach grep {
                         $_ ne 'site_path'
                      && $_ ne 'site_url'
                } @$names;
            }
        }
    }

    if ( $type eq 'author' ) {

        #FIXME: Legacy columns - remove them
        my @cols = qw(is_superuser can_create_blog can_view_log can_edit_templates);
        if ( !$author->is_superuser ) {
            delete $values{$_} for @cols;
        }
        else {
            if ( !$id || ( $author->id != $id ) ) {
                # Assign the auth_type unless it was assigned
                # through the form.
                $obj->auth_type($app->config->AuthenticationModule)
                    unless $obj->auth_type;
                if ( $values{'status'} == MT::Author::ACTIVE() ) {
                    my $sys_perms = MT::Permission->perms('system');
                    if ( defined($q->param('can_administer'))
                      && $q->param('can_administer')) {
                        $obj->is_superuser(1);
                    }
                    else {
                        foreach (@$sys_perms) {
                            my $name = 'can_' . $_->[0];
                            if ( defined $q->param($name) ) {
                                $obj->$name( $q->param($name) );
                                delete $values{$name};
                            }
                            else {
                                $obj->$name(0);
                            }
                        }
                    }
                }
            }
        }
        delete $values{'password'};
    }

    if ( $type eq 'blog' || $type eq 'website' ) {
        # If this is a new blog, set the preferences, archive settings
        # and template set to the defaults.
        if ( !$obj->id ) {
            $obj->language( $q->param('blog_language') || MT->config->DefaultLanguage );
            $obj->nofollow_urls(1);
            $obj->follow_auth_links(1);
            $obj->page_layout('layout-wtt');
            my @authenticators = qw( MovableType );
            my @default_auth = split /,/, MT->config('DefaultCommenterAuth');
            foreach my $auth (@default_auth) {
                my $a = MT->commenter_authenticator($auth);
                if ( !defined $a
                    || ( exists $a->{condition} && ( !$a->{condition}->() ) ) )
                {
                    next;
                }
                push @authenticators, $auth;
            }
            $obj->commenter_authenticators( join ',', @authenticators );
            require MT::Theme;
            my $theme = MT::Theme->load($app->param($type.'_theme'))
                or return $app->error('Internal error: Unknown theme!');
            $obj->theme_id( $theme->{id} );
        }

        if ( $values{file_extension} ) {
            $values{file_extension} =~ s/^\.*//
              if ( $q->param('file_extension') || '' ) ne '';
        }

        unless ( $values{site_url} =~ m!/$! ) {
            my $url = $values{site_url};
            $values{site_url} = $url;
        }
    }

    if ( $type eq 'entry' || $type eq 'page' ) {

        # This has to happen prior to callbacks since callbacks may
        # be affected by the translation...

        # translates naughty words when PublishCharset is NOT UTF-8
        $app->_translate_naughty_words($obj);
    }

    if ( $type eq 'template' ) {
        if (   $q->param('type') eq 'archive'
            && $q->param('archive_type') )
        {
            $values{type} = $q->param('archive_type');
        }
    }

    delete $values{'id'} if exists( $values{'id'} ) && !$values{'id'};
    $obj->set_values( \%values );

    if ( $obj->properties->{audit} ) {
        $obj->created_by( $author->id ) unless $obj->id;
        $obj->modified_by( $author->id ) if $obj->id;
    }

    unless (
        $app->run_callbacks( 'cms_pre_save.' . $type, $app, $obj, $original ) )
    {
        if ( 'blog' eq $type ) {
            my $meth = $q->param('cfg_screen');
            if ( $meth && $app->handlers_for_mode($meth) ) {
                $app->error(
                    $app->translate( "Save failed: [_1]", $app->errstr ) );
                return $app->$meth;
            }
        }
        $param->{return_args} = $app->param('return_args');
        return edit( $app,
            {
                %$param,
                error => $app->translate( "Save failed: [_1]", $app->errstr )
            }
        );
    }

    # Done pre-processing the record-to-be-saved; now save it.

    $obj->touch() if ( $type eq 'blog' || $type eq 'website' );

    $obj->save
      or return $app->error(
        $app->translate( "Saving object failed: [_1]", $obj->errstr ) );

    # Now post-process it.
    $app->run_callbacks( 'cms_post_save.' . $type, $app, $obj, $original )
      or return $app->error( $app->errstr() );

    # Save NWC settings and revision settings
    my $screen = $q->param('cfg_screen') || '';
    if ( ($type eq 'blog' || $type eq 'website') && $screen eq 'cfg_entry' ) {
        my @fields;
        push( @fields, 'title' )     if $q->param('nwc_title');
        push( @fields, 'text' )      if $q->param('nwc_text');
        push( @fields, 'text_more' ) if $q->param('nwc_text_more');
        push( @fields, 'keywords' )  if $q->param('nwc_keywords');
        push( @fields, 'excerpt' )   if $q->param('nwc_excerpt');
        push( @fields, 'tags' )      if $q->param('nwc_tags');
        my $fields = @fields ? join( ',', @fields ) : 0;
        $obj->smart_replace_fields( $fields );
        $obj->smart_replace( $q->param('nwc_smart_replace') );
        $obj->save;
    }

    # Finally, decide where to go next, depending on the object type.
    my $blog_id = $q->param('blog_id');
    if ( $type eq 'blog' || $type eq 'website' ) {
        $blog_id = $obj->id;
    }

    # if we are saving/publishing a template, make sure to log on activity log
    if ( $type eq 'template' ) {
        my $blog = $app->model('blog')->load($obj->blog_id);
        if ($blog) {
            $app->log({
                message => $app->translate("'[_1]' edited the template '[_2]' in the blog '[_3]'",  $app->user->name, $obj->name, $blog->name),
                level   => MT::Log::INFO(),
                blog_id => $blog->id,
                class => 'template',
                category => 'edit',
            });
        } else {
            $app->log({
                message => $app->translate("'[_1]' edited the global template '[_2]'", $app->user->name, $obj->name),
                level   => MT::Log::INFO(),
                class => 'template',
                category => 'edit',
            });
        }
    }

    # TODO: convert this to use $app->call_return();
    # then templates can determine the page flow.
    if ( my $cfg_screen = $q->param('cfg_screen') ) {
        if ( $cfg_screen eq 'cfg_publish_profile' ) {
            my $dcty = $obj->custom_dynamic_templates || 'none';
            if ( ( $dcty eq 'all' ) || ( $dcty eq 'archives' ) ) {
                require MT::CMS::Blog;
                my %param = ();
                MT::CMS::Blog::_create_build_order( $app, $obj, \%param );
                $q->param( 'single_template', 1 ); # to show tmpl full-screen
                if ( $dcty eq 'all' ) {
                    $q->param( 'type', $param{build_order} );
                }
                elsif ( $dcty eq 'archives' ) {
                    my @ats = map { $_->{archive_type} } @{ $param{archive_type_loop} };
                    $q->param( 'type', join( ',', @ats ) );
                }
                return MT::CMS::Blog::start_rebuild_pages($app);
            }
        }
        if ( $cfg_screen eq 'cfg_templatemaps' ) {
            $cfg_screen = 'cfg_prefs';
        }
        my $site_path = $obj->site_path;
        my $fmgr      = $obj->file_mgr;
        unless ( $fmgr->exists($site_path) ) {
            $fmgr->mkpath($site_path);
        }
        $app->add_return_arg( no_writedir => 1 )
          unless $fmgr->exists($site_path) && $fmgr->can_write($site_path);
    }
    elsif ( $type eq 'template' && $q->param('rebuild') ) {
        if ( !$id ) {
            # add return argument for newly created templates
            $app->add_return_arg( id => $obj->id );
        }
        if ( $obj->build_type ) {
            if ( $obj->type eq 'index' ) {
                $q->param( 'type',            'index-' . $obj->id );
                $q->param( 'tmpl_id',         $obj->id );
                $q->param( 'single_template', 1 );
                return $app->forward( 'start_rebuild' );
            } else {
                # archive rebuild support
                $q->param( 'id', $obj->id );
                $q->param( 'reedit', $obj->id );
                return $app->forward( 'publish_archive_templates' );
            }
        }
    }
    elsif ( $type eq 'template' ) {
        if (   $obj->type eq 'archive'
            || $obj->type eq 'category'
            || $obj->type eq 'page'
            || $obj->type eq 'individual' )
        {
            my $static_maps = delete $app->{static_dynamic_maps};
            require MT::TemplateMap;
            my $terms = {};
            if ( $static_maps && @$static_maps ) {
                $terms->{id} = $static_maps;
            }
            else {
                # all existing maps have been dynamic
                # do nothing
            }
            if ( %$terms ) {
                my @maps = MT::TemplateMap->load($terms);
                my @ats = map { $_->archive_type } @maps;
                if ($#ats >= 0) {
                    $q->param( 'type', join( ',', @ats ) );
                    $q->param( 'with_indexes', 1 );
                    $q->param( 'no_static', 1 );
                    $q->param( 'template_id', $obj->id );
                    $q->param( 'single_template', 1 );
                    require MT::CMS::Blog;
                    return MT::CMS::Blog::start_rebuild_pages($app);
                }
            }
        }
    }
    elsif ( $type eq 'blog' || $type eq 'website' ) {
        return $app->redirect(
            $app->uri(
                'mode' => 'cfg_prefs',
                args   => { blog_id => $blog_id, saved => 1 }
            )
        );
    }
    elsif ( $type eq 'author' ) {
        # Delete the author's userpic thumb (if any); it'll be regenerated.
        if ($original->userpic_asset_id != $obj->userpic_asset_id) {
            my $thumb_file = $original->userpic_file();
            my $fmgr = MT::FileMgr->new('Local');
            if ($fmgr->exists($thumb_file)) {
                $fmgr->delete($thumb_file);
            }
        }
    }

    if ( $app->param('forward_list') ) {
        return $app->forward('filtered_list');
    }

    $app->add_return_arg( 'id' => $obj->id ) if !$original->id;
    $app->add_return_arg( 'saved' => 1 );
    $app->call_return;
}

sub edit {
    my $app  = shift;
    my $q    = $app->param;
    my $type = $q->param('_type');

    return $app->errtrans("Invalid request.")
      unless $type;

    # being a general-purpose method, lets look for a mode handler
    # that is specifically for editing this type. if we find it,
    # reroute to it.

    my $edit_mode = $app->mode . '_' . $type;
    if ( my $hdlrs = $app->handlers_for_mode($edit_mode) ) {
        return $app->forward($edit_mode, @_);
    }

    my %param = eval { $_[0] ? %{ $_[0] } : (); };
    die Carp::longmess if $@;
    my $class = $app->model($type) or return;
    my $blog_id = $q->param('blog_id');

    if ( defined($blog_id) && $blog_id ) {
        return $app->error( $app->translate("Invalid parameter") )
          unless ( $blog_id =~ m/\d+/ );
    }

    $app->remove_preview_file;

    if ( $q->param('_recover') ) {
        my $sess_obj = $app->autosave_session_obj;
        if ($sess_obj) {
            my $data = $sess_obj->thaw_data;
            if ($data) {
                $q->param( $_, $data->{$_} ) for keys %$data;
                $param{'recovered_object'} = 1;
            }
            else {
                $param{'recovered_failed'} = 1;
            }
        }
        else {
            $param{'recovered_failed'} = 1;
        }
    }
    elsif ( $q->param('qp') ) {
        foreach (qw( title text )) {
            my $data = $q->param($_);
            $q->param( $_, $data );
        }
    }

    $param{autosave_frequency} = $app->config->AutoSaveFrequency;

    my $id     = $q->param('id');
    my $perms  = $app->permissions;
    my $author = $app->user;
    my $cfg    = $app->config;
    $param{styles} = '';
    if ( $type eq 'author' ) {
        if ( $perms || $blog_id ) {
            return $app->return_to_dashboard( redirect => 1 );
        }
    }
    else {
        if ( ( !$perms || !$blog_id )
            && ( $type eq 'entry' || $type eq 'page'
                 || $type eq 'category' || $type eq 'folder'
                 || $type eq 'comment'  || $type eq 'ping' ) ) {
            return $app->return_to_dashboard( redirect => 1 );
        }
    }

    my $cols = $class->column_names;
    require MT::Promise;
    my $obj_promise = MT::Promise::delay(
        sub {
            return $class->load($id) || undef;
        }
    );

    if ( !$author->is_superuser ) {
        $app->run_callbacks( 'cms_view_permission_filter.' . $type,
            $app, $id, $obj_promise )
          || return $app->permission_denied();
    }
    my $obj;
    my $blog;
    my $blog_class = $app->model('blog');
    if ($blog_id) {
        $blog = $blog_class->load($blog_id);
    }
    else {
        $blog_id = 0;
    }

    if ($id) {    # object exists, we're just editing it.
          # Stash the object itself so we don't have to keep forcing the promise
        $obj = $obj_promise->force()
          or return $app->error(
            $app->translate(
                "Load failed: [_1]",
                $class->errstr || $app->translate("(no reason given)")
            )
          );

        # Populate the param hash with the object's own values
        for my $col (@$cols) {
            $param{$col} =
              defined $q->param($col) ? $q->param($col) : $obj->$col();
        }

        # Make certain any blog-specific element matches the blog we're
        # dealing with. If not, call shenanigans.
        if (   ( exists $param{blog_id} )
            && ( $blog_id != ($obj->blog_id || 0) ) )
        {
            return $app->return_to_dashboard( redirect => 1 );
        }

        if ( $class->properties->{audit} ) {
            my $creator = MT::Author->load(
                {
                    id   => $obj->created_by(),
                    type => MT::Author::AUTHOR()
                }
            );
            if ($creator) {
                $param{created_by} = $creator->name;
            } else {
                $param{created_by} = $app->translate("(user deleted)");
            }
            if ( my $mod_by = $obj->modified_by() ) {
                my $modified = MT::Author->load(
                    {
                        id   => $mod_by,
                        type => MT::Author::AUTHOR()
                    }
                );
                if ($modified) {
                    $param{modified_by} = $modified->name;
                }
                else {
                    $param{modified_by} = $app->translate("(user deleted)");
                }

            }
            # Since legacy MT installs will still have a
            # timestamp type for their modified_on fields,
            # we cannot reliably disaply a modified on date
            # by default; we must only show the modification
            # date IF there is also a modified_by value.
            if ( my $ts = $obj->modified_on ) {
                $param{modified_on_ts} = $ts;
                $param{modified_on_formatted} =
                  format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $ts, undef, $app->user ? $app->user->preferred_language : undef );
            }
            if ( my $ts = $obj->created_on ) {
                $param{created_on_ts} = $ts;
                $param{created_on_formatted} =
                  format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $ts, undef, $app->user ? $app->user->preferred_language : undef );
            }
        }

        $param{new_object} = 0;
    }
    else {    # object is new
        $param{new_object} = 1;
        for my $col (@$cols) {
            $param{$col} = $q->param($col);
        }
    }

    if ( $type eq 'website' || $type eq 'blog' ) {
        require MT::Theme;
        my $themes = MT::Theme->load_all_themes;
        $param{ theme_loop } = [
            map {
                { key => $_->{id}, label => $_->label, }
            }
            grep {
                !defined $_->{class} || $_->{class} eq 'both' || $_->{class} eq $type
            } values %$themes
        ];
        $param{'master_revision_switch'} = $app->config->TrackRevisions;
    }

    my $res = $app->run_callbacks('cms_edit.' . $type, $app, $id, $obj, \%param);
    if (!$res) {
        return $app->error($app->callback_errstr());
    }

    if ($param{autosave_support}) {
        # autosave support, but don't bother if we're reediting
        if ( !$app->param('reedit') ) {
            my $sess_obj = $app->autosave_session_obj;
            if ($sess_obj) {
                $param{autosaved_object_exists} = 1;
                $param{autosaved_object_ts} =
                  MT::Util::epoch2ts( $blog, $sess_obj->start );
            }
        }
    }

    if ( ( $q->param('msg') || "" ) eq 'nosuch' ) {
        $param{nosuch} = 1;
    }
    for my $p ( $q->param ) {
        $param{$p} = $q->param($p) if $p =~ /^saved/;
    }
    $param{page_actions} = $app->page_actions($type, $obj);
    if ( $class->can('class_label') ) {
        $param{object_label} = $class->class_label;
    }
    if ( $class->can('class_label_plural') ) {
        $param{object_label_plural} = $class->class_label_plural;
    }

    my $tmpl_file = $param{output} || "edit_${type}.tmpl";
    $param{object_type} ||= $type;
    $param{screen_id} ||= "edit-$type";
    $param{screen_class} .= " edit-$type";
    return $app->load_tmpl( $tmpl_file, \%param );
}

sub list {
    my $app  = shift;
    my $q    = $app->param;
    my $type = $q->param('_type');
    my $scope = $app->blog                     ? ( $app->blog->is_blog ? 'blog' : 'website' )
              : defined $app->param('blog_id') ? 'system'
              :                                  'user'
              ;
    my $blog_id = $app->blog ? $app->blog->id
                :              0
                ;
    my $list_mode = 'list_' . $type;
    if ( my $hdlrs = $app->handlers_for_mode($list_mode) ) {
        return $app->forward($list_mode);
    }
    my %param;
    $param{list_type} = $type;

    my $screen_settings = MT->registry('listing_screens' => $type )
        or return $app->error(
            $app->translate('Unknown action [_1]', $list_mode)
        );

    # Condition check
    if ( my $cond = $screen_settings->{condition} ) {
        $cond = MT->handler_to_coderef($cond)
            if 'CODE' ne ref $cond;
        $app->error();
        unless ( $cond->($app) ) {
            if ( $app->errstr ) {
                return $app->error( $app->errstr );
            }
            return $app->return_to_dashboard;
        }
    }

    # Validate scope
    if ( my $view = $screen_settings->{view} ) {
        $view = [ $view ] unless ref $view;
        my %view = map { $_ => 1 } @$view;
        if ( !$view{$scope} ) {
            return $app->return_to_dashboard(
                redirect => 1,
            );
        }
    }

    # Permission check
    if ( defined $screen_settings->{permission} && !$app->user->is_superuser() ) {
        my $allowed = 0;
        my @act = split /\s*,\s*/, $screen_settings->{permission};
        my $blog_ids = undef;
        if ( $blog_id ) {
            push @$blog_ids, $blog_id;
            if ( $scope eq 'website' ) {
                push @$blog_ids, $_->id foreach @{ $app->blog->blogs() };
            }
        }
        foreach my $p ( @act ) {
            $allowed = 1, last
                if $app->user->can_do($p, at_least_one => 1, ( $blog_ids ? ( blog_id => $blog_ids ) : () ) );
        }
        return $app->permission_denied()
            unless $allowed;
    }

    my $initial_filter;

    my $list_prefs = $app->user->list_prefs || {};
    my $list_pref = $list_prefs->{$type}{$blog_id} || {};
    my $rows = $list_pref->{rows} || 50;      ## FIXME: Hardcoded
    my $last_filter = $list_pref->{last_filter} || '';
    $last_filter = '' if $last_filter eq '_allpass';
    my $last_items = $list_pref->{last_items} || [];
    my $initial_sys_filter = $q->param('filter_key');
    if ( !$initial_sys_filter && $last_filter =~ /\D/ ) {
        $initial_sys_filter = $last_filter;
    }
    $param{'limit_' . $rows} = 1;

    require MT::ListProperty;
    my $obj_type = $screen_settings->{object_type} || $type;
    my $obj_class = MT->model($obj_type);
    my $list_props = MT::ListProperty->list_properties($type);

    if ( $app->param('no_filter') ) {
        # Nothing to do.
    }
    elsif ( my @cols = $app->param('filter') ) {
        my @vals = $app->param('filter_val');
        my @items;
        my @labels;
        for my $col ( @cols ) {
            my $val = shift @vals;
            if ( my $prop = $list_props->{$col} ) {
                my ( $args, $label );
                if ( $prop->has('args_via_param') ) {
                    $args = $prop->args_via_param($app, $val)
                        or return $app->error( $prop->errstr );
                }
                if ( $prop->has('label_via_param') ) {
                    $label = $prop->label_via_param($app, $val)
                        or return $app->error( $prop->errstr );
                }
                push @items, {
                    type => $col,
                    args => ($args || {}),
                };
                push @labels, ($label || $prop->label);
            }
        }
        $initial_filter = {
            label => join( ', ', @labels ),
            items => \@items,
        };
    }
    elsif ( $initial_sys_filter ) {
        require MT::CMS::Filter;
        $initial_filter = MT::CMS::Filter::filter($app, $type, $initial_sys_filter);
    }
    elsif ( $last_filter ) {
        my $filter = MT->model('filter')->load($last_filter);
        $initial_filter = $filter->to_hash if $filter;
    }
    elsif ( scalar @$last_items && $app->param('does_act') ) {
        my $filter = MT->model('filter')->new;
        $filter->set_values({
            object_ds => $obj_type,
            items     => $last_items,
            author_id => $app->user->id,
            blog_id   => $blog_id || 0,
            label     => $app->translate('New Filter'),
            can_edit  => 1,
        });
        $initial_filter = $filter->to_hash if $filter;
        $param{open_filter_panel} = 1;
    }

    my $columns = $list_pref->{columns} || [];
    my %cols = map { $_ => 1 } @$columns;

    my $primary_col = $screen_settings->{primary};
    $primary_col ||= [ @{$screen_settings->{columns} || [] } ]->[0];
    $primary_col = [ $primary_col ] unless ref $primary_col;
    my %primary_col = map { $_ => 1 } @$primary_col;
    my $default_sort = defined($screen_settings->{default_sort_key}) ? $screen_settings->{default_sort_key} : '';

    my @list_columns;
    for my $prop ( values %$list_props ) {
        next if !$prop->can_display($scope);
        my $col;
        my $id = $prop->id;
        my $disp = $prop->display || 'optional';
        my $show = $disp eq 'force'   ? 1
                 : $disp eq 'none'    ? 0
                 : scalar %cols       ? $cols{$id}
                 : $disp eq 'default' ? 1
                 :                      0;
        my $force = $disp eq 'force' ? 1 : 0;
        my $default = $disp eq 'default' ? 1 : 0;
        my @subfields;
        if ( my $subfields = $prop->sub_fields ) {
            for my $sub ( @$subfields ) {
                push @subfields, {
                    display    => $cols{ $id . '.' . $sub->{class} }
                                      || $sub->{display} eq 'default',
                    class      => $sub->{class},
                    label      => $sub->{label},
                    is_default => $sub->{display} eq 'default' ? 1 : 0,
                }
            }
        }
        push @list_columns, {
            id                 => $prop->id,
            type               => $prop->type,
            label              => $prop->label,
            primary            => $primary_col{$id} ? 1 : 0,
            col_class          => $prop->col_class,
            sortable           => $prop->can_sort,
            sorted             => $prop->id eq $default_sort ? 1 : 0,
            display            => $show,
            is_default         => $force || $default,
            force_display      => $force,
            default_sort_order => $prop->default_sort_order || 'ascend',
            order              => $prop->order,
            sub_fields         => \@subfields,
        };
    }
    @list_columns = sort {
          !$a->{order}  ?  1
        : !$b->{order}  ?  -1
        :                  $a->{order}  <=> $b->{order}
    } @list_columns;

    my @filter_types =
        map {{
           prop                  => $_,
           id                    => $_->id,
           type                  => $_->type,
           label                 => $_->label,
           field                 => $_->filter_tmpl,
           single_select_options => $_->single_select_options( $app ),
           singleton             => $_->singleton              ? 1
                                  : $_->has('filter_editable') ? !$_->filter_editable
                                  :                              0,
           editable              => $_->has('filter_editable') ? $_->filter_editable : 1,
        }}
        sort {
              ( $a->item_order && $b->item_order )   ? $a->item_order <=> $b->item_order
            : ( !$a->item_order && $b->item_order )  ? 1
            : ( $a->item_order  && !$b->item_order ) ? -1
            :                                          ( ref $a->label  ? $a->label->() : $a->label )
                                                       cmp ( ref $b->label ? $b->label->() : $b->label );
        }
        grep {
            $_->can_filter( $scope )
        }
        values %$list_props;

    #for my $filter_type ( @filter_types ) {
    #    if ( my $options = $filter_type->{single_select_options} ) {
    #        require MT::Util;
    #        if ( 'ARRAY' ne ref $options ) {
    #            $options = MT->handler_to_coderef($options)
    #                unless ref $options;
    #            $filter_type->{single_select_options} = $options->( $filter_type->{prop} );
    #        }
    #        for my $option ( @{$filter_type->{single_select_options}} ) {
    #            $option->{label} = MT::Util::encode_js($option->{label});
    #        }
    #    }
    #}

    require MT::CMS::Filter;
    my @filters = MT::CMS::Filter::filters( $app, $type );
    my $allpass_filter = {
        label => MT->translate('All [_1]', $screen_settings->{object_label_plural} || $obj_class->class_label_plural ),
        items => [],
        id    => '_allpass',
        can_edit => 0,
        can_save => 0,
    };
    $initial_filter = $allpass_filter
        unless $initial_filter;
    for my $filter ( @filters, $initial_filter ) {
        $filter->{label} = MT::Util::encode_html($filter->{label});
    };

    ## Encode all HTML in complex structure.
    my $deep_do;
    $deep_do = sub {
        my ( $data, $sub ) = @_;
        if ( ref $data eq 'HASH' ) {
            $deep_do->( \$_, $sub ) for values %$data;
        }
        elsif ( ref $data eq 'ARRAY' ) {
            $deep_do->( \$_, $sub ) for @$data;
        }
        elsif ( ref $data eq 'REF' ) {
            $deep_do->( $$data, $sub );
        }
        elsif ( ref $data eq 'SCALAR' ) {
            $sub->( $data );
        }
        elsif ( !ref $data ) {
            $sub->( \$data );
        }
    };
    my $enc = sub {
        my $ref = shift;
        $$ref = MT::Util::encode_html( $$ref );
    };
    $deep_do->( \@filters, $enc );
    $deep_do->( $initial_filter, $enc );

    require JSON;
    my $json = JSON->new->utf8(0);

    $param{common_listing} = 1;
    $param{blog_id} = $blog_id || '0';
    $param{filters}        = $json->encode( \@filters );
    $param{initial_filter} = $json->encode($initial_filter);
    $param{allpass_filter} = $json->encode($allpass_filter);
    $param{filters_raw}    = \@filters;
    $param{editable_filter_count} = scalar grep { $_->{can_edit} } @filters;
    $param{default_sort_key} = $default_sort;
    $param{list_columns}    = \@list_columns;
    $param{filter_types}    = \@filter_types;
    $param{object_type}     = $type;
    $param{page_title}      = $screen_settings->{screen_label};
    $param{object_label}
        = $screen_settings->{object_label}
        || $obj_class->class_label;
    $param{object_label_plural}
        = $screen_settings->{object_label_plural}
        || $obj_class->class_label_plural;
    $param{contents_label}
        = $screen_settings->{contents_label}
        || $obj_class->contents_label;
    $param{contents_label_plural}
        = $screen_settings->{contents_label_plural}
        || $obj_class->contents_label_plural;
    $param{container_label}
        = $screen_settings->{container_label}
        || $obj_class->container_label;
    $param{container_label_plural}
        = $screen_settings->{container_label_plural}
        || $obj_class->container_label_plural;


    my $s_type = $screen_settings->{search_type} || $obj_type;
    if ( my $search_apis = $app->registry( search_apis => $s_type ) ) {
        $param{search_type}  = $s_type;
        $param{search_label} = $search_apis->{label};
    }
    else {
        $param{search_type}  = 'entry';
        $param{search_label} = MT->translate('Entries');
    }

    my $template = $screen_settings->{template} || 'list_common.tmpl';

    my $feed_link = $screen_settings->{feed_link};
    $feed_link = $feed_link->( $app )
        if 'CODE' eq ref $feed_link;
    if ( $feed_link ) {
        $param{feed_url} = $app->make_feed_link( $type, $blog_id ? { blog_id => $blog_id } : undef );
        $param{object_type_feed} = $screen_settings->{feed_label}
            ? $screen_settings->{feed_label}
            : $app->translate( "[_1] Feed", $obj_class->class_label );
    }

    $app->load_list_actions( $type, \%param );
    $app->load_content_actions( $type, \%param );

    push @{$param{debug_panels}}, {
        name => 'CommonListing',
        title => 'CommonListing',
        nav_title => 'CommonListing',
        content => '<pre id="listing-debug-block" style="border: 1px solid #000; background-color: #eee; font-family: Courier;"></pre>',
    } if $MT::DebugMode;

    my $tmpl = $app->load_tmpl( $template, \%param )
        or return;
    $app->run_callbacks('list_template_param.' . $type, $app, $tmpl->param, $tmpl);
    return $tmpl;
}

sub filtered_list {
    my $app  = shift;
    my ( %forward_params ) = @_;
    my $q    = $app->param;
    my $blog_id = $q->param('blog_id') || 0;
    my $filter_id = $q->param('fid') || $forward_params{saved_fid};
    my $blog = $blog_id ? $app->blog : undef;
    my $scope
        = !$blog         ? 'system'
        : $blog->is_blog ? 'blog'
        :                  'website';
    my $blog_ids = !$blog         ? undef
                 : $blog->is_blog ? [ $blog_id ]
                 :                  [ $blog->id, map { $_->id } @{$blog->blogs} ];
    my $debug = {};
    my @messages = @{ $forward_params{messages} || [] };
    if ( $MT::DebugMode ) {
        require Time::HiRes;
        $debug->{original_prof} = $Data::ObjectDriver::PROFILE;
        $Data::ObjectDriver::PROFILE = 1;
        $debug->{sections} = [];
        $debug->{out}      = '';
        $debug->{section} = sub {
            my ($section) = @_;
            push @{ $debug->{sections} }, [
                $section,
                Time::HiRes::tv_interval($debug->{timer}),
                Data::ObjectDriver->profiler->report_query_frequency(),
            ];
            $debug->{timer} = [ Time::HiRes::gettimeofday() ];
            Data::ObjectDriver->profiler->reset;
        };
        $debug->{print} = sub {
            $debug->{out} .= $_[0] . "\n";
        };
        $debug->{timer} = $debug->{total} = [ Time::HiRes::gettimeofday() ];
        Data::ObjectDriver->profiler->reset;
    }
    else {
        $debug->{section} = sub {};
    }

    my $ds = $q->param('datasource');
    my $setting = MT->registry( listing_screens => $ds )
        or return $app->json_error(
            $app->translate('Unknown list type')
        );

    if ( my $cond = $setting->{condition} ) {
        $cond = MT->handler_to_coderef($cond)
            if 'CODE' ne ref $cond;
        $app->error();
        unless ( $cond->($app) ) {
            if ( $app->errstr ) {
                return $app->json_error( $app->errstr );
            }
            return $app->json_error(
                $app->translate('Invalid request')
            );
        }
    }

    my $class = $setting->{datasource} || MT->model($ds);
    my $filteritems;
    my $allpass = 0;
    if ( my $items = $q->param('items') ) {
        if ( $items =~ /^".*"$/ ) {
            $items =~ s/^"//;
            $items =~ s/"$//;
            $items = MT::Util::decode_js($items);
        }
        $MT::DebugMode && $debug->{print}->($items);
        require JSON;
        my $json = JSON->new->utf8(0);
        $filteritems = $json->decode($items);
    }
    else {
        $allpass = 1;
        $filteritems = [];
    }
    require MT::ListProperty;
    my $props = MT::ListProperty->list_properties($ds);
    if ( !$forward_params{validated} ) {
        for my $item ( @$filteritems ) {
            my $prop = $props->{ $item->{type} };
            if ( $prop->has('validate_item') ) {
                $prop->validate_item($item)
                    or return $app->json_error(
                        MT->translate( 'Invalid filter terms: [_1]', $prop->errstr )
                    );
            }
        }
    }

    my $filter = MT->model('filter')->new;
    $filter->set_values({
        object_ds => $ds,
        items     => $filteritems,
        author_id => $app->user->id,
        blog_id   => $blog_id || 0,
    });
    my $limit  = $q->param('limit') || 50; # FIXME: hard coded.
    my $page   = $q->param('page');
    $page = 1 if !$page || $page =~ /\D/;
    my $offset = ( $page - 1 ) * $limit;

    $MT::DebugMode && $debug->{print}->("LIMIT: $limit PAGE: $page OFFSET: $offset");
    $MT::DebugMode && $debug->{section}->('initialize');

    ## FIXME: take identifical column from column defs.
    my $cols = defined($q->param('columns')) ? $q->param('columns') : '';
    my @cols = ( '__id', grep { /^[^\.]+$/ } split( ',', $cols ) );
    my @subcols = ( '__id', grep { /\./ } split( ',', $cols ) );
    $MT::DebugMode && $debug->{print}->("COLUMNS: $cols");

    my $scope_mode = $setting->{scope_mode} || 'wide';
    my @blog_id_term = (
          !$blog_id             ? ()
        : $scope_mode eq 'none' ? ()
        : $scope_mode eq 'this' ? ( blog_id => $blog_id )
        :                         ( blog_id => $blog_ids )
    );

    my %load_options = (
        terms => { @blog_id_term },
        args       => {},
        sort_by    => $q->param('sort_by') || '',
        sort_order => $q->param('sort_order') || '',
        limit      => $limit,
        offset     => $offset,
        scope      => $scope,
        blog       => $blog,
        blog_id    => $blog_id,
        blog_ids   => $blog_ids,
    );

    my %count_options = (
        terms => { @blog_id_term },
        args       => {},
        scope      => $scope,
        blog       => $blog,
        blog_id    => $blog_id,
        blog_ids   => $blog_ids,
    );

    MT->run_callbacks( 'cms_pre_load_filtered_list.' . $ds, $app, $filter, \%count_options, \@cols );

    my $count = $filter->count_objects(%count_options);
    if ( !defined $count ) {
        return $app->error( $filter->errstr );
    }

    $MT::DebugMode && $debug->{section}->('count objects');
    $load_options{total} = $count;

    my ($objs, @data);
    if ( $count ) {
        MT->run_callbacks( 'cms_pre_load_filtered_list.' . $ds, $app, $filter, \%load_options, \@cols );

        $objs = $filter->load_objects(%load_options);
        if ( !defined $objs ) {
            return $app->error( $filter->errstr );
        }

        $MT::DebugMode && $debug->{section}->('load objects');

        my %cols = map { $_ => 1 } @cols;
        my @results;

        ## FIXME: would like to build MTML if specified, but currently
        ## many of handlers can't run without blog_id. so commented
        ## out for these codes until the problem would be resolved.
        #my $tmpl;
        #if ( scalar grep { $props->{$_}->has('mtml') } @cols ) {
        #    $tmpl = MT::Template->new;
        #    $tmpl->blog_id($blog_id);
        #    $app->set_default_tmpl_params($tmpl);
        #    $tmpl->context->{__stash}{blog} = $blog;
        #    $tmpl->context->{__stash}{blog_id} = $blog_id;
        #}

        $MT::DebugMode && $debug->{section}->('prepare load cols');
        for my $col ( @cols ) {
            my $prop = $props->{$col};
            my @result;
            if ( $prop->has('bulk_html') ) {
                @result = $prop->bulk_html( $objs, $app, \%load_options );
            }
            #elsif ( $prop->has('mtml') ) {
            #    for my $obj ( @$objs ) {
            #        $tmpl->context->{__stash}{$ds} = $obj;
            #        my $out = $prop->html($obj, $app);
            #        $tmpl->text($out);
            #        $tmpl->reset_tokens;
            #        $out = $tmpl->output;
            #        push @result, $out;
            #    }
            #}
            elsif ( $prop->has('html') ) {
                for my $obj ( @$objs ) {
                    push @result, $prop->html( $obj, $app, \%load_options );
                }
            }
            elsif ( $prop->has('html_link') ) {
                for my $obj ( @$objs ) {
                    my $link = $prop->html_link( $obj, $app, \%load_options );
                    my $raw  = $prop->raw( $obj, $app, \%load_options );
                    push @result, qq{<a href="$link">$raw</a>};
                }
            }
            elsif ( $prop->has('raw') ) {
                for my $obj ( @$objs ) {
                    my $out = $prop->raw( $obj, $app, \%load_options );
                    push @result, remove_html($out);
                }
            }

            push @results, \@result;
            $MT::DebugMode && $debug->{section}->("prepare col $col");
        }

        for my $i ( 0.. scalar @$objs - 1 ) {
            push @data, [ map { $_->[$i] } @results ];
        }
    }


    ## Save user list prefs.
    my $list_prefs = $app->user->list_prefs || {};
    my $list_pref = $list_prefs->{$ds}{$blog_id} ||= {};
    $list_pref->{rows} = $limit;
    $list_pref->{columns} = [ split ',', $cols ];
    $list_pref->{last_filter} = $filter_id ? $filter_id : $allpass ? '_allpass' : '';
    $list_pref->{last_items} = $filteritems;
    $app->user->list_prefs($list_prefs);
    ## FIXME: should handle errors..
    $app->user->save;

    require MT::CMS::Filter;
    my @filters = MT::CMS::Filter::filters( $app, $ds );
    my $editable_filter_count = scalar grep { $_->{can_edit} } @filters;
    for my $filter ( @filters ) {
        $filter->{label} = MT::Util::encode_html($filter->{label});
    }

    require POSIX;
    my %res;
    $res{objects}  = \@data;
    $res{columns}  = $cols;
    $res{count}    = $count;
    $res{page}     = $page;
    $res{page_max} = POSIX::ceil( $count / $limit );
    $res{id}       = $filter_id;
    $res{label}    = MT::Util::encode_html( $forward_params{saved_label} ) if $forward_params{saved_label};
    $res{filters}  = \@filters;
    $res{editable_filter_count} = $editable_filter_count;
    $res{messages} = \@messages;
    $MT::DebugMode && $debug->{section}->('finalize');
    MT->run_callbacks( 'cms_filtered_list_param.' . $ds, $app, \%res, $objs );
    if ( $MT::DebugMode ) {
        my $total = Time::HiRes::tv_interval($debug->{total});
        my $out   = $debug->{out};
        for my $section ( @{ $debug->{sections} } ) {
            $out .= sprintf(
                "%s  : %0.2f ms ( %0.2f %% )\n%s\n",
                $section->[0],
                $section->[1] * 1000,
                $section->[1] / $total * 100,
                $section->[2],
            );
        }
        $out .= sprintf "TOTAL: %0.2f ms\n", $total * 1000;
        $out .= sprintf "Matched %i Objects\n", $count;
        $res{debug} = $out;
        $Data::ObjectDriver::PROFILE = $debug->{original_prof};
    }
    return $app->json_result(\%res);
}

sub save_list_prefs {
    my $app  = shift;
    my $ds = $app->param('datasource');
    my $blog_id = $app->param('blog_id') || 0;
    my $blog = $blog_id ? $app->blog : undef;
    my $scope
        = !$blog         ? 'system'
        : $blog->is_blog ? 'blog'
        :                  'website';
    my $limit  = $app->param('limit')   || 50; # FIXME: hard coded.
    my $cols   = $app->param('columns') || '';
    my $list_prefs = $app->user->list_prefs       || {};
    my $list_pref  = $list_prefs->{$ds}{$blog_id} ||= {};
    $list_pref->{rows}    = $limit;
    $list_pref->{columns} = [ split ',', $cols ];
    #$list_pref->{last_filter} = $filter_id ? $filter_id : $allpass ? '_allpass' : '';
    #$list_pref->{last_items} = $filteritems;
    $app->user->list_prefs($list_prefs);
    $app->user->save
        or return $app->json_error( $app->user->errstr );
    return $app->json_result({ success => 1 });
}

sub delete {
    my $app  = shift;
    my $q    = $app->param;
    my $type = $q->param('_type');

    return $app->errtrans("Invalid request.")
      unless $type;

    return $app->error( $app->translate("Invalid request.") )
      if $app->request_method() ne 'POST';

    # being a general-purpose method, lets look for a mode handler
    # that is specifically for editing this type. if we find it,
    # reroute to it.

    my $delete_mode = 'delete_' . $type;
    if ( my $hdlrs = $app->handlers_for_mode($delete_mode) ) {
        return $app->forward($delete_mode);
    }

    my $parent  = $q->param('parent');
    my $blog_id = $q->param('blog_id');
    my $class   = $app->model($type) or return;
    my $perms   = $app->permissions;
    my $author  = $app->user;

    $app->validate_magic() or return;
    $app->setup_filtered_ids
        if $app->param('all_selected');

    my ( $entry_id, $cat_id, $author_id ) = ( "", "", "" );
    my %rebuild_entries;
    my @rebuild_cats;
    my $required_items = 0;
    my @not_deleted;
    for my $id ( $q->param('id') ) {
        next unless $id;    # avoid 'empty' ids
        if ( ( $type eq 'association' ) && ( $id =~ /PSEUDO-/ ) ) {
            require MT::CMS::User;
            MT::CMS::User::_delete_pseudo_association($app, $id);
            next;
        }

        my $obj = $class->load($id);
        next unless $obj;
        $app->run_callbacks( 'cms_delete_permission_filter.' . $type,
            $app, $obj )
          || return $app->error(
            $app->translate( "Permission denied: [_1]", $app->errstr() ) );

        if ( $type eq 'comment' ) {
            $entry_id = $obj->entry_id;
            $rebuild_entries{$entry_id} = 1 if $obj->visible;
        }
        elsif ( $type eq 'ping' || $type eq 'ping_cat' ) {
            require MT::Trackback;
            my $tb = MT::Trackback->load( $obj->tb_id );
            if ($tb) {
                $entry_id = $tb->entry_id;
                $cat_id   = $tb->category_id;
                if ( $obj->visible ) {
                    $rebuild_entries{$entry_id} = 1 if $entry_id;
                    push @rebuild_cats, $cat_id if $cat_id;
                }
            }
        }
        elsif ( $type eq 'tag' ) {

            # if we're in a blog context, remove ONLY tags from that weblog
            # Also, if we're in a website context, remove ONLY tags from that website and weblog which belongs to website.
            if ($blog_id) {
                my $ot_class  = $app->model('objecttag');
                my $blog      = $app->model('blog')->load( $blog_id );
                my $iter      = $ot_class->load_iter(
                    {
                        (   $blog->is_blog
                            ? ( blog_id => $blog_id )
                            : ( blog_id => [
                                    map { $_->id } @{ $blog->blogs }, $blog
                                ]
                            )
                            ),
                        tag_id            => $id
                    }
                );

                if ($iter) {
                    my @ot;
                    while ( my $obj = $iter->() ) {
                        push @ot, $obj->id;
                    }
                    foreach (@ot) {
                        my $obj = $ot_class->load($_);
                        next unless $obj;
                        $obj->remove
                          or return $app->errtrans( 'Removing tag failed: [_1]',
                            $obj->errstr );
                    }
                }

                $app->run_callbacks( 'cms_post_delete.' . $type, $app, $obj );
                next;

            }
        }
        elsif ( $type eq 'category' ) {
            if ( $app->config('DeleteFilesAtRebuild') ) {
                require MT::Blog;
                require MT::Entry;
                require MT::Placement;
                my $blog = MT::Blog->load($blog_id)
                    or return $app->error($app->translate('Can\'t load blog #[_1].', $blog_id));
                my $at   = $blog->archive_type;
                if ( $at && $at ne 'None' ) {
                    my @at = split /,/, $at;
                    for my $target (@at) {
                        my $archiver = $app->publisher->archiver($target);
                        next unless $archiver;
                        if ( $archiver->category_based ) {
                            if ( $archiver->date_based ) {
                                my @entries = MT::Entry->load(
                                    { status => MT::Entry::RELEASE() },
                                    {
                                        join => MT::Placement->join_on(
                                            'entry_id',
                                            { category_id => $id },
                                            { unique      => 1 }
                                        )
                                    }
                                );
                                for (@entries) {
                                    $app->publisher->remove_entry_archive_file(
                                        Category    => $obj,
                                        ArchiveType => $target,
                                        Entry       => $_
                                    );
                                }
                            }
                            else {
                                $app->publisher->remove_entry_archive_file(
                                    Category    => $obj,
                                    ArchiveType => $target
                                );
                            }
                        }
                    }
                }
            }
        }
        elsif ( $type eq 'page' ) {
            if ( $app->config('DeleteFilesAtRebuild') ) {
                $app->publisher->remove_entry_archive_file(
                    Entry       => $obj,
                    ArchiveType => 'Page'
                );
            }
        }
        elsif ( $type eq 'author' ) {
            if ( $app->config->ExternalUserManagement ) {
                require MT::LDAP;
                my $ldap = MT::LDAP->new
                  or return $app->error(
                    MT->translate(
                        "Loading MT::LDAP failed: [_1].",
                        MT::LDAP->errstr
                    )
                  );
                my $dn = $ldap->get_dn( $obj->name );
                if ($dn) {
                    $app->add_return_arg( author_ldap_found => 1 );
                }
            }
        } elsif ( $type eq 'website' ) {
            my $blog_class = $app->model('blog');
            my $count = $blog_class->count({
                parent_id => $obj->id,
            });
            if ( $count > 0 ) {
                push @not_deleted, $obj->id;
                next;
            }
        }

        # FIXME: enumeration of types
        if (   $type eq 'template'
            && $obj->type !~
            /(custom|index|archive|page|individual|category|widget|backup)/o )
        {
            $required_items++;
        }
        else {
            $obj->remove
              or return $app->errtrans(
                'Removing [_1] failed: [_2]',
                $app->translate($type),
                $obj->errstr
              );
            $app->run_callbacks( 'cms_post_delete.' . $type, $app, $obj );
        }
    }
    require MT::Entry;
    for my $entry_id ( keys %rebuild_entries ) {
        my $entry = MT::Entry->load($entry_id);
        $app->rebuild_entry( Entry => $entry, BuildDependencies => 1 )
            or return $app->publish_error();
    }
    for my $cat_id (@rebuild_cats) {

        # FIXME: What about other category-based archives?
        # What if user is not publishing category archives?
        my $cat = MT::Category->load($cat_id);
        $app->rebuild(
            Category    => $cat,
            BlogID      => $blog_id,
            ArchiveType => 'Category'
        ) or return $app->publish_error();
    }
    $app->run_callbacks( 'rebuild', MT::Blog->load($blog_id) );

    if ( $#not_deleted >= 0 ) {
        $app->add_return_arg( 'not_deleted' => 1 );
        $app->add_return_arg( 'error_id' => join ',', @not_deleted );
    }
    else {
        $app->add_return_arg(
            $type eq 'ping'
            ? ( saved_deleted_ping => 1 )
            : ( saved_deleted => 1 )
        );
    }

    if ( $q->param('is_power_edit') ) {
        $app->add_return_arg( is_power_edit => 1 );
    }
    if ($required_items) {
        $app->add_return_arg(
            error => $app->translate("System templates can not be deleted.") );
    }

    $app->call_return;
}

sub not_junk_test {
    my ( $eh, $app, $obj ) = @_;
    require MT::JunkFilter;
    MT::JunkFilter->filter($obj);
    $obj->is_junk ? 0 : 1;
}

sub build_revision_table {
    my $app = shift;
    my (%args) = @_;

    my $q = $app->param;
    my $type = $q->param('_type');
    my $class = $app->model($type);
    my $param = $args{param};
    my $obj   = $args{object};
    my $blog = $obj->blog || MT::Blog->load( $q->param('blog_id') ) || undef;
    my $lang = $app->user ? $app->user->preferred_language : undef;

    my $js = $param->{rev_js};
    unless ( $js ) {
        $js = "location.href='"
          . $app->uri
          . '?__mode=view&amp;_type='
          . $type;
        if ( my $id = $obj->id ) {
            $js .= '&amp;id=' . $id;
        }
        if ( defined $blog ) {
            $js .= '&amp;blog_id=' . $blog->id;
        }
    }
    my %users;
    my $hasher = sub {
        my ( $rev, $row ) = @_;
        if ( my $ts = $rev->created_on ) {
            $row->{created_on_formatted} =
              format_ts( MT::App::CMS::LISTING_DATE_FORMAT(), $ts, $blog, $lang );
            $row->{created_on_time_formatted} =
              format_ts( MT::App::CMS::LISTING_TIMESTAMP_FORMAT(), $ts, $blog, $lang );
            $row->{created_on_relative} =
              relative_date( $ts, time, $blog );
        }
        if ( $row->{created_by} ) {
            my $created_user = $users{ $row->{created_by} } ||=
              MT::Author->load( $row->{created_by} );
            if ($created_user) {
                $row->{created_by} = $created_user->nickname;
            }
            else {
                $row->{created_by} = $app->translate('(user deleted)');
            }
        }
        my $revision = $obj->object_from_revision( $rev );
        my $column_defs = $obj->column_defs;
        #my @changed = map {
        #    my $label = $column_defs->{$_}->{label};
        #    $label ||= $_;
        #    $app->translate( $label );
        #} @{ $revision->[1] };
        #$row->{changed_columns} = \@changed;
        if ( ( 'entry' eq $type ) || ( 'page' eq $type ) ) {
            $row->{rev_status} = $revision->[0]->status;
        }
        $row->{rev_js} = $js . '&amp;r=' . $row->{rev_number} . "'";
        $row->{is_current} = $param->{revision} == $row->{rev_number};
    };
    return $app->listing(
        {
            type   => "$type:revision",
            code   => $hasher,
            terms  => { $class->datasource . '_id' => $obj->id },
            source => $type,
            params => { dialog => scalar $q->param('dialog'), },
            %$param
        }
    );
}

sub list_revision {
    my $app = shift;
    my $q = $app->param;
    my $type = $q->param('_type');
    my $class = $app->model($type);
    my $id = $q->param('id');
    my $rn = $q->param('r');

    $id =~ s/\D//g;
    my $obj = $class->load( $id )
        or return $app->error($app->translate('Can\'t load [_1] #[_1].', $class->class_label, $id));
    my $blog = $obj->blog || MT::Blog->load( $q->param('blog_id') ) || undef;
    my $author = $app->user;
    return $app->permission_denied()
        if $type eq 'entry'
        ? ( $obj->author_id == $author->id
                ? !$app->can_do('edit_own_entry')
                : !$app->can_do('edit_all_entries') )
        : $type eq 'page'     ? !$app->can_do('edit_all_pages')
        : $type eq 'template' ? !$app->can_do('edit_templates')
        : 0;

    my $js = "parent.location.href='"
      . $app->uri
      . '?__mode=view&amp;_type='
      . $type
      . '&amp;id=' . $obj->id;
    if ( defined $blog ) {
        $js .= '&amp;blog_id=' . $blog->id;
    }
    my $revision = $rn
        || (
          $obj->has_meta('revision')
        ? $obj->revision || $obj->current_revision
        : $obj->current_revision
        || 0
        );
    return build_revision_table( $app,
        object => $obj,
        param  => {
            template => 'dialog/list_revision.tmpl',
            args     => {
                sort_order => 'rev_number',
                direction => 'descend',
            },
            rev_js => $js,
            revision => $revision,
        }
    );
}

sub save_snapshot {
    my $app = shift;
    my $q    = $app->param;
    my $type = $q->param('_type');
    my $id = $q->param('id');
    my $param = {};

    return $app->errtrans("Invalid request.")
      unless $type;

    $app->validate_magic() or return;

    $app->run_callbacks( 'cms_save_permission_filter.' . "$type:revision", $app, $id )
      || return $app->error(
        $app->translate( "Permission denied: [_1]", $app->errstr() ) );

    my $filter_result = $app->run_callbacks( 'cms_save_filter.' . "$type:revision", $app );
    if ( !$filter_result ) {
        my %param = (%$param);
        $param{error}       = $app->errstr;
        $param{return_args} = $app->param('return_args');
        my $mode = 'view_' . $type;
        if ( $app->handlers_for_mode($mode) ) {
            return $app->forward( $mode, \%param );
        }
        return $app->forward( 'view', \%param );
    }

    my $class = $app->model($type)
      or return $app->errtrans( "Invalid type [_1]", $type );
    my $obj;
    if ($id) {
        $obj = $class->load($id)
            or return $app->error($app->translate("Invalid ID [_1]", $id));
    }
    else {
        $obj = $class->new;
    }

    my $original = $obj->clone();
    my $names  = $obj->column_names;
    my %values = map { $_ => ( scalar $q->param($_) ) } @$names;

    if ( ( 'entry' eq $type ) || ( 'page' eq $type ) ) {
        $app->_translate_naughty_words($obj);
    }
    delete $values{'id'} if exists( $values{'id'} ) && !$values{'id'};
    $obj->set_values( \%values );
    unless (
        $app->run_callbacks( 'cms_pre_save.' . "$type:revision", $app, $obj, undef ) )
    {
        $param->{return_args} = $app->param('return_args');
        return edit( $app,
            {
                %$param,
                error => $app->translate( "Saving snapshot failed: [_1]", $app->errstr )
            }
        );
    }
    $obj->gather_changed_cols($original);
    if ( exists $obj->{changed_revisioned_cols} ) {
        my $col = 'max_revisions_' . $obj->datasource;
        if ( my $blog = $obj->blog ) {
            my $max = $blog->$col;
            $obj->handle_max_revisions( $max );
        }
        my $revision = $obj->save_revision( $q->param('revision-note') );
        $app->add_return_arg( r => $revision );
        if ( $id ) {
            my $obj_revision = $original->revision || 0;
            unless ( $obj_revision ) {
                $original->revision($revision - 1);
                # hack to bypass instance save method
                $original->{__meta}->save;
            }
            $original->current_revision($revision);
            # call update to bypass instance save method
            $original->update or return $original->error($original->errstr);
        }

        $app->run_callbacks( 'cms_post_save.' . "$type:revision", $app, $obj, undef )
          or return $app->error( $app->errstr() );
    
        $app->add_return_arg( 'saved_snapshot' => 1 );
    }
    else {
        $app->add_return_arg( 'no_snapshot' => 1 );
    }

    $app->add_return_arg( 'id' => $obj->id ) if !$original->id;
    $app->call_return;
}

sub empty_dialog {
    my $app = shift;
    $app->build_page( 'dialog/empty_dialog.tmpl' );
}

1;
