#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib

use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        # Website
        my $website
            = MT::Test::Permission->make_website( name => 'my website', );

        # Blog
        my $blog = MT::Test::Permission->make_blog(
            parent_id => $website->id,
            name      => 'my blog',
        );
    }
);

my $blog = MT::Blog->load( { name => 'my blog' } );

subtest 'Remove FileInfo' => sub {
    my $fmgr = MT::FileMgr->new('Local');
    my $dir  = File::Spec->catfile( MT->config->TempDir );
    if ( !$fmgr->exists($dir) ) {
        $fmgr->mkpath($dir);
    }
    my $file = File::Spec->catfile( $dir, 'test.html' );
    if ( !$fmgr->exists($file) ) {
        $fmgr->put_data( 1, $file );
    }
    my $fileinfo = MT::FileInfo->new;
    $fileinfo->blog_id( $blog->id );
    $fileinfo->file_path($file);
    $fileinfo->save;
    ok( $fmgr->exists($file), 'File exists.' );
    $fileinfo->remove;
    ok( !$fmgr->exists($file), 'File was removed.' );
};

done_testing();
