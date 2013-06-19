package MT::DataAPI::Resource::Website;

use strict;
use warnings;

use base qw(MT::DataAPI::Resource::Blog);

sub fields {
    $_[0]->SUPER::fields();
}

sub updatable_fields {
    $_[0]->SUPER::updatable_fields();
}

1;
