use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAfterRebuild => $ENV{MT_TEST_DELETE_FILES_AFTER_REBUILD} // 1,
        DeleteFilesAtRebuild    => 1,
        RebuildAtDelete         => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

$ENV{MT_TEST_PUBLISH_ASYNC} //= 1;

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::Fixture::ArchiveTypeDistinct;
use MT::Test::App;
use File::Path;
use Test::Deep qw/cmp_deeply cmp_bag/;
use Array::Diff;
use MT::PublishOption;
use MT::Entry;

$test_env->prepare_fixture('archive_type_distinct');
my $objs = MT::Test::Fixture::ArchiveTypeDistinct->load_objs;

my $site = MT::Website->load( { name => 'site_for_archive_test' } );
$site->server_offset(0);    ## to work around an offset issue
$site->save;

my $blog_id   = $site->id;
my $site_root = $site->site_path;
my $author1   = MT::Author->load( { name => 'author1' } );

my $cat_ruler_id  = $objs->{category}{cat_ruler}->id;
my $cat_eraser_id = $objs->{category}{cat_eraser}->id;

if ( !-d $site_root ) {
    MT->publisher->rebuild( BlogID => $blog_id );
}

if ( $ENV{MT_TEST_PUBLISH_ASYNC} ) {
    for my $map ( MT::Template->load, MT::TemplateMap->load ) {
        $map->build_type( MT::PublishOption::ASYNC() );
        $map->save;
    }
}

my @prev_files = $test_env->files($site_root);
my @delta;
my $entry_diff           = 9;
my $same_date_entry_diff = 1;

rmtree($site_root);
MT::FileInfo->remove_all;

sub force_cleanup {
    return unless $ENV{MT_TEST_FORCE_CLEANUP};
    rmtree($site_root);
    MT::FileInfo->remove_all;
    MT->publisher->rebuild( BlogID => $blog_id );
    run_rpt_if_async();
    @prev_files = $test_env->files($site_root);
}

sub diff_should_be {
    my $expected = shift;

    my @current_files = $test_env->files($site_root);
    my $diff          = Array::Diff->diff( \@prev_files, \@current_files );
    my @added         = @{ $diff->added };
    my @deleted       = @{ $diff->deleted };
    note explain \@added;
    note explain \@deleted;
    if (@added) {
        is @added => $expected, "$expected files are added";
        ok !@deleted, "nothing should be deleted";
        @prev_files = @current_files;
        @delta      = @added;

        # all the added files should have their FileInfo
        my @infos = MT::FileInfo->load( { blog_id => $blog_id, file_path => \@added } );
        is scalar @infos => scalar @added, "all the added files have their FileInfo";
    }
    if (@deleted) {
        ok !@added, "nothing should be added";
        cmp_bag( \@deleted, \@delta, "$expected files are deleted" );
        @prev_files = @current_files;
        @delta      = ();

        # all the deleted files should not have their FileInfo
        my @infos = MT::FileInfo->load( { blog_id => $blog_id, file_path => \@deleted } );
        ok !@infos, "all the deleted files do not have their FileInfo"
            or note explain [ map { $_->file_path } @infos ];
    }
    if ( $expected && !@added && !@deleted ) {
        fail "$expected files should be added or deleted";
    }
    if ( !$expected && !@added && !@deleted ) {
        pass "nothing should happen";
    }
}

sub run_rpt_if_async {
    return unless $ENV{MT_TEST_PUBLISH_ASYNC};

    if (@delta) {
        if ( MT->config('DeleteFilesAfterRebuild') ) {
            my @deleted_too_early;
            for my $file (@delta) {
                push @deleted_too_early, $file unless -f $file;
            }
            ok !@deleted_too_early, "nothing should be deleted yet"
                or note explain \@deleted_too_early;
        }
    }
    run_rpt();
}

sub run_rpt {
    note "process queue";
    my $res = _run_rpt();
    note $res;

    my @jobs = MT::TheSchwartz::Job->load;
    ok !@jobs, "no jobs are left";
}

subtest 'async rebuild everything' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    MT->publisher->rebuild( BlogID => $blog_id );

    run_rpt_if_async();

    diff_should_be(0);
};

# different date: more archives are involved
subtest 'create a new entry' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
        }
    );

    $app->post_form_ok(
        'entry_form',
        {   title  => 'new entry',
            text   => 'body',
            status => MT::Entry::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($entry_diff);
};

subtest 'delete the newly-created entry' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'new entry' } );
    my $entry_id = $entry->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
            id      => $entry_id,
        }
    );

    my $link = $app->wq_find('a.delete');

    my %return_args = (
        __mode  => 'list',
        _type   => $link->attr('mt:object-type'),
        blog_id => $link->attr('mt:blog-id'),
    );

    $app->post_form_ok(
        'entry_form',
        {   __mode      => 'delete',
            return_args => join( '&', map {"$_=$return_args{$_}"} keys %return_args ),
        }
    );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be($entry_diff);
};

subtest 'create another new entry' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
        }
    );

    $app->post_form_ok(
        'entry_form',
        {   title  => 'another new entry',
            text   => 'body',
            status => MT::Entry::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($entry_diff);
};

subtest 'unpublish the newly-created entry' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'another new entry' } );
    my $entry_id = $entry->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
            id      => $entry_id,
        }
    );

    $app->post_form_ok( 'entry_form', { status => MT::Entry::HOLD() } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be($entry_diff);
};

subtest 'create yet another new (but out-of-date) entry' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
        }
    );

    $app->post_form_ok(
        'entry_form',
        {   title  => 'yet another new entry',
            text   => 'body',
            status => MT::Entry::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($entry_diff);
};

subtest 'unpublish the newly-created past entry' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'yet another new entry' } );
    $entry->unpublished_on("20200101000000");
    $entry->save or die $entry->errstr;

    run_rpt();

    diff_should_be($entry_diff);
};

subtest 'create a new entry by DataAPI' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    $app->api_request_ok(
        POST  => "/v3/sites/$blog_id/entries",
        entry => {
            title  => 'new entry by DataAPI',
            text   => 'body',
            status => 'Publish',
        }
    );

    run_rpt_if_async();

    diff_should_be($entry_diff);
};

subtest 'delete the newly-created entry by DataAPI' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'new entry by DataAPI' } );
    my $entry_id = $entry->id;

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    $app->api_request_ok( DELETE => "/v4/sites/$blog_id/entries/$entry_id", );

    run_rpt_if_async();

    diff_should_be($entry_diff);
};

subtest 'create another new entry by DataAPI' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    $app->api_request_ok(
        POST  => "/v3/sites/$blog_id/entries",
        entry => {
            title  => 'another new entry by DataAPI',
            text   => 'body',
            status => 'Publish',
        }
    );

    run_rpt_if_async();

    diff_should_be($entry_diff);
};

subtest 'unpublish the newly-created entry by DataAPI' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'another new entry by DataAPI' } );
    my $entry_id = $entry->id;

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    $app->api_request_ok(
        PUT   => "/v3/sites/$blog_id/entries/$entry_id",
        entry => { status => 'Draft' },
    );

    run_rpt_if_async();

    diff_should_be($entry_diff);
};

# the same date: less archives are involved
subtest 'create a new entry with the same date' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
        }
    );

    $app->post_form_ok(
        'entry_form',
        {   title            => 'new entry with the same date',
            text             => 'body',
            authored_on_date => '2018-12-03',
            authored_on_time => '12:11:10',
            category_ids     => "$cat_ruler_id,$cat_eraser_id",
            status           => MT::Entry::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($same_date_entry_diff);
};

subtest 'delete the newly-created entry with the same date' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'new entry with the same date' } );
    my $entry_id = $entry->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
            id      => $entry_id,
        }
    );

    my $link = $app->wq_find('a.delete');

    my %return_args = (
        __mode  => 'list',
        _type   => $link->attr('mt:object-type'),
        blog_id => $link->attr('mt:blog-id'),
    );

    $app->post_form_ok(
        'entry_form',
        {   __mode      => 'delete',
            return_args => join( '&', map {"$_=$return_args{$_}"} keys %return_args ),
        }
    );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be($same_date_entry_diff);
};

subtest 'create another new entry with the same date' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
        }
    );

    $app->post_form_ok(
        'entry_form',
        {   title            => 'another new entry with the same date',
            text             => 'body',
            authored_on_date => '2018-12-03',
            authored_on_time => '12:11:10',
            category_ids     => "$cat_ruler_id,$cat_eraser_id",
            status           => MT::Entry::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($same_date_entry_diff);
};

subtest 'unpublish the newly-created entry with the same date' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'another new entry with the same date' } );
    my $entry_id = $entry->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
            id      => $entry_id,
        }
    );

    $app->post_form_ok( 'entry_form', { status => MT::Entry::HOLD() } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be($same_date_entry_diff);
};

subtest 'create yet another new (but out-of-date) entry with the same date' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
        }
    );

    $app->post_form_ok(
        'entry_form',
        {   title            => 'yet another new entry with the same date',
            text             => 'body',
            authored_on_date => '2018-12-03',
            authored_on_time => '12:11:10',
            category_ids     => "$cat_ruler_id,$cat_eraser_id",
            status           => MT::Entry::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($same_date_entry_diff);
};

subtest 'unpublish the newly-created past entry with the same date' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'yet another new entry with the same date' } );
    $entry->unpublished_on("20200101000000");
    $entry->save or die $entry->errstr;

    run_rpt();

    diff_should_be($same_date_entry_diff);
};

done_testing;
