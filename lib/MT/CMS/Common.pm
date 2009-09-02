# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: Common.pm 109836 2009-08-25 01:59:57Z auno $
package MT::CMS::Common;

use strict;

use MT::Util qw( format_ts offset_time_list relative_date );

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

        if ( ( $type eq 'notification' ) || ( $type eq 'banlist' ) ) {
            return list( $app, \%param );
        }
        elsif ( ( $app->param('cfg_screen') || '' ) eq 'cfg_prefs' ) {
            return MT::CMS::Blog::cfg_prefs( $app, \%param );
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

    if ( $type eq 'blog' ) {
        unless ( $author->is_superuser
            || ( $perms && $perms->can_do('save_all_settings_for_blog') ) )
        {
            if ( $id && !( $perms->can_do('save_blog_pathinfo') ) ) {
                delete $values{site_url};
                delete $values{site_path};
                delete $values{archive_url};
                delete $values{archive_path};
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

    if ( $type eq 'website' ) {
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
            foreach my $auth (qw( Vox LiveJournal )) {
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
            });
        } else {
            $app->log({
                message => $app->translate("'[_1]' edited the global template '[_2]'", $app->user->name, $obj->name),
                level   => MT::Log::INFO(),
            });
        }
    }

    # TODO: convert this to use $app->call_return();
    # then templates can determine the page flow.
    if ( $type eq 'notification' ) {
        return $app->redirect(
            $app->uri(
                'mode' => 'list',
                args   => {
                    '_type' => 'notification',
                    blog_id => $blog_id,
                    saved   => $obj->email
                }
            )
        );
    }
    elsif ( my $cfg_screen = $q->param('cfg_screen') ) {
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
    elsif ( $type eq 'banlist' ) {
        return $app->redirect(
            $app->uri(
                'mode' => 'list',
                args   => {
                    '_type' => 'banlist',
                    blog_id => $blog_id,
                    saved   => $obj->ip
                }
            )
        );
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
                 || $type eq 'comment'  || $type eq 'commenter'
                 || $type eq 'ping' ) ) {
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
          || return $app->error(
            $app->translate( "Permission denied: [_1]", $app->errstr() ) );
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

    return $app->errtrans("Invalid request.")
      unless $type;

    # being a general-purpose method, lets look for a mode handler
    # that is specifically for editing this type. if we find it,
    # reroute to it.

    my $list_mode = 'list_' . $type;
    if ( my $hdlrs = $app->handlers_for_mode($list_mode) ) {
        return $app->forward($list_mode);
    }

    my %param = $_[0] ? %{ $_[0] } : ();

    my $perms = $app->permissions;
    return $app->return_to_dashboard( redirect => 1 )
      unless $perms;

    PERMCHECK: {
        if ( $type eq 'blog' ) {
            last PERMCHECK if $perms->can_do('access_to_blog_list');
        }
        elsif ( $type eq 'template' ) {
            last PERMCHECK if $perms->can_do('access_to_template_list');
        }
        elsif ( $type eq 'notification' ) {
            last PERMCHECK if $perms->can_do('access_to_notification_list');
        }
        elsif ( $type eq 'banlist' ) {
            last PERMCHECK if $perms->can_do('access_to_banlist');
        }
        return $app->return_to_dashboard( permission => 1 );
    }

    my $id        = $q->param('id');
    my $class     = $app->model($type) or return;
    my $blog_id   = $q->param('blog_id');
    my $list_pref = $app->list_pref($type);
    my ( %terms, %args );
    %param = ( %param, %$list_pref );
    my $cols   = $class->column_names;
    my $limit  = $list_pref->{rows};
    my $offset = $app->param('offset') || 0;

    for my $name (@$cols) {
        $terms{blog_id} = $blog_id, last
          if $name eq 'blog_id';
    }
    if ( $type eq 'notification' ) {
        $args{direction} = 'descend';
        $args{offset}    = $offset;
        $args{limit}     = $limit + 1;
    }
    elsif ( $type eq 'banlist' ) {
        $param{use_plugins} = $app->config->UsePlugins;
        $limit = 0;
    }
    my $iter = $class->load_iter( \%terms, \%args );

    my (
        @data,         @index_data,  @custom_data,
        @archive_data, @system_data, @widget_data
    );
    my (%authors);
    my $blog_class = $app->model('blog');
    my $blog       = $blog_class->load($blog_id);
    my $set        = $blog ? $blog->template_set : undef;
    require MT::DefaultTemplates;
    my $dtmpl = MT::DefaultTemplates->templates($set) || [];
    my %dtmpl = map { $_->{type} => $_ } @$dtmpl;

    while ( my $obj = $iter->() ) {
        my $row = $obj->get_values;
        if ( my $ts = $obj->created_on ) {
            $row->{created_on_formatted} =
              format_ts( MT::App::CMS::LISTING_DATE_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_time_formatted} =
              format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_relative} = relative_date( $ts, time, $blog );
        }
        if ( $type eq 'template' ) {
            $row->{name} = '' if !defined $row->{name};
            $row->{name} =~ s/^\s+|\s+$//g;
            $row->{name} = "(" . $app->translate("No Name") . ")"
              if $row->{name} eq '';

            if ( $obj->type eq 'index' ) {
                push @index_data, $row;
                $row->{rebuild_me} =
                  defined $row->{rebuild_me} ? $row->{rebuild_me} : 1;
                my $published_url = $obj->published_url;
                $row->{published_url} = $published_url if $published_url;
            }
            elsif ( $obj->type eq 'custom' ) {
                push @custom_data, $row;
            }
            elsif ( $obj->type eq 'widget' ) {
                push @widget_data, $row;
            }
            elsif ($obj->type eq 'archive'
                || $obj->type eq 'category'
                || $obj->type eq 'page'
                || $obj->type eq 'individual' )
            {

                # FIXME: enumeration of types
                push @archive_data, $row;
            }
            else {
                if ( my $def_tmpl = $dtmpl{ $obj->type } ) {
                    $row->{description} = $def_tmpl->{description_label};
                }
                else {

                    # unknown system template; skip over it
                    # or should we change it to a custom template
                    # right now?
                    next;
                }
                push @system_data, $row;
            }
            $param{search_label} = $app->translate('Templates');
        }
        else {
            if ( $limit && ( scalar @data == $limit ) ) {
                $param{next_offset} = 1;
                last;
            }
            push @data, $row;
        }
        if ( $type eq 'ping' ) {
            return $app->list_pings();
            require MT::Trackback;
            require MT::Entry;
            my $tb_center = MT::Trackback->load( $obj->tb_id );
            my $entry     = MT::Entry->load( $tb_center->entry_id )
                or return $app->error($app->translate('Can\'t load entry #[_1].', $tb_center->entry_id));
            if ( my $ts = $obj->created_on ) {
                $row->{created_on_time_formatted} =
                  format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );
                $row->{has_edit_access} = $perms->can_do('open_all_trackback_edit_screen')
                  || ( ( $app->user->id == $entry->author_id ) && $perms->can_do('open_own_entry_trackback_edit_screen') );
            }
        }
    }    # end loop over the set of objects;
         # NOW transform the @data array
    if ( $type eq 'notification' ) {
        $app->add_breadcrumb( $app->translate('Notification List') );
        $param{nav_notifications} = 1;

        #@data = sort { $a->{email} cmp $b->{email} } @data;
        $param{object_type}        = 'notification';
        $param{list_noncron}       = 1;
        $param{notification_count} = scalar @data;
        $param{search_type} = 'entry';
    }
    if ( $type eq 'template' ) {
        $app->add_breadcrumb( $app->translate('Templates') );
        $param{nav_templates} = 1;
        for my $ref ( \@index_data, \@custom_data, \@archive_data ) {
            @$ref = sort { $a->{name} cmp $b->{name} } @$ref;
        }
        my $tab = $app->param('tab') || 'index';
        $param{template_group}      = $tab;
        $param{"tab_$tab"}          = 1;
        $param{object_index_loop}   = \@index_data;
        $param{object_custom_loop}  = \@custom_data;
        $param{object_widget_loop}  = \@widget_data;
        $param{object_archive_loop} = \@archive_data;
        $param{object_system_loop}  = \@system_data;
        $param{object_type}         = 'template';
    }
    else {
        $param{object_loop} = \@data;
    }

    # add any breadcrumbs
    if ( $type eq 'banlist' ) {
        $app->add_breadcrumb( $app->translate('IP Banning') );
        $param{nav_config}                       = 1;
        $param{object_type}                      = 'banlist';
        $param{show_ip_info}                     = 1;
        $param{list_noncron}                     = 1;
        $param{search_type} = 'entry';
        $param{can_edit_config_or_publish_paths} = $perms->can_do('edit_blog_config')
          || $perms->can_do('edit_blog_pathinfo');
    }
    elsif ( $type eq 'ping' ) {
        $app->add_breadcrumb( $app->translate('TrackBacks') );
        $param{nav_trackbacks} = 1;
        $param{object_type}    = 'ping';
    }
    $param{object_count} = scalar @data;

    if ( $type ne 'template' ) {
        $param{offset}     = $offset;
        $param{list_start} = $offset + 1;
        delete $args{limit};
        delete $args{offset};
        $param{list_total} = $class->count( \%terms, \%args );
        $param{list_end}        = $offset + ( scalar @data );
        $param{next_offset_val} = $offset + ( scalar @data );

    #$param{next_offset} = $param{next_offset_val} < $param{list_total} ? 1 : 0;
        $param{next_max} = $param{list_total} - $limit;
        $param{next_max} = 0 if ( $param{next_max} || 0 ) < $offset + 1;
        if ( $offset > 0 ) {
            $param{prev_offset}     = 1;
            $param{prev_offset_val} = $offset - $limit;
            $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
        }
    }

    $app->load_list_actions( $type, \%param );

    $param{saved}         = $q->param('saved');
    $param{saved_deleted} = $q->param('saved_deleted');
    $param{page_actions}  = $app->page_actions( 'list_' . $type );
    $param{screen_class} ||= "list-$type";
    $param{screen_id} ||= "list-$type";
    $param{listing_screen} = 1;
    $app->load_tmpl( "list_${type}.tmpl", \%param );
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

    my ( $entry_id, $cat_id, $author_id ) = ( "", "", "" );
    my %rebuild_entries;
    my @rebuild_cats;
    my $required_items = 0;
    my $not_deleted = 0;
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
                my $obj_type  = $q->param('__type') || 'entry';
                my $obj_class = $app->model($obj_type);
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
                        object_datasource => $obj_class->datasource,
                        tag_id            => $id
                    },
                    {
                        'join' => $obj_class->join_on(
                            undef,
                            {
                                id => \'= objecttag_object_id',
                                (
                                    $obj_class =~ m/asset/i
                                    ? ()
                                    : ( class => $obj_class->class_type )
                                )
                            }
                        )
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
                $not_deleted++;
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
    $app->add_return_arg(
        $type eq 'ping'
        ? ( saved_deleted_ping => 1 )
        : ( saved_deleted => 1 )
    );
    if ( $q->param('is_power_edit') ) {
        $app->add_return_arg( is_power_edit => 1 );
    }
    if ($required_items) {
        $app->add_return_arg(
            error => $app->translate("System templates can not be deleted.") );
    }

    $app->add_return_arg( 'not_deleted' => 1 )
        if $not_deleted > 0;
    $app->call_return;
}


sub clone_blog {
    my $app     = shift;
    my ($param) = {};
    my $user    = $app->user;

    return $app->error( $app->translate("Permission denied.") )
        if !$user->is_superuser && !$user->can('clone_blog');

    my @id = $app->param('id');

    if ( !@id ) {
        return $app->error( $app->translate("No blog was selected to clone.") );
    }

    if ( scalar @id > 1 ) {
        return $app->error(
            $app->translate(
                "This action can only be run on a single blog at a time.")
        );
    }

    # Get blog_id from params and validate
    require MT::Blog;
    my $blog_id    = shift @id;
    my $blog_class = $app->model('blog');
    my $blog       = $blog_class->load($blog_id)
      or return $app->error( $app->translate("Invalid blog_id") );
    return $app->error( $app->translate("This action cannot clone website."))
        unless $blog->is_blog;

    my $base_url = $blog->column('site_url') || $blog->name;
    $base_url =~ s/\/$//;
    my $base_path = $blog->column('site_path') || $blog->name;

    $param->{'id'} = $blog->id;
    $param->{'new_blog_name'} = $app->param('new_blog_name')
      || 'Clone of ' . MT::Util::encode_html( $blog->name );
    $param->{'site_url'} = defined $app->param('site_url') ? $app->param('site_url') : $base_url . '_clone';
    $param->{'site_path'} = defined $app->param('site_path') ? $app->param('site_path') : $base_path . '_clone';

    require File::Spec;
    my $website = $blog->website;
    $param->{parent_id} = $website->id;
    $param->{parent_path} = File::Spec->catfile($website->site_path, '') if $website->site_path;
    $param->{parent_url} = $website->site_url;
    $param->{blog_id} = $app->param('blog_id');

    if ( $app->param('clone_prefs_entries_pages') ) {
        $param->{'clone_prefs_entries_pages'} =
          $app->param('clone_prefs_entries_pages');
    }

    if ( $app->param('clone_prefs_comments') ) {
        $param->{'clone_prefs_comments'} = $app->param('clone_prefs_comments');
    }

    if ( $app->param('clone_prefs_trackbacks') ) {
        $param->{'clone_prefs_trackbacks'} =
          $app->param('clone_prefs_trackbacks');
    }

    if ( $app->param('clone_prefs_categories') ) {
        $param->{'clone_prefs_categories'} =
          $app->param('clone_prefs_categories');
    }

    my $clone = $app->param('back_to_form') ? 0 : $app->param('clone');
    $param = _has_valid_form( $app, $blog, $param );

    if ( $blog_id && $clone && $param->{'isValidForm'} ) {
        print_status_page( $app, $blog, $param );
        return;
    }
    elsif ( $app->param('verify') ) {

        # build form
        $param->{'verify'}     = 1;
        $param->{'system_msg'} = 1;
    }

    my $tmpl = $app->load_tmpl( "dialog/clone_blog.tmpl", $param );

    return $tmpl;
}

sub _has_valid_form {
    my $app = shift;
    my ($blog, $param) = @_;

    if (
        (
               !$param->{'clone_prefs_comments'}
            || !$param->{'clone_prefs_trackbacks'}
        )
        && $param->{'clone_prefs_entries_pages'}
      )
    {
        if (   !$param->{'clone_prefs_comments'}
            && !$param->{'clone_prefs_trackbacks'} )
        {
            push(
                @{ $param->{'errors'} },
                $app->translate(
"Entries must be cloned if comments and trackbacks are cloned"
                )
            );
        }
        elsif ( $param->{'clone_prefs_comments'} ) {
            push(
                @{ $param->{'errors'} },
                $app->translate(
                    "Entries must be cloned if comments are cloned")
            );
        }
        elsif ( $param->{'clone_prefs_trackbacks'} ) {
            push(
                @{ $param->{'errors'} },
                $app->translate(
                    "Entries must be cloned if trackbacks are cloned")
            );
        }
    }

    $param->{'isValidForm'} = $param->{'errors'} ? 0 : 1;

    return $param;
}

sub print_status_page {
    my $app = shift;
    my ($blog, $param) = @_;
    my ($cloning_prefs) = {};
    $| = 1;

    if ( $app->param('clone_prefs_comments') ) {
        $cloning_prefs->{'MT::Comment'} = 0;
    }

    if ( $app->param('clone_prefs_trackbacks') ) {

        # need to exclude both Trackbacks and Pings
        $cloning_prefs->{'MT::Trackback'} = 0;
        $cloning_prefs->{'MT::TBPing'}    = 0;
    }

    if ( $app->param('clone_prefs_categories') ) {
        $cloning_prefs->{'MT::Category'} = 0;
    }

    if ( $app->param('clone_prefs_entries_pages') ) {
        $cloning_prefs->{'MT::Entry'} = 0;
    }

    my $blog_name = $param->{'new_blog_name'};

    # Set up and commence app output
    $app->{no_print_body} = 1;
    $app->send_http_header;
    my $html_head = <<'SCRIPT';
<script type="text/javascript">
function progress(str, id) {
    var el = getByID(id);
    if (el) el.innerHTML = str;
}
</script>
SCRIPT

    $app->print(
        $app->build_page(
            'dialog/header.tmpl',
            {
                page_title => $app->translate("Clone Blog"),
                html_head  => $html_head
            }
        )
    );
    $app->print( $app->translate_templatized(<<"HTML") );
<h2><__trans phrase="Cloning blog '[_1]'..." params="$blog_name"></h2>

<div class="modal_width" id="dialog-clone-weblog">

<div id="clone-process" class="process-msg">
<ul>
HTML

    my $new_blog;
    eval {
        $new_blog = $blog->clone(
            {
                BlogName => ($blog_name),
                Children => 1,
                Except   => ( { site_path => 1, site_url => 1 } ),
                Callback => sub { _progress( $app, @_ ) },
                Classes  => ($cloning_prefs)
            }
        );

        $new_blog->site_path( $param->{'site_path'} );
        $new_blog->site_url( $param->{'site_url'} );
        $new_blog->save();

        my $website = $app->model( 'website' )->load( $param->{'parent_id'} );
        $website->add_blog( $new_blog );
    };
    if ( my $err = $@ ) {
        $app->print(
            $app->translate_templatized(
                qq{<p class="error-message"><__trans phrase="Error">: $err</p>}
            )
        );
    }
    else {
        my $return_url   = $app->base . $app->uri(
            mode => 'list_blog',
            args => { blog_id => $app->param('blog_id') }
        );
        my $setting_url = $app->uri(
            mode => 'view',
            args => {
                blog_id => $new_blog->id,
                _type   => 'blog',
                id      => $new_blog->id
            }
        );

        $app->print( $app->translate_templatized(<<"HTML") );
</ul>
</div>

<p><strong><__trans phrase="Finished! You can <a href=\"javascript:void(0);\" onclick=\"closeDialog('[_1]');\">return to the blog listing</a>." params="$return_url"></strong></p>

<form method="GET">
    <div class="actions-bar">
        <button
            type="submit"
            accesskey="x"
            class="close action mt-close-dialog-url"
            ><__trans phrase="Close"></button>
    </div>
</form>

</div>

<script type="text/javascript">
/* <![CDATA[ */
jQuery(function() {
    jQuery('button.mt-close-dialog-url').click(function() {
        parent.jQuery.fn.mtDialog.close('$return_url');
    });
});
/* ]]> */
</script>


HTML
    }

    $app->print( $app->build_page('dialog/footer.tmpl') );
}

sub _progress {
    my $app = shift;
    my $ids = $app->request('progress_ids') || {};

    my ($str, $id) = @_;
    if ($id && $ids->{$id}) {
        require MT::Util;
        my $str_js = MT::Util::encode_js($str);
        $app->print(qq{<script type="text/javascript">progress('$str_js', '$id');</script>\n});
    } elsif ($id) {
        $ids->{$id} = 1;
        $app->print(qq{<li id="$id">$str</li>\n});
    } else {
        $app->print("<li>$str</li>");
    }

    $app->request('progress_ids', $ids);
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
        my @changed = map {
            my $label = $column_defs->{$_}->{label};
            $label ||= $_;
            $app->translate( $label );
        } @{ $revision->[1] };
        $row->{changed_columns} = \@changed;
        $row->{rev_js} = $js . '&amp;r=' . $row->{rev_number} . "'";
        $row->{is_current} = $param->{revision} == $row->{rev_number};
    };
    return $app->listing(
        {
            type   => "$type:revision",
            code   => $hasher,
            terms  => { $class->datasource . '_id' => $obj->id },
            source => $type,
            params => { dialog => $q->param('dialog'), },
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
