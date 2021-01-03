# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Summary::Proxy;
use strict;
use warnings;
use base qw( MT::Meta::Proxy );

sub META_CLASS {'MT::Summary'}

sub META_WHICH {'summary'}

sub set {
    my $proxy = shift;
    my ( $terms, $value ) = @_;

    # xxx When you update the metadata, you have to preserve the
    # original data as well. This should be eliminated by adding the
    # update optimization for metadata columns
    $proxy->lazier_load_objects;

    $proxy->{__objects}->{ $terms->{type} }
        = $proxy->create_meta_object( $terms, $value );

    $proxy->{__loaded}->{ $terms->{type} } = 1;
    if ( %{ $proxy->{__loaded} } ) {
        $proxy->{__pkeys}->{type}
            = { not => [ keys %{ $proxy->{__loaded} } ] };
    }
    else {
        delete $proxy->{__pkeys}->{type};
    }
    $proxy->{__objects}->{ $terms->{type} }->expired(0);
    $proxy->save_one($terms);
    $proxy->get($terms);
}

sub get {
    my $proxy = shift;
    my ($terms) = @_;

    require MT::Summary;
    $terms = MT::Summarizable::_set_terms($terms);

    my ( $col, $class ) = ( $terms->{type}, $terms->{class} );
    $proxy->lazier_load_objects;
    my $pkg = $proxy->{pkg};
    if ( my $field = $proxy->META_CLASS()->metadata_by_name( $pkg, $class ) )
    {
        if ( !exists $proxy->{__objects}->{$col} ) {
            $proxy->{__objects}->{$col} = $proxy->meta_pkg->new;
        }
        if ( !$proxy->{__loaded}->{$col} ) {
            $proxy->load_objects($col);
        }
        my $meta = $proxy->{__objects}->{$col};

        my $type = $field->{type}
            or Carp::croak("$col not found on $pkg summaries");

        unless ( $meta->has_column($type) ) {
            Carp::croak(
                "something is wrong: $type not in column_values of summary");
        }
        return $meta->$type;
    }
    else {
        Carp::croak("Summary $class on $pkg not found.");
    }
}

sub create_meta_object {
    my $proxy = shift;
    my ( $terms, $value ) = @_;

    require MT::Summary;
    $terms = MT::Summarizable::_set_terms($terms);

    my $pkg  = $proxy->{pkg};
    my $meta = $proxy->meta_pkg->new;

    my $field
        = $proxy->META_CLASS()->metadata_by_name( $pkg, $terms->{class} )
        or Carp::croak("there's no field $terms->{class} on $pkg");

    my $type_id = $field->{type_id}
        or Carp::croak("no type_id for $terms->{class}");
    my $id   = $field->{id};
    my $type = $MT::Meta::Types{$type_id};
    $meta->type( $terms->{type} );
    $meta->class( $terms->{class} );
    $meta->$type($value);

    $meta;
}

sub save_one {
    my $proxy = shift;
    my ($terms) = @_;

    my $field = $terms->{type};

    my $meta_obj = $proxy->{__objects}->{$field};
    ## primary key from core object
    foreach my $pkey ( keys %{ $proxy->{__pkeys} } ) {
        next if ( $pkey eq 'type' );
        my $pval = $proxy->{__pkeys}->{$pkey};
        $meta_obj->$pkey($pval);
    }

    my $pkg = $proxy->{pkg};

    my $meta = $proxy->META_CLASS()->metadata_by_name( $pkg, $terms->{class} )
        or Carp::croak("Metadata $terms->{class} on $pkg not found.");
    my $type = $meta->{type};

    my $meta_col_def = $meta_obj->column_def($type);
    my $meta_is_blob = $meta_col_def ? $meta_col_def->{type} eq 'blob' : 0;

    ## xxx can be a hook?
    if ( !defined $meta_obj->$type() ) {
        $meta_obj->remove;
    }
    else {
        MT::Meta::Proxy::serialize_blob( $field, $meta_obj ) if $meta_is_blob;
        $meta_obj->save || die $meta_obj->errstr;
        MT::Meta::Proxy::unserialize_blob($meta_obj) if $meta_is_blob;
    }
}

sub load_objects {
    my $proxy = shift;

    return unless $proxy->{__pkeys};
    my ($col)    = @_;
    my $pkg      = $proxy->{pkg};
    my $meta_pkg = $proxy->meta_pkg;

    my @objs = $meta_pkg->search(
        { %{ $proxy->{__pkeys} }, $col ? ( type => $col ) : () } );

    foreach my $meta_obj (@objs) {
        my $type_id = $meta_obj->class;

        my $field = $proxy->META_CLASS()->metadata_by_id( $pkg, $type_id )
            or next;

        my $name = $meta_obj->type;
        my $type = $field->{type};

        my $meta_col_def = $meta_obj->column_def($type);
        if ($meta_col_def) {
            if ( $meta_col_def->{type} eq 'blob' ) {
                MT::Meta::Proxy::unserialize_blob($meta_obj);
            }
            elsif ( $meta_col_def->{type} eq 'datetime' ) {
                $meta_obj->$type( _db2ts( $meta_obj->$type ) );
            }
        }
        $proxy->{__objects}->{$name} = $meta_obj;
        $proxy->{__loaded} ||= {};
        if ( !$proxy->{__loaded}->{$name} ) {
            $proxy->{__loaded}->{$name}     = 1;
            $proxy->{__is_expired}->{$name} = $meta_obj->expired
                if $meta_obj->expired;
            $proxy->{__pkeys}->{type}
                = { not => [ keys %{ $proxy->{__loaded} } ] };
        }
    }
}

1;

__END__

=head1 NAME

MT::Summary::Proxy - interface to a MT::Object's summary objects

=head1 DESCRIPTION

I<MT::Summary::Proxy> provides the low-level interface between a summarizable 
I<MT::Object> and its summary class generated by I<MT::Summary>.

=head1 USAGE

I<MT::Summary::Proxy> inherits most of its functionality from 
I<MT::Meta::Proxy>, with the following significant differences.

=head2 $terms

Instead of a scalar value specifying a metadata field, the I<$terms> argument 
passed to the I<get>, I<set>, and I<create_meta_object> methods can optionally 
be a hashref containing I<class> and/or I<type> elements. Refer to the 
documentation for I<MT::Summarizable> for an explanation of how these are used 
to specify simple or parameterized summaries.

=head2 $proxy->set($terms, $value)

Unlike I<MT::Meta::Proxy->set()>, this method not only sets a summary's value 
but saves it to the database immediately; there is no need to save the parent 
object.
