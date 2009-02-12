#!perl -w
package version;

use 5.005_04;
use strict;

use vars qw(@ISA $VERSION $CLASS *qv);

$VERSION = 0.76;

$CLASS = 'version';

eval "use version::vxs $VERSION";
if ( $@ ) { # don't have the XS version installed
    eval "use version::vpp $VERSION"; # don't tempt fate
    die "$@" if ( $@ );
    push @ISA, "version::vpp";
    local $^W;
    *version::qv = \&version::vpp::qv;
    if ($] > 5.009001 && $] <= 5.010000) {
	no strict 'refs';
	*{'version::stringify'} = \*version::vpp::stringify;
	*{'version::(""'} = \*version::vpp::stringify;
    }
}
else { # use XS module
    push @ISA, "version::vxs";
    local $^W;
    *version::qv = \&version::vxs::qv;
    if ($] > 5.009001 && $] <= 5.010000) {
	no strict 'refs';
	*{'version::stringify'} = \*version::vxs::stringify;
	*{'version::(""'} = \*version::vxs::stringify;
    }
}

# Preloaded methods go here.
sub import {
    my ($class) = shift;
    my $callpkg = caller();
    no strict 'refs';
    
    *{$callpkg."::qv"} = 
	    sub {return bless version::qv(shift), $class }
	unless defined(&{"$callpkg\::qv"});
}

1;
