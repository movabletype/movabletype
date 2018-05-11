use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
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
my @allowed_sub_dirs = qw(
    app
    cms
    cms_permission
    data_api
    mt7
    mt_object
    object_driver
    tag
    util
    xt
);

File::Find::find( \&wanted, $search_dir );

my %file_count;

sub wanted {
    return if -d $File::Find::name;
    return unless $File::Find::name =~ /\.t$/;

    my @dirs = File::Spec->splitdir($File::Find::name);

    if ( @dirs == 2 ) {
        ok( 1, $File::Find::name );    # like t/00-compile.t
        $file_count{'./'}++;
    }
    elsif ( @dirs >= 3 && grep { $_ eq $dirs[1] } @allowed_sub_dirs ) {
        ok( 1, $File::Find::name );
        $file_count{$dirs[1]}++;
    }
    else {
        ok( 0, $File::Find::name . ' may not be tested on Travis CI' );
    }
}

note '';
note '-- test file count --';
for my $dir ( sort keys %file_count ) {
    my $count = $file_count{$dir};
    note "$dir: $count";
}

done_testing;

