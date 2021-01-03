# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Upgrade::v3;

use strict;
use warnings;

sub upgrade_functions {
    return {

        # < 3.2
        'core_set_default_basename_limit' => {
            version_limit => 3.2,
            priority      => 9.3,
            updater       => {
                type      => 'blog',
                label     => 'Setting blog basename limits...',
                condition => sub { !$_[0]->basename_limit },
                code      => sub { $_[0]->basename_limit(15) },
                sql       => 'update mt_blog set blog_basename_limit = 15
                         where blog_basename_limit is null
                            or blog_basename_limit < 15',
            },
        },
        'core_set_default_blog_extension' => {
            version_limit => 3.2,
            priority      => 9.3,
            updater       => {
                type      => 'blog',
                label     => 'Setting default blog file extension...',
                condition => sub { !$_[0]->file_extension },
                code      => sub { $_[0]->file_extension('html') },
            },
        },
        'core_set_enable_archive_paths' => {
            version_limit => 3.2,
            code          => \&core_set_enable_archive_paths,
            priority      => 9.3,
        },

       # whereas init_comment_visible is done for adding new a comment visible
       # to the comment table, this task sets all comments with a visible
       # status of 2 to 0 since we now treat this field as a boolean.
        'core_update_comment_visible' => {
            version_limit => 3.2,
            priority      => 9.3,
            updater       => {
                type      => 'entry',
                label     => 'Updating comment status flags...',
                condition => sub { $_[0]->allow_comments == 2 },
                code      => sub { $_[0]->allow_comments(0) },
                sql       => 'update mt_entry set entry_allow_comments = 0
                         where entry_allow_comments = 2',
            },
        },
        'core_remove_unique_constraints' => {
            version_limit => 3.2,
            code          => \&core_remove_unique_constraints,
            priority      => 9.3,
        },
        'core_create_commenter_records' => {
            version_limit => 3.2,
            priority      => 9.3,
            updater       => {
                type      => 'comment',
                label     => 'Updating commenter records...',
                condition => sub { $_[0]->commenter_id },
                code      => sub {
                    my ($comment) = @_;
                    require MT::Permission;
                    require MT::Author;
                    my $perm = MT::Permission->load(
                        {   author_id => $comment->commenter_id,
                            blog_id   => $comment->blog_id
                        }
                    );
                    if ( !$perm ) {
                        if ( my $cmtr
                            = MT::Author->load( $comment->commenter_id ) )
                        {
                            $cmtr->pending( $comment->blog_id );
                        }
                    }
                }
            }
        },
        'core_set_blog_admins' => {
            version_limit => 3.2,
            priority      => 9.3,
            updater       => {
                type      => 'permission',
                label     => 'Assigning blog administration permissions...',
                condition => sub {
                    $_[0]->author_id
                        && $_[0]->blog_id
                        && $_[0]->can_edit_config;
                },
                code => sub {
                    require MT::Association;
                    require MT::Role;
                    my ($role)
                        = MT::Role->load_by_permission("administer_blog");
                    if ($role) {
                        my $user = MT::Author->load( $_[0]->author_id );
                        my $blog = MT::Author->load( $_[0]->blog_id );
                        if ( $user && $blog ) {
                            MT::Association->link( $role => $user => $blog );
                        }
                    }
                    else {
                        $_[0]->can_administer_blog(1);
                    }
                },
            }
        },
        'core_set_blog_allow_pings' => {
            version_limit => 3.2,
            priority      => 9.3,
            updater       => {
                type      => 'blog',
                label     => 'Setting blog allow pings status...',
                condition => sub { !defined $_[0]->allow_pings },
                code =>
                    sub { $_[0]->allow_pings( $_[0]->allow_pings_default ) },
                sql =>
                    'update mt_blog set blog_allow_pings = blog_allow_pings_default
                         where blog_allow_pings is null',
            }
        },
        'core_set_superuser' => {
            version_limit => 3.2,
            code          => \&core_set_superuser,
            priority      => 9.3,
        },
        'core_conflate_require_email' => {
            version_limit => 3.2,
            priority      => 9.3,
            updater       => {
                type      => 'blog',
                label     => 'Updating blog comment email requirements...',
                condition => sub { !$_[0]->require_comment_emails },
                code      => sub {
                    $_[0]->require_comment_emails(1)
                        if !$_[0]->allow_anon_comments;
                },
            }
        },
        'core_populate_entry_basenames' => {
            version_limit => 3.2,
            priority      => 9.3,
            updater       => {
                type      => 'entry',
                condition => sub { !$_[0]->basename },
                code      => sub {
                    my $entry = shift;
                    my %args  = @_;
                    $args{from} < 3.20021
                        ? $entry->basename( mt32_dirify( $entry->title ) )
                        : 1;
                },
                label => 'Assigning entry basenames for old entries...',
            }
        },
        'core_set_api_password' => {
            version_limit => 3.2,
            priority      => 9.3,
            updater       => {
                type      => 'author',
                condition => sub {
                    ( $_[0]->type == 1 )
                        && ( ( $_[0]->api_password || '' ) eq '' );
                },
                code => sub { $_[0]->api_password( $_[0]->password ) },
                label => 'Updating user web services passwords...',
            }
        },
        'core_create_config_table' => {
            version_limit => 3.2,
            code          => \&core_create_config_table,
            priority      => 9.3,
        },
        'core_deprecate_old_style_archive_links' => {
            version_limit => 3.2,
            priority      => 9.3,
            updater       => {
                type      => 'blog',
                label     => 'Updating blog old archive link status...',
                condition => sub {
                    my $blog = shift;
                    my %args = @_;
                    $blog->old_style_archive_links
                        || $args{from} < 3.0;
                },
                code => sub {
                    my ($blog) = @_;
                    require MT::TemplateMap;
                    foreach my $map (
                        MT::TemplateMap->load( { blog_id => $blog->id } ) )
                    {
                        next if $map->file_template;

                        my $at = $map->archive_type;
                        if ( $at eq 'Individual' ) {
                            $map->file_template('%e%x');
                        }
                        elsif ( $at eq 'Daily' ) {
                            $map->file_template('%y_%m_%d%x');
                        }
                        elsif ( $at eq 'Weekly' ) {
                            $map->file_template('week_%y_%m_%d%x');
                        }
                        elsif ( $at eq 'Monthly' ) {
                            $map->file_template('%y_%m%x');
                        }
                        elsif ( $at eq 'Category' ) {
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
            priority      => 9.3,
            updater       => {
                type      => 'entry',
                condition => sub { ( $_[0]->week_number || 0 ) < 54 },
                code  => sub {1},
                label => 'Updating entry week numbers...',
            }
        },
        'core_set_tag_permissions' => {
            version_limit => 3.20021,
            priority      => 9.3,
            updater       => {
                type      => 'permission',
                condition => sub {
                    !$_[0]->can_edit_tags && !$_[0]->can_administer_blog;
                },
                code =>
                    sub { $_[0]->can_edit_tags( $_[0]->can_edit_categories ) }
                ,
                label => 'Updating user permissions for editing tags...',
            }
        },
        'core_init_blog_entry_display_defaults' => {
            version_limit => 3.20021,
            code          => sub {
                require MT::Permission;
                &MT::Upgrade::core_update_records;
            },
            priority => 9.3,
            updater  => {
                type      => 'blog',
                condition => sub {
                    !(  MT::Permission->exist(
                            { blog_id => $_[0]->id, author_id => 0 }
                        )
                    );
                },
                code => sub {
                    my $perm = new MT::Permission;
                    $perm->entry_prefs('Advanced|Bottom');
                    $perm->blog_id( $_[0]->id );
                    $perm->author_id(0);
                    $perm->save;
                },
                label => 'Setting new entry defaults for blogs...',
            }
        },
        'core_upgrade_tag_categories' => {
            version_limit => 3.20021,
            priority      => 9.3,
            updater       => {
                type => 'category',
                condition =>
                    sub { ( $_[0]->description || '' ) =~ m/<!--tag-->/ },
                code => sub {
                    my ($cat) = @_;
                    require MT::Placement;
                    require MT::Entry;
                    my @e = MT::Entry->load(
                        undef,
                        {   join => [
                                'MT::Placement', 'entry_id',
                                { category_id => $cat->id }
                            ]
                        }
                    );
                    my $tag_name = $cat->label;
                    foreach my $e (@e) {
                        my $tags = $e->tags;
                        $e->tags( $tags, $tag_name );
                        $e->save;
                    }
                },
                label => 'Migrating any "tag" categories to new tags...',
            }
        },
        'core_init_blog_custom_dynamic_templates' => {
            on_field => 'MT::Blog->custom_dynamic_templates',
            priority => 3.1,
            updater  => {
                type      => 'blog',
                condition => sub { !defined $_[0]->custom_dynamic_templates },
                code      => sub { $_[0]->custom_dynamic_templates('none') },
                label     => 'Assigning custom dynamic template settings...',
                sql       => q{update mt_blog
                            set blog_custom_dynamic_templates = 'none'
                          where blog_custom_dynamic_templates is null},
            }
        },
        'core_init_author_type' => {
            on_field => 'MT::Author->type',
            priority => 3.1,
            updater  => {
                type      => 'author',
                condition => sub { !$_[0]->type },
                code      => sub { $_[0]->type(1) },
                label     => 'Assigning user types...',
                sql       => 'update mt_author set author_type = 1
                        where author_type is null or author_type = 0',
            }
        },
        'core_init_category_parent' => {
            on_field => 'MT::Category->parent',
            priority => 3.1,
            updater  => {
                type      => 'category',
                condition => sub { !defined $_[0]->parent },
                code      => sub { $_[0]->parent(0) },
                label     => 'Assigning category parent fields...',
                sql       => 'update mt_category set category_parent = 0
                        where category_parent is null',
            }
        },
        'core_init_template_build_dynamic' => {
            on_field => 'MT::Template->build_dynamic',
            priority => 3.1,
            updater  => {
                type      => 'template',
                condition => sub { !defined $_[0]->build_dynamic },
                code      => sub { $_[0]->build_dynamic(0) },
                label     => 'Assigning template build dynamic settings...',
                sql => 'update mt_template set template_build_dynamic = 0
                        where template_build_dynamic is null',
            }
        },
        'core_init_comment_visible' => {
            on_field => 'MT::Comment->visible',
            priority => 3.1,
            updater  => {
                type      => 'comment',
                condition => sub { !defined $_[0]->visible },
                code      => sub { $_[0]->visible(1) },
                label     => 'Assigning visible status for comments...',
                sql       => 'update mt_comment set comment_visible = 1
                        where comment_visible is null',
            }
        },
        'core_init_tbping_visible' => {
            on_field => 'MT::TBPing->visible',
            priority => 3.1,
            updater  => {
                type      => 'tbping',
                condition => sub { !defined $_[0]->visible },
                code      => sub { $_[0]->visible(1) },
                label     => 'Assigning visible status for TrackBacks...',
                sql       => 'update mt_tbping set tbping_visible = 1
                        where tbping_visible is null',
            }
        },
        'core_init_category_basename' => {
            version_limit => 3.2002,
            priority      => 3.1,
            updater       => {
                type      => 'category',
                condition => sub { !defined $_[0]->basename },
                code      => sub {
                    require MT::Util;
                    my $cat  = shift;
                    my %args = @_;
                    $args{from} < 3.20021
                        ? $cat->basename(
                        MT::Util::make_unique_category_basename($cat) )
                        : 1;
                },
                label => 'Assigning basename for categories...',
            }
        },
        'core_set_author_status' => {
            version_limit => 3.301,
            priority      => 3.1,
            updater       => {
                type      => 'author',
                label     => 'Assigning user status...',
                condition => sub {
                    ( $_[0]->type == 1 ) && ( !defined $_[0]->status );
                },
                code => sub {
                    shift->status(1);
                },
                sql => 'update mt_author set author_status = 1
                        where author_type = 1 and author_status is null',
            }
        },
        'core_migrate_permissions_to_roles' => {
            version_limit => 3.3101,
            priority      => 3.2,
            updater       => {
                type      => 'permission',
                label     => 'Migrating permissions to roles...',
                condition => sub { $_[0]->blog_id },
                code      => \&_migrate_permission_to_role,
            }
        },
        'core_remove_dynamic_site_bootstrapper' => {
            code          => \&remove_mtviewphp,
            version_limit => 3.3101,
            priority      => 5.1,
        },
        'core_migrate_commenter_auth' => {
            code          => \&migrate_commenter_auth,
            version_limit => 3.3101,
            priority      => 3.1,
        },
    };
}

my $perm_role_names = {
    4096  => 'Blog Administrator',    # administer_blog
    30687 => 'Blog Administrator'
    ,    # 32767 - 2048(not comment) - 32(reserved) = all permissions in MT3.3
    14303 => 'Blog Administrator'
    ,    # 16383 - 2048(not comment) - 32(reserved) = all permissions in MT3.2
    2 => 'Writer',                 # post
    6 => 'Writer (can upload)',    # post + upload
    17032 =>
        'Editor',    # edit_all_posts + edit_tags + edit_categories + rebuild
    17036 => 'Editor (can upload)', # Editor + upload
    144   => 'Designer',            # edit_templates + rebuild
    17292 => 'Publisher',           # Editor (can upload) + send_notifications
};

sub _migrate_permission_to_role {
    my $perm           = shift;
    my $full_perm_mask = 0;

    return unless $perm->author_id;
    my $user = MT::Author->load( $perm->author_id );
    if ( !$user ) {
        $perm->remove;
        return;
    }

    # Don't bother with non-AUTHOR types
    return unless $user->type == 1;

    my $role_mask = $perm->role_mask;
    $role_mask -= 32
        if ( 32 & $role_mask ) == 32;    # for permissions before 3.2

    if ( !$full_perm_mask ) {

        # only consider blog permissions that are supported (exclude
        # now reserved permission bits like 32).
        foreach my $key ( keys %MT::Upgrade::LegacyPerms ) {
            next
                if $MT::Upgrade::LegacyPerms{$key}
                =~ m/^not_/;    # skip exclusion permissions
            $full_perm_mask |= $key;
        }
    }

    $role_mask = $full_perm_mask & $role_mask;

    # '0' permission, not used for permissions, just prefs
    return unless $role_mask;

    my $name;
    $name = MT->translate( $perm_role_names->{$role_mask} )
        if $perm_role_names->{$role_mask};
    $name ||= MT->translate( "Custom ([_1])", $role_mask );
    require MT::Role;
    my $role = MT::Role->load( { name => $name } );
    if ($role) {
        if (   ( $role->role_mask != $role_mask )
            && ( ( 4096 != $role->role_mask ) && ( 30687 != $role_mask ) ) )
        {
            $role = undef;
        }
    }
    unless ($role) {
        $role = new MT::Role;
        $role->name($name);
        $role->description(
            MT->translate(
                "This role was generated by Movable Type upon upgrade.")
        );
        $role->role_mask($role_mask);
        $role->save;
    }
    my $blog = MT::Blog->load( $perm->blog_id );
    $user->add_role( $role, $blog ) if $blog;
}

sub remove_mtviewphp {
    my $self = shift;
    my (%param) = @_;

    require MT::Template;
    $self->progress(
        $self->translate_escape(
            'Removing Dynamic Site Bootstrapper index template...')
    );
    MT::Template->remove( { type => 'index', outfile => 'mtview.php' } );
    1;
}

sub migrate_commenter_auth {
    my ($self)  = shift;
    my (%param) = @_;

    my $iter = MT::Blog->load_iter( { 'allow_reg_comments' => 1 } );
    while ( my $blog = $iter->() ) {
        $blog->commenter_authenticators('TypeKey')
            if $blog->remote_auth_token;
        $blog->save;
    }
    1;
}

# A note about upgrade routines:
#
# They should all be 'safe' to execute, regardless of the
# active schema. In other words, running them twice in a row
# should not cause any errors or break the schema.

sub core_remove_unique_constraints {
    my $self = shift;

    my $driver = MT::Object->driver;
    if ( ref $driver->dbd =~ m/::Pg$/ ) {

        # category, author, permission, template
        $driver->sql(
            [   'alter table mt_category drop constraint mt_category_category_blog_id_key',
                'create index mt_category_label on mt_category (category_label)',

                'alter table mt_author drop constraint mt_author_author_name_key',
                'create index mt_author_name on mt_author (author_name)',
                'alter table mt_permission drop constraint mt_permission_permission_blog_id_key',
                'create index mt_permission_blog_id on mt_permission (permission_blog_id)',
                'alter table mt_template drop constraint mt_template_template_blog_id_key',
                'create index mt_template_blog_id on mt_template (template_blog_id)'
            ]
        );
    }
    elsif ( ref $driver->dbd =~ m/::mysql$/ ) {
        $driver->sql(
            [   'alter table mt_category drop index category_blog_id',
                'create index category_blog_id on mt_category (category_blog_id)',
                'create index category_label on mt_category (category_label)',
                'alter table mt_author drop index author_name',
                'create index author_name on mt_author (author_name)',
                'alter table mt_permission drop index permission_blog_id',
                'create index permission_blog_id on mt_permission (permission_blog_id)',
                'alter table mt_template drop index template_blog_id',
                'create index template_blog_id on mt_template (template_blog_id)'
            ]
        );
    }
    1;
}

sub core_create_config_table {
    my $self = shift;

    require MT::Config;
    my $config = MT::Config->load();
    if ( !$config ) {

  #$self->progress($self->translate_escape("Creating configuration record."));
        $config = MT::Config->new;
        $config->data('');
        $config->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $config->errstr
            )
            );
    }
    return 1;
}

sub core_set_enable_archive_paths {
    my $self = shift;
    MT->config->EnableArchivePaths( 1, 1 );
    return 1;
}

#############################################################################

{
    my %HighASCII = (
        "\xc0" => 'A',     # A`
        "\xe0" => 'a',     # a`
        "\xc1" => 'A',     # A'
        "\xe1" => 'a',     # a'
        "\xc2" => 'A',     # A^
        "\xe2" => 'a',     # a^
        "\xc4" => 'Ae',    # A:
        "\xe4" => 'ae',    # a:
        "\xc3" => 'A',     # A~
        "\xe3" => 'a',     # a~
        "\xc8" => 'E',     # E`
        "\xe8" => 'e',     # e`
        "\xc9" => 'E',     # E'
        "\xe9" => 'e',     # e'
        "\xca" => 'E',     # E^
        "\xea" => 'e',     # e^
        "\xcb" => 'Ee',    # E:
        "\xeb" => 'ee',    # e:
        "\xcc" => 'I',     # I`
        "\xec" => 'i',     # i`
        "\xcd" => 'I',     # I'
        "\xed" => 'i',     # i'
        "\xce" => 'I',     # I^
        "\xee" => 'i',     # i^
        "\xcf" => 'Ie',    # I:
        "\xef" => 'ie',    # i:
        "\xd2" => 'O',     # O`
        "\xf2" => 'o',     # o`
        "\xd3" => 'O',     # O'
        "\xf3" => 'o',     # o'
        "\xd4" => 'O',     # O^
        "\xf4" => 'o',     # o^
        "\xd6" => 'Oe',    # O:
        "\xf6" => 'oe',    # o:
        "\xd5" => 'O',     # O~
        "\xf5" => 'o',     # o~
        "\xd8" => 'Oe',    # O/
        "\xf8" => 'oe',    # o/
        "\xd9" => 'U',     # U`
        "\xf9" => 'u',     # u`
        "\xda" => 'U',     # U'
        "\xfa" => 'u',     # u'
        "\xdb" => 'U',     # U^
        "\xfb" => 'u',     # u^
        "\xdc" => 'Ue',    # U:
        "\xfc" => 'ue',    # u:
        "\xc7" => 'C',     # ,C
        "\xe7" => 'c',     # ,c
        "\xd1" => 'N',     # N~
        "\xf1" => 'n',     # n~
        "\xdf" => 'ss',
    );
    my $HighASCIIRE = join '|', keys %HighASCII;

    sub mt32_convert_high_ascii {
        my ($s) = @_;
        $s =~ s/($HighASCIIRE)/$HighASCII{$1}/g;
        $s;
    }
}

sub mt32_iso_dirify {
    my $s = $_[0];
    my $sep;
    if ( $_[1] && ( $_[1] ne '1' ) ) {
        $sep = $_[1];
    }
    else {
        $sep = '_';
    }
    $s = mt32_convert_high_ascii($s);    ## convert high-ASCII chars to 7bit.
    $s = lc $s;                          ## lower-case.
    $s = MT::Util::remove_html($s);      ## remove HTML tags.
    $s =~ s!&[^;\s]+;!!g;                ## remove HTML entities.
    $s =~ s![^\w\s]!!g;                  ## remove non-word/space chars.
    $s =~ s! +!$sep!g;                   ## change space chars to underscores.
    $s;
}

sub mt32_utf8_dirify {
    my $s = $_[0];
    my $sep;
    if ( $_[1] && ( $_[1] ne '1' ) ) {
        $sep = $_[1];
    }
    else {
        $sep = '_';
    }
    $s = mt32_xliterate_utf8($s)
        ;    ## convert two-byte UTF-8 chars to 7bit ASCII
    $s = lc $s;                        ## lower-case.
    $s = MT::Util::remove_html($s);    ## remove HTML tags.
    $s =~ s!&[^;\s]+;!!g;              ## remove HTML entities.
    $s =~ s![^\w\s]!!g;                ## remove non-word/space chars.
    $s =~ s! +!$sep!g;                 ## change space chars to underscores.
    $s;
}

sub mt32_dirify {
    ( $MT::VERSION && MT->instance->{cfg}->PublishCharset =~ m/utf-?8/i )
        ? mt32_utf8_dirify(@_) : mt32_iso_dirify(@_);
}

sub mt32_xliterate_utf8 {
    my ($str) = @_;
    my %utf8_table = (
        "\xc3\x80" => 'A',             # A`
        "\xc3\xa0" => 'a',             # a`
        "\xc3\x81" => 'A',             # A'
        "\xc3\xa1" => 'a',             # a'
        "\xc3\x82" => 'A',             # A^
        "\xc3\xa2" => 'a',             # a^
        "\xc3\x84" => 'Ae',            # A:
        "\xc3\xa4" => 'ae',            # a:
        "\xc3\x83" => 'A',             # A~
        "\xc3\xa3" => 'a',             # a~
        "\xc3\x88" => 'E',             # E`
        "\xc3\xa8" => 'e',             # e`
        "\xc3\x89" => 'E',             # E'
        "\xc3\xa9" => 'e',             # e'
        "\xc3\x8a" => 'E',             # E^
        "\xc3\xaa" => 'e',             # e^
        "\xc3\x8b" => 'Ee',            # E:
        "\xc3\xab" => 'ee',            # e:
        "\xc3\x8c" => 'I',             # I`
        "\xc3\xac" => 'i',             # i`
        "\xc3\x8d" => 'I',             # I'
        "\xc3\xad" => 'i',             # i'
        "\xc3\x8e" => 'I',             # I^
        "\xc3\xae" => 'i',             # i^
        "\xc3\x8f" => 'Ie',            # I:
        "\xc3\xaf" => 'ie',            # i:
        "\xc3\x92" => 'O',             # O`
        "\xc3\xb2" => 'o',             # o`
        "\xc3\x93" => 'O',             # O'
        "\xc3\xb3" => 'o',             # o'
        "\xc3\x94" => 'O',             # O^
        "\xc3\xb4" => 'o',             # o^
        "\xc3\x96" => 'Oe',            # O:
        "\xc3\xb6" => 'oe',            # o:
        "\xc3\x95" => 'O',             # O~
        "\xc3\xb5" => 'o',             # o~
        "\xc3\x98" => 'Oe',            # O/
        "\xc3\xb8" => 'oe',            # o/
        "\xc3\x99" => 'U',             # U`
        "\xc3\xb9" => 'u',             # u`
        "\xc3\x9a" => 'U',             # U'
        "\xc3\xba" => 'u',             # u'
        "\xc3\x9b" => 'U',             # U^
        "\xc3\xbb" => 'u',             # u^
        "\xc3\x9c" => 'Ue',            # U:
        "\xc3\xbc" => 'ue',            # u:
        "\xc3\x87" => 'C',             # ,C
        "\xc3\xa7" => 'c',             # ,c
        "\xc3\x91" => 'N',             # N~
        "\xc3\xb1" => 'n',             # n~
        "\xc3\x9f" => 'ss',            # double-s
    );

    $str =~ s/([\200-\377]{2})/$utf8_table{$1}||''/ge;
    $str;
}

sub core_set_superuser {
    my $self = shift;

    my $SuperUser = $self->superuser();
    my $app       = $self->app();
    my $author;
    if ( ( ref $app ) && ( $app->{author} ) ) {
        require MT::Author;
        $self->progress(
            $self->translate_escape(
                "Setting your permissions to administrator.")
        );
        $author = MT::Author->load( $app->{author}->id );
    }
    elsif ($SuperUser) {
        require MT::Author;
        $self->progress(
            $self->translate_escape(
                "Setting your permissions to administrator.")
        );
        $author = MT::Author->load($SuperUser);
    }

    if ($author) {
        $author->is_superuser(1);
        $author->save
            or return $self->error(
            $self->translate_escape(
                "Error saving record: [_1].",
                $author->errstr
            )
            );
    }

    1;
}

1;
