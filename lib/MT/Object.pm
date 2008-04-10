# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Object;

use strict;
use base qw( Data::ObjectDriver::BaseObject MT::ErrorHandler );

use MT;
use MT::Util qw(offset_time_list);

my (@PRE_INIT_PROPS, @PRE_INIT_META);

sub install_pre_init_properties {
    # Just in case; to prevent any weird recursion
    local $MT::plugins_installed = 1;

    foreach my $def (@PRE_INIT_PROPS) {
        my ($class, $props) = @$def;
        $class->install_properties($props);
    }
    @PRE_INIT_PROPS = ();

    foreach my $def (@PRE_INIT_META) {
        my ($class, $meta) = @$def;
        $class->install_meta($meta);
    }
    @PRE_INIT_META = ();
}

sub install_properties {
    my $class = shift;
    my ($props) = @_;

    if ( ( $class ne 'MT::Config') && ( !$MT::plugins_installed ) ) {
        # We're too early in the phase of MT's bootstrapping to
        # be installing properties; we can't query the registry yet
        # since plugins are not all accounted for. So save this
        # set of properties to install it later (odds are, the
        # package has been loaded to afford installing callbacks
        # or accessing constants and isn't being used to load
        # actual data.)
        #
        # The only exception to this rule is MT::Config; we must
        # have access to the MT configuration table in order to
        # bootstrap MT.

        push @PRE_INIT_PROPS, [$class, $props];
        return;
    }

    my $super_props = $class->SUPER::properties();
    if ($super_props) {
        # subclass; merge hash
        for (qw(primary_key meta_column class_column datasource driver audit meta)) {
            $props->{$_} = $super_props->{$_}
                if exists $super_props->{$_} && !(exists $props->{$_});
        }
        for my $p (qw(column_defs defaults indexes meta_columns)) {
            if (exists $super_props->{$p}) {
                foreach my $k (keys %{ $super_props->{$p} }) {
                    if (!exists $props->{$p}{$k}) {
                        $props->{$p}{$k} = $super_props->{$p}{$k};
                    }
                }
                if ($p eq 'column_defs') {
                    $class->__parse_defs($props->{column_defs});
                }
            }
        }
        if ($super_props->{class_type}) {
            # copy reference of class_to_type/type_to_class hashes
            $props->{__class_to_type} = $super_props->{__class_to_type};
            $props->{__type_to_class} = $super_props->{__type_to_class};
        }
    }

    # Legacy MT::Object types only define 'columns'; we still support that
    # but they aren't handled properly with the upgrade system as a result.
    if (exists $props->{column_defs}) {
        $props->{columns} = [ keys %{ $props->{column_defs} } ];
    } else {
        map { $props->{column_defs}{$_} = () } @{ $props->{columns} };
    }

    # Support audit flags
    if ($props->{audit}) {
        unless (exists $props->{column_defs}{created_on}) {
            $props->{column_defs}{created_on} = 'datetime';
            $props->{column_defs}{created_by} = 'integer';
            $props->{column_defs}{modified_on} = 'datetime';
            $props->{column_defs}{modified_by} = 'integer';
            push @{ $props->{columns} }, qw( created_on created_by modified_on modified_by );
        }
    }

    # Metadata column
    $props->{meta_column} ||= 'meta' if exists $props->{meta};
    if (my $col = $props->{meta_column}) {
        if (!$props->{column_defs}{$col}) {
            $props->{column_defs}{$col} = 'blob';
            push @{ $props->{columns} }, $col;
        }
        no strict 'refs'; ## no critic
        *{$class . '::' . $col} = \&__meta_column;
        $class->add_trigger( pre_save => \&pre_save_serialize_metadata );
    }

    # Classed object types
    $props->{class_column} ||= 'class' if exists $props->{class_type};
    if (my $col = $props->{class_column}) {
        if (!$props->{column_defs}{$col}) {
            $props->{column_defs}{$col} = 'string(255)';
            push @{$props->{columns}}, $col;
            $props->{indexes}{$col} = 1;
        }
        if (!$super_props || !$super_props->{class_column}) {
            $class->add_trigger( pre_search => \&pre_search_scope_terms_to_class );
            $class->add_trigger( post_load => \&post_load_rebless_object );
        }
        if (my $type = $props->{class_type}) {
            $props->{defaults}{$col} = $type;
            $props->{__class_to_type}{$class} = $type;
            $props->{__type_to_class}{$type} = $class;
        }
    }

    my $type_id;
    if ($type_id = $props->{class_type}) {
        if ($type_id ne $props->{datasource}) {
            $type_id = $props->{datasource} . '.' . $type_id;
        }
    } else {
        $type_id = $props->{datasource};
    }

    $class->SUPER::install_properties($props);

    # check for any supplemental columns from other components
    my $more_props = MT->registry('object_types', $type_id);
    if ($more_props && (ref($more_props) eq 'ARRAY')) {
        my $cols = {};
        for my $prop (@$more_props) {
            next if ref($prop) ne 'HASH';
            MT::__merge_hash($cols, $prop, 1);
        }
        my @classes = grep { !ref($_) } @$more_props;
        foreach my $isa_class (@classes) {
            next if UNIVERSAL::isa($class, $isa_class);
            eval "require $isa_class;" or die;
            no strict 'refs'; ## no critic
            push @{$class . '::ISA'}, $isa_class;
        }
        if (%$cols) {
            # special case for 'plugin' key...
            delete $cols->{plugin} if exists $cols->{plugin};
            for my $name (keys %$cols) {
                next if exists $props->{column_defs}{$name};
                $class->install_column($name, $cols->{$name});
                $props->{indexes}{$name} = 1
                    if $cols->{$name} =~ m/\bindexed\b/;
                if ($cols->{$name} =~ m/\bdefault (?:'([^']+?)'|(\d+))\b/) {
                    $props->{defaults}{$name} = defined $1 ? $1 : $2;
                }
            }
        }
    }

    my $pk = $props->{primary_key} || '';
    @{$props->{columns}} = sort { $a eq $pk ? -1 : $b eq $pk ? 1 : $a cmp $b }
        @{$props->{columns}};

    # Child classes are declared as an array;
    # convert them to a hashref for easier lookup.
    if ((ref $props->{child_classes}) eq 'ARRAY') {
        my $classes = $props->{child_classes};
        $props->{child_classes} = {};
        @{$props->{child_classes}}{@$classes} = ();
    }

    # We're declared as a child of some other class; associate ourselves
    # with that package (the invoking class should have already use'd it.)
    if (exists $props->{child_of}) {
        my $parent_classes = $props->{child_of};
        if (!ref $parent_classes) {
            $parent_classes = [ $parent_classes ];
        }
        foreach my $pc (@$parent_classes) {
            my $pp = $pc->properties;
            $pp->{child_classes} ||= {};
            $pp->{child_classes}{$class} = ();
        }
    }

    # Special handling for 'Taggable' objects; automatic saving
    # and removal of tags.
    my @isa;
    {
        no strict 'refs';
        @isa = @{ $class . '::ISA' };
    }
    foreach my $isa_pkg ( @isa ) {
        next unless $isa_pkg =~ /able$/;
        next if $isa_pkg eq $class;
        if ($isa_pkg->can('install_properties')) {
            $isa_pkg->install_properties($class);
        }
    }

    # install legacy date translation
    if (0 < scalar @{ $class->columns_of_type('datetime', 'timestamp') }) {
        if ($props->{audit}) {
            $class->add_trigger( pre_save  => \&assign_audited_fields);
            $class->add_trigger( post_save => \&translate_audited_fields );
        }

        $class->add_trigger( pre_save  => get_date_translator(\&ts2db, 1) );
        $class->add_trigger( post_load => get_date_translator(\&db2ts, 0) );
    }

    if ( exists($props->{cacheable}) && !$props->{cacheable} ) {
        no warnings 'redefine';
        no strict 'refs'; ## no critic
        *{$class . '::driver'} = sub { $_[0]->dbi_driver(@_) };
    }

    return $props;
}

# A post-load trigger for classed objects
sub post_load_rebless_object {
    my $obj = shift;
    my $props = $obj->properties;
    if (my $col = $props->{class_column}) {
        my $type = $obj->column($col);
        my $pkg = ref($obj);
        if ($pkg->class_type ne $type) {
            if (my $class = $props->{__type_to_class}{$type}) {
                bless $obj, $class;
            } else {
                my %models = map { $_ => 1 } MT->models($props->{datasource});
                if (exists $models{ $props->{datasource} . '.' . $type}) {
                    $class = MT->model($props->{datasource} . '.' . $type);
                } elsif (exists $models{$type}) {
                    $class = MT->model($type);
                }
                bless $obj, $class if $class;
            }
        }
    }
}

# A pre-search trigger for classed objects
sub pre_search_scope_terms_to_class {
    my ($class, $terms, $args) = @_;
    # scope search terms to class

    $terms ||= {};
    return if (ref $terms eq 'HASH') && exists($terms->{id});

    my $props = $class->properties;
    my $col = $props->{class_column}
        or return;
    if (ref $terms eq 'HASH') {
        if (exists $terms->{$col}) {
            if ($terms->{$col} eq '*') {
                # class term is '*', which signifies filtering for all classes.
                # simply delete the term in this case.
                delete $terms->{$col} ;
            } elsif ($terms->{$col} =~ m/^(\w+:)\*$/) {
                # class term is in form "foo:*"; translate to a sql-compatible
                # syntax of "like 'foo:%'"
                $terms->{$col} = \"like '$1%'";
            }
            # term has been explicitly given or explictly removed. make
            # no further changes.
            return;
        }
        $terms->{$col} = $props->{class_type};
    }
    elsif (ref $terms eq 'ARRAY') {
        if (my @class_terms = grep { ref $_ eq 'HASH' && 1 == scalar keys %$_ && $_->{$col} } @$terms) {
            # Filter out any unlimiting class terms (class = *).
            @$terms = grep { ref $_ ne 'HASH' || 1 != scalar keys %$_ || !$_->{$col} || $_->{$col} ne '*' } @$terms;

            # The class column has been explicitly given or removed, so don't
            # add one.
            return;
        }
        @$terms = ( { $col => $props->{class_type} } => 'AND' => [ @$terms ] );
    }
}

sub class_label {
    my $pkg = shift;
    return MT->translate($pkg->datasource);
}

sub class_label_plural {
    my $pkg = shift;
    my $label = $pkg->datasource;
    $label =~ s/y$/ie/;
    $label .= 's';
    return MT->translate($label);
}

sub class_labels {
    my $pkg = shift;
    my @all_types = MT->models($pkg->properties->{datasource});
    my %names;
    foreach my $type (@all_types) {
        my $class = $pkg->class_handler($type);
        $names{$type} = $class->class_label;
    }
    return \%names;
}

# Returns a hashref of asset identifiers mapped to the localized string
# used to name them. (Ie, image => 'Image').
sub class_type {
    my $pkg = shift;
    if (ref $pkg) {
        return $pkg->column($pkg->properties->{class_column});
    } else {
        return $pkg->properties->{class_type};
    }
}

sub class_handler {
    my $pkg = shift;
    my $props = $pkg->properties;
    my ($type) = @_;
    my $package = $props->{__type_to_class}{$type};
    unless ($package) {
        my $ds = $props->{datasource};
        if (($type eq $ds) || ($type =~ m/\./)) {
            $package = MT->model($type);
        } else {
            $package = MT->model($ds . '.' . $type);
        }
    }
    if ($package) {
        if (defined *{$package.'::new'}) {
            return $package;
        } else {
            eval "use $package;";
            return $package unless $@;
            eval "use $pkg; $package->new;";
            return $package unless $@;
        }
    }
    return $pkg;
}

sub add_class {
    my $pkg = shift;
    my ($type, $class) = @_;
    my $props = $pkg->properties;
    if ($type =~ m/::/) {
        ($type, $class) = ($class, $type);
    }

    if (my $old_class = $props->{__type_to_class}{$type}) {
        delete $props->{__class_to_type}{$old_class};
    }
    $props->{__type_to_class}{$type} = $class;
    $props->{__class_to_type}{$class} = $type;
}

# 'meta' metadata column support

sub install_meta {
    my $class = shift;
    my ($props) = @_;
    if ( ( $class ne 'MT::Config' ) && (!$MT::plugins_installed) ) {
        push @PRE_INIT_META, [$class, $props];
        return;
    }
    my $cprops = $class->properties;
    my $fields = $cprops->{meta_columns} ||= {};
    my $meta_col = $cprops->{meta_column};
    foreach my $name (@{ $props->{columns} }) {
        $fields->{$name} = ();
        # Skip adding this method if the class overloads it.
        # this lets the SUPER::columnname magic do it's thing
        unless ($class->can($name)) {
            no strict 'refs'; ## no critic
            *{"${class}::$name"} = sub { shift->$meta_col($name, @_) };
        }
    }
}

sub has_meta {
    my $props = $_[0]->properties;
    return $props->{meta} && (@_ > 1 ? exists $props->{meta_columns}{$_[1]} : 1);
}

sub pre_save_serialize_metadata {
    my ($obj) = shift;
    my $meta_col = $obj->properties->{meta_column};
    if ($obj->{changed_cols}{$meta_col}) {
        require MT::Serialize;
        my $meta = $obj->$meta_col;
        $obj->$meta_col(MT::Serialize->serialize(\$meta));
    }
}

sub __thaw_meta {
    my ($meta) = @_;
    $$meta = '' unless defined $$meta;
    require MT::Serialize;
    my $out = MT::Serialize->unserialize($$meta);
    if (ref $out eq 'REF') {
        return $$out;
    } else {
        return {};
    }
}

# $obj->meta returns a hashref of metadata information
# $obj->meta($scalar) allows assignment of a serialized value
# $obj->meta('name', 'value') assigns an individual metadata element
# $obj->meta('name') returns an individual metadata value
# $obj->save will automatically serialize the metadata back to the database
sub __meta_column {
    my $obj = shift;
    my $meta_col = $obj->properties->{meta_column} or return;

    if (@_) {
        my $var = shift;
        if ((defined $var) && ($var =~ m/^SERG\0\0\0\0/)) {
            return $obj->column($meta_col, $var);
        }
        my $meta = $obj->column($meta_col);
        if (!defined($meta)) {
            $obj->{column_values}{$meta_col} = $meta = {};
        } elsif (!ref $meta) {
            $obj->{column_values}{$meta_col} = $meta = __thaw_meta(\$meta);
        }
        if (@_) {
            $meta->{$var} = shift if @_;
            $obj->{changed_cols}{$meta_col}++;
        }
        return $meta->{$var};
    } else {
        my $meta = $obj->column($meta_col);
        if (!ref $meta) {
            $meta = __thaw_meta(\$meta);
            $obj->{column_values}{$meta_col} = $meta;
        }
        # we should assume changes are going to be made, since
        # we can't really monitor the hash once it has left us
        $obj->{changed_cols}{$meta_col}++;
        return $meta;
    }
}

sub ts2db {  
    return unless $_[0];  
    if($_[0] =~ m{ \A \d{4} - }xms) {  
        return $_[0];  
    }  
    my $ret = sprintf '%04d-%02d-%02d %02d:%02d:%02d', unpack 'A4A2A2A2A2A2', $_[0];  
    return $ret;  
}  
  
sub db2ts {  
    my $ts = $_[0];  
    $ts =~ s/(?:\+|-)\d{2}$//;  
    $ts =~ tr/\- ://d;  
    return $ts;  
}  

sub get_date_translator {
    my $translator = shift;
    my $change = shift;
    return sub {
        my $obj = shift;
        my $dbd = $obj->driver->dbd;
        FIELD: for my $field (@{$obj->columns_of_type('datetime', 'timestamp')}) {
            my $value = $obj->column($field);
            next FIELD if !defined $value;
            my $new_val = $translator->($value); 
            if((defined $new_val) && ($new_val ne $value)) {
                $obj->column($field, $new_val, { no_changed_flag => !$change });
            }
        }
    };
}

sub translate_audited_fields {
    my ($obj, $orig_obj) = @_;
    my $dbd = $obj->driver->dbd;
    FIELD: for my $field (qw( created_on modified_on )) {
        my $value = $orig_obj->column($field);
        next FIELD if !defined $value;
        my $new_val = db2ts($value); 
        if((defined $new_val) && ($new_val ne $value)) {
            $orig_obj->column($field, $new_val);
        }
    }
    return;
}

sub nextprev {
    my $obj = shift;
    my $class = ref($obj);
    my %param = @_;
    my ($direction, $terms, $args, $by_field)
        = @param{qw( direction terms args by )};
    return undef unless ($direction eq 'next' || $direction eq 'previous');
    my $next = $direction eq 'next';

    if (!$by_field) {
        return if !$class->properties->{audit};
        $by_field = 'created_on';
    }

    # Selecting the adjacent object can be tricky since timestamps
    # are not necessarily unique for entries. If we find that the
    # next/previous object has a matching timestamp, keep selecting entries
    # to select all entries with the same timestamp, then compare them using
    # id as a secondary sort column.

    my ($id, $ts) = ($obj->id, $obj->$by_field());
    local @$args{qw( sort range_incl )}
        = ( [ { column => $by_field, desc => $next ? 'ASC' : 'DESC' },
            { column => 'id', desc => $next ? 'ASC' : 'DESC' } ],
            { $by_field => 1 });

    my $sibling = $class->load({
        $by_field => ($next ? [ $ts, undef ] : [ undef, $ts ]),
        'id' => $id,
        %{$terms}
    }, { not => { 'id' => 1 }, limit => 1, %$args });

    return $sibling;
}

## Drivers.

# Note: Removed methods: set_driver

sub count          { shift->_proxy('count',          @_) }
sub count_group_by { shift->_proxy('count_group_by', @_) }
sub sum_group_by   { shift->_proxy('sum_group_by',   @_) }
sub avg_group_by   { shift->_proxy('avg_group_by',   @_) }
sub remove_all     { shift->_proxy('remove_all',     @_) }

sub remove {
    my $obj = shift;
    my(@args) = @_;
    if (!ref $obj) {
        return $obj->driver->direct_remove($obj, @args);
    } else {
        return $obj->driver->remove($obj, @args);
    }
}

sub load {
    my $self = shift;
    if (defined $_[0] && (!ref $_[0] || (ref $_[0] ne 'HASH' && ref $_[0] ne 'ARRAY'))) {
        return $self->lookup($_[0]);
    } else {
        if (wantarray) {
            ## MT::Object::load returns a list in list context, just like
            ## a D::OD search.
            return $self->search(@_);
        } else {
            ## MT::Object::load returns the first result in scalar context.
            my $iter = $self->search(@_);
            return if !defined $iter;
            return $iter->();
        }
    }
}

# More or less replacing Data::ObjectDriver::Driver::DBI::search here
# to provide an 'early-finish' iterator as MT::ObjectDriver had provided.

sub load_iter   {
    my $class = shift;
    my($terms, $args) = @_;

    my $driver = $class->driver;
    my $dbi_driver = $driver;

    while ( $dbi_driver->isa('Data::ObjectDriver::Driver::BaseCache') ) {
        $dbi_driver = $dbi_driver->fallback;
    }

    if ($dbi_driver->dbd eq 'MT::ObjectDriver::Driver::SQLite') {
        # for SQLite, use search method, since this technique
        # will cause it to lock the table
        return scalar $class->search(@_);
    }

    my $rec = {};
    my $sth = $dbi_driver->fetch($rec, $class, $terms, $args);

    my $iter = sub {
        ## This is kind of a hack--we need $driver to stay in scope,
        ## so that the DESTROY method isn't called. So we include it
        ## in the scope of the closure.
        my $d = $dbi_driver;
        my $d2 = $driver;

        if (@_ && ($_[0] eq 'finish')) {
            if ($sth) {
                $sth->finish;
                $dbi_driver->end_query($sth);
            }
            undef $sth;
            return;
        }

        unless ($sth->fetch) {
            $sth->finish;
            $dbi_driver->end_query($sth);
            return;
        }
        my $obj;
        $obj = $class->new;
        $obj->set_values_internal($rec);
        ## Don't need a duplicate as there's no previous version in memory
        ## to preserve.
        $obj->call_trigger('post_load') unless $args->{no_triggers};
        $driver->cache_object($obj) if $obj && (!$args->{fetchonly});
        $obj;
    };
    return $iter;
}

## Callbacks

sub assign_audited_fields {
    my ($obj, $orig_obj) = @_;
    if ($obj->properties->{audit}) {
        my $blog_id;
        if ($obj->has_column('blog_id')) {
            $blog_id = $obj->blog_id;
        }
        my @ts = offset_time_list(time, $blog_id);
        my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
            $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];

        my $app = MT->instance;
        if ($app && $app->can('user')) {
            if (my $user = $app->user) {
                if (!defined $obj->created_on) {
                    $obj->created_by($user->id);
                    $orig_obj->created_by($obj->created_by);
                }
            }
        }
        unless ($obj->created_on) {
            $obj->created_on($ts);
            $orig_obj->created_on($ts);
            # intentionally not calling modified_by to distinguish
            $obj->modified_on($ts);
            $orig_obj->modified_on($ts);
        }
    }
}

sub modified_by {
    my $obj = shift;
    my ($user_id) = @_;
    if ($user_id) {
        if ($obj->properties->{audit}) {
            my $res = $obj->SUPER::modified_by($user_id);

            my $blog_id;
            if ($obj->has_column('blog_id')) {
                $blog_id = $obj->blog_id;
            }
            my @ts = offset_time_list(time, $blog_id);
            my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
                $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
            $obj->modified_on($ts);
            return $res;
        }
    }
    return $obj->SUPER::modified_by(@_);
}

# D::OD uses Class::Trigger. Map the call_trigger calls to also invoke
# MT's callbacks (but internal Class::Trigger routines should be invoked
# first in the case of pre-triggers, and last in the case of post-triggers).

sub call_trigger {
    my $obj = shift;
    my $name = shift;
    my $class = ref $obj || $obj;
    my $pre_trigger = $name =~ m/^pre_/;
    $obj->SUPER::call_trigger($name, @_) if $pre_trigger;
    MT->run_callbacks($class . '::' . $name, $obj, @_);
    $obj->SUPER::call_trigger($name, @_) unless $pre_trigger;
}

# Support for MT-based callbacks.

sub add_callback {
    my $class = shift;
    my $meth = shift;
    MT->add_callback($class . '::' . $meth, @_);
}

## Construction/initialization.

sub init {
    my $obj = shift;
    $obj->SUPER::init(@_);
    $obj->set_defaults();
    return $obj;
}

sub set_defaults {
    my $obj = shift;
    my $defaults = $obj->properties->{'defaults'};
    $obj->{'column_values'} = $defaults ? {%$defaults} : {};
}

sub __properties { }

our $DRIVER;
sub driver {
    require MT::ObjectDriverFactory;
    return $DRIVER ||= MT::ObjectDriverFactory->new;
}

# ref to the fallback driver for non-cacheable classes
our $DBI_DRIVER;
sub dbi_driver {
    unless ($DBI_DRIVER) {
        my $driver = driver(@_);
        while ( $driver->can('fallback') ) {
            if ($driver->fallback) {
                $driver = $driver->fallback;
            } else {
                last;
            }
        }
        $DBI_DRIVER = $driver;
    }
    return $DBI_DRIVER;
}

sub table_name {
    my $obj = shift;
    return $obj->driver->table_for($obj);
}

sub clone {
    my $obj = shift;
    my($param) = @_;
    my $clone = $obj->SUPER::clone_all;

    ## If the caller has listed a set of columns not to copy to the clone,
    ## delete them from the clone.
    if ($param && ($param->{Except} || $param->{except})) {
        for my $col (keys %{ $param->{Except} || $param->{except} }) {
            $clone->$col(undef);
        }
    }
    return $clone;
}

sub columns_of_type {
    my $obj = shift;
    my(@types) = @_;
    my $props = $obj->properties;
    my $cols = $props->{columns};
    my $col_defs = $obj->column_defs;
    my @cols;
    my %types = map { $_ => 1 } @types;
    for my $col (@$cols) {
        push @cols, $col
            if $col_defs->{$col} && exists $types{$col_defs->{$col}{type}};
    }
    \@cols;
}

sub created_on_obj {
    my $obj = shift;
    return $obj->column_as_datetime('created_on');
}

sub column_as_datetime {
    my $obj = shift;
    my ($col) = @_;
    if (my $ts = $obj->column($col)) {
        my $blog;
        if ($obj->isa('MT::Blog')) {
            $blog = $obj;
        } else {
            if (my $blog_id = $obj->blog_id) {
                require MT::Blog;
                $blog = MT::Blog->lookup($blog_id);
            }
        }
        my($y, $mo, $d, $h, $m, $s) = $ts =~ /(\d\d\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)/;
        require MT::DateTime;
        my $four_digit_offset;
        if ($blog) {
            $four_digit_offset = sprintf('%.02d%.02d', int($blog->server_offset),
                                        60 * abs($blog->server_offset
                                                 - int($blog->server_offset)));
        }
        return new MT::DateTime(year => $y, month => $mo, day => $d,
                                hour => $h, minute => $m, second => $s,
                                time_zone => $four_digit_offset);
    }
    undef;
}

sub join_on {
    return [ @_ ];
}

sub remove_children {
    my $obj = shift;
    return 1 unless ref $obj;

    my ($param) = @_;
    my $child_classes = $obj->properties->{child_classes} || {};
    my @classes = keys %$child_classes;
    return 1 unless @classes;

    $param ||= {};
    my $key = $param->{key} || $obj->datasource . '_id';
    my $obj_id = $obj->id;
    for my $class (@classes) {
        eval "use $class;";
        $class->remove({ $key => $obj_id });
    }
    1;
}

sub get_by_key {
    my $class = shift;
    my ($key) = @_;
    my($obj) = $class->search($key);
    $obj ||= new $class;
    $obj->set_values($key);
    return $obj;
}

sub set_by_key {
    my $class = shift;
    my ($key, $value) = @_;
    my ($obj) = $class->search($key);
    unless ($obj) {
        $obj = new $class;
        $obj->set_values($key);
    }
    $obj->set_values($value) if $value;
    $obj->save or return;
    return $obj;
}

# This method is overridden since D::OD uses column_values to retrieve
# the content to cache if caching is enabled. Thus, we must ensure any
# metadata is serialized prior to caching.
sub column_values {
    my $props = $_[0]->properties;
    if ($props->{meta_column}
        && $_[0]->{changed_cols}{$props->{meta_column}}) {
        $_[0]->pre_save_serialize_metadata;
    }
    return $_[0]->SUPER::column_values(@_);
}

# We override D::OD's set_values method here only allowing the
# assignment of a column if the value given is defined. There are
# some legacy reasons for doing this, mostly for backward
# compatibility.
sub set_values {
    my $obj = shift;
    my ($values) = @_;
    for my $col (keys %$values) {
        unless ( $obj->has_column($col) ) {
            Carp::croak("You tried to set inexistent column $col to value $values->{$col} on " . ref($obj));
        }
        $obj->$col($values->{$col}) if defined $values->{$col};
    }
}

sub column_def {
    my $obj = shift;
    my ($name) = @_;
    my $defs = $obj->column_defs;
    my $def = $defs->{$name};
    if (!ref($def)) {
        $defs->{$name} = $def = $obj->__parse_def($name, $def);
    }
    return $def;
}

sub index_defs {
    my $obj = shift;
    my $props = $obj->properties;
    $props->{indexes};
}

sub column_defs {
    my $obj = shift;
    my $props = $obj->properties;
    my $defs = $props->{column_defs};
    return undef if !$defs;
    my ($key) = keys %$defs;
    if (!(ref $defs->{$key})) {
        $obj->__parse_defs($props->{column_defs});
    }
    $props->{column_defs};
}

sub __parse_defs {
    my $obj = shift;
    my ($defs) = @_;
    foreach my $col ( keys %$defs ) {
        next if ref($defs->{$col});
        $defs->{$col} = $obj->__parse_def($col, $defs->{$col});
    }
}

sub __parse_def {
    my $obj = shift;
    my ($col, $def) = @_;
    return undef if !defined $def;
    my $props = $obj->properties;
    my %def;
    if ($def =~ s/^([^( ]+)\s*//) {
        $def{type} = $1;
    }
    if ($def =~ s/^\((\d+)\)\s*//) {
        $def{size} = $1;
    }
    $def{not_null} = 1 if $def =~ m/\bnot null\b/i;
    $def{key} = 1 if $def =~ m/\bprimary key\b/i;
    $def{key} = 1 if ($props->{primary_key}) && ($props->{primary_key} eq $col);
    $def{auto} = 1 if $def =~ m/\bauto[_ ]increment\b/i;
    $def{default} = $props->{defaults}{$col} if exists $props->{defaults}{$col};
    \%def;
}

sub cache_property {
    my $obj = shift;
    my $key = shift;
    my $code = shift;
    if (ref $key eq 'CODE') {
        ($key, $code) = ($code, $key);
    }
    $key ||= (caller(1))[3];

    my $r = MT->request;
    my $oc = $r->cache('object_cache');
    unless ($oc) {
        $oc = {};
        $r->cache('object_cache', $oc);
    }
    $oc = $oc->{"$obj"} ||= {};
    if (@_) {
        $oc->{$key} = $_[0];
    } else {
        if ((!exists $oc->{$key}) && $code) {
            $oc->{$key} = $code->($obj, @_);
        }
    }
    return exists $oc->{$key} ? $oc->{$key} : undef;
}

sub clear_cache {
    my $obj = shift;
    my $oc = MT->request('object_cache') or return;
    if (@_) {
        $oc = $oc->{"$obj"};
        delete $oc->{shift} if $oc;
    } else {
        delete $oc->{"$obj"};
    }
}

sub to_hash {
    my $obj = shift;
    my $hash = {};
    my $props = $obj->properties;
    my $pfx = $obj->datasource;
    my $values = $obj->column_values;
    foreach (keys %$values) {
        $hash->{"${pfx}.$_"} = $values->{$_};
    }
    if (my $meta = $props->{meta_columns}) {
        foreach (keys %$meta) {
            $hash->{"${pfx}.$_"} = $obj->meta($_);
        }
    }
    if ($obj->has_column('blog_id')) {
        my $blog_id = $obj->blog_id;
        require MT::Blog;
        if (my $blog = MT::Blog->lookup($blog_id)) {
            my $blog_hash = $blog->to_hash;
            $hash->{"${pfx}.$_"} = $blog_hash->{$_} foreach keys %$blog_hash;
        }
    }
    $hash;
}

1;
__END__

=head1 NAME

MT::Object - Movable Type base class for database-backed objects

=head1 SYNOPSIS

Creating an I<MT::Object> subclass:

    package MT::Foo;
    use strict;

    use base 'MT::Object';

    __PACKAGE__->install_properties({
        columns_defs => {
            'id'  => 'integer not null auto_increment',
            'foo' => 'string(255)',
        },
        indexes => {
            foo => 1,
        },
        primary_key => 'id',
        datasource => 'foo',
    });

Using an I<MT::Object> subclass:

    use MT;
    use MT::Foo;

    ## Create an MT object to load the system configuration and
    ## initialize an object driver.
    my $mt = MT->new;

    ## Create an MT::Foo object, fill it with data, and save it;
    ## the object is saved using the object driver initialized above.
    my $foo = MT::Foo->new;
    $foo->foo('bar');
    $foo->save
        or die $foo->errstr;

=head1 DESCRIPTION

I<MT::Object> is the base class for all Movable Type objects that will be
serialized/stored to some location for later retrieval; this location could
be a DBM file, a relational database, etc.

Movable Type objects know nothing about how they are stored--they know only
of what types of data they consist, the names of those types of data (their
columns), etc. The actual storage mechanism is in the I<MT::ObjectDriver::Driver::DBI>
class and its driver subclasses; I<MT::Object> subclasses, on the other hand,
are essentially just standard in-memory Perl objects, but with a little extra
self-knowledge.

This distinction between storage and in-memory representation allows objects
to be serialized to disk in many different ways--for example, an object could
be stored in a MySQL database, in a DBM file, etc. Adding a new storage method
is as simple as writing an object driver--a non-trivial task, to be sure, but
one that will not require touching any other Movable Type code.

=head1 SUBCLASSING

Creating a subclass of I<MT::Object> is very simple; you simply need to
define the properties and metadata about the object you are creating. Start
by declaring your class, and inheriting from I<MT::Object>:

    package MT::Foo;
    use strict;

    use base 'MT::Object';

=item * __PACKAGE__->install_properties($args)

Then call the I<install_properties> method on your class name; an easy way
to get your class name is to use the special I<__PACKAGE__> variable:

    __PACKAGE__->install_properties({
        column_defs => {
            'id' => 'integer not null auto_increment',
            'foo' => 'string(255)',
        },
        indexes => {
            foo => 1,
        },
        primary_key => 'id',
        datasource => 'foo',
    });

I<install_properties> performs the necessary magic to install the metadata
about your new class in the MT system. The method takes one argument, a hash
reference containing the metadata about your class. That hash reference can
have the following keys:

=over 4

=item * column_defs

The definition of the columns (fields) in your object. Column names are also
used for method names for your object, so your column name should not
contain any strange characters. (It could also be used as part of the name of
the column in a relational database table, so that is another reason to keep
column names somewhat sane.)

The value for the I<columns> key should be a reference to an hashref
containing the key/value pairs that are names of your columns matched with
their schema definition.

The type declaration of a column is pseudo-SQL. The data types loosely match
SQL types, but are vendor-neutral, and each MT::ObjectDriver will map these
to appropriate types for the database it services. The format of a column
type is as follows:

    'column_name' => 'type(size) options'

The 'type' part of the declaration can be any one of:

=over 4

=item * string

For storing string data, typically up to 255 characters, but assigned a length identified by '(size)'.

=item * integer

For storing integers, maybe limited to 32 bits.

=item * boolean

For storing boolean values (numeric values of 1 or 0).

=item * smallint

For storing small integers, typically limited to 16 bits.

=item * datetime

For storing a full date and time value.

=item * timestamp

For storing a date and time that automatically updates upon save.

=item * blob

For storing binary data.

=item * text

For storing text data.

=item * float

For storing floating point values.

=back

Note: The physical data storage capacity of these types will vary depending on
the driver's implementation. Please refer to the documentation of the
MT::ObjectDriver you're using to determine the actual capacity for these
types.

The '(size)' element of the declaration is only valid for the 'string' type.

The 'options' element of the declaration is not required, but is used to
specify additional attributes of the column. Such as:

=over 4

=item * not null

Specify this option when you wish to constrain the column so that it must contain a defined value. This is only enforced by the database itself, not by the MT::ObjectDriver.

=item * auto_increment

Specify for integer columns (typically the primary key) to automatically assign a value.

=item * primary key

Specify for identifying the column as the primary key (only valid for a single column).

=back

=item * indexes

Specifies the column indexes on your objects; this only has consequence for
some object drivers (DBM, for example), where indexes are not automatically
maintained by the datastore (as they are in a relational database).

The value for the I<indexes> key should be a reference to a hash containing
column names as keys, and the value C<1> for each key--each key represents
a column that should be indexed.

B<NOTE:> with the DBM driver, if you do not set up an index on a column you
will not be able to select objects with values matching that column using the
I<load> and I<load_iter> interfaces (see below).

=item * audit

Automatically adds bookkeeping capabilities to your class--each object will
take on four new columns: I<created_on>, I<created_by>, I<modified_on>, and
I<modified_by>. The created_on, created_by columns will be populated
automatically (if they have not already been assigned at the time of saving
the object). Your application is responsible for updating the modified_on,
modified_by columns as these may require explicit application-specific
assignments (ie, your application may only want them updated during explicit
user interaction with the object, as opposed to cases where the object is
being changed and saved for mechanical purposes like upgrading a table).

=item * datasource

The name of the datasource for your class. The datasource is a name uniquely
identifying your class--it is used by the object drivers to construct table
names, file names, etc. So it should not be specific to any one driver.

=item * meta

Specify this property if you wish to add an additional 'meta' column to
the object properties. This is a special type of column that is used to
store complex data structures for the object. The data is serialized into
a blob for storage using the L<MT::Serialize> package.

=item * meta_column

If you wish to specify the name of the column to be used for storing
the object metadata, you may declare this property to name the column.
The default column name is 'meta'.

=item * class_type

If class_type is declared, an additional 'class' column is added to the
object properties. This column is then used to differentiate between
multiple object types that share the same physical table.

Note that if this is used, all searches will be constrained to match
the class type of the package.

=item * class_column

Defines the name of the class column (default is 'class') for storing
classed objects (see 'class_type' above).

=back

=head1 USAGE

=head2 System Initialization

Before using (loading, saving, removing) an I<MT::Object> class and its
objects, you must always initialize the Movable Type system. This is done
with the following lines of code:

    use MT;
    my $mt = MT->new;

Constructing a new I<MT> objects loads the system configuration from the
F<mt.cfg> configuration file, then initializes the object driver that will
be used to manage serialized objects.

=head2 Creating a new object

To create a new object of an I<MT::Object> class, use the I<new> method:

    my $foo = MT::Foo->new;

I<new> takes no arguments, and simply initializes a new in-memory object.
In fact, you need not ever save this object to disk; it can be used as a
purely in-memory object.

=head2 Setting and retrieving column values

To set the column value of an object, use the name of the column as a method
name, and pass in the value for the column:

    $foo->foo('bar');

The return value of the above call will be C<bar>, the value to which you have
set the column.

To retrieve the existing value of a column, call the same method, but without
an argument:

    $foo->foo

This returns the value of the I<foo> column from the I<$foo> object.

=over 4

=item * $obj->init()

=back

This method is used to initialize the object upon construction.

=over 4

=item * $obj->set_defaults()

=back

This method is used by the I<init> method to set the object defaults.

=head2 Saving an object

To save an object using the object driver, call the I<save> method:

=over 4

=item * $foo->save();

=back

On success, I<save> will return some true value; on failure, it will return
C<undef>, and you can retrieve the error message by calling the I<errstr>
method on the object:

    $foo->save
        or die "Saving foo failed: ", $foo->errstr;

If you are saving objects in a loop, take a look at the
L</"Note on object locking">.

=head2 Loading an existing object or objects

=over 4

=item * $obj->load()

=item * $obj->load_iter()

=back

You can load an object from the datastore using the I<load> method. I<load>
is by far the most complicated method, because there are many different ways
to load an object: by ID, by column value, by using a join with another type
of object, etc.

In addition, you can load objects either into an array (I<load>), or by using
an iterator to step through the objects (I<load_iter>).

I<load> has the following general form:

    my @objects = MT::Foo->load(\%terms, \%arguments);

I<load_iter> has the following general form:

    my $iter = MT::Foo->load_iter(\%terms, \%arguments);

Both methods share the same parameters; the only difference is the manner in
which they return the matching objects.

If you call I<load> in scalar context, only the first row of the array
I<@objects> will be returned; this works well when you know that your I<load>
call can only ever result in one object returned--for example, when you load
an object by ID.

I<\%terms> should be either:

=over 4

=item * The numeric ID of an object in the datastore.

=item * A reference to a hash.

The hash should have keys matching column names and the values are the
values for that column.

For example, to load an I<MT::Foo> object where the I<foo> column is
equal to C<bar>, you could do this:

    my @foo = MT::Foo->load({ foo => 'bar' });

In addition to a simple scalar, the hash value can be a reference to an array;
combined with the I<range> setting in the I<\%arguments> list, you can use
this to perform range searches. If the value is a reference, the first element
in the array specifies the low end of the range, and the second element the
high end.

=back

I<\%arguments> should be a reference to a hash containing parameters for the
search. The following parameters are allowed:

=over 4

=item * sort => "column"

Sort the resulting objects by the column C<column>; C<column> must be an
indexed column (see L</"indexes">, above).

=item * direction => "ascend|descend"

To be used together with I<sort>; specifies the sort order (ascending or
descending). The default is C<ascend>.

=item * limit => "N"

Rather than loading all of the matching objects (the default), load only
C<N> objects.

=item * offset => "M"

To be used together with I<limit>; rather than returning the first C<N>
matches (the default), return matches C<M> through C<N + M>.

=item * start_val => "value"

To be used together with I<limit> and I<sort>; rather than returning the
first C<N> matches, return the first C<N> matches where C<column> (the sort
column) is greater than C<value>.

=item * range

To be used together with an array reference as the value for a column in
I<\%terms>; specifies that the specific column should be searched for a range
of values, rather than one specific value.

The value of I<range> should be a hash reference, where the keys are column
names, and the values are all C<1>; each key specifies a column that should
be interpreted as a range.

    MT::Foo->load( { created_on => [ '20011008000000', undef ] },
        { range => { created_on => 1 } } );

This selects C<MT::Foo> objects whose created_on date is greater than
2001-10-08 00:00:00.

=item * range_incl

Like the 'range' attribute, but defines an inclusive range.

=item * join

Can be used to select a set of objects based on criteria, or sorted by
criteria, from another set of objects. An example is selecting the C<N>
entries most recently commented-upon; the sorting is based on I<MT::Comment>
objects, but the objects returned are actually I<MT::Entry> objects. Using
I<join> in this situation is faster than loading the most recent
I<MT::Comment> objects, then loading each of the I<MT::Entry> objects
individually.

Note that I<join> is not a normal SQL join, in that the objects returned are
always of only one type--in the above example, the objects returned are only
I<MT::Entry> objects, and cannot include columns from I<MT::Comment> objects.

I<join> has the following general syntax:

    join => MT::Foo->join_on( JOIN_COLUMN, I<\%terms>, I<\%arguments> )

Use the actual MT::Object-descended package name and the join_on static method
providing these parameters: I<JOIN_COLUMN> is the column joining the two
object tables, I<\%terms> and I<\%arguments> have the same meaning as they do
in the outer I<load> or I<load_iter> argument lists: they are used to select
the objects with which the join is performed.

For example, to select the last 10 most recently commmented-upon entries, you
could use the following statement:

    my @entries = MT::Entry->load(undef, {
        'join' => MT::Comment->join_on( 'entry_id',
                    { blog_id => $blog_id },
                    { 'sort' => 'created_on',
                      direction => 'descend',
                      unique => 1,
                      limit => 10 } )
    });

In this statement, the I<unique> setting ensures that the I<MT::Entry>
objects returned are unique; if this flag were not given, two copies of the
same I<MT::Entry> could be returned, if two comments were made on the same
entry.

=item * unique

Ensures that the objects being returned are unique.

This is really only useful when used within a I<join>, because when loading
data out of a single object datastore, the objects are always going to be
unique.

=back

=head2 Removing an object

=over 4

=item * $foo->remove()

=back

To remove an object from the datastore, call the I<remove> method on an
object that you have already loaded using I<load>:

    $foo->remove();

On success, I<remove> will return some true value; on failure, it will return
C<undef>, and you can retrieve the error message by calling the I<errstr>
method on the object:

    $foo->remove
        or die "Removing foo failed: ", $foo->errstr;

If you are removing objects in a loop, take a look at the
L</"Note on object locking">.

=head2 Removing select objects of a particular class

Combining the syntax of the load and remove methods, you can use the
static version of the remove method to remove particular objects:

    MT::Foo->remove({ bar => 'baz' });

The terms you specify to remove by should be indexed columns. This
method will load the object and remove it, firing the callback operations
associated with those operations.

=head2 Removing all of the objects of a particular class

To quickly remove all of the objects of a particular class, call the
I<remove_all> method on the class name in question:

=over 4

=item * MT::Foo->remove_all();

=back

On success, I<remove_all> will return some true value; on failure, it will
return C<undef>, and you can retrieve the error message by calling the
I<errstr> method on the class name:

    MT::Foo->remove_all
        or die "Removing all foo objects failed: ", MT::Foo->errstr;

=head2 Removing all the children of an object

=over 4

=item * $obj->remove_children([ \%param ])

=back

If your class has registered 'child_classes' as part of it's properties,
then this method may be used to remove objects that are associated with
the active object.

This method is typically used in an overridden 'remove' method.

    sub remove {
        my $obj = shift;
        $obj->remove_children({ key => 'object_id' });
        $obj->SUPER::remove(@_);
    }

The 'key' parameter specified here lets you identify the field name used by
the children classes to relate back to the parent class. If unspecified,
C<remove_children> will assume the key to be the datasource name of the
current class with an '_id' suffix.

=head2 Getting the count of a number of objects

To determine how many objects meeting a particular set of conditions exist,
use the I<count> method:

    my $count = MT::Foo->count({ foo => 'bar' });

I<count> takes the same arguments (I<\%terms> and I<\%arguments>) as I<load>
and I<load_iter>, above.

=head2 Determining if an object exists in the datastore

To check an object for existence in the datastore, use the I<exists> method:

    if ($foo->exists) {
        print "Foo $foo already exists!";
    }

=head2 Counting groups of objects

=over 4

=item * $obj->count_group_by()

=back

The count_group_by method can be used to retrieve a list of all the 
distinct values that appear in a given column along with a count of 
how many objects carry that value. The routine can also be used with 
more than one column, in which case it retrieves the distinct pairs 
(or n-tuples) of values in those columns, along with the counts. 
Yet more powerful, any SQL expression can be used in place of 
the column names to count how many object produce any given result 
values when run through those expressions.

  $iter = MT::Foo->count_group_by($terms, {%args, group => $group_exprs});

C<$terms> and C<%args> pick out a subset of the MT::Foo objects in the
usual way. C<$group_expressions> is an array reference containing the
SQL expressions for the values you want to group by. A single row will
be returned for each distinct tuple of values resulting from the
$group_expressions. For example, if $group_expressions were just a
single column (e.g. group => ['created_on']) then a single row would
be returned for each distinct value of the 'created_on' column. If
$group_expressions were multiple columns, a row would be returned for
each distinct pair (or n-tuple) of values found in those columns.

Each application of the iterator C<$iter> returns a list in the form:

  ($count, $group_val1, $group_val2, ...)

Where C<$count> is the number of MT::Foo objects for which the group
expressions are the values ($group_val1, $group_val2, ...). These
values are in the same order as the corresponding group expressions in
the $group_exprs argument.

In this example, we load up groups of MT::Pip objects, grouped by the
pair (cat_id, invoice_id), and print how many pips have that pair of
values.

    $iter = MT::Pip->count_group_by(undef,
                                    {group => ['cat_id',
                                               'invoice_id']});
    while (($count, $cat, $inv) = $iter->()) {
        print "There are $count Pips with " .
            "category $cat and invoice $inv\n";
    }

=head2 Inspecting and Manipulating Object State

=over 4

=item * $obj->column_values()

=back

Use C<column_values> and C<set_values> to get and set the fields of an
object I<en masse>. The former returns a hash reference mapping column
names to their values in this object. For example:

    $values = $obj->column_values()

=over 4

=item * $obj->set_values()

=back

C<set_values> accepts a similar hash ref, which need not give a value
for every field. For example:

    $obj->set_values({col1 => $val1, col2 => $val2});

is equivalent to

    $obj->col1($val1);
    $obj->col2($val2);

=head2 Other Methods

=over 4

=item * $obj->clone([\%param])

Returns a clone of C<$obj>. That is, a distinct object which has all
the same data stored within it. Changing values within one object does
not modify the other.

An optional C<except> parameter may be provided to exclude particular
columns from the cloning operation. For example, the following would
clone the elements of the blog except the name attribute.

   $blog->clone({ except => { name => 1 } });

=item * $obj->column_names()

Returns a list of the names of columns in C<$obj>; includes all those
specified to the install_properties method as well as the audit
properties (C<created_on>, C<modified_on>, C<created_by>,
C<modified_by>), if those were enabled in install_properties.

=item * $obj->set_driver()

This method sets the object driver to use to link with a database.

=item * MT::Foo->driver()

=item * $obj->driver()

Returns the ObjectDriver object that links this object with a database.

=item * $obj->created_on_obj()

Returns an MT::DateTime object representing the moment when the
object was first saved to the database.

=item * MT::Foo->set_by_key($key_terms, $value_terms)

A convenience method that loads whatever object matches the C<$key_terms>
argument and sets some or all of its fields according to the
C<$value_terms>. For example:

   MT::Foo->set_by_key({name => 'Thor'},
                       {region => 'Norway', gender => 'Male'});

This loads the C<MT::Foo> object having 'name' field equal to 'Thor'
and sets the 'region' and 'gender' fields appropriately.

More than one term is acceptable in the C<$key_terms> argument. The
matching object is the one that matches all of the C<$key_terms>.

This method only useful if you know that there is a unique object
matching the given key. There need not be a unique constraint on the
columns named in the C<$key_hash>; but if not, you should be confident
that only one object will match the key.

=item * MT::Foo->get_by_key($key_terms)

A convenience method that loads whatever object matches the C<$key_terms>
argument. If no matching object is found, a new object will be constructed
and the C<$key_terms> provided will be assigned to it. So regardless of
whether the key exists already, this method will return an object with the
key requested. Note, however: if a new object is instantiated it is
not automatically saved.

    my $thor = MT::Foo->get_by_key({name => 'Thor'});
    $thor->region('Norway');
    $thor->gender('Male');
    $thor->save;

The fact that it returns a new object if one isn't found is to help
optimize this pattern:

    my $obj = MT::Foo->load({key => $value});
    if (!$obj) {
        $obj = new MT::Foo;
        $obj->key($value);
    }

This is equivalent to:

    my $obj = MT::Foo->get_by_key({key => $value});

If you don't appreciate the autoinstantiation behavior of this method,
just use the C<load> method instead.

More than one term is acceptable in the C<$key_terms> argument. The
matching object is the one that matches all of the C<$key_terms>.

This method only useful if you know that there is a unique object
matching the given key. There need not be a unique constraint on the
columns named in the C<$key_hash>; but if not, you should be confident
that only one object will match the key.

=item * $obj->cache_property($key, $code)

Caches the provided key (e.g. entry, trackback) with the return value
of the given code reference (which is often an object load call) so
that the value does not have to be recomputed each time.

=item * $obj->column_def($name)

This method returns the value of the given I<$name> C<column_defs>
propery.

=item * $obj->column_defs()

This method returns all the C<column_defs> of the property of the
object.

=item * $obj->to_hash()

TODO - So far I have not divined what this method actually does. Hints?

=item * Class->join_on()

This method returns the list of used by the join arguments parameter
used by the L<MT::App::CMS/listing> method.

=item * $obj->properties()

TODO - Return the return properties of the object.

=item * $obj->to_xml()

TODO - Returns the XML representation of the object.
This method is defined in MT/BackupRestore.pm - you must first 
use MT::BackupRestore to use this method.

=item * $obj->restore_parent_ids()

TODO - Backup file contains parent objects' ids (foreign keys).  However,
when parent objcects are restored, their ids will be changed.  This method
is to match the old and new ids of parent objects for children objects to be
correctly associated.
This method is defined in MT/BackupRestore.pm - you must first 
use MT::BackupRestore to use this method.

=item * $obj->parent_names()

TODO - Should be overridden by subclasses to return correct hash
whose keys are xml element names of the object's parent objects
and values are class names of them.
This method is defined in MT/BackupRestore.pm - you must first 
use MT::BackupRestore to use this method.

=back

=head1 NOTES

=head2 Note on object locking

When you read objects from the datastore, the object table is locked with a
shared lock; when you write to the datastore, the table is locked with an
exclusive lock.

Thus, note that saving or removing objects in the same loop where you are
loading them from an iterator will not work--the reason is that the datastore
maintains a shared lock on the object table while objects are being loaded
from the iterator, and thus the attempt to gain an exclusive lock when saving
or removing an object will cause deadlock.

For example, you cannot do the following:

    my $iter = MT::Foo->load_iter({ foo => 'bar' });
    while (my $foo = $iter->()) {
        $foo->remove;
    }

Instead you should do either this:

    my @foo = MT::Foo->load({ foo => 'bar' });
    for my $foo (@foo) {
        $foo->remove;
    }

or this:

    my $iter = MT::Foo->load_iter({ foo => 'bar' });
    my @to_remove;
    while (my $foo = $iter->()) {
        push @to_remove, $foo
            if SOME CONDITION;
    }
    for my $foo (@to_remove) {
        $foo->remove;
    }

This last example is useful if you will not be removing every I<MT::Foo>
object where I<foo> equals C<bar>, because it saves memory--only the
I<MT::Foo> objects that you will be deleting are kept in memory at the same
time.

=head1 CALLBACKS

=over 4

=item * $obj->add_callback()

=back

Most MT::Object operations can trigger callbacks to plugin code. Some
notable uses of this feature are: to be notified when a database record is
modified, or to pre- or post-process the data being flowing to the
database.

To add a callback, invoke the C<add_callback> method of the I<MT::Object>
subclass, as follows:

   MT::Foo->add_callback( "pre_save", <priority>, 
                          <plugin object>, \&callback_function);

The first argument is the name of the hook point. Any I<MT::Object>
subclass has a pre_ and a post_ hook point for each of the following
operations:

    load
    save
    remove
    remove_all
    (load_iter operations will call the load callbacks)

The second argument, E<lt>priorityE<gt>, is the relative order in
which the callback should be called. The value should be between 1 and
10, inclusive. Callbacks with priority 1 will be called before those
with 2, 2 before 3, and so on.

Plugins which know they need to run first or last can use the priority
values 0 and 11. A callback with priority 0 will run before all
others, and if two callbacks try to use that value, an error will
result. Likewise priority 11 is exclusive, and runs last.

How to remember which callback priorities are special? As you know,
most guitar amps have a volume knob that goes from 1 to 10. But, like
that of certain rock stars, our amp goes up to 11. A callback with
priority 11 is the "loudest" or most powerful callback, as it will be
called just before the object is saved to the database (in the case of
a 'pre' callback), or just before the object is returned (in the case
of a 'post' callback). A callback with priority 0 is the "quietest"
callback, as following callbacks can completely overwhelm it. This may
be a good choice for your plugin, as you may want your plugin to work
well with other plugins. Determining the correct priority is a matter
of thinking about your plugin in relation to others, and adjusting the
priority based on experience so that users get the best use out of the
plugin.

The E<lt>plugin objectE<gt> is an object of type MT::Plugin which
gives some information about the plugin. This is used to include
the plugin's name in any error messages.

E<lt>callback functionE<gt> is a code referense for a subroutine that
will be called. The arguments to this
function vary by operation (see I<MT::Callback> for details),
but in each case the first parameter is the I<MT::Callback> object
itself:

  sub my_callback {
      my ($cb, ...) = @_;

      if ( <error condition> ) {
          return $cb->error("Error message");
      }
  }

Strictly speaking, the return value of a callback is ignored. Calling
the error() method of the MT::Callback object (C<$cb> in this case)
propagates the error message up to the MT activity log. 

Another way to handle errors is to call C<die>. If a callback dies,
I<MT> will warn the error to the activity log, but will continue
processing the MT::Object operation: so other callbacks will still
run, and the database operation should still occur.

=head2 Any-class Object Callbacks

If you add a callback to the MT class with a hook point that begins
with C<*::>, such as:

    MT->add_callback('*::post_save', 7, $my_plugin, \&code_ref);

then it will be called whenever post_save callbacks are called.
"Any-class" callbacks are called I<after> all class-specific
callbacks. Note that C<add_callback> must be called on the C<MT> class,
not on a subclass of C<MT::Object>.

=over 4

=item * $obj->set_callback_routine()

This method just calls the set_callback_routine as defined by the
MT::ObjectDriver set with the I<set_driver> method.


=back

=head2 Caveat

Be careful how you handle errors. If you transform data as it goes
into and out of the database, and it is possible for one of your
callbacks to fail, the data may get saved in an undefined state. It
may then be difficult or impossible for the user to recover that data.

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
