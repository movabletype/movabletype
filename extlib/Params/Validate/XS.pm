package Params::Validate::XS;

use strict;
use warnings;

my $default_fail = sub {
    require Carp;
    Carp::confess( $_[0] );
};

{
    my %defaults = (
        ignore_case    => 0,
        strip_leading  => 0,
        allow_extra    => 0,
        on_fail        => $default_fail,
        stack_skip     => 1,
        normalize_keys => undef,
    );

    *set_options = \&validation_options;

    sub validation_options {
        my %opts = @_;

        my $caller = caller;

        foreach ( keys %defaults ) {
            $opts{$_} = $defaults{$_} unless exists $opts{$_};
        }

        $Params::Validate::OPTIONS{$caller} = \%opts;
    }

    use XSLoader;
    XSLoader::load(
        __PACKAGE__,
        exists $Params::Validate::XS::{VERSION}
        ? ${ $Params::Validate::XS::{VERSION} }
        : (),
    );
}

sub _check_regex_from_xs {
    return ( defined $_[0] ? $_[0] : '' ) =~ /$_[1]/ ? 1 : 0;
}

1;
