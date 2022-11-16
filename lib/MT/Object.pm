# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Object;

use strict;
use warnings;
use base qw( Data::ObjectDriver::BaseObject MT::ErrorHandler );

use MT;
use MT::Util qw(offset_time_list);

my ( @PRE_INIT_PROPS, @PRE_INIT_META );

sub install_pre_init_properties {

    # Just in case; to prevent any weird recursion
    local $MT::plugins_installed = 1;

    foreach my $def (@PRE_INIT_PROPS) {
        my ( $class, $props ) = @$def;
        $class->install_properties($props);
    }
    @PRE_INIT_PROPS = ();

    foreach my $def (@PRE_INIT_META) {
        my ( $class, $meta, $which ) = @$def;
        $class->install_meta( $meta, $which );
    }
    @PRE_INIT_META = ();
}

sub install_properties {
    my $class = shift;
    my ($props) = @_;

    if ( ( $class ne 'MT::Config' ) && ( !$MT::plugins_installed ) ) {

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

        push @PRE_INIT_PROPS, [ $class, $props ];
        return;
    }

    my %meta;
    my %summary;

    my $super_props = $class->SUPER::properties();
    for my $which (qw( meta summary )) {
        $props->{$which} = 1 if $super_props && $super_props->{$which};
    }

    if ( $props->{meta} ) {

        # yank out any meta columns before we start working on column_defs
        $meta{$_} = delete $props->{column_defs}{$_}
            for grep { $props->{column_defs}{$_} =~ m/\bmeta\b/ }
            keys %{ $props->{column_defs} };
    }

    if ($super_props) {

        # subclass; merge hash
        for (qw(primary_key class_column datasource driver audit)) {
            $props->{$_} = $super_props->{$_}
                if exists $super_props->{$_} && !( exists $props->{$_} );
        }
        for my $p (qw(column_defs defaults indexes)) {
            if ( exists $super_props->{$p} ) {
                foreach my $k ( keys %{ $super_props->{$p} } ) {
                    if ( !exists $props->{$p}{$k} ) {
                        $props->{$p}{$k} = $super_props->{$p}{$k};
                    }
                }
                if ( $p eq 'column_defs' ) {
                    $class->__parse_defs( $props->{column_defs} );
                }
            }
        }
        if ( $super_props->{class_type} ) {

            # copy reference of class_to_type/type_to_class hashes
            $props->{__class_to_type} = $super_props->{__class_to_type};
            $props->{__type_to_class} = $super_props->{__type_to_class};
        }
    }

    # Legacy MT::Object types only define 'columns'; we still support that
    # but they aren't handled properly with the upgrade system as a result.
    if ( !exists $props->{column_defs} ) {
        map { $props->{column_defs}{$_} = () } @{ $props->{columns} };
    }
    $props->{columns} = [ keys %{ $props->{column_defs} } ];

    # Support audit flags
    if ( $props->{audit} ) {
        unless ( exists $props->{column_defs}{created_on} ) {
            $props->{column_defs}{created_on}  = 'datetime';
            $props->{column_defs}{created_by}  = 'integer';
            $props->{column_defs}{modified_on} = 'datetime';
            $props->{column_defs}{modified_by} = 'integer';
            push @{ $props->{columns} },
                qw( created_on created_by modified_on modified_by );
        }
    }

    # Classed object types
    $props->{class_column} ||= 'class' if exists $props->{class_type};
    if ( my $col = $props->{class_column} ) {
        if ( !$props->{column_defs}{$col} ) {
            $props->{column_defs}{$col} = 'string(255)';
            push @{ $props->{columns} }, $col;
            $props->{indexes}{$col} = 1;
        }
        if ( !$super_props || !$super_props->{class_column} ) {
            $class->add_trigger(
                pre_search => \&_pre_search_scope_terms_to_class );
            $class->add_trigger( post_load => \&_post_load_rebless_object );
            $class->add_trigger(
                post_inflate => \&_post_load_rebless_object );
        }
        if ( my $type = $props->{class_type} ) {
            $props->{defaults}{$col}          = $type;
            $props->{__class_to_type}{$class} = $type;
            $props->{__type_to_class}{$type}  = $class;
        }
    }

    my $type_id;
    if ( $type_id = $props->{class_type} ) {
        if ( $type_id ne $props->{datasource} ) {
            $type_id = $props->{datasource} . '.' . $type_id;
        }
    }
    else {
        $type_id = $props->{datasource};
    }

    if ( $props->{summary} ) {
        my $type_summaries = MT->registry( 'summaries', $type_id );
        %summary = map {
            $_ => ( $type_summaries->{$_}->{type} =~ /(string|integer)/ )
                ? "$1 indexed meta"
                : "$type_summaries->{$_}->{type} meta"
        } keys %$type_summaries;
    }

    $props->{get_driver} ||= sub {
        require MT::ObjectDriverFactory;
        return MT::ObjectDriverFactory->instance;
    };

    $class->SUPER::install_properties($props);

    # check for any supplemental columns from other components
    my $more_props = MT->registry( 'object_types', $type_id );
    if ( $more_props && ( ref($more_props) eq 'ARRAY' ) ) {
        my $cols = {};
        for my $prop (@$more_props) {
            next if ref($prop) ne 'HASH';
            MT::__merge_hash( $cols, $prop, 1 );
        }

        my $aliases = MT->registry( 'object_type_aliases', $type_id );
        if ($aliases) {
            my @alias_ids = ref $aliases eq 'ARRAY' ? @$aliases : ($aliases);
            @alias_ids = @{ $alias_ids[0] } if ref $alias_ids[0] eq 'ARRAY';
            for my $alias_id (@alias_ids) {
                my $props_alias = MT->registry( 'object_types', $alias_id );
                if ( $props_alias && ref $props_alias eq 'ARRAY' ) {
                    for my $prop (@$props_alias) {
                        next if ref($prop) ne 'HASH';
                        MT::__merge_hash( $cols, $prop, 1 );
                    }
                }
            }
        }

        my @classes = grep { !ref($_) } @$more_props;
        foreach my $isa_class (@classes) {
            next if UNIVERSAL::isa( $class, $isa_class );
            eval "# line "
                . __LINE__ . " "
                . __FILE__
                . "\nno warnings 'all';require $isa_class;"
                or die;
            no strict 'refs';    ## no critic
            push @{ $class . '::ISA' }, $isa_class;
        }
        if (%$cols) {

            # special case for 'plugin' key...
            delete $cols->{plugin} if exists $cols->{plugin};
            for my $name ( keys %$cols ) {
                next if exists $props->{column_defs}{$name};
                if ( $cols->{$name} =~ m/\bmeta\b/ ) {
                    $meta{$name} = $cols->{$name};
                    next;
                }

                $class->install_column( $name, $cols->{$name} );
                $props->{indexes}{$name} = 1
                    if $cols->{$name} =~ m/\bindexed\b/;
                if ( $cols->{$name} =~ m/\bdefault (?:'([^']+?)'|(\d+))\b/ ) {
                    $props->{defaults}{$name} = defined $1 ? $1 : $2;
                }
            }
        }
    }

    my $pk = $props->{primary_key} || '';
    @{ $props->{columns} }
        = sort { $a eq $pk ? -1 : $b eq $pk ? 1 : $a cmp $b }
        @{ $props->{columns} };

    # Child classes are declared as an array;
    # convert them to a hashref for easier lookup.
    if ( ( ref $props->{child_classes} ) eq 'ARRAY' ) {
        my $classes = $props->{child_classes};
        $props->{child_classes}
            = $super_props && $super_props->{child_classes} || {};
        @{ $props->{child_classes} }{@$classes} = ();
    }

    # We're declared as a child of some other class; associate ourselves
    # with that package (the invoking class should have already use'd it.)
    if ( exists $props->{child_of} ) {
        my $parent_classes = $props->{child_of};
        if ( !ref $parent_classes ) {
            $parent_classes = [$parent_classes];
        }
        foreach my $pc (@$parent_classes) {
            eval "require $pc;";
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
    foreach my $isa_pkg (@isa) {
        next unless $isa_pkg =~ /able$/;
        next if $isa_pkg eq $class;
        if ( $isa_pkg->can('install_properties') ) {
            $isa_pkg->install_properties($class);
        }
    }

    # install legacy date translation
    if ( 0 < scalar @{ $class->columns_of_type( 'datetime', 'timestamp' ) } )
    {
        if ( $props->{audit} ) {
            $class->add_trigger( pre_save  => \&_assign_audited_fields );
            $class->add_trigger( post_save => \&_translate_audited_fields );
        }

        $class->add_trigger(
            pre_save => _get_date_translator( \&_ts2db, 0 ) );
        $class->add_trigger(
            post_load => _get_date_translator( \&_db2ts, 0 ) );
    }

    # Treat blank string with number field
    $class->add_trigger( pre_save => \&_translate_numeric_fields );

    # inherit parent's metadata setup
    if ( $props->{meta} )
    {    # if ($super_props && $super_props->{meta_installed}) {
        $class->install_meta(
            { ( %meta ? ( column_defs => \%meta ) : ( columns => [] ) ) },
            'meta' );
        $class->add_trigger( post_remove => \&remove_meta );
    }
    if ( $props->{summary} )
    {    # if ($super_props && $super_props->{meta_installed}) {
        $class->install_meta(
            {   (   %summary
                    ? ( column_defs => \%summary )
                    : ( columns => [] )
                )
            },
            'summary'
        );
    }

# Because of the inheritance of MT::Entry by MT::Page, we need to do this here
    if ( $class->isa('MT::Revisable') ) {
        $class->init_revisioning();
    }

    my $enc = MT->config->PublishCharset || 'UTF-8';

    # install these callbacks that is guaranteed to be called
    # at the very last in the callback list to encode everything.
    $class->add_trigger(
        '__core_final_pre_save',
        sub {
            my ( $obj, $original ) = @_;
            my $dbd = $obj->driver->dbd;
            return unless $dbd->need_encode;

            my $data = $obj->get_values;
            foreach ( keys %$data ) {
                $data->{$_} = Encode::encode( $enc, $data->{$_} )
                    if Encode::is_utf8( $data->{$_} );
            }
            $obj->set_values( $data, { no_changed_flag => 1 } );
        },
    );

    $class->add_trigger(
        '__core_final_pre_search',
        sub {
            my ( $class, $terms, $args ) = @_;
            my $dbd = $class->driver->dbd;
            return unless $dbd->need_encode;

            if ( 'HASH' eq ref($terms) ) {
                while ( my ( $k, $v ) = each %$terms ) {
                    $terms->{$k} = _encode_terms($v);
                }
            }
            elsif ( 'ARRAY' eq ref($terms) ) {
                for ( my $i = 0; $i < scalar(@$terms); ++$i ) {
                    $terms->[$i] = _encode_terms( $terms->[$i] );
                }
            }
        },
    );

    # install the callback that is guaranteed to be called
    # at the very first in the callback list to decode everything.
    $class->add_trigger(
        '__core_final_post_load',
        sub {
            my ($obj)    = @_;
            my $data     = $obj->{column_values};
            my $props    = $obj->properties;
            my $cols     = $props->{columns};
            my $col_defs = $obj->column_defs;
            my %is_blob;
            for my $col (@$cols) {
                $is_blob{$col} = 1
                    if $col_defs->{$col}
                    && $col_defs->{$col}{type} =~ /\bblob\b/;
            }
            foreach ( keys %$data ) {
                my $v = $data->{$_};
                if ( !( Encode::is_utf8( $data->{$_} ) ) && !$is_blob{$_} ) {
                    $data->{$_} = Encode::decode( $enc, $v );
                }
            }
            $obj->{__core_final_post_load_mark} = 1;
        },
    );

    return $props;
}

sub _encode_terms {
    my ($value) = @_;
    my $enc = MT->config->PublishCharset || 'UTF-8';

    if ( 'SCALAR' eq ref($value) ) {
        return $value unless Encode::is_utf8($$value);
        my $val = Encode::encode( $enc, $$value );
        return \$val;
    }
    elsif ( 'HASH' eq ref($value) ) {
        while ( my ( $key, $val ) = each %$value ) {
            $value->{$key} = _encode_terms($val);
        }
        return $value;
    }
    elsif ( 'ARRAY' eq ref($value) ) {
        my @values;
        foreach my $val (@$value) {
            push @values, _encode_terms($val);
        }
        return \@values;
    }
    elsif ( !ref($value) ) {
        return $value unless Encode::is_utf8($value);
        return Encode::encode( $enc, $value );
    }
}

# A post-load trigger for classed objects
sub _post_load_rebless_object {
    my $obj   = shift;
    my $props = $obj->properties;
    if ( my $col = $props->{class_column} ) {
        my $type = $obj->column($col);
        my $pkg  = ref($obj);
        return unless $pkg->class_type;
        if ( $pkg->class_type ne $type ) {
            if ( my $class = $props->{__type_to_class}{$type} ) {
                bless $obj, $class;
            }
            else {
                my %models
                    = map { $_ => 1 } MT->models( $props->{datasource} );
                if ( exists $models{ $props->{datasource} . '.' . $type } ) {
                    $class = MT->model( $props->{datasource} . '.' . $type );
                }
                elsif ( exists $models{$type} ) {
                    $class = MT->model($type);
                }
                bless $obj, $class if $class;
            }
        }
    }
    return;
}

# A pre-search trigger for classed objects
sub _pre_search_scope_terms_to_class {
    my ( $class, $terms, $args ) = @_;

    # scope search terms to class

    $terms ||= {};

    my $props = $class->properties;
    my $col   = $props->{class_column}
        or return;
    my $no_class = 0;
    if ( $args->{no_class} ) {
        delete $args->{no_class};
        $no_class = 1;
    }
    if ( ref $terms eq 'HASH' ) {
        if ( exists $terms->{$col} ) {
            if ( ( $terms->{$col} eq '*' ) || $no_class ) {

               # class term is '*', which signifies filtering for all classes.
               # simply delete the term in this case.
                delete $terms->{$col};
            }
            elsif ( $terms->{$col} =~ m/^(\w+:)\*$/ ) {

                # class term is in form "foo:*"; translate to a sql-compatible
                # syntax of "like 'foo:%'"
                $terms->{$col} = \"like '$1%'";    # ";
            }

            # term has been explicitly given or explictly removed. make
            # no further changes.
            return;
        }

        # class term is class_type if id is not exists.
        if ( !exists( $terms->{id} ) ) {
            $terms->{$col} = $props->{class_type}
                unless $no_class;
        }
    }
    elsif ( ref $terms eq 'ARRAY' ) {
        if ( my @class_terms
            = grep { ref $_ eq 'HASH' && $_->{$col} } @$terms )
        {

            # Filter out any unlimiting class terms (class = *).
            my $new_terms;
            foreach my $term (@$terms) {
                if ( ref $term ne 'HASH' || !$term->{$col} ) {
                    push @$new_terms, $term;
                }
                else {
                    if ( 1 != keys %$term ) {
                        my $array;
                        foreach my $t ( keys %$term ) {
                            push @$array, { $t => $term->{$t} }
                                if lc $t ne lc $col
                                || ( lc $t eq lc $col
                                && !$no_class
                                && $term->{$t} ne '*' );
                        }
                        push @$new_terms, $array;
                    }
                    else {
                        push @$new_terms, $term
                            if ( $no_class && !$term->{$col} )
                            || ( !$no_class && $term->{$col} ne '*' );
                    }
                }
            }
            @$terms = $new_terms;

            # Remove empty hashrefs.
            @$terms = grep { ref $_ ne 'HASH' || scalar keys %$_ } @$terms;

            # The class column has been explicitly given or removed, so don't
            # add one.
            return;
        }
        @$terms = ( { $col => $props->{class_type} } => 'AND' => [@$terms] )
            unless $no_class;
    }
}

sub class_label {
    my $pkg = shift;
    return MT->translate( $pkg->datasource );
}

sub class_label_plural {
    my $pkg   = shift;
    my $label = $pkg->datasource;
    $label =~ s/y$/ie/;
    $label .= 's';
    return MT->translate($label);
}

sub contents_label { return '' }

sub contents_label_plural {
    my $pkg   = shift;
    my $label = $pkg->contents_label
        or return '';
    $label =~ s/y$/ie/;
    $label .= 's';
    return MT->translate($label);
}

sub container_label { return '' }

sub container_label_plural {
    my $pkg   = shift;
    my $label = $pkg->container_label
        or return '';
    $label =~ s/y$/ie/;
    $label .= 's';
    return MT->translate($label);
}

sub class_labels {
    my $pkg       = shift;
    my @all_types = MT->models( $pkg->properties->{datasource} );
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
    if ( ref $pkg ) {
        return $pkg->column( $pkg->properties->{class_column} );
    }
    else {
        return $pkg->properties->{class_type};
    }
}

sub class_handler {
    my $pkg     = shift;
    my $props   = $pkg->properties;
    my ($type)  = @_;
    my $package = $props->{__type_to_class}{$type};
    unless ($package) {
        my $ds = $props->{datasource};
        if ( ( $type eq $ds ) || ( $type =~ m/\./ ) ) {
            $package = MT->model($type);
        }
        else {
            $package = MT->model( $ds . '.' . $type );
        }
    }
    if ($package) {
        if ( defined *{ $package . '::new' } ) {
            return $package;
        }
        else {
            eval "# line " . __LINE__ . " " . __FILE__
                . "\nno warnings 'all';require $package;";
            return $package unless $@;
            eval "# line " . __LINE__ . " " . __FILE__
                . "\nno warnings 'all';require $pkg; $package->new;";
            return $package unless $@;
        }
    }
    return $pkg;
}

sub add_class {
    my $pkg = shift;
    my ( $type, $class ) = @_;
    my $props = $pkg->properties;
    if ( $type =~ m/::/ ) {
        ( $type, $class ) = ( $class, $type );
    }

    if ( my $old_class = $props->{__type_to_class}{$type} ) {
        delete $props->{__class_to_type}{$old_class};
    }
    $props->{__type_to_class}{$type}  = $class;
    $props->{__class_to_type}{$class} = $type;
}

# 'meta' metadata column support

sub new {
    my $class = shift;
    my $obj   = $class->SUPER::new(@_);
    for my $which (qw( meta summary )) {
        if ( $obj->properties->{ $which . '_installed' } ) {
            $obj->init_meta($which);
        }
    }
    return $obj;
}

sub init_meta {
    my $obj = shift;
    my ($which) = @_;
    $which ||= 'meta';
    my $res;
    if ( lc $which eq 'meta' ) {
        require MT::Meta::Proxy;
        $obj->{"__meta"} = $res = MT::Meta::Proxy->new($obj);
    }
    elsif ( lc $which eq 'summary' ) {
        require MT::Summary::Proxy;
        $obj->{"__summary"} = $res = MT::Summary::Proxy->new($obj);
    }
    else {
        my $class = 'MT::' . ucfirst($which) . '::Proxy';
        eval("require $class;");
        $obj->{"__$which"} = $res = $class->new($obj);
    }
    $res;
}

sub install_meta {
    my $class = shift;
    my ( $params, $which ) = @_;
    $which ||= 'meta';
    my $installed  = $which . '_installed';
    my $meta_class = 'MT::' . ucfirst($which);
    if ( ( $class ne 'MT::Config' ) && ( !$MT::plugins_installed ) ) {
        push @PRE_INIT_META, [ $class, $params, $which ];
        return;
    }

    eval("require $meta_class");
    my $pkg = ref $class || $class;
    if ( !$pkg->SUPER::properties->{$installed} ) {
        $pkg->add_trigger( post_save    => \&_post_save_save_metadata );
        $pkg->add_trigger( post_load    => \&_post_load_initialize_metadata );
        $pkg->add_trigger( post_inflate => \&_post_load_initialize_metadata );
    }

    my $props = $class->properties;

    if (   !$params->{columns}
        && !$params->{fields}
        && !$params->{column_defs} )
    {
        return $class->error('No meta fields specified to install_meta');
    }

    $params->{fields} ||= [];
    if ( my $cols = delete $params->{columns} ) {
        foreach my $col (@$cols) {
            push @{ $params->{fields} },
                {
                name => $col,
                type => 'vblob',
                };

            # $props->{fields}{$col} = 'vblob';
        }
    }
    if ( my $cols = delete $params->{column_defs} ) {
        foreach my $col ( keys %$cols ) {
            my $type = $cols->{$col};
            $type =~ s/\s.*//;   # take first keyword, ignoring anything after
            $type .= '_indexed'
                if $cols->{$col} =~ m/\bindexed\b/;
            $type = $meta_class->normalize_type($type);

            push @{ $params->{fields} },
                {
                name => $col,
                type => $type,
                };

            # $props->{fields}{$col} = $type;
        }
    }

    $params->{datasource} ||= $class->datasource . "_$which";

    if ( $props->{$installed} && !@{ $params->{fields} } ) {
        return 1;
    }

    if ( my $fields = $meta_class->install( $pkg, $params, $which ) ) {

        # we may have inherited meta fields so lets update with
        # the fields returned by MT::Meta
        my $which_fields = ( $which eq 'meta' ) ? 'fields' : 'summaries';
        $props->{$which_fields}->{$_} = $fields->{$_} for keys %$fields;
    }

    return $props->{$installed} = 1;
}

sub meta_args {
    my $class    = shift;
    my $id_field = $class->datasource . '_id';
    return {
        key         => $class->datasource,
        column_defs => {
            $id_field     => 'integer not null',
            type          => 'string(75) not null',
            vchar         => 'string(255)',
            vchar_idx     => 'string(255)',
            vdatetime     => 'datetime',
            vdatetime_idx => 'datetime',
            vinteger      => 'integer',
            vinteger_idx  => 'integer',
            vfloat        => 'float',
            vfloat_idx    => 'float',
            vblob         => 'blob',
            vclob         => 'text',
        },
        columns => [
            $id_field, qw(
                type
                vchar
                vchar_idx
                vdatetime
                vdatetime_idx
                vinteger
                vinteger_idx
                vfloat
                vfloat_idx
                vblob
                vclob
                )
        ],
        indexes => {

            #id_type    => { columns => [ $id_field, 'type' ] }, # redundant
            type_vchar => { columns => [ 'type', 'vchar_idx' ] },
            type_vdt   => { columns => [ 'type', 'vdatetime_idx' ] },
            type_vint  => { columns => [ 'type', 'vinteger_idx' ] },
            type_vflt  => { columns => [ 'type', 'vfloat_idx' ] },
        },
        primary_key => [ $id_field, 'type' ],
    };
}

sub summary_args {
    my $class    = shift;
    my $id_field = $class->datasource . '_id';
    return {
        key         => $class->datasource,
        column_defs => {
            $id_field    => 'integer not null',
            type         => 'string(75) not null',
            class        => 'string(75) not null',
            vchar_idx    => 'string(255)',
            vinteger_idx => 'integer',
            vblob        => 'blob',
            vclob        => 'text',
            expired      => 'smallint',
        },
        columns => [
            $id_field, qw(
                type
                class
                vchar_idx
                vinteger_idx
                vblob
                vclob
                expired
                )
        ],
        indexes => {
            id_class    => { columns => [ $id_field, 'class' ] },
            class_vchar => { columns => [ 'class',   'vchar_idx' ] },
            class_vint  => { columns => [ 'class',   'vinteger_idx' ] },
        },
        primary_key => [ $id_field, 'type' ],
    };
}

sub has_meta {
    my $obj = shift;
    return $obj->is_meta_column(@_) if @_;
    return $obj->properties->{meta_installed} ? 1 : 0;
}

sub has_summary {
    my $obj = shift;
    return $obj->is_summary(@_) if @_;
    return $obj->properties->{summary_installed} ? 1 : 0;
}

sub _post_load_initialize_metadata {
    my $obj = shift;
    for my $which (qw( meta summary )) {
        if ( defined $obj && $obj->properties->{ $which . '_installed' } ) {
            $obj->init_meta($which);
            $obj->{"__$which"}->set_primary_keys($obj);
        }
    }
}

sub is_meta_column {
    my $obj = shift;
    my ( $field, $which ) = @_;
    return unless $field;

    $which ||= 'meta';
    my $which_fields = ( $which eq 'meta' ) ? 'fields' : 'summaries';
    my $props = $obj->properties;
    return unless $props->{ $which . '_installed' };

    my $meta = $obj->meta_pkg($which);
    return 1 if $props->{$which_fields}{$field};

    return;
}

sub is_summary {
    my $obj = shift;
    $obj->is_meta_column( $_[0], 'summary' );
}

sub meta_pkg {
    my $class = shift;
    my ($which) = @_;
    $which ||= 'meta';
    my $pkg   = $which . '_pkg';
    my $props = $class->properties;
    return unless $props->{$which}; # this only works for meta-enabled classes

    return $props->{$pkg} if $props->{$pkg};

    my $meta = ref $class || $class;
    $meta .= '::' . ucfirst($which);
    return $props->{$pkg} = $meta;
}

sub has_column {
    my $obj = shift;
    return 1 if $obj->SUPER::has_column(@_);
    return 1 if $obj->is_meta_column(@_);
    return;
}

sub _post_save_save_metadata {
    my $obj = shift;
    my ($orig_obj) = @_;
    if ( defined $obj && exists $obj->{__meta} ) {
        $obj->{__meta}->set_primary_keys($obj);
        $obj->{__meta}->save;
        $orig_obj->{__meta} = $obj->{__meta};
    }
    if ( defined $obj && exists $obj->{__summary} ) {
        $obj->{__summary}->set_primary_keys($obj);
        $orig_obj->{__summary} = $obj->{__summary};
    }
}

sub meta {
    my $obj = shift;
    my ( $name, $value ) = @_;

    return
          !$obj->{__meta} ? undef
        : 2 == scalar @_ ? $obj->{__meta}->set( $name, $value )
        : 1 == scalar @_ ? (
        ref($name) eq 'HASH'
        ? $obj->{__meta}->set_hash(@_)
        : $obj->{__meta}->get($name)
        )
        : $obj->{__meta}->get_hash;
}

sub summary {
    my $obj = shift;
    my ( $terms, $value ) = @_;
    $obj->{__summary}->set_primary_keys($obj);
    return undef if ( !$obj->{__summary} );
    return $obj->{__summary}->set( $terms, $value ) if ( scalar @_ == 2 );
    return $obj->{__summary}->get($terms);
}

sub meta_obj {
    my $obj = shift;
    return $obj->{__meta};
}

sub column_func {
    my $obj = shift;
    my ($col) = @_;
    return if !$col;

    return $obj->SUPER::column_func(@_)
        if !$obj->is_meta_column($col);

    return sub {
        my $obj = shift;
        if (@_) {
            $obj->{__meta}->set( $col, @_ );
        }
        else {
            $obj->{__meta}->get($col);
        }
    };
}

sub _ts2db {
    return unless $_[0];
    if ( $_[0] =~ m{ \A \d{4} - }xms ) {
        return $_[0];
    }
    my $ret = sprintf '%04d-%02d-%02d %02d:%02d:%02d',
        map { $_ || 0 } unpack 'A4A2A2A2A2A2',
        $_[0];
    return $ret;
}

sub _db2ts {
    my $ts = $_[0];
    $ts =~ s/(?:\+|-)\d{2}$//;
    $ts =~ tr/\- ://d;
    return $ts;
}

sub _get_date_translator {
    my $translator = shift;
    my $change     = shift;
    return sub {
        my $obj = shift;
    FIELD:
        for my $field (
            @{ $obj->columns_of_type( 'datetime', 'timestamp' ) } )
        {
            my $value = $obj->column($field);
            next FIELD if !defined $value;
            my $new_val = $translator->($value);
            $new_val = undef if defined $new_val && $new_val eq '';
            if ( ( !defined $new_val ) || ( $new_val ne $value ) ) {
                $obj->column( $field, $new_val,
                    { no_changed_flag => !$change } );
            }
        }
        if ( $obj->has_meta ) {
            my @meta_columns = MT::Meta->metadata_by_class( ref $obj );
            my @date_meta    = grep {
                       $_->{type} eq 'vdatetime'
                    || $_->{type} eq 'vdatetime_idx'
            } @meta_columns;
        META_FIELD: for my $f (@date_meta) {
                my $field = $f->{name};
                my $value = $obj->$field;
                next META_FIELD if !defined $value;
                my $new_val = $translator->($value);
                $new_val = undef if defined $new_val && $new_val eq '';
                if ( ( !defined $new_val ) || ( $new_val ne $value ) ) {
                    $obj->$field($new_val);
                }
            }
        }
    };
}

sub _translate_numeric_fields {
    my ( $obj, $orig_obj ) = @_;

    for my $field (
        @{  $obj->columns_of_type( 'integer', 'boolean', 'smallint', 'float',
                'double' )
        }
        )
    {
        next unless exists $obj->{changed_cols}->{$field};

        my $value = $obj->column($field);
        delete $obj->{changed_cols}->{$field}
            if defined $value and '' eq $value;
    }
}

sub _translate_audited_fields {
    my ( $obj, $orig_obj ) = @_;
    my $dbd = $obj->driver->dbd;
FIELD: for my $field (qw( created_on modified_on )) {
        my $value = $orig_obj->column($field);
        next FIELD if !defined $value;
        my $new_val = _db2ts($value);
        if ( ( defined $new_val ) && ( $new_val ne $value ) ) {
            $orig_obj->column( $field, $new_val );
        }
    }
    return;
}

sub nextprev {
    my $obj   = shift;
    my $class = ref($obj);
    my %param = @_;
    my ( $direction, $terms, $args, $by_field )
        = @param{qw( direction terms args by )};
    return undef unless ( $direction eq 'next' || $direction eq 'previous' );
    my $next = $direction eq 'next';

    if ( !$by_field ) {
        return if !$class->properties->{audit};
        $by_field = 'created_on';
    }

    # Selecting the adjacent object can be tricky since timestamps
    # are not necessarily unique for entries. If we find that the
    # next/previous object has a matching timestamp, keep selecting entries
    # to select all entries with the same timestamp, then compare them using
    # id as a secondary sort column.

    my ( $id, $ts ) = ( $obj->id, $obj->$by_field() );
    my $desc = $next ? 'ASC' : 'DESC';
    my $op   = $next ? '>'   : '<';
    my @terms = (
        {   $by_field => { $op => $ts },
            ( ref $terms ? %$terms : () ),
        },
        -or => {
            $by_field => $ts,
            id => { $op => $id },
            ( ref $terms ? %$terms : () ),
        },
    );
    my %args = (
        ( ref $args ? %$args : () ),
        limit => 1,
        sort  => [
            { column => $by_field, desc => $desc },
            { column => 'id',      desc => $desc },
        ],
    );
    return $class->load( \@terms, \%args );
}

## Drivers.

sub count          { shift->_proxy( 'count',          @_ ) }
sub exist          { shift->_proxy( 'exist',          @_ ) }
sub count_group_by { shift->_proxy( 'count_group_by', @_ ) }
sub sum_group_by   { shift->_proxy( 'sum_group_by',   @_ ) }
sub avg_group_by   { shift->_proxy( 'avg_group_by',   @_ ) }
sub max_group_by   { shift->_proxy( 'max_group_by',   @_ ) }
sub remove_all     { shift->_proxy( 'remove_all',     @_ ) }

sub save {
    my $obj = shift;
    my $res = eval {
        my $dbh = $obj->driver->rw_handle;
        local $dbh->{RaiseError} = 1;
        $obj->SUPER::save(@_);
    };
    if ( my $err = $@ ) {
        require MT::Util::Log;
        MT::Util::Log::init();
        MT::Util::Log->error($err);
        return $obj->error(MT->translate('An error occurred while saving changes to the database.'));
    }
    delete $obj->{__orig_value};
    return $res;
}

sub remove {
    my $obj = shift;
    my (@args) = @_;
    if ( !ref $obj ) {
        for my $which (qw( meta summary )) {
            my $meth = "remove_$which";
            my $has  = "has_$which";
            $obj->$meth(@args) if $obj->$has;
        }
        $obj->remove_scores(@args) if $obj->isa('MT::Scorable');
        MT->run_callbacks( $obj . '::pre_remove_multi', @args );
        return $obj->driver->direct_remove( $obj, @args );
    }
    else {
        return $obj->driver->remove( $obj, @args );
    }
}

sub load {
    my $self = shift;
    if ( defined $_[0]
        && ( !ref $_[0] || ( ref $_[0] ne 'HASH' && ref $_[0] ne 'ARRAY' ) ) )
    {
        return $self->lookup( $_[0] );
    }
    else {
        if (wantarray) {
            ## MT::Object::load returns a list in list context, just like
            ## a D::OD search.
            return $self->search(@_);
        }
        else {
            ## MT::Object::load returns the first result in scalar context.
            my ( $terms, $args ) = @_;
            $args ||= {};
            local $args->{limit} = 1;
            my $iter = $self->search( $terms, $args );
            return if !defined $iter;
            return $iter->();
        }
    }
}

sub load_iter {
    my $class = shift;
    my ( $terms, $args ) = @_;
    $args ||= {};
    local $args->{window_size} = 100
        unless defined( $args->{window_size} );
    return scalar $class->search( $terms, $args );
}

## Callbacks

sub _assign_audited_fields {
    my ( $obj, $orig_obj ) = @_;
    if ( $obj->properties->{audit} ) {
        my $blog;
        if ( $obj->isa('MT::Blog') ) {
            $blog = $obj;
        }
        elsif ( $obj->can('blog_id') ) {
            $blog = $obj->blog_id;
        }
        my @ts = offset_time_list( time, $blog );
        my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
            $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

        my $app = MT->instance;
        if ( $app && $app->can('user') ) {
            if ( my $user = $app->user ) {
                if ( !defined $obj->created_on ) {
                    $obj->created_by( $user->id );
                    $orig_obj->created_by( $obj->created_by );
                }
            }
        }
        unless ( $obj->created_on ) {
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
        if ( $obj->properties->{audit} ) {
            my $res = $obj->column( 'modified_by', $user_id );

            my $blog;
            if ( $obj->isa('MT::Blog') ) {
                $blog = $obj;
            }
            elsif ( $obj->can('blog_id') ) {
                $blog = $obj->blog_id;
            }
            my @ts = offset_time_list( time, $blog );
            my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
                $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
            $obj->modified_on($ts);
            return $res;
        }
    }
    return $obj->column( 'modified_by', @_ );
}

# D::OD uses Class::Trigger. Map the call_trigger calls to also invoke
# MT's callbacks (but internal Class::Trigger routines should be invoked
# first in the case of pre-triggers, and last in the case of post-triggers).

sub call_trigger {
    my $obj         = shift;
    my $name        = shift;
    my $class       = ref $obj || $obj;
    my $pre_trigger = $name =~ m/^pre_/;
    if ($pre_trigger) {
        $obj->SUPER::call_trigger( $name, @_ );
        MT->run_callbacks( $class . '::' . $name, $obj, @_ );
        $obj->SUPER::call_trigger( '__core_final_pre_save', @_ )
            if 'pre_save' eq $name;
        $obj->SUPER::call_trigger( '__core_final_pre_search', @_ )
            if 'pre_search' eq $name;
    }
    else {
        $obj->SUPER::call_trigger( '__core_final_post_load', @_ )
            if 'post_load' eq $name;
        MT->run_callbacks( $class . '::' . $name, $obj, @_ );
        $obj->SUPER::call_trigger( $name, @_ );
    }
}

# Support for MT-based callbacks.

sub add_callback {
    my $class = shift;
    my $meth  = shift;
    MT->add_callback( $class . '::' . $meth, @_ );
}

## Construction/initialization.

sub init {
    my $obj = shift;
    $obj->set_defaults();
    $obj->SUPER::init(@_);
    return $obj;
}

sub set_defaults {
    my $obj      = shift;
    my $defaults = $obj->properties->{'defaults'};
    $obj->{'column_values'} = $defaults ? {%$defaults} : {};
}

sub __properties { }

our $DRIVER;

sub driver {
    my $class = shift;
    require MT::ObjectDriverFactory;
    return $DRIVER ||= MT::ObjectDriverFactory->instance
        if UNIVERSAL::isa( $class, 'MT::Object' );
    my $driver = $class->SUPER::driver(@_);
    return $driver;
}

sub dbi_driver {
    my $class = shift;
    my $props = $class->properties || {};
    unless ( $props->{dbi_driver} ) {
        my $driver = $class->driver(@_);
        while ( $driver->can('fallback') ) {
            if ( $driver->fallback ) {
                $driver = $driver->fallback;
            }
            else {
                last;
            }
        }
        $props->{dbi_driver} = $driver;
    }
    return $props->{dbi_driver};
}

sub table_name {
    my $obj = shift;
    return $obj->driver->table_for($obj);
}

sub clone_all {
    my $obj     = shift;
    my ($param) = @_;
    my $clone   = $obj->SUPER::clone_all();
    if ( $clone->properties->{meta_installed} ) {
        $clone->init_meta();
        $clone->meta( $obj->meta );
        if (   !$param
            || !ref($param)
            || ( ref($param) ne 'HASH' )
            || !$param->{wantmeta} )
        {
            for my $meta ( keys %{ $clone->{__meta}->{__objects} } ) {
                $clone->{__meta}->{__objects}{$meta}->{changed_cols}
                    = $obj->{__meta}->{__objects}->{$meta}->{changed_cols}
                    || {};
            }
        }
    }
    return $clone;
}

sub clone {
    my $obj = shift;
    my ($param) = @_;

   # pass wantmeta to indicate that it should clone all metadata regardless of
   # changed status
    my $clone = $obj->clone_all( { wantmeta => 1 } );

    ## If the caller has listed a set of columns not to copy to the clone,
    ## delete them from the clone.
    if ( $param && ( $param->{Except} || $param->{except} ) ) {
        for my $col ( keys %{ $param->{Except} || $param->{except} } ) {
            $clone->$col(undef);
        }
    }
    return $clone;
}

sub columns_of_type {
    my $obj      = shift;
    my (@types)  = @_;
    my $props    = $obj->properties;
    my $cols     = $props->{columns};
    my $col_defs = $obj->column_defs;
    my @cols;
    my %types = map { $_ => 1 } @types;
    for my $col (@$cols) {
        push @cols, $col
            if $col_defs->{$col} && exists $types{ $col_defs->{$col}{type} };
    }
    \@cols;
}

sub created_on_obj {
    my $obj = shift;
    return $obj->column_as_datetime('created_on');
}

sub column_as_datetime {
    my $obj   = shift;
    my ($col) = @_;
    my $ts    = $obj->column($col) or return;
    my ( $y, $mo, $d, $h, $m, $s )
        = $ts
        =~ /(\d\d\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)/
        or return;

    my $blog;
    if ( $obj->isa('MT::Blog') ) {
        $blog = $obj;
    }
    else {
        if ( my $blog_id = $obj->blog_id ) {
            require MT::Blog;
            $blog = MT::Blog->lookup($blog_id);
        }
    }
    require MT::DateTime;
    my $four_digit_offset;
    if ($blog) {
        $four_digit_offset = sprintf( '%.02d%.02d',
            int( $blog->server_offset ),
            60 * abs( $blog->server_offset - int( $blog->server_offset ) ) );
    }
    return new MT::DateTime(
        year      => $y,
        month     => $mo,
        day       => $d,
        hour      => $h,
        minute    => $m,
        second    => $s,
        time_zone => $four_digit_offset
    );
}

sub join_on {
    return [@_];
}

sub remove_meta {
    my $obj = shift;
    my $which;
    if ( $_[0] && !ref( $_[0] ) && ( ( $_[0] || '' ) =~ /meta|summary/ ) ) {
        $which = shift;
    }
    $which ||= 'meta';
    my $mpkg = $obj->meta_pkg( $which || 'meta' ) or return;
    if ( ref $obj ) {
        my $id_field = $obj->datasource . '_id';
        return $mpkg->remove( { $id_field => $obj->id } );
    }
    else {

        # static invocation
        my ( $terms, $args ) = @_;
        $args = {%$args} if $args;    # copy so we can alter
        my $meta_id = $obj->datasource . '_id';
        my $offset  = 0;
        $args ||= {};
        $args->{fetchonly}   = ['id'];
        $args->{join}        = [ $mpkg, $meta_id ];
        $args->{no_triggers} = 1;
        $args->{limit}       = 50;
        while ( $offset >= 0 ) {
            $args->{offset} = $offset;
            if ( my @list = $obj->load( $terms, $args ) ) {
                my @ids = map { $_->id } @list;
                $mpkg->driver->direct_remove( $mpkg, { $meta_id => \@ids } );
                if ( scalar @list == 50 ) {
                    $offset += 50;
                }
                else {
                    $offset = -1;    # break loop
                }
            }
            else {
                $offset = -1;
            }
        }
        return 1;
    }
}

sub remove_summary {
    my $obj = shift;
    $obj->remove_meta( 'summary', @_ );
}

sub remove_scores {
    my $class = shift;
    require MT::ObjectScore;
    my ( $terms, $args ) = @_;
    $args = {%$args} if $args;    # copy so we can alter
    my $offset = 0;
    $args ||= {};
    $args->{fetchonly} = ['id'];
    $args->{join}      = [
        'MT::ObjectScore', 'object_id',
        { object_ds => $class->datasource }
    ];
    $args->{no_triggers} = 1;
    $args->{limit}       = 50;

    while ( $offset >= 0 ) {
        $args->{offset} = $offset;
        if ( my @list = $class->load( $terms, $args ) ) {
            my @ids = map { $_->id } @list;
            MT::ObjectScore->driver->direct_remove( 'MT::ObjectScore',
                { object_ds => $class->datasource, 'object_id' => \@ids } );
            if ( scalar @list == 50 ) {
                $offset += 50;
            }
            else {
                $offset = -1;    # break loop
            }
        }
        else {
            $offset = -1;
        }
    }
    return 1;
}

sub remove_children {
    my $obj = shift;
    return 1 unless ref $obj;

    my ($param) = @_;
    my $child_classes = $obj->properties->{child_classes} || {};
    my @classes = keys %$child_classes;
    return 1 unless @classes;

    $param ||= {};
    my @keys;
    if ( defined $param->{key} && $param->{key} ne '' ) {
        @keys = ( $param->{key} );
    }
    else {
        @keys = $obj->child_keys;
    }
    my $obj_id = $obj->id;
    for my $class (@classes) {
        eval "# line " . __LINE__ . " " . __FILE__
            . "\nno warnings 'all';require $class;";
        for my $key (@keys) {
            if ( $class->has_column($key) ) {
                $class->remove_children_multi( { $key => $obj_id } );
            }
        }
    }
    1;
}

sub child_keys {
    my $class = shift;
    if ( $class->long_datasource ne $class->datasource ) {
        ( $class->datasource . '_id', $class->long_datasource . '_id', );
    }
    else {
        ( $class->datasource . '_id' );
    }
}

sub remove_children_multi {
    my $class = shift;
    Carp::croak('Class method should not be called by an instance')
        if ref($class);

    my ($terms) = @_;
    my $child_classes = $class->properties->{child_classes} || {};
    my @classes = keys %$child_classes;

    my @ids = map { $_->id }
        $class->load( $terms, { fetchonly => ['id'], no_triggers => 1 } );
    if (@ids) {
        for my $child (@classes) {
            eval "# line " . __LINE__ . " " . __FILE__
                . "\nno warnings 'all';require $child;";
            for my $key ( $class->child_keys ) {
                if ( $child->has_column($key) ) {
                    $child->remove_children_multi( { $key => \@ids } );
                }
            }
        }

        return $class->remove($terms);
    }
    1;
}

sub get_by_key {
    my $class = shift;
    my ($key) = @_;
    my ($obj) = $class->search($key);
    $obj ||= new $class;
    $obj->set_values($key);
    return $obj;
}

sub set_by_key {
    my $class = shift;
    my ( $key, $value ) = @_;
    my ($obj) = $class->search($key);
    unless ($obj) {
        $obj = new $class;
        $obj->set_values($key);
    }
    $obj->set_values($value) if $value;
    $obj->save or return $class->error( $obj->errstr );
    return $obj;
}

sub set_values {
    my $obj = shift;
    my ( $values, $args ) = @_;
    $args ||= {};
    for my $col ( keys %$values ) {
        if ( $obj->has_column($col) ) {

            # there's no point in croaking here; just set the
            # values that are defined; ignore any others
            next unless defined $values->{$col};

            if (   $args
                && exists( $args->{no_changed_flag} )
                && $args->{no_changed_flag} )
            {
                $obj->column( $col, $values->{$col}, $args );
            }
            else {
                $obj->$col( $values->{$col}, $args );
            }
        }
    }
}

sub get_values {
    my $obj = shift;

    # returns a copy of column_values, as accessing column_values directly
    # can be problematic.
    return { %{ $obj->column_values } };
}

sub column_def {
    my $obj    = shift;
    my ($name) = @_;
    my $defs   = $obj->column_defs;
    my $def    = $defs->{$name};
    if ( !ref($def) ) {
        $defs->{$name} = $def = $obj->__parse_def( $name, $def );
    }
    return $def;
}

sub index_defs {
    my $obj   = shift;
    my $props = $obj->properties;
    $props->{indexes};
}

sub column_defs {
    my $obj   = shift;
    my $props = $obj->properties;
    my $defs  = $props->{column_defs};
    return undef if !$defs;
    my ($key) = keys %$defs;
    unless ( $props->{column_defs_parsed} ) {
        $obj->__parse_defs( $props->{column_defs} );
        $props->{column_defs_parsed} = 1;
    }

    return $props->{column_defs};
}

sub __parse_defs {
    my $obj = shift;
    my ($defs) = @_;
    foreach my $col ( keys %$defs ) {
        next if ref( $defs->{$col} );
        $defs->{$col} = $obj->__parse_def( $col, $defs->{$col} );
    }
}

sub __parse_def {
    my $obj = shift;
    my ( $col, $def ) = @_;
    return undef if !defined $def;
    my $props = $obj->properties;
    my %def;
    if ( $def =~ s/^([^( ]+)\s*// ) {
        $def{type} = $1;
    }
    if ( $def =~ s/^\((\d+)\)\s*// ) {
        $def{size} = $1;
    }
    $def{not_null} = 1 if $def =~ m/\bnot null\b/i;
    $def{key}      = 1 if $def =~ m/\bprimary key\b/i;
    $def{key}      = 1
        if ( $props->{primary_key} ) && ( $props->{primary_key} eq $col );
    $def{auto}       = 1 if $def =~ m/\bauto[_ ]increment\b/i;
    $def{revisioned} = 1 if $def =~ m/\brevisioned\b/i;
    $def{default} = $props->{defaults}{$col}
        if exists $props->{defaults}{$col};
    \%def;
}

sub cache_property {
    my $obj  = shift;
    my $key  = shift;
    my $code = shift;
    if ( ref $key eq 'CODE' ) {
        ( $key, $code ) = ( $code, $key );
    }
    $key ||= ( caller(1) )[3];

    my $r  = MT->request;
    my $oc = $r->cache('object_cache');
    unless ($oc) {
        $oc = {};
        $r->cache( 'object_cache', $oc );
    }

    my $pk = $obj->primary_key;
    return $code->( $obj, @_ ) unless defined $pk;
    $pk = join ":", @$pk if ref $pk;
    $oc = $oc->{ ref($obj) . ':' . $pk } ||= {};

    if (@_) {
        $oc->{$key} = $_[0];
    }
    else {
        if ( ( !exists $oc->{$key} ) && $code ) {
            $oc->{$key} = $code->( $obj, @_ );
        }
    }
    return exists $oc->{$key} ? $oc->{$key} : undef;
}

sub clear_cache {
    my $obj = shift;
    my $oc = MT->request('object_cache') or return;

    my $pk = $obj->primary_key;
    $pk = join ":", @$pk if ref $pk;
    my $key = ref($obj) . ':' . $pk;

    if (@_) {
        $oc = $oc->{$key};
        delete $oc->{ $_[0] } if $oc;
    }
    else {
        delete $oc->{$key};
    }
    1;
}

sub to_hash {
    my $obj    = shift;
    my $hash   = {};
    my $props  = $obj->properties;
    my $pfx    = $obj->long_datasource;
    my $values = $obj->get_values;
    foreach ( keys %$values ) {
        $hash->{"${pfx}.$_"} = $values->{$_};
    }
    if ( my $meta = $props->{meta_columns} ) {
        foreach ( keys %$meta ) {
            $hash->{"${pfx}.$_"} = $obj->meta($_);
        }
    }
    if ( $obj->has_column('blog_id') ) {
        my $blog_id = $obj->blog_id;
        require MT::Blog;
        if ( my $blog = MT::Blog->lookup($blog_id) ) {
            my $blog_hash = $blog->to_hash;
            $hash->{"${pfx}.$_"} = $blog_hash->{$_} foreach keys %$blog_hash;
        }
    }
    $hash;
}

sub search_by_meta {
    my $class = shift;
    my ( $key, $value, $terms, $args ) = @_;
    $terms ||= {};
    $args  ||= {};
    return unless $class->properties->{meta_installed};
    return $class->error("Unknown meta '$key' on $class")
        unless $class->is_meta_column($key);

    my $meta_rec   = MT::Meta->metadata_by_name( $class, $key );
    my $type_col   = $meta_rec->{type};
    my $type_id    = $meta_rec->{name};
    my $meta_terms = {
        $type_col => $value,
        type      => $type_id,
        %$terms,
    };
    my $meta_class = $class->meta_pkg;
    my $meta_pk    = $meta_class->primary_key_tuple;
    $meta_pk
        = [ $meta_pk->[0] ];    # we only need the first column, that's the id
    my @metaobjs = $meta_class->search( $meta_terms,
        { %$args, fetchonly => $meta_pk } );

    my $pk     = $class->primary_key_tuple;
    my $get_pk = sub {
        my $meta = shift;
        [ map { $meta->$_ } @$meta_pk ];
    };

    return unless @metaobjs;
    return grep defined,
        @{ $class->lookup_multi( [ map { $get_pk->($_) } @metaobjs ] ) };
}

sub lookup_multi {
    my $class = shift;
    my $objs  = $class->SUPER::lookup_multi(@_);
    my @objs  = $objs ? grep { defined $_ } @$objs : undef;
    return \@objs;
}

sub cache_class {
    my $class = shift;
    my $ds    = $class->datasource;
    my $model = MT->model($ds);
    return $model ? $model : $class;
}

sub deflate {
    my $self = shift;
    my $data = $self->SUPER::deflate(@_);

    if ( $self->has_meta ) {
        $data->{meta} = $self->{__meta}->deflate_meta;
    }

    $data;
}

sub inflate {
    my $class      = shift;
    my ($deflated) = @_;
    my $obj        = $class->SUPER::inflate(@_);

    if ( $class->has_meta && $deflated->{meta} ) {
        $obj->{__meta}->inflate_meta( $deflated->{meta} );
    }

    $obj;
}

sub assets {
    my ($self) = @_;

    if ( $self->has_summary('all_assets') ) {
        my @assets = $self->get_summary_objs( 'all_assets' => 'MT::Asset' );
        @assets && $assets[0] ? [@assets] : [];
    }
    else {
        [   MT->model('asset')->load(
                { class => '*' },
                {   join => MT->model('objectasset')->join_on(
                        undef,
                        {   asset_id  => \'= asset_id',
                            object_ds => $self->datasource,
                            object_id => $self->id
                        }
                    )
                }
            )
        ];
    }
}

sub long_datasource {
    my $class = shift;
    $class->properties->{long_datasource} || $class->datasource;
}

package MT::Object::Meta;

use base qw( Data::ObjectDriver::BaseObject );

sub install_properties {
    my $class = shift;
    my ($props) = @_;
    $props->{column_defs}->{$_} ||= 'string' for @{ $props->{columns} };

    $props->{get_driver} ||= sub {
        require MT::ObjectDriverFactory;
        my $coderef = MT::ObjectDriverFactory->driver_for_class($class);
        $class->get_driver($coderef);
        return $coderef->(@_);
    };

    $class->SUPER::install_properties(@_);
}

sub __properties { }
sub meta_pkg     {undef}

*table_name      = \&MT::Object::table_name;
*column_defs     = \&MT::Object::column_defs;
*column_def      = \&MT::Object::column_def;
*index_defs      = \&MT::Object::index_defs;
*__parse_defs    = \&MT::Object::__parse_defs;
*__parse_def     = \&MT::Object::__parse_def;
*count           = \&MT::Object::count;
*columns_of_type = \&MT::Object::columns_of_type;
*join_on         = \&MT::Object::join_on;

# TODO: copy this too
sub blob_requires_zip { }

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
serialized/stored to some location for later retrieval.

Movable Type objects know nothing about how they are stored--they know only
of what types of data they consist, the names of those types of data (their
columns), etc. The actual storage mechanism is in the L<Data::ObjectDriver>
class and its driver subclasses; I<MT::Object> subclasses, on the other hand,
are essentially just standard in-memory Perl objects, but with a little extra
self-knowledge.

This distinction between storage and in-memory representation allows objects
to be serialized to disk in many different ways. Adding a new storage method
is as simple as writing an object driver--a non-trivial task, to be sure, but
one that will not require touching any other Movable Type code.

=head1 SUBCLASSING

Creating a subclass of I<MT::Object> is very simple; you simply need to
define the properties and metadata about the object you are creating. Start
by declaring your class, and inheriting from I<MT::Object>:

    package MT::Foo;
    use strict;

    use base 'MT::Object';

=over 4

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

For storing single-precision floating point values (Some ObjectDriver
can save double-precision floating point value to float type).

=item * double

For storing double-precision floating point values.

=back

Note: The physical data storage capacity of these types will vary depending on
the driver's implementation.

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

=item * indexed

Identifies that this column should also be individually indexed.

=item * meta

Declares the column as a meta column, which means it is stored in a separate
table that is used for storing metadata. See L<Metadata> for more information.

=back

=item * indexes

Specifies the column indexes on your objects.

The value for the I<indexes> key should be a reference to a hash containing
column names as keys, and the value C<1> for each key--each key represents
a column that should be indexed:

    indexes => {
        'column_1' => 1,
        'column_2' => 1,
    },

For multi-column indexes, you must declare the individual columns as the
value for the index key:

    indexes => {
        'column_catkey' => {
            columns => [ 'column_1', 'column_2' ],
        },
    },

For declaring a unique constraint, add a 'unique' element to this hash:

    indexes => {
        'column_catkey' => {
            columns => [ 'column_1', 'column_2' ],
            unique => 1,
        },
    },

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

Please note: the length of the datasource name should be conservative; some
drivers place limits on the length of table and column names.

=item * meta

Specify this property if you wish to support the storage of additional
metadata for this class. By doing so, a second table will be declared to
MT's registry, one that is designed to hold any metadata associated
with your class.

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

    my $object = MT::Foo->load( $id );

    my @objects = MT::Foo->load(\%terms, \%arguments);

    my @objects = MT::Foo->load(\@terms, \%arguments);

I<load_iter> has the following general form:

    my $iter = MT::Foo->load_iter(\%terms, \%arguments);

    my $iter = MT::Foo->load_iter(\@terms, \%arguments);

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

=item * A reference to an array.

In this form, the arrayref contains a list of selection terms for more
complex selections.

    my @foo = MT::Foo->load( [ { foo => 'bar' }
        => -or => { foo => 'baz' } ] );

The separating operator keywords inbetween terms can be any of C<-or>,
C<-and>, C<-or_not>, C<-and_not> (the leading '-' is not required, and the
operator itself is case-insensitive).

=back

Values assigned to terms for selecting data can be either simple or complex
in nature. Simple scalar values require an exact match. For instance:

    my @foo = MT::Foo->load( { foo => 'bar' });

This selects all I<MT::Foo> objects where foo == 'bar'. But you can provide
a hashref value to provide more options:

    my @foo = MT::Foo->load( { foo => { like => 'bar%' } });

This selects all I<MT::Foo> objects where foo starts with 'bar'. Other
possibilities include 'not_like', 'not_null', 'not', 'between', '>',
'>=', '<', '<=', '!='. Note that 'not' and 'between' both accept an
arrayref for their value; 'between' expects a two element array, and
'not' will accept an array of 1 or more values which translates to
a 'NOT IN (...)' SQL clause.

I<\%arguments> should be a reference to a hash containing parameters for the
search. The following parameters are allowed:

=over 4

=item * sort => "column"

Sort the resulting objects by the column C<column>; C<column> must be an
indexed column (see L</"indexes">, above).

Sort may also be specified as an arrayref of multiple columns to sort on.
For example:

    sort => [
        { column => "column_1", desc => "DESC" },
        { column => "column_2", }   # default direction is 'ascend'
    ]

=item * direction => "ascend|descend"

To be used together with a scalar I<sort> value; specifies the sort
order (ascending or descending). The default is C<ascend>.

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

Boolean flag that ensures that the objects being returned are unique.

This is really only useful when used within a I<join>, because when loading
data out of a single object datastore, the objects are always going to be
unique.

=item * window_size => "N"

An optional attribute used only with the load_iter method. This attribute
is used when requesting a result set of large or unknown size. If the
load_iter method is called without any I<limit> attribute, this is set to
a default value of 100 (meaning, load 100 objects per SELECT). The iterator
will yield the specified number of objects and then issue an additional
select operation, using the same terms and attributes, adjusting for
a new offset for the next set of objects.

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

=over 4

=item * $obj->remove_scores( \%terms, \%args );

=back

For object classes that also have the L<MT::Scorable> class in their
C<@ISA> list, this method will remove any related score objects they
are associated with. This method is invoked automatically when
C<Class-E<gt>remove> or C<$obj-E<gt>remove> is invoked.

=head2 Getting the count of a number of objects

To determine how many objects meeting a particular set of conditions exist,
use the I<count> method:

    my $count = MT::Foo->count({ foo => 'bar' });

I<count> takes the same arguments as I<load> and I<load_iter>.

=head2 Determining if an object exists in the datastore

To check an object for existence in the datastore, use the I<exists> method:

=over 4

=item * $obj->exists()

=back

    if ($foo->exists) {
        print "Foo $foo already exists!";
    }

To test for the existence of an unloaded object, use the 'exist' method:

=over 4

=item * Class->exist( \%terms )

=back

    if (MT::Foo->exist( { foo => 'bar' })) {
        print "Already exists!";
    }

This is typically faster than issuing a L<count> call.

=head2 Counting groups of objects

=over 4

=item * Class->count_group_by()

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

=head2 Averaging by Group

=over 4

=item * Class->avg_group_by()

=back

Like the count_group_by method, you can select groups of averages from
a MT::Object store.

    my $iter = MT::Foo->avg_group_by($terms, {%args, group => $group_exprs,
        avg => 'property_to_average' })

=head2 Max by Group

=over 4

=item * Class->max_group_by()

=back

Like the count_group_by method, you can select objects from a MT::Object
store using a SQL 'MAX' operator.

    my $iter = MT::Foo->max_group_by($terms, {%args, group => $group_exprs,
        max => 'column_name' })

=head2 Sum by Group

=over 4

=item * Class->sum_group_by()

=back

Like the count_group_by method, you can select groups of sums from
a MT::Object store.

    my $iter = MT::Foo->sum_group_by($terms, {%args, group => $group_exprs,
        avg => 'property_to_sum' })

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

C<get_values> is similar to C<column_values>, in that it returns a hash
reference of column names and values, but it returns a new hash reference,
and a copy of the data rather that the hash reference that MT::Object uses
internally. This is a safer way to access this data, if you intend to also
modify the values.

    my $data = $obj->get_values;
    $data->{$_} = lc $data->{$_} for keys %$data;

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

=item * $obj->clone_all()

Similar to the C<clone> method, but also makes a clones the metadata
information.

=item * $obj->column_names()

Returns a list of the names of columns in C<$obj>; includes all those
specified to the install_properties method as well as the audit
properties (C<created_on>, C<modified_on>, C<created_by>,
C<modified_by>), if those were enabled in install_properties.

=item * MT::Foo->driver()

=item * $obj->driver()

Returns the ObjectDriver object that links this object with a database.
This is a subclass of L<Data::ObjectDriver>.

=item * $obj->dbi_driver()

This method is similar to the 'driver' method, but will always return
a DBI driver (a subclass of the L<Data::ObjectDriver::Driver::DBI>
class) and not a caching driver.

=item * $obj->created_on_obj()

Returns a MT::DateTime object representing the moment when the
object was first saved to the database.

=item * $obj->column_as_datetime( $column )

Returns a MT::DateTime object for the specified datetime/timestamp
column specified.

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

=item * $obj->clear_cache()

Clears any object-level cache data (from the C<cache_property> method)
that may existing.

=item * $obj->column_def($name)

This method returns the value of the given I<$name> C<column_defs>
propery.

=item * $obj->column_defs()

This method returns all the C<column_defs> of the property of the
object.

=item * Class->index_defs()

This method returns all the index definitions assigned to this class.
This is the 'indexes' member of the properties installed for the class.

=item * $obj->to_hash()

Returns a hashref containing column and metadata key/value pairs for
the object. If the object has a blog relationship, it also populates
data from that blog. For example:

    my $entry_hash = $entry->to_hash();
    # returns: { entry.title => "Title", entry.blog.name => "Foo", ... }

=item * Class->join_on( $join_column, \%join_terms, \%join_args )

A simple helper method that returns an arrayref of join terms suitable
for the C<load> and C<load_iter> methods.

=item * $obj->properties()

Returns a hashref of the object properties that were declared with the
I<install_properties> method.

=item * $obj->to_xml()

Returns an XML representation of the object.
This method is defined in MT/BackupRestore.pm - you must first 
use MT::BackupRestore to use this method.

=item * $obj->restore_parent_ids()

TODO - Backup file contains parent objects' ids (foreign keys).  However,
when parent objcects are restored, their ids will be changed.  This method
is to match the old and new ids of parent objects for children objects to be
correctly associated.
This method is defined in MT/BackupRestore.pm - you must first 
use MT::BackupRestore to use this method.

=item * $obj->parents()

If the relationship of the class and its parent is as simple as the class
has 'parent_id' column, the class does not have to implment its own
restore_parent_ids, but instead implement I<parents> method to indicate
what column refers to which parent class.

    { name_of_the_column => class reference }

For example, if a class is a child of MT::Blog and the class has blog_id 
column as the foreign key, the I<parents> method should return the following
hashref:

    { blog_id => MT->model('blog') }

If the class's foreign key is used for more than a parent class (e.g.
MT::Category::parent), I<parents> method can return the following hashref:

    { parent => [ MT->model('category'), MT->model('folder') ] }

If the class's parent (foreign key) is optional (e.g. MT::Comment::commenter_id),
the class's I<parents> method can return the following hashref:

    { commenter_id => { class => MT->model('author'), optional => 1 } }

If the class uses multiple columns to identify the parent object (e.g. ObjectTag)
the class's I<parents> method can return the following hashref:

    { object_id => { relations => {
            key => 'object_datasource',
            entry_id => [ MT->model('entry'), MT->model('page') ],
    }}

=cut

=item * $obj->parent_names()

TODO - Should be overridden by subclasses to return correct hash
whose keys are xml element names of the object's parent objects
and values are class names of them.
This method is defined in MT/BackupRestore.pm - you must first 
use MT::BackupRestore to use this method.

=item * Class->class_handler($type)

Returns the appropriate Perl package name for the given type identifier.
For example,

    # Yields MT::Asset::Image
    MT::Asset->class_handler('asset.image');

=item * Class->class_label

Provides a descriptive name for the requested class package.
This is a localized name, using the currently assigned language.

=item * Class->class_label_plural

Returns a descriptive pluralized name for the requested class package.
This is a localized name, using the currently assigned language.

=item * Class->class_labels

Returns a hashref of type identifiers to class labels for all subclasses
associated with a multiclassed object type. For instance:

    # returns { 'asset' => 'Asset', 'asset.video' => 'Video', ... }
    my $labels = MT::Asset->class_labels;

=item * Class->columns_of_type(@types)

Returns an arrayref of column names that are of the requested type.

    my @dates = MT::Foo->columns_of_type('datetime', 'timestamp')

=item * Class->has_column( $name )

Returns a boolean as to whether the column C<$name> is defined for
this class.

=item * Class->table_name()

Returns the database table name (including any prefix) for the class.

=item * $obj->column_func( $column )

Creates an accessor/mutator method for column C<$column>, returning it as a
coderef. This method overrides the one in L<Data::ObjectDriver::BaseObject>,
by supporting metadata column as well.

=item * $obj->call_trigger( 'trigger_name', @params )

Issues a call to any Class::Trigger triggers installed for the given object.
Also invokes any MT callbacks that are registered using MT's callback
system. "pre" callbacks are invoked after triggers are called; "post"
callbacks are invoked prior to triggers.

=item * $obj->deflate

Returns a minimal representation of the object, including any metadata.
See also L<Data::ObjectDriver::BaseObject>.

=item * Class->inflate( $deflated )

Inflates the deflated representation of the object I<$deflated> into a proper
object in the class I<Class>. That is, undoes the operation C<$deflated =
$obj-E<gt>deflate()> by returning a new object equivalent to C<$obj>.

=item * Class->install_pre_init_properties

This static method is used to install any class properties that were
registered prior to the bootstrapping of MT plugins.

=item * $obj->modified_by

A modified getter/setter accessor method for audited classes with a
'modified_by', 'modified_on' columns. In the event this method is called
to assign a 'modified_by' value, it automatically updates the 'modified_on'
column as well.

=item * $obj->nextprev( %params )

Method to determine adjancent objects, based on a date column and/or id.
The C<%params> hash provides the following elements:

=over 4

=item * direction

Either "next" or "previous".

=item * terms

Any additional terms to supply to the C<load> method.

=item * args

Any additional arguments to supply to the C<load> method (such as a join).

=item * by

The column to use to determine the next/previous object. By default for
audited classes, this is 'created_on'.

=back

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

=head1 SUBCLASSING

It is possible to declare a subclass of an existing MT::Object class,
one that shares the same table storage as the parent class. Examples of
this include L<MT::Log>, L<MT::Entry>, L<MT::Category>. In these cases,
the subclass identifies a 'class_type' property. The parent class must also
have a column where this identifier is stored. Upon loading records from the
table, the object is reblessed into the appropriate package.

=over 4

=item Class->add_class( $type_id, $class )

This method can be called directly to register a new subclass type
and package for the base class.

    MT::Foo->add_class( 'foochild' => 'MT::Foo::Subclass' );

=back

=head1 METADATA

The following methods facilitate the storage and management of metadata;
available when the 'meta' key is included in the installed properties for
the class.

=over 4

=item * $obj->init_meta()

For object classes that have metadata storage, this method will initialize
the metadata member.

=item * Class->install_meta( \%meta_properties, [ $which ] )

Called to register metadata or summary properties on a particular class. If 'summary' is passed in the optional C<$which> parameter, summary properties will be installed, and metadata properties otherwise.

Called to register metadata properties on a particular class. The
C<%meta_properties> may contain an arrayref of 'columns', or a hashref
of 'column_defs' (similar to the C<install_properties> method):

    MT::Foo->install_meta( { column_defs => {
        'metadata1' => 'integer indexed',
        'metadata2' => 'string indexed',
    } });

In this form, the storage type is explicitly declared, so the metadata
is stored into the appropriate column (vinteger_idx and vchar_idx
respectively).

    MT::Foo->install_meta( { columns => [ 'metadata1', 'metadata2' ] } )

In this form, the metadata properties store their data into a 'blob'
column in the meta table. This type of metadata cannot be used to sort
or filter on. This form is supported for backward compatibility and is
considered deprecated.

=item * $obj->remove_meta()

Deletes all related metadata for the given object.

=item * Class->search_by_meta( $key, $value, [ \%terms [, \%args ] ] )

Returns objects that have a C<$key> metadata value of C<$value>. Further
restrictions on the class may be applied through the optional C<%terms>
and C<%args> parameters.

=item * $obj->meta_obj()

Returns the L<MT::Object> class

=item * Class->meta_pkg( [ $which ] )

Returns the Perl package name for storing the class's metadata objects,
or the class's summary objects if 'summary' is passed in C<$which>.

=item * Class->meta_args

Returns the source of a Perl package declaration that is loaded to
declare and process metadata objects for the C<Class>.

=item * Class->summary_args

Returns the source of a Perl package declaration that is loaded to 
declare and process summary data objects for the C<Class>.

=item * Class->has_meta( [ $name ] )

Returns a boolean as to whether the class has metadata when called
without a parameter, or whether there exists a metadata column
of the given C<$name>.

=item * Class->has_summary( [ $name ] )

Returns a boolean as to whether the class supports summaries when 
called without a parameter, or whether a summary type of the given 
C<$name> is defined for the class.

=item * Class->is_meta_column( $name, [ $which ] )

Returns a boolean as to whether the class has a meta column named
C<$name>, or a summary of type C<$name> if 'summary' is passed
in C<$which>.

=item * Class->is_summary( $name )

Returns a boolean as to whether a summary type of the given C<$name> 
is defined for the class.

=back

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
    update (issued for save on existing objects)
    insert (issued for save on new objects)
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

=head2 Caveat

Be careful how you handle errors. If you transform data as it goes
into and out of the database, and it is possible for one of your
callbacks to fail, the data may get saved in an undefined state. It
may then be difficult or impossible for the user to recover that data.

=head1 I<Final> triggers

Those three "final" triggers installed in the install_properties method
is strictly for internal use only.

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
