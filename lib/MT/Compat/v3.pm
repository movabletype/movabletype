# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Compat;

use strict;
use warnings;

# These were loaded by default under MT 3.x in the main MT module.
use MT::Entry;
use MT::Comment;
use MT::Blog;

our %app_ids;
our %api_map;
our %cms_map;
our %cms_rename_map;

BEGIN {
    %app_ids = (
        'MT::App::CMS'           => 'cms',
        'MT::App::Comments'      => 'comments',
        'MT::App::Search'        => 'search',
        'MT::App::ActivityFeeds' => 'feeds',
    );
    %api_map = (
        'MT::Template::Context::add_tag' => "Registry (path: tags, function)",
        'MT::Template::Context::add_container_tag' =>
            "Registry (path: tags, block)",
        'MT::Template::Context::add_conditional_tag' =>
            "Registry (path: tags, block)",
        'MT::Template::Context::add_global_filter' =>
            "Registry (path: tags, modifier)",
        'MT::add_text_filter' => "Registry (path: text_filters)",
        'MT::add_itemset_action' =>
            "Registry (path: application, [app_id], list_actions)",
        'MT::add_plugin_action' =>
            "Registry (path: application, [app_id], page_actions)",
        'MT::register_junk_filter' => "Registry (path: junk_filters)",
    );
    %cms_map = (
        AddressBook => [qw( send_notify entry_notify )],
        Asset       => [
            qw( asset_userpic upload_file build_asset_hasher start_upload complete_upload start_upload_entry build_asset_table complete_insert asset_list_filters asset_insert_text )
            ]
        , # _write_upload _upload_file _set_start_upload_params _process_post_upload
        Blog => [
            qw( update_welcome_message rebuild_pages start_rebuild_pages rebuild_confirm prepare_dynamic_publishing rebuild_phase dialog_select_weblog update_dynamicity rebuild_new_phase build_blog_table cfg_web_services make_blog_list cc_return RegistrationAffectsArchives cfg_blog cfg_prefs_save handshake cfg_prefs save_favorite_blogs cfg_feedback)
        ],
        Category => [
            qw( category_add js_add_category move_category category_do_add )],
        Comment => [
            qw( trust_commenter_by_comment unapprove_item set_item_visible not_junk reply_preview do_reply map_comment_to_commenter handle_junk untrust_commenter build_comment_table trust_commenter approve_item unban_commenter empty_junk build_junk_table cfg_registration dialog_post_comment untrust_commenter_by_comment build_commenter_table ban_commenter_by_comment save_commenter_perm ban_commenter unban_commenter_by_comment reply )
        ],    # _prepare_reply
        Common    => [qw( delete )],
        Dashboard => [
            qw( mt_blog_stats_widget mt_blog_stats_widget_entry_tab new_version_widget get_lmt_content mt_blog_stats_widget_comment_tab generate_dashboard_stats get_newsbox_content dashboard mt_news_widget generate_dashboard_stats_comment_tab this_is_you_widget create_dashboard_stats_file generate_dashboard_stats_entry_tab )
        ],
        Entry => [
            qw( cfg_entry draft_entries save_entries build_entry_table send_pings ping_continuation pinged_urls quickpost_js save_entry_prefs open_batch_editor update_entry_status publish_entries )
        ],    # _finish_rebuild_ping
        Export => [qw( start_export )],
        Import => [qw( do_import start_import )],
        Log    => [qw( apply_log_filter build_log_table )],
        Page   => [qw( CMSPostSave_page save_pages )],
        Plugin => [qw( cfg_plugins plugin_control build_plugin_table )],
        Search => [qw( do_search_replace search_replace )]
        ,     # _default_results_table_template
        Tag => [
            qw( js_tag_list add_tags_to_entries js_recent_entries_for_tag add_tags_to_assets js_tag_check build_tag_table remove_tags_from_assets remove_tags_from_entries list_tag_for rename_tag )
        ],
        Template => [
            qw( refresh_all_templates add_map build_template_table refresh_individual_templates publish_index_templates reset_blog_templates delete_map dialog_refresh_templates )
        ],    # _generate_map_table _populate_archive_loop
        Tools => [
            qw( save_cfg_system_general convert_to_html do_page_action restore copy recover_profile_password cfg_system_general do_list_action restore_directory dialog_restore_upload system_check backup recover_password get_syscheck_content start_recover upgrade start_restore restore_file restore_upload_manifest adjust_sitepath move update_list_prefs recover_passwords restore_premature_cancel backup_download start_backup reset_password dialog_adjust_sitepath )
        ],    # _backup_finisher _log_dirty_restore _progress
        TrackBack => [qw( build_ping_table )],
        User      => [
            qw( upload_userpic set_object_status save_cfg_system_users save_role grant_role dialog_select_sysadmin remove_user_assoc revoke_role remove_userpic build_author_table cfg_system_users dialog_grant_role edit_role list_member )
        ],    # _merge_default_assignments _delete_pseudo_association
    );
    %cms_rename_map = (

        # CMSViewPermissionFilter_asset     => 'Asset::can_view',
        # CMSViewPermissionFilter_author    => 'User::can_view',
        # CMSViewPermissionFilter_blog      => 'Blog::can_view',
        # CMSViewPermissionFilter_category  => 'Category::can_view',
        # CMSViewPermissionFilter_comment   => 'Comment::can_view',
        # CMSViewPermissionFilter_commenter => 'Comment::can_view_commenter',
        # CMSViewPermissionFilter_entry     => 'Entry::can_view',
        # CMSViewPermissionFilter_folder    => 'Folder::can_view',
        # CMSViewPermissionFilter_page      => 'Page::can_view',
        # CMSViewPermissionFilter_ping      => 'Ping::can_view',
        # CMSViewPermissionFilter_template  => 'Template::can_view',
        disable_object      => 'User::disable',
        edit_object         => 'Common::edit',
        enable_object       => 'User::enable',
        export_log          => 'Log::export',
        export_notification => 'AddressBook::export',
        list_assets         => 'Asset::list',
        list_associations   => 'User::list_association',
        list_authors        => 'User::list',
        list_blogs          => 'Blog::list',
        list_category       => 'Category::list',
        list_comments       => 'Comment::list',
        list_entries        => 'Entry::list',
        list_objects        => 'Common::list',
        list_pages          => 'Page::list',
        list_pings          => 'Ping::list',
        list_roles          => 'User::list_role',
        list_tag            => 'Tag::list',
        list_template       => 'Template::list',
        preview_entry       => 'Entry::preview',

        #reg_bm_js                         => '',
        #reg_file                          => '',
        reset_log           => 'Log::reset',
        reset_plugin_config => 'Plugin::reset_config',
        save_asset          => 'Asset::save',
        save_category       => 'Category::save',
        save_entry          => 'Entry::save',
        save_object         => 'Common::save',
        save_plugin_config  => 'Plugin::save_config',
        tools               => 'Tools::system_check',
        view_log            => 'Log::view',

        #_cb_notjunktest_filter            => 'Common::not_junk_test',
    );

    $MT::CallbackAlias{'BuildFileFilter'}     = 'build_file_filter';
    $MT::CallbackAlias{'BuildFile'}           = 'build_file';
    $MT::CallbackAlias{'BuildPage'}           = 'build_page';
    $MT::CallbackAlias{'PreEntrySave'}        = 'MT::Entry::pre_save';
    $MT::CallbackAlias{'PreCommentSave'}      = 'MT::Comment::pre_save';
    $MT::CallbackAlias{'RebuildOptions'}      = 'rebuild_options';
    $MT::CallbackAlias{'TakeDown'}            = 'take_down';
    $MT::CallbackAlias{'NewUserProvisioning'} = 'new_user_provisioning';

    # Unnecessary to map since all the v3 legacy callbacks would fail
    # anyway.
    # $MT::CallbackAlias{'AppTemplateSource'}   = 'template_source';
    # $MT::CallbackAlias{'AppTemplateParam'}    = 'template_param';
    # $MT::CallbackAlias{'AppTemplateOutput'}   = 'template_output';
    my @names = qw(
        CMSSavePermissionFilter_notification CMSSaveFilter_notification
        CMSSavePermissionFilter_banlist CMSSaveFilter_banlist
        CMSViewPermissionFilter_author CMSSavePermissionFilter_author
        CMSDeletePermissionFilter_author CMSSaveFilter_author
        CMSPreSave_author CMSPostSave_author CMSViewPermissionFilter_blog
        CMSSavePermissionFilter_blog CMSDeletePermissionFilter_blog
        CMSPreSave_blog CMSPostSave_blog CMSSaveFilter_blog CMSPostDelete_blog
        CMSViewPermissionFilter_category CMSSavePermissionFilter_category
        CMSDeletePermissionFilter_category CMSPreSave_category
        CMSPostSave_category CMSSaveFilter_category
        CMSViewPermissionFilter_comment CMSSavePermissionFilter_comment
        CMSDeletePermissionFilter_comment CMSPreSave_comment
        CMSPostSave_comment CMSViewPermissionFilter_commenter
        CMSDeletePermissionFilter_commenter CMSViewPermissionFilter_entry
        CMSDeletePermissionFilter_entry CMSPreSave_entry
        CMSViewPermissionFilter_ping CMSSavePermissionFilter_ping
        CMSDeletePermissionFilter_ping CMSPreSave_ping CMSPostSave_ping
        CMSViewPermissionFilter_template CMSSavePermissionFilter_template
        CMSDeletePermissionFilter_template CMSPreSave_template
        CMSPostSave_template
        CMSPostDelete_notification CMSPostDelete_author CMSPostDelete_category
        CMSPostDelete_comment CMSPostDelete_entry CMSPostDelete_ping
        CMSPostDelete_template CMSPostDelete_tag
        CMSPostSave_asset CMSPostDelete_asset
    );
    $MT::CallbackAlias{'AppPostEntrySave'}  = 'cms_post_save.entry';
    $MT::CallbackAlias{'CMSPostSave.entry'} = 'cms_post_save.entry';
    $MT::CallbackAlias{'CMSPostEntrySave'}  = 'cms_post_save.entry';
    $MT::CallbackAlias{'CMSPostEntrySave'}  = 'cms_post_save.entry';
    $MT::CallbackAlias{'CMSPreSave'}        = 'cms_pre_save';
    $MT::CallbackAlias{'CMSPostSave'}       = 'cms_post_save';
    $MT::CallbackAlias{'CMSSavePermissionFilter'}
        = 'cms_save_permission_filter';
    $MT::CallbackAlias{'CMSDeletePermissionFilter'}
        = 'cms_delete_permission_filter';
    $MT::CallbackAlias{'CMSViewPermissionFilter'}
        = 'cms_view_permission_filter';
    $MT::CallbackAlias{'CMSPostDelete'}  = 'cms_post_delete';
    $MT::CallbackAlias{'CMSUploadFile'}  = 'cms_upload_file';
    $MT::CallbackAlias{'CMSUploadImage'} = 'cms_upload_image';
    $MT::CallbackAlias{'HandleJunk'}     = 'handle_spam';
    $MT::CallbackAlias{'HandleNotJunk'}  = 'handle_ham';

    $MT::CallbackAlias{'APIPreSave.entry'}  = 'api_pre_save.entry';
    $MT::CallbackAlias{'APIPostSave.entry'} = 'api_post_save.entry';
    $MT::CallbackAlias{'APIUploadFile'}     = 'api_upload_file';
    $MT::CallbackAlias{'APIUploadImage'}    = 'api_upload_image';

    for (@names) {
        my $x = $_;
        $x =~ s/_/./;
        my $y = lc $x;
        $y =~ s/^cms//;
        $y =~ s/(delete|view|pre|post|permission|save)(?=[a-z])/$1_/g;
        $y = 'MT::App::CMS::' . $y;
        $MT::CallbackAlias{$_} = $MT::CallbackAlias{$x} = $y;
    }
}

# in case multiple MT::Compat::* modules are loaded, all of which contain
# this warn routine:
no warnings 'redefine';

# Module for holding deprecated API elements. If elements in this module
# are used, a warning is issued to alert the user or developer that they
# are using older APIs that will eventually be removed.

sub warn {
    my @c  = caller(1);
    my @c2 = caller(2);
    my $r  = $MT::plugin_registry;
    $r->{compat_errors} ||= [];
    $r->{compat_flag}   ||= {};
    if ( !exists $r->{compat_flag}{ $c[3] } ) {
        $r->{compat_flag}{ $c[3] } = 1;
        my $new = $api_map{ $c[3] };
        if ($new) {
            push @{ $r->{compat_errors} }, sub {
                MT->translate( "uses: [_1], should use: [_2]", $c[3], $new );
            };
        }
        else {
            push @{ $r->{compat_errors} },
                sub { MT->translate( "uses [_1]", $c[3] ); };
        }
    }

# warn "A deprecated MT 3.x API routine ($c[3]) has been called from $c2[3], line $c2[2].";
}

package MT;

use strict;

sub add_log_class {
    MT::Compat::warn();
    my $mt = shift;
    my ( $ident, $class ) = @_;
    my $r = $MT::plugin_registry;
    $r = $r->{object_types} ||= {};
    $r->{ 'log.' . $ident } = $class;
}

sub register_junk_filter {
    MT::Compat::warn();
    my $class = shift;
    my ($filter) = @_;
    if ( !( ref $filter eq 'ARRAY' ) ) {
        $filter = [$filter];
    }
    my $r = $MT::plugin_registry;
    $r = $r->{junk_filters} ||= {};
    foreach my $f (@$filter) {
        $f->{label} ||= $f->{name};
        $r->{ $f->{name} } = $f;
    }
}

sub add_text_filter {
    MT::Compat::warn();
    my $mt = shift;
    my ( $key, $cfg ) = @_;
    my $r = $MT::plugin_registry;
    $r->{text_filters} ||= {};
    $cfg->{label}      ||= $key;
    $cfg->{code}       ||= $cfg->{on_format};
    return $mt->trans_error("No executable code") unless $cfg->{code};
    $r->{text_filters}{$key} = $cfg;
}

sub add_task {
    MT::Compat::warn();
    my $mt     = shift;
    my ($task) = @_;
    my $r      = $MT::plugin_registry;
    $r->{tasks} ||= {};
    my $key;
    if ( ref $task eq 'HASH' ) {
        $key = $task->{key};
    }
    elsif ( ref($task) && UNIVERSAL::isa( $task, 'MT::Task' ) ) {
        $key = $task->key;
    }
    if ( !$key ) {
        die "Tasks cannot be registered without a key.";
    }
    $r->{tasks}{$key} = $task;
}

sub add_plugin_action {
    MT::Compat::warn();
    my $class = shift;
    if ( !ref $class ) {
        my ( $page_id, $cgi, $label ) = @_;
        my $mt = MT->instance;
        if ( $mt->can('id') ) {
            my $app_id = $mt->id;
            my $r      = $MT::plugin_registry;
            require MT::Util;
            my $key = MT::Util::dirify( $MT::plugin_sig . '_' . $page_id );
            $r->{applications}{$app_id}{page_actions}{$page_id}{$key} = {
                label => $label,
                key   => $key,
                link  => $cgi,
            };
        }
    }
}

sub add_itemset_action {
    MT::Compat::warn();
    my $app = shift;
    my ($itemset_action) = @_;
    $app = MT->instance unless ref $app;
    my $r = $MT::plugin_registry;
    if ( $app->can('id') ) {
        my $app_id = $app->id;
        my $type   = $itemset_action->{type};
        Carp::croak 'itemset actions require a string called "key"'
            unless ( $itemset_action->{key}
            && !( ref( $itemset_action->{key} ) ) );
        Carp::croak 'itemset actions require a coderef called "code"'
            unless ( $itemset_action->{code}
            && ( ref $itemset_action->{code} eq 'CODE' ) );
        Carp::croak 'itemset actions require a string called "label"'
            unless ( $itemset_action->{label}
            && !( ref $itemset_action->{label} ) );
        $r->{applications}{$app_id}{list_actions}{$type}
            { $itemset_action->{key} } = $itemset_action;
    }
}

package MT::Template::Context;

sub add_tag {
    MT::Compat::warn();
    my $class = shift;
    my ( $name, $code ) = @_;
    my $r = $MT::plugin_registry;
    $r->{tags} ||= {};
    $r->{tags}{function}{$name} = $code;
}

sub add_container_tag {
    MT::Compat::warn();
    my $class = shift;
    my ( $name, $code ) = @_;
    my $r = $MT::plugin_registry;
    $r->{tags} ||= {};
    $r->{tags}{block}{$name} = $code;
}

sub add_conditional_tag {
    MT::Compat::warn();
    my $class = shift;
    my ( $name, $condition ) = @_;
    my $r = $MT::plugin_registry;
    $r->{tags} ||= {};
    $r->{tags}{block}{ $name . '?' } = $condition;
}

sub add_global_filter {
    MT::Compat::warn();
    my $class = shift;
    my ( $name, $code ) = @_;
    my $r = $MT::plugin_registry;
    $r->{tags} ||= {};
    $r->{tags}{modifier}{$name} = $code;
}

sub register_handler {
    MT::Compat::warn();
    my ( $pkg, $tag, $handler );
    my $r = $MT::plugin_registry;
    $r->{tags} ||= {};
    if ( ref $handler eq 'ARRAY' ) {
        if ( $handler->[1] ) {
            return $r->{tags}{block}{$tag} = $handler->[0];
        }
        else {
            return $r->{tags}{function}{$tag} = $handler->[0];
        }
    }
    return $r->{tags}{function}{$tag} = $handler;
}

package MT::TaskMgr;

*add_task = \&MT::add_task;

package MT::App;

use strict;

# Short-lived templating API that is unsupported in MT 4
sub tmpl_prepend { }
sub tmpl_replace { }
sub tmpl_append  { }
sub tmpl_select  { }

*plugin_actions = \&page_actions;

sub add_methods {
    my $app   = shift;
    my %meths = @_;
    if ( ref($app) ) {
        my $vtbl;
        if ( my $r = $MT::plugin_registry ) {
            $vtbl = $r->{applications}{ $app->id }{methods} ||= {};
        }
        else {
            $vtbl = $app->{vtbl} ||= {};
        }
        for my $meth ( keys %meths ) {
            $vtbl->{$meth} = $meths{$meth};
        }
    }
    else {
        for my $meth ( keys %meths ) {
            $MT::App::Global_actions{$app}{$meth} = $meths{$meth};
        }
    }
}

sub add_plugin_action {
    MT::Compat::warn();

    my $app = shift;

    my ( $object_type, $action_link, $link_text ) = @_;
    my $plugin_envelope = $MT::plugin_envelope;
    my $plugin_sig      = $MT::plugin_sig;
    unless ($plugin_envelope) {
        warn
            "MT->add_plugin_action improperly called outside of MT plugin load loop.";
        return;
    }
    $action_link .= '?' unless $action_link =~ m.\?.;
    push @{ $MT::Plugins{$plugin_sig}{actions} }, "$object_type Action"
        if $plugin_sig;
    my $page = $app->config->AdminCGIPath || $app->config->CGIPath;
    $page .= '/' unless $page =~ m!/$!;
    $page .= $plugin_envelope . '/' if $plugin_envelope;
    $page .= $action_link;
    my $has_params = ( $page =~ m/\?/ )
        && ( $page !~ m!(&|;|\?)$! );
    my $param = {
        page            => $page,
        page_has_params => $has_params,
        link_text       => $link_text,
        orig_link_text  => $link_text,
        plugin          => $plugin_sig
    };
    $app->{plugin_actions} ||= {};
    push @{ $app->{plugin_actions}{$object_type} }, $param;
}

package MT::Upgrade;

sub register_class {
    MT::Compat::warn();
    my $pkg = shift;
    my ( $name, $param ) = @_;
    my @classes = ref $name eq 'ARRAY' ? @$name : ( [ $name, $param ] );
    foreach (@classes) {
        if ( ref $_ eq 'ARRAY' ) {
            $MT::Upgrade::classes{ $_[0] } = $_[1];
        }
        else {
            $MT::Upgrade::classes{$_} = 1;
        }
    }
}

sub register_upgrade_function {
    MT::Compat::warn();
    my $pkg = shift;
    my ( $name, $param ) = @_;
    if ( ref $name eq 'HASH' ) {
        foreach ( keys %$name ) {
            $MT::Upgrade::functions{$_} = $name->{$_};
            $MT::Upgrade::functions{$_}->{priority} ||= 9.5;
        }
    }
    else {
        my @fns = ref $name eq 'ARRAY' ? @$name : ( [ $name, $param ] );
        $MT::Upgrade::functions{ $_[0] } = $_[1] foreach @fns;
    }
}

package MT::App::CMS;

use strict;

sub register_type {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.8');
}

sub add_rebuild_option {
    MT::Compat::warn();
    my $class  = shift;
    my $app    = $class->instance;
    my ($args) = @_;
    $args->{label} ||= $args->{Name} || $args->{name};
    return $class->error(
        MT->translate(
            "Publish-option name must not contain special characters")
        )
        if ( $args->{label} )
        =~ /[\"\']/;    #/[^A-Za-z0-9.:\[\]\(\)\+=!@\#\$\%\^\&\*-]/;
    my $rec = {};
    $rec->{code}  = $args->{Code} || $args->{code};
    $rec->{label} = $args->{label};
    $rec->{key}   = $args->{key} || dirify( $rec->{label} );
    $app->{rebuild_options} ||= [];
    push @{ $app->{rebuild_options} }, $rec;
}

*core_itemset_actions   = \&core_list_actions;
*plugin_itemset_actions = \&plugin_list_actions;

#*itemset_actions        = \&list_actions;

while ( my ( $module, $methods ) = each %cms_map ) {
    for my $method (@$methods) {
        my $shim = sub {
            MT::Compat::warn();
            my $h = MT->handler_to_coderef( join q{::}, '$Core::MT::CMS',
                $module, $method );
            return $h->(@_);
        };

        no strict 'refs';
        *{$method} = $shim;
    }
}

while ( my ( $method, $new_method ) = each %cms_rename_map ) {
    my $shim = sub {
        MT::Compat::warn();
        my $h = MT->handler_to_coderef( join q{::}, '$Core::MT::CMS',
            $new_method );
        return $h->(@_);
    };

    no strict 'refs';
    *{$method} = $shim;
}

package MT::Author;

use strict;

sub session {
    MT::Compat::warn();
    die "MT::Author::session was removed";
}

sub magic_token {
    MT::Compat::warn();
    die "MT::Author::magic_token was removed";
}

package MT::Plugin;

use strict;

sub legacy_init {
    my $plugin = shift;

    # Change location of app_action_links from
    #   app_action_links -> app package -> stuff
    # to
    #   applications -> app id -> page_actions -> stuff
    if (my $actions = delete $plugin->{app_action_links}
        || (  $plugin->can('app_action_links')
            ? $plugin->app_action_links
            : undef
        )
        )
    {
        my $r = $MT::plugin_registry;
        $r = $r->{applications} ||= {};
        foreach my $app ( keys %$actions ) {
            my $app_id = $MT::Compat::app_ids{$app} or next;
            my $app_actions = $actions->{$app};
            if ( ref($app_actions) eq 'ARRAY' ) {
                foreach my $action (@$app_actions) {
                    my $type = $action->{type} or next;
                    my $key  = $action->{key}  or next;
                    $r->{$app_id}{page_actions}{$type}{$key} = $action;
                }
            }
            elsif ( ref($app_actions) eq 'HASH' ) {

                # app_action_links -> MT::App::CMS -> type -> stuff
                my $i = 0;
                foreach my $type (%$app_actions) {
                    $i++;
                    my $key = MT::Util::dirify(
                        $MT::plugin_sig . '_' . $type + $i );
                    $r->{$app_id}{page_actions}{$type}{$key}
                        = $app_actions->{$type};
                }
            }
        }
    }

    # Change location of app_itemset_actions from
    #   app_itemset_actions -> app package -> stuff
    # to
    #   applications -> app id -> list_actions -> stuff
    if (my $actions = delete $plugin->{app_itemset_actions}
        || (  $plugin->can('app_itemset_actions')
            ? $plugin->app_itemset_actions
            : undef
        )
        )
    {
        my $r = $MT::plugin_registry;
        $r = $r->{applications} ||= {};
        foreach my $app ( keys %$actions ) {
            my $app_id = $MT::Compat::app_ids{$app} or next;
            my $app_actions = $actions->{$app};
            if ( ref($app_actions) eq 'ARRAY' ) {
                foreach my $action (@$app_actions) {
                    my $type = $action->{type} or next;
                    my $key  = $action->{key}  or next;
                    $r->{$app_id}{list_actions}{$type}{$key} = $action;
                }
            }
            elsif ( ref($app_actions) eq 'HASH' ) {

                # app_action_links -> MT::App::CMS -> type -> stuff
                foreach my $type (%$app_actions) {
                    my $key = $app_actions->{$type}{key} or next;
                    $r->{$app_id}{list_actions}{$type}{$key}
                        = $app_actions->{$type};
                }
            }
        }
    }

    # Remap app_methods -> app pkg -> method hash
    # to applications -> app id -> method hash
    if ( my $methods = delete $plugin->{app_methods}
        || ( $plugin->can('app_methods') ? $plugin->app_methods : undef ) )
    {
        my $r = $MT::plugin_registry;
        $r = $r->{applications} ||= {};
        foreach my $app ( keys %$methods ) {
            my $app_id = $MT::Compat::app_ids{$app} or next;
            my $app_methods = $methods->{$app};
            if ( ref($app_methods) eq 'HASH' ) {
                foreach my $m ( keys %$app_methods ) {
                    $r->{$app_id}{methods}{$m}
                        = { code => $app_methods->{$m} };
                }
            }
        }
    }

    # Store upgrade_functions in the plugin registry.
    if (my $functions = delete $plugin->{upgrade_functions}
        || (  $plugin->can('upgrade_functions')
            ? $plugin->upgrade_functions
            : undef
        )
        )
    {
        my $r = $MT::plugin_registry;
        $r = $r->{upgrade_functions} ||= {};
        foreach my $fn ( keys %$functions ) {
            $r->{$fn} = $functions->{$fn};
        }
    }

    # Store object_classes in the plugin registry as a hash
    # with the key 'object_types'.
    if ( my $classes = delete $plugin->{object_classes}
        || ($plugin->can('object_classes') ? $plugin->object_classes : undef )
        )
    {
        my $r = $MT::plugin_registry;
        $r = $r->{object_types} ||= {};
        foreach my $class (@$classes) {
            $r->{$class} = $class;
        }
    }

    # Store junk_filters in the plugin registry as a hash
    # with the key 'junk_filters'.
    if ( my $filters = delete $plugin->{junk_filters}
        || ( $plugin->can('junk_filters') ? $plugin->junk_filters : undef ) )
    {
        my $r = $MT::plugin_registry;
        $r = $r->{junk_filters} || {};
        foreach my $f ( keys %$filters ) {
            $r->{$f} = $filters->{$f};
        }
    }
}

1;
