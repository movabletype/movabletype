# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::CMS;

use strict;
use base qw( MT::App );

use MT::Util qw( format_ts epoch2ts perl_sha1_digest_hex perl_sha1_digest
    remove_html );

sub LISTING_DATE_FORMAT ()      {'%b %e, %Y'}
sub LISTING_DATETIME_FORMAT ()  {'%b %e, %Y'}
sub LISTING_TIMESTAMP_FORMAT () {"%Y-%m-%d %I:%M:%S%p"}
sub NEW_PHASE ()                {1}

sub id {'cms'}

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->{state_params} = [
        '_type',      'id',         'tab',     'offset',
        'filter',     'filter_val', 'blog_id', 'is_power_edit',
        'filter_key', 'type'
    ];
    $app->{template_dir}         = 'cms';
    $app->{plugin_template_path} = '';
    $app->{is_admin}             = 1;
    $app->{default_mode}         = 'dashboard';
    $app;
}

sub core_methods {
    my $app = shift;
    my $pkg = '$Core::MT::CMS::';
    return {
        'tools'     => "${pkg}Tools::system_check",
        'dashboard' => "${pkg}Dashboard::dashboard",
        'menu'      => "${pkg}Dashboard::dashboard",
        'admin'     => "${pkg}Dashboard::dashboard",

        ## Generic handlers
        'save'           => "${pkg}Common::save",
        'edit'           => "${pkg}Common::edit",
        'view'           => "${pkg}Common::edit",
        'list'           => "${pkg}Common::list",
        'filtered_list'  => {
            code => "${pkg}Common::filtered_list",
            app_mode => 'JSON',
        },
        'save_list_prefs'  => {
            code => "${pkg}Common::save_list_prefs",
            app_mode => 'JSON',
        },
        'delete'         => "${pkg}Common::delete",
        'search_replace' => "${pkg}Search::search_replace",
        'list_revision'  => "${pkg}Common::list_revision",
        'save_snapshot'  => "${pkg}Common::save_snapshot",

        ## Edit methods
        'edit_role'   => "${pkg}User::edit_role",
        'edit_widget' => "${pkg}Template::edit_widget",
        'view_role'   => "${pkg}User::edit_role",
        'view_widget' => "${pkg}Template::edit_widget",

        ## Listing methods
        'list_template' => "${pkg}Template::list",
        'list_widget'   => "${pkg}Template::list_widget",
        'list_asset'       => {
            code => "${pkg}Asset::dialog_list_asset",
            condition => sub {
                my $app = shift;
                return 0 unless $app->param('dialog_view');
                return 1;
            }
        },
        'list_theme'       => "${pkg}Theme::list",

        'asset_insert'        => "${pkg}Asset::insert",
        'asset_userpic'       => "${pkg}Asset::asset_userpic",
        'save_commenter_perm' => "${pkg}Comment::save_commenter_perm",
        'trust_commenter'     => "${pkg}Comment::trust_commenter",
        'ban_commenter'       => "${pkg}Comment::ban_commenter",
        'approve_item'        => "${pkg}Comment::approve_item",
        'unapprove_item'      => "${pkg}Comment::unapprove_item",
        'preview_entry'       => "${pkg}Entry::preview",
        'apply_theme'         => "${pkg}Theme::apply",
        'uninstall_theme'     => "${pkg}Theme::uninstall",
        'bulk_update_category' => {
            code => "${pkg}Category::bulk_update",
            app_mode => 'JSON',
        },
        'bulk_update_folder' => {
            code => "${pkg}Category::bulk_update",
            app_mode => 'JSON',
        },

        ## Blog configuration screens
        'cfg_prefs'        => "${pkg}Blog::cfg_prefs",
        'cfg_feedback'     => "${pkg}Blog::cfg_feedback",
        'cfg_plugins'      => "${pkg}Plugin::cfg_plugins",
        'cfg_registration' => "${pkg}Blog::cfg_registration",
        'cfg_entry'        => "${pkg}Entry::cfg_entry",
        'cfg_web_services' => "${pkg}Blog::cfg_web_services",

        ## Save
        'save_cat'     => "${pkg}Category::save",
        'save_entries' => "${pkg}Entry::save_entries",
        'save_pages'   => "${pkg}Page::save_pages",
        'save_entry'   => "${pkg}Entry::save",
        'save_role'    => "${pkg}User::save_role",
        'save_widget'  => "${pkg}Template::save_widget",
        'save_filter'  => "${pkg}Filter::save",

        ## Delete
        'delete_entry'  => "${pkg}Entry::delete",
        'delete_widget' => "${pkg}Template::delete_widget",
        'delete_filter' => "${pkg}Filter::delete",

        ## List actions
        'enable_object'      => "${pkg}User::enable",
        'disable_object'     => "${pkg}User::disable",
        'list_action'        => "${pkg}Tools::do_list_action",
        'empty_junk'         => "${pkg}Comment::empty_junk",
        'handle_junk'        => "${pkg}Comment::handle_junk",
        'not_junk'           => "${pkg}Comment::not_junk",
        'open_batch_editor'  => "${pkg}Entry::open_batch_editor",
        'delete_filters'     => {
            code => "${pkg}Filter::delete_filters",
            app_mode => 'JSON',
        },

        'ping'               => "${pkg}Entry::send_pings",
        'rebuild_phase'      => "${pkg}Blog::rebuild_phase",
        'rebuild'            => "${pkg}Blog::rebuild_pages",
        'rebuild_new_phase'  => "${pkg}Blog::rebuild_new_phase",
        'start_rebuild'      => "${pkg}Blog::start_rebuild_pages",
        'rebuild_confirm'    => "${pkg}Blog::rebuild_confirm",
        'entry_notify'       => "${pkg}AddressBook::entry_notify",
        'send_notify'        => "${pkg}AddressBook::send_notify",
        'start_upload'       => "${pkg}Asset::start_upload",
        'upload_file'        => "${pkg}Asset::upload_file",
        'upload_userpic'     => "${pkg}User::upload_userpic",
        'complete_insert'    => "${pkg}Asset::complete_insert",
        'complete_upload'    => "${pkg}Asset::complete_upload",
        'start_upload_entry' => "${pkg}Asset::start_upload_entry",
        'logout'             => {
            code           => sub { $_[0]->SUPER::logout(@_) },
            requires_login => 0,
        },
        'start_recover' => {
            code           => "${pkg}Tools::start_recover",
            requires_login => 0,
        },
        'recover' => {
            code           => "${pkg}Tools::recover_password",
            requires_login => 0,
        },
        'new_pw' => {
            code => "${pkg}Tools::new_password",
            requires_login => 0,
        },

        'start_move_blogs'     => "${pkg}Website::move_blogs",
        'view_rpt_log'         => "${pkg}RptLog::view",
        'reset_rpt_log'        => "${pkg}RptLog::reset",
        'reset_log'            => "${pkg}Log::reset",
        'export_log'           => "${pkg}Log::export",
        'export_notification'  => "${pkg}AddressBook::export",
        'start_import'         => "${pkg}Import::start_import",
        'start_export'         => "${pkg}Export::start_export",
        'export'               => "${pkg}Export::export",
        'import'               => "${pkg}Import::do_import",
        'export_theme'         => "${pkg}Theme::export",
        'theme_element_detail' => "${pkg}Theme::element_dialog",
        'save_theme_detail'    => "${pkg}Theme::save_detail",
        'do_export_theme'      => "${pkg}Theme::do_export",
        'pinged_urls'          => "${pkg}Entry::pinged_urls",
        'save_entry_prefs'     => "${pkg}Entry::save_entry_prefs",
        'save_favorite_blogs'  => "${pkg}Blog::save_favorite_blogs",
        'folder_add'           => "${pkg}Category::category_add",
        'category_add'         => "${pkg}Category::category_add",
        'category_do_add'      => "${pkg}Category::category_do_add",
        'cc_return'            => "${pkg}Blog::cc_return",
        'reset_blog_templates' => "${pkg}Template::reset_blog_templates",
        'handshake'            => "${pkg}Blog::handshake",
        'itemset_action'       => "${pkg}Tools::do_list_action",
        'page_action'          => "${pkg}Tools::do_page_action",
        'cfg_system_general'   => "${pkg}Tools::cfg_system_general",
        'cfg_system_users'     => "${pkg}User::cfg_system_users",
        'save_plugin_config'   => "${pkg}Plugin::save_config",
        'reset_plugin_config'  => "${pkg}Plugin::reset_config",
        'save_cfg_system_general' => "${pkg}Tools::save_cfg_system_general",
        'save_cfg_system_users'   => "${pkg}User::save_cfg_system_users",
        'update_welcome_message'  => "${pkg}Blog::update_welcome_message",
        'upgrade'                 => {
            code           => "${pkg}Tools::upgrade",
            requires_login => 0,
        },
        'plugin_control'           => "${pkg}Plugin::plugin_control",
        'recover_profile_password' => "${pkg}User::recover_profile_password",
        'rename_tag'               => "${pkg}Tag::rename_tag",
        'remove_user_assoc'        => "${pkg}User::remove_user_assoc",
        'revoke_role'              => "${pkg}User::revoke_role",
        'grant_role'               => "${pkg}User::grant_role",
        'start_backup'             => "${pkg}Tools::start_backup",
        'start_restore'            => "${pkg}Tools::start_restore",
        'backup'                   => "${pkg}Tools::backup",
        'backup_download'          => "${pkg}Tools::backup_download",
        'restore'                  => "${pkg}Tools::restore",
        'restore_premature_cancel' => "${pkg}Tools::restore_premature_cancel",
        'adjust_sitepath'          => "${pkg}Tools::adjust_sitepath",
        'system_check'             => "${pkg}Tools::system_check",
        'dialog_refresh_templates' =>
            "${pkg}Template::dialog_refresh_templates",
        'dialog_clone_blog' => "${pkg}Blog::clone",
        'dialog_publishing_profile' =>
            "${pkg}Template::dialog_publishing_profile",
        'refresh_all_templates' => "${pkg}Template::refresh_all_templates",
        'preview_template'      => "${pkg}Template::preview",
        'publish_index_templates' =>
            "${pkg}Template::publish_index_templates",
        'publish_archive_templates' =>
            "${pkg}Template::publish_archive_templates",
        'publish_templates_from_search' =>
            "${pkg}Template::publish_templates_from_search",

        ## Comment Replies
        reply         => "${pkg}Comment::reply",
        do_reply      => "${pkg}Comment::do_reply",
        reply_preview => "${pkg}Comment::reply_preview",

        ## Dialogs
        'dialog_restore_upload'    => "${pkg}Tools::dialog_restore_upload",
        'dialog_adjust_sitepath'   => "${pkg}Tools::dialog_adjust_sitepath",
        'dialog_post_comment'      => "${pkg}Comment::dialog_post_comment",
        'dialog_select_weblog'     => "${pkg}Blog::dialog_select_weblog",
        'dialog_select_website'    => "${pkg}Website::dialog_select_website",
        'dialog_select_theme'      => "${pkg}Theme::dialog_select_theme",
        'dialog_select_sysadmin'   => "${pkg}User::dialog_select_sysadmin",
        'dialog_grant_role'        => "${pkg}User::dialog_grant_role",
        'dialog_select_assoc_type' => "${pkg}User::dialog_select_assoc_type",
        'dialog_select_author'     => "${pkg}User::dialog_select_author",
        'dialog_list_asset'        => "${pkg}Asset::dialog_list_asset",

        ## AJAX handlers
        'delete_map'        => "${pkg}Template::delete_map",
        'add_map'           => "${pkg}Template::add_map",
        'js_tag_check'      => "${pkg}Tag::js_tag_check",
        'js_tag_list'       => "${pkg}Tag::js_tag_list",
        'convert_to_html'   => "${pkg}Tools::convert_to_html",
        'update_list_prefs' => "${pkg}Tools::update_list_prefs",
        'js_add_category'   => "${pkg}Category::js_add_category",
        'remove_userpic'    => "${pkg}User::remove_userpic",
        'login_json'        => {
            code     => "${pkg}Tools::login_json",
            app_mode => 'JSON',
        },
        # declared in MT::App
        'update_widget_prefs' =>
            sub { return shift->update_widget_prefs(@_) },

        'js_recent_entries_for_tag' => "${pkg}Tag::js_recent_entries_for_tag",

        ## DEPRECATED ##
        'list_pings'    => "${pkg}TrackBack::list",
        'list_entries'  => "${pkg}Entry::list",
        'list_pages'    => "${pkg}Page::list",
        'list_comments' => "${pkg}Comment::list",
        'list_authors'      => "${pkg}User::list",
        'list_assets'       => "${pkg}Asset::list",
        'list_cat'          => "${pkg}Category::list",
        'list_blogs'        => "${pkg}Blog::list",
        'list_associations' => "${pkg}User::list_association",
        'list_roles'        => "${pkg}User::list_role",
    };
}

sub core_widgets {
    my $app = shift;
    my $pkg = '$Core::MT::CMS::';
    return {
        this_is_you => {
            label    => 'This is You',
            template => 'widget/this_is_you.tmpl',
            handler  => "${pkg}Dashboard::this_is_you_widget",
            set      => 'main',
            singular => 1,
            view     => 'user',
        },
        mt_news => {
            label    => 'Movable Type News',
            template => 'widget/mt_news.tmpl',
            handler  => "${pkg}Dashboard::mt_news_widget",
            singular => 1,
            set      => 'sidebar',
            view     => 'user',
        },
        blog_stats => {
            label    => 'Blog Stats',
            template => 'widget/blog_stats.tmpl',
            handler  => "${pkg}Dashboard::mt_blog_stats_widget",
            singular => 1,
            set      => 'main',
            view     => 'blog',
            param    => {
                tab => 'entry'
            },
        },
        recent_websites => {
            label    => 'Websites',
            template => 'widget/recent_websites.tmpl',
            handler  => "${pkg}Dashboard::recent_websites_widget",
            singular => 1,
            set      => 'main',
            view     => 'system',
        },
        recent_blogs => {
            label    => 'Blogs',
            template => 'widget/recent_blogs.tmpl',
            handler  => "${pkg}Dashboard::recent_blogs_widget",
            singular => 1,
            set      => 'main',
            view     => 'website',
        },
        favorite_blogs => {
            label    => 'Websites and Blogs',
            template => 'widget/favorite_blogs.tmpl',
            handler  => "${pkg}Dashboard::favorite_blogs_widget",
            singular => 1,
            set      => 'main',
            view     => 'user',
            param    => {
                tab => 'website'
            },
        },
    };
}

sub core_blog_stats_tabs {
    my $app = shift;
    my $pkg = '$Core::MT::CMS::';
    return {
        entry => {
            label    => 'Entries',
            template => 'widget/blog_stats_entry.tmpl',
            handler  => "${pkg}Dashboard::mt_blog_stats_widget_entry_tab",
            stats    => "${pkg}Dashboard::generate_dashboard_stats_entry_tab",
        },
        comment => {
            label    => 'Comments',
            template => 'widget/blog_stats_comment.tmpl',
            handler  => "${pkg}Dashboard::mt_blog_stats_widget_comment_tab",
            stats => "${pkg}Dashboard::generate_dashboard_stats_comment_tab",
        },
        tag_cloud => {
            label    => 'Tag Cloud',
            handler  => "${pkg}Dashboard::mt_blog_stats_tag_cloud_tab",
            template => 'widget/blog_stats_tag_cloud.tmpl',
        },
    };
}

sub core_page_actions {
    return {
        list_templates => {
            refresh_all_blog_templates => {
                label     => "Refresh Templates",
                mode      => 'dialog_refresh_templates',
                condition => sub {
                    MT->app->blog;
                },
                order => 1000,
                dialog    => 1
            },
            refresh_global_templates => {
                label     => "Refresh Templates",
                mode      => 'dialog_refresh_templates',
                condition => sub {
                    !MT->app->blog;
                },
                order => 1000,
                dialog    => 1
            },
            publishing_profile => {
                label     => "Use Publishing Profile",
                mode      => 'dialog_publishing_profile',
                condition => sub {
                    MT->app->blog;
                },
                order => 1100,
                dialog    => 1
            },
        },
    };
}

sub init_plugins {
    my $app = shift;

    # This has to be done prior to plugin initialization since we
    # may have plugins that register themselves using some of the
    # older callback names. The callback aliases are declared
    # in init_core_callbacks.
    $app->init_core_callbacks();
    $app->SUPER::init_plugins(@_);
}

sub init_request {
    my $app = shift;
    $app->SUPER::init_request(@_);
    $app->{requires_login} = 1
        unless exists $app->{requires_login};   # by default, we require login

    my $mode = $app->mode;

    $app->set_no_cache
        if $mode ne 'export_notification'
            && $mode ne 'backup_download'
            && $mode ne 'export'
            && $mode ne 'do_export_theme'
            && $mode ne 'export_log'
            && $mode ne 'export_authors';

    # Global 'blog_id' parameter check; if we get something
    # other than an integer, die
    if ( my $blog_id = $app->param('blog_id') ) {
        if ( $blog_id ne int($blog_id) ) {
            die $app->translate("Invalid request");
        }
        if ( $blog_id > 0 && !$app->model('blog')->load({ id => $blog_id }) ) {
            die $app->translate("Invalid request");
        }
    }

    unless ( defined $app->{upgrade_required} ) {
        $app->{upgrade_required} = 0;
        if (   ( $mode ne 'logout' )
            && ( $mode ne 'start_recover' )
            && ( $mode ne 'recover' )
            && ( $mode ne 'upgrade' ) )
        {
            my $schema  = $app->config('SchemaVersion');
            my $version = $app->config('MTVersion');
            if (   !$schema
                || ( $schema < $app->schema_version )
                || ( ( !$version || ( $version < $app->version_number ) )
                    && $app->config->NotifyUpgrade )
                )
            {
                $app->{upgrade_required} = 1;
            }
            else {
                foreach my $plugin (@MT::Components) {
                    if ( $plugin->needs_upgrade ) {
                        $app->{upgrade_required} = 1;
                        last;
                    }
                }
            }
        }
    }

    if ( $app->{upgrade_required} ) {
        $app->{requires_login} = 0;
        $app->mode('upgrade');
    }
}

sub core_content_actions {
    my $app = shift;
    return {
        'ping' => {
            'empty_junk' => {
                mode => 'empty_junk',
                class => 'icon-action',
                label => 'Delete all Spam trackbacks',
                return_args => 1,
                order => 100,
            },
        },
        'comment' => {
            'empty_junk' => {
                mode => 'empty_junk',
                class => 'icon-action',
                label => 'Delete all Spam comments',
                return_args => 1,
                order => 100,
            },
        },
        'role' => {
            'create_role' => {
                mode => 'view',
                class => 'icon-create',
                label => 'Create Role',
                order => 100,
            }
        },
        'association' => {
            'grant_role' => {
                class => 'icon-create',
                label      => 'Grant Permission',
                mode       => 'dialog_select_assoc_type',
                order      => 100,
                dialog => 1,
            },
        },
        'member' => {
            'grant_role' => {
                class  => 'icon-create',
                label  => sub {
                    return $app->translate( 'Add a user to this [_1]', lc $app->blog->class_label);
                },
                mode   => 'dialog_grant_role',
                args   => {
                    type  => 'blog',
                    _type => 'user',
                },
                return_args => 1,
                order  => 100,
                dialog => 1,
            },
        },
        'log' => {
            'reset_log' => {
                class => 'icon-action',
                label      => 'Clear Activity Log',
                mode       => 'reset_log',
                order      => 100,
            },
            'download_log' => {
                class => 'icon-download',
                label      => 'Download Log (CSV)',
                mode       => 'export_log',
                order      => 200,
            },
        },
        'banlist' => {
            'ban_ip' => {
                class => 'icon-create',
                label => 'Add IP Address',
                id    => 'action-ban-ip',
                order => 100,
            },
        },
        'notification' => {
            'add_contact' => {
                class => 'icon-create',
                label => 'Create Contact',
                id    => 'action-create-contact',
                order => 100,
            },
        },
    };
}

sub core_list_actions {
    my $app = shift;
    my $pkg = '$Core::MT::CMS::';
    return {
        'entry' => {
            'set_draft' => {
                label      => "Unpublish Entries",
                order      => 200,
                code       => "${pkg}Entry::draft_entries",
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;

                    my $blog = $app->blog;
                    my $blog_ids = !$blog
                        ? undef
                        : $blog->is_blog
                            ? [ $blog->id ]
                            : [ map { $_->id } @{$blog->blogs} ];

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        next if !$p->blog->is_blog;

                        $cond = 0, last
                            if !$p->can_do('set_entry_draft_via_list')
                        }
                    return $cond;
                },
            },
            'add_tags' => {
                label       => "Add Tags...",
                order       => 300,
                code        => "${pkg}Tag::add_tags_to_entries",
                input       => 1,
                xhr         => 1,
                input_label => 'Tags to add to selected entries',
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;

                    my $blog = $app->blog;
                    my $blog_ids = !$blog
                        ? undef
                        : $blog->is_blog
                            ? [ $blog->id ]
                            : [ map { $_->id } @{$blog->blogs} ];

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        $cond = 0, last
                            if !$p->can_do('add_tags_to_entry_via_list')
                        }
                    return $cond;
                },
            },
            'remove_tags' => {
                label       => "Remove Tags...",
                order       => 400,
                code        => "${pkg}Tag::remove_tags_from_entries",
                input       => 1,
                input_label => 'Tags to remove from selected entries',
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;

                    my $blog = $app->blog;
                    my $blog_ids = !$blog
                        ? undef
                        : $blog->is_blog
                            ? [ $blog->id ]
                            : [ map { $_->id } @{$blog->blogs} ];

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        $cond = 0, last
                            if !$p->can_do('remove_tags_from_entry_via_list')
                        }
                    return $cond;
                }
            },
            'open_batch_editor' => {
                label     => "Batch Edit Entries",
                code      => "${pkg}Entry::open_batch_editor",
                order     => 500,
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 0 if $app->param('filter_key')
                        && $app->param('filter_key') eq 'spam_entries';
                    return 0 unless $app->param('blog_id');
                    return 1 if $app->user->is_superuser;

                    my $blog = $app->blog;
                    my $blog_ids = !$blog
                        ? undef
                        : $blog->is_blog
                            ? [ $blog->id ]
                            : [ map { $_->id } @{$blog->blogs} ];

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        $cond = 0, last
                            if !$p->can_do('open_batch_entry_editor_via_list')
                        }
                    return $cond;
                },
            },
            'publish' => {
                label      => 'Publish',
                code       => "${pkg}Blog::rebuild_new_phase",
                mode       => 'rebuild_new_phase',
                order      => 100,
                js_message => 'publish',
                button     => 1,
                condition  => sub {
                    return 1 if $app->user->is_superuser;

                    my $blog = $app->blog;
                    my $blog_ids = !$blog
                        ? undef
                        : $blog->is_blog
                            ? [ $blog->id ]
                            : [ map { $_->id } @{$blog->blogs} ];

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        $cond = 0, last
                            if !$p->can_do('publish_entry_via_list')
                        }
                    return $cond;
                },
            },
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
            },
        },
        'page' => {
            'set_draft' => {
                label      => "Unpublish Pages",
                order      => 200,
                code       => "${pkg}Entry::draft_entries",
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;

                    my $blog = $app->blog;
                    my $blog_ids = !$blog
                        ? undef
                        : $blog->is_blog
                            ? [ $blog->id ]
                            : [ $blog->id, map { $_->id } @{$blog->blogs} ];

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        next if !$p->blog->is_blog;

                        $cond = 0, last
                            if !$p->can_do('set_page_draft_via_list')
                        }
                    return $cond;
                },
            },
            'add_tags' => {
                label       => "Add Tags...",
                order       => 300,
                code        => "${pkg}Tag::add_tags_to_entries",
                input       => 1,
                input_label => 'Tags to add to selected pages',
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;

                    my $blog = $app->blog;
                    my $blog_ids = !$blog
                        ? undef
                        : $blog->is_blog
                            ? [ $blog->id ]
                            : [ $blog->id, map { $_->id } @{$blog->blogs} ];

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        $cond = 0, last
                            if !$p->can_do('add_tags_to_pages_via_list')
                        }
                    return $cond;
                },
            },
            'remove_tags' => {
                label       => "Remove Tags...",
                order       => 400,
                code        => "${pkg}Tag::remove_tags_from_entries",
                input       => 1,
                input_label => 'Tags to remove from selected pages',
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;

                    my $blog = $app->blog;
                    my $blog_ids = !$blog
                        ? undef
                        : $blog->is_blog
                            ? [ $blog->id ]
                            : [ $blog->id, map { $_->id } @{$blog->blogs} ];

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        $cond = 0, last
                            if !$p->can_do('remove_tags_from_pages_via_list')
                        }
                    return $cond;
                },
            },
            'open_batch_editor' => {
                label     => "Batch Edit Pages",
                code      => "${pkg}Entry::open_batch_editor",
                order     => 500,
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 0 if $app->param('filter_key')
                        && $app->param('filter_key') eq 'spam_entries';
                    return 0 unless $app->param('blog_id');
                    return 1 if $app->user->is_superuser;

                    my $blog = $app->blog;
                    my $blog_ids = !$blog
                        ? undef
                        : $blog->is_blog
                            ? [ $blog->id ]
                            : [ $blog->id, map { $_->id } @{$blog->blogs} ];

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        $cond = 0, last
                            if !$p->can_do('open_batch_page_editor_via_list')
                        }
                    return $cond;
                },
            },
            'publish' => {
                label      => 'Publish',
                code       => "${pkg}Blog::rebuild_new_phase",
                mode       => 'rebuild_new_phase',
                order      => 100,
                js_message => 'publish',
                button     => 1,
                condition  => sub {
                    return 1 if $app->user->is_superuser;

                    my $blog = $app->blog;
                    my $blog_ids = !$blog
                        ? undef
                        : $blog->is_blog
                            ? [ $blog->id ]
                            : [ $blog->id, map { $_->id } @{$blog->blogs} ];

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        $cond = 0, last
                            if !$p->can_do('publish_page_via_list')
                        }
                    return $cond;
                },
            },
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
            },
        },
        'asset' => {
            'add_tags' => {
                label       => "Add Tags...",
                order       => 100,
                code        => "${pkg}Tag::add_tags_to_assets",
                input       => 1,
                input_label => 'Tags to add to selected assets',
                permit_action => 'add_tags_to_assets_via_list',
            },
            'remove_tags' => {
                label       => "Remove Tags...",
                order       => 200,
                code        => "${pkg}Tag::remove_tags_from_assets",
                input       => 1,
                input_label => 'Tags to remove from selected assets',
                permit_action => 'remove_tags_from_assets_via_list',
            },
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
            },
        },
        'ping' => {
            'spam' => {
                label      => "Mark as Spam",
                order      => 110,
                code       => "${pkg}Comment::handle_junk",
                permit_action => 'edit_all_trackbacks',
                condition   => sub {
                    return $app->mode ne 'view';
                },
            },
            'not_spam' => {
                label      => "Remove Spam status",
                order      => 120,
                code       => "${pkg}Comment::not_junk",
                permit_action => 'edit_all_trackbacks',
                condition   => sub {
                    return $app->mode ne 'view';
                },
            },
            'unapprove_ping' => {
                label         => "Unpublish TrackBack(s)",
                order         => 100,
                code          => "${pkg}Comment::unapprove_item",
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    $app->param('blog_id')
                        && $app->can_do('unapprove_trackbacks_via_list');
                },
            },
            'publish' => {
                label      => 'Publish',
                code       => "${pkg}Comment::approve_item",
                mode       => 'approve_item',
                order      => 100,
                js_message => 'publish',
                button     => 1,
                condition  => sub {
                    $app->param('blog_id')
                        ? $app->can_do('edit_trackback_status')
                        : $app->user->is_superuser;
                },
            },
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
            },
        },
        'comment' => {
            'spam' => {
                label      => "Mark as Spam",
                order      => 110,
                code       => "${pkg}Comment::handle_junk",
                permit_action => 'edit_all_comments',
                condition   => sub {
                    return $app->mode ne 'view';
                },
            },
            'not_spam' => {
                label      => "Remove Spam status",
                order      => 120,
                code       => "${pkg}Comment::not_junk",
                permit_action => 'edit_all_comments',
                condition   => sub {
                    return $app->mode ne 'view';
                },
            },
            'unapprove_comment' => {
                label      => "Unpublish Comment(s)",
                order      => 100,
                code       => "${pkg}Comment::unapprove_item",
                permit_action => 'unapprove_comments_via_list',
                condition   => sub {
                    return $app->mode ne 'view';
                },
            },
            'trust_commenter' => {
                label      => "Trust Commenter(s)",
                order      => 200,
                code       => "${pkg}Comment::trust_commenter_by_comment",
                permit_action => 'trust_commenters_via_list',
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;
                    return $app->config->SingleCommunity
                        ? $app->blog
                            ? 0
                            : 1
                        : $app->blog
                            ? 1
                            : 0;
                }
            },
            'untrust_commenter' => {
                label      => "Untrust Commenter(s)",
                order      => 300,
                code       => "${pkg}Comment::untrust_commenter_by_comment",
                permit_action => 'untrust_commenters_via_list',
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;
                    return $app->config->SingleCommunity
                        ? $app->blog
                            ? 0
                            : 1
                        : $app->blog
                            ? 1
                            : 0;
                }
            },
            'ban_commenter' => {
                label      => "Ban Commenter(s)",
                order      => 400,
                code       => "${pkg}Comment::ban_commenter_by_comment",
                permit_action => 'ban_commenters_via_list',
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;
                    return $app->config->SingleCommunity
                        ? $app->blog
                            ? 0
                            : 1
                        : $app->blog
                            ? 1
                            : 0;
                }
            },
            'unban_commenter' => {
                label      => "Unban Commenter(s)",
                order      => 500,
                code       => "${pkg}Comment::unban_commenter_by_comment",
                permit_action => 'unban_commenters_via_list',
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;
                    return $app->config->SingleCommunity
                        ? $app->blog
                            ? 0
                            : 1
                        : $app->blog
                            ? 1
                            : 0;
                }
            },
            'publish' => {
                label      => 'Publish',
                code       => "${pkg}Comment::approve_item",
                mode       => 'approve_item',
                order      => 100,
                js_message => 'publish',
                button     => 1,
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;
                    return $app->config->SingleCommunity
                        ? $app->blog
                            ? 0
                            : 1
                        : $app->blog
                            ? 1
                            : 0;
                }
            },
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
            },
        },
        'commenter' => {
            'trust' => {
                label      => "Trust Commenter(s)",
                order      => 100,
                code       => "${pkg}Comment::trust_commenter",
                permit_action => 'edit_commenter_status',
                condition => sub {
                    return 0 if $app->blog;
                    return $app->user->is_superuser ? 1 : 0;
                },
           },
            'untrust' => {
                label      => "Untrust Commenter(s)",
                order      => 200,
                code       => "${pkg}Comment::untrust_commenter",
                permit_action => 'edit_commenter_status',
                condition => sub {
                    return 0 if $app->blog;
                    return $app->user->is_superuser ? 1 : 0;
                },
            },
            'ban' => {
                label      => "Ban Commenter(s)",
                order      => 300,
                code       => "${pkg}Comment::ban_commenter",
                permit_action => 'edit_commenter_status',
                condition => sub {
                    return 0 if $app->blog;
                    return $app->user->is_superuser ? 1 : 0;
                },
            },
            'unban' => {
                label      => "Unban Commenter(s)",
                order      => 400,
                code       => "${pkg}Comment::unban_commenter",
                permit_action => 'edit_commenter_status',
                condition => sub {
                    return 0 if $app->blog;
                    return $app->user->is_superuser ? 1 : 0;
                },
            },
        },
        'author' => {
            'recover_passwords' => {
                label                   => "Recover Password(s)",
                order                   => 100,
                continue_prompt_handler => sub {
                    MT->translate("_WARNING_PASSWORD_RESET_MULTI");
                },
                code      => "${pkg}Tools::recover_passwords",
                condition => sub {
                    ( $app->user->is_superuser()
                            && MT::Auth->can_recover_password );
                },
            },
            'delete_user' => {
                label                   => "Delete",
                order                   => 200,
                continue_prompt_handler => sub {
                    $app->config->ExternalUserManagement
                        ? MT->translate("_WARNING_DELETE_USER_EUM")
                        : MT->translate("_WARNING_DELETE_USER");
                },
                code      => "${pkg}Common::delete",
                permit_action => 'delete_user_via_list',
            },
            'enable' => {
                label      => 'Enable',
                code       => "${pkg}User::enable",
                mode       => 'enable_object',
                order      => 100,
                js_message => 'enable',
                button     => 1,
                condition  => sub {
                    $app->can_do('access_to_system_author_list');
                },
            },
            'disable' => {
                label      => 'Disable',
                code       => "${pkg}User::disable",
                mode       => 'disable_object',
                order      => 110,
                js_message => 'disable',
                button     => 1,
                condition  => sub {
                    $app->can_do('access_to_system_author_list');
                },
            },
        },
        'member' => {
            'remove_user_assoc' => {
                label                   => "Remove",
                order                   => 100,
                code      => "${pkg}User::remove_user_assoc",
                mode      => 'remove_user_assoc',
                button    => 1,
                js_message => 'remove',
                condition => sub {
                    my $app = MT->app;
                    return $app->can_do('remove_user_assoc');
                },
                permit_action => 'remove_user_assoc',
            },
        },
        'blog' => {
            refresh_blog_templates => {
                label                   => "Refresh Template(s)",
                continue_prompt_handler => sub {
                    MT->translate("_WARNING_REFRESH_TEMPLATES_FOR_BLOGS");
                },
                code => sub {
                    my $app = MT->app;
                    $app->param( 'backup', 1 );
                    require MT::CMS::Template;
                    MT::CMS::Template::refresh_all_templates( $app, @_ );
                },
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;

                    my $blog = $app->blog;
                    my $blog_ids = !$blog
                        ? undef
                        : $blog->is_blog
                            ? [ $blog->id ]
                            : [ map { $_->id } @{$blog->blogs} ];

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        next unless $p->blog->is_blog;
                        $cond = 0, last
                            if !$p->can_do('refresh_template_via_list')
                        }
                    return $cond;
                },
            },
            move_blogs => {
                label         => "Move blog(s) ",
                order         => 200,
                code          => "${pkg}Website::dialog_move_blogs",
                permit_action => 'move_blogs',
                dialog        => 1,
                condition     => sub {
                    return 0 if $app->mode eq 'view';

                    my $count = MT->model('website')->count();
                    $count > 1 ? 1 : 0;
                }
            },
            clone_blog => {
                label => "Clone Blog",
                code => "${pkg}Blog::clone",
                permission => 'administer',
                max => 1,
                dialog => 1,
            },
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;

                    my $blog = $app->blog;
                    my $blog_ids = !$blog
                        ? undef
                        : $blog->is_blog
                            ? [ $blog->id ]
                            : [ map { $_->id } @{$blog->blogs} ];

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        next unless $p->blog->is_blog;
                        $cond = 0, last
                            if !$p->can_do('delete_blog')
                        }
                    return $cond;
                },
            },
        },
        'website' => {
            refresh_website_templates => {
                label                   => "Refresh Template(s)",
                continue_prompt_handler => sub {
                    MT->translate("_WARNING_REFRESH_TEMPLATES_FOR_BLOGS");
                },
                code => sub {
                    my $app = MT->app;
                    $app->param( 'backup', 1 );
                    require MT::CMS::Template;
                    MT::CMS::Template::refresh_all_templates( $app, @_ );
                },
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            blog_id => { not => 0 },
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        next if $p->blog->is_blog;
                        $cond = 0, last
                            if !$p->can_do('refresh_template_via_list')
                        }
                    return $cond;
                },
            },
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter(
                        {
                            author_id => $app->user->id,
                            blog_id => { not => 0 },
                        }
                    );

                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        next if $p->blog->is_blog;
                        $cond = 0, last
                            if !$p->can_do('delete_website')
                        }
                    return $cond;
                },
            },
        },
        'template' => {
            refresh_tmpl_templates => {
                label      => "Refresh Template(s)",
                code       => "${pkg}Template::refresh_individual_templates",
                permit_action => 'refresh_template_via_list',
                order      => 100,
                condition  => sub {
                    my $app = MT->app;
                    my $tmpl_type = $app->param('filter_key') || '';
                    return
                        $tmpl_type eq 'backup_templates'
                            ? 0
                            : 1;
                },
            },

            # Now a button!
            # publish_index_templates => {
            #     label => "Publish Template(s)",
            #     code => "${pkg}Template::publish_index_templates",
            #     permission => 'rebuild',
            #     condition => sub {
            #         my $app = MT->app;
            #         my $tmpl_type = $app->param('filter_key');
            #         return $app->mode eq 'itemset_action'  ? 1
            #              : !$app->blog                     ? 0
            #              : !$tmpl_type                     ? 0
            #              : $tmpl_type eq 'index_templates' ? 1
            #              :                                   0
            #              ;
            #     },
            #     order => 200,
            # },
            # Now a button!
            # publish_archive_templates => {
            #     label      => "Publish Template(s)",
            #     code       => "${pkg}Template::publish_archive_templates",
            #     permission => 'rebuild',
            #     condition  => sub {
            #         my $app       = MT->app;
            #         my $tmpl_type = $app->param('filter_key');
            #         return $app->mode eq 'itemset_action' ? 1
            #           : !$app->blog ? 0
            #           : !$tmpl_type ? 0
            #           : $tmpl_type eq 'archive_templates' ? 1
            #           :                                     0;
            #     },
            #     order => 300,
            # },
            copy_templates => {
                label      => "Clone Template(s)",
                code       => "${pkg}Template::clone_templates",
                permit_action => 'copy_template_via_list',
                condition  => sub {
                    my $app = MT->app;
                    my $tmpl_type = $app->param('filter_key') || '';
                    return
                          $tmpl_type eq 'system_templates' ? 0
                        : $tmpl_type eq 'email_templates'  ? 0
                        : $tmpl_type eq 'backup_templates'  ? 0
                        :                                    1;
                },
                order => 400,
            },
        },
        'banlist' => {
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
            },
        },
        'notification' => {
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
            },
        },
        'association' => {
            'delete' => {
                label      => 'Revoke Permission',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
            },
        },
        'role' => {
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
            },
        },
        'tag' => {
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
            },
        },
        'tag' => {
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
            },
        },
        'filter' => {
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete_filters',
                order      => 110,
                js_message => 'delete',
                xhr        => 1,
                button     => 1,
            },
        },
    };
}

sub _entry_label {
    my $app = MT->instance;
    my $type = $app->param('type') || 'entry';
    $app->model($type)->class_label_plural;
}

sub core_menus {
    my $app = shift;
    return {
        'website' => {
            label => "Websites",
            order => 50,
        },
        'blog' => {
            label => "Blogs",
            order => 100,
        },
        'entry' => {
            label => "Entries",
            order => 200,
        },
        'page' => {
            label => "Pages",
            order => 300,
        },
        'asset' => {
            label => "Assets",
            order => 400,
        },
        'feedback' => {
            label => "Comments",
            order => 500,
        },
        'user' => {
            label => sub {
                $app->translate( $app->blog ? 'Members' : 'Users' );
            },
            order => 600,
        },
        'design' => {
            label => "Design",
            order => 700,
        },
        'filter' => {
            label => "Listing Filters",
            order => 780,
        },
        'settings' => {
            label => "Settings",
            order => 800,
        },
        'tools' => {
            label => "Tools",
            order => 900,
        },

        'website:manage' => {
            label      => "Manage",
            order      => 100,
            mode       => "list",
            args       => { _type => "website" },
            view       => "system",
        },
        'website:create' => {
            label         => "New",
            order         => 200,
            mode          => 'view',
            args          => { _type => 'website' },
            permit_action => 'use_website:create_menu',
            view          => "system",
        },

        'blog:manage' => {
            label => "Manage",
            order => 100,
            mode  => "list",
            args  => { _type => "blog" },
            view  => [ "system", "website" ],
        },
        'blog:create' => {
            label         => "New",
            order         => 200,
            mode          => 'view',
            args          => { _type => 'blog' },
            permit_action => 'use_blog:create_menu',
            view          => "website",
        },

        'user:member' => {
            label      => "Manage",
            order      => 100,
            mode       => 'list',
            args       => { _type => 'member' },
            view       => [ "blog", "website" ],
            permission => 'administer_blog,manage_users,administer_website',
            system_permission => 'administer',
        },
        'user:manage' => {
            label      => "Manage",
            order      => 100,
            mode       => "list",
            args       => { _type => "author" },
            permission => "administer",
            view       => "system",
        },
        'user:commenter' => {
            label      => "Manage Commenter",
            order      => 151,
            mode       => "list",
            args       => { _type => "commenter" },
            permission => "administer",
            view       => "system",
            condition  => sub {
                return MT->config->SingleCommunity;
            },
        },
        'user:create' => {
            label      => "New",
            order      => 200,
            mode       => "view",
            args       => { _type => "author" },
            permission => "administer",
            condition  => sub {
                return !MT->config->ExternalUserManagement;
            },
            view => "system",
        },
        'user:itemset_action' => {
            order      => 10000,
            mode       => 'itemset_action',
            args       => { _type => "author" },
            display    => 0,
        },

        'entry:manage' => {
            label         => "Manage",
            order         => 100,
            mode          => 'list',
            args          => { _type => 'entry' },
            view          => [ "system", "blog", "website" ],
            condition => sub {
                return 1 if $app->user->is_superuser;

                my $blog = $app->blog;
                my $blog_ids = !$blog
                    ? undef
                    : $blog->is_blog
                        ? [ $blog->id ]
                        : [ map { $_->id } @{$blog->blogs} ];

                require MT::Permission;
                my $iter = MT::Permission->load_iter(
                    {
                        author_id => $app->user->id,
                        ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                    }
                );

                my $cond;
                while ( my $p = $iter->() ) {
                    $cond = 1, last
                        if $p->can_do('use_entry:manage_menu')
                }
                return $cond ? 1 : 0;
            },
        },
        'entry:create' => {
            label      => "New",
            order      => 200,
            mode       => 'view',
            args       => { _type => 'entry' },
            permission => 'create_post',
            view       => "blog",
        },
        'entry:category' => {
            label      => "Categories",
            order      => 300,
            mode       => 'list',
            args       => { _type => 'category' },
            permission => 'edit_categories',
            view       => "blog",
        },
        'entry:tag' => {
            label             => "Tags",
            order             => 400,
            mode              => 'list',
            args              => { _type => 'tag', filter_key => 'entry' },
            permission        => 'edit_tags',
            system_permission => 'administer',
            view              => [ "blog" ] ,
        },
        'entry:view_category' => {
            order      => 10000,
            mode       => 'view',
            args       => { _type => 'category' },
            view       => [ "blog", 'website', 'system' ],
            display    => 0,
        },

        'page:manage' => {
            label      => "Manage",
            order      => 100,
            mode       => 'list',
            args       => { _type => 'page' },
            view       => [ "system", "blog", 'website' ],
            condition => sub {
                return 1 if $app->user->is_superuser;

                my $blog = $app->blog;
                my $blog_ids = !$blog
                    ? undef
                    : $blog->is_blog
                        ? [ $blog->id ]
                        : [ $blog->id, map { $_->id } @{$blog->blogs} ];

                require MT::Permission;
                my $iter = MT::Permission->load_iter(
                    {
                        author_id => $app->user->id,
                        ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                    }
                );

                my $cond;
                while ( my $p = $iter->() ) {
                    $cond = 1, last
                        if $p->can_do('manage_pages')
                }
                return $cond ? 1 : 0;
            },
        },
        'page:create' => {
            label      => "New",
            order      => 200,
            mode       => 'view',
            args       => { _type => 'page' },
            permission => 'manage_pages',
            view       => [ "blog", 'website' ],
        },
        'page:folder' => {
            label      => "Folders",
            order      => 300,
            mode       => 'list',
            args       => { _type => 'folder' },
            permission => 'manage_pages',
            view       => [ "blog", 'website' ],
        },
        'page:tag' => {
            label             => "Tags",
            order             => 400,
            mode              => 'list',
            args              => { _type => 'tag', filter_key => 'page' },
            permission        => 'edit_tags',
            system_permission => 'administer',
            view              => [ "blog", 'website' ],
        },
        'page:view_folder' => {
            order      => 10000,
            mode       => 'view',
            args       => { _type => 'folder' },
            view       => [ "blog", 'website', 'system' ],
            display    => 0,
        },

        'asset:manage' => {
            label      => "Manage",
            order      => 100,
            mode       => 'list',
            args       => { _type => 'asset' },
            permission => '',
            view       => [ "system", "blog", 'website' ],
            condition => sub {
                return 1 if $app->user->is_superuser;

                my $blog = $app->blog;
                my $blog_ids = !$blog
                    ? undef
                    : $blog->is_blog
                        ? [ $blog->id ]
                        : [ $blog->id, map { $_->id } @{$blog->blogs} ];

                require MT::Permission;
                my $iter = MT::Permission->load_iter(
                    {
                        author_id => $app->user->id,
                        ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                    }
                );

                my $cond;
                while ( my $p = $iter->() ) {
                    $cond = 1, last
                        if $p->can_do('edit_assets')
                }
                return $cond ? 1 : 0;
            },
        },
        'asset:upload' => {
            label      => "New",
            order      => 200,
            mode       => 'start_upload',
            permission => 'upload,edit_assets',
            view       => [ "blog", 'website' ],
        },
        'asset:tag' => {
            label             => "Tags",
            order             => 400,
            mode              => 'list',
            args              => { _type => 'tag', filter_key => 'asset' },
            permission        => 'edit_tags',
            system_permission => 'administer',
            view              => [ "blog", 'website' ],
        },
        'asset:view_asset' => {
            order      => 10000,
            mode       => 'view',
            args       => { _type => 'asset' },
            view       => [ "blog", 'website', 'system' ],
            display    => 0,
        },
        'asset:upload_file' => {
            order      => 10000,
            mode       => 'upload_file',
            view       => [ "blog", 'website', 'system' ],
            display    => 0,
        },

        'feedback:comment' => {
            label     => "Comments",
            order     => 100,
            mode      => 'list',
            args      => { _type => 'comment' },
            condition => sub {
                return 1 if $app->user->is_superuser;

                my $blog = $app->blog;
                my $blog_ids = !$blog
                    ? undef
                    : $blog->is_blog
                        ? [ $blog->id ]
                        : [ $blog->id, map { $_->id } @{$blog->blogs} ];

                require MT::Permission;
                my $iter = MT::Permission->load_iter(
                    {
                        author_id => $app->user->id,
                        ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                    }
                );

                my $cond;
                while ( my $p = $iter->() ) {
                    $cond = 1, last
                        if $p->can_do('view_feedback')
                }
                return $cond ? 1 : 0;
            },
            view => [ "system", "blog", 'website' ],
        },
        'feedback:ping' => {
            label      => "TrackBacks",
            order      => 200,
            mode       => 'list',
            args       => { _type => 'ping' },
            view       => [ "system", "blog", 'website' ],
            condition => sub {
                return 1 if $app->user->is_superuser;

                my $blog = $app->blog;
                my $blog_ids = !$blog
                    ? undef
                    : $blog->is_blog
                        ? [ $blog->id ]
                        : [ $blog->id, map { $_->id } @{$blog->blogs} ];

                require MT::Permission;
                my $iter = MT::Permission->load_iter(
                    {
                        author_id => $app->user->id,
                        ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { not => 0 } ) ),
                    }
                );

                my $cond;
                while ( my $p = $iter->() ) {
                    $cond = 1, last
                        if $p->can_do('view_feedback')
                }
                return $cond ? 1 : 0;
            },
        },
        'feedback:view_comment' => {
            order      => 10000,
            mode       => 'view',
            args       => { _type => 'comment' },
            view       => [ "blog", 'website', 'system' ],
            display    => 0,
        },
        'feedback:view_ping' => {
            order      => 10010,
            mode       => 'view',
            args       => { _type => 'ping' },
            view       => [ "blog", 'website', 'system' ],
            display    => 0,
        },

        'design:template' => {
            label             => "Templates",
            order             => 100,
            mode              => 'list_template',
            permission        => 'edit_templates',
            system_permission => 'edit_templates',
            view              => [ "blog", 'website', 'system' ],
        },
        'design:widgets' => {
            label             => 'Widgets',
            order             => 200,
            mode              => 'list_widget',
            permission        => 'edit_templates',
            system_permission => "edit_templates",
            view              => [ "blog", 'website', 'system' ],
        },
        'design:themes' => {
            label => 'Themes',
            order => 500,
            mode  => 'list_theme',
            view  => [ "blog", 'website', 'system' ],
            permit_action => 'use_design:themes_menu',
        },
        'design:view_template' => {
            order      => 10000,
            mode       => 'view',
            args       => { _type => 'template' },
            view       => [ "blog", 'website', 'system' ],
            display    => 0,
        },
        'design:edit_widget' => {
            order      => 10000,
            mode       => 'edit_widget',
            view       => [ "blog", 'website', 'system' ],
            display    => 0,
        },

        'filter:member' => {
            label      => "Manage",
            order      => 100,
            mode       => 'list',
            args       => { _type => 'filter' },
            view       => "system",
            system_permission => 'administer',
        },

        'settings:general' => {
            label      => "General",
            order      => 100,
            mode       => 'cfg_prefs',
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => [ "blog", 'website' ],
        },
        'settings:compose' => {
            label      => "Compose",
            order      => 300,
            mode       => 'cfg_entry',
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => [ "blog", 'website' ],
        },
        'settings:feedback' => {
            label      => "Feedback",
            order      => 400,
            mode       => 'cfg_feedback',
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => [ "blog", 'website' ],
        },
        'settings:registration' => {
            label      => "Registration",
            order      => 500,
            mode       => 'cfg_registration',
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => [ "blog", 'website' ],
        },
        'settings:web_services' => {
            label      => "Web Services",
            order      => 600,
            mode       => 'cfg_web_services',
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => [ "blog", 'website' ],
        },
        'settings:ip_info' => {
            label      => "IP Banning",
            order      => 700,
            mode       => 'list',
            args       => { _type => 'banlist' },
            permission => 'manage_feedback',
            condition  => sub {
                $app->config->ShowIPInformation;
            },
            view              => [ "blog", 'website' ],
        },
        'settings:system' => {
            label      => "General",
            order      => 100,
            mode       => "cfg_system_general",
            view       => "system",
            permission => "administer",
        },
        'settings:user' => {
            label      => "User",
            order      => 200,
            mode       => "cfg_system_users",
            view       => "system",
            permission => "administer",
        },
        'settings:role' => {
            label             => "Roles",
            order             => 300,
            mode              => "list",
            args              => {
                _type => "role",
            },
            system_permission => 'administer',
            view              => "system",
        },
        'settings:association' => {
            label             => "Permissions",
            order             => 400,
            mode              => "list",
            args              => {
                _type => "association",
            },
            system_permission => 'administer',
            view              => "system",
        },
        'settings:view_role' => {
            order      => 10000,
            mode       => 'view',
            args       => { _type => 'role' },
            view       => 'system',
            display    => 0,
        },

        'tools:search' => {
            label             => "Search &amp; Replace",
            order             => 100,
            mode              => "search_replace",
            view              => [ "blog", 'website', 'system' ],
            condition         => sub {
                return 1 if $app->user->is_superuser;
                if ( $app->param('blog_id') ) {
                    my $perms = $app->user->permissions( $app->param('blog_id') );
                    return 0 unless $perms;
                    return 0 unless $perms->permissions;
                    return 0 unless $perms->can_do('use_tools:search');
                }
                return 1;
            }
        },
        'tools:plugins' => {
            label             => "Plugins",
            order             => 200,
            mode              => "cfg_plugins",
            permission        => "administer_blog",
            system_permission => "manage_plugins",
            view              => [ "blog", 'website', 'system' ],
        },
        'tools:import' => {
            label      => "Import Entries",
            order      => 400,
            mode       => "start_import",
            permission => "administer_blog",
            view       => "blog",
        },
        'tools:export' => {
            label      => "Export Entries",
            order      => 500,
            mode       => "start_export",
            permission => "administer_blog",
            view       => "blog",
        },
        'tools:themeexport' => {
            label      => "Export Theme",
            order      => 550,
            mode       => 'export_theme',
            permit_action => 'use_tools:themeexport_menu',
            view       => [ 'blog', 'website' ],
        },
        'tools:start_backup' => {
            label      => "Backup",
            order      => 600,
            mode       => "start_backup",
            permission => "administer_blog",
            view       => [ "blog", 'website', 'system' ],
        },
        'tools:restore' => {
            label      => "Restore",
            order      => 650,
            mode       => "start_restore",
            permission => "administer_blog",
            view       => "system",
        },
        'tools:notification' => {
            label      => "Address Book",
            order      => 700,
            mode       => 'list',
            args       => { _type => 'notification' },
            permission => 'edit_notifications',
            view       => [ "blog", 'website' ],
            condition  => sub {
                return $app->config->EnableAddressBook;
            },
        },
        'tools:activity_log' => {
            label             => "Activity Log",
            order             => 800,
            mode              => "list",
            args              => {
                _type => 'log',
            },
            permission        => "view_blog_log",
            system_permission => "view_log",
            view              => [ "blog", 'website', 'system' ],
        },
        'tools:system_information' => {
            label => "System Information",
            order => 900,
            mode  => "tools",
            view  => "system",
            permit_action => 'use_tools:system_info_menu',
        },
        'tools:do_export_theme' => {
            order      => 10000,
            mode       => 'do_export_theme',
            view       => [ 'blog', 'website' ],
            display    => 0,
        },
        'tools:backup' => {
            order      => 10000,
            mode       => 'backup',
            view       => [ "blog", 'website', 'system' ],
            display    => 0,
        },
    };
}

sub core_compose_menus {
    my $app = shift;

    return {
        compose_menus => {
            label => 'Create New',
            order => 100,
            menus => {
                'entry' => {
                    label      => "Entry",
                    order      => 100,
                    mode       => 'view',
                    args       => { _type => 'entry' },
                    permission => 'create_post',
                    view       => "blog",
                },
                'page' => {
                    label      => "Page",
                    order      => 200,
                    mode       => 'view',
                    args       => { _type => 'page' },
                    permission => 'manage_pages',
                    view       => [ "blog", 'website' ],
                },
                'asset' => {
                    label      => "Asset",
                    order      => 300,
                    mode       => 'start_upload',
                    permission => 'upload,edit_assets',
                    view       => [ "blog", 'website' ],
                },
                'website' => {
                    label         => "Website",
                    order         => 200,
                    mode          => 'view',
                    args          => { _type => 'website' },
                    permit_action => 'use_website:create_menu',
                    view          => "system",
                },
                'user' => {
                    label      => "User",
                    order      => 100,
                    mode       => "view",
                    args       => { _type => "author" },
                    permission => "administer",
                    condition  => sub {
                        return !MT->config->ExternalUserManagement;
                    },
                    view => "system",
                },
                'blog:create' => {
                    label         => "Blog",
                    order         => 400,
                    mode          => 'view',
                    args          => { _type => 'blog' },
                    permit_action => 'use_blog:create_menu',
                    view          => "website",
                },
            },
        },
    };
}

sub init_core_callbacks {
    my $app = shift;
    my $pkg = 'cms_';
    my $pfx = '$Core::MT::CMS::';
    $app->_register_core_callbacks(
        {

            # notification callbacks
            $pkg
                . 'save_permission_filter.notification' =>
                "${pfx}AddressBook::can_save",
            $pkg
                . 'save_filter.notification' =>
                "${pfx}AddressBook::save_filter",
            $pkg
                . 'post_delete.notification' =>
                "${pfx}AddressBook::post_delete",
            $pkg . 'pre_load_filtered_list.notification' => "${pfx}AddressBook::cms_pre_load_filtered_list",

            # banlist callbacks
            $pkg
                . 'save_permission_filter.banlist' =>
                "${pfx}BanList::can_save",
            $pkg . 'save_filter.banlist' => "${pfx}BanList::save_filter",
            $pkg . 'pre_load_filtered_list.banlist' => "${pfx}BanList::cms_pre_load_filtered_list",

            # associations
            $pkg
                . 'delete_permission_filter.association' =>
                "${pfx}User::can_delete_association",
            $pkg . 'pre_load_filtered_list.association'
                => "${pfx}User::cms_pre_load_filtered_list_assoc",

            # user callbacks
            $pkg . 'edit.author'                   => "${pfx}User::edit",
            $pkg . 'view_permission_filter.author' => "${pfx}User::can_view",
            $pkg . 'save_permission_filter.author' => "${pfx}User::can_save",
            $pkg
                . 'delete_permission_filter.author' =>
                "${pfx}User::can_delete",
            $pkg . 'save_filter.author' => "${pfx}User::save_filter",
            $pkg . 'pre_save.author'    => "${pfx}User::pre_save",
            $pkg . 'post_save.author'   => "${pfx}User::post_save",
            $pkg . 'post_delete.author' => "${pfx}User::post_delete",
            $pkg . 'pre_load_filtered_list.author' => sub {
                my ( $cb, $app, $filter, $opts, $cols ) = @_;
                my $terms = $opts->{terms};
                $terms->{type} = MT::Author::AUTHOR();
            },
            $pkg . 'pre_load_filtered_list.commenter' => sub {
                my ( $cb, $app, $filter, $opts, $cols ) = @_;
                my $terms = $opts->{terms};
                my $args = $opts->{args};
                $args->{joins} ||= [];
                push @{ $args->{joins} }, MT->model('permission')->join_on(
                    undef,
                    [
                        { blog_id => 0 },
                        '-and',
                        { author_id => \'= author_id', },
                        '-and',
                        [
                            { permissions => { like => '%comment%' } },
                            '-or',
                            { restrictions => { like => '%comment%' } },
                            '-or',
                            [
                                { permissions => \'IS NULL' },
                                '-and',
                                { restrictions => \'IS NULL' },
                            ],
                        ],
                    ],
                );
            },
            $pkg . 'pre_load_filtered_list.member' => sub {
                my ( $cb, $app, $filter, $opts, $cols ) = @_;
                my $terms = $opts->{terms};
                my $args = $opts->{args};
                $args->{joins} ||= [];
                if ( MT->config->SingleCommunity ) {
                    $terms->{type} = 1;
                    push @{ $args->{joins} }, MT->model('association')->join_on(
                        undef,
                        [
                            {
                                blog_id => $opts->{blog_ids},
                                author_id => { not => 0 },
                            },
                            'and',
                            {
                                author_id => \'= author_id',
                            },
                        ],
                        { unique => 1, },
                    );
                }
                else {
                    push @{ $args->{joins} }, MT->model('permission')->join_on(
                        undef,
                        [
                            {
                                blog_id => $opts->{blog_ids},
                                author_id => { not => 0 },
                            },
                            'and',
                            {
                                author_id => \'= author_id',
                            },
                        ],
                        { unique => 1, },
                    );
                }

            },

            # website callbacks
            $pkg . 'post_save.website'   => "${pfx}Website::post_save",
            $pkg . 'edit.website'        => "${pfx}Website::edit",
            $pkg . 'post_delete.website' => "${pfx}Website::post_delete",
            $pkg . 'save_permission_filter.website' => "${pfx}Website::can_save",
            $pkg . 'pre_load_filtered_list.website' => "${pfx}Website::cms_pre_load_filtered_list",

            # blog callbacks
            $pkg . 'edit.blog'                   => "${pfx}Blog::edit",
            $pkg . 'view_permission_filter.blog' => "${pfx}Blog::can_view",
            $pkg . 'save_permission_filter.blog' => "${pfx}Blog::can_save",
            $pkg
                . 'delete_permission_filter.blog' => "${pfx}Blog::can_delete",
            $pkg . 'pre_save.blog'    => "${pfx}Blog::pre_save",
            $pkg . 'post_save.blog'   => "${pfx}Blog::post_save",
            $pkg . 'save_filter.blog' => "${pfx}Blog::save_filter",
            $pkg . 'post_delete.blog' => "${pfx}Blog::post_delete",
            $pkg . 'pre_load_filtered_list.blog' => "${pfx}Blog::cms_pre_load_filtered_list",

            # folder callbacks
            $pkg . 'edit.folder' => "${pfx}Folder::edit",
            $pkg
                . 'view_permission_filter.folder' => "${pfx}Folder::can_view",
            $pkg
                . 'save_permission_filter.folder' => "${pfx}Folder::can_save",
            $pkg
                . 'delete_permission_filter.folder' =>
                "${pfx}Folder::can_delete",
            $pkg . 'pre_save.folder'    => "${pfx}Folder::pre_save",
            $pkg . 'post_save.folder'   => "${pfx}Folder::post_save",
            $pkg . 'save_filter.folder' => "${pfx}Folder::save_filter",
            $pkg . 'post_delete.folder' => "${pfx}Folder::post_delete",

            # category callbacks
            $pkg . 'edit.category' => "${pfx}Category::edit",
            $pkg
                . 'view_permission_filter.category' =>
                "${pfx}Category::can_view",
            $pkg
                . 'save_permission_filter.category' =>
                "${pfx}Category::can_save",
            $pkg
                . 'delete_permission_filter.category' =>
                "${pfx}Category::can_delete",
            $pkg . 'pre_save.category'    => "${pfx}Category::pre_save",
            $pkg . 'post_save.category'   => "${pfx}Category::post_save",
            $pkg . 'save_filter.category' => "${pfx}Category::save_filter",
            $pkg . 'post_delete.category' => "${pfx}Category::post_delete",
            $pkg . 'pre_load_filtered_list.category'
                => "${pfx}Category::pre_load_filtered_list",
            $pkg . 'filtered_list_param.category'
                => "${pfx}Category::filtered_list_param",
            $pkg . 'pre_load_filtered_list.folder'
                => "${pfx}Category::pre_load_filtered_list",
            $pkg . 'filtered_list_param.folder'
                => "${pfx}Category::filtered_list_param",

            # comment callbacks
            $pkg . 'edit.comment' => "${pfx}Comment::edit",
            $pkg
                . 'view_permission_filter.comment' =>
                "${pfx}Comment::can_view",
            $pkg
                . 'save_permission_filter.comment' =>
                "${pfx}Comment::can_save",
            $pkg
                . 'delete_permission_filter.comment' =>
                "${pfx}Comment::can_delete",
            $pkg . 'pre_save.comment'    => "${pfx}Comment::pre_save",
            $pkg . 'post_save.comment'   => "${pfx}Comment::post_save",
            $pkg . 'post_delete.comment' => "${pfx}Comment::post_delete",
            $pkg . 'pre_load_filtered_list.comment'
                => "${pfx}Comment::cms_pre_load_filtered_list",

            # commenter callbacks
            $pkg . 'edit.commenter' => "${pfx}Comment::edit_commenter",
            $pkg
                . 'view_permission_filter.commenter' =>
                "${pfx}Comment::can_view_commenter",
            $pkg
                . 'delete_permission_filter.commenter' =>
                "${pfx}Comment::can_delete_commenter",

            # entry callbacks
            $pkg . 'edit.entry'                   => "${pfx}Entry::edit",
            $pkg . 'view_permission_filter.entry' => "${pfx}Entry::can_view",
            $pkg
                . 'delete_permission_filter.entry' =>
                "${pfx}Entry::can_delete",
            $pkg . 'pre_save.entry'    => "${pfx}Entry::pre_save",
            $pkg . 'post_save.entry'   => "${pfx}Entry::post_save",
            $pkg . 'post_delete.entry' => "${pfx}Entry::post_delete",
            $pkg . 'pre_load_filtered_list.entry'
                => "${pfx}Entry::cms_pre_load_filtered_list",

            # page callbacks
            $pkg . 'edit.page'                   => "${pfx}Page::edit",
            $pkg . 'view_permission_filter.page' => "${pfx}Page::can_view",
            $pkg
                . 'delete_permission_filter.page' => "${pfx}Page::can_delete",
            $pkg . 'pre_save.page'    => "${pfx}Page::pre_save",
            $pkg . 'post_save.page'   => "${pfx}Page::post_save",
            $pkg . 'post_delete.page' => "${pfx}Page::post_delete",
            $pkg . 'pre_load_filtered_list.page'
                => "${pfx}Page::cms_pre_load_filtered_list",

            # ping callbacks
            $pkg . 'edit.ping' => "${pfx}TrackBack::edit",
            $pkg
                . 'view_permission_filter.ping' =>
                "${pfx}TrackBack::can_view",
            $pkg
                . 'save_permission_filter.ping' =>
                "${pfx}TrackBack::can_save",
            $pkg
                . 'delete_permission_filter.ping' =>
                "${pfx}TrackBack::can_delete",
            $pkg . 'pre_save.ping'    => "${pfx}TrackBack::pre_save",
            $pkg . 'post_save.ping'   => "${pfx}TrackBack::post_save",
            $pkg . 'post_delete.ping' => "${pfx}TrackBack::post_delete",
            $pkg . 'pre_load_filtered_list.ping'
                => "${pfx}TrackBack::cms_pre_load_filtered_list",

            # template callbacks
            $pkg . 'edit.template' => "${pfx}Template::edit",
            $pkg
                . 'view_permission_filter.template' =>
                "${pfx}Template::can_view",
            $pkg
                . 'save_permission_filter.template' =>
                "${pfx}Template::can_save",
            $pkg
                . 'delete_permission_filter.template' =>
                "${pfx}Template::can_delete",
            $pkg . 'pre_save.template'    => "${pfx}Template::pre_save",
            $pkg . 'post_save.template'   => "${pfx}Template::post_save",
            $pkg . 'post_delete.template' => "${pfx}Template::post_delete",
            'restore' => "${pfx}Template::restore_widgetmanagers",

            # tags
            $pkg . 'delete_permission_filter.tag' => "${pfx}Tag::can_delete",
            $pkg . 'post_delete.tag'              => "${pfx}Tag::post_delete",
            $pkg . 'pre_load_filtered_list.tag'   => "${pfx}Tag::cms_pre_load_filtered_list",

            # junk-related callbacks
            #'HandleJunk' => \&_builtin_spam_handler,
            #'HandleNotJunk' => \&_builtin_spam_unhandler,
            $pkg . 'not_junk_test' => "${pfx}Common::not_junk_test",

            # assets
            $pkg . 'edit.asset'                   => "${pfx}Asset::edit",
            $pkg . 'view_permission_filter.asset' => "${pfx}Asset::can_view",
            $pkg
                . 'delete_permission_filter.asset' =>
                "${pfx}Asset::can_delete",
            $pkg . 'pre_save.asset'     => "${pfx}Asset::pre_save",
            $pkg . 'post_save.asset'    => "${pfx}Asset::post_save",
            $pkg . 'post_delete.asset'  => "${pfx}Asset::post_delete",
            'template_param.edit_asset' => "${pfx}Asset::template_param_edit",
            $pkg . 'pre_load_filtered_list.asset'
                => "${pfx}Asset::cms_pre_load_filtered_list",

            # log
            $pkg . 'pre_load_filtered_list.log' => "${pfx}Log::cms_pre_load_filtered_list",
            'list_template_param.log' => "${pfx}Log::template_param_list",

        }
    );
}

sub permission_denied {
    my $app = shift;

    $app->return_to_dashboard(
        permission => 1,
    );
}

## TBD: This should be removed.
sub user_can_admin_commenters {
    my $app   = shift;
    my $perms = $app->permissions;
    $app->user->is_superuser()
        || ( $perms
        && ( $perms->can_administer_blog || $perms->can_manage_feedback ) );
}

sub validate_magic {
    my $app = shift;
    if ( my $feed_token = $app->param('feed_token') ) {
        return unless $app->user;
        my $pw = $app->user->api_password;
        return undef if ( $pw || '' ) eq '';
        my $auth_token = perl_sha1_digest_hex( 'feed:' . $pw );
        return $feed_token eq $auth_token;
    }
    else {
        return $app->SUPER::validate_magic(@_);
    }
}

sub is_authorized {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');
    $app->permissions(undef);
    return 1 unless $blog_id;
    return unless my $user = $app->user;
    my $perms = $app->permissions( $user->permissions($blog_id) );
    $perms
        ? 1
        : $app->error(
        $app->translate("You are not authorized to log in to this blog.") );
}

sub set_default_tmpl_params {
    my $app = shift;
    $app->SUPER::set_default_tmpl_params(@_);
    my ($tmpl) = @_;
    my $param = {};

    my $mode      = $app->mode;
    my $auth_mode = $app->config('AuthenticationModule');
    my ($pref) = split /\s+/, $auth_mode;

    $param->{debug_panels} = [];

    # TODO - remove after testing or after new IA is defined
    $param->{app_layout_fixed} = 0;
    $param->{athena_nav}       = 1;

    $param->{"auth_mode_$pref"} = 1;
    $param->{mt_news}           = $app->config('NewsURL');
    $param->{mt_support}        = $app->config('SupportURL');
    my $lang = lc MT->current_language || 'en_us';
    $param->{language_id} = ( $lang !~ /en[_-]us/ ) ? $lang : '';
    $param->{mode} = $app->mode;

    my $blog_id = $app->param('blog_id') || 0;
    my $blog;
    my $blog_class = $app->model('blog');
    $blog ||= $blog_class->load($blog_id) if $blog_id;
    if ( my $auth = $app->user ) {
        $param->{is_administrator} = $auth->is_superuser;
        $param->{can_create_newblog}  = $auth->can_create_blog;
        $param->{can_create_newbwebsite}  = $auth->can_create_website;
        $param->{can_view_log} ||= $auth->can_view_log;
        $param->{can_manage_plugins}    = $auth->can_manage_plugins;
        $param->{can_edit_templates}    = $auth->can_edit_templates;
        $param->{can_publish_feedbacks} = $auth->is_superuser;
        $param->{can_search_replace}    = $auth->is_superuser;
        $param->{has_authors_button}    = $auth->is_superuser;
        $param->{author_id}             = $auth->id;
        $param->{author_name}           = $auth->name;
        $param->{author_display_name}   = $auth->nickname || $auth->name;
        if (my ($url) = $auth->userpic_url(Width => 36, Height => 36)) {
            $param->{author_userpic_url}    = $url;
        }
    }

    if ( my $perms = $app->permissions ) {
        my $perm_hash = $perms->to_hash;
        foreach my $perm_name ( keys %$perm_hash ) {
            my $perm_token = $perm_name;
            $perm_token =~ s/^permission\.//;
            $param->{$perm_token} = $perm_hash->{$perm_name}
                if defined $perm_hash->{$perm_name};
        }
        $param->{can_edit_entries} 
            = $param->{can_create_post}
            || $param->{can_edit_all_entries}
            || $param->{can_publish_post};
        $param->{can_search_replace} = $param->{can_edit_all_posts};
        $param->{can_edit_authors}   = $param->{can_administer_blog};
        $param->{can_access_assets} 
            = $param->{can_create_post}
            || $param->{can_edit_all_posts}
            || $param->{can_edit_assets};
        $param->{can_edit_commenters} = $param->{can_manage_feedback};
        $param->{has_manage_label} 
            = $param->{can_edit_templates}
            || $param->{can_administer_blog}
            || $param->{can_edit_categories}
            || $param->{can_edit_config}
            || $param->{can_edit_tags}
            || $param->{can_set_publish_paths}
            || $param->{show_ip_info};
        $param->{has_posting_label} 
            = $param->{can_create_post}
            || $param->{can_edit_entries}
            || $param->{can_access_assets};
        $param->{has_community_label} = $param->{can_edit_entries}
            || $param->{can_edit_notifications};
        $param->{can_publish_feedbacks} 
            = $param->{can_manage_feedback}
            || $param->{can_publish_post}
            || $param->{can_edit_all_posts};
        $param->{can_view_log}     = $param->{can_view_blog_log};
        $param->{can_publish_post} = $param->{can_publish_post}
            || $param->{can_edit_all_posts};
        $param->{show_ip_info} = $app->config->ShowIPInformation
            && $param->{can_manage_feedback};
    }

    my $static_app_url = $app->static_path;
    $param->{help_url} = $app->help_url() || $static_app_url . 'docs/';

    $param->{show_ip_info} ||= $app->config('ShowIPInformation');
    my $type = $app->param('_type') || '';

    $param->{ "mode_$mode" . ( $type ? "_$type" : '' ) } = 1;
    $param->{return_args} ||= $app->make_return_args;
    $tmpl->param($param);
}

sub build_page {
    my $app = shift;
    my ( $page, $param ) = @_;
    $param ||= {};

    my $blog_id = $app->param('blog_id') || 0;
    my $blog;
    my $blog_class = $app->model('blog');
    $blog ||= $blog_class->load($blog_id) if $blog_id;
    if ($page ne 'login.tmpl') {
        if ($blog_id) {
            if ($blog) {
                my $scope_type = $blog->is_blog ? 'blog' : 'website';
                my $class = $app->model($scope_type);
                $param->{blog_name}         = $blog->name;
                $param->{blog_id}           = $blog->id;
                $param->{blog_url}          = $blog->site_url;
                $param->{blog_template_set} = $blog->template_set;
                $param->{is_blog}           = $blog->is_blog ? 1 : 0;
                $param->{scope_type}        = $scope_type;
                $param->{scope_label}       = $class->class_label;
                $param->{is_generic_website}   = 1
                    if !$blog->is_blog && ( !$blog->column('site_path') || !$blog->column('site_url'));
            }
            else {
                $app->error( $app->translate( "No such blog [_1]", $blog_id ) );
            }
        } else {
            $param->{scope_type} =
                !defined $app->param('blog_id') && $app->mode eq'dashboard'
                ? 'user'
                : 'system';
       }
    }
    if ( $page ne 'login.tmpl' ) {
        if ( ref $app eq 'MT::App::CMS' ) {
            $param->{system_overview_nav} = 1
                unless $blog_id
                    || exists $param->{system_overview_nav}
                    || $param->{no_breadcrumbs};
            $param->{quick_search} = 1 unless defined $param->{quick_search};
        }
    }

    my $build_blog_selector = exists $param->{build_blog_selector} ? $param->{build_blog_selector} : 1;
    $app->build_blog_selector($param) if $build_blog_selector;
    my $build_menus = exists $param->{build_menus} ? $param->{build_menus} : 1;
    $app->build_menus($param) if $build_menus;
    if ( !ref($page)
        || ( $page->isa('MT::Template') && !$page->param('page_actions') ) )
    {
        # Using a sub here to delay the loading of page actions, since not all
        # templates actually utilize them.
        $param->{page_actions} ||= sub { $app->page_actions( $app->mode ) };
    }
    my $build_compose_menus = exists $param->{build_compose_menus} ? $param->{build_compose_menus} : 1;
    $app->build_compose_menus( $param )
        if $build_compose_menus;

    $app->SUPER::build_page( $page, $param );
}

sub build_blog_selector {
    my $app = shift;
    my ($param) = @_;

    return if exists $param->{load_selector_data};

    my $blog = $app->blog;
    my $blog_id = $blog->id if $blog;
    $param->{dynamic_all} = $blog->custom_dynamic_templates eq 'all' if $blog;

    my $blog_class = $app->model('blog');
    my $website_class = $app->model('website');

    # Any access to a blog will put it on the top of your
    # recently used blogs list (the blog selector)
    if ( $blog && $blog->is_blog ) {
        $app->add_to_favorite_blogs($blog_id);
        $app->add_to_favorite_websites($blog->parent_id);
    } elsif ( $blog && !$blog->is_blog ) {
        $app->add_to_favorite_websites($blog_id);
    }
    my $auth = $app->user or return;

    # Load favorites blogs
    my @fav_blogs = @{ $auth->favorite_blogs || [] };
    if ( scalar @fav_blogs > 5 ) {
        @fav_blogs = @fav_blogs[ 0..4 ];
    }

    # How many blogs that the user can access?
    my %args;
    my %terms;
    $args{join} = MT::Permission->join_on( 'blog_id',
        { author_id => $auth->id, permissions => { not => "'comment'" } }
    ) if !$auth->is_superuser && !$auth->permissions(0)->can_do('edit_templates');
    $terms{class} = 'blog';
    $terms{parent_id} = \">0";
    $args{limit} = 6; # Don't load over 6 blogs
    my @blogs = $blog_class->load( \%terms, \%args );

    # Special case. If this user can access 5 blogs or smaller then load those blogs.
    $param->{selector_hide_blog_chooser} = 1;
    if ( @blogs && scalar @blogs == 6 ) {
        # This user can access over 6 blogs.
        if ( @fav_blogs ) {
            @blogs = $blog_class->load( { id => \@fav_blogs } );
        } else {
            @blogs = ();
        }
        $param->{selector_hide_blog_chooser} = 0;
    }


    # Load favorites or all websites
    my @fav_websites = @{ $auth->favorite_websites || [] };
    my @websites;
    @websites = $website_class->load({ id => \@fav_websites })
        if scalar @fav_websites;

    my $max_load = $blog && $blog->is_blog ? 3 : 4;
    if ( scalar @fav_websites < $max_load ) {
        # Load more accessible websites
        %args = ();
        %terms = ();

        $args{join} = MT::Permission->join_on( 'blog_id',
            { author_id => $auth->id, permissions => { not => "'comment'" } }
        ) if !$auth->is_superuser && !$auth->permissions(0)->can_do('edit_templates');
        $terms{class} = 'website';
        my $not_ids;
        push @$not_ids, @fav_websites;
        push @$not_ids, $blog->website->id if $blog && $blog->is_blog;
        $terms{id} = { not => $not_ids } if scalar @$not_ids;
        $args{limit} = $max_load - ( scalar @fav_websites ); # Don't load over 3 ~ 4 websites.
        my @sites = $website_class->load( \%terms, \%args );
        push @websites, @sites;
    }
    unshift @websites, $blog->website if $blog && $blog->is_blog;

    # Special case. If this user can access 3 websites or smaller then load those websites.
    $param->{selector_hide_website_chooser} = 1;
    if ( @websites && scalar @websites == 4 ) {
        pop @websites;
        $param->{selector_hide_website_chooser} = 0;
    }

    # Build selector data
    my @website_data;
    if (@websites) {
        for my $ws (@websites) {
            next unless $ws;

            my $blog_ids;
            push @$blog_ids, $ws->id;
            push @$blog_ids, ( map { $_->id } @{$ws->blogs} )
               if $ws->blogs;

            my @perms = MT::Permission->load(
                {
                    author_id => $auth->id,
                    blog_id   => $blog_ids,
                }
            );

            if (( $blog && $blog->is_blog && $blog->parent_id == $ws->id ) || ( $blog && !$blog->is_blog && $blog->id == $ws->id) ) {
                $param->{curr_website_id} = $ws->id;
                $param->{curr_website_name} = $ws->name;
                $param->{curr_website_can_link} = ( $auth->is_superuser || $auth->permissions(0)->can_do('edit_templates') || @perms > 0 ) ? 1 : 0;
            } else {
                my $fav_data;
                $fav_data->{ fav_website_id } = $ws->id;
                $fav_data->{ fav_website_name } = $ws->name;
                $fav_data->{ fav_website_can_link } = ( $auth->is_superuser || $auth->permissions(0)->can_do('edit_templates') || @perms > 0 ) ? 1 : 0;

                push @website_data, \%$fav_data;
            }
        }
    }
    $param->{fav_website_loop} = \@website_data;

    if ( !$param->{curr_website_id} ) {
        my $ws;
        if ( $blog && $blog->is_blog && $blog->website ) {
            $ws = $blog->website;
        } elsif ( $blog && !$blog->is_blog ) {
            $ws = $blog;
        }
        if ( $ws ) {
            $param->{curr_website_id} = $ws->id;
            $param->{curr_website_name} = $ws->name;
            $param->{curr_website_can_link} = 1;
        }
    }

    my @blog_data;
    if ( @blogs ) {
        foreach $b ( @blogs ) {
            if ( $blog && $blog->is_blog && $blog->id == $b->id ) {
                $param->{curr_blog_id} = $b->id;
                $param->{curr_blog_name} = $b->name;
            } else {
                my $fav_data;
                $fav_data->{ fav_blog_id } = $b->id;
                $fav_data->{ fav_blog_name } = $b->name;
                $fav_data->{ fav_parent_name } = $b->website->name if $b->website;
                $fav_data->{ fav_parent_id } = $b->website->id if $b->website;

                push @blog_data, \%$fav_data;
            }
        }
    }
    $param->{fav_blog_loop} = \@blog_data;

    if ( !$param->{curr_blog_id} ) {
        if ( $blog && $blog->is_blog ) {
            $param->{curr_blog_id} = $blog->id;
            $param->{curr_blog_name} = $blog->name;
        }
    }

    $param->{load_selector_data} = 1;
    $param->{can_create_blog} = $auth->can_do('create_blog') && $blog;
    $param->{can_create_website} = $auth->can_do('create_website');
    $param->{can_access_overview} = 1;
}

sub build_menus {
    my $app = shift;
    my ($param) = @_;
    return if exists $param->{top_nav_loop};

    my $menus        = $app->registry('menus');
    my $blog         = $app->blog;
    my $blog_id      = $blog ? $blog->id : 0;
    my $theme        = $blog ? $blog->theme : undef;
    my $theme_modify = $theme ? $theme->{menu_modification} : {};
    my $mode         = $app->mode;

    my @top_ids = grep { !/:/ } keys %$menus;
    my @top;
    my @sys;
    my $user = $app->user
      or return;
    my $perms = $app->permissions || $user->permissions;
    my $view = $app->view;
    my $hide_disabled_options = $app->config('HideDisabledMenus') || 1;

    my $admin =
      $user->is_superuser();    # || ($perms && $perms->has('administer_blog'));

    foreach my $id (@top_ids) {
        ## skip only if false value was set explicitly.
        next if exists $theme_modify->{$id} && !$theme_modify->{$id};
        my $menu = $menus->{$id};
        next if $menu->{view} && $menu->{view} ne $view;
        if ( my $cond = $menu->{condition} ) {
            if ( !ref($cond) ) {
                $cond = $menu->{condition} = $app->handler_to_coderef($cond);
            }
            next unless $cond->();
        }

        $menu->{allowed} = 1;
        $menu->{current} = 0;
        $menu->{'id'} = $id;

        my @sub_ids = grep { m/^$id:/ } keys %$menus;
        my @sub;
        foreach my $sub_id (@sub_ids) {
            ## skip only if false value was set explicitly.
            next
              if exists $theme_modify->{$sub_id} && !$theme_modify->{$sub_id};
            my $sub = $menus->{$sub_id};
            $sub->{current} = 0;

            ## Keep a compatibility
            $sub->{view} = [ 'blog', 'system' ]
                unless $sub->{view};

            if ( $sub->{view} ) {
                if ( ref $sub->{view} eq 'ARRAY' ) {
                    next
                      unless ( scalar grep { $_ eq $view } @{ $sub->{view} } );
                }
                else {
                    next if $sub->{view} ne $view;
                }
            }
            $sub->{view_permit} = 1;
            $sub->{'id'} = $sub_id;
            if ( my $cond = $sub->{condition} ) {
                if ( !ref($cond) ) {
                    $cond = $sub->{condition} = $app->handler_to_coderef($cond);
                }
                next unless $cond->();
            }

            my $app_param_type = $app->param('_type') || '';
            if ( $sub->{args} ) {
                next if !$sub->{args}->{_type};

                if ( $sub->{mode} eq $mode
                     && defined($app->param('_type'))
                     && $sub->{args}->{_type} eq $app->param('_type')
                     && ( !defined( $sub->{args}->{filter_key}) ||
                         ( defined($app->param('filter_key')) && $sub->{args}->{filter_key} eq $app->param('filter_key') ) ) )
                {
                    $param->{screen_group} = $id;
                    if ( $app->param('id') ) {
                        $sub->{current} = 1
                            if ( $app_param_type eq 'blog' )
                                || ( $app_param_type eq 'website' );
                    }
                    else {
                        $sub->{current} = 1;
                    }
                }
            }
            else {
                if ( $sub->{mode} eq $mode ) {
                    $param->{screen_group} = $id;
                    if ( $app->param('id') ) {
                        $sub->{current} = 1
                          if ( $app_param_type eq 'blog' )
                          || ( $app_param_type eq 'website' );
                    }
                    else {
                        $sub->{current} = 1;
                    }
                }
            }
            push @sub, $sub;
        }

        if (
            my $p =
              $blog_id
            ? $menu->{permission} || $menu->{system_permission}
            : $menu->{system_permission}
            || $menu->{permission}
          )
        {
            my $allowed = 0;
            my @p = split /,/, $p;
            foreach my $p (@p) {
                my $perm = 'can_' . $p;
                $allowed = 1, last if ( $perms && $perms->$perm() ) || $admin;
            }
            $menu->{allowed} = $allowed;
        }
        elsif ( my $action = $menu->{permit_action} ) {
            $menu->{allowed} = $app->can_do($action) ? 1 : 0;
        }
        elsif ( !$perms && !$blog_id ) {
            $menu->{allowed} = 0 if $menu->{system_permission} && !$admin;
        }

        next if $hide_disabled_options && ( !$menu->{allowed} );

        if (@sub) {
            if ( $id eq 'system' ) {
                push @sys, $menu;
            }
            else {
                push @top, $menu;
            }

            my $has_sub = 0;
            foreach my $sub (@sub) {
                next if defined $sub->{display} && !$sub->{display};
                my $sys_only = $sub->{id} =~ m/^system:/;
                $sub->{allowed} = 1;
                if ( $sub->{mode} ) {
                    $sub->{link} = $app->uri(
                        mode => $sub->{mode},
                        args => {
                            %{ $sub->{args} || {} },
                            (
                                ($blog_id && !$sys_only) || $app->view eq 'system'
                                ? ( blog_id => $blog_id )
                                : ()
                            )
                        }
                    );
                }
                $sub->{allowed} = 0
                  if $sub->{view} && ( !$sub->{view_permit} );
                if ( $sub->{allowed} ) {
                    my $sub_perms =
                      ( $sys_only || ( $sub->{view} || '' ) eq 'system' )
                      ? $app->user->permissions(0)
                      : $perms;
                    if (
                        $sub_perms
                        && (
                            my $p =
                              $blog_id
                            ? $sub->{permission} || $sub->{system_permission}
                            : $sub->{system_permission}
                            || $sub->{permission}
                        )
                      )
                    {
                        my $allowed = 0;
                        my @p = split /,/, $p;
                        foreach my $p (@p) {
                            my $perm = 'can_' . $p;
                            $allowed = 1, last
                              if ( $sub_perms && $sub_perms->$perm() )
                              || $admin;
                        }
                        $sub->{allowed} = $allowed;
                    }
                    elsif ( my $action = $sub->{permit_action} ) {
                        $sub->{allowed} = $app->can_do($action) ? 1 : 0;
                    }
                    elsif ( !$sub_perms && !$blog_id ) {
                        $sub->{allowed} = 0
                          if ( $sub->{system_permission}
                            || $sub->{permission} )
                          && !$admin;
                    }
                    $has_sub = 1 if $sub->{allowed};
                }
            }

            if ( $menu->{mode} ) {
                my $sys_only = 1 if $menu->{id} eq 'system';
                $menu->{link} = $app->uri(
                    mode => $menu->{mode},
                    args => {
                        %{ $menu->{args} || {} },
                        (
                            ($blog_id && !$sys_only) || $app->view eq 'system'
                                ? ( blog_id => $blog_id )
                                : ()
                        )
                    }
                );
            }
            @sub = sort { $a->{order} <=> $b->{order} } @sub;

            @sub = grep { $_->{allowed} } @sub if $hide_disabled_options;
            if ( !$menu->{mode} ) {
                $menu->{link} = $sub[0]->{link};
            }
            $menu->{sub_nav_loop} = \@sub;
            if ( $menu->{allowed} ) {
                $menu->{allowed} = 0 unless $has_sub;
            }
        }
    }

    @top = grep { $_->{allowed} } @top if $hide_disabled_options;
    @sys = grep { $_->{allowed} } @sys if $hide_disabled_options;
    @top = sort { $a->{order} <=> $b->{order} } @top;
    $param->{top_nav_loop} = \@top;
    $param->{sys_nav_loop} = \@sys;
    $param->{view}         = $view;
}

sub build_compose_menus {
    my $app = shift;
    my ( $param ) = @_;
    return if exists $param->{compose_menus};

    my $user = $app->user
      or return;

    my $scope = $app->blog
        ? $app->blog->is_blog
            ? 'blog'
            : 'website'
        : defined $app->param('blog_id')
            ? 'system'
            : 'user';
    my $blog_id = $app->blog
        ? $app->blog->id
        : 0;

    my $menus = $app->registry('compose_menus');
    my @root_keys = keys %$menus;
    my @root_menus;

    foreach my $root_key ( @root_keys ) {
        my @menus;
        my $items;
        my $sub_menus = $menus->{$root_key}{menus};

        foreach my $key ( keys %$sub_menus ) {
            my $item = $sub_menus->{$key};
            if ( $item->{view} ) {
                if ( ref $item->{view} eq 'ARRAY' ) {
                    next
                        unless ( scalar grep { $_ eq $scope } @{ $item->{view} } );
                }
                else {
                    next if $item->{view} ne $scope;
                }
            }
            if ( $item->{mode} ) {
                $item->{link} = $app->uri(
                    mode => $item->{mode},
                    args => {
                        %{ $item->{args} || {} },
                        (
                            $blog_id
                                ? ( blog_id => $blog_id )
                                : ()
                            )
                    }
                );
            }

            push @menus, $item;
        }
        next unless @menus;

        my $compose_menus = $app->filter_conditional_list( \@menus, ($param) );
        @$compose_menus = sort { $a->{order} <=> $b->{order} } @$compose_menus;
        $items->{menus} = $compose_menus;
        $items->{root_label} = $menus->{$root_key}{label};
        $items->{order} = $menus->{$root_key}{order};

        push @root_menus, $items;
    }

    @root_menus = sort { $a->{order} <=> $b->{order} } @root_menus;
    $param->{compose_menus} = \@root_menus;
}

sub return_to_dashboard {
    my $app = shift;
    my (%param) = @_;
    $param{redirect} = 1 unless %param;
    my $blog_id = $app->param('blog_id');
    $param{blog_id} = $blog_id if defined($blog_id) && $blog_id ne '';
    return $app->redirect(
        $app->uri( mode => 'dashboard', args => \%param ) );
}

sub return_to_user_dashboard {
    my $app = shift;
    my (%param) = @_;
    $param{redirect} = 1 unless %param;
    delete $param{blog_id} if exists $param{blog_id};
    return $app->redirect(
        $app->uri( mode => 'dashboard', args => \%param ) );
}

sub list_pref {
    my $app      = shift;
    my ($list)   = @_;
    my $updating = $app->mode eq 'update_list_prefs';
    unless ($updating) {
        my $pref = $app->request("list_pref_$list");
        return $pref if defined $pref;
    }

    my $cookie = $app->cookie_val('mt_list_pref') || '';
    my $mode = $app->mode;

    # defaults:
    my $d = $app->config->DefaultListPrefs || {};
    my %default = (
        Rows       => 25,
        Format     => 'Compact',
        SortOrder  => 'Ascend',      # Ascend|Descend
        Button     => 'Above',       # Above|Below|Both
        DateFormat => 'Relative',    # Relative|Full
    );
    if ( ( $list eq 'comment' ) || ( $list eq 'ping' ) ) {
        $default{Format} = 'expanded';
    }
    $default{$_} = lc( $d->{$_} ) for keys %$d;
    my $list_pref;
    if ( $list eq 'main_menu' ) {
        $list_pref = {
            'sort' => 'name',
            order  => $default{SortOrder} || 'ascend',
            view   => $default{Format} || 'compact',
            dates  => $default{DateFormat} || 'relative',
        };
    }
    else {
        $list_pref = {
            rows  => $default{Rows}       || 25,
            view  => $default{Format}     || 'compact',
            bar   => $default{Button}     || 'above',
            dates => $default{DateFormat} || 'relative',
        };
    }
    my @list_prefs = split /;/, $cookie;
    my $new_cookie = '';
    foreach my $pref (@list_prefs) {
        my ( $name, $prefs ) = $pref =~ m/^(\w+):(.*)$/;
        next unless $name && $prefs;
        if ( $name eq $list ) {
            my @prefs = split /,/, $prefs;
            foreach (@prefs) {
                my ( $k, $v ) = split /=/;
                $list_pref->{$k} = $v if exists $list_pref->{$k};
            }
        }
        else {
            $new_cookie .= ( $new_cookie ne '' ? ';' : '' ) . $pref;
        }
    }

    if ($updating) {
        my $updated = 0;
        if ( my $limit = $app->param('limit') ) {
            $limit = 20 if $limit eq 'none';
            $list_pref->{rows} = $limit > 0 ? $limit : 20;
            $updated = 1;
        }
        if ( my $view = $app->param('verbosity') ) {
            if ( $view =~ m!^compact|expanded$! ) {
                $list_pref->{view} = $view;
                $updated = 1;
            }
        }
        if ( my $bar = $app->param('actions') ) {
            if ( $bar =~ m!^above|below|both$! ) {
                $list_pref->{bar} = $bar;
                $updated = 1;
            }
        }
        if ( my $ord = $app->param('order') ) {
            if ( $ord =~ m!^ascend|descend$! ) {
                $list_pref->{order} = $ord;
                $updated = 1;
            }
        }
        if ( my $sort = $app->param('sort') ) {
            if ( $sort =~ m!^name|created|updated$! ) {
                $list_pref->{'sort'} = $sort;
                $updated = 1;
            }
        }
        if ( my $dates = $app->param('dates') ) {
            if ( $dates =~ m!^relative|full$! ) {
                $list_pref->{'dates'} = $dates;
                $updated = 1;
            }
        }

        if ($updated) {
            my @list_prefs;
            foreach ( keys %$list_pref ) {
                push @list_prefs, $_ . '=' . $list_pref->{$_};
            }
            my $prefs = join ',', @list_prefs;
            $new_cookie
                .= ( $new_cookie ne '' ? ';' : '' ) . $list . ':' . $prefs;
            $app->bake_cookie(
                -name    => 'mt_list_pref',
                -value   => $new_cookie,
                -expires => '+10y'
            );
        }
    }

    if ( $list_pref->{rows} ) {
        $list_pref->{ "limit_" . $list_pref->{rows} } = $list_pref->{rows};
    }
    if ( $list_pref->{view} ) {
        $list_pref->{ "view_" . $list_pref->{view} } = 1;
    }
    if ( $list_pref->{dates} ) {
        $list_pref->{ "dates_" . $list_pref->{dates} } = 1;
    }
    if ( $list_pref->{bar} ) {
        if ( lc $list_pref->{bar} eq 'both' ) {
            $list_pref->{"position_actions_both"}   = 1;
            $list_pref->{"position_actions_top"}    = 1;
            $list_pref->{"position_actions_bottom"} = 1;
        }
        elsif ( lc $list_pref->{bar} eq 'below' ) {
            $list_pref->{"position_actions_bottom"} = 1;
        }
        elsif ( lc $list_pref->{bar} eq 'above' ) {
            $list_pref->{"position_actions_top"} = 1;
        }
    }
    if ( $list_pref->{'sort'} ) {
        $list_pref->{ 'sort_' . $list_pref->{'sort'} } = 1;
    }
    if ( $list_pref->{'order'} ) {
        $list_pref->{ 'order_' . $list_pref->{'order'} } = 1;
    }
    $app->request( "list_pref_$list", $list_pref );
}

sub make_feed_link {
    my $app = shift;
    my ( $view, $params ) = @_;
    my $user = $app->user;
    return if ( $user->api_password || '' ) eq '';

    $params ||= {};
    $params->{view}     = $view;
    $params->{username} = $user->name;
    $params->{token} = perl_sha1_digest_hex( 'feed:' . $user->api_password );
    $app->base
        . $app->mt_path
        . $app->config('ActivityFeedScript')
        . $app->uri_params( args => $params );
}

sub show_error {
    my $app = shift;
    my ($param) = @_;

    # handle legacy scalar error string signature
    $param = { error => $param } unless ref($param) && ref($param) eq 'HASH';
    my $method_info = MT->request('method_info') || {};
    my $mode = $app->mode;
    if ( $method_info->{app_mode} && $method_info->{app_mode} eq 'JSON' ) {
        return $app->json_error( $param->{error}, $param->{status} );
    }
    elsif ( $mode eq 'rebuild' ) {

        my $r = MT::Request->instance;
        if ( my $tmpl = $r->cache('build_template') ) {

            # this is the template that likely caused the rebuild error
            my $tmpl_edit_link = $app->uri(
                        mode => 'view',
                        args => {
                            blog_id => $tmpl->blog_id,
                            '_type' => 'template',
                            id      => $tmpl->id
                        }
                    );

            if ( $app->param('fs') ) {
                $param->{fs} = 1;
                if ( exists $app->{goback} ) {
                    $param->{goback} = "window.location='" . $app->{goback} . "'";
                    if ( $tmpl_edit_link ne $app->{goback} ) {
                        push @{ $param->{button_loop} ||= [] },
                          {
                            link => $tmpl_edit_link,
                            label => $app->translate("Edit Template"),
                          };
                    }
                }
                else {
                    $param->{goback} = "window.location='$tmpl_edit_link'";
                }
            }
            else {
                push @{ $param->{button_loop} ||= [] },
                  {
                    link => $tmpl_edit_link,
                    label => $app->translate("Edit Template"),
                  };
            }
        }

        if ( !exists( $param->{goback} ) && exists( $app->{goback} ) ) {
            $param->{goback} = "window.location='" . $app->{goback} . "'";
        }
        else {
            my $blog_id = $app->param('blog_id');
            my $url     = $app->uri(
                mode => 'rebuild_confirm',
                args => { blog_id => $blog_id }
            );
            $param->{goback} ||= qq{window.location='$url'};
        }
        $param->{value} ||= $app->{value} || $app->translate('Go Back');
    }

    return $app->SUPER::show_error($param);
}

sub show_login {
    my $app   = shift;
    my $method_info = MT->request('method_info') || {};
    if ( $method_info->{app_mode} && $method_info->{app_mode} eq 'JSON' ) {
        $app->{login_again} = 1;
        return $app->show_error({ error => 'Unauthorized', status => 401 });
    }
    return $app->SUPER::show_login;
}

sub load_default_entry_prefs {
    my $app = shift;
    my $prefs;
    require MT::Permission;
    my $blog_id;
    $blog_id = $app->blog->id if $app->blog;
    my $perm
        = MT::Permission->load( { blog_id => $blog_id, author_id => 0 } );
    my %default = %{ $app->config->DefaultEntryPrefs };
    %default = map { lc $_ => $default{$_} } keys %default;
    if ( $perm && $perm->entry_prefs ) {
        $prefs = $perm->entry_prefs;
    }
    else {
        if ( lc( $default{type} ) eq 'custom' ) {
            my %map = (
                Category   => 'category',
                Excerpt    => 'excerpt',
                Keywords   => 'keywords',
                Tags       => 'tags',
                Publishing => 'publishing',
                Feedback   => 'feedback',
                Assets     => 'assets',
            );
            my @p;
            foreach my $p ( keys %map ) {
                push @p, $map{$p} . ':' . $default{ lc $p }
                    if $default{ lc $p };
            }
            $prefs = join ',', @p;
            $prefs ||= 'Custom';
        }
        elsif ( lc( $default{type} ) ne 'default' ) {
            $prefs = 'Advanced';
        }
        $default{button} = 'Bottom' if lc( $default{button} ) eq 'below';
        $default{button} = 'Top'    if lc( $default{button} ) eq 'above';
        $prefs .= '|' . $default{button} if $prefs;
    }
    $prefs ||= 'Default|Bottom';
    return $prefs;
}

sub load_default_page_prefs {
    my $app = shift;
    my $prefs;
    require MT::Permission;
    my $blog_id;
    $blog_id = $app->blog->id if $app->blog;
    my $perm = MT::Permission->load( { blog_id => $blog_id, author_id => 0 } );
    my %default = %{ $app->config->DefaultEntryPrefs };
    %default = map { lc $_ => $default{$_} } keys %default;

    if ( $perm && $perm->page_prefs ) {
        $prefs = $perm->page_prefs;
    }
    else {
        if ( lc( $default{type} ) eq 'custom' ) {
            my %map = (
                Category   => 'category',
                Excerpt    => 'excerpt',
                Keywords   => 'keywords',
                Tags       => 'tags',
                Publishing => 'publishing',
                Feedback   => 'feedback',
                Assets     => 'assets',
            );
            my @p;
            foreach my $p ( keys %map ) {
                push @p, $map{$p} . ':' . $default{ lc $p }
                  if $default{ lc $p };
            }
            $prefs = join ',', @p;
            $prefs ||= 'Custom';
        }
        elsif ( lc( $default{type} ) ne 'default' ) {
            $prefs = 'Advanced';
        }
        $default{button} = 'Bottom' if lc( $default{button} ) eq 'below';
        $default{button} = 'Top'    if lc( $default{button} ) eq 'above';
        $prefs .= '|' . $default{button} if $prefs;
    }
    $prefs ||= 'Default|Bottom';
    return $prefs;
}

sub load_template_prefs {
    my $app = shift;
    my ($prefs) = @_;
    my %param;

    if ( !$prefs ) {
        $prefs = '';
    }
    my @p = split /,/, $prefs;
    for my $p (@p) {
        if ( $p =~ m/^(.+?):(\d+)$/ ) {
            $param{ 'disp_prefs_height_' . $1 } = $2;
        }
    }
    \%param;
}

sub _parse_entry_prefs {
    my $app = shift;
    my ( $prefix, $prefs, $param, $fields ) = @_;
    my @p = split /,/, $prefs;
    for my $p (@p) {
        if ( $p =~ m/^(.+?):(\d+)$/ ) {
            my ( $name, $num ) = ( $1, $2 );
            if ($num) {
                $param->{ 'disp_prefs_height_' . $name } = $num;
            }
            $param->{ $prefix . 'disp_prefs_show_' . $name } = 1;
            push @$fields, { name => $name };
        }
        else {
            $p = 'Default' if lc($p) eq 'basic';
            if ( ( lc($p) eq 'advanced' ) || ( lc($p) eq 'default' ) ) {
                $param->{ $prefix . 'disp_prefs_' . $p } = 1;
                foreach my $def (
                    qw( title body category tags feedback publishing assets )
                  )
                {
                    $param->{ $prefix . 'disp_prefs_show_' . $def } = 1;
                    push @$fields, { name => $def };
                }
                if ( lc($p) eq 'advanced' ) {
                    foreach my $def (qw(excerpt feedback)) {
                        $param->{ $prefix . 'disp_prefs_show_' . $def } = 1;
                        push @$fields, { name => $def };
                    }
                }
            }
            else {
                $param->{ $prefix . 'disp_prefs_show_' . $p } = 1;
                push @$fields, { name => $p };
            }
        }
    }
}

sub load_entry_prefs {
    my $app = shift;
    my ($p) = @_;
    my %param;
    my $pos;
    my $is_from_db = 1;

    # defaults:
    my $type               = $p->{type} || 'entry';
    my $prefs              = $p->{prefs};
    my $prefix             = exists $p->{prefs} ? '' : $type . '_';
    my $load_default_prefs = 'load_default_' . $type . '_prefs';

    if ( !$prefs ) {
        $prefs = $app->$load_default_prefs;
        ( $prefs, $pos ) = split /\|/, $prefs;
        $is_from_db = 0;
        $app->_parse_entry_prefs( $prefix, $prefs, \%param, \my @fields );
        $param{disp_prefs_default_fields} = \@fields;
    }
    else {
        ( $prefs, $pos ) = split /\|/, $prefs;
    }
    $app->_parse_entry_prefs( $prefix, $prefs, \%param, \my @custom_fields );
    if ($is_from_db) {
        my $default_prefs = $app->$load_default_prefs;
        ( $default_prefs, my ($default_pos) ) = split /\|/, $default_prefs;
        $pos ||= $default_pos;
        $app->_parse_entry_prefs( $prefix, $default_prefs, \my %def_param,
            \my @fields );
        if ( $prefs eq 'Default' ) {
            foreach my $p ( keys %param ) {
                delete $param{$p} if $p =~ m/^${prefix}disp_prefs_show_/;
            }
        }
        if ( $param{disp_prefs_Default} ) {

            # apply default settings
            %param = ( %def_param, %param );
        }
        $param{disp_prefs_default_fields} = \@fields;
    }
    $pos ||= 'Bottom';
    if (   !exists $param{'disp_prefs_Default'}
        && !exists $param{'disp_prefs_Advanced'} )
    {
        $param{'disp_prefs_Custom'} = 1;
        $param{disp_prefs_custom_fields} = \@custom_fields if @custom_fields;
    }
    if ( lc $pos eq 'both' ) {
        $param{'position_actions_top'}    = 1;
        $param{'position_actions_bottom'} = 1;
        $param{'position_actions_both'}   = 1;
    }
    else {
        $param{ 'position_actions_' . $pos } = 1;
    }
    \%param;
}

sub _convert_word_chars {
    my ( $app, $s ) = @_;
    return '' if !defined($s) || ( $s eq '' );

    return $s if 'utf-8' ne lc( $app->charset );

    my $blog = $app->blog;
    my $smart_replace
        = $blog
        ? $blog->smart_replace
        : MT->config->NwcSmartReplace;
    return $s if $smart_replace == 2;

    require MT::Util;
    return MT::Util::convert_word_chars($s, $smart_replace);
}

sub _translate_naughty_words {
    my ($app, $entry) = @_;
    require MT::Util;
    return MT::Util::translate_naughty_words($entry);
}

sub autosave_session_obj {
    my $app           = shift;
    my ($or_make_one) = @_;
    my $q             = $app->param;
    my $type          = $q->param('_type');
    return unless $type;
    my $id = $q->param('id');
    $id = '0' unless $id;
    my $ident
        = 'autosave' 
        . ':user='
        . $app->user->id
        . ':type='
        . $type . ':id='
        . $id;

    if ( my $blog = $app->blog ) {
        $ident .= ':blog_id=' . $blog->id;
    }
    require MT::Session;
    my $sess_obj = MT::Session->load( { id => $ident, kind => 'AS' } );

    if ( !$sess_obj && $or_make_one ) {

        # autosave is being requested, so provision an object for saving
        $sess_obj = new MT::Session;
        $sess_obj->kind('AS');    # AutoSave record
        $sess_obj->id($ident);
        $sess_obj->start(time);
    }
    return $sess_obj;
}

sub autosave_object {
    my $app = shift;
    my $sess_obj = $app->autosave_session_obj(1) or return;
    $sess_obj->data('');
    my $class = $app->model( $app->param('_type') ) or return;
    my %data = $app->param_hash;
    delete $data{_autosave};
    delete $data{magic_token};

    # my $col_names = $class->column_names;
    # foreach my $c (@$col_names) {
    foreach my $c ( keys %data ) {
        $sess_obj->set( $c, $data{$c} );
    }
    $sess_obj->start(time);
    $sess_obj->save;
    $app->send_http_header("text/javascript+json");
    $app->{no_print_body} = 1;
    require JSON;
    $app->print_encode( "true" );
}

sub model {
    my $app    = shift;
    my ($type) = @_;
    my $class  = $app->SUPER::model($type)
        or return $app->error(
        $app->translate( "Unknown object type [_1]", $type ) );
    $class;
}
*_load_driver_for = \&model;

sub listify {
    my ($arr) = @_;
    my @ret;
    return unless ref($arr) eq 'ARRAY';
    foreach (@$arr) {
        push @ret, { name => $_ };
    }
    \@ret;
}

sub user_blog_prefs {
    my $app   = shift;
    my $prefs = $app->request('user_blog_prefs');
    return $prefs if $prefs && !$app->param('config_view');

    my $perms = $app->permissions;
    return {} unless $perms;
    my @prefs = split /,/, $perms->blog_prefs || '';
    my %prefs;
    foreach (@prefs) {
        my ( $name, $value ) = split /=/, $_, 2;
        $prefs{$name} = $value;
    }
    my $updated = 0;
    if ( my $view = $app->param('config_view') ) {
        $prefs{'config_view'} = $view;
        $updated = 1;
    }
    if ($updated) {
        my $pref = '';
        foreach ( keys %prefs ) {
            $pref .= ',' if $pref ne '';
            $pref .= $_ . '=' . $prefs{$_};
        }
        $perms->blog_prefs($pref);
        if ( !$perms->blog_id ) {
            my $blog = $app->blog;
            $perms->blog_id( $blog->id ) if $blog;
        }
        $perms->save if $perms->blog_id;
    }
    $app->request( 'user_blog_prefs', \%prefs );
    \%prefs;
}

sub archive_type_sorter {
    my ( $a, $b ) = @_;

    # Logical ordering for exact archive types
    my %order = (
        'Individual' => 1,
        'Page'       => 2,
        'Daily'      => 3,
        'Weekly'     => 4,
        'Monthly'    => 5,
        'Yearly'     => 6
    );
    my $ord_a = $order{ $a->{archive_type} };
    my $ord_b = $order{ $b->{archive_type} };

    if ( defined($ord_a) && defined($ord_b) ) {
        return $ord_a <=> $ord_b;
    }

    # in the event a custom archive type includes the keyword 'Weekly', etc.
    # order it based on the mapping above.
    unless ($ord_a) {
        if ( ( my $best ) = grep { $a->{archive_type} =~ m/$_/ } keys %order )
        {
            $ord_a = $order{$best};
        }
    }
    unless ($ord_b) {
        if ( ( my $best ) = grep { $b->{archive_type} =~ m/$_/ } keys %order )
        {
            $ord_b = $order{$best};
        }
    }

    # Unknown archive types will follow this pattern (typically)
    #    Foo
    #    Foo-Bar
    # ie, Tag, Tag-Daily, etc.
    # So the archive_type is taken and we'll strip off the second
    # piece, if it matches one of our keys in %order, the sort key
    # becomes Tagnn (where nn is a zero-padded weight, selected from
    # the order hash). Tag-Daily would become Tag02.
    # 'Tag-Rank' would just become TagRank and would sort underneath 'Tag'
    # and other 'Tagnn' keys.
    my $str_a = $a->{archive_type};
    if ( $str_a =~ s/-(.*)$// ) {
        $str_a .= $ord_a ? sprintf( "%02d", $ord_a ) : $1;
    }
    else {
        $str_a = "00" . $str_a if defined($ord_a);
    }

    my $str_b = $b->{archive_type};
    if ( $str_b =~ s/-(.*)$// ) {
        $str_b .= $ord_b ? sprintf( "%02d", $ord_b ) : $1;
    }
    else {
        $str_b = "00" . $str_b if defined($ord_b);
    }
    return $str_a cmp $str_b;
}

sub preview_object_basename {
    my $app = shift;
    my $q   = $app->param;
    my @parts;
    my $blog    = $app->blog;
    my $blog_id = $blog->id if $blog;
    my $id      = $q->param('id');
    push @parts, $app->user->id;
    push @parts, $blog_id || 0;
    push @parts, $id || 0;
    push @parts, $q->param('_type');
    push @parts, $app->config->SecretToken;
    my $data = join ",", @parts;
    return 'mt-preview-' . perl_sha1_digest_hex($data);
}

sub object_edit_uri {
    my $app = shift;
    my ( $type, $id ) = @_;
    my $class = $app->model($type);
    die "no such object $type" unless $class;
    my $obj = $class->load($id)
        or die "object_edit_uri could not find $type object $id";
    my $blog_id = $obj->column('blog_id') if $obj->has_column('blog_id');
    return $app->uri(
        'mode' => 'view',
        args   => {
            '_type' => $type,
            ( $blog_id ? ( blog_id => $blog_id ) : () ), id => $_[1]
        }
    );
}

sub add_to_favorite_blogs {
    my $app = shift;
    my ($fav) = @_;

    my $auth = $app->user;
    return unless $auth;

    return unless $auth->has_perm($fav)
        || $auth->is_superuser
        || $auth->permissions(0)->can_do('edit_templates');

    my @current = @{ $auth->favorite_blogs || [] };

    return if @current && ( $current[0] == $fav );
    @current = grep { $_ != $fav } @current;
    unshift @current, $fav;
    @current = @current[ 0 .. 9 ]
        if @current > 10;

    $auth->favorite_blogs( \@current );
    $auth->save;
}

sub add_to_favorite_websites {
    my $app = shift;
    my ($fav) = @_;

    my $auth = $app->user;
    return unless $auth;

    my $trust;
    my $blog_ids;
    push @$blog_ids, $fav;

    my @blogs = MT->model('blog')->load({ parent_id => $fav });
    push @$blog_ids, ( map { $_->id } @blogs )
        if @blogs;

    foreach my $id ( @$blog_ids ) {
        $trust = 1, last
            if $auth->has_perm($id);
    }

    return unless $trust
        || $auth->is_superuser
        || $auth->permissions(0)->can_do('edit_templates');

    my @current = @{ $auth->favorite_websites || [] };

    return if @current && ( $current[0] == $fav );
    @current = grep { $_ != $fav } @current;
    unshift @current, $fav;
    @current = @current[ 0 .. 2 ]
        if @current > 3;

    $auth->favorite_websites( \@current );
    $auth->save;
}

sub _entry_prefs_from_params {
    my $app      = shift;
    my ($prefix) = @_;
    my $q        = $app->param;
    my $disp     = $q->param('entry_prefs');
    my %fields;
    my $prefs = '';
    if ( $disp && lc $disp ne 'custom' ) {
        $fields{$disp} = 1;
    }
    elsif ( $disp && lc $disp eq 'custom' ) {
        my @fields = split /,/, $q->param( $prefix . 'custom_prefs' );
        foreach (@fields) {
            $prefs .= ',' if $prefs ne '';
            $prefs .= $_;
        }
    }
    else {
        $fields{$_} = 1 foreach $q->param( $prefix . 'custom_prefs' );
    }

    if ( my $body_height = $q->param('text_height') ) {
        $fields{'body'} = $body_height;
    }
    foreach ( keys %fields ) {
        $prefs .= ',' if $prefs ne '';
        $prefs .= $_;
        $prefs .= ':' . $fields{$_} if $fields{$_} > 1;
    }
    $prefs .= '|' . $q->param('bar_position');
    $prefs;
}

# rebuild_set is a hash whose keys are entry IDs
# the value can be the entry itself, for efficiency,
# but if the value is not a ref, the entry is loaded from the ID.
# This is not a handler but a utility routine
sub rebuild_these {
    my $app = shift;
    my ( $rebuild_set, %options ) = @_;

    # if there's nothing to rebuild, just return
    if ( !keys %$rebuild_set ) {
        if ( my $start_time = $app->param('start_time') ) {
            $app->publisher->start_time($start_time);
        }

        # now, rebuild indexes for affected blogs
        my @blogs = $app->param('blog_ids');
        if (@blogs) {
            $app->run_callbacks('pre_build') if @blogs;
            foreach my $blog_id (@blogs) {
                my $blog = MT::Blog->load($blog_id) or next;
                $app->rebuild_indexes( Blog => $blog )
                    or return $app->publish_error();
            }
            my $blog_id = int( $app->param('blog_id') );
            my $this_blog = MT::Blog->load($blog_id) if $blog_id;
            $app->run_callbacks( 'rebuild', $this_blog );
            $app->run_callbacks('post_build');
        }
        return $app->call_return;
    }

    if ( exists $options{how} && ( $options{how} eq NEW_PHASE ) ) {
        my $start_time = time;
        $app->run_callbacks('pre_build');
        my $params = {
            return_args => $app->return_args,
            blog_id     => $app->param('blog_id') || 0,
            id          => [ keys %$rebuild_set ],
            start_time  => $start_time,
        };
        my %param = (
            is_full_screen  => 1,
            redirect_target => $app->uri(
                mode => 'rebuild_phase',
                args => $params
            )
        );
        return $app->load_tmpl( 'rebuilding.tmpl', \%param );
    }
    else {
        my @blogs      = $app->param('blog_ids');
        my $start_time = $app->param('start_time');
        $app->publisher->start_time($start_time);
        my %blogs = map { $_ => () } @blogs;
        my @set = keys %$rebuild_set;
        my @rest;
        my $entries_per_rebuild = $app->config('EntriesPerRebuild');
        if ( scalar @set > $entries_per_rebuild ) {
            @rest = @set[ $entries_per_rebuild .. $#set ];
            @set  = @set[ 0 .. $entries_per_rebuild - 1 ];
        }
        require MT::Entry;
        for my $id (@set) {
            my $e = ref $id ? $id : MT::Entry->load($id) or next;
            my $type = $e->class;

            # Rebuilding something that isn't an entry, rebless as required
            #if ( $type ne MT::Entry->class_type ) {
            #    die "had to rebless? $e";
            #    my $pkg = MT->model($type) or next;
            #    bless $e, $pkg;
            #}
            $blogs{ $e->blog_id } = ();
            $app->rebuild_entry(
                Entry             => $e,
                BuildDependencies => 1,
                BuildIndexes      => 0
            ) or return $app->publish_error();
        }
        if (@rest) {
            foreach (@rest) {
                $_ = $_->id if ref $_;
            }
        }
        my $params = {
            return_args     => $app->param('return_args'),
            build_type_name => $app->translate("entry"),
            blog_id         => $app->param('blog_id') || 0,
            blog_ids        => [ keys %blogs ],
            id              => \@rest,
            start_time      => $start_time,
        };
        my %param = (
            is_full_screen  => 1,
            redirect_target => $app->uri(
                mode => 'rebuild_phase',
                args => $params
            )
        );
        return $app->load_tmpl( 'rebuilding.tmpl', \%param );
    }
}

sub remove_preview_file {
    my $app = shift;

    # Clear any preview file that may exist (returning from
    # a preview using the 'reedit', 'cancel' or 'save' buttons)
    if ( my $preview = $app->param('_preview_file') ) {
        require MT::Session;
        if (my $tf = MT::Session->load(
                {   id   => $preview,
                    kind => 'TF',
                }
            )
            )
        {
            my $file = $tf->name;
            my $fmgr = $app->blog->file_mgr;
            $fmgr->delete($file);
            $tf->remove;
        }
    }
}

sub load_text_filters {
    my $app = shift;
    my ( $selected, $type ) = @_;

    $selected = '0' unless defined $selected;

    my $filters = MT->all_text_filters;
    if ( $selected eq '1' ) {
        $selected = '__default__';
    }
    my @f;
    for my $filter ( keys %$filters ) {
        if ( my $c = $filters->{$filter}{condition} ) {
            $c = $app->handler_to_coderef($c) unless ref $c;
            next unless $c->($type);
        }
        my $label = $filters->{$filter}{label};
        $label = $label->() if ref($label) eq 'CODE';
        my $row = {
            key   => $filter,
            label => $label,
        };
        $row->{selected} = $filter eq $selected;
        push @f, $row;
    }
    @f = sort { $a->{label} cmp $b->{label} } @f;
    unshift @f,
        {
        key      => '0',
        label    => $app->translate('None'),
        selected => !$selected,
        };
    return \@f;
}

sub _build_category_list {
    my $app = shift;
    my (%param) = @_;

    my $blog_id         = $param{blog_id};
    my $new_cat_id      = $param{new_cat_id};
    my $include_markers = $param{markers};
    my $counts          = $param{counts};
    my $type            = $param{type};

    my @data;
    my %authors;

    my $class = $app->model($type) or return;

    my %expanded;

    if ($new_cat_id) {
        my $new_cat = $class->load($new_cat_id);
        my @parents = $new_cat->parent_categories;
        %expanded = map { $_->id => 1 } @parents;
    }

    my @cats    = $class->_flattened_category_hierarchy($blog_id);
    my $cols    = $class->column_names;
    my $depth   = 0;
    my $i       = 1;
    my $top_cat = 1;
    my ( $placement_counts, $tb_counts, %tb );

    if ($counts) {
        $app->model('placement');
        $app->model('trackback');
        $app->model('ping');

        my $max_cat_id = 0;
        foreach (@cats) {
            $max_cat_id = $_->id if ( ref $_ ) && ( $_->id > $max_cat_id );
        }

        $placement_counts = {};
        my $cat_entry_count_iter
            = MT::Placement->count_group_by( { blog_id => $blog_id },
            { group => ['category_id'] } );
        while ( my ( $count, $category_id ) = $cat_entry_count_iter->() ) {
            $placement_counts->{$category_id} = $count;
        }

        $tb_counts = {};
        my $tb_count_iter
            = MT::TBPing->count_group_by(
            { blog_id => $blog_id, junk_status => MT::TBPing::NOT_JUNK() },
            { group => ['tb_id'] } );
        while ( my ( $count, $tb_id ) = $tb_count_iter->() ) {
            $tb_counts->{$tb_id} = $count;
        }
        my $tb_iter = MT::Trackback->load_iter(
            {   blog_id     => $blog_id,
                category_id => [ 1, $max_cat_id ]
            },
            { range_incl => { 'category_id' => 1 } }
        );
        while ( my $tb = $tb_iter->() ) {
            $tb{ $tb->category_id } = $tb;
        }
    }

    while ( my $obj = shift @cats ) {
        my $row = {};
        if ( !ref($obj) ) {
            if ( $obj eq 'BEGIN_SUBCATS' ) {
                $depth++;
                $top_cat = 1;
            }
            elsif ( $obj eq 'END_SUBCATS' ) {
                $depth--;
            }
            push @data, { $obj => 1 } if $include_markers;
            next;
        }
        for my $col (@$cols) {
            $row->{ 'category_' . $col } = $obj->$col();
        }
        if ( $obj->class eq 'folder' ) {
            my $path = $obj->publish_path;
            $row->{category_selector_label} = $path;
            my $path_ids = [];
            foreach my $parent ( $obj->parent_categories ) {
                push @$path_ids, $parent->id;
            }
            $path .= $row->{category_label};
            @$path_ids = reverse @$path_ids;
            $row->{category_path_ids} = $path_ids;

            # $row->{category_label} = $path . '/';
            $row->{category_label_full} 
                = $row->{category_basename} . '/'
                . (
                $obj->label ne $row->{category_basename}
                ? ' <em>' . $obj->label . '</em>'
                : ''
                );
        }
        else {
            my $path     = '';
            my $path_ids = [];
            foreach my $parent ( $obj->parent_categories ) {
                push @$path_ids, $parent->id;
                $path .= $parent->label . ' &#8227; ';
            }
            $path .= $row->{category_label};
            @$path_ids                      = reverse @$path_ids;
            $row->{category_path_ids}       = $path_ids;
            $row->{category_selector_label} = $path;
            $row->{category_label_full}     = $row->{category_label};
        }
        $row->{category_label_spacer} = '&nbsp; ' x $depth;
        if ($counts) {
            $row->{category_entrycount}
                = $placement_counts
                ? ( $placement_counts->{ $obj->id } || 0 )
                : MT::Placement->count( { category_id => $obj->id } );
            if ( my $tb = $tb{ $obj->id } ) {
                $row->{has_tb} = 1;
                $row->{tb_id}  = $tb->id;
                $row->{category_tbcount}
                    = $tb_counts
                    ? ( $tb_counts->{ $tb->id } || 0 )
                    : MT::TBPing->count(
                    {   tb_id       => $tb->id,
                        junk_status => MT::TBPing::NOT_JUNK(),
                    }
                    );
            }
        }
        if ( my $fields = $obj->show_fields ) {
            my @fields = split /,/, $fields;
            $row->{category_fields} = \@fields;
        }
        $row->{category_is_expanded} = 1 if $expanded{ $obj->id };
        $row->{category_pixel_depth} = 10 * $depth;
        $row->{top_cat}              = $top_cat;
        $top_cat                     = 0;
        $row->{is_object}            = 1;
        push @data, $row;
    }
    \@data;
}

sub publish_error {
    my $app = shift;
    my ($msg) = @_;
    if ( defined $app->errstr ) {
        require MT::Log;
        $app->log(
            {   message => (
                    defined $msg ? $msg : $app->translate(
                        "Error during publishing: [_1]",
                        $app->errstr
                    )
                ),
                class    => "system",
                level    => MT::Log::ERROR(),
                category => "publish",
            }
        );
    }
    return undef;
}

sub template_paths {
    my $app = shift;
    my @paths;
    my $blog = $app->blog;
    if ( $blog ) {
        my $theme = $blog->theme;
        push @paths, $theme->alt_tmpl_path
            if $theme;
    }
    push @paths, $app->SUPER::template_paths( @_ );
    return @paths;
}

sub _load_child_blog_ids {
    my $app = shift;
    my ( $blog_id ) = @_;
    return unless $blog_id;

    my $blog_class = $app->model('blog');
    my $blog = $blog_class->load($blog_id);
    return unless $blog;

    my $user = $app->user;
    return unless $user;

    my @ids;
    if (!$blog->is_blog && $user->permissions($blog->id)->can_do('manage_member_blogs')) {
        my $blogs = $blog->blogs();
        @ids = map { $_->id } @$blogs
            if @$blogs;
    }

    return \@ids;
}

sub view {
    my $app = shift;
    my $blog = $app->blog;
    my $blog_id = $blog->id if $blog;

    return
        $blog_id
      ? $blog->is_blog
          ? "blog"
          : "website"
      : !defined $app->param('blog_id') && $app->mode eq 'dashboard'
          ? "user"
          : 'system';
}

1;
__END__

=head1 NAME

MT::App::CMS

=head1 SYNOPSIS

The I<MT::App::CMS> module is the primary application module for
Movable Type. It is the administrative interface that is used to
manage blogs, entries, comments, trackbacks, templates, etc.

=cut
