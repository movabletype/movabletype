package Data::ObjectDriver::Iterator;

use strict;
use warnings;

my %Iterators = ();

sub new {
    my $class = shift;
    my( $each, $end ) = @_;
    bless $each, $class;
    if ($end) {
        $Iterators{ $each }{ end } = $end;
    }
    return $each;
}

sub next {
    return shift->();
}

sub end {
    my $each = shift;
    my $hash = delete $Iterators{ $each };
    $hash->{ end }->() if $hash and ref $hash->{ end } eq 'CODE';
}

sub DESTROY {
    my $iter = shift;
#    use YAML; warn Dump \%Iterators;
    $iter->end();
}

1;
