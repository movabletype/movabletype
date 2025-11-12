use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    website => [{
        name         => 'testsite',
        theme_id     => 'classic_test_website',
        site_path    => 'TEST_ROOT/site',
        archive_path => 'TEST_ROOT/site/archive',
        file_extension => 'html ',
    }],
    template => [{
        archive_type => 'Individual',
        name         => "tmpl_entry",
        text         => 'entry test',
    }]
});

my $site  = $objs->{website}{testsite};
my $admin = MT::Author->load(1);

subtest 'file_template' => sub {
    my @testcases = (
       { pattern => '%b/index.html', basename => 'foo',    trim_file_path => 0, expected => 'foo/index.html' },
       { pattern => '%b/index.html', basename => 'foo',    trim_file_path => 1, expected => 'foo/index.html' },
       { pattern => '%b/index.html', basename => ' foo',   trim_file_path => 0, expected => ' foo/index.html' },
       { pattern => '%b/index.html', basename => ' foo',   trim_file_path => 1, expected => 'foo/index.html' },
       { pattern => '%b/index.html', basename => 'foo ',   trim_file_path => 0, expected => 'foo /index.html' },
       { pattern => '%b/index.html', basename => 'foo ',   trim_file_path => 1, expected => 'foo/index.html' },
       { pattern => '%b/index.html', basename => 'f o o',  trim_file_path => 0, expected => 'f o o/index.html' },
       { pattern => '%b/index.html', basename => 'f o o',  trim_file_path => 1, expected => 'f o o/index.html' },
       { pattern => '%b/index.html', basename => ' f o o', trim_file_path => 0, expected => ' f o o/index.html' },
       { pattern => '%b/index.html', basename => ' f o o', trim_file_path => 1, expected => 'f o o/index.html' },
       { pattern => '%b/index.html', basename => 'f o o ', trim_file_path => 0, expected => 'f o o /index.html' },
       { pattern => '%b/index.html', basename => 'f o o ', trim_file_path => 1, expected => 'f o o/index.html' },
       { pattern => 'entry/%b',      basename => 'foo',    trim_file_path => 0, expected => 'entry/foo' },
       { pattern => 'entry/%b',      basename => 'foo',    trim_file_path => 1, expected => 'entry/foo' },
       { pattern => 'entry/%b',      basename => ' foo',   trim_file_path => 0, expected => 'entry/ foo' },
       { pattern => 'entry/%b',      basename => ' foo',   trim_file_path => 1, expected => 'entry/foo' },
       { pattern => 'entry/%b',      basename => 'foo ',   trim_file_path => 0, expected => 'entry/foo ' },
       { pattern => 'entry/%b',      basename => 'foo ',   trim_file_path => 1, expected => 'entry/foo' },
       { pattern => 'entry/%b',      basename => 'f o o',  trim_file_path => 0, expected => 'entry/f o o' },
       { pattern => 'entry/%b',      basename => 'f o o',  trim_file_path => 1, expected => 'entry/f o o' },
       { pattern => 'entry/%b',      basename => ' f o o', trim_file_path => 0, expected => 'entry/ f o o' },
       { pattern => 'entry/%b',      basename => ' f o o', trim_file_path => 1, expected => 'entry/f o o' },
       { pattern => 'entry/%b',      basename => 'f o o ', trim_file_path => 0, expected => 'entry/f o o ' },
       { pattern => 'entry/%b',      basename => 'f o o ', trim_file_path => 1, expected => 'entry/f o o' },
    );
    foreach my $tc (@testcases) {
        MT->config('TrimFilePath' => $tc->{trim_file_path}, 1);
        is(MT->config('TrimFilePath') => $tc->{trim_file_path}, "TrimFilePath is set correctly");
        my $entry = MT::Test::Permission->make_entry(
            blog_id   => $site->id,
            author_id => $admin->id,
            basename  => $tc->{basename},
        );
        my $map = MT::Test::Permission->make_templatemap( file_template => $tc->{pattern} );
        my $got = MT->publisher->archive_file_for($entry, $site, 'Individual', undef, $map, undef, undef, undef);
        is $got, $tc->{expected}, "TrimFilePath: $tc->{trim_file_path}, pattern: $tc->{pattern}";
        $test_env->clear_mt_cache;
        $entry->remove;
    }
};

subtest 'file_extension' => sub {
    my @testcases = (
       { trim_file_path => 0, expected => '1978/01/index.html ' },
       { trim_file_path => 1, expected => '1978/01/index.html' },
    );
    foreach my $tc (@testcases) {
        MT->config('TrimFilePath' => $tc->{trim_file_path}, 1);
        is(MT->config('TrimFilePath') => $tc->{trim_file_path}, "TrimFilePath is set correctly");
        my $entry = MT::Test::Permission->make_entry(
            blog_id   => $site->id,
            author_id => $admin->id,
        );
        my $got = MT->publisher->archive_file_for($entry, $site, 'Monthly', undef,  undef, $entry->authored_on,  undef, undef);
        is $got, $tc->{expected}, "TrimFilePath: $tc->{trim_file_path}";
        $test_env->clear_mt_cache;
        $entry->remove;
    }
};

done_testing;
