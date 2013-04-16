# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::CMS::Blog;

use strict;
use MT::Util qw( dirify dir_separator );

sub edit {
    my $cb = shift;
    my ( $app, $id, $obj, $param ) = @_;

    my $q       = $app->param;
    my $cfg     = $app->config;
    my $blog    = $app->blog;
    my $blog_id = $id;

    if ($id) {
        my $output = $param->{output} ||= 'cfg_prefs.tmpl';
        $param->{need_full_rebuild} = 1 if $q->param('need_full_rebuild');
        $param->{show_ip_info}      = $cfg->ShowIPInformation;
        $param->{use_plugins}       = $cfg->UsePlugins;

        my $entries_on_index = ( $obj->entries_on_index || 0 );
        if ($entries_on_index) {
            $param->{'list_on_index'} = $entries_on_index;
            $param->{'posts'}         = 1;
        }
        else {
            $param->{'list_on_index'} = ( $obj->days_on_index || 0 );
            $param->{'days'} = 1;
        }
        my $lang = $obj->language || 'en';
        $lang = 'en' if lc($lang) eq 'en-us' || lc($lang) eq 'en_us';
        $lang = 'ja' if lc($lang) eq 'jp';
        $param->{ 'language_' . $lang } = 1;

        my $date_lang = $obj->date_language || 'en';
        $date_lang = 'en'
            if lc($date_lang) eq 'en-us' || lc($date_lang) eq 'en_us';
        $date_lang = 'ja' if lc($date_lang) eq 'jp';
        $param->{ 'date_language_' . $date_lang } = 1;

        $param->{system_allow_comments} = $cfg->AllowComments;
        $param->{system_allow_pings}    = $cfg->AllowPings;
        $param->{tk_available}          = eval { require MIME::Base64; 1; }
            && eval { require LWP::UserAgent; 1 };
        $param->{'auto_approve_commenters'}
            = !$obj->manual_approve_commenters;
        $param->{identity_system}     = $app->config('IdentitySystem');
        $param->{handshake_return}    = $app->base . $app->mt_uri;
        $param->{"moderate_comments"} = $obj->moderate_unreg_comments;
        $param->{ "moderate_comments_"
                . ( $obj->moderate_unreg_comments || 0 ) } = 1;
        $param->{ "moderate_pings_" . ( $obj->moderate_pings || 0 ) } = 1;

        my $cmtauth_reg = $app->registry('commenter_authenticators');
        my %cmtauth;
        foreach my $auth ( keys %$cmtauth_reg ) {
            my %auth = %{ $cmtauth_reg->{$auth} };
            $cmtauth{$auth} = \%auth;
            if ( my $c = $cmtauth_reg->{$auth}->{condition} ) {
                $c = $app->handler_to_coderef($c);
                if ($c) {
                    my $reason;
                    $cmtauth{$auth}->{disabled} = 1
                        unless $c->( $blog, \$reason );
                    $cmtauth{$auth}->{disabled_reason} = $reason if $reason;
                    delete $cmtauth{TypeKey}
                        if $auth eq 'TypeKey' && $cmtauth{TypeKey}{disabled};
                }
            }
        }
        if ( my $auths = $blog->commenter_authenticators ) {
            foreach ( split ',', $auths ) {
                if ( 'MovableType' eq $_ ) {
                    $param->{enabled_MovableType} = 1;
                }
                else {
                    $cmtauth{$_}->{enabled} = 1;
                }
            }
        }
        my @cmtauth_loop;
        foreach ( keys %cmtauth ) {
            $cmtauth{$_}->{key} = $_;
            if ( UNIVERSAL::isa( $cmtauth{$_}->{plugin}, 'MT::Plugin' ) ) {

                # force plugin auth schemes to show after native auth schemes
                $cmtauth{$_}{order} = ( $cmtauth{$_}{order} || 0 ) + 100;
            }
            push @cmtauth_loop, $cmtauth{$_};
        }
        @cmtauth_loop = sort { $a->{order} <=> $b->{order} } @cmtauth_loop;

        $param->{cmtauth_loop} = \@cmtauth_loop;

        if ( $output eq 'cfg_prefs.tmpl' ) {
            $app->add_breadcrumb( $app->translate('General Settings') );

            my $lang = $obj->language || 'en';
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
            $param->{ 'archive_type_preferred_'
                    . $blog->archive_type_preferred } = 1
                if $blog->archive_type_preferred;
            my $at = $blog->archive_type;
            if ( $at && $at ne 'None' ) {
                my @at = split /,/, $at;
                for my $at (@at) {
                    $param->{ 'archive_type_' . $at } = 1;
                }
            }
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
                    unless defined $blog->include_system
                    && ( $blog->include_system eq 'php'
                    || $blog->include_system eq '' );
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
            $param->{'master_revision_switch'} = $app->config->TrackRevisions;
            $param->{'use_revision'}           = ( $obj->use_revision || 0 );
            $param->{'max_revisions_entry'}    = ( $obj->max_revisions_entry
                    || $MT::Revisable::MAX_REVISIONS );
            $param->{'max_revisions_template'}
                = (    $obj->max_revisions_template
                    || $MT::Revisable::MAX_REVISIONS );
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
            $threshold = $threshold + 0;
            $threshold = '+' . $threshold if $threshold > 0;
            $param->{junk_score_threshold} = $threshold;
            $param->{junk_folder_expiry}   = $obj->junk_folder_expiry || 60;
            $param->{auto_delete_junk}     = $obj->junk_folder_expiry;
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
        return $app->return_to_dashboard( redirect => 1 )
            if !$blog || ( $blog && $blog->is_blog() );

        $app->add_breadcrumb( $app->translate('New Blog') );
        ( my $tz = $cfg->DefaultTimezone ) =~ s![-\.]!_!g;
        $tz =~ s!_00$!!;    # fix syntax highlight ->!
        $param->{ 'server_offset_' . $tz } = 1;
        $param->{'can_edit_config'} = $app->can_do('edit_new_blog_config');
        $param->{'can_set_publish_paths'}
            = $app->can_do('set_new_blog_publish_paths');
    }

    $param->{languages} = MT::I18N::languages_list( $app,
        $id ? $obj->language : MT->config->DefaultLanguage );

    if ( !$param->{site_path} ) {
        $param->{suggested_site_path} = 'BLOG-NAME';
    }

    if ( !$param->{site_url} ) {
        $param->{suggested_site_url} = 'BLOG-NAME';
    }
    if ( !$param->{id} ) {
        if ( $param->{site_url} ) {
            $param->{site_url} .= '/'
                unless $param->{site_url} =~ /\/$/;
        }
        else {
            $param->{suggested_site_url} .= '/'
                unless $param->{suggested_site_url} =~ /\/$/;
        }
        $param->{screen_class} = "settings-screen";
    }
    else {
        my @raw_site_url = $obj->raw_site_url;
        if ( 2 == @raw_site_url ) {
            my $subdomain = $raw_site_url[0];
            $subdomain =~ s/\.$//;
            $param->{site_url}           = $obj->site_url;
            $param->{site_url_subdomain} = $subdomain;
            $param->{site_url_path}      = $raw_site_url[1];
        }
        else {
            $param->{site_url} = $raw_site_url[0];
        }
        $param->{site_path}          = $obj->column('site_path');
        $param->{site_path_absolute} = $obj->is_site_path_absolute;
    }

    if ( !$blog->is_blog() ) {
        $param->{website_path}
            = File::Spec->catfile( $blog->column('site_path'), '' )
            if $blog->column('site_path');
        $param->{website_url} = $blog->column('site_url');
    }
    elsif ( my $website = $blog->website() ) {
        $param->{website_path}
            = File::Spec->catfile( $website->column('site_path'), '' )
            if $website->column('site_path');
        $param->{website_url} = $website->site_url;
    }
    if ( exists $param->{website_path} ) {
        my $sep = MT::Util::dir_separator;
        $param->{website_path} = $param->{website_path} . $sep
            if $param->{website_path} !~ m/$sep$/;
    }
    if ( exists $param->{website_url} ) {
        my $website_url = $param->{website_url};
        my ( $scheme, $domain ) = $website_url =~ m!^(\w+)://(.+)$!;
        $domain .= '/' if $domain !~ m!/$!;
        $param->{website_scheme} = $scheme;
        $param->{website_domain} = $domain;
    }

    1;
}

sub cfg_prefs {
    my $app = shift;
    my %param;
    %param = %{ $_[0] } if $_[0];
    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 ) unless $blog_id;

    my $blog_prefs = $app->user_blog_prefs;
    my $perms      = $app->permissions;
    return $app->permission_denied()
        unless $app->can_do('access_to_blog_config_screen');

    my $blog = $app->model('blog')->load($blog_id)
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $blog_id ) );

    if ( $blog->is_blog() ) {
        my @data;
        for my $at ( split /\s*,\s*/, $blog->archive_type ) {
            my $archiver = $app->publisher->archiver($at);
            next unless $archiver;
            next if 'entry' ne $archiver->entry_class;
            my $archive_label = $archiver->archive_label;
            $archive_label = $at unless $archive_label;
            $archive_label = $archive_label->()
                if ( ref $archive_label ) eq 'CODE';
            push @data,
                {
                archive_type_translated => $archive_label,
                archive_type            => $at,
                archive_type_is_preferred =>
                    ( $blog->archive_type_preferred eq $at ? 1 : 0 ),
                };
        }
        @data = sort { MT::App::CMS::archive_type_sorter( $a, $b ) } @data;
        unless ( grep $_->{archive_type_is_preferred}, @data ) {
            $param{no_preferred_archive_type} = 1;
        }
        $param{entry_archive_types} = \@data;
    }

    $param{saved_deleted}    = 1 if $q->param('saved_deleted');
    $param{saved_added}      = 1 if $q->param('saved_added');
    $param{archives_changed} = 1 if $q->param('archives_changed');
    $param{no_writedir}    = $q->param('no_writedir');
    $param{no_cachedir}    = $q->param('no_cachedir');
    $param{no_writecache}  = $q->param('no_writecache');
    $param{include_system} = $blog->include_system || '';

    my $mtview_path = File::Spec->catfile( $blog->site_path(), "mtview.php" );

    if ( -f $mtview_path ) {
        open my ($fh), $mtview_path;
        while ( my $line = <$fh> ) {
            $param{dynamic_caching} = 1
                if $line =~ m/^\s*\$mt->caching\(true\);/i;
            $param{dynamic_conditional} = 1
                if $line =~ /^\s*\$mt->conditional\(true\);/i;
        }
        close $fh;
    }
    $param{output} = 'cfg_prefs.tmpl';
    $q->param( '_type', $blog->class );
    $q->param( 'id',    $blog_id );
    $param{screen_class} = 'settings-screen general-screen';
    $param{object_type}  = 'author';
    $param{search_label} = $app->translate('Users');

    my @raw_site_url = $blog->raw_site_url;
    if ( 2 == @raw_site_url ) {
        $param{site_url}           = $blog->site_url;
        $param{site_url_subdomain} = $raw_site_url[0];
        $param{site_url_path}      = $raw_site_url[1];
    }
    else {
        $param{site_url} = $raw_site_url[0];
    }
    $param{site_path}          = $blog->column('site_path');
    $param{site_path_absolute} = $blog->is_site_path_absolute;

    $app->forward( "view", \%param );
}

sub cfg_feedback {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog_id;
    return $app->permission_denied()
        unless $app->can_do('edit_config');
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    $app->forward(
        "view",
        {   output       => 'cfg_feedback.tmpl',
            screen_class => 'settings-screen'
        }
    );
}

sub cfg_registration {
    my $app  = shift;
    my $blog = $app->blog;
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog;
    return $app->permission_denied()
        unless $app->can_do('edit_config');

    eval { require Digest::SHA1; };
    my $openid_available = $@ ? 0 : 1;

    my %param = ();
    $param{id}                       = $blog->id;
    $param{openid_enabled}           = $openid_available;
    $param{screen_class}             = 'settings-screen registration-screen';
    $param{commenter_authenticators} = $blog->commenter_authenticators;
    my $registration = $app->config->CommenterRegistration;
    if ( $registration->{Allow} ) {
        $param{registration} = $blog->allow_commenter_regist ? 1 : 0;
    }
    else {
        $param{system_disallow_registration} = 1;
    }
    $param{allow_reg_comments}     = $blog->allow_reg_comments;
    $param{allow_unreg_comments}   = $blog->allow_unreg_comments;
    $param{require_typekey_emails} = $blog->require_typekey_emails;
    $param{require_comment_emails} = $blog->require_comment_emails;
    $param{allow_commenter_regist} = $blog->allow_commenter_regist;

    my $cmtauth_reg = $app->registry('commenter_authenticators');
    my %cmtauth;
    foreach my $auth ( keys %$cmtauth_reg ) {
        my %auth = %{ $cmtauth_reg->{$auth} };
        $cmtauth{$auth} = \%auth;
        if ( my $c = $cmtauth_reg->{$auth}->{condition} ) {
            delete $cmtauth{$auth}, next
                if $cmtauth_reg->{$auth}->{disable};

            $c = $app->handler_to_coderef($c);
            if ($c) {
                my $reason;
                $cmtauth{$auth}->{disabled} = 1
                    unless $c->( $blog, \$reason );
                $cmtauth{$auth}->{disabled_reason} = $reason if $reason;
                delete $cmtauth{TypeKey}
                    if $auth eq 'TypeKey' && $cmtauth{TypeKey}{disabled};
            }
        }
    }
    if ( my $auths = $blog->commenter_authenticators ) {
        foreach ( split ',', $auths ) {
            if ( 'MovableType' eq $_ ) {
                $param{enabled_MovableType} = 1;
            }
            elsif ( exists $cmtauth{$_} ) {
                $cmtauth{$_}->{enabled} = 1;
            }
        }
    }
    my @cmtauth_loop;
    foreach ( keys %cmtauth ) {
        $cmtauth{$_}->{key} = $_;
        if ( UNIVERSAL::isa( $cmtauth{$_}->{plugin}, 'MT::Plugin' ) ) {

            # force plugin auth schemes to show after native auth schemes
            $cmtauth{$_}{order} = ( $cmtauth{$_}{order} || 0 ) + 100;
        }
        push @cmtauth_loop, $cmtauth{$_};
    }
    @cmtauth_loop = sort { $a->{order} <=> $b->{order} } @cmtauth_loop;

    $param{cmtauth_loop} = \@cmtauth_loop;
    $param{saved}        = $app->param('saved');

    my @def = split ',', $app->config('DefaultAssignments');
    my @roles;
    my @role_ids;
    while ( my $r_id = shift @def ) {
        my $b_id = shift @def;
        next unless $b_id eq $blog->id;
        my $role = $app->model('role')->load($r_id)
            or next;
        push @roles, { role_id => $r_id, role_name => $role->name };
        push @role_ids, $r_id;
    }
    $param{new_roles} = \@roles;
    $param{new_created_user_role} = join( ',', @role_ids );

    $app->load_tmpl( 'cfg_registration.tmpl', \%param );
}

sub cfg_web_services {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog_id;
    return $app->permission_denied()
        unless $app->can_do('edit_config');
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    $app->forward(
        "view",
        {   output       => 'cfg_web_services.tmpl',
            screen_class => 'settings-screen web-services-settings'
        }
    );
}

sub rebuild_phase {
    my $app  = shift;
    my $type = $app->param('_type') || 'entry';
    my @ids  = $app->param('id');
    $app->{goback} = $app->return_uri;
    $app->{value} ||= $app->translate('Back');
    if ( $type eq 'entry' ) {
        my %ids = map { $_ => 1 } @ids;
        return $app->rebuild_these( \%ids );
    }
    elsif ( $type eq 'template' ) {
        require MT::Template;
        foreach (@ids) {
            my $template = MT::Template->load($_)
                or return $app->errtrans( 'Cannot load template #[_1].', $_ );

            my $perms = $app->user->permissions( $template->blog_id );
            return $app->permission_denied()
                unless $perms && $perms->can_do('rebuild');

            $app->rebuild_indexes(
                Template => $template,
                Force    => 1
            ) or return;
        }
    }
    $app->run_callbacks('post_build');
    $app->call_return;
}

sub rebuild_pages {
    my $app   = shift;
    my $perms = $app->permissions
        or return $app->error( $app->translate("No permissions") );
    require MT::Entry;
    require MT::Blog;
    my $q          = $app->param;
    my $start_time = $q->param('start_time');

    if ( !$start_time ) {

        # start of build; invoke callback
        $app->run_callbacks('pre_build');
        $start_time = time;
    }

    my $blog_id = int( $q->param('blog_id') );
    return $app->errtrans("Invalid request.") unless $blog_id;

    my $blog = MT::Blog->load($blog_id)
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $blog_id ) );
    my $order = $q->param('type');
    my @order = split /,/, $order;
    my $next  = $q->param('next');
    my $done  = 0;
    my $type  = $order[$next];

    my $pub = $app->publisher;
    $pub->start_time($start_time)
        if $start_time;    # force start time to parameter start_time

    my $archiver = $pub->archiver($type);
    my $archive_label = $archiver ? $archiver->archive_label : '';

    $archive_label = $app->translate($type) unless $archive_label;
    $archive_label = $archive_label->() if ( ref $archive_label ) eq 'CODE';
    $next++;
    $done++ if $next >= @order;
    my $offset = 0;
    my ($total) = $q->param('total');

    my $with_indexes = $q->param('with_indexes');
    my $no_static    = $q->param('no_static');
    my $template_id  = $q->param('template_id');
    my $map_id       = $q->param('templatemap_id');

    my ($tmpl_saved);

    # Make sure errors go to a sensible place when in fs mode
    # TODO: create contin. earlier, pass it thru
    if ( $app->param('fs') ) {
        my ( $type, $obj_id ) = $app->param('type') =~ m/(entry|index)-(\d+)/;
        if ( $type && $obj_id ) {
            my $edit_type = $type;
            $edit_type = 'template' if $type eq 'index';
            if ( $type eq 'entry' ) {
                require MT::Entry;
                my $entry = MT::Entry->load($obj_id);
                $edit_type = $entry ? $entry->class : 'entry';
            }
            $app->{goback} = $app->object_edit_uri( $edit_type, $obj_id );
            $app->{value} ||= $app->translate('Back');
        }
    }

    if ( $type eq 'all' ) {
        return $app->permission_denied()
            unless $perms->can_do('rebuild');

        # FIXME: Rebuild the entire blog????
        $app->rebuild( BlogID => $blog_id )
            or return $app->publish_error();
    }
    elsif ( $type eq 'index' ) {
        return $app->permission_denied()
            unless $perms->can_do('rebuild');
        $app->rebuild_indexes( BlogID => $blog_id )
            or return $app->publish_error();
    }
    elsif ( $type =~ /^index-(\d+)$/ ) {
        return $app->permission_denied()
            unless $perms->can_do('rebuild');
        my $tmpl_id = $1;
        require MT::Template;
        $tmpl_saved = MT::Template->load($tmpl_id)
            or
            return $app->errtrans( 'Cannot load template #[_1].', $tmpl_id );
        return $app->permission_denied()
            unless $app->user->permissions( $tmpl_saved->blog_id )
                ->can_do('rebuild');

        $app->rebuild_indexes(
            BlogID   => $blog_id,
            Template => $tmpl_saved,
            Force    => 1
        ) or return $app->publish_error();
        $order = "index template '" . $tmpl_saved->name . "'";
    }
    elsif ( $type =~ /^entry-(\d+)$/ ) {
        my $entry_id = $1;
        require MT::Entry;
        my $entry = MT::Entry->load($entry_id);
        return $app->permission_denied()
            if !$perms->can_edit_entry( $entry, $app->user )
                && !$perms->can_republish_entry( $entry, $app->user );
        $app->rebuild_entry(
            Entry             => $entry,
            BuildDependencies => 1,
            OldCategories     => $q->param('old_categories'),
            OldPrevious       => $q->param('old_previous'),
            OldNext           => $q->param('old_next')
        ) or return $app->publish_error();
        $order = "entry '" . $entry->title . "'";
    }
    elsif ( $archiver && $archiver->category_based ) {
        return $app->permission_denied()
            unless $perms->can_do('rebuild');
        if ($template_id) {
            my $tmpl = MT->model('template')->load($template_id)
                or return $app->errtrans( 'Cannot load template #[_1].',
                $template_id );
            return $app->permission_denied()
                unless $app->user->permissions( $tmpl->blog_id )
                    ->can_do('rebuild');
        }
        elsif ($map_id) {
            my $map = MT->model('templatemap')->load($map_id)
                or return $app->errtrans( 'Cannot load template #[_1].',
                $map_id );
            return $app->permission_denied()
                unless $app->user->permissions( $map->blog_id )
                    ->can_do('rebuild');
        }

        $offset = $q->param('offset') || 0;
        my $start = time;
        my $count = 0;
        my $cb    = sub {
            my $result = time - $start > 20 ? 0 : 1;
            $count++ if $result;
            return $result;
        };
        if ( $offset < $total ) {
            $app->rebuild(
                BlogID         => $blog_id,
                ArchiveType    => $type,
                NoIndexes      => 1,
                Offset         => $offset,
                Limit          => $app->config->EntriesPerRebuild,
                FilterCallback => $cb,
                ( $template_id || $map_id ? ( Force => 1 ) : () ),
            ) or return $app->publish_error();
            $offset += $count;
        }
        if ( $offset < $total ) {
            $done-- if $done;
            $next--;
        }
        else {
            $offset = 0;
        }
    }
    elsif ($type) {
        my $special = 0;
        my @options;
        my $opts = $app->registry("rebuild_options") || {};
        if ($opts) {
            foreach my $opt ( keys %$opts ) {
                $opts->{$opt}{key} ||= $opt;
                push @options, $opts->{$opt};
            }
        }
        $app->run_callbacks( 'rebuild_options', $app, \@options );
        for my $optn (@options) {
            if ( ( $optn->{key} || '' ) eq $type ) {
                my $code = $optn->{code};
                unless ( ref($code) eq 'CODE' ) {
                    $code = MT->handler_to_coderef($code);
                    $optn->{code} = $code;
                }
                $optn->{code}->();
                $special = 1;
            }
        }
        if ( !$special ) {
            return $app->permission_denied()
                unless $perms->can_do('rebuild');
            if ($template_id) {
                my $tmpl = MT->model('template')->load($template_id)
                    or return $app->errtrans( 'Cannot load template #[_1].',
                    $template_id );
                return $app->permission_denied()
                    unless $app->user->permissions( $tmpl->blog_id )
                        ->can_do('rebuild');
            }
            elsif ($map_id) {
                my $map = MT->model('templatemap')->load($map_id)
                    or return $app->errtrans( 'Cannot load template #[_1].',
                    $map_id );
                return $app->permission_denied()
                    unless $app->user->permissions( $map->blog_id )
                        ->can_do('rebuild');
            }

            $offset = $q->param('offset') || 0;
            if ( $offset < $total ) {
                my $start = time;
                my $count = 0;
                my $cb    = sub {
                    my $result = time - $start > 20 ? 0 : 1;
                    $count++ if $result;
                    return $result;
                };
                $app->rebuild(
                    BlogID      => $blog_id,
                    ArchiveType => $type,
                    !$with_indexes ? ( NoIndexes => 1 ) : (),
                    Offset         => $offset,
                    Limit          => $app->config->EntriesPerRebuild,
                    FilterCallback => $cb,
                    $no_static ? ( NoStatic => 1 ) : (),
                    $template_id ? ( TemplateID => $template_id, Force => 1 )
                    : (),
                    $map_id ? ( TemplateMap => $template_id, Force => 1 )
                    : (),
                ) or return $app->publish_error();
                $offset += $count;
            }
            if ( $offset < $total ) {
                $done-- if $done;
                $next--;
            }
            else {
                $offset = 0;
            }
        }
    }

    # Rebuild done--now form the continuation.
    unless ($done) {
        my $dynamic   = 0;
        my $type_name = $order[$next];

        ## If we're moving on to the next rebuild step, recalculate the
        ## limit.
        my $static_count;
        if ( $type_name !~ m/^index/ ) {
            $static_count = $blog->count_static_templates($type_name) || 0;
        }
        else {
            $static_count = 1;
        }
        if ( !$static_count ) {
            $dynamic = 1;
        }
        elsif ( defined($offset) && $offset == 0 ) {
            $dynamic = 0;
        }
        if ( $offset == 0 ) {

            # determine total
            if ( my $archiver = $app->publisher->archiver($type_name) ) {
                if ( $archiver->entry_based || $archiver->date_based ) {
                    my $entry_class = $archiver->entry_class || 'entry';
                    require MT::Entry;
                    my $terms = {
                        class   => $entry_class,
                        status  => MT::Entry::RELEASE(),
                        blog_id => $blog_id,
                    };
                    $total = MT::Entry->count($terms);
                }
                elsif ( $archiver->category_based ) {
                    require MT::Category;
                    my $terms = { blog_id => $blog_id, };
                    $total = MT::Category->count($terms);
                }
                elsif ( $archiver->author_based ) {
                    require MT::Author;
                    require MT::Entry;
                    my $terms = {
                        blog_id => $blog_id,
                        status  => MT::Entry::RELEASE(),
                        class   => 'entry',
                    };
                    $total = MT::Author->count(
                        { status => MT::Author::ACTIVE() },
                        {   join => MT::Entry->join_on(
                                'author_id', $terms, { unique => 1 }
                            ),
                            unique => 1,
                        }
                    );
                }
            }
        }

        my $type = $order[$next];
        if ($type) {
            $archiver      = $app->publisher->archiver($type);
            $archive_label = $archiver ? $archiver->archive_label : '';
            $archive_label = $app->translate($type) unless $archive_label;
            $archive_label = $archive_label->()
                if ( ref $archive_label ) eq 'CODE';
        }

        my $complete
            = $total
            ? ( $total == $offset ? 100 : int( ( $offset / $total ) * 100 ) )
            : 0;

        my %param = (
            build_type      => $order,
            build_next      => $next,
            build_type_name => $archive_label,
            archives        => $archiver ? 1 : 0,
            total           => $total,
            offset          => $offset,
            complete        => $complete,
            start_time      => $start_time,
            incomplete      => 100 - $complete,
            entry_id        => scalar $q->param('entry_id'),
            dynamic         => $dynamic,
            is_new          => scalar $q->param('is_new'),
            old_status      => scalar $q->param('old_status'),
            is_full_screen  => scalar $q->param('fs'),
            with_indexes    => scalar $q->param('with_indexes'),
            no_static       => scalar $q->param('no_static'),
            template_id     => scalar $q->param('template_id'),
            return_args     => scalar $q->param('return_args')
        );
        $app->load_tmpl( 'rebuilding.tmpl', \%param );
    }
    else {
        $app->run_callbacks('post_build');
        if ( $q->param('entry_id') ) {
            require MT::Entry;
            my $entry = MT::Entry->load( scalar $q->param('entry_id') )
                or return $app->error(
                $app->translate(
                    'Cannot load entry #[_1].',
                    $q->param('entry_id')
                )
                );
            require MT::Blog;
            my $blog = MT::Blog->load( $entry->blog_id )
                or return $app->error(
                $app->translate( 'Cannot load blog #[_1].', $entry->blog_id )
                );
            require MT::CMS::Entry;
            MT::CMS::Entry::ping_continuation(
                $app,
                $entry, $blog,
                OldStatus => scalar $q->param('old_status'),
                IsNew     => scalar $q->param('is_new'),
            );
        }
        else {
            my $all          = $order =~ /,/;
            my $type         = $order;
            my $is_one_index = $order =~ /index template/;
            my $is_entry     = $order =~ /entry/;
            my $built_type;
            if ( $is_entry || $is_one_index ) {
                ( $built_type = $type )
                    =~ s/^(entry|index template)/$app->translate($1)/e;
            }
            else {
                $built_type = $app->translate($type);
            }
            my %param = (
                all             => $all,
                type            => $archive_label,
                is_one_index    => $is_one_index,
                is_entry        => $is_entry,
                archives        => $type ne 'index',
                start_timestamp => MT::Util::epoch2ts( $blog, $start_time ),
                total_time      => time - $start_time,
            );
            if ($is_one_index) {
                $param{tmpl_url} = $blog->site_url;
                $param{tmpl_url} .= '/' if $param{tmpl_url} !~ m!/$!;
                $param{tmpl_url} .= $tmpl_saved->outfile;
            }
            if ( $q->param('fs') ) {    # full screen--go to a useful app page
                if ( my $return_args = $q->param('return_args') ) {
                    $app->call_return;
                }
                else {
                    my $type = $q->param('type');
                    $type =~ /index-(\d+)/;
                    my $tmpl_id = $1;
                    $app->run_callbacks( 'rebuild', $blog );
                    return $app->redirect(
                        $app->uri(
                            'mode' => 'view',
                            args   => {
                                '_type'       => 'template',
                                id            => $tmpl_id,
                                blog_id       => $blog->id,
                                saved_rebuild => 1
                            }
                        )
                    );
                }
            }
            else {    # popup--just go to cnfrmn. page
                return $app->load_tmpl( 'popup/rebuilt.tmpl', \%param );
            }
        }
    }
}

sub rebuild_new_phase {
    my ($app) = @_;

    $app->validate_magic() or return;

    $app->setup_filtered_ids
        if $app->param('all_selected');
    require MT::CMS::Entry;
    MT::CMS::Entry::publish_entries($app);
}

sub start_rebuild_pages {
    my $app        = shift;
    my $q          = $app->param;
    my $start_time = $q->param('start_time');

    if ( !$start_time ) {

        # start of build; invoke callback
        $app->run_callbacks('pre_build');
        $start_time = time;
    }

    my $type = $q->param('type') || '';
    my $next = $q->param('next') || 0;
    my @order = split /,/, $type;
    my $total         = $q->param('total') || 0;
    my $type_name     = $order[$next];
    my $archiver      = $app->publisher->archiver($type_name);
    my $archive_label = $archiver ? $archiver->archive_label : '';
    $archive_label = $app->translate($type_name) unless $archive_label;
    $archive_label = $archive_label->() if ( ref $archive_label ) eq 'CODE';
    my $blog_id = $q->param('blog_id');

    my $with_indexes = $q->param('with_indexes');
    my $no_static    = $q->param('no_static');
    my $template_id  = $q->param('template_id');

    if ($archiver) {
        if ( $archiver->entry_based || $archiver->date_based ) {
            my $entry_class = $archiver->entry_class || 'entry';
            require MT::Entry;
            my $terms = {
                class   => $entry_class,
                status  => MT::Entry::RELEASE(),
                blog_id => $blog_id,
            };
            $total = MT::Entry->count($terms);
        }
        elsif ( $archiver->category_based ) {
            require MT::Category;
            my $terms = {
                blog_id => $blog_id,
                class   => $archiver->category_class,
            };
            $total = MT::Category->count($terms);
        }
        elsif ( $archiver->author_based ) {
            require MT::Author;
            require MT::Entry;
            my $terms = {
                blog_id => $blog_id,
                status  => MT::Entry::RELEASE(),
                class   => 'entry',
            };
            $total = MT::Author->count(
                { status => MT::Author::ACTIVE() },
                {   join => MT::Entry->join_on(
                        'author_id', $terms, { unique => 1 }
                    ),
                    unique => 1,
                }
            );
        }
    }

    my %param = (
        build_type      => $type,
        build_next      => $next,
        total           => $total,
        start_time      => $start_time,
        complete        => 0,
        incomplete      => 100,
        build_type_name => $archive_label,
        with_indexes    => $with_indexes,
        no_static       => $no_static,
        template_id     => $template_id,
        return_args     => $app->return_args
    );

    if ( $type_name =~ /^index-(\d+)$/ ) {
        my $tmpl_id = $1;
        require MT::Template;
        my $tmpl = MT::Template->load($tmpl_id)
            or return $app->error(
            $app->translate( 'Cannot load template #[_1].', $tmpl_id ) );
        $param{build_type_name} = $app->translate( "index template '[_1]'",
            MT::Util::encode_html( $tmpl->name ) );
        $param{is_one_index} = 1;
    }
    elsif ( $type_name =~ /^entry-(\d+)$/ ) {
        my $entry_id = $1;
        require MT::Entry;
        my $entry = MT::Entry->load($entry_id)
            or return $app->error(
            $app->translate( 'Cannot load entry #[_1].', $entry_id ) );
        $param{build_type_name}
            = $app->translate( "[_1] '[_2]'", $entry->class_label,
            MT::Util::encode_html( $entry->title ) );
        $param{is_entry} = 1;
        $param{entry_id} = $entry_id;
        for my $col (
            qw( is_new old_status old_next old_previous old_categories ))
        {
            $param{$col} = $q->param($col);
        }
    }
    $param{is_full_screen} = ( $param{is_entry} )
        || $q->param('single_template');
    $param{page_titles} = [ { bc_name => 'Rebuilding' } ];
    $app->load_tmpl( 'rebuilding.tmpl', \%param );
}

sub _create_build_order {
    my ( $app, $blog, $param ) = @_;

    my $at = $blog->archive_type || '';
    my ( @blog_at, @at, @data );
    my $archiver;
    my $archive_label;

    if ( $at && $at ne 'None' ) {
        @blog_at = split /,/, $at;
        require MT::PublishOption;
        foreach my $t (@blog_at) {
            $archiver = $app->publisher->archiver($t);
            next unless $archiver;    # ignore unknown archive types
            next
                unless MT::PublishOption::archive_build_is_enable( $blog->id,
                $t );
            push @at, $t;
            $archive_label = $archiver->archive_label;
            $archive_label = $at unless $archive_label;
            $archive_label = $archive_label->()
                if ( ref $archive_label ) eq 'CODE';
            push(
                @data,
                {   archive_type       => $t,
                    archive_type_label => $archive_label
                }
            );
        }
    }
    $param->{archive_type_loop} = \@data;
    $param->{build_order} = join ',', @at, 'index';
    1;
}

sub rebuild_confirm {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');
    require MT::Blog;
    my $blog = MT::Blog->load($blog_id)
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $blog_id ) );

    return $app->permission_denied()
        unless $app->can_do('rebuild');

    my %param = ( build_next => 0, );
    _create_build_order( $app, $blog, \%param );

    $param{index_selected} = ( $app->param('prompt') || "" ) eq 'index';

    if ( my $tmpl_id = $app->param('tmpl_id') ) {
        require MT::Template;
        my $tmpl
            = MT::Template->load( { id => $tmpl_id, blog_id => $blog_id } )
            or return $app->error(
            $app->translate( 'Cannot load template #[_1].', $tmpl_id ) );
        $param{index_tmpl_id}   = $tmpl->id;
        $param{index_tmpl_name} = $tmpl->name;
    }
    my $options = $app->registry("rebuild_options") || {};
    my @options;
    if ($options) {
        foreach my $opt ( keys %$options ) {
            $options->{$opt}{key} ||= $opt;
            push @options, $options->{$opt};
        }
    }
    $app->run_callbacks( 'rebuild_options', $app, \@options );
    my $rebuild_options = $app->filter_conditional_list( \@options );
    $param{rebuild_option_loop} = $rebuild_options;
    $param{refocus}             = 1;
    $app->add_breadcrumb( $app->translate('Publish Site') );
    $app->load_tmpl( 'popup/rebuild_confirm.tmpl', \%param );
}

sub save_favorite_blogs {
    my $app = shift;
    $app->validate_magic() or return;
    my $fav = $app->param('id');
    return unless int($fav) > 0;
    my $blog = $app->model('blog')->load($fav);
    if ( $blog && $blog->is_blog ) {
        $app->add_to_favorite_blogs($fav);
        $app->add_to_favorite_websites( $blog->parent_id );
    }
    elsif ( $blog && !$blog->is_blog ) {
        $app->add_to_favorite_websites($fav);
    }
    $app->send_http_header("text/javascript+json");
    return 'true';
}

sub cc_return {
    my $app   = shift;
    my $name  = $app->param('license_name');
    my $url   = $app->param('license_url');
    my $image = $app->param('license_button');

    my $code;
    if ( $url =~ m!^http://creativecommons\.org/licenses/([a-z\-]+)!i ) {
        $code = $1;
    }
    elsif ( $url =~ m!^http://creativecommons.org/publicdomain/mark/!i ) {
        $code = 'pd';
    }
    elsif ( $url =~ m!^http://creativecommons.org/publicdomain/zero/!i ) {
        $code = 'pdd';
    }
    else {
        return $app->error( "MT is not aware of this license: "
                . MT::Util::encode_html( $name, 1 ) );
    }

    my %param = (
        license_name => MT::Util::cc_name($code),
        license_code => "$code $url $image",
    );
    $app->load_tmpl( 'cc_return.tmpl', \%param );
}

sub handshake {
    my $app               = shift;
    my $blog_id           = $app->param('blog_id');
    my $remote_auth_token = $app->param('remote_auth_token');

    my %param = ();
    $param{remote_auth_token} = $remote_auth_token;
    $app->load_tmpl( 'handshake_return.tmpl', \%param );
}

sub update_welcome_message {
    my $app = shift;
    $app->validate_magic or return;

    my $perms = $app->permissions;
    return $app->permission_denied()
        unless $perms && $perms->can_do('update_welcome_message');

    my $blog_id    = $app->param('blog_id');
    my $message    = $app->param('welcome-message-text');
    my $blog_class = $app->model('blog');
    my $blog       = $blog_class->load($blog_id)
        or return $app->error( $app->translate("Invalid blog") );
    $blog->welcome_msg($message);
    $blog->save;
    $app->redirect(
        $app->uri( mode => 'menu', args => { blog_id => $blog_id } ) );
}

sub dialog_select_weblog {
    my $app = shift;

    my $favorites = $app->param('select_favorites');
    my %favorite;
    my $confirm_js;
    my $terms = {};
    my $args  = {};
    my $auth  = $app->user or return;

    if ($favorites) {
        my @favs = @{ $auth->favorite_blogs || [] };
        if (@favs) {
            @favs = @favs[ 0 .. 4 ] if scalar @favs > 5;
            $terms->{id} = { not => \@favs };
        }
        $confirm_js = 'saveFavorite';
    }
    if (   !$auth->is_superuser
        && !$auth->permissions(0)->can_do('edit_templates') )
    {
        use MT::Permission;
        $args->{join} = MT::Permission->join_on( 'blog_id',
            { author_id => $auth->id } );
    }
    $terms->{class} = 'blog';

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        $row->{label} = $row->{name};
        $row->{'link'} = $obj->site_url;
    };

    $app->listing(
        {   type     => 'blog',
            code     => $hasher,
            template => 'dialog/select_weblog.tmpl',
            terms    => $terms,
            args     => $args,
            params   => {
                dialog_title  => $app->translate("Select Blog"),
                items_prompt  => $app->translate("Selected Blog"),
                search_prompt => $app->translate(
                    "Type a blog name to filter the choices below."),
                panel_label       => $app->translate("Blog Name"),
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
                    . ( $app->param('return_args') || '' ),
                confirm_js  => $confirm_js,
                idfield     => ( $app->param('idfield') || '' ),
                namefield   => ( $app->param('namefield') || '' ),
                search_type => 'blog',
            },
        }
    );
}

sub can_view {
    my ( $eh, $app, $id ) = @_;
    if ($id) {
        return $app->can_do('open_blog_config_screen');
    }
    else {
        return $app->can_do('open_new_blog_screen');
    }
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
            || ( $app->param('cfg_screen')
            && $app->param('cfg_screen') eq 'cfg_publish_profile' );
    }
    else {
        return $app->can_do('create_blog');
    }
}

sub can_delete {
    my ( $eh, $app, $id ) = @_;
    return 1 if $app->user->is_superuser;
    return 0 unless $id;

    unless ( ref $id ) {
        $id = MT->model('blog')->load($id)
            or return;
    }

    return unless $id->is_blog;

    my $author = $app->user;
    return $author->permissions( $id->id )->can_do('delete_blog');
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    if (  !$app->param('overlay')
        && $app->param('cfg_screen') )
    {

        # Checkbox options have to be blanked if they aren't passed.
        my $screen = $app->param('cfg_screen');
        my @fields;
        if ( $screen eq 'cfg_web_services' ) {
        }
        elsif ( $screen eq 'cfg_templatemaps' ) {
        }
        elsif ( $screen eq 'cfg_feedback' ) {
            @fields = qw( allow_comment_html autolink_urls
                use_comment_confirmation allow_pings moderate_pings
                autodiscover_links internal_autodiscovery );
        }
        elsif ( $screen eq 'cfg_registration' ) {
            @fields = qw( allow_commenter_regist
                require_comment_emails allow_unreg_comments
                require_typekey_emails );
        }
        elsif ( $screen eq 'cfg_entry' ) {
            @fields = qw( allow_comments_default
                allow_pings_default );
        }
        elsif ( $screen eq 'cfg_plugins' ) {
        }
        elsif ( $screen eq 'cfg_prefs' ) {
            @fields = qw( use_revision );
        }
        for my $cb (@fields) {
            unless ( defined $app->param($cb) ) {

    # two possibilities: user unchecked the option, or user was not allowed to
    # set the value (and therefore there was no field to submit).
                my $perms = $app->permissions;
                if ( $app->can_do('edit_blog_config') ) {
                    $obj->$cb(0);
                }
                else {
                    delete $obj->{column_values}->{$cb};
                    delete $obj->{changed_cols}->{$cb};
                }
            }
        }
        if ( $screen eq 'cfg_feedback' ) {

            # value for comments:  1 == Accept from anyone
            #                      2 == Accept authenticated only
            #                      0 == No comments
            if ( $app->param('allow_comments') ) {
                $obj->allow_reg_comments(1);
            }
            else {
                $obj->allow_unreg_comments(0);
                $obj->allow_reg_comments(0);
            }
            $obj->moderate_unreg_comments( $app->param('moderate_comments') );
            $obj->nofollow_urls( $app->param('nofollow_urls') ? 1 : 0 );
            $obj->follow_auth_links(
                $app->param('follow_auth_links') ? 1 : 0 );
            my $cp_old = $obj->captcha_provider;
            $obj->captcha_provider( $app->param('captcha_provider') );
            my $rebuild = $cp_old ne $obj->captcha_provider ? 1 : 0;
            $app->add_return_arg( need_full_rebuild => 1 ) if $rebuild;

            if ( my $pings = $app->param('allow_pings') ) {
                if ($pings) {
                    $obj->moderate_pings( $app->param('moderate_pings') );
                    $obj->nofollow_urls(
                        $app->param('nofollow_urls') ? 1 : 0 );
                }
                else {
                    $obj->moderate_pings(1);
                    $obj->email_new_pings(1);
                }
            }

            my $threshold = $app->param('junk_score_threshold');
            $threshold =~ s/\+//;
            $threshold ||= 0;
            $obj->junk_score_threshold($threshold);
            if ( my $expiry = $app->param('junk_folder_expiry') ) {
                $obj->junk_folder_expiry($expiry);
            }
            my $perms = $app->permissions;
            unless ( defined $app->param('auto_delete_junk') ) {
                if ( $app->can_do('edit_junk_auto_delete') ) {
                    $obj->junk_folder_expiry(0);
                }
                else {
                    delete $obj->{column_values}{junk_folder_expiry};
                    delete $obj->{changed_cols}{junk_folder_expiry};
                }
            }
        }
        if ( $screen eq 'cfg_web_services' ) {
            my $tok = '';
            ( $tok = $obj->remote_auth_token ) =~ s/\s//g;
            $obj->remote_auth_token($tok);

            my $ping_servers = $app->registry('ping_servers');
            my @pings_list;
            push @pings_list, $_ foreach grep {
                defined( $app->param( 'ping_' . $_ ) )
                    && $app->param( 'ping_' . $_ )
                }
                keys %$ping_servers;
            $obj->update_pings( join( ',', @pings_list ) );
        }
        if ( $screen eq 'cfg_registration' ) {
            $obj->allow_commenter_regist(
                $app->param('allow_commenter_regist') );
            $obj->allow_unreg_comments( $app->param('allow_unreg_comments') );
            if ( $app->param('allow_unreg_comments') ) {
                $obj->require_comment_emails(
                    $app->param('require_comment_emails') );
            }
            else {
                $obj->require_comment_emails(0);
            }
            my @authenticators;
            for my $param ( $app->param->param ) {
                if ( $param =~ /^enabled_(.*)$/ ) {
                    push @authenticators, $1;
                }
            }
            my $c_old = $obj->commenter_authenticators;
            $obj->commenter_authenticators( join( ',', @authenticators ) );
            my $rebuild = $obj->commenter_authenticators ne $c_old ? 1 : 0;
            if ( $app->param('enabled_TypeKey') ) {
                $rebuild = $obj->require_typekey_emails ? 0 : 1;
                $obj->require_typekey_emails(
                    $app->param('require_typekey_emails') );
            }
            else {
                $obj->require_typekey_emails(0);
            }
            my $tok = '';
            ( $tok = $obj->remote_auth_token ) =~ s/\s//g;
            $obj->remote_auth_token($tok);

            $app->add_return_arg( need_full_rebuild => 1 ) if $rebuild;
        }
        if ( $screen eq 'cfg_entry' ) {
            my %param = $_[0] ? %{ $_[0] } : ();
            my $pref_param = $app->load_entry_prefs( { type => 'entry' } );
            %param = ( %param, %$pref_param );
            $pref_param = $app->load_entry_prefs( { type => 'page' } );
            %param = ( %param, %$pref_param );
            $param{ 'sort_order_posts_' . ( $obj->sort_order_posts || 0 ) }
                = 1;
            $param{words_in_excerpt} = 40
                unless defined $param{words_in_excerpt}
                    && $param{words_in_excerpt} ne '';
            if ( $app->param('days_or_posts') eq 'days' ) {
                $obj->days_on_index( $app->param('list_on_index') );
                $obj->entries_on_index(0);
            }
            else {
                $obj->entries_on_index( $app->param('list_on_index') );
                $obj->days_on_index(0);
            }
            $obj->basename_limit(15)
                if $obj->basename_limit < 15;    # 15 is the *minimum*
            $obj->basename_limit(250)
                if $obj->basename_limit > 250;    # 15 is the *maximum*
        }
        if ( $screen eq 'cfg_prefs' ) {
            $obj->include_system( $app->param('include_system') || '' );
            if ( !$app->param('enable_archive_paths') ) {
                $obj->archive_url('');
                $obj->archive_path('');
            }
        }
        if ( $screen eq 'cfg_publish_profile' ) {
            if ( my $dcty = $app->param('dynamicity') ) {
                $obj->custom_dynamic_templates($dcty);
            }
        }
    }
    else {

       #$obj->is_dynamic(0) unless defined $app->{query}->param('is_dynamic');
    }

    if ( ( $obj->sanitize_spec || '' ) eq '1' ) {
        $obj->sanitize_spec( scalar $app->param('sanitize_spec_manual') );
    }

    1;
}

sub _update_finfos {
    my ( $app, $new_virtual, $where ) = @_;
    my $finfo_class = MT->model('fileinfo');
    my $driver      = $finfo_class->driver;
    my $dbd         = $driver->dbd;

    my $stmt = $dbd->sql_class->new;

    if ($where) {
        my $new_where = {};
        while ( my ( $key, $val ) = each %$where ) {
            my $new_key
                = $dbd->db_column_name( $finfo_class->datasource, $key );
            $new_where->{$new_key} = $val;
        }
        $stmt->add_complex_where( [$new_where] );
    }
    my $virtual_col
        = $dbd->db_column_name( $finfo_class->datasource, 'virtual' );
    $stmt->add_complex_where(
        [   {   $virtual_col =>
                    [ { op => '!=', value => $new_virtual }, \"is null", ]
            }
        ]
    );

    my $sql = join q{ }, 'UPDATE', $driver->table_for($finfo_class), 'SET',
        $virtual_col, '= ?', $stmt->as_sql_where();

    my $dbh = $driver->rw_handle;
    $dbh->do( $sql, {}, $new_virtual, @{ $stmt->{bind} } )
        or return $app->error( $dbh->errstr || $DBI::errstr );
    1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    my $perms = $app->permissions;
    return 1
        unless $app->user->is_superuser
            || (  $obj->is_blog
                ? $app->user->can_create_blog
                : $app->user->can_create_website
            )
            || ( $perms && $perms->can_edit_config );

    # check to see what changed and add a flag to meta_messages
    my @meta_messages = ();
    my %blog_fields
        = ( %{ $obj->column_defs }, %{ $obj->properties()->{fields} } );
    foreach my $key (
        qw{ created_on created_by modified_on modified_by id class children_modified_on }
        )
    {
        delete $blog_fields{$key};
    }

    for my $blog_field ( keys %blog_fields ) {

        if ( $obj->$blog_field() ne $original->$blog_field() ) {
            my $old
                = $original->$blog_field()
                ? $original->$blog_field()
                : "none";
            my $new = $obj->$blog_field() ? $obj->$blog_field() : "none";
            push(
                @meta_messages,
                $app->translate(
                    "[_1] changed from [_2] to [_3]",
                    $blog_field, $old, $new
                )
            );
        }
    }

    # log all of the changes we can possible log
    my $blog_type = $obj->is_blog ? 'Blog' : 'Website';
    if ( scalar(@meta_messages) > 0 ) {
        my $meta_message = join( ", ", @meta_messages );
        $app->log(
            {   message => $app->translate(
                    "Saved [_1] Changes", $obj->class_label
                ),
                metadata => $meta_message,
                level    => MT::Log::INFO(),
                class    => $obj->class,
                blog_id  => $obj->id,
                category => 'edit',
            }
        );
    }

    my $screen = $app->param('cfg_screen') || '';
    if ( $screen eq 'cfg_publish_profile' ) {
        if ( my $dcty = $app->param('dynamicity') ) {

# Apply publishing rules for templates based on
# publishing method selected:
#     none (0% publish queue, all static)
#     async_all (100% publish queue)
#     async_partial (high-priority templates publish synchronously (main index, preferred indiv. archives, feed templates))
#     all (100% dynamic)
#     archives (archives dynamic, static indexes)
#     custom (custom configuration)

            update_publishing_profile( $app, $obj );

            if ( ( $dcty eq 'none' ) || ( $dcty =~ m/^async/ ) ) {
                _update_finfos( $app, 0 );
            }
            elsif ( $dcty eq 'all' ) {
                _update_finfos( $app, 1 );
            }
            elsif ( $dcty eq 'archives' ) {

                # Only archives have template maps.
                _update_finfos( $app, 1,
                    { templatemap_id => \'is not null' } );
                _update_finfos( $app, 0, { templatemap_id => \'is null' } );
            }
        }

        cfg_publish_profile_save( $app, $obj ) or return;
    }
    if ( $screen eq 'cfg_prefs' ) {
        my $blog_id = $obj->id;

        # FIXME: Needs to exclude MT::Permission records for groups
        $app->model('permission')
            ->load( { blog_id => $blog_id, author_id => 0 } );
        if ( !$perms ) {
            $perms = $app->model('permission')->new;
            $perms->blog_id($blog_id);
            $perms->author_id(0);
        }

        cfg_prefs_save( $app, $obj ) or return;

        # If either of the publishing paths changed, rebuild the fileinfos.
        my $path_changed = 0;
        for my $path_field (qw( site_path archive_path site_url archive_url ))
        {
            if ( $obj->$path_field() ne $original->$path_field() ) {
                $path_changed = 1;
                last;
            }
        }

        if ($path_changed) {
            update_dynamicity( $app, $obj );
            $app->rebuild( BlogID => $obj->id, NoStatic => 1 )
                or $app->publish_error();
        }
    }
    if ( $screen eq 'cfg_entry' ) {
        my $blog_id = $obj->id;

        # FIXME: Needs to exclude MT::Permission records for groups
        my $perms = $app->model('permission')
            ->load( { blog_id => $blog_id, author_id => 0 } );
        if ( !$perms ) {
            $perms = $app->model('permission')->new;
            $perms->blog_id($blog_id);
            $perms->author_id(0);
        }
        foreach my $type (qw(entry page)) {
            my $prefs = $app->_entry_prefs_from_params( $type . '_' );
            if ($prefs) {
                my $prefs_type = $type . '_prefs';
                $perms->$prefs_type($prefs);
                $perms->save
                    or
                    return $app->errtrans( "Saving permissions failed: [_1]",
                    $perms->errstr );
            }
        }
    }
    if ( $screen eq 'cfg_registration' ) {
        my $new_default_roles = $app->param('new_created_user_role');
        if ( defined $new_default_roles ) {
            my $blog_id  = $obj->id;
            my @role_ids = split ',',
                ( $app->param('new_created_user_role') || '' );
            my @def = split ',', $app->config('DefaultAssignments');
            my @defaults;
            while ( my $r_id = shift @def ) {
                my $b_id = shift @def;
                next if $b_id eq $blog_id;
                push @defaults, join( ',', $r_id, $b_id );
            }
            push @defaults, join( ',', $_, $blog_id ) for @role_ids;
            $app->config( 'DefaultAssignments', join( ',', @defaults ), 1 );
            $app->config->save_config;
        }
    }

    if ( !$original->id ) {    # If the object is new, the "orignal" was blank
        ## If this is a new blog, we need to set up a permissions
        ## record for the existing user.
        #$obj->create_default_templates( $obj->template_set );

        # Add this blog to the user's "favorite blogs", pushing any 10th
        # blog off the list
        my $auth = $app->user;

        # Grant permission
        my $assoc_class = $app->model('association');
        my $role_class  = $app->model('role');
        my $role;
        if ( $obj->is_blog ) {
            my @roles = $role_class->load_by_permission("administer_blog");
            foreach my $r (@roles) {
                next if $r->permissions =~ m/\'administer_website\'/;
                $role = $r;
                last;
            }
        }
        else {
            my @roles = $role_class->load_by_permission("administer_website");
            foreach my $r (@roles) {
                $role = $r;
                last;
            }
        }
        $assoc_class->link( $auth => $role => $obj );

        if ( $obj->is_blog ) {
            my $website = $app->blog;
            $website->add_blog($obj);
        }

        # permission granted - need to update commenting cookie
        my %cookies = $app->cookies();
        $app->cookie_val();
        my ( $x, $y, $remember )
            = split( /::/, $cookies{ $app->user_cookie() }->value );
        my $cookie = $cookies{'commenter_id'};
        my $cookie_value = $cookie ? $cookie->value : '';
        my ( $id, $blog_ids ) = split( ':', $cookie_value );
        if ( $blog_ids ne 'S' && $blog_ids ne 'N' ) {
            $blog_ids .= ",'" . $obj->id . "'";
        }
        my $timeout = $remember ? '+10y' : 0;
        $timeout = '+' . $app->config->CommentSessionTimeout . 's'
            unless $timeout;
        my %id_kookee = (
            -name  => "commenter_id",
            -value => $auth->id . ':' . $blog_ids,
            -path  => '/',
            ( $timeout ? ( -expires => $timeout ) : () )
        );
        $app->bake_cookie(%id_kookee);
        $app->make_commenter_session($auth);

        require MT::Log;
        $app->log(
            {   message => $app->translate(
                    "[_1] '[_2]' (ID:[_3]) created by '[_4]'",
                    $obj->class_label, $obj->name, $obj->id, $auth->name
                ),
                level    => MT::Log::INFO(),
                class    => $obj->class,
                category => 'new',
            }
        );
        $app->run_callbacks( 'blog_template_set_change', { blog => $obj } );

        if ( $obj->is_blog ) {
            $app->run_callbacks( 'blog_theme_change', { blog => $obj } );
        }
        else {
            $app->run_callbacks( 'website_theme_change',
                { website => $obj } );
        }
        $obj->apply_theme();

    }
    else {

        # if settings were changed that would affect published pages:
        if (grep { $original->column($_) ne $obj->column($_) }
            qw(allow_unreg_comments allow_reg_comments remote_auth_token
            allow_pings          allow_comment_html )
            )
        {
            $app->add_return_arg( need_full_rebuild => 1 );
        }

        my $original_set = $original->template_set;
        $original_set = $original->theme_id if ref $original_set;
        my $obj_set = $obj->template_set;
        $obj_set = $obj->theme_id if ref $obj_set;
        if ( ( $original_set || '' ) ne ( $obj_set || '' ) ) {
            $app->run_callbacks( 'blog_template_set_change',
                { blog => $obj } );
            $app->add_return_arg( need_full_rebuild => 1 );
        }

        ## THINK: should the theme be changed by normal save method?
        if ( ( $original->theme_id || '' ) ne ( $obj->theme_id || '' ) ) {
            if ( $obj->is_blog ) {
                $app->run_callbacks( 'blog_theme_change', { blog => $obj } );
            }
            else {
                $app->run_callbacks( 'website_theme_change',
                    { website => $obj } );
            }

            $obj->apply_theme();
        }
    }
    1;
}

sub save_filter {
    my $eh    = shift;
    my ($app) = @_;
    my $name  = $app->param('name');
    if ( defined $name ) {
        $name =~ s/(^\s+|\s+$)//g;
        $app->param( 'name', $name );
    }
    my $perms = $app->permissions;
    my $screen = $app->param('cfg_screen') || '';
    return $eh->error( MT->translate("You did not specify a blog name.") )
        if ( !( $screen && $app->can_do('edit_blog_config') )
        && ( defined $app->param('name') && ( $app->param('name') eq '' ) ) );

#TBD
#    return $eh->error( MT->translate("Site URL must be an absolute URL.") )
#      if ( $screen eq 'cfg_prefs' )
#      && $app->can_do('set_publish_paths')
#      && $app->param('site_url') !~ m.^https?://.;
#    return $eh->error( MT->translate("Archive URL must be an absolute URL.") )
#      if ( $screen eq 'cfg_prefs' )
#      && $app->can_do('set_publish_paths')
#      && $app->param('archive_url') !~ m.^https?://.
#      && $app->param('enable_archive_paths');
#    return $eh->error( MT->translate("You did not specify an Archive Root.") )
#      if ( $screen eq 'cfg_prefs' )
#      && $app->param('archive_path') =~ m/^\s*$/
#      && $app->param('enable_archive_paths');
    if ( $screen eq 'cfg_prefs' ) {
        return $eh->error(
            MT->translate(
                "The number of revisions to store must be a positive integer."
            )
        ) unless 0 < sprintf( '%d', $app->param('max_revisions_entry') );
        return $eh->error(
            MT->translate(
                "The number of revisions to store must be a positive integer."
            )
            )
            unless 0 < sprintf( '%d', $app->param('max_revisions_template') );
        return $eh->error(
            MT->translate("Please choose a preferred archive type.") )
            if $app->blog->is_blog
                && (   !$app->param('no_archives_are_active')
                    && !$app->param('preferred_archive_type') );
    }
    return 1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {   message => $app->translate(
                "Blog '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->name, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'blog',
            category => 'delete'
        }
    );
    require MT::CMS::User;
    MT::CMS::User::_delete_pseudo_association( $app, undef, $obj->id );
}

sub make_blog_list {
    my $app = shift;
    my ($blogs) = @_;

    my $author = $app->user;
    my $data;
    my $can_edit_authors = 1 if $app->can_do('edit_authors');
    my @blog_ids = map { $_->id } @$blogs;
    my %counts;
    my $e_iter
        = $app->model('entry')->count_group_by( { blog_id => \@blog_ids },
        { group => ['blog_id'] } );
    while ( my ( $e_count, $e_blog_id ) = $e_iter->() ) {
        $counts{$e_blog_id}{'entry'} = $e_count;
    }
    my $pg_iter
        = $app->model('page')->count_group_by( { blog_id => \@blog_ids },
        { group => ['blog_id'] } );
    while ( my ( $p_count, $p_blog_id ) = $pg_iter->() ) {
        $counts{$p_blog_id}{'page'} = $p_count;
    }
    my $c_iter
        = $app->model('comment')->count_group_by( { blog_id => \@blog_ids },
        { group => ['blog_id'] } );
    while ( my ( $c_count, $c_blog_id ) = $c_iter->() ) {
        $counts{$c_blog_id}{'comment'} = $c_count;
    }
    my $p_iter
        = $app->model('tbping')->count_group_by( { blog_id => \@blog_ids },
        { group => ['blog_id'] } );
    while ( my ( $p_count, $p_blog_id ) = $p_iter->() ) {
        $counts{$p_blog_id}{'ping'} = $p_count;
    }

    my $type = $app->param('type');
    if ( $type && $type eq 'website' ) {
        my $b_iter = $app->model('blog')->count_group_by(
            { parent_id => \@blog_ids },
            { group     => ['parent_id'] },
        );
        while ( my ( $b_count, $b_website_id ) = $b_iter->() ) {
            $counts{$b_website_id}{'blog'} = $b_count;
        }
    }

    my @ids = split ',', $app->param('error_id');
    for my $blog (@$blogs) {
        my $blog_id = $blog->id;
        my $perms   = $author->permissions($blog_id);
        my $row     = {
            id          => $blog->id,
            name        => $blog->name,
            description => $blog->description,
            site_url    => $blog->site_url
        };
        $row->{num_blogs} = $counts{$blog_id}{'blog'} unless $blog->is_blog();
        $row->{num_entries}           = $counts{$blog_id}{'entry'};
        $row->{num_pages}             = $counts{$blog_id}{'page'};
        $row->{num_comments}          = $counts{$blog_id}{'comment'};
        $row->{num_pings}             = $counts{$blog_id}{'ping'};
        $row->{can_create_post}       = $perms->can_do('create_new_entry');
        $row->{can_edit_entries}      = $perms->can_do('create_new_entry');
        $row->{can_edit_pages}        = $perms->can_do('manage_pages');
        $row->{can_edit_templates}    = $perms->can_do('edit_templates');
        $row->{can_edit_config}       = $perms->can_do('edit_config');
        $row->{can_set_publish_paths} = $perms->can_do('set_publish_paths');
        $row->{can_manage_feedback}   = $perms->can_do('manage_feedback');
        $row->{can_edit_assets}       = $perms->can_do('edit_assets');
        $row->{can_administer_blog}   = $perms->can_do('administer_blog');
        $row->{can_list_blogs} = $perms->can_do('open_blog_listing_screen');
        $row->{checked} = grep { $_ == $blog->id } @ids;
        push @$data, $row;
    }
    $data;
}

sub build_blog_table {
    my $app = shift;
    my (%args) = @_;

    my $blog_class    = $app->model('blog');
    my $tbp_class     = $app->model('ping');
    my $entry_class   = $app->model('entry');
    my $comment_class = $app->model('comment');

    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('blog');
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
    my $i;
    my ( $entry_count, $ping_count, $comment_count );
    while ( my $blog = $iter->() ) {
        my $blog_id = $blog->id;
        my $row     = {
            id          => $blog->id,
            name        => $blog->name,
            description => $blog->description,
            site_url    => $blog->site_url
        };

        if ( my $website = $blog->website ) {
            $row->{website_name}          = $website->name;
            $row->{website_id}            = $website->id;
            $row->{can_access_to_website} = 1
                if $website
                    && (   $author->is_superuser
                        || $author->permissions( $website->id ) );
        }

        if ( $app->mode ne 'dialog_select_weblog' ) {

            # we should use count by group here...
            $row->{num_entries} = (
                  $entry_count
                ? $entry_count->{$blog_id}
                : $entry_count->{$blog_id}
                    = MT::Entry->count( { blog_id => $blog_id } )
                )
                || 0;
            $row->{num_comments} = (
                  $comment_count
                ? $comment_count->{$blog_id}
                : $comment_count->{$blog_id} = MT::Comment->count(
                    {   blog_id     => $blog_id,
                        junk_status => MT::Comment::NOT_JUNK()
                    }
                )
                )
                || 0;
            $row->{num_pings} = (
                  $ping_count
                ? $ping_count->{$blog_id}
                : $ping_count->{$blog_id} = MT::TBPing->count(
                    {   blog_id     => $blog_id,
                        junk_status => MT::TBPing::NOT_JUNK()
                    }
                )
                )
                || 0;
            $row->{num_authors} = 0;
            if ( $author->is_superuser ) {
                $row->{can_create_post}       = 1;
                $row->{can_edit_entries}      = 1;
                $row->{can_edit_templates}    = 1;
                $row->{can_edit_config}       = 1;
                $row->{can_set_publish_paths} = 1;
                $row->{can_administer_blog}   = 1;
            }
            else {
                my $perms = $author->permissions($blog_id);
                $row->{can_create_post}    = $perms->can_do('create_post');
                $row->{can_edit_entries}   = $perms->can_do('create_post');
                $row->{can_edit_templates} = $perms->can_do('edit_templates');
                $row->{can_edit_config}    = $perms->can_do('edit_config');
                $row->{can_set_publish_paths}
                    = $perms->can_do('set_publish_paths');
                $row->{can_administer_blog}
                    = $perms->can_do('administer_blog');
            }
        }
        $row->{object} = $blog;
        push @data, $row;
    }

    if (@data) {
        $param->{blog_table}[0]{object_loop} = \@data;
        $app->load_list_actions( 'blog', \%$param );
        $param->{object_loop} = $param->{blog_table}[0]{object_loop};
    }

    \@data;
}

sub cfg_blog {
    my $q = $_[0]->{query};
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    $_[0]->forward( "view", { output => 'cfg_prefs.tmpl' } );
}

sub cfg_prefs_save {
    my $app = shift;
    my ($blog) = @_;

    my $at = $app->param('preferred_archive_type');
    $blog->archive_type_preferred($at);
    $blog->include_cache( $app->param('include_cache') ? 1 : 0 );

    if ( $blog->class eq 'blog' && $app->can_do('set_publish_paths') ) {
        my $subdomain = $app->param('site_url_subdomain');
        $subdomain = '' if !$app->param('use_subdomain');
        $subdomain .= '.' if $subdomain && $subdomain !~ /\.$/;
        $subdomain =~ s/\.{2,}/\./g;
        my $path = $app->param('site_url_path');
        $blog->site_url("$subdomain/::/$path");
        if ( $app->param('enable_archive_paths') ) {
            $subdomain = $app->param('archive_url_subdomain');
            $subdomain = '' if !$app->param('use_archive_subdomain');
            $subdomain .= '.' if $subdomain && $subdomain !~ /\.$/;
            $subdomain =~ s/\.{2,}/\./g;
            $path = $app->param('archive_url_path');
            $blog->archive_url("$subdomain/::/$path");
        }
        $blog->site_path( $app->param('site_path_absolute') )
            if !$app->config->BaseSitePath
                && $app->param('use_absolute')
                && $app->param('site_path_absolute');
        $blog->archive_path( $app->param('archive_path_absolute') )
            if !$app->config->BaseSitePath
                && $app->param('enable_archive_paths')
                && $app->param('use_absolute_archive')
                && $app->param('archive_path_absolute');
    }

    require MT::PublishOption;
    if ((   $app->model('template')->exist(
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
        )
    {

        # dynamic enabled and caching option may have changed - update mtview
        my $cache       = $app->param('dynamic_cache')       ? 1 : 0;
        my $conditional = $app->param('dynamic_conditional') ? 1 : 0;
        _create_mtview( $blog, $blog->site_path, $cache, $conditional );
        _create_dynamiccache_dir( $blog, $blog->site_path ) if $cache;
        if ( $blog->archive_path ) {
            _create_mtview( $blog, $blog->archive_path, $cache,
                $conditional );
            _create_dynamiccache_dir( $blog, $blog->archive_path ) if $cache;
        }
    }
    $blog->use_revision( $app->param('use_revision') ? 1 : 0 );
    if ( $app->param('use_revision') ) {
        $blog->max_revisions_entry( $app->param('max_revisions_entry') )
            if $app->param('max_revisions_entry');
        $blog->max_revisions_template( $app->param('max_revisions_template') )
            if $app->param('max_revisions_template');
    }

    $blog->save
        or return $app->error(
        $app->translate( "Saving blog failed: [_1]", $blog->errstr ) );

    1;
}

sub cfg_publish_profile_save {
    my $app = shift;
    my ($blog) = @_;

    my $dcty = $app->param('dynamicity') || 'none';
    my $pq = $dcty =~ m/^async/ ? 1 : 0;
    $blog->publish_queue($pq);
    if ( $dcty eq 'all' || $dcty eq 'archives' ) {

        # update the dynamic publishing options if they changed
        update_dynamicity( $app, $blog );
    }
    $blog->save
        or return $app->error(
        $app->translate( "Saving blog failed: [_1]", $blog->errstr ) );

    1;
}

# Unused function. To be removed.
# FIXME: Faulty, since it doesn't take into account module includes
sub RegistrationAffectsArchives {
    my ( $blog_id, $archive_type ) = @_;
    require MT::TemplateMap;
    require MT::Template;
    my @tms = MT::TemplateMap->load(
        {   archive_type => $archive_type,
            blog_id      => $blog_id
        }
    );
    grep { !$_->build_dynamic && ( $_->text =~ /<MT:?IfRegistration/i ) }
        map { MT::Template->load( $_->template_id ) } @tms;
}

sub update_publishing_profile {
    my $app = shift;
    my ($blog) = @_;

    my $dcty = $blog->custom_dynamic_templates;

    require MT::PublishOption;
    require MT::Template;
    require MT::TemplateMap;

    if ( ( $dcty eq 'none' ) || ( $dcty =~ m/^async/ ) ) {
        my @templates = MT::Template->load(
            {   blog_id => $blog->id,

                # FIXME: enumeration of types
                type =>
                    [ 'index', 'archive', 'individual', 'page', 'category' ],
            }
        );
        for my $tmpl (@templates) {
            my $bt = $tmpl->build_type || 0;

            # Do not make automatic modifications to templates with these
            # manually configured build types
            next if $bt == MT::PublishOption::DISABLED();
            next if $bt == MT::PublishOption::MANUALLY();
            next if $bt == MT::PublishOption::SCHEDULED();

            if ( $dcty eq 'async_partial' ) {

                # these should be build synchronously
                if ( ( $tmpl->identifier || '' )
                    =~ m/^(main_index|feed_recent)$/ )
                {
                    $tmpl->build_type( MT::PublishOption::ONDEMAND() );
                }
                else {
                    if (   ( $tmpl->type eq 'individual' )
                        || ( $tmpl->type eq 'page' ) )
                    {
                        my @tmpl_maps = MT::TemplateMap->load(
                            { template_id => $tmpl->id } );
                        foreach my $tmpl_map (@tmpl_maps) {
                            if ((   $tmpl_map->archive_type
                                    =~ m/^(Individual|Page)$/
                                )
                                && ( $tmpl_map->is_preferred )
                                )
                            {
                                $tmpl_map->build_type(
                                    MT::PublishOption::ONDEMAND() );
                                $tmpl_map->save;
                                next;
                            }
                            if ( $tmpl_map->build_type
                                != MT::PublishOption::ASYNC() )
                            {
                                $tmpl_map->build_type(
                                    MT::PublishOption::ASYNC() );
                                $tmpl_map->save;
                            }
                        }
                    }
                    else {

                        # updates all template maps too
                        $tmpl->build_type( MT::PublishOption::ASYNC() );
                    }
                }
            }
            elsif ( $dcty eq 'async_all' ) {
                $tmpl->build_type( MT::PublishOption::ASYNC() );
            }
            else {
                $tmpl->build_type( MT::PublishOption::ONDEMAND() );
            }
            $tmpl->save();
        }
        if ( $dcty eq 'none' ) {
            if ( $ENV{SERVER_SOFTWARE} =~ /Microsoft-IIS/
                && MT->config->EnableAutoRewriteOnIIS )
            {

                # Remove IIS redirect settings
                my $remove_setting = sub {
                    my ($web_config_path) = @_;
                    require XML::Simple;
                    my $web_config;
                    my $parser = XML::Simple->new;
                    if ( -f $web_config_path ) {
                        $web_config = $parser->XMLin( $web_config_path,
                            keyattr => [] );

                        my $rules;
                        my $new_rules;
                        if (defined $web_config->{'system.webServer'}
                            ->{'rewrite'} )
                        {
                            $rules = $web_config->{'system.webServer'}
                                ->{'rewrite'}->{'rules'}->{'rule'};
                            $rules = [$rules] unless ref $rules eq 'ARRAY';
                            foreach my $rule (@$rules) {
                                if ( defined $rule->{name}
                                    && $rule->{name}
                                    !~ m/^Rewrite rule for '/ )
                                {
                                    unshift @$new_rules, $rule;
                                }
                            }
                        }
                        if ($new_rules) {
                            $web_config->{'system.webServer'}->{'rewrite'}
                                ->{'rules'}->{'rule'} = $new_rules;
                        }
                        elsif (
                            defined $web_config->{'system.webServer'}
                            ->{'rewrite'} )
                        {
                            delete $web_config->{'system.webServer'}
                                ->{'rewrite'};
                        }

                        my $out = $parser->XMLout(
                            $web_config,
                            RootName => undef,
                            keyattr  => []
                        );
                        $out
                            = '<?xml version="1.0" encoding="UTF-8"?>' . "\n"
                            . "<configuration>\n"
                            . $out
                            . "</configuration>\n";

                        my $fh;
                        open( $fh, ">$web_config_path" )
                            || die
                            "Couldn't open $web_config_path for appending";
                        print $fh $out;
                        close $fh;
                    }
                };

                $remove_setting->(
                    File::Spec->catfile( $blog->site_path, "web.config" ) );
                $remove_setting->(
                    File::Spec->catfile( $blog->archive_path, "web.config" )
                );
            }
        }
    }
    elsif ( $dcty eq 'archives' ) {
        my @templates = MT::Template->load(
            {   blog_id => $blog->id,

                # FIXME: enumeration of types
                type =>
                    [ 'index', 'archive', 'individual', 'page', 'category' ],
            }
        );
        for my $tmpl (@templates) {
            my $bt = $tmpl->build_type || 0;
            next if $bt == MT::PublishOption::DISABLED();
            next if $bt == MT::PublishOption::MANUALLY();
            next if $bt == MT::PublishOption::SCHEDULED();

            $tmpl->build_type(
                $tmpl->type ne 'index'
                ? MT::PublishOption::DYNAMIC()
                : MT::PublishOption::ONDEMAND()
            );
            $tmpl->save();
        }
    }
    elsif ( $dcty eq 'all' ) {
        my @templates = MT::Template->load(
            {   blog_id => $blog->id,

                # FIXME: enumeration of types
                type =>
                    [ 'index', 'archive', 'individual', 'page', 'category' ],
            }
        );
        for my $tmpl (@templates) {
            my $bt = $tmpl->build_type || 0;
            next if $bt == MT::PublishOption::DISABLED();
            next if $bt == MT::PublishOption::MANUALLY();
            next if $bt == MT::PublishOption::SCHEDULED();

            $tmpl->build_type( MT::PublishOption::DYNAMIC() );
            $tmpl->save();
        }
    }
    return 1;
}

sub update_dynamicity {
    my $app = shift;
    my ($blog) = @_;

    my $mtview_path = File::Spec->catfile( $blog->site_path(), "mtview.php" );
    my $cache       = 0;
    my $conditional = 0;
    if ( -f $mtview_path ) {
        open my ($fh), $mtview_path;
        while ( my $line = <$fh> ) {
            $cache = 1
                if $line =~ m/^\s*\$mt->caching\(true\);/i;
            $conditional = 1
                if $line =~ /^\s*\$mt->conditional\(true\);/i;
        }
        close $fh;
    }

    $cache       = 1 if $app->param('dynamic_cache');
    $conditional = 1 if $app->param('dynamic_conditional');

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

        # dynamic publishing enabled
        prepare_dynamic_publishing( $app, $blog, $cache, $conditional,
            $blog->site_path, $blog->site_url );
        if ( $blog->archive_path ) {
            prepare_dynamic_publishing( $app, $blog, $cache, $conditional,
                $blog->archive_path, $blog->archive_url );
        }
        my $compiled_template_path
            = File::Spec->catfile( $blog->site_path(), 'templates_c' );
        if ( -d $compiled_template_path ) {
            $app->add_return_arg( 'no_writecache' => 1 )
                unless ( -w $compiled_template_path );
        }
        else {
            $app->add_return_arg( 'no_cachedir' => 1 )
                unless ( -d $compiled_template_path );
        }

        # FIXME: use FileMgr
        if ($cache) {
            my $cache_path
                = File::Spec->catfile( $blog->site_path(), 'cache' );
            if ( -d $cache_path ) {
                $app->add_return_arg( 'no_write_cache_path' => 1 )
                    unless ( -w $cache_path );
            }
            else {
                $app->add_return_arg( 'no_cache_path' => 1 )
                    unless ( -d $cache_path );
            }
        }
    }
}

sub _create_mtview {
    my ( $blog, $site_path, $cache, $conditional ) = @_;

    my $mtview_path = File::Spec->catfile( $site_path, "mtview.php" );
    eval {
        my $mv_contents = '';
        if ( -f $mtview_path ) {
            open( my $mv, "<$mtview_path" );
            while ( my $line = <$mv> ) {
                $mv_contents .= $line if ( $line !~ m!^//|<\?(?:php)?|\?>! );
            }
            close $mv;
        }
        my $cgi_path = MT->instance->server_path() || "";
        $cgi_path =~ s!/*$!!;
        my $mtphp_path = File::Spec->canonpath("$cgi_path/php/mt.php");
        my $blog_id    = $blog->id;
        my $config     = MT->instance->{cfg_file};
        my $cache_code = $cache ? "\n    \$mt->caching(true);" : '';
        my $conditional_code
            = $conditional ? "\n    \$mt->conditional(true);" : '';
        my $new_mtview = <<NEW_MTVIEW;

    include('$mtphp_path');
    \$mt = MT::get_instance($blog_id, '$config');$cache_code$conditional_code
    \$mt->view();
NEW_MTVIEW

        if ( $new_mtview ne substr( $mv_contents, 0, length($new_mtview) ) ) {
            $mv_contents =~ s!\n!\n//!gs;
            my $mtview = <<MTVIEW;
<?php
$new_mtview
$mv_contents
?>
MTVIEW

            $blog->file_mgr->mkpath($site_path);
            open( my $mv, ">$mtview_path" )
                || die "Couldn't open $mtview_path for appending";
            print $mv $mtview || die "Couldn't write to $mtview_path";
            close $mv;
        }
    };
    if ($@) { print STDERR $@; }
}

sub _create_dynamiccache_dir {
    my ( $blog, $site_path ) = @_;

    # FIXME: use FileMgr
    my $cache_path  = File::Spec->catfile( $site_path, 'cache' );
    my $fmgr        = $blog->file_mgr;
    my $saved_umask = MT->config->DirUmask;
    MT->config->DirUmask('0000');
    $fmgr->mkpath($cache_path);
    MT->config->DirUmask($saved_umask);
    my $message;

    if ( -d $cache_path ) {
        $message = MT->translate(
            'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.',
            'cache'
        ) unless ( -w $cache_path );
    }
    else {
        $message = MT->translate(
            'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.',
            'cache'
        ) unless ( -d $cache_path );
    }
    if ($message) {
        MT->log(
            {   message  => $message,
                level    => MT::Log::ERROR(),
                class    => 'system',
                category => 'cache',
            }
        );
    }
}

sub prepare_dynamic_publishing {
    my ( $cb, $blog, $cache, $conditional, $site_path, $site_url ) = @_;

    my $htaccess_path = File::Spec->catfile( $site_path, ".htaccess" );
    my $mtview_path   = File::Spec->catfile( $site_path, "mtview.php" );

    ## First, make template_c dir
    my $compiled_template_path
        = File::Spec->catfile( $site_path, 'templates_c' );
    unless ( -d $compiled_template_path ) {
        my $fmgr        = $blog->file_mgr;
        my $cfg         = MT->config;
        my $saved_umask = $cfg->DirUmask;
        $cfg->DirUmask('0000');
        $fmgr->mkpath($compiled_template_path);
        $cfg->DirUmask($saved_umask);
        my $message = q();

        if ( -d $compiled_template_path ) {
            $message = MT->translate(
                'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.',
                'templates_c'
            ) unless ( -w $compiled_template_path );
        }
        else {
            $message = MT->translate(
                'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.',
                'templates_c'
            ) unless ( -d $compiled_template_path );
        }
    }

    ## Don't re-create when files are there in callback.
    return 1
        if !defined($cache)
            && !defined($conditional)
            && ( 'MT::Callback' eq ref($cb) )
            && ( -f $htaccess_path )
            && ( -f $mtview_path );

    require URI;
    my $mtview_server_url = new URI($site_url);
    $mtview_server_url = $mtview_server_url->path();
    $mtview_server_url
        .= ( $mtview_server_url =~ m|/$| ? "" : "/" ) . "mtview.php";

    # IIS itself does not handle .htaccess,
    # but IISPassword (3rd party) does and dies with this.
    if ( $ENV{SERVER_SOFTWARE} =~ /Microsoft-IIS/
        && MT->config->EnableAutoRewriteOnIIS )
    {

    # On the IIS environment, will make/modify the web.config with URL Rewrite
        my $rule;
        $rule->{'stopProcessing'} = 'false';
        $rule->{'action'}         = {
            'url'               => $mtview_server_url . '{R:2}',
            'appendQueryString' => 'true',
            'type'              => 'Rewrite',
        };
        $rule->{'match'} = {
            'ignoreCase' => 'false',
            'url'        => '^(.*)(\\?.*)?$',
        };
        $rule->{'name'}       = "Rewrite rule for '$site_url'";
        $rule->{'conditions'} = {
            'add' => [
                {   'input'      => '{REQUEST_FILENAME}',
                    'ignoreCase' => 'false',
                    'negate'     => 'true',
                    'matchType'  => 'IsFile'
                }
            ],
            'logicalGrouping' => 'MatchAll',
        };

        require XML::Simple;
        my $web_config_path = File::Spec->catfile( $site_path, "web.config" );
        my $web_config;
        my $parser = XML::Simple->new;
        if ( -f $web_config_path ) {
            $web_config = $parser->XMLin( $web_config_path, keyattr => [] );
            my $ins = 1;
            my $rules;
            if ( exists $web_config->{'system.webServer'}->{'rewrite'} ) {
                $rules = $web_config->{'system.webServer'}->{'rewrite'}
                    ->{'rules'}->{'rule'};
                $rules = [$rules] unless ref $rules eq 'ARRAY';
                foreach my $rule (@$rules) {
                    my $rule_url = $rule->{action}->{url};
                    if ( $rule_url =~ /^$mtview_server_url/i ) {
                        $ins = 0;
                        last;
                    }
                }
            }
            if ($ins) {
                $web_config->{'system.webServer'}->{'rewrite'}->{'rules'}
                    ->{'clear'} = {};
                unshift @$rules, $rule;
            }
            $web_config->{'system.webServer'}->{'rewrite'}->{'rules'}
                ->{'rule'} = $rules;
        }
        else {
            $web_config->{'system.webServer'}
                = { 'rewrite' => { 'rules' => undef } };
            $web_config->{'system.webServer'}->{'rewrite'}->{'rules'}
                ->{'clear'} = {};
            $web_config->{'system.webServer'}->{'rewrite'}->{'rules'}
                ->{'rule'} = $rule;
        }

        my $out = $parser->XMLout(
            $web_config,
            RootName => undef,
            keyattr  => []
        );
        $out
            = '<?xml version="1.0" encoding="UTF-8"?>' . "\n"
            . "<configuration>\n"
            . $out
            . "</configuration>\n";

        my $fh;
        open( $fh, ">$web_config_path" )
            || die "Couldn't open $web_config_path for appending";
        print $fh $out;
        close $fh;
    }
    else {
        eval {
            my $contents = "";
            if ( open( HT, $htaccess_path ) ) {
                local $/ = undef;
                $contents = <HT>;
                close HT;
            }
            if ( $contents !~ /^\s*Rewrite(Cond|Engine|Rule)\b/m ) {
                my $htaccess = <<HTACCESS;

## %%%%%%% Movable Type generated this part; don't remove this line! %%%%%%%
# Disable fancy indexes, so mtview.php gets a chance...
Options -Indexes
  <IfModule mod_rewrite.c>
  # The mod_rewrite solution is the preferred way to invoke
  # dynamic pages, because of its flexibility.

  # Add mtview.php to the list of DirectoryIndex options, listing it last,
  # so it is invoked only if the common choices aren't present...
  <IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.htm default.htm default.html default.asp $mtview_server_url
  </IfModule>

  RewriteEngine on

  # don't serve mtview.php if the request is for a real directory
  # (allows the DirectoryIndex lookup to function)
  RewriteCond %{REQUEST_FILENAME} !-d

  # don't serve mtview.php if the request is for a real file
  # (allows the actual file to be served)
  RewriteCond %{REQUEST_FILENAME} !-f
  # anything else is handed to mtview.php for resolution
  # passthrough query parameters
  RewriteRule ^(.*)(\\?.*)\?\$ $mtview_server_url\$2 [L,QSA]
</IfModule>

<IfModule !mod_rewrite.c>
  # if mod_rewrite is unavailable, we forward any missing page
  # or unresolved directory index requests to mtview
  # if mtview.php can resolve the request, it returns a 200
  # result code which prevents any 4xx error code from going
  # to the server's access logs. However, an error will be
  # reported in the error log file. If this is your only choice,
  # and you want to suppress these messages, adding a "LogLevel crit"
  # directive within your VirtualHost or root configuration for
  # Apache will turn them off.
  ErrorDocument 404 $mtview_server_url
  ErrorDocument 403 $mtview_server_url
</IfModule>
## ******* Movable Type generated this part; don't remove this line! *******

HTACCESS

                $blog->file_mgr->mkpath($site_path);

                open( HT, ">>$htaccess_path" )
                    || die "Couldn't open $htaccess_path for appending";
                print HT $htaccess || die "Couldn't write to $htaccess_path";
                close HT;
            }
        };
        if ($@) { print STDERR $@; }
    }

    _create_mtview( $blog, $site_path, $cache, $conditional );

    if ($cache) {
        _create_dynamiccache_dir( $blog, $site_path );
    }
}

sub clone {
    my $app     = shift;
    my ($param) = {};
    my $user    = $app->user;

    $app->validate_magic() or return;

    my @id = $app->param('id');

    if ( !@id ) {
        return $app->error(
            $app->translate("No blog was selected to clone.") );
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
    return $app->error( $app->translate("This action cannot clone website.") )
        unless $blog->is_blog;

    return $app->permission_denied()
        unless $app->user->permissions( $blog->website->id )
            ->can_do('clone_blog');

    $param->{'id'}            = $blog->id;
    $param->{'new_blog_name'} = $app->param('new_blog_name')
        || $app->translate( 'Clone of [_1]', $blog->name );

    my $website = $blog->website;
    my ( $website_scheme, $website_domain )
        = $website->site_url =~ m!^(https?)://(.+)$!;
    $param->{website_scheme} = $website_scheme;
    $website_domain .= '/' if $website_domain !~ m!/$!;
    $param->{website_domain} = $website_domain;

    if ( $app->param('verify') || defined $app->param('clone') ) {
        $param->{enable_archive_paths}
            = defined $app->param('enable_archive_paths')
            ? $app->param('enable_archive_paths')
            : 0;

        my $base_path
            = defined $app->param('site_path')
            ? $app->param('site_path')
            : '';
        $base_path =~ s/\/$//;
        $param->{site_path} = $base_path;
        $param->{use_absolute}
            = defined $app->param('use_absolute')
            ? $app->param('use_absolute')
            : 0;
        $param->{site_path_absolute}
            = defined $app->param('site_path_absolute')
            ? $app->param('site_path_absolute')
            : '';

        $base_path
            = defined $app->param('archive_path')
            ? $app->param('archive_path')
            : '';
        $base_path =~ s/\/$//;
        $param->{archive_path} = $base_path;
        $param->{use_absolute_archive}
            = defined $app->param('use_absolute_archive')
            ? $app->param('use_absolute_archive')
            : 0;

        $param->{archive_path_absolute}
            = defined $app->param('archive_path_absolute')
            ? $app->param('archive_path_absolute')
            : '';

        my $base_url;
        if ( defined $app->param('site_url') ) {
            $param->{'site_url'} = $app->param('site_url');
        }
        elsif (defined( $app->param('site_url_subdomain') )
            || defined( $app->param('site_url_path') ) )
        {
            $param->{'site_url_subdomain'}
                = $app->param('site_url_subdomain');
            $param->{'site_url_path'} = $app->param('site_url_path');
        }
        else {
            $param->{'site_url'} = '';
            delete $param->{'site_url_subdomain'}
                if defined $param->{'site_url_subdomain'};
            delete $param->{'site_url_path'}
                if defined $param->{'site_url_path'};
        }
        $param->{'use_subdomain'}
            = defined $app->param('use_subdomain')
            ? $app->param('use_subdomain')
            : 0;
        if ( !$param->{'use_subdomain'} ) {
            delete $param->{'site_url_subdomain'}
                if defined $param->{'site_url_subdomain'};
        }

        if ( $param->{enable_archive_paths} ) {
            my $base_archive_url;
            if ( defined $app->param('archive_url') ) {
                $param->{'archive_url'} = $app->param('archive_url');
            }
            elsif (defined( $app->param('archive_url_subdomain') )
                || defined( $app->param('archive_url_path') ) )
            {
                $param->{'archive_url_subdomain'}
                    = $app->param('archive_url_subdomain');
                $param->{'archive_url_path'}
                    = $app->param('archive_url_path');
            }
            else {
                $param->{'archive_url'} = '';
                delete $param->{'archive_url_subdomain'}
                    if defined $param->{'archive_url_subdomain'};
                delete $param->{'archive_url_path'}
                    if defined $param->{'archive_url_path'};
            }
            $param->{'use_archive_subdomain'}
                = defined $app->param('use_archive_subdomain')
                ? $app->param('use_archive_subdomain')
                : 0;
            if ( !$param->{'use_archive_subdomain'} ) {
                delete $param->{'archive_url_subdomain'}
                    if defined $param->{'archive_url_subdomain'};
            }
        }
    }
    else {
        $param->{enable_archive_paths}
            = (    $blog->column('archive_path')
                || $blog->column('archive_url') )
            ? 1
            : 0;

        my $base_path = $blog->column('site_path') || dirify( $blog->name );
        $base_path =~ s/\/$//;
        $param->{site_path}    = $base_path;
        $param->{use_absolute} = $blog->is_site_path_absolute;
        $param->{site_path_absolute}
            = $blog->is_site_path_absolute
            ? $blog->column('site_path')
            : $website->site_path;

        $base_path = $blog->column('archive_path') || '';
        $base_path =~ s/\/$//;
        $param->{archive_path}         = $base_path;
        $param->{use_absolute_archive} = $blog->is_archive_path_absolute;
        $param->{archive_path_absolute}
            = $blog->is_archive_path_absolute
            ? $blog->column('archive_path')
            : $website->site_path;

        my $base_url;
        my @raw_site_url = $blog->raw_site_url;
        if ( 2 == @raw_site_url ) {
            my $subdomain = $raw_site_url[0];
            $subdomain =~ s/\.$//;
            $base_url                    = $blog->site_url;
            $param->{site_url_subdomain} = $subdomain;
            $param->{site_url_path}      = $raw_site_url[1];
        }
        else {
            $base_url = $raw_site_url[0];
        }
        $param->{site_url} = $base_url;
        $param->{'use_subdomain'} = defined $param->{site_url_subdomain};

        if ( $param->{enable_archive_paths} ) {
            my $base_archive_url;
            my @raw_archive_url = $blog->raw_archive_url;
            if ( 2 == @raw_archive_url ) {
                my $subdomain = $raw_archive_url[0];
                $subdomain =~ s/\.$//;
                $base_archive_url               = $blog->archive_url;
                $param->{archive_url_subdomain} = $subdomain;
                $param->{archive_url_path}      = $raw_archive_url[1];
            }
            else {
                $base_archive_url = $raw_archive_url[0];
            }

            $param->{archive_url} = $base_archive_url;
            $param->{'use_archive_subdomain'}
                = defined $param->{archive_url_subdomain};
        }
    }

    require File::Spec;
    $param->{parent_id} = $website->id;
    $param->{parent_path}
        = File::Spec->catfile( $website->site_path ) . MT::Util->dir_separator
        if $website->site_path;
    $param->{blog_id} = $app->param('blog_id');

    for my $key ( $app->param ) {
        if ( $key =~ /^clone_prefs/ ) {
            if ( $app->param($key) ) {
                $param->{$key} = $app->param($key);
            }
        }
    }
    if ( my $limit = $app->config->BaseSitePath ) {
        $param->{'sitepath_limited'} = $limit;
        $limit = File::Spec->catdir( $limit, "PATH" );
        $limit =~ s/PATH$//;
        $param->{'sitepath_limited_trail'} = $limit;
        $param->{'use_absolute'}           = 0;
        $param->{'use_absolute_archive'}   = 0;
    }
    $param = _has_valid_form( $app, $blog, $param );

    if ( $blog_id && $app->param('clone') && $param->{'isValidForm'} ) {
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
    my ( $blog, $param ) = @_;

    if ((      !$param->{'clone_prefs_comments'}
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
    my ( $blog, $param ) = @_;
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

    my $blog_name        = $param->{'new_blog_name'};
    my $blog_name_encode = MT::Util::encode_html($blog_name);

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

    $app->print_encode(
        $app->build_page(
            'dialog/header.tmpl',
            {   page_title => $app->translate("Clone Blog"),
                html_head  => $html_head
            }
        )
    );
    $app->print_encode( $app->translate_templatized(<<"HTML") );
<h2><__trans phrase="Cloning blog '[_1]'..." params="$blog_name_encode"></h2>

<div class="modal_width" id="dialog-clone-weblog">

<div id="clone-process" class="process-msg">
<ul>
HTML

    my $new_blog;
    eval {
        $new_blog = $blog->clone(
            {   BlogName => ($blog_name),
                Children => 1,
                Except   => ( { site_path => 1, site_url => 1 } ),
                Callback => sub { _progress( $app, @_ ) },
                Classes  => ($cloning_prefs)
            }
        );

        $new_blog->site_path(
              $param->{'use_absolute'} && !$app->config->BaseSitePath
            ? $param->{'site_path_absolute'}
            : $param->{'site_path'}
        );
        my $subdomain = $app->param('site_url_subdomain');
        $subdomain = '' if !$app->param('use_subdomain');
        $subdomain .= '.' if $subdomain && $subdomain !~ /\.$/;
        $subdomain =~ s/\.{2,}/\./g;
        my $path = $app->param('site_url_path');
        if ( $subdomain || $path ) {
            $new_blog->site_url("$subdomain/::/$path");
        }
        else {
            $new_blog->site_url( $param->{'site_url'} );
        }

        if ( $param->{enable_archive_paths} ) {
            $new_blog->archive_path(
                $param->{'use_absolute_archive'}
                    && !$app->config->BaseSitePath
                ? $param->{'archive_path_absolute'}
                : $param->{'archive_path'}
            );
            my $subdomain = $app->param('archive_url_subdomain');
            $subdomain = '' if !$app->param('use_archive_subdomain');
            $subdomain .= '.' if $subdomain && $subdomain !~ /\.$/;
            $subdomain =~ s/\.{2,}/\./g;
            my $path = $app->param('archive_url_path');
            if ( $subdomain || $path ) {
                $new_blog->archive_url("$subdomain/::/$path");
            }
            else {
                $new_blog->archive_url( $param->{'site_url'} );
            }
        }

        $new_blog->save();

        my $website = $app->model('website')->load( $param->{'parent_id'} );
        $website->add_blog($new_blog);
    };
    if ( my $err = $@ ) {
        $app->print_encode(
            $app->translate_templatized(
                qq{<p class="error-message"><__trans phrase="Error">: $err</p>}
            )
        );
    }
    else {
        my $return_url = $app->base
            . $app->uri(
            mode => 'list',
            args => {
                '_type' => 'blog',
                blog_id => ( $app->blog ? $new_blog->website->id : 0 )
            }
            );
        my $setting_url = $app->uri(
            mode => 'view',
            args => {
                blog_id => $new_blog->id,
                _type   => 'blog',
                id      => $new_blog->id
            }
        );

        $app->print_encode( $app->translate_templatized(<<"HTML") );
</ul>
</div>

<p><strong><__trans phrase="Finished!"></strong></p>

<form method="GET">
    <div class="actions-bar">
        <button
            type="submit"
            accesskey="x"
            class="close action primary button mt-close-dialog-url"
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

    $app->print_encode( $app->build_page('dialog/footer.tmpl') );
}

sub _progress {
    my $app = shift;
    my $ids = $app->request('progress_ids') || {};

    my ( $str, $id ) = @_;
    if ( $id && $ids->{$id} ) {
        require MT::Util;
        my $str_js = MT::Util::encode_js($str);
        $app->print_encode(
            qq{<script type="text/javascript">progress('$str_js', '$id');</script>\n}
        );
    }
    elsif ($id) {
        $ids->{$id} = 1;
        $app->print_encode(qq{<li id="$id">$str</li>\n});
    }
    else {
        $app->print_encode("<li>$str</li>");
    }

    $app->request( 'progress_ids', $ids );
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $terms = $load_options->{terms};
    $terms->{parent_id} = $load_options->{blog_id}
        if $app->blog;
    $terms->{class} = 'blog';

    my $user = $app->user;
    return   if $user->is_superuser;
    return 1 if $user->permissions(0)->can_do('edit_templates');

    my $iter = MT::Permission->load_iter(
        {   author_id   => $user->id,
            blog_id     => { not => 0 },
            permissions => { not => 'comment' },
        }
    );

    my $blog_ids;
    while ( my $perm = $iter->() ) {
        my $blog = $perm->blog;
        push @$blog_ids, $perm->blog_id
            if $blog && $blog->class eq 'blog';
    }
    if ($blog_ids) {
        $terms->{id} = $blog_ids;
    }
    else {
        $terms->{id} = 0;
    }
    $load_options->{terms} = $terms;
}

sub can_view_blog_list {
    my $app = shift;

    return 1 if $app->user->is_superuser;
    return 1 if $app->user->permissions(0)->can_do('edit_templates');

    my $blog = $app->blog;
    my $blog_ids
        = !$blog         ? undef
        : $blog->is_blog ? [ $blog->id ]
        : $blog->has_blog ? [ map { $_->id } @{ $blog->blogs } ]
        :                   undef;

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {   author_id => $app->user->id,
            (   $blog_ids
                ? ( blog_id => $blog_ids )
                : ( blog_id => { not => 0 } )
            ),
            permissions => { not => 'comment' },
        }
    );

    my $cond;
    while ( my $p = $iter->() ) {
        $cond = 1, last
            if $p->blog->is_blog;
    }
    return $cond ? 1 : 0;
}

1;
