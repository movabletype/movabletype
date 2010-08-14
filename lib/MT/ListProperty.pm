# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ListProperty;
use strict;
use warnings;
use MT;

{
    our %properties;

    sub instance {
        my $pkg = shift;
        my ( $cls, $id ) = @_;
        if ( !defined $id && $cls =~ m/\./ ) {
            ( $cls, $id ) = split /\./, $cls, 2;
        }
        return $properties{$cls}{$id} ||= $pkg->new( $cls, $id );
    }
}

sub new {
    my $obj = bless {}, shift;
    return $obj->init(@_);
}

sub init {
    my $self = shift;
    my ( $cls, $id ) = @_;
    if ( !defined $id && $cls =~ m/\./ ) {
        ( $cls, $id ) = split /\./, $cls, 2;
    }
    die 'Object type and Property ID are required' if ( !$cls || !$id );

    my $setting = MT->registry( listing_screens => $cls ) || {};
    my $object_type = $setting->{object_type} || $cls;
    $self->{type} = $self->{id} = $id;
    $self->{class}       = $cls;
    $self->{object_type} = $object_type;
    $self->{datasource}  = MT->model($object_type);
    $self->_init_core;
    $self;
}

sub _init_core {
    my $self = shift;
    my ( $cls, $id ) = ( $self->{class}, $self->{type} );

    # If datasource don't have own property, load property from
    # "__common" namespace.
    my $prop;
    my $local_props = MT->registry( list_properties => $cls ) || {};
    $prop = $local_props->{$id};
    if ( defined $prop && !ref $prop ) {
        $prop = { auto => 1, label => $prop };
    }
    if ( !defined $prop && $cls ne '__common' ) {
        my $common_props = MT->registry( list_properties => '__common' );
        $prop = $common_props->{$id};

        # Property is undefined
        die "Can't initialize list property $cls $id" if !$prop;
        if ( my $condition = $prop->{condition} ) {
            $condition = MT->handler_to_coderef($condition)
                if !ref $condition;
            $condition->($self)
                or return;
        }
    }

    delete $prop->{plugin};
    for my $key ( keys %$prop ) {
        $self->{$key} = $prop->{$key};
    }
    $self;
}

sub AUTOLOAD {
    my $obj = $_[0];
    ( my $attr = our $AUTOLOAD ) =~ s!.+::!!;
    return if $attr eq 'DESTROY';
    Carp::croak("Cannot find method '$attr' for __PACKAGE__") unless ref $obj;
    {
        no strict 'refs';    ## no critic
        *$AUTOLOAD = sub { shift->_get( $attr, undef, @_ ) };
    }
    goto &$AUTOLOAD;
}

{
    our $ATTR_OWNER;
    our $ATTR_NAME;

    sub _get {
        my $obj      = shift;
        my $attr     = shift;
        my $orig_obj = shift || $obj;
        my ( $attr_val, $attr_owner ) = _get_attr( $obj, $attr, $orig_obj )
            or return undef;
        my $code;
        if ( 'CODE' eq ref $attr_val ) {
            $code = $attr_val;
        }
        elsif ( $attr_val =~ m/^sub \{/ || $attr_val =~ m/^\$/ ) {
            $code = MT->handler_to_coderef($attr_val);
        }

        if ($code) {
            local $ATTR_OWNER = $attr_owner;
            local $ATTR_NAME  = $attr;
            return $code->( $orig_obj, @_ );
        }
        $attr_val;
    }

    sub super {
        my $obj = shift;
        return if !$ATTR_OWNER;
        return if !$ATTR_NAME;
        my $super = $ATTR_OWNER->base
            or return;
        $super->_get( $ATTR_NAME, $obj, @_ );
    }
}

sub _get_attr {
    my $obj      = shift;
    my $attr     = shift;
    my $orig_obj = shift || $obj;
    if ( !exists $obj->{$attr} ) {
        my $base = $obj->base($orig_obj) or return;
        return $base->_get_attr( $attr, $orig_obj, @_ );
    }
    return ( $obj->{$attr}, $obj );
}

sub has {
    my $obj  = shift;
    my $attr = shift;
    return $obj->_get_attr( $attr, $obj, @_ ) ? 1 : 0;
}

sub base {
    my $self     = shift;
    my $orig_obj = shift;
    return $self->{_base} if exists $self->{_base};
    if ( $self->{base} ) {
        $self->{_base} = __PACKAGE__->instance( $self->{base} );
    }
    elsif ( $self->{auto} ) {
        $self->{_base} = $self->_auto_base($orig_obj);
    }
    else {
        $self->{_base} = undef;
    }
    $self->{_base};
}

{
    # Mapping from column def keywords to basic property types.
    my %AUTO = (
        string    => 'string',
        smallint  => 'integer',
        bigint    => 'integer',
        boolean   => 'single_select',
        datetime  => 'date',
        timestamp => 'date',
        integer   => 'integer',
        text      => 'string',
        float     => 'float',
        ## TBD
        # blob      => '',
    );

    sub _auto_base {
        my $self     = shift;
        my $orig_obj = shift || $self;
        my $id       = $orig_obj->id;
        my $class    = $orig_obj->datasource;
        my $def      = $class->column_def($id)
            or die "Failed to load auto prop for $class $id";
        my $column_type = $def->{type};
        my $auto_type   = $AUTO{$column_type}
            or die "Failed to load auto prop for $class $id";
        my $prop = __PACKAGE__->instance( '__common', $auto_type )
            or die "Failed to load auto prop for $class $id";
        $orig_obj->{col} = $id;
        $prop;
    }
}

sub _scope_filter {
    my $prop = shift;
    my ( $area, $scope ) = @_;
    my $area_view = "view_$area";
    my $view = $prop->$area_view || $prop->view
        or return 1;
    my %hash;
    $view = [$view] if !ref $view;
    if ( 'ARRAY' eq ref $view ) {
        %hash = map { $_ => 1 } @$view;
    }
    return $hash{$scope};
}

sub list_properties {
    my $pkg = shift;
    my $cls = shift;
    my %props;

    my $local_props = MT->registry( 'list_properties', $cls );
    if ($local_props) {
        for my $key ( keys %$local_props ) {
            $props{$key} = MT::ListProperty->instance( $cls, $key );
        }
    }
    my $common_props = MT->registry( 'list_properties', '__common' );
    if ($common_props) {
        for my $key ( keys %$common_props ) {
            next if $props{$key};
            my $prop = MT::ListProperty->instance( $cls, $key );
            $props{$key} = $prop if $prop;
        }
    }
    return \%props;
}

sub can_display {
    my $prop = shift;
    return
           ( $prop->has('html') || $prop->has('raw') )
        && ( 'none' ne ( $prop->display || 'optional' ) )
        && $prop->_scope_filter( 'column', @_ );
}

sub can_sort {
    my $prop = shift;
    return (   $prop->has('sort')
            || $prop->has('sort_method')
            || $prop->has('bulk_sort') )
        && $prop->_scope_filter( 'sort', @_ );
}

sub can_filter {
    my $prop = shift;
    return ( $prop->has('terms') || $prop->has('grep') )
        && $prop->_scope_filter( 'filter', @_ );
}

1;
