package Data::ObjectDriver::Driver::MultiPartition;
use strict;
use base qw( Data::ObjectDriver );

__PACKAGE__->mk_accessors(qw( partitions ));

sub init {
    my $driver = shift;
    $driver->SUPER::init(@_);
    my %param = @_;
    $driver->partitions($param{partitions});
    return $driver;
}

sub search {
    my $driver = shift;
    my($class, $terms, $args) = @_;

    my @objs;
    my $only_one_result = $args->{limit} && $args->{limit} == 1;
    for my $partition (@{ $driver->partitions }) {
        my @partial_res = $partition->search($class, $terms, $args);
        return @partial_res if $only_one_result && @partial_res;
        push @objs, @partial_res;
    }
    return @objs;
}

1;

__END__

=head1 NAME

Data::ObjectDriver::Driver::MultiPartition - Search thru partitioned objects without
the partition_key

=head1 DESCRIPTION

I<Data::ObjectDriver::Driver::MultiPartition> is used internally by
I<Data::ObjectDriver::Driver::SimplePartition> to do very simple
search accross partition, if the terms of the query cannot be used to
determine the partition.

It's just a basic support. For instance 'limit' arg isn't supported
except if its value is 1.
