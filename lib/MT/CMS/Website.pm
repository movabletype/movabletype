# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Website;

use strict;
use warnings;
use MT::CMS::Blog;

sub edit {
    my $cb = shift;
    my ( $app, $id, $obj, $param ) = @_;

    my $cfg     = $app->config;
    my $blog    = $obj || $app->blog;
    my $blog_id = $id;

    return $app->return_to_dashboard( redirect => 1 )
        if $blog && !$id;

    return $app->permission_denied()
        if !$id && !$app->user->can_create_site();

    my $lang;
    if ($id) {
        my $output = $param->{output} ||= 'cfg_prefs.tmpl';
        $param->{need_full_rebuild}  = 1 if $app->param('need_full_rebuild');
        $param->{need_index_rebuild} = 1 if $app->param('need_index_rebuild');
        $param->{show_ip_info} = $cfg->ShowIPInformation;
        $param->{use_plugins}  = $cfg->UsePlugins;

        $lang = $obj->language || 'en';
        $lang = 'en' if lc($lang) eq 'en-us' || lc($lang) eq 'en_us';
        $lang = 'ja' if lc($lang) eq 'jp';
        $param->{ 'language_' . $lang } = 1;

        $param->{system_allow_comments} = $cfg->AllowComments;
        $param->{system_allow_pings}    = $cfg->AllowPings;
        $param->{'auto_approve_commenters'}
            = !$obj->manual_approve_commenters;
        $param->{"moderate_comments"} = $obj->moderate_unreg_comments;
        $param->{ "moderate_comments_"
                . ( $obj->moderate_unreg_comments || 0 ) } = 1;
        $param->{ "moderate_pings_" . ( $obj->moderate_pings || 0 ) } = 1;

        if ( $output eq 'cfg_prefs.tmpl' ) {
            $app->add_breadcrumb( $app->translate('General Settings') );

            $lang = $obj->language || 'en';
            $lang = 'en' if lc($lang) eq 'en-us' || lc($lang) eq 'en_us';
            $lang = 'ja' if lc($lang) eq 'jp';
            $param->{ 'language_' . $lang } = 1;

            if ( $obj->cc_license ) {
                $param->{cc_license_name}
                    = MT::Util::cc_name( $obj->cc_license );
                $param->{cc_license_image_url}
                    = MT::Util::cc_image( $obj->cc_license );
                $param->{cc_license_url}
                    = MT::Util::cc_url( $obj->cc_license );
            }
            if (   $obj->column('archive_path')
                || $obj->column('archive_url') )
            {
                $param->{enable_archive_paths} = 1;
                $param->{archive_url}          = $obj->archive_url;
                my @raw_archive_url = $obj->raw_archive_url;
                if ( 2 == @raw_archive_url ) {
                    my $subdomain = $raw_archive_url[0];
                    $subdomain =~ s/\.$//;
                    $param->{archive_url_subdomain} = $subdomain;
                    $param->{archive_url_path}      = $raw_archive_url[1];
                }
                $param->{archive_path} = $obj->column('archive_path');
                $param->{archive_path_absolute}
                    = $obj->is_archive_path_absolute;
            }
            else {
                $param->{archive_path} = '';
                $param->{archive_url}  = '';
            }
            $param->{'use_revision'} = ( $obj->use_revision || 0 );
            require MT::PublishOption;
            if ($app->model('template')->exist(
                    {   blog_id    => $blog->id,
                        build_type => MT::PublishOption::DYNAMIC()
                    }
                )
                || $app->model('templatemap')->exist(
                    {   blog_id    => $blog->id,
                        build_type => MT::PublishOption::DYNAMIC()
                    }
                )
                )
            {
                $param->{dynamic_enabled} = 1;
                $param->{warning_include} = 1
                    unless $blog->include_system eq 'php'
                    || $blog->include_system eq '';
            }
            eval "require List::Util; require Scalar::Util;";
            unless ($@) {
                $param->{can_use_publish_queue} = 1;
            }
            if ( $blog->publish_queue ) {
                $param->{publish_queue} = 1;
            }
            if ( $blog->include_cache ) {
                $param->{include_cache} = 1;
            }
            $param->{'max_revisions_entry'} = ( $obj->max_revisions_entry
                    || $MT::Revisable::MAX_REVISIONS );
            $param->{'max_revisions_cd'}
                = ( $obj->max_revisions_cd || $MT::Revisable::MAX_REVISIONS );
            $param->{'max_revisions_template'}
                = (    $obj->max_revisions_template
                    || $MT::Revisable::MAX_REVISIONS );
            $param->{publish_empty_archive} = $obj->publish_empty_archive;
        }
        elsif ( $output eq 'cfg_entry.tmpl' ) {
            ## load entry preferences for new/edit entry page of the blog
            my $pref_param = $app->load_entry_prefs( { type => 'entry' } );
            %$param = ( %$param, %$pref_param );
            $pref_param = $app->load_entry_prefs( { type => 'page' } );
            %$param = ( %$param, %$pref_param );
            $param->{ 'sort_order_posts_' . ( $obj->sort_order_posts || 0 ) }
                = 1;
            $param->{ 'status_default_' . $obj->status_default } = 1
                if $obj->status_default;
            $param->{ 'allow_comments_default_'
                    . ( $obj->allow_comments_default || 0 ) } = 1;
            $param->{system_allow_pings}
                = $cfg->AllowPings && $blog->allow_pings;
            $param->{system_allow_comments} = $cfg->AllowComments
                && ( $blog->allow_reg_comments
                || $blog->allow_unreg_comments );
            my $replace_fields = $blog->smart_replace_fields || '';
            my @replace_fields = split( /,/, $replace_fields );

            foreach my $fld (@replace_fields) {
                $param->{ 'nwc_' . $fld } = 1;
            }
            $param->{ 'nwc_smart_replace_' . ( $blog->smart_replace || 0 ) }
                = 1;
            $param->{'nwc_replace_none'} = ( $blog->smart_replace || 0 ) == 2;
            $param->{'max_revisions_entry'} = ( $obj->max_revisions_entry
                    || $MT::Revisable::MAX_REVISIONS );
            $param->{'max_revisions_cd'}
                = ( $obj->max_revisions_cd || $MT::Revisable::MAX_REVISIONS );
            $param->{'max_revisions_template'}
                = (    $obj->max_revisions_template
                    || $MT::Revisable::MAX_REVISIONS );
        }
        elsif ( $output eq 'cfg_web_services.tmpl' ) {
            $param->{system_disabled_notify_pings}
                = $cfg->DisableNotificationPings;
            $param->{system_allow_outbound_pings}
                = $cfg->OutboundTrackbackLimit eq 'any';
            my %selected_pings = map { $_ => 1 }
                split ',', ( $obj->update_pings || '' );
            my $pings = $app->registry('ping_servers');
            my @pings;
            push @pings,
                {
                key   => $_,
                label => $pings->{$_}->{label},
                exists( $selected_pings{$_} ) ? ( selected => 1 ) : (),
                } foreach keys %$pings;
            $param->{pings_loop} = \@pings;
        }
        elsif ( $output eq 'cfg_feedback.tmpl' ) {
            $param->{email_new_comments_1}
                = ( $obj->email_new_comments || 0 ) == 1;
            $param->{email_new_comments_2}
                = ( $obj->email_new_comments || 0 ) == 2;
            $param->{nofollow_urls}     = $obj->nofollow_urls;
            $param->{follow_auth_links} = $obj->follow_auth_links;
            $param->{ 'sort_order_comments_'
                    . ( $obj->sort_order_comments || 0 ) } = 1;
            $param->{global_sanitize_spec} = $cfg->GlobalSanitizeSpec;
            $param->{ 'sanitize_spec_' . ( $obj->sanitize_spec ? 1 : 0 ) }
                = 1;
            $param->{sanitize_spec_manual} = $obj->sanitize_spec
                if $obj->sanitize_spec;
            $param->{allow_comments} = $blog->allow_reg_comments
                || $blog->allow_unreg_comments;
            $param->{use_comment_confirmation}
                = defined $blog->use_comment_confirmation
                ? $blog->use_comment_confirmation
                : 0;
            $param->{system_allow_comments} = $cfg->AllowComments
                && ( $blog->allow_reg_comments
                || $blog->allow_unreg_comments );
            my @cps = MT->captcha_providers;

            foreach my $cp (@cps) {
                if ( ( $blog->captcha_provider || '' ) eq $cp->{key} ) {
                    $cp->{selected} = 1;
                }
            }
            $param->{captcha_loop} = \@cps;

            $param->{email_new_pings_1} = ( $obj->email_new_pings || 0 ) == 1;
            $param->{email_new_pings_2} = ( $obj->email_new_pings || 0 ) == 2;
            $param->{nofollow_urls}     = $obj->nofollow_urls;
            $param->{system_allow_selected_pings}
                = $cfg->OutboundTrackbackLimit eq 'selected';
            $param->{system_allow_outbound_pings}
                = $cfg->OutboundTrackbackLimit eq 'any';
            $param->{system_allow_local_pings}
                = ( $cfg->OutboundTrackbackLimit eq 'local' )
                || ( $cfg->OutboundTrackbackLimit eq 'any' );

            my $threshold = $obj->junk_score_threshold || 0;
            $threshold = '+' . $threshold if $threshold > 0;
            $param->{junk_score_threshold} = $threshold;
            $param->{junk_folder_expiry}   = $obj->junk_folder_expiry || 60;
            $param->{auto_delete_junk}     = $obj->junk_folder_expiry;
        }
        elsif ( $output eq 'cfg_registration.tmpl' ) {
            $param->{commenter_authenticators}
                = $obj->commenter_authenticators;
            my $registration = $cfg->CommenterRegistration;
            if ( $registration->{Allow} ) {
                $param->{registration}
                    = $blog->allow_commenter_regist ? 1 : 0;
            }
            else {
                $param->{system_disallow_registration} = 1;
            }
            $param->{allow_reg_comments}   = $blog->allow_reg_comments;
            $param->{allow_unreg_comments} = $blog->allow_unreg_comments;
        }
        elsif ( $output eq 'cfg_plugin.tmpl' ) {
            $app->add_breadcrumb( $app->translate('Plugin Settings') );
            $param->{blog_view} = 1;
            require MT::CMS::Plugin;
            MT::CMS::Plugin::build_plugin_table(
                $app,
                param => $param,
                scope => 'blog:' . $blog_id
            );
            $param->{can_config} = 1;
        }
        else {
            $app->add_breadcrumb( $app->translate('Settings') );
        }

        ( my $offset = $obj->server_offset ) =~ s![-\.]!_!g;
        $offset =~ s!_0+$!!;    # fix syntax highlight ->!
        $param->{ 'server_offset_' . $offset } = 1;
        if ( $output eq 'cfg_feedback.tmpl' ) {
            ## Load text filters.
            $param->{text_filters_comments}
                = $app->load_text_filters( $obj->convert_paras_comments,
                'comment' );
        }
        elsif ( $output eq 'cfg_entry.tmpl' ) {
            ## Load text filters.
            $param->{text_filters}
                = $app->load_text_filters( $obj->convert_paras, 'entry' );
        }
        $param->{nav_config} = 1;
        $param->{error} = $app->errstr if $app->errstr;
    }
    else {
        $app->add_breadcrumb(
            $app->translate('Sites'),
            $app->uri(
                mode => 'list',
                args => {
                    _type   => 'website',
                    blog_id => 0,
                },
            ),
        );
        $app->add_breadcrumb( $app->translate('Create Site') );

        my $tz;
        if ( defined( $param->{server_offset} ) ) {
            ( $tz = $param->{server_offset} ) =~ s![-\.]!_!g;
        }
        else {
            ( $tz = $cfg->DefaultTimezone ) =~ s![-\.]!_!g;
        }
        $tz =~ s!_00$!!;    # fix syntax highlight ->!
        $param->{ 'server_offset_' . $tz } = 1;
        $param->{'can_edit_config'} = $app->can_do('edit_new_blog_config');
        $param->{'can_set_publish_paths'}
            = $app->can_do('set_new_blog_publish_paths');
        $lang = $param->{'blog_language'};
    }

    $param->{languages} = MT::I18N::languages_list( $app,
        $id ? $obj->language : $lang || MT->config->DefaultLanguage );

    if ( !$param->{id} ) {
        if ( !$param->{site_path} ) {
            my $cwd
                = $cfg->BaseSitePath
                ? $cfg->BaseSitePath
                : $app->document_root;
            $cwd =~ s!([\\/])cgi(?:-bin)?([\\/].*)?$!$1!;
            $cwd =~ s!([\\/])mt[\\/]?$!$1!i;
            $param->{site_path} = $param->{suggested_site_path} = $cwd;
        }
        else {
            my $cwd = $param->{site_path};
            $param->{site_path} = $cwd;
        }
    }

    if ( !$param->{id} ) {
        if ( !$param->{site_url} ) {
            $param->{suggested_site_url} = $app->base . '/';
            $param->{suggested_site_url} =~ s!/cgi(?:-bin)?(/.*)?$!/!;
            $param->{suggested_site_url} =~ s!/mt/?$!/!i;
            $param->{site_url} = $param->{suggested_site_url};
        }
        else {
            $param->{site_url} .= '/'
                unless $param->{site_url} =~ /\/$/;
        }
        $param->{screen_class} = "settings-screen";
    }
    $param->{is_website} = 1;

    if ($blog) {
        $param->{website_path}
            = File::Spec->catfile( $blog->column('site_path'), '' )
            if $blog->column('site_path');
        $param->{website_url} = $blog->site_url;
    }
    if ( exists $param->{website_path} ) {
        my $sep = MT::Util::dir_separator;
        $param->{website_path} = $param->{website_path} . $sep
            if $param->{website_path} !~ m/$sep$/;
    }
    if ( exists $param->{website_url} ) {
        my $website_url = $param->{website_url};
        if (my ($scheme, $domain) = $website_url =~ m!^(\w+)://(.+)$!) {
            $domain .= '/' if $domain !~ m!/$!;
            $param->{website_scheme} = $scheme;
            $param->{website_domain} = $domain;
        }
    }

    1;
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;

    if ( !$obj->id ) {
        my $site_path = $obj->site_path;
        my $fmgr      = $obj->file_mgr;
        if ($site_path) {
            unless ( $fmgr->exists($site_path) ) {
                my @dirs = File::Spec->splitdir($site_path);
                pop @dirs;
                $site_path = File::Spec->catdir(@dirs);
            }
        }
        return $app->errtrans(
            "The '[_1]' provided below is not writable by the web server. Change the directory ownership or permissions and try again.",
            $app->translate('Website Root')
            )
            unless $site_path
            && $fmgr->exists($site_path)
            && $fmgr->can_write($site_path);
    }

    return 1;
}

sub post_save {
    MT::CMS::Blog::post_save(@_);
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {   message => $app->translate(
                "Website '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->name, $obj->id, $app->user->name
            ),
            level    => MT::Log::NOTICE(),
            class    => 'website',
            category => 'delete'
        }
    );
    require MT::CMS::User;
    MT::CMS::User::_delete_pseudo_association( $app, undef, $obj->id );
}

sub can_view {
    my ( $eh, $app, $id ) = @_;
    if ($id) {
        return $app->can_do('open_blog_config_screen');
    }
    else {
        return $app->can_do('open_new_website_screen');
    }
}

sub can_view_website_list {
    my $app  = shift;
    my $blog = $app->blog;

    return 0 if $blog;

    return 1 if $app->user->is_superuser;
    return 1 if $app->user->permissions(0)->can_do('edit_templates');
    return 1 if $app->user->permissions(0)->can_do('access_to_website_list');

    my $blog_ids
        = !$blog         ? undef
        : $blog->is_blog ? [ $blog->id ]
        : $blog->has_blog ? [ map { $_->id } @{ $blog->blogs } ]
        :                   undef;

    require MT::Permission;
    my $cnt = MT::Permission->count(
        {   author_id   => $app->user->id,
            blog_id     => { not => 0 },
            permissions => { not => 'comment' },
        }
    );

    return $cnt > 0 ? 1 : 0;
}

sub can_save {
    my ( $eh, $app, $id ) = @_;

    if ($id) {
        unless ( ref $id ) {
            $id = MT->model('blog')->load($id)
                or return;
        }

        my $author = $app->user;
        return $author->permissions( $id->id )->can_do('edit_blog_config')
            || ( $app->isa('MT::App::CMS')
            && $app->param('cfg_screen')
            && $app->param('cfg_screen') eq 'cfg_publish_profile' );
    }
    else {
        return $app->can_do('create_new_website');
    }
}

sub can_delete {
    my ( $eh, $app, $id ) = @_;
    return 1 if $app->user->is_superuser;
    return 0 unless $id;

    unless ( ref $id ) {
        $id = MT->model('website')->load($id)
            or return;
    }

    return unless $id->isa('MT::Website');

    my $author = $app->user;
    return $author->permissions( $id->id )->can_do('delete_website');

}

sub dialog_select_website {
    my $app  = shift;
    my $user = $app->user;

    my $favorites = $app->param('select_favorites');
    my $save_favorite;
    my $terms = {};
    my $args  = {};
    if ($favorites) {

        # Do not exclude top 5 favorite websites from
        #   select website dialog list. bugid:112372
        $save_favorite = 1;
    }
    if (   !$user->is_superuser
        && !$user->permissions(0)->can_do('edit_templates') )
    {
        use MT::Permission;
        $args->{join} = MT::Permission->join_on( 'blog_id',
            { author_id => $user->id } );
    }
    $terms->{class} = 'website';

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        $row->{label} = $row->{name};
        $row->{'link'} = $row->{site_url};
    };

    $app->listing(
        {   type     => 'website',
            code     => $hasher,
            template => $app->param('json') ? 'include/listing_panel.tmpl'
            : 'dialog/select_weblog.tmpl',
            terms  => $terms,
            args   => $args,
            params => {
                dialog_title  => $app->translate("Select Site"),
                items_prompt  => $app->translate("Selected Site"),
                search_prompt => $app->translate(
                    "Type a website name to filter the choices below."),
                panel_label       => $app->translate("Site Name"),
                panel_description => $app->translate("Description"),
                panel_type        => 'blog',
                panel_multi       => defined $app->param('multi')
                ? scalar( $app->param('multi') )
                : 0,
                panel_searchable => 1,
                panel_first      => 1,
                panel_last       => 1,
                list_noncron     => 1,
                return_url       => $app->base
                    . $app->uri . '?'
                    . '__mode=dashboard',
                save_favorite => $save_favorite,
                idfield     => ( $app->param('idfield') || '' ),
                namefield   => ( $app->param('namefield') || '' ),
                search_type => "website",
            },
        }
    );
}

sub dialog_move_blogs {
    my $app = shift;

    $app->validate_param({
        blog_id     => [qw/ID/],
        id          => [qw/ID MULTI/],
        json        => [qw/MAYBE_STRING/],
        return_args => [qw/MAYBE_STRING/],
    }) or return;

    $app->{hide_goback_button} = 1;

    my $blog_id = $app->param('blog_id');

    my $terms = {};
    my $args  = {};
    $terms->{id} = { not => $blog_id } if $blog_id;
    $terms->{class} = 'website';

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        $row->{label} = $row->{name};
        $row->{'link'} = $row->{site_url};
    };

    my @id = $app->multi_param('id');
    if ( MT->model('website')->exist( { id => \@id, class => 'website' } ) ) {
        return $app->error(
            $app->translate('This action cannot move a top-level site.') );
    }

    my $ids = join ',', @id;
    $app->listing(
        {   type     => 'website',
            code     => $hasher,
            template => $app->param('json')
            ? 'include/listing_panel.tmpl'
            : 'dialog/move_blogs.tmpl',
            terms  => $terms,
            args   => $args,
            params => {
                dialog_title  => $app->translate("Select Site"),
                items_prompt  => $app->translate("Selected Site"),
                search_prompt => $app->translate(
                    "Type a site name to filter the choices below."),
                panel_label       => $app->translate("Site Name"),
                panel_description => $app->translate("Description"),
                panel_type        => 'blog',
                panel_multi       => 0,
                panel_searchable  => 1,
                panel_first       => 1,
                panel_last        => 1,
                list_noncron      => 1,
                return_url        => ( $app->param('return_args') || '' ),
                blog_ids          => $ids,
            },
        }
    );
}

sub move_blogs {
    my $app = shift;
    return unless $app->validate_magic;
    return $app->error( $app->translate('Permission denied.') )
        unless $app->can_do('move_blogs');

    $app->validate_param({
        blog_ids => [qw/IDS/],
        ids      => [qw/ID/],
    }) or return;

    my $website_class = $app->model('website');
    my $ids           = $app->param('ids');
    my $website       = $website_class->load($ids)
        or return $app->error(
        $app->translate( 'Cannot load website #[_1].', $ids ) );

    my $blog_class = $app->model('blog');
    my $blog_ids   = $app->param('blog_ids');
    my @id         = split ',', $blog_ids;
    foreach my $id (@id) {
        my $blog = $blog_class->load($id)
            or return $app->error(
            $app->translate( 'Cannot load blog #[_1].', $id ) );
        my $old_website = $blog->website;

        $website->add_blog($blog);
        $blog->save
            or return $app->error( $blog->errstr );

        $app->run_callbacks( 'post_move_blog',
            { website => $old_website, blog => $blog } );

        $app->log(
            {   message => $app->translate(
                    "Blog '[_1]' (ID:[_2]) moved from '[_3]' to '[_4]' by '[_5]'",
                    $blog->name,    $blog->id, $old_website->name,
                    $website->name, $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'blog',
                category => 'move'
            }
        );
    }

    $app->add_return_arg( moved => 1 );
    $app->call_return;
}

sub build_website_table {
    my $app = shift;
    my (%args) = @_;

    my $website_class = $app->model('website');
    my $blog_class    = $app->model('blog');
    my $entry_class   = $app->model('entry');
    my $page_class    = $app->model('page');

    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('website');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
    }
    return [] unless $iter;
    my $param = $args{param};

    my $author           = $app->user;
    my $can_edit_authors = $app->can_do('edit_authors');
    my @data;
    while ( my $blog = $iter->() ) {
        my $blog_id = $blog->id;
        my $row     = {
            id          => $blog->id,
            name        => $blog->name,
            description => $blog->description,
            site_url    => $blog->site_url
        };

        if ( $app->mode ne 'dialog_select_website' ) {
            $row->{num_blogs}
                = $blog_class->count( { parent_id => $blog_id } ) || 0;

            # we should use count by group here...
            $row->{num_entries}
                = $entry_class->count( { blog_id => $blog_id } ) || 0;
            $row->{num_pages}
                = $page_class->count( { blog_id => $blog_id } ) || 0;
            $row->{num_authors} = 0;
            if ( $author->is_superuser ) {
                $row->{can_edit_entries}      = 1;
                $row->{can_edit_pages}        = 1;
                $row->{can_edit_templates}    = 1;
                $row->{can_edit_config}       = 1;
                $row->{can_set_publish_paths} = 1;
                $row->{can_list_blogs}        = 1;
            }
            else {
                my $perms = $author->permissions($blog_id);
                $row->{can_edit_entries}   = $perms->can_do('create_post');
                $row->{can_edit_pages}     = $perms->can_do('manage_pages');
                $row->{can_edit_templates} = $perms->can_do('edit_templates');
                $row->{can_edit_config}    = $perms->can_do('edit_config');
                $row->{can_set_publish_paths}
                    = $perms->can_do('set_publish_paths');
                $row->{can_list_blogs}
                    = $perms->can_do('open_blog_listing_screen');
            }
        }
        $row->{object} = $blog;
        push @data, $row;
    }

    if (@data) {
        $param->{blog_table}[0]{object_loop} = \@data;
        $app->load_list_actions( 'website', \%$param );
        $param->{object_loop} = $param->{blog_table}[0]{object_loop};
    }

    \@data;
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $terms = $load_options->{terms};
    delete $terms->{blog_id};
    $terms->{class} = '*';

    my $user = $app->user;
    return if $user->is_superuser;

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        [   { author_id => $user->id, },
            '-and',
            [   {   blog_id     => 0,
                    permissions => { like => '%edit_templates%' },
                },
                '-or',
                {   blog_id     => { not => 0 },
                    permissions => { not => 'comment' },
                }
            ]
        ],
    );

    my $blog_ids;
    while ( my $perm = $iter->() ) {
        if ( !$perm->blog_id ) {

            # User has system.edit_template
            $blog_ids = undef;
            last;
        }
        my $website = MT->model('website')->load( $perm->blog_id );
        if ( $website && $website->class eq 'website' ) {
            push @$blog_ids, $perm->blog_id;
        }
        elsif ( $website && $website->class eq 'blog' ) {
            push @$blog_ids, $website->parent_id if $website->parent_id;
        }
    }

    $terms->{id} = $blog_ids
        if $blog_ids;
    $load_options->{terms} = $terms;
}

1;
