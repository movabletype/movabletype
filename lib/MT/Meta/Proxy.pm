# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: Proxy.pm 71506 2008-01-18 23:13:43Z ykerherve $

package MT::Meta::Proxy;
use strict;
use warnings;

use MT::Meta;
use MT::Serialize;

my $serializer = MT::Serialize->new('MT');

sub new {
    my $class = shift;
    my($obj)  = @_;
    my $proxy = bless { pkg => ref($obj) }, $class;
    $proxy->set_primary_keys($obj) if $obj->has_primary_key;
    $proxy;
}

sub is_changed {
    my $proxy = shift;
    my($col) = @_;
    return unless $proxy->{__objects}; ## don't remove this line
                                       ## see below. we should probably change this idiom

    if ($col) {
        return 0 unless exists $proxy->{__objects}{$col};
        my $pkg  = $proxy->{pkg};
        my $meta = $proxy->{__objects}{$col};
        my $field = MT::Meta->metadata_by_name($pkg, $col)
            or return 0;
        my $type = $field->{type}
            or return 0;
        return $meta->is_changed($type);
    } else {
        foreach my $field (keys %{ $proxy->{__objects} } ) {
            next if $field eq '';
            return 1 if $proxy->is_changed($field);
        }
        return;
    }
}

sub exists_meta {
    my $proxy = shift;
    my($col)  = @_;

    $proxy->lazy_load_objects;
    return exists $proxy->{__objects}->{$col};
}

sub get {
    my $proxy = shift;
    my ($col) = @_;

    $proxy->lazy_load_objects;

    if (exists $proxy->{__objects}->{$col}) {
        my $pkg  = $proxy->{pkg};
        my $meta = $proxy->{__objects}->{$col};

        my $field = MT::Meta->metadata_by_name($pkg, $col)
            or Carp::croak("Metadata $col on $pkg not found.");
        my $type = $field->{type}
            or Carp::croak("$col not found on $pkg meta fields");

        unless ($meta->has_column($type)) {
            Carp::croak("something is wrong: $type not in column_values of metadata");
        }
        return $meta->$type;
    } else {
        ## no metadata row in the database ... return undef, not ''
        return undef;
    }
}

sub get_hash {
    my $proxy = shift;
    my ($col) = @_;

    $proxy->lazy_load_objects;

    my $collection = {};

    foreach my $name (keys %{ $proxy->{__objects} }) {
        $collection->{$name} = $proxy->get($name);
    }

    return $collection;
}

sub set_hash {
    my $proxy = shift;
    my ($collection) = @_;

    foreach my $name (keys %{ $collection }) {
        $proxy->set($name, $collection->{$name});
    }
}

sub get_collection {
    my $proxy = shift;
    my ($col) = @_;

    $proxy->lazy_load_objects;

    my $collection = {};

    foreach my $name (keys %{ $proxy->{__objects} }) {
        if ($name =~ m/^\Q$col\E\.(.+)$/) {
            my $suffix = $1;
            $collection->{$suffix} = $proxy->get($name);
        }
    }

    return $collection;
}

sub meta_pkg {
    my $proxy = shift;
    return $proxy->{pkg}->meta_pkg;
}

sub create_meta_object {
    my $proxy = shift;
    my($col, $value) = @_;

    my $pkg = $proxy->{pkg};
    my $meta = $proxy->meta_pkg->new;

    my $field = MT::Meta->metadata_by_name($pkg, $col)
        or Carp::croak("there's no field $col on $pkg");

    my $type_id = $field->{type_id}
        or Carp::croak("no type_id for $col");
    my $id = $field->{id};
    my $type = $MT::Meta::Types{$type_id};

    $meta->type($col);
    $meta->$type($value);

    $meta;
}

sub set {
    my $proxy = shift;
    my ($col, $value) = @_;

    # xxx When you update the metadata, you have to preserve the
    # original data as well. This should be eliminated by adding the
    # update optimization for metadata columns
    $proxy->lazy_load_objects;

    $proxy->{__objects}->{$col} = $proxy->create_meta_object($col, $value);
    $proxy->get($col);
}

sub save {
    my $proxy = shift;

    # perl funkiness ... keys %{ $proxy->{__objects} } will automatically clobber
    # empty hash reference on that key!
    return unless $proxy->{__objects};

    foreach my $field (keys %{ $proxy->{__objects} } ) {
        next if $field eq '';
        next unless $proxy->is_changed($field);
        my $meta_obj = $proxy->{__objects}->{$field};

        ## primary key from core object
        foreach my $pkey (keys %{ $proxy->{__pkeys} } ) {
            my $pval = $proxy->{__pkeys}->{$pkey};
            $meta_obj->$pkey($pval);
        }

        my $pkg = $proxy->{pkg};
        my $meta = MT::Meta->metadata_by_name($pkg, $field)
            or Carp::croak("Metadata $field on $pkg not found.");
        my $type = $meta->{type};

        my $meta_col_def = $meta_obj->column_def($type);
        my $meta_is_blob = $meta_col_def ? $meta_col_def->{type} eq 'blob' : 0;

        ## xxx can be a hook?
        if ( ! defined $meta_obj->$type() ) {
            $meta_obj->remove;
        }
        else {
            serialize_blob($field, $meta_obj) if $meta_is_blob;
            if ($MT::Meta::REPLACE_ENABLED) {
                $meta_obj->replace;
            } 
            else {
                $meta_obj->save;
            }
            unserialize_blob($meta_obj) if $meta_is_blob;
        }
    }
}

sub remove {
    my $proxy = shift;
    my $meta_pkg = $proxy->meta_pkg;
    Carp::croak("Deletion of meta without PK installed") 
        unless $proxy->{__pkeys};

    my %args = ($_[1] and ref($_[1]) eq 'HASH') ? %{ $_[1] } : ();
    $args{nofetch} = 1;

    $meta_pkg->remove($proxy->{__pkeys}, \%args);

    delete $proxy->{__objects};
}

sub set_primary_keys {
    my ($proxy, $obj) = @_;

    if (my $pkmap = $proxy->meta_pkg->properties->{pk_map}) {
        my $pkeys;
        while (my($object_key, $meta_key) = each %$pkmap) {
            $pkeys->{$meta_key} = $obj->$object_key();
        }
        $proxy->{__pkeys} = $pkeys;
        return;
    }
    ## Map the N fields of the object's primary key to the first N fields of the meta object's primary key.
    ## TODO: can we assume the meta class's primary key starts with the host package's primary key?
    ## TODO: isn't there some idiom for iterating over two arrays in tandem?
    my @class_keys = @{ $obj->primary_key_tuple };
    my @meta_keys  = @{ $proxy->meta_pkg->primary_key_tuple };
    my $pkeys = {};
    for my $i (0..$#class_keys) {
        my $pkey = $class_keys[$i];
        $pkeys->{$meta_keys[$i]} = $obj->$pkey();
    }

    $proxy->{__pkeys} = $pkeys;
}

sub lazy_load_objects {
    my $proxy = shift;
    $proxy->load_objects if ! exists $proxy->{__objects} && $proxy->{__pkeys};
}

sub load_objects {
    my $proxy = shift;

    my $pkg = $proxy->{pkg};
    my $meta_pkg = $proxy->meta_pkg;

    my @objs  = $meta_pkg->search($proxy->{__pkeys});

    foreach my $meta_obj (@objs) {
        my $type_id = $meta_obj->type;

        my $field = MT::Meta->metadata_by_id($pkg, $type_id)
            or next;

        my $name  = $field->{name};
        my $type  = $field->{type};

        my $meta_col_def = $meta_obj->column_def($type);
        if ( $meta_col_def ) {
            if ( $meta_col_def->{type} eq 'blob' ) {
                unserialize_blob($meta_obj);
            }
            elsif ( $meta_col_def->{type} eq 'datetime' ) {
                $meta_obj->$type( _db2ts( $meta_obj->$type ) );
            }
        }
        $proxy->{__objects}->{$name} = $meta_obj;
    }
}

# FIXME: copied from MT::Object
sub _db2ts {  
    my $ts = $_[0];
    $ts =~ s/(?:\+|-)\d{2}$//;
    $ts =~ tr/\- ://d;
    return $ts;
}

# This expose our unserialization just in case someone needs it
# PhenoType differ does.
sub do_unserialization {
    my $class = shift;
    my $dataref = shift;

    return $dataref unless defined $$dataref;
    $$dataref =~ s/^([ABCINS]{3})://;
    my $prefix = $1;
    unless (defined $prefix) {
        return $dataref;
    }

    if ($prefix eq 'BIN') {
        my $val = $serializer->unserialize($$dataref);
        if (defined $val) {
            return $val; # it's a ref already.
        } else {
            return \$val;
        }
    } elsif ($prefix eq 'ASC') {
        return $dataref;
    } else {
        warn "Something's wrong with the data: prefix is $prefix";
        return $dataref;
    }
}

sub unserialize_blob {
    my $meta_obj = shift;
    for my $column (@{ $meta_obj->columns_of_type('blob') }) {
        my $data = $meta_obj->$column();

        my $unser = do_unserialization($meta_obj, \$data);
        
        # set it back to the unserialized data structure
        $meta_obj->$column($$unser, { no_changed_flag => 1 });
    }
}

sub serialize_blob {
    my $field = shift;
    my $meta_obj = shift;
    for my $column (@{ $meta_obj->columns_of_type('blob') }) {
        my $data = $meta_obj->$column();

        my $val;
        if (ref $data) {
            $val = 'BIN:' . $serializer->serialize(\$data);
        } elsif (defined $data) {
            $val = 'ASC:' . $data;
        } else {
            $val = undef;
        }

        # set it back the serialized data
        $meta_obj->$column($val, { no_changed_flag => 1 });
    }
}

sub deflate_meta {
    my $proxy = shift;

    ## Load all metadata for the object, so that we can store it. Odds are,
    ## we've already got it anyway.
    $proxy->lazy_load_objects;

    my $meta = {};
    for my $field (keys %{ $proxy->{__objects} } ) {
        next if $field eq '';
        $meta->{$field} = $proxy->get($field);
    }
    $meta;
}

sub inflate_meta {
    my $proxy = shift;
    my($deflated) = @_;
    for my $key (keys %$deflated) {
        my $value = eval { $proxy->create_meta_object($key, $deflated->{$key}) };
        next if $@; ## probably 2 versions of the code using the same memcached
        $proxy->{__objects}{$key} = $value;
        $proxy->{__objects}{$key}{changed_cols} = {};
    }
}

sub refresh {
    my $proxy = shift;
    # just delete and let the Proxy lazy load it afterwards
    delete $proxy->{__objects};
    return 1;
}

1;

__END__

=head1 NAME

MT::Meta::Proxy - interface to a MT::Object's meta data object

=head1 SYNOPSIS

    package Foo;
    use base qw( MT::Object );

    __PACKAGE__->install_properties({ ... });

    __PACKAGE__->install_meta({
        datasource => 'foo_meta',
        fields     => [
            { name => 'selfaware', type => 'vchar', key => 1 },
        ],
    });

    sub meta_args {
        +{ key => 'foo' };
    }


    package main;
    # then what?


=head1 DESCRIPTION

The I<MT::Meta::Proxy> is the interface between a I<MT::Object> and
its meta data class generated by I<MT::Meta>.

=head1 USAGE

=head2 MT::Meta::Proxy->new($obj)

Returns a new metadata proxy to manage metadata for the given
I<MT::Object> instance.

=head2 $proxy->get($field)

Returns the value of the metadata field I<$field> represented by this proxy.

=head2 $proxy->meta_pkg()

Returns the name of the class containing the metadata this proxy will get and
set. The meta data class name is typically the original I<MT::Object>
class appended with C<::Meta>.

=head2 $proxy->create_meta_object($field, $value)

Returns a new instance of the meta data class this proxy manages, representing
the metadata field I<$field> and containing the value I<$value>.

As I<create_meta_object> will not put the object under this proxy's management,
you should not use it directly, but instead prefer to use I<set>.

=head2 $proxy->set($field, $value)

Sets the metadata field I<$field> under this proxy's care to the value I<$value>.

=head2 $proxy->save()

Saves each of the meta data objects this proxy manages that have been changed.

=head2 $proxy->remove()

Removes all of the meta data objects this proxy manages from the database and
local memory storage.

=head2 $proxy->set_primary_keys($obj)

Sets the primary keys of I<$proxy> to those of the MT::Object instance
I<$obj>.

=head2 $proxy->lazy_load_objects()

Loads the meta data objects this proxy manages if they have not already been
loaded and cached in local memory storage. The actual loading is performed by
I<load_objects>.

=head2 $proxy->load_objects()

Loads all the meta data objects this proxy manages into local memory storage,
regardless of whether they've already been loaded.

=head2 $proxy->deflate_meta()

Returns a flat hash reference containing all the metadata managed by this
proxy.

=head2 $proxy->inflate_meta($hash)

Restores the internal state of this proxy with the metadata fields and values
found in the flat hash reference I<$hash>. Note the proxy will assume that the
hash contains the saved values of the meta data. That is, the fields named in
I<$hash> will I<not> be marked as changed by I<inflate_meta()>.


=head1 SEE ALSO

I<MT::Object>, I<MT::Meta>

=cut

