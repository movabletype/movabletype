# Movable Type (r) (C) 2001-2019 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Blog;

use strict;
use warnings;
use MT::Util qw( dirify dir_separator );

sub edit {
    my $cb = shift;
    my ( $app, $id, $obj, $param ) = @_;

    my $cfg     = $app->config;
    my $blog    = $obj || $app->blog;
    my $blog_id = $id;

    my $lang;
    if ($id) {
        my $output = $param->{output} ||= 'cfg_prefs.tmpl';
        $param->{need_full_rebuild} = 1 if $app->param('need_full_rebuild');
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
        $lang = $obj->language || 'en';
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
                next if $cmtauth_reg->{$auth}->{disable};

                $c = $app->handler_to_coderef($c);
                if ($c) {
                    my $reason;
                    $cmtauth{$auth}->{disabled} = 1
                        unless $c->( $blog, \$reason );
                    $cmtauth{$auth}->{disabled_reason} = $reason if $reason;
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
            if ( $cmtauth{$_}{disable} ) {
                next unless $cmtauth{$_}{enabled};
                $cmtauth{$_}{disabled} = 1;
            }
            $cmtauth{$_}->{key} = $_;
            $cmtauth{$_}->{order} ||= 0;
            if ( UNIVERSAL::isa( $cmtauth{$_}->{plugin}, 'MT::Plugin' ) ) {

                # force plugin auth schemes to show after native auth schemes
                $cmtauth{$_}{order} = $cmtauth{$_}{order} + 100;
            }
            push @cmtauth_loop, $cmtauth{$_};
        }
        @cmtauth_loop = sort { $a->{order} <=> $b->{order} } @cmtauth_loop;

        $param->{cmtauth_loop} = \@cmtauth_loop;

        if ( $output eq 'cfg_prefs.tmpl' ) {
            if ( $obj->is_blog ) {
                $app->add_breadcrumb( $app->translate('General Settings') );
            }

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
            $param->{'max_revisions_cd'}
                = ( $obj->max_revisions_cd || $MT::Revisable::MAX_REVISIONS );
            $param->{'max_revisions_template'}
                = (    $obj->max_revisions_template
                    || $MT::Revisable::MAX_REVISIONS );
            $param->{publish_empty_archive} = $obj->publish_empty_archive;

            # Default options for upload
            $param->{'upload_destination'} = $obj->upload_destination;
            $param->{'extra_path'}         = $obj->extra_path;
            $param->{'allow_to_change_at_upload'}
                = defined $obj->allow_to_change_at_upload
                ? $obj->allow_to_change_at_upload
                : 1;
            $param->{'operation_if_exists'} = $obj->operation_if_exists;
            $param->{'normalize_orientation'}
                = defined $obj->normalize_orientation
                ? $obj->normalize_orientation
                : 1;
            $param->{'auto_rename_non_ascii'}
                = defined $obj->auto_rename_non_ascii
                ? $obj->auto_rename_non_ascii
                : 1;

            require MT::CMS::Asset;
            my @dest_root
                = MT::CMS::Asset::_make_upload_destinations( $app, $obj );
            $param->{destination_loop} = \@dest_root;
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

            $param->{popup}      = $blog->image_default_popup ? 1 : 0;
            $param->{make_thumb} = $blog->image_default_thumb ? 1 : 0;
            $param->{ 'align_' . ( $blog->image_default_align || 'none' ) }
                = 1;
            $param->{thumb_width} = $blog->image_default_width || 0;

            $app->add_breadcrumb( $app->translate('Compose Settings') );
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

            $param->{enable_data_api} = data_api_is_enabled( $app, $blog_id );

            if ( $cfg->is_readonly('DataAPIDisableSite') ) {
                $param->{'data_api_disable_site_readonly'} = 1;
                $param->{config_warning} = $app->translate(
                    "These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.",
                    'DataAPIDisableSite',
                );
            }
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

            $app->add_breadcrumb( $app->translate('Feedback Settings') );
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
        elsif ( $output eq 'cfg_registration.tmpl' ) {
            $app->add_breadcrumb( $app->translate('Registration Settings') );
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
    elsif ( $param->{output} && $param->{output} eq 'cfg_web_services.tmpl' )
    {
        # System level web services settings.
        $param->{enable_data_api} = data_api_is_enabled( $app, $blog_id );
        if ( $app->config->is_readonly('DataAPIDisableSite') ) {
            $param->{'data_api_disable_site_readonly'} = 1;
            $param->{config_warning} = $app->translate(
                "These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.",
                'DataAPIDisableSite',
            );
        }
    }
    else {
        return $app->return_to_dashboard( redirect => 1 )
            if !$blog || ( $blog && $blog->is_blog() );

        $app->add_breadcrumb(
            $app->translate('Child Sites'),
            $app->uri(
                mode => 'list',
                args => {
                    _type   => 'blog',
                    blog_id => $blog->id,
                },
            ),
        );
        $app->add_breadcrumb( $app->translate('Create Child Site') );
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

    if ( !$param->{site_path} ) {
        $param->{suggested_site_path} = 'SITE-NAME';
    }

    if ( !$param->{site_url_path} ) {
        $param->{suggested_site_url} = 'SITE-NAME';
    }
    if ( !$param->{id} ) {
        if ( $param->{site_url_path} ) {
            $param->{site_url_path} .= '/'
                unless $param->{site_url_path} =~ /\/$/;
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

    if ($blog) {
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
    my $blog_id = $app->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 ) unless $blog_id;

    return $app->permission_denied()
        unless $app->can_do('access_to_blog_config_screen');

    my $blog = $app->model('blog')->load($blog_id)
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $blog_id ) );

    my @data;
    my $preferred_archive_type = $app->param('preferred_archive_type') || '';
    for my $at ( split /\s*,\s*/, $blog->archive_type ) {
        my $archiver = $app->publisher->archiver($at);
        next unless $archiver;
        next if 'entry' ne $archiver->entry_class;
        next if ( $at =~ /^ContentType/ );
        my $archive_label = $archiver->archive_label;
        $archive_label = $at unless $archive_label;
        $archive_label = $archive_label->()
            if ( ref $archive_label ) eq 'CODE';
        my $row = {
            archive_type_translated => $archive_label,
            archive_type            => $at,
            archive_type_is_preferred =>
                ( $blog->archive_type_preferred eq $at ? 1 : 0 ),
        };

        if ( $preferred_archive_type eq $at ) {
            $row->{archive_type_is_preferred} = 1;
        }
        elsif ( $blog->archive_type_preferred eq $at ) {
            $row->{archive_type_is_preferred} = 1;
        }
        push @data, $row;
    }
    @data = sort { MT::App::CMS::archive_type_sorter( $a, $b ) } @data;
    unless ( grep $_->{archive_type_is_preferred}, @data ) {
        $param{no_preferred_archive_type} = 1;
    }
    $param{entry_archive_types} = \@data;

    $param{saved_deleted}    = 1 if $app->param('saved_deleted');
    $param{saved_added}      = 1 if $app->param('saved_added');
    $param{archives_changed} = 1 if $app->param('archives_changed');
    $param{no_writedir}      = $app->param('no_writedir');
    $param{no_cachedir}      = $app->param('no_cachedir');
    $param{no_writecache}    = $app->param('no_writecache');
    $param{include_system} = $blog->include_system || '';

    my $mtview_path = File::Spec->catfile( $blog->site_path(), "mtview.php" );

    if ( -f $mtview_path ) {
        open my $fh, "<", $mtview_path
            or die "Couldn't open $mtview_path: $!";
        while ( my $line = <$fh> ) {
            $param{dynamic_caching} = 1
                if $line =~ m/^\s*\$mt->caching\(true\);/i;
            $param{dynamic_conditional} = 1
                if $line =~ /^\s*\$mt->conditional\(true\);/i;
        }
        close $fh;
    }
    $param{output} = 'cfg_prefs.tmpl';
    $app->param( '_type', $blog->class );
    $app->param( 'id',    $blog_id );
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

    # Set directory separator
    $param{dir_separator} = MT::Util::dir_separator;

    $app->forward( "view", \%param );
}

sub cfg_feedback {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog_id;
    return $app->permission_denied()
        unless $app->can_do('edit_config');
    $app->param( '_type', $app->blog ? $app->blog->class : 'blog' );
    $app->param( 'id', $blog_id );
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

    $app->param( '_type', $app->blog->class );
    $app->param( 'id',    $blog->id );
    $app->forward(
        "view",
        {   output => 'cfg_registration.tmpl',
            %param,
        }
    );
}

sub cfg_web_services {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');
    return $app->permission_denied()
        unless $app->can_do('edit_config');

    my @config_templates = ();
    my $web_services     = $app->registry('web_services');
    for my $k (%$web_services) {
        my $plugin = $web_services->{$k}{plugin};
        my $tmpl   = $web_services->{$k}{config_template}
            or next;

        if ( ref $tmpl eq 'HASH' ) {
            $tmpl = MT->handler_to_coderef( $tmpl->{code} );
        }

        push @config_templates,
            {
            tmpl => (
                  ref $tmpl eq 'CODE' ? $tmpl->( $plugin, @_ )
                : $plugin             ? $plugin->load_tmpl($tmpl)
                :                       $app->load_tmpl($tmpl)
            )
            };
    }

    $app->param( '_type', $app->blog ? $app->blog->class : 'blog' );
    $app->param( 'id', $blog_id );
    $app->forward(
        "view",
        {   output           => 'cfg_web_services.tmpl',
            screen_class     => 'settings-screen web-services-settings',
            config_templates => \@config_templates,
        }
    );
}

sub rebuild_phase {
    my $app  = shift;
    my $type = $app->param('_type') || 'entry';
    my @ids  = $app->multi_param('id');
    $app->{goback} = $app->return_uri;
    $app->{value} ||= $app->translate('Back');
    my %ids = map { $_ => 1 } @ids;
    if ( $type eq 'entry' ) {
        return $app->rebuild_these( \%ids );
    }
    elsif ( $type eq 'content_data' ) {
        return $app->rebuild_these_content_data( \%ids );
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
    my $start_time = $app->param('start_time');

    if ( !$start_time ) {

        # start of build; invoke callback
        $app->run_callbacks('pre_build');
        $start_time = time;
    }

    my $blog_id = int( $app->param('blog_id') || 0 );
    return $app->errtrans("Invalid request.") unless $blog_id;

    my $blog = MT::Blog->load($blog_id)
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $blog_id ) );

    # param('type') is used differently
    my $param_type = $app->param('type') || '';

    my $order = $param_type;
    my @order = split /,/, $order;
    my $next  = $app->param('next') || 0;
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
    my $total  = $app->param('total');

    my $with_indexes   = $app->param('with_indexes');
    my $no_static      = $app->param('no_static');
    my $template_id    = $app->param('template_id');
    my $map_id         = $app->param('templatemap_id');
    my $fs             = $app->param('fs');
    my $old_categories = $app->param('old_categories');
    my $old_previous   = $app->param('old_previous');
    my $old_next       = $app->param('old_next');
    my $entry_id       = $app->param('entry_id');
    my $is_new         = $app->param('is_new');
    my $old_status     = $app->param('old_status');
    my $return_args    = $app->param('return_args');

    my $content_type_id = $app->param('content_type_id');
    my $content_data_id = $app->param('content_data_id');

    my ($tmpl_saved);

    # Make sure errors go to a sensible place when in fs mode
    # TODO: create contin. earlier, pass it thru
    if ($fs) {
        my ( $type, $obj_id )
            = $param_type =~ m/(entry|content_data|index)-(\d+)/;
        if ( $type && $obj_id ) {
            my $edit_type = $type;
            $edit_type = 'template' if $type eq 'index';
            if ( $type eq 'entry' ) {
                require MT::Entry;
                my $entry = MT::Entry->load($obj_id);
                $edit_type = $entry ? $entry->class : 'entry';
            }
            if ( $type eq 'content_data' ) {
                require MT::ContentData;
                my $content_data = MT::ContentData->load($obj_id);
                $app->{goback} = $app->uri(
                    mode => 'view',
                    args => {
                        _type => 'content_data',
                        id    => $obj_id,
                        $content_data
                        ? ( blog_id => $content_data->blog_id )
                        : (),
                        content_type_id => $content_data->content_type_id,
                    },
                );
            }
            else {
                $app->{goback} = $app->object_edit_uri( $edit_type, $obj_id );
            }
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
            OldCategories     => $old_categories,
            OldPrevious       => $old_previous,
            OldNext           => $old_next
        ) or return $app->publish_error();
        $order = "entry '" . $entry->title . "'";
    }
    elsif ( $type =~ /^content_data-(\d+)$/ ) {
        my $content_data_id = $1;
        require MT::ContentData;
        my $content_data = MT::ContentData->load($content_data_id);
        return $app->permission_denied
            unless $perms->can_edit_content_data( $content_data, $app->user );
        $app->rebuild_content_data(
            ContentData       => $content_data,
            BuildDependencies => 1,
            OldCategories     => $old_categories,
            OldPrevious       => $old_previous,
            OldNext           => $old_next,
        ) or return $app->publish_error;
        $order = "content data (ID:" . $content_data->id . ")";
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

        $offset = $app->param('offset') || 0;
        my $start = time;
        my $count = 0;
        my $cb    = sub {
            my $result
                = time - $start > $app->config->RebuildOffsetSeconds ? 0 : 1;
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
            my $map;
            if ($template_id) {
                my $tmpl = MT->model('template')->load($template_id)
                    or return $app->errtrans( 'Cannot load template #[_1].',
                    $template_id );
                return $app->permission_denied()
                    unless $app->user->permissions( $tmpl->blog_id )
                    ->can_do('rebuild');
            }
            elsif ($map_id) {
                $map = MT->model('templatemap')->load($map_id)
                    or return $app->errtrans( 'Cannot load template #[_1].',
                    $map_id );
                return $app->permission_denied()
                    unless $app->user->permissions( $map->blog_id )
                    ->can_do('rebuild');
            }

            $offset = $app->param('offset') || 0;
            if ( $offset < $total ) {
                my $start = time;
                my $count = 0;
                my $cb    = sub {
                    my $result
                        = time - $start > $app->config->RebuildOffsetSeconds
                        ? 0
                        : 1;
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
                    $map ? ( TemplateMap => $map, Force => 1 )
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

    return if $app->param('no_rebuilding_tmpl');

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
                my $content_type_id = $app->param('content_type_id');
                $total = _determine_total( $archiver, $blog_id,
                    $content_type_id );
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
            entry_id        => $entry_id,
            content_type_id => $content_type_id,
            content_data_id => $content_data_id,
            dynamic         => $dynamic,
            is_new          => $is_new,
            old_status      => $old_status,
            is_full_screen  => $fs,
            with_indexes    => $with_indexes,
            no_static       => $no_static,
            template_id     => $template_id,
            return_args     => $return_args
        );
        $app->load_tmpl( 'rebuilding.tmpl', \%param );
    }
    else {
        $app->run_callbacks('post_build');
        if ($entry_id) {
            require MT::Entry;
            my $entry = MT::Entry->load($entry_id)
                or return $app->error(
                $app->translate( 'Cannot load entry #[_1].', $entry_id ) );
            require MT::Blog;
            my $blog = MT::Blog->load( $entry->blog_id )
                or return $app->error(
                $app->translate( 'Cannot load blog #[_1].', $entry->blog_id )
                );
            if ( MT->has_plugin('Trackback') ) {
                require Trackback::CMS::Entry;
                Trackback::CMS::Entry::ping_continuation(
                    $app,
                    $entry, $blog,
                    OldStatus => $old_status,
                    IsNew     => $is_new,
                );
            }
            else {
                require MT::CMS::Entry;
                MT::CMS::Entry::_finish_rebuild( $app, $entry, $is_new );
            }
        }
        elsif ($content_data_id) {
            require MT::ContentData;
            my $content_data = MT::ContentData->load($content_data_id)
                or return $app->errtrans( 'Cannot load content data #[_1].',
                $content_data_id );
            require MT::Blog;
            my $blog = MT::Blog->load( $content_data->blog_id )
                or return $app->errtrans( 'Cannot load blog #[_1].',
                $content_data->blog_id );
            return $app->redirect(
                $app->uri(
                    mode => 'view',
                    args => {
                        blog_id         => $blog->id,
                        content_type_id => $content_data->content_type_id,
                        _type           => 'content_data',
                        type            => 'content_data_'
                            . $content_data->content_type_id,
                        id => $content_data->id,
                        $is_new
                        ? ( saved_added => 1 )
                        : ( saved_changes => 1 ),
                    }
                )
            );
        }
        else {
            my $all             = $order =~ /,/;
            my $type            = $order;
            my $is_one_index    = $order =~ /index template/;
            my $is_entry        = $order =~ /entry/;
            my $is_content_data = $order =~ /content data/;
            my $built_type;
            if ( $is_entry || $is_content_data || $is_one_index ) {
                ( $built_type = $type )
                    =~ s/^(entry|content data|index template)/$app->translate($1)/e;
            }
            else {
                $built_type = $app->translate($type);
            }
            my %param = (
                all             => $all,
                type            => $archive_label,
                is_one_index    => $is_one_index,
                is_entry        => $is_entry,
                is_content_data => $is_content_data,
                archives        => $type ne 'index',
                start_timestamp => MT::Util::epoch2ts( $blog, $start_time ),
                total_time      => time - $start_time,
            );
            if ($is_one_index) {
                $param{tmpl_url} = $blog->site_url;
                $param{tmpl_url} .= '/' if $param{tmpl_url} !~ m!/$!;
                $param{tmpl_url} .= $tmpl_saved->outfile;
            }
            if ($fs) {    # full screen--go to a useful app page
                if ($return_args) {
                    $app->call_return;
                }
                else {
                    my $type = $param_type;
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

    if ( ( $app->param('_type') || '' ) eq 'content_data' ) {
        require MT::CMS::ContentData;
        MT::CMS::ContentData::publish_content_data($app);
    }
    else {
        require MT::CMS::Entry;
        MT::CMS::Entry::publish_entries($app);
    }
}

sub start_rebuild_pages {
    my $app        = shift;
    my $start_time = $app->param('start_time');

    if ( !$start_time ) {

        # start of build; invoke callback
        $app->run_callbacks('pre_build');
        $start_time = time;
    }

    my $type = $app->param('type') || '';
    my $next = $app->param('next') || 0;
    my @order = split /,/, $type;
    my $total         = $app->param('total') || 0;
    my $type_name     = $order[$next];
    my $archiver      = $app->publisher->archiver($type_name);
    my $archive_label = $archiver ? $archiver->archive_label : '';
    $archive_label = $app->translate($type_name) unless $archive_label;
    $archive_label = $archive_label->() if ( ref $archive_label ) eq 'CODE';
    my $blog_id = $app->param('blog_id');

    my $with_indexes    = $app->param('with_indexes');
    my $no_static       = $app->param('no_static');
    my $template_id     = $app->param('template_id');
    my $content_type_id = $app->param('content_type_id');

    if ($archiver) {
        $total = _determine_total( $archiver, $blog_id, $content_type_id );
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
        return_args     => $app->return_args,
        ( $content_type_id ? ( content_type_id => $content_type_id ) : () ),
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
        $param{is_content} = 1;
        $param{is_entry}   = 1;
        $param{entry_id}   = $entry_id;
        for my $col (
            qw( is_new old_status old_next old_previous old_categories ))
        {
            $param{$col} = $app->param($col);
        }
    }
    elsif ( $type_name =~ /^content_data-(\d+)$/ ) {
        my $content_data_id = $1;
        require MT::ContentData;
        my $content_data = MT::ContentData->load($content_data_id)
            or return $app->errtrans( 'Cannot load content data #[_1].',
            $content_data_id );
        $param{build_type_name} = $app->translate(
            "[_1] (ID:[_2])",
            $content_data->content_type->name || $app->translate('(no name)'),
            $content_data->id,
        );
        $param{is_content}      = 1;
        $param{is_content_data} = 1;
        $param{content_data_id} = $content_data_id;
        $param{content_type_id} = $content_data->content_type_id;

        for my $col (
            qw( is_new old_status old_next old_previous old_categories ))
        {
            $param{$col} = $app->param($col);
        }
    }
    $param{is_full_screen}
        = $param{is_content}
        || $param{is_content_data}
        || $app->param('single_template');
    $param{page_titles} = [ { bc_name => 'Rebuilding' } ];
    if ( $app->param('no_rebuilding_tmpl') ) {
        $app->param( 'total', $total );
        MT::CMS::Blog::rebuild_pages($app);
    }
    else {
        $app->load_tmpl( 'rebuilding.tmpl', \%param );
    }
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

sub dialog_select_weblog {
    my $app = shift;

    my $favorites = $app->param('select_favorites');
    my $confirm_js;
    my $terms = {};
    my $args  = {};
    my $auth  = $app->user or return;

    if ($favorites) {

        # Do not exclude top 5 favorite blogs from
        #   select blog dialog list. bugid:112372
        $confirm_js = 'saveFavorite';
    }
    if (   !$auth->is_superuser
        && !$auth->permissions(0)->can_do('access_to_blog_list')
        && !$auth->permissions(0)->can_do('edit_templates') )
    {
        use MT::Permission;
        $args->{join} = MT::Permission->join_on( 'blog_id',
            { author_id => $auth->id, permissions => { not => "'comment'" } }
        );
    }
    $terms->{class}     = 'blog';
    $terms->{parent_id} = $app->blog->id
        if $app->blog && !$app->blog->is_blog;

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        $row->{label} = $row->{name};
        $row->{'link'} = $obj->site_url;
    };

    $app->listing(
        {   type     => 'blog',
            code     => $hasher,
            template => $app->param('json') ? 'include/listing_panel.tmpl'
            : 'dialog/select_weblog.tmpl',
            terms  => $terms,
            args   => $args,
            params => {
                dialog_title  => $app->translate("Select Child Site"),
                items_prompt  => $app->translate("Selected Child Site"),
                search_prompt => $app->translate(
                    "Enter a site name to filter the choices below."),
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
            || ( $app->isa('MT::App::CMS')
            && $app->param('cfg_screen')
            && $app->param('cfg_screen') eq 'cfg_publish_profile' );
    }
    else {
        return $app->can_do('create_site');
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
    my $overlay = $app->param('overlay');
    my $screen = $app->param('cfg_screen') || '';

    if ( !$overlay && $screen ) {

        # Checkbox options have to be blanked if they aren't passed.
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
                require_comment_emails allow_unreg_comments );
        }
        elsif ( $screen eq 'cfg_entry' ) {
            @fields = qw( allow_comments_default
                allow_pings_default image_default_thumb image_default_popup );
        }
        elsif ( $screen eq 'cfg_plugins' ) {
        }
        elsif ( $screen eq 'cfg_prefs' ) {
            @fields
                = qw( use_revision allow_to_change_at_upload normalize_orientation auto_rename_non_ascii );
        }
        for my $cb (@fields) {
            unless ( defined $app->param($cb) ) {

    # two possibilities: user unchecked the option, or user was not allowed to
    # set the value (and therefore there was no field to submit).
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
            my $allow_comments    = $app->param('allow_comments');
            my $moderate_comments = $app->param('moderate_comments');
            my $nofollow_urls     = $app->param('nofollow_urls');
            my $follow_auth_links = $app->param('follow_auth_links');
            my $captcha_provider  = $app->param('captcha_provider');
            if ($allow_comments) {
                $obj->allow_reg_comments(1);
            }
            else {
                $obj->allow_unreg_comments(0);
                $obj->allow_reg_comments(0);
            }
            $obj->moderate_unreg_comments($moderate_comments);
            $obj->nofollow_urls( $nofollow_urls         ? 1 : 0 );
            $obj->follow_auth_links( $follow_auth_links ? 1 : 0 );
            my $cp_old = $obj->captcha_provider;
            $obj->captcha_provider($captcha_provider);
            my $rebuild = $cp_old ne $obj->captcha_provider ? 1 : 0;
            $app->add_return_arg( need_full_rebuild => 1 ) if $rebuild;

            if ( my $pings = $app->param('allow_pings') ) {
                if ($pings) {
                    my $moderate_pings = $app->param('moderate_pings');
                    $obj->moderate_pings($moderate_pings);
                    $obj->nofollow_urls( $nofollow_urls ? 1 : 0 );
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
            push @pings_list, $_
                foreach grep { scalar $app->param( 'ping_' . $_ ) }
                keys %$ping_servers;
            $obj->update_pings( join( ',', @pings_list ) );
        }
        if ( $screen eq 'cfg_registration' ) {
            my $allow_commenter_regist
                = $app->param('allow_commenter_regist');
            my $allow_unreg_comments = $app->param('allow_unreg_comments');
            my $require_comment_emails
                = $app->param('require_comment_emails');
            $obj->allow_commenter_regist($allow_commenter_regist);
            $obj->allow_unreg_comments($allow_unreg_comments);
            if ($allow_unreg_comments) {
                $obj->require_comment_emails($require_comment_emails);
            }
            else {
                $obj->require_comment_emails(0);
            }
            my @authenticators;
            for my $param ( $app->multi_param ) {
                if ( $param =~ /^enabled_(.*)$/ ) {
                    push @authenticators, $1;
                }
            }
            my $c_old = $obj->commenter_authenticators;
            $obj->commenter_authenticators( join( ',', @authenticators ) );
            my $rebuild = $obj->commenter_authenticators ne $c_old ? 1 : 0;
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

            my $days_or_posts = $app->param('days_or_posts') || '';
            my $list_on_index = $app->param('list_on_index');
            if ( $days_or_posts eq 'days' ) {
                $obj->days_on_index($list_on_index);
                $obj->entries_on_index(0);
            }
            else {
                $obj->entries_on_index($list_on_index);
                $obj->days_on_index(0);
            }
            $obj->basename_limit(15)
                if $obj->basename_limit < 15;    # 15 is the *minimum*
            $obj->basename_limit(250)
                if $obj->basename_limit > 250;    # 15 is the *maximum*

            my $image_default_thumb = $app->param('image_default_thumb');
            my $image_default_width = $app->param('image_default_width');
            my $image_default_align = $app->param('image_default_align');
            my $image_default_popup = $app->param('image_default_popup');
            $obj->image_default_thumb( $image_default_thumb ? 1 : 0 );
            $obj->image_default_width($image_default_width);
            $obj->image_default_align($image_default_align);
            $obj->image_default_popup( $image_default_popup ? 1 : 0 );
        }
        if ( $screen eq 'cfg_prefs' ) {
            my $include_system = $app->param('include_system') || '';
            $obj->include_system($include_system);
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

    # Set parent site ID
    my $blog_id = $app->param('blog_id');
    if ( !$obj->id and $obj->class eq 'blog' ) {
        $obj->parent_id($blog_id);
    }

    # assumation: if the it is a blog and its site path is relative, then
    # it is probably writeable.
    if (    ( !$obj->id or $screen eq 'cfg_prefs' )
        and ( $obj->class ne 'blog' or $obj->is_site_path_absolute() ) )
    {
        my $site_path = $obj->site_path;
        my $fmgr      = $obj->file_mgr;
        unless ( $fmgr->exists($site_path) ) {
            my @dirs = File::Spec->splitdir($site_path);
            pop @dirs;
            $site_path = File::Spec->catdir(@dirs);
        }
        return $app->errtrans(
            "The '[_1]' provided below is not writable by the web server. Change the directory ownership or permissions and try again.",
            $obj->class eq 'blog'
            ? $app->translate('Blog Root')
            : $app->translate('Website Root')
            )
            unless $fmgr->exists($site_path) && $fmgr->can_write($site_path);
    }

    if ( ( $obj->sanitize_spec || '' ) eq '1' ) {
        my $sanitize_spec_manual = $app->param('sanitize_spec_manual');
        $obj->sanitize_spec($sanitize_spec_manual);
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

sub _post_save_cfg_screens {
    my ( $app, $obj, $original ) = @_;

    my $screen = $app->param('cfg_screen') || '';
    if ( $screen eq 'cfg_publish_profile' ) {
        if ( my $dcty = $app->param('dynamicity') ) {

# Apply publishing rules for templates based on
# publishing method selected:
#     none (0% publish queue, all static)
#     async_all (100% publish queue)
#     async_partial (high-priority templates publish synchronously (main index, preferred entry_based/contenttype_based archives, feed templates))
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

            # MTC-26415
            # $app->rebuild( BlogID => $obj->id, NoStatic => 1 )
            #     or $app->publish_error();
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
    if ( $screen eq 'cfg_web_services' ) {
        save_data_api_settings($app);
    }

    return 1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    my $perms = $app->permissions
        or return 1;
    return 1
        unless $app->user->is_superuser
        || $perms->can_do('create_site')
        || $perms->can_edit_config;

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

        my $old
            = defined $original->$blog_field()
            ? $original->$blog_field()
            : "";
        my $new = defined $obj->$blog_field() ? $obj->$blog_field() : "";
        if ( $new ne $old ) {
            $old = "none" if $old eq "";
            $new = "none" if $new eq "";
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

    if ( $app->isa('MT::App::CMS') ) {
        _post_save_cfg_screens( $app, $obj, $original ) or return;
    }
    elsif ( $app->isa('MT::App::DataAPI') ) {

        # Use eval here because decreasing dependency on Data API.
        if ( eval { require MT::DataAPI::Callback::Blog; 1 } ) {
            MT::DataAPI::Callback::Blog::post_save( $eh, $app, $obj,
                $original )
                or return;
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
        my @roles = $role_class->load_by_permission("administer_site");
        foreach my $r (@roles) {
            $role = $r;
            last;
        }
        $assoc_class->link( $auth => $role => $obj );

        if ( $obj->is_blog ) {
            my $website = $app->blog;
            $website->add_blog($obj);
        }

        # permission granted - need to update commenting cookie
        my %cookies = $app->cookies();
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
        if ( $app->isa('MT::App::CMS') ) {
            if (grep {
                    ( $original->column($_) || '' ) ne
                        ( $obj->column($_)  || '' )
                } qw(allow_unreg_comments allow_reg_comments remote_auth_token
                allow_pings          allow_comment_html )
                )
            {
                $app->add_return_arg( need_full_rebuild => 1 );
            }
        }

        my $original_set = $original->template_set;
        $original_set = $original->theme_id if ref $original_set;
        my $obj_set = $obj->template_set;
        $obj_set = $obj->theme_id if ref $obj_set;
        if ( ( $original_set || '' ) ne ( $obj_set || '' ) ) {
            $app->run_callbacks( 'blog_template_set_change',
                { blog => $obj } );
            $app->add_return_arg( need_full_rebuild => 1 )
                if $app->isa('MT::App::CMS');
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
    my $screen = $app->param('cfg_screen') || '';
    return $eh->error( MT->translate("You did not specify a blog name.") )
        if ( !( $screen && $app->can_do('edit_blog_config') )
        && ( defined $name && $name eq '' ) );

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
        for my $param_name (
            qw( max_revisions_entry max_revisions_cd max_revisions_template ))
        {
            my $value = $app->param($param_name) || 0;
            return $eh->error(
                MT->translate(
                    "The number of revisions to store must be a positive integer."
                )
            ) unless 0 < sprintf( '%d', $value );
        }
        return $eh->error(
            MT->translate("Please choose a preferred archive type.") )
            if ( !$app->param('no_archives_are_active')
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

sub build_blog_table {
    my $app = shift;
    my (%args) = @_;

    my $blog_class  = $app->model('blog');
    my $entry_class = $app->model('entry');
    my $page_class  = $app->model('page');

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
                && ( $author->is_superuser
                || $author->permissions( $website->id ) );
        }

        if ( $app->mode ne 'dialog_select_weblog' ) {

            # we should use count by group here...
            $row->{num_entries}
                = $entry_class->count( { blog_id => $blog_id } ) || 0;
            $row->{num_pages}
                = $page_class->count( { blog_id => $blog_id } ) || 0;
            $row->{num_authors} = 0;
            if ( $author->is_superuser ) {
                $row->{can_create_post}       = 1;
                $row->{can_edit_entries}      = 1;
                $row->{can_edit_pages}        = 1;
                $row->{can_edit_templates}    = 1;
                $row->{can_edit_config}       = 1;
                $row->{can_set_publish_paths} = 1;
                $row->{can_administer_site}   = 1;
            }
            else {
                my $perms = $author->permissions($blog_id);
                $row->{can_create_post}    = $perms->can_do('create_post');
                $row->{can_edit_entries}   = $perms->can_do('create_post');
                $row->{can_edit_pages}     = $perms->can_do('manage_pages');
                $row->{can_edit_templates} = $perms->can_do('edit_templates');
                $row->{can_edit_config}    = $perms->can_do('edit_config');
                $row->{can_set_publish_paths}
                    = $perms->can_do('set_publish_paths');
                $row->{can_administer_site}
                    = $perms->can_do('administer_site');
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
    my $app     = shift;
    my $blog_id = $app->param('blog_id');
    $app->param( '_type', 'blog' );
    $app->param( 'id',    $blog_id );
    $app->forward( "view", { output => 'cfg_prefs.tmpl' } );
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
        my $site_path_absolute    = $app->param('site_path_absolute');
        my $use_absolute          = $app->param('use_absolute');
        my $archive_path_absolute = $app->param('archive_path_absolute');
        my $enable_archive_paths  = $app->param('enable_archive_paths');
        my $use_absolute_archive  = $app->param('use_absolute_archive');
        $blog->site_path($site_path_absolute)
            if (
            !$app->config->BaseSitePath
            || ($app->config->BaseSitePath
                && MT::CMS::Common::is_within_base_sitepath(
                    $app, $site_path_absolute
                )
            )
            )
            && $use_absolute
            && $site_path_absolute;
        $blog->archive_path($archive_path_absolute)
            if !$app->config->BaseSitePath
            && $enable_archive_paths
            && $use_absolute_archive
            && $archive_path_absolute;
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
    my $use_revision = $app->param('use_revision');
    $blog->use_revision( $use_revision ? 1 : 0 );
    if ($use_revision) {
        my $max_revisions_entry    = $app->param('max_revisions_entry');
        my $max_revisions_cd       = $app->param('max_revisions_cd');
        my $max_revisions_template = $app->param('max_revisions_template');
        $blog->max_revisions_entry($max_revisions_entry)
            if $max_revisions_entry;
        $blog->max_revisions_cd($max_revisions_cd)
            if $max_revisions_cd;
        $blog->max_revisions_template($max_revisions_template)
            if $max_revisions_template;
    }

    my $upload_destination        = $app->param('upload_destination');
    my $extra_path                = $app->param('extra_path');
    my $allow_to_change_at_upload = $app->param('allow_to_change_at_upload');
    my $operation_if_exists       = $app->param('operation_if_exists');
    my $normalize_orientation     = $app->param('normalize_orientation');
    my $auto_rename_non_ascii     = $app->param('auto_rename_non_ascii');
    $blog->upload_destination($upload_destination);
    $blog->extra_path($extra_path);
    $blog->allow_to_change_at_upload( $allow_to_change_at_upload ? 1 : 0 );
    $blog->operation_if_exists($operation_if_exists);
    $blog->normalize_orientation( $normalize_orientation ? 1 : 0 );
    $blog->auto_rename_non_ascii( $auto_rename_non_ascii ? 1 : 0 );

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

sub update_publishing_profile {
    my $app = shift;
    my ($blog) = @_;

    my $dcty = $blog->custom_dynamic_templates;

    require MT::PublishOption;
    require MT::Template;
    require MT::TemplateMap;

    if ( ( $dcty eq 'none' ) || ( $dcty =~ m/^async/ ) ) {

        # none, async_all or async_partial

        my @templates = MT::Template->load(
            {   blog_id => $blog->id,

                # FIXME: enumeration of types
                type => [
                    'index',    'archive', 'individual', 'page',
                    'category', 'ct',      'ct_archive'
                ],
            }
        );
        for my $tmpl (@templates) {
            my $bt = $tmpl->build_type || 0;

            # Do not make automatic modifications to templates with these
            # manually configured build types
            next if $bt == MT::PublishOption::DISABLED();
            next if $bt == MT::PublishOption::MANUALLY();
            next if $bt == MT::PublishOption::SCHEDULED();

            # ONDEMAND, DYNAMIC and ASYNC remains

            if ( $dcty eq 'async_partial' ) {

                # these should be build synchronously
                if ( ( $tmpl->identifier || '' )
                    =~ m/^(main_index|feed_recent)$/ )
                {
                    $tmpl->build_type( MT::PublishOption::ONDEMAND() );
                }
                else {
                    if (   $tmpl->type eq 'individual'
                        || $tmpl->type eq 'page'
                        || $tmpl->type eq 'ct' )
                    {
                        my @tmpl_maps = MT::TemplateMap->load(
                            { template_id => $tmpl->id } );
                        foreach my $tmpl_map (@tmpl_maps) {
                            if ((   $tmpl_map->archive_type
                                    =~ m/^(Individual|Page|ContentType)$/
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
            if ( ( $ENV{SERVER_SOFTWARE} || '' ) =~ /Microsoft-IIS/
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
                        open( $fh, ">", $web_config_path )
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
                type => [
                    'index',    'archive', 'individual', 'page',
                    'category', 'ct',      'ct_archive'
                ],
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
                type => [
                    'index',    'archive', 'individual', 'page',
                    'category', 'ct',      'ct_archive'
                ],
            }
        );
        for my $tmpl (@templates) {
            my $bt = $tmpl->build_type || 0;
            next if $bt == MT::PublishOption::DISABLED();
            next if $bt == MT::PublishOption::MANUALLY();
            next if $bt == MT::PublishOption::SCHEDULED();

            # ONDEMAND, DYNAMIC and ASYNC remains

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
        open my $fh, "<", $mtview_path
            or die "Couldn't open $mtview_path: $!";
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
            open my $mv, "<", $mtview_path
                or die "Couldn't open $mtview_path: $!";
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
            open( my $mv, ">", $mtview_path )
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
    if ( ( $ENV{SERVER_SOFTWARE} || '' ) =~ /Microsoft-IIS/
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
        open( $fh, ">", $web_config_path )
            || die "Couldn't open $web_config_path for appending";
        print $fh $out;
        close $fh;
    }
    else {
        eval {
            my $contents = "";
            if ( open( my $HT, "<", $htaccess_path ) ) {
                local $/ = undef;
                $contents = <$HT>;
                close $HT;
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

                open( my $HT, ">>", $htaccess_path )
                    || die "Couldn't open $htaccess_path for appending";
                print $HT $htaccess || die "Couldn't write to $htaccess_path";
                close $HT;
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

    $app->{hide_goback_button} = 1;

    my @id = $app->multi_param('id');

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
        = File::Spec->catfile( $website->site_path )
        . MT::Util->dir_separator
        if $website->site_path;
    $param->{blog_id} = $app->param('blog_id');

    for my $key ( $app->multi_param ) {
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

    my $tmpl = $app->load_tmpl( 'dialog/clone_blog.tmpl', $param );

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

    $app->print_encode( $app->build_page('layout/modal/header.tmpl') );

    my $page_title = $app->translate('Clone Child Site');
    $app->print_encode( $app->translate_templatized(<<"HTML" ) );

<div class="modal-header">
    <h5 class="modal-title">$page_title</h5>
    <button type="button" class="close" data-dismiss="modal" aria-label="Close" data-mt-modal-close>
      <span aria-hidden="true">&times;</span>
    </button>
</div>

<div class="modal-body">
    <h2><__trans phrase="Cloning child site '[_1]'..." params="$blog_name_encode"></h2>
    <div class="modal_width card" id="dialog-clone-weblog" style="background-color: #fafafa;">
        <div id="clone-process" class="process-msg card-block">
            <ul class="list-unstyled p-3">
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
        my $auth = $app->user;
        require MT::Log;
        $app->log(
            {   message => $app->translate(
                    "'[_1]' (ID:[_2]) has been copied as '[_3]' (ID:[_4]) by '[_5]' (ID:[_6]).",
                    $blog->name,   $blog->id,   $blog_name,
                    $new_blog->id, $auth->name, $auth->id
                ),
                level    => MT::Log::INFO(),
                class    => $new_blog->class,
                category => 'new',
            }
        );
        my $return_url = $app->base
            . $app->uri(
            mode => 'list',
            args => {
                '_type' => $app->blog ? 'blog' : 'website',
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
    </div>
    <p class="mt-3"><strong><__trans phrase="Finished!"></strong></p>
</div>

<div class="modal-footer">
    <form method="GET">
        <div class="actions-bar">
            <button
                type="submit"
                accesskey="x"
                onclick="jQuery.fn.mtModal.close('$return_url'); return false;"
                class="btn btn-primary mt-close-dialog-url"
                ><__trans phrase="Close"></button>
        </div>
    </form>
</div>
HTML
    }

    $app->print_encode( $app->build_page('layout/modal/footer.tmpl') );
}

sub _progress {
    my $app = shift;
    my $ids = $app->request('progress_ids') || {};

    my ( $str, $id ) = @_;
    if ( $id && $ids->{$id} ) {
        require MT::Util;
        my $str_js = MT::Util::encode_js($str);
        $app->print_encode(<<"SCRIPT");
<script type="text/javascript">
function progress(str, id) {
    var el = getByID(id);
    if (el) el.innerHTML = str;
}

if (typeof getByID !== 'function') {
    function getByID(n, d) {
        if (!d) d = document;
        if (d.getElementById)
            return d.getElementById(n);
        else if (d.all)
            return d.all[n];
    }
}

progress('$str_js', '$id');
</script>
SCRIPT
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
    delete $terms->{blog_id};
    $terms->{parent_id} = $load_options->{blog_id}
        if $app->blog;
    $terms->{class} = 'blog'
        unless $terms->{class} and $terms->{class} eq '*';

    my $user = $load_options->{user} || $app->user;
    if (   $user->is_superuser
        || $user->permissions(0)->can_do('access_to_blog_list')
        || $user->permissions(0)->can_do('edit_templates') )
    {
        $load_options->{terms} = $terms;
        return;
    }

    my $iter = MT::Permission->load_iter(
        {   author_id   => $user->id,
            blog_id     => { not => 0 },
            permissions => { not => 'comment' },
        }
    );

    my $blog_ids = [];
    while ( my $perm = $iter->() ) {
        push @$blog_ids, $perm->blog_id if $perm->blog_id;
    }
    if ( $terms->{class} eq '*' ) {
        push @$blog_ids,
            map { $_->parent_id } $app->model('blog')->load(
            { class     => 'blog', id => $blog_ids },
            { fetchonly => ['parent_id'] }
            );
    }

    if ( $blog_ids && @$blog_ids ) {
        if ( $terms->{class} eq '*' ) {
            delete $terms->{class};
            $load_options->{args}{no_class} = 1;
        }
        $terms->{id} = $blog_ids;
    }
    else {
        $terms->{id} = 0;
    }

    $load_options->{terms} = $terms;
}

sub can_view_blog_list {
    my $app  = shift;
    my $blog = $app->blog;

    return 0 if !$blog || $blog->is_blog;

    return 1 if $app->user->is_superuser;
    return 1 if $app->user->permissions(0)->can_do('edit_templates');
    return 1 if $app->user->permissions(0)->can_do('access_to_blog_list');

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

sub data_api_is_enabled {
    my ( $app, $blog_id ) = @_;
    my $cfg = $app->config;

    my @disable_site = split ',',
        defined $cfg->DataAPIDisableSite ? $cfg->DataAPIDisableSite : '';
    return ( grep { $blog_id == $_ } @disable_site ) ? 0 : 1;
}

sub save_data_api_settings {
    my ($app) = @_;

    my $blog_id = $app->param('id') || 0;
    my $cfg = $app->config;

    my $data_api_disable_site
        = defined $cfg->DataAPIDisableSite ? $cfg->DataAPIDisableSite : '';
    my %data_api_disable_site
        = map { $_ => 1 } ( split ',', $data_api_disable_site );
    if ( $app->param('enable_data_api') ) {
        delete $data_api_disable_site{$blog_id};
    }
    else {
        $data_api_disable_site{$blog_id} = 1;
    }
    my $new_data_api_disable_site = join ',',
        ( sort { $a <=> $b } keys %data_api_disable_site );
    $cfg->DataAPIDisableSite( $new_data_api_disable_site, 1 );

    $cfg->save_config;

    return 1;
}

sub _determine_total {
    my ( $archiver, $blog_id, $content_type_id ) = @_;

    my $total = 0;
    if (   $archiver->entry_based
        || $archiver->contenttype_based
        || $archiver->date_based )
    {
        if (   $archiver->contenttype_based
            || $archiver->contenttype_date_based )
        {
            my $terms = {
                status  => MT::Entry::RELEASE(),
                blog_id => $blog_id,
                (   $content_type_id
                    ? ( content_type_id => $content_type_id )
                    : ()
                ),
            };
            $total = MT->model('content_data')->count($terms);
        }
        else {
            my $entry_class = $archiver->entry_class || 'entry';
            require MT::Entry;
            my $terms = {
                class   => $entry_class,
                status  => MT::Entry::RELEASE(),
                blog_id => $blog_id,
            };
            $total = MT::Entry->count($terms);
        }
    }
    elsif ( $archiver->category_based ) {
        if ( $archiver->contenttype_category_based ) {
            my @cat_set
                = MT->model('category_set')->load( { blog_id => $blog_id } );
            $total
                = MT->model('category')
                ->count( { category_set_id => [ map { $_->id } @cat_set ] } );
        }
        else {
            require MT::Category;
            my $terms = {
                blog_id         => $blog_id,
                class           => $archiver->category_class,
                category_set_id => 0,
            };
            $total = MT::Category->count($terms);
        }
    }
    elsif ( $archiver->author_based ) {
        require MT::Author;
        my $terms = {
            blog_id => $blog_id,
            status  => MT::Entry::RELEASE(),
            (   $archiver->contenttype_author_based ? ()
                : ( class => 'entry' )
            ),
            (   $archiver->contenttype_author_based && $content_type_id
                ? ( content_type_id => $content_type_id )
                : ()
            ),
        };
        my $obj_class
            = $archiver->contenttype_author_based ? 'content_data' : 'entry';
        $total = MT::Author->count(
            { status => MT::Author::ACTIVE() },
            {   join => MT->model($obj_class)
                    ->join_on( 'author_id', $terms, { unique => 1 } ),
                unique => 1,
            }
        );
    }

    return $total;
}

sub filtered_list_param {
    my ( $cb, $app, $param, $objs ) = @_;
    my %obj_hash = map { $_->id => $_ } @$objs;
    my $objects = $param->{objects};
    return unless $objects && @$objects > 0;
    for my $obj (@$objects) {
        my $id = $obj->[0] or next;
        if ( $obj_hash{$id} && !$obj_hash{$id}->is_blog ) {
            $obj->[0] = undef;
        }
    }
}

1;
