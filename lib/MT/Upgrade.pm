# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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

use vars
    qw(%classes %functions %LegacyPerms $App $DryRun $Installing $SuperUser
    $CLI $MAX_TIME $MAX_ROWS @steps);

sub app {
    return $App;
}

sub superuser {
    return $SuperUser;
}

sub max_rows {
    return $MAX_ROWS;
}

sub max_time {
    return $MAX_TIME;
}

sub BEGIN {
    $MAX_TIME = 5;
    $MAX_ROWS = 100;

    %functions = (

        # standard routines
        'core_upgrade_begin' => {
            code     => \&core_upgrade_begin,
            priority => 1,
        },
        'core_fix_type' => {
            code     => \&core_fix_type,
            priority => 2,
        },
        'core_add_column' => {
            code     => sub { shift->core_column_action( 'add', @_ ) },
            priority => 3,
        },
        'core_drop_column' => {
            code     => sub { shift->core_column_action( 'drop', @_ ) },
            priority => 3,
        },
        'core_alter_column' => {
            code     => sub { shift->core_column_action( 'alter', @_ ) },
            priority => 3,
        },
        'core_index_column' => {
            code     => sub { shift->core_column_action( 'index', @_ ) },
            priority => 3.5,
        },
        'core_seed_database' => {
            code     => \&seed_database,
            priority => 4,
        },
        'core_upgrade_end' => {
            code     => \&core_upgrade_end,
            priority => 9,
        },
        'core_finish' => {
            code     => \&core_finish,
            priority => 10,
        },
    );

    %LegacyPerms = (

        # System-wide permissions
        #[ 2**0, 'administer', 'System Administrator', 2, 'system' ],
        #[ 2**1, 'create_blog', 'Create Blogs', 2, 'system' ],
        #[ 2**2, 'view_log', 'View System Activity Log', 2, 'system' ],
        #[ 2**3, 'manage_plugins', 'Manage Plugins', 'system' ],

        # Blog-specific permissions:
        # The order here is the same order they are presented on the
        # role definition screen.
        2**0  => 'comment',             # 'Add Comments', 1, 'blog'],
        2**12 => 'administer_blog',     # 'Blog Administrator', 1, 'blog'],
        2**6  => 'edit_config',         # 'Configure Blog', 1, 'blog'],
        2**3  => 'edit_all_posts',      # 'Edit All Entries', 1, 'blog'],
        2**4  => 'edit_templates',      # 'Manage Templates', 1, 'blog'],
        2**2  => 'upload',              # 'Upload File', 1, 'blog'],
        2**1  => 'post',                # 'Create Entry', 1, 'blog'],
        2**16 => 'edit_assets',         # 'Manage Assets', 1, 'blog'],
        2**15 => 'save_image_defaults', # 'Save Image Defaults', 1, 'blog'],
        2**9  => 'edit_categories',     # 'Add/Manage Categories', 1, 'blog'],
        2**14 => 'edit_tags',           # 'Manage Tags', 1, 'blog'],
        2**10 =>
            'edit_notifications',    # 'Manage Notification List', 1, 'blog'],
        2**8  => 'send_notifications',    # 'Send Notifications', 1, 'blog'],
        2**13 => 'view_blog_log',         # 'View Activity Log', 1, 'blog'],
            #[ 2**17, 'publish_post', 'Publish Post', 1, 'blog'],
            #[ 2**18, 'manage_feedback', 'Manage Feedback', 1, 'blog'],
            #[ 2**19, 'set_publish_paths', 'Set Publishing Paths', 1, 'blog'],
            #[ 2**20, 'manage_pages', 'Manage Pages', 1, 'blog'],
            # 2**5 == 32 is deprecated; reserved for future use
        2**7 => 'rebuild',    # 'Rebuild Files', 1, 'blog'],
            # Not a real permission but a denial thereeof; unlisted because it
            # has no label.
        2**11 => 'not_comment',    # '', 1, 'blog'],
    );
}

sub init {
    my $pkg = shift;
    unless (%classes) {
        my $types = MT->registry('object_types');
        foreach my $type ( keys %$types ) {
            $classes{$type} = $types->{$type};
        }
    }

    my $fns = MT::Component->registry('upgrade_functions') || [];
    foreach my $fn_set (@$fns) {
        %functions = ( %functions, %{$fn_set} );
    }

    # Load versioned MT::Upgrade functions, ie MT::Upgrade::v3
    # Only load the ones that will be required for upgrading
    # from the source SchemaVersion
    my $from = int( MT->config->SchemaVersion || 0 );
    $from = 1 if $from < 1;
    my $to = int( MT->version_number );
    for ( my $i = $from; $i <= $to; $i++ ) {
        my $vpkg = "${pkg}::v$i";
        eval "# line " . __LINE__ . " " . __FILE__ . "\nrequire $vpkg; 1;"
            or die;
        next if $@;
        my $fn_set = $vpkg->upgrade_functions();
        %functions = ( %functions, %$fn_set )
            if $fn_set && ( ref($fn_set) eq 'HASH' );
    }

    # Clear RAM cache
    require MT::ObjectDriver::Driver::Cache::RAM;
    MT::ObjectDriver::Driver::Cache::RAM->clear_cache;
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
    my ( $name, %param ) = @$step;

    if ( my $fn = $functions{$name} ) {
        local $MT::CallbacksEnabled = 0;
        if ( my $cond = $fn->{condition} ) {
            $cond = MT->handler_to_coderef($cond);
            next unless $cond->( $self, %param );
        }
        my %update_params;
        if ( $fn->{updater} ) {
            %update_params = %{ $fn->{updater} };
            $fn->{code} ||= \&core_update_records;
        }
        my $code = $fn->{code} || $fn->{handler};
        $code = MT->handler_to_coderef($code);
        my $result = $code->( $self, %param, %update_params, step => $name );
        if ( ref $result eq 'HASH' ) {
            $param{$_} = $result->{$_} for keys %$result;
            $result = 1;
            $self->add_step( $name, %param );
        }
        elsif ( ( defined $result ) && ( $result > 1 ) ) {
            $param{offset} = $result;
            $result = 1;
            $self->add_step( $name, %param );
        }
        return $result;
    }
    else {
        return $self->error(
            $self->translate_escape(
                "Invalid upgrade function: [_1].", $name
            )
        );
    }
    0;
}

sub run_callbacks {
    my $self = shift;
    my ( $cb, @param ) = @_;
    local $MT::CallbacksEnabled = 1;
    MT->run_callbacks( 'MT::Upgrade::' . $cb, $self, @param )
        or return $self->error( MT->callback_errstr );
    1;
}

# Main "do" interface for controlling apparatus

sub do_upgrade {
    my $self = shift;
    my (%opt) = @_;

    $self->init;

    my $harnessed
        = ref $opt{App} && ( UNIVERSAL::can( $opt{App}, 'add_step' ) );

    local $App       = $opt{App};
    local $DryRun    = $opt{DryRun};
    local $SuperUser = $opt{SuperUser} || '';
    local $CLI       = $opt{CLI} || '';

    @steps = ();
    if ( $opt{Install} ) {
        my %init_params = ( %{ $opt{User} || {} }, %{ $opt{Website} || {} } );
        $self->install_database( \%init_params );
    }
    else {
        $self->upgrade_database();
    }

    # no app is running the show, so we must!
    if ( !$harnessed ) {

        # set these limits very high since we're running unharnessed
        $MAX_TIME = 10000000;
        $MAX_ROWS = 300;
        my $fn          = \%MT::Upgrade::functions;
        my @these_steps = @steps;

        while (@these_steps) {
            my $step = shift @these_steps;
            @steps = ();
            $self->run_step($step);
            if (@steps) {
                push @these_steps, @steps;
                @these_steps = sort {
                    ( $fn->{ $a->[0] }->{priority} || 0 )
                        <=> ( $fn->{ $b->[0] }->{priority} || 0 )
                } @these_steps;
            }

            # Reset the request to eliminate any caching that may be
            # happening there (objects tend to cache into the request
            # with the 'cache_property' method)
            MT->request->reset;
        }
        return 1;
    }
    else {
        return \@steps;
    }
}

sub upgrade_database {
    my $self = shift;

    my $config_schema_ver;
    my $schema_ver;
    if ( $config_schema_ver = MT->instance->config('SchemaVersion') ) {
        my $needs_upgrade;
        $needs_upgrade = 1 if $config_schema_ver < MT->schema_version;
        if ( !$needs_upgrade ) {
            foreach (@MT::Components) {
                $needs_upgrade = 1 if $_->needs_upgrade;
            }
        }
        return 1 unless $needs_upgrade;
        $schema_ver = $config_schema_ver;
    }
    else {
        $schema_ver = $self->detect_schema_version;
    }

    # this will add steps to upgrade all tables that need it...
    $self->add_step( "core_upgrade_begin", from => $schema_ver );
    $self->check_schema;
    $self->add_step( 'core_upgrade_end', from => $schema_ver );
    $self->add_step('core_finish');
    1;
}

sub install_database {
    my $self = shift;
    my ($user) = @_;

    $self->add_step("core_upgrade_begin");

    # this will add steps to install all tables...
    $self->check_schema;

    # this will populate them...
    $self->add_step( 'core_seed_database', %$user );
    $self->add_step('core_upgrade_end');
    $self->add_step('core_finish');
    1;
}

sub check_schema {
    my $self = shift;
    my $class;
    foreach my $type ( keys %classes ) {
        $class = MT->model($type)
            or return $self->error(
            $self->translate_escape( "Error loading class [_1].", $type ) );
        $self->check_type($type);
    }
    1;
}

sub check_type {
    my $self = shift;
    my ($type) = @_;

    my $class = MT->model($type);

    # handle schema updates for meta tables
    for my $which (qw( meta summary )) {
        if ( $class->meta_pkg($which) ) {
            $self->check_type( $type . ":$which" );
        }
    }

    # handle schema updates for revision table
    if ( $class->isa('MT::Revisable') ) {
        $self->check_type( $type . ':revision' );
    }

    if ( my $result = $self->type_diff($type) ) {
        if ( $result->{fix} ) {
            $self->add_step( 'core_fix_type', type => $type );
        }
        else {
            $self->add_step( 'core_add_column', type => $type )
                if $result->{add};
            $self->add_step( 'core_alter_column', type => $type )
                if $result->{alter};
            $self->add_step( 'core_drop_column', type => $type )
                if $result->{drop};
            $self->add_step( 'core_index_column', type => $type )
                if $result->{index};
        }
    }

    1;
}

sub type_diff {
    my $self = shift;
    my ($type) = @_;

    my $class = MT->model($type) or return;

    my $table = $class->datasource;
    my $defs  = $class->column_defs;

    my $ddl     = $class->driver->dbd->ddl_class;
    my $db_defs = $ddl->column_defs($class);

    my $class_idx_defs = $class->index_defs;
    my $db_idx_defs    = $ddl->index_defs($class);

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
    my ( @cols_to_add, @cols_to_alter, @cols_to_drop, @cols_to_index );

    if ( !$fix_class ) {
        my @def_cols = keys %$defs;

        foreach my $col (@def_cols) {
            my $col_def = $defs->{$col};
            next if !defined $col_def;

            $col_def->{name} = $col;

            my $db_def = $db_defs->{$col};

            if ( !$db_def ) {

                # column is missing altogether; we're going to have to add it
                push @cols_to_add, $col;
            }
            else {
                if (   ( $col_def->{type} eq 'string' )
                    && ( $db_def->{type} eq 'string' )
                    && ( $col_def->{size} != $db_def->{size} ) )
                {
                    push @cols_to_alter, $col;
                }
                elsif ( $ddl->type2db($col_def) ne $ddl->type2db($db_def) ) {
                    push @cols_to_alter, $col;
                }
                elsif ( ( $col_def->{not_null} || 0 )
                    != ( $db_def->{not_null} || 0 ) )
                {
                    push @cols_to_alter, $col;
                }
            }
        }

        foreach my $key ( keys %$class_idx_defs ) {
            my $db_idx_def = $db_idx_defs->{$key};
            if ( !$db_idx_def ) {
                push @cols_to_index, $key;
                next;
            }

            # if there is a mismatch in definition, add it to index
            my $class_idx_def = $class_idx_defs->{$key};
            if ( ref($class_idx_def) ) {
                if ( !ref $db_idx_def ) {
                    push @cols_to_index, $key;
                }
                else {
                    my $db_cols;
                    if ( exists $db_idx_def->{columns} ) {
                        $db_cols = join ',', @{ $db_idx_def->{columns} };
                    }
                    else {
                        $db_cols = $key;
                    }
                    my $class_cols;
                    if ( exists $class_idx_def->{columns} ) {
                        $class_cols = join ',',
                            @{ $class_idx_def->{columns} };
                    }
                    else {
                        $class_cols = $key;
                    }
                    if ( $db_cols ne $class_cols ) {
                        push @cols_to_index, $key;
                    }
                    else {
                        if ( ( $db_idx_def->{unique} || 0 )
                            != ( $class_idx_def->{unique} || 0 ) )
                        {
                            push @cols_to_index, $key;
                        }
                    }
                }
            }
            else {
                if ( ref $db_idx_def ) {
                    push @cols_to_index, $key;
                }
            }
        }
    }

    if (   $fix_class
        || @cols_to_add
        || @cols_to_alter
        || @cols_to_drop
        || @cols_to_index )
    {
        my %param;
        $param{drop}  = \@cols_to_drop  if @cols_to_drop;
        $param{add}   = \@cols_to_add   if @cols_to_add;
        $param{alter} = \@cols_to_alter if @cols_to_alter;
        $param{fix}   = $fix_class;
        $param{index} = \@cols_to_index if @cols_to_index;
        if (   ( @cols_to_add && !$ddl->can_add_column )
            || ( @cols_to_alter && !$ddl->can_alter_column )
            || ( @cols_to_drop  && !$ddl->can_drop_column ) )
        {
            $param{fix} = 1;
        }
        return \%param;
    }
    undef;
}

sub seed_database {
    my $self = shift;
    my (%param) = @_;
    $self->run_callbacks( 'seed_database', %param );
    return 1;
}

###  Upgrade triggers

# we don't need these yet, but it makes me feel good to have them around

# 'pre' triggers should execute quickly. 'post' triggers can add steps
# if they require processing that will take time to complete.

sub pre_upgrade_class {
    return 1;
}

sub post_upgrade_class {
    my $self = shift;
    my ($class) = @_;

    # Special case for handling upgrade process for old "meta" column
    # storage to new narrow tables; some database drivers cannot
    # add new columns without recreating the table, so it's necessary
    # to prioritize migration of meta column data before the schema
    # for that class is updated and the meta column winds up getting
    # dropped as a result.
    return unless MT->config->SchemaVersion;
    if ( MT->config->SchemaVersion < 4.0057 ) {
        return 1 unless $class =~ m/::Meta$/;

        my $pc = $class;
        $pc =~ s/::Meta$//;

        my $type = $pc->datasource;

        # 'page' instead of 'entry', for instance
        $type = $pc->class_type || $type if $pc->can('class_type');

        # do nothing for website/blog at this point.
        # this step will do later.
        return 1 if $type eq 'website' || $type eq 'blog';

        my %step_param = ( type => $type );
        $step_param{plugindata} = 1 if $type eq 'category';
        $step_param{meta_column} = $pc->properties->{meta_column}
            if $pc->properties->{meta_column};
        $self->add_step( 'core_upgrade_meta_for_table', %step_param );
    }

    return 1;
}

sub pre_alter_column   {1}
sub post_alter_column  {1}
sub pre_drop_column    {1}
sub post_drop_column   {1}
sub pre_add_column     {1}
sub pre_index_column   {1}
sub post_index_column  {1}
sub pre_schema_upgrade {1}

# issued last, after all table creation...

sub post_schema_upgrade {
    my $self = shift;
    my ($from) = @_;

    my $plugin_ver = MT->config('PluginSchemaVersion') || {};
    $plugin_ver->{'core'} = $from;

    # run any functions that define a version_limit and where the schema we're
    # upgrading from is below that limit.
    foreach my $fn ( keys %functions ) {
        my $save_from = $from;
        {
            my $func = $functions{$fn};

            if ( $func->{plugin}
                && ( UNIVERSAL::isa( $func->{plugin}, 'MT::Component' ) ) )
            {
                my $id = $func->{plugin}->id;
                $from = $plugin_ver->{$id};
            }
            if (   $func->{version_limit}
                && ( defined $from )
                && ( $from < $func->{version_limit} ) )
            {
                $self->add_step( $fn, from => $from );
            }
            elsif ($func
                && !exists( $func->{version_limit} )
                && !defined($from) )
            {
                $self->add_step($fn);
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

    if ( !$Installing ) {
        foreach ( keys %functions ) {
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
    my ( $class, $col_defs ) = @_;

    if ( !$Installing ) {
        my %cols = map { $_ => 1 } @$col_defs;
        foreach ( keys %functions ) {
            my $func = $functions{$_};
            next unless $func->{on_field};
            if ( $func->{on_field} =~ m/^\Q$class\E->(.*)/ ) {
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
    my $self  = shift;
    my $trans = MT->translate(@_);
    return $trans if $CLI;
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
    if ( $App && ( ref $App ) ) {
        $App->add_step(@_);
    }
    else {
        push @steps, [@_];
    }
}

# Misc utilities.

sub detect_schema_version {
    my $self = shift;

    require MT::Object;
    my $driver = MT::Object->driver;

    require MT::Config;
    if ( $driver->table_exists('MT::Config') ) {
        return 3.2;
    }

    require MT::Template;
    my $dyn_error_template
        = MT::Template->exist( { type => 'dynamic_error' } );
    if ($dyn_error_template) {
        return 3.1;
    }

    my $comment_pending_template
        = MT::Template->exist( { type => 'comment_pending' } );
    if ($comment_pending_template) {
        return 3.0;
    }

    require MT::TemplateMap;
    if ( $driver->table_exists('MT::TemplateMap') ) {
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

    my $type  = $param{type};
    my $class = MT->model($type);

    my $result = $self->type_diff($type);
    return 1 unless $result;
    return 1 unless $result->{fix};

    my $alter = $result->{alter};
    my $add   = $result->{add};
    my $drop  = $result->{drop};
    my $index = $result->{index};

    my $driver = $class->driver;
    my $ddl    = $driver->dbd->ddl_class;
    my @stmts;
    push @stmts, sub { $self->pre_upgrade_class($class) };
    push @stmts, $ddl->upgrade_begin($class);
    push @stmts, sub { $self->pre_create_table($class) };
    push @stmts, sub { $self->pre_add_column( $class, $add ) }
        if $add;
    push @stmts, sub { $self->pre_alter_column( $class, $alter ) }

        if $alter;
    push @stmts, sub { $self->pre_drop_column( $class, $drop ) }
        if $drop;
    push @stmts, sub { $self->pre_index_column( $class, $index ) }
        if $index;
    push @stmts, $ddl->fix_class($class);
    push @stmts, sub { $self->post_create_table($class) };
    push @stmts, sub { $self->post_add_column( $class, $add ) }
        if $add;
    push @stmts, sub { $self->post_alter_column( $class, $alter ) }

        if $alter;
    push @stmts, sub { $self->post_drop_column( $class, $drop ) }
        if $drop;
    push @stmts, sub { $self->post_index_column( $class, $index ) }
        if $index;
    push @stmts, $ddl->upgrade_end($class);
    push @stmts, sub { $self->post_upgrade_class($class) };
    $self->run_statements( $class, @stmts );
}

sub core_column_action {
    my $self = shift;
    my ( $action, %param ) = @_;

    my $type  = $param{type};
    my $class = MT->model($type);
    my $defs  = $class->column_defs;

    my $result = $self->type_diff($type);
    return 1 unless $result;
    my $columns = $result->{$action};
    return 1 unless $columns;

    my $pre_method  = "pre_${action}_column";
    my $post_method = "post_${action}_column";
    my $method      = "${action}_column";

    my $driver = $class->driver;
    my $ddl    = $driver->dbd->ddl_class;
    my @stmts;
    push @stmts, sub { $self->pre_upgrade_class($class) };
    push @stmts, $ddl->upgrade_begin($class);
    push @stmts, sub { $self->$pre_method( $class, $columns ) };
    push @stmts, $ddl->$method( $class, $_ ) foreach @$columns;
    push @stmts, sub { $self->$post_method( $class, $columns ) };
    push @stmts, $ddl->upgrade_end($class);
    push @stmts, sub { $self->post_upgrade_class($class) };
    $self->run_statements( $class, @stmts );
}

sub run_statements {
    my $self = shift;
    my ( $class, @stmts ) = @_;

    my $driver = $class->driver;
    my $defs   = $class->column_defs;
    my $dbh    = $driver->rw_handle;
    my $mt     = MT->instance;

    my $updated = 0;
    if (@stmts) {
        $self->progress(
            $self->translate_escape(
                "Upgrading table for [_1] records...",
                $class->can('class_label') ? $class->class_label : $class
            )
        );
        eval {
            foreach my $stmt (@stmts)
            {
                if ( ref $stmt eq 'CODE' ) {
                    $stmt->() if !$DryRun;
                }
                else {
                    if ( $dbh && !$DryRun && $stmt ) {
                        my $err;
                        $dbh->do($stmt) or $err = $dbh->errstr;
                        if ($err) {

                           # ignore drop errors; the table/sequence/constraint
                           # didn't exist
                            if (   ( $stmt !~ m/^drop /i )
                                && ( $stmt !~ m/DROP CONSTRAINT /i ) )
                            {
                                die "failed to execute statement $stmt: $err";
                            }
                        }
                    }
                    elsif ( $dbh && $DryRun ) {
                        $self->run_callbacks( 'SQL', $stmt );
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
    my $self        = shift;
    my (%param)     = @_;
    my $from_schema = $param{from};
    if ($from_schema) {
        my $cur_schema = MT->schema_version;
        $self->progress(
            $self->translate_escape(
                "Upgrading database from version [_1].", $from_schema
            )
        ) if $from_schema < $cur_schema;
        $self->pre_schema_upgrade($from_schema);
    }
    $self->run_callbacks( 'upgrade_begin', %param );
    return 1;
}

sub core_upgrade_end {
    my $self = shift;
    my (%param) = @_;

    my $from_schema = $param{from};
    if ($from_schema) {
        $self->post_schema_upgrade($from_schema);
    }
    $self->run_callbacks( 'upgrade_end', %param );
    return 1;
}

sub core_finish {
    my $self = shift;

    my $user;
    if ( ( ref $App ) && ( $App->{author} ) ) {
        $user = $App->{author};
    }

    my $cfg        = MT->config;
    my $cur_schema = MT->instance->schema_version;
    my $old_schema = $cfg->SchemaVersion || 0;
    if ( $cur_schema > $old_schema ) {
        $self->progress(
            $self->translate_escape(
                "Database has been upgraded to version [_1].", $cur_schema
            )
        );
        if ( $user && !$DryRun ) {
            MT->log(
                {   message => MT->translate(
                        "User '[_1]' upgraded database to version [_2]",
                        $user->name, $cur_schema
                    ),
                    category => 'upgrade',
                }
            );
        }
        $cfg->SchemaVersion( $cur_schema, 1 );
    }

    my $plugin_schema = $cfg->PluginSchemaVersion || {};
    foreach my $plugin (@MT::Components) {
        my $ver = $plugin->schema_version;
        next unless $ver;
        next if $plugin->id eq 'core';
        my $old_plugin_schema = $plugin_schema->{ $plugin->id } || 0;
        if ( $old_plugin_schema && ( $ver > $old_plugin_schema ) ) {
            $self->progress(
                $self->translate_escape(
                    "Plugin '[_1]' upgraded successfully to version [_2] (schema version [_3]).",
                    $plugin->label,
                    $plugin->version || '-',
                    $ver
                )
            );
            if ( $user && !$DryRun ) {
                MT->log(
                    {   message => MT->translate(
                            "User '[_1]' upgraded plugin '[_2]' to version [_3] (schema version [_4]).",
                            $user->name,
                            $plugin->label,
                            $plugin->version || '-',
                            $ver
                        ),
                        category => 'upgrade',
                        class    => 'plugin',
                    }
                );
            }
        }
        elsif ( $ver && !$old_plugin_schema ) {
            $self->progress(
                $self->translate_escape(
                    "Plugin '[_1]' installed successfully.",
                    $plugin->label
                )
            );
            if ( $user && !$DryRun ) {
                MT->log(
                    {   message => MT->translate(
                            "User '[_1]' installed plugin '[_2]', version [_3] (schema version [_4]).",
                            $user->name,
                            $plugin->label,
                            $plugin->version || '-',
                            $ver
                        ),
                        category => 'install',
                        class    => 'plugin',
                    }
                );
            }
        }
        $plugin_schema->{ $plugin->id } = $ver;
    }
    if ( keys %$plugin_schema ) {
        $cfg->PluginSchemaVersion( $plugin_schema, 1 );
    }

    my $cur_version = MT->version_number;
    if ( !defined( $cfg->MTVersion ) || ( $cur_version > $cfg->MTVersion ) ) {
        $cfg->MTVersion( $cur_version, 1 );
    }
    my $cur_rel = MT->release_number;
    if ( !defined( $cfg->MTReleaseNumber )
        || ( $cur_rel > $cfg->MTReleaseNumber ) )
    {
        $cfg->MTReleaseNumber( $cur_rel, 1 );
    }
    $cfg->save_config unless $DryRun;

    # do one last thing....
    if ( ( ref $App ) && ( $App->can('finish') ) ) {
        $App->finish();
    }

    1;
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
        { offset => $offset, limit => $MAX_ROWS + 1 } );
    my $start = time;
    my ( %touched, %c, %tb );
    my $rows = 0;
    while ( my $e = $iter->() ) {
        $rows++;
        $c{ $e->id } = $e;
        if ( my $tb = $e->trackback ) {
            $tb{ $tb->id } = $e;
        }
        $continue = 1, last if scalar $rows == $MAX_ROWS;
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

sub core_update_records {
    my $self = shift;
    my (%param) = @_;

    my $class = MT->model( $param{type} );
    return $self->error(
        $self->translate_escape( "Error loading class: [_1].", $param{type} )
    ) unless $class;

    my $msg;
    my $class_label
        = ( $class->can('class_label') ? $class->class_label : $class );
    if ( $param{label} ) {
        $msg = $param{label};
        if ( ref $msg eq 'CODE' ) {
            $msg = $msg->($class_label);
        }
        $msg = $self->translate_escape($msg);
    }
    else {
        $msg = $self->translate_escape( $param{message}
                || "Updating [_1] records...", $class_label );
    }
    my $offset = $param{offset};
    my $count  = $param{count};
    if ( !$count ) {
        $count = $class->count( $param{terms} || undef );
    }
    return unless $count;
    if ($offset) {
        $self->progress( sprintf( "$msg (%d%%)", ( $offset / $count * 100 ) ),
            $param{step} );
    }
    else {
        $self->progress( $msg, $param{step} );
    }

    my $cond = MT->handler_to_coderef( $param{condition} );
    my $code = MT->handler_to_coderef( $param{code} );
    my $sql  = $param{sql};

    my $continue = 0;
    my $driver   = $class->driver;

    if ( $sql && $DryRun ) {
        $self->run_callbacks( 'SQL', $sql );
    }
    return 1 if $DryRun;

    if ( !$sql || !$driver->sql($sql) ) {
        my $iter = $class->load_iter( $param{terms} || undef,
            { offset => $offset, limit => $MAX_ROWS + 1 } );
        my $start = time;
        my @list;
        while ( my $obj = $iter->() ) {
            push @list, $obj;
            $continue = 1, last if scalar @list == $MAX_ROWS;
        }
        $iter->end if $continue;
        for my $obj (@list) {
            $offset++;
            if ($cond) {
                next unless $cond->( $obj, %param );
            }
            $code->($obj);
            $obj->save()
                or return $self->error(
                $self->translate_escape(
                    "Error saving [_1] record # [_3]: [_2]...",
                    $class_label, $obj->errstr, $obj->id
                )
                );
            $continue = 1, last if time > $start + $MAX_TIME;
        }
    }
    if ($continue) {
        return { offset => $offset, count => $count };
    }
    else {
        $self->progress( "$msg (100%)", $param{step} );
    }
    1;
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

=head2 MT::Upgrade->add_step( $function[, %params ] )

Adds an additional upgrade function to the upgrade pipeline. The
parameters given will be given to the upgrade function when invoked.
Note that all values in the C<%params> hash should be simple scalar
values, as they have to be represented in JSON notation.

=head2 MT::Upgrade->check_schema()

Run during the upgrade process to verify all object types are
up-to-date. Calls the L<check_type> method which does the work
for an individual object type. Returns '1' for success, or
undef for failure.

=head2 MT::Upgrade->check_type($type)

Issues schema checks for the specified C<$type>. If schema differences
exist, upgrade steps are added to bring the object type up to date.

=head2 MT::Upgrade->core_column_action($action, %params)

Upgrade function to process an object type in a specific
way. C<$action> may be one of C<add>, C<drop>, C<alter>, C<index>.
C<%params> should contain a C<type> parameter identifying the object
type to process.

=head2 MT::Upgrade->core_create_config_table

Upgrade function to handle the creation of the initial
L<MT::Config> object.

=head2 MT::Upgrade->core_create_template_maps

Upgrade function to handle the creation of L<MT::TemplateMap> records
for upgrading pre-2.0 MT schemas.

=head2 MT::Upgrade->core_drop_meta_for_table

Upgrade function to handle the removal of "meta" blob columns for
pre-MT 4.2 schemas.

=head2 MT::Upgrade->core_finish

Upgrade function that finalizes an upgrade operation. This routine
is always run at the end of the upgrade process.

=head2 MT::Upgrade->core_fix_type

Upgrade function that handles a table "overhaul", where it is necessary
to create a new temporary table, drop the existing one, then rebuild it
from scratch. This is necessary when an object driver (SQLite, for instance)
does not support a kind of table manipulation that is required to upgrade
it.

=head2 MT::Upgrade->core_populate_author_auth_type

Upgrade function to handle the assignment of the authentication type
(specifically, the 'auth_type' column) for upgraded L<MT::Author> records.

=head2 MT::Upgrade->core_remove_unique_constraints

Upgrade function that removes some old table constraints for pre-3.2
MT schemas.

=head2 MT::Upgrade->core_set_enable_archive_paths

Upgrade function that enables the C<EnableArchivePaths> configuration
setting, if the existing schema version is 3.2 or earlier (preserves
'archive path', 'archive url' blog settings fields).

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
