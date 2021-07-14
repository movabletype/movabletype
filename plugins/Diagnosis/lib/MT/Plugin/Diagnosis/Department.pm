package MT::Plugin::Diagnosis::Department;
use strict;
use warnings;
use Carp qw(croak);
use MT::Util;

sub description { croak 'Method "description" not implemented by subclass' }

sub scan { croak 'Method "scan" not implemented by subclass' }

sub repair { croak 'Method "repair" not implemented by subclass' }

sub department_name {
    my $class = shift;
    my $prefix = __PACKAGE__;
    return ($class =~ qr{^$prefix\::(.+)})[0];
}

1;
