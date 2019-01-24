package MT::Test::Fixture::ArchiveTypeSimple;

use strict;
use warnings;
use base 'MT::Test::Fixture::ArchiveType';

sub fixture_spec {
    my $class = shift;
    my %spec  = %{ $class->SUPER::fixture_spec };

    # remove "cf_same_catset_other_fruit" categories field
    for my $ct_key ( keys %{ $spec{content_type} } ) {
        my %new_ct = @{ $spec{content_type}{$ct_key} };
        delete $new_ct{cf_same_catset_other_fruit} or next;
        $spec{content_type}{$ct_key} = [%new_ct];
    }
    for my $cd ( values %{ $spec{content_data} } ) {
        delete $cd->{data}{cf_same_catset_other_fruit};
    }

    # remove non-primary category in entry/content_data
    for my $entry ( @{ $spec{entry} } ) {
        next unless @{ $entry->{categories} || [] } > 1;
        $entry->{categories} = [ $entry->{categories}[0] ];
    }
    for my $cd ( values %{ $spec{content_data} } ) {
        for my $cf_key ( keys %{ $cd->{data} } ) {
            next unless $cf_key =~ /^cf_/ && $cf_key =~ /_catset_/;
            next unless @{ $cd->{data}{$cf_key} || [] } > 1;
            $cd->{data}{$cf_key} = [ $cd->{data}{$cf_key}[0] ];
        }
    }

    return \%spec;
}

1;
