# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Upgrade::v4;

use strict;
use warnings;

sub upgrade_functions {
    return {
        'core_init_comment_junk_status' => {
            version_limit => 4.0053,
            priority      => 3.1,
            updater       => {
                type      => 'comment',
                condition => sub { !$_[0]->junk_status },
                code      => sub { $_[0]->junk_status(1) },
                label     => 'Assigning junk status for comments...',
                sql       => 'update mt_comment set comment_junk_status = 1
                        where comment_junk_status is null
                           or comment_junk_status=0',
            }
        },
        'core_init_tbping_junk_status' => {
            version_limit => 4.0053,
            priority      => 3.1,
            updater       => {
                type      => 'tbping',
                condition => sub { !$_[0]->junk_status },
                code      => sub { $_[0]->junk_status(1) },
                label     => 'Assigning junk status for TrackBacks...',
                sql       => 'update mt_tbping set tbping_junk_status = 1
                        where tbping_junk_status is null
                          or tbping_junk_status=0',
            }
        },
        'core_deprecate_bitmask_permissions' => {
            code          => \&deprecate_bitmask_permissions,
            version_limit => 4.0002,
            priority      => 3.3,
        },
        'core_migrate_system_privileges' => {
            code          => \&migrate_system_privileges,
            version_limit => 4.0002,
            priority      => 3.3,
        },
        'core_populate_authored_on' => {
            version_limit => 4.0014,
            priority      => 3.1,
            updater       => {
                type => 'entry',
                label =>
                    'Populating authored and published dates for entries...',
                condition => sub {
                    !defined $_[0]->authored_on;
                },
                code => sub {
                    $_[0]->authored_on( $_[0]->created_on )
                        if !defined $_[0]->authored_on;
                },
                sql =>
                    'update mt_entry set entry_authored_on = entry_created_on
                        where entry_authored_on is null',
            },
        },
        'core_update_3x_system_search_templates' => {
            version_limit => 4.0017,
            priority      => 3.1,
            code          => \&update_3x_system_search_templates,
        },
        'core_rename_php_plugin_filenames' => {
            version_limit => 4.0019,
            priority      => 3.1,
            code          => \&rename_php_plugin_filenames,
        },
        'core_migrate_nofollow_settings' => {
            version_limit => 4.0020,
            priority      => 3.1,
            code          => \&migrate_nofollow_settings,
        },
        'core_update_widget_template' => {
            version_limit => 4.0022,
            priority      => 3.1,
            updater       => {
                type      => 'template',
                label     => 'Updating widget template records...',
                condition => sub {
                    return 0 unless 'custom' eq $_[0]->type;
                    my $name = $_[0]->name;
                    if ( $name =~ s/^(?:Widget|Sidebar): ?// ) {
                        $_[0]->name($name);
                        $_[0]->type('widget');
                        $_[0]->save;
                    }
                    0;
                },
                code => sub { 1; },
            },
        },

        # This upgrade step is currently necessary for PostgreSQL
        # which doesn't support adding a column, populating the existing
        # records with a value.
        'core_typify_category_records' => {
            version_limit => 4.0023,
            priority      => 3.1,
            updater       => {
                type      => 'category',
                label     => 'Classifying category records...',
                condition => sub {
                    !$_[0]->column('class');
                },
                code => sub {
                    $_[0]->class('category');
                },
                sql => "update mt_category set category_class = 'category'
                        where category_class is null",
            },
        },
        'core_typify_entry_records' => {
            version_limit => 4.0023,
            priority      => 3.1,
            updater       => {
                type      => 'entry',
                label     => 'Classifying entry records...',
                condition => sub {
                    !$_[0]->column('class');
                },
                code => sub {
                    $_[0]->class('entry');
                },
                sql => "update mt_entry set entry_class = 'entry'
                        where entry_class is null",
            },
        },
        'core_merge_comment_response_templates' => {
            version_limit => 4.0023,
            priority      => 3.1,
            updater       => {
                type  => 'blog',
                label => "Merging comment system templates...",
                code  => \&_merge_comment_response_templates_updater,
            },
        },
        'core_populate_default_file_template' => {
            version_limit => 4.0023,
            priority      => 3.1,
            updater       => {
                type => 'templatemap',
                label =>
                    'Populating default file template for templatemaps...',
                condition => sub {
                    !defined $_[0]->file_template;
                },
                code => sub {
                    my %default_template = (
                        Individual => '%y/%m/%f',
                        Category   => '%c/%i',
                    );
                    $_[0]->file_template(
                        $default_template{ $_[0]->archive_type } )
                        if !defined $_[0]->file_template
                        && exists( $default_template{ $_[0]->archive_type } );
                },
            },
        },
        'core_remove_unused_templatemap' => {
            version_limit => 4.0023,
            priority      => 3.0,
            updater       => {
                type      => 'blog',
                label     => 'Removing unused template maps...',
                condition => sub {
                    my $blog = shift;
                    my @blog_at = split /,/, $blog->archive_type;
                    require MT::TemplateMap;
                    MT::TemplateMap->remove(
                        { blog_id => $blog->id, archive_type => \@blog_at },
                        { not => { archive_type => 1 } } )
                        if @blog_at;
                    return 0;
                },
            },
        },
        'core_set_author_auth_type' => {
            version_limit => 4.0024,
            priority      => 3.1,
            updater       => {
                type      => 'author',
                label     => 'Assigning user authentication type...',
                condition => sub {
                    !$_[0]->auth_type;
                },
                code => \&core_populate_author_auth_type,
            },
        },
        'core_add_newfeature_widget' => {
            version_limit => 4.0027,
            priority      => 3.4,
            updater       => {
                type      => 'author',
                label     => 'Adding new feature widget to dashboard...',
                condition => sub {
                    my $App = $MT::Upgrade::App;
                    my ($user) = @_;
                    if ( $user->type == MT::Author::AUTHOR() ) {
                        return 1
                            if $App
                            && UNIVERSAL::isa( $App, 'MT::App' )
                            && ( $user->id == $App->user->id );
                    }
                    return 0;
                },
                code => sub {
                    my ($user) = @_;
                    my $widget_store = $user->widgets();
                    if ( $widget_store && %$widget_store ) {
                        for my $set ( keys %$widget_store ) {
                            $widget_store->{$set}->{new_version} = {
                                template => 'widget/new_version.tmpl',
                                set      => 'main',
                                singular => 1,
                                order    => -1,
                            };
                        }
                    }
                    else {

                        # FIXME: copied from MT::CMS::Dashboard
                        my %default_widgets = (
                            'new_version' => {
                                order    => -1,
                                set      => 'main',
                                template => 'widget/new_version.tmpl',
                                singular => 1
                            },
                            'blog_stats' => {
                                param => { tab => 'entry' },
                                order => 1,
                                set   => 'main'
                            },
                            'this_is_you-1' =>
                                { order => 1, set => 'sidebar' },
                            'mt_shortcuts' =>
                                { order => 2, set => 'sidebar' },
                            'mt_news' => { order => 3, set => 'sidebar' },
                        );
                        my $blog_iter = MT->model('blog')
                            ->load_iter( undef, { fetchonly => ['id'] } );
                        while ( my $blog = $blog_iter->() ) {
                            my $set = 'dashboard:blog:' . $blog->id;
                            $widget_store->{$set} = \%default_widgets;
                        }
                        $widget_store->{'dashboard:system'}
                            = \%default_widgets;
                    }
                    $user->widgets($widget_store);
                },
            },
        },
        'core_add_email_template' => {
            version_limit => 4.0030,
            priority      => 9.3,
            code          => sub {
                my $self = shift;
                $self->add_step('core_upgrade_templates');
            },
        },
        'core_replace_openid_username' => {
            version_limit => 4.0033,
            priority      => 3.2,
            updater       => {
                type  => 'author',
                label => 'Moving OpenID usernames to external_id fields...',
                condition => sub {
                    return 0 if 'MT' eq $_[0]->auth_type;
                    my $auth
                        = MT->commenter_authenticator( $_[0]->auth_type );
                    return 0
                        unless $auth && %$auth && exists( $auth->{class} );
                    my $auth_class = $auth->{class};
                    eval "require $auth_class;";
                    return 0 if $@;
                    return UNIVERSAL::isa( $auth_class, 'MT::Auth::OpenID' );
                },
                code => sub {
                    return unless $_[0]->url;
                    my $existing = MT::Author->load(
                        { name => $_[0]->url, auth_type => 'OpenID' } );
                    unless ($existing) {
                        $_[0]->external_id( $_[0]->name );
                        $_[0]->name( $_[0]->url );
                    }
                },
            },
        },
        'core_set_template_set' => {
            version_limit => 4.0034,
            priority      => 3.2,
            updater       => {
                type      => 'blog',
                label     => 'Assigning blog template set...',
                condition => sub {
                    !$_[0]->template_set;
                },
                code => sub {
                    $_[0]->template_set('mt_blog');
                    MT->run_callbacks( 'blog_template_set_change',
                        { blog => $_[0] } );
                },
            },
        },
        'core_set_page_layout' => {
            version_limit => 4.0036,
            priority      => 3.2,
            updater       => {
                type      => 'blog',
                label     => 'Assigning blog page layout...',
                condition => sub {
                    !$_[0]->page_layout;
                },
                code => sub {
                    my ($blog) = @_;
                    my $layout = 'layout-wtt';
                    require MT::Template;
                    my $styles = MT::Template->load(
                        { blog_id => $blog->id, identifier => 'styles' } );
                    if ($styles) {
                        if ( $styles->text
                            =~ m{ <\$?mt:?setvar \s+ name="page_layout" \s+ value="([^"]+)"\$?> }xmsi
                            )
                        {
                            $layout = $1;
                        }
                    }
                    $blog->page_layout($layout);
                },
            },
        },
        'core_set_author_basename' => {
            version_limit => 4.0037,
            priority      => 3.2,
            updater       => {
                type      => 'author',
                label     => 'Assigning author basename...',
                condition => sub {
                    $_[0]->type == 1;
                },
                code => sub {
                    my ($author) = @_;
                    my $basename
                        = MT::Util::make_unique_author_basename($author);
                    $author->basename($basename);
                },
            },
        },
        'core_remove_indexes' => {
            version_limit => 4.0041,
            priority      => 3.2,
            code          => \&remove_indexes,
        },
        'core_set_count_columns' => {
            version_limit => 4.0047,
            priority      => 3.2,
            code          => \&core_update_entry_counts,
        },
        'core_assign_object_embedded' => {
            version_limit => 4.0052,
            priority      => 3.2,
            updater       => {
                type  => 'objectasset',
                label => 'Assigning embedded flag to asset placements...',
                code  => sub {
                    $_[0]->embedded(1);
                },
                sql => 'update mt_objectasset set objectasset_embedded=1',
            },
        },
        'core_set_template_build_type' => {
            version_limit => 4.0053,
            priority      => 3.2,
            updater       => {
                type  => 'blog',
                label => 'Updating template build types...',
                code  => sub {
                    my ($blog) = @_;
                    require MT::CMS::Blog;
                    my $App = $MT::Upgrade::App;
                    MT::CMS::Blog::update_publishing_profile( $App, $blog );
                    require MT::Template;
                    require MT::PublishOption;
                    my @tmpls
                        = MT::Template->load( { blog_id => $blog->id } );
                    foreach my $tmpl (@tmpls) {

                        if ( $tmpl->build_dynamic ) {
                            require MT::TemplateMap;
                            $tmpl->build_type( MT::PublishOption::DYNAMIC() );
                            $tmpl->save;
                            my @maps = MT::TemplateMap->load(
                                { template_id => $tmpl->id } );
                            foreach my $map (@maps) {
                                $map->build_type(
                                    MT::PublishOption::DYNAMIC() );
                                $map->save;
                            }
                        }
                        elsif ( !$tmpl->rebuild_me && $tmpl->type eq 'index' )
                        {
                            $tmpl->build_type(
                                MT::PublishOption::MANUALLY() );
                            $tmpl->save;
                        }
                        elsif ( !defined $tmpl->build_type ) {
                            $tmpl->build_type(
                                MT::PublishOption::ONDEMAND() );
                            $tmpl->save;
                        }
                    }
                    return 0;
                },
            },
        },
        'core_enable_address_book' => {
            version_limit => 4.0054,
            priority      => 3.2,
            code          => sub {
                require MT::Notification;
                if ( MT::Notification->exist() ) {
                    my $cfg = MT->config;
                    if ( !$cfg->EnableAddressBook ) {
                        $cfg->EnableAddressBook( 1, 1 );
                        $cfg->save;
                    }
                }
                return 0;
            },
        },
        'core_upgrade_meta' => {
            version_limit => 4.0057,
            priority      => 3.2,
            code          => \&core_upgrade_meta,
        },
        'core_upgrade_category_meta' => {
            version_limit => 4.0057,
            priority      => 3.2,
            code          => \&core_upgrade_category_meta,
        },

        # Helper upgrade routines for core_upgrade_meta
        # and possibly other object types that require
        # this migration; version_limit is unspecified, so
        # these can only be invoked if another upgrade
        # operation utilizes them.
        'core_upgrade_meta_for_table' => {
            priority => 1.5,
            code     => \&core_upgrade_meta_for_table,
        },
        'core_upgrade_plugindata_meta_for_table' => {
            priority => 1.5,
            code     => \&core_upgrade_plugindata_meta_for_table,
        },
        'core_drop_meta_for_table' => {
            priority => 3.4,
            code     => \&core_drop_meta_for_table,
        },
        'core_replace_file_template_format' => {
            version_limit => 4.0058,
            priority      => 3.2,
            updater       => {
                type  => 'templatemap',
                label => 'Replacing file formats to use CategoryLabel tag...',
                condition => sub {
                    ( $_[0]->file_template || '' ) =~ m/%-?C/;
                },
                code => sub {
                    my ($map) = shift;
                    my $file_template = $map->file_template();
                    $file_template =~ s/%C/<MTCategoryLabel dirify="1">/g;
                    $file_template =~ s/%-C/<MTCategoryLabel dirify="-">/g;
                    $map->file_template($file_template);
                },
            },
        },
        'core_update_password_recover_template' => {
            version_limit => 4.0068,
            code          => \&core_update_password_recover_template,
        },
        'core_disable_cloner_plugin' => {
            version_limit => 4.0073,
            code          => sub {
                my $cfg = MT->config;
                $cfg->PluginSwitch( "Cloner/cloner.pl=0", 1 );
                $cfg->save_config;
            }
        },
    };
}

### Subroutines

sub _process_masks {
    my ($perm) = @_;

    my $mask = $perm->role_mask;
    return unless $mask;
    my @perms;
    for my $key ( keys %MT::Upgrade::LegacyPerms ) {
        if ( int($mask) & int($key) ) {
            if ( 2 eq $key ) {    # post
                push @perms, 'create_post', 'publish_post';
            }
            elsif ( 64 eq $key ) {    #edit_config
                push @perms, 'edit_config', 'set_publish_paths',
                    'manage_feedback';
            }
            elsif ( 16 eq $key ) {    #designer
                push @perms, 'manage_themes', 'edit_templates',
                    unless grep '/^manage_themes/', @perms;
            }
            elsif ( 256 eq $key ) {    #send_notifications
                push @perms, 'create_post', 'send_notifications';
            }
            elsif ( 4096 eq $key ) {    #adminsiter_blog
                push @perms, 'administer_blog';
            }
            elsif ( 2048 eq $key ) {    #not_comment
                $perm->restrictions("'comment'");
            }
            else {
                push @perms, $MT::Upgrade::LegacyPerms{$key};
            }
        }
    }
    my $perm_str = scalar(@perms) ? "'" . join( "','", @perms ) . "'" : q();
    $perm->permissions($perm_str);
    $perm->role_mask(0);                ## remove legacy permissions
    $perm;
}

sub deprecate_bitmask_permissions {
    my $self = shift;

    require MT::Permission;
    my $perm_iter = MT::Permission->load_iter;
    $self->progress(
        $self->translate_escape(
            'Migrating permission records to new structure...')
    );
    while ( my $perm = $perm_iter->() ) {
        if ( _process_masks($perm) ) {
            $perm->save;
        }
    }

    require MT::Role;
    my $role_iter = MT::Role->load_iter;
    $self->progress(
        $self->translate_escape('Migrating role records to new structure...')
    );
    while ( my $role = $role_iter->() ) {
        if ( _process_masks($role) ) {

            # do not have to rebuild permissions here.
            # "save" here causes segfault in sqlite.
            $role->update;
        }
    }
}

sub migrate_system_privileges {
    my $self = shift;

    require MT::Permission;
    my $author_iter
        = MT::Author->load_iter( { type => MT::Author::AUTHOR() } );
    $self->progress(
        $self->translate_escape(
            'Migrating system level permissions to new structure...')
    );
    while ( my $author = $author_iter->() ) {
        my @perms;
        push @perms, 'administer' if $author->column('is_superuser');
        push @perms, 'create_blog'
            if $author->column('can_create_blog')
            || $author->column('is_superuser');
        push @perms, 'view_log'
            if $author->column('can_view_log')
            || $author->column('is_superuser');
        push @perms, 'manage_plugins' if $author->column('is_superuser');
        if (@perms) {
            my $perm = MT::Permission->load(
                {   author_id => $author->id,
                    blog_id   => 0
                }
            );
            if ( !$perm ) {
                $perm = MT::Permission->new;
                $perm->author_id( $author->id );
                $perm->blog_id(0);
            }
            $perm->set_these_permissions(@perms);
            $perm->save;
        }
    }
}

sub update_3x_system_search_templates {
    my $self = shift;

    require MT::Template;
    $self->progress(
        $self->translate_escape('Updating system search template records...')
    );
    my $tmpl_iter = MT::Template->load_iter( { type => 'search_template', } );
    my %blogs;
    while ( my $tmpl = $tmpl_iter->() ) {
        $blogs{ $tmpl->blog_id } = $tmpl->id;
        $tmpl->type('search_results');
        $tmpl->save;
    }

    # for any old 'search_template' system templates, remove the
    # newly installed 'search_results' template.
    foreach my $blog_id ( keys %blogs ) {
        my $tmpl = MT::Template->load(
            {   type    => 'search_results',
                blog_id => $blog_id,
                id      => $blogs{$blog_id}
            },
            { not => { id => 1 } }
        );
        $tmpl->remove if $tmpl;
    }
    if ( my @blog_ids = keys %blogs ) {
        MT::Template->remove(
            { type => 'search_results', blog_id => \@blog_ids },
            { not => { blog_id => 1 } } );
    }
    0;
}

sub rename_php_plugin_filenames {
    my $self = shift;

    my $server_path = MT->instance->server_path() || '';
    $server_path =~ s/\/*$//;
    my $plugin_path = File::Spec->canonpath("$server_path/php/plugins");

    # If PHP plugins directory doesn't exist, return without failing
    return 0 if !-d $plugin_path;

    opendir( DIR, $plugin_path )
        or return 0;
    my @files = grep {/^(?:function|block)\.(.*)\.php$/} readdir(DIR);
    closedir(DIR);

    return 0 unless @files;

    $self->progress(
        $self->translate_escape('Renaming PHP plugin file names...') );
    my @error_files = ();
    for my $file (@files) {
        my $newfile = lc $file;
        next if $file eq $newfile;
        if ( !rename( "$plugin_path/$file", "$plugin_path/$newfile" ) ) {
            push @error_files, $file;
        }
    }
    if ( $#error_files >= 0 ) {
        $self->progress(
            $self->translate_escape(
                'Error renaming PHP files. Please check the Activity Log.')
        );
        MT->log(
            {   message => $self->translate_escape(
                    "Cannot rename in [_1]: [_2].",
                    $plugin_path,
                    join( ', ', @error_files )
                ),
                level    => MT::Log::ERROR(),
                category => 'upgrade',
            }
        );
    }
    1;
}

sub migrate_nofollow_settings {
    my $self = shift;

    $self->progress(
        $self->translate_escape("Migrating Nofollow plugin settings...") );
    require MT::PluginData;
    my $cfg             = MT->config;
    my $plugins         = $cfg->PluginSwitch || {};
    my $nofollow_switch = $plugins->{'nofollow/nofollow.pl'};
    my $enabled = defined $nofollow_switch ? ( $nofollow_switch ? 1 : 0 ) : 1;
    my $default_follow_auth_links = 1;

    # For any configuration settings that exist
    my @config = MT::PluginData->load( { plugin => 'Nofollow' } );
    my %blogs_saved;
    foreach my $cfg (@config) {
        if ( $cfg->key =~ m/^configuration:blog:(\d+)/ ) {
            my $blog = MT::Blog->load($1) or next;
            my $setting = ( $cfg->data || {} )->{follow_auth_links};
            $blog->follow_auth_links($setting) if defined $setting;
            $blog->nofollow_urls($enabled);
            $blog->save;
            $blogs_saved{ $blog->id } = 1;
        }
        else {
            my $setting = ( $cfg->data || {} )->{follow_auth_links};
            $default_follow_auth_links = $setting if defined $setting;
        }
    }
    $_->remove for @config;

    my $blog_iter = MT::Blog->load_iter;
    while ( my $blog = $blog_iter->() ) {
        next if exists $blogs_saved{ $blog->id };
        $blog->nofollow_urls($enabled);
        $blog->follow_auth_links($default_follow_auth_links);
        $blog->save;
    }

    # Forcibly disable nofollow plugin now since this has become
    # a core function.
    $cfg->PluginSwitch( 'nofollow/nofollow.pl=0', 1 );
    $cfg->save_config();

    return 0;
}

sub _merge_comment_response_templates_updater {
    my ($blog) = @_;
    require MT::Template;
    my $tmpl = MT::Template->load(
        { blog_id => $blog->id, type => 'comment_response' } );
    unless ($tmpl) {
        $tmpl = new MT::Template;
        $tmpl->blog_id( $blog->id );
        $tmpl->type('comment_response');
    }

    my $confirm_template = <<'EOT';
<MTSetVarBlock name="page_title"><__trans phrase="Comment Posted"></MTSetVarBlock>

<MTSetVar name="heading" value="<__trans phrase="Confirmation...">">

<MTSetVarBlock name="message">
<p><__trans phrase="Your comment has been posted!"></p>
</MTSetVarBlock>
EOT

    my $pending_template = <<'EOT';
<MTSetVarBlock name="page_title"><__trans phrase="Comment Pending"></MTSetVarBlock>

<MTSetVar name="heading" value="<__trans phrase="Thank you for commenting.">">

<MTSetVarBlock name="message">
<p><__trans phrase="Your comment has been received and held for review by a blog administrator."></p>
</MTSetVarBlock>
EOT

    my $error_template = <<'EOT';
<MTSetVarBlock name="page_title"><__trans phrase="Comment Submission Error"></MTSetVarBlock>

<MTSetVar name="heading" value="$page_title">

<MTSetVarBlock name="message">
<p><__trans phrase="Your comment submission failed for the following reasons:"></p>
<blockquote>
    <$MTErrorMessage$>
</blockquote>
</MTSetVarBlock>
EOT

    my $header_template = <<'EOT';
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=<$MTPublishCharset$>" />
    <meta name="generator" content="<$MTProductName version="1"$>" />
    <link rel="stylesheet" href="<$MTBlogURL$>styles-site.css" type="text/css" />
    <title>
    <__trans phrase="[_1]: [_2]" params="<$MTBlogName encode_html="1"$>%%<$MTGetVar name="page_title"$>">
    </title>
    <script type="text/javascript" src="<$MTBlogURL$>mt-site.js"></script>
</head>
<body class="layout-one-column comment-preview" onload="individualArchivesOnLoad(commenter_name)">
    <div id="container">
        <div id="container-inner" class="pkg">
            <div id="banner">
                <div id="banner-inner" class="pkg">
                    <h1 id="banner-header"><a href="<$MTBlogURL$>" accesskey="1"><$MTBlogName encode_html="1"$></a></h1>
                    <h2 id="banner-description"><$MTBlogDescription$></h2>
                </div>
            </div>
            <div id="pagebody">
                <div id="pagebody-inner" class="pkg">
                    <div id="alpha">
                        <div id="alpha-inner" class="pkg">
EOT

    my $footer_template = <<'EOT';
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
EOT

    my $message_template = <<'EOT';
<h1><$MTGetVar name="heading"$></h1>

<$MTGetVar name="message"$>

<p><__trans phrase="Return to the <a href="[_1]">original entry</a>." params="<$MTEntryLink$>"></p>
EOT

    my $mt               = MT->instance;
    my $current_language = MT->current_language;
    MT->set_language( $blog->language );
    $tmpl->name( $mt->translate("Comment Response") );
    $tmpl->text( $mt->translate_templatized(<<"EOT") );
<MTSetVar name="system_template" value="1">
<MTSetVar name="feedback_template" value="1">

<MTIf name="body_class" eq="mt-comment-pending">
$pending_template
</MTIf>

<MTIf name="body_class" eq="mt-comment-error">
$error_template
</MTIf>

<MTIf name="body_class" eq="mt-comment-confirmation">
$confirm_template
</MTIf>

$header_template

$message_template

$footer_template
EOT
    MT->set_language($current_language);
    $tmpl->save;
}

sub core_populate_author_auth_type {
    my ($u) = @_;
    if ( $u->type == 1 ) {
        $u->auth_type( MT->config->AuthenticationModule || 'MT' );
    }
    else {

        # for legacy OpenID plugin commenters
        if ( $u->name =~ m(^openid\n(.*)$) ) {
            my $url = $1;
            if ( eval { require MT::Util::Digest::MD5; 1; } ) {
                $url = MT::Util::Digest::MD5::md5_hex( Encode::encode_utf8($url) );
            }
            else {
                $url = substr $url, 0, 255;
            }
            $u->name($url);
            $u->auth_type('OpenID');
        }
        elsif ( $u->name =~ m!^[a-f0-9]{32}$! ) {

            # Vox OpenID URL; set auth_type to 'Vox'
            if ( $u->url =~ m!\.vox\.com/! ) {
                $u->auth_type('Vox');
            }

            # LJ OpenID URL; set auth_type to 'LiveJournal'
            elsif ( $u->url =~ m!\.livejournal\.com/! ) {
                $u->auth_type('LiveJournal');
            }
            else {

                # Other custom auth, which for now means OpenID
                $u->auth_type('OpenID');
            }
        }
        else {

            # Default to TypePad for remaining plain name fields
            $u->auth_type('TypeKey');
        }
    }
}

sub remove_indexes {
    my $self = shift;

    $self->progress(
        $self->translate_escape('Removing unnecessary indexes...') );

    my $driver = MT::Object->driver;

    if ( $driver->dbd =~ m/::Pg$|::Oracle$/ ) {
        $driver->sql(
            [   'drop index mt_asset_url',
                'drop index mt_asset_file_path',
                'drop index mt_blocklist_name',
                'drop index mt_entry_blog_id',
                'drop index mt_template_build_dynamic'
            ]
        );
    }
    elsif ( $driver->dbd =~ m/::mysql$/ ) {
        $driver->sql(
            [   'drop index mt_asset_url on mt_asset',
                'drop index mt_asset_file_path on mt_asset',
                'drop index mt_blocklist_name on mt_blocklist',
                'drop index mt_entry_blog_id on mt_entry',
                'drop index mt_template_build_dynamic on mt_template'
            ]
        );
    }
    elsif ( $driver->dbd =~ m/::mssqlserver$/ ) {
        $driver->sql(
            [   'drop index mt_asset.mt_asset_url',
                'drop index mt_asset.mt_asset_file_path',
                'drop index mt_blocklist.mt_blocklist_name',
                'drop index mt_entry.mt_entry_blog_id',
                'drop index mt_template.mt_template_build_dynamic'
            ]
        );
    }
    1;
}

sub core_upgrade_meta {
    my $self = shift;

    my $types = MT->registry('object_types');
    my %added_step;
TYPE: while ( my ( $registry_type, $reg_class ) = each %$types ) {
        next TYPE
            if $registry_type eq 'plugin'
            && ref $reg_class;    # plugin reference

        my $class = MT->model($registry_type);
        next TYPE if !$class->has_meta();    # nothing to upgrade

# If this is a class-based package, find its super-most superclass with the same table.
        my $class_type = $class->properties->{class_type};
        if ( $class_type && $class_type ne $class->datasource ) {
            if ( my $super_class = MT->model( $class->datasource ) ) {
                $class = $super_class
                    if $super_class->datasource eq $class->datasource;
            }

           # If there's no appropriate superclass, go to update with the class
           # we have, not the class we want.
        }

        # Don't add another step for this table if we already made one.
        next TYPE if $added_step{ $class->datasource };

 # Categories' and Folders' metadata are only custom fields, which are stored
 # in plugindata anyway. They're converted in their own upgrade step. So don't
 # handle them here.
        next TYPE if $class->isa('MT::Category');

        my %step_param = ( type => $registry_type );
        $step_param{meta_column} = $class->properties->{meta_column}
            if $class->properties->{meta_column};
        $self->add_step( 'core_upgrade_meta_for_table', %step_param );

        # Yay, we added a step for this table.
        $added_step{ $class->datasource } = 1;
    }
    return 0;
}

sub _save_meta {
    my ( $obj, $type, $value ) = @_;

    my $meta_obj = $obj->meta_pkg->new;

    my @class_keys = @{ $obj->primary_key_tuple };
    my @meta_keys  = @{ $meta_obj->primary_key_tuple };
    for my $i ( 0 .. $#class_keys ) {
        my $class_field = $class_keys[$i];
        my $meta_field  = $meta_keys[$i];
        $meta_obj->$meta_field( $obj->$class_field() );
    }

    # Set the type without checking if it's defined, unlike real meta().
    $meta_obj->type($type);

    # Does this meta type have a data type defined?
    my $datatype;
    if ( my $field = MT::Meta->metadata_by_name( ref $obj || $obj, $type ) ) {
        if ( my $type_id = $field->{type_id} ) {
            $datatype = $MT::Meta::Types{$type_id};
        }
    }
    $datatype ||= 'vblob';

    $meta_obj->$datatype($value);

    my $meta_col_def = $meta_obj->column_def($datatype);
    my $meta_is_blob = $meta_col_def ? $meta_col_def->{type} eq 'blob' : 0;
    MT::Meta::Proxy::serialize_blob( undef, $meta_obj ) if $meta_is_blob;
    $meta_obj->save();
    MT::Meta::Proxy::unserialize_blob($meta_obj) if $meta_is_blob;
}

sub core_upgrade_category_meta {
    my $self = shift;
    $self->add_step( 'core_upgrade_plugindata_meta_for_table',
        type => 'category' );
    $self->add_step( 'core_upgrade_plugindata_meta_for_table',
        type => 'folder' );
    return 0;
}

sub core_upgrade_plugindata_meta_for_table {
    my $self       = shift;
    my $Installing = $MT::Upgrade::Installing;
    return 0 if $Installing;
    my (%param) = @_;
    my $type = $param{type};
    return 0 unless $type;
    my $class = MT->model($type);
    return 0 unless $class;

    my $cfclass = MT->model('field');
    return 0 if !$cfclass;

    # this looks weird, but it winds up invoking
    # the loading of custom field types and the
    # installation of their meta properties
    MT->registry('tags');

    # special case for types that use CustomField plugindata
    # for storing their custom field metadata instead of a 'meta'
    # column.
    require CustomFields::Upgrade;

# TODO: really this should vary on $type but it's already translated for "categories"
    $self->progress(
        $self->translate_escape('Moving metadata storage for categories...')
    );
    CustomFields::Upgrade::customfields_move_meta( $self, $type );

    return 0;
}

sub core_upgrade_meta_for_table {
    my $self       = shift;
    my $Installing = $MT::Upgrade::Installing;
    return 0 if $Installing;
    my (%param) = @_;
    my $type = $param{type};
    return 0 unless $type;
    my $class = MT->model($type);
    return 0 unless $class;

    my $offset = int( $param{offset} || 0 );
    my $count  = int( $param{count}  || 0 );

    my $pid = join q{:}, $param{step} . "_type", $class;

    my $db_class   = $class;
    my $class_type = $class->properties->{class_type};
    if ( $class_type && $class_type ne $class->datasource ) {
        if ( my $super_class = MT->model( $class->datasource ) ) {
            $db_class = $super_class
                if $super_class->datasource eq $class->datasource;
        }

        # If there's no appropriate superclass, go to update with the class
        # we have, not the class we want.
    }

    my $driver = $db_class->dbi_driver;
    my $dbh    = $driver->rw_handle;
    my $dbd    = $driver->dbd;

    my $meta_col = $param{meta_column} || 'meta';

    my $ddl     = $driver->dbd->ddl_class;
    my $db_defs = $ddl->column_defs($db_class);
    return 0 unless $db_defs && exists( $db_defs->{$meta_col} );

    my $terms = { $meta_col => { not_null => 1 } };
    my $args = {
        'limit'     => 101,
        'fetchonly' => ['id'],   # meta is added to the select list separately
        'sort'      => 'id',
        'direction' => 'ascend',
        $offset ? ( 'offset' => $offset ) : ()
    };
    my $stmt = $driver->prepare_statement( $class, $terms, $args );
    my $db_meta_col = $dbd->db_column_name( $class->datasource, $meta_col );
    ## Meta column has to be added in here because it's already
    ## gone from the column_names - something fetchonly relies on
    $stmt->add_select( $db_meta_col => $db_meta_col );
    my $sql = $stmt->as_sql;
    my $sth = $dbh->prepare($sql);
    return 0 if !$sth;   # ignore this operation if _meta column doesn't exist
    $sth->execute
        or return $self->error( $dbh->errstr || $DBI::errstr );

    my $msg = $self->translate_escape( "Upgrading metadata storage for [_1]",
        $class->class_label_plural );

    if ( !$offset ) {
        $self->progress( $msg, $pid );
    }
    else {
        my $count = $class->count(
            { $class->properties->{class_column} ? ( class => '*' ) : () } );
        return 0 unless $count;
        $self->progress(
            sprintf( $msg . " (%d%%)", ( $offset / $count * 100 ) ), $pid );
    }

    my $rows = 0;

    require MT::Serialize;
    my $ser = MT::Serialize->new('MT');
    my %fields;

    my @ids;
    my $cfclass = MT->model('field');
    while ( my $row = $sth->fetchrow_arrayref ) {
        $rows++;
        my ( $id, $rawmeta )
            = @$row
            ;    ## add_select pushes the column - it should be in this order
        if ( defined $rawmeta ) {
            push @ids, $id;
            if ( $rawmeta =~ m/^SERG/ ) {

                # deserialize
                my $metadataref = $ser->unserialize($rawmeta);
                if ($metadataref) {
                    my $metadata = $$metadataref;
                    my $obj      = $class->load(
                        { id => $id },
                        {   no_class  => 1,
                            fetchonly => [
                                'id',
                                (   $class_type
                                    ? ( $class->properties->{class_column} )
                                    : ()
                                )
                            ]
                        }
                    );
                    if ($obj) {
                        foreach my $metaname ( keys %$metadata ) {
                            my $metavalue = $metadata->{$metaname};
                            if ( $metaname eq 'customfields' ) {
                                next unless $cfclass;

                                # extra work for custom fields;
                                # a hash into itself
                                my $cfdata = $metavalue;
                                next unless ref $cfdata eq 'HASH';

                                foreach my $cfname ( keys %$cfdata ) {
                                    my $cfvalue = $cfdata->{$cfname};
                                    my $cftype  = $type;
                                    if ($class_type) {
                                        $cftype = $obj->class_type;
                                    }

                                    # make sure CustomFields::Field exists
                                    my $fld = $fields{$cfname}{$cftype}
                                        ||= $cfclass->load(
                                        {   basename => $cfname,
                                            obj_type => $cftype
                                        }
                                        );
                                    next unless $fld;

                                    _save_meta( $obj, 'field.' . $cfname,
                                        $cfvalue );
                                }
                            }
                            else {
                                _save_meta( $obj, $metaname, $metavalue );
                            }
                        }
                    }
                }
            }
        }
        last if $rows == 100;
    }
    if ( $rows == 100 && $sth->fetchrow_arrayref ) {
        $rows++;
    }
    $sth->finish;

    if ( $rows == 101 ) {
        $offset += 100;
    }
    else {

        # done, so lets drop that meta column, what say you?
        if ( $dbd->ddl_class->can_drop_column ) {

            # if the driver cannot drop a column, it is likely
            # to get dropped as the table is updated for other
            # new columns anyway.
            $sql = $dbd->ddl_class->drop_column_sql( $class, $meta_col );
            $self->add_step(
                'core_drop_meta_for_table',
                class => $db_class,
                sql   => $sql
            );
        }
        $self->progress( $msg . ' (100%)', $pid );
        $offset = 0;    # done!
    }
    return $offset;
}

sub core_drop_meta_for_table {
    my $self    = shift;
    my (%param) = @_;
    my $class   = $param{class};
    my $sql     = $param{sql};

    eval "require $class;";
    my $driver = $class->dbi_driver;
    my $dbh    = $driver->rw_handle;
    my $err;
    eval { $dbh->do($sql) or $err = $dbh->errstr; };

    # ignore drop errors; the column has probably been
    # removed already
    #if ($err) {
    #    print STDERR "$err: $sql\n";
    #}

    return 0;
}

sub core_update_entry_counts {
    my $self = shift;
    my (%param) = @_;

    my $class = MT->model('entry');
    return $self->error(
        $self->translate_escape( "Error loading class: [_1].", $param{type} )
    ) unless $class;

    my $msg = $self->translate_escape(
        "Assigning entry comment and TrackBack counts...");
    my $offset = $param{offset} || 0;
    my $count = $param{count};
    if ( !$count ) {
        $count = $class->count( { class => '*' } );
    }
    return unless $count;
    if ($offset) {
        $self->progress( sprintf( "$msg (%d%%)", ( $offset / $count * 100 ) ),
            $param{step} );
    }
    else {
        $self->progress( $msg, $param{step} );
    }

    my $continue = 0;
    my $driver   = $class->driver;

    my $iter = $class->load_iter( { class => '*' },
        { sort => 'id', offset => $offset, limit => $self->max_rows + 1 } );
    my $start = time;
    my ( %touched, %c, %tb );
    my $rows = 0;
    while ( my $e = $iter->() ) {
        $rows++;
        $c{ $e->id } = $e;
        if ( MT->has_plugin('Trackback') ) {
            if ( my $tb = $e->trackback ) {
                $tb{ $tb->id } = $e;
            }
        }
        $continue = 1, last if scalar $rows == $self->max_rows;
    }
    if ($continue) {
        $iter->end;
        $offset += $rows;
    }

    # now gather counts -- comments
    if (my $grp_iter = MT::Comment->count_group_by(
            {   visible  => 1,
                entry_id => [ keys %c ],
            },
            { group => ['entry_id'], }
        )
        )
    {
        while ( my ( $count, $id ) = $grp_iter->() ) {
            my $e = $c{$id} or next;
            if (   ( !defined $e->comment_count )
                || ( ( $e->comment_count || 0 ) != $count ) )
            {
                $e->comment_count($count);
                $touched{ $e->id } = $e;
            }
        }
    }

    # pings
    if (%tb) {
        if (my $grp_iter = MT::TBPing->count_group_by(
                {   visible => 1,
                    tb_id   => [ keys %tb ],
                },
                { group => ['tb_id'], }
            )
            )
        {
            while ( my ( $count, $id ) = $grp_iter->() ) {
                my $e = $tb{$id} or next;
                if (   ( !defined $e->ping_count )
                    || ( ( $e->ping_count || 0 ) != $count ) )
                {
                    $e->ping_count($count);
                    $touched{ $e->id } = $e;
                }
            }
        }
    }

    foreach my $e ( values %touched ) {
        $e->save;
    }

    if ($continue) {
        return { offset => $offset, count => $count };
    }
    else {
        $self->progress( "$msg (100%)", $param{step} );
    }
    1;
}

sub core_update_password_recover_template {
    my $self = shift;
    $self->progress(
        $self->translate_escape(
            "Updating password recover email template...")
    );
    require MT::DefaultTemplates;
    my $recover_tmpl
        = MT::DefaultTemplates->load( { identifier => 'recover-password' } );
    my $recover_text
        = MT->instance->translate_templatized( $recover_tmpl->{text} );
    require MT::Template;
    my @tmpls = MT::Template->load(
        { type => 'email', identifier => 'recover-password' } );
    for my $tmpl (@tmpls) {
        my $backup = $tmpl->clone;
        delete $backup->{column_values}->{id}
            ;    # make sure we don't overwrite original
        delete $backup->{changed_cols}->{id};
        $backup->name(
            $backup->name . ' (Backup during upgrade to version 4.24)' );
        $backup->type('backup');
        $backup->identifier(undef);
        $backup->save;

        $tmpl->text($recover_text);
        $tmpl->save;
    }
}

1;
