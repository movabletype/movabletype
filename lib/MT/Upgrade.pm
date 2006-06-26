# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Upgrade;

use strict;
use MT::ErrorHandler;

@MT::Upgrade::ISA = 'MT::ErrorHandler';

# The upgrade process...
#
#    * Database check of all data types
#      - assign default values for 'null' columns
#    * Template check for all weblogs

use vars qw(%classes %functions $App $DryRun $Installing $SuperUser 
            $CLI $MAX_TIME $MAX_ROWS @steps);
sub BEGIN {
    $MAX_TIME = 5;
    $MAX_ROWS = 100;

    %classes = map { ("MT::$_" => 1) } qw( Author Blog Category Comment
                                           Entry FileInfo IPBanList Log
                                           Notification Permission Placement
                                           PluginData Session TBPing Template
                                           TemplateMap Trackback Config
                                           Tag ObjectTag );

    %functions = (
        # standard routines
        'core_upgrade_begin' => {
            code => \&core_upgrade_begin,
            priority => 1,
        },
        'core_fix_class' => {
            code => \&core_fix_class,
            priority => 2,
        },
        'core_add_column' => {
            code => sub { shift->core_column_action('add', @_) }
,
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
        'core_install_templates' => {
            code => sub {
                my $self = shift; $self->upgrade_templates(Install => 1)
            },
            priority => 5,
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
    
        # < 2.0
        'core_create_placements' => {
            version_limit => 2.0,
            code => \&core_update_records,
            priority => 9.1,
            updater => {
                class => 'MT::Entry',
                message => 'Creating entry category placements...',
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
            code => \&core_update_records,
            priority => 9.2,
            updater => {
                class => 'MT::Placement',
                message => 'Updating category placements...',
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
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Blog',
                message => 'Assigning comment/moderation settings...',
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
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Blog',
                message => 'Setting blog basename limits...',
                condition => sub { !$_[0]->basename_limit },
                code => sub { $_[0]->basename_limit(15) },
                sql => 'update mt_blog set blog_basename_limit = 15
                         where blog_basename_limit is null
                            or blog_basename_limit < 15',
            },
        },
        'core_set_default_blog_extension' => {
            version_limit => 3.2,
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Blog',
                message => 'Setting default blog file extension...',
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
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Entry',
                message => 'Updating comment status flags...',
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
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Comment',
                message => 'Updating commenter records...',
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
        'core_set_blog_admins' => {
            version_limit => 3.2,
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Permission',
                message => 'Assigning blog administration permissions...',
                condition => sub { $_[0]->can_edit_config },
                code => sub { $_[0]->can_administer_blog(1) },
            }
        },
        'core_set_blog_allow_pings' => {
            version_limit => 3.2,
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Blog',
                message => 'Setting blog allow pings status...',
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
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Blog',
                message => 'Updating blog comment email requirements...',
                condition => sub { !$_[0]->require_comment_emails },
                code => sub { $_[0]->require_comment_emails(1)
                                  if !$_[0]->allow_anon_comments },
            }
        },
        'core_populate_entry_basenames' => {
            version_limit => 3.2,
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Entry',
                condition => sub { !$_[0]->basename },
                code => sub { my $entry = shift; my %args = @_;
                    $args{from} < 3.20021
                        ? $entry->basename(mt32_dirify($entry->title))
                        : 1;
                },
                message => 'Assigning entry basenames for old entries...',
            }
        },
        'core_set_api_password' => {
            version_limit => 3.2,
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Author',
                condition => sub { ($_[0]->type == 1) && (($_[0]->api_password || '') eq '') },
                code => sub { $_[0]->api_password($_[0]->password) },
                message => 'Updating author web services passwords...',
            }
        },
        'core_create_config_table' => {
            version_limit => 3.2,
            code => \&core_create_config_table,
            priority => 9.3,
        },
        'core_deprecate_old_style_archive_links' => {
            version_limit => 3.2,
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Blog',
                message => 'Updating blog old archive link status...',
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
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Entry',
                condition => sub { ($_[0]->week_number || 0) < 54 },
                code => sub { 1 },
                message => 'Updating entry week numbers...',
            }
        },
        'core_set_tag_permissions' => {
            version_limit => 3.20021,
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Permission',
                condition => sub { !$_[0]->can_edit_tags && !$_[0]->can_administer_blog },
                code => sub { $_[0]->can_edit_tags($_[0]->can_edit_categories) },
                message => 'Updating user permissions for editing tags...',
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
                class => 'MT::Blog',
                condition => sub { !(scalar MT::Permission->load({
                    blog_id => $_[0]->id, author_id => 0 })) },
                code => sub {
                    my $perm = new MT::Permission;
                    $perm->entry_prefs('Advanced|Bottom');
                    $perm->blog_id($_[0]->id);
                    $perm->author_id(0);
                    $perm->save;
                },
                message => 'Setting new entry defaults for weblogs...',
            }
        },
        'core_upgrade_tag_categories' => {
            version_limit => 3.20021,
            code => \&core_update_records,
            priority => 9.3,
            updater => {
                class => 'MT::Category',
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
                message => 'Migrating any "tag" categories to new tags...',
            }
        },
        'core_init_blog_custom_dynamic_templates' => {
            code => \&core_update_records,
            on_field => 'MT::Blog->custom_dynamic_templates',
            priority => 3.1,
            updater => {
                class => 'MT::Blog',
                condition => sub { !defined $_[0]->custom_dynamic_templates },
                code => sub { $_[0]->custom_dynamic_templates('none') },
                message => 'Assigning custom dynamic template settings...',
                sql => q{update mt_blog
                            set blog_custom_dynamic_templates = 'none'
                          where blog_custom_dynamic_templates is null},
            }
        },
        'core_init_author_type' => {
            code => \&core_update_records,
            on_field => 'MT::Author->type',
            priority => 3.1,
            updater => {
                class => 'MT::Author',
                condition => sub { !$_[0]->type },
                code => sub { $_[0]->type(1) },
                message => 'Assigning author types...',
                sql => 'update mt_author set author_type = 1
                        where author_type is null or author_type = 0',
            }
        },
        'core_init_category_parent' => {
            code => \&core_update_records,
            on_field => 'MT::Category->parent',
            priority => 3.1,
            updater => {
                class => 'MT::Category',
                condition => sub { !defined $_[0]->parent },
                code => sub { $_[0]->parent(0) },
                message => 'Assigning category parent fields...',
                sql => 'update mt_category set category_parent = 0
                        where category_parent is null',
            }
        },
        'core_init_template_build_dynamic' => {
            code => \&core_update_records,
            on_field => 'MT::Template->build_dynamic',
            priority => 3.1,
            updater => {
                class => 'MT::Template',
                condition => sub { !defined $_[0]->build_dynamic },
                code => sub { $_[0]->build_dynamic(0) },
                message => 'Assigning template build dynamic settings...',
                sql => 'update mt_template set template_build_dynamic = 0
                        where template_build_dynamic is null',
            }
        },
        'core_init_comment_visible' => {
            code => \&core_update_records,
            on_field => 'MT::Comment->visible',
            priority => 3.1,
            updater => {
                class => 'MT::Comment',
                condition => sub { !defined $_[0]->visible },
                code => sub { $_[0]->visible(1) },
                message => 'Assigning visible status for comments...',
                sql => 'update mt_comment set comment_visible = 1
                        where comment_visible is null',
            }
        },
        'core_init_comment_junk_status' => {
            code => \&core_update_records,
            on_field => 'MT::Comment->junk_status',
            priority => 3.1,
            updater => {
                class => 'MT::Comment',
                condition => sub { !defined $_[0]->junk_status },
                code => sub { $_[0]->junk_status(1) },
                message => 'Assigning junk status for comments...',
                sql => 'update mt_comment set comment_junk_status = 1
                        where comment_junk_status is null',
            }
        },
        'core_init_tbping_visible' => {
            code => \&core_update_records,
            on_field => 'MT::TBPing->visible',
            priority => 3.1,
            updater => {
                class => 'MT::TBPing',
                condition => sub { !defined $_[0]->visible },
                code => sub { $_[0]->visible(1) },
                message => 'Assigning visible status for TrackBacks...',
                sql => 'update mt_tbping set tbping_visible = 1
                        where tbping_visible is null',
            }
        },
        'core_init_tbping_junk_status' => {
            code => \&core_update_records,
            on_field => 'MT::TBPing->junk_status',
            priority => 3.1,
            updater => {
                class => 'MT::TBPing',
                condition => sub { !defined $_[0]->junk_status },
                code => sub { $_[0]->junk_status(1) },
                message => 'Assigning junk status for TrackBacks...',
                sql => 'update mt_tbping set tbping_junk_status = 1
                        where tbping_junk_status is null',
            }
        },
        'core_init_category_basename' => {
            code => \&core_update_records,
            version_limit => 3.2002,
            priority => 3.1,
            updater => {
                class => 'MT::Category',
                condition => sub { !defined $_[0]->basename },
                code => sub { my $cat = shift; my %args = @_;
                    $args{from} < 3.20021
                        ? $cat->basename(mt32_dirify($cat->label))
                        : 1;
                },
                message => 'Assigning basename for categories...',
            }
        }
    );
}

sub register_class {
    my $pkg = shift;
    my ($name, $param) = @_;
    my @classes = ref $name eq 'ARRAY' ? @$name : ([$name, $param]);
    foreach (@classes) {
        if (ref $_ eq 'ARRAY') {
            $classes{$_[0]} = $_[1];
        } else {
            $classes{$_} = 1;
        }
    }
}

sub register_upgrade_function {
    my $pkg = shift;
    my ($name, $param) = @_;
    if (ref $name eq 'HASH') {
        foreach (keys %$name) {
            $functions{$_} = $name->{$_};
            $functions{$_}->{priority} ||= 9.5;
        }
    } else {
        my @fns = ref $name eq 'ARRAY' ? @$name : ([$name, $param]);
        $functions{$_[0]} = $_[1] foreach @fns;
    }
}

sub init {
    my $pkg = shift;
    foreach my $plugin (@MT::Plugins) {
        if (my $classes = $plugin->object_classes) {
            $pkg->register_class($classes);
        }
        if (my $functions = $plugin->upgrade_functions) {
            foreach (keys %$functions) {
                # associate plugin with upgrade function
                $_->{plugin} = $plugin->{plugin_sig};
            }
            $pkg->register_upgrade_function($functions);
        }
    }
}

# Step execution...

# iterate routines:
#     no parameters, start with offset == 0
#     offset parameter, pass thru
#     if routine returns -1, routine is done
#     if routine returns false, routine failed
#     if routine returns > 0, that's the new offset

sub run_step {
    my $self = shift;
    my ($step) = @_;
    my ($name, %param) = @$step;

    if (my $fn = $functions{$name}) {
        local $MT::CallbacksEnabled = 0;
        if ($fn->{condition}) {
            next unless $fn->{condition}->($self, %param);
        }
        my %update_params;
        if ($fn->{updater}) {
            %update_params = %{$fn->{updater}};
        }
        my $result = $fn->{code}->($self, %param, %update_params, step => $name);
        if ((defined $result) && ($result > 1)) {
            $param{offset} = $result; $result = 1;
            $self->add_step($name, %param);
        }
        return $result;
    } else {
        return $self->error($self->translate("Invalid upgrade function: [_1].", $name));
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
        $self->install_database($opt{User});
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
    # this will make sure system templates are defined...
    $self->add_step('core_install_templates');
    $self->add_step('core_finish');
    1;
}

sub check_schema {
    my $self = shift;
    foreach my $class (keys %classes) {
        $self->check_class($class);
    }
    1;
}

sub check_class {
    my $self = shift;
    my ($class) = @_;

    return $self->error($self->translate("Error loading class: [_1].", $class))
        unless eval 'require '.$class;

    if (my $result = $self->class_diff($class)) {
        if ($result->{fix}) {
            $self->add_step('core_fix_class', class => $class);
        } else {
            $self->add_step('core_add_column', class => $class)
                if $result->{add};
            $self->add_step('core_alter_column', class => $class)
                if $result->{alter};
            $self->add_step('core_drop_column', class => $class)
                if $result->{drop};
        }
    }
    1;
}

sub class_diff {
    my $self = shift;
    my ($class) = @_;

    return $self->error($self->translate("Error loading class: [_1].", $class))
        unless eval 'require '.$class;

    my $table = $class->datasource;
    my $defs = $class->column_defs;

    my $driver = MT::Object->driver;
    my $db_defs = $driver->column_defs($class);

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
                } elsif ($driver->type2db($col_def)
                      ne $driver->type2db($db_def)) {
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
        if ((@cols_to_add && !$driver->can_add_column) ||
            (@cols_to_alter && !$driver->can_alter_column) || 
            (@cols_to_drop && !$driver->can_drop_column)) {
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

    $self->progress($self->translate("Creating initial weblog and author records..."));

    local $MT::CallbacksEnabled = 1;

    require MT::L10N;
    my $lang = exists $param{user_lang} ? $param{user_lang} : MT::ConfigMgr->instance->DefaultLanguage;
    my $LH = MT::L10N->get_handle($lang);

    # TBD: parameter for username/password provided by user from $app
    use URI::Escape;
    my $author = MT::Author->new;
    $author->name(exists $param{user_name} ? uri_unescape($param{user_name}) : 'Melody');
    $author->type(MT::Author::AUTHOR());
    $author->set_password(exists $param{user_password} ? $param{user_password} : 'Nelson');
    $author->email(exists $param{user_email} ? $param{user_email} : '');
    $author->hint(exists $param{user_hint} ? uri_unescape($param{user_hint}) : '');
    $author->is_superuser(1);
    $author->can_create_blog(1);
    $author->can_view_log(1);
    $author->preferred_language($lang);
    $author->save or return $self->error($self->translate("Error saving record: [_1].", $author->errstr));

    require MT::Blog;
    my $blog = MT::Blog->new;
    $blog->set_defaults();
    $blog->name($LH->maketext('First Weblog'));
    $blog->save or return $self->error($self->translate("Error saving record: [_1].", $blog->errstr));

    require MT::Permission;
    my $perms = MT::Permission->new;
    $perms->author_id($author->id);
    $perms->blog_id($blog->id);
    $perms->set_full_permissions;
    $perms->save or return $self->error($self->translate("Error saving record: [_1].", $perms->errstr));

    1;
}

sub upgrade_templates {
    my $self = shift;
    my (%opt) = @_;

    my $install = $opt{Install} || 0;

    my $updated = 0;

    my $tmpl_list;
    require MT::DefaultTemplates;
    $tmpl_list = MT::DefaultTemplates->templates;
    return $self->error($self->translate("Can't find default template list; where is 'default-templates.pl'? Error: [_1]", $@))
        if $@ || !$tmpl_list || ref($tmpl_list) ne 'ARRAY' || !@$tmpl_list;

    my $mt = MT->instance;
    my @arch_tmpl;

    require MT::Template;
    require MT::Blog;

    for my $val (@$tmpl_list) {
        if (!$install) {
            next if $val->{type} =~ m/^(archive|individual|category|index|custom)$/;
        }

        $val->{name} = $mt->translate($val->{name});
        $val->{text} = $mt->translate_templatized($val->{text});

        my $terms = {};
        $terms->{type} = $val->{type};
        $terms->{name} = $val->{name}
            if $val->{type} =~ m/^(archive|individual|category|index|custom)$/;
        my @exists = MT::Template->load( $terms,
                                         { limit => 1 } );
        next if @exists;

        $self->progress($self->translate("Creating new template: '[_1]'.", $val->{name}));

        my $iter = MT::Blog->load_iter();
        while (my $blog = $iter->()) {
            my $obj = MT::Template->new;
            $obj->build_dynamic(0);
            $obj->set_values($val);
            $obj->blog_id($blog->id);
            $obj->save or return $self->error($self->translate("Error saving record: [_1].", $obj->errstr));
            $updated = 1;
            if ($val->{type} eq 'archive' || $val->{type} eq 'individual' ||
                $val->{type} eq 'category') {
                push @arch_tmpl, $obj;
            }
        }
    }

    if (@arch_tmpl) {
        $self->progress($self->translate("Mapping templates to blog archive types..."));
        require MT::TemplateMap;
    
        for my $tmpl (@arch_tmpl) {
            my(@at);
            if ($tmpl->type eq 'archive') {
                @at = qw( Daily Weekly Monthly );
            } elsif ($tmpl->type eq 'category') {
                @at = qw( Category );
            } elsif ($tmpl->type eq 'individual') {
                @at = qw( Individual );
            }
            for my $at (@at) {
                my $map = MT::TemplateMap->new;
                $map->archive_type($at);
                $map->is_preferred(1);
                $map->template_id($tmpl->id);
                $map->blog_id($tmpl->blog_id);
                $map->save or return $self->error($self->translate("Error saving record: [_1].", $map->errstr));
            }
        }
    }

    $updated;
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

    my $plugin_ver = MT->config('PluginSchemaVersion');

    # run any functions that define a version_limit and where the schema we're
    # upgrading from is below that limit.
    foreach (keys %functions) {
        my $save_from = $from;
        {
            my $func = $functions{$_};
            if ($func->{plugin_sig} && $plugin_ver) {
                $from = $plugin_ver->{$func->{plugin_sig}};
            }
            if ($func->{version_limit} && ($from < $func->{version_limit})) {
                $self->add_step($_, from => $from);
            }
        }
        $from = $save_from;
    }

    1;
}

sub pre_create_table {
    my $self = shift;
    my ($class) = @_;
    MT::Object->driver->drop_sequence($class);
}

sub post_create_table {
    my $self = shift;
    my ($class) = @_;

    MT::Object->driver->create_sequence($class);

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

sub translate {
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

sub core_fix_class {
    my $self = shift;
    my (%param) = @_;

    my $class = $param{class};
    return $self->error($self->translate("Error loading class: [_1].", $class))
        unless eval 'require '.$class;

    my $result = $self->class_diff($class);
    return 1 unless $result;
    return 1 unless $result->{fix};

    my $alter = $result->{alter};
    my $add = $result->{add};
    my $drop = $result->{drop};

    my $driver = MT::Object->driver;
    my @stmts;
    push @stmts, sub { $self->pre_upgrade_class($class) };
    push @stmts, $driver->upgrade_begin($class);
    push @stmts, sub { $self->pre_create_table($class) };
    push @stmts, sub { $self->pre_add_column($class, $add) } if $add;
    push @stmts, sub { $self->pre_alter_column($class, $alter) } if $alter;
    push @stmts, sub { $self->pre_drop_column($class, $drop) } if $drop;
    push @stmts, $driver->fix_class($class);
    push @stmts, sub { $self->post_create_table($class) };
    push @stmts, sub { $self->post_add_column($class, $add) } if $add;
    push @stmts, sub { $self->post_alter_column($class, $alter) } if $alter;
    push @stmts, sub { $self->post_drop_column($class, $drop) } if $drop;
    push @stmts, $driver->upgrade_end($class);
    push @stmts, sub { $self->post_upgrade_class($class) };
    $self->run_statements($class, @stmts);
}

sub core_column_action {
    my $self = shift;
    my ($action, %param) = @_;

    my $class = $param{class};
    my $result = $self->class_diff($class);
    return 1 unless $result;
    my $columns = $result->{$action};
    return 1 unless $columns;

    my $pre_method = "pre_${action}_column";
    my $post_method = "post_${action}_column";
    my $method = "${action}_column";

    my $driver = MT::Object->driver;
    my @stmts;
    push @stmts, sub { $self->pre_upgrade_class($class) };
    push @stmts, $driver->upgrade_begin($class);
    push @stmts, sub { $self->$pre_method($class, $columns) };
    push @stmts, $driver->$method($class, $_->{name}) foreach @$columns;
    push @stmts, sub { $self->$post_method($class, $columns) };
    push @stmts, $driver->upgrade_end($class);
    push @stmts, sub { $self->post_upgrade_class($class) };
    $self->run_statements($class, @stmts);
}

sub run_statements {
    my $self = shift;
    my ($class, @stmts) = @_;

    my $driver = MT::Object->driver;
    my $dbh = $driver->{dbh};
    my $mt = MT->instance;

    my $updated = 0;
    if (@stmts) {
        $self->progress($self->translate("Upgrading table for [_1]", $class));
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
        $self->progress($self->translate("Upgrading database from version [_1].", $from_schema)) if $from_schema < $cur_schema;
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
    my $cfg = MT::ConfigMgr->instance;
    my $cur_schema = MT->instance->schema_version;
    my $old_schema = $cfg->SchemaVersion || 0;
    $self->progress($self->translate("Database has been upgraded to version [_1].", $cur_schema)) if $cur_schema > $old_schema;
    $cfg->SchemaVersion( $cur_schema, 1 );

    my $plugin_schema = $cfg->PluginSchemaVersion || {};
    foreach my $plugin (@MT::Plugins) {
        my $ver = $plugin->schema_version;
        next unless $ver;
        my $old_plugin_schema = $plugin_schema->{$plugin->{plugin_sig}} || 0;
        if ($old_plugin_schema && ($ver > $old_plugin_schema)) {
            $self->progress($self->translate("Plugin '[_1]' upgraded successfully.", $plugin->name));
        } elsif ($ver && !$old_plugin_schema) {
            $self->progress($self->translate("Plugin '[_1]' installed successfully.", $plugin->name));
        }
        $plugin_schema->{$plugin->{plugin_sig}} = $ver;
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
        $self->progress($self->translate("Setting your permissions to administrator."));
        $author = MT::Author->load($app->{author}->id);
    } elsif ($SuperUser) {
        require MT::Author;
        $self->progress($self->translate("Setting your permissions to administrator."));
        $author = MT::Author->load($SuperUser);
    }

    if ($author) {
        $author->is_superuser(1);
        $author->save or return $self->error($self->translate("Error saving record: [_1].", $author->errstr));
    }

    1;
}

sub core_remove_unique_constraints {
    my $self = shift;

    my $driver = MT::Object->driver;
    #$driver->index_column('category_id');
    if (ref $driver eq 'MT::ObjectDriver::DBI::postgres') {
        # category
        $driver->sql('alter table mt_category drop constraint mt_category_category_blog_id_key');
        $driver->sql('create index mt_category_label on mt_category (category_label)');

        # author
        $driver->sql('alter table mt_author drop constraint mt_author_author_name_key');
        $driver->sql('create index mt_author_name on mt_author (author_name)');

        # permission
        $driver->sql('alter table mt_permission drop constraint mt_permission_permission_blog_id_key');
        $driver->sql('create index mt_permission_blog_id on mt_permission (permission_blog_id)');

        # template
        $driver->sql('alter table mt_template drop constraint mt_template_template_blog_id_key');
        $driver->sql('create index mt_template_blog_id on mt_template (template_blog_id)');
    } elsif (ref $driver eq 'MT::ObjectDriver::DBI::mysql') {
        # category
        $driver->sql('alter table mt_category drop index category_blog_id');
        $driver->sql('create index category_blog_id on mt_category (category_blog_id)');
        $driver->sql('create index category_label on mt_category (category_label)');

        # author
        $driver->sql('alter table mt_author drop index author_name');
        $driver->sql('create index author_name on mt_author (author_name)');

        # permission
        $driver->sql('alter table mt_permission drop index permission_blog_id');
        $driver->sql('create index permission_blog_id on mt_permission (permission_blog_id)');

        # template
        $driver->sql('alter table mt_template drop index template_blog_id');
        $driver->sql('create index template_blog_id on mt_template (template_blog_id)');
    }
    1;
}

sub core_create_config_table {
    my $self = shift;

    require MT::Config;
    my $config = MT::Config->load();
    if (!$config) {
        #$self->progress($self->translate("Creating configuration record."));
        $config = MT::Config->new;
        $config->data('');
        $config->save or return $self->error($self->translate("Error saving record: [_1].", $config->errstr));
    }
    1;
}

sub core_set_enable_archive_paths {
    my $self = shift;
    my $config = MT::ConfigMgr->instance;
    $config->EnableArchivePaths(1, 1);
    1;
}

sub core_create_template_maps {
    my $self = shift;
    my (%param) = @_;
    
    my $offset = $param{offset};
    require MT::Template;
    require MT::TemplateMap;
    require MT::Blog;

    my $msg = $self->translate("Creating template maps...");
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
                    $self->progress($self->translate("Mapping template ID [_1] to [_2] ([_3]).", $tmpl->id, $at, $file_tmpl));
                    $map->file_template($file_tmpl);
                } else {
                    $self->progress($self->translate("Mapping template ID [_1] to [_2].", $tmpl->id, $at));
                }
                $map->archive_type($at);
                $map->is_preferred(1);
                $map->template_id($tmpl->id);
                $map->blog_id($tmpl->blog_id);
                $map->save or return $self->error($self->translate("Error saving record: [_1].", $map->errstr));
            }
        }
        $count++;
        $continue = 1, last if $count == $MAX_ROWS;
        $continue = 1, last if time > $start + $MAX_TIME;
    }
    if ($continue) {
        while ($iter->()) {}
        return $offset;
    } else {
        $self->progress("$msg (100%)", 1);
    }
    1;
}

sub core_update_records {
    my $self = shift;
    my (%param) = @_;

    my $class = $param{class};
    return $self->error($self->translate("Error loading class: [_1].", $class))
        unless eval 'require '.$class;

    my $msg = $self->translate($param{message} || "Updating [_1] records...", $class);
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
    my $driver = MT::Object->driver;

    if ($sql && $DryRun && $driver->{dbh}) {
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
                or return $self->error($self->translate("Error saving record: [_1].", $obj->errstr));
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
to install a weblog and initial author.

=item * App

A package name or app object that can service the following methods:

=over 4

=item * progress($package, $message)

Called during the upgrade operation to provide feedback with respect to
the operations the upgrade process is running.

=item * error($package, $message)

Called during the upgrade operation to communicate an error that has
occurred.

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

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
