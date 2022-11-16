# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Common;

use strict;
use warnings;

use MT::Util qw( format_ts offset_time_list relative_date remove_html);

sub save {
    my $app             = shift;
    my $type            = $app->param('_type');
    my $id              = $app->param('id');
    my @types_for_event = ($type);

    my $class = $app->model($type)
        or return $app->errtrans( "Invalid type [_1]", $type );

    return $app->errtrans("Invalid request.")
        unless $type;

    return $app->errtrans("Invalid request.")
        if !$id && $type eq 'asset';

    if ( exists $class->properties->{class_type} and $app->param('class') ) {
        my $classParamFilter
            = lc $app->config('DefaultClassParamFilter') || 'all';
        if ( $classParamFilter ne 'none' ) {

            # Respect result of callbacks
            my $res;
            $res
                = $app->run_callbacks( 'cms_class_param_filter.' . $type,
                $app )
                if $app->is_callback_registered(
                'cms_class_param_filter.' . $type );

            if ( !$res ) {

                # all callbacks not returns true, or no callbacks found
                if ( $classParamFilter eq 'moderate' ) {

                    # MT core object only
                    $res = 1;
                    my @list
                        = qw ( MT::Asset MT::Entry MT::Page MT::Category MT::Folder MT::Blog MT::Website );
                    foreach my $o (@list) {
                        if ( $class->isa($o) ) {
                            $res = 0;
                            last;
                        }
                    }
                }
            }

            # Raise error when state is still active
            return $app->errtrans('Invalid request.')
                if !$res;
        }
    }

    if ( $id && $type eq 'website' ) {
        $type = 'blog';
        unshift @types_for_event, $type;
    }

    # being a general-purpose method, lets look for a mode handler
    # that is specifically for editing this type. if we find it,
    # reroute to it.

    my $save_mode = 'save_' . $type;
    if ( my $hdlrs = $app->handlers_for_mode($save_mode) ) {
        return $app->forward($save_mode);
    }

    for my $t (@types_for_event) {
        return $app->errtrans("Invalid request.")
            unless is_enabled_mode( $app, 'save', $t );
    }

    $app->param( 'allow_pings', 0 )
        if ( $type eq 'category' ) && !defined( $app->param('allow_pings') );

    $app->validate_magic() or return;
    my $author = $app->user;

    # Check permissions
    my $perms = $app->permissions;

    if ( !$author->is_superuser ) {
        if ( ( $type ne 'author' ) && ( $type ne 'template' ) )
        {    # for authors, blog-ctx $perms is not relevant
            return $app->permission_denied()
                if !$perms && $id;
        }

        for my $t (@types_for_event) {
            return $app->permission_denied()
                unless $app->run_callbacks(
                'cms_save_permission_filter.' . $t,
                $app, $id );
        }
    }

    my $param = {};
    if ( $type eq 'author' ) {
        if ( my $delim = $app->param('tag_delim') ) {
            $param->{ 'auth_pref_tag_delim_' . $delim } = 1;
            $param->{'auth_pref_tag_delim'} = $delim;
        }
        my $preferred_language     = $app->param('preferred_language');
        my $create_personal_weblog = $app->param('create_personal_weblog');
        $param->{languages}
            = MT::I18N::languages_list( $app, $preferred_language )
            if $preferred_language;
        $param->{create_personal_weblog} = $create_personal_weblog ? 1 : 0;
        require MT::Permission;
        my $sys_perms = MT::Permission->perms('system');
        foreach (@$sys_perms) {
            $param->{ 'perm_can_' . $_->[0] } = 1
                if $app->param( 'can_' . $_->[0] );
        }
    }

    my $filter_result = 1;
    for my $t (@types_for_event) {
        $filter_result
            &&= $app->run_callbacks( 'cms_save_filter.' . $t, $app );
    }

    my $cfg_screen = $app->param('cfg_screen') || '';
    if ( !$filter_result ) {
        my %param = (%$param);
        $param{error}       = $app->errstr;
        $param{return_args} = $app->param('return_args');

        if ( $cfg_screen eq 'cfg_prefs' ) {
            return MT::CMS::Blog::cfg_prefs( $app, \%param );
        }
        elsif ( $app->param('forward_list') ) {
            return $app->json_error( $param{error} );
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

    my $name    = $app->param('name');
    my $outfile = $app->param('outfile');
    return $app->errtrans(
        'The Template Name and Output File fields are required.')
        if $type eq 'template' && !$name && !$outfile;

    if ( $type eq 'template' ) {

        # check for preview file
        $app->remove_preview_file;

        # check for autosave
        if ( $app->param('_autosave') ) {
            return $app->autosave_object();
        }
    }

    my ($obj);
    if ($id) {
        $obj = $class->load($id)
            or
            return $app->error( $app->translate( "Invalid ID [_1]", $id ) );
    }
    else {
        $obj = $class->new;
    }

    my $use_absolute       = $app->param('use_absolute');
    my $site_path_absolute = $app->param('site_path_absolute');

    my $original = $obj->clone();
    my $names    = $obj->column_names;
    my %values   = map { $_ => ( scalar $app->param($_) ) } @$names;
    if (   $type eq 'blog'
        && $obj->class eq 'blog'
        && ( !$cfg_screen
            || ( $cfg_screen eq 'cfg_prefs' ) )
        )
    {
        if (    $values{site_path}
            and $values{site_path}
            =~ m!^(?:/|[a-zA-Z]:\\|\\\\[a-zA-Z0-9\.]+)! )
        {
            return $app->errtrans("Invalid request.");
        }

        if (   $use_absolute
            && $site_path_absolute
            && $app->config->BaseSitePath )
        {
            my $l_path = $app->config->BaseSitePath;
            my $s_path = $site_path_absolute;
            unless ( is_within_base_sitepath( $app, $s_path ) ) {
                return $app->errtrans(
                    "The blog root directory must be within [_1].", $l_path );
            }
        }

        unless ( $obj->id ) {
            my $subdomain = $app->param('site_url_subdomain') || '';
            $subdomain = '' if !$app->param('use_subdomain');
            $subdomain .= '.' if $subdomain && $subdomain !~ /\.$/;
            $subdomain =~ s/\.{2,}/\./g;
            my $path = $app->param('site_url_path') || '';
            $values{site_url} = "$subdomain/::/$path";

            $values{site_path} = $site_path_absolute
                if !$app->config->BaseSitePath
                && $use_absolute
                && $site_path_absolute;
        }

        unless ( $author->is_superuser
            || ( $perms && $perms->can_do('save_all_settings_for_blog') ) )
        {
            if ( $id && !( $perms->can_do('save_blog_pathinfo') ) ) {
                delete $values{site_url};
                delete $values{site_path};
                delete $values{archive_url};
                delete $values{archive_path};
                delete $values{site_path_absolute};
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

    if ( $type eq 'website'
        || ( $type eq 'blog' && $obj->class eq 'website' ) )
    {
        unless ( $author->is_superuser
            || ( $perms && $perms->can_do('save_all_settings_for_website') ) )
        {
            if ( $id && !( $perms->can_do('save_blog_pathinfo') ) ) {
                delete $values{site_url};
                delete $values{site_path};
            }
            if ( $id && !( $perms->can_do('save_blog_config') ) ) {
                delete $values{$_}
                    foreach grep { $_ ne 'site_path' && $_ ne 'site_url' }
                    @$names;
            }
        }
        if ( $values{site_path} and $app->config->BaseSitePath ) {
            my $l_path = $app->config->BaseSitePath;
            my $s_path = $values{site_path};
            unless ( is_within_base_sitepath( $app, $s_path ) ) {
                return $app->errtrans(
                    "The website root directory must be within [_1].",
                    $l_path );
            }
        }
        if ( $values{site_path}
            and not File::Spec->file_name_is_absolute( $values{site_path} ) )
        {
            return $app->errtrans("Invalid request.");
        }
    }

    if ( $type eq 'author' ) {

        # Load system permission record
        my $prev_sys_perms = $obj->permissions(0)->permissions;

        #FIXME: Legacy columns - remove them
        my @cols
            = qw(is_superuser can_create_blog can_view_log can_edit_templates);
        delete $values{$_} for @cols;

        delete $values{'status'}
            if ( ( $author->id || 0 ) == ( $obj->id || 0 ) )
            || ( !$author->is_superuser && $obj->is_superuser );

        if (  !$id
            || $author->is_superuser
            || $author->can_manage_users_groups )
        {

            # Assign the auth_type unless it was assigned
            # through the form.
            $obj->auth_type( $app->config->AuthenticationModule )
                unless $obj->auth_type;
            if ( ( $values{'status'} || 0 ) == MT::Author::ACTIVE() ) {
                my $sys_perms      = MT::Permission->perms('system');
                my $can_administer = $app->param('can_administer');
                if ($can_administer) {
                    $obj->is_superuser(1);
                }
                else {
                    my %legacy_perms
                        = ( create_website => 1, create_blog => 1 );
                    foreach (@$sys_perms) {
                        next if $legacy_perms{ $_->[0] };

                        my $name  = 'can_' . $_->[0];
                        my $value = $app->param($name);
                        my $perm_obj = $obj->can($name) ? $obj : $obj->permissions(0);
                        if ( defined $value ) {
                            $perm_obj->$name($value);
                            delete $values{$name};
                        }
                        else {
                            $perm_obj->$name(0);
                        }
                    }
                }
            }
        }
        delete $values{'password'};

        # Load current system permnission, then rebuild permissions if needed.
        my $curr_sys_perms = $obj->permissions(0)->permissions;
        if (( $prev_sys_perms and !$curr_sys_perms )
            or (    $prev_sys_perms
                and $curr_sys_perms
                and $prev_sys_perms ne $curr_sys_perms )
            )
        {
            my $perm_iter = MT->model('permission')->load_iter(
                {   author_id => $obj->id,
                    blog_id   => { not => 0 },
                }
            );
            while ( my $perm = $perm_iter->() ) {

                # Clear all permissions then rebuild it.
                $perm->permissions('');
                $perm->rebuild;
            }
        }
    }

    if ( $type eq 'blog' || $type eq 'website' ) {

        # If this is a new blog, set the preferences, archive settings
        # and template set to the defaults.
        if ( !$obj->id ) {
            my $blog_language = $app->param('blog_language');
            $obj->language( $blog_language || MT->config->DefaultLanguage );
            $obj->date_language( $obj->language );
            $obj->nofollow_urls(1);
            $obj->follow_auth_links(1);
            $obj->page_layout('layout-wtt');
            my @authenticators = qw( MovableType );
            my @default_auth = split /,/, MT->config('DefaultCommenterAuth');

            foreach my $auth (@default_auth) {
                my $a = MT->commenter_authenticator($auth);
                if ( !defined $a
                    || ( exists $a->{condition} && ( !$a->{condition}->() ) )
                    )
                {
                    next;
                }
                push @authenticators, $auth;
            }
            $obj->commenter_authenticators( join ',', @authenticators );
            require MT::Theme;
            my $type_theme = $app->param( $type . '_theme' );
            my $theme      = MT::Theme->load($type_theme)
                or return $app->error('Internal error: Unknown theme!');
            $obj->theme_id( $theme->{id} );
        }

        if ( $values{file_extension} ) {
            $values{file_extension} =~ s/^\.*//
                if ( $app->param('file_extension') || '' ) ne '';
        }

        if ( $cfg_screen eq 'cfg_prefs' ) {
            $values{publish_empty_archive}
                = $app->param('publish_empty_archive') ? 1 : 0;
        }

        if ( $obj && $cfg_screen eq 'cfg_web_services' ) {
            run_web_services_save_config_callbacks( $app, $obj );
        }
    }

    if ( $type eq 'entry' || $type eq 'page' ) {

        # This has to happen prior to callbacks since callbacks may
        # be affected by the translation...

        # translates naughty words when PublishCharset is NOT UTF-8
        $app->_translate_naughty_words($obj);
    }

    if ( $type eq 'template' ) {
        my $archive_type = $app->param('archive_type');
        my $param_type   = $app->param('type') || '';
        if (   $param_type eq 'archive'
            && $archive_type )
        {
            $values{type} = $archive_type;
        }
    }

    if ( $type eq 'notification' ) {
        if ( defined $obj->blog_id ) {
            delete $values{'blog_id'};
        }
    }

    delete $values{'id'} if exists( $values{'id'} ) && !$values{'id'};
    $obj->set_values( \%values );

    if ( $obj->properties->{audit} ) {
        $obj->created_by( $author->id ) unless $obj->id;
        $obj->modified_by( $author->id ) if $obj->id;
    }

    $filter_result = 1;
    for my $t (@types_for_event) {
        $filter_result &&= $app->run_callbacks( 'cms_pre_save.' . $t,
            $app, $obj, $original );
    }
    unless ($filter_result) {
        if ( 'blog' eq $type ) {
            my $meth = $cfg_screen;
            if ( $meth && $app->handlers_for_mode($meth) ) {
                $app->mode($meth);
                $app->error(
                    $app->translate( "Save failed: [_1]", $app->errstr ) );
                return $app->$meth;
            }
        }
        $param->{return_args} = $app->param('return_args');
        my %app_param = $app->param_hash;
        while ( my ( $key, $value ) = each(%app_param) ) {
            $param->{$key} = $value unless $param->{$key};
        }
        return edit(
            $app,
            {   %$param,
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
    for my $t (@types_for_event) {
        return $app->error( $app->errstr() )
            unless $app->run_callbacks( 'cms_post_save.' . $t,
            $app, $obj, $original );
    }

    # Save NWC settings and revision settings
    if ( ( $type eq 'blog' || $type eq 'website' )
        && $cfg_screen eq 'cfg_entry' )
    {
        my $nwc_smart_replace = $app->param('nwc_smart_replace');
        my @fields;
        push( @fields, 'title' )     if $app->param('nwc_title');
        push( @fields, 'text' )      if $app->param('nwc_text');
        push( @fields, 'text_more' ) if $app->param('nwc_text_more');
        push( @fields, 'keywords' )  if $app->param('nwc_keywords');
        push( @fields, 'excerpt' )   if $app->param('nwc_excerpt');
        push( @fields, 'tags' )      if $app->param('nwc_tags');
        my $fields = @fields ? join( ',', @fields ) : 0;
        $obj->smart_replace_fields($fields);
        $obj->smart_replace($nwc_smart_replace);
        $obj->save;
    }

    # Finally, decide where to go next, depending on the object type.
    my $blog_id = $app->param('blog_id');
    if ( $type eq 'blog' || $type eq 'website' ) {
        $blog_id = $obj->id;
    }

    # if we are saving/publishing a template, make sure to log on activity log
    if ( $type eq 'template' ) {
        my $blog = $app->model('blog')->load( $obj->blog_id );
        if ($blog) {
            $app->log(
                {   message => $app->translate(
                        "'[_1]' edited the template '[_2]' in the blog '[_3]'",
                        $app->user->name, $obj->name, $blog->name
                    ),
                    level    => MT::Log::NOTICE(),
                    blog_id  => $blog->id,
                    class    => 'template',
                    category => 'edit',
                }
            );
        }
        else {
            $app->log(
                {   message => $app->translate(
                        "'[_1]' edited the global template '[_2]'",
                        $app->user->name, $obj->name
                    ),
                    level    => MT::Log::NOTICE(),
                    class    => 'template',
                    category => 'edit',
                }
            );
        }
        if ($id) {
            my $cache_key = $original->get_cache_key();
            require MT::Cache::Negotiate;
            MT::Cache::Negotiate->new()->delete($cache_key);
        }
    }

    # TODO: convert this to use $app->call_return();
    # then templates can determine the page flow.
    if ($cfg_screen) {
        if ( $cfg_screen eq 'cfg_publish_profile' ) {
            my $dcty = $obj->custom_dynamic_templates || 'none';
            if ( ( $dcty eq 'all' ) || ( $dcty eq 'archives' ) ) {
                require MT::CMS::Blog;
                my %param = ();
                MT::CMS::Blog::_create_build_order( $app, $obj, \%param );
                $app->param( 'single_template', 1 )
                    ;    # to show tmpl full-screen
                if ( $dcty eq 'all' ) {
                    $app->param( 'type', $param{build_order} );
                }
                elsif ( $dcty eq 'archives' ) {
                    my @ats = map { $_->{archive_type} }
                        @{ $param{archive_type_loop} };
                    $app->param( 'type', join( ',', @ats ) );
                }
                return MT::CMS::Blog::start_rebuild_pages_directly($app);
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
    elsif ( $type eq 'template' && $app->param('rebuild') ) {
        if ( !$id ) {

            # add return argument for newly created templates
            $app->add_return_arg( id => $obj->id );
        }
        if ( $obj->build_type ) {
            if ( $obj->type eq 'index' ) {
                require MT::Util::UniqueID;
                my $token = MT::Util::UniqueID::create_magic_token(
                    'rebuild' . time );
                if ( my $session = $app->session ) {
                    $session->set( 'mt_rebuild_token', $token );
                    $session->save;
                }
                $app->param( 'type',            'index-' . $obj->id );
                $app->param( 'tmpl_id',         $obj->id );
                $app->param( 'single_template', 1 );
                $app->param( 'ott' => $token );
                $app->add_return_arg( 'saved'     => 1 );
                $app->add_return_arg( 'published' => 1 );
                return $app->forward('start_rebuild');
            }
            else {

                # archive rebuild support
                $app->param( 'id',     $obj->id );
                $app->param( 'reedit', $obj->id );
                return $app->forward('publish_archive_templates');
            }
        }
    }
    elsif ( $type eq 'template' ) {
        if (   $obj->type eq 'archive'
            || $obj->type eq 'category'
            || $obj->type eq 'page'
            || $obj->type eq 'individual'
            || $obj->type eq 'ct'
            || $obj->type eq 'ct_archive' )
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
            if (%$terms) {
                my @maps = MT::TemplateMap->load($terms);
                my @ats  = map { $_->archive_type } @maps;
                if ( $#ats >= 0 ) {
                    $app->param( 'type', join( ',', @ats ) );
                    $app->param( 'with_indexes',    1 );
                    $app->param( 'no_static',       1 );
                    $app->param( 'template_id',     $obj->id );
                    $app->param( 'single_template', 1 );
                    require MT::CMS::Blog;
                    return MT::CMS::Blog::start_rebuild_pages_directly($app);
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
        if (   $original->userpic_asset_id
            && $original->userpic_asset_id != $obj->userpic_asset_id )
        {
            my $thumb_file = $original->userpic_file();
            my $fmgr       = MT::FileMgr->new('Local');
            if ( $fmgr->exists($thumb_file) ) {
                $fmgr->delete($thumb_file);
            }
        }
    }

    if ( $app->param('forward_list') ) {
        return $app->forward('filtered_list');
    }

    $app->add_return_arg( 'id'    => $obj->id ) if !$original->id;
    $app->add_return_arg( 'saved' => 1 );
    $app->add_return_arg(
        ( $original->id ? 'saved_changes' : 'saved_added' ) => 1 );
    $app->call_return;
}

sub run_web_services_save_config_callbacks {
    my ($app) = @_;

    my $web_services = $app->registry('web_services');
    for my $k (%$web_services) {
        my $callback = $web_services->{$k}{save_config}
            or next;

        if ( ref $callback eq 'HASH' ) {
            $callback = MT->handler_to_coderef( $callback->{code} );
        }

        $callback->( $app, @_ );
    }
}

sub edit {
    my $app = shift;

    my $type            = $app->param('_type');
    my $id              = $app->param('id');
    my @types_for_event = ($type);

    return $app->errtrans("Invalid request.")
        unless $type;

    my $class = $app->model($type)
        or return $app->errtrans( "Invalid type [_1]", $type );

    if ( $id && $type eq 'website' ) {
        $type = 'blog';
        unshift @types_for_event, $type;
    }

    # being a general-purpose method, lets look for a mode handler
    # that is specifically for editing this type. if we find it,
    # reroute to it.

    my $edit_mode = $app->mode . '_' . $type;
    if ( my $hdlrs = $app->handlers_for_mode($edit_mode) ) {
        return $app->forward( $edit_mode, @_ );
    }

    for my $t (@types_for_event) {
        return $app->errtrans("Invalid request.")
            unless is_enabled_mode( $app, 'edit', $t );
    }

    my %param = eval { $_[0] ? %{ $_[0] } : (); };
    die Carp::longmess if $@;
    my $blog_id = $app->param('blog_id');

    if ( defined($blog_id) && $blog_id ) {
        return $app->error( $app->translate("Invalid parameter") )
            unless ( $blog_id =~ m/\d+/ );
    }

    $app->remove_preview_file;

    if ( $app->param('_recover') ) {
        my $sess_obj = $app->autosave_session_obj;
        if ($sess_obj) {
            my $data = $sess_obj->thaw_data;
            if ($data) {
                $app->param( $_, $data->{$_} ) for keys %$data;
                my $recovered_id = $app->param('id');
                $app->delete_param('id')
                    if defined $recovered_id && !$recovered_id;
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
    elsif ( $app->param('_discard') ) {
        my $sess_obj = $app->autosave_session_obj;
        if ($sess_obj) {
            $sess_obj->remove;
        }
    }
    elsif ( $app->param('qp') ) {

        # dedupe
        foreach (qw( title text )) {
            my $data = $app->param($_);
            $app->param( $_, $data );
        }
    }

    $param{autosave_frequency} = $app->config->AutoSaveFrequency;

    my $perms  = $app->permissions;
    my $author = $app->user;
    my $cfg    = $app->config;
    $param{styles} = '';
    if ( $type eq 'author' ) {
        if ($blog_id) {
            return $app->return_to_dashboard( redirect => 1 );
        }
    }
    else {
        if (( !$perms || !$blog_id )
            && (   $type eq 'entry'
                || $type eq 'page'
                || $type eq 'category'
                || $type eq 'folder'
                || $type eq 'comment'
                || $type eq 'ping' )
            )
        {
            return $app->return_to_dashboard( redirect => 1 );
        }
    }

    my $cols = $class->column_names;
    require MT::Promise;
    my $obj_promise = MT::Promise::delay(
        sub {
            return $class->load($id);
        }
    );

    for my $t (@types_for_event) {
        return $app->return_to_dashboard( redirect => 1 )
            unless $app->run_callbacks( 'cms_object_scope_filter.' . $t,
            $app, $id );
    }

    if ( !$author->is_superuser ) {
        for my $t (@types_for_event) {
            return $app->permission_denied()
                unless $app->run_callbacks(
                'cms_view_permission_filter.' . $t,
                $app, $id, $obj_promise );
        }
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
            my $value = $app->param($col);
            $param{$col} = defined $value ? $value : $obj->$col();
        }

        # Make certain any blog-specific element matches the blog we're
        # dealing with. If not, call shenanigans.
        if (   ( exists $param{blog_id} )
            && ( $blog_id != ( $obj->blog_id || 0 ) ) )
        {
            return $app->return_to_dashboard( redirect => 1 );
        }

        if ( $class->properties->{audit} ) {
            my $creator = MT::Author->load(
                {   id   => $obj->created_by(),
                    type => MT::Author::AUTHOR()
                }
            );
            if ($creator) {
                $param{created_by} = $creator->name;
            }
            else {
                $param{created_by} = $app->translate("(user deleted)");
            }
            if ( my $mod_by = $obj->modified_by() ) {
                my $modified = MT::Author->load(
                    {   id   => $mod_by,
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
                $param{modified_on_formatted}
                    = format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(),
                    $ts, undef,
                    $app->user ? $app->user->preferred_language : undef );
            }
            if ( my $ts = $obj->created_on ) {
                $param{created_on_ts} = $ts;
                $param{created_on_formatted}
                    = format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(),
                    $ts, undef,
                    $app->user ? $app->user->preferred_language : undef );
            }
        }

        $param{new_object} = 0;
    }
    else {    # object is new
        $param{new_object} = 1;
        for my $col (@$cols) {
            $param{$col} = $app->param($col);
        }
    }

    {
        # If any column value is overridden by $app->param,
        # the MT (especially WYSISYG editor) will be working in tainted mode.
        $param{tainted_input} = 0;
        local $app->{login_again};
        unless ( $app->validate_magic ) {
            $param{tainted_input} ||= ( $app->param($_) || '' ) !~ /^\d*$/
                for @$cols;
        }
    }

    if ( $type eq 'website' || $type eq 'blog' ) {
        require MT::Theme;
        my $theme = $app->param( $type . '_theme' );
        $param{theme_loop} = MT::Theme->load_theme_loop( $type, $theme );
        $param{'master_revision_switch'} = $app->config->TrackRevisions;
        my $limit = File::Spec->catdir( $cfg->BaseSitePath, 'PATH' );
        $limit =~ s/PATH$//;
        $param{'sitepath_limited_trail'} = $limit;
        $param{'sitepath_limited'}       = $cfg->BaseSitePath;
        $param{'can_use_absolute'}       = !$cfg->BaseSitePath
            || ( $blog && $blog->is_site_path_absolute );
    }

    my $res = 1;
    for my $t (@types_for_event) {
        $res &&= $app->run_callbacks( 'cms_edit.' . $t, $app, $id, $obj,
            \%param );
    }
    if ( !$res ) {
        return $app->error( $app->callback_errstr() );
    }

    if ( $param{autosave_support} ) {

        # autosave support, but don't bother if we're reediting
        if ( !$app->param('reedit') ) {
            my $sess_obj = $app->autosave_session_obj;
            if ($sess_obj) {
                $param{autosaved_object_exists} = 1;
                $param{autosaved_object_ts}
                    = MT::Util::epoch2ts( $blog, $sess_obj->start );
                $param{autosaved_object_is_outdated} = 1
                    if $obj && $param{autosaved_object_ts} < $obj->modified_on;
            }
            if (my $other_user = $app->user_who_is_also_editing_the_same_stuff($obj)) {
                $param{is_also_edited_by} = $other_user->{name};
                $param{is_also_edited_at} = $other_user->{time};
            }
        }
    }

    if ( ( $app->param('msg') || "" ) eq 'nosuch' ) {
        $param{nosuch} = 1;
    }
    for my $p ( $app->multi_param ) {
        $param{$p} = $app->param($p) if $p =~ /^saved/;
    }
    $param{page_actions} = $app->page_actions( $type, $obj );
    if ( $class->can('class_label') ) {
        $param{object_label} = $class->class_label;
    }
    if ( $class->can('class_label_plural') ) {
        $param{object_label_plural} = $class->class_label_plural;
    }

    my $tmpl_file = $param{output} || "edit_${type}.tmpl";
    $param{object_type}  ||= $type;
    $param{search_label} ||= $class->class_label;
    $param{screen_id}    ||= "edit-$type";
    $param{screen_class} .= " edit-$type";

    # If this object came from non core component,
    # set component for template loading
    my @compo = MT::Component->select;
    my $component;
    foreach my $c (@compo) {
        my $r = $c->registry( 'object_types' => $type );
        if ($r) {
            $component = $c->id;
            last;
        }
    }
    local $app->{component} = $component if $component;

    if ( $app->mode eq 'cfg_web_services' ) {
        $app->add_breadcrumb( $app->translate('Web Services Settings') );
    }

    return $app->load_tmpl( $tmpl_file, \%param );
}

my %ListLimitMap = map {$_ => 1} (10, 25, 50, 100, 200);

sub canonicalize_list_limit {
    my $limit = shift || MT->config->DefaultListLimit;
    $ListLimitMap{$limit} ? $limit : 50;
}

sub list {
    my $app     = shift;
    my $type    = $app->param('_type');
    my $subtype = $app->param('type') ? '.' . $app->param('type') : '';
    my $scope
        = $app->blog ? ( $app->blog->is_blog ? 'blog' : 'website' )
        : defined $app->param('blog_id') ? 'system'
        :                                  'user';
    my $blog_id
        = $app->blog
        ? $app->blog->id
        : 0;
    my $list_mode = 'list_' . $type;
    if ( my $hdlrs = $app->handlers_for_mode($list_mode) ) {
        return $app->forward($list_mode);
    }
    my %param;
    $param{list_type} = $type . $subtype;
    my @messages;

    my @list_components = grep {
               $_->registry( list_properties => $type . $subtype )
            || $_->registry( listing_screens => $type . $subtype )
            || $_->registry( list_actions    => $type . $subtype )
            || $_->registry( content_actions => $type . $subtype )
            || $_->registry( system_filters  => $type . $subtype )
    } MT::Component->select;

    my @list_headers;
    my $core_include = File::Spec->catfile( MT->config->TemplatePath,
        $app->{template_dir}, 'listing', $type . '_list_header.tmpl' );
    push @list_headers,
        {
        filename  => $core_include,
        component => 'Core'
        }
        if -e $core_include;

    for my $c (@list_components) {
        my $f = File::Spec->catfile( $c->path, 'tmpl', 'listing',
            $type . '_list_header.tmpl' );
        push @list_headers, { filename => $f, component => $c->id } if -e $f;
    }

    my $screen_settings = MT->registry( listing_screens => $type . $subtype )
        or return $app->error(
        $app->translate( 'Unknown action [_1]', $list_mode ) );

    # Condition check
    if ( my $cond = $screen_settings->{condition} ) {
        $cond = MT->handler_to_coderef($cond)
            if 'CODE' ne ref $cond;
        $app->error();
        unless ( $cond->($app) ) {
            if ( $app->errstr ) {
                return $app->error( $app->errstr );
            }
            return $app->permission_denied();
        }
    }

    # Validate scope
    if ( my $view = $screen_settings->{view} ) {
        $view = [$view] unless ref $view;
        my %view = map { $_ => 1 } @$view;
        if ( !$view{$scope} ) {
            return $app->return_to_dashboard( redirect => 1, );
        }
    }

    # Permission check
    if ( defined $screen_settings->{permission}
        && !$app->user->is_superuser() )
    {
        my ($actions, $inherit_blogs) = eval { $app->parse_filtered_list_permission($screen_settings->{permission}) };
        my $error = $@;
        return $app->error($app->translate('Error occurred during permission check: [_1]', $error)) if $error;

        my $blog_ids = undef;
        if ($blog_id) {
            push @$blog_ids, $blog_id;
        }
        my $allowed = 0;
        foreach my $action (@$actions) {
            $allowed = 1,
                last
                if $app->user->can_do(
                $action,
                at_least_one => 1,
                ( $blog_ids ? ( blog_id => $blog_ids ) : () )
                );
        }
        return $app->permission_denied()
            unless $allowed;
    }

    my $initial_filter;

    my $list_prefs = $app->user->list_prefs || {};
    my $list_pref = $list_prefs->{ $type . $subtype }{$blog_id} || {};
    my $last_filter = $list_pref->{last_filter} || '';
    $last_filter = '' if $last_filter eq '_allpass';
    my $last_items         = $list_pref->{last_items} || [];
    my $initial_sys_filter = $app->param('filter_key');
    if ( !$initial_sys_filter && $last_filter =~ /\D/ ) {
        $initial_sys_filter = $last_filter;
    }
    $param{'limit'} = canonicalize_list_limit($list_pref->{rows});

    require MT::ListProperty;
    my $obj_type   = $screen_settings->{object_type} || $type;
    my $obj_class  = MT->model($obj_type);
    my $list_props = MT::ListProperty->list_properties( $type . $subtype );

    my $breadcrumb
        = $screen_settings->{object_label_plural}
        ? $screen_settings->{object_label_plural}
        : $obj_class->class_label_plural;
    $breadcrumb = $breadcrumb->() if ref $breadcrumb eq 'CODE';
    $app->add_breadcrumb( $app->translate($breadcrumb) );

    if ( $app->param('no_filter') ) {

        # Nothing to do.
    }
    elsif ( my @cols = $app->multi_param('filter') ) {
        my @vals = $app->multi_param('filter_val');
        my @items;
        my @labels;
        for my $col (@cols) {
            my $val = shift @vals;
            if ( my $prop = $list_props->{$col} ) {
                my ( $args, $label );
                if ( $prop->has('args_via_param') ) {
                    $args = $prop->args_via_param( $app, $val );
                    if ( !$args ) {
                        if ( my $errstr = $prop->errstr ) {
                            push @messages,
                                {
                                cls => 'warning',
                                msg => MT->translate(
                                    q{Invalid filter: [_1]},
                                    MT::Util::encode_html($errstr)
                                )
                                };
                        }
                        next;
                    }
                }
                if ( $prop->has('label_via_param') ) {
                    $label = $prop->label_via_param( $app, $val );
                    if ( !$label ) {
                        if ( my $errstr = $prop->errstr ) {
                            push @messages,
                                {
                                cls => 'warning',
                                msg => MT->translate(
                                    q{Invalid filter: [_1]},
                                    MT::Util::encode_html($errstr),
                                )
                                };
                        }
                        next;
                    }
                }
                push @items,
                    {
                    type => $col,
                    args => ( $args || {} ),
                    };
                push @labels, ( $label || $prop->label );
            }
            else {
                push @messages,
                    {
                    cls => 'warning invalid-filter',
                    msg => MT->translate(
                        q{Invalid filter: [_1]},
                        MT::Util::encode_html($col),
                    )
                    };
            }
        }
        if ( scalar @items ) {
            $initial_filter = {
                label => join( ', ', @labels ),
                items => \@items,
            };
        }
        else {
            $initial_filter = undef;
        }
    }
    elsif ($initial_sys_filter) {
        require MT::CMS::Filter;
        $initial_filter = MT::CMS::Filter::filter( $app, $type . $subtype,
            $initial_sys_filter );
    }
    elsif ($last_filter) {
        my $filter = MT->model('filter')->load($last_filter);
        $initial_filter = $filter->to_hash if $filter;
    }
    elsif ( scalar @$last_items && $app->param('does_act') ) {
        my $filter = MT->model('filter')->new;
        $filter->set_values(
            {   object_ds => $obj_type,
                items     => $last_items,
                author_id => $app->user->id,
                blog_id   => $blog_id || 0,
                label     => $app->translate('New Filter'),
                can_edit  => 1,
            }
        );
        $initial_filter = $filter->to_hash if $filter;
        $param{open_filter_panel} = 1;
    }

    my $columns = $list_pref->{columns} || [];
    my %cols = map { $_ => 1 } @$columns;

    my $primary_col = $screen_settings->{primary};
    $primary_col ||= [ @{ $screen_settings->{columns} || [] } ]->[0];
    $primary_col = [$primary_col] unless ref $primary_col;
    my %primary_col = map { $_ => 1 } @$primary_col;
    my $default_sort
        = defined( $screen_settings->{default_sort_key} )
        ? $screen_settings->{default_sort_key}
        : '';

    my @list_columns;
    for my $prop ( values %$list_props ) {
        next if !$prop->can_display($scope);
        my $id   = $prop->id;
        my $disp = $prop->display || 'optional';
        my $show
            = $disp eq 'force'   ? 1
            : $disp eq 'none'    ? 0
            : scalar %cols       ? $cols{$id}
            : $disp eq 'default' ? 1
            :                      0;

        my $force   = $disp eq 'force'   ? 1 : 0;
        my $default = $disp eq 'default' ? 1 : 0;
        my @subfields;

        if ( my $subfields = $prop->sub_fields ) {
            for my $sub (@$subfields) {
                my $sdisp = $sub->{display} || 'optional';
                my $display
                    = $sdisp eq 'force'   ? 1
                    : $sdisp eq 'none'    ? 0
                    : scalar %cols        ? $cols{ $id . '.' . $sub->{class} }
                    : $sdisp eq 'default' ? 1
                    :                       0;
                push @subfields,
                    {
                    display    => $display,
                    id         => $id . '.' . $sub->{class},
                    class      => $sub->{class},
                    parent_id  => $id,
                    label      => $app->translate( $sub->{label} ),
                    is_default => $sdisp eq 'default' ? 1 : 0,
                    checked    => $display,
                    };
            }
        }
        push @list_columns,
            {
            id                 => $prop->id,
            type               => $prop->type,
            label              => MT::Util::encode_html( $prop->label, 1 ),
            primary            => $primary_col{$id} ? 1 : 0,
            col_class          => $prop->col_class,
            sortable           => $prop->can_sort($scope),
            sorted             => $prop->id eq $default_sort ? 1 : 0,
            display            => $show,
            is_default         => $force || $default,
            checked            => $show,
            force_display      => $force,
            default_sort_order => $prop->default_sort_order || 'ascend',
            order              => $prop->order,
            sub_fields         => \@subfields,
            };
    }
    @list_columns = sort {
              !$a->{order} ? 1
            : !$b->{order} ? -1
            : $a->{order} <=> $b->{order}
    } @list_columns;

    my @filter_types;
    for my $prop ( values %$list_props ) {
        next unless $prop->can_filter($scope);

        my $label_for_sort;
        if ( defined $prop->filter_label ) {
            $label_for_sort
                = ref $prop->filter_label eq 'CODE'
                ? $prop->filter_label->($screen_settings)
                : $prop->filter_label;
        }
        if ( !defined $label_for_sort ) {
            $label_for_sort
                = ref $prop->label eq 'CODE'
                ? $prop->label->($screen_settings)
                : $prop->label;
            $label_for_sort = '' unless defined $label_for_sort;
        }

        push @filter_types,
            {
            prop => $prop,
            id   => $prop->id,
            type => $prop->type,
            label => $prop->filter_label || $prop->label,
            field                 => $prop->filter_tmpl,
            single_select_options => $prop->single_select_options($app),
            verb                  => defined $prop->verb ? $prop->verb
            : $app->translate('__SELECT_FILTER_VERB'),
            singleton => $prop->singleton ? 1
            : $prop->has('filter_editable') ? !$prop->filter_editable
            : 0,
            editable => $prop->has('filter_editable') ? $prop->filter_editable
            : 1,
            base_type      => $prop->base_type,
            item_order     => $prop->item_order || 0,
            label_for_sort => $label_for_sort,
            };
    }
    @filter_types = sort {
               $a->{item_order} <=> $b->{item_order}
            or $a->{label_for_sort} cmp $b->{label_for_sort}
    } @filter_types;

    require MT::CMS::Filter;
    my $filters = MT::CMS::Filter::filters( $app, $type . $subtype );

    my $allpass_filter = {
        label => MT->translate(
            'All [_1]',
            $screen_settings->{object_label_plural}
            ? $screen_settings->{object_label_plural}
            : $obj_class->class_label_plural
        ),
        items    => [],
        id       => '_allpass',
        can_edit => 0,
        can_save => 0,
    };
    $initial_filter = $allpass_filter
        unless $initial_filter;

    require JSON;
    my $json = JSON->new->utf8(0);

    my $encode_filter = sub {
        my $raw     = shift;
        my $encoded = $json->encode($raw);
        $encoded =~ s/(s)(cript)/$1\\$2/gi;
        return $encoded;
    };

    $param{common_listing}     = 1;
    $param{blog_id}            = $blog_id || '0';
    $param{filters}            = $encode_filter->($filters),
        $param{initial_filter} = $encode_filter->($initial_filter),
        $param{allpass_filter} = $encode_filter->($allpass_filter);
    $param{system_messages}   = $json->encode( \@messages );
    $param{filters_raw}       = $filters;
    $param{default_sort_key}  = $default_sort;
    $param{list_columns}      = \@list_columns;
    $param{list_columns_json} = $json->encode( \@list_columns );
    $param{filter_types}      = \@filter_types;
    $param{object_type}       = $type;
    $param{subtype}           = $app->param('type');
    $param{page_title}        = $screen_settings->{screen_label};
    $param{list_headers}      = \@list_headers;
    $param{build_user_menus}  = $screen_settings->{has_user_properties};
    $param{use_filters}       = 1;
    $param{use_actions}       = 1;
    $param{object_label}      = $screen_settings->{object_label}
        || $obj_class->class_label;
    $param{object_label_plural}
        = $screen_settings->{object_label_plural}
        ? $screen_settings->{object_label_plural}
        : $obj_class->class_label_plural;
    $param{action_label} = $screen_settings->{action_label}
        if $screen_settings->{action_label};
    $param{action_label_plural} = $screen_settings->{action_label_plural}
        if $screen_settings->{action_label_plural};
    $param{contents_label} = $screen_settings->{contents_label}
        || $obj_class->contents_label;
    $param{contents_label_plural} = $screen_settings->{contents_label_plural}
        || $obj_class->contents_label_plural;
    $param{container_label} = $screen_settings->{container_label}
        || $obj_class->container_label;
    $param{container_label_plural}
        = $screen_settings->{container_label_plural}
        || $obj_class->container_label_plural;
    $param{zero_state}
        = $screen_settings->{zero_state}
        ? $app->translate( $screen_settings->{zero_state} )
        : '',

        my $s_type = $screen_settings->{search_type} || $obj_type;
    if ( my $search_apis = $app->registry( search_apis => $s_type ) ) {
        $param{search_type}  = $s_type;
        $param{search_label} = $search_apis->{label};
    }
    else {
        $param{search_type}  = 'entry';
        $param{search_label} = MT->translate('Entries');
    }

    my $template = $screen_settings->{template};
    my $component;
    if ($template) {

        # If this object came from non core component,
        # set component for template loading
        my @compo = MT::Component->select;
        foreach my $c (@compo) {
            my $r = $c->registry( 'object_types' => ($type) );
            if ($r) {
                $component = $c->id;
                last;
            }
        }
    }
    else {
        $template = 'list_common.tmpl';
    }

    my $feed_link = $screen_settings->{feed_link};
    $feed_link = $feed_link->($app)
        if 'CODE' eq ref $feed_link;
    if ($feed_link and !MT->config->DisableActivityFeeds) {
        my $view = $subtype ? $app->param('type') : $type;
        $param{feed_url} = $app->make_feed_link( $view,
            $blog_id ? { blog_id => $blog_id } : undef );
        $param{object_type_feed}
            = $screen_settings->{feed_label}
            ? $screen_settings->{feed_label}
            : $app->translate( "[_1] Feed", $obj_class->class_label );
    }

    if ( $param{use_actions} ) {
        $app->load_list_actions( ( $type . $subtype ), \%param );
        $app->load_content_actions( ( $type . $subtype ), \%param );
    }

    push @{ $param{debug_panels} },
        {
        name      => 'CommonListing',
        title     => 'CommonListing',
        nav_title => 'CommonListing',
        content =>
            '<pre id="listing-debug-block" style="border: 1px solid #000; background-color: #eee; font-family: Courier;"></pre>',
        }
        if $MT::DebugMode;

    local $app->{component} = $component if $component;
    my $tmpl = $app->load_tmpl( $template, \%param )
        or return;
    $app->run_callbacks( 'list_template_param.' . $type,
        $app, $tmpl->param, $tmpl );
    return $tmpl;
}

sub filtered_list {
    my $app              = shift;
    my (%forward_params) = @_;
    my $blog_id          = $app->param('blog_id') || 0;
    my $filter_id        = $app->param('fid') || $forward_params{saved_fid};
    my $blog             = $blog_id ? $app->blog : undef;
    my $scope
        = !$blog         ? 'system'
        : $blog->is_blog ? 'blog'
        :                  'website';
    my $blog_ids
        = !$blog         ? undef
        : $blog->is_blog ? [$blog_id]
        :                  [ $blog->id, map { $_->id } @{ $blog->blogs } ];
    my $debug    = {};
    my @messages = @{ $forward_params{messages} || [] };

    if ($MT::DebugMode) {
        require Time::HiRes;
        $debug->{original_prof}      = $Data::ObjectDriver::PROFILE;
        $Data::ObjectDriver::PROFILE = 1;
        $debug->{sections}           = [];
        $debug->{out}                = '';
        $debug->{section}            = sub {
            my ($section) = @_;
            push @{ $debug->{sections} },
                [
                $section,
                Time::HiRes::tv_interval( $debug->{timer} ),
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
        $debug->{section} = sub { };
    }

    my $ds      = $app->param('datasource');
    my $setting = MT->registry( listing_screens => $ds )
        or return $app->json_error( $app->translate('Unknown list type') );

    if ( my $cond = $setting->{condition} ) {
        $cond = MT->handler_to_coderef($cond)
            if 'CODE' ne ref $cond;
        $app->error();
        unless ( $cond->($app) ) {
            if ( $app->errstr ) {
                return $app->json_error( $app->errstr );
            }
            return $app->json_error( $app->translate('Invalid request') );
        }
    }

    # Validate scope
    if ( my $view = $setting->{view} ) {
        $view = [$view] unless ref $view;
        my %view = map { $_ => 1 } @$view;
        if ( !$view{$scope} ) {
            return $app->json_error( $app->translate('Invalid request') );
        }
    }

    # Permission check
    if ( defined $setting->{permission}
        && !$app->user->is_superuser() )
    {
        my $allowed = 0;
        my ($actions, $inherit_blogs) = eval { $app->parse_filtered_list_permission($setting->{permission}) };
        my $error = $@;
        return $app->json_error($app->translate('Error occurred during permission check: [_1]', $error)) if $error;

        foreach my $action (@$actions) {
            $allowed = 1,
                last
                if $app->user->can_do(
                $action,
                at_least_one => 1,
                ( $blog_ids ? ( blog_id => $blog_ids ) : () )
                );
        }
        return $app->json_error(
            $app->translate(
                'Permission denied: [_1]',
                join( ',', @$actions )
            )
        ) unless $allowed;
    }

    my $filteritems;
    my $allpass = 0;
    if ( my $items = $app->param('items') ) {
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
        $allpass     = 1;
        $filteritems = [];
    }
    require MT::ListProperty;
    my $props = MT::ListProperty->list_properties($ds);
    if ( !$forward_params{validated} ) {
        for my $item (@$filteritems) {
            my $prop = $props->{ $item->{type} };
            if ( $prop->has('validate_item') ) {
                $prop->validate_item($item)
                    or return $app->json_error(
                    MT->translate(
                        'Invalid filter terms: [_1]',
                        $prop->errstr
                    )
                    );
            }
        }
    }

    my $filter = MT->model('filter')->new;
    $filter->set_values(
        {   object_ds => $ds,
            items     => $filteritems,
            author_id => $app->user->id,
            blog_id   => $blog_id || 0,
        }
    );
    my $limit = $app->param('limit');
    $limit = canonicalize_list_limit($limit);
    my $page  = $app->param('page');
    $page = 1 if !$page || $page =~ /\D/;
    my $offset = ( $page - 1 ) * $limit;

    $MT::DebugMode
        && $debug->{print}->("LIMIT: $limit PAGE: $page OFFSET: $offset");
    $MT::DebugMode && $debug->{section}->('initialize');

    ## FIXME: take identifical column from column defs.
    my $cols
        = defined( $app->param('columns') ) ? $app->param('columns') : '';
    my @cols    = grep {/^[^\.]+$/} split( ',', $cols );
    my @subcols = grep {/\./} split( ',', $cols );
    my $class   = MT->model( $setting->{object_type} || $ds );
    if ( $class->has_column('id') ) {
        unshift @cols,    '__id';
        unshift @subcols, '__id';
    }
    elsif ( $setting->{id_column} ) {
        unshift @cols,    $setting->{id_column};
        unshift @subcols, $setting->{id_column};
    }

    $MT::DebugMode && $debug->{print}->("COLUMNS: $cols");

    my $scope_mode   = $setting->{scope_mode} || 'wide';
    my @blog_id_term = (
         !$blog_id              ? ()
        : $scope_mode eq 'none' ? ()
        : $scope_mode eq 'this' ? ( blog_id => $blog_id )
        :                         ( blog_id => $blog_ids )
    );

    my %load_options = (
        terms      => {@blog_id_term},
        args       => {},
        sort_by    => $app->param('sort_by') || '',
        sort_order => $app->param('sort_order') || '',
        limit      => $limit,
        offset     => $offset,
        scope      => $scope,
        blog       => $blog,
        blog_id    => $blog_id,
        blog_ids   => $blog_ids,
    );

    my %count_options = (
        terms    => {@blog_id_term},
        args     => {},
        scope    => $scope,
        blog     => $blog,
        blog_id  => $blog_id,
        blog_ids => $blog_ids,
    );

    my $callback_ds = $ds;
    if ( $ds =~ m/(.*)\./ ) {
        $callback_ds = $1;
    }
    MT->run_callbacks( 'cms_pre_load_filtered_list.' . $callback_ds,
        $app, $filter, \%count_options, \@cols );

    my $count_result = $filter->count_objects(%count_options);
    if ( !defined $count_result ) {
        return $app->json_error(
            MT->translate(
                "An error occurred while counting objects: [_1]",
                $filter->errstr
            )
        );
    }
    my ( $count, $editable_count ) = @$count_result;

    $MT::DebugMode && $debug->{section}->('count objects');
    $load_options{total} = $count;

    my ( $objs, @data );
    if ($count) {
        MT->run_callbacks( 'cms_pre_load_filtered_list.' . $callback_ds,
            $app, $filter, \%load_options, \@cols );

        $objs = $filter->load_objects(%load_options);
        if ( !defined $objs ) {
            return $app->json_error(
                MT->translate(
                    "An error occurred while loading objects: [_1]",
                    $filter->errstr
                )
            );
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
        for my $col (@cols) {
            my $prop = $props->{$col} or next;
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
                for my $obj (@$objs) {
                    push @result, $prop->html( $obj, $app, \%load_options );
                }
            }
            elsif ( $prop->has('html_link') ) {
                for my $obj (@$objs) {
                    my $link = $prop->html_link( $obj, $app, \%load_options );
                    my $raw  = MT::Util::encode_html(
                        $prop->raw( $obj, $app, \%load_options ) );
                    push @result,
                        ( $link ? qq{<a href="$link">$raw</a>} : $raw );
                }
            }
            elsif ( $prop->has('raw') ) {
                for my $obj (@$objs) {
                    my $out = $prop->raw( $obj, $app, \%load_options );
                    push @result, MT::Util::encode_html($out);
                }
            }

            push @results, \@result;
            $MT::DebugMode && $debug->{section}->("prepare col $col");
        }

        for my $i ( 0 .. scalar @$objs - 1 ) {
            push @data, [ map { $_->[$i] } @results ];
        }
    }

    ## Save user list prefs.
    my $list_prefs = $app->user->list_prefs || {};
    my $list_pref = $list_prefs->{$ds}{$blog_id} ||= {};
    $list_pref->{rows}    = $limit;
    $list_pref->{columns} = [ split ',', $cols ];
    $list_pref->{last_filter}
        = $filter_id ? $filter_id : $allpass ? '_allpass' : '';
    $list_pref->{last_items} = $filteritems;
    $app->user->list_prefs($list_prefs);
    ## FIXME: should handle errors..
    $app->user->save;

    require MT::CMS::Filter;
    my $filters = MT::CMS::Filter::filters( $app, $ds );

    require POSIX;
    my %res;
    $res{objects}        = \@data;
    $res{columns}        = $cols;
    $res{count}          = $count;
    $res{editable_count} = $editable_count;
    $res{page}           = $page;
    $res{page_max}       = POSIX::ceil( $count / $limit );
    $res{id}             = $filter_id;
    $res{label} = MT::Util::encode_html( $forward_params{saved_label} )
        if $forward_params{saved_label};
    $res{filters}  = $filters;
    $res{messages} = \@messages;
    %res = ( %forward_params, %res );
    $MT::DebugMode && $debug->{section}->('finalize');
    MT->run_callbacks( 'cms_filtered_list_param.' . $callback_ds,
        $app, \%res, $objs );

    if ($MT::DebugMode) {
        my $total = Time::HiRes::tv_interval( $debug->{total} );
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
        $out .= sprintf "TOTAL: %0.2f ms\n",    $total * 1000;
        $out .= sprintf "Matched %i Objects\n", $count;
        $res{debug} = $out;
        $Data::ObjectDriver::PROFILE = $debug->{original_prof};
    }
    return $app->json_result( \%res );
}

sub save_list_prefs {
    my $app     = shift;
    my $ds      = $app->param('datasource');
    my $blog_id = $app->param('blog_id') || 0;
    my $blog    = $blog_id ? $app->blog : undef;
    my $scope
        = !$blog         ? 'system'
        : $blog->is_blog ? 'blog'
        :                  'website';
    my $cols       = $app->param('columns') || '';
    my $list_prefs = $app->user->list_prefs || {};
    my $list_pref = $list_prefs->{$ds}{$blog_id} ||= {};
    my $limit = $app->param('limit');
    $list_pref->{rows}    = canonicalize_list_limit($limit);
    $list_pref->{columns} = [ split ',', $cols ];

#$list_pref->{last_filter} = $filter_id ? $filter_id : $allpass ? '_allpass' : '';
#$list_pref->{last_items} = $filteritems;
    $app->user->list_prefs($list_prefs);
    $app->user->save
        or return $app->json_error( $app->user->errstr );
    return $app->json_result( { success => 1 } );
}

sub delete {
    my $app  = shift;
    my $type = $app->param('_type');

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

    return $app->errtrans("Invalid request.")
        unless is_enabled_mode( $app, 'delete', $type );

    my $parent  = $app->param('parent');
    my $blog_id = $app->param('blog_id');
    my $class   = $app->model($type) or return;
    my $author  = $app->user;

    $app->validate_magic() or return;
    $app->setup_filtered_ids
        if $app->param('all_selected');

    my ( $entry_id, $cat_id, $author_id ) = ( "", "", "" );
    my %rebuild_entries;
    my @rebuild_cats;
    my $required_items = 0;
    my @not_deleted;
    my $delete_count = 0;
    my %return_arg;
    for my $id ( $app->multi_param('id') ) {
        next unless $id;    # avoid 'empty' ids
        if ( ( $type eq 'association' ) && ( $id =~ /PSEUDO-/ ) ) {
            require MT::CMS::User;
            MT::CMS::User::_delete_pseudo_association( $app, $id );
            next;
        }

        my $obj = $class->load($id);
        next unless $obj;
        $app->run_callbacks( 'cms_delete_permission_filter.' . $type,
            $app, $obj )
            || return $app->permission_denied();

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
                my $ot_class = $app->model('objecttag');
                my $blog     = $app->model('blog')->load($blog_id);
                my $iter     = $ot_class->load_iter(
                    {   (   $blog->is_blog
                            ? ( blog_id => $blog_id )
                            : ( blog_id => [
                                    map { $_->id } @{ $blog->blogs }, $blog
                                ]
                            )
                        ),
                        tag_id => $id
                    }
                );

                if ($iter) {
                    my @ot;
                    while ( my $ot = $iter->() ) {
                        push @ot, $ot->id;
                    }
                    foreach (@ot) {
                        my $ot = $ot_class->load($_);
                        next unless $ot;
                        $ot->remove
                            or return $app->errtrans(
                            'Removing tag failed: [_1]',
                            $ot->errstr );

                        # Clear cache
                        my $linked_class
                            = $app->model( $ot->object_datasource );
                        my $linked = $linked_class->load( $ot->object_id );
                        next unless $linked;

                        $linked->{__tags} = [];
                        delete $linked->{__save_tags};
                        MT::Tag->clear_cache(
                            datasource => $linked->datasource,
                            (   $linked->blog_id
                                ? ( blog_id => $linked->blog_id )
                                : ()
                            )
                        );

                        require MT::Memcached;
                        if ( MT::Memcached->is_available ) {
                            MT::Memcached->instance->delete(
                                $linked->tag_cache_key );
                        }
                    }
                }

                $app->run_callbacks( 'cms_post_delete.' . $type, $app, $obj );
                next;

            }
        }
        elsif ( $type eq 'category' ) {
            require MT::CMS::Category;
            MT::CMS::Category::pre_delete( $app, $obj )
                or return $app->trans_error( 'Cannot load blog #[_1].',
                $blog_id );
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
            $app->run_callbacks( 'cms_delete_ext_author_filter',
                $app, $obj, \%return_arg )
                || next;
        }
        elsif ( $type eq 'website' ) {
            my $blog_class = $app->model('blog');
            my $count      = $blog_class->count( { parent_id => $obj->id, } );
            if ( $count > 0 ) {
                push @not_deleted, $obj->id;
                next;
            }
        }
        elsif ( $type eq 'template' ) {
            my $cache_key = $obj->get_cache_key();
            require MT::Cache::Negotiate;
            MT::Cache::Negotiate->new()->delete($cache_key);

            # FIXME: enumeration of types
            if ( $obj->type
                !~ /(custom|index|archive|page|individual|category|widget|backup|ct|ct_archive)/
                )
            {
                $required_items++;
                next;
            }
        }
        elsif ( $type eq 'content_type' ) {
            my $template_class = $app->model('template');
            my $count
                = $template_class->count(
                { content_type_id => $obj->id, type => { not => 'backup' } }
                );
            if ( $count > 0 ) {
                push @not_deleted, $obj->id;
                next;
            }

            my $used_in_content_type_field
                = $app->model('content_field')->exist(
                {   blog_id                 => $obj->blog_id,
                    related_content_type_id => $obj->id,
                },
                {   join => $app->model('content_type')
                        ->join_on( undef, { id => \'= cf_content_type_id', },
                        ),
                },
                );
            if ($used_in_content_type_field) {
                push @not_deleted, $obj->id;
                next;
            }
        }
        elsif ( $type eq 'category_set' ) {
            my $used_in_categories_field
                = $app->model('content_field')->exist(
                {   blog_id            => $obj->blog_id,
                    related_cat_set_id => $obj->id,
                },
                {   join => $app->model('content_type')
                        ->join_on( undef, { id => \'= cf_content_type_id', },
                        ),
                },
                );
            if ($used_in_categories_field) {
                push @not_deleted, $obj->id;
                next;
            }
        }

        $obj->remove
            or return $app->errtrans(
            'Removing [_1] failed: [_2]',
            $app->translate($type),
            $obj->errstr
            );
        $app->run_callbacks( 'cms_post_delete.' . $type, $app, $obj );
        $delete_count++;
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
        $return_arg{not_deleted} = 1;
        $return_arg{error_id}    = join ',', @not_deleted;
    }
    else {
        $return_arg{
            $type eq 'ping'
            ? 'saved_deleted_ping'
            : 'saved_deleted'
            }
            = 1;
    }

    if ( $app->param('is_power_edit') ) {
        $return_arg{is_power_edit} = 1;
    }
    if ($required_items) {
        $return_arg{error}
            = $app->translate("System templates cannot be deleted.");
    }

    if ( $app->param('xhr') ) {
        my @msgs;
        if ( delete $return_arg{saved_deleted} ) {
            push @msgs,
                {
                cls => 'success',
                msg => MT->translate(
                    'The selected [_1] has been deleted from the database.',
                    $delete_count == 1
                    ? $class->class_label
                    : $class->class_label_plural,
                )
                };
        }

        $return_arg{messages} = \@msgs;
        return \%return_arg;
    }
    else {
        $app->add_return_arg(%return_arg);
        return $app->call_return;
    }
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

    my $type    = $app->param('_type');
    my $blog_id = $app->param('blog_id');
    my $dialog  = $app->param('dialog');
    my $class   = $app->model($type);
    my $param   = $args{param};
    my $obj     = $args{object};
    my $blog    = $obj->blog || MT::Blog->load($blog_id);
    my $lang    = $app->user ? $app->user->preferred_language : undef;

    my $js = $param->{rev_js};
    unless ($js) {
        $js
            = "location.href='"
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
    my $broken_rev = 0;
    my $hasher = sub {
        my ( $rev, $row ) = @_;
        if ( my $ts = $rev->created_on ) {
            $row->{created_on_formatted}
                = format_ts( MT::App::CMS::LISTING_DATE_FORMAT(),
                $ts, $blog, $lang );
            $row->{created_on_time_formatted}
                = format_ts( MT::App::CMS::LISTING_TIMESTAMP_FORMAT(),
                $ts, $blog, $lang );
            $row->{created_on_relative} = relative_date( $ts, time, $blog );
        }
        if ( $row->{created_by} ) {
            my $created_user = $users{ $row->{created_by} }
                ||= MT::Author->load( $row->{created_by} );
            if ($created_user) {
                $row->{created_by} = $created_user->nickname;
            }
            else {
                $row->{created_by} = $app->translate('(user deleted)');
            }
        }

        my $revision = $obj->object_from_revision($rev);

        if (!$revision) {
            $row->{is_broken} = 1;
            $broken_rev++;
            return;
        }

        my $column_defs = $obj->column_defs;

        #my @changed = map {
        #    my $label = $column_defs->{$_}->{label};
        #    $label ||= $_;
        #    $app->translate( $label );
        #} @{ $revision->[1] };
        #$row->{changed_columns} = \@changed;
        if ( $type =~ /^(entry|page|content_data)$/ ) {
            $row->{rev_status} = $revision->[0]->status;
        }
        $row->{rev_js}     = $js . '&amp;r=' . $row->{rev_number} . "'";
        $row->{is_current} = $param->{revision} == $row->{rev_number};
    };
    my $ret = $app->listing(
        {   type   => "$type:revision",
            code   => $hasher,
            terms  => { $class->datasource . '_id' => $obj->id },
            source => $type,
            params => { dialog => $dialog, },
            %$param
        }
    );

    if ($broken_rev > 0) {
        MT->log({
            message => MT->translate(
                '[_1] broken revisions of [_2](id:[_3]) are removed.',
                $broken_rev, MT->translate($class->datasource), $obj->id
            ),
            blog_id   => $blog->id,
            author_id => $app->user->id,
            category  => 'edit',
            level     => MT::Log::NOTICE(),
        });
    }

    return $ret;
}

sub list_revision {
    my $app     = shift;
    my $type    = $app->param('_type');
    my $class   = $app->model($type);
    my $id      = $app->param('id');
    my $rn      = $app->param('r');
    my $blog_id = $app->param('blog_id');

    return $app->errtrans('Invalid request')
        unless $class->isa('MT::Revisable');

    $id =~ s/\D//g;
    require MT::Promise;
    my $obj_promise = MT::Promise::delay(
        sub {
            return $class->load($id);
        }
    );

    $app->run_callbacks( 'cms_view_permission_filter.' . $type,
        $app, $id, $obj_promise )
        || return $app->permission_denied();

    my $obj  = $obj_promise->force();
    my $blog = $obj->blog || MT::Blog->load($blog_id);
    my $js   = "parent.location.href='" . $app->uri;
    if ( $type eq 'content_data' ) {
        $js .= '?__mode=view&amp;_type=content_data&amp;content_type_id='
            . $obj->content_type_id;
    }
    else {
        $js .= '?__mode=view&amp;_type=' . $type;
    }
    $js .= '&amp;id=' . $obj->id;
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
    return build_revision_table(
        $app,
        object => $obj,
        param  => {
            template => 'dialog/list_revision.tmpl',
            args     => {
                sort_order => 'rev_number',
                direction  => 'descend',
            },
            rev_js   => $js,
            revision => $revision,
        }
    );
}

# Currently, not in use.
sub save_snapshot {
    my $app   = shift;
    my $type  = $app->param('_type');
    my $id    = $app->param('id');
    my $param = {};

    return $app->errtrans("Invalid request.")
        unless $type;

    $app->validate_magic() or return;

    $app->run_callbacks( 'cms_save_permission_filter.' . "$type:revision",
        $app, $id )
        || return $app->error(
        $app->translate( "Permission denied: [_1]", $app->errstr() ) );

    my $filter_result
        = $app->run_callbacks( 'cms_save_filter.' . "$type:revision", $app );
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
            or
            return $app->error( $app->translate( "Invalid ID [_1]", $id ) );
    }
    else {
        $obj = $class->new;
    }

    my $original = $obj->clone();
    my $names    = $obj->column_names;
    my %values   = map { $_ => scalar $app->param($_) } @$names;

    if ( ( 'entry' eq $type ) || ( 'page' eq $type ) ) {
        $app->_translate_naughty_words($obj);
    }
    delete $values{'id'} if exists( $values{'id'} ) && !$values{'id'};
    $obj->set_values( \%values );
    unless (
        $app->run_callbacks(
            'cms_pre_save.' . "$type:revision",
            $app, $obj, undef
        )
        )
    {
        $param->{return_args} = $app->param('return_args');
        return edit(
            $app,
            {   %$param,
                error => $app->translate(
                    "Saving snapshot failed: [_1]",
                    $app->errstr
                )
            }
        );
    }
    $obj->gather_changed_cols($original);
    if ( exists $obj->{changed_revisioned_cols} ) {
        my $col = 'max_revisions_' . $obj->datasource;
        if ( my $blog = $obj->blog ) {
            my $max = $blog->$col;
            $obj->handle_max_revisions($max);
        }
        my $revision_note = $app->param('revision-note');
        my $revision      = $obj->save_revision($revision_note);
        $app->add_return_arg( r => $revision );
        if ($id) {
            my $obj_revision = $original->revision || 0;
            unless ($obj_revision) {
                $original->revision( $revision - 1 );

                # hack to bypass instance save method
                $original->{__meta}->save;
            }
            $original->current_revision($revision);

            # call update to bypass instance save method
            $original->update
                or return $original->error( $original->errstr );
        }

        $app->run_callbacks( 'cms_post_save.' . "$type:revision",
            $app, $obj, undef )
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
    $app->build_page('dialog/empty_dialog.tmpl');
}

sub is_disabled_mode {
    my $app = shift;
    my ( $mode, $type ) = @_;

    my $res;
    if ( my $reg = $app->registry( 'disable_object_methods', $type ) ) {
        if ( defined $reg->{$mode} ) {
            if ( 'CODE' eq ref $reg->{$mode} ) {
                my $code = $reg->{$mode};
                $code = MT->handler_to_coderef($code);
                $res  = $code->();
            }
            else {
                $res = $reg->{$mode};
            }
        }
    }
    return $res;
}

sub is_enabled_mode {
    my $app = shift;
    my ( $mode, $type ) = @_;

    my $res;
    if ( my $reg = $app->registry( 'enable_object_methods', $type ) ) {
        if ( defined $reg->{$mode} ) {
            if ( 'CODE' eq ref $reg->{$mode} ) {
                my $code = $reg->{$mode};
                $code = MT->handler_to_coderef($code);
                $res  = $code->();
            }
            else {
                $res = $reg->{$mode};
            }
        }
    }
    return $res;
}

sub is_within_base_sitepath {
    my ( $app, $s_path ) = @_;
    return unless (defined $s_path && $s_path ne '');
    
    my $l_path = $app->config->BaseSitePath;

    # making sure that we have a '/' in the end of the paths
    $l_path = File::Spec->catdir( $l_path, "PATH" );
    $l_path =~ s/PATH$//;
    $l_path = quotemeta($l_path);
    $s_path = File::Spec->catdir( $s_path, "PATH" );
    $s_path =~ s/PATH$//;

    return $s_path =~ m/^$l_path/i;
}

1;
