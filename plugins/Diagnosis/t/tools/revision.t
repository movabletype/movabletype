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
use MT::Revisable;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    author => [{
        name         => 'admin',
        password     => 'pass',
        is_superuser => 1,
    }],
    blog => [
        { id => 1, name => 'my_blog1', },
        { id => 2, name => 'my_blog2', },
    ],
    entry        => [{ blog_id => 2, basename => "entry1", }],
    content_type => { ct => { blog_id => 2, fields => [cf_title => 'single_line_text'] } },
    content_data => {
        cd => {
            blog_id      => 2,
            content_type => 'ct',
            label        => 'cd1',
            data         => {},
        },
    },
    template => [{
            blog_id => 2,
            name    => 'template1',
            text    => 'test',
        },
    ],
});

my $ds_spec = {
    entry => {
        fixture => 'entry',
        field   => 'status',
    },
    cd => {
        fixture => 'content_data',
        field   => 'status',
    },
    template => {
        fixture => 'template',
        field   => 'text',
    },
};

my $site1 = $objs->{blog}{my_blog1};
my $site2 = $objs->{blog}{my_blog2};

{
    my ($stdin, $stdout, $stderr) = do_command(['--entry']);
    my $oks = () = $stdout =~ /OK\./g;
    is $oks, 2, 'right number of tests processed';
}

{
    my ($stdin, $stdout, $stderr) = do_command(['--entry', '--blog_id=1']);
    my $oks = () = $stdout =~ /OK\./g;
    is $oks, 1, 'right number of tests processed';
}

for my $ds ('template', 'cd', 'entry') {
    my $col = 'max_revisions_' . $ds;
    is $site2->$col, undef, 'revision_max is undef for brandnew sites';

    my $obj = $objs->{ $ds_spec->{$ds}->{fixture} }{ $ds . '1' };

    for (1 .. 21) {
        my $rev_obj = $obj->clone();
        $rev_obj->{changed_revisioned_cols} = [$ds_spec->{$ds}->{field}];
        $rev_obj->save_revision('test');
    }

    {
        my $count = MT->model($ds . ':revision')->count({ $ds . '_id' => $obj->id });
        is $count, 21, 'excessive';
    }

    {
        my ($stdin, $stdout, $stderr) = do_command(["--$ds"]);
        my $count = MT->model($ds . ':revision')->count({ $ds . '_id' => $obj->id });
        is $count, 21, 'not deleted yet';
        my $oks = () = $stdout =~ /OK\./g;
        is $oks, 1, 'right number of tests processed';
        is(($stdout =~ qr{Detected: (\d+)})[0], 1, 'right amount detected');
    }

    {
        my ($stdin, $stdout, $stderr) = do_command(["--$ds", '--delete']);
        my $count = MT->model($ds . ':revision')->count({ $ds . '_id' => $obj->id });
        is $count, 20, 'deleted';
        my $oks = () = $stdout =~ /OK\./g;
        is $oks, 1, 'right number of tests processed';
        is(($stdout =~ qr{Deleted: (\d+)})[0], 1, 'right amount deleted');
    }

    {
        my ($stdin, $stdout, $stderr) = do_command(["--$ds", '--delete']);
        my $count = MT->model($ds . ':revision')->count({ $ds . '_id' => $obj->id });
        is $count, 20, 'no more deletion';
        my $oks = () = $stdout =~ /OK\./g;
        is $oks, 2, 'right number of tests processed';
        is(($stdout =~ qr{Deleted: (\d+)})[0], 0, 'right amount deleted');
    }

    $site2->$col(3);
    $site2->save();

    {
        my ($stdin, $stdout, $stderr) = do_command(["--$ds", '--delete']);
        my $count = MT->model($ds . ':revision')->count({ $ds . '_id' => $obj->id });
        is $count, 3, 'deleted';
        my $oks = () = $stdout =~ /OK\./g;
        is $oks, 1, 'right number of tests processed';
        is(($stdout =~ qr{Deleted: (\d+)})[0], 17, 'right amount deleted');
    }
}

{
    $site2->max_revisions_entry(3);
    $site2->save();
    my $obj = $objs->{'entry'}{'entry1'};

    for (1 .. 5) {
        my $rev_obj = $obj->clone();
        $rev_obj->{changed_revisioned_cols} = ['status'];
        $rev_obj->save_revision('test');
    }

    {
        my ($stdin, $stdout, $stderr) = do_command(["--entry", '--delete', '--limit=2']);
        my $count = MT->model('entry:revision')->count({ 'entry_id' => $obj->id });
        is $count, 6, 'deleted';
        my $oks = () = $stdout =~ /OK\./g;
        is $oks, 1, 'right number of tests processed';
        is(($stdout =~ qr{Deleted: (\d+)})[0], 2, 'right amount deleted');
    }
}

sub do_command {
    my ($cmd_options) = @_;
    my @cmd = (
        $^X, '-I',
        File::Spec->catdir($ENV{MT_HOME}, 't/lib'),
        File::Spec->catfile($ENV{MT_HOME}, 'tools/Diagnosis/revision'),
        @$cmd_options,
    );

    run3 \@cmd, \my $stdin, \my $stdout, \my $stderr;
    note $stderr if $stderr;

    return $stdin, $stdout, $stderr;
}

done_testing;
