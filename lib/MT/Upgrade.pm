# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Upgrade;

use strict;
use base qw( MT::ErrorHandler );
use File::Spec;

# The upgrade process...
#
#    * Database check of all data types
#      - assign default values for 'null' columns
#    * Template check for all blogs

use vars qw(%classes %functions $App $DryRun $Installing $SuperUser 
            $CLI $MAX_TIME $MAX_ROWS @steps);
sub BEGIN {
    $MAX_TIME = 5;
    $MAX_ROWS = 100;

    %functions = (
        # standard routines
        'core_upgrade_begin' => {
            code => \&core_upgrade_begin,
            priority => 1,
        },
        'core_fix_type' => {
            code => \&core_fix_type,
            priority => 2,
        },
        'core_add_column' => {
            code => sub { shift->core_column_action('add', @_) },
            priority => 3,
        },
        'core_drop_column' => {
            code => sub { shift->core_column_action('drop', @_) },
            priority => 3,
        },
        'core_alter_column' => {
            code => sub { shift->core_column_action('alter', @_) },
            priority => 3,
        },
        'core_seed_database' => {
            code => \&seed_database,
            priority => 4,
        },
        'core_upgrade_templates' => {
            code => \&upgrade_templates,
            priority => 5,
        },
        'core_upgrade_end' => {
            code => \&core_upgrade_end,
            priority => 9,
        },
        'core_finish' => {
            code => \&core_finish,
            priority => 10,
        },
    );
}

sub core_upgrade_functions {
    return {
        # < 2.0
        'core_create_placements' => {
            version_limit => 2.0,
            priority => 9.1,
            updater => {
                type => 'entry',
                label => 'Creating entry category placements...',
                condition => sub { $_[0]->category_id },
                code => sub {
                    require MT::Placement;
                    my $entry = shift;
                    my $existing = MT::Placement->load({ entry_id => $entry->id,
                        category_id => $entry->category_id });
                    if (!$existing) {
                        my $place = MT::Placement->new;
                        $place->entry_id($entry->id);
                        $place->blog_id($entry->blog_id);
                        $place->category_id($entry->category_id);
                        $place->is_primary(1);
                        $place->save;
                    }
                    $entry->category_id(0);
                },
            },
        },
        'core_create_template_maps' => {
            version_limit => 2.0,
            code => \&core_create_template_maps,
            priority => 9.1,
        },

        # < 2.1
        'core_fix_placement_blog_ids' => {
            version_limit => 2.1,
            priority => 9.2,
            updater => {
                type => 'placement',
                label => 'Updating category placements...',
                condition => sub { !$_[0]->blog_id },
                code => sub {
                    require MT::Category;
                    my $cat = MT::Category->load($_[0]->category_id);
                    $_[0]->blog_id($cat->blog_id) if $cat;
                },
            },
        },

        # < 3.0
        'core_set_blog_allow_comments' => {
            version_limit => 3.0,
            priority => 9.3,
            updater => {
                type => 'blog',
                label => 'Assigning comment/moderation settings...',
                condition => sub { !(defined $_[0]->allow_unreg_comments ||
                                     defined $_[0]->allow_reg_comments ||
                                     defined $_[0]->manual_approve_comments ||
                                     defined $_[0]->moderate_unreg_comments) },
                code => sub {
                    $_[0]->allow_unreg_comments(1)
                        unless defined $_[0]->allow_unreg_comments;
                    $_[0]->allow_reg_comments(1)
                        unless defined $_[0]->allow_reg_comments;
                    $_[0]->manual_approve_commenters(0)
                        unless defined $_[0]->manual_approve_commenters;
                    $_[0]->moderate_unreg_comments(0)
                        unless defined $_[0]->moderate_unreg_comments;
                    $_[0]->moderate_pings(0)
                        unless defined $_[0]->moderate_pings;
                },
                sql => [
                    'update mt_blog
                        set blog_allow_unreg_comments = 1
                      where blog_allow_unreg_comments is null',
                    'update mt_blog
                        set blog_allow_reg_comments = 1
                      where blog_allow_reg_comments is null',
                    'update mt_blog
                        set blog_manual_approve_commenters = 0
                      where blog_manual_approve_commenters is null',
                    'update mt_blog
                        set blog_moderate_unreg_comments = 0
                      where blog_moderate_unreg_comments is null'
                ],
            },
        },

        # < 3.2
        'core_set_default_basename_limit' => {
            version_limit => 3.2,
            priority => 9.3,
            updater => {
                type => 'blog',
                label => 'Setting blog basename limits...',
                condition => sub { !$_[0]->basename_limit },
                code => sub { $_[0]->basename_limit(15) },
                sql => 'update mt_blog set blog_basename_limit = 15
                         where blog_basename_limit is null
                            or blog_basename_limit < 15',
            },
        },
        'core_set_default_blog_extension' => {
            version_limit => 3.2,
            priority => 9.3,
            updater => {
                type => 'blog',
                label => 'Setting default blog file extension...',
                condition => sub { !$_[0]->file_extension },
                code => sub { $_[0]->file_extension('html') },
            },
        },
        'core_set_enable_archive_paths' => {
            version_limit => 3.2,
            code => \&core_set_enable_archive_paths,
            priority => 9.3,
        },
        # whereas init_comment_visible is done for adding new a comment visible
        # to the comment table, this task sets all comments with a visible
        # status of 2 to 0 since we now treat this field as a boolean.
        'core_update_comment_visible' => {
            version_limit => 3.2,
            priority => 9.3,
            updater => {
                type => 'entry',
                label => 'Updating comment status flags...',
                condition => sub { $_[0]->allow_comments == 2 },
                code => sub { $_[0]->allow_comments(0) },
                sql => 'update mt_entry set entry_allow_comments = 0
                         where entry_allow_comments = 2',
            },
        },
        'core_remove_unique_constraints' => {
            version_limit => 3.2,
            code => \&core_remove_unique_constraints,
            priority => 9.3,
        },
        'core_create_commenter_records' => {
            version_limit => 3.2,
            priority => 9.3,
            updater => {
                type => 'comment',
                label => 'Updating commenter records...',
                condition => sub { $_[0]->commenter_id },
                code => sub {
                    my ($comment) = @_;
                    require MT::Permission; require MT::Author;
                    my $perm = MT::Permission->load( { author_id => $comment->commenter_id,
                        blog_id => $comment->blog_id } );
                    if (!$perm) {
                        if (my $cmtr = MT::Author->load($comment->commenter_id)) {
                            $cmtr->pending($comment->blog_id);
                        }
                    }
                }
            }
        },
        # TBD: Revise to use role.
        'core_set_blog_admins' => {
            version_limit => 3.2,
            priority => 9.3,
            updater => {
                type => 'permission',
                label => 'Assigning blog administration permissions...',
                condition => sub { $_[0]->can_edit_config },
                code => sub { $_[0]->can_administer_blog(1) },
            }
        },
        'core_set_blog_allow_pings' => {
            version_limit => 3.2,
            priority => 9.3,
            updater => {
                type => 'blog',
                label => 'Setting blog allow pings status...',
                condition => sub { !defined $_[0]->allow_pings },
                code => sub { $_[0]->allow_pings($_[0]->allow_pings_default) },
                sql => 'update mt_blog set blog_allow_pings = blog_allow_pings_default
                         where blog_allow_pings is null',
            }
        },
        'core_set_superuser' => {
            version_limit => 3.2,
            code => \&core_set_superuser,
            priority => 9.3,
        },
        'core_conflate_require_email' => {
            version_limit => 3.2,
            priority => 9.3,
            updater => {
                type => 'blog',
                label => 'Updating blog comment email requirements...',
                condition => sub { !$_[0]->require_comment_emails },
                code => sub { $_[0]->require_comment_emails(1)
                                  if !$_[0]->allow_anon_comments },
            }
        },
        'core_populate_entry_basenames' => {
            version_limit => 3.2,
            priority => 9.3,
            updater => {
                type => 'entry',
                condition => sub { !$_[0]->basename },
                code => sub { my $entry = shift; my %args = @_;
                    $args{from} < 3.20021
                        ? $entry->basename(mt32_dirify($entry->title))
                        : 1;
                },
                label => 'Assigning entry basenames for old entries...',
            }
        },
        'core_set_api_password' => {
            version_limit => 3.2,
            priority => 9.3,
            updater => {
                type => 'author',
                condition => sub { ($_[0]->type == 1) && (($_[0]->api_password || '') eq '') },
                code => sub { $_[0]->api_password($_[0]->password) },
                label => 'Updating user web services passwords...',
            }
        },
        'core_create_config_table' => {
            version_limit => 3.2,
            code => \&core_create_config_table,
            priority => 9.3,
        },
        'core_deprecate_old_style_archive_links' => {
            version_limit => 3.2,
            priority => 9.3,
            updater => {
                type => 'blog',
                label => 'Updating blog old archive link status...',
                condition => sub { my $blog = shift; my %args = @_;
                                   $blog->old_style_archive_links
                                       || $args{from} < 3.0 },
                code => sub {
                    my ($blog) = @_;
                    require MT::TemplateMap;
                    foreach my $map (MT::TemplateMap->load({ blog_id => $blog->id })) {
                        next if $map->file_template;
            
                        my $at = $map->archive_type;
                        if ($at eq 'Individual') {
                            $map->file_template('%e%x');
                        } elsif ($at eq 'Daily') {
                            $map->file_template('%y_%m_%d%x');
                        } elsif ($at eq 'Weekly') {
                            $map->file_template('week_%y_%m_%d%x');
                        } elsif ($at eq 'Monthly') {
                            $map->file_template('%y_%m%x');
                        } elsif ($at eq 'Category') {
                            $map->file_template('cat_%C%x');
                        }
                        $map->save;
                    }
                    $blog->old_style_archive_links(0);
                }
            }
        },
        'core_set_entry_weeknumber' => {
            version_limit => 3.20006,
            priority => 9.3,
            updater => {
                type => 'entry',
                condition => sub { ($_[0]->week_number || 0) < 54 },
                code => sub { 1 },
                label => 'Updating entry week numbers...',
            }
        },
        'core_set_tag_permissions' => {
            version_limit => 3.20021,
            priority => 9.3,
            updater => {
                type => 'permission',
                condition => sub { !$_[0]->can_edit_tags && !$_[0]->can_administer_blog },
                code => sub { $_[0]->can_edit_tags($_[0]->can_edit_categories) },
                label => 'Updating user permissions for editing tags...',
            }
        },
        'core_init_blog_entry_display_defaults' => {
            version_limit => 3.20021,
            code => sub {
                require MT::Permission;
                &core_update_records
            },
            priority => 9.3,
            updater => {
                type => 'blog',
                condition => sub { !(MT::Permission->count({
                    blog_id => $_[0]->id, author_id => 0 })) },
                code => sub {
                    my $perm = new MT::Permission;
                    $perm->entry_prefs('Advanced|Bottom');
                    $perm->blog_id($_[0]->id);
                    $perm->author_id(0);
                    $perm->save;
                },
                label => 'Setting new entry defaults for blogs...',
            }
        },
        'core_upgrade_tag_categories' => {
            version_limit => 3.20021,
            priority => 9.3,
            updater => {
                type => 'category',
                condition => sub { ($_[0]->description||'') =~ m/<!--tag-->/ },
                code => sub {
                    my ($cat) = @_;
                    require MT::Placement;
                    require MT::Entry;
                    my @e = MT::Entry->load(undef, {join => ['MT::Placement', 'entry_id', { category_id => $cat->id }]});
                    my $tag_name = $cat->label;
                    foreach my $e (@e) {
                        my $tags = $e->tags;
                        $e->tags($tags, $tag_name);
                        $e->save;
                    }
                },
                label => 'Migrating any "tag" categories to new tags...',
            }
        },
        'core_init_blog_custom_dynamic_templates' => {
            on_field => 'MT::Blog->custom_dynamic_templates',
            priority => 3.1,
            updater => {
                type => 'blog',
                condition => sub { !defined $_[0]->custom_dynamic_templates },
                code => sub { $_[0]->custom_dynamic_templates('none') },
                label => 'Assigning custom dynamic template settings...',
                sql => q{update mt_blog
                            set blog_custom_dynamic_templates = 'none'
                          where blog_custom_dynamic_templates is null},
            }
        },
        'core_init_author_type' => {
            on_field => 'MT::Author->type',
            priority => 3.1,
            updater => {
                type => 'author',
                condition => sub { !$_[0]->type },
                code => sub { $_[0]->type(1) },
                label => 'Assigning user types...',
                sql => 'update mt_author set author_type = 1
                        where author_type is null or author_type = 0',
            }
        },
        'core_init_category_parent' => {
            on_field => 'MT::Category->parent',
            priority => 3.1,
            updater => {
                type => 'category',
                condition => sub { !defined $_[0]->parent },
                code => sub { $_[0]->parent(0) },
                label => 'Assigning category parent fields...',
                sql => 'update mt_category set category_parent = 0
                        where category_parent is null',
            }
        },
        'core_init_template_build_dynamic' => {
            on_field => 'MT::Template->build_dynamic',
            priority => 3.1,
            updater => {
                type => 'template',
                condition => sub { !defined $_[0]->build_dynamic },
                code => sub { $_[0]->build_dynamic(0) },
                label => 'Assigning template build dynamic settings...',
                sql => 'update mt_template set template_build_dynamic = 0
                        where template_build_dynamic is null',
            }
        },
        'core_init_comment_visible' => {
            on_field => 'MT::Comment->visible',
            priority => 3.1,
            updater => {
                type => 'comment',
                condition => sub { !defined $_[0]->visible },
                code => sub { $_[0]->visible(1) },
                label => 'Assigning visible status for comments...',
                sql => 'update mt_comment set comment_visible = 1
                        where comment_visible is null',
            }
        },
        'core_init_comment_junk_status' => {
            on_field => 'MT::Comment->junk_status',
            priority => 3.1,
            updater => {
                type => 'comment',
                condition => sub { !defined $_[0]->junk_status },
                code => sub { $_[0]->junk_status(1) },
                label => 'Assigning junk status for comments...',
                sql => 'update mt_comment set comment_junk_status = 1
                        where comment_junk_status is null',
            }
        },
        'core_init_tbping_visible' => {
            on_field => 'MT::TBPing->visible',
            priority => 3.1,
            updater => {
                type => 'tbping',
                condition => sub { !defined $_[0]->visible },
                code => sub { $_[0]->visible(1) },
                label => 'Assigning visible status for TrackBacks...',
                sql => 'update mt_tbping set tbping_visible = 1
                        where tbping_visible is null',
            }
        },
        'core_init_tbping_junk_status' => {
            on_field => 'MT::TBPing->junk_status',
            priority => 3.1,
            updater => {
                type => 'tbping',
                condition => sub { !defined $_[0]->junk_status },
                code => sub { $_[0]->junk_status(1) },
                label => 'Assigning junk status for TrackBacks...',
                sql => 'update mt_tbping set tbping_junk_status = 1
                        where tbping_junk_status is null',
            }
        },
        'core_init_category_basename' => {
            version_limit => 3.2002,
            priority => 3.1,
            updater => {
                type => 'category',
                condition => sub { !defined $_[0]->basename },
                code => sub { my $cat = shift; my %args = @_;
                    $args{from} < 3.20021
                        ? $cat->basename(mt32_dirify($cat->label))
                        : 1;
                },
                label => 'Assigning basename for categories...',
            }
        },
        'core_set_author_status' => {
            version_limit => 3.301,
            priority => 3.1,
            updater => {
                type => 'author',
                label => 'Assigning user status...',
                condition => sub {
                    ($_[0]->type == 1) && (!defined $_[0]->status)
                },
                code => sub {
                    shift->status(1);
                },
                sql => 'update mt_author set author_status = 1
                        where author_type = 1 and author_status is null',
            }
        },
        'core_install_default_roles' => {
            code => \&create_default_roles,
            on_class => 'MT::Role',
            priority => 3.1,
        },
        'core_migrate_permissions_to_roles' => {
            version_limit => 3.3101,
            priority => 3.2,
            updater => {
                type => 'permission',
                label => 'Migrating permissions to roles...',
                condition => sub { $_[0]->blog_id },
                code => \&_migrate_permission_to_role,
            }
        },
        'core_remove_dynamic_site_bootstrapper' => {
            code => \&remove_mtviewphp,
            version_limit => 3.3101,
            priority => 5.1,
        },
        'core_fix_blob_for_mssqlserver' => {
            code => \&fix_blob_for_mssqlserver,
            version_limit => 4.0002,
            priority => 3.1,
        },
        'core_deprecate_bitmask_permissions' => {
            code => \&deprecate_bitmask_permissions,
            version_limit => 4.0002,
            priority => 3.3,
        },
        'core_migrate_system_privileges' => {
            code => \&migrate_system_privileges,
            version_limit => 4.0002,
            priority => 3.3,
        },
        'core_migrate_commenter_auth' => {
            code => \&migrate_commenter_auth,
            version_limit => 3.3101,
            priority => 3.1,
        },
        'core_populate_authored_on' => {
            version_limit => 4.0014,
            priority => 3.1,
            updater => {
                type => 'entry',
                label => 'Populating authored and published dates for entries...',
                condition => sub {
                    !defined $_[0]->authored_on
                },
                code => sub {
                    $_[0]->authored_on($_[0]->created_on)
                        if !defined $_[0]->authored_on;
                },
                sql =>
                    'update mt_entry set entry_authored_on = entry_created_on
                        where entry_authored_on is null',
            },
        },
        'core_update_3x_system_search_templates' => {
            version_limit => 4.0017,
            priority => 3.1,
            code => \&update_3x_system_search_templates,
        },
        'core_rename_php_plugin_filenames' => {
            version_limit => 4.0019,
            priority => 3.1,
            code => \&rename_php_plugin_filenames,
        },
        'core_migrate_nofollow_settings' => {
            version_limit => 4.0020,
            priority => 3.1,
            code => \&migrate_nofollow_settings,
        },
    };
}

sub migrate_nofollow_settings {
    my $self = shift;

    $self->progress($self->translate_escape("Migrating Nofollow plugin settings..."));
    require MT::PluginData;
    my $cfg = MT->config;
    my $plugins = $cfg->PluginSwitch || {};
    my $nofollow_switch = $plugins->{'nofollow/nofollow.pl'};
    my $enabled = defined $nofollow_switch ? ($nofollow_switch ? 1 : 0) : 1;
    my $default_follow_auth_links = 1;

    # For any configuration settings that exist
    my @config = MT::PluginData->load({ plugin => 'Nofollow' });
    my %blogs_saved;
    foreach my $cfg (@config) {
        if ($cfg->key =~ m/^configuration:blog:(\d+)/) {
            my $blog = MT::Blog->load($1) or next;
            my $setting = ($cfg->data || {})->{follow_auth_links};
            $blog->follow_auth_links($setting) if defined $setting;
            $blog->nofollow_urls($enabled);
            $blog->save;
            $blogs_saved{$blog->id} = 1;
        } else {
            my $setting = ($cfg->data || {})->{follow_auth_links};
            $default_follow_auth_links = $setting if defined $setting;
        }
    }
    $_->remove for @config;

    my $blog_iter = MT::Blog->load_iter;
    while (my $blog = $blog_iter->()) {
        next if exists $blogs_saved{$blog->id};
        $blog->nofollow_urls($enabled);
        $blog->follow_auth_links($default_follow_auth_links);
        $blog->save;
    }

    # Forcibly disable nofollow plugin now since this has become
    # a core function.
    $cfg->PluginSwitch('nofollow/nofollow.pl=0', 1);
    $cfg->save_config();

    return 0;
}

sub update_3x_system_search_templates {
    my $self = shift;

    require MT::Template;
    $self->progress($self->translate_escape('Updating system search template records...'));
    my $tmpl_iter = MT::Template->load_iter({
        type => 'search_template',
    });
    my %blogs;
    while (my $tmpl = $tmpl_iter->()) {
        $blogs{$tmpl->blog_id} = $tmpl->id;
        $tmpl->type('search_results');
        $tmpl->save;
    }
    # for any old 'search_template' system templates, remove the
    # newly installed 'search_results' template.
    foreach my $blog_id (keys %blogs) {
        my $tmpl = MT::Template->load({ type => 'search_results',
            blog_id => $blog_id, id => $blogs{$blog_id} }, {
            not => { id => 1 } });
        $tmpl->remove if $tmpl;
    }
    0;
}

my $perm_role_names = {
    4096 => 'Blog Administrator',  # administer_blog
    30687 => 'Blog Administrator', # 32767 - 2048(not comment) - 32(reserved) = all permissions in MT3.3
    14303 => 'Blog Administrator', # 16383 - 2048(not comment) - 32(reserved) = all permissions in MT3.2
    2 => 'Writer', # post
    6 => 'Writer (can upload)', # post + upload
    17032 => 'Editor',  # edit_all_posts + edit_tags + edit_categories + rebuild
    17036 => 'Editor (can upload)', # Editor + upload
    144 => 'Designer', # edit_templates + rebuild
    17292 => 'Publisher', # Editor (can upload) + send_notifications
};

{
    my $full_perm_mask = 0;
    my %LegacyPerms = (
        # System-wide permissions
        #[ 2**0, 'administer', 'System Administrator', 2, 'system' ],
        #[ 2**1, 'create_blog', 'Create Blogs', 2, 'system' ],
        #[ 2**2, 'view_log', 'View System Activity Log', 2, 'system' ],
        #[ 2**3, 'manage_plugins', 'Manage Plugins', 'system' ],
 
        # Blog-specific permissions:
        # The order here is the same order they are presented on the
        # role definition screen.
        2**0 => 'comment',# 'Add Comments', 1, 'blog'], 
        2**12 => 'administer_blog',# 'Blog Administrator', 1, 'blog'], 
        2**6 => 'edit_config',# 'Configure Blog', 1, 'blog'], 
        2**3 => 'edit_all_posts',# 'Edit All Entries', 1, 'blog'], 
        2**4 => 'edit_templates',# 'Manage Templates', 1, 'blog'], 
        2**2 => 'upload',# 'Upload File', 1, 'blog'], 
        2**1 => 'post',# 'Create Entry', 1, 'blog'], 
        2**16 => 'edit_assets',# 'Manage Assets', 1, 'blog'],
        2**15 => 'save_image_defaults',# 'Save Image Defaults', 1, 'blog'], 
        2**9 => 'edit_categories',# 'Add/Manage Categories', 1, 'blog'], 
        2**14 => 'edit_tags',# 'Manage Tags', 1, 'blog'], 
        2**10 => 'edit_notifications',# 'Manage Notification List', 1, 'blog'], 
        2**8 => 'send_notifications',# 'Send Notifications', 1, 'blog'], 
        2**13 => 'view_blog_log',# 'View Activity Log', 1, 'blog'], 
        #[ 2**17, 'publish_post', 'Publish Post', 1, 'blog'],
        #[ 2**18, 'manage_feedback', 'Manage Feedback', 1, 'blog'],
        #[ 2**19, 'set_publish_paths', 'Set Publishing Paths', 1, 'blog'],
        #[ 2**20, 'manage_pages', 'Manage Pages', 1, 'blog'],
        # 2**5 == 32 is deprecated; reserved for future use 
        2**7 => 'rebuild',# 'Rebuild Files', 1, 'blog'], 
        # Not a real permission but a denial thereeof; unlisted because it 
        # has no label. 
        2**11 => 'not_comment',# '', 1, 'blog'],
    );


sub _migrate_permission_to_role {
    my $perm = shift;

    return unless $perm->author_id;
    my $user = MT::Author->load($perm->author_id);
    if (!$user) {
        $perm->remove;
        return;
    }
    # Don't bother with non-AUTHOR types
    return unless $user->type == 1;

    my $role_mask = $perm->role_mask;
    $role_mask -= 32 if (32 & $role_mask) == 32; # for permissions before 3.2

    if (!$full_perm_mask) {
        # only consider blog permissions that are supported (exclude
        # now reserved permission bits like 32).
        foreach my $key (keys %LegacyPerms) {
            next if $LegacyPerms{$key} =~ m/^not_/; # skip exclusion permissions
            $full_perm_mask |= $key;
        }
    }

    $role_mask = $full_perm_mask & $role_mask;

    # '0' permission, not used for permissions, just prefs
    return unless $role_mask;

    my $name = MT->translate($perm_role_names->{$role_mask});
    $name ||= MT->translate("Custom ([_1])", $role_mask);
    require MT::Role;
    my $role = MT::Role->load({ name => $name });
    if ($role) {
        if (($role->role_mask != $role_mask) && 
            ((4096 != $role->role_mask) && (30687 != $role_mask))) {
            print STDERR "$role_mask:" . $role->role_mask;
            $role = undef;
        }
    }
    unless ($role) {
        $role = new MT::Role;
        $role->name($name);
        $role->description(MT->translate("This role was generated by Movable Type upon upgrade."));
        $role->role_mask($role_mask);
        $role->save;
    }
    my $blog = MT::Blog->load($perm->blog_id);
    $user->add_role($role, $blog) if $blog;
}

sub _process_masks {
    my $self = shift;
    my ($perm) = @_;

    my $mask = $perm->role_mask;
    next unless $mask;
    my @perms;
    for my $key (keys %LegacyPerms) {
        if (int($mask) & int($key)) {
            if (2 eq $key) { # post
                push @perms, 'create_post', 'publish_post';
            } elsif (64 eq $key) { #edit_config
                push @perms, 'edit_config', 'set_publish_paths', 'manage_feedback';
            } elsif (4096 eq $key) { #adminsiter_blog
                push @perms, 'administer_blog', 'manage_pages';
            } elsif (2048 eq $key) { #not_comment
                $perm->restrictions("'comment'");
            } else {
                push @perms, $LegacyPerms{$key};
            }
        }
    }
    my $perm_str = scalar(@perms) ? "'" . join("','", @perms) . "'" : q();
    $perm->permissions($perm_str);
    $perm->role_mask(0); ## remove legacy permissions
    $perm;
}

sub deprecate_bitmask_permissions {
    my $self = shift;
    
    require MT::Permission;
    my $perm_iter = MT::Permission->load_iter;
    $self->progress($self->translate_escape('Migrating permission records to new structure...'));
    while (my $perm = $perm_iter->()) {
        $self->_process_masks($perm);
        $perm->save;
    }

    require MT::Role;
    my $role_iter = MT::Role->load_iter;
    $self->progress($self->translate_escape('Migrating role records to new structure...'));
    while (my $role = $role_iter->()) {
        $self->_process_masks($role);
        $role->save;
    }
}
}

sub migrate_system_privileges {
    my $self = shift;

    my $author_iter = MT::Author->load_iter({ type => MT::Author::AUTHOR() });
    $self->progress($self->translate_escape('Migrating system level permissions to new structure...'));
    while (my $author = $author_iter->()) {
        my @perms;
        push @perms, 'administer' if $author->column('is_superuser');
        push @perms, 'create_blog' if $author->column('can_create_blog') || $author->column('is_superuser');
        push @perms, 'view_log' if $author->column('can_view_log') || $author->column('is_superuser');
        push @perms, 'manage_plugins' if $author->column('is_superuser');
        if (@perms) {
            require MT::Permission;
            my $perm = MT::Permission->new;
            $perm->author_id($author->id);
            $perm->blog_id(0);
            $perm->permissions("'" . join("','", @perms) . "'");
            $perm->save;
        }
    }
}

sub init {
    my $pkg = shift;
    unless (%classes) {
        my $types = MT->registry('object_types');
        foreach my $type (keys %$types) {
            $classes{$type} = $types->{$type};
        }
    }
    my $fns = MT::Component->registry('upgrade_functions') || [];
    foreach my $fn_set (@$fns) {
        %functions = ( %functions, %{ $fn_set } );
    }
}

# Step execution...

# iterate routines:
#     no parameters, start with offset == 0
#     offset parameter, pass thru
#     if routine returns 0, routine is done
#     if routine returns undef, routine failed
#     if routine returns > 0, that's the new offset

sub run_step {
    my $self = shift;
    my ($step) = @_;
    my ($name, %param) = @$step;

    if (my $fn = $functions{$name}) {
        local $MT::CallbacksEnabled = 0;
        if (my $cond = $fn->{condition}) {
            $cond = MT->handler_to_coderef($cond);
            next unless $cond->($self, %param);
        }
        my %update_params;
        if ($fn->{updater}) {
            %update_params = %{$fn->{updater}};
            $fn->{code} ||= \&core_update_records;
        }
        my $code = $fn->{code} || $fn->{handler};
        $code = MT->handler_to_coderef($code);
        my $result = $code->($self, %param, %update_params, step => $name);
        if ((defined $result) && ($result > 1)) {
            $param{offset} = $result; $result = 1;
            $self->add_step($name, %param);
        }
        return $result;
    } else {
        return $self->error($self->translate_escape("Invalid upgrade function: [_1].", $name));
    }
    0;
}

sub run_callbacks {
    my $self = shift;
    my ($cb, @param) = @_;
    local $MT::CallbacksEnabled = 1;
    MT->run_callbacks('MT::Upgrade::' . $cb, $self, @param);
}

# Main "do" interface for controlling apparatus

sub do_upgrade {
    my $self = shift;
    my (%opt) = @_;

    $self->init;

    my $harnessed = ref $opt{App} && (UNIVERSAL::can($opt{App}, 'add_step'));

    local $App = $opt{App};
    local $DryRun = $opt{DryRun};
    local $SuperUser = $opt{SuperUser} || '';
    local $CLI = $opt{CLI} || '';

    @steps = ();
    if ($opt{Install}) {
        my %init_params = (%{$opt{User}}, %{$opt{Blog}});
        $self->install_database(\%init_params);
    } else {
        $self->upgrade_database();
    }

    # no app is running the show, so we must!
    if (!$harnessed) {
        # set these limits very high since we're running unharnessed
        $MAX_TIME = 10000000;
        $MAX_ROWS = 300;
        my $fn = \%MT::Upgrade::functions;
        my @these_steps = @steps;
        while (@these_steps) {
            my $step = shift @these_steps;
            @steps = ();
            $self->run_step($step);
            if (@steps) {
                push @these_steps, @steps;
                @these_steps = sort { $fn->{$a->[0]}->{priority} <=>
                                      $fn->{$b->[0]}->{priority} } @these_steps;
            }
        }
        return 1;
    } else {
        return \@steps;
    }
}

sub upgrade_database {
    my $self = shift;

    my $config_schema_ver;
    my $schema_ver;
    if ($config_schema_ver = MT->instance->config('SchemaVersion')) {
        my $needs_upgrade;
        $needs_upgrade = 1 if $config_schema_ver < MT->schema_version;
        if (!$needs_upgrade) {
            foreach (@MT::Plugins) {
                $needs_upgrade = 1 if $_->needs_upgrade;
            }
        }
        return 1 unless $needs_upgrade;
        $schema_ver = $config_schema_ver;
    } else {
        $schema_ver = $self->detect_schema_version;
    }

    # this will add steps to upgrade all tables that need it...
    $self->add_step("core_upgrade_begin", from => $schema_ver);
    $self->check_schema;
    $self->add_step('core_upgrade_templates');
    $self->add_step('core_upgrade_end', from => $schema_ver);
    $self->add_step('core_finish');
    1;
}

sub install_database {
    my $self = shift;
    my ($user) = @_;

    # this will add steps to install all tables...
    $self->check_schema;
    # this will populate them...
    $self->add_step('core_seed_database', %$user);
    $self->add_step('core_finish');
    1;
}

sub check_schema {
    my $self = shift;
    my $class;
    foreach my $type (keys %classes) {
        $class = MT->model($type)
            or return $self->error($self->translate_escape("Error loading class [_1].", $type));
        $self->check_type($type);
    }
    1;
}

sub check_type {
    my $self = shift;
    my ($type) = @_;

    my $class = MT->model($type);
    if (my $result = $self->type_diff($type)) {
        if ($result->{fix}) {
            $self->add_step('core_fix_type', type => $type);
        } else {
            $self->add_step('core_add_column', type => $type)
                if $result->{add};
            $self->add_step('core_alter_column', type => $type)
                if $result->{alter};
            $self->add_step('core_drop_column', type => $type)
                if $result->{drop};
        }
    }
    1;
}

sub type_diff {
    my $self = shift;
    my ($type) = @_;

    my $class = MT->model($type) or return;

    my $table = $class->datasource;
    my $defs = $class->column_defs;

    my $ddl = $class->driver->dbd->ddl_class;
    my $db_defs = $ddl->column_defs($class);

    # now, compare $defs and $db_defs;
    # here are the scenarios
    #   1. we find something in $defs that isn't in $db_defs
    #      -- column should be inserted. this may trigger a process
    #   2. we find something in $db_defs that isn't in $defs
    #      -- this is a-ok. user may have added a column.
    #   3. we find a difference between $defs and $db_defs for a field
    #      a. type differs; this may trigger a process
    #      b. type is same, but null property differs; this may
    #         trigger a process
    #      c. type is same, but size differs; this may trigger a process
    #      d. key differs
    #      e. auto differs (auto-increment)
    #   4. table doesn't exist and must be created

    my $fix_class;
    $fix_class = 1 unless defined $db_defs;

    # we're only scanning defined columns; we don't care about
    # columns that are unique to the table.
    my (@cols_to_add, @cols_to_alter, @cols_to_drop);

    if (!$fix_class) {
        my @def_cols = keys %$defs;

        foreach my $col (@def_cols) {
            my $col_def = $defs->{$col};
            next if !defined $col_def;

            $col_def->{name} = $col;

            my $db_def = $db_defs->{$col};

            if (!$db_def) {
                # column is missing altogether; we're going to have to add it
                push @cols_to_add, $col_def;
            } else {
                if (($col_def->{type} eq 'string')
                 && ($db_def->{type} eq 'string')
                 && ($col_def->{size} <= $db_def->{size})) {
                    if (($col_def->{not_null} || 0) != ($db_def->{not_null} || 0)) {
                        push @cols_to_alter, $col_def;
                    }
                } elsif ($ddl->type2db($col_def)
                      ne $ddl->type2db($db_def)) {
                    # types are different
                    # don't bother if the database has sufficient
                    # capacity for this field
                    next if ($db_def->{type} eq 'integer')
                         && ($col_def->{type} eq 'smallint'
                          || $col_def->{type} eq 'boolean');
                    push @cols_to_alter, $col_def;
                } elsif (($col_def->{not_null} || 0) != ($db_def->{not_null} || 0)) {
                    push @cols_to_alter, $col_def;
                }
            }
        }
    }

    if ($fix_class || @cols_to_add || @cols_to_alter || @cols_to_drop) {
        my %param;
        $param{drop} = \@cols_to_drop if @cols_to_drop;
        $param{add} = \@cols_to_add if @cols_to_add;
        $param{alter} = \@cols_to_alter if @cols_to_alter;
        $param{fix} = $fix_class;
        if ((@cols_to_add && !$ddl->can_add_column) ||
            (@cols_to_alter && !$ddl->can_alter_column) || 
            (@cols_to_drop && !$ddl->can_drop_column)) {
            $param{fix} = 1;
        }
        return \%param;
    }
    undef;
}

sub seed_database {
    my $self = shift;
    my (%param) = @_;

    require MT::Author;
    return undef if MT::Author->count;

    $self->progress($self->translate_escape("Creating initial blog and user records..."));

    local $MT::CallbacksEnabled = 1;

    require MT::L10N;
    my $lang = exists $param{user_lang} ? $param{user_lang} : MT->config->DefaultLanguage;
    my $LH = MT::L10N->get_handle($lang);

    # TBD: parameter for username/password provided by user from $app
    use URI::Escape;
    my $author = MT::Author->new;
    $author->name(exists $param{user_name} ? uri_unescape($param{user_name}) : 'Melody');
    $author->type(MT::Author::AUTHOR());
    $author->set_password(exists $param{user_password} ? uri_unescape($param{user_password}) : 'Nelson');
    $author->email(exists $param{user_email} ? uri_unescape($param{user_email}) : '');
    $author->hint(exists $param{user_hint} ? uri_unescape($param{user_hint}) : '');
    $author->nickname(exists $param{user_nickname} ? uri_unescape($param{user_nickname}) : '');
    $author->is_superuser(1);
    $author->can_create_blog(1);
    $author->can_view_log(1);
    $author->can_manage_plugins(1);
    $author->preferred_language($lang);
    $author->external_id(MT::Author->pack_external_id($param{user_external_id})) if exists $param{user_external_id};
    $author->save or return $self->error($self->translate_escape("Error saving record: [_1].", $author->errstr));
    $App->{author} = $author if ref $App;

    $self->create_default_roles(%param);

    require MT::Blog;
    my $blog = MT::Blog->create_default_blog($LH->maketext('First Blog'))
        or return $self->error($self->translate_escape("Error saving record: [_1].", MT::Blog->errstr));
    $blog->site_path(exists $param{blog_path} ? uri_unescape($param{blog_path}) : '');
    $blog->site_url(exists $param{blog_url} ? uri_unescape($param{blog_url}) : '');
    $blog->name(exists $param{blog_name} ? uri_unescape($param{blog_name}) : '');
    $blog->server_offset(exists $param{blog_timezone} ? ($param{blog_timezone} || 0) : 0);
    $blog->save;

    # Create an initial entry and comment for this blog
    require MT::Entry;
    my $entry = MT::Entry->new;
    $entry->blog_id($blog->id);
    $entry->title($LH->maketext("I just finished installing Movable Type 4!"));
    $entry->text($LH->maketext("Welcome to my new blog powered by Movable Type 4. This is the first post on my blog and was created for me automatically when I finished the installation process. But that is ok, because I will soon be creating posts of my own!"));
    $entry->author_id($author->id);
    $entry->status(MT::Entry::RELEASE());
    $entry->save
        or return $self->error($self->translate_escape("Error saving record: [_1].", MT::Entry->errstr));

    require MT::Comment;
    my $comment = MT::Comment->new;
    $comment->entry_id($entry->id);
    $comment->blog_id($blog->id);
    $comment->text($LH->maketext("Movable Type also created a comment for me as well so that I could see what a comment will look like on my blog once people start submitting comments on all the posts I will write."));
    $comment->visible(1);
    $comment->junk_status(1);
    $comment->save
        or return $self->error($self->translate_escape("Error saving record: [_1].", MT::Comment->errstr));

    # TBD: change to use association methods...
    require MT::Permission;
    my $perms = MT::Permission->new;
    $perms->author_id($author->id);
    $perms->blog_id($blog->id);
    $perms->set_full_permissions();
    $perms->save or return $self->error($self->translate_escape("Error saving record: [_1].", $perms->errstr));

    1;
}

## Translation
# translate('Blog Administrator')
# translate('Can administer the blog.')
# translate('Editor')
# translate('Can upload files, edit all entries/categories/tags on a blog and rebuild.')
# translate('Author')
# translate('Can create entries, edit their own, upload files and publish.')
# translate('Designer')
# translate('Can edit, manage and rebuild blog templates.')
# translate('Webmaster')
# translate('Can manage pages and rebuild blog templates.')
# translate('Contributor')
# translate('Can create entries, edit their own and comment.')
# translate('Moderator')
# translate('Can comment and manage feedback.')
# translate('Commenter')
# translate('Can comment.')

sub create_default_roles {
    my $self = shift;
    my (%param) = @_;

    my @default_roles = (
        { name => 'Blog Administrator',
          description => 'Can administer the blog.',
          role_mask => 2**12,
          perms => ['administer_blog'] },
        { name => 'Editor',
          description => 'Can upload files, edit all entries/categories/tags on a blog and rebuild.',
          perms => ['comment', 'create_post', 'publish_post', 'edit_all_posts', 'edit_categories', 'edit_tags', 'manage_pages',
                    'rebuild', 'upload', 'send_notifications', 'manage_feedback'], },
        { name => 'Author',
          description => 'Can create entries, edit their own, upload files and publish.',
          perms => ['comment', 'create_post', 'publish_post', 'upload', 'send_notifications'], },
        { name => 'Designer',
          description => 'Can edit, manage and rebuild blog templates.',
          role_mask => (2**4 + 2**7),
          perms => ['edit_templates', 'rebuild'] },
        { name => 'Webmaster',
          description => 'Can manage pages and rebuild blog templates.',
          perms => ['manage_pages', 'rebuild'] },
        { name => 'Contributor',
          description => 'Can create entries, edit their own and comment.',
          perms => ['comment', 'create_post'], },
        { name => 'Moderator',
          description => 'Can comment and manage feedback.',
          perms => ['comment', 'manage_feedback'], },
        { name => 'Commenter',
          description => 'Can comment.',
          role_mask => 2**0,
          perms => ['comment'], },
    );

    require MT::Role;
    return if MT::Role->count();

    foreach my $r (@default_roles) {
        my $role = MT::Role->new();
        $role->name(MT->translate($r->{name}));
        $role->description(MT->translate($r->{description}));
        $role->clear_full_permissions;
        $role->set_these_permissions($r->{perms});
        if ($r->{name} =~ m/^System/) {
            $role->is_system(1);
        }
        $role->role_mask($r->{role_mask}) if exists $r->{role_mask};
        $role->save;
    }

    1;
}

sub remove_mtviewphp {
    my $self = shift;
    my (%param) = @_;

    require MT::Template;
    $self->progress($self->translate_escape('Removing Dynamic Site Bootstrapper index template...'));
    MT::Template->remove( { type => 'index', outfile => 'mtview.php' } );
    1;
}

sub fix_blob_for_mssqlserver {
    my $self = shift;
    my (%param) = @_;

    my $driver = MT::Object->driver;
    return unless $driver =~ /MSSQLServer/i;

    $self->progress($self->translate_escape('Fixing binary data for Microsoft SQL Server storage...'));

    require MT::Session;
    my $sess_iter = MT::Session->load_iter();
    while (my $sess_obj = $sess_iter->()) {
        $sess_obj->data(pack('H*', $sess_obj->data)) if defined $sess_obj->data;
        $sess_obj->save;
    }

    require MT::PluginData;
    my $pd_iter = MT::PluginData->load_iter();
    while (my $pd_obj = $pd_iter->()) {
        $pd_obj->data(pack('H*', $pd_obj->data)) if defined $pd_obj->data;
        $pd_obj->save;
    }

    1;
}

sub migrate_commenter_auth {
    my ($self) = shift;
    my (%param) = @_;

    my $iter = MT::Blog->load_iter({ 'allow_reg_comments' => 1 });
    while (my $blog = $iter->()) {
        $blog->commenter_authenticators('TypeKey') if $blog->remote_auth_token;
        $blog->save;
    }
    1;
}

sub upgrade_templates {
    my $self = shift;
    my (%opt) = @_;

    my $install = $opt{Install} || 0;

    my $updated = 0;

    my $tmpl_list;
    require MT::DefaultTemplates;
    $tmpl_list = MT::DefaultTemplates->templates || [];

    my $mt = MT->instance;
    my @arch_tmpl;

    require MT::Template;
    require MT::Blog;

    for my $val (@$tmpl_list) {
        if (!$install) {
            next if $val->{type} =~ m/^(archive|individual|page|category|index|custom)$/;
        }

        $val->{name} = $mt->translate($val->{name});
        $val->{text} = $mt->translate_templatized($val->{text});

        my $terms = {};
        $terms->{type} = $val->{type};
        $terms->{name} = $val->{name}
            if $val->{type} =~ m/^(archive|individual|page|category|index|custom)$/;
        my @exists = MT::Template->load( $terms,
                                         { limit => 1 } );
        next if @exists;

        $self->progress($self->translate_escape("Creating new template: '[_1]'.", $val->{name}));

        my $iter = MT::Blog->load_iter();
        while (my $blog = $iter->()) {
            my $obj = MT::Template->new;
            $obj->build_dynamic(0);
            foreach my $v (keys %$val) {
                $obj->column($v, $val->{$v}) if $obj->has_column($v);
            }
            $obj->blog_id($blog->id);
            $obj->save or return $self->error($self->translate_escape("Error saving record: [_1].", $obj->errstr));
            $updated = 1;
            if ($val->{type} eq 'archive' || $val->{type} eq 'individual' ||
                $val->{type} eq 'page' || $val->{type} eq 'category') {
                push @arch_tmpl, $obj;
            }
        }
    }

    if (@arch_tmpl) {
        $self->progress($self->translate_escape("Mapping templates to blog archive types..."));
        require MT::TemplateMap;
    
        for my $tmpl (@arch_tmpl) {
            my(@at);
            if ($tmpl->type eq 'archive') {
                @at = qw( Daily Weekly Monthly Category-Monthly Author-Monthly Category );
            } elsif ($tmpl->type eq 'individual') {
                @at = qw( Individual );
            } elsif ($tmpl->type eq 'page') {
                @at = qw( Page );
            }
            for my $at (@at) {
                my $map = MT::TemplateMap->new;
                $map->archive_type($at);
                $map->is_preferred(1);
                $map->template_id($tmpl->id);
                $map->blog_id($tmpl->blog_id);
                $map->save or return $self->error($self->translate_escape("Error saving record: [_1].", $map->errstr));
            }
        }
    }

    $updated;
}

sub rename_php_plugin_filenames {
    my $self = shift;

    my $server_path = MT->instance->server_path() || '';
    $server_path =~ s/\/*$//;
    my $plugin_path = File::Spec->canonpath("$server_path/php/plugins");

    $self->progress($self->translate_escape('Renaming php plugin file names...'));
    opendir(DIR, $plugin_path)
        or return $self->error($self->translate_escape("Error opening directory: [_1].", $plugin_path));
    my @files = grep { /^(?:function|block)\.(.*)\.php$/ } readdir(DIR);
    closedir(DIR);

    my @error_files = ();
    for my $file (@files) {
        my $newfile = lc $file;
        next if $file eq $newfile;
        if (!rename("$plugin_path/$file", "$plugin_path/$newfile")) {
            push @error_files, $file;
        }
    }
    if ($#error_files >= 0) {
        $self->progress($self->translate_escape('Error rename php files. Please check the Activity Log'));
        MT->log(
            {
                message => $self->translate_escape("Cannot rename in [_1]: [_2].", $plugin_path, join(', ', @error_files)),
                level   => MT::Log::ERROR(),
                category => 'upgrade',
            }
        );
    }
    1;
}

###  Upgrade triggers

# we don't need these yet, but it makes me feel good to have them around

# 'pre' triggers should execute quickly. 'post' triggers can add steps
# if they require processing that will take time to complete.

sub pre_upgrade_class { 1 }
sub post_upgrade_class { 1 }
sub pre_alter_column { 1 }
sub post_alter_column { 1 }
sub pre_drop_column { 1 }
sub post_drop_column { 1 }
sub pre_add_column { 1 }
sub pre_schema_upgrade { 1 }

# issued last, after all table creation...

sub post_schema_upgrade {
    my $self = shift;
    my ($from) = @_;

    my $plugin_ver = MT->config('PluginSchemaVersion') || {};

    # run any functions that define a version_limit and where the schema we're
    # upgrading from is below that limit.
    foreach my $fn (keys %functions) {
        my $save_from = $from;
        {
            my $func = $functions{$fn};
            if ($func->{plugin_sig}) {
                $from = $plugin_ver->{$func->{plugin_sig}} || 0;
            }
            if ($func->{version_limit} && ($from < $func->{version_limit})) {
                $self->add_step($fn, from => $from);
            }
        }
        $from = $save_from;
    }

    1;
}

sub pre_create_table {
    my $self = shift;
    my ($class) = @_;
    $class->driver->dbd->ddl_class->drop_sequence($class);
}

sub post_create_table {
    my $self = shift;
    my ($class) = @_;

    $class->driver->dbd->ddl_class->create_sequence($class);

    if (!$Installing) {
        foreach (keys %functions) {
            my $func = $functions{$_};
            next unless $func->{on_class};
            $self->add_step($_) if $func->{on_class} eq $class;
        }
    }

    1;
}

# Note that this trigger only fires on BerkeleyDB for columns
# that are non-null or indexed.

sub post_add_column {
    my $self = shift;
    my ($class, $col_defs) = @_;

    if (!$Installing) {
        my %cols = map { $_->{name} => 1 } @$col_defs;
        foreach (keys %functions) {
            my $func = $functions{$_};
            next unless $func->{on_field};
            if ($func->{on_field} =~ m/^\Q$class\E->(.*)/) {
                $self->add_step($_) if $cols{$1};
            }
        }
    }
    1;
}

# Passthru routines-- passing to calling application...

sub progress {
    my $self = shift;
    $App->progress(@_) if $App;
}

sub translate_escape {
    my $self = shift;
    my $trans = MT->translate(@_);
    return $trans if $CLI;
    $trans = MT::I18N::encode_text($trans, undef, 'utf-8');
    return MT::Util::escape_unicode($trans);
}

sub error {
    my $self = shift;
    my ($msg) = @_;
    $App->error(@_) if $App;
    return undef;
}

sub add_step {
    my $self = shift;
    if ($App && (ref $App)) {
        $App->add_step(@_);
    } else {
        push @steps, [ @_ ];
    }
}

# Misc utilities.

sub detect_schema_version {
    my $self = shift;

    require MT::Object;
    my $driver = MT::Object->driver;

    require MT::Config;
    if ($driver->table_exists('MT::Config')) {
        return 3.2;
    }

    require MT::Template;
    my $dyn_error_template = 
        MT::Template->count({type => 'dynamic_error'});
    if ($dyn_error_template) {
        return 3.1;
    }

    my $comment_pending_template =
        MT::Template->count({type => 'comment_pending'});
    if ($comment_pending_template) {
        return 3.0;
    }

    require MT::TemplateMap;
    if ($driver->table_exists('MT::TemplateMap')) {
        return 2.0;
    }

    1.0;
}

# A note about upgrade routines:
#
# They should all be 'safe' to execute, regardless of the
# active schema. In other words, running them twice in a row
# should not cause any errors or break the schema.

sub core_fix_type {
    my $self = shift;
    my (%param) = @_;

    my $type = $param{type};
    my $class = MT->model($type);

    my $result = $self->type_diff($type);
    return 1 unless $result;
    return 1 unless $result->{fix};

    my $alter = $result->{alter};
    my $add = $result->{add};
    my $drop = $result->{drop};

    my $driver = $class->driver;
    my $ddl = $driver->dbd->ddl_class;
    my @stmts;
    push @stmts, sub { $self->pre_upgrade_class($class) };
    push @stmts, $ddl->upgrade_begin($class);
    push @stmts, sub { $self->pre_create_table($class) };
    push @stmts, sub { $self->pre_add_column($class, $add) } if $add;
    push @stmts, sub { $self->pre_alter_column($class, $alter) } if $alter;
    push @stmts, sub { $self->pre_drop_column($class, $drop) } if $drop;
    push @stmts, $ddl->fix_class($class);
    push @stmts, sub { $self->post_create_table($class) };
    push @stmts, sub { $self->post_add_column($class, $add) } if $add;
    push @stmts, sub { $self->post_alter_column($class, $alter) } if $alter;
    push @stmts, sub { $self->post_drop_column($class, $drop) } if $drop;
    push @stmts, $ddl->upgrade_end($class);
    push @stmts, sub { $self->post_upgrade_class($class) };
    $self->run_statements($class, @stmts);
}

sub core_column_action {
    my $self = shift;
    my ($action, %param) = @_;

    my $type = $param{type};
    my $class = MT->model($type);
    my $defs = $class->column_defs;

    my $result = $self->type_diff($type);
    return 1 unless $result;
    my $columns = $result->{$action};
    return 1 unless $columns;

    my $pre_method = "pre_${action}_column";
    my $post_method = "post_${action}_column";
    my $method = "${action}_column";

    my $driver = $class->driver;
    my $ddl = $driver->dbd->ddl_class;
    my @stmts;
    push @stmts, sub { $self->pre_upgrade_class($class) };
    push @stmts, $ddl->upgrade_begin($class);
    push @stmts, sub { $self->$pre_method($class, $columns) };
    push @stmts, $ddl->$method($class, $_->{name}) foreach @$columns;
    push @stmts, sub { $self->$post_method($class, $columns) };
    push @stmts, $ddl->upgrade_end($class);
    push @stmts, sub { $self->post_upgrade_class($class) };
    $self->run_statements($class, @stmts);
}

sub run_statements {
    my $self = shift;
    my ($class, @stmts) = @_;

    my $driver = $class->driver;
    my $defs = $class->column_defs;
    my $dbh = $driver->rw_handle;
    my $mt = MT->instance;

    my $updated = 0;
    if (@stmts) {
        $self->progress($self->translate_escape("Upgrading table for [_1]", $class));
        eval {
            foreach my $stmt (@stmts) {
                if (ref $stmt eq 'CODE') {
                    $stmt->() if !$DryRun;
                } else {
                    if ($dbh && !$DryRun) {
                        my $err;
                        $dbh->do($stmt) or $err = $dbh->errstr;
                        if ($err) {
                            # ignore drop errors; the table/sequence didn't exist
                            if ($stmt !~ m/^drop /i) {
                                die "failed to execute statement $stmt: $err";
                            }
                        }
                    } elsif ($dbh && $DryRun) {
                        $self->run_callbacks('SQL', $stmt);
                    }
                }
                $updated = 1;
            }
        };
        if ($@) {
            return $self->error($@);
        }
    }
    $updated;
}

sub core_upgrade_begin {
    my $self = shift;
    my (%param) = @_;
    my $from_schema = $param{from};
    if ($from_schema) {
        my $cur_schema = MT->schema_version;
        $self->progress($self->translate_escape("Upgrading database from version [_1].", $from_schema)) if $from_schema < $cur_schema;
        $self->pre_schema_upgrade($from_schema);
    }
}

sub core_upgrade_end {
    my $self = shift;
    my (%param) = @_;

    my $from_schema = $param{from};
    if ($from_schema) {
        $self->post_schema_upgrade($from_schema);
    }
    1;
}

sub core_finish {
    my $self = shift;

    my $user;
    if ((ref $App) && ($App->{author})) {
        $user = $App->{author};
    }

    my $cfg = MT->config;
    my $cur_schema = MT->instance->schema_version;
    my $old_schema = $cfg->SchemaVersion || 0;
    if ($cur_schema > $old_schema) {
        $self->progress($self->translate_escape("Database has been upgraded to version [_1].", $cur_schema)) ;
        if ($user && !$DryRun) {
            MT->log(MT->translate("User '[_1]' upgraded database to version [_2]", $user->name, $cur_schema));
        }
        $cfg->SchemaVersion( $cur_schema, 1 );
    }

    my $plugin_schema = $cfg->PluginSchemaVersion || {};
    foreach my $plugin (@MT::Plugins) {
        my $ver = $plugin->schema_version;
        next unless $ver;
        my $old_plugin_schema = $plugin_schema->{$plugin->{plugin_sig}} || 0;
        if ($old_plugin_schema && ($ver > $old_plugin_schema)) {
            $self->progress($self->translate_escape("Plugin '[_1]' upgraded successfully to version [_2] (schema version [_3]).", $plugin->label, $plugin->version || '-', $ver));
            if ($user && !$DryRun) {
                MT->log(MT->translate("User '[_1]' upgraded plugin '[_2]' to version [_3] (schema version [_4]).", $user->name, $plugin->label, $plugin->version || '-', $ver));
            }
        } elsif ($ver && !$old_plugin_schema) {
            $self->progress($self->translate_escape("Plugin '[_1]' installed successfully.", $plugin->label));
            if ($user && !$DryRun) {
                MT->log(MT->translate("User '[_1]' installed plugin '[_2]', version [_3] (schema version [_4]).", $user->name, $plugin->label, $plugin->version || '-', $ver));
            }
        }
        $plugin_schema->{$plugin->id} = $ver;
    }
    if (keys %$plugin_schema) {
        $cfg->PluginSchemaVersion($plugin_schema, 1);
    }
    $cfg->save_config unless $DryRun;

    # do one last thing....
    if ((ref $App) && ($App->can('finish'))) {
        $App->finish();
    }

    1;
}

sub core_set_superuser {
    my $self = shift;

    my $app = $App;
    my $author;
    if ((ref $app) && ($app->{author})) {
        require MT::Author;
        $self->progress($self->translate_escape("Setting your permissions to administrator."));
        $author = MT::Author->load($app->{author}->id);
    } elsif ($SuperUser) {
        require MT::Author;
        $self->progress($self->translate_escape("Setting your permissions to administrator."));
        $author = MT::Author->load($SuperUser);
    }

    if ($author) {
        $author->is_superuser(1);
        $author->save or return $self->error($self->translate_escape("Error saving record: [_1].", $author->errstr));
    }

    1;
}

sub core_remove_unique_constraints {
    my $self = shift;

    my $driver = MT::Object->driver;
    if (ref $driver->dbd =~ m/::Pg$/) {
        # category, author, permission, template
        $driver->sql([
            'alter table mt_category drop constraint mt_category_category_blog_id_key',
            'create index mt_category_label on mt_category (category_label)',

            'alter table mt_author drop constraint mt_author_author_name_key',
            'create index mt_author_name on mt_author (author_name)',
            'alter table mt_permission drop constraint mt_permission_permission_blog_id_key',
            'create index mt_permission_blog_id on mt_permission (permission_blog_id)',
            'alter table mt_template drop constraint mt_template_template_blog_id_key',
            'create index mt_template_blog_id on mt_template (template_blog_id)'
        ]);
    } elsif (ref $driver->dbd =~ m/::mysql$/) {
        $driver->sql([
            'alter table mt_category drop index category_blog_id',
            'create index category_blog_id on mt_category (category_blog_id)',
            'create index category_label on mt_category (category_label)',
            'alter table mt_author drop index author_name',
            'create index author_name on mt_author (author_name)',
            'alter table mt_permission drop index permission_blog_id',
            'create index permission_blog_id on mt_permission (permission_blog_id)',
            'alter table mt_template drop index template_blog_id',
            'create index template_blog_id on mt_template (template_blog_id)'
        ]);
    }
    1;
}

sub core_create_config_table {
    my $self = shift;

    require MT::Config;
    my $config = MT::Config->load();
    if (!$config) {
        #$self->progress($self->translate_escape("Creating configuration record."));
        $config = MT::Config->new;
        $config->data('');
        $config->save or return $self->error($self->translate_escape("Error saving record: [_1].", $config->errstr));
    }
    return 1;
}

sub core_set_enable_archive_paths {
    my $self = shift;
    MT->config->EnableArchivePaths(1, 1);
    return 1;
}

sub core_create_template_maps {
    my $self = shift;
    my (%param) = @_;
    
    my $offset = $param{offset};
    require MT::Template;
    require MT::TemplateMap;
    require MT::Blog;

    my $msg = $self->translate_escape("Creating template maps...");
    if ($offset) {
        my $count = MT::Template->count;
        return 1 unless $count;
        $self->progress(sprintf("$msg (%d%%)", ($offset / $count * 100)), 1);
    } else {
        $self->progress($msg, 1);
    }

    my $iter = MT::Template->load_iter(undef, { offset => $offset, limit => $MAX_ROWS+1 });
    my $start = time;
    my $continue = 0;
    my $count = 0;
    while (my $tmpl = $iter->()) {
        $offset++;
        my $blog = MT::Blog->load($tmpl->blog_id);
        my(@at);
        if ($tmpl->type eq 'archive') {
            @at = qw( Daily Weekly Monthly );
        } elsif ($tmpl->type eq 'category') {
            @at = ('Category');
        } elsif ($tmpl->type eq 'page') {
            @at = ('Page');
        } elsif ($tmpl->type eq 'individual') {
            @at = ('Individual');
        } else {
            next;
        }
        for my $at (@at) {
            my $meth = 'archive_tmpl_' . lc($at);
            my $file_tmpl = $blog->$meth();
            my $existing = MT::TemplateMap->load({ blog_id => $blog->id,
                archive_type => $at, template_id => $tmpl->id });
            if (!$existing) {
                my $map = MT::TemplateMap->new;
                if ($file_tmpl) {
                    $self->progress($self->translate_escape("Mapping template ID [_1] to [_2] ([_3]).", $tmpl->id, $at, $file_tmpl));
                    $map->file_template($file_tmpl);
                } else {
                    $self->progress($self->translate_escape("Mapping template ID [_1] to [_2].", $tmpl->id, $at));
                }
                $map->archive_type($at);
                $map->is_preferred(1);
                $map->template_id($tmpl->id);
                $map->blog_id($tmpl->blog_id);
                $map->save or return $self->error($self->translate_escape("Error saving record: [_1].", $map->errstr));
            }
        }
        $count++;
        $continue = 1, last if $count == $MAX_ROWS;
        $continue = 1, last if time > $start + $MAX_TIME;
    }
    if ($continue) {
        $iter->('finish');
        return $offset;
    } else {
        $self->progress("$msg (100%)", 1);
    }
    1;
}

sub core_update_records {
    my $self = shift;
    my (%param) = @_;

    my $class = MT->model($param{type});
    return $self->error($self->translate_escape("Error loading class: [_1].", $param{type}))
        unless $class;

    my $msg;
    my $class_label = ($class->can('class_label') ? $class->class_label : $class);
    if ($param{label}) {
        $msg = $param{label};
        if (ref $msg eq 'CODE') {
            $msg = $msg->($class_label);
        }
    } else {
        $msg = $self->translate_escape($param{message} || "Updating [_1] records...", $class_label);
    }
    my $offset = $param{offset};
    if ($offset) {
        my $count = $class->count;
        return unless $count;
        $self->progress(sprintf("$msg (%d%%)", ($offset/$count*100)), $param{step});
    } else {
        $self->progress($msg, $param{step});
    }

    my $cond = $param{condition};
    my $code = $param{code};
    my $sql = $param{sql};

    my $continue = 0;
    my $driver = $class->driver;

    if ($sql && $DryRun) {
        $self->run_callbacks('SQL', $sql);
    }
    return 1 if $DryRun;

    if (!$sql || !$driver->sql($sql)) {
        my $iter= $class->load_iter(undef, { offset => $offset, limit => $MAX_ROWS+1 });
        my $start = time;
        my @list;
        while (my $obj = $iter->()) {
            push @list, $obj;
            $continue = 1, last if scalar @list == $MAX_ROWS;
        }
        $iter->('finish') if $continue;
        for my $obj (@list) {
            $offset++;
            if ($cond) {
                next unless $cond->($obj, %param);
            }
            $code->($obj);
            $obj->save()
                or return $self->error($self->translate_escape("Error saving record: [_1].", $obj->errstr));
            $continue = 1, last if time > $start + $MAX_TIME;
        }
    }
    if ($continue) {
        return $offset;
    } else {
        $self->progress("$msg (100%)", $param{step});
    }
    1;
}

#############################################################################

{
    my %HighASCII = (
        "\xc0" => 'A',    # A`
        "\xe0" => 'a',    # a`
        "\xc1" => 'A',    # A'
        "\xe1" => 'a',    # a'
        "\xc2" => 'A',    # A^
        "\xe2" => 'a',    # a^
        "\xc4" => 'Ae',   # A:
        "\xe4" => 'ae',   # a:
        "\xc3" => 'A',    # A~
        "\xe3" => 'a',    # a~
        "\xc8" => 'E',    # E`
        "\xe8" => 'e',    # e`
        "\xc9" => 'E',    # E'
        "\xe9" => 'e',    # e'
        "\xca" => 'E',    # E^
        "\xea" => 'e',    # e^
        "\xcb" => 'Ee',   # E:
        "\xeb" => 'ee',   # e:
        "\xcc" => 'I',    # I`
        "\xec" => 'i',    # i`
        "\xcd" => 'I',    # I'
        "\xed" => 'i',    # i'
        "\xce" => 'I',    # I^
        "\xee" => 'i',    # i^
        "\xcf" => 'Ie',   # I:
        "\xef" => 'ie',   # i:
        "\xd2" => 'O',    # O`
        "\xf2" => 'o',    # o`
        "\xd3" => 'O',    # O'
        "\xf3" => 'o',    # o'
        "\xd4" => 'O',    # O^
        "\xf4" => 'o',    # o^
        "\xd6" => 'Oe',   # O:
        "\xf6" => 'oe',   # o:
        "\xd5" => 'O',    # O~
        "\xf5" => 'o',    # o~
        "\xd8" => 'Oe',   # O/
        "\xf8" => 'oe',   # o/
        "\xd9" => 'U',    # U`
        "\xf9" => 'u',    # u`
        "\xda" => 'U',    # U'
        "\xfa" => 'u',    # u'
        "\xdb" => 'U',    # U^
        "\xfb" => 'u',    # u^
        "\xdc" => 'Ue',   # U:
        "\xfc" => 'ue',   # u:
        "\xc7" => 'C',    # ,C
        "\xe7" => 'c',    # ,c
        "\xd1" => 'N',    # N~
        "\xf1" => 'n',    # n~
        "\xdf" => 'ss',
    );
    my $HighASCIIRE = join '|', keys %HighASCII;
    sub mt32_convert_high_ascii {
        my($s) = @_;
        $s =~ s/($HighASCIIRE)/$HighASCII{$1}/g;
        $s;
    }
}

sub mt32_iso_dirify {
    my $s = $_[0];
    my $sep;
    if ($_[1] && ($_[1] ne '1')) {
        $sep = $_[1];
    } else {
        $sep = '_';
    }
    $s = mt32_convert_high_ascii($s);  ## convert high-ASCII chars to 7bit.
    $s = lc $s;                   ## lower-case.
    $s = MT::Util::remove_html($s);         ## remove HTML tags.
    $s =~ s!&[^;\s]+;!!g;         ## remove HTML entities.
    $s =~ s![^\w\s]!!g;           ## remove non-word/space chars.
    $s =~ s! +!$sep!g;             ## change space chars to underscores.
    $s;    
}

sub mt32_utf8_dirify {
    my $s = $_[0];
    my $sep;
    if ($_[1] && ($_[1] ne '1')) {
        $sep = $_[1];
    } else {
        $sep = '_';
    }
    $s = mt32_xliterate_utf8($s);      ## convert two-byte UTF-8 chars to 7bit ASCII
    $s = lc $s;                   ## lower-case.
    $s = MT::Util::remove_html($s);         ## remove HTML tags.
    $s =~ s!&[^;\s]+;!!g;         ## remove HTML entities.
    $s =~ s![^\w\s]!!g;           ## remove non-word/space chars.
    $s =~ s! +!$sep!g;             ## change space chars to underscores.
    $s;    
}

sub mt32_dirify {
    ($MT::VERSION && MT->instance->{cfg}->PublishCharset =~ m/utf-?8/i)
        ? mt32_utf8_dirify(@_) : mt32_iso_dirify(@_);
}

sub mt32_xliterate_utf8 {
    my ($str) = @_;
    my %utf8_table = (
          "\xc3\x80" => 'A',    # A`
          "\xc3\xa0" => 'a',    # a`
          "\xc3\x81" => 'A',    # A'
          "\xc3\xa1" => 'a',    # a'
          "\xc3\x82" => 'A',    # A^
          "\xc3\xa2" => 'a',    # a^
          "\xc3\x84" => 'Ae',   # A:
          "\xc3\xa4" => 'ae',   # a:
          "\xc3\x83" => 'A',    # A~
          "\xc3\xa3" => 'a',    # a~
          "\xc3\x88" => 'E',    # E`
          "\xc3\xa8" => 'e',    # e`
          "\xc3\x89" => 'E',    # E'
          "\xc3\xa9" => 'e',    # e'
          "\xc3\x8a" => 'E',    # E^
          "\xc3\xaa" => 'e',    # e^
          "\xc3\x8b" => 'Ee',   # E:
          "\xc3\xab" => 'ee',   # e:
          "\xc3\x8c" => 'I',    # I`
          "\xc3\xac" => 'i',    # i`
          "\xc3\x8d" => 'I',    # I'
          "\xc3\xad" => 'i',    # i'
          "\xc3\x8e" => 'I',    # I^
          "\xc3\xae" => 'i',    # i^
          "\xc3\x8f" => 'Ie',   # I:
          "\xc3\xaf" => 'ie',   # i:
          "\xc3\x92" => 'O',    # O`
          "\xc3\xb2" => 'o',    # o`
          "\xc3\x93" => 'O',    # O'
          "\xc3\xb3" => 'o',    # o'
          "\xc3\x94" => 'O',    # O^
          "\xc3\xb4" => 'o',    # o^
          "\xc3\x96" => 'Oe',   # O:
          "\xc3\xb6" => 'oe',   # o:
          "\xc3\x95" => 'O',    # O~
          "\xc3\xb5" => 'o',    # o~
          "\xc3\x98" => 'Oe',   # O/
          "\xc3\xb8" => 'oe',   # o/
          "\xc3\x99" => 'U',    # U`
          "\xc3\xb9" => 'u',    # u`
          "\xc3\x9a" => 'U',    # U'
          "\xc3\xba" => 'u',    # u'
          "\xc3\x9b" => 'U',    # U^
          "\xc3\xbb" => 'u',    # u^
          "\xc3\x9c" => 'Ue',   # U:
          "\xc3\xbc" => 'ue',   # u:
          "\xc3\x87" => 'C',    # ,C
          "\xc3\xa7" => 'c',    # ,c
          "\xc3\x91" => 'N',    # N~
          "\xc3\xb1" => 'n',    # n~
          "\xc3\x9f" => 'ss',   # double-s
    );
    
    $str =~ s/([\200-\377]{2})/$utf8_table{$1}||''/ge;
    $str;
}

1;
__END__

=head1 NAME

MT::Upgrade - MT class for managing system upgrades.

=head1 SYNOPSIS

    MT::Upgrade->do_upgrade(Install => 1);

=head1 DESCRIPTION

This module is responsible for handling the upgrade or installation of
an MT database. The framework is flexible enough for third party plugins
to use as well to manage their own schema (please refer to the documentation
in L<MT::Plugin> for more information on this).

=head1 METHODS

=head2 MT::Upgrade-E<gt>do_upgrade

The main worker method for this module is I<do_upgrade>. It accepts a
handful of arguments, which are:

=over 4

=item * Install

Specify a value of '1' to assume a new installation along with an operation
to install a blog and initial user.

=item * App

A package name or app object that can service the following methods:

=over 4

=item * progress($package, $message)

Called during the upgrade operation to provide feedback with respect to
the operations the upgrade process is running.

=item * error($package, $message)

Called during the upgrade operation to communicate an error that has
occurred.

=item * translate_escape

Call this method to translate messages and phrases which are to appear
on the progress screen.  DO NOT use this method to messages and phrases
which directly are stored in database.  Use MT->translate for the purpose.

=back

=item * CLI

Specified (set to '1') when invoked from a command line tool. This prevents
encoding response messages in the configured PublishCharset for the
installation.

=item * SuperUser

If upgrading from the command line, and running on a pre-MT 3.2 database,
set this to an existing author ID that should be upgrade to system
administrator status.

=item * DryRun

Specified (set to '1') to examine the database for installation/upgrade
needs but not actually make any physical changes to the database. This will
issue all the upgrade progress messages without doing the upgrade itself.

=back

=head1 CALLBACKS

The upgrade module defines the following MT callbacks:

=over 4

=item * MT::Upgrade::SQL

Called with each SQL statement that is executed against the database
as part of the upgrade process. The parameters passed to this callback are:

    $callback, $upgrade_app, $sql_statement

The first parameter is an L<MT::Callback> object. C<$upgrade_app> is a
package name or L<MT::App> object used to drive the upgrade process.
C<$sql_statement> is the actual SQL query that is about to be executed
against the database.

=back

=head1 UPGRADE FUNCTIONS

The bulk of this module consists of Movable Type upgrade operations.
These are declared as upgrade functions, and are registered in the
package variabled '%functions'. (Note: the word 'function' here is
not meant to describe a Perl subroutine.)

Some functions are invoked to manage the upgrade process from start
to finish ('core_upgrade_begin' for instance, which merely displays
a progress message to the calling application). The rest handle
schema and data transformation from one version of the MT schema to
another.

Schema translation itself is handled by Movable Type automatically.
MT is able to check the physical schema represenation in the database
and compare it with the schema as defined by the L<MT::Object>-descended
package. If a new property is added to the L<MT::Blog> package, the
upgrade process sees that has happened and can issue the actual
'alter table' SQL statement necessary to add it to the database. The
'core_fix_type' function is responsible for examining a particular
table used by a class like L<MT::Blog> and will append additional
upgrade steps ('core_add_column', 'core_alter_column') that it finds
necessary to the upgrade workflow.

Following the schema translation operations, the data transformation
functions would be used to manipulate the data as necessary from
an older schema to the current one. For instance, the
'core_create_placements' upgrade function was written to upgrade
really old MT schemas from the pre-2.0 release to the current schema.
The upgrade function is registered like this:

    $MT::Upgrade::functions{core_create_placements} = {
        version_limit => 2.0,
        code          => \&core_update_records,
        priority      => 9.1,
        updater       => {
            class     => 'MT::Entry',
            message   => 'Creating entry category placements...',
            condition => sub { $_[0]->category_id },
            code      => sub {
                require MT::Placement;
                my $entry = shift;
                my $existing = MT::Placement->load({ entry_id => $entry->id,
                    category_id => $entry->category_id });
                if (!$existing) {
                    my $place = MT::Placement->new;
                    $place->entry_id($entry->id);
                    $place->blog_id($entry->blog_id);
                    $place->category_id($entry->category_id);
                    $place->is_primary(1);
                    $place->save;
                }
                $entry->category_id(0);
            }
        }
    };

With MT version 2.0, the L<MT::Placement> class was introduced and
immediately deprecated the use of MT::Entry-E<gt>category as a result.
To facilitate upgrading the existing L<MT::Entry> objects this upgrade
function is declared such that:

=over 4

=item * It is limited to only run for MT schemas older than version 2.0 (the version_limit element handles this).

=item * It operates on L<MT::Entry> objects (updater-E<gt>class element
declares that).

=item * It tells the user what is happening (updater-E<gt>message).

=item * It excludes any L<MT::Entry> objects that do not have a category_id element (updater-E<gt>condition).

=item * It checks for an existing L<MT::Placement> relationship; if not
present, it creates one (updater-E<gt>code).

=item * It empties out the category_id member of the L<MT::Entry> object
being upgrade to prevent it from being processed in the future
(updater-E<gt>code).

=back

For plugins, upgrade functions are assignable in the plugin registration
hash as documented in L<MT::Plugin>. You may also return a hashref of
upgrade functions from the plugin using the MT::Plugin::upgrade_functions
subroutine.

Let's look at the anatomy of an upgrade function declaration:

=over 4

=item * version_limit (optional)

The version_limit property allows you to declare that this upgrade
operation is only applicable to MT B<schema> versions below the version
specified.

To register an upgrade function that is only applied to releases prior
to the current one, specify the current schema version as the version
limit. This will allow the upgrade function to run for any prior releases
but prevent it from running in subsequent releases.

B<NOTE>: If you are declaring a B<plugin> upgrade function, this version
limit is compared with your plugin's schema version, not the Movable Type
schema version.

=item * priority (optional)

If your upgrade operation is dependent on another being done already,
it is possible to order them using the priority value. A lower value
means a higher priority.

=item * condition (optional)

This is a coderef parameter. If specified, it should return a true or
false value that determines whether the upgrade step is actually to run
or not.

When called, it is given the parameters normally passed to an upgrade
operation (see the 'code' parameter documentation).

=item * on_field (optional)

If specified, this upgrade function is triggered upon the creation of
the field identified by this element. For instance,

    on_field => 'MT::Foo->bar'

This would specify that the upgrade step is only to run when the 'bar'
column is being added to the table that stores data for the MT::Foo
package.

=item * code

This coderef parameter is the declared handler for the upgrade
function. It is responsible for doing the upgrade task itself. For
quick operations, it is fine to do all of your work within this
subroutine. However, to faciliate large databases, it is important
to do that work in manageable portions so it doesn't time-out by
the web server or browser client.

To facilitate an iterative process for your upgrade function, the
upgrade routine itself can yield a return value to signal the
upgrade process on how to proceed:

=over 4

=item * 0

The upgrade function completed successfully.

=item * undef

upgrade routine failed with error. The error should be placed using the
MT::Upgrade-E<gt>error method.

=item * E<gt> 0

More work to do; the return value is the 'offset' parameter
to pass on the next invocation of the upgrade function.

=back

Due to the complexity of handling this kind of staged operation,
you will most likely want to use the prebuilt
'MT::Upgrade::core_update_records' routine to do most of your upgrade
operations that handle some or all records of a given package.

If using the 'core_update_records' routine, you should also specify
an 'updater' parameter for your upgrade function.

=item * updater

This parameter is only used if you've specified the 'core_update_records'
routine (from the L<MT::Upgrade> package itself) for the 'code' element of
your upgrade function.

    code => \&MT::Upgrade::core_update_records,
    updater => {
        class => 'MT::Foo',
        message => 'Updating Foo bars...',
        code => sub {
            my $foo = shift;
            $foo->bar(1);
        },
        condition => sub {
            my $foo = shift;
            !defined $foo->bar;
        },
        sql => 'update mt_foo set foo_bar = 1 where foo_bar is null'
    }

This updater declaration is going to process all MT::Foo objects that
are available, setting the 'bar' property to 1 if it hasn't been assigned
a value already.

Here's an overview of an 'updater' element:

=over 4

=item * class (required)

The L<MT::Object>-descendant class to be processed.

=item * code (required)

A coderef to execute for B<each> record of the table. The parameter to
this routine is the object being processed. Following the call to your
subroutine, the object is saved for you, so you don't have to save
the object yourself.

=item * message (optional)

The status message to display when running this upgrade operation.

=item * condition (optional)

A coderef to use to test whether the current object needs to be upgraded
or not. This routine should return true if it is to be processed; false
if not. It is given the object as a parameter.

=item * sql (optional)

If specified, and if MT is using a SQL-based database for storing data,
this SQL statement is issued instead of doing the Perl-based row-by-row
upgrade.

    sql => 'update mt_foo set foo_bar=1 where foo_bar is null'

You may also specify multiple SQL statements using an array:

    sql => [
        'update mt_foo set foo_bar=1 where foo_bar is null',
        'update mt_foo set foo_baz=2 where foo_baz is null'
    ]

B<WARNING>: The 'sql' property is only meant to be used for cases where you
can issue simple, cross-database SQL statements. It is not advised to
use any vendor-specific SQL syntax. So, if you can't do that, don't specify
the 'sql' element at all and instead use the 'code' element exclusively
to do the upgrade operation.

=back

=back

The declarative style of upgrade functions make it possible for MT to
fix itself, upgrading from any older schema version to the current one.
Upgrade functions are selected through an introspection process, so any
given upgrade operation may run a different selection of upgrade functions.
As such, it is important that any upgrade functions be written with this
in mind. Here are some general best practices to use when writing them:

=over 4

=item * Make them fast.

Use the 'sql' element for a 'core_update_records' type upgrade function
so that SQL-based databases can be upgraded in one pass.

=item * Make them indepedent.

Don't assume that any other upgrade operation will have run within the
same application request. The upgrade process can run them in most any
order and across multiple application requests. You do have a guarantee
that a higher priority upgrade function will be run prior to a lower-priority
upgrade function (ie, assigning a priority of 1 will ensure it will run
before one with a priority of 2).

=item * Limit them as much as possible.

Specify a version_limit so it only runs for the proper schemas. Use the
condition element to bypass objects or the upgrade step altogether when
possible.

=item * Repeating an upgrade function should be safe.

This can be made possible through use of the 'condition' elements, bypassing
objects that have already been processed (see how the
'core_create_placements' upgrade function declares conditions for an
example).

=item * Beware which translate method to call

$self->translate_escape is for messages and phrases which appear on the 
progress screen (therefore they are sent in JSON).  Use MT->translate
to messages and phrases which directly stored in the database.  Log messages
and objects' attributes fall into this category.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
