package MT::Test::Fixture::ArchiveTypeForChildSite;

use strict;
use warnings;
use base 'MT::Test::Fixture::ArchiveType';

sub fixture_spec {
    my $class = shift;
    my %spec  = %{ $class->SUPER::fixture_spec };
    $spec{blog} = delete $spec{website};
    \%spec;
}

1;
