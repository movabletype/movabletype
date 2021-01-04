# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Meta;

#--------------------------------------#
# Dependencies

use strict;
use warnings;

#--------------------------------------#
# Constants

sub TYPE_VCHAR ()             {1}
sub TYPE_VCHAR_INDEXED ()     {2}
sub TYPE_VBLOB ()             {3}
sub TYPE_VINTEGER ()          {4}
sub TYPE_VINTEGER_INDEXED ()  {5}
sub TYPE_VDATETIME ()         {6}
sub TYPE_VDATETIME_INDEXED () {7}
sub TYPE_VFLOAT ()            {8}
sub TYPE_VFLOAT_INDEXED ()    {9}
sub TYPE_VCLOB ()             {10}

sub DEBUG () {0}

## Specify if the faster REPLACE INTO can be used instead of INSERT/UPDATE
our $REPLACE_ENABLED = 0;

our ( %Types, %TypesByName );

BEGIN {
    %Types = (
        TYPE_VCHAR()             => "vchar",
        TYPE_VCHAR_INDEXED()     => "vchar_idx",
        TYPE_VINTEGER()          => "vinteger",
        TYPE_VINTEGER_INDEXED()  => "vinteger_idx",
        TYPE_VDATETIME()         => "vdatetime",
        TYPE_VDATETIME_INDEXED() => "vdatetime_idx",
        TYPE_VFLOAT()            => "vfloat",
        TYPE_VFLOAT_INDEXED()    => "vfloat_idx",
        TYPE_VBLOB()             => "vblob",
        TYPE_VCLOB()             => "vclob",
    );

    %TypesByName = reverse %Types;

    # some other aliases
    $TypesByName{string}           = TYPE_VCHAR;
    $TypesByName{integer}          = TYPE_VINTEGER;
    $TypesByName{datetime}         = TYPE_VDATETIME;
    $TypesByName{float}            = TYPE_VFLOAT;
    $TypesByName{string_indexed}   = TYPE_VCHAR_INDEXED;
    $TypesByName{integer_indexed}  = TYPE_VINTEGER_INDEXED;
    $TypesByName{datetime_indexed} = TYPE_VDATETIME_INDEXED;
    $TypesByName{float_indexed}    = TYPE_VFLOAT_INDEXED;
    $TypesByName{text}             = TYPE_VCLOB;
    $TypesByName{hash}             = TYPE_VBLOB;
    $TypesByName{array}            = TYPE_VBLOB;
}

## $Registry = {
##   'foo' => { # key
##     'MT::Foo' => {
##       'column' => {
##         name    => 'column',
##         id      => 123,
##         type_id => 1,
##         type    => 'vchar_idx',
##         pkg     => 'MT::Foo',
##         zip     => $cfg,   ## optional
##       },
##     }
##   },
## }

## $RegistryById = {
##   'foo' => { # key
##     123 => {
##       name    => 'column',
##       id      => 123,
##       type_id => 1,
##       zip     => $cfg,   ## optional
##     },
##   },
## }
our ( $Registry, $RegistryById );

#--------------------------------------#
# Public Class Methods

sub _meta_args {
    my $class = shift;
    my ( $pkg, $which ) = @_;
    $which ||= 'meta';
    my $meth = $which . '_args';
    $pkg->$meth;
}

sub install {
    my $class = shift;
    my ( $pkg, $params, $which ) = @_;

    ## add base class defs, if they exist
    my $base_args = $class->_meta_args( $pkg, $which );
    if ($base_args) {
        while ( my ( $k, $v ) = each( %{$base_args} ) ) {
            $params->{$k} = $v;
        }
    }

    ## add inherited metadata fields...
    my $key = $params->{key};
    my $inherited = $class->_load_inheritance( $pkg, $key );

    my $fields = delete $params->{fields};    # we'll reduce this big value
    push @$fields, @$inherited;

    ## ... and add metadata fields to registry after
    $class->register( $pkg, $key, $fields );

    ## ... and save reduced fields in params (will be installed in properties)
    ##     while saving extra properties
    for (@$fields) {
        $params->{fields}{ $_->{name} } = 1;
        $params->{blob_zip_cfg}{ $_->{name} } = $_->{zip} if $_->{zip};
    }

    if ( MT->config->DisableMetaObjectCache ) {
        $params->{cacheable} = 0;
    }

    ## build subclass
    $class->_build_subclass( $pkg, $params, $which );

    return $params->{fields};
}

sub register {
    my $class = shift;
    my ( $pkg, $key, $fields ) = @_;

    foreach my $field ( @{$fields} ) {
        my $name = $field->{name};
        my $type = $field->{type};
        my $zip  = $field->{zip};

        ## check for potential deep recursion
        #        warn("$pkg has $name subroutine! Deep recursion imminent!")
        #            if $pkg->can($name);

        my $type_id = $TypesByName{$type}
            or Carp::croak(
            "Invalid metadata type '$type' for field $pkg $field->{name}");

        ## load registry
        print STDERR "$pkg is registering metadata $key\t$name\n" if DEBUG;

        ## clone it
        my $value = {
            name    => $name,
            type_id => $type_id,
            type    => $Types{$type_id},
            pkg     => $pkg,
        };
        $value->{zip} = $zip if defined $zip;

        $Registry->{$key}{$pkg}{$name} = $value;
    }
}

sub metadata_by_class {
    my $class = shift;
    my ($pkg) = @_;
    values %{ $Registry->{ $pkg->meta_args->{key} }{$pkg} };
}

sub metadata_by_name {
    my $class = shift;
    my ( $pkg, $name ) = @_;
    $Registry->{ $pkg->meta_args->{key} }{$pkg}{$name};
}

*metadata_by_id = \&metadata_by_name;

sub has_own_metadata_of {
    my $class = shift;
    my ($pkg) = @_;
    my $key
        = $pkg->meta_args->{key};   # xxx is it really safe to call meta_args?
    exists $Registry->{$key}{$pkg};
}

sub normalize_type {
    my $pkg = shift;
    my ($type) = @_;
    return $Types{ $TypesByName{$type} || TYPE_VBLOB };
}

#--------------------------------------#
# Private Class Methods

sub _load_inheritance {
    my $class = shift;
    my ( $pkg, $key ) = @_;

    no strict 'refs';    ## no critic
    my $base = ${"$pkg\::ISA"}[0];
    return [] if $base eq $pkg;
    my @inherited;
    if ( exists $Registry->{$key}{$base} ) {
        for my $field ( values %{ $Registry->{$key}->{$base} } ) {
            push @inherited, $field;
        }
    }
    return \@inherited;
}

sub _build_subclass {
    my $class = shift;
    my ( $pkg, $meta, $which ) = @_;

    my $subclass = $pkg->meta_pkg($which);
    return unless $subclass;

    no strict 'refs';    ## no critic
    return if defined ${"${subclass}::VERSION"};

    ## Try to use this subclass first to see if it exists
    my $subclass_file = $subclass . '.pm';
    $subclass_file =~ s{::}{/}g;
    eval "# line " . __LINE__ . " " . __FILE__
        . "\nno warnings 'all';require '$subclass_file';$subclass->import();";
    if ($@) {
        ## Die if we get an unexpected error
        die $@ unless $@ =~ /Can't locate /;
    }
    else {
        ## This class exists.  We don't need to do anything.
        return 1;
    }

    my $base_class = 'MT::Object::Meta';

    my $subclass_src = "
        # line " . __LINE__ . " " . __FILE__ . "
        package $subclass;
        our \$VERSION = 1.0;
        use base qw($base_class);
        1;
    ";

    ## no critic ProhibitStringyEval
    eval $subclass_src
        or print STDERR "Could not create package $subclass!\n";

    $subclass->install_properties($meta);
}

1;

__END__

=head1 NAME

MT::Meta - Get/Set metadata on a variety of objects

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

    my $foo = Foo->new;
    $foo->selfaware(1);
    $foo->save if you dare;


=head1 DESCRIPTION

The I<MT::Meta> class manages the configuration and of metadata for
I<MT::Object>s. As metadata is fully integrated into I<MT::Object>,
you should not need to access I<MT::Meta> directly.


=head1 USAGE

These class methods allow you to retrieve information about the metadata
defined for specific classes and metadata fields.

=head2 MT::Meta->install($class, $params, [ $which ])

Defines the set of metadata for the class I<$class> as described in the hash
reference I<$params>, and configures I<$class> for use as a metadata host.

If 'summary' is passed in the optional I<$which> argument, defines the set of 
summary data, rather than metadata, for the class.

Members of I<$params> can include:

=over 4

=item * fields

An array reference describing the metadata fields to define. Each member of the
array should be a hash reference containing:

=over 4

=item * name

The name of the metadata field. This corresponds to the object method you'd use
to get/set the metadata on a particular object in the package I<$class>.

=item * id

The numeric ID of the metadata field. This is used as the key for this metadata
field in the database.

=item * type

The data type of the metadata field. One of: C<vchar>, C<vchar_idx>, or
C<vblob>.

=back

The I<fields> member is required.

=item * key

A string to uniquely describe a hierarchy of classes that should share a set of
metadata fields. For example, for ArcheType::M::Asset I<and its subclasses>,
I<key> is C<asset>.

Note that, as this should be the same key as returned in the original class's
I<meta_args> method, you should probably not bother sending it here.

=back

The I<$params> hash may also contain arguments to be set as properties of the
metadata package (the class of I<MT::Object> actually containing the meta
data). Useful properties to set include:

=over 4

=item * datasource

=item * primary_key

=item * get_driver

=back

As I<install> does not mark metadata as installed in the properties of
I<$class>, you should not use it directly, but prefer instead to use
I<MT::Object::install_meta>. (Its single argument is the same as
I<$params> here.)

=head2 MT::Meta->register($class, $key, $fields)

Defines the metadata fields I<$fields> for the class I<$class> under the key
I<$key>. The fields and key arguments are the same as those given to the
I<install> method in I<$params>.

As I<register> does not configure I<$class> for use as a metadata host
(defining the meta data class, enabling automatic initialization of metadata on
loaded instances of I<$class>, etc), you should not use it directly, but prefer
instead to use I<install>.

=head2 MT::Meta->metadata_by_class($class)

Returns a list of hash references describing all the metadata defined for the
class I<$class>. Each item in the array is a reference to a hash containing the
following keys:

=over 4

=item * name

The name of the metadata field. This corresponds to the object method you'd use
to get/set the metadata on a particular object in the package I<$class>.

=item * id

The numeric ID of the metadata field. This is used as the key for this metadata
field in the database.

=item * type

The data type of the metadata field. One of: C<vchar>, C<vchar_idx>, or
C<vblob>.

=item * type_id

The numeric ID corresponding to I<type>.

=item * pkg

The name of the original I<MT::Object> subclass to which this metadata
field belongs.

=back

=head2 MT::Meta->metadata_by_name($class, $name)

Looks up a metadata field in the class I<$class> with the name I<$name>. If
I<$name> is a valid metadata field for I<$class>, returns a reference to a hash
containing the same keys as is returned above from I<metadata_by_class>.
Otherwise, returns false.

=head2 MT::Meta->metadata_by_id($class, $id)

Looks up a metadata field in the class I<$class> with the numeric ID I<$id>.
If I<$id> identifies a valid metadata field for I<$class>, returns a reference
to a hash containing the same keys as is returned above from
I<metadata_by_class>. Otherwise, returns false.

=head2 MT::Meta->has_own_metadata_of($class)

Returns true if the given class has any metadata fields defined. Otherwise,
returns false.


=head1 SEE ALSO

L<MT::Object>, L<MT::Meta::Proxy>

=cut
