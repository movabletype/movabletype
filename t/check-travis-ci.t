use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


# This test checks test files that may not be tested on Travis CI.
# This test will be removed after resolving split tests issue.

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
    elsif ( @dirs >= 3 && $dirs[1] eq 'cms_permission' ) {
        ok( 1, $File::Find::name );    # like t/cms_permission/110-cms-permission.t
    }
    elsif ( @dirs >= 3 && $dirs[1] eq 'data_api' ) {
        ok( 1, $File::Find::name );    # like t/data_api/230-api-endpoint-entry.t
    }
    elsif ( @dirs >= 3 && $dirs[1] eq 'tag' ) {
        ok( 1, $File::Find::name );    # like t/tag/35-tags.t
    }
    else {
        ok( 0, $File::Find::name . ' may not be tested on Travis CI' );
    }
}

done_testing;

