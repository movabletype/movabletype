#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::ArchiveType;
use MT::Test::Tag;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

filters {
    archive_type => [qw( chomp )],
    template     => [qw( chomp )],
    expected     => [qw( chomp )],
};

$test_env->prepare_fixture('archive_type');
my $objs    = MT::Test::Fixture::ArchiveType->load_objs;
my $blog_id = $objs->{blog_id};

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

done_testing;

__END__

=== raw mt:ArchiveFile
--- template
<mt:ArchiveFile>
--- expected_error
Could not determine entry

=== mt:ArchiveFile in object loop
--- skip
1
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26132
--- template
<mt:Entries><mt:ArchiveFile>
</mt:Entries>
<mt:Pages><mt:ArchiveFile>
</mt:Pages>
<mt:Contents content_type="ct_with_same_catset"><mt:ArchiveFile>
</mt:Contents>
--- exepted
