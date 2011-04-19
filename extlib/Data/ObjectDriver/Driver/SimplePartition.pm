package Data::ObjectDriver::Driver::SimplePartition;
use strict;
use warnings;
use base qw( Data::ObjectDriver::Driver::Partition );

use Carp qw( croak );
use Data::Dumper;
use Data::ObjectDriver::Driver::MultiPartition;

sub init {
    my $driver = shift;
    my %param = @_;
    my $class = delete $param{using} or croak "using is required";
    my @extra = %param;
    $param{get_driver} = _make_get_driver($class, \@extra);
    $driver->SUPER::init(%param);
    return $driver;
}

sub _make_get_driver {
    my($class, $extra) = @_;
    $extra ||= [];

    ## Make sure we've loaded the parent class that contains information
    ## about our partitioning scheme.
    croak "Bogus classname." unless $class =~ /^[\w:]+$/;
    "eval $class; 1;" or die "Failed to load parent class: $@\n";

    my $col = $class->primary_key_tuple->[0];
    my $get_driver = $class->properties->{partition_get_driver}
        or croak "Partitioning driver not defined for $class";

    my $number = $class->properties->{number_of_partitions};
    my $mp_driver = Data::ObjectDriver::Driver::MultiPartition->new(
        partitions => [ map { $get_driver->($_, @$extra) } (1 .. $number) ]
    );

    return sub {
        my($terms, $args) = @_;
        my $parent_id;
        if (ref($terms) eq 'HASH') {
            $parent_id = $terms->{ $col };
        } elsif (ref($terms) eq 'ARRAY') {
            ## An array ref could either be a multiple-column primary key OR
            ## a list of primary keys. With a multiple-column primary key, the
            ## $id is an array ref, where the first column is always the
            ## parent_id.
            $parent_id = ref($terms->[0]) eq 'ARRAY' ?
                $terms->[0][0] : $terms->[0];
        }
        if ($parent_id) {
            my $parent = $class->driver->lookup($class, $parent_id)
                or croak "Member of $class with ID $parent_id not found";
            return $get_driver->( $parent->partition_id, @$extra );
        } else {
            unless($args->{multi_partition}) {
                croak "Cannot extract $col from terms ", Dumper($terms);
            }
            return $mp_driver;
        }
    };
}

1;

__END__

=head1 NAME

Data::ObjectDriver::Driver::SimplePartition - basic partitioned object driver

=head1 SYNOPSIS

    package ParentObject;
    use base qw( Data::ObjectDriver::BaseObject );

    __PACKAGE__->install_properties({
        columns     => [ 'parent_id', 'partition_id', ... ],
        ...
        driver      => Data::ObjectDriver::Driver::DBI->new( @$GLOBAL_DB_INFO ),
        primary_key => 'parent_id',
    });

    __PACKAGE__->has_partitions(
        number     => scalar @PARTITIONS,
        get_driver => \&get_driver_by_partition,
    );

    package SomeObject;
    use base qw( Data::ObjectDriver::BaseObject );

    __PACKAGE__->install_properties({
        ...
        driver               => Data::ObjectDriver::Driver::SimplePartition->new(
                                    using => 'ParentObject'
                                ),
        primary_key          => ['parent_id', 'object_id'],
    });


=head1 DESCRIPTION

I<Data::ObjectDriver::Driver::SimplePartition> is a basic driver for objects
partitioned into separate databases. See
L<Data::ObjectDriver::Driver::Partition> for more about partitioning databases.

I<SimplePartition> helps you partition objects into databases based on their
association with one record of a I<parent> class. If your classes don't meet
the requirements imposed by I<SimplePartition>, you can still write your own
partitioning driver. See L<Data::ObjectDriver::Driver::Partition>.

=head1 SUGGESTED PRACTICES

Often this is used for user partitioning, where the parent class is your user
account class; all records of other classes that are "owned" by that user are
partitioned into the same database. This allows you to scale horizontally with
the number of users, at the cost of complicating querying multiple users' data
together.

I<SimplePartition> will load the related instance of the parent class every
time it needs to find the partition for a related object. Consider using a
minimal mapping class for the parent, keeping as much data as possible in other
related classes. For example, if C<User> were your parent class, you might keep
I<only> the user ID and other data used to find users (such as login name and
email address) in C<User>, keeping further profile data in another
C<UserProfile> class.

As all the partitioned classes related to a given parent class will share the
same C<partition_get_driver> logic to turn a partition ID into a driver, you
might put the C<partition_get_driver> function in the parent class, or use a
custom subclass of I<SimplePartition> that contains and automatically specifies
the C<partition_get_driver> function.

=head1 USAGE

=head2 Data::ObjectDriver::Driver::SimplePartition->new(%params)

Creates a new basic partitioning driver for a particular class. The required
members of C<%params> are:

=over 4

=item * C<using>

The name of the parent class on which the driven class is partitioned.

Using a class as a parent partitioned class requires these properties to be defined:

=over 4

=item * C<columns>

The parent class must have a C<partition_id> column containing a partition
identifier. This identifier is passed to the C<partition_get_driver> function to
identify a driver to return.

=item * C<primary_key>

The parent class's primary key must be a simple single-column key, and that
column must be the same as the referencing column in the partitioned classes.

=item * C<partition_get_driver>

The C<partition_get_driver> property must be a function that returns an object
driver, given a partition ID and any extra parameters given to the
C<SimplePartition> constructor.

This property can also be defined as C<get_driver> in a call to
C<Class-E<gt>has_partitions()>. See L<Data::ObjectDriver::BaseObject>.

=back

=back

You can also include any further optional parameters you like. They will be
passed to the partitioned class's C<partition_get_driver> function as given.

A I<SimplePartition> driver will require these properties to be defined for
partitioned classes:

=over 4

=item * C<primary_key>

Your primary key should be a complex primary key (arrayref) with the simple key
of the parent object for the first field.

=back

=head1 DIAGNOSTICS

=over 4

=item * C<using is required.>

The C<using> parameter to the I<SimplePartition> constructor is required to
create the partitioned class's C<get_driver> function. Perhaps you omitted it,
or your subclass of I<SimplePartition> did not properly specify it to its
parent's constructor.

=item * C<Bogus classname.>

The parent class name you specified in your C<using> parameter does not appear
to be a valid class name. If you are automatically generating parent class
names, check that your method of converting strings to class names is correct.

=item * C<Failed to load parent class: I<error>>

The parent class you specified in your C<using> parameter could not be loaded,
for the given reason. Perhaps you didn't include its location in your library
path.

=item * C<Partitioning driver not defined for I<partitioned class>>

The partitioned class named in the error is configured to use the
I<SimplePartition> driver but does not have a C<partition_get_driver> set.
Check that you intended to use I<SimplePartition> with that class or, if you're
automatically specifying the C<partition_get_driver> function, that your
technique is working correctly.

=item * C<Cannot extract I<column> from terms I<search terms or primary key>>

The I<SimplePartition> driver could not determine from the given search terms
or object key what the ID of the related parent record was. Check that your
columns in the partitioned and parent classes share the same name, and that
your application includes the parent ID in all C<search()> calls for the
partitioned class and instances of partitioned objects before attempting to
save them.

Optionaly you can enable a basic support of search accross multiple
partition by passing the 'multi_partition' arg (true value) to the search
query.

=item * C<Member of I<class> with ID I<parent ID> not found>

The parent record associated with the partitioned object could not be loaded.
Perhaps your application deleted the parent record without removing its
associated partitioned objects first.

=back

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

=head1 SEE ALSO

L<Data::ObjectDriver::Driver::Partition>

=head1 LICENSE

I<Data::ObjectDriver> is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, I<Data::ObjectDriver> is Copyright 2005-2006
Six Apart, cpan@sixapart.com. All rights reserved.

=cut

