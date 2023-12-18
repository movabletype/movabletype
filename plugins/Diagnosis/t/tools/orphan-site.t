use strict;
use warnings;
use utf8;
use IPC::Run3 qw/run3/;
use File::Spec;
use FindBin;
use lib "$FindBin::Bin/../../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new();
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Blog;
use MT::Website;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    author => [{
        name         => 'admin',
        password     => 'pass',
        is_superuser => 1,
    }],
    website => [
        #{ name     => 'First Website' }, # fixture preset
        { name => 'parent1' },
        { name => 'parent2' },
    ],
    blog => [
        { name => 'child1-1', parent_id => 1 },
        { name => 'child1-2', parent_id => 1 },    # break it later
        { name => 'child1-3', parent_id => 1 },    # break it later
        { name => 'child2-1', parent_id => 2 },    # break it later
        { name => 'child2-2', parent_id => 2 },    # break it later
    ],
    entry => [{ basename => "child1-1", blog_id => 4 }, { basename => "child1-2", blog_id => 5 },],
});

is(MT::Website->count(), 3, 'right number of parents');
is(MT::Blog->count(),    5, 'right number of childs');
is(MT::Entry->count(),   2, 'right number of childs');

$objs->{blog}{'child1-2'}->parent_id(undef);
$objs->{blog}{'child1-2'}->save;
$objs->{blog}{'child1-3'}->parent_id(undef);
$objs->{blog}{'child1-3'}->save;
$objs->{blog}{'child2-2'}->parent_id(undef);
$objs->{blog}{'child2-2'}->save;

{
    my ($stdin, $stdout, $stderr) = do_command();
    my $found = () = $stdout =~ /^Child site/gm;
    is $found, 3, 'right number of broken sites found';
    is(MT::Website->count(), 3, 'right number of parents');
    is(MT::Blog->count(),    5, 'right number of childs');
    is(MT::Entry->count(),   2, 'right number of entry');
}

{
    my ($stdin, $stdout, $stderr) = do_command(1);
    my $found = () = $stdout =~ /^Child site/gm;
    is $found, 3, 'right number of broken sites found';
    is(MT::Website->count(), 3, 'right number of parents');
    is(MT::Blog->count(),    2, 'right number of childs');
    is(MT::Entry->count(),   1, 'right number of entry');
}

sub do_command {
    my $mode = shift;
    my @cmd  = (
        $^X,
        '-I',
        File::Spec->catdir($ENV{MT_HOME}, 't/lib'),
        File::Spec->catfile($ENV{MT_HOME}, 'tools/Diagnosis/orphan-site'),
        ($mode ? { 1 => '--delete' }->{$mode} : ''));

    run3 \@cmd, \my $stdin, \my $stdout, \my $stderr;
    note $stderr if $stderr;

    return $stdin, $stdout, $stderr;
}

done_testing;
