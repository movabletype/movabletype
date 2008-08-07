# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
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
        'delete'         => "${pkg}Common::delete",
        'search_replace' => "${pkg}Search::search_replace",

        ## Edit methods
        'edit_role'   => "${pkg}User::edit_role",
        'edit_widget' => "${pkg}Template::edit_widget",

        ## Listing methods
        'list_ping'     => "${pkg}TrackBack::list",
        'list_entry'    => "${pkg}Entry::list",
        'list_template' => "${pkg}Template::list",
        'list_widget'   => "${pkg}Template::list_widget",
        'list_page'     => "${pkg}Page::list",
        'list_comment'  => {
            handler    => "${pkg}Comment::list",
            permission => 'view_feedback',
        },
        'list_member'      => "${pkg}User::list_member",
        'list_user'        => "${pkg}User::list",
        'list_author'      => "${pkg}User::list",
        'list_commenter'   => "${pkg}Comment::list_commenter",
        'list_asset'       => "${pkg}Asset::list",
        'list_blog'        => "${pkg}Blog::list",
        'list_category'    => "${pkg}Category::list",
        'list_tag'         => "${pkg}Tag::list",
        'list_association' => "${pkg}User::list_association",
        'list_role'        => "${pkg}User::list_role",

        'asset_insert'        => "${pkg}Asset::insert",
        'asset_userpic'       => "${pkg}Asset::asset_userpic",
        'save_commenter_perm' => "${pkg}Comment::save_commenter_perm",
        'trust_commenter'     => "${pkg}Comment::trust_commenter",
        'ban_commenter'       => "${pkg}Comment::ban_commenter",
        'approve_item'        => "${pkg}Comment::approve_item",
        'unapprove_item'      => "${pkg}Comment::unapprove_item",
        'preview_entry'       => "${pkg}Entry::preview",

        ## Blog configuration screens
        'cfg_archives'     => "${pkg}Blog::cfg_archives",
        'cfg_prefs'        => "${pkg}Blog::cfg_prefs",
        'cfg_plugins'      => "${pkg}Plugin::cfg_plugins",
        'cfg_comments'     => "${pkg}Comment::cfg_comments",
        'cfg_trackbacks'   => "${pkg}TrackBack::cfg_trackbacks",
        'cfg_registration' => "${pkg}Comment::cfg_registration",
        'cfg_spam'         => "${pkg}Comment::cfg_spam",
        'cfg_entry'        => "${pkg}Entry::cfg_entry",
        'cfg_web_services' => "${pkg}Blog::cfg_web_services",

        ## Save
        'save_cat'     => "${pkg}Category::save",
        'save_entries' => "${pkg}Entry::save_entries",
        'save_pages'   => "${pkg}Page::save_pages",
        'save_entry'   => "${pkg}Entry::save",
        'save_role'    => "${pkg}User::save_role",
        'save_widget'  => "${pkg}Template::save_widget",

        ## Delete
        'delete_entry'  => "${pkg}Entry::delete",
        'delete_widget' => "${pkg}Template::delete_widget",

        ## List actions
        'enable_object'  => "${pkg}User::enable",
        'disable_object' => "${pkg}User::disable",
        'list_action'    => "${pkg}Tools::do_list_action",
        'empty_junk'     => "${pkg}Comment::empty_junk",
        'handle_junk'    => "${pkg}Comment::handle_junk",
        'not_junk'       => "${pkg}Comment::not_junk",

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

        'view_log'             => "${pkg}Log::view",
        'list_log'             => "${pkg}Log::view",
        'reset_log'            => "${pkg}Log::reset",
        'export_log'           => "${pkg}Log::export",
        'export_notification'  => "${pkg}AddressBook::export",
        'start_import'         => "${pkg}Import::start_import",
        'start_export'         => "${pkg}Export::start_export",
        'export'               => "${pkg}Export::export",
        'import'               => "${pkg}Import::do_import",
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
        'cfg_system'           => "${pkg}Tools::cfg_system_general",
        'cfg_system_users'     => "${pkg}User::cfg_system_users",
        'cfg_system_feedback'  => "${pkg}Comment::cfg_system_feedback",
        'save_plugin_config'   => "${pkg}Plugin::save_config",
        'reset_plugin_config'  => "${pkg}Plugin::reset_config",
        'save_cfg_system_feedback' =>
            "${pkg}Comment::save_cfg_system_feedback",
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
        'dialog_publishing_profile' =>
            "${pkg}Template::dialog_publishing_profile",
        'refresh_all_templates' => "${pkg}Template::refresh_all_templates",
        'preview_template'      => "${pkg}Template::preview",
        'publish_index_templates' =>
            "${pkg}Template::publish_index_templates",
        'publish_archive_templates' =>
            "${pkg}Template::publish_archive_templates",

        ## Comment Replies
        reply         => "${pkg}Comment::reply",
        do_reply      => "${pkg}Comment::do_reply",
        reply_preview => "${pkg}Comment::reply_preview",

        ## Dialogs
        'dialog_restore_upload'  => "${pkg}Tools::dialog_restore_upload",
        'dialog_adjust_sitepath' => "${pkg}Tools::dialog_adjust_sitepath",
        'dialog_post_comment'    => "${pkg}Comment::dialog_post_comment",
        'dialog_select_weblog'   => "${pkg}Blog::dialog_select_weblog",
        'dialog_select_sysadmin' => "${pkg}User::dialog_select_sysadmin",
        'dialog_grant_role'      => "${pkg}User::dialog_grant_role",
        'dialog_select_author'   => "${pkg}User::dialog_select_author",

        ## AJAX handlers
        'delete_map'        => "${pkg}Template::delete_map",
        'add_map'           => "${pkg}Template::add_map",
        'js_tag_check'      => "${pkg}Tag::js_tag_check",
        'js_tag_list'       => "${pkg}Tag::js_tag_list",
        'convert_to_html'   => "${pkg}Tools::convert_to_html",
        'update_list_prefs' => "${pkg}Tools::update_list_prefs",
        'js_add_category'   => "${pkg}Category::js_add_category",
        'remove_userpic'    => "${pkg}User::remove_userpic",

        # declared in MT::App
        'update_widget_prefs' =>
            sub { return shift->update_widget_prefs(@_) },

        'js_recent_entries_for_tag' => "${pkg}Tag::js_recent_entries_for_tag",

        ## DEPRECATED ##
        'list_pings'    => "${pkg}TrackBack::list",
        'list_entries'  => "${pkg}Entry::list",
        'list_pages'    => "${pkg}Page::list",
        'list_comments' => {
            handler    => "${pkg}Comment::list",
            permission => 'view_feedback',
        },
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
        new_install => {
            template => 'widget/new_install.tmpl',
            set      => 'main',    # forces this widget to the main group
            singular => 1,
        },
        new_user => {
            template => 'widget/new_user.tmpl',
            set      => 'main',    # forces this widget to the main group
            singular => 1,
        },
        new_version => {
            template => 'widget/new_version.tmpl',
            set      => 'main',
            singular => 1,
            handler  => "${pkg}Dashboard::new_version_widget",
        },
        this_is_you => {
            label    => 'This is You',
            template => 'widget/this_is_you.tmpl',
            handler  => "${pkg}Dashboard::this_is_you_widget",
            set      => 'sidebar',
            singular => 1,
        },
        mt_shortcuts => {
            label    => 'Handy Shortcuts',
            template => 'widget/mt_shortcuts.tmpl',
            singular => 1,
            set      => 'sidebar',
        },
        mt_news => {
            label    => 'Movable Type News',
            template => 'widget/mt_news.tmpl',
            handler  => "${pkg}Dashboard::mt_news_widget",
            singular => 1,
            set      => 'sidebar',
        },
        blog_stats => {
            label    => 'Blog Stats',
            template => 'widget/blog_stats.tmpl',
            handler  => "${pkg}Dashboard::mt_blog_stats_widget",
            singular => 1,
            set      => 'main',
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
                label     => "Refresh Blog Templates",
                dialog    => 'dialog_refresh_templates',
                condition => sub {
                    MT->app->blog,;
                },
                order => 1000,
            },
            refresh_global_templates => {
                label     => "Refresh Global Templates",
                dialog    => 'dialog_refresh_templates',
                condition => sub {
                    !MT->app->blog,;
                },
                order => 1000,
            },
            publishing_profile => {
                label     => "Use Publishing Profile",
                dialog    => 'dialog_publishing_profile',
                condition => sub {
                    MT->app->blog,;
                },
                order => 1100,
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
    $app->set_no_cache;
    $app->{requires_login} = 1
        unless exists $app->{requires_login};   # by default, we require login

    my $mode = $app->mode;

    # Global 'blog_id' parameter check; if we get something
    # other than an integer, die
    if ( my $blog_id = $app->param('blog_id') ) {
        if ( $blog_id ne int($blog_id) ) {
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

sub core_list_actions {
    my $app = shift;
    my $pkg = '$Core::MT::CMS::';
    return {
        'entry' => {
            'set_published' => {
                label      => "Publish Entries",
                order      => 100,
                code       => "${pkg}Entry::publish_entries",
                permission => 'edit_all_posts,publish_post',
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return $app->blog && $app->blog->site_path ? 1 : 0;
                },
            },
            'set_draft' => {
                label      => "Unpublish Entries",
                order      => 200,
                code       => "${pkg}Entry::draft_entries",
                permission => 'edit_all_posts,publish_post',
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return $app->blog && $app->blog->site_path ? 1 : 0;
                    }
            },
            'add_tags' => {
                label       => "Add Tags...",
                order       => 300,
                code        => "${pkg}Tag::add_tags_to_entries",
                input       => 1,
                input_label => 'Tags to add to selected entries',
                permission  => 'edit_all_posts',
                condition   => sub {
                    return $app->mode ne 'view';
                    }
            },
            'remove_tags' => {
                label       => "Remove Tags...",
                order       => 400,
                code        => "${pkg}Tag::remove_tags_from_entries",
                input       => 1,
                input_label => 'Tags to remove from selected entries',
                permission  => 'edit_all_posts',
                condition   => sub {
                    return $app->mode ne 'view';
                    }
            },
            'open_batch_editor' => {
                label     => "Batch Edit Entries",
                code      => "${pkg}Entry::open_batch_editor",
                order     => 500,
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    $app->param('blog_id')
                        && ( $app->user->is_superuser()
                        || $app->permissions->can_edit_all_posts );
                },
            },
        },
        'page' => {
            'set_published' => {
                label      => "Publish Pages",
                order      => 100,
                code       => "${pkg}Entry::publish_entries",
                permission => 'manage_pages',
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return $app->blog && $app->blog->site_path ? 1 : 0;
                },
            },
            'set_draft' => {
                label      => "Unpublish Pages",
                order      => 200,
                code       => "${pkg}Entry::draft_entries",
                permission => 'manage_pages',
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return $app->blog && $app->blog->site_path ? 1 : 0;
                },
            },
            'add_tags' => {
                label       => "Add Tags...",
                order       => 300,
                code        => "${pkg}Tag::add_tags_to_entries",
                input       => 1,
                input_label => 'Tags to add to selected pages',
                permission  => 'manage_pages',
                condition   => sub {
                    return $app->mode ne 'view';
                },
            },
            'remove_tags' => {
                label       => "Remove Tags...",
                order       => 400,
                code        => "${pkg}Tag::remove_tags_from_entries",
                input       => 1,
                input_label => 'Tags to remove from selected pages',
                permission  => 'manage_pages',
                condition   => sub {
                    return $app->mode ne 'view';
                },
            },
            'open_batch_editor' => {
                label     => "Batch Edit Pages",
                code      => "${pkg}Entry::open_batch_editor",
                order     => 500,
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    $app->param('blog_id')
                        && ( $app->user->is_superuser()
                        || $app->permissions->can_manage_pages );
                },
            },
        },
        'asset' => {
            'add_tags' => {
                label       => "Add Tags...",
                order       => 100,
                code        => "${pkg}Tag::add_tags_to_assets",
                input       => 1,
                input_label => 'Tags to add to selected assets',
                permission  => 'edit_assets',
            },
            'remove_tags' => {
                label       => "Remove Tags...",
                order       => 200,
                code        => "${pkg}Tag::remove_tags_from_assets",
                input       => 1,
                input_label => 'Tags to remove from selected assets',
                permission  => 'edit_assets',
            },
        },
        'ping' => {
            'unapprove_ping' => {
                label      => "Unpublish TrackBack(s)",
                order      => 100,
                code       => "${pkg}Comment::unapprove_item",
                permission => 'manage_feedback,publish_post',
            },
        },
        'comment' => {
            'unapprove_comment' => {
                label      => "Unpublish Comment(s)",
                order      => 100,
                code       => "${pkg}Comment::unapprove_item",
                permission => 'manage_feedback,publish_post',
                condition  => sub {
                    return 1;
                },
            },
            'trust_commenter' => {
                label      => "Trust Commenter(s)",
                order      => 200,
                code       => "${pkg}Comment::trust_commenter_by_comment",
                permission => 'manage_feedback',
            },
            'untrust_commenter' => {
                label      => "Untrust Commenter(s)",
                order      => 300,
                code       => "${pkg}Comment::untrust_commenter_by_comment",
                permission => 'manage_feedback',
            },
            'ban_commenter' => {
                label      => "Ban Commenter(s)",
                order      => 400,
                code       => "${pkg}Comment::ban_commenter_by_comment",
                permission => 'manage_feedback',
            },
            'unban_commenter' => {
                label      => "Unban Commenter(s)",
                order      => 500,
                code       => "${pkg}Comment::unban_commenter_by_comment",
                permission => 'manage_feedback',
            },
        },
        'commenter' => {
            'untrust' => {
                label      => "Untrust Commenter(s)",
                order      => 100,
                code       => "{$pkg}Comment::untrust_commenter",
                permission => 'manage_feedback',
            },
            'unban' => {
                label      => "Unban Commenter(s)",
                order      => 200,
                code       => "${pkg}Comment::unban_commenter",
                permission => 'manage_feedback',
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
                condition => sub {
                    $app->user->is_superuser();
                },
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
            },
        },
        'template' => {
            refresh_tmpl_templates => {
                label      => "Refresh Template(s)",
                code       => "${pkg}Template::refresh_individual_templates",
                permission => 'edit_templates',
                order      => 100,
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
                permission => 'edit_templates',
                condition  => sub {
                    my $app = MT->app;
                    my $tmpl_type = $app->param('filter_key') || '';
                    return
                          $tmpl_type eq 'system_templates' ? 0
                        : $tmpl_type eq 'email_templates'  ? 0
                        :                                    1;
                },
                order => 400,
            },
        },
    };
}

sub _entry_label {
    my $app = MT->instance;
    my $type = $app->param('type') || 'entry';
    $app->model($type)->class_label_plural;
}

sub core_list_filters {
    my $app = shift;
    return {
        asset => sub {
            require MT::CMS::Asset;
            return MT::CMS::Asset::asset_list_filters( $app, @_ );
        },
        entry => {
            published => {
                label => sub {
                    $app->translate( 'Published [_1]', _entry_label );
                },
                order   => 100,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    $terms->{status} = 2;
                },
            },
            unpublished => {
                label => sub {
                    $app->translate( 'Unpublished [_1]', _entry_label );
                },
                order   => 200,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    $terms->{status} = 1;
                },
            },
            scheduled => {
                label => sub {
                    $app->translate( 'Scheduled [_1]', _entry_label );
                },
                order   => 300,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    $terms->{status} = 4;
                },
            },
            my_posts => {
                label => sub {
                    $app->translate( 'My [_1]', _entry_label );
                },
                order   => 400,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    $terms->{author_id} = $app->user->id;
                },
            },
            received_comments_in_last_7_days => {
                label => sub {
                    $app->translate( '[_1] with comments in the last 7 days',
                        _entry_label );
                },
                order   => 500,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    my $ts = time - 10 * 24 * 60 * 60;
                    $ts = epoch2ts( MT->app->blog, $ts );
                    $args->{join} = MT::Comment->join_on(
                        'entry_id',
                        {   created_on  => [ $ts, undef ],
                            junk_status => MT::Comment::NOT_JUNK(),
                        },
                        { range_incl => { created_on => 1 }, unique => 1 }
                    );

                    # Since we're selecting content from the mt_entry
                    # table, but we want to sort by the joined
                    # 'comment_created_on' column, we have to specify the
                    # sort column as a reference and a full field name,
                    # to prevent MT from adding a 'entry_' prefix to
                    # the column name.
                    $args->{sort} = [ { column => \'comment_created_on' } ];
                    $args->{direction} = 'descend';
                },
            },
            _by_date => {
                label => sub {
                    my $app = MT->instance;
                    my $val = $app->param('filter_val');
                    my ( $from, $to ) = split /-/, $val;
                    $from = undef unless $from =~ m/^\d{8}$/;
                    $to   = undef unless $to   =~ m/^\d{8}$/;
                    my $format = '%x';
                    $from = format_ts(
                        $format, $from . '000000',
                        undef,   MT->current_language
                    ) if $from;
                    $to = format_ts(
                        $format, $to . '000000',
                        undef,   MT->current_language
                    ) if $to;
                    my $label = _entry_label;

                    if ( $from && $to ) {
                        return $app->translate(
                            '[_1] posted between [_2] and [_3]',
                            $label, $from, $to );
                    }
                    elsif ($from) {
                        return $app->translate( "[_1] posted since [_2]",
                            $label, $from );
                    }
                    elsif ($to) {
                        return $app->translate(
                            "[_1] posted on or before [_2]",
                            $label, $to );
                    }
                },
                handler => sub {
                    my ( $terms, $args ) = @_;
                    my $val = $app->param('filter_val');
                    my ( $from, $to ) = split /-/, $val;
                    $from = undef unless $from =~ m/^\d{8}$/;
                    $from .= '000000';
                    $to = undef unless $to =~ m/^\d{8}$/;
                    $to .= '235959';
                    $terms->{authored_on} = [ $from, $to ];
                    $args->{range_incl}{authored_on} = 1;
                },
            },
        },
        ping => {
            default => {
                label   => 'Non-spam TrackBacks',
                order   => 100,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::TBPing;
                    $terms->{junk_status} = MT::TBPing::NOT_JUNK();
                },
            },
            my_posts => {
                label   => 'TrackBacks on my entries',
                order   => 200,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::Entry;
                    my $app = MT->instance;
                    require MT::TBPing;
                    require MT::Trackback;
                    $terms->{junk_status} = MT::TBPing::NOT_JUNK();
                    $args->{join}         = MT::Trackback->join_on(
                        undef,
                        { id => \'= tbping_tb_id', },
                        {   join => MT::Entry->join_on(
                                undef,
                                {   id        => \'= trackback_entry_id',
                                    author_id => $app->user->id
                                }
                            )
                        },
                    );
                },
            },
            published => {
                label   => 'Published TrackBacks',
                order   => 200,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    $terms->{visible} = 1;
                },
            },
            unpublished => {
                label   => 'Unpublished TrackBacks',
                order   => 300,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::TBPing;
                    $terms->{junk_status} = MT::TBPing::NOT_JUNK();
                    $terms->{visible}     = 0;
                },
            },
            spam => {
                label   => 'TrackBacks marked as Spam',
                order   => 400,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::TBPing;
                    $terms->{junk_status} = MT::TBPing::JUNK();
                },
            },
            last_7_days => {
                label   => 'All TrackBacks in the last 7 days',
                order   => 700,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    my $ts = time - 7 * 24 * 60 * 60;
                    $ts = epoch2ts( MT->app->blog, $ts );
                    $terms->{created_on} = [ $ts, undef ];
                    $args->{range_incl}{created_on} = 1;
                    $terms->{junk_status} = MT::TBPing::NOT_JUNK();
                },
            },
        },
        comment => {
            default => {
                label   => 'Non-spam Comments',
                order   => 100,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::Comment;
                    $terms->{junk_status} = MT::Comment::NOT_JUNK();
                },
            },
            my_posts => {
                label   => 'Comments on my entries',
                order   => 200,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::Entry;
                    require MT::Comment;
                    my $app = MT->instance;
                    $terms->{junk_status} = MT::Comment::NOT_JUNK();

                    # This join syntax employs a hack that allows us
                    # to do joins on abitrary columns. Typically,
                    # objectdriver joins are applied with the primary
                    # key column of the driving table (here,
                    # mt_comment.comment_id), but we actually want to
                    # join to the mt_entry table where the entry_id
                    # matches to mt_comment.comment_entry_id (not the
                    # primary key). So by specifying NO 'join' column
                    # (which is always compared with the primary key),
                    # we specify the actual join conditions in the
                    # terms. And using a reference for the
                    # 'comment_entry_id' column name, to pass that
                    # on directly to the SQL statement that is generated.
                    $args->{join} = MT::Entry->join_on(
                        undef,
                        {   id        => \'= comment_entry_id',
                            author_id => $app->user->id
                        }
                    );
                },
            },
            unpublished => {
                label   => 'Pending comments',
                order   => 300,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::Comment;
                    $terms->{junk_status} = MT::Comment::NOT_JUNK();
                    $terms->{visible}     = 0;
                },
            },
            spam => {
                label   => 'Spam Comments',
                order   => 400,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::Comment;
                    $terms->{junk_status} = MT::Comment::JUNK();
                },
            },
            published => {
                label   => 'Published comments',
                order   => 500,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    $terms->{visible} = 1;
                },
            },
            last_7_days => {
                label   => 'Comments in the last 7 days',
                order   => 700,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::Comment;
                    my $ts = time - 7 * 24 * 60 * 60;
                    $ts = epoch2ts( MT->app->blog, $ts );
                    $terms->{created_on} = [ $ts, undef ];
                    $args->{range_incl}{created_on} = 1;
                    $terms->{junk_status} = MT::Comment::NOT_JUNK();
                },
            },
            _comments_by_user => {
                label => sub {
                    my $app     = MT->app;
                    my $user_id = $app->param('filter_val');
                    my $user    = MT::Author->load($user_id);
                    require MT::Author;
                    return $app->translate(
                        "All comments by [_1] '[_2]'",
                        (     $user->type == MT::Author::COMMENTER()
                            ? $app->translate("Commenter")
                            : $app->translate("Author")
                        ),
                        (     $user->nickname
                            ? $user->nickname . ' (' . $user->name . ')'
                            : $user->name
                        )
                    );
                },
                handler => sub {
                    my ( $terms, $args ) = @_;
                    my $cmtr_id = int( MT->app->param('filter_val') );
                    $terms->{commenter_id} = $cmtr_id;
                },
            },
            _comments_by_entry => {
                label => sub {
                    my $entry_id = MT->app->param('filter_val');
                    my $entry    = MT::Entry->load($entry_id);
                    return MT->translate( "All comments for [_1] '[_2]'",
                        $entry->class_label, $entry->title );
                },
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::Comment;
                    my $entry_id = int( MT->app->param('filter_val') );
                    $terms->{entry_id}    = $entry_id;
                    $terms->{junk_status} = MT::Comment::NOT_JUNK();
                },
            },
            _by_date => {
                label => sub {
                    my $app = MT->instance;
                    my $val = $app->param('filter_val');
                    my ( $from, $to ) = split /-/, $val;
                    $from = undef unless $from =~ m/^\d{8}$/;
                    $to   = undef unless $to   =~ m/^\d{8}$/;
                    my $format = '%x';
                    $from = format_ts(
                        $format, $from . '000000',
                        undef,   MT->current_language
                    ) if $from;
                    $to = format_ts(
                        $format, $to . '000000',
                        undef,   MT->current_language
                    ) if $to;

                    if ( $from && $to ) {
                        return $app->translate(
                            'Comments posted between [_1] and [_2]',
                            $from, $to );
                    }
                    elsif ($from) {
                        return $app->translate( "Comments posted since [_1]",
                            $from );
                    }
                    elsif ($to) {
                        return $app->translate(
                            "Comments posted on or before [_1]", $to );
                    }
                },
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::Comment;
                    my $val = $app->param('filter_val');
                    my ( $from, $to ) = split /-/, $val;
                    $from = undef unless $from =~ m/^\d{8}$/;
                    $from .= '000000';
                    $to = undef unless $to =~ m/^\d{8}$/;
                    $to .= '235959';
                    $terms->{junk_status}           = MT::Comment::NOT_JUNK();
                    $terms->{created_on}            = [ $from, $to ];
                    $args->{range_incl}{created_on} = 1;
                },
            },
        },
        template => {
            index_templates => {
                label   => "Index Templates",
                order   => 100,
                handler => sub {
                    my ( $terms, $args ) = @_;

                    # FIXME: enumeration of types
                    $terms->{type} = 'index';
                },
                condition => sub {
                    $app->param('blog_id');
                },
            },
            archive_templates => {
                label   => "Archive Templates",
                order   => 200,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    $terms->{type}
                        = [ 'individual', 'page', 'archive', 'category' ];
                },
                condition => sub {
                    $app->param('blog_id');
                },
            },
            module_templates => {
                label   => "Template Modules",
                order   => 400,
                handler => sub {
                    my ($terms) = @_;
                    $terms->{type} = 'custom';
                },
            },
            email_templates => {
                label   => "E-mail Templates",
                order   => 300,
                handler => sub {
                    my ($terms) = @_;
                    $terms->{type} = 'email';
                },
                condition => sub {
                    !$app->param('blog_id');
                },
            },
            system_templates => {
                label   => "System Templates",
                order   => 200,
                handler => sub {
                    my ($terms) = @_;
                    my $scope;
                    my $set;
                    if ( my $blog_id = $app->param('blog_id') ) {
                        my $blog = $app->model('blog')->load($blog_id);
                        $set = $blog->template_set;
                        $scope .= 'system';
                    }
                    else {
                        $terms->{blog_id} = 0;
                        $scope = 'global:system';
                    }
                    my @tmpl_path
                        = ( $set && ( $set ne 'mt_blog' ) )
                        ? ( "template_sets", $set, 'templates', $scope )
                        : ( "default_templates", $scope );
                    my $sys_tmpl = MT->registry(@tmpl_path) || {};
                    $terms->{type} = [ keys %$sys_tmpl ];
                },
                condition => sub {
                    $app->param('blog_id');
                },
            },
        },
        tag => {
            entry => {
                label => 'Tags with entries',
                order => 100,
            },
            page => {
                label => 'Tags with pages',
                order => 200,
            },
            asset => {
                label => 'Tags with assets',
                order => 300,
            },
        },
        sys_user => {
            enabled => {
                label   => 'Enabled Users',
                order   => 100,
                handler => sub {
                    my ($terms) = @_;
                    $terms->{status} = 1;
                },
            },
            disabled => {
                label   => "Disabled Users",
                order   => 200,
                handler => sub {
                    my ($terms) = @_;
                    $terms->{status} = 2;
                },
            },
            pending => {
                label   => "Pending Users",
                order   => 300,
                handler => sub {
                    my ($terms) = @_;
                    $terms->{status} = 3;
                },
            },
        },
        user => {
            author => {
                label   => 'Authors',
                order   => 100,
                handler => sub {
                    my ($terms) = @_;
                    require MT::Author;
                    $terms->{type} = MT::Author::AUTHOR();
                },
            },
            commenter => {
                label   => 'Commenters',
                order   => 200,
                handler => sub {
                    my ($terms) = @_;
                    require MT::Author;
                    $terms->{type} = MT::Author::COMMENTER();
                },
            },
        },
    };
}

sub core_menus {
    my $app = shift;
    return {
        'create' => {
            label => "Create",
            order => 100,
        },
        'manage' => {
            label => "Manage",
            order => 200,
        },
        'design' => {
            label => "Design",
            order => 300,
        },
        'prefs' => {
            label => "Preferences",
            order => 400,
        },
        'tools' => {
            label => "Tools",
            order => 500,
        },

        'create:blog' => {
            label => "Blog",
            order => 100,
            view  => "system",
        },
        'create:blog' => {
            label      => "Blog",
            order      => 200,
            view       => "system",
            mode       => "view",
            args       => { _type => "blog" },
            permission => "create_blog",
        },
        'create:user' => {
            label      => "User",
            order      => 200,
            view       => "system",
            mode       => "view",
            args       => { _type => "author" },
            permission => "administer",
            condition  => sub {
                return !MT->config->ExternalUserManagement;
            },
        },
        'create:entry' => {
            label      => "Entry",
            order      => 100,
            mode       => 'view',
            args       => { _type => 'entry' },
            permission => 'create_post',
            view       => "blog",
        },
        'create:page' => {
            label      => "Page",
            order      => 200,
            mode       => 'view',
            args       => { _type => 'page' },
            permission => 'manage_pages',
            view       => "blog",
        },
        'create:file' => {
            label      => "Upload File",
            order      => 300,
            dialog     => 'start_upload',
            permission => 'upload,edit_assets',
            view       => "blog",
        },

        'manage:blog' => {
            label => "Blogs",
            mode  => "list_blog",
            order => 100,
            view  => "system",
        },
        'manage:user' => {
            label      => "Users",
            mode       => "list_user",
            order      => 200,
            permission => "administer",
            view       => "system",
        },
        'manage:entry' => {
            label     => "Entries",
            mode      => 'list_entry',
            order     => 1000,
            condition => sub {
                return 1 if $app->user->is_superuser;
                if ( $app->param('blog_id') ) {
                    my $perms
                        = $app->user->permissions( $app->param('blog_id') );
                    return 1
                        if $perms->can_create_post
                            || $perms->can_publish_post
                            || $perms->can_edit_all_posts;
                }
                else {
                    require MT::Permission;
                    my @blogs
                        = map { $_->blog_id }
                        grep {
                        $_->can_create_post
                            || $_->can_publish_post
                            || $_->can_edit_all_posts
                        } MT::Permission->load(
                        { author_id => $app->user->id } );
                    return 1 if @blogs;
                }
                return 0;
            },

            #permission => 'create_post,publish_post,edit_all_posts',
        },
        'manage:comment' => {
            label     => "Comments",
            mode      => 'list_comment',
            order     => 2000,
            condition => sub {
                return 1 if $app->user->is_superuser;
                if ( $app->param('blog_id') ) {
                    my $perms
                        = $app->user->permissions( $app->param('blog_id') );
                    return 1
                        if $perms->can_create_post
                            || $perms->can_manage_feedback
                            || $perms->can_edit_all_posts
                            || $perms->can_comment;
                }
                else {
                    require MT::Permission;
                    my @blogs
                        = map { $_->blog_id }
                        grep {
                               $_->can_create_post
                            || $_->can_manage_feedback
                            || $_->can_edit_all_posts
                            || $_->can_comment
                        } MT::Permission->load(
                        { author_id => $app->user->id } );
                    return 1 if @blogs;
                }
                return 0;
            },

          #permission => 'create_post,edit_all_posts,manage_feedback,comment',
        },
        'manage:asset' => {
            label      => "Assets",
            mode       => 'list_asset',
            order      => 3000,
            permission => 'edit_assets',
        },
        'manage:page' => {
            label      => "Pages",
            mode       => 'list_pages',
            order      => 4000,
            permission => 'manage_pages',
        },
        'manage:ping' => {
            label      => "TrackBacks",
            mode       => 'list_pings',
            order      => 5000,
            permission => 'create_post,edit_all_posts,manage_feedback',
        },
        'manage:category' => {
            label      => "Categories",
            mode       => 'list_cat',
            order      => 6000,
            permission => 'edit_categories',
            view       => "blog",
        },
        'manage:folder' => {
            label      => "Folders",
            mode       => 'list_cat',
            args       => { _type => 'folder' },
            order      => 7000,
            permission => 'manage_pages',
            view       => "blog",
        },
        'manage:tag' => {
            label             => "Tags",
            mode              => 'list_tag',
            order             => 8000,
            permission        => 'edit_tags',
            system_permission => 'administer',
        },
        'manage:blog_user' => {
            label             => "Users",
            mode              => 'list_member',
            order             => 9000,
            view              => "blog",
            permission        => 'administer_blog',
            system_permission => 'administer',
        },
        'manage:notification' => {
            label      => "Address Book",
            mode       => 'list',
            args       => { _type => 'notification' },
            order      => 10000,
            permission => 'edit_notifications',
            view       => "blog",
            condition  => sub {
                return $app->config->EnableAddressBook;
            },
        },

        'design:template' => {
            label             => "Templates",
            mode              => 'list',
            args              => { _type => 'template' },
            order             => 100,
            permission        => 'edit_templates',
            system_permission => 'edit_templates',
        },
        'design:widgets' => {
            label             => 'Widgets',
            mode              => 'list_widget',
            order             => 200,
            permission        => 'edit_templates',
            system_permission => "edit_templates",
        },

        'prefs:general' => {
            label      => "General",
            order      => 100,
            mode       => "cfg_system",
            view       => "system",
            permission => "administer",
        },
        'prefs:user' => {
            label      => "User",
            order      => 200,
            mode       => "cfg_system_users",
            view       => "system",
            permission => "administer",
        },
        'prefs:feedback' => {
            label      => "Feedback",
            order      => 300,
            mode       => "cfg_system_feedback",
            view       => "system",
            permission => "administer",
        },
        'prefs:settings' => {
            label      => "General",
            mode       => 'cfg_prefs',
            order      => 100,
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => "blog",
        },
        'prefs:publishing' => {
            label      => "Publishing",
            mode       => 'cfg_archives',
            order      => 110,
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => "blog",
        },
        'prefs:entry' => {
            label      => "Entry",
            mode       => 'cfg_entry',
            order      => 120,
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => "blog",
        },
        'prefs:comment' => {
            label      => "Comment",
            mode       => 'cfg_comments',
            order      => 130,
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => "blog",
        },
        'prefs:trackback' => {
            label      => "TrackBack",
            mode       => 'cfg_trackbacks',
            order      => 140,
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => "blog",
        },
        'prefs:registration' => {
            label      => "Registration",
            mode       => 'cfg_registration',
            order      => 150,
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => "blog",
        },
        'prefs:spam' => {
            label      => "Spam",
            mode       => 'cfg_spam',
            order      => 160,
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => "blog",
        },
        'prefs:web_services' => {
            label      => "Web Services",
            mode       => 'cfg_web_services',
            order      => 170,
            permission => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => "blog",
        },

        'tools:plugins' => {
            label             => "Plugins",
            order             => 100,
            mode              => "cfg_plugins",
            permission        => "administer_blog",
            system_permission => "manage_plugins",
        },
        'tools:activity_log' => {
            label             => "Activity Log",
            order             => 200,
            mode              => "view_log",
            permission        => "view_blog_log",
            system_permission => "view_log",
        },
        'tools:import' => {
            label      => "Import",
            order      => 300,
            mode       => "start_import",
            view       => "blog",
            permission => "administer_blog",
        },
        'tools:export' => {
            label      => "Export",
            order      => 400,
            mode       => "start_export",
            view       => "blog",
            permission => "administer_blog",
        },
        'tools:backup' => {
            label      => "Backup",
            order      => 500,
            mode       => "start_backup",
            permission => "administer_blog",
        },
        'tools:restore' => {
            label      => "Restore",
            order      => 600,
            mode       => "start_restore",
            permission => "administer_blog",
            view       => "system",
        },
        'tools:system_information' => {
            label => "System Information",
            order => 700,
            mode  => "tools",
            view  => "system",
        },
        'tools:ip_info' => {
            label      => "IP Banning",
            mode       => 'list',
            args       => { _type => 'banlist' },
            order      => 900,
            permission => 'manage_feedback',
            condition  => sub {
                $app->config->ShowIPInformation;
            },
            view => "blog",
        },

        # System menu which is actually separate
        # in the CMS navigation
        'system' => {
            label => "System Overview",
            mode  => 'dashboard',
            order => 10000,
        },
        'system:user' => {
            label             => "Users",
            mode              => 'list_authors',
            order             => 100,
            permission        => 'administer_blog',
            system_permission => 'administer',
        },
        'system:blog' => {
            label => "Blogs",
            mode  => 'list_blogs',
            order => 200,
        },
        'system:template' => {
            label             => "Global Templates",
            mode              => 'list_template',
            order             => 250,
            system_permission => 'edit_templates',
        },
        'system:settings' => {
            label             => "Settings",
            mode              => 'cfg_system',
            order             => 300,
            system_permission => 'administer',
        },
        'system:plugins' => {
            label             => "Plugins",
            mode              => 'cfg_plugins',
            order             => 400,
            system_permission => 'manage_plugins',
        },
        'system:log' => {
            label             => "Activity Log",
            mode              => 'view_log',
            order             => 500,
            system_permission => 'view_log',
        },
        'system:tools' => {
            label             => "Tools",
            mode              => 'tools',
            order             => 600,
            system_permission => 'administer',
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

            # banlist callbacks
            $pkg
                . 'save_permission_filter.banlist' =>
                "${pfx}BanList::can_save",
            $pkg . 'save_filter.banlist' => "${pfx}BanList::save_filter",

            # associations
            $pkg
                . 'delete_permission_filter.association' =>
                "${pfx}User::can_delete_association",

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

            # page callbacks
            $pkg . 'edit.page'                   => "${pfx}Page::edit",
            $pkg . 'view_permission_filter.page' => "${pfx}Page::can_view",
            $pkg
                . 'delete_permission_filter.page' => "${pfx}Page::can_delete",
            $pkg . 'pre_save.page'    => "${pfx}Page::pre_save",
            $pkg . 'post_save.page'   => "${pfx}Page::post_save",
            $pkg . 'post_delete.page' => "${pfx}Page::post_delete",

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
        }
    );
}

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
        $param->{can_create_blog}  = $auth->can_create_blog;
        $param->{can_view_log} ||= $auth->can_view_log;
        $param->{can_manage_plugins}    = $auth->can_manage_plugins;
        $param->{can_edit_templates}    = $auth->can_edit_templates;
        $param->{can_publish_feedbacks} = $auth->is_superuser;
        $param->{can_search_replace}    = $auth->is_superuser;
        $param->{has_authors_button}    = $auth->is_superuser;
        $param->{author_id}             = $auth->id;
        $param->{author_name}           = $auth->name;
        $param->{author_display_name}   = $auth->nickname || $auth->name;
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
    if ( $blog_id && $page ne 'login.tmpl' ) {
        if ($blog) {
            $param->{blog_name}         = $blog->name;
            $param->{blog_id}           = $blog->id;
            $param->{blog_url}          = $blog->site_url;
            $param->{blog_template_set} = $blog->template_set;
        }
        else {
            $app->error( $app->translate( "No such blog [_1]", $blog_id ) );
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

    $app->build_blog_selector($param);
    $app->build_menus($param);
    if ( !ref($page)
        || ( $page->isa('MT::Template') && !$page->param('page_actions') ) )
    {
        $param->{page_actions} ||= $app->page_actions( $app->mode );
    }

    $app->SUPER::build_page( $page, $param );
}

sub build_blog_selector {
    my $app = shift;
    my ($param) = @_;

    return if exists $param->{top_blog_loop};

    my $blog = $app->blog;
    my $blog_id = $blog->id if $blog;
    $param->{dynamic_all} = $blog->custom_dynamic_templates eq 'all' if $blog;

    my $blog_class = $app->model('blog');
    my $auth = $app->user or return;

    # Any access to a blog will put it on the top of your
    # recently used blogs list (the blog selector)
    $app->add_to_favorite_blogs($blog_id) if $blog_id;

    my %args;
    $args{join} = MT::Permission->join_on( 'blog_id',
        { author_id => $auth->id, permissions => { not => "'comment'" } } );
    $args{limit} = 11;    # don't load more than 11
    my @blogs = $blog_class->load( undef, \%args );

    my @fav_blogs = @{ $auth->favorite_blogs || [] };
    @fav_blogs = grep { $_ != $blog_id } @fav_blogs if $blog_id;

    # Special case for when a user only has access to a single blog.
    if (   ( !defined( $app->param('blog_id') ) )
        && ( @blogs == 1 )
        && ( scalar @fav_blogs <= 1 ) )
    {

        # User only has visibility to a single blog. Don't
        # bother giving them a dashboard link for 'all blogs', or
        # to 'select a blog'.
        $param->{single_blog_mode} = 1;
        my $blog = $blogs[0];
        $blog_id = $blog->id;
        my $perms = MT::Permission->load(
            {   blog_id   => $blog_id,
                author_id => $auth->id
            }
        );
        if ( !$app->blog ) {
            if ( $app->mode eq 'dashboard' ) {
                $app->param( 'blog_id', $blog_id );
                $param->{blog_id}   = $blog_id;
                $param->{blog_name} = $blog->name;
                $app->permissions($perms);
                $app->blog($blog);
            }
            else {
                @fav_blogs = ($blog_id);
                $blog_id   = undef;
            }
        }
    }
    elsif ( @blogs && ( @blogs <= 10 ) ) {

        # This user only has visibility to 10 or fewer blogs;
        # no need to reference their 'favorite' blogs list.
        my @ids = map { $_->id } @blogs;
        if ($blog_id) {
            @ids = grep { $_ != $blog_id } @ids;
        }
        @fav_blogs = @ids;
        if ( $auth->is_superuser ) {

            # Better check to see if there are more than
            # 10 blogs in the system; if so, a superuser
            # will still want the 'Select a blog...' chooser.
            # Otherwise, hide it.
            my $all_blog_count = $blog_class->count();
            if ( $all_blog_count < 11 ) {
                $param->{selector_hide_chooser} = 1;
            }
        }
        else {

            # This user is not a superuser and only has
            # 10 blogs, so they don't need a 'select blog'
            # link...
            $param->{selector_hide_chooser} = 1;
        }
    }
    $param->{selector_hide_chooser} ||= 0;

    # Logic for populating the blog selector control
    #   * Pull list of 'favorite blogs' from user record
    #   * Load all of those blogs so we can display them
    #   * Exclude the current blog from the favorite list so it isn't
    #     shown twice.
    @blogs = $blog_class->load( { id => \@fav_blogs } ) if @fav_blogs;
    my %blogs = map { $_->id => $_ } @blogs;
    @blogs = ();
    foreach my $id (@fav_blogs) {
        push @blogs, $blogs{$id} if $blogs{$id};
    }

    my @data;
    if (@blogs) {
        my @perms = grep { !$_->is_empty } MT::Permission->load(
            {   author_id => $auth->id,
                blog_id   => \@fav_blogs,
            }
        );
        my %perms = map { $_->blog_id => $_ } @perms;
        for my $blog (@blogs) {
            my $perm = $perms{ $blog->id };
            next
                unless $auth->is_superuser || ( $perm && !$perm->is_empty );
            push @data,
                {
                top_blog_id   => $blog->id,
                top_blog_name => $blog->name
                };
            $data[-1]{top_blog_selected} = 1
                if $blog_id && ( $blog->id == $blog_id );
        }
    }
    $param->{top_blog_loop} = \@data;
    if ( !$app->user->can_create_blog
        && ( $param->{single_blog_mode} || scalar(@data) <= 1 ) )
    {
        $param->{no_submenu} = 1;
    }
}

sub build_menus {
    my $app = shift;
    my ($param) = @_;
    return if exists $param->{top_nav_loop};

    my $menus   = $app->registry('menus');
    my $blog    = $app->blog;
    my $blog_id = $blog->id if $blog;

    my @top_ids = grep { !/:/ } keys %$menus;
    my @top;
    my @sys;
    my $user = $app->user
        or return;
    my $perms = $app->permissions || $user->permissions;
    my $view = $blog_id ? "blog" : "system";

    my $hide_disabled_options = $app->config('HideDisabledMenus') || 0;

    my $admin = $user->is_superuser()
        ;    # || ($perms && $perms->has('administer_blog'));

    foreach my $id (@top_ids) {
        my $menu = $menus->{$id};
        next if $menu->{view} && $menu->{view} ne $view;
        if ( my $cond = $menu->{condition} ) {
            if ( !ref($cond) ) {
                $cond = $menu->{condition} = $app->handler_to_coderef($cond);
            }
            next unless $cond->();
        }

        $menu->{allowed} = 1;
        $menu->{'id'} = $id;

        my @sub_ids = grep {m/^$id:/} keys %$menus;
        my @sub;
        foreach my $sub_id (@sub_ids) {
            my $sub = $menus->{$sub_id};
            next
                if $sub->{view}
                    && ( $sub->{view} ne $view );
            $sub->{'id'} = $sub_id;
            if ( my $cond = $sub->{condition} ) {
                if ( !ref($cond) ) {
                    $cond = $sub->{condition}
                        = $app->handler_to_coderef($cond);
                }
                next unless $cond->();
            }
            push @sub, $sub;
        }

        if (my $p
            = $blog_id
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
                my $sys_only = $sub->{id} =~ m/^system:/;
                $sub->{allowed} = 1;
                if ( $sub->{mode} ) {
                    $sub->{link} = $app->uri(
                        mode => $sub->{mode},
                        args => {
                            %{ $sub->{args} || {} },
                            (   $blog_id && !$sys_only
                                ? ( blog_id => $blog_id )
                                : ()
                            )
                        }
                    );
                }
                $sub->{allowed} = 0
                    if $sub->{view} && ( $sub->{view} ne $view );
                if ( $sub->{allowed} ) {
                    my $sub_perms
                        = ( $sys_only || ( $sub->{view} || '' ) eq 'system' )
                        ? $app->user->permissions(0)
                        : $perms;
                    if ($sub_perms
                        && (my $p
                            = $blog_id
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
                        (   $blog_id
                                && !$sys_only ? ( blog_id => $blog_id ) : ()
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
}

sub return_to_dashboard {
    my $app = shift;
    my (%param) = @_;
    $param{redirect} = 1 unless %param;
    my $blog_id = $app->param('blog_id');
    $param{blog_id} = $blog_id if $blog_id;
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
    $param = { error => $param } unless ref($param) eq 'HASH';

    my $mode = $app->mode;
    if ( $mode eq 'rebuild' ) {

        my $r = MT::Request->instance;
        if ( my $tmpl = $r->cache('build_template') ) {

            # this is the template that likely caused the rebuild error
            push @{ $param->{button_loop} ||= [] },
                {
                link => $app->uri(
                    mode => 'view',
                    args => {
                        blog_id => $tmpl->blog_id,
                        '_type' => 'template',
                        id      => $tmpl->id
                    }
                ),
                label => $app->translate("Edit Template"),
                };
        }

        my $blog_id = $app->param('blog_id');
        my $url     = $app->uri(
            mode => 'rebuild_confirm',
            args => { blog_id => $blog_id }
        );
        $param->{goback} ||= qq{window.location='$url'};
        $param->{value}  ||= $app->translate('Go Back');
    }

    return $app->SUPER::show_error($param);
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
            );
            my @p;
            foreach my $p ( keys %map ) {
                push @p,
                    $map{$p} . ':' . ( $default{$p} || $default{ lc $p } )
                    if ( $default{$p} || $default{ lc $p } );
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
    my ( $prefs, $param ) = @_;

    my @p = split /,/, $prefs;
    for my $p (@p) {
        if ( $p =~ m/^(.+?):(\d+)$/ ) {
            my ( $name, $num ) = ( $1, $2 );
            if ($num) {
                $param->{ 'disp_prefs_height_' . $name } = $num;
            }
            $param->{ 'disp_prefs_show_' . $name } = 1;
        }
        else {
            $p = 'Default' if lc($p) eq 'basic';
            if ( ( lc($p) eq 'advanced' ) || ( lc($p) eq 'default' ) ) {
                $param->{ 'disp_prefs_' . $p } = 1;
                foreach my $def (
                    qw(title body category tags keywords feedback publishing )
                    )
                {
                    $param->{ 'disp_prefs_show_' . $def } = 1;
                }
                if ( lc($p) eq 'advanced' ) {
                    foreach my $def (qw(excerpt feedback)) {
                        $param->{ 'disp_prefs_show_' . $def } = 1;
                    }
                }
            }
            else {
                $param->{ 'disp_prefs_show_' . $p } = 1;
            }
        }
    }
}

sub load_entry_prefs {
    my $app = shift;
    my ($prefs) = @_;
    my %param;
    my $pos;
    my $is_from_db = 1;

    # defaults:
    if ( !$prefs ) {
        $prefs = $app->load_default_entry_prefs;
        ( $prefs, $pos ) = split /\|/, $prefs;
        $is_from_db = 0;
        $app->_parse_entry_prefs( $prefs, \%param );
        my @fields;
        foreach ( keys %param ) {
            if (m/^disp_prefs_show_(.+)/) {
                push @fields, { name => $1 };
            }
        }
        $param{disp_prefs_default_fields} = \@fields;
    }
    else {
        ( $prefs, $pos ) = split /\|/, $prefs;
    }
    $app->_parse_entry_prefs( $prefs, \%param );
    if ($is_from_db) {
        my $default_prefs = $app->load_default_entry_prefs;
        ( $default_prefs, my ($default_pos) ) = split /\|/, $default_prefs;
        $pos ||= $default_pos;
        $app->_parse_entry_prefs( $default_prefs, \my %def_param );
        my @fields;
        foreach ( keys %def_param ) {
            if (m/^disp_prefs_show_(.+)/) {
                push @fields, { name => $1 };
            }
        }
        if ( $prefs eq 'Default' ) {
            foreach my $p ( keys %param ) {
                delete $param{$p} if $p =~ m/^disp_prefs_show_/;
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
    return '' unless $s;
    return $s if 'utf-8' ne lc( $app->charset );

    my $blog = $app->blog;
    my $smart_replace
        = $blog
        ? $blog->smart_replace
        : MT->config->NwcSmartReplace;
    return $s if $smart_replace == 2;

    if ($smart_replace) {

        # html character entity replacements
        $s =~ s/\342\200\231/&#8217;/g;
        $s =~ s/\342\200\230/&#8216;/g;
        $s =~ s/\342\200\246/&#133;/g;
        $s =~ s/\342\200\223/-/g;
        $s =~ s/\342\200\224/&#8212;/g;
        $s =~ s/\342\200\234/&#8220;/g;
        $s =~ s/\342\200\235/&#8221;/g;
    }
    else {

        # ascii equivalent replacements
        $s =~ s/\342\200[\230\231]/'/g;
        $s =~ s/\342\200\246/.../g;
        $s =~ s/\342\200\223/-/g;
        $s =~ s/\342\200\224/--/g;
        $s =~ s/\342\200[\234\235]/"/g;
    }

    # While we're fixing Word, remove processing instructions with
    # colons, as they can break PHP.
    $s =~ s{ <\? xml:namespace [^>]*> }{}ximsg;

    $s;
}

sub _translate_naughty_words {
    my $app     = shift;
    my ($entry) = @_;
    my $blog    = $app->blog;
    return if $blog->smart_replace == 2;

    my $fields = $blog->smart_replace_fields;
    return unless $fields;

    my @fields = split( /\s*,\s*/, $fields || '' );
    foreach my $field (@fields) {
        if ( $entry->can($field) ) {
            $entry->$field( _convert_word_chars( $app, $entry->$field ) );
        }
    }
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
    $app->print("true");
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

sub languages_list {
    my $app = shift;
    my ($curr) = @_;

    my $langs = $app->supported_languages;
    my @data;
    $curr ||= $app->config('DefaultLanguage');
    $curr = 'en-us' if ( lc($curr) eq 'en_us' );
    for my $tag ( keys %$langs ) {
        ( my $name = $langs->{$tag} ) =~ s/\w+ English/English/;
        my $row = { l_tag => $tag, l_name => $app->translate($name) };
        $row->{l_selected} = 1 if $curr eq $tag;
        push @data, $row;
    }
    [ sort { $a->{l_name} cmp $b->{l_name} } @data ];
}

sub add_to_favorite_blogs {
    my $app = shift;
    my ($fav) = @_;

    my $auth = $app->user;
    my @current = @{ $auth->favorite_blogs || [] };
    return if @current && ( $current[0] == $fav );
    @current = grep { $_ != $fav } @current;
    unshift @current, $fav;
    @current = @current[ 0 .. 9 ]
        if @current > 10;
    $auth->favorite_blogs( \@current );
    $auth->save;
}

sub _entry_prefs_from_params {
    my $app  = shift;
    my $q    = $app->param;
    my $type = $q->param('entry_prefs');
    my %fields;
    if ( $type && lc $type ne 'custom' ) {
        $fields{$type} = 1;
    }
    else {
        $fields{$_} = 1 foreach $q->param('custom_prefs');
    }
    if ( my $body_height = $q->param('text_height') ) {
        $fields{'body'} = $body_height;
    }
    my $prefs = '';
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
        $row->{category_label} = remove_html( $row->{category_label} );
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

1;
__END__

=head1 NAME

MT::App::CMS

=head1 SYNOPSIS

The I<MT::App::CMS> module is the primary application module for
Movable Type. It is the administrative interface that is used to
manage blogs, entries, comments, trackbacks, templates, etc.

=cut
