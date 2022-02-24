# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ListProperty;
use strict;
use warnings;
use MT;
use base qw( MT::ErrorHandler );

our %CachedListProperties;

sub instance {
    my $pkg = shift;
    my ( $cls, $id ) = @_;
    if ( !defined $id && $cls =~ m/\./ ) {
        ( $cls, $id ) = split /\./, $cls, 2;
    }
    my $prop = $pkg->new( $cls, $id );
    $prop->_get('init') if $prop->has('init');
    $prop;
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
        die MT->translate( q{Cannot initialize list property [_1].[_2].},
            $cls, $id )
            if !$prop;
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
        elsif ( defined($attr_val) && ($attr_val =~ m/^sub \{/ || $attr_val =~ m/^\$/) ) {
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
        $self->{_base} = __PACKAGE__->new( $self->{base} );
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
        double    => 'float',
        ## TBD
        # blob      => '',

        ## Meta
        vchar         => 'string',
        vchar_idx     => 'string',
        vinteger      => 'integer',
        vinteger_idx  => 'integer',
        vdatetime     => 'date',
        vdatetime_idx => 'date',
        vfloat        => 'float',
        vfloat_idx    => 'float',
        vclob         => 'string',
        ## TBD
        # vblob         => '',
    );

    sub _auto_base {
        my $self       = shift;
        my $orig_obj   = shift || $self;
        my $id         = $orig_obj->id;
        my $class      = $orig_obj->datasource;
        my $prop_class = $self->class;
        require MT::Meta;
        if ( !$class->has_column($id) ) {
            die MT->translate(
                'Failed to initialize auto list property [_1].[_2]: Cannot find definition of column [_3].',
                $prop_class, $id, $id, );
        }
        my $def;
        if ( $class->has_meta && $class->is_meta_column($id) ) {
            $def = MT::Meta->metadata_by_name( $class, $id );
            $orig_obj->{is_meta}  = 1;
            $orig_obj->{meta_col} = $def->{type};
        }
        else {
            $def = $class->column_def($id);
        }
        my $column_type = $def->{type};
        my $auto_type   = $AUTO{$column_type}
            or die MT->translate(
            'Failed to initialize auto list property [_1].[_2]: unsupported column type.',
            $prop_class, $id
            );
        $orig_obj->{col} = $id;
        my $prop = __PACKAGE__->instance( '__virtual', $auto_type );
        return $prop;
    }
}

sub join_meta {
    my $prop = shift;
    my ( $to_args, $cond, $opts ) = @_;
    my $class      = $prop->datasource;
    my $meta_class = $class->meta_pkg;
    my $meta_pk    = $meta_class->primary_key_tuple;
    $meta_pk = $meta_pk->[0];   # we only need the first column, that's the id
    my $meta_id_cond = '= ' . $meta_pk;

    my ( %j_terms, %j_args );
    $j_terms{type}  = $prop->col;
    $j_args{unique} = 1;
    if ( $opts->{sort} ) {
        $j_args{sort}      = $prop->meta_col;
        $j_args{direction} = $opts->{direction};
        delete $to_args->{sort};
        delete $to_args->{direction};
    }
    if ( $opts->{sort} && !defined $cond ) {
        $j_args{type}      = 'left';
        $j_args{jalias}    = 'left_' . $prop->col;
        $j_args{condition} = $meta_pk;
    }
    else {
        $j_terms{ $prop->meta_col } = $cond if defined $cond;
        $j_terms{$meta_pk}          = \$meta_id_cond;
        $j_args{alias}              = $prop->col;
    }

    $to_args->{joins} ||= [];
    push @{ $to_args->{joins} },
        $prop->datasource->meta_pkg->join_on( undef, [ \%j_terms ], \%j_args,
        );
    return;
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

    return $CachedListProperties{$cls} if exists $CachedListProperties{$cls};

    my $cacheable = 1;
    my $local_props = MT->registry( 'list_properties', $cls );
    if ($local_props) {
        for my $key ( keys %$local_props ) {
            my $prop = MT::ListProperty->instance( $cls, $key );
            if ( $prop->has('condition') ) {
                $cacheable = 0;
                next unless $prop->condition;
            }
            $props{$key} = $prop;
        }
    }

    my $common_props = MT->registry( 'list_properties', '__common' );
    if ($common_props) {
        for my $key ( keys %$common_props ) {
            next if $props{$key};
            my $prop = MT::ListProperty->instance( $cls, $key );
            if ( $prop->has('condition') ) {
                $cacheable = 0;
                next unless $prop->condition;
            }
            $props{$key} = $prop if $prop;
        }
    }
    if ($cacheable) {
        $CachedListProperties{$cls} = \%props;
    }

    return \%props;
}

sub can_display {
    my $prop = shift;
    return (   $prop->has('bulk_html')
            || $prop->has('html')
            || $prop->has('raw') )
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

sub common_label_html {
    my $prop = shift;
    my ( $obj, $app ) = @_;
    return make_common_label_html( $obj, $app, $prop->col,
        $prop->alternative_label );
}

sub make_common_label_html {
    my ( $obj, $app, $col, $alt_label, $no_link ) = @_;
    my $id    = $obj->id;
    my $label = $obj->$col;
    $label = '' if !defined $label;
    $label =~ s/^\s+|\s+$//g;
    my $blog_id
        = $obj->has_column('blog_id') ? $obj->blog_id
        : $app->blog                  ? $app->blog->id
        :                               0;
    my $type
        = $obj->isa('MT::ContentData') ? 'content_data' : $obj->class_type;
    my $edit_link = $app->uri(
        mode => 'view',
        args => {
            _type   => $type,
            id      => $id,
            blog_id => $blog_id,
            $obj->isa('MT::ContentData')
            ? ( content_type_id => $obj->content_type_id )
            : (),
        },
    );

    if ( defined $label && $label ne '' ) {
        my $can_double_encode = 1;
        $label = MT::Util::encode_html( $label, $can_double_encode );
        return $no_link ? $label : qq{<a href="$edit_link">$label</a>};
    }
    elsif ($no_link) {
        return MT->translate( '[_1] (id:[_2])',
            $alt_label ? $alt_label : 'No ' . $label, $id, );
    }
    else {
        return MT->translate(
            qq{[_1] (<a href="[_2]">id:[_3]</a>)},
            $alt_label ? $alt_label : 'No ' . $label,
            $edit_link, $id,
        );
    }
}

1;
