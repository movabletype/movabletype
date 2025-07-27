package MT::Test::Fixture::ContentData::Dirty;

use strict;
use warnings;
use base 'MT::Test::Fixture::ContentData';

my $invalid_id = 1000;

sub fixture_spec {
    my $class = shift;
    my $spec  = $class->SUPER::fixture_spec;
    push @{ $spec->{content_data}{cd}{data}{cf_tags} },               \$invalid_id;
    push @{ $spec->{content_data}{cd}{data}{cf_categories} },         \$invalid_id;
    push @{ $spec->{content_data}{cd}{data}{cf_image} },              \$invalid_id;
    push @{ $spec->{content_data}{cd}{data}{cf_content_type} },       \$invalid_id;
    push @{ $spec->{content_data}{cd_multi}{data}{cf_tags} },         \$invalid_id;
    push @{ $spec->{content_data}{cd_multi}{data}{cf_categories} },   \$invalid_id;
    push @{ $spec->{content_data}{cd_multi}{data}{cf_image} },        \$invalid_id;
    push @{ $spec->{content_data}{cd_multi}{data}{cf_content_type} }, \$invalid_id;
    $spec;
}

1;
