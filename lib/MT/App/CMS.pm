# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::CMS;

use strict;
use base qw( MT::App );

use Symbol;
use File::Spec;
use MT::Util qw( encode_html format_ts offset_time_list offset_time epoch2ts
  remove_html get_entry mark_odd_rows first_n_words
  perl_sha1_digest_hex is_valid_email relative_date ts2epoch
  perl_sha1_digest encode_url dirify encode_js is_valid_date
  archive_file_for is_url );
use MT::I18N qw( substr_text const length_text wrap_text encode_text
  break_up_text first_n_text guess_encoding );
use CGI;

use constant LISTING_DATE_FORMAT      => '%b %e, %Y';
use constant LISTING_DATETIME_FORMAT  => '%b %e, %Y';
use constant LISTING_TIMESTAMP_FORMAT => "%Y-%m-%d %I:%M:%S%p";

sub id { 'cms' }

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->{state_params} = [
        '_type',  'id',         'tab',     'offset',
        'filter', 'filter_val', 'blog_id', 'is_power_edit',
        'filter_key'
    ];
    $app->{template_dir}         = 'cms';
    $app->{plugin_template_path} = '';
    $app->{is_admin}             = 1;
    $app->{default_mode}         = 'dashboard';
    $app;
}

sub core_methods {
    my $app = shift;
    return {
        'tools'     => \&tools,
        'dashboard' => \&dashboard,
        'menu'      => \&dashboard,
        'admin'     => \&dashboard,

        ## Generic handlers
        'save'           => \&save_object,
        'edit'           => \&edit_object,
        'view'           => \&edit_object,
        'list'           => \&list_objects,
        'delete'         => \&delete,
        'search_replace' => \&search_replace,

        ## Edit methods
        'edit_role' => \&edit_role,

        ## Listing methods
        'list_ping'     => \&list_pings,
        'list_entry'    => \&list_entries,
        'list_template' => \&list_template,
        'list_page'     => \&list_pages,
        'list_comment'  => {
            handler    => \&list_comments,
            permission => 'view_feedback',
        },
        'list_member'      => \&list_member,
        'list_user'        => \&list_authors,
        'list_author'      => \&list_authors,
        'list_commenter'   => \&list_commenter,
        'list_asset'       => \&list_assets,
        'list_blog'        => \&list_blogs,
        'list_category'    => \&list_category,
        'list_tag'         => \&list_tag,
        'list_association' => \&list_associations,
        'list_role'        => \&list_roles,

        'asset_insert'        => \&asset_insert,
        'asset_userpic'       => \&asset_userpic,
        'save_commenter_perm' => \&save_commenter_perm,
        'trust_commenter'     => \&trust_commenter,
        'ban_commenter'       => \&ban_commenter,
        'approve_item'        => \&approve_item,
        'unapprove_item'      => \&unapprove_item,
        'preview_entry'       => \&preview_entry,

        ## Blog configuration screens
        'cfg_archives'     => \&cfg_archives,
        'cfg_prefs'        => \&cfg_prefs,
        'cfg_plugins'      => \&cfg_plugins,
        'cfg_comments'     => \&cfg_comments,
        'cfg_trackbacks'   => \&cfg_trackbacks,
        'cfg_registration' => \&cfg_registration,
        'cfg_spam'         => \&cfg_spam,
        'cfg_entry'        => \&cfg_entry,
        'cfg_web_services' => \&cfg_web_services,

        ## Save
        'save_cat'     => \&save_category,
        'save_entries' => \&save_entries,
        'save_pages'   => \&save_pages,
        'save_entry'   => \&save_entry,
        'save_role'    => \&save_role,

        ## List actions
        'enable_object'  => \&enable_object,
        'disable_object' => \&disable_object,
        'list_action'    => \&do_list_action,
        'empty_junk'     => \&empty_junk,
        'handle_junk'    => \&handle_junk,
        'not_junk'       => \&not_junk,

        'ping'               => \&send_pings,
        'rebuild_phase'      => \&rebuild_phase,
        'rebuild'            => \&rebuild_pages,
        'rebuild_new_phase'  => \&rebuild_new_phase,
        'start_rebuild'      => \&start_rebuild_pages,
        'rebuild_confirm'    => \&rebuild_confirm,
        'entry_notify'       => \&entry_notify,
        'send_notify'        => \&send_notify,
        'start_upload'       => \&start_upload,
        'upload_file'        => \&upload_file,
        'upload_userpic'     => \&upload_userpic,
        'complete_insert'    => \&complete_insert,
        'complete_upload'    => \&complete_upload,
        'start_upload_entry' => \&start_upload_entry,
        'logout'             => {
            code           => \&logout,
            requires_login => 0,
        },
        'start_recover' => {
            code           => \&start_recover,
            requires_login => 0,
        },
        'recover' => {
            code           => \&recover_password,
            requires_login => 0,
        },

        'view_log'            => \&view_log,
        'list_log'            => \&view_log,
        'reset_log'           => \&reset_log,
        'export_log'          => \&export_log,
        'export_notification' => \&export_notification,
        'start_import'        => \&start_import,
        'start_export'        => \&start_export,
        'export'              => \&export,
        'import'              => \&do_import,
        'pinged_urls'         => \&pinged_urls,
        'save_entry_prefs'    => \&save_entry_prefs,
        'save_favorite_blogs' => \&save_favorite_blogs,
        'reg_file'            => \&reg_file,
        'reg_bm_js'           => {
            code           => \&reg_bm_js,
            requires_login => 0,
        },
        'folder_add'               => \&category_add,
        'category_add'             => \&category_add,
        'category_do_add'          => \&category_do_add,
        'cc_return'                => \&cc_return,
        'reset_blog_templates'     => \&reset_blog_templates,
        'handshake'                => \&handshake,
        'itemset_action'           => \&do_list_action,
        'page_action'              => \&do_page_action,
        'cfg_system'               => \&cfg_system_general,
        'cfg_system_users'         => \&cfg_system_users,
        'cfg_system_feedback'      => \&cfg_system_feedback,
        'save_plugin_config'       => \&save_plugin_config,
        'reset_plugin_config'      => \&reset_plugin_config,
        'save_cfg_system_feedback' => \&save_cfg_system_feedback,
        'save_cfg_system_general'  => \&save_cfg_system_general,
        'save_cfg_system_users'    => \&save_cfg_system_users,
        'update_welcome_message'   => \&update_welcome_message,
        'upgrade'                  => {
            code           => \&upgrade,
            requires_login => 0,
        },
        'plugin_control'           => \&plugin_control,
        'recover_profile_password' => \&recover_profile_password,
        'rename_tag'               => \&rename_tag,
        'remove_user_assoc'        => \&remove_user_assoc,
        'revoke_role'              => \&revoke_role,
        'grant_role'               => \&grant_role,
        'start_backup'             => \&start_backup,
        'start_restore'            => \&start_restore,
        'backup'                   => \&backup,
        'backup_download'          => \&backup_download,
        'restore'                  => \&restore,
        'restore_premature_cancel' => \&restore_premature_cancel,
        'adjust_sitepath'          => \&adjust_sitepath,
        'system_check'             => \&system_check,
        'dialog_refresh_templates' => \&dialog_refresh_templates,
        'refresh_all_templates'    => \&refresh_all_templates,

        ## Comment Replies
        reply         => \&reply,
        do_reply      => \&do_reply,
        reply_preview => \&reply_preview,

        ## Dialogs
        'dialog_restore_upload'  => \&dialog_restore_upload,
        'dialog_adjust_sitepath' => \&dialog_adjust_sitepath,
        'dialog_post_comment'    => \&dialog_post_comment,
        'dialog_select_weblog'   => \&dialog_select_weblog,
        'dialog_select_sysadmin' => \&dialog_select_sysadmin,
        'dialog_grant_role'      => \&dialog_grant_role,

        ## AJAX handlers
        'delete_map'        => \&delete_map,
        'add_map'           => \&add_map,
        'js_tag_check'      => \&js_tag_check,
        'js_tag_list'       => \&js_tag_list,
        'convert_to_html'   => \&convert_to_html,
        'update_list_prefs' => \&update_list_prefs,
        'js_add_category'   => \&js_add_category,
        'remove_userpic'    => \&remove_userpic,

        # declared in MT::App
        'update_widget_prefs' => sub { return shift->update_widget_prefs(@_) },

        'js_recent_entries_for_tag' => \&js_recent_entries_for_tag,

        ## DEPRECATED ##
        'list_pings'    => \&list_pings,
        'list_entries'  => \&list_entries,
        'list_pages'    => \&list_pages,
        'list_comments' => {
            handler    => \&list_comments,
            permission => 'view_feedback',
        },
        'list_authors'      => \&list_authors,
        'list_assets'       => \&list_assets,
        'list_cat'          => \&list_category,
        'list_blogs'        => \&list_blogs,
        'list_associations' => \&list_associations,
        'list_roles'        => \&list_roles,
    };
}

sub core_widgets {
    my $app = shift;
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
            handler  => \&new_version_widget,
        },
        this_is_you => {
            label    => 'This is You',
            template => 'widget/this_is_you.tmpl',
            handler  => \&this_is_you_widget,
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
            handler  => \&mt_news_widget,
            singular => 1,
            set      => 'sidebar',
        },
        blog_stats => {
            label    => 'Blog Stats',
            template => 'widget/blog_stats.tmpl',
            handler  => \&mt_blog_stats_widget,
            singular => 1,
            set      => 'main',
        },
    };
}

sub core_blog_stats_tabs {
    my $app = shift;
    return {
        entry => {
            label    => 'Entries',
            template => 'widget/blog_stats_entry.tmpl',
            handler  => \&mt_blog_stats_widget_entry_tab,
            stats    => \&generate_dashboard_stats_entry_tab,
        },
        comment => {
            label    => 'Comments',
            template => 'widget/blog_stats_comment.tmpl',
            handler  => \&mt_blog_stats_widget_comment_tab,
            stats    => \&generate_dashboard_stats_comment_tab,
        },
        tag_cloud => {
            label    => 'Tag Cloud',
            template => 'widget/blog_stats_tag_cloud.tmpl',
        },
    };
}

sub core_page_actions {
    return {
        list_templates => {
            refresh_all_blog_templates => {
                label => "Refresh Blog Templates",
                dialog => 'dialog_refresh_templates',
                condition => sub {
                    MT->app->blog,
                },
                order => 1000,
            },
            refresh_global_templates => {
                label => "Refresh Global Templates",
                code => sub {
                    MT->app->refresh_all_templates(@_);
                },
                condition => sub {
                    ! MT->app->blog,
                },
                order => 1000,
                continue_prompt => MT->translate('This action will restore your global templates to factory settings without creating a backup. Click OK to continue or Cancel to abort.'),
            },
        },
    };
}
sub js_recent_entries_for_tag {
    my $app          = shift;
    my $user         = $app->user or return;
    my $tag_class    = $app->model('tag') or return;
    my $objtag_class = $app->model('objecttag') or return;
    my $limit        = $app->param('limit') || 10;
    my $obj_ds       = $app->param('_type') || 'entry';
    my $blog_id      = $app->param('blog_id');
    my $obj_class    = $app->model($obj_ds) or return;
    my $tag_name     = $app->param('tag') or return;
    if ( 'utf-8' ne lc( $app->config->PublishCharset) ) {
        $tag_name = MT::I18N::encode_text( $tag_name, 'utf-8', $app->config->PublishCharset );
    }
    my $tag_obj =
      $tag_class->load( { name => $tag_name }, { binary => { name => 1 } } );

    if ( !$tag_obj ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }
    my $tag_id = $tag_obj->id;

    my @entries = $obj_class->load(
        {
            ( $blog_id ? ( blog_id => $blog_id ) : () ),
            status => MT::Entry::RELEASE(),
        },
        {
            sort      => 'authored_on',
            direction => 'descend',
            limit     => $limit,
            join      => $objtag_class->join_on(
                'object_id',
                {
                    ( $blog_id ? ( blog_id => $blog_id ) : () ),
                    tag_id            => $tag_id,
                    object_datasource => $obj_ds,
                }
            ),
        }
    );
    my $count =
      $obj_class->tagged_count( $tag_id,
        { ( $blog_id ? ( blog_id => $blog_id ) : () ) } );
    require MT::Template;
    require MT::Blog;
    my $tmpl = $app->load_tmpl('widget/blog_stats_recent_entries.tmpl');
    my $ctx  = $tmpl->context;
    $ctx->stash( 'blog', MT::Blog->load($blog_id) ) if $blog_id;
    $ctx->stash( 'entries', \@entries );
    $tmpl->param( 'entry_count', scalar @entries );
    $tmpl->param( 'script_url', $app->uri );
    $tmpl->param( 'tag',        $tag_name );
    $tmpl->param( 'blog_id',    $blog_id ) if $blog_id;
    my $editable = $app->user->is_superuser;
    if ( $blog_id && !$editable ) {
        $editable = $user->permissions($blog_id)->can_edit_all_posts;
    }
    $tmpl->param('editable',    $editable);
    my $html = $app->build_page( $tmpl );
    return $app->json_result( { html => $html } );
}

sub js_add_category {
    my $app = shift;
    unless ( $app->validate_magic ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    my $perms   = $app->permissions;
    my $type    = $app->param('_type') || 'category';
    my $class   = $app->model($type);
    if ( !$class ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }

    my $label = $app->param('label');
    my $enc   = $app->config->PublishCharset;

    # XMLHttpRequest always send text in UTF-8... right?
    if ( 'utf-8' ne lc($enc) ) {
        $label = MT::I18N::encode_text( $label, 'utf-8', $enc );
    }
    my $basename = $app->param('basename');
    if ( !defined($label) || ( $label =~ m/^\s*$/ ) ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }

    my $blog = $app->blog;
    if ( !$blog ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }

    my $parent;
    if ( my $parent_id = $app->param('parent') ) {
        if ( $parent_id != -1 ) {    # special case for 'root' folder
            $parent = $class->load( { id => $parent_id, blog_id => $blog_id } );
            if ( !$parent ) {
                return $app->json_error( $app->translate("Invalid request.") );
            }
        }
    }

    my $obj      = $class->new;
    my $original = $obj->clone;

    if (
        !$app->run_callbacks(
            'cms_save_permission.' . $type,
            $app, $obj, $original
        )
      )
    {
        return $app->json_error( $app->translate("Permission denied.") );
    }

    $obj->label($label);
    $obj->basename($basename)   if $basename;
    $obj->parent( $parent->id ) if $parent;
    $obj->blog_id($blog_id);
    $obj->author_id( $user->id );
    $obj->created_by( $user->id );

    if (
        !$app->run_callbacks( 'cms_pre_save.' . $type, $app, $obj, $original ) )
    {
        return $app->json_error( $app->errstr );
    }

    $obj->save;

    $app->run_callbacks( 'cms_post_save.' . $type, $app, $obj, $original );

    return $app->json_result(
        {
            id       => $obj->id,
            basename => $obj->basename
        }
    );
}

sub convert_to_html {
    my $app    = shift;
    my $format = $app->param('format');
    my $text   = $app->param('text');
    # XMLHttpRequest always send text in UTF-8... right?
    if ( defined $text ) {
        $text = encode_text($text, 'utf-8', $app->config->PublishCharset);
    } 
    else {
        $text = '' ;
    }
    my $text_more = $app->param('text_more');
    if ( defined $text_more ) {
        $text_more = encode_text($text_more, 'utf-8', $app->config->PublishCharset);
    } 
    else {
        $text_more = '' ;
    }
    my $result = {
        text      => $app->apply_text_filters( $text,      [$format] ),
        text_more => $app->apply_text_filters( $text_more, [$format] ),
        format    => $format,
    };
    return $app->json_result($result);
}

sub tools {
    my $app = shift;
    $app->system_check;
}

sub system_check {
    my $app = shift;

    if ( my $blog_id = $app->param('blog_id') ) {
        return $app->redirect(
            $app->uri(
                'mode' => 'view_log',
                args => { blog_id => $blog_id }
            )
        );
    }

    my %param;
    # licensed user count: someone who has logged in within 90 days  
    my $sess_class = $app->model('session');  
    my $from = time - ( 60 * 60 * 24 * 90 + 60 * 60 * 24 );  
    $sess_class->remove(
        { kind => 'UA', start => [ undef, $from ] },  
        { range => { start => 1 } }
    );  
    $param{licensed_user_count} = $sess_class->count( { kind => 'UA' } );

    my $author_class = $app->model('author');
    $param{user_count} = $author_class->count(
        { type => MT::Author::AUTHOR() } );

    # commeters: users with only comment permission and MT::Author::COMMENTER
    my $cmntrs = $author_class->count(
        { type => MT::Author::COMMENTER() } );

    my @perms = $app->model('permission')->load(
      {
        permissions => "%'comment'%", 
        blog_id     => '0',
      },
      {
        'like' => { 'permissions' => 1 },
        'not'  => { 'blog_id'     => 1 },
      }
    );
    @perms = grep { $_->permissions =~ m/'comment'/ } @perms;
    $param{commenter_count} = scalar(@perms) + $cmntrs;
    $param{screen_id} = "system-check";
    $param{syscheck_html} = $app->get_syscheck_content() || '';
    
    $app->load_tmpl( 'system_check.tmpl', \%param );
}

sub get_syscheck_content {
    my $app = shift;

    my $syscheck_url = $app->base . $app->mt_path . $app->config('CheckScript') .
        '?view=tools&version=' . MT->version_id;
    if ( $syscheck_url && $syscheck_url ne 'disable' ) {
        my $SYSCHECKCACHE_TIMEOUT = 60 * 60 * 24;
        my $sess_class        = $app->model('session');
        my ($syscheck_object)     = ("");
        my $retries           = 0;
        $syscheck_object = $sess_class->load( { id => 'SC' } );
        if ( $syscheck_object
            && ( $syscheck_object->start() < ( time - $SYSCHECKCACHE_TIMEOUT ) ) )
        {
            $syscheck_object->remove;
            $syscheck_object = undef;
        }
        return encode_text( $syscheck_object->data(), 'utf-8', undef )
          if ($syscheck_object);

        my $ua = $app->new_ua({ timeout => 20 });
        return unless $ua;
        $ua->max_size(undef) if $ua->can('max_size');

        my $req = new HTTP::Request( GET => $syscheck_url );
        my $resp = $ua->request($req);
        return unless $resp->is_success();
        my $result = $resp->content();
        if ($result) {
            require MT::Sanitize;

            # allowed html
            my $spec = '* style class id,ul,li,div,span,br,h2,h3,strong,code,blockquote,p';
            $result = MT::Sanitize->sanitize( $result, $spec );
            $syscheck_object = MT::Session->new();
            $syscheck_object->set_values(
                {
                    id    => 'SC',
                    kind  => 'SC',
                    start => time(),
                    data  => $result
                }
            );
            $syscheck_object->save();
            $result = encode_text( $result, 'utf-8', undef );
        }
        return $result;
    }
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
      unless exists $app->{requires_login};    # by default, we require login

    my $mode = $app->mode;

    # Global 'blog_id' parameter check; if we get something
    # other than an integer, die
    if (my $blog_id = $app->param('blog_id')) {
        if ($blog_id ne int($blog_id)) {
            die $app->translate("Invalid request");
        }
    }

    unless (defined $app->{upgrade_required}) {
        $app->{upgrade_required} = 0;
        if (   ( $mode ne 'logout' )
            && ( $mode ne 'start_recover' )
            && ( $mode ne 'recover' )
            && ( $mode ne 'upgrade' ) )
        {
            my $schema  = $app->config('SchemaVersion');
            my $version = $app->config('MTVersion');
            if ( !$schema  || ( $schema  < $app->schema_version )
              || ( ( !$version || ( $version < $app->version_number ) ) 
                && $app->config->NotifyUpgrade ) ) {
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

    if ($app->{upgrade_required}) {
        $app->{requires_login} = 0;
        $app->mode('upgrade');
    }
}

sub core_list_actions {
    my $app = shift;
    return {
        'entry' => {
            'set_published' => {
                label      => "Publish Entries",
                order      => 100,
                code       => \&publish_entries,
                permission => 'edit_all_posts,publish_post',
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return $app->blog && $app->blog->site_path ? 1 : 0;
                  }
            },
            'set_draft' => {
                label      => "Unpublish Entries",
                order      => 200,
                code       => \&draft_entries,
                permission => 'edit_all_posts,publish_post',
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return $app->blog && $app->blog->site_path ? 1 : 0;
                  }
            },
            'add_tags' => {
                label       => "Add Tags...",
                order       => 300,
                code        => \&add_tags_to_entries,
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
                code        => \&remove_tags_from_entries,
                input       => 1,
                input_label => 'Tags to remove from selected entries',
                permission  => 'edit_all_posts',
                condition   => sub {
                    return $app->mode ne 'view';
                  }
            },
            'open_batch_editor' => {
                label     => "Batch Edit Entries",
                code      => \&open_batch_editor,
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
                code       => \&publish_entries,
                permission => 'manage_pages',
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return $app->blog && $app->blog->site_path ? 1 : 0;
                },
            },
            'set_draft' => {
                label      => "Unpublish Pages",
                order      => 200,
                code       => \&draft_entries,
                permission => 'manage_pages',
                condition  => sub {
                    return 0 if $app->mode eq 'view';
                    return $app->blog && $app->blog->site_path ? 1 : 0;
                },
            },
            'add_tags' => {
                label       => "Add Tags...",
                order       => 300,
                code        => \&add_tags_to_entries,
                input       => 1,
                input_label => 'Tags to add to selected pages',
                permission  => 'manage_pages',
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                },
            },
            'remove_tags' => {
                label       => "Remove Tags...",
                order       => 400,
                code        => \&remove_tags_from_entries,
                input       => 1,
                input_label => 'Tags to remove from selected pages',
                permission  => 'manage_pages',
                condition   => sub {
                    return 0 if $app->mode eq 'view';
                },
            },
            'open_batch_editor' => {
                label     => "Batch Edit Pages",
                code      => \&open_batch_editor,
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
                code        => \&add_tags_to_assets,
                input       => 1,
                input_label => 'Tags to add to selected assets',
                permission  => 'edit_assets',
            },
            'remove_tags' => {
                label       => "Remove Tags...",
                order       => 200,
                code        => \&remove_tags_from_assets,
                input       => 1,
                input_label => 'Tags to remove from selected assets',
                permission  => 'edit_assets',
            },
        },
        'ping' => {
            'unapprove_ping' => {
                label      => "Unpublish TrackBack(s)",
                order      => 100,
                code       => \&unapprove_item,
                permission => 'manage_feedback,publish_post',
            },
        },
        'comment' => {
            'unapprove_comment' => {
                label      => "Unpublish Comment(s)",
                order      => 100,
                code       => \&unapprove_item,
                permission => 'manage_feedback,publish_post',
                condition  => sub {
                    return 1;
                },
            },
            'trust_commenter' => {
                label      => "Trust Commenter(s)",
                order      => 200,
                code       => \&trust_commenter_by_comment,
                permission => 'manage_feedback',
            },
            'untrust_commenter' => {
                label      => "Untrust Commenter(s)",
                order      => 300,
                code       => \&untrust_commenter_by_comment,
                permission => 'manage_feedback',
            },
            'ban_commenter' => {
                label      => "Ban Commenter(s)",
                order      => 400,
                code       => \&ban_commenter_by_comment,
                permission => 'manage_feedback',
            },
            'unban_commenter' => {
                label      => "Unban Commenter(s)",
                order      => 500,
                code       => \&unban_commenter_by_comment,
                permission => 'manage_feedback',
            },
        },
        'commenter' => {
            'untrust' => {
                label      => "Untrust Commenter(s)",
                order      => 100,
                code       => \&untrust_commenter,
                permission => 'manage_feedback',
            },
            'unban' => {
                label      => "Unban Commenter(s)",
                order      => 200,
                code       => \&unban_commenter,
                permission => 'manage_feedback',
            },
        },
        'author' => {
            'recover_passwords' => {
                label => "Recover Password(s)",
                order => 100,
                continue_prompt =>
                  $app->translate("_WARNING_PASSWORD_RESET_MULTI"),
                code      => \&recover_passwords,
                condition => sub {
                    ( $app->user->is_superuser()
                          && MT::Auth->can_recover_password );
                },
            },
            'delete_user' => {
                label           => "Delete",
                order           => 200,
                continue_prompt => $app->config->ExternalUserManagement
                ? $app->translate("_WARNING_DELETE_USER_EUM")
                : $app->translate("_WARNING_DELETE_USER"),
                code      => \&delete,
                condition => sub {
                    $app->user->is_superuser();
                },
            },
        },
        'blog' => {
            refresh_blog_templates => {
                label => "Refresh Template(s)",
                code => sub {
                    my $app = MT->app;
                    $app->param('backup', 1);
                    $app->refresh_all_templates(@_)
                },
            },
        },
        'template' => {
            refresh_tmpl_templates => {
                label => "Refresh Template(s)",
                code => sub { MT->app->refresh_individual_templates(@_) },
                permission => 'edit_templates',
            },
            publish_index_templates => {
                label => "Publish Template(s)",
                code => sub { MT->app->publish_index_templates(@_) },
                permission => 'rebuild',
                condition => sub {
                    my $app = MT->app;
                    my $tmpl_type = $app->param('filter_key');
                    return $app->mode eq 'itemset_action'  ? 1
                         : !$app->blog                     ? 0
                         : !$tmpl_type                     ? 0
                         : $tmpl_type eq 'index_templates' ? 1
                         :                                   0
                         ;
                },
            },
        },
    };
}

sub _entry_label {
    my $app = MT->instance;
    my $type = $app->param('type') || 'entry';
    $app->model($type)->class_label_plural;
}

sub asset_list_filters {
    my $app = shift;

    my %filters;
    my $types = MT::Asset->class_labels;
    foreach my $type ( keys %$types ) {
        my $asset_type = $type;
        $asset_type =~ s/^asset\.//;
        $filters{$asset_type} = {
            label   => sub { MT::Asset->class_handler($type)->class_label_plural },
            handler => sub {
                my ( $terms, $args ) = @_;
                $terms->{class} = $asset_type eq 'asset' ? '*' : $asset_type;
            },
        };
    }
    my @types =
      sort { $filters{$a}{label} cmp $filters{$b}{label} } keys %filters;
    my $order = 100;
    foreach (@types) {
        $filters{$_}{order} = $order;
        $order += 100;
    }
    $filters{'asset'}{order} = 0;
    $filters{'asset'}{label} = "All Assets"; # labels are translated later
                                             # translate("All Assets");
    return \%filters;
}

sub core_list_filters {
    my $app = shift;
    return {
        asset => sub { $app->asset_list_filters(@_) },
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
                    $ts = MT::Util::epoch2ts( MT->app->blog, $ts );
                    $args->{join} = MT::Comment->join_on(
                        'entry_id',
                        {
                            created_on  => [ $ts, undef ],
                            junk_status => [ 0,   1 ]
                        },
                        { range_incl => { created_on => 1 }, unique => 1 }
                    );
                    # Since we're selecting content from the mt_entry
                    # table, but we want to sort by the joined
                    # 'comment_created_on' column, we have to specify the
                    # sort column as a reference and a full field name,
                    # to prevent MT from adding a 'entry_' prefix to
                    # the column name.
                    $args->{sort}      = \'comment_created_on';
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
                    $from = MT::Util::format_ts(
                        $format, $from . '000000',
                        undef,   MT->current_language
                    ) if $from;
                    $to = MT::Util::format_ts(
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
                        return $app->translate( "[_1] posted on or before [_2]",
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
                    $terms->{authored_on} =
                      [ MT::Object::ts2db($from), MT::Object::ts2db($to) ];
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
                    $terms->{junk_status} = [ 0, 1 ];
                },
            },
            my_posts => {
                label   => 'TrackBacks on my entries',
                order   => 200,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::Entry;
                    my $app = MT->instance;
                    $terms->{junk_status} = [ 0, 1 ];
                    require MT::Trackback;
                    $args->{join} = MT::Trackback->join_on(
                        undef,
                        {
                            id => \'= tbping_tb_id',
                        },
                        {
                            join => MT::Entry->join_on(
                                undef,
                                {
                                    id => \'= trackback_entry_id',
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
                    $terms->{junk_status} = [ 0, 1 ];
                    $terms->{visible} = 0;
                },
            },
            spam => {
                label   => 'TrackBacks marked as Spam',
                order   => 400,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    $terms->{junk_status} = -1;
                },
            },
            last_7_days => {
                label   => 'All TrackBacks in the last 7 days',
                order   => 700,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    my $ts = time - 7 * 24 * 60 * 60;
                    $ts = MT::Util::epoch2ts( MT->app->blog, $ts );
                    $terms->{created_on} = [ $ts, undef ];
                    $args->{range_incl}{created_on} = 1;
                    $terms->{junk_status} = [ 0, 1 ];
                },
            },
        },
        comment => {
            default => {
                label   => 'Non-spam Comments',
                order   => 100,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    $terms->{junk_status} = [ 0, 1 ];
                },
            },
            my_posts => {
                label   => 'Comments on my entries',
                order   => 200,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    require MT::Entry;
                    my $app = MT->instance;
                    $terms->{junk_status} = [ 0, 1 ];
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
                        {
                            id        => \'= comment_entry_id',
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
                    $terms->{junk_status} = [ 0, 1 ];
                    $terms->{visible} = 0;
                },
            },
            spam => {
                label   => 'Spam Comments',
                order   => 400,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    $terms->{junk_status} = -1;
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
            #            my_comments => {
            #                label   => 'My comments',
            #                order   => 600,
            #                handler => sub {
            #                    my ( $terms, $args ) = @_;
            #                    $terms->{commenter_id} = $app->user->id;
            #                },
            #            },
            last_7_days => {
                label   => 'Comments in the last 7 days',
                order   => 700,
                handler => sub {
                    my ( $terms, $args ) = @_;
                    my $ts = time - 7 * 24 * 60 * 60;
                    $ts = MT::Util::epoch2ts( MT->app->blog, $ts );
                    $terms->{created_on} = [ $ts, undef ];
                    $args->{range_incl}{created_on} = 1;
                    $terms->{junk_status} = [ 0, 1 ];
                },
            },
            #           last_24_hours => {
            #               label   => 'All comments in the last 24 hours',
            #               order   => 800,
            #               handler => sub {
            #                   my ( $terms, $args ) = @_;
            #                   my $ts = time - 24 * 60 * 60;
            #                   $ts = MT::Util::epoch2ts( MT->app->blog, $ts );
            #                   $terms->{created_on} = [ $ts, undef ];
            #                   $args->{range_incl}{created_on} = 1;
            #                   $terms->{junk_status} = [ 0, 1 ];
            #               },
            #           },
            _comments_by_user => {
                label => sub {
                    my $app     = MT->app;
                    my $user_id = $app->param('filter_val');
                    my $user    = MT::Author->load($user_id);
                    require MT::Author;
                    return $app->translate(
                        "All comments by [_1] '[_2]'",
                        (
                              $user->type == MT::Author::COMMENTER()
                            ? $app->translate("Commenter")
                            : $app->translate("Author")
                        ),
                        (
                              $user->nickname
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
                    my $entry_id = int( MT->app->param('filter_val') );
                    $terms->{entry_id} = $entry_id;
                    $terms->{junk_status} = [ 0, 1 ];
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
                    $from = MT::Util::format_ts(
                        $format, $from . '000000',
                        undef,   MT->current_language
                    ) if $from;
                    $to = MT::Util::format_ts(
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
                    my $val = $app->param('filter_val');
                    my ( $from, $to ) = split /-/, $val;
                    $from = undef unless $from =~ m/^\d{8}$/;
                    $from .= '000000';
                    $to = undef unless $to =~ m/^\d{8}$/;
                    $to .= '235959';
                    $terms->{junk_status} = [ 0, 1 ];
                    $terms->{created_on} =
                      [ MT::Object::ts2db($from), MT::Object::ts2db($to) ];
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
                    $terms->{type} =
                      [ 'individual', 'page', 'archive', 'category' ];
                },
                condition => sub {
                    $app->param('blog_id');
                },
            },
            module_templates => {
                label   => "Template Modules",
                order   => 300,
                handler => sub {
                    my ($terms) = @_;
                    $terms->{type} = 'custom';
                },
            },
            email_templates => {
                label   => "E-mail Templates",
                order   =>  400,
                handler => sub {
                    my ($terms) = @_;
                    $terms->{type} = 'email';
                },
                condition => sub {
                    !$app->param('blog_id');
                },
            },
            backup_templates => {
                label   => "Backup Templates",
                order   =>  10000,
                handler => sub {
                    my ($terms) = @_;
                    $terms->{type} = 'backup';
                },
            },
            system_templates => {
                label   => "System Templates",
                order   => 500,
                handler => sub {
                    my ($terms) = @_;
                    my $scope;
                    my $set;
                    if ( my $blog_id = $app->param('blog_id') ) {
                        my $blog  = $app->model('blog')->load($blog_id);
                        $set   = $blog->template_set;
                        $scope .= 'system';
                    }
                    else {
                        $terms->{blog_id} = 0;
                        $scope = 'global:system';
                    }
                    my @tmpl_path = ( $set && ($set ne 'mt_blog')) ? ("template_sets", $set, 'templates', $scope) : ("default_templates", $scope);
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
                label => 'Enabled Users',
                order => 100,
                handler => sub {
                    my ($terms) = @_;
                    $terms->{status} = 1;
                },
            },
            disabled => {
                label => "Disabled Users",
                order => 200,
                handler => sub {
                    my ($terms) = @_;
                    $terms->{status} = 2;
                },
            },
            pending => {
                label => "Pending Users",
                order => 300,
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
            label      => "Entries",
            mode       => 'list_entry',
            order      => 1000,
            condition  => sub {
                return 1 if $app->user->is_superuser;
                if ( $app->param('blog_id') ) {
                    my $perms = $app->user->permissions($app->param('blog_id'));
                    return 1 if $perms->can_create_post || $perms->can_publish_post || $perms->can_edit_all_posts;
                }
                else {
                    require MT::Permission;
                    my @blogs = 
                        map { $_->blog_id }
                          grep { $_->can_create_post || $_->can_pubish_post || $_->can_edit_all_posts }
                          MT::Permission->load( { author_id => $app->user->id } );
                    return 1 if @blogs;
                }
                return 0;
            },
            #permission => 'create_post,publish_post,edit_all_posts',
        },
        'manage:comment' => {
            label      => "Comments",
            mode       => 'list_comment',
            order      => 2000,
            condition  => sub {
                return 1 if $app->user->is_superuser;
                if ( $app->param('blog_id') ) {
                    my $perms = $app->user->permissions($app->param('blog_id'));
                    return 1 if $perms->can_create_post || $perms->can_manage_feedback || $perms->can_edit_all_posts || $perms->can_comment;
                }
                else {
                    require MT::Permission;
                    my @blogs = 
                        map { $_->blog_id }
                          grep { $_->can_create_post || $_->can_manage_feedback || $_->can_edit_all_posts || $_->can_comment }
                          MT::Permission->load( { author_id => $app->user->id } );
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

        'design:template' => {
            label         => "Templates",
            mode          => 'list',
            args          => { _type => 'template' },
            order         => 100,
            permission    => 'edit_templates',
            system_permission    => 'edit_templates',
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
        'prefs:plugins' => {
            label             => "Plugins",
            order             => 600,
            mode              => "cfg_plugins",
            permission        => "administer_blog",
            system_permission => "manage_plugins",
        },
        'prefs:settings' => {
            label             => "Blog Settings",
            mode              => 'cfg_prefs',
            order             => 100,
            permission        => 'administer_blog,edit_config,set_publish_paths',
            system_permission => 'administer',
            view              => "blog",
        },
        'prefs:notification' => {
            label      => "Address Book",
            mode       => 'list',
            args       => { _type => 'notification' },
            order      => 400,
            permission => 'edit_notifications',
            view       => "blog",
        },

        'tools:main' => {
            label => "System Information",
            order => 100,
            mode  => "tools",
            view  => "system",
        },
        'tools:activity_log' => {
            label             => "Activity Log",
            order             => 200,
            mode              => "view_log",
            permission        => "view_blog_log",
            system_permission => "view_log",
            view              => "system",
        },
        'tools:import' => {
            label      => "Import",
            order      => 300,
            mode       => "start_import",
            view       => "blog",
            permission => "administer_blog",
            view       => "system",
        },
        'tools:export' => {
            label      => "Export",
            order      => 400,
            mode       => "start_export",
            view       => "blog",
            permission => "administer_blog",
            view       => "system",
        },
        'tools:backup' => {
            label      => "Backup",
            order      => 500,
            mode       => "start_backup",
            permission => "administer_blog",
            view       => "system",
        },
        'tools:restore' => {
            label      => "Restore",
            order      => 600,
            mode       => "start_restore",
            permission => "administer_blog",
            view       => "system",
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
    $app->_register_core_callbacks(
        {
            # notification callbacks
            $pkg . 'save_permission_filter.notification' => sub {
                my ( $eh, $app, $id ) = @_;
                my $perms = $app->permissions;
                return $perms && $perms->can_edit_notifications;
            },
            $pkg . 'save_filter.notification' => \&CMSSaveFilter_notification,
            $pkg . 'post_delete.notification' => \&CMSPostDelete_notification,

            # banlist callbacks
            $pkg . 'save_permission_filter.banlist' => sub {
                my ( $eh, $app, $id ) = @_;
                my $perms = $app->permissions;
                return $perms
                  && ( $perms->can_edit_config || $perms->can_manage_feedback );
            },
            $pkg . 'save_filter.banlist' => \&CMSSaveFilter_banlist,

            # associations
            $pkg
              . 'delete_permission_filter.association' =>
              \&CMSDeletePermissionFilter_association,

            # user callbacks
            $pkg
              . 'view_permission_filter.author' =>
              \&CMSViewPermissionFilter_author,
            $pkg
              . 'save_permission_filter.author' =>
              \&CMSSavePermissionFilter_author,
            $pkg
              . 'delete_permission_filter.author' =>
              \&CMSDeletePermissionFilter_author,
            $pkg . 'save_filter.author' => \&CMSSaveFilter_author,
            $pkg . 'pre_save.author'    => \&CMSPreSave_author,
            $pkg . 'post_save.author'   => \&CMSPostSave_author,
            $pkg . 'post_delete.author' => \&CMSPostDelete_author,

            # blog callbacks
            $pkg
              . 'view_permission_filter.blog' => \&CMSViewPermissionFilter_blog,
            $pkg
              . 'save_permission_filter.blog' => \&CMSSavePermissionFilter_blog,
            $pkg
              . 'deletePermissionFilter.blog' =>
              \&CMSDeletePermissionFilter_blog,
            $pkg . 'pre_save.blog'    => \&CMSPreSave_blog,
            $pkg . 'post_save.blog'   => \&CMSPostSave_blog,
            $pkg . 'save_filter.blog' => \&CMSSaveFilter_blog,
            $pkg . 'post_delete.blog' => \&CMSPostDelete_blog,

            # folder callbacks
            $pkg
              . 'view_permission_filter.folder' =>
              \&CMSViewPermissionFilter_folder,
            $pkg
              . 'save_permission_filter.folder' =>
              \&CMSSavePermissionFilter_folder,
            $pkg
              . 'delete_permission_filter.category' =>
              \&CMSDeletePermissionFilter_folder,
            $pkg . 'pre_save.category'    => \&CMSPreSave_folder,
            $pkg . 'post_save.category'   => \&CMSPostSave_folder,
            $pkg . 'save_filter.category' => \&CMSSaveFilter_folder,
            $pkg . 'post_delete.category' => \&CMSPostDelete_folder,

            # category callbacks
            $pkg
              . 'view_permission_filter.category' =>
              \&CMSViewPermissionFilter_category,
            $pkg
              . 'save_permission_filter.category' =>
              \&CMSSavePermissionFilter_category,
            $pkg
              . 'delete_permission_filter.category' =>
              \&CMSDeletePermissionFilter_category,
            $pkg . 'pre_save.category'    => \&CMSPreSave_category,
            $pkg . 'post_save.category'   => \&CMSPostSave_category,
            $pkg . 'save_filter.category' => \&CMSSaveFilter_category,
            $pkg . 'post_delete.category' => \&CMSPostDelete_category,

            # comment callbacks
            $pkg
              . 'view_permission_filter.comment' =>
              \&CMSViewPermissionFilter_comment,
            $pkg
              . 'save_permission_filter.comment' =>
              \&CMSSavePermissionFilter_comment,
            $pkg
              . 'delete_permission_filter.comment' =>
              \&CMSDeletePermissionFilter_comment,
            $pkg . 'pre_save.comment'    => \&CMSPreSave_comment,
            $pkg . 'post_save.comment'   => \&CMSPostSave_comment,
            $pkg . 'post_delete.comment' => \&CMSPostDelete_comment,

            # commenter callbacks
            $pkg
              . 'view_permission_filter.commenter' =>
              \&CMSViewPermissionFilter_commenter,
            $pkg
              . 'delete_permission_filter.commenter' =>
              \&CMSDeletePermissionFilter_commenter,

            # entry callbacks
            $pkg
              . 'view_permission_filter.entry' =>
              \&CMSViewPermissionFilter_entry,
            $pkg
              . 'delete_permission_filter.entry' =>
              \&CMSDeletePermissionFilter_entry,
            $pkg . 'pre_save.entry'    => \&CMSPreSave_entry,
            $pkg . 'post_save.entry'   => \&CMSPostSave_entry,
            $pkg . 'post_delete.entry' => \&CMSPostDelete_entry,

            # page callbacks
            $pkg
              . 'view_permission_filter.page' => \&CMSViewPermissionFilter_page,
            $pkg
              . 'delete_permission_filter.page' =>
              \&CMSDeletePermissionFilter_page,
            $pkg . 'pre_save.page'    => \&CMSPreSave_page,
            $pkg . 'post_save.page'   => \&CMSPostSave_page,
            $pkg . 'post_delete.page' => \&CMSPostDelete_page,

            # ping callbacks
            $pkg
              . 'view_permission_filter.ping' => \&CMSViewPermissionFilter_ping,
            $pkg
              . 'save_permission_filter.ping' => \&CMSSavePermissionFilter_ping,
            $pkg
              . 'delete_permission_filter.ping' =>
              \&CMSDeletePermissionFilter_ping,
            $pkg . 'pre_save.ping'    => \&CMSPreSave_ping,
            $pkg . 'post_save.ping'   => \&CMSPostSave_ping,
            $pkg . 'post_delete.ping' => \&CMSPostDelete_ping,

            # template callbacks
            $pkg
              . 'view_permission_filter.template' =>
              \&CMSViewPermissionFilter_template,
            $pkg
              . 'save_permission_filter.template' =>
              \&CMSSavePermissionFilter_template,
            $pkg
              . 'delete_permission_filter.template' =>
              \&CMSDeletePermissionFilter_template,
            $pkg . 'pre_save.template'    => \&CMSPreSave_template,
            $pkg . 'post_save.template'   => \&CMSPostSave_template,
            $pkg . 'post_delete.template' => \&CMSPostDelete_template,

            # tags
            $pkg
              . 'delete_permission_filter.tag' =>
              \&CMSDeletePermissionFilter_tag,
            $pkg . 'post_delete.tag' => \&CMSPostDelete_tag,

            # junk-related callbacks
            #'HandleJunk' => \&_builtin_spam_handler,
            #'HandleNotJunk' => \&_builtin_spam_unhandler,
            $pkg . 'not_junk_test' => \&_cb_notjunktest_filter,

            # assets
            $pkg
              . 'view_permission_filter.asset' =>
              \&CMSViewPermissionFilter_asset,
            $pkg
              . 'delete_permission_filter.asset' =>
              \&CMSDeletePermissionFilter_asset,
            $pkg . 'pre_save.asset'    => \&CMSPreSave_asset,
            $pkg . 'post_save.asset'   => \&CMSPostSave_asset,
            $pkg . 'post_delete.asset' => \&CMSPostDelete_asset,
            'template_param.edit_asset' => \&CMSTemplateParam_edit_asset,
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
        my $auth_token = MT::Util::perl_sha1_digest_hex( 'feed:' . $pw );
        return $feed_token eq $auth_token;
    }
    else {
        return $app->SUPER::validate_magic(@_);
    }
}

sub update_welcome_message {
    my $app = shift;
    $app->validate_magic or return;

    my $perms = $app->permissions;
    return $app->errtrans("Permission denied.")
      unless $perms && $perms->can_edit_config;

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

sub upgrade {
    my $app = shift;

    # check for an empty database... no author table would do it...
    my $driver         = MT::Object->driver;
    my $upgrade_script = $app->config('UpgradeScript');
    my $user_class     = MT->model('author');
    if ( !$driver || !$driver->table_exists($user_class) ) {
        return $app->redirect( $app->path
              . $upgrade_script
              . $app->uri_params( mode => 'install' ) );
    }

    return $app->redirect( $app->path . $upgrade_script );
}

sub logout {
    my $app = shift;
    $app->SUPER::logout(@_);
}

sub start_recover {
    my $app = shift;
    $app->add_breadcrumb( $app->translate('Password Recovery') );
    $app->load_tmpl('dialog/recover.tmpl');
}

sub recover_password {
    my $app   = shift;
    my $q     = $app->param;
    my $name  = $q->param('name');
    my $class = ref $app eq 'MT::App::Upgrader' ? 'MT::BasicAuthor' : $app->model('author');
    eval "use $class;";
    my @author = $class->load( { name => $name } );
    my $author;
    foreach (@author) {
        next unless $_->password && ( $_->password ne '(none)' );
        $author = $_;
    }

    my ( $rc, $res ) =
      $app->reset_password( $author, $q->param('hint'), $name );

    if ($rc) {
        $app->add_breadcrumb( $app->translate('Password Recovery') );
        $app->load_tmpl(
            'dialog/recover.tmpl',
            {
                recovered => 1,
                email     => $author->email
            }
        );
    }
    else {
        $app->error($res);
    }
}

sub recover_profile_password {
    my $app = shift;
    $app->validate_magic or return;
    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();

    my $q = $app->param;

    require MT::Auth;
    require MT::Log;
    if ( !MT::Auth->can_recover_password ) {
        $app->log(
            {
                message => $app->translate(
"Invalid password recovery attempt; can't recover password in this configuration"
                ),
                level    => MT::Log::SECURITY(),
                class    => 'system',
                category => 'recover_profile_password',
            }
        );
        return $app->error("Can't recover password in this configuration");
    }

    my $author_id = $q->param('author_id');
    my $author    = MT::Author->load($author_id);

    return $app->error( $app->translate("Invalid author_id") )
      if !$author || $author->type != MT::Author::AUTHOR() || !$author_id;

    my ( $rc, $res ) =
      $app->reset_password( $author, $author->hint, $author->name );

    if ($rc) {
        my $url = $app->uri(
            'mode' => 'view',
            args   => { _type => 'author', recovered => 1, id => $author_id }
        );
        $app->redirect($url);
    }
    else {
        $app->error($res);
    }
}

sub reset_password {
    my $app      = shift;
    my ($author) = $_[0];
    my $hint     = $_[1];
    my $name     = $_[2];

    require MT::Auth;
    require MT::Log;
    if ( !MT::Auth->can_recover_password ) {
        $app->log(
            {
                message => $app->translate(
"Invalid password recovery attempt; can't recover password in this configuration"
                ),
                level    => MT::Log::SECURITY(),
                class    => 'system',
                category => 'recover_password',
            }
        );
        return ( 0,
            $app->translate("Can't recover password in this configuration") );
    }

    $app->log(
        {
            message => $app->translate(
                "Invalid user name '[_1]' in password recovery attempt", $name
            ),
            level    => MT::Log::SECURITY(),
            class    => 'system',
            category => 'recover_password',
        }
      ),
      return ( 0, $app->translate("User name or password hint is incorrect.") )
      unless $author;
    return ( 0,
        $app->translate("User has not set pasword hint; cannot recover password")
    ) if ( $hint && !$author->hint );

    $app->log(
        {
            message => $app->translate(
                "Invalid attempt to recover password (used hint '[_1]')",
                $hint
            ),
            level    => MT::Log::SECURITY(),
            class    => 'system',
            category => 'recover_password'
        }
      ),
      return ( 0, $app->translate("User name or password hint is incorrect.") )
      unless $author->hint eq $hint;

    return ( 0, $app->translate("User does not have email address") )
      unless $author->email;

    my @pool = ( 'a' .. 'z', 0 .. 9 );
    my $pass = '';
    for ( 1 .. 8 ) { $pass .= $pool[ rand @pool ] }
    $author->set_password($pass);
    $author->save;
    my $message =
      $app->translate(
"Password was reset for user '[_1]' (user #[_2]). Password was sent to the following address: [_3]",
        $author->name, $author->id, $author->email );
    $app->log(
        {
            message  => $message,
            level    => MT::Log::SECURITY(),
            class    => 'system',
            category => 'recover_password'
        }
    );

    my $address =
      defined $author->nickname
      ? $author->nickname . ' <' . $author->email . '>'
      : $author->email;
    my %head = (
        id      => 'recover_password',
        To      => $address,
        From    => $app->config('EmailAddressMain') || $address,
        Subject => $app->translate("Password Recovery")
    );
    my $charset = $app->charset;
    my $mail_enc = uc( $app->config('MailEncoding') || $charset );
    $head{'Content-Type'} = qq(text/plain; charset="$mail_enc");

    my $body = $app->build_email( 'recover-password.tmpl',
        { user_password => $pass, link_to_login => $app->base . $app->mt_uri } 
    );
    $body = wrap_text( $body, 72 );
    require MT::Mail;
    MT::Mail->send( \%head, $body )
      or return (
        0,
        $app->translate(
            "Error sending mail ([_1]); please fix the problem, then "
              . "try again to recover your password.",
            MT::Mail->errstr
        )
      );
    ( 1, $message );
}

sub js_tag_list {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');
    my $type    = $app->param('_type') || 'entry';

    my $class = $app->model($type)
      or return $app->json_error( $app->translate("Invalid request.") );
    my $result;
    if (
        my $tag_list = MT::Tag->cache(
            blog_id => $blog_id,
            class   => $class,
            private => 1,
        )
      )
    {
        $result = { tags => $tag_list };
    }
    else {
        $result = { tags => {} };
    }
    $app->json_result($result);
}

sub js_tag_check {
    my $app       = shift;
    my $name      = $app->param('tag_name');
    my $blog_id   = $app->param('blog_id');
    my $type      = $app->param('_type') || 'entry';
    my $tag_class = $app->model('tag')
      or return $app->json_error( $app->translate("Invalid request.") );
    my $tag =
      $tag_class->load( { name => $name }, { binary => { name => 1 } } );
    my $class = $app->model($type)
      or $app->json_error( $app->translate("Invalid request.") );
    if ( $tag && $blog_id ) {
        my $ot_class = $app->model('objecttag');
        my $count    = $ot_class->count(
            {
                object_datasource => $class->datasource,
                blog_id           => $blog_id,
                tag_id            => $tag->id
            }
        );
        undef $tag unless $count;
    }
    return $app->json_result( { exists => $tag ? 'true' : 'false' } );
}

sub recover_passwords {
    my $app = shift;
    my @id  = $app->param('id');

    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();

    my $class = ref $app eq 'MT::App::Upgrader' ? 'MT::BasicAuthor' : $app->model('author');
    eval "use $class;";

    my @msg_loop;
    foreach (@id) {
        my $author = $class->load($_);
        my ( $rc, $res ) = $app->reset_password( $author, $author->hint );
        push @msg_loop, { message => $res };
    }

    $app->load_tmpl( 'recover_password_result.tmpl',
        { message_loop => \@msg_loop, return_url => $app->return_uri } );
}

sub _merge_default_assignments {
    my $app = shift;
    my ( $data, $hasher, $type, $id ) = @_;

    if ( my $def = $app->config->DefaultAssignments ) {
        my @def = split ',', $def;
        while ( my $role_id = shift @def ) {
            my $blog_id = shift @def;
            next unless $role_id && $blog_id;
            next if ( $type eq 'role' ) && ( $id != $role_id );
            next if ( $type eq 'blog' ) && ( $id != $blog_id );
            my $obj = MT::Association->new;
            $obj->role_id($role_id);
            $obj->blog_id($blog_id);
            $obj->id( 'PSEUDO-' . $role_id . '-' . $blog_id );
            my $row = $obj->column_values();
            $hasher->( $obj, $row ) if $hasher;
            $row->{user_id}   = 'PSEUDO';
            $row->{user_name} = $app->translate('(newly created user)');
            push @$data, $row;
        }
    }
}

sub build_asset_hasher {
    my $app = shift;
    my (%param) = @_;
    my ($default_thumb_width, $default_thumb_height, $default_preview_width,
        $default_preview_height) =
        @param{qw( ThumbWidth ThumbHeight PreviewWidth PreviewHeight )};

    require File::Basename;
    require JSON;
    my %blogs;
    return sub {
        my ( $obj, $row, %param ) = @_;
        my ($thumb_width, $thumb_height) = @param{qw( ThumbWidth ThumbHeight )};
        $row->{id} = $obj->id;
        my $blog = $blogs{ $obj->blog_id } ||= $obj->blog;
        $row->{blog_name} = $blog ? $blog->name : '-';
        $row->{url} = $obj->url; # this has to be called to calculate
        $row->{asset_type} = $obj->class_type;
        $row->{asset_class_label} = $obj->class_label;
        my $file_path = $obj->file_path; # has to be called to calculate
        my $meta = $obj->metadata;
        if ( $file_path && ( -f $file_path ) ) {
            $row->{file_path} = $file_path;
            $row->{file_name} = File::Basename::basename( $file_path );
            my @stat = stat( $file_path );
            my $size = $stat[7];
            $row->{file_size} = $size;
            if ( $size < 1024 ) {
                $row->{file_size_formatted} = sprintf( "%d Bytes", $size );
            }
            elsif ( $size < 1024000 ) {
                $row->{file_size_formatted} =
                  sprintf( "%.1f KB", $size / 1024 );
            }
            else {
                $row->{file_size_formatted} =
                  sprintf( "%.1f MB", $size / 1024000 );
            }
            $meta->{'file_size'} = $row->{file_size_formatted};
        }
        else {
            $row->{file_is_missing} = 1 if $file_path;
        }
        $row->{file_label} = $row->{label} = $obj->label || $row->{file_name} || $app->translate('Untitled');

        if ($obj->has_thumbnail) { 
            $row->{has_thumbnail} = 1;
            my $height = $thumb_height || $default_thumb_height || 75;
            my $width  = $thumb_width  || $default_thumb_width  || 75;
            @$meta{qw( thumbnail_url thumbnail_width thumbnail_height )}
              = $obj->thumbnail_url( Height => $height, Width => $width );

            $meta->{thumbnail_width_offset}  = int(($width  - $meta->{thumbnail_width})  / 2);
            $meta->{thumbnail_height_offset} = int(($height - $meta->{thumbnail_height}) / 2);

            if ($default_preview_width && $default_preview_height) {
                @$meta{qw( preview_url preview_width preview_height )}
                  = $obj->thumbnail_url(
                    Height => $default_preview_height,
                    Width  => $default_preview_width,
                );
                $meta->{preview_width_offset}  = int(($default_preview_width  - $meta->{preview_width})  / 2);
                $meta->{preview_height_offset} = int(($default_preview_height - $meta->{preview_height}) / 2);
            }
        }
        else {
            $row->{has_thumbnail} = 0;
        }

        my $ts = $obj->created_on;
        if ( my $by = $obj->created_by ) {
            my $user = MT::Author->load($by);
            $row->{created_by} = $user ? $user->name : '';
        }
        if ($ts) {
            $row->{created_on_formatted} =
              format_ts( LISTING_DATE_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_time_formatted} =
              format_ts( LISTING_TIMESTAMP_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_relative} = relative_date( $ts, time, $blog );
        }

        @$row{keys %$meta} = values %$meta;
        $row->{metadata_json} = JSON::objToJson($meta);
        $row;
    };
}

sub list_assets {
    my $app = shift;

    my $blog_id = $app->param('blog_id');
    my $blog;
    if ($blog_id) {
        my $blog_class = $app->model('blog');
        $blog = $blog_class->load($blog_id)
          or return $app->errtrans("Invalid request.");
        my $perms = $app->permissions;
        return $app->errtrans("Permission denied.")
          unless $app->user->is_superuser
          || (
            $perms
            && (   $perms->can_edit_assets
                || $perms->can_edit_all_posts
                || $perms->can_create_post )
          );
    }

    my $asset_class = $app->model('asset') or return;
    my %terms;
    my %args = ( sort => 'created_on', direction => 'descend' );

    my $class_filter;
    my $filter = ( $app->param('filter') || '' );
    if ( $filter eq 'class' ) {
        $class_filter = $app->param('filter_val');
    }
    elsif ($filter eq 'userpic') {
        $class_filter = 'image';
        $terms{created_by} = $app->param('filter_val');

        my $tag = MT::Tag->load( { name => '@userpic' },
            { binary => { name => 1 } } );
        if ($tag) {
            require MT::ObjectTag;
            $args{'join'} = MT::ObjectTag->join_on(
                'object_id',
                {
                    tag_id            => $tag->id,
                    object_datasource => MT::Asset->datasource
                },
                { unique => 1 }
            );
        }
    }

    $app->add_breadcrumb( $app->translate("Files") );
    if ($blog_id) {
        $terms{blog_id} = $blog_id;
    }
    elsif ((defined $blog_id) && ($blog_id ne '')) {
        $terms{blog_id} = '0';
    }
    else {
        unless ( $app->user->is_superuser ) {
            my @perms = MT::Permission->load( { author_id => $app->user->id } );
            my @blog_ids;
            push @blog_ids, $_->blog_id
              foreach grep { $_->can_edit_assets } @perms;
            $terms{blog_id} = \@blog_ids;
        }
    }

    my $hasher = $app->build_asset_hasher(
        PreviewWidth => 240, PreviewHeight => 240 );

    if ($class_filter) {
        my $asset_pkg = MT::Asset->class_handler($class_filter);
        $terms{class} = $asset_pkg->type_list;
    }
    else {
        $terms{class} = '*';    # all classes
    }

    # identifier => name
    my $classes = MT::Asset->class_labels;
    my @class_loop;
    foreach my $class ( keys %$classes ) {
        next if $class eq 'asset';
        push @class_loop,
          {
            class_id    => $class,
            class_label => $classes->{$class},
          };
    }

    # Now, sort it
    @class_loop = sort { $a->{class_label} cmp $b->{class_label} } @class_loop;

    my $dialog_view = $app->param('dialog_view') ? 1 : 0;
    my $perms = $app->permissions;
    my %carry_params = map { $_ => $app->param($_) || '' }
        (qw( edit_field upload_mode require_type next_mode asset_select ));
    $carry_params{'user_id'} = $app->param('filter_val')
        if $filter eq 'userpic';
    $app->_set_start_upload_params(\%carry_params);
    $app->listing(
        {
            terms    => \%terms,
            args     => \%args,
            type     => 'asset',
            code     => $hasher,
            template => $dialog_view
            ? 'dialog/asset_list.tmpl'
            : '',
            params => {
                (
                    $blog
                    ? (
                        blog_id   => $blog_id,
                        blog_name => $blog->name
                          || '',
                        edit_blog_id => $blog_id,
                      )
                    : (),
                ),
                is_image         => defined $class_filter
                  && $class_filter eq 'image' ? 1 : 0,
                dialog_view      => $dialog_view,
                search_label     => MT::Asset->class_label_plural,
                search_type      => 'asset',
                class_loop       => \@class_loop,
                can_delete_files => (
                    $perms ? $perms->can_edit_assets : $app->user->is_superuser
                ),
                nav_assets       => 1,
                panel_searchable => 1,
                object_type      => 'asset',
                %carry_params,
            },
        }
    );
}

sub list_roles {
    my $app = shift;

    $app->return_to_dashboard( redirect => 1 ) if $app->param('blog_id');

    my $pref = $app->list_pref('role');
    my $all_perms;
    if ( $pref->{view_expanded} ) {
        my @all_perms = @{ MT::Permission->perms() };
        $all_perms = [@all_perms];
        foreach (@$all_perms) {
            $_->[1] = $app->translate( $_->[1] );
        }
    }

    my $author_class = $app->model('author');
    my $assoc_class  = $app->model('association');
    my $hasher       = sub {
        my ( $obj, $row ) = @_;
        my $user_count = $assoc_class->count(
            {
                role_id   => $obj->id,
                author_id => [ 1, undef ],
            },
            {
                unique     => 'author_id',
                range_incl => { author_id => 1 },
            }
        );
        $row->{members} = $user_count;
        $row->{weblogs} = $assoc_class->count(
            {
                role_id => $obj->id,
                blog_id => [ 1, undef ],
            },
            {
                unique     => 'blog_id',
                range_incl => { blog_id => 1 },
            }
        );
        if ( $obj->created_by ) {
            my $user = $author_class->load( $obj->created_by );
            $row->{created_by} = $user ? $user->name : '';
        }
        else {
            $row->{created_by} = '';
        }

        # populate permissions for the expanded view
        if ( $pref->{view_expanded} ) {
            my @perms;
            foreach (@$all_perms) {
                next unless length( $_->[1] || '' );
                push @perms, { name => $app->translate( $_->[1] ) }
                  if $obj->has( $_->[0] );
            }
            $row->{perm_loop} = \@perms;
        }
    };
    unless ( $app->user->is_superuser() ) {
        return $app->errtrans("Permission denied.");
    }
    $app->add_breadcrumb( $app->translate("Roles") );
    $app->listing(
        {
            args   => { sort => 'name' },
            type   => 'role',
            code   => $hasher,
            params => {
                nav_privileges    => 1,
                list_noncron      => 1,
                can_create_role   => $app->user->is_superuser,
                has_expanded_mode => 1,
                search_label      => $app->translate('Users'),
                object_type       => 'role',
                screen_id         => 'list-role',
            },
        }
    );
}

sub list_associations {
    my $app = shift;

    my $blog_id   = $app->param('blog_id');
    my $author_id = $app->param('author_id');
    my $role_id   = $app->param('role_id');

    my $this_user = $app->user;
    if ( !$this_user->is_superuser ) {
        if (
            (
                   !$blog_id
                || !$this_user->permissions($blog_id)->can_administer_blog
            )
            && ( !$author_id || ( $author_id != $this_user->id ) )
          )
        {
            return $app->errtrans("Permission denied.");
        }
    }

    my ( $user, $role );
    $app->error(undef);

    if ($author_id) {
        $app->add_breadcrumb( $app->translate('Users'),
              $app->user->is_superuser
            ? $app->uri( mode => 'list_authors' )
            : undef );
        if ( 'PSEUDO' ne $author_id ) {
            my $author_class = $app->model('author');
            $user = $author_class->load($author_id);
            $app->add_breadcrumb(
                $user->name,
                $app->uri(
                    mode => 'view',
                    args => { _type => 'author', id => $author_id }
                )
            );
        }
        else {
            $app->add_breadcrumb( $app->translate('(newly created user)') );
        }
        $app->add_breadcrumb( $app->translate('User Associations') );
    }
    if ($role_id) {
        my $role_class = $app->model('role') or return;
        $role = $role_class->load($role_id);
        $app->add_breadcrumb( $app->translate("Roles"),
            $app->uri( mode => "list_roles" ) );
        $app->add_breadcrumb(
            $role->name,
            $app->uri(
                mode => 'edit_role',
                args => { _type => 'role', id => $role_id }
            )
        );
        $app->add_breadcrumb( $app->translate("Role Users & Groups") );
    }
    if ( !$role_id  && !$author_id ) {
        if ($blog_id) {
            $app->add_breadcrumb( $app->translate("Users") );
        }
        else {
            $app->add_breadcrumb( $app->translate("Associations") );
        }
    }

    my $pref = $app->list_pref('association');
    my $all_perms;
    if ( $pref->{view_expanded} ) {
        my @all_perms = @{ MT::Permission->perms() };
        $all_perms = [@all_perms];
        foreach (@$all_perms) {
            $_->[1] = $app->translate( $_->[1] );
        }
    }

    # Supplies additional parameters for the row being listed
    my %users;
    $users{ $this_user->id } = $this_user;
    my $hasher = sub {
        my ( $obj, $row ) = @_;
        if ( my $user = $obj->user ) {
            $row->{user_id}   = $user->id;
            $row->{user_name} = $user->name;
        }
        if ( my $role = $obj->role ) {
            $row->{role_name} = $role->name;

            # populate permissions for the expanded view
            if ( $pref->{view_expanded} ) {
                my @perms;
                foreach (@$all_perms) {
                    next unless length( $_->[1] || '' );
                    push @perms, { name => $app->translate( $_->[1] ) }
                      if $role->has( $_->[0] );
                }
                $row->{perm_loop} = \@perms;
            }
        }
        else {
            $row->{role_name} = $app->translate("(Custom)");
        }
        if ( my $blog = $obj->blog ) {
            $row->{blog_name} = $blog->name;
        }
        if ( my $ts = $obj->created_on ) {
            $row->{created_on_formatted} =
              format_ts( LISTING_DATE_FORMAT, $ts, $obj->blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_time_formatted} =
              format_ts( LISTING_TIMESTAMP_FORMAT, $ts, $obj->blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_relative} =
              relative_date( $ts, time, $obj->blog );
        }
        if ( $row->{created_by} ) {
            my $created_user = $users{ $row->{created_by} } ||=
              MT::Author->load( $row->{created_by} );
            if ($created_user) {
                $row->{created_by} = $created_user->name;
            }
            else {
                $row->{created_by} = $app->translate('(user deleted)');
            }
        }
    };
    $app->model('association') or return;
    my $types;
    if ( !$author_id && !$blog_id ) {
        $types = [
            MT::Association::USER_BLOG_ROLE(),
            MT::Association::USER_ROLE(),
        ];
    }
    elsif ( !$author_id ) {
        $types = [
            MT::Association::USER_BLOG_ROLE(),
        ];
    }
    elsif ($author_id) {
        $types =
          [ MT::Association::USER_BLOG_ROLE(), MT::Association::USER_ROLE() ];
    }

    my $pre_build = sub {
        my ($param) = @_;
        my $data = $param->{object_loop} || [];

        #TODO: handle group_view
        if ( $param->{user_view}
            && ( 'PSEUDO' ne $param->{edit_author_id} ) )
        {

            # don't merge
        }
        elsif ( $param->{role_view} ) {
            $app->_merge_default_assignments( $data, $hasher, 'role',
                $param->{role_id} );
        }
        elsif ( $param->{blog_view} ) {
            $app->_merge_default_assignments( $data, $hasher, 'blog',
                $param->{blog_id} );
        }
        else {
            $app->_merge_default_assignments( $data, $hasher, 'all' );
        }
    };

    return $app->listing(
        {
            args  => { sort => 'created_on', direction => 'descend' },
            type  => 'association',
            code  => $hasher,
            terms => {
                type => $types,
                $author_id ? ( author_id => $author_id ) : (),
                $blog_id   ? ( blog_id   => $blog_id )   : (),
                $role_id   ? ( role_id   => $role_id )   : (),
            },
            pre_build => $pre_build,
            params => {
                can_create_association => $app->user->is_superuser || ( $blog_id
                    && $app->user->permissions($blog_id)->can_administer_blog ),
                has_expanded_mode => 1,
                nav_privileges =>
                  ( $author_id || $blog_id ? 0 : 1 ) || $role_id,
                nav_authors => ( $author_id || $blog_id ? 1 : 0 )
                  && !$role_id,
                blog_view     => $blog_id   ? 1 : 0,
                user_view     => $author_id ? 1 : 0,
                role_view     => $role_id   ? 1 : 0,
                $role_id
                ? (
                    role_id   => $role_id,
                    role_name => $role->name,
                  )
                : (),
                $author_id
                ? (
                    edit_author_id   => $author_id,
                    edit_name => $user
                    ? ( $user->nickname ? $user->nickname : $user->name )
                    : $app->translate('(newly created user)'),
                    edit_object => $app->translate('The user'),
                    group_count => $user ? $user->group_count() : 0,
                    status_enabled => $user ? ( $user->is_active ? 1 : 0 ) : 0,
                    status_pending => $user
                    ? ( $user->status == MT::Author::PENDING() ? 1 : 0 )
                    : 0,
                  )
                : (),
                saved         => $app->param('saved')         || 0,
                saved_deleted => $app->param('saved_deleted') || 0,
                usergroup_view => !$author_id  && !$role_id,
                blog_id => $blog_id,
                search_label => $app->translate('Users'),
                object_type  => 'association',
                pt_name => $app->translate('User'),
                screen_id => "list-associations",
            },
        }
    );
}

sub list_tag {
    my $app = shift;
    my %param;
    my $filter_key = $app->param('filter_key') || 'entry';
    my $type       = $app->param('_type')      || $filter_key;
    my $plural;
    $param{TagObjectType} = $type;
    $param{Package}       = $app->model($type);

    if ( !$app->blog && !$app->user->is_superuser ) {
        return $app->errtrans("Permission denied.");
    }

    my $perms = $app->permissions;
    if ( $app->blog && ( ( !$perms ) || ( $perms && $perms->is_empty ) ) ) {
        $app->delete_param('blog_id');
        return $app->return_to_dashboard( permission => 1 );
    }

    if ( $param{Package}->can('class_label_plural') ) {
        $plural = $param{Package}->class_label_plural();
    }
    else {
        if ( $type =~ m/y$/ ) {
            $plural = $type;
            $plural =~ s/y$/ies/;
        }
        else {
            $plural = $type . 's';
        }
        $plural =~ s/(.*)/\u$1/;
    }

    $param{TagObjectLabelPlural} = $plural;
    $app->model($type) or return;
    unless ( UNIVERSAL::can( $param{Package}, 'tag_count' ) ) {
        return $app->errtrans("Invalid type");
    }
    $app->list_tag_for(%param);
}

sub list_tag_for {
    my $app = shift;
    my (%params) = @_;

    my $pkg = $params{Package};

    my $q         = $app->param;
    my $blog_id   = $app->param('blog_id');
    my $list_pref = $app->list_pref('tag');
    my %param     = %$list_pref;

    my $limit = $list_pref->{rows};
    my $offset = $app->param('offset') || 0;

    my ( %terms, %arg );

    my $tag_class = $app->model('tag');
    my $ot_class  = $app->model('objecttag');
    my $total = $pkg->tag_count( $blog_id ? { blog_id => $blog_id } : undef )
      || 0;

    $arg{'sort'} = 'name';
    $arg{limit} = $limit + 1;
    if ( $total && $offset > $total - 1 ) {
        $arg{offset} = $offset = $total - $limit;
    }
    elsif ( ( $offset < 0 ) || ( $total - $offset < $limit ) ) {
        $arg{offset} = $offset = 0;
    }
    else {
        $arg{offset} = $offset if $offset;
    }
    $arg{join} = $ot_class->join_on(
        'tag_id',
        {
            object_datasource => $pkg->datasource,
            ( $blog_id ? ( blog_id => $blog_id ) : () )
        },
        {
            unique => 1,
            'join' => $pkg->join_on(
                undef,
                {
                    id => \'= objecttag_object_id',
                    ( $pkg =~ m/asset/i ? () : ( class => $pkg->class_type ) )
                }
            )
        }
    );

    my $data = $app->build_tag_table(
        load_args => [ \%terms, \%arg ],
        'package' => $pkg,
        param     => \%param
    );
    delete $param{tag_table} unless @$data;

    ## We tried to load $limit + 1 entries above; if we actually got
    ## $limit + 1 back, we know we have another page of entries.
    my $have_next_entry = @$data > $limit;
    pop @$data while @$data > $limit;
    if ($offset) {
        $param{prev_offset}     = 1;
        $param{prev_offset_val} = $offset - $limit;
        $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
    }
    if ($have_next_entry) {
        $param{next_offset}     = 1;
        $param{next_offset_val} = $offset + $limit;
    }

    # load tag filters
    my $filters = $app->registry( "list_filters", "tag" ) || {};
    my $filter_key = $app->param('filter_key') || 'entry';
    my $filter_label = '';
    if ( my $filter = $filters->{$filter_key} ) {
        $filter_label = $filter->{label};
    }

    $param{limit}                   = $limit;
    $param{offset}                  = $offset;
    $param{tag_object_type}         = $params{TagObjectType};
    $param{tag_object_label}        = $params{TagObjectLabel} || $pkg->class_label;
    $param{tag_object_label_plural} = $params{TagObjectLabelPlural} || $pkg->class_label_plural;
    $param{object_label}            = $tag_class->class_label;
    $param{object_label_plural}     = $tag_class->class_label_plural;
    $param{object_type}             = 'tag';
    $param{list_start}              = $offset + 1;
    $param{list_end}                = $offset + scalar @$data;
    $param{list_total}              = $total;
    $param{next_max}                = $param{list_total} - $limit;
    $param{next_max}     = 0 if ( $param{next_max} || 0 ) < $offset + 1;
    $param{list_noncron} = 1;
    $param{list_filters} = $app->list_filters('tag');
    $param{filter_key}   = $filter_key;
    $param{filter_label} = $filter_label;
    $param{link_to}      = 'list_' . lc $params{TagObjectType};

    $param{saved}         = $q->param('saved');
    $param{saved_deleted} = $q->param('saved_deleted');
    $param{nav_tags}      = 1;
    $app->add_breadcrumb( $app->translate('Tags') );
    $param{screen_class} = "list-tag";
    $param{screen_id} = "list-tag";
    $param{listing_screen} = 1;

    $app->load_tmpl( 'list_tag.tmpl', \%param );
}

sub rename_tag {
    my $app     = shift;
    my $perms   = $app->permissions;
    my $blog_id = $app->blog->id if $app->blog;
    ( $blog_id && $perms && $perms->can_edit_tags )
      || ( $app->user->is_superuser() )
      or return $app->errtrans("Permission denied.");
    my $id        = $app->param('__id');
    my $name      = $app->param('tag_name')
      or return $app->error( $app->translate("New name of the tag must be specified.") );
    my $obj_type  = $app->param('__type') || 'entry';
    my $obj_class = $app->model($obj_type);
    my $tag_class = $app->model('tag');
    my $ot_class  = $app->model('objecttag');
    my $tag       = $tag_class->load($id)
      or return $app->error( $app->translate("No such tag") );
    my $tag2 =
      $tag_class->load( { name => $name }, { binary => { name => 1 } } );

    if ($tag2) {
        return $app->call_return if $tag->id == $tag2->id;
    }

    my $terms = { tag_id => $tag->id };
    $terms->{blog_id} = $blog_id if $blog_id;

    my $iter = $obj_class->load_iter(
        {
            (
                $obj_type =~ m/asset/i
                ? ( class => '*' )
                : ( class => $obj_type )
            )
        },
        { join => MT::ObjectTag->join_on( 'object_id', $terms ) }
    );
    my @tagged_objects;
    while ( my $o = $iter->() ) {
        $o->remove_tags( $tag->name );
        $o->add_tags($name);
        push @tagged_objects, $o;
    }
    $_->save foreach @tagged_objects;

    if ($tag2) {
        $app->add_return_arg( merged => 1 );
    }
    else {
        $app->add_return_arg( renamed => 1 );
    }
    $app->call_return;
}

sub build_tag_table {
    my $app = shift;
    my (%args) = @_;

    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('tag');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { shift @{ $args{items} } };
    }
    return [] unless $iter;

    my $param   = $args{param} || {};
    my $blog_id = $app->param('blog_id');
    my $pkg     = $args{'package'};

    my @data;
    while ( my $tag = $iter->() ) {
        my $count = $pkg->tagged_count(
            $tag->id,
            {
                ( $blog_id ? ( blog_id => $blog_id ) : () ),
                ( $pkg =~ m/asset/i ? ( class => '*' ) : () )
            }
        );
        $count ||= 0;
        my $row = {
            tag_id    => $tag->id,
            tag_name  => $tag->name,
            tag_count => $count,
            object    => $tag,
        };
        push @data, $row;
    }
    return [] unless @data;

    $param->{tag_table}[0]{object_loop} = \@data;
    $app->load_list_actions( 'tag', $param->{tag_table}[0] );
    $param->{object_loop} = $param->{tag_table}[0]{object_loop};
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
        $param->{can_edit_entries} = $param->{can_create_post}
          || $param->{can_edit_all_entries}
          || $param->{can_publish_post};
        $param->{can_search_replace} = $param->{can_edit_all_posts};
        $param->{can_edit_authors}   = $param->{can_administer_blog};
        $param->{can_access_assets}  = $param->{can_create_post}
          || $param->{can_edit_all_posts}
          || $param->{can_edit_assets};
        $param->{can_edit_commenters}   = $param->{can_manage_feedback};
             $param->{has_manage_label} = $param->{can_edit_templates}
          || $param->{can_administer_blog}
          || $param->{can_edit_categories}
          || $param->{can_edit_config}
          || $param->{can_edit_tags}
          || $param->{can_set_publish_paths}
          || $param->{show_ip_info};
        $param->{has_posting_label} = $param->{can_create_post}
          || $param->{can_edit_entries}
          || $param->{can_access_assets};
        $param->{has_community_label} = $param->{can_edit_entries}
          || $param->{can_edit_notifications};
        $param->{can_publish_feedbacks} = $param->{can_manage_feedback}
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
    $param->{page_actions} ||= $app->page_actions($mode);

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
            $param->{blog_name} = $blog->name;
            $param->{blog_id}   = $blog->id;
            $param->{blog_url}  = $blog->site_url;
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
    $app->SUPER::build_page( $page, $param );
}

sub generate_dashboard_stats {
    my $app = shift;
    my ($param) = @_;

    my $cache_time = 60 * 15;    # cache for 15 minutes

    my $blog_id = $app->blog ? $app->blog->id : 0;
    my $user    = $app->user;
    my $user_id = $user->id;

    my $static_path      = $app->static_path;
    my $static_file_path = $app->static_file_path;

    if ( -f File::Spec->catfile( $static_file_path, "mt.js" ) ) {
        $param->{static_file_path} = $static_file_path;
    }
    else {
        return;
    }

    my $low_dir = sprintf("%03d", $user_id % 1000);
    my $sub_dir = sprintf("%03d", $blog_id % 1000);
    my $top_dir = $blog_id > $sub_dir ? $blog_id - $sub_dir : 0;
    $param->{support_path} =
      File::Spec->catdir( $static_file_path, 'support', 'dashboard', 'stats',
        $top_dir, $sub_dir, $low_dir); 

    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    unless ( $fmgr->exists( $param->{support_path} ) ) {
        $fmgr->mkpath( $param->{support_path} );
        unless ( $fmgr->exists( $param->{support_path} ) ) {
            return;
        }
    }

    my $stats_static_path = $static_path . 'support/dashboard/stats/' .
        $top_dir . '/' . $sub_dir . '/' . $low_dir;

    my $tabs = $app->registry('blog_stats_tabs') or return;
    while (my ($tab_id, $tab) = each %$tabs) {
        my $file = "${tab_id}.xml";
        $param->{stat_url}->{$tab_id} = $stats_static_path . '/' . $file;
        my $path = File::Spec->catfile( $param->{support_path}, $file );

        my $time = ( stat($path) )[9] if -f $path;

        if ( !$time || ( time - $time > $cache_time ) ) {
            my $gen_stats = $tab->{stats};
            next if !$gen_stats;
            $gen_stats = $app->handler_to_coderef($gen_stats);

            my %counts = $gen_stats->($app, $tab);

            unless ( $app->create_dashboard_stats_file( $path, \%counts ) ) {
                delete $param->{stat_url}->{$tab_id};
            }
        }
    }

    1;
}

sub generate_dashboard_stats_entry_tab {
    my $app = shift;
    my ($tab) = @_;
    
    my $blog_id = $app->blog ? $app->blog->id : 0;
    my $user    = $app->user;
    my $user_id = $user->id;

    my $entry_class = $app->model('entry');
    my $terms       = { status => MT::Entry::RELEASE() };
    my $args        = {
        group => [
            "extract(year from authored_on)",
            "extract(month from authored_on)",
            "extract(day from authored_on)"
        ],
    };
    $terms->{blog_id} = $blog_id if $blog_id;
    if ( !$user->is_superuser && !$blog_id ) {
        $args->{join} = MT::Permission->join_on(
            undef,
            {
                blog_id   => \'= entry_blog_id',
                author_id => $user_id
            },
        );
    }

    my $entry_iter = $entry_class->count_group_by( $terms, $args );
    my %counts;
    while ( my ( $count, $y, $m, $d ) = $entry_iter->() ) {
        my $date = sprintf( "%04d%02d%02dT00:00:00", $y, $m, $d );
        $counts{$date} = $count;
    }

    %counts;
}

sub generate_dashboard_stats_comment_tab {
    my $app = shift;
    my ($tab) = @_;
    
    my $blog_id = $app->blog ? $app->blog->id : 0;
    my $user    = $app->user;
    my $user_id = $user->id;

    my $cmt_class = $app->model('comment');
    my $terms = { visible => 1 };
    $terms->{blog_id} = $blog_id if $blog_id;
    my $args = {
        group => [
            "extract(year from created_on)",
            "extract(month from created_on)",
            "extract(day from created_on)"
        ],
    };
    if ( !$user->is_superuser && !$blog_id ) {
        $args->{join} = MT::Permission->join_on(
            undef,
            {
                blog_id   => \'= comment_blog_id',
                author_id => $user_id
            },
        );
    }
    my $cmt_iter = $cmt_class->count_group_by( $terms, $args );

    my %counts;
    while ( my ( $count, $y, $m, $d ) = $cmt_iter->() ) {
        my $date = sprintf( "%04d%02d%02dT00:00:00", $y, $m, $d );
        $counts{$date} = $count;
    }

    %counts;
}

sub create_dashboard_stats_file {
    my $app = shift;
    my ( $file, $data ) = @_;

    my $support_dir = File::Spec->catdir( $app->static_file_path, "support" );
    if ( !-d $support_dir ) {
        mkdir( $support_dir, 0777 );
        if ($!) {
            $app->log("Failed to create 'support' directory.");
            return;
        }
    }

    local *FOUT;
    if ( !open( FOUT, ">$file" ) ) {
        return;
    }

    print FOUT <<EOT;
<?xml version="1.0"?>
<rsp status_code="0" status_message="Success">
  <daily_counts>
EOT
    my $now = time;
    for ( my $i = 120 ; $i >= 1 ; $i-- ) {
        my $ds =
          substr( epoch2ts( $app->blog, $now - ( ( $i - 1 ) * 60 * 60 * 24 ) ),
            0, 8 )
          . 'T00:00:00';
        my $count = $data->{$ds} || 0;
        print FOUT qq{    <count date="$ds">$count</count>\n};
    }
    print FOUT <<EOT;
  </daily_counts>
</rsp>
EOT
    close FOUT;
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
    $args{join} =
      MT::Permission->join_on( 'blog_id', { author_id => $auth->id, } );
    $args{limit} = 11;    # don't load more than 11
    my @blogs = $blog_class->load( undef, \%args );

    my @fav_blogs = @{ $auth->favorite_blogs || [] };
    @fav_blogs = grep { $_ != $blog_id } @fav_blogs if $blog_id;

    # Special case for when a user only has access to a single blog.
    if ( (!defined($app->param('blog_id'))) && ( @blogs == 1 ) && ( scalar @fav_blogs <= 1 ) ) {

        # User only has visibility to a single blog. Don't
        # bother giving them a dashboard link for 'all blogs', or
        # to 'select a blog'.
        $param->{single_blog_mode} = 1;
        my $blog = $blogs[0];
        $blog_id = $blog->id;
        my $perms = MT::Permission->load(
            {
                blog_id   => $blog_id,
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
            {
                author_id => $auth->id,
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

    my $admin =
      $user->is_superuser();    # || ($perms && $perms->has('administer_blog'));

    foreach my $id (@top_ids) {
        my $menu = $menus->{$id};
        next if $menu->{view} && $menu->{view} ne $view;
        if (my $cond = $menu->{condition}) {
            if (!ref($cond)) {
                $cond = $menu->{condition} = $app->handler_to_coderef($cond);
            }
            next unless $cond->();
        }

        $menu->{allowed} = 1;
        $menu->{'id'} = $id;

        my @sub_ids = grep { m/^$id:/ } keys %$menus;
        my @sub;
        foreach my $sub_id (@sub_ids) {
            my $sub = $menus->{$sub_id};
            next
              if $sub->{view}
              && ( $sub->{view} ne $view );
            $sub->{'id'} = $sub_id;
            if (my $cond = $sub->{condition}) {
                if (!ref($cond)) {
                    $cond = $sub->{condition} = $app->handler_to_coderef($cond);
                }
                next unless $cond->();
            }
            push @sub, $sub;
        }

        if (
            my $p =
              $blog_id
            ? $menu->{permission}
            || $menu->{system_permission}
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

        next if $hide_disabled_options && (! $menu->{allowed});

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
                            (
                                $blog_id
                                  && !$sys_only ? ( blog_id => $blog_id ) : ()
                            )
                        }
                    );
                }
                $sub->{allowed} = 0
                  if $sub->{view} && ( $sub->{view} ne $view );
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
                            ? $sub->{permission}
                            || $sub->{system_permission}
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
                          if ( $sub->{system_permission} || $sub->{permission} )
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
                            $blog_id
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

sub get_newsbox_content {
    my $app = shift;
    my $newsbox_url = $app->config('NewsboxURL');
    if ( $newsbox_url && $newsbox_url ne 'disable' ) {
        return MT::Util::get_newsbox_html($newsbox_url, 'NW');
    }
    return q();
}

sub get_lmt_content {
    my $app = shift;
    my $newsbox_url = $app->config('LearningNewsURL');
    if ( $newsbox_url && $newsbox_url ne 'disable' ) {
        return MT::Util::get_newsbox_html($newsbox_url, 'LW');
    }
    return q();
}

sub make_blog_list {
    my $app = shift;
    my ($blogs) = @_;

    my $tbp_class     = $app->model('ping');
    my $entry_class   = $app->model('entry');
    my $comment_class = $app->model('comment');
    my $author        = $app->user;
    my $data;
    my $i;
    my @blog_ids;
    push @blog_ids, $_->id for @$blogs;
    my ( $entry_count, $ping_count, $comment_count );
    my $can_edit_authors = 1 if $author->is_superuser;

    for my $blog (@$blogs) {
        my $blog_id = $blog->id;
        my $perms   = $author->permissions($blog_id);
        my $row     = {
            id          => $blog->id,
            name        => $blog->name,
            description => $blog->description,
            site_url    => $blog->site_url
        };

        # we should use count by group here...
        $row->{num_entries} =
          ( $entry_count ? $entry_count->{$blog_id} : $entry_count->{$blog_id} =
              MT::Entry->count( { blog_id => $blog_id } ) )
          || 0;
        $row->{num_comments} = (
              $comment_count
            ? $comment_count->{$blog_id}
            : $comment_count->{$blog_id} = MT::Comment->count(
                { blog_id => $blog_id, junk_status => [ 0, 1 ] }
            )
          )
          || 0;
        $row->{num_pings} = (
            $ping_count ? $ping_count->{$blog_id} : $ping_count->{$blog_id} =
              MT::TBPing->count(
                { blog_id => $blog_id, junk_status => [ 0, 1 ] }
              )
        ) || 0;
        $row->{num_authors} = 0;

        # FIXME: this isn't efficient
        my $iter = MT::Permission->load_iter(
            {
                blog_id => [ 0, $blog_id ],

                #    role_mask => [ 2, undef ]
                #}, {
                #    range_incl => { 'role_mask' => 1 }
            }
        );
        my %a;
        while ( my $p = $iter->() ) {
            next if exists $a{ $p->author_id };
            $a{ $p->author_id } = 1;
            $row->{num_authors}++ if $p->can_create_post;
        }
        $row->{can_create_post}  = $perms->can_create_post;
        $row->{can_edit_entries} = $perms->can_create_post
          || $perms->can_edit_all_posts
          || $perms->can_publish_post;
        $row->{can_edit_templates} = $perms->can_edit_templates;
        $row->{can_edit_config}    = $perms->can_edit_config
          || $perms->can_administer_blog;
        $row->{can_set_publish_paths} = $perms->can_set_publish_paths
          || $perms->can_administer_blog;
        $row->{can_manage_feedback} = $perms->can_manage_feedback;
        $row->{can_edit_assets}     = $perms->can_edit_assets;
        $row->{can_administer_blog} = $perms->can_administer_blog;
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
    my $can_edit_authors = $author->is_superuser;
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

        # we should use count by group here...
        $row->{num_entries} =
          ( $entry_count ? $entry_count->{$blog_id} : $entry_count->{$blog_id} =
              MT::Entry->count( { blog_id => $blog_id } ) )
          || 0;
        $row->{num_comments} = (
              $comment_count
            ? $comment_count->{$blog_id}
            : $comment_count->{$blog_id} = MT::Comment->count(
                { blog_id => $blog_id, junk_status => [ 0, 1 ] }
            )
          )
          || 0;
        $row->{num_pings} = (
            $ping_count ? $ping_count->{$blog_id} : $ping_count->{$blog_id} =
              MT::TBPing->count(
                { blog_id => $blog_id, junk_status => [ 0, 1 ] }
              )
        ) || 0;
        $row->{num_authors} = 0;

        # FIXME: This isn't efficient
        my $iter = MT::Permission->load_iter(
            {
                blog_id => [ 0, $blog_id ],

                #    role_mask => [ 2, undef ]
                #}, {
                #    range_incl => { 'role_mask' => 1 }
            }
        );
        my %a;
        while ( my $p = $iter->() ) {
            next if exists $a{ $p->author_id };
            $a{ $p->author_id } = 1;
            $row->{num_authors}++ if $p->can_create_post;
        }
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
            $row->{can_create_post}  = $perms->can_create_post;
            $row->{can_edit_entries} = $perms->can_create_post
              || $perms->can_edit_all_posts
              || $perms->can_publish_post;
            $row->{can_edit_templates} = $perms->can_edit_templates;
            $row->{can_edit_config}    = $perms->can_edit_config
              || $perms->can_administer_blog;
            $row->{can_set_publish_paths} = $perms->can_set_publish_paths
              || $perms->can_administer_blog;
            $row->{can_administer_blog} = $perms->can_administer_blog;
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

## Application methods

sub return_to_dashboard {
    my $app = shift;
    my (%param) = @_;
    $param{redirect} = 1 unless %param;
    my $blog_id = $app->param('blog_id');
    $param{blog_id} = $blog_id if $blog_id;
    return $app->redirect( $app->uri( mode => 'dashboard', args => \%param ) );
}

sub dashboard {
    my $app = shift;
    my (%param) = @_;

    if ( $app->request('fresh_login') ) {
        if ( !$app->param('blog_id') ) {

            # return to the last blog they visted, if any
            my $fav_blogs = $app->user->favorite_blogs || [];
            my $blog_id = $fav_blogs->[0] if @$fav_blogs;
            $app->param( 'blog_id', $blog_id ) if $blog_id;
            $app->delete_param('blog_id') unless $app->is_authorized;
        }
    }

    my $param = \%param;

    $param->{redirect}   ||= $app->param('redirect');
    $param->{permission} ||= $app->param('permission');
    $param->{saved}      ||= $app->param('saved');

    $param->{system_overview_nav} = $app->param('blog_id') ? 0 : defined($app->param('blog_id')) ? 1 : 0;
    $param->{quick_search}        = 0;
    $param->{no_breadcrumbs}      = 1;
    $param->{screen_class}        = "dashboard";
    $param->{screen_id}           = "dashboard";

    my $default_widgets = {
        'blog_stats' =>
          { param => { tab => 'entry' }, order => 1, set => 'main' },
        'this_is_you-1' => { order => 1, set => 'sidebar' },
        'mt_shortcuts'  => { order => 2, set => 'sidebar' },
        'mt_news'       => { order => 3, set => 'sidebar' },
    };

    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    $param->{support_path} =
        File::Spec->catdir( $app->static_file_path, 'support', 'uploads' );
    if ( $fmgr->exists( $param->{support_path} ) ) {
        $param->{has_uploads_path} = 1;
    } else {
        $fmgr->mkpath( $param->{support_path} );
        if ( $fmgr->exists( $param->{support_path} )
             && $fmgr->can_write( $param->{support_path} ) )
        {
            $param->{has_uploads_path} = 1;
        }
    }

    # We require that the determination of the 'single blog mode'
    # state be done PRIOR to the generation of the widgets
    $app->build_blog_selector($param);
    $app->load_widget_list( 'dashboard', $param, $default_widgets );
    $param = $app->load_widgets( 'dashboard', $param, $default_widgets );
    return $app->load_tmpl( "dashboard.tmpl", $param );
}

sub mt_blog_stats_widget_comment_tab {
    my ($app, $tmpl, $param) = @_;

    my $user    = $app->user;
    my $blog    = $app->blog;
    my $blog_id = $blog->id if $blog;

    $param->{editable} = $user->is_superuser;
    if ( $blog && !$param->{editable} ) {
        $param->{editable} = $user->permissions($blog_id)->can_edit_all_posts;
        $param->{comment_editable} = $user->permissions($blog_id)->can_manage_feedback;
    }

    my $comments = sub {
        my $args = {
            limit     => 10,
            sort      => 'created_on',
            direction => 'descend',
        };
        if ( !$user->is_superuser && !$blog_id ) {
            $args->{join} = MT::Permission->join_on(
                undef,
                {
                    blog_id   => \'= comment_blog_id',
                    author_id => $user->id
                },
            );
        }
        my @c = MT::Comment->load(
            {
                ( $blog_id ? ( blog_id => $blog_id ) : () ),
                junk_status => [ 0, 1 ],
            },
            $args
        );
        \@c;
    };

    require MT::Promise;
    my $ctx = $tmpl->context;
    $ctx->stash( 'comments',  MT::Promise::delay($comments) );
}

sub mt_blog_stats_widget_entry_tab {
    my ($app, $tmpl, $param) = @_;

    my $user    = $app->user;
    my $blog    = $app->blog;
    my $blog_id = $blog->id if $blog;

    $param->{editable} = $user->is_superuser;
    if ( $blog && !$param->{editable} ) {
        $param->{editable} = $user->permissions($blog_id)->can_edit_all_posts;
    }

    my $entries = sub {
        my $args = {
            limit     => 10,
            sort      => 'authored_on',
            direction => 'descend',
        };
        if ( !$user->is_superuser && !$blog_id ) {
            $args->{join} = MT::Permission->join_on(
                undef,
                {
                    blog_id   => \'= entry_blog_id',
                    author_id => $user->id
                },
            );
        }
        my @e =
          MT::Entry->load( { ( $blog_id ? ( blog_id => $blog_id ) : () ), },
            $args );
        \@e;
    };

    require MT::Promise;
    my $ctx = $tmpl->context;
    $ctx->stash( 'entries',  MT::Promise::delay($entries) );
}

sub mt_blog_stats_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    # For stats shown on this page
    $app->generate_dashboard_stats($param) or return;

    my $tabs = $app->registry('blog_stats_tabs') or return;
    $tabs = $app->filter_conditional_list($tabs, 'dashboard', ($param->{widget_scope} || ''));

    $param->{tab_html_head} = '';
    {
        local $param->{main};
        local $param->{html_head};

        my %cfgs;
        my $stat_url = delete $param->{stat_url};
        while (my ($tab_id, $url) = each %$stat_url) {
            $param->{has_stat_urls} = 1;
            $cfgs{$tab_id} = { param => { stat_url => $url } };
        }
        $app->build_widgets(
            set            => 'blog_stats',
            param          => $param,
            widgets        => $tabs,
            widget_cfgs    => \%cfgs,
            passthru_param => [qw( html_head js_include tabs active_stats_panel_updates )],
        ) or return;

        $param->{blog_stats} = $param->{main};
        $param->{tab_html_head} .= $param->{html_head};
    }
}

sub mt_news_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    $param->{news_html} = $app->get_newsbox_content() || '';
    $param->{learning_mt_news_html} = $app->get_lmt_content() || '';
}

sub new_version_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    push @{ $param->{feature_loop} ||= [] },
      {
        feature_label => MT->translate('Shared Template Modules'),
        feature_url  => $app->help_url('designer/shared-templates.html'),
        feature_description => MT->translate('Reuse elements of your site design or layout across all the blogs and sites managed within Movable Type.')
      },
      {
        feature_label => MT->translate('Userpics'),
        feature_url  => $app->help_url('author/userpics.html'),
        feature_description => MT->translate('Allow authors and commenters to upload a photo of themselves to be displayed alongside their comments.')
      },
      {
        feature_label => MT->translate('Template Sets'),
        feature_url  => $app->help_url('designer/template-sets.html'),
        feature_description => MT->translate('Template sets provide an easy way to bundle an entire design and install it into Movable Type.')
      };
}

sub this_is_you_widget {
    my $app = shift;
    my ( $tmpl, $param ) = @_;

    my $user = $app->user;

    # User profile data
    # Number of posts by this user
    require MT::Entry;
    $param->{publish_count} = MT::Entry->count( { author_id => $user->id, } );
    $param->{draft_count} = MT::Entry->count(
        {
            author_id => $user->id,
            status    => MT::Entry::HOLD(),
        }
    );
    if ( $param->{publish_count} ) {
        require MT::Comment;
        $param->{comment_count} = MT::Comment->count(
            { junk_status => [ 0, 1 ], },
            {
                join => MT::Entry->join_on(
                    undef,
                    {
                        author_id => $user->id,
                        'id'      => \'= comment_entry_id',
                    },
                    {},
                ),
            }
        );
    }

    my $last_post = MT::Entry->load(
        {
            author_id => $user->id,
            status    => MT::Entry::RELEASE(),
        },
        {
            sort      => 'authored_on',
            direction => 'descend',
            limit     => 1,
        }
    );
    if ($last_post) {
        $param->{last_post_id}      = $last_post->id;
        $param->{last_post_blog_id} = $last_post->blog_id;
        $param->{last_post_blog_name} = $last_post->blog->name;
        $param->{last_post_ts}      = $last_post->authored_on;
    }

    if (my ($url) = $user->userpic_url()) {
        $param->{author_userpic_url}    = $url;
    }
    $param->{author_userpic_width}  = 50;
    $param->{author_userpic_height} = 50;
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
        Rows       => 20,
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
            rows  => $default{Rows}       || 20,
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
            $new_cookie .=
              ( $new_cookie ne '' ? ';' : '' ) . $list . ':' . $prefs;
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

sub list_blogs {
    my $app = shift;

    $app->return_to_dashboard( redirect => 1 ) if $app->param('blog_id');

    my $author    = $app->user;
    my $list_pref = $app->list_pref('blog');

    my $limit  = $list_pref->{rows};
    my $offset = $app->param('offset') || 0;
    my $args   = { offset => $offset, sort => 'name' };
    $args->{limit} = $limit + 1;
    unless ( $author->is_superuser ) {
        $args->{join} = MT::Permission->join_on(
            'blog_id',
            { author_id => $author->id },
            { unique    => 1 }
        );
    }
    my $blog_class       = $app->model('blog');
    my %param            = %$list_pref;
    my @blogs            = $blog_class->load( undef, $args );
    my $can_edit_authors = $author->is_superuser;
    my $blog_loop        = $app->make_blog_list( \@blogs );

    if ($blog_loop) {
        ## We tried to load $limit + 1 entries above; if we actually got
        ## $limit + 1 back, we know we have another page of entries.
        my $have_next = @$blog_loop > $limit;
        pop @$blog_loop while @$blog_loop > $limit;
        if ($offset) {
            $param{prev_offset}     = 1;
            $param{prev_offset_val} = $offset - $limit;
            $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
        }
        if ($have_next) {
            $param{next_offset}     = 1;
            $param{next_offset_val} = $offset + $limit;
        }
    }
    $param{offset}      = $offset;
    $param{object_type} = 'blog';
    $param{list_start}  = $offset + 1;
    delete $args->{limit};
    delete $args->{offset};
    $param{list_total} = $blog_class->count( undef, $args );
    $param{list_end}        = $offset + ( $blog_loop ? scalar @$blog_loop : 0 );
    $param{next_max}        = $param{list_total} - $limit;
    $param{next_max}        = 0 if ( $param{next_max} || 0 ) < $offset + 1;
    $param{can_create_blog} = $author->can_create_blog;
    $param{saved_deleted}   = $app->param('saved_deleted');
    $param{nav_blogs}       = 1;
    $param{list_noncron}    = 1;
    $param{search_label}    = $app->translate('Blogs');

    if ($blog_loop) {
        $param{object_loop} = $param{blog_table}[0]{object_loop} = $blog_loop;
        $app->load_list_actions( 'blog', \%param );
    }

    $param{page_actions} = $app->page_actions('list_blog');
    $param{feed_name}    = $app->translate("Blog Activity Feed");
    $param{feed_url}     = $app->make_feed_link('blog');
    $app->add_breadcrumb( $app->translate("Blogs") );
    $param{nav_weblogs} = 1;
    $param{object_label} = $blog_class->class_label;
    $param{object_label_plural} = $blog_class->class_label_plural;
    $param{screen_class} = "list-blog";
    $param{screen_id} = "list-blog";
    $param{listing_screen} = 1;
    return $app->load_tmpl( 'list_blog.tmpl', \%param );
}

# list of all users, regardless of commenter/author on a blog
sub list_member {
    my $app = shift;

    my $blog_id = $app->param('blog_id');
    $app->return_to_dashboard( redirect => 1 )
      unless $blog_id;

    my $blog  = $app->blog;
    my $user  = $app->user;
    my $perms = $app->permissions;
    return $app->return_to_dashboard( permission => 1 )
      unless $user->is_superuser() || ($perms && $perms->can_administer_blog());

    my $super_user = 1 if $user->is_superuser();
    my $args       = {};
    my $terms      = {};
    my $param = { list_noncron => 1 };
    $args->{join} =
      MT::Permission->join_on( 'author_id', { blog_id => $blog_id, } );

    $args->{sort_order} = 'created_on';
    $args->{direction}  = 'descend';

    $param->{saved} = 1 if $app->param('saved');
    $param->{search_label} = $app->translate('Users');
    $param->{object_type} = 'author';

    my $all_perms;
    my @all_perms = @{ MT::Permission->perms() };
    $all_perms = [@all_perms];
    foreach (@$all_perms) {
        $_->[1] = $app->translate( $_->[1] );
    }

    require MT::Association;
    require MT::Role;
    my @all_roles = MT::Role->load( undef, { sort => 'name' });

    my $sel_role = 0;
    my $filter = $app->param('filter') || '';
    if ($filter eq 'role') {
        my $val = scalar $app->param('filter_val');
        if ($val) {
            $sel_role = $val;
            $args->{join} = MT::Association->join_on('author_id', { blog_id => $blog_id, role_id => $val });
        }
    }
    elsif ($filter eq 'status') {
        my $val = $app->param('filter_val');
        if ($val eq 'disabled') {
            $terms->{status} = 2;
        }
        elsif ($val eq 'pending') {
            $terms->{status} = 3;
        }
        else {
            $terms->{status} = 1;
        }
    }

    my @role_loop;
    foreach my $r (@all_roles) {
        push @role_loop, { role_id => $r->id, role_name => $r->name, selected => $r->id == $sel_role };
    }
    $param->{role_loop} = \@role_loop;
    my $hasher = sub {
        my ( $obj, $row ) = @_;
        if ( ( $row->{email} || '' ) !~ m/@/ ) {
            $row->{email} = '';
        }
        if ( $row->{created_by} ) {
            if ( my $created_by = MT::Author->load( $row->{created_by} ) ) {
                $row->{created_by} = $created_by->name;
            }
            else {
                $row->{created_by} = $app->translate('*User deleted*');
            }
        }
        $row->{is_me}           = $row->{id} == $user->id;
        $row->{has_edit_access} = 1 if $super_user;
        $row->{usertype_author} = 1 if $obj->type == MT::Author::AUTHOR();
        if ( $obj->type == MT::Author::COMMENTER() ) {
            $row->{usertype_commenter} = 1;
            $row->{status_trusted} = 1 if $obj->is_trusted($blog_id);
            if ($row->{name} =~ m/^[a-f0-9]{32}$/) {
                $row->{name} = $row->{nickname} || $row->{url};
            }
        }
        $row->{status_enabled} = 1 if $obj->status == 1;
        my @roles = MT::Role->load(undef, { join => MT::Association->join_on('role_id', { author_id => $row->{id}, blog_id => $blog_id }, { unique => 1 })});
        my @role_loop;
        foreach my $role (@roles) {
            my @perms;
            foreach (@$all_perms) {
                next unless length( $_->[1] || '' );
                push @perms, $app->translate( $_->[1] )
                  if $role->has( $_->[0] );
            }
            my $role_perms = join(", ", @perms);
            push @role_loop, { role_name => $role->name, role_id => $role->id, role_perms => $role_perms };
        }
        $row->{role_loop} = \@role_loop;
        $row->{auth_icon_url} = $obj->auth_icon_url;
    };
    $param->{screen_id} = "list-member";

    return $app->listing(
        {
            type     => 'user',
            template => 'list_member.tmpl',
            terms    => $terms,
            params   => $param,
            args     => $args,
            code     => $hasher,
        }
    );
}

sub list_authors {
    my $app = shift;
    my (%param) = @_;

    $app->return_to_dashboard( redirect => 1 )
      if $app->param('blog_id');

    my $this_author = $app->user;
    return $app->return_to_dashboard( permission => 1 )
      unless $this_author->is_superuser();

    my $this_author_id = $this_author->id;
    my $list_pref      = $app->list_pref('author');
    %param             = (%param, %$list_pref);
    my $limit          = $list_pref->{rows};
    my $offset         = $app->param('offset') || 0;
    my $args           = { offset => $offset, sort => 'name' };
    $args->{limit} = $limit + 1;
    my %author_entry_count;
    $param{tab_users} = 1;
    my ( $filter_col, $val );
    $param{filter_args} = "";
    my %terms = ( type => MT::Author::AUTHOR() );

    my $filter_key = $app->param('filter_key');
    if (   ( $filter_col = $app->param('filter') )
        && ( $val = $app->param('filter_val') ) )
    {
        if ( !exists( $terms{$filter_col} ) ) {
            $terms{$filter_col} = $val;
            $param{filter}      = $filter_col;
            $param{filter_val}  = $val;
            $param{filter_args} = "&filter=" . encode_url($filter_col) . "&filter_val=" . encode_url($val);
        }
    } elsif ($filter_key) {
        my $filters = $app->registry("list_filters", "sys_user") || {};
        if ( my $filter = $filters->{$filter_key} ) {
            if ( my $code = $filter->{code}
                || $app->handler_to_coderef( $filter->{handler} ) )
            {
                $param{filter} = 1;
                $param{filter_key}   = $filter_key;
                $param{filter_label} = $filter->{label};
                $code->( \%terms, $args );
            }
        }
    }
    $param{can_create_user}           = $this_author->is_superuser;
    $param{synchronized}              = 1 if $app->param('synchronized');
    $param{error}                     = 1 if $app->param('error');
    my $author_iter = MT::Author->load_iter( \%terms, $args );
    my ( @data, %authors, %entry_count_refs );
    my $entry_class = $app->model('entry');
    while ( my $au = $author_iter->() ) {
        my $row = $au->column_values;
        $row->{name} = '(unnamed)' if !$row->{name};
        $authors{ $au->id } ||= $au;
        $row->{id}    = $au->id;
        $row->{email} = ''
          unless ( !defined $au->email )
          or ( $au->email =~ /@/ );
        $row->{entry_count}          = 0;
        $entry_count_refs{ $au->id } = \$row->{entry_count};
        $row->{is_me}                = $au->id == $this_author_id;
        $row->{has_edit_access}      = $this_author->is_superuser;
        $row->{status_enabled}       = $au->is_active;
        $row->{status_pending}       = $au->status == MT::Author::PENDING();

        if ( $row->{created_by} ) {
            my $parent_author = $authors{ $au->created_by } ||=
              MT::Author->load( $au->created_by )
              if $au->created_by;
            if ($parent_author) {
                $row->{created_by_name} = $parent_author->name;
            }
            else {
                $row->{created_by_name} = $app->translate('(user deleted)');
            }
        }
        push @data, $row;
        last if scalar @data == $limit;
    }
    if ( keys %entry_count_refs ) {
        my $author_entry_count_iter =
          MT::Entry->count_group_by(
            { author_id => [ keys %entry_count_refs ] },
            { group     => ['author_id'] } );
        while ( my ( $count, $author_id ) = $author_entry_count_iter->() ) {
            ${ $entry_count_refs{$author_id} } = $count;
        }
    }
    $param{object_loop} = \@data;
    $param{object_type} = 'author';
    $param{object_label} = $app->model('author')->class_label;
    $param{object_label_plural} = $app->model('author')->class_label_plural;
    if ( $this_author->is_superuser() ) {
        $param{search_label} = $app->translate('Users');
        $param{is_superuser} = 1;
    }

    $param{limit}      = $limit;
    $param{list_start} = $offset + 1;
    delete $args->{limit};
    delete $args->{offset};
    $param{list_total} = MT::Author->count( \%terms, $args );
    $param{list_end}        = $offset + ( scalar @data );
    $param{next_offset_val} = $offset + ( scalar @data );
    $param{next_offset} = $param{next_offset_val} < $param{list_total} ? 1 : 0;
    $param{next_max}    = $param{list_total} - $limit;
    $param{next_max}    = 0 if ( $param{next_max} || 0 ) < $offset + 1;
    if ( $offset > 0 ) {
        $param{prev_offset}     = 1;
        $param{prev_offset_val} = $offset - $limit;
        $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
    }
    $param{offset}            = $offset;
    $param{list_filters}      = $app->list_filters("sys_user");
    $param{list_noncron}      = 1;
    $param{saved_deleted}     = $app->param('saved_deleted');
    $param{saved_removed}     = $app->param('saved_removed');
    $param{author_ldap_found} = $app->param('author_ldap_found');
    $param{saved}             = $app->param('saved');
    my $status = $app->param('saved_status');
    $param{"saved_status_$status"} = 1 if $status;
    $param{unchanged} = $app->param('unchanged');
    $app->load_list_actions( 'author', \%param );
    $param{page_actions} =
      $app->page_actions('list_authors');

    $param{nav_authors} = 1;
    $param{listing_screen} = 1;
    $param{screen_id} = "list-author";
    my $tmpl_file = $param{output} || 'list_author.tmpl';
    $app->load_tmpl( $tmpl_file, \%param );
}

sub make_feed_link {
    my $app = shift;
    my ( $view, $params ) = @_;
    my $user = $app->user;
    return if ( $user->api_password || '' ) eq '';

    $params ||= {};
    $params->{view}     = $view;
    $params->{username} = $user->name;
    $params->{token}    = perl_sha1_digest_hex( 'feed:' . $user->api_password );
    $app->base
      . $app->mt_path
      . $app->config('ActivityFeedScript')
      . $app->uri_params( args => $params );
}

sub build_author_table {
    my $app = shift;
    my (%args) = @_;

    my $i = 1;
    my @author;
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('author');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
    }
    return [] unless $iter;
    my $blog_id = $app->param('blog_id');
    my $param = $args{param};
    $param->{has_edit_access}  = $app->user->is_superuser();
    $param->{is_administrator} = $app->user->is_superuser();
    my ( %blogs, %entry_count_refs );
    while ( my $author = $iter->() ) {
        my $row = {
            name           => $author->name,
            nickname       => $author->nickname,
            email          => $author->email,
            url            => $author->url,
            status_enabled => $author->is_active,
            status_pending => ( $author->status == MT::Author::PENDING() )
            ? 1
            : 0,
            id          => $author->id,
            entry_count => 0,
            is_me => ( $app->user->id == $author->id ? 1 : 0 )
        };
        $entry_count_refs{ $author->id } = \$row->{entry_count};
        if ( $author->created_by ) {
            if ( my $parent_author =
                $app->model('author')->load( $author->created_by ) )
            {
                $row->{created_by} = $parent_author->name;
            }
            else {
                $row->{created_by} = $app->translate('(user deleted)');
            }
        }
        $row->{object} = $author;
        $row->{usertype_author} = 1 if $author->type == MT::Author::AUTHOR();
        if ( $author->type == MT::Author::COMMENTER() ) {
            $row->{usertype_commenter} = 1;
            $row->{status_trusted} = 1 if $blog_id && $author->is_trusted($blog_id);
            if ($row->{name} =~ m/^[a-f0-9]{32}$/) {
                $row->{name} = $row->{nickname} || $row->{url};
            }
        }
        $row->{auth_icon_url} = $author->auth_icon_url;
        push @author, $row;
    }
    return [] unless @author;
    my $type = $app->param('entry_type') || 'entry';
    my $entry_class = $app->model($type);
    my $author_entry_count_iter =
      $entry_class->count_group_by( { author_id => [ keys %entry_count_refs ] },
        { group => ['author_id'] } );
    while ( my ( $count, $author_id ) = $author_entry_count_iter->() ) {
        ${ $entry_count_refs{$author_id} } = $count;
    }
    $param->{author_table}[0]{object_loop} = \@author;

    $app->load_list_actions( 'author', $param->{author_table}[0] );
    $param->{page_actions} = $param->{author_table}[0]{page_actions} =
      $app->page_actions('list_authors');
    $param->{object_loop} = $param->{author_table}[0]{object_loop};

    \@author;
}

sub quickpost_js {
    my $app     = shift;
    my ($type)  = @_;
    my $blog_id = $app->blog->id;
    my %args    = ( '_type' => $type, blog_id => $blog_id, qp => 1 );
    my $uri = $app->base . $app->uri( 'mode' => 'view', args => \%args );
qq!javascript:d=document;w=window;t='';if(d.selection)t=d.selection.createRange().text;else{if(d.getSelection)t=d.getSelection();else{if(w.getSelection)t=w.getSelection()}}void(w.open('$uri&title='+encodeURIComponent(d.title)+'&text='+encodeURIComponent(d.location.href)+encodeURIComponent('<br/><br/>')+encodeURIComponent(t),'_blank','scrollbars=yes,status=yes,resizable=yes,location=yes'))!;
}

sub apply_log_filter {
    my $app = shift;
    my ($param) = @_;
    my %arg;
    if ($param) {
        my $filter_col = $param->{filter};
        my $val        = $param->{filter_val};
        if ( $filter_col && $val ) {
            if ( $filter_col eq 'level' ) {
                my @types;
                for ( 1, 2, 4, 8, 16 ) {
                    push @types, $_ if $val & $_;
                }
                if (@types) {
                    $arg{'level'} = \@types;
                }
            }
            elsif ( $filter_col eq 'class' ) {
                if ($val eq 'publish') {
                    $arg{category} = 'publish';
                }
                else {
                    if ($val =~ m/,/) {
                        $arg{class} = [ split /,/, $val ];
                    } else {
                        $arg{class} = $val;
                    }
                }
            }
        }
        $arg{blog_id} = [ split /,/, $param->{blog_id} ]
          if $param->{blog_id};
    }
    \%arg;
}

sub view_log {
    my $app     = shift;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    my $perms   = $app->permissions;
    if ($blog_id) {
        return $app->error( $app->translate("Permission denied.") )
          unless ( $perms && $perms->can_view_blog_log ) || $user->can_view_log;
    }
    else {
        return $app->error( $app->translate("Permission denied.") )
          unless $user->can_view_log;
    }
    my $log_class  = $app->model('log');
    my $blog_class = $app->model('blog');
    my $list_pref  = $app->list_pref('log');
    my $limit      = $list_pref->{rows};
    my $offset     = $app->param('offset') || 0;
    my $terms      = { $blog_id ? ( blog_id => $blog_id ) : () };
    my $cfg        = $app->config;
    my %param      = (%$list_pref);
    my ( $filter_col, $val );
    $param{filter_args} = "";

    if (   ( $filter_col = $app->param('filter') )
        && ( $val = $app->param('filter_val') ) )
    {
        $param{filter}     = $filter_col;
        $param{filter_val} = $val;
        my %filter_arg = %{ $app->apply_log_filter( \%param ) };
        $terms->{$_} = $filter_arg{$_} foreach keys %filter_arg;
        $param{filter_args} = "&filter=" . encode_url($filter_col) . "&filter_val=" . encode_url($val);
    }

    # all classes of log objects
    unless ( exists $terms->{class} ) {
        $terms->{class} = '*';
    }

    my $iter = $log_class->load_iter(
        $terms,
        {
            'sort'      => 'id',
            'direction' => 'descend',
            'offset'    => $offset,
            'limit'     => $limit
        }
    );

    my @class_loop;
    my $labels = MT::Log->class_labels;
    foreach ( keys %$labels ) {
        next if $_ eq 'log';
        my $name = $_;
        $name =~ s/log\.(\w)/$1/;
        next unless $name;
        push @class_loop,
          {
            class_name  => $name,
            class_label => $labels->{$_},
          };
    }
    push @class_loop,
      {
        class_name  => 'comment,ping',
        class_label => $app->translate("All Feedback"),
      },
      {
        class_name  => 'search',
        class_label => $app->translate("Search"),
      },
      {
        class_name  => 'publish',
        class_label => $app->translate("Publishing"),
      };
    @class_loop = sort { $a->{class_label} cmp $b->{class_label} } @class_loop;
    $param{class_loop} = \@class_loop;

    my $log = $app->build_log_table( iter => $iter, param => \%param );
    my $blog = $blog_class->load($blog_id) if $blog_id;
    my ($so);
    if ($blog) {
        $so = $blog->server_offset;
    }
    else {
        $so = $app->config('TimeOffset');
    }
    if ($so) {
        my $partial_hour_offset = 60 * abs( $so - int($so) );
        my $tz                  = sprintf( "%s%02d:%02d",
            $so < 0 ? '-' : '+',
            abs($so), $partial_hour_offset );
        $param{time_offset} = $tz;
    }
    $param{object_type}     = 'log';
    $param{search_label}    = $app->translate('Activity Log');
    $param{list_start}      = $offset + 1;
    $param{list_total}      = MT::Log->count($terms);
    $param{list_end}        = $offset + ( scalar @$log );
    $param{offset}          = $offset;
    $param{next_offset_val} = $offset + ( scalar @$log );
    $param{next_offset} = $param{next_offset_val} < $param{list_total} ? 1 : 0;
    $param{next_max}    = $param{list_total} - $limit;
    $param{next_max}    = 0 if ( $param{next_max} || 0 ) < $offset + 1;

    if ( $offset > 0 ) {
        $param{prev_offset}     = 1;
        $param{prev_offset_val} = $offset - $limit;
        $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
    }
    $param{'reset'}      = $app->param('reset');
    $param{nav_log}      = 1;
    $param{feed_name}    = $app->translate("System Activity Feed");
    $param{screen_class} = "list-log";
    $param{screen_id} = "list-log";
    $param{listing_screen} = 1;
    $param{feed_url} =
      $app->make_feed_link( 'system',
        $blog_id ? { blog_id => $blog_id } : undef );
    if ( $param{feed_url} && $param{filter_args} ) {
        $param{feed_url} .= $param{filter_args};
    }
    $app->add_breadcrumb( $app->translate('Activity Log') );
    unless ( $app->param('blog_id') ) {
        $param{system_overview_nav} = 1;
    }
    $app->load_tmpl( 'view_log.tmpl', \%param );
}

sub build_log_table {
    my $app = shift;
    my (%args) = @_;

    my $blog       = $app->blog;
    my $blog_view  = $blog ? 1 : 0;
    my $blog_class = $app->model('blog');
    my $i          = 1;
    my @log;
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('log');
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
    my %blogs;
    # reusing comment length constant for log view
    my $break_len = const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_SHORT');
    while ( my $log = $iter->() ) {
        my $msg = $log->message;
        $msg =
          break_up_text( $msg, $break_len )
          ;    # break up really long strings
        my $row = {
            log_message => $msg,
            log_ip      => $log->ip,
            id          => $log->id,
            blog_id     => $log->blog_id
        };
        if ( my $ts = $log->created_on ) {
            if ($blog_view) {
                $row->{created_on_formatted} =
                  format_ts( LISTING_DATETIME_FORMAT,
                    epoch2ts( $blog, ts2epoch( undef, $ts ) ), $blog, $app->user ? $app->user->preferred_language : undef );
            }
            else {
                $row->{created_on_formatted} =
                  format_ts( LISTING_DATETIME_FORMAT,
                    epoch2ts( undef, offset_time( ts2epoch( undef, $ts ) ) ), undef, $app->user ? $app->user->preferred_language : undef );
                if ( $log->blog_id ) {
                    $blog = $blogs{ $log->blog_id } ||=
                      $blog_class->load( $log->blog_id, { cache_ok => 1 } );
                    $row->{weblog_name} = $blog ? $blog->name : '';
                }
                else {
                    $row->{weblog_name} = '';
                }
            }
            $row->{created_on_relative} = relative_date( $ts, time );
            $row->{log_detail} = $log->description;
        }
        if ( my $uid = $log->author_id ) {
            my $user_class = $app->model('author');
            my $user       = $user_class->load($uid);
            $row->{username} = $user->name if defined $user;
        }
        $row->{object} = $log;
        push @log, $row;
    }
    return [] unless @log;
    $param->{object_loop} = $param->{log_table}[0]{object_loop} = \@log;
    \@log;
}

sub reset_log {
    my $app    = shift;
    $app->validate_magic() or return;
    my $author = $app->user;
    my $log_class = $app->model('log');
    if ( my $blog_id = $app->param('blog_id') ) {
        my $perms = $app->permissions;
        return $app->error( $app->translate("Permission denied.") )
          unless $perms && $perms->can_view_log;
        my $blog_class = $app->model('blog');
        my $blog = $blog_class->load( $blog_id )
            or return $app->errtrans("Invalid request.");
        if ( $log_class->remove( { blog_id => $blog_id, class => '*' } ) ) {
            $app->log(
                {
                    message => $app->translate(
"Activity log for blog '[_1]' (ID:[_2]) reset by '[_3]'",
                        $blog->name, $blog_id, $author->name
                    ),
                    level    => MT::Log::INFO(),
                    class    => 'system',
                    category => 'reset_log'
                }
            );
        }
    }
    else {
        return $app->error( $app->translate("Permission denied.") )
          unless $author->can_view_log;
        if ( $log_class->remove( { class => '*' } ) ) {
            $app->log(
                {
                    message => $app->translate(
                        "Activity log reset by '[_1]'",
                        $author->name
                    ),
                    level    => MT::Log::INFO(),
                    class    => 'system',
                    category => 'reset_log'
                }
            );
        }
    }
    $app->add_return_arg( 'reset' => 1 );
    $app->call_return;
}

sub export_notification {
    my $app   = shift;
    my $user  = $app->user;
    my $perms = $app->permissions;
    my $blog  = $app->blog
      or return $app->error( $app->translate("Please select a blog.") );
    return $app->error( $app->translate("Permission denied.") )
      unless $user->is_superuser
      || ( $perms && $perms->can_edit_notifications );
    $app->validate_magic() or return;

    $| = 1;
    my $enc = $app->config('ExportEncoding');
    $enc = $app->config('LogExportEncoding') if ( !$enc );
    $enc = ( $app->charset || '' ) if ( !$enc );

    my $not_class = $app->model('notification');
    my $iter = $not_class->load_iter( { blog_id => $blog->id },
        { 'sort' => 'created_on', 'direction' => 'ascend' } );

    my $file = '';
    $file = dirify( $blog->name ) . '-' if $blog;
    $file = "Blog-" . $blog->id . '-' if $file eq '-';
    $file .= "notifications_list.csv";
    $app->{no_print_body} = 1;
    $app->set_header( "Content-Disposition" => "attachment; filename=$file" );
    $app->send_http_header(
        $enc
        ? "text/csv; charset=$enc"
        : 'text/csv'
    );

    while ( my $note = $iter->() ) {
        $app->print( $note->email );
        $app->print(',');
    }
}

sub show_error {
    my $app  = shift;
    my ($param) = @_;

    # handle legacy scalar error string signature
    $param = { error => $param } unless ref($param) eq 'HASH';

    my $mode = $app->mode;
    if ( $mode eq 'rebuild' ) {

        my $r = MT::Request->instance;
        if (my $tmpl = $r->cache('build_template')) {
            # this is the template that likely caused the rebuild error
            push @{ $param->{button_loop} ||= [] }, {
                link => $app->uri( mode => 'view', args => { blog_id => $tmpl->blog_id, '_type' => 'template', id => $tmpl->id }),
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

sub export_log {
    my $app       = shift;
    my $user      = $app->user;
    my $perms     = $app->permissions;
    my $blog      = $app->blog;
    my $blog_view = $blog ? 1 : 0;
    if ($blog_view) {
        return $app->error( $app->translate("Permission denied.") )
          unless $user->can_view_log || ( $perms && $perms->can_view_blog_log );
    }
    else {
        return $app->error( $app->translate("Permission denied.") )
          unless $user->can_view_log;
    }
    $app->validate_magic() or return;
    $| = 1;
    my $enc = $app->config('ExportEncoding');
    $enc = $app->config('LogExportEncoding') if ( !$enc );
    $enc = ( $app->charset || '' ) if ( !$enc );
    my $blog_enc = $app->config('PublishCharset');

    my $q           = $app->param;
    my $filter_args = $q->param('filter_args');
    my %terms;
    if ($filter_args) {
        $q->parse_params($filter_args) if $filter_args;
        %terms = %{
            $app->apply_log_filter(
                {
                    filter     => $q->param('filter'),
                    filter_val => $q->param('filter_val')
                }
            )
          };
    } else {
        %terms = ( class => '*' );
    }
    if ($blog) {
        $terms{blog_id} = $blog->id;
    }
    my $log_class  = $app->model('log');
    my $blog_class = $app->model('blog');
    my $iter =
      $log_class->load_iter( \%terms,
        { 'sort' => 'created_on', 'direction' => 'ascend' } );
    my %blogs;

    my $file = '';
    $file = dirify( $blog->name ) . '-' if $blog;
    $file = "Blog-" . $blog->id . '-' if $file eq '-';
    my @ts = gmtime(time);
    my $ts = sprintf "%04d-%02d-%02d-%02d-%02d-%02d", $ts[5] + 1900, $ts[4] + 1,
      @ts[ 3, 2, 1, 0 ];
    $file .= "log_$ts.csv";
    $app->{no_print_body} = 1;
    $app->set_header( "Content-Disposition" => "attachment; filename=$file" );
    $app->send_http_header(
        $enc
        ? "text/csv; charset=$enc"
        : 'text/csv'
    );

    my $csv = "timestamp,ip,weblog,message\n";
    while ( my $log = $iter->() ) {

        # columns:
        # date, ip address, weblog, log message
        my @col;
        my $ts = $log->created_on;
        if ($blog_view) {
            push @col,
              format_ts( "%Y-%m-%d %H:%M:%S",
                epoch2ts( $blog, ts2epoch( undef, $ts ) ), $blog, $app->user ? $app->user->preferred_language : undef );
        }
        else {
            push @col, format_ts( "%Y-%m-%d %H:%M:%S", $log->created_on, undef, $app->user ? $app->user->preferred_language : undef );
        }
        push @col, $log->ip;
        my $blog;
        if ( $log->blog_id ) {
            $blog = $blogs{ $log->blog_id } ||=
              $blog_class->load( $log->blog_id );
        }
        if ( $blog ) {
            my $name = $blog->name;
            $name =~ s/"/\\"/gs;
            $name =~ s/[\r\n]+/ /gs;
            $name = encode_text( $name, undef, $enc ) if $enc;
            push @col, '"' . $name . '"';
        }
        else {
            push @col, '';
        }
        my $msg = $log->message;
        $msg = encode_text( $msg, $blog_enc, $enc ) if $enc;
        $msg =~ s/"/\\"/gs;
        $msg =~ s/[\r\n]+/ /gs;
        push @col, '"' . $msg . '"';
        $csv .= ( join ',', @col ) . "\n";
        $app->print($csv);
        $csv = '';
    }
}

sub start_import {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');

    my $perms = $app->permissions;
    return $app->return_to_dashboard( permission => 1 )
      if $perms
      && ( !( $perms->can_edit_config || $perms->can_administer_blog ) );
    my %param;

    # FIXME: This should build a category hierarchy!
    my $cat_class = $app->model('category');
    my $iter = $cat_class->load_iter( { blog_id => $blog_id } );
    my @data;
    while ( my $cat = $iter->() ) {
        push @data,
          {
            category_id    => $cat->id,
            category_label => $cat->label
          };
    }
    @data = sort { $a->{category_label} cmp $b->{category_label} } @data;
    $param{category_loop} = \@data;
    $param{nav_import}    = 1;

    #$param{can_edit_authors} = $app->permissions->can_administer_blog;
    $param{encoding_names} = const('ENCODING_NAMES');
    require MT::Auth;
    $param{password_needed} = MT::Auth->password_exists;

    my $importer_loop = [];
    require MT::Import;
    my $imp  = MT::Import->new;
    my @keys = $imp->importer_keys;
    my ( $mt, $mt_format );
    for my $key (@keys) {
        my $importer = $imp->importer($key);
        $importer->{key} = $key;
        $mt        = $importer, next if $key eq 'import_mt';
        $mt_format = $importer, next if $key eq 'import_mt_format';
        push @$importer_loop,
          {
            label       => $importer->{label},
            key         => $importer->{key},
            description => $importer->{description},
            importer_options_html =>
              $imp->get_options_html( $importer->{key}, $blog_id ),
          };
    }
    push @$importer_loop,
      {
        label       => $mt_format->{label},
        key         => $mt_format->{key},
        description => $mt_format->{description},
        importer_options_html =>
          $imp->get_options_html( $mt_format->{key}, $blog_id ),
      };
    unshift @$importer_loop,
      {
        label                 => $mt->{label},
        key                   => $mt->{key},
        description           => $mt->{description},
        importer_options_html => $imp->get_options_html( $mt->{key}, $blog_id ),
      };

    $param{importer_loop} = $importer_loop;

    if ($blog_id) {
        $param{blog_id} = $blog_id;
        my $blog = $app->model('blog')->load($blog_id);
        $param{text_filters} = $app->load_text_filters( $blog->convert_paras );
    }

    $app->add_breadcrumb( $app->translate('Import/Export') );
    $app->load_tmpl( 'import.tmpl', \%param );
}

sub _populate_archive_loop {
    my $app = shift;
    my ( $blog, $obj ) = @_;

    my $index = $app->config('IndexBasename');
    my $ext = $blog->file_extension || '';
    $ext = '.' . $ext if $ext ne '';

    require MT::TemplateMap;
    my @tmpl_maps = MT::TemplateMap->load( { template_id => $obj->id } );
    my @maps;
    my %types;
    foreach my $map_obj (@tmpl_maps) {
        my $map = {};
        $map->{map_id}           = $map_obj->id;
        $map->{map_is_preferred} = $map_obj->is_preferred;
        my $at = $map->{archive_type} = $map_obj->archive_type;
        $types{$at}++;
        $map->{ 'archive_type_preferred_' . $blog->archive_type_preferred } = 1
          if $blog->archive_type_preferred;
        $map->{file_template} = $map_obj->file_template
          if $map_obj->file_template;

        my $archiver = $app->publisher->archiver($at);
        next unless $archiver;
        $map->{archive_label} = $archiver->archive_label;
        my $tmpls     = $archiver->default_archive_templates;
        my $tmpl_loop = [];
        foreach (@$tmpls) {
            my $name = $_->{label};
            $name =~ s/\.html$/$ext/;
            $name =~ s/index$ext$/$index$ext/;
            push @$tmpl_loop,
              {
                name    => $name,
                value   => $_->{template},
                default => ( $_->{default} || 0 )
              };
        }

        my $custom = 1;

        foreach (@$tmpl_loop) {
            if (   ( !$map->{file_template} && $_->{default} )
                || ( $map->{file_template} eq $_->{value} ) )
            {
                $_->{selected}        = 1;
                $custom               = 0;
                $map->{file_template} = $_->{value}
                  if !$map->{file_template};
            }
        }
        if ($custom) {
            unshift @$tmpl_loop,
              {
                name     => $map->{file_template},
                value    => $map->{file_template},
                selected => 1,
              };
        }

        $map->{archive_tmpl_loop} = $tmpl_loop;
        if (
            1 < MT::TemplateMap->count(
                { archive_type => $at, blog_id => $obj->blog_id }
            )
          )
        {
            $map->{has_multiple_archives} = 1;
        }

        push @maps, $map;
    }
    @maps = sort { archive_type_sorter( $a, $b ) } @maps;
    return \@maps;
}

sub edit_object {
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

    my $enc = $app->config->PublishCharset;
    if ( $q->param('_recover') ) {
        my $sess_obj = $app->autosave_session_obj;
        if ($sess_obj) {
            my $data = $sess_obj->thaw_data;
            if ($data) {

                # XMLHttpRequest always send text in UTF-8... right?
                if ( 'utf-8' eq lc($enc) ) {
                    $q->param( $_, $data->{$_} ) for keys %$data;
                }
                else {
                    foreach ( keys %$data ) {
                        my $encoded =
                          MT::I18N::encode_text( $data->{$_}, 'utf-8', $enc );
                        $q->param( $_, $encoded );
                    }
                }
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
            my $encoded = MT::I18N::encode_text( $data, undef, $enc )
              if $data;
            $q->param( $_, $encoded );
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

        # Set type-specific display parameters
        if ( ( $type eq 'entry' ) || ( $type eq 'page' ) ) {
            return $app->error( $app->translate("Invalid parameter") )
              if $obj->class ne $type;

            $param{nav_entries} = 1;
            $param{entry_edit}  = 1;
            if ( $type eq 'entry' ) {
                $app->add_breadcrumb(
                    $app->translate('Entries'),
                    $app->uri(
                        'mode' => 'list_entries',
                        args   => { blog_id => $blog_id }
                    )
                );
            }
            elsif ( $type eq 'page' ) {
                $app->add_breadcrumb(
                    $app->translate('Pages'),
                    $app->uri(
                        'mode' => 'list_pages',
                        args   => { blog_id => $blog_id }
                    )
                );
            }
            $app->add_breadcrumb( $obj->title
                  || $app->translate('(untitled)') );
            ## Don't pass in author_id, because it will clash with the
            ## author_id parameter of the author currently logged in.
            delete $param{'author_id'};
            unless ( defined $q->param('category_id') ) {
                delete $param{'category_id'};
                if ( my $cat = $obj->category ) {
                    $param{category_id} = $cat->id;
                }
            }
            $blog_id = $obj->blog_id;
            my $blog = $app->model('blog')->load($blog_id);
            my $status = $q->param('status') || $obj->status;
            $param{ "status_" . MT::Entry::status_text($status) } = 1;
            $param{ "allow_comments_"
                  . ( $q->param('allow_comments') || $obj->allow_comments || 0 )
              } = 1;
            $param{'authored_on_date'} = $q->param('authored_on_date')
              || format_ts( "%Y-%m-%d", $obj->authored_on, $blog, $app->user ? $app->user->preferred_language : undef );
            $param{'authored_on_time'} = $q->param('authored_on_time')
              || format_ts( "%H:%M:%S", $obj->authored_on, $blog, $app->user ? $app->user->preferred_language : undef );
            my $comments = $obj->comments;
            my @c_data;
            my $i = 1;
            @$comments = grep { $_->junk_status > -1 } @$comments;
            @$comments = sort { $a->created_on cmp $b->created_on } @$comments;
            my $c_data =
              $app->build_comment_table( items => $comments, param => \%param );
            $param{num_comment_rows} = @$c_data + 3;
            $param{num_comments}     = @$c_data;

            # Check permission to send notifications and if the
            # blog has notification list subscribers
            if (   $perms->can_send_notifications
                && $obj->status == MT::Entry::RELEASE() )
            {
                my $not_class = $app->model('notification');
                $param{can_send_notifications} = 1;
                $param{has_subscribers} =
                  $not_class->count( { blog_id => $blog_id } );
            }

            ## Load list of trackback pings sent for this entry.
            require MT::Trackback;
            require MT::TBPing;
            my $tb = MT::Trackback->load( { entry_id => $obj->id } );
            my $tb_data;
            if ($tb) {
                my $iter = MT::TBPing->load_iter(
                    {
                        tb_id         => $tb->id,
                        'junk_status' => [ 0, 1 ]
                    },
                    {
                        'sort'    => 'created_on',
                        direction => 'descend'
                    }
                );
                $tb_data =
                  $app->build_ping_table( iter => $iter, param => \%param );
            }
            else {
                $tb_data = [];
            }
            $param{num_ping_rows} = @$tb_data + 3;
            $param{num_pings}     = @$tb_data;

            $param{show_pings_tab}    = @$tb_data || $obj->allow_pings;
            $param{show_comments_tab} = @$c_data  || $obj->allow_comments;

            ## Load next and previous entries for next/previous links
            if ( my $next = $obj->next ) {
                $param{next_entry_id} = $next->id;
            }
            if ( my $prev = $obj->previous ) {
                $param{previous_entry_id} = $prev->id;
            }

            $param{has_any_pinged_urls} = ( $obj->pinged_urls || '' ) =~ m/\S/;
            $param{ping_errors}         = $q->param('ping_errors');
            $param{can_view_log}        = $app->user->can_view_log;
            $param{entry_permalink}     = $obj->permalink;
            $param{'mode_view_entry'}   = 1;
            $param{'basename_old'}      = $obj->basename;

            if ( my $ts = $obj->authored_on ) {
                $param{authored_on_ts} = $ts;
                $param{authored_on_formatted} =
                  format_ts( LISTING_DATETIME_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            }

            $app->load_list_actions( $type, \%param );

        }
        elsif ( ( $type eq 'category' ) || ( $type eq 'folder' ) ) {
            $param{nav_categories} = 1;

            #$param{ "tab_" . ( $app->param('tab') || 'details' ) } = 1;

            # $app->add_breadcrumb($app->translate('Categories'),
            #                      $app->uri( 'mode' => 'list_cat',
            #                          args => { blog_id => $obj->blog_id }));
            # $app->add_breadcrumb($obj->label);
            my $parent   = $obj->parent_category;
            my $site_url = $blog->site_url;
            $site_url .= '/' unless $site_url =~ m!/$!;
            $param{path_prefix} =
              $site_url . ( $parent ? $parent->publish_path : '' );
            $param{path_prefix} .= '/' unless $param{path_prefix} =~ m!/$!;
            require MT::Trackback;
            my $tb = MT::Trackback->load( { category_id => $obj->id } );

            if ($tb) {
                my $list_pref = $app->list_pref('ping');
                %param = ( %param, %$list_pref );
                my $path = $app->config('CGIPath');
                $path .= '/' unless $path =~ m!/$!;
                if ($path =~ m!^/!) {
                    my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
                    $path = $blog_domain . $path;
                }

                my $script = $app->config('TrackbackScript');
                $param{tb}     = 1;
                $param{tb_url} = $path . $script . '/' . $tb->id;
                if ( $param{tb_passphrase} = $tb->passphrase ) {
                    $param{tb_url} .= '/' . encode_url( $param{tb_passphrase} );
                }
                $app->load_list_actions( 'ping', $param{ping_table}[0],
                    'pings' );
            }
        }
        elsif ( $type eq 'template' ) {

            # FIXME: Template types should not be enumerated here
            $param{nav_templates} = 1;
            my $tab;
            if ( $obj->type eq 'index' ) {
                $tab = 'index';
                $param{template_group_trans} = $app->translate('index');
            }
            elsif ($obj->type eq 'archive'
                || $obj->type eq 'individual'
                || $obj->type eq 'category'
                || $obj->type eq 'page' )
            {

                # FIXME: enumeration of types
                $tab = 'archive';
                $param{template_group_trans} = $app->translate('archive');
            }
            elsif ( $obj->type eq 'custom' ) {
                $tab = 'module';
                $param{template_group_trans} = $app->translate('module');
            }
            elsif ( $obj->type eq 'widget' ) {
                $tab = 'widget';
                $param{template_group_trans} = $app->translate('widget');
            }
            elsif ( $obj->type eq 'email' ) {
                $tab = 'email';
                $param{template_group_trans} = $app->translate('email');
            }
            else {
                $tab = 'system';
                $param{template_group_trans} = $app->translate('system');
            }
            $param{template_group} = $tab;
            $blog_id = $obj->blog_id;

            # FIXME: enumeration of types
                 $param{has_name} = $obj->type eq 'index'
              || $obj->type eq 'custom'
              || $obj->type eq 'widget'
              || $obj->type eq 'archive'
              || $obj->type eq 'category'
              || $obj->type eq 'page'
              || $obj->type eq 'individual';
            if ( !$param{has_name} ) {
                $param{ 'type_' . $obj->type } = 1;
                $param{name} = $obj->name;
            }
            $app->add_breadcrumb( $param{name} );
            $param{has_outfile} = $obj->type eq 'index';
            $param{has_rebuild} =
              (      ( $obj->type eq 'index' )
                  && ( ( $blog->custom_dynamic_templates || "" ) ne 'all' ) );
            $param{custom_dynamic} =
              $blog && ( $blog->custom_dynamic_templates || "" ) eq 'custom';
            $param{has_build_options} =
              ( $param{custom_dynamic} || $param{has_rebuild} );

            # FIXME: enumeration of types
                 $param{is_special} = $param{type} ne 'index'
              && $param{type} ne 'archive'
              && $param{type} ne 'category'
              && $param{type} ne 'page'
              && $param{type} ne 'individual';
                 $param{has_build_options} = $param{has_build_options}
              && $param{type} ne 'custom'
              && $param{type} ne 'widget'
              && !$param{is_special};
            $param{rebuild_me} =
              defined $obj->rebuild_me ? $obj->rebuild_me : 1;
            $param{search_label} = $app->translate('Templates');
            $param{object_type}  = 'template';
            my $published_url = $obj->published_url;
            $param{published_url} = $published_url if $published_url;
            $param{saved_rebuild} = 1 if $q->param('saved_rebuild');

            $app->load_list_actions( 'template', \%param );

            $obj->compile;
            if ( $obj->{errors} && @{ $obj->{errors} } ) {
                $param{error} = $app->translate(
                    "One or more errors were found in this template.");
                $param{error} .= "<ul>\n";
                foreach my $err ( @{ $obj->{errors} } ) {
                    $param{error} .= "<li>"
                      . MT::Util::encode_html( $err->{message} )
                      . "</li>\n";
                }
                $param{error} .= "</ul>\n";
            }

            # Populate list of included templates
            if ( my $includes = $obj->getElementsByTagName('Include') ) {
                my @includes;
                my @widgets;
                my %seen;
                foreach my $tag (@$includes) {
                    my $include = {};
                    my $mod = $include->{include_module} = $tag->[1]->{module} || $tag->[1]->{widget};
                    next unless $mod;
                    my $type = $tag->[1]->{widget} ? 'widget' : 'custom';
                    next if exists $seen{$type}{$mod};
                    $seen{$type}{$mod} = 1;
                    my $other = MT::Template->load(
                        {
                            blog_id => [ $obj->blog_id, 0 ],
                            name    => $mod,
                            type    => $type,
                        }, {
                            sort      => 'blog_id',
                            direction => 'descend',
                        }
                    );
                    if ($other) {
                        $include->{include_link} = $app->mt_uri(
                            mode => 'view',
                            args => {
                                blog_id => $other->blog_id || 0,
                                '_type' => 'template',
                                id      => $other->id
                            }
                        );
                    }
                    else {
                        $include->{create_link} = $app->mt_uri(
                            mode => 'view',
                            args => {
                                blog_id => $obj->blog_id,
                                '_type' => 'template',
                                type    => $type,
                                name    => $mod,
                            }
                        );
                    }
                    if ($type eq 'widget') {
                        push @widgets, $include;
                    } else {
                        push @includes, $include;
                    }
                }
                $param{include_loop} = \@includes if @includes;
                $param{widget_loop} = \@widgets if @widgets;
            }
            my @sets = ( @{ $obj->getElementsByTagName('WidgetSet') || [] }, @{ $obj->getElementsByTagName('WidgetManager') || [] } );
            if ( @sets ) {
                my @widget_sets;
                my %seen;
                foreach my $set (@sets) {
                    my $name = $set->[1]->{name};
                    next unless $name;
                    next if $seen{$name};
                    $seen{$name} = 1;
                    push @widget_sets, {
                        include_link => $app->mt_uri(
                            mode => 'edit_widget',
                            args => {
                                blog_id => $obj->blog_id,
                                widgetmanager => $name,
                            },
                        ),
                        include_module => $name,
                    };
                }
                $param{widget_set_loop} = \@widget_sets if @widget_sets;
            }
            $param{have_includes} = 1 if $param{widget_set_loop} || $param{include_loop} || $param{widget_loop};
            # Populate archive types for creating new map
            my $obj_type = $obj->type;
            if (   $obj_type eq 'individual'
                || $obj_type eq 'page'
                || $obj_type eq 'author'
                || $obj_type eq 'category'
                || $obj_type eq 'archive' )
            {
                my @at = $app->publisher->archive_types;
                my @archive_types;
                for my $at (@at) {
                    my $archiver      = $app->publisher->archiver($at);
                    my $archive_label = $archiver->archive_label;
                    $archive_label = $at unless $archive_label;
                    $archive_label = $archive_label->()
                      if ( ref $archive_label ) eq 'CODE';
                    if (   ( $obj_type eq 'archive' )
                        || ( $obj_type eq 'author' )
                        || ( $obj_type eq 'category' ) )
                    {

                        # only include if it is NOT an entry-based archive type
                        next if $archiver->entry_based;
                    }
                    elsif ( $obj_type eq 'page' ) {
                        # only include if it is a entry-based archive type and page
                        next unless $archiver->entry_based;
                        next if $archiver->entry_class ne 'page';
                    }
                    elsif ( $obj_type eq 'individual' ) {
                        # only include if it is a entry-based archive type and entry
                        next unless $archiver->entry_based;
                        next if $archiver->entry_class eq 'page';
                    }
                    push @archive_types,
                      {
                        archive_type_translated => $archive_label,
                        archive_type            => $at,
                      };
                    @archive_types =
                      sort { archive_type_sorter( $a, $b ) } @archive_types;
                }
                $param{archive_types} = \@archive_types;

                # Populate template maps for this template
                my $maps = $app->_populate_archive_loop( $blog, $obj );
                $param{object_loop} = $param{template_map_loop} = $maps
                  if @$maps;
            }
        }
        elsif ( $type eq 'blog' ) {
            require MT::IPBanList;
            my $output = $param{output} || '';
            $param{need_full_rebuild}  = 1 if $q->param('need_full_rebuild');
            $param{need_index_rebuild} = 1 if $q->param('need_index_rebuild');
            $param{show_ip_info} = $cfg->ShowIPInformation;
            $param{use_plugins} = $cfg->UsePlugins;

            my $entries_on_index = ( $obj->entries_on_index || 0 );
            if ($entries_on_index) {
                $param{'list_on_index'} = $entries_on_index;
                $param{'posts'}         = 1;
            }
            else {
                $param{'list_on_index'} = ( $obj->days_on_index || 0 );
                $param{'days'} = 1;
            }
            my $lang = $obj->language || 'en';
            $lang = 'en' if lc($lang) eq 'en-us' || lc($lang) eq 'en_us';
            $lang = 'ja' if lc($lang) eq 'jp';
            $param{ 'language_' . $lang } = 1;

            $param{system_allow_comments} = $cfg->AllowComments;
            $param{system_allow_pings}    = $cfg->AllowPings;
            $param{tk_available}          = eval { require MIME::Base64; 1; }
              && eval { require LWP::UserAgent; 1 };
            $param{'auto_approve_commenters'} =
              !$obj->manual_approve_commenters;
            $param{identity_system}     = $app->config('IdentitySystem');
            $param{handshake_return}    = $app->base . $app->mt_uri;
            $param{"moderate_comments"} = $obj->moderate_unreg_comments;
            $param{ "moderate_comments_"
                  . ( $obj->moderate_unreg_comments || 0 ) } = 1;
            $param{ "moderate_pings_" . ( $obj->moderate_pings || 0 ) } = 1;

            my $cmtauth_reg = $app->registry('commenter_authenticators');
            foreach my $auth ( keys %$cmtauth_reg ) {
                $cmtauth_reg->{$auth}->{disabled} = 1
                  if exists( $cmtauth_reg->{$auth}->{condition} )
                  && !( $cmtauth_reg->{$auth}->{condition}->() );
            }
            if ( my $auths = $blog->commenter_authenticators ) {
                foreach ( split ',', $auths ) {
                    if ( 'MovableType' eq $_ ) {
                        $param{enabled_MovableType} = 1;
                    }
                    else {
                        $cmtauth_reg->{$_}->{enabled} = 1;
                    }
                }
            }
            my @cmtauth_loop;
            foreach ( keys %$cmtauth_reg ) {
                $cmtauth_reg->{$_}->{key} = $_;
                if (
                    UNIVERSAL::isa(
                        $cmtauth_reg->{$_}->{plugin}, 'MT::Plugin'
                    )
                  )
                {
                    push @cmtauth_loop, $cmtauth_reg->{$_};
                }
            }
            unshift @cmtauth_loop, $cmtauth_reg->{'TypeKey'}
              if exists( $cmtauth_reg->{'TypeKey'} )
              && $blog->remote_auth_token;
            unshift @cmtauth_loop, $cmtauth_reg->{'Vox'}
              if exists $cmtauth_reg->{'Vox'};
            unshift @cmtauth_loop, $cmtauth_reg->{'LiveJournal'}
              if exists $cmtauth_reg->{'LiveJournal'};
            unshift @cmtauth_loop, $cmtauth_reg->{'OpenID'}
              if exists $cmtauth_reg->{'OpenID'};

            $param{cmtauth_loop} = \@cmtauth_loop;

            if ( $output eq 'cfg_prefs.tmpl' ) {
                $app->add_breadcrumb( $app->translate('General Settings') );

                my $lang = $obj->language || 'en';
                $lang = 'en' if lc($lang) eq 'en-us' || lc($lang) eq 'en_us';
                $lang = 'ja' if lc($lang) eq 'jp';
                $param{ 'language_' . $lang } = 1;

                if ( $obj->cc_license ) {
                    $param{cc_license_name} =
                      MT::Util::cc_name( $obj->cc_license );
                    $param{cc_license_image_url} =
                      MT::Util::cc_image( $obj->cc_license );
                    $param{cc_license_url} =
                      MT::Util::cc_url( $obj->cc_license );
                }
            }
            elsif ( $output eq 'cfg_entry.tmpl' ) {
                ## load entry preferences for new/edit entry page of the blog
                my $pref_param = $app->load_entry_prefs;
                %param = ( %param, %$pref_param );
                $param{ 'sort_order_posts_'
                      . ( $obj->sort_order_posts || 0 ) } = 1;
                $param{ 'status_default_' . $obj->status_default } = 1
                  if $obj->status_default;
                $param{ 'allow_comments_default_'
                      . ( $obj->allow_comments_default || 0 ) } = 1;
                $param{system_allow_pings} =
                  $cfg->AllowPings && $blog->allow_pings;
                $param{system_allow_comments} = $cfg->AllowComments
                  && ( $blog->allow_reg_comments
                    || $blog->allow_unreg_comments );
                my $replace_fields = $blog->smart_replace_fields || '';
                my @replace_fields = split( /,/, $replace_fields );
                foreach my $fld (@replace_fields) {
                    $param{ 'nwc_' . $fld } = 1;
                }
                $param{ 'nwc_smart_replace_' . ( $blog->smart_replace || 0 ) } = 1;
                $param{ 'nwc_replace_none' } = ( $blog->smart_replace || 0 ) == 2;
            }
            elsif ( $output eq 'cfg_web_services.tmpl' ) {
                $param{system_disabled_notify_pings} =
                  $cfg->DisableNotificationPings;
                $param{system_allow_outbound_pings} =
                  $cfg->OutboundTrackbackLimit eq 'any';
                my %selected_pings = map { $_ => 1 }
                  split ',', ($obj->update_pings || '');
                my $pings = $app->registry('ping_servers');
                my @pings;
                push @pings,
                  {
                    key   => $_,
                    label => $pings->{$_}->{label},
                    exists( $selected_pings{$_} ) ? ( selected => 1 ) : (),
                  } foreach keys %$pings;
                $param{pings_loop} = \@pings;
            }
            elsif ( $output eq 'cfg_comments.tmpl' ) {
                $param{email_new_comments_1} =
                  ( $obj->email_new_comments || 0 ) == 1;
                $param{email_new_comments_2} =
                  ( $obj->email_new_comments || 0 ) == 2;
                $param{nofollow_urls}     = $obj->nofollow_urls;
                $param{follow_auth_links} = $obj->follow_auth_links;
                $param{ 'sort_order_comments_'
                      . ( $obj->sort_order_comments || 0 ) } = 1;
                $param{global_sanitize_spec} = $cfg->GlobalSanitizeSpec;
                $param{ 'sanitize_spec_' . ( $obj->sanitize_spec ? 1 : 0 ) } =
                  1;
                $param{sanitize_spec_manual} = $obj->sanitize_spec
                  if $obj->sanitize_spec;
                $param{allow_comments} = $blog->allow_reg_comments
                  || $blog->allow_unreg_comments;
                $param{use_comment_confirmation} =
                  defined $blog->use_comment_confirmation
                  ? $blog->use_comment_confirmation
                  : 0;
                $param{system_allow_comments} = $cfg->AllowComments
                  && ( $blog->allow_reg_comments
                    || $blog->allow_unreg_comments );
                my @cps = MT->captcha_providers;

                foreach my $cp (@cps) {
                    if ( ( $blog->captcha_provider || '' ) eq $cp->{key} ) {
                        $cp->{selected} = 1;
                    }
                }
                $param{captcha_loop} = \@cps;
            }
            elsif ( $output eq 'cfg_trackbacks.tmpl' ) {
                $param{email_new_pings_1} = ( $obj->email_new_pings || 0 ) == 1;
                $param{email_new_pings_2} = ( $obj->email_new_pings || 0 ) == 2;
                $param{nofollow_urls}     = $obj->nofollow_urls;
                $param{system_allow_selected_pings} =
                  $cfg->OutboundTrackbackLimit eq 'selected';
                $param{system_allow_outbound_pings} =
                  $cfg->OutboundTrackbackLimit eq 'any';
                $param{system_allow_local_pings} =
                     ( $cfg->OutboundTrackbackLimit eq 'local' )
                  || ( $cfg->OutboundTrackbackLimit eq 'any' );
            }
            elsif ( $output eq 'cfg_registration.tmpl' ) {
                $param{commenter_authenticators} =
                  $obj->commenter_authenticators;
                my $registration = $cfg->CommenterRegistration;
                if ( $registration->{Allow} ) {
                    $param{registration} =
                      $blog->allow_commenter_regist ? 1 : 0;
                }
                else {
                    $param{system_disallow_registration} = 1;
                }
                $param{allow_reg_comments} = $blog->allow_reg_comments;
                $param{allow_unreg_comments} = $blog->allow_unreg_comments;
                $param{require_typekey_emails} = $obj->require_typekey_emails;
            }
            elsif ( $output eq 'cfg_spam.tmpl' ) {
                my $threshold = $obj->junk_score_threshold || 0;
                $threshold = '+' . $threshold if $threshold > 0;
                $param{junk_score_threshold} = $threshold;
                $param{junk_folder_expiry}   = $obj->junk_folder_expiry || 60;
                $param{auto_delete_junk}     = $obj->junk_folder_expiry;
            }
            elsif ( $output eq 'cfg_archives.tmpl' ) {
                $app->add_breadcrumb( $app->translate('Publishing Settings') );
                if (   $obj->column('archive_path')
                    || $obj->column('archive_url') )
                {
                    $param{enable_archive_paths} = 1;
                    $param{archive_path}         = $obj->column('archive_path');
                    $param{archive_url}          = $obj->column('archive_url');
                }
                else {
                    $param{archive_path} = '';
                    $param{archive_url}  = '';
                }
                $param{ 'archive_type_preferred_'
                      . $blog->archive_type_preferred } = 1
                  if $blog->archive_type_preferred;
                my $at = $blog->archive_type;
                if ( $at && $at ne 'None' ) {
                    my @at = split /,/, $at;
                    for my $at (@at) {
                        $param{ 'archive_type_' . $at } = 1;
                    }
                }
                if ( $blog->publish_queue ) {
                    $param{publish_queue} = 1;
                }
            }
            elsif ( $output eq 'cfg_plugin.tmpl' ) {
                $app->add_breadcrumb( $app->translate('Plugin Settings') );
                $param{blog_view} = 1;
                $app->build_plugin_table(
                    param => \%param,
                    scope => 'blog:' . $blog_id
                );
                $param{can_config} = 1;
            }
            else {
                $app->add_breadcrumb( $app->translate('Settings') );
            }
            ( my $offset = $obj->server_offset ) =~ s![-\.]!_!g;
            $offset =~ s!_0+$!!; # fix syntax highlight ->!
            $param{ 'server_offset_' . $offset } = 1;
            if ( $output eq 'cfg_comments.tmpl' ) {
                ## Load text filters.
                $param{text_filters_comments} =
                  $app->load_text_filters( $obj->convert_paras_comments,
                    'comment' );
            }
            elsif ( $output eq 'cfg_entry.tmpl' ) {
                ## Load text filters.
                $param{text_filters} =
                  $app->load_text_filters( $obj->convert_paras, 'entry' );
            }
            $param{nav_config} = 1;
            $param{error} = $app->errstr if $app->errstr;

        }
        elsif ( $type eq 'ping' ) {
            $param{nav_trackbacks} = 1;
            $app->add_breadcrumb(
                $app->translate('TrackBacks'),
                $app->uri(
                    'mode' => 'list_pings',
                    args   => { blog_id => $blog_id }
                )
            );
            $app->add_breadcrumb( $app->translate('Edit TrackBack') );
            $param{approved}           = $app->param('approved');
            $param{unapproved}         = $app->param('unapproved');
            $param{has_publish_access} = 1 if $app->user->is_superuser;
            $param{has_publish_access} = (
                ( $perms->can_manage_feedback || $perms->can_edit_all_posts )
                ? 1
                : 0
            ) unless $app->user->is_superuser;
            require MT::Trackback;

            if ( my $tb = MT::Trackback->load( $obj->tb_id ) ) {
                if ( $tb->entry_id ) {
                    $param{entry_ping} = 1;
                    require MT::Entry;
                    if ( my $entry = MT::Entry->load( $tb->entry_id ) ) {
                        $param{entry_title} = $entry->title;
                        $param{entry_id}    = $entry->id;
                        unless ( $param{has_publish_access} ) {
                            $param{has_publish_access} =
                              ( $perms->can_publish_post
                                  && ( $app->user->id == $entry->author_id ) )
                              ? 1
                              : 0;
                        }
                    }
                }
                elsif ( $tb->category_id ) {
                    $param{category_ping} = 1;
                    require MT::Category;
                    if ( my $cat = MT::Category->load( $tb->category_id ) ) {
                        $param{category_id}    = $cat->id;
                        $param{category_label} = $cat->label;
                    }
                }
            }

            $param{"ping_approved"} = $obj->is_published
              or $param{"ping_pending"} = $obj->is_moderated
              or $param{"is_junk"}      = $obj->is_junk;

            ## Load next and previous entries for next/previous links
            if ( my $next = $obj->next ) {
                $param{next_ping_id} = $next->id;
            }
            if ( my $prev = $obj->previous ) {
                $param{previous_ping_id} = $prev->id;
            }
            my $parent = $obj->parent;
            if ( $parent && ( $parent->isa('MT::Entry') ) ) {
                if ( $parent->status == MT::Entry::RELEASE() ) {
                    $param{entry_permalink} = $parent->permalink;
                }
            }

            if ( $obj->junk_log ) {
                $app->build_junk_table( param => \%param, object => $obj );
            }

            $param{created_on_time_formatted} =
              format_ts( LISTING_DATETIME_FORMAT, $obj->created_on(), $blog, $app->user ? $app->user->preferred_language : undef );
            $param{created_on_day_formatted} =
              format_ts( LISTING_DATE_FORMAT, $obj->created_on(), $blog, $app->user ? $app->user->preferred_language : undef );

            $param{search_label} = $app->translate('TrackBacks');
            $param{object_type}  = 'ping';

            $app->load_list_actions( $type, \%param );

            # since MT::App::build_page clobbers it:
            $param{source_blog_name} = $param{blog_name};
        }
        elsif ( $type eq 'comment' ) {
            $param{nav_comments} = 1;
            $app->add_breadcrumb(
                $app->translate('Comments'),
                $app->uri(
                    'mode' => 'list_comment',
                    args   => { blog_id => $blog_id }
                )
            );
            $app->add_breadcrumb( $app->translate('Edit Comment') );
            $param{has_publish_access} = 1 if $app->user->is_superuser;
            $param{has_publish_access} = (
                ( $perms->can_manage_feedback || $perms->can_edit_all_posts )
                ? 1
                : 0
            ) unless $app->user->is_superuser;
            if ( my $entry = $obj->entry ) {
                my $title_max_len = const('DISPLAY_LENGTH_EDIT_COMMENT_TITLE');
                $param{entry_title} =
                  ( !defined( $entry->title ) || $entry->title eq '' )
                  ? $app->translate('(untitled)')
                  : $entry->title;
                $param{entry_title} =
                  substr_text( $param{entry_title}, 0, $title_max_len ) . '...'
                  if $param{entry_title}
                  && length_text( $param{entry_title} ) > $title_max_len;
                $param{entry_permalink} = $entry->permalink;
                unless ( $param{has_publish_access} ) {
                    $param{has_publish_access} =
                      ( $perms->can_publish_post
                          && ( $app->user->id == $entry->author_id ) ) ? 1 : 0;
                }
            }
            else {
                $param{no_entry} = 1;
            }
            $param{comment_approved} = $obj->is_published
              or $param{comment_pending} = $obj->is_moderated
              or $param{is_junk}         = $obj->is_junk;

            $param{created_on_time_formatted} =
              format_ts( LISTING_DATETIME_FORMAT, $obj->created_on(), $blog, $app->user ? $app->user->preferred_language : undef );
            $param{created_on_day_formatted} =
              format_ts( LISTING_DATE_FORMAT, $obj->created_on(), $blog, $app->user ? $app->user->preferred_language : undef );

            $param{approved}   = $app->param('approved');
            $param{unapproved} = $app->param('unapproved');
            $param{is_junk}    = $obj->is_junk;

            $param{entry_class_label} = $obj->entry->class_label;
            $param{entry_class} = $obj->entry->class;

            ## Load next and previous entries for next/previous links
            if ( my $next = $obj->next ) {
                $param{next_comment_id} = $next->id;
            }
            if ( my $prev = $obj->previous ) {
                $param{previous_comment_id} = $prev->id;
            }
            if ( $obj->junk_log ) {
                $app->build_junk_table( param => \%param, object => $obj );
            }

            if ( my $cmtr_id = $obj->commenter_id ) {
                my $cmtr = $app->model('author')->load($cmtr_id);
                if ($cmtr) {
                    $param{is_mine} = 1 if $cmtr_id == $app->user->id;
                    $param{commenter_approved} =
                      $cmtr->commenter_status( $obj->blog_id ) ==
                      MT::Author::APPROVED();
                    $param{commenter_banned} =
                      $cmtr->commenter_status( $obj->blog_id ) ==
                      MT::Author::BANNED();
                    $param{type_author} = 1
                      if MT::Author::AUTHOR() == $cmtr->type;
                    $param{commenter_url} = $app->uri(
                        mode => 'view',
                        args => { '_type' => 'author', 'id' => $cmtr->id, }
                      )
                      if ( MT::Author::AUTHOR() == $cmtr->type )
                      && $app->user->is_superuser;
                }
                if ( $obj->email !~ m/@/ ) {    # no email for this commenter
                    $param{email_withheld} = 1;
                }
            }
            $param{invisible_unregistered} = !$obj->visible
              && !$obj->commenter_id;

            $param{search_label} = $app->translate('Comments');
            $param{object_type}  = 'comment';

            my $children =
              $app->build_comment_table( load_args =>
                  [ { parent_id => $obj->id }, { direction => 'descend' } ] );
            $param{object_loop} = $children if @$children;

            $app->load_list_actions( $type, \%param );
        }
        elsif ( $type eq 'author' ) {

            # TODO: Populate permissions / blogs for this user
            # populate blog_loop, permission_loop
            $param{is_me} = 1 if $id == $author->id;
            $param{editing_other_profile} = 1
              if !$param{is_me} && $author->is_superuser;

            $param{userpic} = $obj->userpic_html();

            require MT::Permission;

            # General permissions...
            my $sys_perms = MT::Permission->perms('system');
            foreach (@$sys_perms) {
                $param{ 'perm_can_' . $_->[0] } =
                  ($obj->is_superuser || $obj->permissions(0)->has( $_->[0] )) ? 1 : 0;
            }
            $param{perm_is_superuser} = $obj->is_superuser;

            require MT::Auth;
            if ( $app->user->is_superuser ) {
                $param{search_label} = $app->translate('Users');
                $param{object_type}  = 'author';
                $param{can_edit_username} = 1;
            }
            $param{status_enabled} = $obj->is_active ? 1 : 0;
            $param{status_pending} =
              $obj->status == MT::Author::PENDING() ? 1 : 0;
            $param{can_modify_password} =
              ( $param{editing_other_profile} || $param{is_me} )
              && MT::Auth->password_exists;
            $param{can_recover_password} = MT::Auth->can_recover_password;
            $param{languages} = $app->languages_list( $obj->preferred_language )
              unless exists $param{langauges};
        }
        elsif ( $type eq 'commenter' ) {
            $app->add_breadcrumb(
                $app->translate("Authenticated Commenters"),
                $app->uri(
                    mode => 'list_commenter',
                    args => { blog_id => $blog_id }
                )
            );
            $app->add_breadcrumb( $app->translate("Commenter Details") );
            my $tab = $q->param('tab') || 'commenter';

            # populate the comments / junk comments for this user
            $param{'mode_view_commenter'} = 1;
            if ( $tab eq 'commenter' ) {

                # we need itemset actions for commenters
                $app->load_list_actions( 'commenter', \%param );

                # no native actions for this screen.
                delete $param{list_actions}
                  if exists $param{list_actions};
                $param{has_list_actions} = 1
                  if exists $param{more_list_actions};
                $param{is_email_hidden} = $obj->is_email_hidden;
                $param{status}          = {
                    PENDING  => "pending",
                    APPROVED => "approved",
                    BANNED   => "banned"
                }->{ $obj->commenter_status($blog_id) };
                $param{commenter_approved} =
                  $obj->commenter_status($blog_id) == MT::Author::APPROVED();
                $param{commenter_banned} =
                  $obj->commenter_status($blog_id) == MT::Author::BANNED();
                $param{commenter_url} = $obj->url if $obj->url;
                if ( $app->user->is_superuser()
                  || ($perms && $perms->can_administer_blog ) ) {
                    $param{object_type}   = 'author';
                    $param{search_label}  = $app->translate('Users');
                }
                else {
                    $param{object_type}   = 'entry';
                }
            }
            else {
                my $list_pref = $app->list_pref('comment');
                %param = ( %param, %$list_pref );
                my $limit = $list_pref->{rows};
                my $offset = $q->param('offset') || 0;
                my ( %terms, %arg );
                $terms{commenter_id} = $id;
                if ( $tab eq 'comments' ) {
                    $terms{junk_status} = [ 0, 1 ];
                }
                elsif ( $tab eq 'junk' ) {
                    $terms{junk_status} = -1;
                }
                $arg{offset} = $offset if $offset;
                require MT::Comment;
                my $iter = MT::Comment->load_iter( \%terms, \%arg );
                my $loop = $app->build_comment_table(
                    iter  => $iter,
                    param => \%param
                );
                ## We tried to load $limit + 1 entries above; if we actually got
                ## $limit + 1 back, we know we have another page of entries.
                my $have_next = @$loop > $limit;
                pop @$loop while @$loop > $limit;
                if ($offset) {
                    $param{prev_offset}     = 1;
                    $param{prev_offset_val} = $offset - $limit;
                    $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
                }
                if ($have_next) {
                    $param{next_offset}     = 1;
                    $param{next_offset_val} = $offset + $limit;
                }
                $param{limit}        = $limit;
                $param{offset}       = $offset;
                $param{object_type}  = 'comment';
                $param{search_label} = $app->translate('Comments');
                $param{list_start}   = $offset + 1;
                $param{list_end}     = $offset + scalar @$loop;
                delete $arg{limit};
                delete $arg{offset};
                $param{list_total} = MT::Comment->count( \%terms, \%arg );

                if ( $param{list_total} ) {
                    $param{next_max} = $param{list_total} - $limit;
                    $param{next_max} = 0
                      if ( $param{next_max} || 0 ) < $offset + 1;
                }

                # These are stubs for the commenter-scoped itemset references
                $param{list_actions}      = [];
                $param{more_list_actions} = [];
            }
            $param{"tab_$tab"} = 1;
            $param{screen_class} = ( $tab ne "commenter" ) ? "list-comment" : 0;
            $param{screen_class} .=
              ( $tab eq $type ) ? " edit-${type}" : " edit-${type}-${tab}";
            $param{is_me} = 1 if $obj->id == $app->user->id;
            $param{type_author} = 1
              if MT::Author::AUTHOR() == $obj->type;
        }
        elsif ( $type eq 'asset' ) {
            my $asset_class = $app->model('asset');
            $param{asset} = $obj;
            $param{search_label} = $app->translate('Assets');

            my $hasher = $app->build_asset_hasher;
            $hasher->($obj, \%param, ThumbWidth => 240, ThumbHeight => 240);

            my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
            require MT::Tag;
            my $tags = MT::Tag->join( $tag_delim, $obj->tags );
            $param{tags} = $tags;

            my @related;
            if ($obj->parent) {
                my $parent = $asset_class->load($obj->parent);
                push @related, $hasher->($parent, { asset => $parent, is_parent => 1 });

                push @related, map { $hasher->($_, { asset => $_, is_sibling => 1 }) }
                    $asset_class->search({
                        id     => { op => '!=', value => $obj->id },
                        class  => '*',
                        parent => $obj->parent
                    });
            }
            push @related, map { $hasher->($_, { asset => $_, is_child => 1 }) }
                $asset_class->search({
                    class  => '*',
                    parent => $obj->id,
                });
            $param{related} = \@related if @related;

            my @appears_in;
            my $place_class = $app->model('objectasset');
            my $place_iter = $place_class->load_iter({ asset_id => $obj->id });
            while (my $place = $place_iter->()) {
                my $entry_class = $app->model($place->object_ds);
                my $entry = $entry_class->load($place->object_id);
                my %entry_data = (
                    id    => $place->object_id,
                    class => $entry->class_type,
                    entry => $entry,
                    title => $entry->title,
                );
                if (my $ts = $entry->authored_on) {
                    $entry_data{authored_on_ts} = $ts;
                    $entry_data{authored_on_formatted} =
                      format_ts( LISTING_DATETIME_FORMAT, $ts, undef,
                        $app->user ? $app->user->preferred_language : undef );
                }
                if (my $ts = $entry->created_on) {
                    $entry_data{created_on_ts} = $ts;
                    $entry_data{created_on_formatted} =
                      format_ts( LISTING_DATETIME_FORMAT, $ts, undef,
                        $app->user ? $app->user->preferred_language : undef );
                }
                push @appears_in, \%entry_data;
            }
            if (11 == @appears_in) {    
                pop @appears_in;
                $param{appears_in_more} = 1;
            }
            $param{appears_in} = \@appears_in if @appears_in;

            my $prev_asset = $obj->nextprev(
                direction => 'previous',
                terms     => { class => '*', blog_id => $obj->blog_id },
            );
            my $next_asset = $obj->nextprev(
                direction => 'next',
                terms     => { class => '*', blog_id => $obj->blog_id },
            );
            $param{previous_entry_id} = $prev_asset->id if $prev_asset;
            $param{next_entry_id}     = $next_asset->id if $next_asset;
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
                      format_ts( LISTING_DATETIME_FORMAT, $ts, undef, $app->user ? $app->user->preferred_language : undef );
                }
            }
            if ( my $ts = $obj->created_on ) {
                $param{created_on_ts} = $ts;
                $param{created_on_formatted} =
                  format_ts( LISTING_DATETIME_FORMAT, $ts, undef, $app->user ? $app->user->preferred_language : undef );
            }
        }

        $param{new_object} = 0;
    }
    else {    # object is new
        $param{new_object} = 1;
        for my $col (@$cols) {
            $param{$col} = $q->param($col);
        }
        if ( ( $type eq 'entry' ) || ( $type eq 'page' ) ) {
            $param{entry_edit} = 1;
            if ($blog_id) {
                if ( $type eq 'entry' ) {
                    $app->add_breadcrumb(
                        $app->translate('Entries'),
                        $app->uri(
                            'mode' => 'list_entries',
                            args   => { blog_id => $blog_id }
                        )
                    );
                    $app->add_breadcrumb( $app->translate('New Entry') );
                    $param{nav_new_entry} = 1;
                }
                elsif ( $type eq 'page' ) {
                    $app->add_breadcrumb(
                        $app->translate('Pages'),
                        $app->uri(
                            'mode' => 'list_pages',
                            args   => { blog_id => $blog_id }
                        )
                    );
                    $app->add_breadcrumb( $app->translate('New Page') );
                    $param{nav_new_page} = 1;
                }
            }

            # (if there is no blog_id parameter, this is a
            # bookmarklet post and doesn't need breadcrumbs.)
            delete $param{'author_id'};
            delete $param{'pinged_urls'};
            my $blog_timezone = 0;
            if ($blog_id) {
                my $blog = $blog_class->load($blog_id);
                $blog_timezone = $blog->server_offset();
                if ( $type eq 'entry' ) {

                    # We only use new entry defaults on new entries.
                    my $def_status = $q->param('status')
                      || $blog->status_default;
                    if ($def_status) {
                        $param{ "status_"
                              . MT::Entry::status_text($def_status) } = 1;
                    }
                    $param{
                        'allow_comments_'
                          . (
                            defined $q->param('allow_comments')
                            ? $q->param('allow_comments')
                            : $blog->allow_comments_default
                          )
                      }
                      = 1;
                    $param{allow_comments} = $blog->allow_comments_default
                      unless defined $q->param('allow_comments');
                    $param{allow_pings} = $blog->allow_pings_default
                      unless defined $q->param('allow_pings');
                }
            }

            require POSIX;
            my @now = offset_time_list( time, $blog );
            $param{authored_on_date} = $q->param('authored_on_date')
              || POSIX::strftime( "%Y-%m-%d", @now );
            $param{authored_on_time} = $q->param('authored_on_time')
              || POSIX::strftime( "%H:%M:%S", @now );
        }
        elsif ( $type eq 'author' ) {
            $param{create_personal_weblog} =
              $app->config->NewUserAutoProvisioning ? 1 : 0
              unless exists $param{create_personal_weblog};
            $param{can_modify_password}  = MT::Auth->password_exists;
            $param{can_recover_password} = MT::Auth->can_recover_password;

            # $param{editing_other_profile} = 1;
        }
        elsif ( $type eq 'template' ) {
            my $new_tmpl = $q->param('create_new_template');
            my $template_type;
            if ($new_tmpl) {
                if ( $new_tmpl =~ m/^blank:(.+)/ ) {
                    $template_type = $1;
                    $param{type} = $1;
                }
                elsif ( $new_tmpl =~ m/^default:([^:]+):(.+)/ ) {
                    $template_type = $1;
                    $template_type = 'custom' if $template_type eq 'module';
                    my $template_id = $2;
                    my $set = $blog ? $blog->template_set : undef;
                    require MT::DefaultTemplates;
                    my $def_tmpl = MT::DefaultTemplates->templates($set) || [];
                    my ($tmpl) =
                      grep { $_->{identifier} eq $template_id } @$def_tmpl;
                    $param{text} = $app->translate_templatized( $tmpl->{text} )
                      if $tmpl;
                    $param{type} = $template_type;
                }
            }
            else {
                $template_type = $q->param('type');
                $template_type = 'custom' if 'module' eq $template_type;
                $param{type}   = $template_type;
            }
            return $app->errtrans("Create template requires type")
              unless $template_type;
            $param{nav_templates} = 1;
            my $tab;

            # FIXME: enumeration of types
            if ( $template_type eq 'index' ) {
                $tab = 'index';
                $param{template_group_trans} = $app->translate('index');
            }
            elsif ($template_type eq 'archive'
                || $template_type eq 'individual'
                || $template_type eq 'category'
                || $template_type eq 'page' )
            {
                $tab                         = 'archive';
                $param{template_group_trans} = $app->translate('archive');
                $param{type_archive}         = 1;
                my @types = (
                    {
                        key   => 'archive',
                        label => $app->translate('Archive')
                    },
                    {
                        key   => 'individual',
                        label => $app->translate('Entry or Page')
                    },
                );
                $param{new_archive_types} = \@types;
            }
            elsif ( $template_type eq 'custom' ) {
                $tab = 'module';
                $param{template_group_trans} = $app->translate('module');
            }
            elsif ( $template_type eq 'widget' ) {
                $tab = 'widget';
                $param{template_group_trans} = $app->translate('widget');
            }
            else {
                $tab = 'system';
                $param{template_group_trans} = $app->translate('system');
            }
            $param{template_group} = $tab;
            $app->translate($tab);
            $app->add_breadcrumb( $app->translate('New Template') );

            # FIXME: enumeration of types
                 $param{has_name} = $template_type eq 'index'
              || $template_type eq 'custom'
              || $template_type eq 'widget'
              || $template_type eq 'archive'
              || $template_type eq 'category'
              || $template_type eq 'page'
              || $template_type eq 'individual';
            $param{has_outfile} = $template_type eq 'index';
            $param{has_rebuild} =
              (      ( $template_type eq 'index' )
                  && ( ( $blog->custom_dynamic_templates || "" ) ne 'all' ) );
            $param{custom_dynamic} =
              $blog && $blog->custom_dynamic_templates eq 'custom';
            $param{has_build_options} =
                 $blog && ($blog->custom_dynamic_templates eq 'custom'
              || $param{has_rebuild});

            # FIXME: enumeration of types
                 $param{is_special} = $param{type} ne 'index'
              && $param{type} ne 'archive'
              && $param{type} ne 'category'
              && $param{type} ne 'page'
              && $param{type} ne 'individual';
                 $param{has_build_options} = $param{has_build_options}
              && $param{type} ne 'custom'
              && $param{type} ne 'widget'
              && !$param{is_special};

            $param{rebuild_me} = 1;
            $param{name}       = MT::Util::decode_url( $app->param('name') )
              if $app->param('name');
        }
        elsif ( $type eq 'blog' ) {
            $app->add_breadcrumb( $app->translate('New Blog') );
            ( my $tz = $cfg->DefaultTimezone ) =~ s![-\.]!_!g;
            $tz =~ s!_00$!!; # fix syntax highlight ->!
            $param{ 'server_offset_' . $tz } = 1;
            $param{'can_edit_config'}        = $app->user->can_create_blog;
            $param{'can_set_publish_paths'}  = $app->user->can_create_blog;

            my $sets = $app->registry("template_sets");
            $sets->{$_}{key} = $_ for keys %$sets;
            $sets->{'mt_blog'}{selected} = 1;
            $sets = $app->filter_conditional_list([ values %$sets ]);
            no warnings;
            @$sets = sort { $a->{order} <=> $b->{order} } @$sets;
            $param{'template_set_loop'} = $sets;
            $param{'template_set_index'} = $#$sets;
        }
    }

    # Regardless of whether the obj is new, load data into $param
    if (   ( $type eq 'entry' )
        || ( $type eq 'page' )
        || ( $type eq 'template' ) )
    {

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

    # Regardless of whether the obj is new, load data into $param
    if ( ( $type eq 'entry' ) || ( $type eq 'page' ) ) {
        ## Load categories and process into loop for category pull-down.
        require MT::Placement;
        my $cat_id = $param{category_id};
        my $depth  = 0;
        my %places;

        # set the dirty flag in js?
        $param{dirty} = $q->param('dirty') ? 1 : 0;

        if ($id) {
            my @places =
              MT::Placement->load( { entry_id => $id, is_primary => 0 } );
            %places = map { $_->category_id => 1 } @places;
        }
        my $cats = $q->param('category_ids');
        if ( defined $cats ) {
            if ( my @cats = split /,/, $cats ) {
                $cat_id = $cats[0];
                %places = map { $_ => 1 } @cats;
            }
        }
        if ( $q->param('reedit') ) {
            $param{reedit} = 1;
            if ( !$q->param('basename_manual') ) {
                $param{'basename'} = '';
            }
        }
        if ($blog) {
            $param{file_extension} = $blog->file_extension || '';
            $param{file_extension} = '.' . $param{file_extension}
              if $param{file_extension} ne '';
        }
        else {
            $param{file_extension} = 'html';
        }

        ## Now load user's preferences and customization for new/edit
        ## entry page.
        if ($perms) {
            my $pref_param = $app->load_entry_prefs( $perms->entry_prefs );
            %param = ( %param, %$pref_param );
            $param{disp_prefs_bar_colspan} = $param{new_object} ? 1 : 2;

            # Completion for tags
            my $auth_prefs = $author->entry_prefs;
            if ( my $delim = chr( $auth_prefs->{tag_delim} ) ) {
                if ( $delim eq ',' ) {
                    $param{'auth_pref_tag_delim_comma'} = 1;
                }
                elsif ( $delim eq ' ' ) {
                    $param{'auth_pref_tag_delim_space'} = 1;
                }
                else {
                    $param{'auth_pref_tag_delim_other'} = 1;
                }
                $param{'auth_pref_tag_delim'} = $delim;
            }

            require MT::ObjectTag;
            my $count = MT::Tag->count(
                undef,
                {
                    'join' => MT::ObjectTag->join_on(
                        'tag_id',
                        {
                            blog_id           => $blog_id,
                            object_datasource => MT::Entry->datasource
                        },
                        { unique => 1 }
                    )
                }
            );
            if ( $count > 1000 ) {    # FIXME: Configurable limit?
                $param{defer_tag_load} = 1;
            }
            else {
                require JSON;
                $param{tags_js} =
                  JSON::objToJson(
                    MT::Tag->cache( blog_id => $blog_id, class => 'MT::Entry', private => 1 )
                  );
            }

            $param{can_edit_categories} = $perms->can_edit_categories;
        }

        my $data = $app->_build_category_list(
            blog_id => $blog_id,
            markers => 1,
            type    => $class->container_type,
        );
        my $top_cat = $cat_id;
        my @sel_cats;
        my $cat_tree = [];
        if ( $type eq 'page' ) {
            push @$cat_tree,
              {
                id    => -1,
                label => '/',
                basename => '/',
                path  => [],
              };
            $top_cat ||= -1;
        }
        foreach (@$data) {
            next unless exists $_->{category_id};
            if ( $type eq 'page' ) {
                $_->{category_path_ids} ||= [];
                unshift @{ $_->{category_path_ids} }, -1;
            }
            push @$cat_tree,
              {
                id => $_->{category_id},
                label => $_->{category_label} . ( $type eq 'page' ? '/' : '' ),
                basename => $_->{category_basename} . ( $type eq 'page' ? '/' : '' ),
                path => $_->{category_path_ids} || [],
              };
            push @sel_cats, $_->{category_id}
              if $places{ $_->{category_id} }
              && $_->{category_id} != $cat_id;
        }
        $param{category_tree} = $cat_tree;
        unshift @sel_cats, $top_cat if defined $top_cat && $top_cat ne "";
        $param{selected_category_loop}   = \@sel_cats;
        $param{have_multiple_categories} = scalar @$data > 1;

        $param{basename_limit} = ( $blog ? $blog->basename_limit : 0 ) || 30;

        if ( $q->param('tags') ) {
            $param{tags} = $q->param('tags');
        }
        else {
            if ($obj) {
                my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
                require MT::Tag;
                my $tags = MT::Tag->join( $tag_delim, $obj->tags );
                $param{tags} = $tags;
            }
        }

        ## Load text filters if user displays them
        my %entry_filters;
        if ( defined( my $filter = $q->param('convert_breaks') ) ) {
            $entry_filters{$filter} = 1;
        }
        elsif ($obj) {
            %entry_filters = map { $_ => 1 } @{ $obj->text_filters };
        }
        elsif ($blog) {
            my $cb = $author->text_format || $blog->convert_paras;
            $cb = '__default__' if $cb eq '1';
            $entry_filters{$cb} = 1;
            $param{convert_breaks} = $cb;
        }
        my $filters = MT->all_text_filters;
        $param{text_filters} = [];
        for my $filter ( keys %$filters ) {
            push @{ $param{text_filters} },
              {
                filter_key      => $filter,
                filter_label    => $filters->{$filter}{label},
                filter_selected => $entry_filters{$filter},
                filter_docs     => $filters->{$filter}{docs},
              };
        }
        $param{text_filters} =
          [ sort { $a->{filter_key} cmp $b->{filter_key} }
              @{ $param{text_filters} } ];
        unshift @{ $param{text_filters} },
          {
            filter_key      => '0',
            filter_label    => $app->translate('None'),
            filter_selected => ( !keys %entry_filters ),
          };

        if ($blog) {
            if ( !defined $param{convert_breaks} ) {
                my $cb = $blog->convert_paras;
                $cb = '__default__' if $cb eq '1';
                $param{convert_breaks} = $cb;
            }
            my $ext = ( $blog->file_extension || '' );
            $ext = '.' . $ext if $ext ne '';
            $param{blog_file_extension} = $ext;
        }

        my $rte;
        if ($param{convert_breaks} eq 'richtext') {
            ## Rich Text editor
            $rte = lc($app->config('RichTextEditor'));
        }
        else {
            $rte = 'archetype';
        }
        my $editors = $app->registry("richtext_editors");
        my $edit_reg = $editors->{$rte} || $editors->{archetype};
        my $rich_editor_tmpl;
        if ($rich_editor_tmpl = $edit_reg->{plugin}->load_tmpl($edit_reg->{template})) {
            $param{rich_editor} = $rte;
            $param{rich_editor_tmpl} = $rich_editor_tmpl;
        }

        $param{object_type}  = $type;
        $param{quickpost_js} = $app->quickpost_js($type);
        if ( 'page' eq $type ) {
            $param{search_label} = $app->translate('pages');
            $param{output}       = 'edit_entry.tmpl';
        }
        $param{sitepath_configured} = $blog && $blog->site_path ? 1 : 0;
    }
    elsif ( $type eq 'template' ) {
        my $set = $blog ? $blog->template_set : undef;
        require MT::DefaultTemplates;
        my $tmpls = MT::DefaultTemplates->templates($set);
        my @tmpl_ids;
        foreach my $dtmpl (@$tmpls) {
            if ( !$param{has_name} ) {
                if ($obj->type eq 'email') {
                    if ($dtmpl->{identifier} eq $obj->identifier) {
                        $param{template_name_label} = $dtmpl->{label};
                        $param{template_name}       = $dtmpl->{name};
                    }
                }
                else {
                    if ( $dtmpl->{type} eq $obj->type ) {
                        $param{template_name_label} = $dtmpl->{label};
                        $param{template_name}       = $dtmpl->{name};
                    }
                }
            }
            if ( $dtmpl->{type} eq 'index' ) {
                push @tmpl_ids,
                  {
                    label    => $dtmpl->{label},
                    key      => $dtmpl->{key},
                    selected => $dtmpl->{key} eq
                      ( ( $obj ? $obj->identifier : undef ) || '' ),
                  };
            }
        }
        $param{index_identifiers} = \@tmpl_ids;

        $param{"type_$param{type}"} = 1;
        if ($perms) {
            my $pref_param =
              $app->load_template_prefs( $perms->template_prefs );
            %param = ( %param, %$pref_param );
        }

        # Populate structure for template snippets
        if ( my $snippets = $app->registry('template_snippets') || {} ) {
            my @snippets;
            for my $snip_id ( keys %$snippets ) {
                my $label = $snippets->{$snip_id}{label};
                $label = $label->() if ref($label) eq 'CODE';
                push @snippets,
                  {
                    id      => $snip_id,
                    trigger => $snippets->{$snip_id}{trigger},
                    label   => $label,
                    content => $snippets->{$snip_id}{content},
                  };
            }
            @snippets = sort { $a->{label} cmp $b->{label} } @snippets;
            $param{template_snippets} = \@snippets;
        }

        # Populate structure for tag documentation
        my $all_tags = MT::Component->registry("tags");
        my $tag_docs = {};
        foreach my $tag_set (@$all_tags) {
            my $url = $tag_set->{help_url};
            $url = $url->() if ref($url) eq 'CODE';
            # hey, at least give them a google search
            $url ||= 'http://www.google.com/search?q=mt%t';
            my $tag_list = '';
            foreach my $type (qw( block function )) {
                my $tags = $tag_set->{$type} or next;
                $tag_list .= ($tag_list eq '' ? '' : ',') . join(",", keys(%$tags));
            }
            $tag_list =~ s/(^|,)plugin(,|$)/,/;
            if (exists $tag_docs->{$url}) {
                $tag_docs->{$url} .= ',' . $tag_list;
            }
            else {
                $tag_docs->{$url} = $tag_list;
            }
        }
        $param{tag_docs} = $tag_docs;
        $param{link_doc} = $app->help_url('appendices/tags/');

        # template language
        $param{template_lang} = 'html';
        if ( $obj && $obj->outfile ) {
            if ( $obj->outfile =~ m/\.(css|js|html|php|pl|asp)$/ ) {
                $param{template_lang} = {
                    css => 'css',
                    js => 'javascript',
                    html => 'html',
                    php => 'php',
                    pl => 'perl',
                    asp => 'asp',
                }->{$1};
            }
        }
    }
    elsif ( $type eq 'blog' ) {
        if (   !$param{site_path}
            && !( $param{site_path} = $app->config('DefaultSiteRoot') ) )
        {
            my $cwd = '';
            if ( $ENV{MOD_PERL} ) {
                ## If mod_perl, just use the document root.
                $cwd = $app->{apache}->document_root;
            }
            else {
                $cwd = $ENV{DOCUMENT_ROOT} || $app->mt_dir;
            }
            $cwd = File::Spec->canonpath($cwd);
            $cwd =~ s!([\\/])cgi(?:-bin)?([\\/].*)?$!$1!;
            $cwd =~ s!([\\/])mt[\\/]?$!$1!i;
            $param{suggested_site_path} = $cwd;
        }
        if ( !$param{id} ) {
            if ( $param{site_path} ) {
                $param{site_path} =
                  File::Spec->catdir( $param{site_path}, 'BLOG-NAME' );
            }
            else {
                $param{suggested_site_path} =
                  File::Spec->catdir( $param{suggested_site_path},
                    'BLOG-NAME' );
            }
        }

        # If not yet defined, set the site_url to the config default, if one exists.
        $param{site_url} ||= $app->config('DefaultSiteURL');
        if ( !$param{site_url} ) {
            $param{suggested_site_url} = $app->base . '/';
            $param{suggested_site_url} =~ s!/cgi(?:-bin)?(/.*)?$!/!;
            $param{suggested_site_url} =~ s!/mt/?$!/!i;
        }
        if ( !$param{id} ) {
            if ( $param{site_url} ) {
                $param{site_url} .= '/'
                  unless $param{site_url} =~ /\/$/;
                $param{site_url} .= 'BLOG-NAME/';
            }
            else {
                $param{suggested_site_url} .= '/'
                  unless $param{suggested_site_url} =~ /\/$/;
                $param{suggested_site_url} .= 'BLOG-NAME/';
            }
        }
    }
    elsif ( $type eq 'author' ) {
        $app->add_breadcrumb( $app->translate("Users"),
              $app->user->is_superuser
            ? $app->uri( mode => 'list_authors' )
            : undef );
        my $auth_prefs;
        if ($obj) {
            $app->add_breadcrumb( $obj->name );
            $param{languages} =
              $app->languages_list( $obj->preferred_language );
            $auth_prefs = $obj->entry_prefs;
        }
        else {
            $app->add_breadcrumb( $app->translate("Create User") );
            $param{languages} =
              $app->languages_list( $app->config('DefaultUserLanguage') )
              unless ( exists $param{languages} );
            $auth_prefs = { tag_delim => $app->config->DefaultUserTagDelimiter }
              unless ( exists $param{'auth_pref_tag_delim'} );
        }
        $param{text_filters} =
          $app->load_text_filters( $obj ? $obj->text_format : undef,
            'comment' );
        unless ( exists $param{'auth_pref_tag_delim'} ) {
            my $delim = chr( $auth_prefs->{tag_delim} );
            if ( $delim eq ',' ) {
                $param{'auth_pref_tag_delim_comma'} = 1;
            }
            elsif ( $delim eq ' ' ) {
                $param{'auth_pref_tag_delim_space'} = 1;
            }
            else {
                $param{'auth_pref_tag_delim_other'} = 1;
            }
            $param{'auth_pref_tag_delim'} = $delim;
        }
        $param{'nav_authors'} = 1;
    }
    if ( ( $q->param('msg') || "" ) eq 'nosuch' ) {
        $param{nosuch} = 1;
    }
    for my $p ( $q->param ) {
        $param{$p} = $q->param($p) if $p =~ /^saved/;
    }
    if ( $type eq 'comment' ) {
        my $cmntr = MT::Author->load(
            {
                id   => $obj->commenter_id(),
                type => MT::Author::COMMENTER()
            }
        );
        $param{email_hidden} = $cmntr && $cmntr->is_email_hidden();
        $param{email} = $cmntr ? $cmntr->email : $obj->email;
        $param{comments_script_uri} = $app->config('CommentScript');
        if ( $cmntr && $cmntr->url ) {
            $param{commenter_url} = $cmntr->url;
        }
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
    unless ( $param{screen_class} ) {
        $param{screen_id} = "edit-$type";
        $param{screen_class} = "edit-$type";
        $param{screen_class} .= " edit-entry"
          if $param{object_type} eq "page";  # to piggyback on edit-entry styles
    }
    return $app->load_tmpl( $tmpl_file, \%param );
}

sub CMSTemplateParam_edit_asset {
    my ($cb, $app, $param, $tmpl) = @_;
    my $asset = $param->{asset} or return;
    $asset->edit_template_param(@_);
}

sub load_default_entry_prefs {
    my $app = shift;
    my $prefs;
    require MT::Permission;
    my $blog_id;
    $blog_id = $app->blog->id if $app->blog;
    my $perm = MT::Permission->load( { blog_id => $blog_id, author_id => 0 } );
    my %default = %{ $app->config->DefaultEntryPrefs };
    if ( $perm && $perm->entry_prefs ) {
        $prefs = $perm->entry_prefs;
    }
    else {
        my %default = %{ $app->config->DefaultEntryPrefs };
        if ( lc( $default{type} ) ne 'default' ) {
            $prefs = 'Advanced';
        }
        elsif ( lc( $default{type} ) eq 'custom' ) {
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
                push @p, $map{$p} . ':' . ( $default{$p} || $default{ lc $p } )
                  if ( $default{$p} || $default{ lc $p } );
            }
            $prefs = join ',', @p;
            $prefs ||= 'Custom';
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
                    qw(title body category tags keywords feedback publishing ))
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

sub build_junk_table {
    my $app = shift;
    my (%args) = @_;

    my $param = $args{param};
    my $obj   = $args{object};

    if ( defined $obj->junk_score ) {
        $param->{junk_score} =
          ( $obj->junk_score > 0 ? '+' : '' ) . $obj->junk_score;
    }
    my $log = $obj->junk_log || '';
    my @log = split /\r?\n/, $log;
    my @junk;
    for ( my $i = 0 ; $i < scalar(@log) ; $i++ ) {
        my $line = $log[$i];
        $line =~ s/(^\s+|\s+$)//g;
        next unless $line;
        last if $line =~ m/^--->/;
        my ( $test, $score, $log );
        ($test) = $line =~ m/^([^:]+?):/;
        if ( defined $test ) {
            ($score) = $test =~ m/\(([+-]?\d+?(?:\.\d*?)?)\)/;
            $test =~ s/\(.+\)//;
        }
        if ( defined $score ) {
            $score =~ s/\+//;
            $score .= '.0' unless $score =~ m/\./;
            $score = ( $score > 0 ? '+' : '' ) . $score;
        }
        $log = $line;
        $log =~ s/^[^:]+:\s*//;
        $log = encode_html($log);
        for ( my $j = $i + 1 ; $j < scalar(@log) ; $j++ ) {
            my $line = encode_html( $log[$j] );
            if ( $line =~ m/^\t+(.*)$/s ) {
                $i = $j;
                $log .= "<br />" . $1;
            }
            else {
                last;
            }
        }
        push @junk, { test => $test, score => $score, log => $log };
    }
    $param->{junk_log_loop} = \@junk;
    \@junk;
}

sub CMSViewPermissionFilter_blog {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    if ( $id
        && ( $perms->can_set_publish_paths && !$perms->can_administer_blog ) )
    {
        return 1 if 'view' eq $app->mode;
    }
    if (
        (
            $id && !(
                   $perms->can_edit_config
                || $perms->can_set_publish_paths
                || $perms->can_manage_feedback
            )
        )
        || ( !$id && !$app->user->can_create_blog )
      )
    {
        return 0;
    }
    1;
}

sub CMSViewPermissionFilter_template {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return !$id || ($perms && $perms->can_edit_templates) || (!$app->blog && $app->user->can_edit_templates);
}

sub CMSViewPermissionFilter_page {
    my ( $eh, $app, $id, $objp ) = @_;
    my $perms = $app->permissions;
    if ( !$perms->can_manage_pages ) {
        return 0;
    }
    1;
}

sub CMSViewPermissionFilter_entry {
    my ( $eh, $app, $id, $objp ) = @_;
    my $perms = $app->permissions;
    if (   !$id
        && !$perms->can_create_post )
    {
        return 0;
    }
    if ($id) {
        my $obj = $objp->force();
        if ( !$perms->can_edit_entry( $obj, $app->user ) ) {
            return 0;
        }
    }
    1;
}

sub CMSViewPermissionFilter_author {
    my ( $eh, $app, $id ) = @_;
    return $id && ( $app->user->id == $id );
}

sub CMSViewPermissionFilter_folder {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return $perms->can_manage_pages();
}

sub CMSViewPermissionFilter_category {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return $perms->can_edit_categories();
}

sub CMSViewPermissionFilter_asset {
    my ($eh, $app, $id) = @_;
    my $perms = $app->permissions;
    return $perms->can_edit_assets();
}

sub CMSViewPermissionFilter_commenter {
    my $eh = shift;
    my ( $app, $id ) = @_;
    my $auth = MT::Author->load(
        {
            id   => $id,
            type => MT::Author::COMMENTER()
        }
    );
    $auth ? 1 : 0;
}

sub CMSViewPermissionFilter_comment {
    my $eh = shift;
    my ( $app, $id, $objp ) = @_;
    return 0 unless ($id);
    my $obj = $objp->force() or return 0;
    require MT::Entry;
    my $entry = MT::Entry->load( $obj->entry_id )
      or return 0;
    my $perms = $app->permissions;
    if (
        !(
               $entry->author_id == $app->user->id
            || $perms->can_edit_all_posts
            || $perms->can_manage_feedback
        )
      )
    {
        return 0;
    }
    1;
}

sub CMSViewPermissionFilter_ping {
    my $eh = shift;
    my ( $app, $id, $objp ) = @_;
    my $obj = $objp->force() or return 0;
    require MT::Trackback;
    my $tb    = MT::Trackback->load( $obj->tb_id );
    my $perms = $app->permissions;
    if ($tb) {
        if ( $tb->entry_id ) {
            require MT::Entry;
            my $entry = MT::Entry->load( $tb->entry_id );
            return ( $entry->author_id == $app->user->id
                  || $perms->can_manage_feedback
                  || $perms->can_edit_all_posts );
        }
        elsif ( $tb->category_id ) {
            require MT::Category;
            my $cat = MT::Category->load( $tb->category_id );
            return $cat && $perms->can_edit_categories;
        }
    }
    else {
        return 0;    # no TrackBack center--no edit
    }
}

sub CMSSaveFilter_author {
    my ( $eh, $app ) = @_;

    my $status = $app->param('status');
    return 1 if $status and $status == MT::Author::INACTIVE();

    require MT::Auth;
    my $auth_mode = $app->config('AuthenticationModule');
    my ($pref) = split /\s+/, $auth_mode;

    my $name = $app->param('name');
    if ( $pref eq 'MT' ) {
        if ( defined $name ) {
            $name =~ s/(^\s+|\s+$)//g;
            $app->param( 'name', $name );
        }
        return $eh->error( $app->translate("User requires username") )
          if ( !$name );
    }

    require MT::Author;
    my $existing = MT::Author->load(
        {
            name => $name,
            type => MT::Author::AUTHOR()
        }
    );
    my $id = $app->param('id');
    if ( $existing && ( ( $id && $existing->id ne $id ) || !$id ) ) {
        return $eh->error(
            $app->translate("A user with the same name already exists.") );
    }

    return 1 if ( $pref ne 'MT' );
    if ( !$app->param('id') ) {    # it's a new object
        return $eh->error( $app->translate("User requires password") )
          if ( !$app->param('pass') );
        return $eh->error(
            $app->translate("User requires password recovery word/phrase") )
          if ( !$app->param('hint') );
    }
    return $eh->error(
        MT->translate("Email Address is required for password recovery") )
      unless $app->param('email');
    if ( $app->param('url') ) {
        my $url = $app->param('url');
        return $eh->error( MT->translate("Website URL is imperfect") )
          unless is_url($url);
    }
    1;
}

sub CMSSaveFilter_notification {
    my $eh    = shift;
    my ($app) = @_;
    my $email = lc $app->param('email');
    $email =~ s/(^\s+|\s+$)//gs;
    my $blog_id = $app->param('blog_id');
    if ( !is_valid_email($email) ) {
        return $eh->error(
            $app->translate(
                "The value you entered was not a valid email address")
        );
    }
    require MT::Notification;

    # duplicate check
    my $notification_iter =
      MT::Notification->load_iter( { blog_id => $blog_id } );
    while ( my $obj = $notification_iter->() ) {
        if (   ( lc( $obj->email ) eq $email )
            && ( $obj->id ne $app->param('id') ) )
        {
            return $eh->error(
                $app->translate(
"The e-mail address you entered is already on the Notification List for this blog."
                )
            );
        }
    }
    return 1;
}

sub CMSSaveFilter_banlist {
    my $eh    = shift;
    my ($app) = @_;
    my $ip    = $app->param('ip');
    $ip =~ s/(^\s+|\s+$)//g;
    return $eh->error(
        MT->translate("You did not enter an IP address to ban.") )
      if ( '' eq $ip );
    my $blog_id = $app->param('blog_id');
    require MT::IPBanList;
    my $existing =
      MT::IPBanList->load( { 'ip' => $ip, 'blog_id' => $blog_id } );
    my $id = $app->param('id');

    if ( $existing && ( !$id || $existing->id != $id ) ) {
        return $eh->error(
            $app->translate(
                "The IP you entered is already banned for this blog.")
        );
    }
    return 1;
}

sub CMSSaveFilter_blog {
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
      if ( !( $screen && $perms->can_edit_config )
        && ( defined $app->param('name') && ( $app->param('name') eq '' ) ) );
    return $eh->error( MT->translate("Site URL must be an absolute URL.") )
      if ( $screen eq 'cfg_archives' )
      && $perms->can_set_publish_paths
      && $app->param('site_url') !~ m.^https?://.;
    return $eh->error( MT->translate("Archive URL must be an absolute URL.") )
      if ( $screen eq 'cfg_archives' )
      && $perms->can_set_publish_paths
      && $app->param('archive_url') !~ m.^https?://.
      && $app->param('enable_archive_paths');
    return $eh->error( MT->translate("You did not specify an Archive Root.") )
      if ( $screen eq 'cfg_archives' )
      && $app->param('archive_path') =~ m/^\s*$/
      && $app->param('enable_archive_paths');
    return 1;
}

sub CMSSaveFilter_folder {
    my $eh = shift;
    my ($app) = @_;
    return $app->errtrans( "The name '[_1]' is too long!",
        $app->param('label') )
      if ( length( $app->param('label') ) > 100 );
    return 1;
}

sub CMSSaveFilter_category {
    my $eh = shift;
    my ($app) = @_;
    return $app->errtrans( "The name '[_1]' is too long!",
        $app->param('label') )
      if ( length( $app->param('label') ) > 100 );
    return 1;
}

sub CMSPreSave_ping {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;
    my $perms = $app->permissions;
    return 1
      unless $perms->can_publish_post
      || $perms->can_edit_categories
      || $perms->can_edit_all_posts
      || $perms->can_manage_feedback;

    unless ( $perms->can_edit_all_posts || $perms->can_manage_feedback ) {
        return 1 unless $perms->can_publish_post || $perms->can_edit_categories;
        require MT::Trackback;
        my $tb = MT::Trackback->load( $obj->tb_id );
        if ($tb) {
            if ( $tb->entry_id ) {
                require MT::Entry;
                my $entry = MT::Entry->load( $tb->entry_id );
                return 1
                  unless ( $entry->author_id == $app->user->id )
                  && $perms->can_publish_post;
            }
        }
        elsif ( $tb->category_id ) {
            require MT::Category;
            my $cat = MT::Category->load( $tb->category_id );
            return 1 unless $cat && $perms->can_edit_categories;
        }
    }

    my $status = $app->param('status');
    if ( $status eq 'publish' ) {
        $obj->approve;
        if ( $original->junk_status != $obj->junk_status ) {
            $app->run_callbacks( 'handle_ham', $app, $obj );
        }
    }
    elsif ( $status eq 'moderate' ) {
        $obj->moderate;
        $obj->junk_status(0);
    }
    elsif ( $status eq 'junk' ) {
        $obj->junk;
        if ( $original->junk_status != $obj->junk_status ) {
            $app->run_callbacks( 'handle_spam', $app, $obj );
        }
    }
    return 1;
}

sub CMSPreSave_comment {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;
    my $perms = $app->permissions;
    return 1
      unless $perms->can_publish_post
      || $perms->can_edit_all_posts
      || $perms->can_manage_feedback;

    unless ( $perms->can_edit_all_posts || $perms->can_manage_feedback ) {
        return 1 unless $perms->can_publish_post;
        require MT::Entry;
        my $entry = MT::Entry->load( $obj->entry_id )
          or return 1;
        return 1 unless $entry->author_id == $app->user->id;
    }

    my $status = $app->param('status');
    if ( $status eq 'publish' ) {
        $obj->approve;
        if ( $original->junk_status != $obj->junk_status ) {
            $app->run_callbacks( 'handle_ham', $app, $obj );
        }
    }
    elsif ( $status eq 'moderate' ) {
        $obj->moderate;
        $obj->junk_status(0);
    }
    elsif ( $status eq 'junk' ) {
        $obj->junk;
        if ( $original->junk_status != $obj->junk_status ) {
            $app->run_callbacks( 'handle_spam', $app, $obj );
        }
    }
    return 1;
}

sub CMSPreSave_author {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    # Authors should only be of type AUTHOR when created from
    # the CMS app; COMMENTERs are created from the Comments app.
    $obj->type( MT::Author::AUTHOR() );

    my $pass = $app->param('pass');
    if ($pass) {
        $obj->set_password($pass);
    }
    elsif ( !$obj->id ) {
        $obj->password('(none)');
    }

    my ( $delim, $delim2 ) = $app->param('tag_delim');
    $delim = $delim ? $delim : $delim2;
    if ( $delim =~ m/comma/i ) {
        $delim = ord(',');
    }
    elsif ( $delim =~ m/space/i ) {
        $delim = ord(' ');
    }
    else {
        $delim = ord(',');
    }
    $obj->entry_prefs( 'tag_delim' => $delim );

    unless ( $obj->id ) {
        $obj->created_by( $app->user->id );
    }
    1;
}

sub CMSPreSave_template {
    my $eh = shift;
    my ( $app, $obj ) = @_;

    $obj->rebuild_me(0) 
      if $app->param('current_rebuild_me')
      && !$app->param('rebuild_me');
    $obj->build_dynamic(0)
      if $app->param('current_build_dynamic')
      && !$app->param('build_dynamic');

    ## Strip linefeed characters.
    ( my $text = $obj->text ) =~ tr/\r//d;

    if ($text =~ m/<(MT|_)_trans/i) {
        $text = $app->translate_templatized($text);
    }

    $obj->text($text);

    # update text heights if necessary
    if ( my $perms = $app->permissions ) {
        my $prefs = $perms->template_prefs || '';
        my $text_height = $app->param('text_height');
        if ( defined $text_height ) {
            my ($pref_text_height) = $prefs =~ m/\btext:(\d+)\b/;
            $pref_text_height ||= 0;
            if ( $text_height != $pref_text_height ) {
                if ( $prefs =~ m/\btext\b/ ) {
                    $prefs =~ s/\btext(:\d+)\b/text:$text_height/;
                }
                else {
                    $prefs = 'text:' . $text_height . ',' . $prefs;
                }
            }
        }

        if ( $prefs ne ( $perms->template_prefs || '' ) ) {
            $perms->template_prefs($prefs);
            $perms->save;
        }
    }
    1;
}

sub CMSPreSave_blog {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    if ( !$app->param('overlay')
        && $app->param('cfg_screen') )
    {

        # Checkbox options have to be blanked if they aren't passed.
        my $screen = $app->param('cfg_screen');
        my @fields;
        if ( $screen eq 'cfg_web_services' ) {
        }
        elsif ( $screen eq 'cfg_archives' ) {
            @fields = qw(file_extension);
        }
        elsif ( $screen eq 'cfg_templatemaps' ) {
        }
        elsif ( $screen eq 'cfg_comments' ) {
            @fields = qw( allow_comment_html autolink_urls
              use_comment_confirmation );
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
        elsif ( $screen eq 'cfg_trackbacks' ) {
            @fields = qw( allow_pings moderate_pings
              autodiscover_links internal_autodiscovery );
        }
        elsif ( $screen eq 'cfg_plugins' ) {
        }
        for my $cb (@fields) {
            unless ( defined $app->param($cb) ) {

      # two possibilities: user unchecked the option, or user was not allowed to
      # set the value (and therefore there was no field to submit).
                my $perms = $app->permissions;
                if (
                    $app->user->is_superuser
                    || (
                        $perms
                        && (   $perms->can_administer_blog
                            || $perms->can_edit_config )
                    )
                  )
                {
                    $obj->$cb(0);
                }
                else {
                    delete $obj->{column_values}->{$cb};
                    delete $obj->{changed_cols}->{$cb};
                }
            }
        }
        if ( $screen eq 'cfg_comments' ) {

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
            $obj->nofollow_urls( $app->param('nofollow_urls')         ? 1 : 0 );
            $obj->follow_auth_links( $app->param('follow_auth_links') ? 1 : 0 );
            my $cp_old = $obj->captcha_provider;
            $obj->captcha_provider( $app->param('captcha_provider') );
            my $rebuild = $cp_old ne $obj->captcha_provider ? 1 : 0;
            $app->add_return_arg( need_full_rebuild => 1 ) if $rebuild;
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
        if ( $screen eq 'cfg_entry' ) {
            my %param = $_[0] ? %{ $_[0] } : ();
            my $pref_param = $app->load_entry_prefs;
            %param = ( %param, %$pref_param );
        }
        if ( $screen eq 'cfg_trackbacks' ) {
            if ( my $pings = $app->param('allow_pings') ) {
                if ($pings) {
                    $obj->moderate_pings( $app->param('moderate_pings') );
                    $obj->nofollow_urls( $app->param('nofollow_urls') ? 1 : 0 );
                }
                else {
                    $obj->moderate_pings(1);
                    $obj->email_new_pings(1);
                }
            }
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

            my $c = $app->registry('commenter_authenticators');
            foreach ( keys %$c ) {
                if ( $app->param( 'enabled_' . $_ ) ) {
                    push @authenticators, $_;
                }
            }
            push @authenticators, 'MovableType'
              if $app->param('enabled_MovableType');
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
        if ( $screen eq 'cfg_spam' ) {
            my $threshold = $app->param('junk_score_threshold');
            $threshold =~ s/\+//;
            $threshold ||= 0;
            $obj->junk_score_threshold($threshold);
            if ( my $expiry = $app->param('junk_folder_expiry') ) {
                $obj->junk_folder_expiry($expiry);
            }
            my $perms = $app->permissions;
            unless ( defined $app->param('auto_delete_junk') ) {
                if (
                    $app->user->is_superuser
                    || (
                        $perms
                        && (   $perms->can_administer_blog
                            || $perms->can_edit_config )
                    )
                  )
                {
                    $obj->junk_folder_expiry(0);
                }
                else {
                    delete $obj->{column_values}->{junk_folder_expiry};
                    delete $obj->{changed_cols}->{junk_folder_expiry};
                }
            }
        }
        if ( $screen eq 'cfg_entry' ) {
            my %param = $_[0] ? %{ $_[0] } : ();
            my $pref_param = $app->load_entry_prefs;
            %param = ( %param, %$pref_param );
            $param{ 'sort_order_posts_' . ( $obj->sort_order_posts || 0 ) } = 1;
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
        if ( $screen eq 'cfg_archives' ) {
            if ( my $dcty = $app->param('dynamicity') ) {
                $obj->custom_dynamic_templates($dcty);
            }
            if ( !$app->param('enable_archive_paths') ) {
                $obj->archive_url('');
                $obj->archive_path('');
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

sub CMSPostSave_folder {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    if ( !$original->id ) {
        $app->log(
            {
                message => $app->translate(
                    "Folder '[_1]' created by '[_2]'", $obj->label,
                    $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'folder',
                category => 'new',
            }
        );
    }
    1;
}

sub CMSPostSave_category {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    if ( !$original->id ) {
        $app->log(
            {
                message => $app->translate(
                    "Category '[_1]' created by '[_2]'", $obj->label,
                    $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'category',
                category => 'new',
            }
        );
    }
    1;
}

sub CMSPreSave_folder {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    my $pkg      = $app->model('folder');
    my @siblings = $pkg->load(
        {
            parent  => $obj->parent,
            blog_id => $obj->blog_id
        }
    );
    foreach (@siblings) {
        next if $obj->id && ( $_->id == $obj->id );
        return $eh->error(
            $app->translate(
"The folder '[_1]' conflicts with another folder. Folders with the same parent must have unique basenames.",
                $_->label
            )
        ) if $_->basename eq $obj->basename;
    }
    1;
}

sub CMSPreSave_category {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    my $pkg = $app->model('category');
    if ( defined( my $pass = $app->param('tb_passphrase') ) ) {
        $obj->{__tb_passphrase} = $pass;
    }
    my @siblings = $pkg->load(
        {
            parent  => $obj->parent,
            blog_id => $obj->blog_id
        }
    );
    foreach (@siblings) {
        next if $obj->id && ( $_->id == $obj->id );
        return $eh->error(
            $app->translate(
"The category name '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.",
                $_->label
            )
        ) if $_->label eq $obj->label;
        return $eh->error(
            $app->translate(
"The category basename '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.",
                $_->label
            )
        ) if $_->basename eq $obj->basename;
    }
    1;
}

sub CMSPreSave_page {
    &CMSPreSave_entry;
}

sub _convert_word_chars {
    my ( $app, $s ) = @_;
    return '' unless $s;
    return $s if 'utf-8' ne lc( $app->charset );

    my $blog = $app->blog;
    my $smart_replace = $blog ? $blog->smart_replace
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
    $s =~ s{ <\? xml:namespace [^>]*> }{}xmsg;

    $s;
}

sub _translate_naughty_words {
    my $app = shift;
    my ($entry) = @_;
    my $blog = $app->blog;
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

sub CMSPostSave_page {
    &CMSPostSave_entry;
}

sub CMSPostSave_entry {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    my $sess_obj = $app->autosave_session_obj;
    $sess_obj->remove if $sess_obj;
    1;
}

sub CMSPreSave_entry {
    my $eh = shift;
    my ( $app, $obj ) = @_;

    # save tags
    my $tags = $app->param('tags');
    if ( defined $tags ) {
        my $blog = $app->blog;
        my $fields = $blog->smart_replace_fields;
        if ( $fields =~ m/tags/ig ) {
            $tags = _convert_word_chars( $app, $tags );
        }

        require MT::Tag;
        my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
        my @tags = MT::Tag->split( $tag_delim, $tags );
        if (@tags) {
            $obj->set_tags(@tags);
        }
        else {
            $obj->remove_tags();
        }
    }

    # update text heights if necessary
    if ( my $perms = $app->permissions ) {
        my $prefs = $perms->entry_prefs || $app->load_default_entry_prefs;
        my $text_height = $app->param('text_height');
        if ( defined $text_height ) {
            my ($pref_text_height) = $prefs =~ m/\bbody:(\d+)\b/;
            $pref_text_height ||= 0;
            if ( $text_height != $pref_text_height ) {
                if ( $prefs =~ m/\bbody\b/ ) {
                    $prefs =~ s/\bbody(:\d+)\b/body:$text_height/;
                }
                else {
                    $prefs = 'body:' . $text_height . ',' . $prefs;
                }
            }
        }
        if ( $prefs ne ( $perms->entry_prefs || '' ) ) {
            $perms->entry_prefs($prefs);
            $perms->save;
        }
    }
    $obj->discover_tb_from_entry();
    1;
}

sub CMSPreSave_asset {
    my $eh = shift;
    my ( $app, $obj ) = @_;

    # save tags
    my $tags = $app->param('tags');
    if ( defined $tags ) {
        my $blog = $app->blog;
        my $fields = $blog ? $blog->smart_replace_fields
            : MT->config->NwcReplaceField;
        if ( $fields && $fields =~ m/tags/ig ) {
            $tags = _convert_word_chars( $app, $tags );
        }

        require MT::Tag;
        my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
        my @tags = MT::Tag->split( $tag_delim, $tags );
        if (@tags) {
            $obj->set_tags(@tags);
        }
        else {
            $obj->remove_tags();
        }
    }
    1;
}

sub CMSPostSave_blog {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    my $perms = $app->permissions;
    return 1
      unless $app->user->is_superuser
      || $app->user->can_create_blog
      || ( $perms && $perms->can_edit_config );

    my $screen = $app->param('cfg_screen') || '';
    if ( $screen eq 'cfg_archives' ) {
        if ( my $dcty = $app->param('dynamicity') ) {
            if ( $dcty ne 'none' ) {
                $app->update_dynamicity(
                    $obj,
                    $app->param('dynamic_cache')       ? 1 : 0,
                    $app->param('dynamic_conditional') ? 1 : 0
                );
                $app->rebuild( BlogID => $obj->id, NoStatic => 1 )
                    or return $app->publish_error();
            } else {
                require MT::Template;
                my @tmpls = MT::Template->load({ build_dynamic => 1});
                for my $tmpl (@tmpls) {
                    $tmpl->build_dynamic(0);
                    $tmpl->save;
                }
            }
        }
        $app->cfg_archives_save($obj);
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
    }
    if ( $screen eq 'cfg_entry' ) {
        my $blog_id = $obj->id;

        # FIXME: Needs to exclude MT::Permission records for groups
        my $perms =
          $app->model('permission')
          ->load( { blog_id => $blog_id, author_id => 0 } );
        if ( !$perms ) {
            $perms = $app->model('permission')->new;
            $perms->blog_id($blog_id);
            $perms->author_id(0);
        }
        my $prefs = $app->_entry_prefs_from_params;
        if ($prefs) {
            $perms->entry_prefs($prefs);
            $perms->save
              or return $app->errtrans( "Saving permissions failed: [_1]",
                $perms->errstr );
        }
    }

    if ( !$original->id ) {    # If the object is new, the "orignal" was blank
        ## If this is a new blog, we need to set up a permissions
        ## record for the existing user.
        $obj->create_default_templates( $obj->template_set );

        # Add this blog to the user's "favorite blogs", pushing any 10th
        # blog off the list
        my $auth = $app->user;

        # FIXME: Should we still be doing this?
        my $perms = $app->model('permission')->new;
        $perms->author_id( $auth->id );
        $perms->blog_id( $obj->id );
        $perms->set_full_permissions;
        $perms->save;

        require MT::Log;
        $app->log(
            {
                message => $app->translate(
                    "Blog '[_1]' (ID:[_2]) created by '[_3]'",
                    $obj->name, $obj->id, $auth->name
                ),
                level    => MT::Log::INFO(),
                class    => 'blog',
                category => 'new',
            }
        );

        $app->run_callbacks( 'blog_template_set_change', { blog => $obj } );
    }
    else {

        # if you've changed the comment configuration
        if (
            (
                grep { $original->column($_) ne $obj->column($_) }
                qw(allow_unreg_comments allow_reg_comments remote_auth_token)
            )
          )
        {
            if ( RegistrationAffectsArchives( $obj->id, 'Individual' ) ) {
                $app->add_return_arg( need_full_rebuild => 1 );
            }
            else {
                $app->add_return_arg( need_index_rebuild => 1 );
            }
        }

        # if other settings were changed that would affect published pages:
        if ( grep { $original->column($_) ne $obj->column($_) }
            qw(allow_pings allow_comment_html) )
        {
            $app->add_return_arg( need_full_rebuild => 1 );
        }

        if ( ($original->template_set || '') ne ($obj->template_set || '') ) {
            $app->run_callbacks( 'blog_template_set_change', { blog => $obj } );
            $app->add_return_arg( need_full_rebuild => 1 );
        }
    }
    1;
}

sub RegistrationAffectsArchives {
    my ( $blog_id, $archive_type ) = @_;
    require MT::TemplateMap;
    require MT::Template;
    my @tms = MT::TemplateMap->load(
        {
            archive_type => $archive_type,
            blog_id      => $blog_id
        }
    );
    grep { $_->text =~ /<MT:?IfRegistration/i }
      map { MT::Template->load( $_->template_id ) } @tms;
}

sub CMSPostSave_author {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    if ( !$original->id ) {
        $app->log(
            {
                message => $app->translate(
                    "User '[_1]' (ID:[_2]) created by '[_3]'",
                    $obj->name, $obj->id, $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'author',
                category => 'new',
            }
        );
        $obj->add_default_roles;

        my $author_id = $obj->id;
        if ( $app->param('create_personal_weblog') ) {

            # provision new user with a personal blog
            $app->run_callbacks( 'new_user_provisioning', $obj );
        }
    }
    else {
        if ( $app->user->id == $obj->id ) {
            ## If this is a user editing his/her profile, $id will be
            ## some defined value; if so we should update the user's
            ## cookie to reflect any changes made to username and password.
            ## Otherwise, this is a new user, and we shouldn't update the
            ## cookie.
            $app->user($obj);
            if (   ( $obj->name ne $original->name )
                || ( $app->param('pass') ) )
            {
                $app->start_session();
            }
        }
    }
    1;
}

sub CMSPostSave_comment {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;
    if ( $obj->visible
        || ( ( $obj->visible || 0 ) != ( $original->visible || 0 ) ) )
    {
        $app->rebuild_entry( Entry => $obj->entry_id, BuildIndexes => 1 )
            or return $app->publish_error();
    }
    1;
}

sub CMSPostSave_ping {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;
    require MT::Trackback;
    require MT::Entry;
    require MT::Category;
    if ( my $tb = MT::Trackback->load( $obj->tb_id ) ) {
        my ( $entry, $cat );
        if ( $tb->entry_id && ( $entry = MT::Entry->load( $tb->entry_id ) ) ) {
            if ( $obj->visible
                || ( ( $obj->visible || 0 ) != ( $original->visible || 0 ) ) )
            {
                $app->rebuild_entry( Entry => $entry, BuildIndexes => 1 )
                    or return $app->publish_error();
            }
        }
        elsif ( $tb->category_id
            && ( $cat = MT::Category->load( $tb->category_id ) ) )
        {

            # FIXME: rebuild single category
        }
    }
    1;
}

sub CMSPostSave_trackback {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;
    $app->rebuild_entry( Entry => $obj->entry_id, BuildIndexes => 1 )
        or return $app->publish_error();
    1;
}

sub CMSPostSave_template {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    my $sess_obj = $app->autosave_session_obj;
    $sess_obj->remove if $sess_obj;

    require MT::TemplateMap;
    my $q = $app->param;
    my @p = $q->param;
    for my $p (@p) {
        if ( $p =~ /^archive_tmpl_preferred_(\w+)_(\d+)$/ ) {
            my $at     = $1;
            my $map_id = $2;
            my $map    = MT::TemplateMap->load($map_id);
            $map->prefer( $q->param($p) );    # prefer method saves in itself
        }
        elsif ( $p =~ /^archive_file_tmpl_(\d+)$/ ) {
            my $map_id = $1;
            my $map    = MT::TemplateMap->load($map_id);
            $map->file_template( $q->param($p) );
            $map->save;
        }
    }

    if ( !$original->id ) {
        $app->log(
            {
                message => $app->translate(
                    "Template '[_1]' (ID:[_2]) created by '[_3]'",
                    $obj->name, $obj->id, $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'template',
                category => 'new',
            }
        );
    }

    if ( $obj->build_dynamic ) {
        if ( $obj->type eq 'index' ) {
            $app->rebuild_indexes(
                BlogID   => $obj->blog_id,
                Template => $obj,
                NoStatic => 1,
            ) or return $app->publish_error();    # XXXX
        }
        else {
            $app->rebuild(
                BlogID     => $obj->blog_id,
                TemplateID => $obj->id,
                NoStatic   => 1,
            ) or return $app->publish_error();
        }
    }
    1;
}

sub CMSSavePermissionFilter_blog {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return ( $id
          && ( $perms->can_edit_config || $perms->can_set_publish_paths ) )
      || ( !$id && $app->user->can_create_blog );
}

sub CMSSavePermissionFilter_template {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return ($perms && $perms->can_edit_templates) || (!$perms && $app->user->can_edit_templates);
}

sub CMSSavePermissionFilter_folder {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return $perms->can_manage_pages();
}

sub CMSSavePermissionFilter_category {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return $perms->can_edit_categories();
}

sub CMSSavePermissionFilter_notification {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return $perms->can_edit_notifications;
}

sub CMSSavePermissionFilter_author {
    my ( $eh, $app, $id ) = @_;
    my $author = $app->user;
    if ( !$id ) {
        return $author->is_superuser;
    }
    else {
        return $author->id == $id;
    }
}

sub CMSSavePermissionFilter_comment {
    my ( $eh, $app, $id ) = @_;
    return 0 unless $id;    # Can't create new comments here
    return 1 if $app->user->is_superuser();

    my $perms = $app->permissions;
    return 1
      if $perms
      && ( $perms->can_edit_all_posts
        || $perms->can_manage_feedback );

    my $c = MT::Comment->load($id);
    if ( $perms && $perms->can_create_post && $perms->can_publish_post ) {
        return $c->entry->author_id == $app->user->id;
    }
    elsif ( $perms && $perms->can_create_post ) {
        return ( $c->entry->author_id == $app->user->id )
          && ( ( $c->is_junk && ( 'junk' eq $app->param('status') ) )
            || ( $c->is_moderated && ( 'moderate' eq $app->param('status') ) )
            || ( $c->is_published && ( 'publish' eq $app->param('status') ) ) );
    }
    elsif ( $perms && $perms->can_publish_post ) {
        return 0 unless $c->entry->author_id == $app->user->id;
        return 0
          unless ( $c->text eq $app->param('text') )
          && ( $c->author eq $app->param('author') )
          && ( $c->email  eq $app->param('email') )
          && ( $c->url    eq $app->param('url') );
    }
    else {
        return 0;
    }
}

sub CMSSavePermissionFilter_ping {
    my ( $eh, $app, $id ) = @_;
    return 0 unless $id;    # Can't create new pings here
    return 1 if $app->user->is_superuser();

    my $perms = $app->permissions;
    return 1
      if $perms
      && ( $perms->can_edit_all_posts
        || $perms->can_manage_feedback );
    my $p      = MT::TBPing->load($id);
    my $tbitem = $p->parent;
    if ( $tbitem->isa('MT::Entry') ) {
        if ( $perms && $perms->can_publish_post && $perms->can_create_post ) {
            return $tbitem->author_id == $app->user->id;
        }
        elsif ( $perms->can_create_post ) {
            return ( $tbitem->author_id == $app->user->id )
              && (
                ( $p->is_junk && ( 'junk' eq $app->param('status') ) )
                || ( $p->is_moderated
                    && ( 'moderate' eq $app->param('status') ) )
                || ( $p->is_published
                    && ( 'publish' eq $app->param('status') ) )
              );
        }
        elsif ( $perms && $perms->can_publish_post ) {
            return 0 unless $tbitem->author_id == $app->user->id;
            return 0
              unless ( $p->excerpt eq $app->param('excerpt') )
              && ( $p->blog_name  eq $app->param('blog_name') )
              && ( $p->title      eq $app->param('title') )
              && ( $p->source_url eq $app->param('source_url') );
        }
    }
    else {
        return $perms && $perms->can_edit_categories;
    }
}

sub CMSDeletePermissionFilter_association {
    my ( $eh, $app, $obj ) = @_;

    my $blog_id = $app->param('blog_id');
    my $user    = $app->user;
    if ( !$user->is_superuser ) {
        if ( !$blog_id || !$user->permissions($blog_id)->can_administer_blog ) {
            return $eh->error( MT->translate("Permission denied.") );
        }
        if ( $obj->author_id == $user->id ) {
            return $eh->error(
                MT->translate("You cannot delete your own association.") );
        }
    }
    1;
}

sub CMSDeletePermissionFilter_author {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    if ( $author->id == $obj->id ) {
        return $eh->error(
            MT->translate("You cannot delete your own user record.") );
    }
    return 1 if $author->is_superuser();
    if ( !( $obj->created_by && $obj->created_by == $author->id ) ) {
        return $eh->error(
            MT->translate(
                "You have no permission to delete the user [_1].", $obj->name
            )
        );
    }
}

sub CMSDeletePermissionFilter_blog {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();
    require MT::Permission;
    my $perms = $author->permissions( $obj->id );
    return $perms && $perms->can_administer_blog;
}

sub CMSDeletePermissionFilter_folder {
    my ( $eh, $app, $obj ) = @_;
    return 1 if $app->user->is_superuser();
    my $perms = $app->permissions;
    return $perms && $perms->can_manage_pages();
}

sub CMSDeletePermissionFilter_category {
    my ( $eh, $app, $obj ) = @_;
    return 1 if $app->user->is_superuser();
    my $perms = $app->permissions;
    return $perms && $perms->can_edit_categories();
}

sub CMSDeletePermissionFilter_asset {
    my ( $eh, $app, $obj ) = @_;
    return 1 if $app->user->is_superuser();
    my $perms = $app->permissions;
    return $perms && $perms->can_edit_assets();
}

sub CMSDeletePermissionFilter_comment {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();
    my $perms = $app->permissions;
    require MT::Entry;
    my $entry = MT::Entry->load( $obj->entry_id );
    if ( !$perms || $perms->blog_id != $entry->blog_id ) {
        $perms ||= $author->permissions( $entry->blog_id );
    }

    # publish_post allows entry author to delete comment.
    return 1
      if $perms->can_edit_all_posts
      || $perms->can_manage_feedback
      || $perms->can_edit_entry( $entry, $author, 1 );
    return 0 if $obj->visible;    # otherwise, visible comment can't be deleted.
    return $perms && $perms->can_edit_entry( $entry, $author );
}

sub CMSDeletePermissionFilter_commenter {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();
    my $perms = $author->permissions( $obj->blog_id );
    ( $perms && $perms->can_administer_blog );
}

sub CMSDeletePermissionFilter_page {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();
    my $perms = $app->permissions;
    if ( !$perms || $perms->blog_id != $obj->blog_id ) {
        $perms ||= $author->permissions( $obj->blog_id );
    }
    return $perms && $perms->can_manage_pages;
}

sub CMSDeletePermissionFilter_entry {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();
    my $perms = $app->permissions;
    if ( !$perms || $perms->blog_id != $obj->blog_id ) {
        $perms ||= $author->permissions( $obj->blog_id );
    }
    return $perms && $perms->can_edit_entry( $obj, $author );
}

sub CMSDeletePermissionFilter_ping {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();
    my $perms = $app->permissions;
    require MT::Trackback;
    my $tb = MT::Trackback->load( $obj->tb_id );
    if ( my $entry = $tb->entry ) {
        if ( !$perms || $perms->blog_id != $entry->blog_id ) {
            $perms ||= $author->permissions( $entry->blog_id );
        }

        # publish_post allows entry author to delete comment.
        return 1
          if $perms->can_edit_all_posts
          || $perms->can_manage_feedback
          || $perms->can_edit_entry( $entry, $author, 1 );
        return 0
          if $obj->visible;    # otherwise, visible comment can't be deleted.
        return $perms->can_edit_entry( $entry, $author );
    }
    elsif ( $tb->category_id ) {
        $perms ||= $author->permissions( $tb->blog_id );
        return ( $perms && $perms->can_edit_categories() );
    }
    return 0;
}

sub CMSDeletePermissionFilter_tag {
    my ( $eh, $app, $obj ) = @_;
    return 1 if $app->user->is_superuser();
    my $perms = $app->permissions;
    return 1
      if $app->blog
      && ( $perms->can_administer_blog() || $perms->can_edit_tags );
    return 0;
}

sub CMSDeletePermissionFilter_template {
    my ( $eh, $app, $obj ) = @_;
    return 1 if $app->user->is_superuser();
    my $perms = $app->permissions;
    return ($perms && $perms->can_edit_templates) || (!$perms && $app->user->can_edit_templates);
}

sub CMSPostDelete_blog {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {
            message => $app->translate(
                "Blog '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->name, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'blog',
            category => 'delete'
        }
    );
    $app->_delete_pseudo_association(undef, $obj->id);
}

sub CMSPostDelete_notification {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {
            message => $app->translate(
"Subscriber '[_1]' (ID:[_2]) deleted from address book by '[_3]'",
                $obj->email, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub CMSPostDelete_author {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {
            message => $app->translate(
                "User '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->name, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub CMSPostDelete_folder {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {
            message => $app->translate(
                "Folder '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->label, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub CMSPostDelete_category {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {
            message => $app->translate(
                "Category '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->label, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub CMSPostDelete_comment {
    my ( $eh, $app, $obj ) = @_;

    require MT::Entry;
    my $title = '';
    if ( my $entry = MT::Entry->load( $obj->entry_id ) ) {
        $title = $entry->title;
    }

    $app->log(
        {
            message => $app->translate(
"Comment (ID:[_1]) by '[_2]' deleted by '[_3]' from entry '[_4]'",
                $obj->id, $obj->author, $app->user->name, $title
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub CMSPostDelete_page {
    my ( $eh, $app, $obj ) = @_;

    my $sess_obj = $app->autosave_session_obj;
    $sess_obj->remove if $sess_obj;

    $app->log(
        {
            message => $app->translate(
                "Page '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->title, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub CMSPostDelete_entry {
    my ( $eh, $app, $obj ) = @_;

    my $sess_obj = $app->autosave_session_obj;
    $sess_obj->remove if $sess_obj;

    $app->log(
        {
            message => $app->translate(
                "Entry '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->title, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub CMSPostDelete_ping {
    my ( $eh, $app, $obj ) = @_;

    my ( $message, $title );
    my $obj_parent = $obj->parent();
    if ( $obj_parent->isa('MT::Category') ) {
        $title = $obj_parent->label || $app->translate('(Unlabeled category)');
        $message =
          $app->translate(
            "Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from category '[_4]'",
            $obj->id, $obj->blog_name, $app->user->name, $title );
    }
    else {
        $title = $obj_parent->title || $app->translate('(Untitled entry)');
        $message =
          $app->translate(
            "Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from entry '[_4]'",
            $obj->id, $obj->blog_name, $app->user->name, $title );
    }

    $app->log(
        {
            message  => $message,
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub CMSPostDelete_template {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {
            message => $app->translate(
                "Template '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->name, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub CMSPostDelete_tag {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {
            message => $app->translate(
                "Tag '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->name, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub CMSPostSave_asset {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    if ( !$original->id ) {
        $app->log(
            {
                message => $app->translate(
                    "File '[_1]' uploaded by '[_2]'", $obj->file_name,
                    $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'asset',
                category => 'new',
            }
        );
    }
    1;
}

sub CMSPostDelete_asset {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {
            message => $app->translate(
                "File '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->file_name, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'asset',
            category => 'delete'
        }
    );
}

sub autosave_session_obj {
    my $app           = shift;
    my ($or_make_one) = @_;
    my $q             = $app->param;
    my $type          = $q->param('_type');
    return unless $type;
    my $id = $q->param('id');
    $id = '0' unless $id;
    my $ident =
      'autosave' . ':user=' . $app->user->id . ':type=' . $type . ':id=' . $id;

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

sub save_object {
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
          $app->languages_list( $q->param('preferred_language') )
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
            return $app->list_objects( \%param );
        }
        elsif ( ( $app->param('cfg_screen') || '' ) eq 'cfg_archives' ) {
            return $app->cfg_archives( \%param );
        }
        else {
            return $app->forward( 'edit', \%param );
        }
    }

    return $app->errtrans(
        'The Template Name and Output File fields are required.')
      if $type eq 'template' && !$q->param('name') && !$q->param('outfile');

    if ( $type eq 'author' ) {
        ## If we are saving a user profile, we need to do some
        ## password maintenance. First make sure that the two
        ## passwords match...
        my $editing_other_profile;
        if ( $id && ( $author->id != $id ) && ( $author->is_superuser ) ) {
            $editing_other_profile = 1;
        }
        my %param = (%$param);
        unless ($editing_other_profile) {
            require MT::Auth;
            my $error = MT::Auth->sanity_check($app);
            if ($error) {
                $param{error} = $error;
                require MT::Log;
                $app->log(
                    {
                        message  => $error,
                        level    => MT::Log::ERROR(),
                        class    => 'system',
                        category => 'save_author_profile'
                    }
                );
            }
            if ( $param{error} ) {
                $param{return_args} = $app->param('return_args');
                my $qual = $id ? '' : 'author_state_';
                for my $f (qw( name nickname email url state )) {
                    $param{ $qual . $f } = $q->param($f);
                }
                return $app->edit_object( \%param );
            }
        }
    }

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
        $obj = $class->load($id);
    }
    else {
        $obj = $class->new;
    }

    my $original = $obj->clone();
    my $names    = $obj->column_names;
    my %values   = map { $_ => ( scalar $q->param($_) ) } @$names;

    if ( $type eq 'blog' ) {
        unless ( $author->is_superuser
            || ( $perms && $perms->can_administer_blog ) )
        {
            if ( $id && !( $perms->can_set_publish_paths ) ) {
                delete $values{site_url};
                delete $values{site_path};
                delete $values{archive_url};
                delete $values{archive_path};
            }
            if ( $id && !( $perms->can_edit_config ) ) {
                delete $values{$_} foreach grep {
                         $_ ne 'site_path'
                      && $_ ne 'site_url'
                      && $_ ne 'archive_path'
                      && $_ ne 'archive_url'
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
                    if ( defined($q->param('is_superuser'))
                      && $q->param('is_superuser')) {
                        $obj->is_superuser(1);
                    }
                    else {
                        foreach (@$sys_perms) {
                            my $name = 'can_' . $_->[0];
                            $name = 'is_superuser' if $name eq 'can_administer';
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

    if ( $type eq 'blog' ) {
        # If this is a new blog, set the preferences, archive settings
        # and template set to the defaults.
        if ( !$obj->id ) {
            $obj->language( $app->user->preferred_language );
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
            my $set = $app->param('template_set') || 'mt_blog';
            $obj->template_set( $set );
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
            if ( $meth && $app->can($meth) ) {
                $app->error(
                    $app->translate( "Save failed: [_1]", $app->errstr ) );
                return $app->$meth;
            }
        }
        return $app->edit_object(
            {
                %$param,
                error => $app->translate( "Save failed: [_1]", $app->errstr )
            }
        );
    }

    # Done pre-processing the record-to-be-saved; now save it.

    $obj->touch() if ( $type eq 'blog' );

    $obj->save
      or return $app->error(
        $app->translate( "Saving object failed: [_1]", $obj->errstr ) );

    # Now post-process it.
    $app->run_callbacks( 'cms_post_save.' . $type, $app, $obj, $original )
      or return $app->error( $app->errstr() );

    # Save NWC settings
    my $screen = $q->param('cfg_screen') || '';
    if ( $type eq 'blog' && $screen eq 'cfg_entry' ) {
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
    if ( $type eq 'blog' ) {
        $blog_id = $obj->id;
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
        if ( $cfg_screen eq 'cfg_templatemaps' ) {
            $cfg_screen = 'cfg_archives';
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
        $q->param( 'type',            'index-' . $obj->id );
        $q->param( 'tmpl_id',         $obj->id );
        $q->param( 'single_template', 1 );
        return $app->start_rebuild_pages();
    }
    elsif ( $type eq 'blog' ) {
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

sub list_template {
    my $app = shift;

    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    return $app->return_to_dashboard( redirect => 1 )
      unless $perms || $app->user->is_superuser;
    if ( $perms && !$perms->can_edit_templates ) {
        return $app->return_to_dashboard( permission => 1 );
    }

    require MT::Template;
    my $blog_id = $app->param('blog_id') || 0;
    my $filter  = $app->param('filter_key');
    if ( !$filter ) {
        if ($app->blog) {
            $filter = 'index_templates';
            $app->param( 'filter_key', 'index_templates' );
        }
        else {
            $filter = 'module_templates';
            $app->param( 'filter_key', 'module_templates' );
        }
    }
    else {
        # global index templates redirect to module templates
        if ( !$app->blog && $filter eq 'index_templates' ) {
            $filter = 'module_templates';
            $app->param( 'filter_key', 'module_templates' );
        }
    }
    my $terms = { blog_id => $blog_id };
    my $args  = { sort    => 'name' };

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        my $template_type;
        my $type = $row->{type} || '';
        if ( $type =~ m/^(individual|page|category|archive)$/ ) {
            $template_type = 'archive';
        }
        elsif ( $type eq 'widget' ) {
            $template_type = 'widget';
        }
        elsif ( $type eq 'index' ) {
            $template_type = 'index';
        }
        elsif ( $type eq 'custom' ) {
            $template_type = 'module';
        }
        elsif ( $type eq 'email' ) {
            $template_type = 'email';
        }
        elsif ( $type eq 'backup' ) {
            $template_type = 'backup';
        }
        else {
            $template_type = 'system';
        }
        $row->{template_type} = $template_type;
        $row->{type} = 'entry' if $type eq 'individual';
        my $published_url = $obj->published_url;
        $row->{published_url} = $published_url if $published_url;
    };

    my $params        = {};
    my $template_type = $filter;
    $template_type =~ s/_templates//;
    my $template_type_label = $app->translate($template_type);
    if ( $template_type_label eq $template_type ) {
        $template_type_label = "\u$template_type";
    }
    $params->{template_type}       = $template_type;
    $params->{template_type_label} = $template_type_label;

    #@tt_loop = sort { $a->{label} cmp $b->{label} } @tt_loop;
    #$params->{template_type_loop} = \@tt_loop;

    $app->load_list_actions( 'template', $params );
    $params->{page_actions} = $app->page_actions('list_templates');
    $params->{search_label} = $app->translate("Templates");
    $params->{blog_view} = 1;
    $params->{refreshed} = $app->param('refreshed');
    $params->{published} = $app->param('published');

    return $app->listing(
        {
            type     => 'template',
            terms    => $terms,
            args     => $args,
            params   => $params,
            no_limit => 1,
            code     => $hasher,
        }
    );
}

sub list_objects {
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
    if (
        $perms
        && (   ( $type eq 'blog' && !$perms->can_edit_config )
            || ( $type eq 'template'     && !$perms->can_edit_templates )
            || ( $type eq 'notification' && !$perms->can_edit_notifications ) )
      )
    {
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
        my $row = $obj->column_values;
        if ( my $ts = $obj->created_on ) {
            $row->{created_on_formatted} =
              format_ts( LISTING_DATE_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_time_formatted} =
              format_ts( LISTING_DATETIME_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );
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
            my $entry     = MT::Entry->load( $tb_center->entry_id );
            if ( my $ts = $obj->created_on ) {
                $row->{created_on_time_formatted} =
                  format_ts( LISTING_DATETIME_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );
                $row->{has_edit_access} = $perms->can_edit_all_posts
                  || $app->user->id == $entry->author_id;
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
        my $blog = $blog_class->load( scalar $q->param('blog_id') );
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
        my $blog = $blog_class->load($blog_id);
        $app->add_breadcrumb( $app->translate('IP Banning') );
        $param{nav_config}                       = 1;
        $param{object_type}                      = 'banlist';
        $param{show_ip_info}                     = 1;
        $param{list_noncron}                     = 1;
        $param{search_type} = 'entry';
        $param{can_edit_config_or_publish_paths} = $perms->can_edit_config
          || $perms->can_set_publish_paths;
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
    unless ( $param{screen_class} ) {
        $param{screen_class} = "list-$type";
    }
    $app->load_tmpl( "list_${type}.tmpl", \%param );
}

sub _delete_pseudo_association {
    my $app = shift;
    my ($pid, $bid) = @_;
    my $rid;
    if ($pid) {
        ( my $pseudo, $rid, $bid ) = split '-', $pid;
    }
    my @newdef;
    if ( my $def = $app->config->DefaultAssignments ) {
        my @def = split ',', $def;
        while ( my $role_id = shift @def ) {
            my $blog_id = shift @def;
            next unless $role_id && $blog_id;
            next
              if ( $rid && ( $role_id == $rid ) && ( $blog_id == $bid ) )
                || ( !defined($rid) && ( $blog_id == $bid ) );
            push @newdef, "$role_id,$blog_id";
        }
    }
    if (@newdef) {
        $app->config( 'DefaultAssignments', join( ',', @newdef ), 1 );
    }
    else {
        $app->config( 'DefaultAssignments', undef, 1 );
    }
    $app->config->save_config;
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
    for my $id ( $q->param('id') ) {
        next unless $id;    # avoid 'empty' ids
        if ( ( $type eq 'association' ) && ( $id =~ /PSEUDO-/ ) ) {
            $app->_delete_pseudo_association($id);
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
            if ($blog_id) {
                my $ot_class  = $app->model('objecttag');
                my $obj_type  = $q->param('__type') || 'entry';
                my $obj_class = $app->model($obj_type);
                my $iter      = $ot_class->load_iter(
                    {
                        blog_id           => $blog_id,
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
            my @kids = MT::Category->load( { parent => $id } );
            return $app->errtrans(
"You can't delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one."
            ) if @kids;
            if ( $app->config('DeleteFilesAtRebuild') ) {
                require MT::Blog;
                require MT::Entry;
                require MT::Placement;
                my $blog = MT::Blog->load($blog_id);
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
                                            { unqiue      => 1 }
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
        elsif ( $type eq 'entry' ) {
            if ( $app->config('DeleteFilesAtRebuild') ) {
                $app->publisher->remove_entry_archive_file(
                    Entry       => $obj,
                    ArchiveType => 'Individual'
                );
                require MT::Blog;
                my $blog = MT::Blog->load($blog_id);
                my $at   = $blog->archive_type;
                if ( $at && $at ne 'None' ) {
                    my @at = split (/,/, $at);
                    for my $target (@at) {
                        my $archiver = $app->publisher->archiver($target);
                        next unless $archiver;
                        my $entries_count = $archiver->archive_entries_count;
                        if ($entries_count){
                            my $count = $entries_count->($blog, $target, $obj);
                            if ( $count == 1 ) {
                                $app->publisher->remove_entry_archive_file(
                                    Entry       => $obj,
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
    $app->call_return;
}

sub enable_object  { shift->set_object_status( MT::Author::ACTIVE() ) }
sub disable_object { shift->set_object_status( MT::Author::INACTIVE() ) }

sub set_object_status {
    my $app = shift;
    my ($new_status) = @_;

    $app->validate_magic() or return;
    return $app->error( $app->translate('Permission denied.') )
      unless $app->user->is_superuser;
    return $app->error( $app->translate("Invalid request.") )
      if $app->request_method ne 'POST';

    my $q    = $app->param;
    my $type = $q->param('_type');
    return $app->error( $app->translate('Invalid type') )
      unless ( $type eq 'user' )
      || ( $type eq 'author' )
      || ( $type eq 'group' );

    my $class = $app->model($type);

    my @sync;
    my $saved = 0;
    for my $id ( $q->param('id') ) {
        next unless $id;    # avoid 'empty' ids
        my $obj = $class->load($id);
        next unless $obj;
        if ( ( $obj->id == $app->user->id ) && ( $type eq 'author' ) ) {
            next;
        }
        next if $new_status == $obj->status;
        $obj->status($new_status);
        $obj->save;
        $saved++;
        if ( $type eq 'author' ) {
            if ( $new_status == MT::Author::ACTIVE() ) {
                push @sync, $obj;
            }
        }
    }
    my $unchanged = 0;
    if (@sync) {
        MT::Auth->synchronize_author( User => \@sync );
        foreach (@sync) {
            if ( $_->status != MT::Author::ACTIVE() ) {
                $unchanged++;
            }
        }
    }
    if ( $saved && ( $saved > $unchanged ) ) {
        $app->add_return_arg(
            saved_status => ( $new_status == MT::Author::ACTIVE() )
            ? 'enabled'
            : 'disabled'
        );
    }
    $app->add_return_arg( is_power_edit => 1 )
      if $q->param('is_power_edit');
    $app->add_return_arg( unchanged => $unchanged )
      if $unchanged;
    $app->call_return;
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

sub asset_insert {
    my $app  = shift;
    my $text = $app->_process_post_upload();
    return unless defined $text;
    $app->load_tmpl(
        'dialog/asset_insert.tmpl',
        {
            upload_html => $text || '',
            edit_field => scalar $app->param('edit_field') || '',
        },
    );
}

sub asset_userpic {
    my $app = shift;
    my ($param) = @_;

    my ($id, $asset);
    if ($asset = $param->{asset}) {
        $id = $asset->id;
    }
    else {
        $id = $param->{asset_id} || scalar $app->param('id');
        $asset = $app->model('asset')->lookup($id);
    }

    my $thumb_html = $app->model('author')->userpic_html( Asset => $asset );

    my $user_id = $param->{user_id} || $app->param('user_id');
    if ($user_id) {
        my $user = $app->model('author')->load( {id => $user_id} );
        if ($user) {
            # Delete the author's userpic thumb (if any); it'll be regenerated.
            if ($user->userpic_asset_id != $asset->id) {
                my $old_file = $user->userpic_file();
                my $fmgr = MT::FileMgr->new('Local');
                if ($fmgr->exists($old_file)) {
                    $fmgr->delete($old_file);
                }
                $user->userpic_asset_id($asset->id);
                $user->save;
            }
        }
    }

    $app->load_tmpl(
        'dialog/asset_userpic.tmpl',
        {
            asset_id       => $id,
            edit_field     => $app->param('edit_field') || '',
            author_userpic => $thumb_html,
        },
    );
}

sub complete_upload {
    my $app   = shift;
    my %param = $app->param_hash;
    my $asset;
    require MT::Asset;
    $param{id} && ( $asset = MT::Asset->load( $param{id} ) )
      or return $app->errtrans("Invalid request.");
    $asset->label( $param{label} )             if $param{label};
    $asset->description( $param{description} ) if $param{description};
    if ( $param{tags} ) {
        require MT::Tag;
        my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
        my @tags = MT::Tag->split( $tag_delim, $param{tags} );
        $asset->set_tags(@tags);
    }
    $asset->save();
    $asset->on_upload( \%param );

    my $perms = $app->permissions;
    return $app->return_to_dashboard( permission => 1 )
        unless $app->user->is_superuser
        || (
            $perms
            && (   $perms->can_edit_assets
                || $perms->can_edit_all_posts
                || $perms->can_create_post )
        );

    return $app->redirect(
        $app->uri(
            'mode' => 'list_assets',
            args   => { 'blog_id' => $app->param('blog_id') }
        )
    );
}

sub start_upload_entry {
    my $app = shift;
    my $q   = $app->param;
    $q->param( '_type', 'entry' );
    defined( my $text = $app->_process_post_upload ) or return;
    $q->param( 'text', $text );

    # strip any asset id
    $q->param( 'id', 0 );

    # clear tags value
    $app->param->param( 'tags', '' );
    $app->edit_object;
}

sub _process_post_upload {
    my $app   = shift;
    my %param = $app->param_hash;
    my $asset;
    require MT::Asset;
    $param{id} && ( $asset = MT::Asset->load( $param{id} ) )
      or return $app->errtrans("Invalid request.");
    $asset->label( $param{label} )             if $param{label};
    $asset->description( $param{description} ) if $param{description};
    if ( $param{tags} ) {
        require MT::Tag;
        my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
        my @tags = MT::Tag->split( $tag_delim, $param{tags} );
        $asset->set_tags(@tags);
    }
    $asset->save();

    $asset->on_upload( \%param );
    return $app->asset_insert_text( \%param );
}

sub asset_insert_text {
    my $app     = shift;
    my ($param) = @_;
    my $q       = $app->param;
    my $id      = $app->param('id')
      or return $app->errtrans("Invalid request.");
    require MT::Asset;
    my $asset = MT::Asset->load($id)
      or return $app->errtrans( "Can't load file #[_1].", $id );
    return $asset->as_html($param);
}

use constant NEW_PHASE => 1;

sub save_commenter_perm {
    my $app      = shift;
    my ($params) = @_;
    my $q        = $app->param;
    my $action   = $q->param('action');

    $app->validate_magic() or return;

    my $acted_on;
    my %rebuild_set;
    my @ids     = $params ? @$params : $app->param('commenter_id');
    my $blog_id = $q->param('blog_id');
    my $author  = $app->user;

    foreach my $id (@ids) {
        ( $id, $blog_id ) = @$id if ref $id eq 'ARRAY';

        my $cmntr = MT::Author->load($id)
          or return $app->errtrans( "No such commenter [_1].", $id );
        my $old_status = $cmntr->commenter_status($blog_id);

        if (   $action eq 'trust'
            && $cmntr->commenter_status($blog_id) != MT::Author::APPROVED() )
        {
            $cmntr->approve($blog_id) or return $app->error( $cmntr->errstr );
            $app->log(
                $app->translate(
                    "User '[_1]' trusted commenter '[_2]'.", $author->name,
                    $cmntr->name
                )
            );
            $acted_on++;
        }
        elsif ($action eq 'ban'
            && $cmntr->commenter_status($blog_id) != MT::Author::BANNED() )
        {
            $cmntr->ban($blog_id) or return $app->error( $cmntr->errstr );
            $app->log(
                $app->translate(
                    "User '[_1]' banned commenter '[_2]'.", $author->name,
                    $cmntr->name
                )
            );
            $acted_on++;
        }
        elsif ($action eq 'unban'
            && $cmntr->commenter_status($blog_id) == MT::Author::BANNED() )
        {
            $cmntr->pending($blog_id) or return $app->error( $cmntr->errstr );
            $app->log(
                $app->translate(
                    "User '[_1]' unbanned commenter '[_2]'.", $author->name,
                    $cmntr->name
                )
            );
            $acted_on++;
        }
        elsif ($action eq 'untrust'
            && $cmntr->commenter_status($blog_id) == MT::Author::APPROVED() )
        {
            $cmntr->pending($blog_id) or return $app->error( $cmntr->errstr );
            $app->log(
                $app->translate(
                    "User '[_1]' untrusted commenter '[_2]'.", $author->name,
                    $cmntr->name
                )
            );
            $acted_on++;
        }

        require MT::Entry;
        require MT::Comment;
        my $iter = MT::Entry->load_iter(
            undef,
            {
                join => MT::Comment->join_on(
                    'entry_id', { commenter_id => $cmntr->id }
                )
            }
        );
        my $e;
        while ( $e = $iter->() ) {
            $rebuild_set{$id} = $e;
        }
    }
    if ($acted_on) {
        my %msgs = (
            trust   => 'trusted',
            ban     => 'banned',
            unban   => 'unbanned',
            untrust => 'untrusted'
        );
        $app->add_return_arg( $msgs{$action} => 1 );
    }
    $app->call_return;
}

sub map_comment_to_commenter {
    my $app = shift;
    my ($comments) = @_;
    my %commenters;
    require MT::Comment;
    for my $id (@$comments) {
        my $cmt = MT::Comment->load($id);
        if ( $cmt->commenter_id ) {
            $commenters{ $cmt->commenter_id . ':' . $cmt->blog_id } =
              [ $cmt->commenter_id, $cmt->blog_id ];
        }
        else {
            $app->add_return_arg( 'unauth', 1 );
        }
    }
    return values %commenters;
}

sub trust_commenter_by_comment {
    my $app        = shift;
    my @comments   = $app->param('id');
    my @commenters = $app->map_comment_to_commenter( \@comments );
    $app->param( 'action', 'trust' );
    $app->save_commenter_perm( \@commenters );
}

sub untrust_commenter_by_comment {
    my $app        = shift;
    my @comments   = $app->param('id');
    my @commenters = $app->map_comment_to_commenter( \@comments );
    $app->param( 'action', 'untrust' );
    $app->save_commenter_perm( \@commenters );
}

sub ban_commenter_by_comment {
    my $app        = shift;
    my @comments   = $app->param('id');
    my @commenters = $app->map_comment_to_commenter( \@comments );
    $app->param( 'action', 'ban' );
    $app->save_commenter_perm( \@commenters );
}

sub unban_commenter_by_comment {
    my $app        = shift;
    my @comments   = $app->param('id');
    my @commenters = $app->map_comment_to_commenter( \@comments );
    $app->param( 'action', 'unban' );
    $app->save_commenter_perm( \@commenters );
}

sub trust_commenter {
    my $app        = shift;
    my @commenters = $app->param('id');
    $app->param( 'action', 'trust' );
    $app->save_commenter_perm( \@commenters );
}

sub ban_commenter {
    my $app        = shift;
    my @commenters = $app->param('id');
    $app->param( 'action', 'ban' );
    $app->save_commenter_perm( \@commenters );
}

sub unban_commenter {
    my $app        = shift;
    my @commenters = $app->param('id');
    $app->param( 'action', 'unban' );
    $app->save_commenter_perm( \@commenters );
}

sub untrust_commenter {
    my $app        = shift;
    my @commenters = $app->param('id');
    $app->param( 'action', 'untrust' );
    $app->save_commenter_perm( \@commenters );
}

sub rebuild_phase {
    my $app  = shift;
    my $type = $app->param('_type') || 'entry';
    my @ids  = $app->param('id');
    $app->{goback} = "window.location='" . $app->return_uri . "'";
    $app->{value} ||= $app->translate('Go Back');
    if ( $type eq 'entry' ) {
        my %ids = map { $_ => 1 } @ids;
        return $app->rebuild_these( \%ids );
    }
    elsif ( $type eq 'template' ) {
        require MT::Template;
        foreach (@ids) {
            my $template = MT::Template->load($_);
            $app->rebuild_indexes(
                Template => $template,
                Force    => 1
            ) or return;
        }
    }
    $app->call_return;
}

sub draft_entries {
    my $app = shift;
    require MT::Entry;
    $app->update_entry_status( MT::Entry::HOLD(), $app->param('id') );
}

sub publish_entries {
    my $app = shift;
    require MT::Entry;
    $app->update_entry_status( MT::Entry::RELEASE(), $app->param('id') );
}

sub update_entry_status {
    my $app = shift;
    my ( $new_status, @ids ) = @_;
    return $app->errtrans("Need a status to update entries")
      unless $new_status;
    return $app->errtrans("Need entries to update status")
      unless @ids;
    my @bad_ids;
    my %rebuild_these;
    require MT::Entry;

    foreach my $id (@ids) {
        my $entry = MT::Entry->load($id)
          or return $app->errtrans(
            "One of the entries ([_1]) did not actually exist", $id );
        next if $entry->status == $new_status;
        if ( $app->config('DeleteFilesAtRebuild')
            && ( MT::Entry::RELEASE() eq $entry->status ) )
        {
            my $archive_type =
              $entry->class eq 'page'
              ? 'Page'
              : 'Individual';
            $app->publisher->remove_entry_archive_file(
                Entry       => $entry,
                ArchiveType => $archive_type
            );
        }
        my $old_status = $entry->status;
        $entry->status($new_status);
        $entry->save() and $rebuild_these{$id} = 1;
        my $message = $app->translate(
            "[_1] '[_2]' (ID:[_3]) status changed from [_4] to [_5]",
            $entry->class_label,
            $entry->title,
            $entry->id,
            $app->translate( MT::Entry::status_text($old_status) ),
            $app->translate( MT::Entry::status_text($new_status) )
        );
        $app->log(
            {
                message  => $message,
                level    => MT::Log::INFO(),
                class    => $entry->class,
                category => 'edit',
                metadata => $entry->id
            }
        );
    }
    $app->rebuild_these( \%rebuild_these, how => NEW_PHASE );
}

sub open_batch_editor {
    my $app = shift;
    my @ids = $app->param('id');

    $app->param( 'is_power_edit', 1 );
    $app->param( 'filter',        'power_edit' );
    $app->param( 'filter_val',    \@ids );
    $app->mode(
        'list_' . ( 'entry' eq $app->param('_type') ? 'entries' : 'pages' ) );
    $app->list_entries( { type => $app->param('_type') } );
}

sub approve_item {
    my $app   = shift;
    my $perms = $app->permissions;
    $app->param( 'approve', 1 );
    $app->set_item_visible;
}

sub unapprove_item {
    my $app   = shift;
    my $perms = $app->permissions;
    $app->param( 'unapprove', 1 );
    $app->set_item_visible;
}

sub set_item_visible {
    my $app    = shift;
    my $perms  = $app->permissions;
    my $author = $app->user;

    my $type    = $app->param('_type');
    my $class   = $app->model($type);
    my @obj_ids = $app->param('id');

    if ( my $req_nonce = $app->param('nonce') ) {
        if ( scalar @obj_ids == 1 ) {
            my $cmt_id = $obj_ids[0];
            if ( my $obj = $class->load($cmt_id) ) {
                my $nonce =
                  MT::Util::perl_sha1_digest_hex( $obj->id
                      . $obj->created_on
                      . $obj->blog_id
                      . $app->config->SecretToken );
                return $app->errtrans("Invalid request.")
                  unless $nonce eq $req_nonce;
                my $return_args = $app->uri_params(
                    mode => 'view',
                    args => {
                        '_type' => $type,
                        id      => $cmt_id,
                        blog_id => $obj->blog_id
                    }
                );
                $return_args =~ s!^\?!!;
                $app->return_args($return_args);
            }
            else {
                return $app->errtrans("Invalid request.");
            }
        }
        else {
            return $app->errtrans("Invalid request.");
        }
    }
    else {
        $app->validate_magic() or return;
    }

    my $new_visible;
    if ( $app->param('approve') ) {
        $new_visible = 1;
    }
    elsif ( $app->param('unapprove') ) {
        $new_visible = 0;
    }

    my %rebuild_set = ();
    require MT::Entry;
    foreach my $id (@obj_ids) {
        my $obj = $class->load($id);
        my $old_visible = $obj->visible || 0;
        if ( $old_visible != $new_visible ) {
            if ( $obj->isa('MT::TBPing') ) {
                my $obj_parent = $obj->parent();
                if ( $obj_parent->isa('MT::Category') ) {
                    my $blog = MT::Blog->load( $obj_parent->blog_id );
                    next unless $blog;
                    $app->publisher->_rebuild_entry_archive_type(
                        Entry       => undef,
                        Blog        => $blog,
                        Category    => $obj_parent,
                        ArchiveType => 'Category'
                    );
                }
                else {
                    if ( !$author->is_superuser ) {
                        if ( !$perms || $perms->blog_id != $obj->blog_id ) {
                            $perms = $author->permissions( $obj->blog_id );
                        }
                        unless ($perms) {
                            return $app->errtrans(
"You don't have permission to approve this comment."
                            );
                        }
                        unless (
                            $perms->can_manage_feedback
                            || ( $perms->can_publish_post
                                && ( $obj_parent->author_id == $author->id ) )
                          )
                        {
                            return $app->errtrans(
"You don't have permission to approve this comment."
                            );
                        }
                    }
                    $rebuild_set{ $obj_parent->id } = $obj_parent;
                }
            }
            elsif ( $obj->entry_id ) {

                # TODO: Factor out permissions checking
                my $entry = MT::Entry->load( $obj->entry_id )
                  || return $app->error(
                    $app->translate("Comment on missing entry!") );
                if ( !$author->is_superuser ) {
                    if ( !$perms || $perms->blog_id != $obj->blog_id ) {
                        $perms = $author->permissions( $obj->blog_id );
                    }
                    unless ($perms) {
                        return $app->errtrans(
                            "You don't have permission to approve this comment."
                        );
                    }
                    unless (
                        $perms->can_manage_feedback
                        || ( $perms->can_publish_post
                            && ( $entry->author_id == $author->id ) )
                      )
                    {
                        return $app->errtrans(
                            "You don't have permission to approve this comment."
                        );
                    }
                }
                $rebuild_set{ $obj->entry_id } = $entry;
            }
            $obj->visible($new_visible);
            $obj->save();
        }
    }
    my $approved_flag = ( $new_visible ? '' : 'un' ) . 'approved';
    $app->add_return_arg( $approved_flag => 1 );
    return $app->rebuild_these( \%rebuild_set, how => NEW_PHASE );
}

sub list_commenter {
    my $app = shift;
    unless ( $app->user_can_admin_commenters ) {
        return $app->error( $app->translate("Permission denied.") );
    }

    my $q         = $app->param;
    my $list_pref = $app->list_pref('commenter');
    my $blog_id   = $q->param('blog_id');
    my %param     = %$list_pref;
    my %terms     = ( type => MT::Author::COMMENTER() );
    my %terms2    = ();
    my $limit     = $list_pref->{rows};
    my $offset    = $q->param('offset') || 0;
    my %arg;
    require MT::Comment;
    $arg{'join'} = MT::Comment->join_on(
        'commenter_id',
        { ( $blog_id ? ( blog_id => $blog_id ) : () ) },
        {
            'sort'    => 'created_on',
            direction => 'descend',
            unique    => 1
        }
    );
    my ( $filter_col, $val );
    $param{filter_args} = "";

    if (   ( $filter_col = $q->param('filter') )
        && ( $val = $q->param('filter_val') ) )
    {
        if ( !exists( $terms{$filter_col} ) ) {
            if ( $filter_col eq 'status' ) {
                my ($perm) = (
                      $val eq 'neutral'  ? undef
                    : $val eq 'approved' ? 'comment'
                    : $val eq 'banned'   ? 'not_comment'
                    : undef
                );
                $arg{join} = MT::Permission->join_on(
                    'author_id',
                    {
                        blog_id => $blog_id,
                        ( defined $perm ) ? ( permissions => $perm ) : ()
                    }
                );
            }
            else {
                $terms{$filter_col} = $val;
            }

            $param{filter}     = $filter_col;
            $param{filter_val} = $val;
            $param{filter_args} = "&filter=" . encode_url($filter_col) . "&filter_val=" . encode_url($val);
        }
    }
    $arg{'offset'} = $offset if $offset;
    $arg{'limit'} = $limit + 1;
    my $terms = \%terms;
    my $arg   = \%arg;
    my $iter  = MT::Author->load_iter( $terms, $arg );

    my $data = $app->build_commenter_table( iter => $iter, param => \%param );
    if ( @$data > $limit ) {
        pop @$data;
        $param{next_offset}     = 1;
        $param{next_offset_val} = $offset + $limit;
    }
    if ( $offset > 0 ) {
        $param{prev_offset}     = 1;
        $param{prev_offset_val} = $offset - $limit;
        $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
    }

    $param{object_type}  = 'commenter';
    $param{search_label} = $app->translate('Commenters');
    $param{list_start}   = $offset + 1;
    $param{list_end}     = $offset + scalar @$data;
    $param{offset}       = $offset;
    $param{limit}        = $limit;
    delete $arg->{limit};
    delete $arg->{offset};
    $param{list_total} = MT::Author->count( $terms, $arg );

    if ( $param{list_total} ) {
        $param{next_max} = $param{list_total} - $limit;
        $param{next_max} = 0 if ( $param{next_max} || 0 ) < $offset + 1;
    }
    $app->add_breadcrumb( $app->translate('Authenticated Commenters') );
    $param{nav_commenters} = 1;
    for my $msg (qw(trusted untrusted banned unbanned)) {
        $param{$msg} = 1 if $app->param($msg);
    }
    return $app->load_tmpl( 'list_commenter.tmpl', \%param );
}

sub build_commenter_table {
    my $app = shift;
    my (%args) = @_;

    my $param = $args{param};
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('commenter');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
    }
    return [] unless $iter;

    my $app_user  = $app->user;
    my $user_perm = $app->permissions;
    my $blog_id   = $app->param('blog_id');

    my @data;
    require MT::Blog;
    my $blog = MT::Blog->load($blog_id);
    while ( my $cmtr = $iter->() ) {
        require MT::Comment;
        my $cmt_count = MT::Comment->count(
            {
                commenter_id => $cmtr->id,
                blog_id      => $blog_id
            }
        );
        my $most_recent = MT::Comment->load(
            {
                commenter_id => $cmtr->id,
                blog_id      => $blog_id
            },
            {
                'sort'    => 'created_on',
                direction => 'descend'
            }
        ) if $cmt_count > 0;

        my $blog_connection = MT::Permission->load(
            {
                author_id => $cmtr->id,
                blog_id   => $blog_id
            }
        );

        # Tells us whether the commenter is associated with this
        # blog. the role flags are not important
        next if ( !$cmt_count && !$blog_connection );

        my $row = {};
        $row->{author_id}      = $cmtr->id();
        $row->{author}         = $cmtr->name();
        $row->{author_display} = $cmtr->nickname();
        $row->{email}          = $cmtr->email();
        $row->{url}            = $cmtr->url();
        $row->{email_hidden}   = $cmtr->is_email_hidden();
        $row->{comment_count}  = $cmt_count;
        if ($most_recent) {

            if ( my $ts = $most_recent->created_on ) {
                $row->{most_recent_time_formatted} =
                  format_ts( LISTING_DATETIME_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );
                $row->{most_recent_formatted} =
                  format_ts( LISTING_DATE_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );
                $row->{most_recent_relative} =
                  relative_date( $ts, time, $blog );
            }
        }
        $row->{status} = {
            PENDING  => "neutral",
            APPROVED => "approved",
            BANNED   => "banned"
        }->{ $cmtr->commenter_status($blog_id) };
        $row->{commenter_approved} =
          $cmtr->commenter_status($blog_id) == MT::Author::APPROVED();
        $row->{commenter_banned} =
          $cmtr->commenter_status($blog_id) == MT::Author::BANNED();
        $row->{commenter_url}   = $cmtr->url if $cmtr->url;
        $row->{has_edit_access} = $app->user_can_admin_commenters;
        $row->{object}          = $cmtr;
        push @data, $row;
    }
    return [] unless @data;

    $param->{commenter_table}[0]{object_loop} = \@data if @data;
    $app->load_list_actions( 'commenter', $param->{commenter_table}[0] );
    $param->{commenter_table}[0]{page_actions} =
      $app->page_actions('list_commenter');
    $param->{object_loop} = $param->{commenter_table}[0]{object_loop};
    \@data;
}

sub list_comments {
    my $app = shift;

    my $trim_length =
      $app->config('ShowIPInformation')
      ? const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_SHORT')
      : const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_LONG');
    my $author_max_len = const('DISPLAY_LENGTH_EDIT_COMMENT_AUTHOR');
    my $comment_short_len =
      const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_SHORT');
    my $comment_long_len =
      const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_LONG');
    my $title_max_len = const('DISPLAY_LENGTH_EDIT_COMMENT_TITLE');

    my ( %entries, %blogs, %cmntrs );
    my $perms = $app->permissions;
    my $user  = $app->user;
    my $admin = $user->is_superuser
      || ( $perms && $perms->can_administer_blog );
    my $can_empty_junk = $admin
      || ( $perms && $perms->can_manage_feedback )
      ? 1 : 0;
    my $state_editable = $admin
      || ( $perms
        && ( $perms->can_publish_post
          || $perms->can_edit_all_posts || $perms->can_manage_feedback ) )
      ? 1 : 0;
    my $entry_pkg = $app->model('entry');
    my $code      = sub {
        my ( $obj, $row ) = @_;

        # Comment column
        $row->{comment_short} =
          ( substr_text( $obj->text(), 0, $trim_length )
              . ( length_text( $obj->text ) > $trim_length ? "..." : "" ) );
        $row->{comment_short} =
          break_up_text( $row->{comment_short}, $comment_short_len )
          ;    # break up really long strings
        $row->{comment_long} = remove_html( $obj->text );
        $row->{comment_long} =
          break_up_text( $row->{comment_long}, $comment_long_len )
          ;    # break up really long strings

        # Commenter name column
        $row->{author_display} = $row->{author};
        $row->{author_display} =
          substr_text( $row->{author_display}, 0, $author_max_len ) . '...'
          if $row->{author_display}
          && length_text( $row->{author_display} ) > $author_max_len;
        if ( $row->{commenter_id} ) {
            my $cmntr = $cmntrs{ $row->{commenter_id} } ||=
              MT::Author->load( { id => $row->{commenter_id} } );
            if ($cmntr) {
                $row->{email_hidden} = $cmntr && $cmntr->is_email_hidden();
                $row->{auth_icon_url} = $cmntr->auth_icon_url;

                my $status = $cmntr->commenter_status( $obj->blog_id );
                $row->{commenter_approved} =
                  ( $cmntr->commenter_status( $obj->blog_id ) ==
                      MT::Author::APPROVED() );
                $row->{commenter_banned} =
                  ( $cmntr->commenter_status( $obj->blog_id ) ==
                      MT::Author::BANNED() );
            }
        }

        # Entry column
        my $entry = $entries{ $obj->entry_id } ||=
          $entry_pkg->load( $obj->entry_id );
        unless ($entry) {
            $entry = $entry_pkg->new;
            $entry->title( '* ' . $app->translate('Orphaned comment') . ' *' );
        }
        $row->{entry_class} = $entry->class;
        $row->{entry_class_label} = $entry->class_label;
        $row->{entry_title} = (
              defined( $entry->title ) ? $entry->title
            : defined( $entry->text )  ? $entry->text
            : ''
        );
        $row->{entry_title} = $app->translate('(untitled)')
          if $row->{entry_title} eq '';
        $row->{entry_title} =
          substr_text( $row->{entry_title}, 0, $title_max_len ) . '...'
          if $row->{entry_title}
          && length_text( $row->{entry_title} ) > $title_max_len;

        # Date column
        my $blog = $blogs{ $obj->blog_id } ||= $obj->blog;
        if ( my $ts = $obj->created_on ) {
            $row->{created_on_time_formatted} =
              format_ts( LISTING_DATETIME_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_formatted} =
              format_ts( LISTING_DATE_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );

            $row->{created_on_relative} = relative_date( $ts, time, $blog );
        }

        $row->{has_edit_access} = $state_editable
          || ( $entry && ( $user->id == $entry->author_id ) );

        # Blog column
        if ($blog) {
            $row->{weblog_id}   = $blog->id;
            $row->{weblog_name} = $blog->name;
        }
        else {
            $row->{weblog_name} =
              '* ' . $app->translate('Orphaned comment') . ' *';
        }

        $row->{reply_count} =
          $app->model('comment')->count( { parent_id => $obj->id } );
    };

    my %param;
    my $blog_id = $app->param('blog_id');
    $param{feed_name} = $app->translate("Comments Activity Feed");
    $param{feed_url} =
      $app->make_feed_link( 'comment',
        $blog_id ? { blog_id => $blog_id } : undef );
    $param{filter_spam} =
      ( $app->param('filter_key') && $app->param('filter_key') eq 'spam' );
    $param{has_expanded_mode} = 1;
    $param{object_type}       = 'comment';
    $param{screen_id}         = 'list-comment';
    $param{screen_class}      = 'list-comment';
    $param{search_label}      = $app->translate('Comments');
    $param{state_editable}    = $state_editable;
    $param{can_empty_junk}    = $can_empty_junk;
    return $app->listing(
        {
            type   => 'comment',
            code   => $code,
            args   => { sort => 'created_on', direction => 'descend' },
            params => \%param,
        }
    );
}

sub build_asset_table {
    my $app = shift;
    my (%args) = @_;

    my $asset_class = $app->model('asset') or return;
    my $perms     = $app->permissions;
    my $list_pref = $app->list_pref('asset');
    my $limit     = $args{limit};
    my $param     = $args{param} || {};
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('asset');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
        $limit = scalar @{ $args{items} };
    }
    return [] unless $iter;

    my @data;
    my $hasher = $app->build_asset_hasher;
    while ( my $obj = $iter->() ) {
        my $row = $obj->column_values;
        $hasher->($obj, $row);
        $row->{object} = $obj;
        push @data, $row;
        last if $limit and @data > $limit;
    }
    return [] unless @data;

    $param->{template_table}[0]              = {%$list_pref};
    $param->{template_table}[0]{object_loop} = \@data;
    $param->{template_table}[0]{object_type} = 'asset';
    $app->load_list_actions( 'asset', $param );
    $param->{object_loop} = \@data;
    $param->{can_delete_files} = 1
        if (($perms && $perms->can_edit_assets) || $app->user->is_superuser);
    \@data;
}

sub build_template_table {
    my $app = shift;
    my (%args) = @_;

    my $perms     = $app->permissions;
    my $list_pref = $app->list_pref('template');
    my $limit     = $args{limit};
    my $param     = $args{param} || {};
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('template');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
        $limit = scalar @{ $args{items} };
    }
    return [] unless $iter;

    my @data;
    my $i;
    my %blogs;
    while ( my $tmpl = $iter->() ) {
        my $blog = $blogs{ $tmpl->blog_id } ||=
          MT::Blog->load( $tmpl->blog_id );
        my $row = $tmpl->column_values;
        $row->{name} = '' if !defined $row->{name};
        $row->{name} =~ s/^\s+|\s+$//g;
        $row->{name} = "(" . $app->translate("No Name") . ")"
          if $row->{name} eq '';
        my $published_url = $tmpl->published_url;
        $row->{published_url} = $published_url if $published_url;

        # FIXME: enumeration of types
        $row->{can_delete} = 1
          if $tmpl->type =~ m/(custom|index|archive|page|individual|category)/;
        if ($blog) {
            $row->{weblog_name} = $blog->name;
        }
        elsif ($tmpl->blog_id) {
            $row->{weblog_name} = '* ' . $app->translate('Orphaned') . ' *';
        }
        else {
            $row->{weblog_name} = '* ' . $app->translate('Global Templates') . ' *';
        }
        $row->{object} = $tmpl;
        push @data, $row;
        last if @data > $limit;
    }
    return [] unless @data;

    $param->{template_table}[0]              = {%$list_pref};
    $param->{template_table}[0]{object_loop} = \@data;
    $param->{template_table}[0]{object_type} = 'template';
    $app->load_list_actions( 'template', $param );
    $param->{object_loop} = \@data;
    \@data;
}

sub build_comment_table {
    my $app = shift;
    my (%args) = @_;

    my $author    = $app->user;
    my $class     = $app->model('comment');
    my $list_pref = $app->list_pref('comment');
    my $entry_pkg = $app->model('entry');
    my $iter;
    if ( $args{load_args} ) {
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
    }
    return [] unless $iter;
    my $limit = $args{limit};
    my $param = $args{param} || {};

    my @data;
    my $i;
    $i = 1;
    my ( %blogs, %entries, %perms, %cmntrs );
    my $trim_length =
      $app->config('ShowIPInformation')
      ? const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_SHORT')
      : const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_LONG');
    my $author_max_len = const('DISPLAY_LENGTH_EDIT_COMMENT_AUTHOR');
    my $comment_short_len =
      const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_SHORT');
    my $comment_long_len =
      const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_LONG');
    my $title_max_len = const('DISPLAY_LENGTH_EDIT_COMMENT_TITLE');

    while ( my $obj = $iter->() ) {
        my $row = $obj->column_values;
        $row->{author_display} = $row->{author};
        $row->{author_display} =
          substr_text( $row->{author_display}, 0, $author_max_len ) . '...'
          if $row->{author_display}
          && length_text( $row->{author_display} ) > $author_max_len;
        $row->{comment_short} =
          ( substr_text( $obj->text(), 0, $trim_length )
              . ( length_text( $obj->text ) > $trim_length ? "..." : "" ) );
        $row->{comment_short} =
          break_up_text( $row->{comment_short}, $comment_short_len )
          ;    # break up really long strings
        $row->{comment_long} = remove_html( $obj->text );
        $row->{comment_long} =
          break_up_text( $row->{comment_long}, $comment_long_len )
          ;    # break up really long strings

        $row->{visible}  = $obj->visible();
        $row->{entry_id} = $obj->entry_id();
        my $blog = $blogs{ $obj->blog_id } ||= $obj->blog;
        my $entry = $entries{ $obj->entry_id } ||=
          $entry_pkg->load( $obj->entry_id );
        unless ($entry) {
            $entry = $entry_pkg->new;
            $entry->title( '* ' . $app->translate('Orphaned comment') . ' *' );
        }
        $row->{entry_class} = $entry->class;
        $row->{entry_class_label} = $entry->class_label;
        $row->{entry_title} = (
              defined( $entry->title ) ? $entry->title
            : defined( $entry->text )  ? $entry->text
            : ''
        );
        $row->{entry_title} = $app->translate('(untitled)')
          if $row->{entry_title} eq '';
        $row->{entry_title} =
          substr_text( $row->{entry_title}, 0, $title_max_len ) . '...'
          if $row->{entry_title}
          && length_text( $row->{entry_title} ) > $title_max_len;
        $row->{commenter_id} = $obj->commenter_id() if $obj->commenter_id();
        my $cmntr;
        if ( $obj->commenter_id ) {
            $cmntr = $cmntrs{ $obj->commenter_id } ||= MT::Author->load(
                {
                    id   => $obj->commenter_id(),
                }
            );
        }
        if ($cmntr) {
            $row->{email_hidden} = $cmntr && $cmntr->is_email_hidden();
            $row->{auth_icon_url} = $cmntr->auth_icon_url;

            my $status = $cmntr->commenter_status( $obj->blog_id );
            $row->{commenter_approved} =
              ( $cmntr->commenter_status( $obj->blog_id ) ==
                  MT::Author::APPROVED() );
            $row->{commenter_banned} =
              ( $cmntr->commenter_status( $obj->blog_id ) ==
                  MT::Author::BANNED() );
        }
        if ( my $ts = $obj->created_on ) {
            $row->{created_on_time_formatted} =
              format_ts( LISTING_DATETIME_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_formatted} =
              format_ts( LISTING_DATE_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );

            $row->{created_on_relative} = relative_date( $ts, time, $blog );
        }
        if ( $author->is_superuser() ) {
            $row->{has_edit_access} = 1;
            $row->{has_bulk_access} = 1;
        }
        else {
            my $perms = $perms{ $obj->blog_id } ||=
              $author->permissions( $obj->blog_id );
            $row->{has_bulk_access} = (
                $perms && ( $perms->can_edit_all_posts
                    || $perms->can_manage_feedback )
                  || ( ( $perms->can_publish_post )
                    && ( $author->id == $entry->author_id ) )
            );
            $row->{has_edit_access} = (
                $perms && ( $perms->can_edit_all_posts
                    || $perms->can_manage_feedback )
                  || ( ( $perms->can_create_post )
                    && ( $author->id == $entry->author_id ) )
            );
        }
        if ($blog) {
            $row->{weblog_id}   = $blog->id;
            $row->{weblog_name} = $blog->name;
        }
        else {
            $row->{weblog_name} =
              '* ' . $app->translate('Orphaned comment') . ' *';
        }
        $row->{reply_count} = $class->count( { parent_id => $obj->id } );
        $row->{object} = $obj;
        push @data, $row;
        last if $limit and @data > $limit;
    }
    return [] unless @data;

    my $junk_tab = ( $app->param('tab') || '' ) eq 'junk';
    $param->{comment_table}[0]              = {%$list_pref};
    $param->{comment_table}[0]{object_loop} = \@data;
    $param->{comment_table}[0]{object_type} = 'comment';
    $param->{object_loop} = $param->{comment_table}[0]{object_loop}
      unless exists $param->{object_loop};

    $app->load_list_actions( 'comment', \%$param );
    \@data;
}

sub plugin_control {
    my $app = shift;

    $app->validate_magic or return;
    return unless $app->user->can_manage_plugins;

    my $plugin_sig = $app->param('plugin_sig') || '';
    my $state      = $app->param('state')      || '';

    my $cfg = $app->config;
    if ( $plugin_sig eq '*' ) {
        $cfg->UsePlugins( $state eq 'on' ? 1 : 0, 1 );
    }
    else {
        if ( exists $MT::Plugins{$plugin_sig} ) {
            $cfg->PluginSwitch(
                $plugin_sig . '=' . ( $state eq 'on' ? '1' : '0' ), 1 );
        }
    }
    $cfg->save_config;

    $app->add_return_arg( 'switched' => 1 );
    $app->call_return;
}

sub build_plugin_table {
    my $app = shift;
    my (%opt) = @_;

    my $param = $opt{param};
    my $scope = $opt{scope} || 'system';
    my $cfg   = $app->config;
    my $data  = [];

    # we have to sort the plugin list in an odd fashion...
    #   PLUGINS
    #     (those at the top of the plugins directory and those
    #      that only have 1 .pl script in a plugin folder)
    #   PLUGIN SET
    #     (plugins folders with multiple .pl files)
    my %list;
    my %folder_counts;
    for my $sig ( keys %MT::Plugins ) {
        my $sub = $sig =~ m!/! ? 1 : 0;
        my $obj = $MT::Plugins{$sig}{object};

        # Prevents display of component objects
        next if $obj && !$obj->isa('MT::Plugin');

        my $err = $MT::Plugins{$sig}{error}   ? 0 : 1;
        my $on  = $MT::Plugins{$sig}{enabled} ? 0 : 1;
        my ( $fld, $plg );
        ( $fld, $plg ) = $sig =~ m!(.*)/(.*)!;
        $fld = '' unless $fld;
        $folder_counts{$fld}++ if $fld;
        $plg ||= $sig;
        $list{  $sub
              . sprintf( "%-100s", $fld )
              . ( $obj ? '1' : '0' )
              . $plg } = $sig;
    }
    my @keys = keys %list;
    foreach my $key (@keys) {
        my $fld = substr( $key, 1, 100 );
        $fld =~ s/\s+$//;
        if ( !$fld || ( $folder_counts{$fld} == 1 ) ) {
            my $sig = $list{$key};
            delete $list{$key};
            my $plugin = $MT::Plugins{$sig};
            my $name =
              $plugin && $plugin->{object} ? $plugin->{object}->name : $sig;
            $list{ '0' . ( ' ' x 100 ) . sprintf( "%-102s", $name ) } = $sig;
        }
    }

    my $last_fld = '*';
    my $next_is_first;
    my $id = 0;
    ( my $cgi_path = $cfg->AdminCGIPath || $cfg->CGIPath ) =~ s|/$||;
    for my $list_key ( sort keys %list ) {
        $id++;
        my $plugin_sig = $list{$list_key};
        next if $plugin_sig =~ m/^[^A-Za-z0-9]/;
        my $profile = $MT::Plugins{$plugin_sig};
        my ($plg);
        ($plg) = $plugin_sig =~ m!(?:.*)/(.*)!;
        my $fld = substr( $list_key, 1, 100 );
        $fld =~ s/\s+$//;
        my $folder =
            $fld
          ? $app->translate( "Plugin Set: [_1]", $fld )
          : $app->translate("Individual Plugins");
        my $row;
        my $icon = $app->static_path . 'images/plugin.gif';

        if ( my $plugin = $profile->{object} ) {
            my $plugin_icon;
            if ( $plugin->icon ) {
                $plugin_icon =
                  $app->static_path . $plugin->envelope . '/' . $plugin->icon;
            }
            else {
                $plugin_icon = $icon;
            }
            my $plugin_name = remove_html( $plugin->name() );
            my $config_link = $plugin->config_link();
            my $plugin_page =
              ( $cgi_path . '/' . $plugin->envelope . '/' . $config_link )
              if $config_link;
            my $doc_link = $plugin->doc_link;
            if ( $doc_link && ( $doc_link !~ m!^https?://! ) ) {
                $doc_link =
                  $app->static_path . $plugin->envelope . '/' . $doc_link;
            }

            my ($config_html);
            my %plugin_param;
            my $settings = $plugin->get_config_obj($scope);
            $plugin->load_config( \%plugin_param, $scope );
            if ( my $snip_tmpl =
                $plugin->config_template( \%plugin_param, $scope ) )
            {
                my $tmpl;
                if ( ref $snip_tmpl ne 'MT::Template' ) {
                    require MT::Template;
                    $tmpl = MT::Template->new(
                        type   => 'scalarref',
                        source => ref $snip_tmpl
                        ? $snip_tmpl
                        : \$snip_tmpl

                          # TBD: add path for plugin template directory
                    );
                }
                else {
                    $tmpl = $snip_tmpl;
                }

                # Process template independent of $app to avoid premature
                # localization (give plugin a chance to do L10N first).
                $tmpl->param( \%plugin_param );
                $config_html = $tmpl->output()
                    or $config_html = "Error in configuration template: " . $tmpl->errstr;
                $config_html = $plugin->translate_templatized($config_html)
                  if $config_html =~ m/<(?:__trans|mt_trans) /i;
            }
            else {

                # don't list non-configurable plugins for blog scope...
                next if $scope ne 'system';
            }

            if ( $last_fld ne $fld ) {
                $row = {
                    plugin_sig    => $plugin_sig,
                    plugin_folder => $folder,
                    plugin_set    => $fld ? $folder_counts{$fld} > 1 : 0,
                    plugin_error  => $profile->{error},
                };
                push @$data, $row;
                $last_fld      = $fld;
                $next_is_first = 1;
            }

            my $registry = $plugin->registry;
            my $row      = {
                first                => $next_is_first,
                plugin_name          => $plugin_name,
                plugin_page          => $plugin_page,
                plugin_major         => 1,
                plugin_icon          => $plugin_icon,
                plugin_desc          => $plugin->description(),
                plugin_version       => $plugin->version(),
                plugin_author_name   => $plugin->author_name(),
                plugin_author_link   => $plugin->author_link(),
                plugin_plugin_link   => $plugin->plugin_link(),
                plugin_full_path     => $plugin->{full_path},
                plugin_doc_link      => $doc_link,
                plugin_sig           => $plugin_sig,
                plugin_key           => $plugin->key(),
                plugin_config_link   => $plugin->config_link(),
                plugin_config_html   => $config_html,
                plugin_settings_id   => $settings->id,
                plugin_id            => $id,
                plugin_compat_errors => $registry->{compat_errors},
            };
            my $block_tags = $plugin->registry('tags', 'block');
            my $function_tags = $plugin->registry('tags', 'function');
            my $modifiers = $plugin->registry('tags', 'modifier');
            my $junk_filters = $plugin->registry('junk_filters');
            my $text_filters = $plugin->registry('text_filters');

            $row->{plugin_tags} = listify(
                [

                    # Filter out 'plugin' registry entry
                    grep { !/^<\$?MTplugin\$?>$/ } (
                        (

                            # Format all 'block' tags with <MT(name)>
                            map { s/\?$//; "<MT$_>" }
                              ( keys %{ $block_tags || {} } )
                        ),
                        (

                            # Format all 'function' tags with <$MT(name)$>
                            map { "<\$MT$_\$>" }
                              ( keys %{ $function_tags || {} } )
                        )
                    )
                ]
            ) if $block_tags || $function_tags;
            $row->{plugin_attributes} = listify(
                [

                    # Filter out 'plugin' registry entry
                    grep { $_ ne 'plugin' }
                      keys %{ $modifiers || {} }
                ]
            ) if $modifiers;
            $row->{plugin_junk_filters} = listify(
                [

                    # Filter out 'plugin' registry entry
                    grep { $_ ne 'plugin' }
                      keys %{ $junk_filters || {} }
                ]
            ) if $junk_filters;
            $row->{plugin_text_filters} = listify(
                [

                    # Filter out 'plugin' registry entry
                    grep { $_ ne 'plugin' }
                      keys %{ $text_filters || {} }
                ]
            ) if $text_filters;
            if (   $row->{plugin_tags}
                || $row->{plugin_attributes}
                || $row->{plugin_junk_filters}
                || $row->{plugin_text_filters} )
            {
                $row->{plugin_resources} = 1;
            }
            push @$data, $row;
        }
        else {

            # don't list non-configurable plugins for blog scope...
            next if $scope ne 'system';

            if ( $last_fld ne $fld ) {
                $row = {
                    plugin_sig    => $plugin_sig,
                    plugin_folder => $folder,
                    plugin_set    => $fld ? $folder_counts{$fld} > 1 : 0,
                    plugin_error  => $profile->{error},
                };
                push @$data, $row;
                $last_fld      = $fld;
                $next_is_first = 1;
            }

            # no registered plugin objects--
            $row = {
                first                => $next_is_first,
                plugin_major         => $fld ? 0 : 1,
                plugin_icon          => $icon,
                plugin_name          => $plugin_sig,
                plugin_sig           => $plugin_sig,
                plugin_error         => $profile->{error},
                plugin_disabled      => $profile->{enabled} ? 0 : 1,
                plugin_id            => $id,
            };
            push @$data, $row;
        }
        $next_is_first = 0;
    }
    $param->{plugin_loop} = $data;
}

sub listify {
    my ($arr) = @_;
    my @ret;
    return unless ref($arr) eq 'ARRAY';
    foreach (@$arr) {
        push @ret, { name => $_ };
    }
    \@ret;
}

sub list_pings {
    my $app   = shift;
    my $q     = $app->param;
    my $perms = $app->permissions;

    my $can_empty_junk = 1;
    my $state_editable = 1;
    my $admin = $app->user->is_superuser
      || ( $perms && $perms->can_administer_blog );
    if ($perms) {
        unless ( $perms->can_view_feedback ) {
            return $app->error( $app->translate("Permission denied.") );
        }
        $can_empty_junk = $admin
          || ( $perms && $perms->can_manage_feedback )
          ? 1 : 0;
        $state_editable = $admin
          || ( $perms
            && ( $perms->can_publish_post
              || $perms->can_edit_all_posts || $perms->can_manage_feedback ) )
          ? 1 : 0;
    }    # otherwise we simply filter the list of objects

    my $list_pref = $app->list_pref('ping');
    my $class     = $app->model("ping") or return;
    my $blog_id   = $q->param('blog_id');
    my $blog;
    if ($blog_id) {
        $blog = $app->model('blog')->load($blog_id);
    }
    my %param = %$list_pref;
    my %terms;
    if ($blog_id) {
        $terms{blog_id} = $blog_id;
    }
    elsif ( !$app->user->is_superuser ) {
        $terms{blog_id} = [
            map    { $_->blog_id }
              grep { $_->can_view_feedback }
              MT::Permission->load( { author_id => $app->user->id } )
        ];
        return $app->errtrans("Permission denied.")
          unless @{ $terms{blog_id} };
    }
    my $cols           = $class->column_names;
    my $limit          = $list_pref->{rows};
    my $offset         = $app->param('offset') || 0;
    my $sort_direction = $q->param('sortasc') ? 'ascend' : 'descend';

    ## We load $limit + 1 records so that we can easily tell if we have a
    ## page of next entries to link to. Obviously we only display $limit
    ## entries.
    my %arg;
    if ( ( $app->param('tab') || '' ) eq 'junk' ) {
        $app->param( 'filter',     'junk_status' );
        $app->param( 'filter_val', '-1' );
        $param{filter_special} = 1;
        $param{filter_phrase}  = $app->translate('Junk TrackBacks');
    }
    else {
        $terms{'junk_status'} = [ 0, 1 ];
    }

    my $filter_key = $q->param('filter_key');
    if ( !$filter_key && !$app->param('filter') ) {
        $filter_key = 'default';
    }
    my @val        = $q->param('filter_val');
    my $filter_col = $q->param('filter');
    if ( $filter_col && ( my $val = $q->param('filter_val') ) ) {
        if ( $filter_col eq 'status' ) {
            $terms{visible} = $val eq 'approved' ? 1 : 0;
        }
        elsif ($filter_col eq 'category_id'
            || $filter_col eq 'entry_id' )
        {
            $arg{join} = $app->model('trackback')->join_on(
                undef,
                {
                    id          => \'= tbping_tb_id',
                    $filter_col => $val,
                    $blog_id ? ( blog_id => $blog_id ) : (),
                }
            );
            if ( $filter_col eq 'entry_id' ) {
                my $pkg   = $app->model('entry');
                my $entry = $pkg->load($val);
                $param{filter_phrase} = $app->translate(
"TrackBacks where <strong>[_1]</strong> is &quot;[_2]&quot;.",
                    $entry->class_label,
                    encode_html( $entry->title )
                );
            }
            elsif ( $filter_col eq 'category_id' ) {
                my $pkg = $app->model('category');
                my $cat = $pkg->load($val);
                $param{filter_phrase} = $app->translate(
"TrackBacks where <strong>[_1]</strong> is &quot;[_2]&quot;.",
                    $cat->class_label,
                    encode_html( $cat->label )
                );
            }
            $param{filter_special} = 1;
        }
        else {
            if ( $val[1] ) {
                $terms{$filter_col} = [ $val[0], $val[1] ];
                $arg{'range_incl'} = { $filter_col => 1 };
                $param{filter_val2}  = $val[1];
                $param{filter_range} = 1;
            }
            else {
                $terms{$filter_col} = $val;
            }
        }
        $param{filter_args} = "&filter=" . encode_url($filter_col) . "&filter_val=" . encode_url($val);
        $param{filter}     ||= $filter_col;
        $param{filter_val} ||= $val;
        $param{is_filtered} = 1;
        $param{is_ip_filter} = $filter_col eq "ip";
    }
    elsif ($filter_key) {
        my $filters = $app->registry("list_filters", "ping") || {};
        if ( my $filter = $filters->{$filter_key} ) {
            if ( my $code = $filter->{code}
                || $app->handler_to_coderef( $filter->{handler} ) )
            {
                $param{filter} = 1;
                $param{filter_key}   = $filter_key;
                $param{filter_label} = $filter->{label};
                $code->( \%terms, \%arg );
            }
        }
    }

    my $ping_class = $app->model('ping');
    my $total      = $ping_class->count( \%terms, \%arg ) || 0;
    $arg{'sort'}    = 'created_on';
    $arg{direction} = $sort_direction;
    $arg{limit}     = $limit + 1;
    if ( $total && $offset > $total - 1 ) {
        $arg{offset} = $offset = $total - $limit;
    }
    elsif ( ( $offset < 0 ) || ( $total - $offset < $limit ) ) {
        $arg{offset} = $offset = 0;
    }
    elsif ($offset) {
        $arg{offset} = $offset;
    }

    my $iter = $class->load_iter( \%terms, \%arg );
    my $data = $app->build_ping_table( iter => $iter, param => \%param );

    ## We tried to load $limit + 1 entries above; if we actually got
    ## $limit + 1 back, we know we have another page of entries.
    my $have_next_entry = @$data > $limit;
    pop @$data while @$data > $limit;
    if ($offset) {
        $param{prev_offset}     = 1;
        $param{prev_offset_val} = $offset - $limit;
        $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
    }
    if ($have_next_entry) {
        $param{next_offset}     = 1;
        $param{next_offset_val} = $offset + $limit;
    }

    $param{ping_count}         = scalar @$data;
    $param{limit}              = $limit;
    $param{offset}             = $offset;
    $param{list_filters}       = $app->list_filters('ping');
    $param{saved}              = $q->param('saved');
    $param{junked}             = $q->param('junked');
    $param{unjunked}           = $q->param('unjunked');
    $param{approved}           = $q->param('approved');
    $param{unapproved}         = $q->param('unapproved');
    $param{emptied}            = $q->param('emptied');
    $param{state_editable}     = $state_editable;
    $param{can_empty_junk}     = $can_empty_junk;
    $param{saved_deleted_ping} = $q->param('saved_deleted')
      || $q->param('saved_deleted_ping');
    $param{object_type}         = 'ping';
    $param{object_label}        = $ping_class->class_label;
    $param{object_label_plural} = $ping_class->class_label_plural;
    $param{search_label}        = $param{object_label_plural};
    $param{list_start}          = $offset + 1;
    $param{list_end}            = $offset + scalar @$data;
    $param{list_total}          = $total;
    $param{next_max}     = $param{list_total} - $limit if $param{list_total};
    $param{next_max}     = 0 if ( $param{next_max} || 0 ) < $offset + 1;
    $param{page_actions} = $app->page_actions('list_pings')
      || $app->page_actions('list_ping');
    $param{nav_trackbacks}    = 1;
    $param{has_expanded_mode} = 1;
    $param{tab}               = $app->param('tab') || 'pings';
    $param{ "tab_" . ( $app->param('tab') || 'pings' ) } = 1;

    unless ($blog_id) {
        $param{system_overview_nav} = 1;
        $param{nav_pings}           = 1;
    }
    $param{filter_spam} =
      ( $app->param('filter_key') && $app->param('filter_key') eq 'spam' );
    if ( $param{'tab'} ne 'junk' ) {
        $param{feed_name} = $app->translate("TrackBack Activity Feed");
        $param{feed_url} =
          $app->make_feed_link( 'ping',
            $blog_id ? { blog_id => $blog_id } : undef );
    }
    $param{screen_id} = "list-ping";
    $param{listing_screen} = 1;
    $app->add_breadcrumb( $app->translate('TrackBacks') );
    $app->load_tmpl( "list_ping.tmpl", \%param );
}

# takes param and one of load_args, iter, or items
sub build_ping_table {
    my $app = shift;
    my (%args) = @_;

    require MT::Entry;
    require MT::Trackback;
    require MT::Category;

    my $author    = $app->user;
    my $list_pref = $app->list_pref('ping');
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('ping');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
    }
    return [] unless $iter;
    my $limit = $args{limit};
    my $param = $args{param};

    my @data;
    my ( %blogs, %entries, %cats, %perms );
    my $excerpt_max_len = const('DISPLAY_LENGTH_EDIT_PING_TITLE_FROM_EXCERPT');
    my $title_max_len   = const('DISPLAY_LENGTH_EDIT_PING_BREAK_UP');
    while ( my $obj = $iter->() ) {
        my $row = $obj->column_values;
        my $blog = $blogs{ $obj->blog_id } ||= $obj->blog if $obj->blog_id;
        $row->{excerpt} = '[' . $app->translate("No Excerpt") . ']'
          unless ( $row->{excerpt} || '' ) ne '';
        if ( ( $row->{title} || '' ) eq ( $row->{source_url} || '' ) ) {
            $row->{title} = '[' . $app->translate("No Title") . ']';
        }
        if ( !defined( $row->{title} ) ) {
            $row->{title} =
              substr_text( $row->{excerpt} || "", 0, $excerpt_max_len ) . '...';
        }
        $row->{excerpt} ||= '';
        $row->{title}     = break_up_text( $row->{title},     $title_max_len );
        $row->{excerpt}   = break_up_text( $row->{excerpt},   $title_max_len );
        $row->{blog_name} = break_up_text( $row->{blog_name}, $title_max_len );
        $row->{object}    = $obj;
        push @data, $row;

        my $entry;
        my $cat;
        if ( my $tb_center = MT::Trackback->load( $obj->tb_id ) ) {
            if ( $tb_center->entry_id ) {
                $entry = $entries{ $tb_center->entry_id } ||=
                  $app->model('entry')->load( $tb_center->entry_id );
                my $class = $entry->class || 'entry';
                if ($entry) {
                    $row->{target_title} = $entry->title;
                    $row->{target_link}  = $app->uri(
                        'mode' => 'view',
                        args   => {
                            '_type' => $class,
                            id      => $entry->id,
                            blog_id => $entry->blog_id,
                            tab     => 'pings'
                        }
                    );
                }
                else {
                    $row->{target_title} =
                      ( '* ' . $app->translate('Orphaned TrackBack') . ' *' );
                }
                $row->{target_type} = $app->translate($class);
            }
            elsif ( $tb_center->category_id ) {
                $cat = $cats{ $tb_center->category_id } ||=
                  MT::Category->load( $tb_center->category_id );
                if ($cat) {
                    $row->{target_title} =
                      ( '* ' . $app->translate('Orphaned TrackBack') . ' *' );
                    $row->{target_title} = $cat->label;
                    $row->{target_link}  = $app->uri(
                        'mode' => 'view',
                        args   => {
                            '_type' => 'category',
                            id      => $cat->id,
                            blog_id => $cat->blog_id,
                            tab     => 'pings'
                        }
                    );
                }
                $row->{target_type} = $app->translate('category');
            }
        }
        if ( my $ts = $obj->created_on ) {
            $row->{created_on_time_formatted} =
              format_ts( LISTING_DATETIME_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_formatted} =
              format_ts( LISTING_DATE_FORMAT, $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_relative} = relative_date( $ts, time, $blog );
        }
        if ($blog) {
            $row->{weblog_id}   = $blog->id;
            $row->{weblog_name} = $blog->name;
        }
        else {
            $row->{weblog_name} =
              '* ' . $app->translate('Orphaned TrackBack') . ' *';
        }
        if ( $author->is_superuser() ) {
            $row->{has_edit_access} = 1;
            $row->{has_bulk_access} = 1;
        }
        else {
            my $perms = $perms{ $obj->blog_id } ||=
              $author->permissions( $obj->blog_id );
            $row->{has_bulk_access} = (
                (
                    $perms
                      && (
                        (
                            $entry && ( $perms->can_edit_all_posts
                                || $perms->can_manage_feedback )
                        )
                        || (
                            $cat
                            && (   $perms->can_edit_categories
                                || $perms->can_manage_feedback )
                        )
                      )
                )
                  || ( $cat && $author->id == $cat->author_id )
                  || (
                    $entry
                    && ( ( $author->id == $entry->author_id )
                        && $perms->can_publish_post )
                  )
            );
            $row->{has_edit_access} = (
                (
                    $perms
                      && (
                        (
                            $entry && ( $perms->can_edit_all_posts
                                || $perms->can_manage_feedback )
                        )
                        || (
                            $cat
                            && (   $perms->can_edit_categories
                                || $perms->can_manage_feedback )
                        )
                      )
                )
                  || ( $cat && $author->id == $cat->author_id )
                  || (
                    $entry
                    && ( ( $author->id == $entry->author_id )
                        && $perms->can_create_post )
                  )
            );
        }
    }
    return [] unless @data;

    $param->{ping_table}[0] = {%$list_pref};
    $param->{object_loop} = $param->{ping_table}[0]{object_loop} = \@data;
    $param->{ping_table}[0]{object_type} = 'ping';
    $app->load_list_actions( 'ping', $param );
    \@data;
}

sub list_entries {
    my $app = shift;
    my ($param) = @_;
    $param ||= {};

    require MT::Entry;
    my $type = $param->{type} || MT::Entry->class_type;
    my $pkg = $app->model($type) or return "Invalid request.";

    my $q     = $app->param;
    my $perms = $app->permissions;
    if ( $type eq 'page' ) {
        if ( $perms
            && ( !$perms->can_manage_pages ) )
        {
            return $app->errtrans("Permission denied.");
        }
    }
    else {
        if (
            $perms
            && (   !$perms->can_edit_all_posts
                && !$perms->can_create_post
                && !$perms->can_publish_post )
          )
        {
            return $app->errtrans("Permission denied.");
        }
    }

    my $list_pref = $app->list_pref($type);
    my %param     = %$list_pref;
    my $blog_id   = $q->param('blog_id');
    my %terms;
    $terms{blog_id} = $blog_id if $blog_id;
    $terms{class} = $type;
    my $limit = $list_pref->{rows};
    my $offset = $app->param('offset') || 0;

    if ( !$blog_id && !$app->user->is_superuser ) {
        require MT::Permission;
        $terms{blog_id} = [
            map { $_->blog_id }
              grep { $_->can_create_post || $_->can_edit_all_posts }
              MT::Permission->load( { author_id => $app->user->id } )
        ];
    }

    my %arg;
    my $filter_key = $q->param('filter_key') || '';
    my $filter_col = $q->param('filter')     || '';
    my $filter_val = $q->param('filter_val');

    # check blog_id for deciding to apply category filter or not
    my ( $filter_name, $filter_value );    # human-readable versions
    if ( !exists( $terms{$filter_col} ) ) {
        if ( $filter_col eq 'category_id' ) {
            $filter_name = $app->translate('Category');
            require MT::Category;
            my $cat = MT::Category->load($filter_val);
            return $app->errtrans( "Load failed: [_1]", MT::Category->errstr )
              unless $cat;
            if ( $cat->blog_id != $blog_id ) {
                $filter_key = '';
                $filter_col = '';
                $filter_val = '';
            }
            $filter_value = $cat->label;
        }
        elsif ( $filter_col eq 'asset_id' ) {
            $filter_name = $app->translate('Asset');
            my $asset_class = MT->model('asset');
            my $asset = $asset_class->load($filter_val);
            return $app->errtrans( "Load failed: [_1]", $asset_class->errstr )
              unless $asset;
            if ($asset->blog_id != $blog_id) {
                $filter_key = '';
                $filter_col = '';
                $filter_val = '';
            }
            $filter_value = $param{asset_label} = $asset->label;
        }
    }
    if ( $filter_col && $filter_val ) {
        if ( 'power_edit' eq $filter_col ) {
            $filter_col = 'id';
            unless ( 'ARRAY' eq ref($filter_val) ) {
                my @values = $app->param('filter_val');
                $filter_val = \@values;
            }
        }
        if ( !exists( $terms{$filter_col} ) ) {
            if ( $filter_col eq 'category_id' ) {
                $arg{'join'} = MT::Placement->join_on(
                    'entry_id',
                    { category_id => $filter_val },
                    { unique      => 1 }
                );
            }
            elsif ( $filter_col eq 'asset_id' ) {
                $arg{'join'} = MT->model('objectasset')->join_on(
                    'object_id',
                    { object_ds => $type,
                      asset_id  => $filter_val },
                    { unique    => 1 }
                );
            }
            elsif (( $filter_col eq 'normalizedtag' )
                || ( $filter_col eq 'exacttag' ) )
            {
                my $normalize = ( $filter_col eq 'normalizedtag' );
                require MT::Tag;
                require MT::ObjectTag;
                my $tag_delim   = chr( $app->user->entry_prefs->{tag_delim} );
                my @filter_vals = MT::Tag->split( $tag_delim, $filter_val );
                my @filter_tags = @filter_vals;
                if ($normalize) {
                    push @filter_tags, MT::Tag->normalize($_)
                      foreach @filter_vals;
                }
                my @tags = MT::Tag->load( { name => [@filter_tags] },
                    { binary => { name => 1 } } );
                my @tag_ids;
                foreach (@tags) {
                    push @tag_ids, $_->id;
                    if ($normalize) {
                        my @more = MT::Tag->load(
                            { n8d_id => $_->n8d_id ? $_->n8d_id : $_->id } );
                        push @tag_ids, $_->id foreach @more;
                    }
                }
                @tag_ids = (0) unless @tags;
                $arg{'join'} = MT::ObjectTag->join_on(
                    'object_id',
                    {
                        tag_id            => \@tag_ids,
                        object_datasource => $pkg->datasource
                    },
                    { unique => 1 }
                );
            }
            else {
                $terms{$filter_col} = $filter_val;
            }
            $param{filter_args} = "&filter=" . encode_url($filter_col) . "&filter_val=" . encode_url($filter_val);

            if (   ( $filter_col eq 'normalizedtag' )
                || ( $filter_col eq 'exacttag' ) )
            {
                $filter_name  = $app->translate('Tag');
                $filter_value = $filter_val;
            }
            elsif ( $filter_col eq 'author_id' ) {
                $filter_name = $app->translate('User');
                my $author = MT::Author->load($filter_val);
                return $app->errtrans( "Load failed: [_1]", MT::Author->errstr )
                  unless $author;
                $filter_value = $author->name;
            }
            elsif ( $filter_col eq 'status' ) {
                $filter_name = $app->translate('Entry Status');
                $filter_value =
                  $app->translate( MT::Entry::status_text($filter_val) );
            }
            if ( $filter_name && $filter_value ) {
                $param{filter}                        = $filter_col;
                $param{ 'filter_col_' . $filter_col } = 1;
                $param{filter_val}                    = $filter_val;
            }
        }
        $param{filter_unpub} = $filter_col eq 'status';
    }
    elsif ($filter_key) {
        my $filters = $app->registry("list_filters", "entry") || {};
        if ( my $filter = $filters->{$filter_key} ) {
            if ( my $code = $filter->{code}
                || $app->handler_to_coderef( $filter->{handler} ) )
            {
                $param{filter_key}   = $filter_key;
                $param{filter_label} = $filter->{label};
                $code->( \%terms, \%arg );
            }
        }
    }
    require MT::Category;
    require MT::Placement;

    my $total = $pkg->count( \%terms, \%arg ) || 0;
    $arg{'sort'} = $type eq 'page' ? 'modified_on' : 'authored_on';
    $arg{direction} = 'descend';
    $arg{limit}     = $limit + 1;
    if ( $total && $offset > $total - 1 ) {
        $arg{offset} = $offset = $total - $limit;
    }
    elsif ( ( $offset < 0 ) || ( $total - $offset < $limit ) ) {
        $arg{offset} = $offset = 0;
    }
    else {
        $arg{offset} = $offset if $offset;
    }

    my $iter = $pkg->load_iter( \%terms, \%arg );

    my $is_power_edit = $q->param('is_power_edit');
    if ($is_power_edit) {
        $param{has_expanded_mode} = 0;
        delete $param{view_expanded};
    }
    else {
        $param{has_expanded_mode} = 1;
    }
    my $data = $app->build_entry_table(
        iter          => $iter,
        is_power_edit => $is_power_edit,
        param         => \%param,
        type          => $type
    );
    delete $param{entry_table} unless @$data;

    ## We tried to load $limit + 1 entries above; if we actually got
    ## $limit + 1 back, we know we have another page of entries.
    my $have_next_entry = @$data > $limit;
    pop @$data while @$data > $limit;
    if ($offset) {
        $param{prev_offset}     = 1;
        $param{prev_offset_val} = $offset - $limit;
        $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
    }
    if ($have_next_entry) {
        $param{next_offset}     = 1;
        $param{next_offset_val} = $offset + $limit;
    }

    $iter = MT::Author->load_iter(
        { type => MT::Author::AUTHOR() },
        {
            'join' => $pkg->join_on(
                'author_id',
                { $blog_id ? ( blog_id => $blog_id ) : () },
                {
                    'unique'  => 1,
                    'sort'    => 'authored_on',
                    direction => 'descend'
                }
            ),
        }
    );
    my %seen;
    my @authors;
    while ( my $au = $iter->() ) {
        next if $seen{ $au->id };
        $seen{ $au->id } = 1;
        my $row = {
            author_name => $au->name,
            author_id   => $au->id
        };
        push @authors, $row;
        if ( @authors == 50 ) {
            $iter->('finish');
            last;
        }
    }
    $param{entry_author_loop} = \@authors;

    $iter = $app->model('asset')->load_iter(
        { class => '*', blog_id => $blog_id },
        {
            'join' => MT->model('objectasset')->join_on(
                'asset_id',
                {},
                { unique => 1 }
            ),
            'sort'    => 'created_on',
            direction => 'descend',
        }
    );
    %seen = ();
    my @assets;
    while ( my $asset = $iter->() ) {
        next if $seen{ $asset->id };
        $seen{ $asset->id } = 1;
        my $row = {
            asset_label => $asset->label,
            asset_id    => $asset->id,
        };
        push @assets, $row;
        if ( @assets == 50 ) {
            $iter->('finish');
            last;
        }
    }
    if ($filter_col eq 'asset_id' && !$seen{$filter_val}) {
        push @assets, {
            asset_label => $param{asset_label},
            asset_id    => $filter_val,
        };
    }
    $param{entry_asset_loop} = \@assets;

    $param{page_actions}        = $app->page_actions( $app->mode );
    $param{list_filters}        = $app->list_filters('entry');
    $param{can_power_edit}      = $blog_id && !$is_power_edit;
    $param{can_republish}       = $blog_id ? $perms->can_rebuild : 1;
    $param{is_power_edit}       = $is_power_edit;
    $param{saved_deleted}       = $q->param('saved_deleted');
    $param{saved}               = $q->param('saved');
    $param{limit}               = $limit;
    $param{offset}              = $offset;
    $param{object_type}         = $type;
    $param{object_label}        = $pkg->class_label;
    $param{object_label_plural} = $param{search_label} =
      $pkg->class_label_plural;
    $param{list_start}  = $offset + 1;
    $param{list_end}    = $offset + scalar @$data;
    $param{list_total}  = $total;
    $param{next_max}    = $param{list_total} - $limit;
    $param{next_max}    = 0 if ( $param{next_max} || 0 ) < $offset + 1;
    $param{nav_entries} = 1;
    $param{feed_label}  = $app->translate( "[_1] Feed", $pkg->class_label );
    $param{feed_url} =
      $app->make_feed_link( $type, $blog_id ? { blog_id => $blog_id } : undef );
    $app->add_breadcrumb( $pkg->class_label_plural );
    $param{listing_screen} = 1;

    unless ($blog_id) {
        $param{system_overview_nav} = 1;
    }
    $param{container_label} = $pkg->container_label;
    unless ( $param{screen_class} ) {
        $param{screen_class} = "list-$type";
        $param{screen_class} .= " list-entry"
          if $param{object_type} eq "page";  # to piggyback on list-entry styles
    }
    $param{mode}            = $app->mode;
    if ( my $blog = MT::Blog->load($blog_id) ) {
        $param{sitepath_unconfigured} = $blog->site_path ? 0 : 1;
    }

    $param->{return_args} ||= $app->make_return_args;
    my @return_args = grep { $_ !~ /offset=\d/ } split /&/, $param->{return_args};
    $param{return_args} = join '&', @return_args;
    $param{return_args} .= "&offset=$offset" if $offset;
    $param{screen_id} = "list-entry";
    $param{screen_id} = "list-page"
      if $param{object_type} eq "page";
    if ( $param{is_power_edit} ) {
        $param{screen_id} = "batch-edit-entry";
        $param{screen_id} = "batch-edit-page"
          if $param{object_type} eq "page";
        $param{screen_class} .= " batch-edit";
    }
    $app->load_tmpl( "list_entry.tmpl", \%param );
}

# FIXME: hack to add pages in here and above. search for "list_pages"

sub list_pages {
    my $app = shift;
    $app->param( 'type', 'page' );
    $app->list_entries( { type => 'page' } );
}

sub build_entry_table {
    my $app = shift;
    my (%args) = @_;

    my $app_author = $app->user;
    my $perms      = $app->permissions;
    my $type       = $args{type};
    my $class      = $app->model($type);

    my $list_pref = $app->list_pref($type);
    if ( $args{is_power_edit} ) {
        delete $list_pref->{view_expanded};
    }
    my $iter;
    if ( $args{load_args} ) {
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { shift @{ $args{items} } };
    }
    return [] unless $iter;
    my $limit         = $args{limit};
    my $is_power_edit = $args{is_power_edit} || 0;
    my $param         = $args{param} || {};

    ## Load list of categories for display in filter pulldown (and selection
    ## pulldown on power edit page).
    my ( $c_data, %cats );
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        $c_data = $app->_build_category_list(
            blog_id => $blog_id,
            type    => $class->container_type,
        );
        my $i = 0;
        for my $row (@$c_data) {
            $row->{category_index} = $i++;
            my $spacer = $row->{category_label_spacer} || '';
            $spacer =~ s/\&nbsp;/\\u00A0/g;
            $row->{category_label_js} =
              $spacer . encode_js( $row->{category_label} );
            $cats{ $row->{category_id} } = $row;
        }
        $param->{category_loop} = $c_data;
    }

    my ( $date_format, $datetime_format );

    ## Load list of users for display in filter pulldown (and selection
    ## pulldown on power edit page).
    my ( @a_data, %authors );
    if ($is_power_edit) {

        # FIXME: Scaling issue for lots of authors on one blog
        my $auth_iter = MT::Author->load_iter(
            { type => MT::Author::AUTHOR() },
            {
                'join' => MT::Permission->join_on(
                    'author_id', { blog_id => $blog_id }
                )
            }
        );
        while ( my $author = $auth_iter->() ) {
            $authors{ $author->id } = $author->name;
            push @a_data,
              {
                author_id   => $author->id,
                author_name => encode_js( $author->name )
              };
        }
        @a_data = sort { $a->{author_name} cmp $b->{author_name} } @a_data;
        my $i = 0;
        for my $row (@a_data) {
            $row->{author_index} = $i++;
        }
        $param->{author_loop} = \@a_data;
        $date_format          = "%Y.%m.%d";
        $datetime_format      = "%Y-%m-%d %H:%M:%S";
    }
    else {
        $date_format     = LISTING_DATE_FORMAT;
        $datetime_format = LISTING_DATETIME_FORMAT;
    }

    my ( @cat_list, @auth_list );
    if ($is_power_edit) {
        @cat_list =
          sort { $cats{$a}->{category_index} <=> $cats{$b}->{category_index} }
          keys %cats;
        @auth_list = sort { $authors{$a} cmp $authors{$b} } keys %authors;
    }

    my @data;
    my %blogs;
    require MT::Blog;
    my $title_max_len   = const('DISPLAY_LENGTH_EDIT_ENTRY_TITLE');
    my $excerpt_max_len = const('DISPLAY_LENGTH_EDIT_ENTRY_TEXT_FROM_EXCERPT');
    my $text_max_len    = const('DISPLAY_LENGTH_EDIT_ENTRY_TEXT_BREAK_UP');
    my %blog_perms;
    $blog_perms{ $perms->blog_id } = $perms if $perms;
    while ( my $obj = $iter->() ) {
        my $blog_perms;
        if ( !$app_author->is_superuser() ) {
            $blog_perms = $blog_perms{ $obj->blog_id }
              || $app_author->blog_perm( $obj->blog_id );
        }

        my $row = $obj->column_values;
        $row->{text} ||= '';
        if ( my $ts =
            ( $type eq 'page' ) ? $obj->modified_on : $obj->authored_on )
        {
            $row->{created_on_formatted} =
              format_ts( $date_format, $ts, $obj->blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_time_formatted} =
              format_ts( $datetime_format, $ts, $obj->blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_relative} =
              relative_date( $ts, time, $obj->blog );
        }
        my $author = $obj->author;
        $row->{author_name} =
          $author ? $author->name : $app->translate('(user deleted)');
        if ( my $cat = $obj->category ) {
            $row->{category_label}    = $cat->label;
            $row->{category_basename} = $cat->basename;
        }
        else {
            $row->{category_label}    = '';
            $row->{category_basename} = '';
        }
        $row->{file_extension} = $obj->blog ? $obj->blog->file_extension : '';
        $row->{title_short} = $obj->title;
        if ( !defined( $row->{title_short} ) || $row->{title_short} eq '' ) {
            my $title = remove_html( $obj->text );
            $row->{title_short} =
              substr_text( defined($title) ? $title : "", 0, $title_max_len )
              . '...';
        }
        else {
            $row->{title_short} = remove_html( $row->{title_short} );
            $row->{title_short} =
              substr_text( $row->{title_short}, 0, $title_max_len + 3 ) . '...'
              if length_text( $row->{title_short} ) > $title_max_len;
        }
        if ( $row->{excerpt} ) {
            $row->{excerpt} = remove_html( $row->{excerpt} );
        }
        if ( !$row->{excerpt} ) {
            my $text = remove_html( $row->{text} ) || '';
            $row->{excerpt} = first_n_text( $text, $excerpt_max_len );
            if ( length($text) > length( $row->{excerpt} ) ) {
                $row->{excerpt} .= ' ...';
            }
        }
        $row->{text} = break_up_text( $row->{text}, $text_max_len )
          if $row->{text};
        $row->{title_long} = remove_html( $obj->title );
        $row->{status_text} =
          $app->translate( MT::Entry::status_text( $obj->status ) );
        $row->{ "status_" . MT::Entry::status_text( $obj->status ) } = 1;
        $row->{has_edit_access} = $app_author->is_superuser
          || ( ( 'entry' eq $type )
            && $blog_perms
            && $blog_perms->can_edit_entry( $obj, $app_author ) )
          || ( ( 'page' eq $type )
            && $blog_perms
            && $blog_perms->can_manage_pages );
        if ($is_power_edit) {
            $row->{has_publish_access} = $app_author->is_superuser
              || ( ( 'entry' eq $type )
                && $blog_perms
                && $blog_perms->can_edit_entry( $obj, $app_author, 1 ) )
              || ( ( 'page' eq $type )
                && $blog_perms
                && $blog_perms->can_manage_pages );
            $row->{is_editable} = $row->{has_edit_access};

            ## This is annoying. In order to generate and pre-select the
            ## category, user, and status pull down menus, we need to
            ## have a separate *copy* of the list of categories and
            ## users for every entry listed, so that each row in the list
            ## can "know" whether it is selected for this entry or not.
            my @this_c_data;
            my $this_category_id = $obj->category ? $obj->category->id : undef;
            for my $c_id (@cat_list) {
                push @this_c_data, { %{ $cats{$c_id} } };
                $this_c_data[-1]{category_is_selected} = $this_category_id
                  && $this_category_id == $c_id ? 1 : 0;
            }
            $row->{row_category_loop} = \@this_c_data;

            my @this_a_data;
            my $this_author_id = $obj->author_id;
            for my $a_id (@auth_list) {
                push @this_a_data,
                  {
                    author_name => $authors{$a_id},
                    author_id   => $a_id
                  };
                $this_a_data[-1]{author_is_selected} = $this_author_id
                  && $this_author_id == $a_id ? 1 : 0;
            }
            unless ( $obj->author ) {
                push @this_a_data,
                  {
                    author_name => $app->translate(
                        '(user deleted - ID:[_1])',
                        $obj->author_id
                    ),
                    author_id          => $obj->author_id,
                    author_is_selected => 1,
                  };
            }
            $row->{row_author_loop} = \@this_a_data;
        }
        if ( my $blog = $blogs{ $obj->blog_id } ||=
            MT::Blog->load( $obj->blog_id ) )
        {
            $row->{weblog_id}   = $blog->id;
            $row->{weblog_name} = $blog->name;
        }
        if ( $obj->status == MT::Entry::RELEASE() ) {
            $row->{entry_permalink} = $obj->permalink;
        }
        $row->{object} = $obj;
        push @data, $row;
    }
    return [] unless @data;

    $param->{entry_table}[0] = {%$list_pref};
    $param->{object_loop} = $param->{entry_table}[0]{object_loop} = \@data;
    $app->load_list_actions( $type, \%$param )
      unless $is_power_edit;
    \@data;
}
*build_page_table = \&build_entry_table;

sub save_entries {
    my $app   = shift;
    my $perms = $app->permissions;
    my $type  = $app->param('_type');
    return $app->errtrans("Permission denied.")
      unless $perms
      && (
        $type eq 'page'
        ? ( $perms->can_manage_pages )
        : (      $perms->can_publish_post
              || $perms->can_create_post
              || $perms->can_edit_all_posts )
      );

    $app->validate_magic() or return;

    my $q = $app->param;
    my @p = $q->param;
    require MT::Entry;
    require MT::Placement;
    require MT::Log;
    my $blog_id        = $q->param('blog_id');
    my $this_author    = $app->user;
    my $this_author_id = $this_author->id;
    for my $p (@p) {
        next unless $p =~ /^category_id_(\d+)/;
        my $id    = $1;
        my $entry = MT::Entry->load($id);
        return $app->error( $app->translate("Permission denied.") )
          unless ( $perms->can_publish_post
            || $perms->can_create_post
            || $perms->can_edit_all_posts );
        my $orig_obj = $entry->clone;
        if ( $perms->can_edit_entry( $entry, $this_author ) ) {
            my $author_id = $q->param( 'author_id_' . $id );
            $entry->author_id( $author_id ? $author_id : 0 );
            $entry->title( scalar $q->param( 'title_' . $id ) );
        }
        if ( $perms->can_edit_entry( $entry, $this_author, 1 ) )
        {    ## can he/she change status?
            $entry->status( scalar $q->param( 'status_' . $id ) );
            my $co = $q->param( 'created_on_' . $id );
            unless ( $co =~
                m!(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})(?::(\d{2}))?! )
            {
                return $app->error(
                    $app->translate(
"Invalid date '[_1]'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.",
                        $co
                    )
                );
            }
            my $s = $6 || 0;

            # Emit an error message if the date is bogus.
            return $app->error(
                $app->translate(
"Invalid date '[_1]'; authored on dates should be real dates.",
                    $co
                )
              )
              if $s > 59
              || $s < 0
              || $5 > 59
              || $5 < 0
              || $4 > 23
              || $4 < 0
              || $2 > 12
              || $2 < 1
              || $3 < 1
              || ( MT::Util::days_in( $2, $1 ) < $3
                && !MT::Util::leap_day( $0, $1, $2 ) );

            # FIXME: Should be assigning the publish_date field here
            my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $1, $2, $3, $4, $5, $s;
            if ($type eq 'page' ) {
                $entry->modified_on($ts);
            } else {
                $entry->authored_on($ts);
            }
        }
        $app->run_callbacks( 'cms_pre_save.' . $type, $app, $entry, $orig_obj )
          || return $app->error(
            $app->translate(
                "Saving [_1] failed: [_2]",
                $entry->class_label, $app->errstr
            )
          );
        $entry->save
          or return $app->error(
            $app->translate(
                "Saving entry '[_1]' failed: [_2]", $entry->title,
                $entry->errstr
            )
          );
        my $cat_id = $q->param("category_id_$id");
        my $place  = MT::Placement->load(
            {
                entry_id   => $id,
                is_primary => 1
            }
        );
        if ( $place && !$cat_id ) {
            $place->remove
              or return $app->error(
                $app->translate(
                    "Removing placement failed: [_1]",
                    $place->errstr
                )
              );
        }
        elsif ($cat_id) {
            unless ($place) {
                $place = MT::Placement->new;
                $place->entry_id($id);
                $place->blog_id($blog_id);
                $place->is_primary(1);
            }
            $place->category_id( scalar $q->param($p) );
            $place->save
              or return $app->error(
                $app->translate(
                    "Saving placement failed: [_1]",
                    $place->errstr
                )
              );
        }
        my $message;
        if ( $orig_obj->status ne $entry->status ) {
            $message = $app->translate(
"[_1] '[_2]' (ID:[_3]) edited and its status changed from [_4] to [_5] by user '[_6]'",
                $entry->class_label,
                $entry->title,
                $entry->id,
                $app->translate( MT::Entry::status_text( $orig_obj->status ) ),
                $app->translate( MT::Entry::status_text( $entry->status ) ),
                $this_author->name
            );
        }
        else {
            $message =
              $app->translate( "[_1] '[_2]' (ID:[_3]) edited by user '[_4]'",
                $entry->class_label, $entry->title, $entry->id,
                $this_author->name );
        }
        $app->log(
            {
                message  => $message,
                level    => MT::Log::INFO(),
                class    => $entry->class,
                category => 'edit',
                metadata => $entry->id
            }
        );
        $app->run_callbacks( 'cms_post_save.' . $type, $app, $entry, $orig_obj );
    }
    $app->add_return_arg( 'saved' => 1, is_power_edit => 1 );
    $app->call_return;
}
*save_pages = \&save_entries;

sub remove_preview_file {
    my $app = shift;

    # Clear any preview file that may exist (returning from
    # a preview using the 'reedit', 'cancel' or 'save' buttons)
    if ( my $preview = $app->param('_preview_file') ) {
        require MT::Session;
        if (
            my $tf = MT::Session->load(
                {
                    id   => $preview,
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

sub save_entry {
    my $app = shift;
    $app->validate_magic or return;

    $app->remove_preview_file;

    if ( $app->param('is_power_edit') ) {
        return $app->save_entries(@_);
    }
    my $author = $app->user;
    my $type = $app->param('_type') || 'entry';

    my $class = $app->model($type)
      or retrun $app->errtrans("Invalid parameter");

    my $cat_class = $app->model( $class->container_type );

    my $perms = $app->permissions
      or return $app->errtrans("Permission denied.");

    if ( $type eq 'page' ) {
        return $app->errtrans("Permission denied.")
          unless $perms->can_manage_pages;
    }

    my $id = $app->param('id');
    if ( !$id ) {
        return $app->errtrans("Permission denied.")
          unless ( ( 'entry' eq $type ) && $perms->can_create_post )
          || ( ( 'page' eq $type ) && $perms->can_manage_pages );
    }

    $app->validate_magic() or return;

    # check for autosave
    if ( $app->param('_autosave') ) {
        return $app->autosave_object();
    }

    require MT::Blog;
    my $blog_id = $app->param('blog_id');
    my $blog    = MT::Blog->load($blog_id);

    my $archive_type;

    my ( $obj, $orig_obj, $orig_file );
    if ($id) {
        $obj = $class->load($id)
          || return $app->error(
            $app->translate( "No such [_1].", $class->class_label ) );
        return $app->error( $app->translate("Invalid parameter") )
          unless $obj->blog_id == $blog_id;
        if ( $type eq 'entry' ) {
            return $app->error( $app->translate("Permission denied.") )
              unless $perms->can_edit_entry( $obj, $author );
            return $app->error( $app->translate("Permission denied.") )
              if ( $obj->status ne $app->param('status') )
              && !( $perms->can_edit_entry( $obj, $author, 1 ) );
            $archive_type = 'Individual';
        }
        elsif ( $type eq 'page' ) {
            $archive_type = 'Page';
        }
        $orig_obj = $obj->clone;
        $orig_file = archive_file_for( $orig_obj, $blog, $archive_type );
    }
    else {
        $obj = $class->new;
    }
    my $status_old = $id ? $obj->status : 0;
    my $names = $obj->column_names;

    ## Get rid of category_id param, because we don't want to just set it
    ## in the Entry record; save it for later when we will set the Placement.
    my ( $cat_id, @add_cat ) = split /\s*,\s*/,
      ( $app->param('category_ids') || '' );
    $app->delete_param('category_id');
    if ($id) {
        ## Delete the author_id param (if present), because we don't want to
        ## change the existing author.
        $app->delete_param('author_id');
    }

    my %values = map { $_ => scalar $app->param($_) } @$names;
    delete $values{'id'} unless $app->param('id');
    ## Strip linefeed characters.
    for my $col (qw( text excerpt text_more keywords )) {
        $values{$col} =~ tr/\r//d if $values{$col};
    }
    $values{allow_comments} = 0
      if !defined( $values{allow_comments} )
      || $app->param('allow_comments') eq '';
    delete $values{week_number}
      if ( $app->param('week_number') || '' ) eq '';
    delete $values{basename}
      unless $perms->can_publish_post || $perms->can_edit_all_posts;
    $obj->set_values( \%values );
    $obj->allow_pings(0)
      if !defined $app->param('allow_pings')
      || $app->param('allow_pings') eq '';
    my $ao_d = $app->param('authored_on_date');
    my $ao_t = $app->param('authored_on_time');

    if ( !$id ) {

        #  basename check for this new entry...
        if (   ( my $basename = $app->param('basename') )
            && !$app->param('basename_manual')
            && $type eq 'entry' )
        {
            my $cnt =
              $class->count( { blog_id => $blog_id, basename => $basename } );
            if ($cnt) {
                $obj->basename( MT::Util::make_unique_basename($obj) );
            }
        }
    }

    if ( $type eq 'page' ) {

        # -1 is a special id for identifying the 'root' folder
        $cat_id = 0 if $cat_id == -1;
        my $dup_it = $class->load_iter(
            {
                blog_id  => $blog_id,
                basename => $obj->basename,
                class    => 'page',
                ( $id ? ( id => $id ) : () )
            },
            { ( $id ? ( not => { id => 1 } ) : () ) }
        );
        while ( my $p = $dup_it->() ) {
            my $p_folder = $p->folder;
            my $dup_folder_path =
              defined $p_folder ? $p_folder->publish_path() : '';
            my $folder = MT::Folder->load($cat_id) if $cat_id;
            my $folder_path = defined $folder ? $folder->publish_path() : '';
            return $app->error(
                $app->translate(
"Same Basename has already been used. You should use an unique basename."
                )
            ) if ( $dup_folder_path eq $folder_path );
        }

    }

    if ( $type eq 'entry' ) {
        $obj->status( MT::Entry::HOLD() )
          if !$id
          && !$perms->can_publish_post
          && !$perms->can_edit_all_posts;
    }

    my $filter_result = $app->run_callbacks( 'cms_save_filter.' . $type, $app );

    if ( !$filter_result ) {
        my %param = ();
        $param{error}       = $app->errstr;
        $param{return_args} = $app->param('return_args');
        return $app->edit_object( \%param );
    }

    # check to make sure blog has site url and path defined.
    # otherwise, we can't publish a released entry
    if ( ( $obj->status || 0 ) != MT::Entry::HOLD() ) {
        if ( !$blog->site_path || !$blog->site_url ) {
            return $app->error(
                $app->translate(
"Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined."
                )
            );
        }
    }

    my ( $previous_old, $next_old );
    if (   ( $perms->can_publish_post || $perms->can_edit_all_posts )
        && ($ao_d) )
    {
        my $ao = $ao_d . ' ' . $ao_t;
        unless (
            $ao =~ m!^(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})(?::(\d{2}))?$! )
        {
            return $app->error(
                $app->translate(
"Invalid date '[_1]'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.",
$ao
                )
            );
        }
        my $s = $6 || 0;
        return $app->error(
            $app->translate(
                "Invalid date '[_1]'; authored on dates should be real dates.",
                $ao
            )
          )
          if (
               $s > 59
            || $s < 0
            || $5 > 59
            || $5 < 0
            || $4 > 23
            || $4 < 0
            || $2 > 12
            || $2 < 1
            || $3 < 1
            || ( MT::Util::days_in( $2, $1 ) < $3
                && !MT::Util::leap_day( $0, $1, $2 ) )
          );
        if ($obj->authored_on) {
            $previous_old = $obj->previous(1);
            $next_old     = $obj->next(1);
        }
        my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $1, $2, $3, $4, $5, $s;
        $obj->authored_on($ts);
    }
    my $is_new = $obj->id ? 0 : 1;

    $app->_translate_naughty_words($obj);

    $obj->modified_by( $author->id ) unless $is_new;

    $app->run_callbacks( 'cms_pre_save.' . $type, $app, $obj, $orig_obj )
      || return $app->error(
        $app->translate(
            "Saving [_1] failed: [_2]",
            $class->class_label, $app->errstr
        )
      );

    $obj->save
      or return $app->error(
        $app->translate(
            "Saving [_1] failed: [_2]",
            $class->class_label, $obj->errstr
        )
      );

    my $message;
    if ($is_new) {
        $message =
          $app->translate( "[_1] '[_2]' (ID:[_3]) added by user '[_4]'",
            $class->class_label, $obj->title, $obj->id, $author->name );
    }
    elsif ( $orig_obj->status ne $obj->status ) {
        $message = $app->translate(
"[_1] '[_2]' (ID:[_3]) edited and its status changed from [_4] to [_5] by user '[_6]'",
            $class->class_label,
            $obj->title,
            $obj->id,
            $app->translate( MT::Entry::status_text( $orig_obj->status ) ),
            $app->translate( MT::Entry::status_text( $obj->status ) ),
            $author->name
        );

    }
    else {
        $message =
          $app->translate( "[_1] '[_2]' (ID:[_3]) edited by user '[_4]'",
            $class->class_label, $obj->title, $obj->id, $author->name );
    }
    require MT::Log;
    $app->log(
        {
            message => $message,
            level   => MT::Log::INFO(),
            class   => $type,
            $is_new ? ( category => 'new' ) : ( category => 'edit' ),
            metadata => $obj->id
        }
    );

    my $error_string = MT::callback_errstr();

    ## Now that the object is saved, we can be certain that it has an
    ## ID. So we can now add/update/remove the primary placement.
    require MT::Placement;
    my $place =
      MT::Placement->load( { entry_id => $obj->id, is_primary => 1 } );
    if ($cat_id) {
        unless ($place) {
            $place = MT::Placement->new;
            $place->entry_id( $obj->id );
            $place->blog_id( $obj->blog_id );
            $place->is_primary(1);
        }
        $place->category_id($cat_id);
        $place->save;
    }
    else {
        if ( $place ) {
            $place->remove;
        }
    }

    my $placements_updated;

    # save secondary placements...
    my @place = MT::Placement->load(
        {
            entry_id   => $obj->id,
            is_primary => 0
        }
    );
    for my $place (@place) {
        $place->remove;
        $placements_updated = 1;
    }
    for my $cat_id (@add_cat) {
        my $cat = $cat_class->load($cat_id);

        # blog_id sanity check
        next if $cat->blog_id != $obj->blog_id;

        my $place = MT::Placement->new;
        $place->entry_id( $obj->id );
        $place->blog_id( $obj->blog_id );
        $place->is_primary(0);
        $place->category_id($cat_id);
        $place->save
          or return $app->error(
            $app->translate( "Saving placement failed: [_1]", $place->errstr )
          );
        $placements_updated = 1;
    }

    $app->run_callbacks( 'cms_post_save.' . $type, $app, $obj, $orig_obj );

    ## If the saved status is RELEASE, or if the *previous* status was
    ## RELEASE, then rebuild entry archives, indexes, and send the
    ## XML-RPC ping(s). Otherwise the status was and is HOLD, and we
    ## don't have to do anything.
    if ( ( $obj->status || 0 ) == MT::Entry::RELEASE()
        || $status_old eq MT::Entry::RELEASE() )
    {
        if ( $app->config('DeleteFilesAtRebuild') && $orig_obj ) {
            my $file = archive_file_for( $obj, $blog, $archive_type );
            if ( $file ne $orig_file || $obj->status != MT::Entry::RELEASE() ) {
                $app->publisher->remove_entry_archive_file(
                    Entry       => $orig_obj,
                    ArchiveType => $archive_type
                );
            }
        }

        # If there are no static pages, just rebuild indexes.
        if ( $blog->count_static_templates($archive_type) == 0
            || MT::Util->launch_background_tasks() )
        {
            my $res = MT::Util::start_background_task(
                sub {
                    $app->rebuild_entry(
                        Entry             => $obj,
                        BuildDependencies => 1,
                        OldEntry          => $orig_obj,
                        OldPrevious       => ($previous_old)
                        ? $previous_old->id
                        : undef,
                        OldNext => ($next_old) ? $next_old->id : undef
                    ) or return $app->publish_error();
                    $app->run_callbacks( 'rebuild', $blog );
                    1;
                }
            );
            return unless $res;
            return $app->ping_continuation(
                $obj, $blog,
                OldStatus => $status_old,
                IsNew     => $is_new,
            );
        }
        else {
            return $app->redirect(
                $app->uri(
                    'mode' => 'start_rebuild',
                    args   => {
                        blog_id    => $obj->blog_id,
                        'next'     => 0,
                        type       => 'entry-' . $obj->id,
                        entry_id   => $obj->id,
                        is_new     => $is_new,
                        old_status => $status_old,
                        (
                            $previous_old
                            ? ( old_previous => $previous_old->id )
                            : ()
                        ),
                        ( $next_old ? ( old_next => $next_old->id ) : () )
                    }
                )
            );
        }
    }
    $app->_finish_rebuild_ping( $obj, !$id );
}

sub publish_error {
    my $app = shift;
    my ($msg) = @_;
    if (defined $app->errstr) {
        require MT::Log;
        $app->log({
            message => $app->translate("Error during publishing: [_1]", (defined $msg ? $msg : $app->errstr)),
            class => "system",
            level => MT::Log::ERROR(),
            category => "publish",
        })
    }
    return undef;
}

sub ping_continuation {
    my $app = shift;
    my ( $entry, $blog, %options ) = @_;
    my $list = $app->needs_ping(
        Entry     => $entry,
        Blog      => $blog,
        OldStatus => $options{OldStatus}
    );
    require MT::Entry;
    if ( $entry->status == MT::Entry::RELEASE() && $list ) {
        my @urls = map { { url => $_ } } @$list;
        $app->load_tmpl(
            'pinging.tmpl',
            {
                blog_id    => $blog->id,
                entry_id   => $entry->id,
                old_status => $options{OldStatus},
                is_new     => $options{IsNew},
                url_list   => \@urls,
            }
        );
    }
    else {
        $app->_finish_rebuild_ping( $entry, $options{IsNew} );
    }
}

sub _finish_rebuild_ping {
    my $app = shift;
    my ( $entry, $is_new, $ping_errors ) = @_;
    $app->redirect(
        $app->uri(
            'mode' => 'view',
            args   => {
                '_type' => $entry->class,
                blog_id => $entry->blog_id,
                id      => $entry->id,
                ( $is_new ? ( saved_added => 1 ) : ( saved_changes => 1 ) ),
                ( $ping_errors ? ( ping_errors => 1 ) : () )
            }
        )
    );
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
        my $cat_entry_count_iter =
          MT::Placement->count_group_by( { blog_id => $blog_id },
            { group => ['category_id'] } );
        while ( my ( $count, $category_id ) = $cat_entry_count_iter->() ) {
            $placement_counts->{$category_id} = $count;
        }

        $tb_counts = {};
        my $tb_count_iter =
          MT::TBPing->count_group_by(
            { blog_id => $blog_id, junk_status => [ 0, 1 ] },
            { group   => ['tb_id'] } );
        while ( my ( $count, $tb_id ) = $tb_count_iter->() ) {
            $tb_counts->{$tb_id} = $count;
        }
        my $tb_iter = MT::Trackback->load_iter(
            {
                blog_id     => $blog_id,
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
            $row->{category_label_full} = $row->{category_basename} . '/'
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
            $row->{category_entrycount} =
              $placement_counts
              ? ( $placement_counts->{ $obj->id } || 0 )
              : MT::Placement->count( { category_id => $obj->id } );
            if ( my $tb = $tb{ $obj->id } ) {
                $row->{has_tb} = 1;
                $row->{tb_id}  = $tb->id;
                $row->{category_tbcount} =
                  $tb_counts
                  ? ( $tb_counts->{ $tb->id } || 0 )
                  : MT::TBPing->count(
                    {
                        tb_id       => $tb->id,
                        junk_status => [ 0, 1 ]
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

sub list_category {
    my $app   = shift;
    my $q     = $app->param;
    my $type  = $q->param('_type') || 'category';
    my $class = $app->model($type);

    my $perms = $app->permissions;
    my $entry_class;
    my $entry_type;
    if ( $type eq 'category' ) {
        $entry_type = 'entry';
        return $app->return_to_dashboard( redirect => 1 )
          unless $perms && $perms->can_edit_categories;
    }
    elsif ( $type eq 'folder' ) {
        $entry_type = 'page';
        return $app->return_to_dashboard( redirect => 1 )
          unless $perms && $perms->can_manage_pages;
    }
    $entry_class = $app->model($entry_type);
    my $blog_id = scalar $q->param('blog_id');
    require MT::Blog;
    my $blog = MT::Blog->load($blog_id)
      or return $app->errtrans("Invalid request.");
    my %param;
    my %authors;
    my $data = $app->_build_category_list(
        blog_id    => $blog_id,
        counts     => 1,
        new_cat_id => scalar $q->param('new_cat_id'),
        type       => $type
    );
    if ( $blog->site_url =~ /\/$/ ) {
        $param{blog_site_url} = $blog->site_url;
    }
    else {
        $param{blog_site_url} = $blog->site_url . '/';
    }
    $param{object_loop} = $param{category_loop} = $data;
    $param{saved} = $q->param('saved');
    $param{saved_deleted} = $q->param('saved_deleted');
    $app->load_list_actions( $type, \%param );

    #$param{nav_categories} = 1;
    $param{sub_object_label} =
        $type eq 'folder'
      ? $app->translate('Subfolder')
      : $app->translate('Subcategory');
    $param{object_label}        = $class->class_label;
    $param{object_label_plural} = $class->class_label_plural;
    $param{object_type}         = $type;
    $param{entry_label_plural}  = $entry_class->class_label_plural;
    $param{entry_label}         = $entry_class->class_label;
    $param{search_label}        = $param{entry_label_plural};
    $param{search_type}         = $entry_type;
    $param{screen_id} =
        $type eq 'folder'
      ? 'list-folder'
      : 'list-category';
    $param{listing_screen}      = 1;
    $app->add_breadcrumb( $param{object_label_plural} );

    $param{screen_class} = "list-${type}";
    $param{screen_class} .= " list-category"
      if $type eq 'folder';    # to piggyback on list-category styles
    my $tmpl_file = 'list_' . $type . '.tmpl';
    $app->load_tmpl( $tmpl_file, \%param );
}

sub move_category {
    my $app   = shift;
    my $type  = $app->param('_type');
    my $class = $app->model($type)
      or return $app->errtrans("Invalid request.");
    $app->validate_magic() or return;

    my $cat        = $class->load( $app->param('move_cat_id') );
    my $new_parent = $app->param('move-radio');

    return 1 if ( $new_parent == $cat->parent );

    $cat->parent($new_parent);
    my @siblings = $class->load(
        {
            parent  => $cat->parent,
            blog_id => $cat->blog_id
        }
    );
    foreach (@siblings) {

        # FIXME: Language should support both category / folder
        return $app->errtrans(
"The category name '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.",
            $_->label
        ) if $_->label eq $cat->label;
    }

    $cat->save
      or return $app->error(
        $app->translate( "Saving category failed: [_1]", $cat->errstr ) );
}

sub save_category {
    my $app   = shift;
    my $q     = $app->param;
    my $perms = $app->permissions;
    my $type  = $q->param('_type');
    my $class = $app->model($type)
      or return $app->errtrans("Invalid request.");

    if ( $type eq 'category' ) {
        return $app->errtrans("Permission denied.")
          unless $perms && $perms->can_edit_categories;
    }
    elsif ( $type eq 'folder' ) {
        return $app->errtrans("Permission denied.")
          unless $perms && $perms->can_manage_pages;
    }

    $app->validate_magic() or return;

    my $blog_id = $q->param('blog_id');
    my $cat;
    if ( my $moved_cat_id = $q->param('move_cat_id') ) {
        $cat = $class->load( $q->param('move_cat_id') );
        $app->move_category() or return;
    }
    else {
        for my $p ( $q->param ) {
            my ($parent) = $p =~ /^category-new-parent-(\d+)$/;
            next unless ( defined $parent );

            my $label = $q->param($p);
            $label =~ s/(^\s+|\s+$)//g;
            next unless ( $label ne '' );

            $cat = $class->new;
            my $original = $cat->clone;
            $cat->blog_id($blog_id);
            $cat->label($label);
            $cat->author_id( $app->user->id );
            $cat->parent($parent);

            $app->run_callbacks( 'cms_pre_save.' . $type,
                $app, $cat, $original )
              || return $app->errtrans( "Saving [_1] failed: [_2]", $type,
                $app->errstr );

            $cat->save
              or return $app->error(
                $app->translate(
                    "Saving [_1] failed: [_2]",
                    $type, $cat->errstr
                )
              );

            # Now post-process it.
            $app->run_callbacks( 'cms_post_save.' . $type,
                $app, $cat, $original );
        }
    }

    return $app->errtrans( "The [_1] must be given a name!", $type )
      if !$cat;

    $app->redirect(
        $app->uri(
            'mode' => 'list_cat',
            args   => {
                _type      => $type,
                blog_id    => $blog_id,
                saved      => 1,
                new_cat_id => $cat->id
            }
        )
    );
}

sub save_asset {
    my $app   = shift;
    my $q     = $app->param;
    my $perms = $app->permissions;
    my $type  = $q->param('_type');
    my $class = $app->model($type)
      or return $app->errtrans("Invalid request.");

    $app->validate_magic() or return;

    return $app->errtrans("Permission denied.")
      unless $perms && $perms->can_edit_assets;

    my $blog_id = $q->param('blog_id');
    my $id = $q->param('id');
    my $obj = $id ? $class->load($id) : $class->new;
    my $original = $obj->clone();

    $obj->set_values_from_query($q);

    $app->run_callbacks( 'cms_pre_save.' . $type, $app, $obj, $original )
      || return $app->errtrans( "Saving [_1] failed: [_2]", $type,
        $app->errstr );

    $obj->save
      or return $app->error(
        $app->translate(
            "Saving [_1] failed: [_2]",
            $type, $obj->errstr
        )
      );

    $app->run_callbacks( 'cms_post_save.' . $type, $app, $obj, $original );

    $app->redirect(
        $app->uri(
            'mode' => 'view',
            args   => {
                _type   => $type,
                blog_id => $blog_id,
                id      => $obj->id,
                saved   => 1,
            }
        )
    );
}

sub cfg_blog {
    my $q = $_[0]->{query};
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    $_[0]->edit_object( { output => 'cfg_prefs.tmpl' } );
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

sub cfg_prefs {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
      unless $blog_id;
    $q->param( '_type', 'blog' );
    $q->param( 'id',    $blog_id );
    my $blog_prefs = $app->user_blog_prefs;
    my $perms      = $app->permissions;
    return $app->error( $app->translate('Permission denied.') )
      unless $app->user->is_superuser()
      || (
        $perms
        && (   $perms->can_edit_config
            || $perms->can_administer_blog
            || $perms->can_set_publish_paths )
      );
    my $output = 'cfg_prefs.tmpl';
    $app->edit_object(
        {
            output       => $output,
            screen_class => 'settings-screen general-screen'
        }
    );
}

sub cfg_plugins {
    my $app = shift;
    my $q   = $app->param;
    my %param;
    $param{screen_class} = 'settings-screen';
    if ( $q->param('blog_id') ) {
        $q->param( '_type', 'blog' );
        $q->param( 'id',    scalar $q->param('blog_id') );
        $param{screen_id} = "list-plugins";
        $param{screen_class} .= " plugin-settings";
        $param{output} = 'cfg_plugin.tmpl';
        $app->edit_object( \%param );
    }
    else {
        my $cfg = $app->config;
        $param{can_config}  = $app->user->can_manage_plugins;
        $param{use_plugins} = $cfg->UsePlugins;
        $app->build_plugin_table( param => \%param, scope => 'system' );
        $param{nav_config}   = 1;
        $param{nav_settings} = 1;
        $param{nav_plugins}  = 1;
        $param{switched}     = 1 if $app->param('switched');
        $param{'reset'}  = 1 if $app->param('reset');
        $param{saved}    = 1 if $app->param('saved');
        $param{mod_perl} = 1 if $ENV{MOD_PERL};
        $app->add_breadcrumb( $app->translate("Plugin Settings") );
        $param{screen_id} = "list-plugins";
        $param{screen_class} = "plugin-settings";

        $app->load_tmpl( 'cfg_plugin.tmpl', \%param );
    }
}

sub cfg_comments {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
      unless $blog_id;
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    $app->edit_object(
        {
            output         => 'cfg_comments.tmpl',
            screen_class   => 'settings-screen',
            screen_id      => 'comment-settings',
        }
    );
}

sub cfg_trackbacks {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
      unless $blog_id;
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    $app->edit_object(
        {
            output       => 'cfg_trackbacks.tmpl',
            screen_class => 'settings-screen',
            screen_id    => 'trackback-settings',
        }
    );
}

sub cfg_registration {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
      unless $blog_id;
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    eval { require Digest::SHA1; };
    my $openid_available = $@ ? 0 : 1;
    $app->edit_object(
        {
            output       => 'cfg_registration.tmpl',
            screen_class => 'settings-screen registration-screen',
            openid_enabled => $openid_available
        }
    );
}

sub cfg_spam {
    my $app = shift;
    my $q   = $app->param;
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );

    my $plugin_config_html;
    my $plugin_name;
    my $plugin;
    if ( my $p = $q->param('plugin') ) {
        $plugin = $MT::Plugins{$p};
        if ($plugin) {
            $plugin = $plugin->{object};
        }
        else {
            $plugin = MT->component($p);
        }
        return $app->errtrans("Invalid request.") unless $plugin;

        my $scope;
        if ( $q->param('blog_id') ) {
            $scope = 'blog:' . $q->param('blog_id');
        }
        else {
            $scope = 'system';
        }
        $plugin_name = $plugin->name;
        my %plugin_param;
        $plugin->load_config( \%plugin_param, $scope );
        my $snip_tmpl = $plugin->config_template( \%plugin_param, $scope );
        my $tmpl;
        if ( ref $snip_tmpl ne 'MT::Template' ) {
            require MT::Template;
            $tmpl = MT::Template->new(
                type   => 'scalarref',
                source => ref $snip_tmpl
                ? $snip_tmpl
                : \$snip_tmpl
            );
        }
        else {
            $tmpl = $snip_tmpl;
        }

        # Process template independent of $app to avoid premature
        # localization (give plugin a chance to do L10N first).
        $tmpl->param( \%plugin_param );
        $plugin_config_html = $tmpl->output();
        $plugin_config_html =
          $plugin->translate_templatized($plugin_config_html)
          if $plugin_config_html =~ m/<(?:__trans|mt_trans) /i;
    }
    my $filters = MT::Component->registry('junk_filters') || [];
    my %plugins;
    foreach my $set (@$filters) {
        foreach my $f ( values %$set ) {
            $plugins{ $f->{plugin} } = $f->{plugin};
        }
    }
    my @plugins = values %plugins;
    my $loop    = [];
    foreach my $p (@plugins) {
        push @$loop,
          {
            name   => $p->name,
            plugin => $p->id,
            active => ( $plugin && ( $p->id eq $plugin->id ) ? 1 : 0 ),
          },
          ;
    }
    @$loop = sort { $a->{name} cmp $b->{name} } @$loop;

    $app->edit_object(
        {
            plugin_config_html => $plugin_config_html,
            plugin_name        => $plugin_name,
            junk_filter_loop   => $loop,
            output             => 'cfg_spam.tmpl',
            screen_class       => 'settings-screen spam-screen'
        }
    );
}

sub cfg_entry {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
      unless $blog_id;
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    $app->edit_object(
        {
            output       => 'cfg_entry.tmpl',
            screen_class => 'settings-screen entry-screen'
        }
    );
}

sub cfg_web_services {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
      unless $blog_id;
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    $app->edit_object(
        {
            output       => 'cfg_web_services.tmpl',
            screen_class => 'settings-screen web-services-settings'
        }
    );
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
        if ( ( my $best ) = grep { $a->{archive_type} =~ m/$_/ } keys %order ) {
            $ord_a = $order{$best};
        }
    }
    unless ($ord_b) {
        if ( ( my $best ) = grep { $b->{archive_type} =~ m/$_/ } keys %order ) {
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

sub cfg_archives {
    my $app = shift;
    my %param;
    %param = %{ $_[0] } if $_[0];
    my $q = $app->param;

    my $blog_id = $q->param('blog_id');

    return $app->return_to_dashboard( redirect => 1 ) unless $blog_id;

    my $blog = $app->model('blog')->load($blog_id);
    my @data;
    for my $at ( split /\s*,\s*/, $blog->archive_type ) {
        my $archiver = $app->publisher->archiver($at);
        next unless $archiver;
        next if 'entry' ne $archiver->entry_class;
        my $archive_label = $archiver->archive_label;
        $archive_label = $at unless $archive_label;
        $archive_label = $archive_label->() if ( ref $archive_label ) eq 'CODE';
        push @data,
          {
            archive_type_translated => $archive_label,
            archive_type            => $at,
            archive_type_is_preferred =>
              ( $blog->archive_type_preferred eq $at ? 1 : 0 ),
          };
    }
    @data = sort { archive_type_sorter( $a, $b ) } @data;
    $param{entry_archive_types} = \@data;
    $param{saved_deleted}       = 1 if $q->param('saved_deleted');
    $param{saved_added}         = 1 if $q->param('saved_added');
    $param{archives_changed}    = 1 if $q->param('archives_changed');
    $param{no_writedir}         = $q->param('no_writedir');
    $param{no_cachedir}         = $q->param('no_cachedir');
    $param{no_writecache}       = $q->param('no_writecache');
    $param{dynamic_none}        = $blog->custom_dynamic_templates eq 'none';
    $param{dynamic_archives}    = $blog->custom_dynamic_templates eq 'archives';
    $param{dynamic_custom}      = $blog->custom_dynamic_templates eq 'custom';
    $param{dynamic_all}         = $blog->custom_dynamic_templates eq 'all';

    if ( $app->config->ObjectDriver =~ qr/(db[id]::)?sqlite/i ) {
        $param{hide_build_option} = 1
          unless $app->config->UseSQLite2;
    }
    my $mtview_path = File::Spec->catfile( $blog->site_path(), "mtview.php" );

    if ( -f $mtview_path ) {
        open my ($fh), $mtview_path;
        while ( my $line = <$fh> ) {
            $param{dynamic_caching} = 1
              if $line =~ m/^\s*\$mt->caching\s*=\s*true;/i;
            $param{dynamic_conditional} = 1
              if $line =~ /^\s*\$mt->conditional\s*=\s*true;/i;
        }
        close $fh;
    }
    $param{output} = 'cfg_archives.tmpl';
    $q->param( '_type', 'blog' );
    $q->param( 'id',    $blog_id );
    $param{screen_class} = "settings-screen archive-settings";
    $param{object_type}  = 'author';
    $param{search_label} = $app->translate('Users');
    $app->edit_object( \%param );
}

sub cfg_archives_save {
    my $app = shift;
    my ($blog) = @_;

    my $at = $app->param('preferred_archive_type');
    $blog->archive_type_preferred($at);
    my $pq = $app->param('publish_queue');
    $blog->publish_queue( $pq ? 1 : 0 );
    $blog->save
      or return $app->error(
        $app->translate( "Saving blog failed: [_1]", $blog->errstr ) );
}

sub cfg_system_general {
    my $app = shift;
    my %param;
    if ( $app->param('blog_id') ) {
        return $app->return_to_dashboard( redirect => 1 );
    }

    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();
    my $cfg = $app->config;
    $app->add_breadcrumb( $app->translate('General Settings') );
    $param{nav_config}   = 1;
    $param{nav_settings} = 1;
    $param{languages} =
      $app->languages_list( $app->config('DefaultUserLanguage') );
    my $tag_delim = $app->config('DefaultUserTagDelimiter') || 'comma';
    $param{"tag_delim_$tag_delim"} = 1;

    ( my $tz = $app->config('DefaultTimezone') ) =~ s![-\.]!_!g;
    $tz =~ s!_00$!!;
    $param{ 'server_offset_' . $tz } = 1;

    $param{default_site_root} = $app->config('DefaultSiteRoot');
    $param{default_site_url}  = $app->config('DefaultSiteURL');
    $param{personal_weblog_readonly} =
      $app->config->is_readonly('NewUserAutoProvisioning');
    $param{personal_weblog} = $app->config->NewUserAutoProvisioning ? 1 : 0;
    if ( my $id = $param{new_user_template_blog_id} =
        $app->config('NewUserTemplateBlogId') || '' )
    {
        my $blog = MT::Blog->load($id);
        if ($blog) {
            $param{new_user_template_blog_name} = $blog->name;
        }
        else {
            $app->config( 'NewUserTemplateBlogId', undef, 1 );
            $cfg->save_config();
            delete $param{new_user_template_blog_id};
        }
    }
    $param{system_email_address} = $cfg->EmailAddressMain;
    $param{saved}                = $app->param('saved');
    $param{error}                = $app->param('error');
    $param{screen_class}         = "settings-screen system-general-settings";
    $app->load_tmpl( 'cfg_system_general.tmpl', \%param );
}

sub cfg_system_users {
    my $app = shift;
    my %param;
    if ( $app->param('blog_id') ) {
        return $app->return_to_dashboard( redirect => 1 );
    }

    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();
    my $cfg = $app->config;
    $app->add_breadcrumb( $app->translate('General Settings') );
    $param{nav_config}   = 1;

    $param{nav_settings} = 1;
    $param{languages} =
      $app->languages_list( $app->config('DefaultUserLanguage') );
    my $tag_delim = $app->config('DefaultUserTagDelimiter') || ord(',');
    if ( $tag_delim eq ord(',') ) {
        $tag_delim = 'comma';
    }
    elsif ( $tag_delim eq ord(' ') ) {
        $tag_delim = 'space';
    }
    else {
        $tag_delim = 'comma';
    }
    $param{"tag_delim_$tag_delim"} = 1;

    ( my $tz = $app->config('DefaultTimezone') ) =~ s![-\.]!_!g;
    $tz =~ s!_00$!!;
    $param{ 'server_offset_' . $tz } = 1;

    $param{default_site_root} = $app->config('DefaultSiteRoot');
    $param{default_site_url}  = $app->config('DefaultSiteURL');
    $param{personal_weblog_readonly} =
      $app->config->is_readonly('NewUserAutoProvisioning');
    $param{personal_weblog} = $app->config->NewUserAutoProvisioning ? 1 : 0;
    if ( my $id = $param{new_user_template_blog_id} =
        $app->config('NewUserTemplateBlogId') || '' )
    {
        my $blog = MT::Blog->load($id);
        if ($blog) {
            $param{new_user_template_blog_name} = $blog->name;
        }
        else {
            $app->config( 'NewUserTemplateBlogId', undef, 1 );
            $cfg->save_config();
            delete $param{new_user_template_blog_id};
        }
    }
    $param{system_email_address} = $cfg->EmailAddressMain;
    $param{saved}                = $app->param('saved');
    $param{error}                = $app->param('error');
    $param{screen_class}         = "settings-screen system-general-settings";
    my $registration = $cfg->CommenterRegistration;
    if ( $registration->{Allow} ) {
        $param{registration} = 1;
        if ( my $ids = $registration->{Notify} ) {
            my @ids = split ',', $ids;
            my @sysadmins = MT::Author->load(
                {
                    id   => \@ids,
                    type => MT::Author::AUTHOR()
                },
                {
                    join => MT::Permission->join_on(
                        'author_id',
                        {
                            permissions => "\%'administer'\%",
                            blog_id     => '0',
                        },
                        { 'like' => { 'permissions' => 1 } }
                    )
                }
            );
            my @names;
            foreach my $a (@sysadmins) {
                push @names, $a->name . '(' . $a->id . ')';
            }
            $param{notify_user_id} = $ids;
            $param{notify_user_name} = join ',', @names;
        }
    }
    $app->load_tmpl( 'cfg_system_users.tmpl', \%param );
}

sub save_cfg_system_general {
    my $app = shift;
    $app->validate_magic or return;
    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();

    my $cfg = $app->config;
    $app->config( 'EmailAddressMain',
        $app->param('system_email_address') || undef, 1 );

    $cfg->save_config();

    my $args = ();
    $args->{saved} = 1;
    $app->redirect(
        $app->uri(
            'mode' => 'cfg_system',
            args   => $args
        )
    );
}

sub save_cfg_system_users {
    my $app = shift;
    $app->validate_magic or return;
    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();

    my $tmpl_blog_id = $app->param('new_user_template_blog_id') || '';
    if ( $tmpl_blog_id =~ m/^\d+$/ ) {
        MT::Blog->load($tmpl_blog_id)
          or return $app->error(
            $app->translate(
                "Invalid ID given for personal blog clone source ID.")
          );
    }
    else {
        if ( $tmpl_blog_id ne '' ) {
            return $app->error(
                $app->translate(
                    "Invalid ID given for personal blog clone source ID.")
            );
        }
    }

    my $cfg = $app->config;
    my $tz  = $app->param('default_time_zone');
    $app->config( 'DefaultTimezone', $tz || undef, 1 );
    $app->config( 'DefaultSiteRoot', $app->param('default_site_root') || undef,
        1 );
    $app->config( 'DefaultSiteURL', $app->param('default_site_url') || undef,
        1 );
    $app->config( 'NewUserAutoProvisioning',
        $app->param('personal_weblog') ? 1 : 0, 1 );
    $app->config( 'NewUserTemplateBlogId', $tmpl_blog_id || undef, 1 );
    $app->config( 'DefaultUserLanguage', $app->param('default_language'), 1 );
    $app->config( 'DefaultUserTagDelimiter',
        $app->param('default_user_tag_delimiter') || undef, 1 );
    my $registration = $cfg->CommenterRegistration;
    if ( my $reg = $app->param('registration') ) {
        $registration->{Allow} = $reg ? 1 : 0;
        $registration->{Notify} = $app->param('notify_user_id');
        $cfg->CommenterRegistration( $registration, 1 );
    }
    elsif ( $registration->{Allow} ) {
        $registration->{Allow} = 0;
        $cfg->CommenterRegistration( $registration, 1 );
    }
    $cfg->save_config();

    my $args = ();

    if ( $app->config->NewUserAutoProvisioning() ne
        ( $app->param('personal_weblog') ? 1 : 0 ) )
    {
        $args->{error} =
          $app->translate(
'If personal blog is set, the default site URL and root are required.'
          );
    }
    else {
        $args->{saved} = 1;
    }

    $app->redirect(
        $app->uri(
            'mode' => 'cfg_system_users',
            args   => $args
        )
    );
}

sub cfg_system_feedback {
    my $app = shift;
    my %param;
    return $app->redirect(
        $app->uri(
            mode => 'cfg_comments',
            args => { blog_id => $app->param('blog_id') }
        )
    ) if $app->param('blog_id');

    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();

    my $cfg = $app->config;
    $param{nav_config} = 1;
    $app->add_breadcrumb( $app->translate('Feedback Settings') );
    $param{nav_settings}         = 1;
    $param{comment_disable}      = $cfg->AllowComments ? 0 : 1;
    $param{ping_disable}         = $cfg->AllowPings ? 0 : 1;
    $param{disabled_notify_ping} = $cfg->DisableNotificationPings ? 1 : 0;
    $param{system_no_email}      = 1 unless $cfg->EmailAddressMain;
    my $send = $cfg->OutboundTrackbackLimit || 'any';

    if ( $send =~ m/^(any|off|selected|local)$/ ) {
        $param{ "trackback_send_" . $cfg->OutboundTrackbackLimit } = 1;
        if ( $send eq 'selected' ) {
            my @domains = $cfg->OutboundTrackbackDomains;
            my $domains = join "\n", @domains;
            $param{trackback_send_domains} = $domains;
        }
    }
    else {
        $param{"trackback_send_any"} = 1;
    }
    $param{saved}        = $app->param('saved');
    $param{screen_class} = "settings-screen system-feedback-settings";
    $app->load_tmpl( 'cfg_system_feedback.tmpl', \%param );
}

sub save_cfg_system_feedback {
    my $app = shift;
    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();

    $app->validate_magic or return;
    my $cfg = $app->config;
    $cfg->AllowComments( ( $app->param('comment_disable') ? 0 : 1 ), 1 );
    $cfg->AllowPings(    ( $app->param('ping_disable')    ? 0 : 1 ), 1 );
    $cfg->DisableNotificationPings(
        ( $app->param('disable_notify_ping') ? 1 : 0 ), 1 );
    my $send = $app->param('trackback_send') || 'any';
    if ( $send =~ m/^(any|off|selected|local)$/ ) {
        $cfg->OutboundTrackbackLimit( $send, 1 );
        if ( $send eq 'selected' ) {
            my $domains = $app->param('trackback_send_domains') || '';
            $domains =~ s/[\r\n]+/ /gs;
            $domains =~ s/\s{2,}/ /gs;
            my @domains = split /\s/, $domains;
            $cfg->OutboundTrackbackDomains( \@domains, 1 );
        }
    }

    $cfg->save_config();
    $app->redirect(
        $app->uri(
            'mode' => 'cfg_system_feedback',
            args   => { saved => 1 }
        )
    );
}

sub reset_plugin_config {
    my $app = shift;

    $app->validate_magic or return;
    return $app->errtrans("Permission denied.")
        unless $app->user->can_manage_plugins;

    my $q          = $app->param;
    my $plugin_sig = $q->param('plugin_sig');
    my $profile    = $MT::Plugins{$plugin_sig};
    my $blog_id    = $q->param('blog_id');
    my %param;
    if ( $profile && $profile->{object} ) {
        $profile->{object}
          ->reset_config( $blog_id ? 'blog:' . $blog_id : 'system' );
    }
    $app->add_return_arg( 'reset' => 1 );
    $app->call_return;
}

sub save_plugin_config {
    my $app = shift;

    $app->validate_magic or return;
    return $app->errtrans("Permission denied.")
        unless $app->user->can_manage_plugins;

    my $q          = $app->param;
    my $plugin_sig = $q->param('plugin_sig');
    my $profile    = $MT::Plugins{$plugin_sig};
    my $blog_id    = $q->param('blog_id');
    my %param;
    my @params = $q->param;
    foreach (@params) {
        next if $_ =~ m/^(__mode|return_args|plugin_sig|magic_token|blog_id)$/;
        $param{$_} = $q->param($_);
    }
    if ( $profile && $profile->{object} ) {
        $profile->{object}
          ->save_config( \%param, $blog_id ? 'blog:' . $blog_id : 'system' );
    }

    $app->add_return_arg( saved => 1 );
    $app->call_return;
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
    return MT::Util::perl_sha1_digest_hex($data);
}

sub preview_entry {
    my $app         = shift;
    my $q           = $app->param;
    my $type        = $q->param('_type') || 'entry';
    my $entry_class = $app->model($type);
    my $blog_id     = $q->param('blog_id');
    my $blog        = $app->blog;
    my $id          = $q->param('id');
    my $entry;
    my $user_id = $app->user->id;

    if ($id) {
        $entry = $entry_class->load( { id => $id, blog_id => $blog_id } )
            or return $app->errtrans( "Invalid request." );
        $user_id = $entry->author_id;
    }
    else {
        $entry = $entry_class->new;
        $entry->author_id($user_id);
        $entry->id(-1); # fake out things like MT::Taggable::__load_tags
        $entry->blog_id($blog_id);
    }
    my $cat;
    my $names = $entry->column_names;

    my %values = map { $_ => scalar $app->param($_) } @$names;
    delete $values{'id'} unless $q->param('id');
    ## Strip linefeed characters.
    for my $col (qw( text excerpt text_more keywords )) {
        $values{$col} =~ tr/\r//d if $values{$col};
    }
    $values{allow_comments} = 0
      if !defined( $values{allow_comments} )
      || $q->param('allow_comments') eq '';
    $values{allow_pings} = 0
      if !defined( $values{allow_pings} )
      || $q->param('allow_pings') eq '';
    $entry->set_values( \%values );

    my $cat_ids = $q->param('category_ids');
    if ($cat_ids) {
        my @cats = split /,/, $cat_ids;
        if (@cats) {
            my $primary_cat = $cats[0];
            $cat =
              MT::Category->load( { id => $primary_cat, blog_id => $blog_id } );
            my @categories = MT::Category->load( { id => \@cats, blog_id => $blog_id });
            $entry->cache_property('category', undef, $cat);
            $entry->cache_property('categories', undef, \@categories);
        }
    } else {
        $entry->cache_property('category', undef, undef);
        $entry->cache_property('categories', undef, []);
    }
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my @tag_names = MT::Tag->split( $tag_delim, $q->param('tags') );
    if (@tag_names) {
        my @tags;
        foreach my $tag_name (@tag_names) {
            my $tag = MT::Tag->new;
            $tag->name($tag_name);
            push @tags, $tag;
        }
        $entry->{__tags} = \@tag_names;
        $entry->{__tag_objects} = \@tags;
    }

    my $date = $q->param('authored_on_date');
    my $time = $q->param('authored_on_time');
    my $ts   = $date . $time;
    $ts =~ s/\D//g;
    $entry->authored_on($ts);

    my $preview_basename = $app->preview_object_basename;
    $entry->basename($preview_basename);

    require MT::TemplateMap;
    require MT::Template;
    my $tmpl_map = MT::TemplateMap->load(
        {
            archive_type => ( $type eq 'page' ? 'Page' : 'Individual' ),
            is_preferred => 1,
            blog_id => $blog_id,
        }
    );

    my $tmpl;
    my $fullscreen;
    my $archive_file;
    my $orig_file;
    my $file_ext;
    if ($tmpl_map) {
        $tmpl         = MT::Template->load( $tmpl_map->template_id );
        $file_ext = $blog->file_extension || '';
        $archive_file = $entry->archive_file;

        my $blog_path = $type eq 'page' ?
            $blog->site_path :
            ($blog->archive_path || $blog->site_path);
        $archive_file = File::Spec->catfile( $blog_path, $archive_file );
        require File::Basename;
        my $path;
        ( $orig_file, $path ) = File::Basename::fileparse( $archive_file );
        $file_ext = '.' . $file_ext if $file_ext ne '';
        $archive_file = File::Spec->catfile( $path, $preview_basename . $file_ext );
    }
    else {
        $tmpl       = $app->load_tmpl('preview_entry_content.tmpl');
        $fullscreen = 1;
    }

    # translates naughty words when PublishCharset is NOT UTF-8
    $app->_translate_naughty_words($entry);

    $entry->convert_breaks( scalar $q->param('convert_breaks') );
        
    my @data = ( { data_name => 'author_id', data_value => $user_id } );
    $app->run_callbacks( 'cms_pre_preview', $app, $entry, \@data );

    my $ctx = $tmpl->context;
    $ctx->stash( 'entry', $entry );
    $ctx->stash( 'blog',  $blog );
    $ctx->stash( 'category', $cat ) if $cat;
    $ctx->{current_timestamp} = $ts;
    $ctx->var('entry_template',    1);
    $ctx->var('main_template',     1);
    $ctx->var('archive_template',  1);
    $ctx->var('entry_template',    1);
    $ctx->var('feedback_template', 1);
    $ctx->var('archive_class',     'entry-archive');
    $ctx->var('preview_template',  1);
    my $html = $tmpl->output;
    my %param;
    unless ( defined($html) ) {
        my $preview_error = $app->translate( "Publish error: [_1]",
            MT::Util::encode_html( $tmpl->errstr ) );
        $param{preview_error} = $preview_error;
        my $tmpl_plain = $app->load_tmpl('preview_entry_content.tmpl');
        $tmpl->text( $tmpl_plain->text );
        $html = $tmpl->output;
        defined($html)
          or return $app->error(
            $app->translate( "Publish error: [_1]", $tmpl->errstr ) );
        $fullscreen = 1;
    }

    # If MT is configured to do 'local' previews, convert all
    # the normal blog URLs into the domain used by MT itself (ie,
    # blog is published to www.example.com, which is a different
    # server from where MT runs, mt.example.com; previews therefore
    # should occur locally, so replace all http://www.example.com/
    # with http://mt.example.com/).
    my ($old_url, $new_url);
    if ($app->config('LocalPreviews')) {
        $old_url = $blog->site_url;
        $old_url =~ s!^(https?://[^/]+?/)(.*)?!$1!;
        $new_url = $app->base . '/';
        $html =~ s!\Q$old_url\E!$new_url!g;
    }

    if ( !$fullscreen ) {
        my $fmgr = $blog->file_mgr;

        ## Determine if we need to build directory structure,
        ## and build it if we do. DirUmask determines
        ## directory permissions.
        require File::Basename;
        my $path = File::Basename::dirname($archive_file);
        $path =~ s!/$!!
          unless $path eq '/';    ## OS X doesn't like / at the end in mkdir().
        unless ( $fmgr->exists($path) ) {
            $fmgr->mkpath($path);
        }

        if ( $fmgr->exists($path) && $fmgr->can_write($path) ) {
            $fmgr->put_data( $html, $archive_file );
            $param{preview_file} = $preview_basename;
            my $preview_url = $entry->archive_url;
            $preview_url =~ s! / \Q$orig_file\E ( /? ) $!/$preview_basename$file_ext$1!x;

            # We also have to translate the URL used for the
            # published file to be on the MT app domain.
            if (defined $new_url) {
                $preview_url =~ s!^\Q$old_url\E!$new_url!;
            }

            $param{preview_url}  = $preview_url;

            # we have to make a record of this preview just in case it
            # isn't cleaned up by re-editing, saving or cancelling on
            # by the user.
            require MT::Session;
            my $sess_obj = MT::Session->get_by_key(
                {
                    id   => $preview_basename,
                    kind => 'TF',                # TF = Temporary File
                    name => $archive_file,
                }
            );
            $sess_obj->start(time);
            $sess_obj->save;
        }
        else {
            $fullscreen = 1;
            $param{preview_error} = $app->translate(
                "Unable to create preview file in this location: [_1]", $path );
            my $tmpl_plain = $app->load_tmpl('preview_entry_content.tmpl');
            $tmpl->text( $tmpl_plain->text );
            $tmpl->reset_tokens;
            $html = $tmpl->output;
            $param{preview_body} = $html;
        }
    }
    else {
        $param{preview_body} = $html;
    }
    $param{id} = $id if $id;
    $param{new_object} = $param{id} ? 0 : 1;
    $param{title} = $entry->title;
    my $cols = $entry_class->column_names;

    for my $col (@$cols) {
        next
          if $col eq 'created_on'
          || $col eq 'created_by'
          || $col eq 'modified_on'
          || $col eq 'modified_by'
          || $col eq 'authored_on'
          || $col eq 'author_id'
          || $col eq 'pinged_urls'
          || $col eq 'tangent_cache'
          || $col eq 'template_id'
          || $col eq 'class'
          || $col eq 'meta';
        if ( $col eq 'basename' ) {
            if (   ( !defined $q->param('basename') )
                || ( $q->param('basename') eq '' ) )
            {
                $q->param( 'basename', $q->param('basename_old') );
            }
        }
        push @data,
          {
            data_name  => $col,
            data_value => scalar $q->param($col)
          };
    }
    for my $data (
        qw( authored_on_date authored_on_time basename_manual basename_old category_ids tags )
      )
    {
        push @data,
          {
            data_name  => $data,
            data_value => scalar $q->param($data)
          };
    }

    $param{entry_loop} = \@data;
    my $list_mode;
    my $list_title;
    if ( $type eq 'page' ) {
        $list_title = 'Pages';
        $list_mode  = 'list_pages';
    }
    else {
        $list_title = 'Entries';
        $list_mode  = 'list_entries';
    }
    if ($id) {
        $app->add_breadcrumb(
            $app->translate($list_title),
            $app->uri(
                'mode' => $list_mode,
                args   => { blog_id => $blog_id }
            )
        );
        $app->add_breadcrumb( $entry->title || $app->translate('(untitled)') );
    }
    else {
        $app->add_breadcrumb( $app->translate($list_title),
            $app->uri( 'mode' => $list_mode, args => { blog_id => $blog_id } )
        );
        $app->add_breadcrumb(
            $app->translate( 'New [_1]', $entry_class->class_label ) );
        $param{nav_new_entry} = 1;
    }
    $param{object_type}  = $type;
    $param{object_label} = $entry_class->class_label;
    if ($fullscreen) {
        return $app->load_tmpl( 'preview_entry.tmpl', \%param );
    }
    else {
        return $app->load_tmpl( 'preview_strip.tmpl', \%param );
    }
}

sub rebuild_confirm {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');
    require MT::Blog;
    my $blog = MT::Blog->load($blog_id);
    my $at = $blog->archive_type || '';
    my ( @blog_at, @at, @data );
    my $archiver;
    my $archive_label;

    if ( $at && $at ne 'None' ) {
        @blog_at = split /,/, $at;
        foreach my $t (@blog_at) {
            $archiver = $app->publisher->archiver($t);
            next unless $archiver;    # ignore unknown archive types
            push @at, $t;
            $archive_label = $archiver->archive_label;
            $archive_label = $at unless $archive_label;
            $archive_label = $archive_label->()
              if ( ref $archive_label ) eq 'CODE';
            push(
                @data,
                {
                    archive_type       => $t,
                    archive_type_label => $archive_label
                }
            );
        }
    }
    my $order     = join ',', @at, 'index';
    my $entry_pkg = $app->model('entry');
    my %param     = (
        archive_type_loop => \@data,
        build_order       => $order,
        build_next        => 0,
    );
    $param{index_selected} = ( $app->param('prompt') || "" ) eq 'index';

    if ( my $tmpl_id = $app->param('tmpl_id') ) {
        require MT::Template;
        my $tmpl = MT::Template->load($tmpl_id);
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

sub start_rebuild_pages {
    my $app           = shift;
    my $q             = $app->param;
    my $type          = $q->param('type');
    my $next          = $q->param('next') || 0;
    my @order         = split /,/, $type;
    my $total         = $q->param('total') || 0;
    my $type_name     = $order[$next];
    my $archiver      = $app->publisher->archiver($type_name);
    my $archive_label = $archiver ? $archiver->archive_label : '';
    $archive_label = $app->translate($type_name) unless $archive_label;
    $archive_label = $archive_label->() if ( ref $archive_label ) eq 'CODE';
    my $blog_id = $q->param('blog_id');

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
                class => 'entry',
            };
            $total = MT::Author->count(
                undef,
                {
                    join   => MT::Entry->join_on( 'author_id', $terms, { unique => 1 } ),
                    unique => 1,
                }
            );
        }
    }

    my %param = (
        build_type      => $type,
        build_next      => $next,
        total           => $total,
        complete        => 0,
        incomplete      => 100,
        build_type_name => $archive_label
    );

    if ( $type_name =~ /^index-(\d+)$/ ) {
        my $tmpl_id = $1;
        require MT::Template;
        my $tmpl = MT::Template->load($tmpl_id);
        $param{build_type_name} =
          $app->translate( "index template '[_1]'", $tmpl->name );
        $param{is_one_index} = 1;
    }
    elsif ( $type_name =~ /^entry-(\d+)$/ ) {
        my $entry_id = $1;
        require MT::Entry;
        my $entry = MT::Entry->load($entry_id);
        $param{build_type_name} =
          $app->translate( "[_1] '[_2]'", $entry->class_label, $entry->title );
        $param{is_entry} = 1;
        $param{entry_id} = $entry_id;
        for my $col (qw( is_new old_status old_next old_previous )) {
            $param{$col} = $q->param($col);
        }
    }
    $param{is_full_screen} = ( $param{is_entry} )
      || $q->param('single_template');
    $param{page_titles} = [ { bc_name => 'Rebuilding' } ];
    $app->load_tmpl( 'rebuilding.tmpl', \%param );
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

sub rebuild_pages {
    my $app   = shift;
    my $perms = $app->permissions
      or return $app->error( $app->translate("No permissions") );
    require MT::Entry;
    require MT::Blog;
    my $q             = $app->param;
    my $blog_id       = $q->param('blog_id');
    my $blog          = MT::Blog->load($blog_id);
    my $order         = $q->param('type');
    my @order         = split /,/, $order;
    my $next          = $q->param('next');
    my $done          = 0;
    my $type          = $order[$next];
    my $archiver      = $app->publisher->archiver($type);
    my $archive_label = $archiver ? $archiver->archive_label : '';
    $archive_label = $app->translate($type) unless $archive_label;
    $archive_label = $archive_label->() if ( ref $archive_label ) eq 'CODE';
    $next++;
    $done++ if $next >= @order;
    my $offset = 0;
    my ($total) = $q->param('total');

    ## Tells MT::_rebuild_entry_archive_type to cache loaded templates so
    ## that each template is only loaded once.
    $app->{cache_templates} = 1;

    my ($tmpl_saved);

    # Make sure errors go to a sensible place when in fs mode
    # TODO: create contin. earlier, pass it thru
    if ( $app->param('fs') ) {
        my ( $type, $obj_id ) = $app->param('type') =~ m/(entry|index)-(\d+)/;
        if ( $type && $obj_id ) {
            my $edit_type = $type;
            $edit_type = 'template' if $type eq 'index';
            if ($type eq 'entry') {
                require MT::Entry;
                my $entry = MT::Entry->load($obj_id);
                $edit_type = $entry->class;
            }
            $app->{goback} =
              "window.location='"
              . $app->object_edit_uri( $edit_type, $obj_id ) . "'";
            $app->{value} ||= $app->translate('Go Back');
        }
    }

    # FIXME: Wrap the entire rebuild operation with begin/end callbacks
    if ( $type eq 'all' ) {
        return $app->error( $app->translate("Permission denied.") )
          unless $perms->can_rebuild;

        # FIXME: Rebuild the entire blog????
        $app->rebuild( BlogID => $blog_id )
          or return $app->publish_error();
    }
    elsif ( $type eq 'index' ) {
        return $app->error( $app->translate("Permission denied.") )
          unless $perms->can_rebuild;
        $app->rebuild_indexes( BlogID => $blog_id )
            or return $app->publish_error();
    }
    elsif ( $type =~ /^index-(\d+)$/ ) {
        return $app->error( $app->translate("Permission denied.") )
          unless $perms->can_rebuild;
        my $tmpl_id = $1;
        require MT::Template;
        $tmpl_saved = MT::Template->load($tmpl_id);
        $app->rebuild_indexes(
            BlogID   => $blog_id,
            Template => $tmpl_saved,
            Force    => 1
        ) or return $app->publish_error();
        $order = $app->translate( "index template '[_1]'", $tmpl_saved->name );
    }
    elsif ( $type =~ /^entry-(\d+)$/ ) {
        my $entry_id = $1;
        require MT::Entry;
        my $entry = MT::Entry->load($entry_id);
        return $app->error( $app->translate("Permission denied.") )
          unless $perms->can_edit_entry( $entry, $app->user );
        $app->rebuild_entry(
            Entry             => $entry,
            BuildDependencies => 1,
            OldPrevious       => $q->param('old_previous'),
            OldNext           => $q->param('old_next')
        ) or return $app->publish_error();
        $order = "entry '" . $entry->title . "'";
    }
    elsif ( $archiver->category_based ) {
        return $app->error( $app->translate("Permission denied.") )
          unless $perms->can_rebuild;
        $offset = $q->param('offset') || 0;
        my $start = time;
        my $count = 0;
        my $cb    = sub {
            return 0 if time - $start > 20;    # 10 seconds
            $count++;
            return 1;
        };
        if ( $offset < $total ) {
            $app->rebuild(
                BlogID         => $blog_id,
                ArchiveType    => $type,
                NoIndexes      => 1,
                Offset         => $offset,
                FilterCallback => $cb,
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
        my @options = $app->{rebuild_options} ||= {};
        $app->run_callbacks( 'rebuild_options', $app, \@options );
        for my $optn (@options) {
            if ( ( $optn->{key} || '' ) eq $type ) {
                $optn->{code}->();
                $special = 1;
            }
        }
        if ( !$special ) {
            return $app->error( $app->translate("Permission denied.") )
              unless $perms->can_rebuild;
            $offset = $q->param('offset') || 0;
            if ( $offset < $total ) {
                my $start = time;
                my $count = 0;
                my $cb    = sub {
                    return 0 if time - $start > 20;    # 10 seconds
                    $count++;
                    return 1;
                };
                $app->rebuild(
                    BlogID         => $blog_id,
                    ArchiveType    => $type,
                    NoIndexes      => 1,
                    Offset         => $offset,
                    FilterCallback => $cb,
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
                        undef,
                        {
                            join   => MT::Entry->join_on( 'author_id', $terms, { unique => 1 } ),
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

        my $complete =
          $total
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
            incomplete      => 100 - $complete,
            entry_id        => scalar $q->param('entry_id'),
            dynamic         => $dynamic,
            is_new          => scalar $q->param('is_new'),
            old_status      => scalar $q->param('old_status')
        );
        $app->load_tmpl( 'rebuilding.tmpl', \%param );
    }
    else {
        if ( $q->param('entry_id') ) {
            require MT::Entry;
            my $entry = MT::Entry->load( scalar $q->param('entry_id') );
            require MT::Blog;
            my $blog = MT::Blog->load( $entry->blog_id );
            $app->ping_continuation(
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
                ( $built_type = $type ) =~
                  s/^(entry|index template)/$app->translate($1)/e;
            }
            else {
                $built_type = $app->translate($type);
            }
            my %param = (
                all          => $all,
                type         => $archive_label,
                is_one_index => $is_one_index,
                is_entry     => $is_entry,
                archives     => $type ne 'index',
            );
            if ($is_one_index) {
                $param{tmpl_url} = $blog->site_url;
                $param{tmpl_url} .= '/' if $param{tmpl_url} !~ m!/$!;
                $param{tmpl_url} .= $tmpl_saved->outfile;
            }
            if ( $q->param('fs') ) {    # full screen--go to a useful app page
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
            else {    # popup--just go to cnfrmn. page
                $app->run_callbacks( 'rebuild', $blog );
                return $app->load_tmpl( 'popup/rebuilt.tmpl', \%param );
            }
        }
    }
}

sub send_pings {
    my $app = shift;
    my $q   = $app->param;
    $app->validate_magic() or return;
    require MT::Entry;
    require MT::Blog;
    my $blog  = MT::Blog->load( scalar $q->param('blog_id') );
    my $entry = MT::Entry->load( scalar $q->param('entry_id') );
    ## MT::ping_and_save pings each of the necessary URLs, then processes
    ## the return value from MT::ping to update the list of URLs pinged
    ## and not successfully pinged. It returns the return value from
    ## MT::ping for further processing. If a fatal error occurs, it returns
    ## undef.
    my $results = $app->ping_and_save(
        Blog      => $blog,
        Entry     => $entry,
        OldStatus => scalar $q->param('old_status')
    ) or return;
    my $has_errors = 0;
    require MT::Log;
    for my $res (@$results) {
        $has_errors++,
          $app->log(
            {
                message => $app->translate(
                    "Ping '[_1]' failed: [_2]",
                    $res->{url},
                    encode_text( $res->{error}, undef, undef )
                ),
                class => 'system',
                level => MT::Log::WARNING()
            }
          ) unless $res->{good};
    }
    $app->_finish_rebuild_ping( $entry, scalar $q->param('is_new'),
        $has_errors );
}

sub edit_role {
    my $app = shift;

    $app->return_to_dashboard( redirect => 1 ) if $app->param('blog_id');

    my %param  = $_[0] ? %{ $_[0] } : ();
    my $q      = $app->param;
    my $author = $app->user;
    my $id     = $q->param('id');

    require MT::Permission;
    if ( !$author->is_superuser ) {
        return $app->error( $app->translate("Invalid request.") );
    }
    my $role;
    require MT::Role;
    if ($id) {
        $role = MT::Role->load($id);

        # $param{is_enabled} = $role->is_active;
        $param{is_enabled}  = 1;
        $param{name}        = $role->name;
        $param{description} = $role->description;
        $param{id}          = $role->id;
        require MT::Author;
        my $creator = MT::Author->load( $role->created_by )
          if $role->created_by;
        $param{created_by} = $creator ? $creator->name : '';

        my $permissions = $role->permissions;
        if ( defined($permissions) && $permissions ) {
            my @perms = split ',', $permissions;

            my @roles = MT::Role->load_same(
                { 'id' => [$id] },
                { not  => { id => 1 } },
                1,    # exact match
                @perms
            );
            my @same_perms;
            for my $other_role (@roles) {
                push @same_perms,
                  {
                    name => $other_role->name,
                    id   => $other_role->id,
                  };
            }
            $param{same_perm_loop} = \@same_perms if @same_perms;
        }
        require MT::Association;
        require MT::Author;
        $param{user_count} = MT::Author->count( undef, { join  => MT::Association->join_on( 'author_id', { role_id => $id }, { unique => 1 } ) } );
    }

    my $all_perm_flags = MT::Permission->perms('blog');

    my @p_data;
    for my $ref (@$all_perm_flags) {
        $param{ 'have_access-' . $ref->[0] } =
          ( $role && $role->has( $ref->[0] ) ) ? 1 : 0;
        $param{ 'prompt-' . $ref->[0] } = $app->translate( $ref->[1] );
    }
    $param{saved}          = $q->param('saved');
    $param{nav_privileges} = 1;
    $app->add_breadcrumb( $app->translate('Roles'),
        $app->uri( mode => 'list_roles' ) );
    if ($id) {
        $app->add_breadcrumb( $role->name );
    }
    else {
        $app->add_breadcrumb( $app->translate('Create Role') );
    }
    $param{screen_class}        = "settings-screen edit-role";
    $param{object_type}         = 'role';
    $param{object_label}        = MT::Role->class_label;
    $param{object_label_plural} = MT::Role->class_label_plural;
    $param{search_label}        = $app->translate('Users');
    $app->load_tmpl( 'edit_role.tmpl', \%param );
}

sub save_role {
    my $app = shift;
    my $q   = $app->param;
    $app->validate_magic()   or return;
    $app->user->is_superuser or return $app->errtrans("Invalid request.");

    my $id    = $q->param('id');
    my @perms = $q->param('permission');
    my $role;
    require MT::Role;
    $role = $id ? MT::Role->load($id) : MT::Role->new;
    my $name = $q->param('name') || '';
    $name =~ s/(^\s+|\s+$)//g;
    return $app->errtrans("Role name cannot be blank.")
      if $name eq '';

    my $role_by_name = MT::Role->load( { name => $name } );
    if ( $role_by_name && ( ( $id && ( $role->id != $id ) ) || !$id ) ) {
        return $app->errtrans("Another role already exists by that name.");
    }
    if ( !@perms ) {
        return $app->errtrans("You cannot define a role without permissions.");
    }

    $role->name( $q->param('name') );
    $role->description( $q->param('description') );
    $role->clear_full_permissions;
    $role->set_these_permissions(@perms);
    if ( $role->id ) {
        $role->modified_by( $app->user->id );
    }
    else {
        $role->created_by( $app->user->id );
    }
    $role->save or return $app->error( $role->errstr );

    my $url;
    $url = $app->uri(
        'mode' => 'edit_role',
        args   => { id => $role->id, saved => 1 }
    );
    $app->redirect($url);
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

sub entry_notify {
    my $app   = shift;
    my $user  = $app->user;
    my $perms = $app->permissions;
    return $app->error( $app->translate("No permissions.") )
      unless $perms->can_send_notifications;

    my $q        = $app->param;
    my $entry_id = $q->param('entry_id')
      or return $app->error( $app->translate("No entry ID provided") );
    require MT::Entry;
    require MT::Blog;
    my $entry = MT::Entry->load($entry_id)
      or return $app->error(
        $app->translate( "No such entry '[_1]'", $entry_id ) );
    my $blog  = MT::Blog->load( $entry->blog_id );
    my $param = {};
    $param->{entry_id} = $entry_id;
    return $app->load_tmpl( "dialog/entry_notify.tmpl", $param );
}

sub send_notify {
    my $app = shift;
    $app->validate_magic() or return;
    my $q        = $app->param;
    my $entry_id = $q->param('entry_id')
      or return $app->error( $app->translate("No entry ID provided") );
    require MT::Entry;
    require MT::Blog;
    my $entry = MT::Entry->load($entry_id)
      or return $app->error(
        $app->translate( "No such entry '[_1]'", $entry_id ) );
    my $blog = MT::Blog->load( $entry->blog_id );

    my $user = $app->user;
    $app->blog($blog);
    my $perms = $user->permissions($blog);
    return $app->error( $app->translate("No permissions.") )
      unless $perms->can_send_notifications;

    my $author = $entry->author;
    return $app->error(
        $app->translate( "No email address for user '[_1]'", $author->name ) )
      unless $author->email;

    my $cols = 72;
    my %params;
    $params{blog} = $blog;
    $params{entry} = $entry;
    $params{author} = $author;

    if ( $q->param('send_excerpt') ) {
        $params{send_excerpt} = 1;
    }
    $params{message} = wrap_text( $q->param('message'), $cols, '', '' );
    if ( $q->param('send_body') ) {
        $params{send_body} = 1;
    }

    my $entry_editurl = $app->uri(
        'mode' => 'view',
        args   => {
            '_type' => 'entry',
            blog_id => $entry->blog_id,
            id      => $entry->id,
        }
    );
    if ( $entry_editurl =~ m|^/| ) {
        my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
        $entry_editurl = $blog_domain . $entry_editurl;
    }
    $params{entry_editurl} = $entry_editurl;

    my $addrs;
    if ( $q->param('send_notify_list') ) {
        require MT::Notification;
        my $iter = MT::Notification->load_iter( { blog_id => $blog->id } );
        while ( my $note = $iter->() ) {
            next unless is_valid_email( $note->email );
            $addrs->{ $note->email } = 1;
        }
    }

    if ( $q->param('send_notify_emails') ) {
        my @addr = split /[\n\r,]+/, $q->param('send_notify_emails');
        for my $a (@addr) {
            next unless is_valid_email($a);
            $addrs->{$a} = 1;
        }
    }

    keys %$addrs
      or return $app->error(
        $app->translate(
            "No valid recipients found for the entry notification.")
      );

    my $body = $app->build_email( 'notify-entry.tmpl', \%params );

    my $subj =
      $app->translate( "[_1] Update: [_2]", $blog->name, $entry->title );
    if ( $app->current_language ne 'ja' ) {    # FIXME perhaps move to MT::I18N
        $subj =~ s![\x80-\xFF]!!g;
    }
    my $address =
      defined $author->nickname
      ? $author->nickname . ' <' . $author->email . '>'
      : $author->email;
    my %head = (
        id      => 'notify_entry',
        To      => $address,
        From    => $address,
        Subject => $subj,
    );
    my $charset = $app->config('MailEncoding')
      || $app->charset;
    $head{'Content-Type'} = qq(text/plain; charset="$charset");
    my $i = 1;
    require MT::Mail;
    MT::Mail->send( \%head, $body )
      or return $app->error(
        $app->translate(
            "Error sending mail ([_1]); try another MailTransfer setting?",
            MT::Mail->errstr
        )
      );
    delete $head{To};

    foreach my $email ( keys %{$addrs} ) {
        next unless $email;
        if ( $app->config('EmailNotificationBcc') ) {
            push @{ $head{Bcc} }, $email;
            if ( $i++ % 20 == 0 ) {
                MT::Mail->send( \%head, $body )
                  or return $app->error(
                    $app->translate(
"Error sending mail ([_1]); try another MailTransfer setting?",
                        MT::Mail->errstr
                    )
                  );
                @{ $head{Bcc} } = ();
            }
        }
        else {
            $head{To} = $email;
            MT::Mail->send( \%head, $body )
              or return $app->error(
                $app->translate(
"Error sending mail ([_1]); try another MailTransfer setting?",
                    MT::Mail->errstr
                )
              );
            delete $head{To};
        }
    }
    if ( $head{Bcc} && @{ $head{Bcc} } ) {
        MT::Mail->send( \%head, $body )
          or return $app->error(
            $app->translate(
                "Error sending mail ([_1]); try another MailTransfer setting?",
                MT::Mail->errstr
            )
          );
    }
    $app->redirect(
        $app->uri(
            'mode' => 'view',
            args   => {
                '_type'      => $entry->class,
                blog_id      => $entry->blog_id,
                id           => $entry->id,
                saved_notify => 1
            }
        )
    );
}

sub _set_start_upload_params {
    my $app = shift;
    my ($param) = @_;

    if (my $perms = $app->permissions) {
        return $app->error( $app->translate("Permission denied.") )
          unless $perms->can_upload;
        my $blog_id = $app->param('blog_id');
        require MT::Blog;
        my $blog = MT::Blog->load($blog_id);

        $param->{enable_archive_paths} = $blog->column('archive_path');
        $param->{local_site_path}      = $blog->site_path;
        $param->{local_archive_path}   = $blog->archive_path;
        my $label_path;
        if ( $param->{enable_archive_paths} ) {
            $label_path = $app->translate('Archive Root');
        }
        else {
            $label_path = $app->translate('Site Root');
        }
        my @extra_paths;
        my $date_stamp = epoch2ts( $blog, time );
        $date_stamp =~ s!^(\d\d\d\d)(\d\d)(\d\d).*!$1/$2/$3!;
        my $path_hash = {
            path  => $date_stamp,
            label => '<' . $app->translate($label_path) . '>' . '/' . $date_stamp,
        };

        if ( exists( $param->{middle_path} )
            && ( $date_stamp eq $param->{middle_path} ) )
        {
            $path_hash->{selected} = 1;
            delete $param->{archive_path};
        }
        push @extra_paths, $path_hash;
        $param->{extra_paths} = \@extra_paths;
        $param->{refocus}     = 1;
        $param->{missing_paths} =
          (      ( defined $blog->site_path || defined $blog->archive_path )
              && ( -d $blog->site_path || -d $blog->archive_path ) ) ? 0 : 1;

        if ( $param->{missing_paths} ) {
            if (
                $app->user->is_superuser
                || $app->run_callbacks(
                    'cms_view_permission_filter.blog',
                    $app, $blog_id, $blog
                )
              )
            {
                $param->{have_permissions} = 1;
            }
        }

        $param->{enable_destination} = 1;
        
        my $data = $app->_build_category_list(
            blog_id => $blog_id,
            markers => 1,
            type    => 'folder',
        );
        my $top_cat = -1;
        my $cat_tree = [{
            id    => -1,
            label => '/',
            basename => '/',
            path  => [],
        }];
        foreach (@$data) {
            next unless exists $_->{category_id};
            $_->{category_path_ids} ||= [];
            unshift @{ $_->{category_path_ids} }, -1;
            push @$cat_tree,
              {
                id => $_->{category_id},
                label => $_->{category_label} . '/',
                basename => $_->{category_basename} . '/',
                path => $_->{category_path_ids} || [],
              };
        }
        $param->{category_tree} = $cat_tree;
    }
    else {
        $param->{local_site_path}      = '';
        $param->{local_archive_path}   = '';
    }

    $param;
}

sub start_upload {
    my $app = shift;

    $app->add_breadcrumb( $app->translate('Upload File') );
    my %param;
    %param = @_ if @_;

    $app->_set_start_upload_params(\%param);

    for my $field (qw( entry_insert edit_field upload_mode require_type
      asset_select )) {
        $param{$field} ||= $app->param($field);
    }

    $app->load_tmpl( 'dialog/asset_upload.tmpl', \%param );
}

sub complete_insert {
    my $app = shift;
    my (%args) = @_;

    my $asset = $args{asset};
    if ( !$asset && $app->param('id') ) {
        require MT::Asset;
        $asset = MT::Asset->load( $app->param('id') )
          || return $app->errtrans( "Can't load file #[_1].",
            $app->param('id') );
    }
    return $app->errtrans('Invalid request.') unless $asset;

    $args{is_image} = $asset->isa('MT::Asset::Image') ? 1 : 0
      unless defined $args{is_image};

    require MT::Blog;
    my $blog = $asset->blog
      or
      return $app->errtrans( "Can't load blog #[_1].", $app->param('blog_id') );
    my $perms = $app->permissions
      or return $app->errtrans('No permissions');

    my $param = {
        asset_id            => $asset->id,
        bytes               => $args{bytes},
        fname               => $asset->file_name,
        is_image            => $args{is_image} || 0,
        url                 => $asset->url,
        middle_path         => $app->param('middle_path') || '',
        extra_path          => $app->param('extra_path') || '',
    };
    for my $field (qw( direct_asset_insert edit_field entry_insert site_path
      asset_select )) {
        $param->{$field} = scalar $app->param($field) || '';
    }
    if ( $args{is_image} ) {
        $param->{width}  = $asset->image_width;
        $param->{height} = $asset->image_height;
    }
    if ( !$app->param('asset_select')
      && ($perms->can_create_post || $app->user->is_superuser) ) {
        my $html = $asset->insert_options($param);
        if ( $param->{direct_asset_insert} && !$html ) {
            $app->param( 'id', $asset->id );
            return $app->asset_insert();
        }
        $param->{options_snippet} = $html;
    }

    if ($perms) {
        my $pref_param = $app->load_entry_prefs( $perms->entry_prefs );
        %$param = ( %$param, %$pref_param );

        # Completion for tags
        my $author     = $app->user;
        my $auth_prefs = $author->entry_prefs;
        if ( my $delim = chr( $auth_prefs->{tag_delim} ) ) {
            if ( $delim eq ',' ) {
                $param->{'auth_pref_tag_delim_comma'} = 1;
            }
            elsif ( $delim eq ' ' ) {
                $param->{'auth_pref_tag_delim_space'} = 1;
            }
            else {
                $param->{'auth_pref_tag_delim_other'} = 1;
            }
            $param->{'auth_pref_tag_delim'} = $delim;
        }

        require MT::ObjectTag;
        my $q       = $app->param;
        my $blog_id = $q->param('blog_id');
        my $count   = MT::Tag->count(
            undef,
            {
                'join' => MT::ObjectTag->join_on(
                    'tag_id',
                    {
                        blog_id           => $blog_id,
                        object_datasource => MT::Asset->datasource
                    },
                    { unique => 1 }
                )
            }
        );
        if ( $count > 1000 ) {    # FIXME: Configurable limit?
            $param->{defer_tag_load} = 1;
        }
        else {
            require JSON;
            $param->{tags_js} = JSON::objToJson(
                MT::Tag->cache( blog_id => $blog_id, class => 'MT::Asset', private => 1 ) );
        }
    }

    $app->load_tmpl( 'dialog/asset_options.tmpl', $param );
}

sub _make_string_csv {
    my $app = shift;
    my ( $value, $enc ) = @_;
    $value =~ s/\r|\r\n/\n/gs;
    if ( ( ( index( $value, '"' ) > -1 ) || ( index( $value, '\n' ) > -1 ) )
        && !( $value =~ m/^".*"$/gs ) )
    {
        $value = "\"$value\"";
    }
    return encode_text( $value, undef, $enc );
}

sub upload_file {
    my $app = shift;

    my ($asset, $bytes) = $app->_upload_file(
        require_type => ($app->param('require_type') || ''),
        @_,
    );
    return if !defined $asset;
    return $asset if !defined $bytes;  # whatever it is

    $app->complete_insert(
        asset => $asset,
        bytes => $bytes,
    );
}

sub upload_userpic {
    my $app = shift;

    my ($asset, $bytes) = $app->_upload_file(
        @_,
        require_type => 'image',
    );
    return if !defined $asset;
    return $asset if !defined $bytes;  # whatever it is

    ## TODO: should this be layered into _upload_file somehow, so we don't
    ## save the asset twice?
    $asset->tags('@userpic');
    $asset->save;

    my $user_id = $app->param('user_id');

    $app->forward( 'asset_userpic', { asset => $asset, user_id => $user_id } );
}

sub _upload_file {
    my $app = shift;
    my (%upload_param) = @_;

    if (my $perms = $app->permissions) {
        return $app->error( $app->translate("Permission denied.") )
          unless $perms->can_upload;
    }

    $app->validate_magic() or return;

    my $q = $app->param;
    my ($fh, $info) = $app->upload_info('file');
    my $mimetype;
    if ($info) {
        $mimetype = $info->{'Content-Type'};
    }
    my $has_overwrite = $q->param('overwrite_yes') || $q->param('overwrite_no');
    my %param = (
        entry_insert => $q->param('entry_insert'),
        middle_path  => $q->param('middle_path'),
        edit_field   => $q->param('edit_field'),
        site_path    => $q->param('site_path'),
        extra_path   => $q->param('extra_path'),
        upload_mode  => $app->mode,
    );
    return $app->start_upload( %param,
        error => $app->translate("Please select a file to upload.") )
      if !$fh && !$has_overwrite;
    my $basename = $q->param('file') || $q->param('fname');
    $basename =~ s!\\!/!g;    ## Change backslashes to forward slashes
    $basename =~ s!^.*/!!;    ## Get rid of full directory paths
    if ( $basename =~ m!\.\.|\0|\|! ) {
        return $app->start_upload( %param,
            error => $app->translate( "Invalid filename '[_1]'", $basename ) );
    }

    if (my $asset_type = $upload_param{require_type}) {
        require MT::Asset;
        my $asset_pkg = MT::Asset->handler_for_file($basename);

        my %settings_for = (
            audio => {
                class => 'MT::Asset::Audio',
                error => $app->translate( "Please select an audio file to upload." ),
            },
            image => {
                class => 'MT::Asset::Image',
                error => $app->translate( "Please select an image to upload." ),
            },
            video => {
                class => 'MT::Asset::Video',
                error => $app->translate( "Please select a video to upload." ),
            },
        );

        if (my $settings = $settings_for{$asset_type}) {
            return $app->start_upload( %param, error => $settings->{error} )
                if !$asset_pkg->isa($settings->{class});
        }
    }

    my ($blog_id, $blog, $fmgr, $local_file, $asset_file, $base_url,
      $asset_base_url, $relative_url, $relative_path);
    if ($blog_id = $q->param('blog_id')) {
        $param{blog_id} = $blog_id;
        require MT::Blog;
        $blog = MT::Blog->load($blog_id);
        $fmgr = $blog->file_mgr;

        ## Set up the full path to the local file; this path could start
        ## at either the Local Site Path or Local Archive Path, and could
        ## include an extra directory or two in the middle.
        my ( $root_path, $middle_path );
        if ( $q->param('site_path') ) {
            $root_path = $blog->site_path;
        }
        else {
            $root_path = $blog->archive_path;
        }
        return $app->error(
            $app->translate(
                "Before you can upload a file, you need to publish your blog."
            )
        ) unless -d $root_path;
        $relative_path = $q->param('extra_path');
        $middle_path = $q->param('middle_path') || '';
        my $relative_path_save = $relative_path;
        if ( $middle_path ne '' ) {
            $relative_path =
              $middle_path . ( $relative_path ? '/' . $relative_path : '' );
        }
        my $path = $root_path;
        if ($relative_path) {
            if ( $relative_path =~ m!\.\.|\0|\|! ) {
                return $app->start_upload(
                    %param,
                    error => $app->translate(
                        "Invalid extra path '[_1]'", $relative_path
                    )
                );
            }
            $path = File::Spec->catdir( $path, $relative_path );
            ## Untaint. We already checked for security holes in $relative_path.
            ($path) = $path =~ /(.+)/s;
            ## Build out the directory structure if it doesn't exist. DirUmask
            ## determines the permissions of the new directories.
            unless ( $fmgr->exists($path) ) {
                $fmgr->mkpath($path)
                  or return $app->start_upload(
                    %param,
                    error => $app->translate(
                        "Can't make path '[_1]': [_2]",
                        $path, $fmgr->errstr
                    )
                  );
            }
        }
        $relative_url =
          File::Spec->catfile( $relative_path, encode_url($basename) );
        $relative_path = $relative_path
          ? File::Spec->catfile( $relative_path, $basename )
          : $basename;
        $asset_file = $q->param('site_path') ? '%r' : '%a';
        $asset_file = File::Spec->catfile( $asset_file, $relative_path );
        $local_file = File::Spec->catfile( $path, $basename );
        $base_url = $app->param('site_path') ? $blog->site_url
          : $blog->archive_url;
        $asset_base_url = $app->param('site_path') ? '%r' : '%a';

        ## Untaint. We have already tested $basename and $relative_path for security
        ## issues above, and we have to assume that we can trust the user's
        ## Local Archive Path setting. So we should be safe.
        ($local_file) = $local_file =~ /(.+)/s;

        ## If $local_file already exists, we try to write the upload to a
        ## tempfile, then ask for confirmation of the upload.
        if ( $fmgr->exists($local_file) ) {
            if ($has_overwrite) {
                my $tmp = $q->param('temp');
                if ( $tmp =~ m!([^/]+)$! ) {
                    $tmp = $1;
                }
                else {
                    return $app->error(
                        $app->translate( "Invalid temp file name '[_1]'", $tmp ) );
                }
                my $tmp_dir = $app->config('TempDir');
                my $tmp_file = File::Spec->catfile( $tmp_dir, $tmp );
                if ( $q->param('overwrite_yes') ) {
                    $fh = gensym();
                    open $fh, $tmp_file
                      or return $app->error(
                        $app->translate(
                            "Error opening '[_1]': [_2]",
                            $tmp_file, "$!"
                        )
                      );
                }
                else {
                    if ( -e $tmp_file ) {
                        unlink($tmp_file)
                          or return $app->error(
                            $app->translate(
                                "Error deleting '[_1]': [_2]",
                                $tmp_file, "$!"
                            )
                          );
                    }
                    return $app->start_upload;
                }
            }
            else {
                eval { require File::Temp };
                if ($@) {
                    return $app->error(
                        $app->translate(
                            "File with name '[_1]' already exists. (Install "
                              . "File::Temp if you'd like to be able to overwrite "
                              . "existing uploaded files.)",
                            $basename
                        )
                    );
                }
                my $tmp_dir = $app->config('TempDir');
                my ( $tmp_fh, $tmp_file );
                eval {
                    ( $tmp_fh, $tmp_file ) =
                      File::Temp::tempfile( DIR => $tmp_dir );
                };
                if ($@) {    #!$tmp_fh
                    return $app->errtrans(
                        "Error creating temporary file; please check your TempDir "
                          . "setting in your coniguration file (currently '[_1]') "
                          . "this location should be writable.",
                        (
                              $tmp_dir
                            ? $tmp_dir
                            : '[' . $app->translate('unassigned') . ']'
                        )
                    );
                }
                defined( _write_upload( $fh, $tmp_fh ) )
                  or return $app->error(
                    $app->translate(
                        "File with name '[_1]' already exists; Tried to write "
                          . "to tempfile, but open failed: [_2]",
                        $basename,
                        "$!"
                    )
                  );
                close $tmp_fh;
                my ( $vol, $path, $tmp ) = File::Spec->splitpath($tmp_file);
                return $app->load_tmpl(
                    'dialog/asset_replace.tmpl',
                    {
                        temp         => $tmp,
                        extra_path   => $relative_path_save,
                        site_path    => scalar $q->param('site_path'),
                        asset_select => $q->param('asset_select'),
                        entry_insert => $q->param('entry_insert'),
                        edit_field   => $app->param('edit_field'),
                        middle_path  => $middle_path,
                        fname        => $basename
                    }
                );
            }
        }
    }
    else {
        $blog_id        = 0;
        $asset_base_url = '%s/support/uploads';
        $base_url       = $app->static_path . 'support/uploads';
        $param{support_path} =
          File::Spec->catdir( $app->static_file_path, 'support', 'uploads' );

        require MT::FileMgr;
        $fmgr = MT::FileMgr->new('Local');
        unless ( $fmgr->exists( $param{support_path} ) ) {
            $fmgr->mkpath( $param{support_path} );
            unless ( $fmgr->exists( $param{support_path} ) ) {
                return $app->error( $app->translate(
                    "Could not create upload path '[_1]': [_2]",
                        $param{support_path}, $fmgr->errstr
                ) );
            }
        }

        require File::Basename;
        my ($stem, undef, $type) = File::Basename::fileparse( $basename,
            qr/\.[A-Za-z0-9]+$/ );
        my $unique_stem = $stem;
        $local_file = File::Spec->catfile( $param{support_path},
            $unique_stem . $type );
        my $i = 1;
        while ($fmgr->exists($local_file)) {
            $unique_stem = join q{-}, $stem, $i++;
            $local_file = File::Spec->catfile( $param{support_path},
                $unique_stem . $type );
        }

        my $unique_basename = $unique_stem . $type;
        $relative_path  = $unique_basename;
        $relative_url   = encode_url($unique_basename);
        $asset_file     = File::Spec->catfile( '%s', 'support', 'uploads',
          $unique_basename );
    }

    require MT::Image;
    my ($w, $h, $id, $write_file) = MT::Image->check_upload(
        Fh => $fh, Fmgr => $fmgr, Local => $local_file,
        Max => $upload_param{max_size},
        MaxDim => $upload_param{max_image_dimension}
    );

    return $app->error(MT::Image->errstr)
        unless $write_file;

    ## File does not exist, or else we have confirmed that we can overwrite.
    my $umask = oct $app->config('UploadUmask');
    my $old   = umask($umask);
    defined( my $bytes = $write_file->() )
      or return $app->error(
        $app->translate(
            "Error writing upload to '[_1]': [_2]", $local_file,
            $fmgr->errstr
        )
      );
    umask($old);

    ## Close up the filehandle.
    close $fh;

    ## If we are overwriting the file, that means we still have a temp file
    ## lying around. Delete it.
    if ( $q->param('overwrite_yes') ) {
        my $tmp = $q->param('temp');
        if ( $tmp =~ m!([^/]+)$! ) {
            $tmp = $1;
        }
        else {
            return $app->error(
                $app->translate( "Invalid temp file name '[_1]'", $tmp ) );
        }
        my $tmp_file = File::Spec->catfile( $app->config('TempDir'), $tmp );
        unlink($tmp_file)
          or return $app->error(
            $app->translate( "Error deleting '[_1]': [_2]", $tmp_file, "$!" ) );
    }

    ## We are going to use $relative_path as the filename and as the url passed
    ## in to the templates. So, we want to replace all of the '\' characters
    ## with '/' characters so that it won't look like backslashed characters.
    ## Also, get rid of a slash at the front, if present.
    $relative_path =~ s!\\!/!g;
    $relative_path =~ s!^/!!;
    $relative_url  =~ s!\\!/!g;
    $relative_url  =~ s!^/!!;
    my $url = $base_url;
    $url .= '/' unless $url =~ m!/$!;
    $url .= $relative_url;
    my $asset_url = $asset_base_url . '/' . $relative_url;

    require File::Basename;
    my $local_basename = File::Basename::basename($local_file);
    my $ext =
      ( File::Basename::fileparse( $local_file, qr/[A-Za-z0-9]+$/ ) )[2];

    require MT::Asset;
    my $asset_pkg = MT::Asset->handler_for_file($local_basename);
    my $is_image  = defined($w)
      && defined($h)
      && $asset_pkg->isa('MT::Asset::Image');
    my $asset;
    if (
        !(
            $asset = $asset_pkg->load(
                { file_path => $asset_file, blog_id => $blog_id }
            )
        )
      )
    {
        $asset = $asset_pkg->new();
        $asset->file_path($asset_file);
        $asset->file_name($local_basename);
        $asset->file_ext($ext);
        $asset->blog_id($blog_id);
        $asset->created_by( $app->user->id );
    }
    else {
        $asset->modified_by( $app->user->id );
    }
    my $original = $asset->clone;
    $asset->url($asset_url);
    if ($is_image) {
        $asset->image_width($w);
        $asset->image_height($h);
    }
    $asset->mime_type($mimetype) if $mimetype;
    $asset->save;
    $app->run_callbacks( 'cms_post_save.asset', $app, $asset, $original );

    if ($is_image) {
        $app->run_callbacks(
            'cms_upload_file.' . $asset->class,
            File  => $local_file,
            file  => $local_file,
            Url   => $url,
            url   => $url,
            Size  => $bytes,
            size  => $bytes,
            Asset => $asset,
            asset => $asset,
            Type  => 'image',
            type  => 'image',
            Blog  => $blog,
            blog  => $blog
        );
        $app->run_callbacks(
            'cms_upload_image',
            File       => $local_file,
            file       => $local_file,
            Url        => $url,
            url        => $url,
            Size       => $bytes,
            size       => $bytes,
            Asset      => $asset,
            asset      => $asset,
            Height     => $h,
            height     => $h,
            Width      => $w,
            width      => $w,
            Type       => 'image',
            type       => 'image',
            ImageType  => $id,
            image_type => $id,
            Blog       => $blog,
            blog       => $blog
        );
    }
    else {
        $app->run_callbacks(
            'cms_upload_file.' . $asset->class,
            File  => $local_file,
            file  => $local_file,
            Url   => $url,
            url   => $url,
            Size  => $bytes,
            size  => $bytes,
            Asset => $asset,
            asset => $asset,
            Type  => 'file',
            type  => 'file',
            Blog  => $blog,
            blog  => $blog
        );
    }

    return ($asset, $bytes);
}

sub _write_upload {
    my ( $upload_fh, $dest_fh ) = @_;
    my $fh = gensym();
    if ( ref($dest_fh) eq 'GLOB' ) {
        $fh = $dest_fh;
    }
    else {
        open $fh, ">$dest_fh" or return;
    }
    binmode $fh;
    binmode $upload_fh;
    my ( $bytes, $data ) = (0);
    while ( my $len = read $upload_fh, $data, 8192 ) {
        print $fh $data;
        $bytes += $len;
    }
    close $fh;
    $bytes;
}

sub remove_userpic {
    my $app = shift;
    $app->validate_magic() or return;
    my $q  = $app->param;
    my $user_id = $q->param('user_id');
    my $user = $app->model('author')->load( { id => $user_id } )
        or return;
    if ($user->userpic_asset_id) {
        my $old_file = $user->userpic_file();
        my $fmgr = MT::FileMgr->new('Local');
        if ($fmgr->exists($old_file)) {
            $fmgr->delete($old_file);
        }
        $user->userpic_asset_id(0);
        $user->save;
    }
    return 'success';
}

sub search_replace {
    my $app = shift;
    my $param = $app->do_search_replace(@_) or return;
    my $blog_id = $app->param('blog_id');
    $app->add_breadcrumb( $app->translate('Search & Replace') );
    $param->{nav_search}   = 1;
    $param->{screen_class} = "search-replace";
    $param->{screen_id}    = "search-replace";
    $param->{search_tabs}  = $app->search_apis($blog_id ? 'blog' : 'system');
    $param->{entry_type}  = $app->param('entry_type');
    my $tmpl = $app->load_tmpl( 'search_replace.tmpl', $param );
    my $placeholder = $tmpl->getElementById('search_results');
    $placeholder->innerHTML(delete $param->{results_template});
    return $tmpl;
}

sub core_search_apis {
    my $app = shift;
    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');
    my $author  = $app->user;
    my @perms;
    if ( !$blog_id ) {
        if ( !$author->is_superuser() ) {
            require MT::Permission;
            @perms = MT::Permission->load( { author_id => $author->id } );
        }
    }
    else {
        @perms = ( $app->permissions )
          or return $app->error( $app->translate("No permissions") );
    }
    return {
        'entry' => {
            'order' => 100,
            'permission' => 'create_post,publish_post,edit_all_posts',
            'label' => 'Entries',
            'perm_check' => sub {
                grep { $_->can_edit_entry( $_[0], $author ) } @perms;
            },
            'search_cols' => {
                'title' => sub { $app->translate('Title') },
                'text' => sub { $app->translate('Entry Body') },
                'text_more' => sub { $app->translate('Extended Entry') },
                'keywords' => sub { $app->translate('Keywords') },
                'excerpt' => sub { $app->translate('Excerpt') },
                'basename' => sub { $app->translate('Basename') },
            },
            'replace_cols'       => [qw(title text text_more keywords excerpt)],
            'can_replace'        => 1,
            'can_search_by_date' => 1,
            'date_column'        => 'authored_on',
        },
        'comment' => {
            'order' => 200,
            'permission' => 'publish_post,create_post,edit_all_posts,manage_feedback',
            'label' => 'Comments',
            'perm_check' => sub {
                require MT::Entry;
                my $entry = MT::Entry->load( $_[0]->entry_id );
                grep { $_->can_edit_entry( $entry, $author ) } @perms;
            },
            'search_cols' => {
                'url' => sub { $app->translate('URL') },
                'text' => sub { $app->translate('Comment Text') },
                'email' => sub { $app->translate('Email Address') },
                'ip' => sub { $app->translate('IP Address') },
                'author' => sub { $app->translate('Name') },
            },
            'replace_cols'       => [qw(text)],
            'can_replace'        => 1,
            'can_search_by_date' => 1,
        },
        'ping' => {
            'order' => 300,
            'permission' => 'create_post,publish_post,edit_all_posts,manage_feedback',
            'label' => 'TrackBacks',
            'perm_check' => sub {
                my $ping = shift;
                my $tb   = MT::Trackback->load( $ping->tb_id );
                if ( $tb->entry_id ) {
                    require MT::Entry;
                    my $entry = MT::Entry->load( $tb->entry_id );
                    return
                      grep { $_->can_edit_entry( $entry, $author ) } @perms;
                }
                elsif ( $tb->category_id ) {
                    return grep { $_->can_edit_categories } @perms;
                }
            },
            'search_cols' => {
                'title' => sub { $app->translate('Title') },
                'excerpt' => sub { $app->translate('Excerpt') },
                'source_url' => sub { $app->translate('Source URL') },
                'ip' => sub { $app->translate('IP Address') },
                'blog_name' => sub { $app->translate('Blog Name') },
            },
            'replace_cols'       => [qw(title excerpt)],
            'can_replace'        => 1,
            'can_search_by_date' => 1,
        },
        'page' => {
            'order' => 400,
            'permission' => 'manage_pages',
            'label' => 'Pages',
            'perm_check' => sub {
                grep { $_->can_manage_pages( $_[0], $author ) } @perms;
            },
            'search_cols' => {
                'title' => sub { $app->translate('Title') },
                'text' => sub { $app->translate('Page Body') },
                'text_more' => sub { $app->translate('Extended Page') },
                'keywords' => sub { $app->translate('Keywords') },
                'excerpt' => sub { $app->translate('Excerpt') },
                'basename' => sub { $app->translate('Basename') },
            },
            'replace_cols'       => [qw(title text text_more keywords excerpt)],
            'can_replace'        => 1,
            'can_search_by_date' => 1,
            'date_column'        => 'authored_on',
            'results_table_template' => '<mt:include name="include/entry_table.tmpl">',
        },
        'template' => {
            'order'         => 500,
            'permission'    => 'edit_templates',
            'label'         => 'Templates',
            'perm_check' => sub {
                my ($obj) = @_;

                # are there any perms that match this object and
                # allow template editing?
                my @check = grep {
                         $_->blog_id == $obj->blog_id
                      && $_->can_edit_templates
                } @perms;
                return @check;

            },
            'search_cols' => {
                'name' => sub { $app->translate('Template Name') },
                'text' => sub { $app->translate('Text') },
                'linked_file' => sub { $app->translate('Linked Filename') },
                'outfile' => sub { $app->translate('Output Filename') },
            },
            'replace_cols'       => [qw(name text linked_file outfile)],
            'can_replace'        => 1,
            'can_search_by_date' => 0,
        },
        'asset' => {
            'order' => 600,
            'permission' => 'manage_assets',
            'label' => 'Assets',
            'perm_check' => sub {
                1;
            },
            'search_cols' => {
                'file_name' => sub { $app->translate('Filename') },
                'description' => sub { $app->translate('Description') },
                'label' => sub { $app->translate('Label') },
            },
            'replace_cols'       => [],
            'can_replace'        => 0,
            'can_search_by_date' => 1,
            'setup_terms_args'   => sub {
                my ($terms, $args, $blog_id) = @_;
                $terms->{class} = '*';
                $terms->{blog_id} = $blog_id if $blog_id;
            }
        },
        'log' => {
            'order' => 700,
            'permission'        => "view_blog_log",
            'system_permission' => "view_log",
            'label' => 'Activity Log',
            'perm_check' => sub {
                my ($obj) = @_;
                return 1 if $author->can_view_log;
                my $perm = $author->permissions( $obj->blog_id );
                return $perm->can_view_blog_log;
            },
            'search_cols' => {
                'ip' => sub { $app->translate('Log Message') },
                'message' => sub { $app->translate('IP Address') },
            },
            'can_replace'        => 0,
            'can_search_by_date' => 1,
            'setup_terms_args'   => sub {
                my ($terms, $args, $blog_id) = @_;
                $terms->{class} = '*';
                $terms->{blog_id} = $blog_id if $blog_id;
            }
        },
        'author' => {
            'order' => 800,
            'system_permission' => 'administer',
            'label' => 'Users',
            'perm_check' => sub {
                return 1 if $author->is_superuser;
                if ($blog_id) {
                    my $perm = $author->permissions($blog_id);
                    return $perm->can_administer_blog;
                }
                return 0;
            },
            'search_cols' => {
                'name'     => sub { $app->translate('Username') },
                'nickname' => sub { $app->translate('Display Name') },
                'email'    => sub { $app->translate('Email Address') },
                'url'      => sub { $app->translate('URL') },
            },
            'can_replace'        => 0,
            'can_search_by_date' => 0,
            'setup_terms_args'   => sub {
                my ($terms, $args, $blog_id) = @_;
                if ($blog_id) {
                    $args->{'join'} =
                      MT::Permission->join_on( 'author_id',
                        { blog_id => $blog_id } );
                }
                else {
                    $terms->{'type'} = MT::Author::AUTHOR();
                }
            },
            'results_table_template' => '
<mt:if name="blog_id">
    <mt:include name="include/member_table.tmpl">
<mt:else>
    <mt:include name="include/author_table.tmpl">
</mt:if>',
        },
        'blog' => {
            'order' => 900,
            'system_permission' => 'administer',
            'label' => 'Blogs',
            'perm_check' => sub {
                return 1 if $author->is_superuser;
                my ($obj) = @_;
                my $perm = $author->permissions( $obj->id );
                $perm
                  && ( $perm->can_administer_blog || $perm->can_edit_config );
            },
            'search_cols' => {
                'name' => sub { $app->translate('Name') },
                'site_url' => sub { $app->translate('Site URL') },
                'site_path' => sub { $app->translate('Site Root') },
                'description' => sub { $app->translate('Description') },
            },
            'replace_cols'       => [qw(name site_url site_path description)],
            'can_replace'        => $author->is_superuser(),
            'can_search_by_date' => 0,
            'view'               => 'system',
            'setup_terms_args'   => sub {
                my ($terms, $args, $blog_id) = @_;
                $args->{sort}      = 'name';
                $args->{direction} = 'ascend';
            }
        }
    };

}

sub _default_results_table_template {
    my $app = shift;
    my ($type, $results, $plural) = @_;
    if ($results) {
        return "<mt:include name=\"include/${type}_table.tmpl\">";
    }
    else {
        return <<TMPL;    
        <mtapp:statusmsg
                id="no-$plural"
                class="info">
                <__trans phrase="No [_1] were found that match the given criteria." params="$plural">
            </mtapp:statusmsg>
        </mt:if>
TMPL
    }
}

sub do_search_replace {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');
    my $author  = $app->user;

    my $search_api = $app->registry("search_apis");

    my (
        $search,        $replace,     $do_replace,    $case,
        $is_regex,      $is_limited,  $type,          $is_junk,
        $is_dateranged, $ids,         $datefrom_year, $datefrom_month,
        $datefrom_day,  $dateto_year, $dateto_month,  $dateto_day,
        $from,          $to,          $show_all,      $do_search,
        $orig_search,   $quicksearch
      )
      = map scalar $q->param($_),
      qw( search replace do_replace case is_regex is_limited _type is_junk is_dateranged replace_ids datefrom_year datefrom_month datefrom_day dateto_year dateto_month dateto_day from to show_all do_search orig_search quicksearch );


    if ( !$type || ( 'category' eq $type ) || ( 'folder' eq $type ) ) {
        $type = 'entry';
    }
    
    foreach my $obj_type (qw( role association )) {
        if ( $type eq $obj_type ) {
            $type = 'author';
        }
    }

    $replace && ( $app->validate_magic() or return );
    $search = $orig_search if $do_replace;    # for safety's sake
    my $list_pref = $app->list_pref($type);

    $app->assert( $search_api->{$type}, "Invalid request." ) or return;

    # force action bars to top and bottom
    $list_pref->{"bar"}                     = 'both';
    $list_pref->{"position_actions_both"}   = 1;
    $list_pref->{"position_actions_top"}    = 1;
    $list_pref->{"position_actions_bottom"} = 1;
    $list_pref->{"view"}                    = 'compact';
    $list_pref->{"view_compact"}            = 1;
    my ( @cols, $datefrom, $dateto, $date_col );
    $do_replace    = 0 unless $search_api->{$type}{can_replace};
    $is_dateranged = 0 unless $search_api->{$type}{can_search_by_date};
    my @ids;

    if ($ids) {
        @ids = split /,/, $ids;
    }
    if ($is_limited) {
        @cols = $q->param('search_cols');
        my %search_api_cols =
          map { $_ => 1 } keys %{ $search_api->{$type}{search_cols} };
        if ( @cols && ( $cols[0] =~ /,/ ) ) {
            @cols = split /,/, $cols[0];
        }
        @cols = grep { $search_api_cols{$_} } @cols;
    }
    else {
        @cols = keys %{ $search_api->{$type}->{search_cols} };
    }
    my $quicksearch_id;
    if ($quicksearch && ($search || '') ne '' && $search !~ m{ \D }xms) {
        $quicksearch_id = $search;
        unshift @cols, 'id';
    }
    foreach (
        $datefrom_year, $datefrom_month, $datefrom_day,
        $dateto_year,   $dateto_month,   $dateto_day
      )
    {
        s!\D!!g if $_;
    }
    if ($is_dateranged) {
        $datefrom = sprintf( "%04d%02d%02d",
            $datefrom_year, $datefrom_month, $datefrom_day );
        $dateto =
          sprintf( "%04d%02d%02d", $dateto_year, $dateto_month, $dateto_day );
        if ( ( $datefrom eq '00000000' ) && ( $dateto eq '00000000' ) ) {
            $is_dateranged = 0;
        }
        else {
            if (   !is_valid_date( $datefrom . '000000' )
                || !is_valid_date( $dateto . '000000' ) )
            {
                return $app->error(
                    $app->translate(
                        "Invalid date(s) specified for date range.")
                );
            }
        }
    }
    elsif ( $from && $to ) {
        $is_dateranged = 1;
        s!\D!!g foreach ( $from, $to );
        $datefrom = substr( $from, 0, 8 );
        $dateto   = substr( $to,   0, 8 );
    }
    my $tab = $q->param('tab') || 'entry';
    ## Sometimes we need to pass in the search columns like 'title,text', so
    ## we look for a comma (not a valid character in a column name) and split
    ## on it if it's there.
    if ( ($search || '') ne '' ) {
        my $enc = $app->charset;
        $search = MT::I18N::encode_text( $search, 'utf-8', $enc )
          if ( $enc !~ m/utf-?8/i )
          && ( 'dialog_grant_role' eq $app->param('__mode') );
        $search = quotemeta($search) unless $is_regex;
        $search = '(?i)' . $search   unless $case;
    }
    my ( @to_save, @data );
    my $api   = $search_api->{$type};
    my $class = $app->model($api->{object_type} || $type);
    my %param = %$list_pref;
    my $limit = $q->param('limit') || 125;    # FIXME: mt.cfg setting?
    my $matches;
    $date_col = $api->{date_column} || 'created_on';
    if ( ( $do_search && $search ne '' ) || $show_all || $do_replace ) {
        my %terms;
        my %args;
        ## we need to search all user/group for 'grant permissions',
        ## if $blog_id is specified. it affects the setup_terms_args.
        if ( $app->param('__mode') eq 'dialog_grant_role' ) {
            $blog_id = 0;
        }
        if (exists $api->{setup_terms_args}) {
            my $code = $app->handler_to_coderef($api->{setup_terms_args});
            $code->(\%terms, \%args, $blog_id);
        }
        else {
            %terms = $blog_id ? ( blog_id => $blog_id ) : ();
            if ( $type ne 'template' ) {
                %args = ( 'sort' => $date_col, direction => 'descend' );
            }
        }
        if ( $class->has_column('junk_status') ) {
            if ($is_junk) {
                $terms{junk_status} = -1;
            }
            else {
                $terms{junk_status} = [ 0, 1 ];
            }
        }
        if ($is_dateranged) {
            $args{range_incl}{$date_col} = 1;
            if ( $datefrom gt $dateto ) {
                $terms{$date_col} =
                  [ $dateto . '000000', $datefrom . '235959' ];
            }
            else {
                $terms{$date_col} =
                  [ $datefrom . '000000', $dateto . '235959' ];
            }
        }
        my $iter;
        if ($do_replace) {
            $iter = sub {
                if ( my $id = pop @ids ) {
                    $class->load($id);
                }
            };
        }
        if ( $blog_id || ($type eq 'blog') ) {
            $iter = $class->load_iter( \%terms, \%args ) or die $class->errstr;
        }
        else {

            my @streams;
            if ( $author->is_superuser ) {
                @streams = ( { iter => $class->load_iter( \%terms, \%args ) } );
            } 
            else {
                # Get an iter for each accessible blog
                my @perms = $app->model('permission')->load(
                    { blog_id => '0', author_id => $author->id },
                    { not => { blog_id => 1 } },
                );
                if (@perms) {
                    @streams = map {
                        {
                            iter => $class->load_iter(
                                {
                                    blog_id => $_->blog_id,
                                    %terms
                                },
                                \%args
                            )
                        }
                    } @perms;
                }
            }

            # Pull out the head of each iterator
            # Next: effectively mergesort the various iterators
            # To call the iterator n times takes time in O(bn)
            #   with 'b' the number of blogs
            # we expect to hit the iterator l/p times where 'p' is the
            #   prob. of the search term appearing and 'l' is $limit
            $_->{head} = $_->{iter}->() foreach @streams;
            if ( $type ne 'template' ) {
                $iter = sub {

                    # find the head with greatest created_on
                    my $which = \$streams[0];
                    foreach my $iter (@streams) {
                        next
                          if !exists $iter->{head}
                          || !$which
                          || !${$which}->{head}
                          || !defined( $iter->{head} );
                        if ( $iter->{head}->created_on >
                            ${$which}->{head}->created_on )
                        {
                            $which = \$iter;
                        }
                    }

                    # Advance the chosen one
                    my $result = ${$which}->{head};
                    ${$which}->{head} = ${$which}->{iter}->() if $result;
                    $result;
                };
            }
            else {
                $iter = sub {
                    return undef unless @streams;

                    # find the head with greatest created_on
                    my $which = \$streams[0];
                    while ( @streams && ( !defined ${$which}->{head} ) ) {
                        shift @streams;
                        last unless @streams;
                        $which = \$streams[0];
                    }
                    my $result = ${$which}->{head};
                    ${$which}->{head} = ${$which}->{iter}->() if $result;
                    $result;
                };
            }
        }
        my $i = 1;
        my %replace_cols;
        if ($do_replace) {
            %replace_cols = map { $_ => 1 } @{ $api->{replace_cols} };
        }

        my $re;
        if (($search || '') ne '') {
            $re = eval { qr/$search/ };
            if ( my $err = $@ ) {
                return $app->error(
                    $app->translate( "Error in search expression: [_1]", $@ ) );
            }
        }
        while ( my $obj = $iter->() ) {
            next unless $author->is_superuser || $api->{perm_check}->($obj);
            my $match = 0;
            unless ($show_all) {
                for my $col (@cols) {
                    next if $do_replace && !$replace_cols{$col};
                    my $text = $obj->column($col);
                    $text = '' unless defined $text;
                    if ($do_replace) {
                        if ( $text =~ s!$re!$replace!g ) {
                            $match++;
                            $obj->$col($text);
                        }
                    }
                    else {
                        $match = $search ne '' ? $text =~ m!$re! : 1;
                        last if $match;
                    }
                }
            }
            if ( $match || $show_all ) {
                push @to_save, $obj if $do_replace && !$show_all;
                push @data, $obj;
            }
            last if ( $limit ne 'all' ) && @data > $limit;
        }
        if (@data) {
            $param{have_results} = 1;

            # We got one extra to see if there were more
            if ( ( $limit ne 'all' ) && @data > $limit ) {
                $param{have_more} = 1;
                pop @data;
            }
            $matches = @data;
        }
        else {
            $matches = 0;
        }
    }
    my $replace_count = 0;
    for my $obj (@to_save) {
        $replace_count++;
        $obj->save
          or return $app->error(
            $app->translate( "Saving object failed: [_2]", $obj->errstr ) );
    }
    if (@data) {
        if ($quicksearch) {
            my $obj;
            if (1 == scalar @data) {
                ($obj) = @data;
            }
            elsif (defined $quicksearch_id) {
                ($obj) = grep { $_->id == $quicksearch_id } @data;
            }

            if ($obj) {
                my %args = (
                    _type         => $type,
                    id            => $obj->id,
                    search_result => 1,
                );
                $args{blog_id} = $obj->blog_id
                    if $obj->has_column('blog_id');
                return $app->redirect($app->uri(
                    mode => 'view',
                    args => \%args,
                ));
            }
        }

        if (my $meth = $search_api->{$type}{handler}) {
            $meth = $app->handler_to_coderef($meth);
            $meth->($app, items => \@data, param => \%param, type => $type );
        } else {
            my $meth = 'build_' . $type . '_table';
            if ( $app->can($meth) ) {
                $app->$meth( items => \@data, param => \%param, type => $type );
            }
            else {
                my @objects;
                push @objects, { object => $_ } for @data;
                $param{object_loop} = \@objects;
            }
        }
        $param{object_type} = $type;
        if ( exists $api->{results_table_template} ) {
            $param{results_template} = $api->{results_table_template};
        }
        else {
            $param{results_template} = $app->_default_results_table_template($type, 1, $class->class_label_plural);
        }
    }
    else {
        if ( exists $api->{no_results_template} ) {
            $param{results_template} = $api->{no_results_template};
        }
        else {
            $param{results_template} = $app->_default_results_table_template($type, 0, $class->class_label_plural);
        }
    }
    if ($is_dateranged) {
        ( $datefrom_year, $datefrom_month, $datefrom_day ) =
          $datefrom =~ m/^(\d\d\d\d)(\d\d)(\d\d)/;
        ( $dateto_year, $dateto_month, $dateto_day ) =
          $dateto =~ m/^(\d\d\d\d)(\d\d)(\d\d)/;
    }
    my %res = (
        error => $q->param('error') || '',
        limit => $limit,
        limit_all => $limit eq 'all',
        count_matches  => $matches,
        replace_count  => $replace_count,
        "search_$type" => 1,
        search_label   => $class->class_label_plural,
        object_label_plural => $class->class_label_plural,
        object_type    => $type,
        search         => ($do_replace ? $q->param('orig_search')
        : $q->param('search')) || '',
        searched => (
            $do_replace ? $q->param('orig_search')
            : ( $do_search && $q->param('search') ne '' )
          )
          || $show_all,
        replace            => $replace,
        do_replace         => $do_replace,
        case               => $case,
        datefrom_year      => $datefrom_year,
        datefrom_month     => $datefrom_month,
        datefrom_day       => $datefrom_day,
        dateto_year        => $dateto_year,
        dateto_month       => $dateto_month,
        dateto_day         => $dateto_day,
        is_regex           => $is_regex,
        is_limited         => $is_limited,
        is_dateranged      => $is_dateranged,
        is_junk            => $is_junk,
        can_search_junk    => ( $type eq 'comment' || $type eq 'ping' ),
        can_replace        => $search_api->{$type}{can_replace},
        can_search_by_date => $search_api->{$type}{can_search_by_date},
        quick_search       => 0,
        "tab_$tab"         => 1,
        %param
    );
    $res{'tab_junk'} = 1 if $is_junk;
    
    my $search_cols = $search_api->{$type}{search_cols};
    my %cols = map { $_ => 1 } @cols;
    my @search_cols;
    for my $field (keys %$search_cols) {
        my %search_field;
        $search_field{field}    = $field;
        $search_field{selected} = 1 if exists($cols{$field});
        $search_field{label}    = 'CODE' eq ref($search_cols->{$field})
          ? $search_cols->{$field}->()
          : $app->translate($search_cols->{$field});
        push @search_cols, \%search_field;
    }
    $res{'search_cols'} = \@search_cols;
    \%res;
}

sub start_export {
    my $app = shift;
    my %param;
    my $blog_id = $app->param('blog_id');

    my $perms = $app->permissions;
    return $app->return_to_dashboard( permission => 1 )
      if ( $perms && !$perms->can_administer_blog );

    $param{blog_id} = $blog_id;
    $app->load_tmpl( 'export.tmpl', \%param );
}

sub export {
    my $app = shift;
    $app->{no_print_body} = 1;
    local $| = 1;
    my $charset = $app->charset;
    require MT::Blog;
    my $blog_id = $app->param('blog_id')
      or return $app->error( $app->translate("Please select a blog.") );
    my $blog = MT::Blog->load($blog_id)
      or return $app->error(
        $app->translate(
            "Load of blog '[_1]' failed: [_2]",
            $blog_id, MT::Blog->errstr
        )
      );
    my $perms = $app->permissions;
    return $app->error( $app->translate("You do not have export permissions") )
      unless $perms && $perms->can_edit_config;
    $app->validate_magic() or return;
    my $file = dirify( $blog->name ) . ".txt";

    if ( $file eq ".txt" ) {
        my @ts = localtime(time);
        $file = sprintf "export-%06d-%04d%02d%02d%02d%02d%02d.txt",
          $app->param('blog_id'), $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
    }

    $app->set_header( "Content-Disposition" => "attachment; filename=$file" );
    $app->send_http_header(
        $charset
        ? "text/plain; charset=$charset"
        : 'text/plain'
    );
    require MT::ImportExport;
    MT::ImportExport->export( $blog, sub { $app->print(@_) } )
      or return $app->error( MT::ImportExport->errstr );
    1;
}

sub do_import {
    my $app = shift;

    my $q = $app->param;
    require MT::Blog;
    my $blog_id = $q->param('blog_id')
      or return $app->error( $app->translate("Please select a blog.") );
    my $blog = MT::Blog->load($blog_id)
      or return $app->error(
        $app->translate(
            "Load of blog '[_1]' failed: [_2]",
            $blog_id, MT::Blog->errstr
        )
      );

    if ( 'POST' ne $app->request_method ) {
        return $app->redirect(
            $app->uri(
                'mode' => 'start_import',
                args => { blog_id => $blog_id }
            )
        );
    }
    
    my $import_as_me = $q->param('import_as_me');

    ## Determine the user as whom we will import the entries.
    my $author    = $app->user;
    my $author_id = $author->id;
    if ( !$author->is_superuser ) {
        my $perms = $author->permissions($blog_id);
        return $app->error(
            $app->translate("You do not have import permissions") )
          unless $perms
          && ( $perms->can_edit_config || $perms->can_administer_blog );
        if ( !$import_as_me ) {
            return $app->error(
                $app->translate("You do not have permission to create users") )
              unless $perms->can_administer_blog;
        }
    }

    my ($pass);
    if ( !$import_as_me ) {
        $pass = $q->param('password')
          or return $app->error(
            $app->translate(
                    "You need to provide a password if you are going to "
                  . "create new users for each user listed in your blog."
            )
          ) if ( MT::Auth->password_exists );
    }

    $app->validate_magic() or return;

    my ($fh) = $app->upload_info('file');
    my $encoding = $q->param('encoding');
    my $stream = $fh ? $fh : $app->config('ImportPath');

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    my $param;
    $param = { import_as_me => $import_as_me, import_upload => ($fh ? 1 : 0) };

    $app->print( $app->build_page( 'include/import_start.tmpl', $param ) );

    require MT::Entry;
    require MT::Placement;
    require MT::Category;
    require MT::Permission;
    require MT::Comment;
    require MT::TBPing;

    my $import_type = $q->param('import_type');
    require MT::Import;
    my $imp      = MT::Import->new;
    my $importer = $imp->importer($import_type);

    return $app->error(
        $app->translate( 'Importer type [_1] was not found.', $import_type ) )
      unless $importer;

    my %options = map { $_ => $q->param($_); } @{ $importer->{options} }
      if $importer->{options};
    my $import_result = $imp->import_contents(
        Key      => $import_type,
        Blog     => $blog,
        Stream   => $stream,
        Callback => sub { $app->print(@_) },
        Encoding => $encoding,
        ($import_as_me)
        ? ( ImportAs => $author )
        : ( ParentAuthor => $author ),
        NewAuthorPassword => ( $q->param('password')       || undef ),
        DefaultCategoryID => ( $q->param('default_cat_id') || undef ),
        ConvertBreaks     => ( $q->param('convert_breaks') || undef ),
        (%options) ? (%options) : (),
    );

    $param->{import_success} = $import_result;
    $param->{error} = $importer->{type}->errstr unless $import_result;

    $app->print( $app->build_page( "include/import_end.tmpl", $param ) );

    close $fh if $fh;
    1;
}

sub save_entry_prefs {
    my $app   = shift;
    my $perms = $app->permissions
      or return $app->error( $app->translate("No permissions") );
    $app->validate_magic() or return;
    my $q     = $app->param;
    my $prefs = $app->_entry_prefs_from_params;
    $perms->entry_prefs($prefs);
    $perms->save
      or return $app->error(
        $app->translate( "Saving permissions failed: [_1]", $perms->errstr ) );
    $app->send_http_header("text/json");
    return "true";
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

sub save_favorite_blogs {
    my $app = shift;
    $app->validate_magic() or return;
    my $fav = $app->param('id');
    return unless int($fav) > 0;
    $app->add_to_favorite_blogs($fav);
    $app->send_http_header("text/javascript+json");
    return 'true';
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

sub _generate_map_table {
    my $app = shift;
    my ( $blog_id, $template_id ) = @_;

    require MT::Template;
    require MT::Blog;
    my $blog     = MT::Blog->load($blog_id);
    my $template = MT::Template->load($template_id);
    my $tmpl     = $app->load_tmpl('include/archive_maps.tmpl');
    my $maps     = $app->_populate_archive_loop( $blog, $template );
    $tmpl->param( { object_type => 'templatemap' } );
    $tmpl->param( { object_loop => $maps } ) if @$maps;
    my $html = $tmpl->output();

    if ( $html =~ m/<__trans / ) {
        $html = $app->translate_templatized($html);
    }
    $html;
}

sub delete_map {
    my $app = shift;
    $app->validate_magic() or return;
    my $perms = $app->{perms}
      or return $app->error( $app->translate("No permissions") );
    my $q  = $app->param;
    my $id = $q->param('id');

    require MT::TemplateMap;
    MT::TemplateMap->remove( { id => $id } );
    my $html =
      $app->_generate_map_table( $q->param('blog_id'),
        $q->param('template_id') );
    $app->{no_print_body} = 1;
    $app->send_http_header("text/plain");
    $app->print($html);
}

sub add_map {
    my $app = shift;
    $app->validate_magic() or return;
    my $perms = $app->{perms}
      or return $app->error( $app->translate("No permissions") );

    my $q = $app->param;

    require MT::TemplateMap;
    my $blog_id = $q->param('blog_id');
    my $at      = $q->param('new_archive_type');
    my $count   = MT::TemplateMap->count(
        {
            blog_id      => $blog_id,
            archive_type => $at
        }
    );
    my $map = MT::TemplateMap->new;
    $map->is_preferred( $count ? 0 : 1 );
    $map->template_id( scalar $q->param('template_id') );
    $map->blog_id($blog_id);
    $map->archive_type($at);
    $map->save
      or return $app->error(
        $app->translate( "Saving map failed: [_1]", $map->errstr ) );
    my $html =
      $app->_generate_map_table( $blog_id, scalar $q->param('template_id') );
    $app->rebuild(
        BlogID      => $blog_id,
        ArchiveType => $at,
        TemplateMap => $map,
        TemplateID  => scalar $q->param('template_id'),
        NoStatic    => 1
    ) or return $app->publish_error();
    $app->{no_print_body} = 1;
    $app->send_http_header("text/plain");
    $app->print($html);
}

sub pinged_urls {
    my $app   = shift;
    my $perms = $app->permissions
      or return $app->error( $app->translate("No permissions") );
    my %param;
    my $entry_id = $app->param('entry_id');
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id);
    $param{url_loop} = [ map { { url => $_ } } @{ $entry->pinged_url_list } ];
    $param{failed_url_loop} =
      [ map { { url => $_ } }
          @{ $entry->pinged_url_list( OnlyFailures => 1 ) } ];
    $app->load_tmpl( 'popup/pinged_urls.tmpl', \%param );
}

sub reg_file {
    my $app = shift;
    my $q   = $app->param;
    my $uri = $app->base
      . $app->uri(
        'mode' => 'reg_bm_js',
        args   => {
            bm_show   => $q->param('bm_show'),
            bm_height => $q->param('bm_height')
        }
      );
    $app->{no_print_body} = 1;
    $app->set_header( 'Content-Disposition' => 'attachment; filename=mt.reg' );
    $app->send_http_header('text/plain; name=mt.reg');
    $app->print( qq(REGEDIT4\r\n)
          . qq([HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\MenuExt\\QuickPost]\r\n)
          . qq(@="$uri"\r\n)
          . qq("contexts"=hex:31) );
    1;
}

sub reg_bm_js {
    my $app = shift;
    my $q   = $app->param;
    my $js =
      $app->_bm_js( scalar $q->param('bm_show'),
        scalar $q->param('bm_height') );
    $js =~ s!d=document!d=external.menuArguments.document!;
    $js =~ s!d\.location\.href!external.menuArguments.location.href!;
    $js =~ s!^javascript:!!;
    $js =~ s!\%20! !g;
    $app->{no_print_body} = 1;
    $app->send_http_header('text/plain');
    $app->print( '<script language="javascript">' . $js . '</script>' );
    1;
}

sub category_add {
    my $app  = shift;
    my $q    = $app->param;
    my $type = $q->param('_type') || 'category';
    my $pkg  = $app->model($type);
    my $data = $app->_build_category_list(
        blog_id => scalar $q->param('blog_id'),
        type    => $type
    );
    my %param;
    $param{'category_loop'} = $data;
    $app->add_breadcrumb( $app->translate( 'Add a [_1]', $pkg->class_label ) );
    $param{object_type}  = $type;
    $param{object_label} = $pkg->class_label;
    $app->load_tmpl( 'popup/category_add.tmpl', \%param );
}

sub category_do_add {
    my $app    = shift;
    my $q      = $app->param;
    my $type   = $q->param('_type') || 'category';
    my $author = $app->user;
    my $pkg    = $app->model($type);
    $app->validate_magic() or return;
    my $name = $q->param('label')
      or return $app->error( $app->translate("No label") );
    $name =~ s/(^\s+|\s+$)//g;
    return $app->errtrans("Category name cannot be blank.")
      if $name eq '';
    my $parent   = $q->param('parent') || '0';
    my $cat      = $pkg->new;
    my $original = $cat->clone;
    $cat->blog_id( scalar $q->param('blog_id') );
    $cat->author_id( $app->user->id );
    $cat->label($name);
    $cat->parent($parent);

    if ( !$author->is_superuser ) {
        $app->run_callbacks( 'cms_save_permission_filter.' . $type,
            $app, undef )
          || return $app->error(
            $app->translate( "Permission denied: [_1]", $app->errstr() ) );
    }

    my $filter_result = $app->run_callbacks( 'cms_save_filter.' . $type, $app )
      || return;

    $app->run_callbacks( 'cms_pre_save.' . $type, $app, $cat, $original )
      || return;

    $cat->save or return $app->error( $cat->errstr );

    # Now post-process it.
    $app->run_callbacks( 'cms_post_save.' . $type, $app, $cat, $original )
      or return;

    my $id = $cat->id;
    $name = encode_js($name);
    my %param = ( javascript => <<SCRIPT);
    o.doAddCategoryItem('$name', '$id');
SCRIPT
    $app->load_tmpl( 'reload_opener.tmpl', \%param );
}

sub cc_return {
    my $app   = shift;
    my $code  = $app->param('license_code');
    my $url   = $app->param('license_url');
    my $image = $app->param('license_button');
    my %param = ( license_name => MT::Util::cc_name($code) );
    if ($url) {
        $param{license_code} = "$code $url $image";
    }
    else {
        $param{license_code} = $code;
    }
    $app->load_tmpl( 'cc_return.tmpl', \%param );
}

sub reset_blog_templates {
    my $app   = shift;
    my $q     = $app->param;
    my $perms = $app->permissions
      or return $app->error( $app->translate("No permissions") );
    return $app->error( $app->translate("Permission denied.") )
      unless $perms->can_edit_templates;
    $app->validate_magic() or return;
    my $blog = MT::Blog->load( $perms->blog_id );
    require MT::Template;
    my @tmpl = MT::Template->load( { blog_id => $blog->id } );

    for my $tmpl (@tmpl) {
        $tmpl->remove or return $app->error( $tmpl->errstr );
    }
    my $set = $blog ? $blog->template_set : undef;
    require MT::DefaultTemplates;
    my $tmpl_list = MT::DefaultTemplates->templates($set) || [];
    my @arch_tmpl;
    for my $val (@$tmpl_list) {
        $val->{name} = $app->translate( $val->{name} );
        $val->{text} = $app->translate_templatized( $val->{text} );
        my $tmpl = MT::Template->new;
        $tmpl->set_values($val);
        $tmpl->build_dynamic(0);
        $tmpl->blog_id( $blog->id );
        $tmpl->save
          or return $app->error(
            $app->translate(
                "Populating blog with default templates failed: [_1]",
                $tmpl->errstr
            )
          );

        # FIXME: enumeration of types
        if (   $val->{type} eq 'archive'
            || $val->{type} eq 'category'
            || $val->{type} eq 'page'
            || $val->{type} eq 'individual' )
        {
            push @arch_tmpl, $tmpl;
        }
    }

    ## Set up mappings from new templates to archive types.
    for my $tmpl (@arch_tmpl) {
        my (@at);

        # FIXME: enumeration of types
        if ( $tmpl->type eq 'archive' ) {
            @at = qw( Daily Weekly Monthly Category );
        }
        elsif ( $tmpl->type eq 'page' ) {
            @at = qw( Page );
        }
        elsif ( $tmpl->type eq 'individual' ) {
            @at = qw( Individual );
        }
        require MT::TemplateMap;
        for my $at (@at) {
            my $map = MT::TemplateMap->new;
            $map->archive_type($at);
            $map->is_preferred(1);
            $map->template_id( $tmpl->id );
            $map->blog_id( $tmpl->blog_id );
            $map->save
              or return $app->error(
                $app->translate(
                    "Setting up mappings failed: [_1]",
                    $map->errstr
                )
              );
        }
    }
    $app->redirect(
        $app->uri(
            'mode' => 'list',
            args =>
              { '_type' => 'template', blog_id => $blog->id, 'reset' => 1 }
        )
    );
}

sub update_dynamicity {
    my $app = shift;
    my ( $blog, $cache, $conditional ) = @_;
    my $dcty = $blog->custom_dynamic_templates;
    if ( $dcty eq 'none' ) {
        require MT::Template;
        my @templates = MT::Template->load( { blog_id => $blog->id } );
        for my $tmpl (@templates) {
            $tmpl->build_dynamic(0);
            $tmpl->save();
        }
    }
    elsif ( $dcty eq 'archives' ) {
        require MT::Template;
        my @templates = MT::Template->load( { blog_id => $blog->id } );
        for my $tmpl (@templates) {
            $tmpl->build_dynamic( $tmpl->type ne 'index' || 0 );
            $tmpl->save();
        }
    }
    elsif ( $dcty eq 'custom' ) {
    }
    elsif ( $dcty eq 'all' ) {
        require MT::Template;
        my @templates = MT::Template->load(
            {
                blog_id => $blog->id,

                # FIXME: enumeration of types
                type =>
                  [ 'index', 'archive', 'individual', 'page', 'category' ],
            }
        );
        for my $tmpl (@templates) {
            $tmpl->build_dynamic(1);
            $tmpl->save();
        }
    }

    if ( $dcty ne 'none' ) {
        $app->prepare_dynamic_publishing(@_, $blog->site_path, $blog->site_url);
        if ( $blog->archive_path ) {
            $app->prepare_dynamic_publishing(@_, $blog->archive_path, $blog->archive_url);
        }
        my $compiled_template_path =
          File::Spec->catfile( $blog->site_path(), 'templates_c' );
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
            my $cache_path = File::Spec->catfile( $blog->site_path(), 'cache' );
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
    $app->add_return_arg( dynamic_set => 1 );
}

sub prepare_dynamic_publishing {
    my ( $cb, $blog, $cache, $conditional, $site_path, $site_url ) = @_;

    my $htaccess_path = File::Spec->catfile( $site_path, ".htaccess" );
    my $mtview_path   = File::Spec->catfile( $site_path, "mtview.php" );

    ## Don't re-create when files are there in callback.
    return 1
      if !defined($cache)
      && !defined($conditional)
      && ( 'MT::Callback' eq ref($cb) )
      && ( -f $htaccess_path )
      && ( -f $mtview_path );
    return 1 if ( 'none' eq $blog->custom_dynamic_templates );

    require File::Spec;

    # IIS itself does not handle .htaccess,
    # but IISPassword (3rd party) does and dies with this.
    if ( $ENV{SERVER_SOFTWARE} !~ /Microsoft-IIS/ ) {
        eval {
            require URI;
            my $mtview_server_url = new URI( $site_url );
            $mtview_server_url = $mtview_server_url->path();
            $mtview_server_url .=
              ( $mtview_server_url =~ m|/$| ? "" : "/" ) . "mtview.php";

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
Options -Indexes +SymLinksIfOwnerMatch
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
  RewriteRule ^(.*)\$ $mtview_server_url [L,QSA]
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

                $blog->file_mgr->mkpath( $site_path );

                open( HT, ">>$htaccess_path" )
                  || die "Couldn't open $htaccess_path for appending";
                print HT $htaccess || die "Couldn't write to $htaccess_path";
                close HT;
            }
        };
        if ($@) { print STDERR $@; }
    }

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
        my $cache_code = $cache ? "\n    \$mt->caching = true;" : '';
        my $conditional_code =
          $conditional ? "\n    \$mt->conditional = true;" : '';
        my $new_mtview = <<NEW_MTVIEW;

    include('$mtphp_path');
    \$mt = new MT($blog_id, '$config');$cache_code$conditional_code
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

            $blog->file_mgr->mkpath( $site_path );
            open( my $mv, ">$mtview_path" )
              || die "Couldn't open $mtview_path for appending";
            print $mv $mtview || die "Couldn't write to $mtview_path";
            close $mv;
        }
    };
    if ($@) { print STDERR $@; }

    my $compiled_template_path =
      File::Spec->catfile( $site_path, 'templates_c' );
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

    # FIXME: use FileMgr
    if ($cache) {
        my $cache_path = File::Spec->catfile( $blog->site_path(), 'cache' );
        $cfg->DirUmask('0000');
        $fmgr->mkpath($cache_path);
        $cfg->DirUmask($saved_umask);
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
    }
    MT->log(
        {
            message => $message,
            level   => MT::Log::ERROR(),
            class   => 'system',
        }
    );
}

sub handshake {
    my $app               = shift;
    my $blog_id           = $app->param('blog_id');
    my $remote_auth_token = $app->param('remote_auth_token');

    my %param = ();
    $param{remote_auth_token} = $remote_auth_token;
    $app->load_tmpl( 'handshake_return.tmpl', \%param );
}

sub do_list_action {
    my $app = shift;
    $app->validate_magic or return;

    # plugin_action_selector should always (?) be in the query; use it?
    my $action_name = $app->param('action_name');
    my $type        = $app->param('_type');
    my ($the_action) =
      ( grep { $_->{key} eq $action_name } @{ $app->list_actions($type) } );
    return $app->errtrans( "That action ([_1]) is apparently not implemented!",
        $action_name )
      unless $the_action;

    unless ( ref( $the_action->{code} ) ) {
        if ( my $plugin = $the_action->{plugin} ) {
            $the_action->{code} =
              $app->handler_to_coderef( $the_action->{handler}
                  || $the_action->{code} );
        }
    }
    $the_action->{code}->($app);
}

sub do_page_action {
    my $app = shift;

    # plugin_action_selector should always (?) be in the query; use it?
    my $action_name = $app->param('action_name');
    my $type        = $app->param('_type');
    my ($the_action) =
      ( grep { $_->{key} eq $action_name } @{ $app->page_actions($type) } );
    return $app->errtrans( "That action ([_1]) is apparently not implemented!",
        $action_name )
      unless $the_action;

    unless ( ref( $the_action->{code} ) ) {
        if ( my $plugin = $the_action->{plugin} ) {
            $the_action->{code} =
              $app->handler_to_coderef( $the_action->{handler}
                  || $the_action->{code} );
        }
    }
    $the_action->{code}->($app);
}

sub rebuild_new_phase {
    my ($app) = @_;
    my %reb_set = map { $_ => 1 } $app->param('id');
    $app->rebuild_these( \%reb_set, how => NEW_PHASE );
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

        # now, rebuild indexes for affected blogs
        my @blogs = $app->param('blog_ids');
        foreach my $blog_id (@blogs) {
            my $blog = MT::Blog->load($blog_id) or next;
            $app->rebuild_indexes( Blog => $blog )
                or return $app->publish_error();
        }
        my $this_blog = MT::Blog->load( $app->param('blog_id') );
        $app->run_callbacks( 'rebuild', $this_blog );
        return $app->call_return;
    }

    if ( exists $options{how} && ( $options{how} eq NEW_PHASE ) ) {
        my $params = {
            return_args => $app->return_args,
            blog_id     => $app->param('blog_id') || 0,
            id          => [ keys %$rebuild_set ]
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
        my @blogs = $app->param('blog_ids');
        my %blogs = map { $_ => () } @blogs;
        my @set   = keys %$rebuild_set;
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
            if ( $type ne MT::Entry->class_type ) {
                my $pkg = MT->model($type) or next;
                bless $e, $pkg;
            }
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

sub empty_junk {
    my $app     = shift;
    my $perms   = $app->permissions;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    return $app->errtrans("Permission denied.")
      if ( !$blog_id && !$user->is_superuser() )
      || (
        $perms
        && !(
               $perms->can_administer_blog
            || $perms->can_edit_all_posts
            || $perms->can_manage_feedback
        )
      );

    my $type  = $app->param('_type');
    my $class = $app->model($type);
    my $arg   = {};
    $arg->{junk_status} = -1;
    $arg->{blog_id} = $blog_id if $blog_id;
    $class->remove($arg);
    $app->add_return_arg( 'emptied' => 1 );
    $app->call_return;
}

sub handle_junk {
    my $app   = shift;
    my @ids   = $app->param("id");
    my $type  = $app->param("_type");
    my $class = $app->model($type);
    my @item_loop;
    my $i       = 0;
    my $blog_id = $app->param('blog_id');
    my ( %rebuild_entries, %rebuild_categories );

    my @obj_ids = $app->param('id');
    if ( my $req_nonce = $app->param('nonce') ) {
        if ( scalar @obj_ids == 1 ) {
            my $cmt_id = $obj_ids[0];
            if ( my $obj = $class->load($cmt_id) ) {
                my $nonce =
                  MT::Util::perl_sha1_digest_hex( $obj->id
                      . $obj->created_on
                      . $obj->blog_id
                      . $app->config->SecretToken );
                return $app->errtrans("Invalid request.")
                  unless $nonce eq $req_nonce;
                my $return_args = $app->uri_params(
                    mode => 'view',
                    args => {
                        '_type' => $type,
                        id      => $cmt_id,
                        blog_id => $obj->blog_id
                    }
                );
                $return_args =~ s!^\?!!;
                $app->return_args($return_args);
            }
            else {
                return $app->errtrans("Invalid request.");
            }
        }
        else {
            return $app->errtrans("Invalid request.");
        }
    }
    else {
        $app->validate_magic() or return;
    }

    my $perms = $app->permissions;
    my $perm_checked = ( $app->user->is_superuser()
      || (
        $app->param('blog_id')
        && (   $perms->can_manage_feedback
            || $perms->can_edit_all_posts )
      ) ) ? 1 : 0;

    foreach my $id (@ids) {
        next unless $id;

        my $obj = $class->load($id) or die "No $class $id";
        my $old_visible = $obj->visible || 0;
        unless ($perm_checked) {
            if ( $obj->isa('MT::TBPing') && $obj->parent->isa('MT::Entry') ) {
                next if $obj->parent->author_id != $app->user->id;
            }
            elsif ( $obj->isa('MT::Comment') ) {
                next if $obj->entry->author_id != $app->user->id;
            }
            next unless $perms->can_publish_post;
        }
        $obj->junk;
        $app->run_callbacks( 'handle_spam', $app, $obj )
          ;            # mv this into blk below?
        $obj->save;    # (so that each cb doesn't have to save indiv'ly)
        next if $old_visible == $obj->visible;
        if ( $obj->isa('MT::TBPing') ) {
            my ( $parent_type, $parent_id ) = $obj->parent_id();
            if ( $parent_type eq 'MT::Entry' ) {
                $rebuild_entries{$parent_id} = 1;
            }
            else {
                $rebuild_categories{ $obj->category_id } = 1;

                # TODO: do something with this list.
            }
        }
        else {
            $rebuild_entries{ $obj->entry_id } = 1;
        }
    }
    $app->add_return_arg( 'junked' => 1 );
    if (%rebuild_entries) {
        $app->rebuild_these( \%rebuild_entries, how => NEW_PHASE );
    }
    else {
        $app->call_return;
    }
}

sub not_junk {
    my $app = shift;

    my $perms = $app->permissions;

    my @ids = $app->param("id");
    my @item_loop;
    my $i     = 0;
    my $type  = $app->param('_type');
    my $class = $app->model($type);
    my %rebuild_set;

    my $perm_checked = ( $app->user->is_superuser()
      || (
        $app->param('blog_id')
        && (   $perms->can_manage_feedback
            || $perms->can_edit_all_posts )
      ) ) ? 1 : 0;

    foreach my $id (@ids) {
        next unless $id;
        my $obj = $class->load($id);
        unless ($perm_checked) {
            if ( $obj->isa('MT::TBPing') && $obj->parent->isa('MT::Entry') ) {
                next if $obj->parent->author_id != $app->user->id;
            }
            elsif ( $obj->isa('MT::Comment') ) {
                next if $obj->entry->author_id != $app->user->id;
            }
            next unless $perms->can_publish_post;
        }
        $obj->approve;
        $app->run_callbacks( 'handle_ham', $app, $obj );
        if ( $obj->isa('MT::TBPing') ) {
            my ( $parent_type, $parent_id ) = $obj->parent_id();
            if ( $parent_type eq 'MT::Entry' ) {
                $rebuild_set{$parent_id} = 1;
            }
            else {
            }
        }
        else {
            $rebuild_set{ $obj->entry_id } = 1;
        }
        $obj->save();
    }
    $app->param( 'approve', 1 );

    $app->add_return_arg( 'unjunked' => 1 );

    $app->rebuild_these( \%rebuild_set, how => NEW_PHASE );
}

sub _cb_notjunktest_filter {
    my ( $eh, $app, $obj ) = @_;
    require MT::JunkFilter;
    MT::JunkFilter->filter($obj);
    $obj->is_junk ? 0 : 1;
}

sub update_list_prefs {
    my $app   = shift;
    my $prefs = $app->list_pref( $app->param('_type') );
    $app->call_return;
}

sub add_tags_to_entries {
    my $app = shift;

    my @id = $app->param('id');

    require MT::Tag;
    my $tags      = $app->param('itemset_action_input');
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my @tags      = MT::Tag->split( $tag_delim, $tags );
    return $app->call_return unless @tags;

    require MT::Entry;

    my $user  = $app->user;
    my $perms = $app->permissions;
    foreach my $id (@id) {
        next unless $id;
        my $entry = MT::Entry->load($id) or next;
        next
          unless $user->is_superuser
          || $perms->can_edit_entry( $entry, $user );

        $entry->add_tags(@tags);
        $entry->save
          or return $app->trans_error( "Error saving entry: [_1]",
            $entry->errstr );
    }

    $app->add_return_arg( 'saved' => 1 );
    $app->call_return;
}

sub remove_tags_from_entries {
    my $app = shift;

    my @id = $app->param('id');

    require MT::Tag;
    my $tags      = $app->param('itemset_action_input');
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my @tags      = MT::Tag->split( $tag_delim, $tags );
    return $app->call_return unless @tags;

    require MT::Entry;

    my $user  = $app->user;
    my $perms = $app->permissions;
    foreach my $id (@id) {
        next unless $id;
        my $entry = MT::Entry->load($id) or next;
        next
          unless $user->is_superuser
          || $perms->can_edit_entry( $entry, $user );
        $entry->remove_tags(@tags);
        $entry->save
          or return $app->trans_error( "Error saving entry: [_1]",
            $entry->errstr );
    }

    $app->add_return_arg( 'saved' => 1 );
    $app->call_return;
}

sub dialog_select_weblog {
    my $app = shift;

    #return $app->errtrans("Permission denied.")
    #    unless $app->user->is_superuser;

    my $favorites = $app->param('select_favorites');
    my %favorite;
    my $confirm_js;
    my $terms = {};
    my $args  = {};
    if ($favorites) {
        my $auth = $app->user or return;
        if ( my @favs = @{ $auth->favorite_blogs || [] } ) {
            $terms->{id} = \@favs;
            $args->{not}{id} = 1;
        }
        $confirm_js = 'saveFavorite';
    }

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        $row->{label} = $row->{name};
        $row->{'link'} = $row->{site_url};
    };

    $app->listing(
        {
            type     => 'blog',
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
                ? $app->param('multi')
                : 0,
                panel_searchable => 1,
                panel_first      => 1,
                panel_last       => 1,
                list_noncron     => 1,
                return_url       => $app->uri . '?'
                  . ( $app->param('return_args') || '' ),
                confirm_js => $confirm_js,
                idfield    => ( $app->param('idfield') || '' ),
                namefield  => ( $app->param('namefield') || '' ),
            },
        }
    );
}

sub dialog_select_sysadmin {
    my $app = shift;
    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser;

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        $row->{label}       = $row->{name};
        $row->{description} = $row->{nickname};
    };

    $app->listing(
        {
            type  => 'author',
            terms => {
                type   => MT::Author::AUTHOR(),
                status => MT::Author::ACTIVE(),
            },
            args => {
                sort => 'name',
                join => MT::Permission->join_on(
                    'author_id',
                    {
                        permissions => "\%'administer'\%",
                        blog_id     => '0',
                    },
                    { 'like' => { 'permissions' => 1 } }
                ),
            },
            code     => $hasher,
            template => 'dialog/select_users.tmpl',
            params   => {
                dialog_title =>
                  $app->translate("Select a System Administrator"),
                items_prompt =>
                  $app->translate("Selected System Administrator"),
                search_prompt => $app->translate(
                    "Type a username to filter the choices below."),
                panel_label       => $app->translate("System Administrator"),
                panel_description => $app->translate("Name"),
                panel_type        => 'author',
                panel_multi       => defined $app->param('multi')
                ? $app->param('multi')
                : 0,
                panel_searchable => 1,
                panel_first      => 1,
                panel_last       => 1,
                list_noncron     => 1,
                idfield          => $app->param('idfield'),
                namefield        => $app->param('namefield'),
            },
        }
    );
}

sub add_tags_to_assets {
    my $app = shift;

    my @id = $app->param('id');

    require MT::Tag;
    my $tags      = $app->param('itemset_action_input');
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my @tags      = MT::Tag->split( $tag_delim, $tags );
    return $app->call_return unless @tags;

    require MT::Asset;

    my $user  = $app->user;
    my $perms = $app->permissions;
    foreach my $id (@id) {
        next unless $id;
        my $asset = MT::Asset->load($id) or next;
        next
          unless $user->is_superuser
          || $perms->can_edit_assets;

        $asset->add_tags(@tags);
        $asset->save
          or
          return $app->trans_error( "Error saving file: [_1]", $asset->errstr );
    }

    $app->add_return_arg( 'saved' => 1 );
    $app->call_return;
}

sub remove_tags_from_assets {
    my $app = shift;

    my @id = $app->param('id');

    require MT::Tag;
    my $tags      = $app->param('itemset_action_input');
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my @tags      = MT::Tag->split( $tag_delim, $tags );
    return $app->call_return unless @tags;

    require MT::Asset;

    my $user  = $app->user;
    my $perms = $app->permissions;
    foreach my $id (@id) {
        next unless $id;
        my $asset = MT::Asset->load($id) or next;
        next
          unless $user->is_superuser
          || $perms->can_edit_assets;
        $asset->remove_tags(@tags);
        $asset->save
          or
          return $app->trans_error( "Error saving file: [_1]", $asset->errstr );
    }

    $app->add_return_arg( 'saved' => 1 );
    $app->call_return;
}

# This mode can be called to service a number of views
# Adding roles->blogs for a user
# Adding roles->blogs for a group
# Adding users->roles->blogs
# Adding groups->roles->blogs
sub dialog_grant_role {
    my $app = shift;

    my $author_id = $app->param('author_id');
    my $blog_id   = $app->param('blog_id');
    my $role_id   = $app->param('role_id');

    my $this_user = $app->user;
    if ( !$this_user->is_superuser ) {
        if (   !$blog_id
            || !$this_user->permissions($blog_id)->can_administer_blog )
        {
            return $app->errtrans("Permission denied.");
        }
    }

    my $type = $app->param('_type');
    my ( $user, $role );
    if ($author_id) {
        $user = MT::Author->load($author_id);
    }
    if ($role_id) {
        require MT::Role;
        $role = MT::Role->load($role_id);
    }

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        $row->{label} = $row->{name};
        $row->{description} = $row->{nickname} if exists $row->{nickname};
    };

    # Only show active users who are not commenters.
    my $terms = {};
    if ( $type && ( $type eq 'author' ) ) {
        $terms->{status} = MT::Author::ACTIVE();
        $terms->{type}   = MT::Author::AUTHOR();
    }

    my $pseudo_user_row = {
        id    => 'PSEUDO',
        label => $app->translate('(newly created user)'),
        description =>
          $app->translate('represents a user who will be created afterwards'),
    };

    if ( $app->param('search') || $app->param('json') ) {
        my $params = {
            panel_type   => $type,
            list_noncron => 1,
            panel_multi  => 1,
        };
        $app->listing(
            {
                terms    => $terms,
                type     => $type,
                code     => $hasher,
                params   => $params,
                template => 'include/listing_panel.tmpl',
                $app->param('search') ? () : (
                    pre_build => sub {
                        my ($param) = @_;
                        if ( $type && $type eq 'author' ) {
                            if ( !$app->param('offset') ) {
                                my $objs = $param->{object_loop} ||= [];
                                unshift @$objs, $pseudo_user_row;
                            }
                        }
                    }
                ),
            }
        );
    }
    else {

        # traditional, full-screen listing
        my $params = {
            ($author_id || 0) eq 'PSEUDO'
            ? (
                edit_author_name => $app->translate('(newly created user)'),
                edit_author_id   => 'PSEUDO'
              )
            : $author_id
              ? (
                  edit_author_name => $user->nickname
                  ? $user->nickname
                  : $user->name,
                  edit_author_id => $user->id,
                )
              : (),
            $role_id
            ? (
                role_name => $role->name,
                role_id   => $role->id,
              )
            : (),
        };

        my @panels;
        if ( !$role_id ) {
            push @panels, 'role';
        }
        if ( !$blog_id ) {
            push @panels, 'blog';
        }
        if ( !$author_id ) {
            if ( $type eq 'user' ) {
                unshift @panels, 'author';
            }
        }

        my $panel_info = {
            'blog' => {
                panel_title       => $app->translate("Select Blogs"),
                panel_label       => $app->translate("Blog Name"),
                items_prompt      => $app->translate("Blogs Selected"),
                search_label      => $app->translate("Search Blogs"),
                panel_description => $app->translate("Description"),
            },
            'author' => {
                panel_title       => $app->translate("Select Users"),
                panel_label       => $app->translate("Username"),
                items_prompt      => $app->translate("Users Selected"),
                search_label      => $app->translate("Search Users"),
                panel_description => $app->translate("Name"),
            },
            'role' => {
                panel_title       => $app->translate("Select Roles"),
                panel_label       => $app->translate("Role Name"),
                items_prompt      => $app->translate("Roles Selected"),
                search_label      => $app->translate(""),
                panel_description => $app->translate("Description"),
            },
        };

        $params->{blog_id}      = $blog_id;
        $params->{dialog_title} = $app->translate("Grant Permissions");
        $params->{panel_loop}   = [];
        $params->{panel_multi}  = 1;

        for ( my $i = 0 ; $i <= $#panels ; $i++ ) {
            my $source       = $panels[$i];
            my $panel_params = {
                panel_type => $source,
                %{ $panel_info->{$source} },
                list_noncron     => 1,
                panel_last       => $i == $#panels,
                panel_first      => $i == 0,
                panel_number     => $i + 1,
                panel_total      => $#panels + 1,
                panel_has_steps  => ( $#panels == '0' ? 0 : 1 ),
                panel_searchable => ( $source eq 'role' ? 0 : 1 ),
            };

            # Only show active user/groups.
            my $terms = {};
            if ( $source eq 'author' ) {
                $terms->{status} = MT::Author::ACTIVE();
                $terms->{type}   = MT::Author::AUTHOR();
            }

            $app->listing(
                {
                    no_html => 1,
                    code    => $hasher,
                    type    => $source,
                    params  => $panel_params,
                    terms   => $terms,
                    args    => { sort => 'name' },
                }
            );
            if ( $source && ( $source eq 'author' ) ) {
                if ( !$app->param('offset') ) {
                    my $data = $panel_params->{object_loop} ||= [];
                    unshift @$data, $pseudo_user_row;
                }
            }
            if (
                !$panel_params->{object_loop}
                || ( $panel_params->{object_loop}
                    && @{ $panel_params->{object_loop} } < 1 )
              )
            {
                $params->{"missing_$source"} = 1;
                $params->{"missing_data"}    = 1;
            }
            push @{ $params->{panel_loop} }, $panel_params;
        }

        # save the arguments from whence we came...
        $params->{return_args} = $app->return_args;
        $app->load_tmpl( 'dialog/create_association.tmpl', $params );
    }
}

sub revoke_role {
    my $app = shift;
    $app->validate_magic or return;

    my $user = $app->user;
    my $perms = $app->permissions;
    return $app->errtrans("Permission denied.")
        unless $perms->can_administer_blog;

    my $blog_id = $app->param('blog_id');
    my $role_id = $app->param('role_id');
    my $user_id = $app->param('author_id');
    return $app->errtrans("Invalid request.")
        unless $blog_id && $role_id && $user_id;

    require MT::Association;
    require MT::Role;
    require MT::Blog;

    my $author = MT::Author->load( $user_id );
    my $role = MT::Role->load( $role_id );
    my $blog = MT::Blog->load( $blog_id );
    return $app->errtrans("Invalid request.")
        unless $blog && $role && $author;

    MT::Association->unlink( $blog => $role => $author );

    $app->add_return_arg( saved => 1 );
    $app->call_return;
}

sub remove_user_assoc {
    my $app = shift;
    $app->validate_magic or return;

    my $user = $app->user;
    my $perms = $app->permissions;
    return $app->errtrans("Permission denied.")
        unless $perms->can_administer_blog;

    my $blog_id = $app->param('blog_id');
    my @ids = $app->param('id');
    return $app->errtrans("Invalid request.")
        unless $blog_id && @ids;

    require MT::Association;
    require MT::Permission;
    foreach my $id (@ids) {
        next unless $id;
        MT::Association->remove({ blog_id => $blog_id, author_id => $id });
        # these too, just in case there are no real associations
        # (ie, commenters)
        MT::Permission->remove({ blog_id => $blog_id, author_id => $id });
    }

    $app->add_return_arg( saved => 1 );
    $app->call_return;
}

sub grant_role {
    my $app = shift;

    my $user = $app->user;

    my $blogs   = $app->param('blog')   || '';
    my $authors = $app->param('author') || '';
    my $roles   = $app->param('role')   || '';
    my $author_id = $app->param('author_id');
    my $blog_id   = $app->param('blog_id');
    my $role_id   = $app->param('role_id');

    my @blogs   = split /,/, $blogs;
    my @authors = split /,/, $authors;
    my @roles   = split /,/, $roles;

    require MT::Blog;
    require MT::Role;

    foreach (@blogs) {
        my $id = $_;
        $id =~ s/\D//g;
        $_ = MT::Blog->load($id);
    }
    foreach (@roles) {
        my $id = $_;
        $id =~ s/\D//g;
        $_ = MT::Role->load($id);
    }
    my $add_pseudo_new_user = 0;
    foreach (@authors) {
        my $id = $_;
        if ( 'author-PSEUDO' eq $id ) {
            $add_pseudo_new_user = 1;
            next;
        }
        $id =~ s/\D//g;
        $_ = MT::Author->load($id);
    }
    $app->error(undef);

    if ($author_id) {
        if ( $author_id eq 'PSEUDO' ) {
            $add_pseudo_new_user = 1;
        }
        else {
            push @authors, MT::Author->load($author_id);
        }
    }
    push @blogs,   MT::Blog->load($blog_id)     if $blog_id;
    push @roles,   MT::Role->load($role_id)     if $role_id;

    if ( !$user->is_superuser ) {
        if (   ( scalar @blogs != 1 )
            || ( !$user->permissions( $blogs[0] )->can_administer_blog ) )
        {
            return $app->errtrans("Permission denied.");
        }
    }

    require MT::Association;

    my @default_assignments;

    # TBD: handle case for associating system roles to users/groups
    foreach my $blog (@blogs) {
        next unless ref $blog;
        foreach my $role (@roles) {
            next unless ref $role;
            if ($add_pseudo_new_user) {
                push @default_assignments, $role->id . ',' . $blog->id;
            }
            foreach my $ug ( @authors ) {
                next unless ref $ug;
                MT::Association->link( $ug => $role => $blog );
            }
        }
    }

    if ( $add_pseudo_new_user && @default_assignments ) {
        my $da = $app->config('DefaultAssignments');
        $da .= ',' if $da;
        $app->config( 'DefaultAssignments',
            $da . join( ',', @default_assignments ), 1 );
        $app->config->save_config;
    }

    $app->add_return_arg( saved => 1 );
    $app->call_return;
}

sub start_backup {
    my $app     = shift;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    my $perms   = $app->permissions;

    unless ( $user->is_superuser ) {
        return $app->errtrans("Permission denied.")
          unless defined($blog_id) && $perms->can_administer_blog;
    }

    my %param = ();
    if ( defined($blog_id) ) {
        $param{blog_id} = $blog_id;
        $app->add_breadcrumb( $app->translate('Backup') );
    }
    else {
        $app->add_breadcrumb( $app->translate('Backup & Restore') );
    }
    $param{system_overview_nav} = 1 unless $blog_id;
    $param{nav_backup} = 1;
    require MT::Util::Archive;
    my @formats = MT::Util::Archive->available_formats();
    $param{archive_formats} = \@formats;

    my $limit = $app->config('CGIMaxUpload') || 2048;
    $param{over_300}  = 1 if $limit >= 300 * 1024;
    $param{over_500}  = 1 if $limit >= 500 * 1024;
    $param{over_1024} = 1 if $limit >= 1024 * 1024;
    $param{over_2048} = 1 if $limit >= 2048 * 1024;

    my $tmp = $app->config('TempDir');
    unless ( ( -d $tmp ) && ( -w $tmp ) ) {
        $param{error} =
          $app->translate(
'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.'
          );
    }
    $app->load_tmpl( 'backup.tmpl', \%param );
}

sub start_restore {
    my $app     = shift;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    my $perms   = $app->permissions;

    unless ( $user->is_superuser ) {
        return $app->errtrans("Permission denied.")
          unless defined($blog_id) && $perms->can_administer_blog;
    }

    my %param = ();
    if ( defined($blog_id) ) {
        $param{blog_id} = $blog_id;
        $app->add_breadcrumb( $app->translate('Backup') );
    }
    else {
        $app->add_breadcrumb( $app->translate('Backup & Restore') );
    }
    $param{system_overview_nav} = 1 unless $blog_id;
    $param{nav_backup} = 1;

    eval "require XML::SAX";
    $param{missing_sax} = 1 if $@;

    my $tmp = $app->config('TempDir');
    unless ( ( -d $tmp ) && ( -w $tmp ) ) {
        $param{error} =
          $app->translate(
'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.'
          );
    }
    $app->load_tmpl( 'restore.tmpl', \%param );
}

sub _backup_finisher {
    my $app = shift;
    my ( $fnames, $param ) = @_;
    unless ( ref $fnames ) {
        $fnames = [$fnames];
    }
    $param->{filename}       = $fnames->[0];
    $param->{backup_success} = 1;
    require MT::Session;
    MT::Session->remove( { kind => 'BU' } );
    foreach my $fname (@$fnames) {
        my $sess = MT::Session->new;
        $sess->id( $app->make_magic_token() );
        $sess->kind('BU');    # BU == Backup
        $sess->name($fname);
        $sess->start(time);
        $sess->save;
    }
    my $message;
    if ( my $blog_id = $param->{blog_id} || $param->{blog_ids} ) {
        $message = $app->translate(
            "Blog(s) (ID:[_1]) was/were successfully backed up by user '[_2]'",
            $blog_id, $app->user->name
        );
    }
    else {
        $message =
          $app->translate(
            "Movable Type system was successfully backed up by user '[_1]'",
            $app->user->name );
    }
    $app->log(
        {
            message  => $message,
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'restore'
        }
    );
    $app->print( $app->build_page( 'include/backup_end.tmpl', $param ) );
}

sub backup {
    my $app     = shift;
    my $user    = $app->user;
    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');
    my $perms   = $app->permissions;
    unless ( $user->is_superuser ) {
        return $app->errtrans("Permission denied.")
          unless defined($blog_id) && $perms->can_administer_blog;
    }
    $app->validate_magic() or return;

    my $blog_ids = $q->param('backup_what');

    my $size = $q->param('size_limit') || 0;
    return $app->errtrans( '[_1] is not a number.',
        MT::Util::encode_html($size) )
      if $size !~ /^\d+$/;

    my @blog_ids = split ',', $blog_ids;

    my $archive = $q->param('backup_archive_format');
    my $enc     = $app->charset || 'utf-8';
    my @ts      = gmtime(time);
    my $ts = sprintf "%04d-%02d-%02d-%02d-%02d-%02d", $ts[5] + 1900, $ts[4] + 1,
      @ts[ 3, 2, 1, 0 ];
    my $file = "Movable_Type-$ts" . '-Backup';

    my $param = { return_args => '__mode=start_backup' };
    $app->{no_print_body} = 1;
    $app->add_breadcrumb(
        $app->translate('Backup & Restore'),
        $app->uri( mode => 'start_backup' )
    );
    $app->add_breadcrumb( $app->translate('Backup') );
    $param->{system_overview_nav} = 1 if defined($blog_ids) && $blog_ids;
    $param->{blog_id} = $blog_id if $blog_id;
    $param->{blog_ids} = $blog_ids if $blog_ids;
    $param->{nav_backup} = 1;

    local $| = 1;
    $app->send_http_header('text/html');
    $app->print( $app->build_page( 'include/backup_start.tmpl', $param ) );
    require File::Temp;
    require File::Spec;
    use File::Copy;
    my $temp_dir = $app->config('TempDir');

    require MT::BackupRestore;
    my $count_term =
      $blog_id
      ? { class => '*', blog_id => $blog_id }
      : { class => '*' };
    my $num_assets = $app->model('asset')->count($count_term);
    my $printer;
    my $splitter;
    my $finisher;
    my $progress = sub { $app->_progress(@_); };
    my $fh;
    my $fname;
    my $arc_buf;

    if ( !( $size || $num_assets ) ) {
        $splitter = sub { };

        if ( '0' eq $archive ) {
            ( $fh, my $filepath ) =
              File::Temp::tempfile( 'xml.XXXXXXXX', DIR => $temp_dir );
            ( my $vol, my $dir, $fname ) = File::Spec->splitpath($filepath);
            $printer =
              sub { my ($data) = @_; print $fh $data; return length($data); };
            $finisher = sub {
                my ($asset_files) = @_;
                close $fh;
                $app->_backup_finisher( $fname, $param );
            };
        }
        else {  # archive/compress files
            $printer =
              sub { my ($data) = @_; $arc_buf .= $data; return length($data); };
            $finisher = sub {
                require MT::Util::Archive;
                my ($asset_files) = @_;
                ( my $fh, my $filepath ) =
                  File::Temp::tempfile( $archive . '.XXXXXXXX', DIR => $temp_dir );
                ( my $vol, my $dir, $fname ) = File::Spec->splitpath($filepath);
                close $fh;
                unlink $filepath;
                my $arc = MT::Util::Archive->new($archive, $filepath);
                $arc->add_string( $arc_buf, "$file.xml" );
                $arc->add_string(
                        "<manifest xmlns='"
                      . MT::BackupRestore::NS_MOVABLETYPE()
                      . "'><file type='backup' name='$file.xml' /></manifest>",
                      "$file.manifest");
                $arc->close;
                $app->_backup_finisher( $fname, $param );
            };
        }
    }
    else {
        my @files;
        my $filename = File::Spec->catfile( $temp_dir, $file . "-1.xml" );
        $fh = gensym();
        open $fh, ">$filename";
        my $url =
            $app->uri
          . "?__mode=backup_download&name=$file-1.xml&magic_token="
          . $app->current_magic;
        $url .= "&blog_id=$blog_id" if defined($blog_id);
        push @files,
          {
            url      => $url,
            filename => $file . "-1.xml"
          };
        $printer =
          sub { my ($data) = @_; print $fh $data; return length($data); };
        $splitter = sub {
            my ($findex) = @_;
            print $fh '</movabletype>';
            close $fh;
            my $filename =
              File::Spec->catfile( $temp_dir, $file . "-$findex.xml" );
            $fh = gensym();
            open $fh, ">$filename";
            my $url =
                $app->uri
              . "?__mode=backup_download&name=$file-$findex.xml&magic_token="
              . $app->current_magic;
            $url .= "&blog_id=$blog_id" if defined($blog_id);
            push @files,
              {
                url      => $url,
                filename => $file . "-$findex.xml"
              };
            my $header .=
              "<movabletype xmlns='"
              . MT::BackupRestore::NS_MOVABLETYPE() . "'>\n";
            $header = "<?xml version='1.0' encoding='$enc'?>\n$header"
              if $enc !~ m/utf-?8/i;
            print $fh $header;
        };
        $finisher = sub {
            my ($asset_files) = @_;
            close $fh;
            my $filename = File::Spec->catfile( $temp_dir, "$file.manifest" );
            $fh = gensym();
            open $fh, ">$filename";
            print $fh "<manifest xmlns='"
              . MT::BackupRestore::NS_MOVABLETYPE() . "'>\n";
            for my $file (@files) {
                my $name = $file->{filename};
                print $fh "<file type='backup' name='$name' />\n";
            }
            for my $id ( keys %$asset_files ) {
                my $name = $id . '-' . $asset_files->{$id}->[2];
                my $tmp = File::Spec->catfile( $temp_dir, $name );
                unless ( copy( $asset_files->{$id}->[1], $tmp ) ) {
                    $app->log(
                        {
                            message => $app->translate(
                                'Copying file [_1] to [_2] failed: [_3]',
                                $asset_files->{$id}->[1],
                                $tmp, $!
                            ),
                            level    => MT::Log::INFO(),
                            class    => 'system',
                            category => 'backup'
                        }
                    );
                    next;
                }
                print $fh "<file type='asset' name='"
                  . $asset_files->{$id}->[2]
                  . "' asset_id='"
                  . $id
                  . "' />\n";
                my $url =
                    $app->uri
                  . "?__mode=backup_download&assetname=$name&magic_token="
                  . $app->current_magic;
                $url .= "&blog_id=$blog_id" if defined($blog_id);
                push @files,
                  {
                    url      => $url,
                    filename => $name,
                  };
            }
            print $fh "</manifest>\n";
            close $fh;
            my $url =
                $app->uri
              . "?__mode=backup_download&name=$file.manifest&magic_token="
              . $app->current_magic;
            $url .= "&blog_id=$blog_id" if defined($blog_id);
            push @files,
              {
                url      => $url,
                filename => "$file.manifest"
              };
            if ( '0' eq $archive ) {
                $param->{files_loop} = \@files;
                $param->{tempdir}    = $temp_dir;
                my @fnames = map { $_->{filename} } @files;
                $app->_backup_finisher( \@fnames, $param );
            }
            else {
                my ( $fh_arc, $filepath ) =
                  File::Temp::tempfile( $archive . '.XXXXXXXX', DIR => $temp_dir );
                ( my $vol, my $dir, $fname ) = File::Spec->splitpath($filepath);
                require MT::Util::Archive;
                close $fh_arc;
                unlink $filepath;
                my $arc = MT::Util::Archive->new($archive, $filepath);
                for my $f (@files) {
                    $arc->add_file( $temp_dir, $f->{filename} );
                }
                $arc->close;
                # for safery, don't unlink before closing $arc here.
                for my $f (@files) {
                    unlink File::Spec->catfile( $temp_dir, $f->{filename} );
                }
                $app->_backup_finisher( $fname, $param );
            }
        };
    }

    my @tsnow    = gmtime(time);
    my $metadata = {
        backup_by => $app->user->name . '(ID: ' . $app->user->id . ')',
        backup_on => sprintf(
            "%04d-%02d-%02dT%02d:%02d:%02d",
            $tsnow[5] + 1900,
            $tsnow[4] + 1,
            @tsnow[ 3, 2, 1, 0 ]
        ),
        backup_what    => join( ',', @blog_ids ),
        schema_version => $app->config('SchemaVersion'),
    };
    MT::BackupRestore->backup( \@blog_ids, $printer, $splitter, $finisher,
        $progress, $size * 1024,
        $enc, $metadata );
}

sub _progress {
    my $app = shift;
    my $ids = $app->request('progress_ids') || {};

    my ( $str, $id ) = @_;
    if ( $id && $ids->{$id} ) {
        require MT::Util;
        my $str_js = MT::Util::encode_js($str);
        $app->print(
qq{<script type="text/javascript">progress('$str_js', '$id');</script>}
        );
    }
    elsif ($id) {
        $ids->{$id} = 1;
        $app->print(qq{\n<span id="$id">$str</span>});
    }
    else {
        $app->print("<span>$str</span>");
    }

    $app->request( 'progress_ids', $ids );
}

sub backup_download {
    my $app     = shift;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    unless ( $user->is_superuser ) {
        my $perms = $app->permissions;
        return $app->errtrans("Permission denied.")
          unless defined($blog_id) && $perms->can_administer_blog;
    }
    $app->validate_magic() or return;
    my $filename  = $app->param('filename');
    my $assetname = $app->param('assetname');
    my $temp_dir  = $app->config('TempDir');
    my $newfilename;
    if ( defined($assetname) ) {
        my $sess = MT::Session->load( { kind => 'BU', name => $assetname } );
        if ( !defined($sess) || !$sess ) {
            return $app->errtrans("Specified file was not found.");
        }
        $newfilename = $filename = $assetname;
        $sess->remove;
    }
    elsif ( defined($filename) ) {
        my $sess = MT::Session->load( { kind => 'BU', name => $filename } );
        if ( !defined($sess) || !$sess ) {
            return $app->errtrans("Specified file was not found.");
        }
        my @ts = gmtime( $sess->start );
        my $ts = sprintf "%04d-%02d-%02d-%02d-%02d-%02d", $ts[5] + 1900,
          $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
        $newfilename = "Movable_Type-$ts" . '-Backup';
        $sess->remove;
    }
    else {
        $newfilename = $app->param('name');
        return
          if $newfilename !~
/Movable_Type-\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}-Backup(?:-\d+)?\.\w+/;
        $filename = $newfilename;
    }

    require File::Spec;
    my $fname = File::Spec->catfile( $temp_dir, $filename );

    my $contenttype;
    if ( !defined($assetname) && ( $filename =~ m/^xml\..+$/i ) ) {
        my $enc = $app->charset || 'utf-8';
        $contenttype = "text/xml; charset=$enc";
        $newfilename .= '.xml';
    }
    elsif ( $filename =~ m/^tgz\..+$/i ) {
        $contenttype = 'application/x-tar-gz';
        $newfilename .= '.tar.gz';
    }
    elsif ( $filename =~ m/^zip\..+$/i ) {
        $contenttype = 'application/zip';
        $newfilename .= '.zip';
    }
    else {
        $contenttype = 'application/octet-stream';
    }

    if ( open( my $fh, "<", $fname ) ) {
        binmode $fh;
        $app->{no_print_body} = 1;
        $app->set_header(
            "Content-Disposition" => "attachment; filename=$newfilename" );
        $app->send_http_header($contenttype);
        my $data;
        while ( read $fh, my ($chunk), 8192 ) {
            $data .= $chunk;
        }
        close $fh;
        $app->print($data);
        $app->log(
            {
                message => $app->translate(
                    '[_1] successfully downloaded backup file ([_2])',
                    $app->user->name, $fname
                ),
                level    => MT::Log::INFO(),
                class    => 'system',
                category => 'restore'
            }
        );
        unlink $fname;
    }
    else {
        $app->errtrans('Specified file was not found.');
    }
}

sub restore {
    my $app  = shift;
    my $user = $app->user;
    return $app->errtrans("Permission denied.") if !$user->is_superuser;
    $app->validate_magic() or return;

    my $q = $app->param;

    my ($fh) = $app->upload_info('file');
    my $uploaded = $q->param('file');
    my ( $volume, $directories, $uploaded_filename ) =
      File::Spec->splitpath($uploaded)
      if defined($uploaded);
    if ( defined($uploaded_filename)
        && ( $uploaded_filename =~ /^.+\.manifest$/i ) )
    {
        return $app->restore_upload_manifest($fh);
    }

    my $param = { return_args => '__mode=dashboard' };

    $app->add_breadcrumb(
        $app->translate('Backup & Restore'),
        $app->uri( mode => 'start_restore' )
    );
    $app->add_breadcrumb( $app->translate('Restore') );
    $param->{system_overview_nav} = 1;
    $param->{nav_backup}          = 1;

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    $app->print( $app->build_page( 'restore_start.tmpl', $param ) );

    require File::Path;

    my $error = '';
    my $result;
    if (!$fh) {
        $param->{restore_upload} = 0;
        my $dir = $app->config('ImportPath');
        my ( $blog_ids, $asset_ids ) = $app->restore_directory( $dir, \$error );
        if ( defined $blog_ids ) {
            $param->{open_dialog} = 1;
            $param->{blog_ids}    = join( ',', @$blog_ids );
            $param->{asset_ids}   = join( ',', @$asset_ids )
              if defined $asset_ids;
            $param->{tmp_dir} = $dir;
        }
    }
    else {
        $param->{restore_upload} = 1;
        if ( $uploaded_filename =~ /^.+\.xml$/i ) {
            my $blog_ids = $app->restore_file( $fh, \$error );
            if ( defined $blog_ids ) {
                $param->{open_dialog} = 1;
                $param->{blog_ids} = join( ',', @$blog_ids );
            }
        }
        else {
            require MT::Util::Archive;
            my $arc;
            my $error;
            if ( $uploaded_filename =~ /^.+\.tar(\.gz)?$/i ) {
                $arc = MT::Util::Archive->new('tgz', $fh);
            }
            elsif ( $uploaded_filename =~ /^.+\.zip$/i ) {
                $arc = MT::Util::Archive->new('zip', $fh);
            }
            else {
                $error =
                  $app->translate(
                    'Please use xml, tar.gz, zip, or manifest as a file extension.'
                  );
            }
            unless ($arc) {
                $result = 0;
                $param->{restore_success} = 0;
                if ($error) {
                    $param->{error}           = $error;
                }
                else {
                    $error = MT->translate('Unknown file format');
                    $app->log(
                        {
                            message  => $error . ":$uploaded_filename",
                            level    => MT::Log::WARNING(),
                            class    => 'system',
                            category => 'restore',
                            metadata => MT::Util::Archive->errstr,
                        }
                    );
                }
                $app->print( $error );
                $app->print(
                    $app->build_page( "restore_end.tmpl", $param ) );
                close $fh if $fh;
                return 1;
            }
            my $temp_dir = $app->config('TempDir');
            require File::Temp;
            my $tmp = File::Temp::tempdir( $uploaded_filename . 'XXXX',
                DIR => $temp_dir );
            $arc->extract($tmp);
            $arc->close;
            my ( $blog_ids, $asset_ids ) =
              $app->restore_directory( $tmp, \$error );
            if (defined $blog_ids) {
                $param->{open_dialog} = 1;
                $param->{blog_ids} = join( ',', @$blog_ids )
                  if defined $blog_ids;
                $param->{asset_ids} = join( ',', @$asset_ids )
                  if defined $asset_ids;
                $param->{tmp_dir} = $tmp;
            }
        }
    }
    $param->{restore_success} = !$error;
    $param->{error} = $error if $error;
    if ( ( exists $param->{open_dialog} ) && ( $param->{open_dialog} ) ) {
        $param->{dialog_mode} = 'dialog_adjust_sitepath';
        $param->{dialog_params} =
            'magic_token='
          . $app->current_magic
          . '&amp;blog_ids='
          . $param->{blog_ids}
          . '&amp;asset_ids='
          . $param->{asset_ids}
          . '&amp;tmp_dir='
          . encode_url( $param->{tmp_dir} );
        if ( ( $param->{restore_upload} ) && ( $param->{restore_upload} ) ) {
            $param->{dialog_params} .= '&amp;restore_upload=1';
        }
        if ( ( $param->{error} ) && ( $param->{error} ) ) {
            $param->{dialog_params} .=
              '&amp;error=' . encode_url( $param->{error} );
        }
    }

    $app->print( $app->build_page( "restore_end.tmpl", $param ) );
    close $fh if $fh;
    1;
}

sub _log_dirty_restore {
    my $app = shift;
    my ($deferred) = @_;
    my %deferred_by_class;
    for my $key ( keys %$deferred ) {
        my ( $class, $id ) = split( '#', $key );
        if ( exists $deferred_by_class{$class} ) {
            push @{ $deferred_by_class{$class} }, $id;
        }
        else {
            $deferred_by_class{$class} = [$id];

        }
    }
    while ( my ( $class_name, $ids ) = each %deferred_by_class ) {
        my $message = $app->translate(
'Some [_1] were not restored because their parent objects were not restored.',
            $class_name
        );
        $app->log(
            {
                message  => $message,
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
                metadata => join( ', ', @$ids ),
            }
        );
    }
    1;
}

sub restore_file {
    my $app = shift;
    my ( $fh, $errormsg ) = @_;
    my $q = $app->param;
    my $schema_version =
      $q->param('ignore_schema_conflict')
      ? 'ignore'
      : $app->config('SchemaVersion');
    my $overwrite_template = $q->param('overwrite_global_templates') ? 1 : 0;

    require MT::BackupRestore;
    my ( $deferred, $blogs ) =
      MT::BackupRestore->restore_file( $fh, $errormsg, $schema_version, $overwrite_template,
        sub { $app->_progress(@_); } );

    if ( !defined($deferred) || scalar( keys %$deferred ) ) {
        $app->_log_dirty_restore($deferred);
        my $log_url = $app->uri( mode => 'view_log', args => {} );
        $$errormsg .= '; ' if $$errormsg;
        $$errormsg .= $app->translate(
'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.',
            $log_url
        );
        return $blogs;
    }
    if ($$errormsg) {
        $app->log(
            {
                message  => $$errormsg,
                level    => MT::Log::ERROR(),
                class    => 'system',
                category => 'restore',
            }
        );
        return $blogs;
    }

    $app->log(
        {
            message => $app->translate(
"Successfully restored objects to Movable Type system by user '[_1]'",
                $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'restore'
        }
    );

    $blogs;
}

sub restore_directory {
    my $app = shift;
    my ( $dir, $error ) = @_;

    if ( !-d $dir ) {
        $$error = $app->translate( '[_1] is not a directory.', $dir );
        return ( undef, undef );
    }

    my $q = $app->param;
    my $schema_version =
      $q->param('ignore_schema_conflict')
      ? 'ignore'
      : $app->config('SchemaVersion');

    my $overwrite_template = $q->param('overwrite_global_templates') ? 1 : 0;

    my @errors;
    my %error_assets;
    require MT::BackupRestore;
    my ( $deferred, $blogs, $assets ) =
      MT::BackupRestore->restore_directory( $dir, \@errors, \%error_assets,
        $schema_version, $overwrite_template, sub { $app->_progress(@_); } );

    if ( scalar @errors ) {
        $$error = $app->translate('Error occured during restore process.');
        $app->log(
            {
                message  => $$error,
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
                metadata => join( '; ', @errors ),
            }
        );
    }
    return ( $blogs, $assets ) unless ( defined($deferred) && %$deferred );

    if ( scalar( keys %error_assets ) ) {
        my $data;
        while ( my ( $key, $value ) = each %error_assets ) {
            $data .=
              $app->translate( 'MT::Asset#[_1]: ', $key ) . $value . "\n";
        }
        my $message = $app->translate('Some of files could not be restored.');
        $app->log(
            {
                message  => $message,
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
                metadata => $data,
            }
        );
        $$error .= $message;
    }

    if ( scalar( keys %$deferred ) ) {
        $app->_log_dirty_restore($deferred);
        my $log_url = $app->uri( mode => 'view_log', args => {} );
        $$error = $app->translate(
'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.',
            $log_url
        );
        return ( $blogs, $assets );
    }

    return ( $blogs, $assets ) if $$error;

    $app->log(
        {
            message => $app->translate(
"Successfully restored objects to Movable Type system by user '[_1]'",
                $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'restore'
        }
    );
    return ( $blogs, $assets );
}

sub restore_upload_manifest {
    my $app  = shift;
    my ($fh) = @_;
    my $user = $app->user;
    return $app->errtrans("Permission denied.") if !$user->is_superuser;
    $app->validate_magic() or return;

    my $q = $app->param;

    require MT::BackupRestore;
    my $backups = MT::BackupRestore->process_manifest($fh);
    return $app->errtrans(
        "Uploaded file was not a valid Movable Type backup manifest file.")
      if !defined($backups);

    my $files     = $backups->{files};
    my $assets    = $backups->{assets};
    my $file_next = shift @$files if defined($files) && scalar(@$files);
    my $assets_json;
    my $param = {};

    if ( !defined($file_next) ) {
        if ( scalar(@$assets) > 0 ) {
            my $asset = shift @$assets;
            $file_next = $asset->{name};
            $param->{is_asset} = 1;
        }
    }
    require JSON;
    require MT::Util;
    $assets_json = MT::Util::encode_url( JSON::objToJson($assets) )
      if scalar(@$assets) > 0;
    $param->{files}       = join( ',', @$files );
    $param->{assets}      = $assets_json;
    $param->{filename}    = $file_next;
    $param->{last}        = scalar(@$files) ? 0 : ( scalar(@$assets) ? 0 : 1 );
    $param->{open_dialog} = 1;
    $param->{schema_version} =
      $q->param('ignore_schema_conflict')
      ? 'ignore'
      : $app->config('SchemaVersion');
    $param->{overwrite_templates} = $q->param('overwrite_global_templates') ? 1 : 0;

    $param->{dialog_mode} = 'dialog_restore_upload';
    $param->{dialog_params} =
        'start=1'
      . '&amp;magic_token='
      . $app->current_magic
      . '&amp;files='
      . $param->{files}
      . '&amp;assets='
      . $param->{assets}
      . '&amp;current_file='
      . $param->{filename}
      . '&amp;last='
      . $param->{'last'}
      . '&amp;schema_version='
      . $param->{schema_version}
      . '&amp;overwrite_templates='
      . $param->{overwrite_templates}
      . '&amp;redirect=1';
    $app->load_tmpl( 'restore.tmpl', $param );

    #close $fh if $fh;
}

sub dialog_restore_upload {
    my $app  = shift;
    my $user = $app->user;
    return $app->errtrans("Permission denied.") if !$user->is_superuser;
    $app->validate_magic() or return;

    my $q = $app->param;

    my $current        = $q->param('current_file');
    my $last           = $q->param('last');
    my $files          = $q->param('files');
    my $assets_json    = $q->param('assets');
    my $is_asset       = $q->param('is_asset') || 0;
    my $schema_version = $q->param('schema_version')
      || $app->config('SchemaVersion');
    my $overwrite_template = $q->param('overwrite_templates') ? 1 : 0;

    my $objects  = {};
    my $deferred = {};
    require JSON;
    my $objects_json = $q->param('objects_json') if $q->param('objects_json');
    $deferred = JSON::jsonToObj( $q->param('deferred_json') )
      if $q->param('deferred_json');

    my ($fh) = $app->upload_info('file');

    my $param = {};
    $param->{start}          = $q->param('start') || 0;
    $param->{is_asset}       = $is_asset;
    $param->{name}           = $current;
    $param->{files}          = $files;
    $param->{assets}         = $assets_json;
    $param->{last}           = $last;
    $param->{redirect}       = 1;
    $param->{is_dirty}       = $q->param('is_dirty');
    $param->{objects_json}   = $objects_json if defined($objects_json);
    $param->{deferred_json}  = JSON::objToJson($deferred) if defined($deferred);
    $param->{blogs_meta}     = $q->param('blogs_meta');
    $param->{schema_version} = $schema_version;
    $param->{overwrite_templates} = $overwrite_template;

    my $uploaded = $q->param('file');
    if ( defined($uploaded) ) {
        $uploaded =~ s!\\!/!g;    ## Change backslashes to forward slashes
        my ( $volume, $directories, $uploaded_filename ) =
          File::Spec->splitpath($uploaded);
        if ( $current ne $uploaded_filename ) {
            close $fh if $uploaded_filename;
            $param->{error} =
              $app->translate( 'Please upload [_1] in this page.', $current );
            return $app->load_tmpl( 'dialog/restore_upload.tmpl', $param );
        }
    }

    if (!$fh) {
        $param->{error} = $app->translate('File was not uploaded.')
          if !( $q->param('redirect') );
        return $app->load_tmpl( 'dialog/restore_upload.tmpl', $param );
    }

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    $app->print( $app->build_page( 'dialog/restore_start.tmpl', $param ) );

    if ( defined $objects_json ) {
        my $objects_tmp = JSON::jsonToObj($objects_json);
        my %class2ids;

        # { MT::CLASS#OLD_ID => NEW_ID }
        for my $key ( keys %$objects_tmp ) {
            my ( $class, $old_id ) = split '#', $key;
            if ( exists $class2ids{$class} ) {
                my $newids = $class2ids{$class}->{newids};
                push @$newids, $objects_tmp->{$key};
                my $keymaps = $class2ids{$class}->{keymaps};
                push @$keymaps,
                  { newid => $objects_tmp->{$key}, oldid => $old_id };
            }
            else {
                $class2ids{$class} = {
                    newids => [ $objects_tmp->{$key} ],
                    keymaps =>
                      [ { newid => $objects_tmp->{$key}, oldid => $old_id } ]
                };
            }
        }
        for my $class ( keys %class2ids ) {
            eval "require $class;";
            next if $@;
            my $newids  = $class2ids{$class}->{newids};
            my $keymaps = $class2ids{$class}->{keymaps};
            my @objs    = $class->load( { id => $newids } );
            for my $obj (@objs) {
                my @old_ids = grep { $_->{newid} eq $obj->id } @$keymaps;
                my $old_id = $old_ids[0]->{oldid};
                $objects->{"$class#$old_id"} = $obj;
            }
        }
    }

    my $assets = JSON::jsonToObj( MT::Util::decode_html($assets_json) )
      if ( defined($assets_json) && $assets_json );
    $assets = [] if !defined($assets);
    my $asset;
    my @errors;
    my $error_assets = {};
    require MT::BackupRestore;
    my $blog_ids;
    my $asset_ids;

    if ($is_asset) {
        $asset = shift @$assets;
        $asset->{fh} = $fh;
        my $blogs_meta = JSON::jsonToObj( $q->param('blogs_meta') || '{}' );
        MT::BackupRestore->_restore_asset_multi( $asset, $objects,
            $error_assets, sub { $app->print(@_); }, $blogs_meta );
        if ( defined( $error_assets->{ $asset->{asset_id} } ) ) {
            $app->log(
                {
                    message => $app->translate('Restoring a file failed: ')
                      . $error_assets->{ $asset->{asset_id} },
                    level    => MT::Log::WARNING(),
                    class    => 'system',
                    category => 'restore',
                }
            );
        }
    }
    else {
        ( $blog_ids, $asset_ids ) = eval {
            MT::BackupRestore->restore_process_single_file( $fh, $objects,
                $deferred, \@errors, $schema_version, $overwrite_template,
                sub { $app->_progress(@_) } );
        };
        if ($@) {
            $last = 1;
        }
    }

    my @files = split( ',', $files );
    my $file_next = shift @files if scalar(@files);
    if ( !defined($file_next) ) {
        if ( scalar(@$assets) ) {
            $asset             = $assets->[0];
            $file_next         = $asset->{asset_id} . '-' . $asset->{name};
            $param->{is_asset} = 1;
        }
    }
    $param->{files}  = join( ',', @files );
    $param->{assets} = MT::Util::encode_html( JSON::objToJson($assets) );
    $param->{name}   = $file_next;
    if ( 0 < scalar(@files) ) {
        $param->{last} = 0;
    }
    elsif ( 0 >= scalar(@$assets) - 1 ) {
        $param->{last} = 1;
    }
    else {
        $param->{last} = 0;
    }
    $param->{is_dirty} = scalar( keys %$deferred );
    if ($last) {
        $param->{restore_end} = 1;
        if ( $param->{is_dirty} ) {
            $app->_log_dirty_restore($deferred);
            my $log_url = $app->uri( mode => 'view_log', args => {} );
            $param->{error} =
              $app->translate(
'Some objects were not restored because their parent objects were not restored.'
              );
            $param->{error_url} = $log_url;
        }
        elsif ( scalar( keys %$error_assets ) ) {
            $param->{error} =
              $app->translate('Some of the files were not restored correctly.');
            my $log_url = $app->uri( mode => 'view_log', args => {} );
            $param->{error_url} = $log_url;
        }
        elsif ( scalar @errors ) {
            $param->{error} = join '; ', @errors;
            my $log_url = $app->uri( mode => 'view_log', args => {} );
            $param->{error_url} = $log_url;
        }
        else {
            $app->log(
                {
                    message => $app->translate(
"Successfully restored objects to Movable Type system by user '[_1]'",
                        $app->user->name
                    ),
                    level    => MT::Log::INFO(),
                    class    => 'system',
                    category => 'restore'
                }
            );
            $param->{ok_url} = $app->uri( mode => 'start_restore', args => {} );
        }
    }
    else {
        my %objects_json;
        %objects_json = map { $_ => $objects->{$_}->id } keys %$objects;
        $param->{objects_json}  = JSON::objToJson( \%objects_json );
        $param->{deferred_json} = JSON::objToJson($deferred);

        $param->{error} = join( '; ', @errors );
        if ( defined($blog_ids) && scalar(@$blog_ids) ) {
            $param->{next_mode} = 'dialog_adjust_sitepath';
            $param->{blog_ids}  = join( ',', @$blog_ids );
            $param->{asset_ids} = join( ',', @$asset_ids )
              if defined($asset_ids);
        }
        else {
            $param->{next_mode} = 'dialog_restore_upload';
        }
    }
    MT->run_callbacks('restore', $objects, $deferred, \@errors, sub { $app->_progress(@_) });

    $app->print( $app->build_page( 'dialog/restore_end.tmpl', $param ) );
    close $fh if $fh;
}

sub restore_premature_cancel {
    my $app  = shift;
    my $user = $app->user;
    return $app->errtrans("Permission denied.") if !$user->is_superuser;
    $app->validate_magic() or return;

    require JSON;
    my $deferred = JSON::jsonToObj( $app->param('deferred_json') )
      if $app->param('deferred_json');
    my $param = { restore_success => 1 };
    if ( defined $deferred && ( scalar( keys %$deferred ) ) ) {
        $app->_log_dirty_restore($deferred);
        my $log_url = $app->uri( mode => 'view_log', args => {} );
        $param->{restore_success} = 0;
        my $message =
          $app->translate(
'Some objects were not restored because their parent objects were not restored.'
          );
        $param->{error} = $message . '  '
          . $app->translate(
"Detailed information is in the <a href='javascript:void(0)' onclick='closeDialog(\"[_1]\")'>activity log</a>.",
            $log_url
          );
    }
    else {
        $app->log(
            {
                message => $app->translate(
'[_1] has canceled the multiple files restore operation prematurely.',
                    $app->user->name
                ),
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
            }
        );
    }
    $app->redirect( $app->uri( mode => 'view_log', args => {} ) );
}

sub dialog_adjust_sitepath {
    my $app  = shift;
    my $user = $app->user;
    return $app->errtrans("Permission denied.") if !$user->is_superuser;
    $app->validate_magic() or return;

    my $q         = $app->param;
    my $tmp_dir   = $q->param('tmp_dir');
    my $error     = $q->param('error') || q();
    my $uploaded  = $q->param('restore_upload') || 0;
    my @blog_ids  = split ',', $q->param('blog_ids');
    my $asset_ids = $q->param('asset_ids');
    my @blogs     = $app->model('blog')->load( { id => \@blog_ids } );
    my @blogs_loop;

    foreach my $blog (@blogs) {
        push @blogs_loop,
          {
            name          => $blog->name,
            id            => $blog->id,
            old_site_path => $blog->site_path,
            old_site_url  => $blog->site_url,
            $blog->column('archive_path')
            ? ( old_archive_path => $blog->archive_path )
            : (),
            $blog->column('archive_url')
            ? ( old_archive_url => $blog->archive_url )
            : (),
          };
    }
    my $param = { blogs_loop => \@blogs_loop, tmp_dir => $tmp_dir };
    $param->{error}          = $error     if $error;
    $param->{restore_upload} = $uploaded  if $uploaded;
    $param->{asset_ids}      = $asset_ids if $asset_ids;
    for my $key (
        qw(files assets last redirect is_dirty is_asset objects_json deferred_json)
      )
    {
        $param->{$key} = $q->param($key) if $q->param($key);
    }
    $param->{name} = $q->param('current_file');
    $app->load_tmpl( 'dialog/adjust_sitepath.tmpl', $param );
}

sub adjust_sitepath {
    my $app  = shift;
    my $user = $app->user;
    return $app->errtrans("Permission denied.") if !$user->is_superuser;
    $app->validate_magic() or return;

    require MT::BackupRestore;

    my $q         = $app->param;
    my $tmp_dir   = $q->param('tmp_dir');
    my $error     = $q->param('error') || q();
    my %asset_ids = split ',', $q->param('asset_ids');

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    $app->print( $app->build_page( 'dialog/restore_start.tmpl', {} ) );

    my %error_assets;
    my %blogs_meta;
    my @p = $q->param;
    foreach my $p (@p) {
        next unless $p =~ /^site_path_(\d+)/;
        my $id            = $1;
        my $blog          = $app->model('blog')->load($id);
        my $old_site_path = scalar $q->param("old_site_path_$id");
        my $old_site_url  = scalar $q->param("old_site_url_$id");
        my $site_path     = scalar $q->param("site_path_$id") || q();
        my $site_url      = scalar $q->param("site_url_$id") || q();
        $blog->site_path($site_path);
        $blog->site_url($site_url);

        if ( $site_url || $site_path ) {
            $app->print(
                $app->translate(
                    "Changing Site Path for the blog '[_1]' (ID:[_2])...",
                    $blog->name, $blog->id
                )
            );
        }
        else {
            $app->print(
                $app->translate(
                    "Removing Site Path for the blog '[_1]' (ID:[_2])...",
                    $blog->name, $blog->id
                )
            );
        }
        my $old_archive_path = scalar $q->param("old_archive_path_$id");
        my $old_archive_url  = scalar $q->param("old_archive_url_$id");
        my $archive_path     = scalar $q->param("archive_path_$id") || q();
        my $archive_url      = scalar $q->param("archive_url_$id") || q();
        $blog->archive_path($archive_path);
        $blog->archive_url($archive_url);
        if (   ( $old_archive_url && $archive_url )
            || ( $old_archive_path && $archive_path ) )
        {
            $app->print(
                "\n"
                  . $app->translate(
                    "Changing Archive Path for the blog '[_1]' (ID:[_2])...",
                    $blog->name, $blog->id
                  )
            );
        }
        elsif ( $old_archive_url || $old_archive_path ) {
            $app->print(
                "\n"
                  . $app->translate(
                    "Removing Archive Path for the blog '[_1]' (ID:[_2])...",
                    $blog->name, $blog->id
                  )
            );
        }
        $blog->save or $app->print( $app->translate("failed") . "\n" ), next;
        $app->print( $app->translate("ok") . "\n" );

        $blogs_meta{$id} = {
            'old_archive_path' => $old_archive_path,
            'old_archive_url'  => $old_archive_url,
            'archive_path'     => $archive_path,
            'archive_url'      => $archive_url,
            'old_site_path'    => $old_site_path,
            'old_site_url'     => $old_site_url,
            'site_path'        => $site_path,
            'site_url'         => $site_url,
        };
        next unless %asset_ids;

        my $fmgr = ( $site_path || $archive_path ) ? $blog->file_mgr : undef;
        next unless defined $fmgr;

        my @assets =
          $app->model('asset')->load( { blog_id => $id, class => '*' } );
        foreach my $asset (@assets) {
            my $path = $asset->column('file_path');
            my $url  = $asset->column('url');
            if ($archive_path) {
                $path =~ s/^\Q$old_archive_path\E/$archive_path/i;
                $asset->file_path($path);
            }
            if ($archive_url) {
                $url =~ s/^\Q$old_archive_url\E/$archive_url/i;
                $asset->url($url);
            }
            if ($site_path) {
                $path =~ s/^\Q$old_site_path\E/$site_path/i;
                $asset->file_path($path);
            }
            if ($site_url) {
                $url =~ s/^\Q$old_site_url\E/$site_url/i;
                $asset->url($url);
            }
            $app->print(
                $app->translate(
                    "Changing file path for the asset '[_1]' (ID:[_2])...",
                    $asset->label, $asset->id
                )
            );
            $asset->save
              or $app->print( $app->translate("failed") . "\n" ), next;
            $app->print( $app->translate("ok") . "\n" );
            unless ( $q->param('redirect') ) {
                my $old_id   = $asset_ids{ $asset->id };
                my $filename = "$old_id-" . $asset->file_name;
                my $file     = File::Spec->catfile( $tmp_dir, $filename );
                MT::BackupRestore->restore_asset( $file, $asset, $old_id, $fmgr,
                    \%error_assets, sub { $app->print(@_); } );
            }
        }
    }
    if (%error_assets) {
        my $data;
        while ( my ( $key, $value ) = each %error_assets ) {
            $data .=
              $app->translate( 'MT::Asset#[_1]: ', $key ) . $value . "\n";
        }
        my $message = $app->translate(
            'Some of the actual files for assets could not be restored.');
        $app->log(
            {
                message  => $message,
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
                metadata => $data,
            }
        );
        $error .= $message;
    }

    if ($tmp_dir) {
        require File::Path;
        File::Path::rmtree($tmp_dir);
    }

    my $param = {};
    if ( scalar $q->param('redirect') ) {
        $param->{restore_end} = 0;  # redirect=1 means we are from multi-uploads
        require JSON;
        require MT::Util;
        $param->{blogs_meta} = JSON::objToJson( \%blogs_meta );
        $param->{next_mode}  = 'dialog_restore_upload';
    }
    else {
        $param->{restore_end} = 1;
    }
    if ($error) {
        $param->{error}     = $error;
        $param->{error_url} = $app->uri( mode => 'view_log', args => {} );
    }
    for my $key (
        qw(files last redirect is_dirty is_asset objects_json deferred_json))
    {
        $param->{$key} = scalar $q->param($key);
    }
    $param->{name}   = $q->param('current_file');
    $param->{assets} = MT::Util::encode_html( $q->param('assets') );
    $app->print( $app->build_page( 'dialog/restore_end.tmpl', $param ) );
}

sub dialog_post_comment {
    my $app = shift;
    $app->validate_magic or return;

    my $user      = $app->user;
    my $parent_id = $app->param('reply_to');

    return $app->errtrans('Parent comment id was not specified.')
      unless $parent_id;

    my $comment_class = $app->model('comment');
    my $parent        = $comment_class->load($parent_id)
      or return $app->errtrans('Parent comment was not found.');
    return $app->errtrans("You can't reply to unapproved comment.")
      unless $parent->is_published;

    my $perms = $app->{perms};
    return unless $perms;

    my $entry_class = $app->_load_driver_for('entry');
    my $entry       = $entry_class->load( $parent->entry_id );

    unless ( $user->is_superuser()
        || $perms->can_edit_all_posts
        || $perms->can_manage_feedback )
    {
        return $app->errtrans("Permission denied.")
          unless $perms->can_edit_entry( $entry, $user, 1 )
          ;    # check for publish_post
    }

    my $blog = $parent->blog
            || $app->model('blog')->load($app->param('blog_id'));

    require MT::Sanitize;
    my $spec = $blog->sanitize_spec
            || $app->config->GlobalSanitizeSpec;
    my $param = {
        reply_to       => $parent_id,
        commenter_name => MT::Sanitize->sanitize($parent->author, $spec),
        entry_title    => $entry->title,
        comment_created_on =>
          format_ts( LISTING_DATETIME_FORMAT, $parent->created_on, $blog, $app->user ? $app->user->preferred_language : undef ),
        comment_text       => MT::Sanitize->sanitize($parent->text, $spec),
        comment_script_url => $app->config('CGIPath')
          . $app->config('CommentScript'),
        return_url => $app->base
          . $app->mt_uri . '?'
          . $app->param('return_args'),
    };

    $app->load_tmpl( 'dialog/comment_reply.tmpl', $param );
}

sub _prepare_reply {
    my $app = shift;
    my $q   = $app->param;

    my $comment_class = $app->model('comment');
    my $parent        = $comment_class->load( $q->param('reply_to') );
    my $entry         = $app->model('entry')->load( $parent->entry_id );

    unless ( $parent->is_published ) {
        $app->error(
            $app->translate("You can't reply to unpublished comment.") );
        return ( undef, $parent, $entry );
    }

    unless ( $app->validate_magic ) {
        $app->error( $app->translate("Invalid request.") );
        return ( undef, $parent, $entry );
    }

    my $blog = $app->model('blog')->load( $entry->blog_id );

    my $nick = $app->user->nickname || $app->translate('Registered User');

    my $comment = $comment_class->new;

    ## Strip linefeed characters.
    my $text = $q->param('text');
    $text = '' unless defined $text;
    $text =~ tr/\r//d;
    $comment->ip( $app->remote_ip );
    $comment->commenter_id( $app->user->id );
    $comment->blog_id( $entry->blog_id );
    $comment->entry_id( $entry->id );
    $comment->author( remove_html($nick) );
    $comment->email( remove_html( $app->user->email ) );
    $comment->text($text);

    $comment->visible(1);    # leave as undefined
    $comment->is_junk(0);

    # strip of any null characters (done after junk checks so they can
    # monitor for that kind of activity)
    for my $field (qw(author email text)) {
        my $val = $comment->column($field);
        if ( $val =~ m/\x00/ ) {
            $val =~ tr/\x00//d;
            $comment->column( $field, $val );
        }
    }

    ( $comment, $parent, $entry );
}

#TODO: this should be refactored for more general use
sub reply {
    my $app = shift;
    my $q   = $app->param;

    my $reply_to    = encode_html( $q->param('reply_to') );
    my $magic_token = encode_html( $q->param('magic_token') );
    my $blog_id     = encode_html( $q->param('blog_id') );
    my $return_url  = encode_html( $q->param('return_url') );
    my $text        = encode_html( $q->param('text') );
    my $indicator   = $app->static_path . 'images/indicator.gif';
    my $url         = $app->uri;
    <<SPINNER;
<html><head><style type="text/css">
#dialog-indicator {position: relative;top: 200px;
background: url($indicator)
no-repeat;width: 66px;height: 66px;margin: 0 auto;
}</style><script type="text/javascript">
function init() { var f = document.getElementById('f'); f.submit(); }
window.setTimeout("init()", 1500);
</script></head><body>
<div align="center"><div id="dialog-indicator"></div>
<form id="f" method="post" action="$url">
<input type="hidden" name="__mode" value="do_reply" />
<input type="hidden" name="reply_to" value="$reply_to" />
<input type="hidden" name="magic_token" value="$magic_token" />
<input type="hidden" name="blog_id" value="$blog_id" />
<input type="hidden" name="return_url" value="$return_url" />
<input type="hidden" name="text" value="$text" />
</form></div></body></html>
SPINNER
}

sub do_reply {
    my $app = shift;
    my $q   = $app->param;

    my $param = {
        reply_to    => $q->param('reply_to'),
        magic_token => $q->param('magic_token'),
        blog_id     => $q->param('blog_id'),
    };

    my ( $comment, $parent, $entry ) = $app->_prepare_reply;

    $param->{commenter_name} = $parent->author;
    $param->{entry_title}    = $entry->title;
    $param->{comment_created_on} =
      format_ts( "%Y-%m-%d %H:%M:%S", $parent->created_on, undef, $app->user ? $app->user->preferred_language : undef );
    $param->{comment_text} = $parent->text;

    return $app->build_page( 'dialog/comment_reply.tmpl',
        { %$param, error => $app->errstr } )
      unless $comment;

    $comment->parent_id( $param->{reply_to} );
    $comment->approve;
    return $app->handle_error(
        $app->translate( "An error occurred: [_1]", $comment->errstr() ) )
      unless $comment->save;

    MT::Util::start_background_task(
        sub {
            $app->rebuild_entry( Entry => $parent->entry_id, BuildDependencies => 1 )
              or return $app->publish_error( "Publish failed: [_1]", $app->errstr );
            $app->_send_comment_notification( $comment, q(), $entry,
                $app->model('blog')->load( $param->{blog_id} ), $app->user );
        }
    );
    return $app->build_page( 'dialog/comment_reply.tmpl',
        { closing => 1, return_url => $q->param('return_url') } );
}

sub reply_preview {
    my $app = shift;
    my $q   = $app->param;
    my $cfg = $app->config;

    my $param = {
        reply_to    => $q->param('reply_to'),
        magic_token => $q->param('magic_token'),
        blog_id     => $q->param('blog_id'),
    };
    my ( $comment, $parent, $entry ) = $app->_prepare_reply;

    my $blog = $parent->blog
            || $app->model('blog')->load($q->param('blog_id'));

    require MT::Sanitize;
    my $spec = $blog->sanitize_spec
            || $app->config->GlobalSanitizeSpec;
    $param->{commenter_name} = MT::Sanitize->sanitize($parent->author, $spec);
    $param->{entry_title}    = $entry->title;
    $param->{comment_created_on} =
      format_ts( "%Y-%m-%d %H:%M:%S", $parent->created_on, undef, $app->user ? $app->user->preferred_language : undef );
    $param->{comment_text} = MT::Sanitize->sanitize($parent->text, $spec);

    return $app->build_page( 'dialog/comment_reply.tmpl',
        { %$param, error => $app->errstr } )
      unless $comment;

    my $cmt_tmpl =
      $app->model('template')->load( { identifier => 'comment_detail' } );
    my $tmpl_name = $cmt_tmpl->name;
    require MT::Template;
    my $tmpl = MT::Template->new(
        type   => 'scalarref',
        source => \"<\$MTInclude module=\"$tmpl_name\"\$>",
    );
    my $ctx = $tmpl->context;
    ## Set timestamp as we would usually do in ObjectDriver.
    my @ts = MT::Util::offset_time_list( time, $entry->blog_id );
    my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $ts[5] + 1900, $ts[4] + 1,
      @ts[ 3, 2, 1, 0 ];
    $comment->created_on($ts);
    $comment->commenter_id( $app->user->id );
    $ctx->stash( 'comment', $comment );

    require MT::Serialize;
    my $ser   = MT::Serialize->new( $cfg->Serializer );
    my $state = $comment->column_values;
    $state->{static} = $q->param('static');
    $ctx->stash( 'comment_state', unpack 'H*', $ser->serialize( \$state ) );
    $ctx->stash( 'comment_is_static', 1 );
    $ctx->stash( 'entry',             $entry );
    $ctx->{current_timestamp} = $ts;
    $ctx->stash( 'commenter', $app->user );
    $ctx->stash( 'blog_id',   $parent->blog_id );
    $ctx->stash( 'blog',      $parent->blog );
    my %cond;
    my $html = $tmpl->build( $ctx, \%cond );
    return $app->build_page( 'dialog/comment_reply.tmpl',
        { %$param, error => $tmpl->errstr } )
      unless defined $html;

    return $app->build_page( 'dialog/comment_reply.tmpl',
        { %$param, text => $q->param('text'), preview_html => $html } );
}

sub dialog_refresh_templates {
    my $app = shift;
    $app->validate_magic or return;

    # permission check
    my $perms = $app->permissions;
    return $app->errtrans("Permission denied.")
        unless $app->user->is_superuser ||
            $perms->can_administer_blog ||
            $perms->can_edit_templates;

    my $param = {};
    my $blog = $app->blog;
    $param->{return_args} = $app->param('return_args');

    if ($blog) {
        $param->{blog_id} = $blog->id;

        my $sets = $app->registry("template_sets");
        $sets->{$_}{key} = $_ for keys %$sets;
        $sets = $app->filter_conditional_list([ values %$sets ]);

        no warnings; # some sets may not define an order
        @$sets = sort { $a->{order} <=> $b->{order} } @$sets;
        $param->{'template_set_loop'} = $sets;

        my $existing_set = $blog->template_set || 'mt_blog';
        foreach (@$sets) {
            if ($_->{key} eq $existing_set) {
                $_->{selected} = 1;
            }
        }
        $param->{'template_set_index'} = $#$sets;
        $param->{'template_set_count'} = scalar @$sets;

        $param->{template_sets} = $sets;
        $param->{screen_id} = "refresh-templates-dialog";
    }

    # load template sets
    $app->build_page('dialog/refresh_templates.tmpl',
        $param);
}

sub refresh_all_templates {
    my ($app) = @_;

    my $backup = 0;
    if ($app->param('backup')) {
        # refresh templates dialog uses a 'backup' field
        $backup = 1;
    }

    my $template_set = $app->param('template_set');
    my $refresh_type = $app->param('refresh_type') || 'refresh';

    my $t = time;

    my @id;
    if ($app->param('blog_id')) {
        @id = ( scalar $app->param('blog_id') );
    }
    else {
        @id = $app->param('id');
        if (! @id) {
            # refresh global templates
            @id = ( 0 );
        }
    }

    require MT::Template;
    require MT::DefaultTemplates;
    require MT::Blog;
    require MT::Permission;
    require MT::Util;

    foreach my $blog_id (@id) {
        my $blog;
        if ($blog_id) {
            $blog = MT::Blog->load($blog_id);
            next unless $blog;
        }
        if ( !$app->user->is_superuser() ) {
            my $perms = MT::Permission->load(
                { blog_id => $blog_id, author_id => $app->user->id } );
            if (
                !$perms
                || (   !$perms->can_edit_templates()
                    && !$perms->can_administer_blog() )
              )
            {
                next;
            }
        }

        my $tmpl_list;
        if ($blog_id) {

            if ($refresh_type eq 'clean') {
                # the user wants to back up all templates and
                # install the new ones

                my @ts = MT::Util::offset_time_list( $t, $blog_id );
                my $ts = sprintf "%04d-%02d-%02d %02d:%02d:%02d",
                    $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

                my $tmpl_iter = MT::Template->load_iter({
                    blog_id => $blog_id,
                    type => { not => 'backup' },
                });

                while (my $tmpl = $tmpl_iter->()) {
                    if ($backup) {
                        # zap all template maps
                        require MT::TemplateMap;
                        MT::TemplateMap->remove({
                            template_id => $tmpl->id,
                        });
                        $tmpl->type('backup');
                        $tmpl->name(
                            $tmpl->name . ' (Backup from ' . $ts . ')' );
                        $tmpl->identifier(undef);
                        $tmpl->rebuild_me(0);
                        $tmpl->linked_file(undef);
                        $tmpl->outfile('');
                        $tmpl->save;
                    } else {
                        $tmpl->remove;
                    }
                }

                # This also creates our template mappings
                $blog->create_default_templates( $template_set ||
                    $blog->template_set || 'mt_blog' );

                if ($template_set) {
                    $blog->template_set( $template_set );
                    $blog->save;
                    $app->run_callbacks( 'blog_template_set_change', { blog => $blog } );
                }

                next;
            }

            $tmpl_list = MT::DefaultTemplates->templates($template_set || $blog->template_set) || MT::DefaultTemplates->templates();
        }
        else {
            $tmpl_list = MT::DefaultTemplates->templates();
        }

        foreach my $val (@$tmpl_list) {
            if ($blog_id) {
                # when refreshing blog templates,
                # skip over global templates which
                # specify a blog_id of 0...
                next if $val->{global};
            }
            else {
                next unless exists $val->{global};
            }

            if ( !$val->{orig_name} ) {
                $val->{orig_name} = $val->{name};
                $val->{name}      = $app->translate( $val->{name} );
                $val->{text}      = $app->translate_templatized( $val->{text} );
            }

            my $orig_name = $val->{orig_name};

            my @ts = MT::Util::offset_time_list( $t, ( $blog_id ? $blog_id : undef ) );
            my $ts = sprintf "%04d-%02d-%02d %02d:%02d:%02d", $ts[5] + 1900,
              $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

            my $terms = {};
            $terms->{blog_id} = $blog_id;
            $terms->{type} = $val->{type};
            if ( $val->{type} =~
                m/^(archive|individual|page|category|index|custom|widget)$/ )
            {
                $terms->{name} = $val->{name};
            }
            else {
                $terms->{identifier} = $val->{identifier};
            }

            # this should only return 1 template; we're searching
            # within a given blog for a specific type of template (for
            # "system" templates; or for a type + name, which should be
            # unique for that blog.
            my $tmpl = MT::Template->load($terms);
            if ($tmpl && $backup) {

                # check for default template text...
                # if it is a default template, then outright replace it
                my $text = $tmpl->text;
                $text =~ s/\s+//g;

                my $def_text = $val->{text};
                $def_text =~ s/\s+//g;

                # if it has been customized, back it up to a new tmpl record
                if ($def_text ne $text) {
                    my $backup = $tmpl->clone;
                    delete $backup->{column_values}
                      ->{id};    # make sure we don't overwrite original
                    delete $backup->{changed_cols}->{id};
                    $backup->name(
                        $backup->name . $app->translate( ' (Backup from [_1])', $ts ) );
                    $backup->type('backup');
                    # if ( $backup->type !~
                    #         m/^(archive|individual|page|category|index|custom|widget)$/ )
                    # {
                    #     $backup->type('custom')
                    #       ;      # system templates can't be created
                    # }
                    $backup->outfile('');
                    $backup->linked_file( $tmpl->linked_file );
                    $backup->identifier(undef);
                    $backup->rebuild_me(0);
                    $backup->build_dynamic(0);
                    $backup->save;
                }
            }
            if ($tmpl) {
                # we found that the previous template had not been
                # altered, so replace it with new default template...
                $tmpl->text( $val->{text} );
                $tmpl->identifier( $val->{identifier} );
                $tmpl->type( $val->{type} )
                  ; # fixes mismatch of types for cases like "archive" => "individual"
                $tmpl->linked_file('');
                $tmpl->save;
            }
            else {
                # create this one...
                my $tmpl = new MT::Template;
                $tmpl->build_dynamic(0);
                $tmpl->set_values(
                    {
                        text       => $val->{text},
                        name       => $val->{name},
                        type       => $val->{type},
                        identifier => $val->{identifier},
                        outfile    => $val->{outfile},
                        rebuild_me => $val->{rebuild_me}
                    }
                );
                $tmpl->blog_id($blog_id);
                $tmpl->save
                  or return $app->error(
                        $app->translate("Error creating new template: ")
                      . $tmpl->errstr );
            }
        }
    }

    $app->add_return_arg( 'refreshed' => 1 );
    $app->call_return;
}

sub refresh_individual_templates {
    my ($app) = @_;

    require MT::Util;

    my $user = $app->user;
    my $perms = $app->permissions;
    return $app->error(
        $app->translate(
            "Permission denied.")
      )
      #TODO: system level-designer permission
      unless $user->is_superuser() || $user->can_edit_templates()
      || ( $perms
        && ( $perms->can_edit_templates()
          || $perms->can_administer_blog ) );

    my $set;
    if ( my $blog_id = $app->param('blog_id') ) {
        my $blog = $app->model('blog')->load($blog_id);
        $set = $blog->template_set()
            if $blog;
    }

    require MT::DefaultTemplates;
    my $tmpl_list = MT::DefaultTemplates->templates($set) or return;

    my $trnames    = {};
    my $tmpl_types = {};
    my $tmpl_ids   = {};
    my $tmpls      = {};
    foreach my $tmpl (@$tmpl_list) {
        $tmpl->{text} = $app->translate_templatized( $tmpl->{text} );
        $tmpl_ids->{ $tmpl->{identifier} } = $tmpl
            if $tmpl->{identifier};
        $trnames->{ $app->translate( $tmpl->{name} ) } = $tmpl->{name};
        if ( $tmpl->{type} !~ m/^(archive|individual|page|category|index|custom|widget)$/ )
        {
            $tmpl_types->{ $tmpl->{type} } = $tmpl;
        }
        else {
            $tmpls->{ $tmpl->{type} }{ $tmpl->{name} } = $tmpl;
        }
    }

    my $t = time;

    my @msg;
    my @id = $app->param('id');
    require MT::Template;
    foreach my $tmpl_id (@id) {
        my $tmpl = MT::Template->load($tmpl_id);
        next unless $tmpl;
        my $blog_id = $tmpl->blog_id;

        # FIXME: permission check -- for this blog_id

        my @ts = MT::Util::offset_time_list( $t, $blog_id );
        my $ts = sprintf "%04d-%02d-%02d %02d:%02d:%02d", $ts[5] + 1900,
          $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

        my $orig_name = $trnames->{ $tmpl->name } || $tmpl->name;
        my $val = ( $tmpl->identifier ? $tmpl_ids->{ $tmpl->identifier() } : undef )
          || $tmpl_types->{ $tmpl->type() }
          || $tmpls->{ $tmpl->type() }{$orig_name};
        if ( !$val ) {
            push @msg,
              $app->translate(
"Skipping template '[_1]' since it appears to be a custom template.",
                $tmpl->name
              );
            next;
        }

        my $text = $tmpl->text;
        $text =~ s/\s+//g;

        my $def_text = $val->{text};
        $def_text =~ s/\s+//g;

        if ($text ne $def_text) {
            # if it has been customized, back it up to a new tmpl record
            my $backup = $tmpl->clone;
            delete $backup->{column_values}
              ->{id};    # make sure we don't overwrite original
            delete $backup->{changed_cols}->{id};
            $backup->name( $backup->name . ' (Backup from ' . $ts . ')' );
            $backup->type('backup');
            $backup->outfile('');
            $backup->linked_file( $tmpl->linked_file );
            $backup->rebuild_me(0);
            $backup->build_dynamic(0);
            $backup->identifier(undef);
            $backup->save;
            push @msg,
              $app->translate(
    'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>',
                  $blog_id, $backup->id, $tmpl->name );

            # we found that the previous template had not been
            # altered, so replace it with new default template...
            $tmpl->text( $val->{text} );
            $tmpl->identifier( $val->{identifier} );
            $tmpl->linked_file('');
            $tmpl->save;
        } else {
            push @msg, $app->translate("Skipping template '[_1]' since it has not been changed.", $tmpl->name);
        }
    }
    my @msg_loop;
    push @msg_loop, { message => $_ } foreach @msg;

    $app->build_page( 'refresh_results.tmpl',
        { message_loop => \@msg_loop, return_url => $app->return_uri } );
}

sub publish_index_templates {
    my $app = shift;
    $app->validate_magic or return;

    # permission check
    my $perms = $app->permissions;
    return $app->errtrans("Permission denied.")
        unless $app->user->is_superuser ||
            $perms->can_administer_blog ||
            $perms->can_rebuild;

    my $blog = $app->blog;
    my $templates = MT->model('template')->lookup_multi([ $app->param('id') ]);
    TEMPLATE: for my $tmpl (@$templates) {
        next TEMPLATE if !defined $tmpl;
        next TEMPLATE if $tmpl->blog_id != $blog->id;
        $app->rebuild_indexes(
            Blog     => $blog,
            Template => $tmpl,
        );
    }

    $app->call_return( published => 1 );
}

1;
__END__

=head1 NAME

MT::App::CMS

=head1 SYNOPSIS

The I<MT::App::CMS> module is the primary application module for
Movable Type. It is the administrative interface that is used to
manage blogs, entries, comments, trackbacks, templates, etc.

=head1 METHODS

=head2 $app->init

Initializes the application, defining the modes that are serviced and
core callbacks and itemset actions.

=head2 $app->init_request

Initializes the application to handle the request. The CMS also does a
schema version check to make certain the schema is up-to-date. If it is
not, it forces a direct to the configured UpgradeScript application
(typically mt-upgrade.cgi).

=head2 $app->init_plugins

Overrides I<MT::init_plugins> to call L<init_core_callbacks> before other
plugins are run (since init_core_callbacks defines some remapped callback
names plugins may rely on).

=head2 $app->apply_log_filter(\%param)

Returns terms suitable for filtering L<MT::Log> based on the parameters
given. 'filter', 'filter_val' and 'blog_id' are recognized parameters.
'filter' may be one of 'level' or 'class'. Valid 'filter_val' values for
a 'filter' of 'level' is any number between 1 and 2^16, being a bitmask.
Valid 'filter_val' values for a 'filter' of 'class' include any of the
register L<MT::Log> class names. See L<MT::Log> for further information.

=head2 $app->build_author_table(%args)

=head2 $app->build_blog_table(%args)

=head2 $app->build_comment_table(%args)

=head2 $app->build_commenter_table(%args)

=head2 $app->build_entry_table(%args)

=head2 $app->build_group_table(%args)

=head2 $app->build_junk_table(%args)

=head2 $app->build_log_table(%args)

=head2 $app->build_ping_table(%args)

=head2 $app->build_tag_table(%args)

=head2 $app->build_template_table(%args)

Each of these routines have a similar interface and function. They
load data for the E<lt>typeE<gt>_table.tmpl application template.
Parameters for these routine are:

=over 4

=item * param

The parameter hash to populate. This is eventually applied to
the application template.

=item * load_args

An array reference containing the terms and arguments that are to be passed
on to Class-E<gt>load_iter method to load the data.

=item * iter

An existing iterator that can be used to load the records.

=item * items

An array of objects used to populate the listing.

=back

Only one of these arguments is allowed: param, load_args, iter. Upon return,
the hashref provided in the 'param' element is populated with the data
necessary to build the template.

These routines are called by their listing modes (where a 'load_args'
parameter is given) and also from the search_replace mode when displaying
search results (where it passes an 'items' element).

=head2 $app->build_page($tmpl_file, \%param)

Overridden method for L<MT::App::build_page> that adds additional
template parameters that are common to CMS application templates.

=head2 $app->build_plugin_table(%opt)

Populates template parameters necessary for rendering the cfg_plugin.tmpl
for the blog-centric and system-overview views.

=head2 $app->do_search_replace

Utility method used to do the physical search and replace operation
invoked with the 'search_replace' application mode. This method is also
used by the 'listing' method when a 'search' parameter is sent in the
request.

=head2 $app->get_newsbox_content

Handles the task of retrieving the "Movable Type News" from sixapart.com.
This request is done at most once per day since the data is cached
after retrieval. This operation can be disabled by setting the
C<NewsboxURL> to "disable".

=head2 $app->is_authorized

Determines if the active user is authorized to access the blog being
requested. If a blog-level request is active, this method sets the
permissions object for the current user and blog.

=head2 $app->list_actions($which, $type, @param)

Utility method to handle the selection of itemset actions for a given
C<$type>. Any @param data given here is passed through to the itemset
action's "condition" coderef, if registered.

=head2 $app->languages_list($lang)

Returns a list of supported languages in a format suitable for the
edit_author.tmpl, edit_profile.tmpl and cfg_system_general.tmpl application
templates. The C<$lang> parameter pre-selects that language in the
list.

=head2 $app->list_tag_for(%param)

Generates a listing screen for L<MT::Tag> objects that are attached
to a given 'taggable' package. The parameters for this method are:

=over 4

=item * Package

The Perl package name of a class that supports the L<MT::Taggable>
interface that the listing is for.

=item * TagObjectType

The registered type (ie, 'entry' for MT::Entry objects) of data these
tags are associated with.

=item * TagObjectLabelPlural

Translated version of TagObjectTypePlural.

=back

To list tags for the L<MT::Entry> package, you would use this:

    $app->list_tag_for(
        Package => 'MT::Entry',
        TagObjectType => 'entry',
        TagObjectLabelPlural => $app->translate("entries")
    );

This method uses the list_tag.tmpl application template to
render the tag listing view.

=head2 $app->load_default_entry_prefs

=head2 $app->load_entry_prefs

=head2 $app->load_list_actions

=head2 $app->list_pref($type)

Returns a hashref of listing preferences suitable for the pager.tmpl
application template. It will also update new listing preference settings
if it sees the current request is posting them.

=head2 $app->listing(\%param)

This is a method for generating a typical listing screen. It is configured
through the parameter hash passed to it. The accepted parameters include:

=over 4

=item * Type

Specifies a data type to be processed. This is one of the types registered
with the application (see the L<register_type> method). Standard types
include: C<blog>, C<entry>, C<author>, C<comment>, C<ping>, C<template>,
C<notification>, C<templatemap>, C<commenter>, C<banlist>, C<category>,
C<ping_cat>, C<log>, C<tag>, C<group>, C<role>, C<association>.

The Type parameter provides a reference to the actual Perl package to be
used for loading the data for the listing. L<MT::App::CMS> uses it's
C<model> method to retrieve the package name and load the
module if necessary. The module provided should be a MT::Object descendant.

=item * Template

The application template filename to be used to generate the page.
If unspecified, the default is named after the 'Type' parameter:
"list_E<lt>typeE<gt>.tmpl". Note that this parameter is not used when
the 'NoHTML' parameter is specified.

=item * Params

A hashref of parameters that will be passed to the application template
without further modification.

=item * Code

A coderef that is invoked for each row data displayed. This routine is passed
two parameters: the object being processed and a hashref of parameter data
for that row. This is typically used to further customize the row-level
parameter data before the application template is processed.

=item * Terms

This is a hashref that is passed to the C<load_iter> method of the package
that is providing the data for the listing. The Terms parameter provides a
way of filtering the data retrieved. Refer to the L<MT::Object> documentation
of the C<load> and C<load_iter> methods for more information about this
parameter.

=item * Args

This is a hashref that is passed to the C<load_iter> method of the package
that is providing the data for the listing. The Args parameter can be used
to specify a sort order, a join operation and other operations that are
applied upon loading the data for the listing. Refer to the L<MT::Object>
documentation of the C<load> and C<load_iter> methods for more information
about this parameter.

=item * Iterator

The default value for this parameter is 'load_iter'. This is a standard
method for all L<MT::Object> type packages. So, for instance, if your 'Type'
parameter is 'author', the package that will be used is 'MT::Author',
so the listing method will call MT::Author-E<gt>load_iter to fetch the data.
But the L<MT::Author> package provides some convenient iterators for fetching
other things that are related to the author, such as roles they are assigned.
So, for invoking the 'role_iter' iterator method, you'd specify 'role_iter' as
the value for the Iterator parameter.

=item * NoHTML

Specify this parameter (with a true value, such as '1') to cause the
listing method to simply return the hashref of data it would have given
to the application template to return.

=back

The listing method is also aware of many of the query parameters common to
the Movable Type CMS listings. It will automatically recognize the following
query parameters:

=over 4

=item * offset

A number specifying the number of rows to skip when displaying the listing.

=item * search

A string to use for a search query of the data displayed. This parameter
is only useful for data types supported by the CMS search function: currently,
C<blog>, C<author>, C<entry>, C<comment>, C<template>, C<ping>.

=item * filter, filter_val

Used to filter the listing for a particular value. This will supplement
the Terms parameter given to the listing method, adding a term for
C<filter>=C<filter_val>.

=back

The listing method is also aware of the list preferences saved for the
'Type' identified.

=head3 Examples

This will produce a listing page (using the "list_entry.tmpl" application
template) of all entries created by the currently logged-in user.

    return $app->listing({
        Type => 'entry',
        Terms => {
            author_id => $app->user->id,
        },
    });


=head2 $app->load_template_prefs

Returns as hashref of the template edit screen preferences for the active
user.

=head2 $app->make_blog_list(\@blogs)

Takes an array of blogs and returns an array reference of data that is
suitable for the list_blog.tmpl and list_blog.tmpl application
templates.

=head2 $app->object_edit_uri($type, $id)

A convenience method for returning an application URI that can be used
to direct the user to an edit operation for the C<$type> and object C<$id>
given. This method assumes the type given is serviced through the 'view'
application mode.

=head2 $app->pre_run

Handles the menial task of localizing the stock "Convert Line Breaks" text
filter for the current user.

=head2 $app->update_dynamicity($blog, $cache, $conditional)

When saving the blog's configuration settings regarding dynamic publishing,
this method is called to update the blog's templates to match the dynamic
configuration (if specifying no dynamic publishing, all templates are
configured to be statically published, when specifying 'dynamic archives',
archive templates are configured to be dynamically published and all
other templates are set to static).

Also, the '.htaccess' file and 'mtview.php' file in the blog's root path 
is generated/updated to include rules that invoke the dynamic publishing engine.
If this file cannot be written or updated, the user is notified of this problem.

=head2 $app->user_blog_prefs

Returns a hashref of the current user's blog preferences (such as their
tag delimiter choice).

=head2 $app->user_can_admin_commenters

A utility method used by commenter-based itemset actions to condition
their display based on whether or not the active user has permissions
to administer commenters for the current blog.

=head2 $app->validate_magic

Verifies the 'magic_token' POST parameter that is placed in forms that
are submitted to the application. This token is used as a safety device
to protect against CSRF (cross-site request forgery) style attacks.

=head1 MODE HANDLERS

The CMS mode handlers typically do a permission test to verify the user
has permission to invoke the mode, then process the request and return
the response using an application template.

=over 4

=item * add_group

Adds a user to one or more groups. Returns to the list_groups mode upon
success.

=item * add_member

Adds one or more users to a group. Returns to the list_authors mode upon
success.

=item * add_tags_to_entries

Applies a set of tags to one or more entries.

=item * approve_item

Approves a comment or trackback for publication.

=item * ban_commenter

Bans a commenter for a particular blog.

=item * ban_commenter_by_comment

Bans commenters on a blog based on a selection of one or more comments.

=item * category_add

Displays the popup window (used on the entry composition screen) for
adding a new category.

=item * category_do_add

Processes the creation of a new category and returns the JavaScript that
adds the category to the category drop down list on the entry composition
screen.

=item * cc_return

Handles the Creative Commons license data returned from their license
selection process.

=item * cfg_comments

Handles the display of the weblog comments settings screen.

=item * cfg_trackbacks

Handles the display of the weblog trackback settings screen.

=item * cfg_spam

Handles the display of the weblog spam settings screen.

=item * cfg_entry

Handles the display of the weblog entries settings screen.

=item * cfg_web_services

Handles the display of the weblog web services settings screen.

=item * cfg_archives

Handler for the Blog Archives configuration screen.

=item * cfg_blog

Handles the display of the general settings for the blog.

=item * cfg_plugins

Handles the display of the "Plugins" tab of the blog setting screen.

=item * cfg_prefs

Handles the display of the "Customize Entry display preferences" screen.

=item * cfg_system_feedback

Handles the display of the "System-Wide Feedback Settings" screen.

=item * cfg_system_general

Handles the display of the "System-Wide: General Settings" screen.

=item * delete

Handles the deletion of registered data types.

=item * dialog_grant_role

Handles display of the modal dialog for granting roles.

=item * dialog_select_group

Handles display of the modal dialog for selecting one or more groups.

=item * dialog_select_user

Handles the display of the modal dialog for selecting one or more users.

=item * dialog_select_weblog

Handles the display of the modal dialog for selecting a blog.

=item * disable_object

Handles the request to disable a user or group.

=item * do_import

Handles the request to process entry import file(s).

=item * draft_entries

Handles the request to unpublish existing entries.

=item * edit_object

Handles the display of editing registered data types.

=item * edit_role

Handles the display of editing a particular role.

=item * empty_junk

Handles the request to empty the junk folder for comments or trackbacks.

=item * enable_object

Handles the request to enable a user or group.

=item * start_export

Handler for the display of the export screen.

=item * export

Handles the request to export the data for a blog.

=item * export_log

Handles the request to export activity log data in a CSV format.

=item * grant_role

Handles the request from the "Grant Role" modal dialog to grant a role
to an user or group.

=item * handle_junk

Handles the request to junk a given comment or trackback.

=item * handshake

Handles the response from TypeKey for assigning the TypeKey token to
a particular blog.

=item * itemset_action

Generic application mode handler used by all itemset actions. This handler
will locate the actual coderef to be run to service the itemset action and
if found, calls it.

=item * js_tag_check

Ajax-style handler for testing whether a particular tag name exists or not.

=item * js_tag_list

Ajax-style handler for returning the tags that exist on a particular blog.

=item * list_assets

Handler for displaying a list of blog-level assets.

=item * list_associations

Handler for displaying the associations listing (either all associations,
associations for a particular user, group, role or blog).

=item * list_authors

Handler for displaying a list of authors.

=item * dashboard

Handler for the front screen of MT, where the user's associated blogs
are listed.

=item * list_category

Handler for displaying the categories for a particular blog.

=item * list_commenter

Handler for displaying a list of authenticated commenters for a particular
blog.

=item * list_comments

Handler for displaying a list of comments (either blog-level or system-wide).

=item * list_entries

Handler for displaying a list of entries (either blog-level or system-wide).

=item * list_groups

Handler for displaying the group listing.

=item * list_objects

Handler for displaying the installed templates for a particular blog (this
used to be a routine called for most listings, but they have been broken out
into separate handlers).

=item * list_pings

Handler for displaying a list of trackbacks (either blog-level or
system-wide).

=item * cfg_system_plugins

Handler for displaying all installed plugins (the system-overview view of
plugins).

=item * list_roles

Handler for displaying the role listing.

=item * list_tag

Handler for displaying a list of tags (either blog-level or system-wide).

=item * logout

Handler for logging the active user out of the application, ending their
session.

=item * move_category

Handles the request for moving a category from one parent to another (or
to the top level).

=item * not_junk

Handler for approving previously junked comments or TrackBack objects.

=item * pinged_urls

Handler for displaying the list of URLs that have been pinged for
a particular entry.

=item * plugin_control

Handler for the request to enable/disable a particular plugin or all
plugins.

=item * preview_entry

Handler for displaying an entry preview (invoked from the entry
composition screen).

=item * publish_entries

Itemset handler for the request to publish a selection of entries.

=item * rebuild_confirm

Handler for displaying the list of rebuild options in the rebuild site
popup window.

=item * rebuild_new_phase

Displays the "rebuilding.tmpl" page and invokes a "rebuild_phase"
mode request to process the rebuild of a set of entries/templates.

=item * rebuild_pages

Primary rebuild handler for the rebuild site process.

=item * rebuild_phase

Handler for rebuilding entries/templates selected from the listings. Rebuilds
the requested set of items and returns to the originally viewed listing.

=item * recover_password

Handler for displaying the password recovery screen.

=item * recover_passwords

Handler for resetting the passwords for one or more users.

=item * recover_profile_password

Handler for the password reset request invoked by a system administrator
from the user profile screen.

=item * reg_bm_js

Handler for returning the JavaScript code for displaying the QuickPost
composition page for Internet Explorer users that have installed the
QuickPost Windows registry file.

=item * reg_file

Handler that returns the "mt.reg" for enabling a conext-menu QuickPost item
that is suitable for Internet Explorer.

=item * remove_group

Handler for removing one or more group associations from a particular user.

=item * remove_member

Handler for removing one or more user associations from a particular group.

=item * remove_tags_from_entries

Itemset handler for removing a list of tags from one or more entries.

=item * rename_tag

Handler for renaming a I<MT::Tag>, or merging with another tag if one
exists by that name.

=item * reset_blog_templates

Handler for resetting a given blogs templates back to their default
configuration.

=item * reset_log

Handler for resetting the system-wide activity log.

=item * reset_password

=item * reset_plugin_config

=item * save_category

=item * save_cfg_system_feedback

=item * save_cfg_system_general

=item * save_commenter_perm

=item * save_entries

=item * save_entry

=item * save_entry_prefs

=item * save_object

=item * save_plugin_config

=item * save_role

=item * search_replace

=item * send_notify

=item * send_pings

=item * set_item_visible

=item * set_object_status

=item * show_admin

=item * show_entry_prefs

=item * show_menu

=item * show_upload_html

=item * start_import

Handler for the display of the import screen.

=item * start_rebuild_pages

=item * start_recover

=item * start_upload

=item * start_upload_entry

=item * asset_insert

=item * asset_insert_text

=item * start_upload_entry

=item * list_blogs

Handler for the display of the system-wide list of blogs.

=item * trust_commenter

=item * trust_commenter_by_comment

=item * unapprove_item

=item * unban_commenter

=item * unban_commenter_by_comment

=item * untrust_commenter

=item * untrust_commenter_by_comment

=item * update_list_prefs

Handler for saving changes to the user's list preferences.

=item * update_welcome_message

Handler for saving the change to the blog's welcome message.

=item * upgrade

Transient mode handler used to redirect user to the mt-upgrade script
for either installation of upgrade of their database.

=item * upload_file

=item * complete_insert

=item * view_log

Handler for viewing the activity log (either blog-level or system-wide).

=item * start_backup

Handler for the display of the backup screen.

=item * start_restore

Handler for the display of the restore screen.

=item * backup

Handler for the system backup function.

=item * restore

Handler for the system backup function.

=back

=head1 UTILITY FUNCTIONS

=head2 listify(\@array)

Utility function that takes an array reference of strings and returns
an array reference of hashes. So this:

    listify(['a','b','c'])

yields this:

    [{name => 'a'},{name => 'b'},{name => 'c'}]

This is handy for presenting a simple list of things in an HTML::Template
template.

=head2 $app->make_feed_link($view, $params)

Utility method for constructing an Activity Feed link based on the current
view. This routine requires the user have an API password assigned to
their profile.

=head2 $app->map_comment_to_commenter(\@comments)

Utility method for retrieving the unique set of commenter_id and blog_id
values for the set of comments given. The return value from this method
is an list of array references that each have the commenter_id and blog_id
in them.

=head2 $app->ping_continuation

Utility method that returns a response to show the "Pinging..." status
page (pinging.tmpl application template).

=head2 $app->rebuild_these(\%rebuild_set, %options)

Utility method for rebuilding a set of entries. If C<$options{how}> is
passed and it is set to the C<NEW_PHASE> constant, the handler returns
the 'rebuilding.tmpl' application template to kick off the actual
rebuild operation with a separate request. Otherwise, the entries
are rebuilt immediately.

=head2 $app->register_type($type, $package)

Registers a new "API" type that goes into the C<%API> hash. This registry
is used by the C<model> method and other generic handlers
that expect a '_type' parameter to be passed in the request.

=head2 RegistrationAffectsArchives($blog_id, $archive_type)

Private utility routine to test if a particular archive type is affected
by changes to commenter registration settings. Returns true if particular
tags are in use (namely, MTIfRegistrationRequired,
MTIfRegistrationNotRequired, MTIfRegistrationAllowed).

=head2 $app->update_entry_status($new_status, @id_list)

Called by the draft_entries and publish_entries handlers to actually
apply the updates to the entries identified and publish pages that
are necessary.  If DeleteFilesAtRebuild directive is set to 1, it also
removes the previously published individual entry archive page if the
new status for the entry is the one other than RELEASE.

=head1 CUSTOM REBUILD OPTIONS

The pop-up rebuild dialog that you see in Movable Type has a drop-down
list of rebuild options. This list can be populated with custom options
provided through a plugin. For example, a plugin might want to provide
the user with an option to rebuild a template identified for creating
user archives.

=head2 $app->add_rebuild_option(\%param)

=over 4

=item label

The label to display in the list of rebuild options.

=item code

The code to execute when running the custom rebuild option.

=item key

An identifier unique to this option (optional, will derive from the label if
unavailable).

=back

In addition to this application method, there is also a C<rebuild_options>
callback that can be used to further customize the list of extra rebuild
options. This callback is useful when needing to add items to the list
that are unique to the active user or blog.

=head1 CALLBACKS

The application-level callbacks of the C<MT::App::CMS> application are
documented here.

=over 4

=item rebuild_options

    callback($cb, $app, \@options)

The rebuild_options callback provides control over an array of additional
custom rebuild options that are displayed in MT's rebuild window. The array
is populated with hashrefs, each containing:

=over 4

=item code

The code to execute when running the custom rebuild option.

=item label

The label to display in the list of rebuild options.

=item key

An identifier unique to this option (optional, will derive from the label
if unavailable).

=back

=item CMSPostSave.entry

Called when an entry has been saved, after all of its constituent
parts (for example, category placements) have been saved. An 
CMSPostEntrySave callback would have the following signature:

    sub cms_post_entry_save($cb, $app, $entry, $original)
    {
        ...
    }

=back

For backward compatibility, C<CMSPostEntrySave> and C<AppPostEntrySave> are
aliases to C<CMSPostSave.entry>.

=head2 Parametric Calllbacks

Every object "type" has a suite of callbacks defined for that type, as
below. Each item in the list below forms a callback name by appending
the object "type" after a period,
e.g. C<CMSViewPermissionFilter.blog>, C<CMSPostSave.template>,
etc. The "type" values come from the same space as passed to the CMS
app's C<_type> query parameter. If you're not sure what C<_type>
corresponds to a certain MT::Object subclass, consult the following list:

=over 4

=item author           => MT::Author

=item comment          => MT::Comment

=item entry            => MT::Entry

=item template         => MT::Template

=item blog             => MT::Blog

=item notification     => MT::Notification

=item templatemap      => MT::TemplateMap

=item category         => MT::Category

=item banlist          => MT::IPBanList

=item ping             => MT::TBPing

=item ping_cat         => MT::TBPing

=item group            => MT::Group

=item role             => MT::Role

=item association      => MT::Association

=back

Callbacks that apply to these object types are as follows:

=over 4

=item CMSViewPermissionFilter
    
Calling convention is:

    callback($cb, $app, $id, $obj_promise)

Where C<$id> is the ID of an object, if it already exists, or
C<undef> if the user will be creating a new object of this type.

C<$obj_promise> is a promise for the object itself. You can use
C<$obj_promise->force> to get ahold of the object, if you need it, but
typically you won't need it. (See L<MT::Promise>)

Return a false value to abort the operation and display a message to
the user that s/he doesn't have permission to view the object.

=item CMSDeletePermissionFilter

    callback($cb, $app, $obj)

=item CMSSavePermissionFilter
    
Calling convention is:

    callback($cb, $app, $id)
    
Where C<$id> is the ID of the object, if it already exists, or
C<undef> if it is a new object with this request.

Note that at this point, the object may not yet exist. The request can
be understood through the query parameters of the app, accessible
through C<$app-E<gt>param()>. A C<CMSSavePermissionFilter> callback
should be "safe"--it should not modify the database.

Return a false value to abort the operation and display a message to
the user that s/he doesn't have permission to modify the object. The
method is not called if the acting user is a superuser.

=item CMSSaveFilter

This callback gives you the chance to "decline" for reasons other than lack of permissions.

The routine is called as follows:
    
    callback($cb, $app)

Returning a false value will decline the request. It is advisibable to
return an error via the C<$cb> object in order to signal to the user
what went wrong.

Note that the new object has not been constructed yet. The operation
can be understood by examining the C<$app> object's query parameters
via C<$app-E<gt>param()>

A C<CMSSaveFilter> callback should be "safe"--it should not modify the
database.

=item CMSPreSave

    callback($cb, $app, $obj, $original)

C<$obj> and C<$original> hold the object which is about to be saved,
and the object as it was when this request began, respectively. This
allows the callback to determine what kind of changes are being
attempted in the user's request. If the request is to create a new
object, $original will be a valid object reference, but the object
will be "blank": it will be just what is returned by the C<new> method
on that class.

=item CMSPostSave

    callback($cb, $app, $obj, $original)

C<$obj> and C<$original> hold the object which is about to be saved,
and the object as it was when this request began, respectively. When
the callback routine is called, the new object as C<$obj> has already
been committed to the database. This is a convenient time to trigger
follow-up actions, such as notification and static-page rebuilds.

=item CMSPostDelete

    callback($cb, $app, $obj)

C<$obj> holds the object that has just been removed from the database.
This callback is useful when removing data that is associated with
the object being removed.

=item CMSUploadFile

    callback($cb, %params)

This callback is invoked for each file the user uploads to the blog.
It is called for each file, regardless of type. If the user uploads an
image, both the C<CMSUploadFile> and C<CMSUploadImage> callbacks are invoked.

=head3 Parameters

=over 4

=item * File

The full file path of the file that has been saved into the blog.

=item * Url

The URL of the file that has been saved into the blog.

=item * Size

The length of the file in bytes.

=item * Type

Either 'image', 'file' or 'thumbnail'.

=item * Blog

The I<MT::Blog> object the uploaded file is associated with.

=back

=item CMSUploadImage

    callback($cb, %params)

This callback is invoked for each uploaded image. In the case the user
creates a thumbnail for their uploaded image, this callback will be
invoked twice-- once for the uploaded original image and a second time
for the thumbnail that was generated for it.

=over 4

=item * File

The full path and filename for the uploaded file.

=item * Url

The full URL for the uploaded file.

=item * Size

The length of the uploaded image in bytes.

=item * Type

Either "image" or "thumbnail" (for generated thumbnails).

=item * Height

The height of the image in pixels (available if C<Image::Size> module
is present).

=item * Width

The width of the image in pixels (available if C<Image::Size> module
is present).

=item * ImageType

The image identifier as reported by the C<Image::Size> module. Typically,
'GIF', 'JPG' or 'PNG'.

=item * Blog

The C<MT::Blog> object of the blog the image is associated with.

=back

=item Rebuild

    callback($cb, $blog)

C<$blog> holds the current blog which is being rebuilt.  This callback is
called whenever with the CMS a blog completes the process of rebuilding.

=back

=cut
