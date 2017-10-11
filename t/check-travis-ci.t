use strict;
use warnings;

# This test checks test files that may not be tested on Travis CI.
# This test will be removed after resolving split tests issue.

use Test::More;

use File::Find ();
use File::Spec;

my $search_dir = 't';

File::Find::find( \&wanted, $search_dir );

sub wanted {
    return if -d $File::Find::name;
    return unless $File::Find::name =~ /\.t$/;

    my @dirs = File::Spec->splitdir($File::Find::name);

    if ( @dirs == 2 ) {
        ok( 1, $File::Find::name );    # like t/00-compile.t
    }
    elsif ( @dirs >= 3 && $dirs[1] eq 'mt7' ) {
        ok( 1, $File::Find::name );    # like t/mt7/archive_type.t
    }
    else {
        ok( 0, $File::Find::name . ' may not be tested on Travis CI' );
    }
}

done_testing;

