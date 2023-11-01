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

use MT::Util::Checksums;
use ExtUtils::Manifest;
use File::Copy qw(copy);
use Path::Tiny;
use File::pushd;
use Test::Differences;

$test_env->save_file('lib/Foo.pm',              'package Foo; 1');
$test_env->save_file('plugins/Test/lib/Bar.pm', 'package Bar; 1');
$test_env->save_file('t/foo.t',                 'use Test::More; ok 1; done_testing');

copy('MANIFEST.SKIP', $test_env->root);
{
    no Carp::Always;
    local $ExtUtils::Manifest::Verbose = $ENV{TEST_VERBOSE} ? 1 : 0;
    my $guard = pushd $test_env->root;
    ExtUtils::Manifest::mkmanifest();
}

my $manifest_file = path($test_env->path('MANIFEST'));
ok -f $manifest_file, "generated MANIFEST";

my $manifest = $manifest_file->slurp;
like $manifest   => qr!lib/Foo\.pm!,              "has lib/Foo.pm";
like $manifest   => qr!plugins/Test/lib/Bar\.pm!, "has plugins/Test/lib/Bar.pm";
unlike $manifest => qr!t/foo\.t!,                 "no t/foo.t";

my $checksums_file = path($test_env->path('CHECKSUMS'));
ok !-f $checksums_file, "CHECKSUMS does not exist yet";

{
    no Carp::Always;
    local $ExtUtils::Manifest::Verbose = $ENV{TEST_VERBOSE} ? 1 : 0;
    my $guard = pushd $test_env->root;
    MT::Util::Checksums::update_checksums();
}

ok -f $checksums_file, "CHECKSUMS exists now";
my $checksums = $checksums_file->slurp;
like $checksums   => qr![0-9a-f]{32}\tlib/Foo\.pm!,              "has lib/Foo.pm in CHECKSUMS";
like $checksums   => qr![0-9a-f]{32}\tplugins/Test/lib/Bar\.pm!, "has plugins/Test/lib/Bar.pm in CHECKSUMS";
unlike $checksums => qr![0-9a-f]{32}\tt/foo\.t!,                 "no t/foo.t in CHECKSUMS";

my $updated_manifest = $manifest_file->slurp;
like $updated_manifest => qr!CHECKSUMS!, "MANIFEST has CHECKSUMS as well";

{
    no Carp::Always;
    local $ExtUtils::Manifest::Verbose = $ENV{TEST_VERBOSE} ? 1 : 0;
    my $guard = pushd $test_env->root;
    my $res   = MT::Util::Checksums::test_checksums();
    eq_or_diff $res => undef, "everything is genuine and tracked";
}

$test_env->save_file('plugins/Test/lib/Bar.pm', 'package Bar; say "modified"; 1');
$test_env->save_file('lib/Baz.pm',              'package Baz; 1');

{
    no Carp::Always;
    local $ExtUtils::Manifest::Verbose = $ENV{TEST_VERBOSE} ? 1 : 0;
    my $guard = pushd $test_env->root;
    my $res   = MT::Util::Checksums::test_checksums();
    eq_or_diff $res => { modified => ['plugins/Test/lib/Bar.pm'], untracked => ['lib/Baz.pm'] }, "test_checksums found modified/untracked files";

    $res = MT::Util::Checksums::test_checksums('plugins');
    eq_or_diff $res => { modified => ['plugins/Test/lib/Bar.pm'], untracked => [] }, "test_checksums with a target directory works fine";
}

unless (`git --version` =~ /git version/ && `git config --global user.email` =~ /\w+\@\w+/) {
    done_testing;
    exit;
}

unlink $manifest_file;
unlink $checksums_file;

{
    copy(".gitignore", $test_env->root);
    my $guard  = pushd $test_env->root;
    my $silent = $ENV{TEST_VERBOSE} ? '' : '-q';
    system(qq{git init $silent});
    system(qq{git add .});
    system(qq{git commit $silent -m "init"});
    MT::Util::Checksums::update_checksums();
}

ok -f $checksums_file, "CHECKSUMS exists now";
$checksums = $checksums_file->slurp;
like $checksums   => qr![0-9a-f]{32}\tlib/Foo\.pm!,              "has lib/Foo.pm in CHECKSUMS";
like $checksums   => qr![0-9a-f]{32}\tplugins/Test/lib/Bar\.pm!, "has plugins/Test/lib/Bar.pm in CHECKSUMS";
like $checksums   => qr![0-9a-f]{32}\tlib/Baz\.pm!,              "has lib/Baz.pm in CHECKSUMS";
unlike $checksums => qr![0-9a-f]{32}\tt/foo\.t!,                 "no t/foo.t in CHECKSUMS";

{
    no Carp::Always;
    local $ExtUtils::Manifest::Verbose = $ENV{TEST_VERBOSE} ? 1 : 0;
    my $guard = pushd $test_env->root;
    my $res   = MT::Util::Checksums::test_checksums();
    eq_or_diff $res => undef, "everything is genuine and tracked";
}

$test_env->save_file('plugins/Test/lib/Bar.pm', 'package Bar; say "modified again"; 1');
$test_env->save_file('lib/Quux.pm',             'package Quux; 1');

{
    no Carp::Always;
    local $ExtUtils::Manifest::Verbose = $ENV{TEST_VERBOSE} ? 1 : 0;
    my $guard = pushd $test_env->root;
    my $res   = MT::Util::Checksums::test_checksums();
    eq_or_diff $res => { modified => ['plugins/Test/lib/Bar.pm'], untracked => ['lib/Quux.pm'] }, "test_checksums found modified/untracked files";

    $res = MT::Util::Checksums::test_checksums('plugins');
    eq_or_diff $res => { modified => ['plugins/Test/lib/Bar.pm'], untracked => [] }, "test_checksums with a target directory works fine";
}

done_testing;
