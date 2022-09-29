# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::CMS;

use strict;
use warnings;
use base qw( MT::App );

use MT::CMS::ContentData;
use MT::Util qw( format_ts epoch2ts perl_sha1_digest_hex perl_sha1_digest
    remove_html );
use MT::App::CMS::Common;

sub LISTING_DATE_FORMAT ()      {'%b %e, %Y'}
sub LISTING_DATETIME_FORMAT ()  {'%b %e, %Y'}
sub LISTING_TIMESTAMP_FORMAT () {"%Y-%m-%d %I:%M:%S%p"}
sub NEW_PHASE ()                {1}

sub id {'cms'}

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->{state_params} = [
        '_type',           'id',
        'tab',             'offset',
        'filter',          'filter_val',
        'blog_id',         'is_power_edit',
        'filter_key',      'type',
        'content_type_id', 'content_data_id',
    ];
    $app->{template_dir}         = 'cms';
    $app->{plugin_template_path} = '';
    $app->{is_admin}             = 1;
    $app->{default_mode}         = 'dashboard';
    $app;
}

sub _has_feedback_plugins {
    for (qw/ Comments Trackback /) {
        return 1 if MT->has_plugin($_);
    }
    return;
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
        'save' => {
            code      => "${pkg}Common::save",
            no_direct => 1,
        },
        'edit'          => "${pkg}Common::edit",
        'view'          => "${pkg}Common::edit",
        'list'          => "${pkg}Common::list",
        'filtered_list' => {
            code     => "${pkg}Common::filtered_list",
            app_mode => 'JSON',
        },
        'save_list_prefs' => {
            code     => "${pkg}Common::save_list_prefs",
            app_mode => 'JSON',
        },
        'delete' => {
            code      => "${pkg}Common::delete",
            no_direct => 1,
        },
        'search_replace' => "${pkg}Search::search_replace",
        'list_revision'  => "${pkg}Common::list_revision",

 # 'save_snapshot'  => "${pkg}Common::save_snapshot", # Currently, not in use.

        ## Edit methods
        'edit_role'   => "${pkg}User::edit_role",
        'edit_widget' => "${pkg}Template::edit_widget",
        'view_role'   => "${pkg}User::edit_role",
        'view_widget' => "${pkg}Template::edit_widget",

        ## Listing methods
        'list_template' => "${pkg}Template::list",
        'list_asset'    => {
            code      => "${pkg}Asset::dialog_list_asset",
            condition => sub {
                my $app = shift;
                return 0 unless $app->param('dialog_view');
                return 1;
            }
        },
        'list_theme' => "${pkg}Theme::list",

        'asset_insert'         => "${pkg}Asset::insert",
        'asset_userpic'        => "${pkg}Asset::asset_userpic",
        'transform_image'      => "${pkg}Asset::transform_image",
        'preview_entry'        => "${pkg}Entry::preview",
        'apply_theme'          => "${pkg}Theme::apply",
        'uninstall_theme'      => "${pkg}Theme::uninstall",
        'bulk_update_category' => {
            code     => "${pkg}Category::bulk_update",
            app_mode => 'JSON',
        },
        'bulk_update_folder' => {
            code     => "${pkg}Category::bulk_update",
            app_mode => 'JSON',
        },

        ## Blog configuration screens
        'cfg_prefs'    => "${pkg}Blog::cfg_prefs",
        'cfg_feedback' => {
            code      => "${pkg}Blog::cfg_feedback",
            condition => \&_has_feedback_plugins,
        },
        'cfg_plugins'      => "${pkg}Plugin::cfg_plugins",
        'cfg_entry'        => "${pkg}Entry::cfg_entry",
        'cfg_web_services' => "${pkg}Blog::cfg_web_services",

        ## Save
        'save_cat' => {
            code      => "${pkg}Category::save",
            no_direct => 1,
        },
        'save_entries' => {
            code      => "${pkg}Entry::save_entries",
            no_direct => 1,
        },
        'save_pages' => {
            code      => "${pkg}Page::save_pages",
            no_direct => 1,
        },
        'save_entry' => {
            code      => "${pkg}Entry::save",
            no_direct => 1,
        },
        'save_role' => {
            code      => "${pkg}User::save_role",
            no_direct => 1,
        },
        'save_widget' => {
            code      => "${pkg}Template::save_widget",
            no_direct => 1,
        },
        'save_filter' => {
            code      => "${pkg}Filter::save",
            no_direct => 1,
        },

        ## Delete
        'delete_entry' => {
            code      => "${pkg}Entry::delete",
            no_direct => 1,
        },
        'delete_widget' => {
            code      => "${pkg}Template::delete_widget",
            no_direct => 1,
        },
        'delete_filter' => {
            code      => "${pkg}Filter::delete",
            no_direct => 1,
        },

        ## List actions
        'enable_object'     => "${pkg}User::enable",
        'disable_object'    => "${pkg}User::disable",
        'unlock'            => "${pkg}User::unlock",
        'list_action'       => "${pkg}Tools::do_list_action",
        'open_batch_editor' => "${pkg}Entry::open_batch_editor",
        'delete_filters'    => {
            code      => "${pkg}Filter::delete_filters",
            no_direct => 1,
        },

        'rebuild_phase'      => "${pkg}Blog::rebuild_phase",
        'rebuild'            => "${pkg}Blog::rebuild_pages",
        'rebuild_new_phase'  => "${pkg}Blog::rebuild_new_phase",
        'start_rebuild'      => "${pkg}Blog::start_rebuild_pages",
        'rebuild_confirm'    => "${pkg}Blog::rebuild_confirm",
        'entry_notify'       => "${pkg}AddressBook::entry_notify",
        'send_notify'        => "${pkg}AddressBook::send_notify",
        'start_upload'       => "${pkg}Asset::start_upload",
        'upload_file'        => "${pkg}Asset::upload_file",
        'complete_insert'    => "${pkg}Asset::complete_insert",
        'cancel_upload'      => "${pkg}Asset::cancel_upload",
        'complete_upload'    => "${pkg}Asset::complete_upload",
        'start_upload_entry' => "${pkg}Asset::start_upload_entry",

        ## New asset mode
        'js_upload_file' => {
            code     => "${pkg}Asset::js_upload_file",
            app_mode => 'JSON',
        },
        'dialog_edit_asset' => "${pkg}Asset::dialog_edit_asset",
        'js_save_asset'     => {
            code     => "${pkg}Asset::js_save_asset",
            app_mode => 'JSON',
        },
        'dialog_asset_modal' =>
            { code => "${pkg}Asset::dialog_asset_modal", },
        'dialog_insert_options' => "${pkg}Asset::dialog_insert_options",
        'insert_asset'          => "${pkg}Asset::insert_asset",

        'logout' => {
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
            code           => "${pkg}Tools::new_password",
            requires_login => 0,
        },
        'recover_lockout' => {
            code           => "${pkg}User::recover_lockout",
            requires_login => 0,
        },

        'start_move_blogs'     => "${pkg}Website::move_blogs",
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
        'save_template_prefs'  => "${pkg}Template::save_template_prefs",
        'save_favorite_blogs'  => "${pkg}Blog::save_favorite_blogs",
        'cc_return'            => "${pkg}Blog::cc_return",
        'itemset_action'       => "${pkg}Tools::do_list_action",
        'page_action'          => "${pkg}Tools::do_page_action",
        'cfg_system_general'   => "${pkg}Tools::cfg_system_general",
        'test_system_mail'     => {
            code     => "${pkg}Tools::test_system_mail",
            app_mode => 'JSON',
        },
        'cfg_system_users'        => "${pkg}User::cfg_system_users",
        'save_plugin_config'      => "${pkg}Plugin::save_config",
        'reset_plugin_config'     => "${pkg}Plugin::reset_config",
        'save_cfg_system_general' => "${pkg}Tools::save_cfg_system_general",
        'save_cfg_system_web_services' =>
            "${pkg}Tools::save_cfg_system_web_services",
        'save_cfg_system_users' => "${pkg}User::save_cfg_system_users",
        'upgrade'               => {
            code           => "${pkg}Tools::upgrade",
            requires_login => 0,
        },
        'plugin_control'           => "${pkg}Plugin::plugin_control",
        'rename_tag'               => "${pkg}Tag::rename_tag",
        'remove_user_assoc'        => "${pkg}User::remove_user_assoc",
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
        'publish_ct_templates' => "${pkg}Template::publish_archive_templates",
        'publish_templates_from_search' =>
            "${pkg}Template::publish_templates_from_search",

        ## Dialogs
        'dialog_restore_upload'    => "${pkg}Tools::dialog_restore_upload",
        'dialog_adjust_sitepath'   => "${pkg}Tools::dialog_adjust_sitepath",
        'dialog_select_weblog'     => "${pkg}Blog::dialog_select_weblog",
        'dialog_select_website'    => "${pkg}Website::dialog_select_website",
        'dialog_select_sysadmin'   => "${pkg}User::dialog_select_sysadmin",
        'dialog_grant_role'        => "${pkg}User::dialog_grant_role",
        'dialog_select_assoc_type' => "${pkg}User::dialog_select_assoc_type",
        'dialog_select_author'     => "${pkg}User::dialog_select_author",
        'dialog_list_asset'        => "${pkg}Asset::dialog_list_asset",
        'dialog_edit_image'        => "${pkg}Asset::dialog_edit_image",

        'thumbnail_image' =>
            "${pkg}Asset::thumbnail_image",    # Used in Edit Image dialog.

        ## AJAX handlers
        'delete_map'      => "${pkg}Template::delete_map",
        'add_map'         => "${pkg}Template::add_map",
        'js_tag_check'    => "${pkg}Tag::js_tag_check",
        'js_add_tag'      => "${pkg}Tag::js_add_tag",
        'convert_to_html' => "${pkg}Tools::convert_to_html",
        'js_add_category' => "${pkg}Category::js_add_category",
        'remove_userpic'  => "${pkg}User::remove_userpic",
        'login_json'      => {
            code     => "${pkg}Tools::login_json",
            app_mode => 'JSON',
        },
        'regenerate_site_stats_data' => {
            code     => "${pkg}Dashboard::regenerate_site_stats_data",
            app_mode => 'JSON',
        },

        # declared in MT::App
        'update_widget_prefs' =>
            sub { return shift->update_widget_prefs(@_) },

        ## DEPRECATED ##
        'upload_userpic' => "${pkg}User::upload_userpic",

        ## MT7 - Content Data
        'view_content_data'    => "${pkg}ContentData::edit",
        'edit_content_data'    => "${pkg}ContentData::edit",
        'save_content_data'    => "${pkg}ContentData::save",
        'preview_content_data' => "${pkg}ContentData::preview",
        'delete_content_data'  => "${pkg}ContentData::delete",

        ## MT7 - Content Type
        'edit_content_type' => "${pkg}ContentType::edit",
        'view_content_type' => "${pkg}ContentType::edit",
        'save_content_type' => "${pkg}ContentType::save",

     # 'cfg_content_type_data' => " ${pkg}ContentType::cfg_content_type_data",
        'select_list_content_type' =>
            "${pkg}ContentType::select_list_content_type",
        'select_edit_content_type' =>
            "${pkg}ContentType::select_edit_content_type",
        'validate_content_fields' => {
            code     => " ${pkg}ContentType::validate_content_fields",
            app_mode => 'JSON',
        },
        'dialog_content_data_modal' =>
            "${pkg}ContentType::dialog_content_data_modal",
        'dialog_list_content_data' => {
            code      => "${pkg}ContentType::dialog_list_content_data",
            condition => sub {
                my $app = shift;
                return 0 unless $app->param('dialog_view');
                return 1;
            }
        },

        'data_convert_to_html' => "${pkg}ContentData::data_convert_to_html",

        'view_category_set' => "${pkg}CategorySet::view",

        'list_ct_boilerplates' => "${pkg}ContentType::list_boilerplates",

        ## MT7 Rebuild Trigger
        'cfg_rebuild_trigger'  => "${pkg}RebuildTrigger::config",
        'add_rebuild_trigger'  => "${pkg}RebuildTrigger::add",
        'save_rebuild_trigger' => {
            code      => "${pkg}RebuildTrigger::save",
            no_direct => 1,
        },

        ## Groups
        'delete_group'             => "${pkg}Group::delete_group",
        'remove_member'            => "${pkg}Group::remove_member",
        'remove_group'             => "${pkg}Group::remove_group",
        'add_member'               => "${pkg}Group::add_member",
        'add_group'                => "${pkg}Group::add_group",
        'dialog_select_group_user' => "${pkg}Group::dialog_select_group_user",
        'view_group'               => "${pkg}Group::view_group",
        'edit_group'               => "${pkg}Group::view_group",

        'change_to_pc_view' => {
            code     => "${pkg}Mobile::change_to_pc_view",
            app_mode => 'JSON',
        },
    };
}

sub core_widgets {
    my $app = shift;
    my $pkg = '$Core::MT::CMS::';

    my $core_widgets = {
        mt_news => {
            label    => 'Movable Type News',
            template => 'widget/mt_news.tmpl',
            handler  => "${pkg}Dashboard::mt_news_widget",
            singular => 1,
            set      => 'sidebar',
            view     => [ 'user', 'system' ],
            order    => 100,
            default  => 1,
        },
        notification_dashboard => {
            label    => 'Notification Dashboard',
            template => 'widget/notification_dashboard.tmpl',
            handler  => "${pkg}Dashboard::notification_widget",
            singular => 1,
            set      => 'main',
            view     => [ 'user', 'system' ],
            order    => 0,
            default  => 1,
        },
        site_stats => {
            label    => 'Site Stats',
            template => 'widget/site_stats.tmpl',
            handler  => "${pkg}Dashboard::site_stats_widget",
            singular => 1,
            set      => 'main',
            view     => [ 'website', 'blog' ],
            order    => 200,
            default  => 1,
        },
        system_information => {
            label    => 'System Information',
            template => 'widget/system_information.tmpl',
            handler  => "${pkg}Dashboard::system_information_widget",
            singular => 1,
            set      => 'main',
            view     => 'system',
            order    => 100,
            default  => 1,
        },
        updates => {
            label     => 'Updates',
            template  => 'widget/updates.tmpl',
            handler   => "${pkg}Dashboard::updates_widget",
            singular  => 1,
            set       => 'sidebar',
            view      => [ 'user', 'system' ],
            order     => 0,
            default   => 1,
            condition => sub {
                MT->config('DisableVersionCheck') ? 0 : 1;
            }
        },
        activity_log => {
            label    => 'Activity Log',
            template => 'widget/activity_log.tmpl',
            handler  => "${pkg}Dashboard::activity_log_widget",
            singular => 1,
            set      => 'sidebar',
            view     => [ 'system', 'user', 'website', 'blog' ],
            order    => 200,
            default  => 1,
        },
        site_list => {
            label    => 'Site List',
            template => 'widget/site_list.tmpl',
            handler  => "${pkg}Dashboard::site_list_widget",
            singular => 1,
            set      => 'main',
            view     => [ 'user', 'website', 'blog' ],
            order    => 100,
            default  => 1,
        },
        site_list_for_mobile => {
            label    => 'Site List for Mobile',
            template => 'widget/site_list_for_mobile.tmpl',
            handler  => "${pkg}Dashboard::site_list_widget",
            singular => 1,
            set      => 'main',
            view     => [ 'user', 'website', 'blog' ],
            order    => 50,
            default  => 1,
            mobile   => 1,
        },
    };

    return $core_widgets;
}

sub core_page_actions {
    return {
        list_templates => {
            refresh_all_blog_templates => {
                label     => "Refresh Templates",
                mode      => 'dialog_refresh_templates',
                condition => sub {
                    my $blog = MT->app->blog;
                    return 0 unless $blog;
                    return $blog->theme_id || $blog->template_set;
                },
                order  => 1000,
                dialog => 1
            },
            refresh_global_templates => {
                label     => "Refresh Templates",
                mode      => 'dialog_refresh_templates',
                condition => sub {
                    !MT->app->blog;
                },
                order  => 1000,
                dialog => 1
            },
            publishing_profile => {
                label     => "Use Publishing Profile",
                mode      => 'dialog_publishing_profile',
                condition => sub {
                    MT->app->blog;
                },
                order  => 1100,
                dialog => 1
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
    MT::App::CMS::Common::init_core_callbacks($app);

    my $pkg = $app->id . '_';
    my $pfx = '$Core::MT::CMS::';
    $app->_register_core_callbacks(
        {
            # entry callbacks
            $pkg
                . 'pre_load_filtered_list.entry' =>
                "${pfx}Entry::cms_pre_load_filtered_list",
            $pkg . 'view_permission_filter.entry' => "${pfx}Entry::can_view",

            # page callbacks
            $pkg
                . 'pre_load_filtered_list.page' =>
                "${pfx}Page::cms_pre_load_filtered_list",
            $pkg . 'view_permission_filter.page' => "${pfx}Page::can_view",

            # user callbacks
            $pkg . 'pre_load_filtered_list.author' => sub {
                my ( $cb, $app, $filter, $opts, $cols ) = @_;
                my $terms = $opts->{terms};
                $terms->{type} = MT::Author::AUTHOR();
            },
            $pkg . 'view_permission_filter.author' => "${pfx}User::can_view",
            $pkg . 'save_filter.author' => "${pfx}User::save_filter",
            $pkg . 'pre_save.author'    => "${pfx}User::pre_save",
            $pkg
                . 'delete_ext_author_filter' => "${pfx}User::can_delete_this",

            # blog callbacks
            $pkg . 'view_permission_filter.blog' => "${pfx}Blog::can_view",
            $pkg . 'save_filter.blog'            => "${pfx}Blog::save_filter",
            $pkg
                . 'pre_load_filtered_list.blog' =>
                "${pfx}Blog::cms_pre_load_filtered_list",
            $pkg
                . 'filtered_list_param.blog' =>
                "${pfx}Blog::filtered_list_param",

            # category callbacks
            $pkg
                . 'view_permission_filter.category' =>
                "${pfx}Category::can_view",
            $pkg . 'save_filter.category' => "${pfx}Category::save_filter",
            $pkg
                . 'pre_load_filtered_list.category' =>
                "${pfx}Category::pre_load_filtered_list",

            # folder callbacks
            $pkg
                . 'view_permission_filter.folder' => "${pfx}Folder::can_view",
            $pkg
                . 'pre_load_filtered_list.folder' =>
                "${pfx}Category::pre_load_filtered_list",

            # asset callbacks
            $pkg . 'view_permission_filter.asset' => "${pfx}Asset::can_view",
            $pkg . 'save_filter.asset' => "${pfx}Asset::cms_save_filter",
            $pkg . 'pre_save.asset'    => "${pfx}Asset::pre_save",
            $pkg
                . 'pre_load_filtered_list.asset' =>
                "${pfx}Asset::cms_pre_load_filtered_list",

            # tag callbacks
            $pkg
                . 'pre_load_filtered_list.tag' =>
                "${pfx}Tag::cms_pre_load_filtered_list",
            $pkg . 'delete_permission_filter.tag' => "${pfx}Tag::can_delete",

            # template callbacks
            $pkg
                . 'view_permission_filter.template' =>
                "${pfx}Template::can_view",

            # MT7
            'template_param.list_common' =>
                "${pfx}ContentType::tmpl_param_list_common",
            'template_param.edit_role' =>
                "${pfx}ContentType::tmpl_param_edit_role",
            $pkg
                . 'pre_load_filtered_list.content_data' =>
                "${pfx}ContentData::cms_pre_load_filtered_list",
            "${pkg}list_permission_filter.category_set" =>
                "${pfx}CategorySet::can_list",

            # group
            $pkg . 'pre_load_filtered_list.group_member' => sub {
                my ( $cb, $app, $filter, $opts, $cols ) = @_;
                $filter->append_item( { type => '_type', } );
            },
            'list_template_param.group' => sub {
                my $cb = shift;
                my ( $app, $param, $tmpl ) = @_;
                $param->{object_type_for_table_class} = 'grp';
                return if $app->can_do('access_to_permission_list');
                $param->{use_filters}      = 0;
                $param->{use_actions}      = 0;
                $param->{has_list_actions} = 0;
                my $author_name = $app->user->name;
                $param->{page_title}
                    = MT->translate( q{[_1]'s Group}, $author_name );
            },
            $pkg . 'save_filter.group' => "${pfx}Group::CMSSaveFilter_group",
        }
    );

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
        if ( $blog_id > 0
            && !$app->model('blog')->load( { id => $blog_id } ) )
        {
            die $app->translate("Invalid request");
        }
    }

    # Global '_type' parameter check; if we get something
    # special character, die
    if ( my $type = $app->param('_type') ) {
        if ( $type =~ /\W/ ) {
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
            my $rel_num = $app->config('MTReleaseNumber');
            if (   !$schema
                || ( $schema < $app->schema_version )
                || ($app->config->NotifyUpgrade
                    && (   !$version
                        || ( $version < $app->version_number )
                        || (!defined $rel_num
                            || ( ( $version == $app->version_number )
                                && ($rel_num < ( $app->release_number || 0 ) )
                            )
                        )
                    )
                )
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

    # Check ImageDriver here because GD cannot be loaded
    # when using IIS and FastCGI.
    eval { require MT::Image; MT::Image->new or die; };
    if ($@) {
        $app->request( 'image_driver_error', 1 );
    }
}

sub core_content_actions {
    my $app = shift;
    return {
        'role' => {
            'create_role' => {
                mode  => 'view',
                class => 'icon-create',
                label => 'Create Role',
                icon  => 'ic_add',
                order => 100,
            }
        },
        'association' => {
            'grant_role' => {
                class => 'icon-create',
                label => 'Grant Permission',
                icon  => 'ic_add',
                mode  => 'dialog_grant_role',
                args  => {
                    _type => 'user',
                    type  => 'site',
                },
                return_args => 1,
                permit_action =>
                    { system_action => 'create_any_association', },
                order  => 100,
                dialog => 1,
            },
        },
        'member' => {
            'grant_role' => {
                class => 'icon-create',
                label => sub {
                    return $app->translate(
                        'Add a user to this [_1]',
                        lc $app->blog->class_label
                    );
                },
                icon => 'ic_add',
                mode => 'dialog_grant_role',
                args => sub {
                    if ( $app->blog->is_blog ) {
                        return {
                            type  => 'blog',
                            _type => 'user',
                        };
                    }
                    else {
                        return {
                            type  => 'website',
                            _type => 'user',
                        };
                    }
                },
                return_args => 1,
                order       => 100,
                dialog      => 1,
            },
        },
        'log' => {
            'reset_log' => {
                class       => 'icon-action',
                label       => 'Clear Activity Log',
                icon        => 'ic_setting',
                mode        => 'reset_log',
                order       => 100,
                confirm_msg => sub {
                    MT->translate(
                        'Are you sure you want to reset the activity log?');
                },
                permit_action => {
                    permit_action => 'reset_blog_log',
                    include_all   => 1,
                },
            },
            'download_log' => {
                class         => 'icon-download',
                label         => 'Download Log (CSV)',
                icon          => 'ic_download',
                mode          => 'export_log',
                order         => 200,
                permit_action => {
                    permit_action => 'export_blog_log',
                    include_all   => 1,
                    system_action => 'export_system_log',
                },
            },
        },
        'banlist' => {
            'ban_ip' => {
                class         => 'icon-create',
                label         => 'Add IP Address',
                id            => 'action-ban-ip',
                order         => 100,
                permit_action => 'save_banlist',
                icon          => 'ic_add',
                condition     => sub {
                    MT->app && MT->app->param('blog_id');
                },
            },
        },
        'notification' => {
            'add_contact' => {
                class      => 'icon-create',
                label      => 'Add Contact',
                id         => 'action-create-contact',
                order      => 100,
                permission => 'edit_notifications',
                icon       => 'ic_add',
                condition  => sub {
                    MT->app && MT->app->param('blog_id');
                },
            },
            'download_csv' => {
                class       => 'icon-download',
                label       => 'Download Address Book (CSV)',
                order       => 200,
                mode        => 'export_notification',
                return_args => 1,
                permission  => 'export_addressbook',
                icon        => 'ic_download',
                condition   => sub {
                    MT->app && MT->app->param('blog_id');
                }
            },
        },
        'group_member' => {
            'add_member' => {
                class             => 'icon-action',
                label             => 'Add user to group',
                mode              => 'dialog_select_group_user',
                system_permission => 'administer,manage_users_groups',
                condition         => sub {
                    my $app = MT->instance;
                    $app->config->ExternalGroupManagement ? 0 : 1;
                },
                dialog => 1,
            },
        },

        # TODO: FogBugz:114491
        # Hide create link temporarily and will fix in new UI.
        # 'content_type' => '$Core::MT::CMS::ContentType::content_actions',

        # Make a content action for Content Data dynamically.
        %{ MT::CMS::ContentData::make_content_actions() },
    };
}

sub core_list_actions {
    my $app = shift;
    my $pkg = '$Core::MT::CMS::';
    return {
        'entry' => {
            'set_draft' => {
                label         => "Unpublish Entries",
                order         => 200,
                code          => "${pkg}Entry::draft_entries",
                mobile        => 1,
                permit_action => {
                    permit_action => 'set_entry_draft_via_list',
                    include_all   => 1,
                },
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 1;
                },
            },
            'add_tags' => {
                label => "Add Tags...",
                order => 300,
                code  => "${pkg}Tag::add_tags_to_entries",
                input => 1,

                #                xhr           => 1,
                input_label   => 'Tags to add to selected entries',
                permit_action => {
                    permit_action => 'add_tags_to_entry_via_list',
                    include_all   => 1,
                },
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 1;
                },
            },
            'remove_tags' => {
                label         => "Remove Tags...",
                order         => 400,
                code          => "${pkg}Tag::remove_tags_from_entries",
                input         => 1,
                input_label   => 'Tags to remove from selected entries',
                permit_action => {
                    permit_action => 'remove_tags_from_entry_via_list',
                    include_all   => 1,
                },
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 1;
                }
            },
            'open_batch_editor' => {
                label         => "Batch Edit Entries",
                code          => "${pkg}Entry::open_batch_editor",
                order         => 500,
                no_prompt     => 1,
                permit_action => {
                    permit_action => 'open_batch_entry_editor_via_list',
                    include_all   => 1,
                },
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 0
                        if $app->param('filter_key')
                        && $app->param('filter_key') eq 'spam_entries';
                    return 0 unless $app->param('blog_id');
                    return 1;
                },
            },
            'publish' => {
                label         => 'Publish',
                code          => "${pkg}Blog::rebuild_new_phase",
                mode          => 'rebuild_new_phase',
                order         => 100,
                js_message    => 'publish',
                button        => 1,
                mobile        => 1,
                permit_action => {
                    permit_action =>
                        'publish_entry_via_list,publish_all_entry',
                    include_all => 1,
                },
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 1;
                },
            },
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
                mobile     => 1,
            },
        },
        'page' => {
            'set_draft' => {
                label         => "Unpublish Pages",
                order         => 200,
                code          => "${pkg}Entry::draft_entries",
                mobile        => 1,
                permit_action => {
                    permit_action => 'set_page_draft_via_list',
                    include_all   => 1,
                },
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 1;
                },
            },
            'add_tags' => {
                label         => "Add Tags...",
                order         => 300,
                code          => "${pkg}Tag::add_tags_to_entries",
                input         => 1,
                input_label   => 'Tags to add to selected pages',
                permit_action => {
                    permit_action => 'add_tags_to_pages_via_list',
                    include_all   => 1,
                },
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 1;
                },
            },
            'remove_tags' => {
                label         => "Remove Tags...",
                order         => 400,
                code          => "${pkg}Tag::remove_tags_from_entries",
                input         => 1,
                input_label   => 'Tags to remove from selected pages',
                permit_action => {
                    permit_action => 'remove_tags_from_pages_via_list',
                    include_all   => 1,
                },
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 1;
                },
            },
            'open_batch_editor' => {
                label         => "Batch Edit Pages",
                code          => "${pkg}Entry::open_batch_editor",
                order         => 500,
                permit_action => {
                    permit_action => 'open_batch_page_editor_via_list',
                    include_all   => 1,
                },
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 0
                        if $app->param('filter_key')
                        && $app->param('filter_key') eq 'spam_entries';
                    return 0 unless $app->param('blog_id');
                    return 1;
                },
            },
            'publish' => {
                label         => 'Publish',
                code          => "${pkg}Blog::rebuild_new_phase",
                mode          => 'rebuild_new_phase',
                order         => 100,
                js_message    => 'publish',
                button        => 1,
                mobile        => 1,
                permit_action => {
                    permit_action => 'publish_page_via_list',
                    include_all   => 1,
                },
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 1;
                },
            },
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
                mobile     => 1,
            },
        },
        'asset' => {
            'add_tags' => {
                label         => "Add Tags...",
                order         => 100,
                code          => "${pkg}Tag::add_tags_to_assets",
                input         => 1,
                input_label   => 'Tags to add to selected assets',
                permit_action => {
                    permit_action => 'add_tags_to_assets_via_list',
                    include_all   => 1,
                },
            },
            'remove_tags' => {
                label         => "Remove Tags...",
                order         => 200,
                code          => "${pkg}Tag::remove_tags_from_assets",
                input         => 1,
                input_label   => 'Tags to remove from selected assets',
                permit_action => {
                    permit_action => 'remove_tags_from_assets_via_list',
                    include_all   => 1,
                },
            },
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
                mobile     => 1,
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
                    ( $app->user->can_manage_users_groups()
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
                    $app->user->can_do('delete_user_via_list');
                },
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
            'unlock' => {
                label      => 'Unlock',
                code       => "${pkg}User::unlock",
                mode       => 'unlock',
                order      => 120,
                js_message => 'unlock',
                button     => 1,
                condition  => sub {
                    $app->can_do('access_to_system_author_list');
                },
            },
        },
        'member' => {
            'remove_user_assoc' => {
                label         => "Remove",
                order         => 100,
                code          => "${pkg}User::remove_user_assoc",
                mode          => 'remove_user_assoc',
                button        => 1,
                js_message    => 'remove',
                permit_action => {
                    permit_action => 'remove_user_assoc',
                    system_action => 'remove_user_assoc',
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
                permit_action => {
                    permit_action => 'refresh_template_via_list',
                    include_all   => 1,
                    system_action => 'refresh_template_via_list',
                },
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 1;
                },
            },
            move_blogs => {
                label         => "Move child site(s) ",
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
                label         => "Clone Child Site",
                code          => "${pkg}Blog::clone",
                permit_action => 'clone_blog',
                max           => 1,
                dialog        => 1,
            },
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete',
                order      => 110,
                js_message => 'delete',
                button     => 1,
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;

                    my $terms = {
                        author_id => $app->user->id,
                        blog_id   => { not => 0 },
                    };
                    my $args = {
                        join => MT->model('blog')->join_on(
                            undef,
                            {   id    => \'= permission_blog_id',
                                class => 'blog',
                                $app->blog
                                ? ( parent_id => $app->blog->id )
                                : (),
                            },
                        ),
                    };

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter( $terms, $args );

                    my $cond = 0;
                    while ( my $p = $iter->() ) {
                        $cond = 0, last
                            if !$p->can_do('delete_blog');
                        $cond++;
                    }

                    if ($cond) {
                        my $has_system_edit_tmpl = MT::Permission->count(
                            {   author_id   => $app->user->id,
                                blog_id     => 0,
                                permissions => { like => "'edit_templates'" },
                            }
                        );
                        if ($has_system_edit_tmpl) {
                            return $cond == MT::Blog->count(
                                $app->blog
                                ? { parent_id => $app->blog->id }
                                : undef
                            );
                        }
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
                permit_action => {
                    permit_action => 'refresh_template_via_list',
                    system_action => 'refresh_template_via_list',
                },
                condition => sub {
                    return 0 if $app->mode eq 'view';
                    return 1;
                },
            },
            'delete' => {
                label => 'Delete',
                code  => "${pkg}Common::delete",

                #                xhr        => 1,
                order      => 110,
                js_message => 'delete',
                button     => 1,
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return 1 if $app->user->is_superuser;

                    my $terms = {
                        author_id => $app->user->id,
                        blog_id   => { not => 0 },
                    };
                    my $args = {
                        join => MT->model('website')->join_on(
                            undef,
                            {   id    => \'= permission_blog_id',
                                class => 'website',
                            },
                        ),
                    };

                    require MT::Permission;
                    my $iter = MT::Permission->load_iter( $terms, $args );

                    my $cond = 0;
                    while ( my $p = $iter->() ) {
                        $cond = 0, last
                            if !$p->can_do('delete_website');
                        $cond++;
                    }

                    if ($cond) {
                        my $has_system_edit_tmpl = MT::Permission->count(
                            {   author_id   => $app->user->id,
                                blog_id     => 0,
                                permissions => { like => "'edit_templates'" },
                            }
                        );
                        if ($has_system_edit_tmpl) {
                            return $cond == MT::Website->count();
                        }
                    }

                    return $cond;
                },
            },
            move_blogs => {
                label         => "Move child site(s) ",
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
                label         => "Clone Child Site",
                code          => "${pkg}Blog::clone",
                permit_action => 'clone_blog',
                max           => 1,
                dialog        => 1,
            },
        },
        'template' => {
            refresh_tmpl_templates => {
                label => "Refresh Template(s)",
                code  => "${pkg}Template::refresh_individual_templates",
                permit_action => {
                    permit_action => 'refresh_template_via_list',
                    include_all   => 1,
                    system_action => 'refresh_template_via_list',
                },
                order     => 100,
                condition => sub {
                    my $app = MT->app;
                    my $tmpl_type = $app->param('filter_key') || '';
                    return 0 if $tmpl_type eq 'backup_templates';
                    my $blog = $app->blog;
                    return 1 unless $blog;
                    return $blog->theme_id || $blog->template_set;
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
                label         => "Clone Template(s)",
                code          => "${pkg}Template::clone_templates",
                permit_action => {
                    permit_action => 'copy_template_via_list',
                    include_all   => 1,
                    system_action => 'copy_template_via_list',

                },
                condition => sub {
                    my $app = MT->app;
                    my $tmpl_type = $app->param('filter_key') || '';
                    return
                          $tmpl_type eq 'system_templates' ? 0
                        : $tmpl_type eq 'email_templates'  ? 0
                        : $tmpl_type eq 'backup_templates' ? 0
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
        'filter' => {
            'delete' => {
                label      => 'Delete',
                code       => "${pkg}Common::delete",
                mode       => 'delete_filters',
                order      => 110,
                js_message => 'delete',

                #                xhr        => 1,
                button => 1,
            },
        },
        'category_set' => '$Core::MT::CMS::CategorySet::list_actions',
        'content_type' => '$Core::MT::CMS::ContentType::list_actions',
        'content_data' => '$Core::MT::CMS::ContentData::list_actions',
        'group'        => {
            'delete_group' => {
                label                   => 'Delete',
                order                   => 100,
                continue_prompt_handler => sub {
                    MT->translate(
                        'Are you sure you want to delete the selected group(s)?'
                    );
                },
                handler   => '$Core::MT::CMS::Group::delete_group',
                condition => sub {
                    my $app = MT->instance;
                    $app->user->can_manage_users_groups()
                        && ( !$app->config->ExternalGroupManagement )
                        && ( !$app->param('author_id') );
                },
            },
            'enable_group' => {
                label      => 'Enable',
                mode       => 'enable_object',
                order      => 100,
                js_message => 'enable',
                button     => 1,
                condition  => sub {
                    my $app = MT->instance;
                    $app->user->can_manage_users_groups()
                        && ( !$app->param('author_id') );
                },
            },
            'disable_group' => {
                label      => 'Disable',
                mode       => 'disable_object',
                order      => 200,
                js_message => 'disable',
                button     => 1,
                condition  => sub {
                    my $app = MT->instance;
                    $app->user->can_manage_users_groups()
                        && ( !$app->param('author_id') );
                },
            },
        },
        'group_member' => {
            'remove_member' => {
                label                   => 'Remove',
                button                  => 1,
                order                   => 100,
                continue_prompt_handler => sub {
                    MT->translate(
                        'Are you sure you want to remove the selected member(s) from the group?'
                    );
                },
                mode      => 'remove_member',
                condition => sub {
                    my $app = MT->instance;
                    $app->user->can_manage_users_groups()
                        && ( !$app->config->ExternalGroupManagement );
                },
            },
        },

    };
}

sub core_menu_actions {
    my $app = shift;
    return {
        rebuild => {
            class     => 'mt-rebuild',
            condition => sub {
                return ( $app->blog && $app->can_do('rebuild') );
            },
            icon  => 'ic_build',
            label => 'Rebuild',
            mode  => 'rebuild_confirm',
            order => 100,
        },
        view_site => {
            condition => sub {
                $app->blog ? 1 : 0;
            },
            icon  => 'ic_permalink',
            label => 'View Site',
            href  => sub {
                $app->blog->site_url;
            },
            order  => 200,
            target => '_blank',
        },
    };
}

sub core_user_actions {
    my $app = shift;
    return {
        profile => {
            condition => sub {
                $app->user ? 1 : 0;
            },
            href => sub {
                $app->uri(
                    mode => 'view',
                    args => {
                        _type => 'author',
                        id    => $app->user->id,
                    },
                );
            },
            label => 'Profile',
            order => 100,
        },
        documentation => {
            href => sub {
                $app->translate('https://www.movabletype.org/documentation/');
            },
            label  => 'Documentation',
            order  => 200,
            target => '_blank',
        },
        sign_out => {
            condition => sub {
                $app->user ? 1 : 0;
            },
            label => 'Sign out',
            mode  => 'logout',
            order => 300,
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
            label => "Sites",
            icon  => 'ic_sites',
            order => 100,
        },
        'blog' => {
            label => "Sites",
            icon  => 'ic_sites',
            order => 100,
        },
        'content_data' => {
            label => 'Content Data',
            icon  => 'ic_contentdata',
            order => 200,
        },
        'entry' => {
            label => "Entries",
            icon  => 'ic_contentdata',
            order => 300,
        },
        'page' => {
            label => "Pages",
            icon  => 'ic_contentdata',
            order => 400,
        },
        'category_set' => {
            label => 'Category Sets',
            icon  => 'ic_category',
            order => 500,
        },
        'tag' => {
            label => "Tags",
            icon  => 'ic_tag',
            order => 600,
        },
        'asset' => {
            label => "Assets",
            icon  => 'ic_asset',
            order => 700,
        },
        'content_type' => {
            label => 'Content Types',
            icon  => 'ic_contentstype',
            order => 800,
        },
        'user' => {
            label => sub {
                $app->translate( $app->blog ? 'Members' : 'Users' );
            },
            icon  => 'ic_user',
            order => 900,
        },
        'group' => {
            icon  => 'ic_member',
            label => 'Groups',
            order => 1000,
        },
        'feedback' => {
            label => "Feedbacks",
            icon  => 'ic_feedback',
            order => 1000,
        },
        'role' => {
            label => 'Roles',
            icon  => 'ic_role',
            order => 1100,
        },
        'design' => {
            label => "Design",
            icon  => 'ic_design',
            order => 1200,
        },
        'filter' => {
            label => "Filters",
            icon  => 'ic_filter',
            order => 1400,
        },
        'settings' => {
            label => "Settings",
            icon  => 'ic_setting',
            order => 1500,
        },
        'tools' => {
            label => "Tools",
            icon  => 'ic_tool',
            order => 1600,
        },

        'website:manage' => {
            label     => "Manage",
            order     => 100,
            mode      => "list",
            args      => { _type => "website" },
            view      => "system",
            condition => sub {
                require MT::CMS::Website;
                return MT::CMS::Website::can_view_website_list($app);
            },
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
            label     => "Manage",
            order     => 100,
            mode      => "list",
            args      => { _type => "blog" },
            view      => ["website"],
            mobile    => 1,
            condition => sub {
                require MT::CMS::Blog;
                return MT::CMS::Blog::can_view_blog_list($app);
            },
        },
        'blog:create' => {
            label         => "New",
            order         => 200,
            mode          => 'view',
            args          => { _type => 'blog' },
            permit_action => 'use_blog:create_menu',
            view          => ["website"],
        },

        'user:member' => {
            label         => "Manage",
            order         => 100,
            mode          => 'list',
            args          => { _type => 'member' },
            view          => [ "blog", "website" ],
            permit_action => "manage_users",
        },
        'user:manage' => {
            label             => "Manage",
            order             => 100,
            mode              => "list",
            args              => { _type => "author" },
            permission        => "administer,manage_users",
            system_permission => "administer,manage_users_groups",
            view              => "system",
        },
        'group:manage' => {

            label             => 'Manage',
            order             => 100,
            mode              => 'list',
            args              => { _type => 'group' },
            view              => 'system',
            system_permission => "administer,manage_users_groups",
        },
        'group:create' => {

            label             => 'New',
            order             => 200,
            mode              => 'view',
            args              => { _type => 'group' },
            view              => 'system',
            system_permission => "administer,manage_users_groups",
            condition         => sub {
                my $app = MT->instance;
                $app->config->ExternalGroupManagement ? 0 : 1;
            }
        },
        'group:manage_members' => {
            label             => 'Manage Members',
            order             => 300,
            mode              => 'list',
            args              => { _type => 'group_member' },
            view              => 'system',
            system_permission => "administer,manage_users_groups",
        },
        'role:manage' => {
            label             => "Manage",
            order             => 100,
            mode              => "list",
            args              => { _type => "role", },
            system_permission => 'administer',
            view              => "system",
        },
        'role:create' => {
            label             => "New",
            order             => 200,
            mode              => "view",
            args              => { _type => "role" },
            system_permission => 'administer',
            view              => "system",
        },
        'role:association' => {
            label             => "Associations",
            order             => 300,
            mode              => "list",
            args              => { _type => "association", },
            system_permission => "administer,manage_users_groups",
            view              => "system",
        },

        'user:create' => {
            label             => "New",
            order             => 200,
            mode              => "view",
            args              => { _type => "author" },
            permission        => "administer,manage_users",
            system_permission => "administer,manage_users_groups",
            condition         => sub {
                return !MT->config->ExternalUserManagement;
            },
            view => "system",
        },

        'entry:manage' => {
            label     => "Manage",
            order     => 100,
            mode      => 'list',
            args      => { _type => 'entry' },
            view      => [ "blog", "website" ],
            mobile    => 1,
            condition => sub {
                return 1 if $app->user->is_superuser;

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
                        if $p->can_do('use_entry:manage_menu');
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
            view       => [ "blog", "website" ],
            mobile     => 1,
        },
        'entry:category' => {
            label      => "Categories",
            order      => 300,
            mode       => 'list',
            args       => { _type => 'category' },
            permission => 'edit_categories',
            view       => [ "blog", "website" ],
            mobile     => 1,
        },
        'entry:import' => {
            label      => "Import",
            order      => 400,
            mode       => "start_import",
            permission => "administer_site",
            view       => [ "blog", "website" ],
        },
        'entry:export' => {
            label      => "Export",
            order      => 500,
            mode       => "start_export",
            permission => "administer_site",
            view       => [ "blog", "website" ],
        },

        'page:manage' => {
            label     => "Manage",
            order     => 100,
            mode      => 'list',
            args      => { _type => 'page' },
            view      => [ "blog", 'website' ],
            mobile    => 1,
            condition => sub {
                return 1 if $app->user->is_superuser;

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
                        if $p->can_do('manage_pages');
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
            mobile     => 1,
        },
        'page:folder' => {
            label      => "Folders",
            order      => 300,
            mode       => 'list',
            args       => { _type => 'folder' },
            permission => 'manage_pages',
            view       => [ "blog", 'website' ],
            mobile     => 1,
        },

        'asset:manage' => {
            label      => "Manage",
            order      => 100,
            mode       => 'list',
            args       => { _type => 'asset' },
            permission => '',
            view       => [ "system", "blog", 'website' ],
            mobile     => 1,
            condition  => sub {
                return 1
                    if ( $app->user->is_superuser
                    || $app->user->permissions(0)
                    ->can_do('access_to_asset_list') );

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
                        if $p->can_do('edit_assets');
                }
                return $cond ? 1 : 0;
            },
        },
        'asset:upload' => {
            label      => "Upload",
            order      => 200,
            mode       => 'start_upload',
            permission => 'upload,edit_assets',
            view       => [ "blog", 'website' ],
            mobile     => 1,
        },
        'asset:edit' => {
            order   => 10000,
            mode    => 'view',
            args    => { _type => 'asset' },
            view    => [ "blog", 'website', 'system' ],
            display => 0,
        },

        'content_type:manage_content_type' => {
            label      => 'Manage',
            order      => 100,
            mode       => 'list',
            args       => { _type => 'content_type' },
            permission => 'manage_content_types',
            view       => [ 'website', 'blog' ],
        },
        'content_type:create_content_type' => {
            label      => 'New',
            mode       => 'view',
            args       => { _type => 'content_type' },
            order      => 200,
            view       => [ 'website', 'blog' ],
            permission => 'manage_content_types',
        },

        'tag:manage' => {
            label             => "Manage",
            order             => 100,
            mode              => 'list',
            args              => { _type => 'tag' },
            permission        => 'edit_tags',
            system_permission => 'administer',
            view              => [ "blog", 'website' ],
        },

        'design:template' => {
            label => sub {
                $app->translate(
                    $app->blog ? 'Templates' : 'Global Templates' );
            },
            order             => 100,
            mode              => 'list_template',
            permission        => 'edit_templates',
            system_permission => 'edit_templates',
            view              => [ "blog", 'website', 'system' ],
        },
        'design:themes' => {
            label         => 'Themes',
            order         => 300,
            mode          => 'list_theme',
            view          => [ "blog", 'website', 'system' ],
            permit_action => 'use_design:themes_menu',
        },

        'filter:member' => {
            label             => "Manage",
            order             => 100,
            mode              => 'list',
            args              => { _type => 'filter' },
            view              => "system",
            system_permission => 'administer',
        },

        'settings:general' => {
            label      => "General",
            order      => 100,
            mode       => 'cfg_prefs',
            permission => 'administer_site,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => [ "blog", 'website' ],
        },
        'settings:compose' => {
            label      => "Compose",
            order      => 300,
            mode       => 'cfg_entry',
            permission => 'administer_site,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => [ "blog", 'website' ],
        },
        'settings:feedback' => {
            label      => "Feedback",
            order      => 400,
            mode       => 'cfg_feedback',
            permission => 'administer_site,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => [ "blog", 'website' ],
            condition         => \&_has_feedback_plugins,
        },
        'settings:web_services' => {
            label      => "Web Services",
            order      => 600,
            mode       => 'cfg_web_services',
            permission => 'administer_site,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => [ "blog", 'website' ],
        },
        'settings:site_plugins' => {
            label             => "Plugins",
            order             => 700,
            mode              => "cfg_plugins",
            permission        => "administer_site",
            system_permission => "manage_plugins",
            view              => [ "blog", "website" ],
        },
        'settings:rebuild_trigger' => {
            label      => "Rebuild Trigger",
            order      => 800,
            mode       => "cfg_rebuild_trigger",
            permission => "administer_site",
            view       => [ "system", "blog", 'website' ],
        },
        'settings:ip_info' => {
            label     => "IP Banning",
            order     => 900,
            mode      => 'list',
            args      => { _type => 'banlist' },
            condition => sub {
                return 0 unless $app->config->ShowIPInformation;
                return 1 if $app->user->is_superuser;

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
                        if $p->can_do('manage_feedback');
                }
                return $cond ? 1 : 0;
            },
            view => [qw( system website blog )],
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
        'settings:system_web_services' => {
            label             => "Web Services",
            order             => 600,
            mode              => 'cfg_web_services',
            system_permission => 'administer',
            view              => 'system',
        },
        'settings:system_plugins' => {
            label             => "Plugins",
            order             => 700,
            mode              => "cfg_plugins",
            permission        => "administer_site",
            system_permission => "manage_plugins",
            view              => ['system'],
        },
        'settings:system_information' => {
            label         => "System Information",
            order         => 900,
            mode          => "tools",
            view          => "system",
            permit_action => 'use_tools:system_info_menu',
        },

        'tools:search' => {
            label     => "Search & Replace",
            order     => 50,
            mode      => "search_replace",
            view      => [ "blog", 'website', 'system' ],
            condition => sub {
                require MT::CMS::Search;
                return MT::CMS::Search::can_search_replace($app);
            }
        },
        'tools:activity_log' => {
            label     => "Activity Log",
            order     => 100,
            mode      => "list",
            args      => { _type => 'log', },
            condition => sub {
                my $user    = $app->user;
                my $blog_id = $app->param('blog_id');
                return 1 if $user->is_superuser;

                my $terms;
                push @$terms, { author_id => $user->id };
                if ($blog_id) {
                    my $blog = MT->model('blog')->load($blog_id);
                    my @blog_ids;
                    push @blog_ids, $blog_id;
                    if ( $blog && !$blog->is_blog ) {
                        push @blog_ids, map { $_->id } @{ $blog->blogs };
                    }
                    push @$terms,
                        [
                        '-and',
                        {   blog_id     => \@blog_ids,
                            permissions => { like => "\%'view_blog_log'\%" },
                        }
                        ];
                }
                else {
                    push @$terms,
                        [
                        '-and',
                        [   {   blog_id     => 0,
                                permissions => { like => "\%'view_log'\%" },
                            },
                            '-or',
                            {   blog_id => \' > 0',
                                permissions =>
                                    { like => "\%'view_blog_log'\%" },
                            }
                        ]
                        ];
                }

                my $cnt = MT->model('permission')->count($terms);
                return ( $cnt && $cnt > 0 ) ? 1 : 0;
            },
            view => [ "blog", 'website', 'system' ],
        },
        'tools:restore' => {
            label      => "Import Sites",
            order      => 200,
            mode       => "start_restore",
            permission => "administer_site",
            view       => "system",
        },
        'tools:system_export' => {
            label      => "Export Sites",
            order      => 300,
            mode       => "start_backup",
            permission => "administer_site",
            view       => ['system'],
        },
        'tools:site_export' => {
            label      => "Export Site",
            order      => 400,
            mode       => "start_backup",
            permission => "administer_site",
            view       => [ "blog", "website" ],
        },
        'tools:themeexport' => {
            label         => "Export Theme",
            order         => 500,
            mode          => 'export_theme',
            permit_action => 'use_tools:themeexport_menu',
            view          => [ 'blog', 'website' ],
        },
        'tools:notification' => {
            label     => "Address Book",
            order     => 600,
            mode      => 'list',
            args      => { _type => 'notification' },
            condition => sub {
                return 0 unless $app->config->EnableAddressBook;
                return 1 if $app->user->is_superuser;

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
                        if $p->can_do('edit_notifications');
                }
                return $cond ? 1 : 0;
            },
            view => [qw( system website blog )],
        },

        'category_set:manage' => {
            label      => 'Manage',
            order      => 100,
            mode       => 'list',
            permission => 'manage_category_set',
            args       => { _type => 'category_set' },
            view       => [ 'website', 'blog' ],
            mobile     => 1,
        },
        'category_set:create' => {
            label      => 'New',
            order      => 200,
            mode       => 'view',
            permission => 'manage_category_set',
            args       => { _type => 'category_set' },
            view       => [ 'website', 'blog' ],
        },

        %{ MT::CMS::ContentData::make_menus() },
    };
}

sub core_compose_menus {
    my $app = shift;
    return {
        'entry' => {
            id    => 'entry',
            label => "Entry",
            order => 100,
            mode  => 'view',
            args       => { _type => 'entry' },
            permission => 'create_post',
            view => [ "blog", "website" ],
        },
        'page' => {
            id    => 'page',
            label => "Page",
            order => 200,
            mode  => 'view',
            args       => { _type => 'page' },
            permission => 'manage_pages',
            view => [ "blog", 'website' ],
        },
        'asset' => {
            id         => 'asset',
            label      => "Asset",
            order      => 300,
            mode       => 'start_upload',
            permission => 'upload,edit_assets',
            view => [ "blog", 'website' ],
        },
        'website' => {
            id    => 'website',
            label => "Website",
            order => 200,
            mode  => 'view',
            args          => { _type => 'website' },
            permit_action => 'use_website:create_menu',
            view          => "system",
        },
        'user' => {
            id    => 'user',
            label => "User",
            order => 100,
            mode  => "view",
            args       => { _type => "author" },
            permission => "administer",
            condition  => sub {
                return !MT->config->ExternalUserManagement;
            },
            view => "system",
        },
        'blog:create' => {
            id    => 'blog',
            label => "Blog",
            order => 400,
            mode  => 'view',
            args          => { _type => 'blog' },
            permit_action => 'use_blog:create_menu',
            view          => "website",
        },
    };
}

sub core_user_menus {
    my $app = shift;
    return {
        'profile' => {
            label      => 'Profile',
            order      => 100,
            mode       => 'view',
            args       => { _type => 'author' },
            user_param => 'id',
            view       => "system",
            condition  => sub {
                my ( $app, $param ) = @_;
                $param->{is_me} ? 1 : $app->can_do('view_other_user_profile');
            },
        },
        'permission' => {
            label => "Permissions",
            order => 200,
            link  => sub {
                my ( $app, $param ) = @_;
                if ( $app->can_do('access_to_permission_list') ) {
                    return $app->uri(
                        mode => 'list',
                        args => {
                            blog_id    => 0,
                            _type      => 'association',
                            filter     => 'author_id',
                            filter_val => $param->{user_menu_id},
                        },
                    );
                }
                else {
                    return $app->uri(
                        mode => 'list',
                        args => {
                            blog_id => 0,
                            _type   => 'association',
                        },
                    );
                }
            },
            user_param => 'filter_val',
            view       => "system",
            condition  => sub {
                my ( $app, $param ) = @_;
                $param->{is_me}
                    ? 1
                    : $app->can_do('view_other_user_permissions');
            },
        },
        'group' => {
            label_handler => sub {
                my ( $app, $param ) = @_;
                my $aid        = $param->{user_menu_id};
                my $asso_class = MT->model('association');
                my $gcount     = $asso_class->count(
                    {   type      => $asso_class->USER_GROUP(),
                        author_id => $aid,
                        group_id  => \' is not null',
                    },
                );
                return MT->translate( 'Groups ([_1])', $gcount );
            },
            order => 1000,
            link  => sub {
                my ( $app, $param ) = @_;
                if ( $app->can_do('access_to_group_list') ) {
                    return $app->uri(
                        mode => 'list',
                        args => {
                            blog_id    => 0,
                            _type      => 'group',
                            filter     => 'author_id',
                            filter_val => $param->{user_menu_id},
                        },
                    );
                }
                else {
                    return $app->uri(
                        mode => 'list',
                        args => {
                            blog_id => 0,
                            _type   => 'group',
                        },
                    );
                }
            },
            user_param => 'filter_val',
            condition  => sub {
                my ( $app, $param ) = @_;
                $param->{is_me}
                    ? 1
                    : $app->can_do('manage_groups');
            }
        },
    };
}

sub core_enable_object_methods {
    my $app = shift;
    return {
        asset => {
            delete => 1,
            edit   => 1,
            save   => 1,
        },
        association => { delete => 1 },
        author      => {
            delete => 1,
            edit   => 1,
            save   => 1,
        },
        banlist => {
            delete => 1,
            save   => 1,
        },
        blog => {
            delete => 1,
            edit   => 1,
            save   => 1,
        },
        category => {
            delete => 1,
            edit   => sub { $app->param('id') ? 1 : 0 },
            save   => sub { $app->param('id') ? 1 : 0 },
        },
        category_set => { delete => 1 },
        content_type => { delete => 1, },
        entry        => { edit   => 1 },
        page         => {
            delete => 1,
            edit   => 1,
            save   => 1,
        },
        folder => {
            delete => 1,
            edit   => sub { $app->param('id') ? 1 : 0 },
            save   => sub { $app->param('id') ? 1 : 0 },
        },
        notification => {
            delete => 1,
            save   => 1,
        },
        role     => { delete => 1 },
        tag      => { delete => 1 },
        template => {
            delete => 1,
            edit   => 1,
            save   => 1,
        },
        website => {
            delete => 1,
            edit   => 1,
            save   => 1,
        },
        group => {
            delete => 1,
            save   => 1,
        }
    };
}

sub permission_denied {
    my $app = shift;

    my $method_info = MT->request('method_info') || {};
    if ( $app->param('xhr') or ( ( $method_info->{app_mode} || '' ) eq 'JSON' ) ) {
        return $app->errtrans('Permission denied');
    }

    $app->return_to_dashboard( permission => 1, );
}

## TBD: This should be removed.
sub user_can_admin_commenters {
    my $app   = shift;
    my $perms = $app->permissions;
    $app->user->is_superuser()
        || ( $perms
        && ( $perms->can_administer_site || $perms->can_manage_feedback ) );
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

sub can_sign_in {
    my $app = shift;
    my ($user) = @_;

    if ( !$user->can_sign_in_cms() ) {
        $app->log(
            {   message => $app->translate(
                    "Failed login attempt by user who does not have sign in permission. '[_1]' (ID:[_2])",
                    $user->name,
                    $user->id,
                ),
                level    => MT::Log::SECURITY(),
                category => 'login_user',
                class    => 'author',
            }
        );
        return 0;
    }

    return 1;
}

sub is_authorized {
    my $app = shift;

    # Clear current permissions.
    $app->permissions(undef);

    # Not authroized.
    my $user = $app->user;
    return unless $user;

    # User should have sign in system permission
    return $app->errtrans('Invalid login.')
        unless $app->can_sign_in($user);

    # System administrator is alweays true.
    return 1 if $user->is_superuser;

    # User has Edit Templates permission on system, always true.
    # Permission will be verified on each mode.
    return 1 if $user->can_edit_templates;

    # Always true if blog_id is undef or 0 because scope is
    # User or System.
    my $blog_id = $app->param('blog_id');
    return 1 unless $blog_id;

    my $blog = MT->model('blog')->load($blog_id)
        or return $app->errtrans( 'Cannot load blog (ID:[_1])', $blog_id );

    # Return true if user has any permissions for a specified
    # blog or parent website.
    my @blog_ids = [ 0, $blog_id ];
    if ( !$blog->is_blog ) {
        push @blog_ids, +( map { $_->id } @{ $blog->blogs } );
    }

    my $terms = [
        { author_id => $user->id },
        '-and',
        { blog_id => \@blog_ids },
        '-and',
        [   { permissions => \'IS NOT NULL' },
            '-or',
            { permissions => { not => '' } },
        ]
    ];
    my @perms = MT->model('permission')->load($terms);
    if (@perms) {
        foreach my $perm (@perms) {
            if ( $perm->blog_id == 0 ) {

                # Return true when user has any permissions
                # except sign_in_*
                my @grep = grep { $_ !~ /'sign_in_.*\'/ } split ",",
                    $perm->permissions;
                return 1 if @grep;
            }
            else {
                # Anyway, return true when user has any permission
                # for requested blog or parent site
                return 1;
            }
        }
        return $app->permission_denied();
    }
    else {
        return $app->permission_denied();
    }

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

    $param->{"auth_mode_$pref"} = 1;
    $param->{mt_news}           = $app->config('NewsURL');
    $param->{mt_support}        = $app->config('SupportURL');
    $param->{mt_feedback_url}   = $app->config('FeedbackURL');
    my $lang = lc MT->current_language || 'en_us';
    $param->{language_id} = ( $lang !~ /en[_-]us/ ) ? $lang : '';
    $param->{mode} = $app->mode;

    my $blog_id = $app->param('blog_id') || 0;
    my $blog;
    my $blog_class = $app->model('blog');
    $blog ||= $blog_class->load($blog_id) if $blog_id;
    if ( my $auth = $app->user ) {
        $param->{is_administrator} = $auth->is_superuser;
        $param->{can_access_to_system_dashboard}
            = $auth->can_do('access_to_system_dashboard');
        $param->{can_create_newblog} = $auth->can_do('create_site') && $blog;
        $param->{can_create_newbwebsite} = $auth->can_create_site;
        $param->{can_view_log} ||= $auth->can_view_log;
        $param->{can_manage_plugins}    = $auth->can_manage_plugins;
        $param->{can_edit_templates}    = $auth->can_edit_templates;
        $param->{can_publish_feedbacks} = $auth->is_superuser;
        $param->{can_search_replace}    = $auth->is_superuser;
        $param->{has_authors_button}    = $auth->is_superuser;
        $param->{author_id}             = $auth->id;
        $param->{author_name}           = $auth->name;
        $param->{author_display_name}   = $auth->nickname || $auth->name;

        my $date_format = $auth->date_format || 'relative';
        $param->{ "dates_" . $date_format } = 1;

        if ( my ($url)
            = $auth->userpic_url( Width => 36, Height => 36, Ts => 1 ) )
        {
            $param->{author_userpic_url} = $url;
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
        require MT::CMS::Search;
        $param->{can_search_replace}
            = MT::CMS::Search::can_search_replace($app);
        $param->{can_edit_authors} = $param->{can_administer_site};
        $param->{can_access_assets}
            = $param->{can_create_post}
            || $param->{can_edit_all_posts}
            || $param->{can_edit_assets};
        $param->{has_manage_label}
            = $param->{can_edit_templates}
            || $param->{can_administer_site}
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

        $param->{can_edit_commenters} = 1
            if $app->user->is_superuser
            || ( $app->config->SingleCommunity
            && !$blog
            && $param->{can_manage_feedback} )
            || ( !$app->config->SingleCommunity
            && $blog
            && $param->{can_manage_feedback} );
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
    if ( !defined $param ) {
        if ( $page->isa('MT::Template') ) {
            $param = $page->param();
        }
        else {
            $param = {};
        }
    }
    my $blog_id = $app->param('blog_id') || 0;
    my $blog;
    my $blog_class = $app->model('blog');
    $blog ||= $blog_class->load($blog_id) if $blog_id;
    if ( $page ne 'login.tmpl' ) {
        if ($blog_id) {
            if ($blog) {
                my $scope_type = $blog->is_blog ? 'blog' : 'website';
                my $class = $app->model($scope_type);
                $param->{blog_name}          = $blog->name;
                $param->{blog_id}            = $blog->id;
                $param->{blog_url}           = $blog->site_url;
                $param->{blog_template_set}  = $blog->template_set;
                $param->{is_blog}            = $blog->is_blog ? 1 : 0;
                $param->{scope_type}         = $scope_type;
                $param->{scope_label}        = $class->class_label;
                $param->{is_generic_website} = 1
                    if !$blog->is_blog
                    && ( !$blog->column('site_path')
                    || !$blog->column('site_url') );
            }
            else {
                $app->error(
                    $app->translate( "No such blog [_1]", $blog_id ) );
            }
        }
        else {
            $param->{scope_type}
                = !defined $app->param('blog_id')
                && $app->mode eq 'dashboard'
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

    my $build_blog_selector
        = exists $param->{build_blog_selector}
        ? $param->{build_blog_selector}
        : 1;
    $app->build_blog_selector($param) if $build_blog_selector;
    my $build_menus
        = exists $param->{build_menus} ? $param->{build_menus} : 1;
    if ($build_menus) {
        $app->build_menus($param);
        $app->build_actions( 'menu_actions', $param );
        $app->build_actions( 'user_actions', $param );
    }
    if ( !ref($page)
        || ( $page->isa('MT::Template') && !$page->param('page_actions') ) )
    {

        # Using a sub here to delay the loading of page actions, since not all
        # templates actually utilize them.
        $param->{page_actions} ||= sub { $app->page_actions( $app->mode ) };
    }
    my $build_compose_menus
        = exists $param->{build_compose_menus}
        ? $param->{build_compose_menus}
        : 1;
    $app->build_compose_menus($param)
        if $build_compose_menus;

    my $build_user_menus
        = exists $param->{build_user_menus} ? $param->{build_user_menus}
        : $param->{user_menu_id}            ? 1
        : $app->param('author_id')          ? 1
        :                                     0;

    $app->build_user_menus($param)
        if $build_user_menus;

    $app->SUPER::build_page( $page, $param );
}

sub build_blog_selector {
    my $app = shift;
    my ($param) = @_;

    return if exists $param->{load_selector_data};

    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id if $blog;
    $param->{dynamic_all} = $blog->custom_dynamic_templates eq 'all' if $blog;

    my $blog_class    = $app->model('blog');
    my $website_class = $app->model('website');

    # Any access to a blog will put it on the top of your
    # recently used blogs list (the blog selector)
    if ( $blog && $blog->is_blog ) {
        $app->add_to_favorite_blogs($blog_id);
        $app->add_to_favorite_websites( $blog->parent_id );
    }
    elsif ( $blog && !$blog->is_blog ) {
        $app->add_to_favorite_websites($blog_id);
    }
    my $auth = $app->user or return;

    # Load favorites blogs
    my @fav_blogs = @{ $auth->favorite_blogs || [] };
    my $max_fav_sites = MT->config->MaxFavoriteSites || 5;
    my $max_load = $max_fav_sites + 1;
    if ( scalar @fav_blogs > $max_fav_sites ) {
        @fav_blogs = @fav_blogs[ 0 .. $max_fav_sites - 1 ];
    }

    # How many blogs that the user can access?
    my %args;
    my %terms;
    $args{join}
        = MT::Permission->join_on( 'blog_id',
        { author_id => $auth->id, permissions => { not => "'comment'" } } )
        if !$auth->is_superuser
        && !$auth->permissions(0)->can_do('edit_templates')
        && !$auth->permissions(0)->can_do('access_to_website_list');
    $terms{class}     = 'blog';
    $terms{parent_id} = \">0";    # FOR-EDITOR";
    $args{limit}      = $max_load;        # Don't load over 6 blogs
    my @blogs = $blog_class->load( \%terms, \%args );

# Special case. If this user can access 5 blogs or smaller then load those blogs.
    $param->{selector_hide_blog_chooser} = 1;
    if ( @blogs && scalar @blogs == $max_load ) {

        # This user can access over 6 blogs.
        if (@fav_blogs) {
            @blogs
                = $blog_class->load( { class => 'blog', id => \@fav_blogs } );
        }
        else {
            @blogs = ();
        }
        $param->{selector_hide_blog_chooser} = 0;
    }

    # Load favorites or all websites
    my @fav_websites = @{ $auth->favorite_websites || [] };
    if ( scalar @fav_websites > $max_fav_sites ) {
        @fav_websites = @fav_websites[ 0 .. $max_fav_sites - 1 ];
    }
    my @websites;
    @websites = $website_class->load( { id => \@fav_websites } )
        if scalar @fav_websites;

    if ( scalar @fav_websites < $max_load ) {

        # Load more accessible websites
        %args  = ();
        %terms = ();

        $args{join} = MT::Permission->join_on( 'blog_id',
            { author_id => $auth->id, permissions => { not => "'comment'" } }
            )
            if !$auth->is_superuser
            && !$auth->permissions(0)->can_do('edit_templates')
            && !$auth->permissions(0)->can_do('access_to_website_list');
        $terms{class} = 'website';
        my $not_ids;
        push @$not_ids, @fav_websites;
        push @$not_ids, $blog->parent_id if $blog && $blog->is_blog && $blog->parent_id;
        $terms{id} = { not => $not_ids } if scalar @$not_ids;
        $args{limit} = $max_load
            - ( scalar @fav_websites );    # Don't load over 3 ~ 4 websites.
        my @sites = $website_class->load( \%terms, \%args );
        push @websites, @sites;
    }

    if (@fav_websites) {
        my $i;
        my %sorted = map { $_ => $i++ } @fav_websites;
        foreach (@websites) {
            $sorted{ $_->id } = scalar @websites if !exists $sorted{ $_->id };
        }
        @websites
            = sort { ( $sorted{ $a->id } || 0 ) <=> ( $sorted{ $b->id } || 0 ) }
            @websites;
    }

# Special case. If this user can access 3 websites or smaller then load those websites.
    $param->{selector_hide_website_chooser} = 1;
    if ( @websites && scalar @websites == $max_load ) {
        pop @websites;
        $param->{selector_hide_website_chooser} = 0;
    }

    # Build selector data
    my @website_data;
    if (@websites) {

        for my $ws (@websites) {
            next unless $ws;
            next if $ws->is_blog;

            my $blog_ids;
            push @$blog_ids, $ws->id;
            push @$blog_ids, ( map { $_->id } @{ $ws->blogs } )
                if $ws->blogs;

            my @perms = MT::Permission->load(
                {   author_id => $auth->id,
                    blog_id   => $blog_ids,
                }
            );

            if (   ( $blog && $blog->is_blog && $blog->parent_id == $ws->id )
                || ( $blog && !$blog->is_blog && $blog->id == $ws->id ) )
            {
                $param->{curr_website_id}   = $ws->id;
                $param->{curr_website_name} = $ws->name;
                $param->{curr_website_can_link}
                    = (    $auth->is_superuser
                        || $auth->permissions(0)->can_do('edit_templates')
                        || $auth->permissions(0)
                        ->can_do('access_to_website_list')
                        || @perms > 0 )
                    ? 1
                    : 0;
            }
            else {
                my $fav_data;
                $fav_data->{fav_website_id}   = $ws->id;
                $fav_data->{fav_website_name} = $ws->name;
                $fav_data->{fav_website_can_link}
                    = (    $auth->is_superuser
                        || $auth->permissions(0)->can_do('edit_templates')
                        || $auth->permissions(0)
                        ->can_do('access_to_website_list')
                        || @perms > 0 )
                    ? 1
                    : 0;

                push @website_data, \%$fav_data;
            }
        }
    }
    $param->{fav_website_loop} = \@website_data;

    if ( !$param->{curr_website_id} ) {
        my $ws;
        if ( $blog && $blog->is_blog && $blog->website ) {
            $ws = $blog->website;
        }
        elsif ( $blog && !$blog->is_blog ) {
            $ws = $blog;
        }
        if ($ws) {
            $param->{curr_website_id}       = $ws->id;
            $param->{curr_website_name}     = $ws->name;
            $param->{curr_website_can_link} = 1;
        }
    }

    my @blog_data;
    if (@blogs) {

        my $i;
        my %sorted = map { $_ => $i++ } @fav_blogs;
        @blogs
            = sort { ( $sorted{ $a->id } || 0 ) <=> ( $sorted{ $b->id } || 0 ) }
            @blogs;

        foreach $b (@blogs) {
            if ( $blog && $blog->is_blog && $blog->id == $b->id ) {
                $param->{curr_blog_id}   = $b->id;
                $param->{curr_blog_name} = $b->name;
            }
            else {
                my $fav_data;
                $fav_data->{fav_blog_id}     = $b->id;
                $fav_data->{fav_blog_name}   = $b->name;

                my $parent = $b->website || next; # fatally broken
                $fav_data->{fav_parent_id}   = $parent->id;
                $fav_data->{fav_parent_name} = $parent->name;

                push @blog_data, \%$fav_data;
            }
        }
    }
    $param->{fav_blog_loop} = \@blog_data;

    if ( !$param->{curr_blog_id} ) {
        if ( $blog && $blog->is_blog ) {
            $param->{curr_blog_id}   = $blog->id;
            $param->{curr_blog_name} = $blog->name;
        }
    }

    $app->_build_site_selector($param);

    $param->{load_selector_data}  = 1;
    $param->{can_create_blog}     = $auth->can_do('create_site') && $blog;
    $param->{can_create_website}  = $auth->can_do('create_site');
    $param->{can_access_overview} = 1;
}

sub _build_site_selector {
    my $app = shift;
    my ($param) = @_;

FAV_BLOG: for my $fav_blog ( @{ $param->{fav_blog_loop} } ) {
        for my $fav_website ( @{ $param->{fav_website_loop} } ) {
            if ($fav_website->{fav_website_id} == $fav_blog->{fav_parent_id} )
            {
                push @{ $fav_website->{fav_website_children} ||= [] },
                    $fav_blog;
                next FAV_BLOG;
            }
        }
        my $can_link
            = $app->user->is_superuser
            || $app->user->permissions(0)->can_do('edit_templates')
            || $app->user->permissions(0)->can_do('access_to_blog_list')
            || MT::Permission->count(
            {   author_id => $app->user->id,
                blog_id   => $fav_blog->{fav_parent_id}
            }
            );
        push @{ $param->{fav_website_loop} },
            +{
            fav_website_can_link => $can_link,
            fav_website_id       => $fav_blog->{fav_parent_id},
            fav_website_name     => $fav_blog->{fav_parent_name},
            fav_website_children => [$fav_blog],
            };
    }
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
    my $perms                 = $app->permissions || $user->permissions;
    my $view                  = $app->view;
    my $hide_disabled_options = $app->config('HideDisabledMenus') || 1;

    my $admin = $user->is_superuser()
        ;    # || ($perms && $perms->has('administer_site'));

    my $app_param_type = $app->param('_type') || '';
    my $filter_key     = $app->param('filter_key');
    my $app_param_id   = $app->param('id');

    my $is_category_set;
    if ($app_param_type eq 'category' && $mode eq 'view' && !$app->param('is_category_set')) {
        $is_category_set = $app->model('category')->exist({
            id => $app_param_id || 0,
            category_set_id => { not => 0 }
        });
    }

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
        $menu->{'id'}    = $id;

        my @sub_ids = grep {m/^$id:/} keys %$menus;
        my @sub;
        foreach my $sub_id (@sub_ids) {
            ## skip only if false value was set explicitly.
            next
                if exists $theme_modify->{$sub_id}
                && !$theme_modify->{$sub_id};
            my $sub = $menus->{$sub_id};
            $sub->{current} = 0;

            ## Keep a compatibility
            $sub->{view} = [ 'blog', 'system' ]
                unless $sub->{view};

            if ( $sub->{view} ) {
                if ( ref $sub->{view} eq 'ARRAY' ) {
                    next
                        unless ( scalar grep { $_ eq $view }
                        @{ $sub->{view} } );
                }
                else {
                    next if $sub->{view} ne $view;
                }
            }
            $sub->{view_permit} = 1;
            $sub->{'id'} = $sub_id;
            if ( my $cond = $sub->{condition} ) {
                if ( !ref($cond) ) {
                    $cond = $sub->{condition}
                        = $app->handler_to_coderef($cond);
                }
                next unless $cond->();
            }

            if ( $sub->{args} ) {
                if (   $sub->{mode} eq $mode
                    && defined($app_param_type)
                    && ( $sub->{args}->{_type} || '' ) eq $app_param_type
                    && $app_param_type ne 'content_data'
                    && (!defined( $sub->{args}->{filter_key} )
                        || ( defined($filter_key)
                            && $sub->{args}->{filter_key} eq $filter_key )
                    )
                    )
                {
                    $param->{screen_group} = $id;
                    if ($app_param_id) {
                        $sub->{current} = 1
                            if ( $app_param_type eq 'blog' )
                            || ( $app_param_type eq 'website' );
                    }
                    else {
                        $sub->{current} = 1;
                    }
                }
                elsif (( $app_param_type || '' ) eq 'content_data'
                    && ( $sub->{args}{_type} || '' ) eq 'content_data'
                    && $mode ne 'search_replace' )
                {
                    $param->{screen_group} = $id;

                    my ($content_type_id)
                        = ( $app->param('type') || '' )
                        =~ /^content_data_([0-9]+)$/;
                    $content_type_id ||= $app->param('content_type_id');
                    $content_type_id ||= 0;

                    if ( "content_data:$content_type_id" eq $sub_id ) {
                        $sub->{current} = 1;
                    }
                }
                elsif (( $app_param_type || '' ) eq 'category'
                    && ( $sub->{args}{_type} || '' ) eq 'category_set'
                    && $app->param('is_category_set') )
                {

                    $param->{screen_group} = 'category_set';
                    if ( $sub_id eq 'category_set:create'
                        && !$app->param('id') )
                    {
                        $sub->{current} = 1;
                    }
                }
                elsif (( $app_param_type || '' ) eq 'category'
                    && $mode eq 'view'
                    && !$app->param('is_category_set') )
                {
                    $param->{screen_group}
                        = $is_category_set ? 'category_set' : 'entry';
                }
            }
            else {
                if ( $sub->{mode} eq $mode ) {
                    $param->{screen_group} = $id;
                    if ($app_param_id) {
                        $sub->{current} = 1
                            if ( $app_param_type eq 'blog' )
                            || ( $app_param_type eq 'website' );
                    }
                    else {
                        $sub->{current} = 1;
                    }
                }
            }
            unless ( exists $sub->{mobile} ) {
                $sub->{mobile} = 0;
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
                            (   ( $blog_id && !$sys_only )
                                    || $app->view eq 'system'
                                ? ( blog_id => $blog_id )
                                : ()
                            )
                        }
                    );
                }
                $sub->{allowed} = 0
                    if $sub->{view} && ( !$sub->{view_permit} );
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
                my $sys_only;
                $sys_only = 1 if $menu->{id} eq 'system';
                $menu->{link} = $app->uri(
                    mode => $menu->{mode},
                    args => {
                        %{ $menu->{args} || {} },
                        (   ( $blog_id && !$sys_only )
                                || $app->view eq 'system'
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
            unless ( exists $menu->{mobile} ) {
                $menu->{mobile} = ( grep { $_->{mobile} } @sub ) ? 1 : 0;
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
    my ($param) = @_;
    return if exists $param->{compose_menus};

    my $user = $app->user
        or return;

    my $scope = $app->view;
    my $blog_id
        = $app->blog
        ? $app->blog->id
        : 0;

    my $menus = $app->registry('compose_menus');
    if ( my $legacy_menus = $menus->{compose_menus} ) {
        $menus = { %$menus, %{ $legacy_menus->{menus} }, };
        delete $menus->{compose_menus};
    }
    my @root_keys = keys %$menus;
    my @menus;

    foreach my $key (@root_keys) {
        my $item = $menus->{$key};
        if ( $item->{view} ) {
            if ( ref $item->{view} eq 'ARRAY' ) {
                next
                    unless ( scalar grep { $_ eq $scope }
                    @{ $item->{view} } );
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
                    (   $blog_id
                        ? ( blog_id => $blog_id )
                        : ()
                    )
                }
            );
        }
        push @menus, $item;
    }

    if ( my $compose_menus
        = $app->filter_conditional_list( \@menus, ($param) ) )
    {
        @menus = sort { $a->{order} <=> $b->{order} } @$compose_menus;
    }
    else {
        @menus = ();
    }
    $param->{compose_menus} = \@menus;
}

sub build_user_menus {
    my $app = shift;
    my ($param) = @_;
    return if exists $param->{user_menus};
    my $login_user = $app->user
        or return;
    my $scope = $app->view;
    my $user_id
        = $param->{user_menu_id}
        || $app->param('author_id')
        || $login_user->id;
    my $menu_user = MT->model('author')->load($user_id)
        or return $app->errtrans('Invalid parameter');
    $param->{user_menu_id} ||= $user_id;
    $param->{user_menu_user} = $menu_user;
    my $active = $param->{active_user_menu};
    $active = '' unless defined $active;
    $param->{is_me} ||= $login_user->id == $user_id;
    my $reg_menus = $app->registry('user_menus');
    my $menus = $app->filter_conditional_list( $reg_menus, $app, $param );
    my @menus;

    foreach my $key ( keys %$menus ) {
        my %menu_item;
        my $item = $menus->{$key};
        if ( $item->{view} ) {
            if ( ref $item->{view} eq 'ARRAY' ) {
                next
                    unless ( scalar grep { $_ eq $scope }
                    @{ $item->{view} } );
            }
            else {
                next if $item->{view} ne $scope;
            }
        }
        if ( my $link = $item->{link} ) {
            $link = MT->handler_to_coderef($link) unless ref $link;
            $menu_item{link} = $link->( $app, $param );
        }
        elsif ( $item->{mode} ) {
            my $user_key = $item->{user_param} || 'author_id';
            $menu_item{link} = $app->uri(
                mode => $item->{mode},
                args => {
                    %{ $item->{args} || {} },
                    blog_id   => 0,
                    $user_key => $user_id,
                }
            );
        }
        if ( my $hdlr = $item->{label_handler} ) {
            $hdlr = MT->handler_to_coderef($hdlr) unless ref $hdlr;
            $menu_item{label} = $hdlr->( $app, $param );
        }
        else {
            $menu_item{label} = $item->{label};
        }
        $menu_item{order}     = $item->{order};
        $menu_item{is_active} = $active eq $key ? 1 : 0;
        $menu_item{id}        = $key;
        push @menus, \%menu_item;
    }
    @menus = sort { $a->{order} <=> $b->{order} } @menus;
    $param->{user_menus} = \@menus;
}

sub build_actions {
    my $app = shift;
    my ( $registry_key, $param ) = @_;

    my $actions = $app->registry($registry_key) || {};

    my @valid_actions;
    for my $id ( keys %$actions ) {
        my $action = $actions->{$id};
        my $cond   = $action->{condition};
        if ( defined $cond ) {
            next unless $cond;
            next if ref $cond eq 'CODE' && !$cond->( $app, $param );
        }

        my $href = $action->{href};
        if ( $href && ref $href eq 'CODE' ) {
            $href = $href->( $app, $param );
        }
        $action->{id} = $id;
        $action->{order} ||= 0;

        push @valid_actions, $action;
    }

    @valid_actions
        = sort { $a->{order} <=> $b->{order} or $a->{id} cmp $b->{id} }
        @valid_actions;

    $param->{$registry_key} = \@valid_actions;
}

sub return_to_dashboard {
    my $app = shift;
    my (%param) = @_;

    $param{redirect} = 1 unless %param;

    my $blog_id = $app->param('blog_id');
    if ( defined($blog_id) && $blog_id ne '' ) {
        my $perm = MT->model('permission')->load(
            {   author_id => $app->user->id,
                blog_id   => $blog_id,
            }
        );
        $param{blog_id} = $blog_id if $perm;
    }

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

    if ( $list_pref->{view} ) {
        $list_pref->{ "view_" . $list_pref->{view} } = 1;
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
    if ( $app->param('xhr')
        or ( ( $method_info->{app_mode} || '' ) eq 'JSON' ) )
    {
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
                    $param->{goback}
                        = "window.location='" . $app->{goback} . "'";
                    if ( $tmpl_edit_link ne $app->{goback} ) {
                        push @{ $param->{button_loop} ||= [] },
                            {
                            link  => $tmpl_edit_link,
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
                    link  => $tmpl_edit_link,
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
        $param->{value} ||= $app->{value} || $app->translate('Back');
    }

    return $app->SUPER::show_error($param);
}

sub show_login {
    my $app = shift;
    my $method_info = MT->request('method_info') || {};
    if ( $app->param('xhr')
        or ( ( $method_info->{app_mode} || '' ) eq 'JSON' ) )
    {
        $app->{login_again} = 1;
        return $app->show_error( { error => 'Unauthorized', status => 401 } );
    }
    return $app->SUPER::show_login(@_);
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
        if ( $prefs !~ m/\b(?:default|basic|custom|advanced)\b/i ) {
            if ( $prefs !~ m/\btitle\b/ ) {
                $prefs = 'title,' . $prefs;
            }
            if ( $prefs !~ m/\btext\b/ ) {
                $prefs =~ s/\btitle\b/title,text/;
            }
        }
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
    my $perm
        = MT::Permission->load( { blog_id => $blog_id, author_id => 0 } );
    my %default = %{ $app->config->DefaultEntryPrefs };
    %default = map { lc $_ => $default{$_} } keys %default;

    if ( $perm && $perm->page_prefs ) {
        $prefs = $perm->page_prefs;
        if ( $prefs !~ m/\b(?:default|basic|custom|advanced)\b/i ) {
            if ( $prefs !~ m/\btitle\b/ ) {
                $prefs = 'title,' . $prefs;
            }
            if ( $prefs !~ m/\btext\b/ ) {
                $prefs =~ s/\btitle\b/title,text/;
            }
        }
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
        if ( $p =~ m/^(.+?):(\w+)$/ ) {
            $param{ 'disp_prefs_' . $1 } = $2;
        }
    }
    \%param;
}

sub _parse_entry_prefs {
    my $app = shift;
    my ( $prefix, $prefs, $param, $fields ) = @_;
    my @p = split /,/, $prefs;
    for my $p (@p) {
        my ( $name, $ext ) = $p =~ m/^(.+?):(.+)$/;
        $p = $name if ( defined $ext );

        if ( $ext and ( $ext =~ m/^(\d+)$/ ) ) {
            $param->{ 'disp_prefs_height_' . $p } = $ext;
        }
        if ( grep { lc($p) eq $_ } qw{advanced default basic} ) {
            $p = 'Default' if lc($p) eq 'basic';
            $param->{ $prefix . 'disp_prefs_' . $p } = 1;
            my @fields
                = qw( title body category tags feedback publishing assets );
            if ( lc($p) eq 'advanced' ) {
                push @fields, qw(excerpt feedback keywords);
            }
            foreach my $def (@fields) {
                $param->{ $prefix . 'disp_prefs_show_' . $def } = 1;
                push @$fields, { name => $def };
            }
        }
        else {
            $param->{ $prefix . 'disp_prefs_show_' . $p } = 1;
            push @$fields, { name => $p };
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
    return MT::Util::convert_word_chars( $s, $smart_replace );
}

sub _translate_naughty_words {
    my ( $app, $entry ) = @_;
    require MT::Util;
    return MT::Util::translate_naughty_words($entry);
}

sub user_who_is_also_editing_the_same_stuff {
    my ($app, $obj) = @_;
    my $type  = $app->param('_type') or return;
    my $id    = $app->param('id') or return;
    my $ident = 'autosave:user=%:type=' . $type . ':id=' . $id;
    my $blog  = $app->blog;
    if ($blog) {
        $ident .= ':blog_id=' . $blog->id;
    }
    if ( $type eq 'content_data' ) {
        my $content_type_id = $app->param('content_type_id') or return;
        $ident .= ':content_type_id=' . $content_type_id;
    }
    require MT::Session;
    my $sess_obj = MT::Session->load(
        { id    => { like  => $ident }, kind => 'AS',    start     => [time - MT->config->AutosaveSessionTimeout - 1] },
        { range => { start => 1 },      sort => 'start', direction => 'descend' }) or return;
    my ($user_id) = $sess_obj->id =~ /:user=([0-9]+)/;
    if ($user_id != $app->user->id && MT::Util::epoch2ts($blog, $sess_obj->start) > $obj->modified_on) {
        my $user = $app->model('author')->load($user_id);
        require MT::Util;
        return {
            name => $user->nickname || $user->name,
            time => MT::Util::format_ts('%Y-%m-%d %H:%M:%S', MT::Util::epoch2ts($blog, $sess_obj->start), $blog),
        } if $user;
    }
    return;
}

sub autosave_session_obj {
    my $app           = shift;
    my ($or_make_one) = @_;
    my $type          = $app->param('_type');
    return unless $type;
    my $id = $app->param('id');
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
    if ( $type eq 'content_data' ) {
        my $content_type_id = $app->param('content_type_id');
        $ident .= ':content_type_id=' . $content_type_id;
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
    my $type  = $app->param('_type');
    my $class = $app->model($type) or return;
    my %data  = $app->param_hash;
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
    $app->print_encode("true");
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

sub archive_type_sorter {
    my ( $a, $b ) = @_;

    my $order_a = MT->publisher->archiver( $a->{archive_type} )->order();
    my $order_b = MT->publisher->archiver( $b->{archive_type} )->order();

    my $a_is_preferred = $a->{map_is_preferred} || 0;
    my $b_is_preferred = $b->{map_is_preferred} || 0;

    return $order_a <=> $order_b
        || $b_is_preferred <=> $a_is_preferred;
}

sub preview_object_basename {
    my $app = shift;
    my @parts;
    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id if $blog;
    my $id              = $app->param('id');
    my $type            = $app->param('_type');
    my $content_type_id = $app->param('content_type_id');
    push @parts, $app->user->id;
    push @parts, $blog_id || 0;
    push @parts, $id || 0;
    push @parts, $type if $type;
    push @parts, $content_type_id if $content_type_id;
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
    my $blog_id;
    $blog_id = $obj->column('blog_id') if $obj->has_column('blog_id');
    return $app->uri(
        'mode' => 'view',
        args   => {
            '_type' => $type,
            ( $blog_id ? ( blog_id => $blog_id ) : () ), id => $_[1]
        }
    );
}

sub add_to_favorite_sites {
    my $app = shift;
    my ($fav) = @_;

    my $user = $app->user;
    return unless $user;

    my $site = MT->model('blog')->load($fav);
    return unless $site;

    return
           unless $user->has_perm($fav)
        || $user->is_superuser
        || $user->permissions(0)->can_do('edit_templates')
        || $user->permissions(0)->can_do('access_to_website_list');

    my @current = @{ $user->favorite_sites || [] };

    return if @current && ( $current[0] == $fav );
    my $max_fav_sites_to_remember = (MT->config->MaxFavoriteSites || 5) * 2 * 2;
    @current = grep { $_ != $fav } @current;
    unshift @current, $fav;
    @current = @current[ 0 .. $max_fav_sites_to_remember - 1 ]
        if @current > $max_fav_sites_to_remember;

    $user->favorite_sites( \@current );
    $user->save;
}

sub add_to_favorite_blogs {
    my $app = shift;
    my ($fav) = @_;

    add_to_favorite_sites( $app, $fav );

    my $auth = $app->user;
    return unless $auth;

    my $blog = MT->model('blog')->load($fav);
    return unless $blog;
    return unless $blog->is_blog;

    return
           unless $auth->has_perm($fav)
        || $auth->is_superuser
        || $auth->permissions(0)->can_do('edit_templates')
        || $auth->permissions(0)->can_do('access_to_blog_list');

    my @current = @{ $auth->favorite_blogs || [] };

    return if @current && ( $current[0] == $fav );
    my $max_fav_sites_to_remember = (MT->config->MaxFavoriteSites || 5) * 2;
    @current = grep { $_ != $fav } @current;
    unshift @current, $fav;
    @current = @current[ 0 .. $max_fav_sites_to_remember - 1 ]
        if @current > $max_fav_sites_to_remember;

    $auth->favorite_blogs( \@current );
    $auth->save;
}

sub add_to_favorite_websites {
    my $app = shift;
    my ($fav) = @_;

    add_to_favorite_sites( $app, $fav );

    my $auth = $app->user;
    return unless $auth;

    my $website = MT->model('website')->load($fav);
    return unless $website;
    return if $website->is_blog;

    my $trust;
    my $blog_ids;
    push @$blog_ids, $fav;

    my @blogs = MT->model('blog')->load( { parent_id => $fav } );
    push @$blog_ids, ( map { $_->id } @blogs )
        if @blogs;

    foreach my $id (@$blog_ids) {
        $trust = 1, last
            if $auth->has_perm($id);
    }

    return
           unless $trust
        || $auth->is_superuser
        || $auth->permissions(0)->can_do('edit_templates')
        || $auth->permissions(0)->can_do('access_to_website_list');

    my @current = @{ $auth->favorite_websites || [] };

    return if @current && ( $current[0] == $fav );
    my $max_fav_sites_to_remember = (MT->config->MaxFavoriteSites || 5) * 2;
    @current = grep { $_ != $fav } @current;
    unshift @current, $fav;
    @current = @current[ 0 .. $max_fav_sites_to_remember - 1 ]
        if @current > $max_fav_sites_to_remember;

    $auth->favorite_websites( \@current );
    $auth->save;
}

sub _entry_prefs_from_params {
    my $app    = shift;
    my $prefix = shift || '';
    my $disp   = $app->param('entry_prefs') || '';
    my @fields;
    if ( lc $disp eq 'custom' ) {
        @fields = split /,/, $app->param( $prefix . 'custom_prefs' ) || '';
    }
    elsif ($disp) {
        push @fields, $disp;
    }
    else {
        @fields = $app->multi_param( $prefix . 'custom_prefs' );
    }

    if ( my $body_height = $app->param('text_height') ) {
        push @fields, 'body:' . $body_height;
    }
    return
        join( ',', @fields ) . '|' . ( $app->param('bar_position') || 'top' );
}

# rebuild_set is a hash whose keys are entry IDs
# the value can be the entry itself, for efficiency,
# but if the value is not a ref, the entry is loaded from the ID.
# This is not a handler but a utility routine
sub rebuild_these {
    my $app = shift;
    my ( $rebuild_set, %options ) = @_;
    my $complete = $options{complete_handler} || sub {
        my ($app) = @_;
        $app->call_return;
    };
    my $phase = $options{rebuild_phase_handler} || sub {
        my ( $app, $params ) = @_;
        my %param = (
            is_full_screen  => 1,
            redirect_target => $app->uri(
                mode => 'rebuild_phase',
                args => $params
            )
        );
        $app->load_tmpl( 'rebuilding.tmpl', \%param );
    };

    # if there's nothing to rebuild, just return
    if ( !keys %$rebuild_set ) {
        if ( my $start_time = $app->param('start_time') ) {
            $app->publisher->start_time($start_time);
        }

        # now, rebuild indexes for affected blogs
        my @blogs = $app->multi_param('blog_ids');
        if (@blogs) {
            $app->run_callbacks('pre_build') if @blogs;
            foreach my $blog_id (@blogs) {
                my $blog = MT::Blog->load($blog_id) or next;
                $app->rebuild_indexes( Blog => $blog )
                    or return $app->publish_error();
            }
            my $blog_id = int( $app->param('blog_id') || 0 );
            my $this_blog;
            $this_blog = MT::Blog->load($blog_id) if $blog_id;
            $app->run_callbacks( 'rebuild', $this_blog );
            $app->run_callbacks('post_build');
        }
        return $complete->($app);
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
        return $phase->( $app, $params );
    }
    else {
        my @blogs      = $app->multi_param('blog_ids');
        my $start_time = $app->param('start_time');
        $app->publisher->start_time($start_time) if $start_time;
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

            my $perms = $app->user->permissions( $e->blog_id );
            return $app->permission_denied()
                unless $perms
                && $perms->can_republish_entry( $e, $app->user );

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
            return_args     => scalar $app->param('return_args'),
            build_type_name => $app->translate("entry"),
            blog_id         => $app->param('blog_id') || 0,
            blog_ids        => [ keys %blogs ],
            id              => \@rest,
            start_time      => $start_time,
        };
        return $phase->( $app, $params );
    }
}

sub rebuild_these_content_data {
    my $app = shift;
    my ( $rebuild_set, %options ) = @_;
    my $complete = $options{complete_handler} || sub {
        my ($app) = @_;
        $app->call_return;
    };
    my $phase = $options{rebuild_phase_handler} || sub {
        my ( $app, $params ) = @_;
        my %param = (
            is_full_screen  => 1,
            redirect_target => $app->uri(
                mode => 'rebuild_phase',
                args => $params
            )
        );
        $app->load_tmpl( 'rebuilding.tmpl', \%param );
    };

    # if there's nothing to rebuild, just return
    if ( !keys %$rebuild_set ) {
        if ( my $start_time = $app->param('start_time') ) {
            $app->publisher->start_time($start_time);
        }

        # now, rebuild indexes for affected blogs
        my @blogs = $app->multi_param('blog_ids');
        if (@blogs) {
            $app->run_callbacks('pre_build') if @blogs;
            foreach my $blog_id (@blogs) {
                my $blog = MT::Blog->load($blog_id) or next;
                $app->rebuild_indexes( Blog => $blog )
                    or return $app->publish_error();
            }
            my $blog_id = int( $app->param('blog_id') || 0 );
            my $this_blog;
            $this_blog = MT::Blog->load($blog_id) if $blog_id;
            $app->run_callbacks( 'rebuild', $this_blog );
            $app->run_callbacks('post_build');
        }
        return $complete->($app);
    }

    if ( exists $options{how} && ( $options{how} eq NEW_PHASE ) ) {
        my $start_time = time;
        $app->run_callbacks('pre_build');
        my $params = {
            return_args => $app->return_args,
            blog_id     => $app->param('blog_id') || 0,
            _type       => 'content_data',
            id          => [ keys %$rebuild_set ],
            start_time  => $start_time,
        };
        return $phase->( $app, $params );
    }
    else {
        my @blogs      = $app->multi_param('blog_ids');
        my $start_time = $app->param('start_time');
        $app->publisher->start_time($start_time) if $start_time;
        my %blogs = map { $_ => () } @blogs;
        my @set = keys %$rebuild_set;
        my @rest;
        my $entries_per_rebuild = $app->config('EntriesPerRebuild');
        if ( scalar @set > $entries_per_rebuild ) {
            @rest = @set[ $entries_per_rebuild .. $#set ];
            @set  = @set[ 0 .. $entries_per_rebuild - 1 ];
        }
        require MT::ContentData;
        for my $id (@set) {
            my $cd = ref $id ? $id : MT::ContentData->load($id) or next;

            my $perms = $app->user->permissions( $cd->blog_id );
            return $app->permission_denied()
                unless $perms
                && $perms->can_republish_content_data( $cd, $app->user );

            $blogs{ $cd->blog_id } = ();
            $app->rebuild_content_data(
                ContentData       => $cd,
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
            return_args     => scalar $app->param('return_args'),
            build_type_name => $app->translate("content data"),
            blog_id         => $app->param('blog_id') || 0,
            blog_ids        => [ keys %blogs ],
            _type           => 'content_data',
            id              => \@rest,
            start_time      => $start_time,
        };
        return $phase->( $app, $params );
    }
}

sub remove_preview_file {
    my $app = shift;

    # Clear any preview file that may exist (returning from
    # a preview using the 'reedit', 'cancel' or 'save' buttons)
    my $preview_basename = $app->param('_preview_file');

    # Clear any preview file when saving entry,
    # if PreviewInNewWindow is ON.
    $preview_basename = $app->preview_object_basename
        if ( !$preview_basename && $app->config('PreviewInNewWindow') );

    if ($preview_basename) {
        require MT::Session;
        if (my $tf = MT::Session->load(
                {   id   => $preview_basename,
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
    my $type            = $param{type};
    my $cat_set_id;
    if ( $type eq 'category' ) {
        $cat_set_id = $param{cat_set_id};
    }

    my @data;
    my $class = $app->model($type) or return;

    my %expanded;

    if ($new_cat_id) {
        my $new_cat = $class->load($new_cat_id);
        my @parents = $new_cat->parent_categories;
        %expanded = map { $_->id => 1 } @parents;
    }

    my $id_ord;
    if ($cat_set_id) {
        require MT::CategorySet;
        if ( my $cat_set = MT::CategorySet->load($cat_set_id) ) {
            $id_ord = $cat_set->order || '';
        }
    }
    else {
        my $meta = $type . '_order';
        my $blog
            = MT->model('blog')
            ->load( { id => $blog_id }, { no_class => 1 } );
        $id_ord = $blog->$meta || '';
    }

    my @cats = $class->load(
        {   blog_id         => $blog_id,
            category_set_id => $cat_set_id || [ \'IS NULL', 0 ],
        }
    );
    @cats = MT::Category::_sort_by_id_list(
        $id_ord,
        \@cats,
        unknown_place        => 'top',
        secondary_sort       => 'created_on',
        secondary_sort_order => 'descend'
    );
    @cats = MT::Category::_flattened_category_hierarchy( \@cats );
    my $cols    = $class->column_names;
    my $depth   = 0;
    my $i       = 1;
    my $top_cat = 1;

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
        if ( my $fields = $obj->show_fields ) {
            $row->{category_selected_fields} = $fields;
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
    if ($blog) {
        my $theme = $blog->theme;
        push @paths, $theme->alt_tmpl_path
            if $theme;
    }
    push @paths, $app->SUPER::template_paths(@_);
    return @paths;
}

sub _load_child_blog_ids {
    my $app = shift;
    my ($blog_id) = @_;
    return unless $blog_id;

    my $blog_class = $app->model('blog');
    my $blog       = $blog_class->load($blog_id);
    return unless $blog;

    my $user = $app->user;
    return unless $user;

    my @ids;
    if (  !$blog->is_blog
        && $user->permissions( $blog->id )->can_do('administer_site') )
    {
        my $blogs = $blog->blogs();
        if (@$blogs) {
            foreach my $b (@$blogs) {
                push @ids, $b->id
                    if $user->permissions( $b->id )
                    ->can_do('administer_site');
            }
        }
    }

    return \@ids;
}

sub view {
    my $app  = shift;
    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id if $blog;

    return
          $blog_id
        ? $blog->is_blog
            ? "blog"
            : "website"
        : !defined $app->param('blog_id')
        && $app->mode eq 'dashboard' ? "user"
        : 'system';
}

sub setup_filtered_ids {
    my $app        = shift;
    my $select_all = $app->param('all_selected');
    $app->param( 'all_selected', undef );
    return unless $select_all;
    my $blog_id = $app->param('blog_id');
    my $blog    = $app->blog;
    my $debug   = {};
    my $filteritems;
    ## TBD: use decode_js or something for decode js_string generated by jQuery.json.
    if ( my $items = $app->param('items') ) {
        if ( $items =~ /^".*"$/ && MT->config->UseMTCommonJSON ) {
            $items =~ s/^"//;
            $items =~ s/"$//;
            $items =~ s/\\"/"/g;
        }
        require JSON;
        my $json = JSON->new->utf8(0);
        $filteritems = $json->decode($items);
    }
    else {
        $filteritems = [];
    }
    my $ds     = $app->param('_type');
    my $filter = MT->model('filter')->new;
    $filter->set_values(
        {   object_ds => $ds,
            items     => $filteritems,
            author_id => $app->user->id,
            ( $blog ? ( blog_id => $blog->id ) : () ),
        }
    );
    my $scope
        = !$blog         ? 'system'
        : $blog->is_blog ? 'blog'
        :                  'website';
    my $blog_ids
        = !$blog         ? []
        : $blog->is_blog ? [$blog_id]
        :                  [ $blog->id, map { $_->id } @{ $blog->blogs } ];
    my $terms = {};
    $terms->{blog_id} = $blog_ids if $blog;
    my $args = {};
    my $opts = {
        terms    => $terms,
        args     => $args,
        scope    => $scope,
        blog     => $blog,
        blog_id  => $blog_id,
        blog_ids => $blog_ids,
    };

    my $callback_ds = $ds;
    if ( $ds =~ m/(.*)\./ ) {
        $callback_ds = $1;
    }
    MT->run_callbacks( 'cms_pre_load_filtered_list.' . $callback_ds,
        $app, $filter, $opts, [] );
    my $objs = $filter->load_objects(%$opts)
        or die $filter->errstr;
    my %data = ( objects => [ map( [ $_->id ], @$objs ) ] );
    MT->run_callbacks( 'cms_filtered_list_param.' . $callback_ds,
        $app, \%data, $objs );
    $app->param( 'id', map( $_->[0], @{ $data{objects} } ) );
}

sub setup_editor_param {
    my $app = shift;
    my ($param) = @_;

    if ( my $blog = $app->blog ) {
        if ( my $css = $blog->content_css ) {
            $css =~ s#\{\{support}}/?#$app->support_directory_url#ie;
            if ( my $theme = $blog->theme ) {
                $css =~ s#\{\{theme_static}}/?#$theme->static_file_url#ie;
            }
            if ( $css !~ m#\A(https?:)?/# ) {
                $css = MT::Util::caturl( $blog->site_url, $css );
            }
            $param->{content_css} = $css;
        }
    }

    $param->{object_type} = $app->param('_type') || '';

    if ( my $editor_regs = MT::Component->registry('editors') ) {
        $param->{editors} = {};
        foreach my $editors (@$editor_regs) {
            foreach my $editor_key ( keys(%$editors) ) {
                my $reg    = $editors->{$editor_key};
                my $plugin = $reg->{plugin};
                my $tmpls  = $param->{editors}{$editor_key} ||= {
                    templates  => [],
                    extensions => [],
                    config     => {},
                };

                foreach my $k ( 'template', 'extension' ) {
                    my $conf = $reg->{$k};
                    next unless defined $conf;
                    if ( !ref $conf ) {
                        $conf = {
                            template => $conf,
                            order    => 5,
                        };
                    }

                    if ( my $tmpl = $plugin->load_tmpl( $conf->{template} ) )
                    {
                        push(
                            @{ $tmpls->{ $k . 's' } },
                            { %$conf, tmpl => $tmpl }
                        );
                    }
                }

                $tmpls->{config}
                    = { %{ $tmpls->{config} }, %{ $reg->{'config'} } }
                    if $reg->{'config'};
                delete $tmpls->{config}{plugin};
            }
        }

        foreach my $editor_key ( keys %{ $param->{editors} } ) {
            if ( !@{ $param->{editors}{$editor_key}{templates} } ) {
                delete $param->{editors}{$editor_key};
                next;
            }

            foreach my $k ( 'templates', 'extensions' ) {
                $param->{editors}{$editor_key}{$k}
                    = [ sort { $a->{order} <=> $b->{order} }
                        @{ $param->{editors}{$editor_key}{$k} } ];
            }
        }

        if ( %{ $param->{editors} } ) {
            my $editor = lc( $app->config('Editor') );
            $param->{wysiwyg_editor}
                = lc( $app->config('WYSIWYGEditor') || $editor );
            $param->{source_editor}
                = lc( $app->config('SourceEditor') || $editor );
            $param->{editor_strategy} = lc( $app->config('EditorStrategy') );
        }
        else {
            delete $param->{editors};
        }
    }

    if ( !$param->{editors} ) {
        my $rte;
        if ( defined $param->{convert_breaks}
            && $param->{convert_breaks} =~ m/richtext/ )
        {
            ## Rich Text editor
            $rte = lc( $app->config('RichTextEditor') );
        }
        else {
            $rte = 'archetype';
        }
        my $editors = $app->registry("richtext_editors");
        my $edit_reg = $editors->{$rte} || $editors->{archetype};

        my $rich_editor_tmpl;
        if ( $rich_editor_tmpl
            = $edit_reg->{plugin}->load_tmpl( $edit_reg->{template} ) )
        {
            $param->{rich_editor}      = $rte;
            $param->{rich_editor_tmpl} = $rich_editor_tmpl;
        }
    }
}

sub archetype_editor_is_enabled {
    my ( $app, $param ) = @_;

    if ( !( $param->{editors} || $param->{rich_editor} ) ) {
        $param = {};
        $app->setup_editor_param($param);
    }

    return !$param->{editors}
        && lc( $app->config('RichTextEditor') ) eq 'archetype';
}

sub sanitize_tainted_param {
    my ( $app, $param, $keys ) = @_;

    die '$param->{tainted_input} does not exist'
        unless exists $param->{tainted_input};

    return 1 unless $param->{tainted_input};

    require MT::Sanitize;
    for my $k (@$keys) {
        die '$param->{' . $k . '} does not exist' unless exists $param->{$k};

        if ( my $v = $app->param($k) ) {
            $param->{$k} = MT::Sanitize->sanitize( $v,
                $app->config->GlobalSanitizeSpec );
        }
    }
}

sub validate_request_params {
    my $app = shift;
    my ($method_info) = @_;

    if ((   $app->param('xhr')
            || ( ( $method_info->{app_mode} || '' ) eq 'JSON' )
        )
        && ( ( $app->get_header('X-Requested-With') || '' ) ne
            'XMLHttpRequest' )
        )
    {
        return $app->errtrans('Invalid request');
    }

    $app->SUPER::validate_request_params(@_);
}

sub default_widgets_for_dashboard {
    my ( $app, $scope ) = @_;

    my $key = 'default_widget:' . $scope;
    return $app->request($key) if defined $app->request($key);

    my $widgets = $app->registry('widgets');
    return $app->request( $key, '' ) unless ref($widgets) eq 'HASH';

    my %default_widgets;
    foreach my $key ( keys %$widgets ) {
        my ( $view, $order, $set, $param, $default )
            = map { $widgets->{$key}{$_} } qw( view order set param default );

        my @views = ref($view) ? @$view : ($view);
        next unless grep { $scope eq $_ } @views;
        next unless ( ref($default) && $default->{$scope} ) || $default;

        $default_widgets{$key} = {
            order => ref($order) ? $order->{$scope} : $order,
            set   => ref($set)   ? $set->{$scope}   : $set,
            $param ? ( param => $param ) : (),
        };
    }

    $app->request( $key, %default_widgets ? \%default_widgets : '' );
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
