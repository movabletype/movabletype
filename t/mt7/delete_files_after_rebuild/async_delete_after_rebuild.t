use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
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

$ENV{MT_TEST_PUBLISH_ASYNC}   //= 1;
$ENV{MT_TEST_PUBLISH_DYNAMIC} //= 0;
$ENV{MT_TEST_FORCE_CLEANUP}   //= 0;

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::Fixture::ArchiveTypeDistinct;
use MT::Test::App;
use File::Path;
use Test::Deep qw/cmp_bag/;
use Array::Diff;
use List::Util qw/uniq/;
use Time::Piece;
use Time::Seconds;
use MT::PublishOption;
use MT::EntryStatus;
use MT::ContentStatus;
use Path::Tiny;

$test_env->prepare_fixture('archive_type_distinct');
my $objs = MT::Test::Fixture::ArchiveTypeDistinct->load_objs;

my $site = MT::Website->load( { name => 'site_for_archive_test' } );
$site->server_offset(0);    ## to work around an offset issue
$site->save;

my $blog_id   = $site->id;
my $site_root = $site->site_path;
my $author1   = MT::Author->load( { name => 'author1' } );

my $ct_objs = $objs->{content_type}{ct_with_same_catset};

my $ct_id = $ct_objs->{content_type}->id;

my $cf_date_id        = $ct_objs->{content_field}{cf_same_date}->id;
my $cf_datetime_id    = $ct_objs->{content_field}{cf_same_datetime}->id;
my $cf_same_fruit_id  = $ct_objs->{content_field}{cf_same_catset_fruit}->id;
my $cf_other_fruit_id = $ct_objs->{content_field}{cf_same_catset_other_fruit}->id;
my $cat_apple_id      = $objs->{category_set}{catset_fruit}{category}{cat_apple}->id;
my $cat_orange_id     = $objs->{category_set}{catset_fruit}{category}{cat_orange}->id;
my $cat_strawberry_id = $objs->{category_set}{catset_fruit}{category}{cat_strawberry}->id;
my $cat_peach_id      = $objs->{category_set}{catset_fruit}{category}{cat_peach}->id;
my $cat_ruler_id      = $objs->{category}{cat_ruler}{$blog_id}->id;
my $cat_eraser_id     = $objs->{category}{cat_eraser}{$blog_id}->id;
my $cat_compass_id    = $objs->{category}{cat_compass}{$blog_id}->id;

if ( $ENV{MT_TEST_PUBLISH_DYNAMIC} ) {
    rmtree($site_root);
    for my $map ( MT::Template->load, MT::TemplateMap->load ) {
        $map->build_type( MT::PublishOption::DYNAMIC() );
        $map->save;
    }
    $ENV{MT_TEST_PUBLISH_ASYNC} = 0;
}

if ( !-d $site_root ) {
    MT->publisher->rebuild( BlogID => $blog_id );
}

if ( $ENV{MT_TEST_PUBLISH_ASYNC} ) {
    for my $map ( MT::Template->load, MT::TemplateMap->load ) {
        $map->build_type( MT::PublishOption::ASYNC() );
        $map->save;
    }
}

my $special_case;

my @initial_files = list_files();
my @prev_files    = @initial_files;
my @delta;
my $entry_diff                   = 9;
my $content_diff                 = 13;
my $same_date_entry_diff         = 1;
my $same_date_content_diff       = 1;
my $entry_datetime_change_diff   = 9;
my $content_datetime_change_diff = 13;
my $entry_category_change_diff   = 17;
my $content_category_change_diff = 13;

rmtree($site_root);
MT::FileInfo->remove_all;

sub make_date {
    my $date = Time::Piece->new(shift);
    $date += ONE_WEEK if $date->week == 1;
    $date -= ONE_WEEK if $date->week == 52;
    $date;
}

sub list_files {
    if ( $ENV{MT_TEST_PUBLISH_DYNAMIC} ) {
        return
            sort { $a cmp $b }
            uniq map { $_->file_path } MT::FileInfo->load( { blog_id => $blog_id } );
    }
    else {
        return $test_env->files($site_root);
    }
}

sub force_cleanup {
    my $force = shift;
    return unless $force || $ENV{MT_TEST_FORCE_CLEANUP};
    rmtree($site_root);
    MT::FileInfo->remove_all;
    MT->publisher->rebuild( BlogID => $blog_id );
    run_rpt_if_async();
    @prev_files = list_files();
}

sub diff_should_be {
    my $expected = shift;

    my @current_files = list_files();
    my $diff          = Array::Diff->diff( \@prev_files, \@current_files );
    my @added         = @{ $diff->added };
    my @deleted       = @{ $diff->deleted };
    note explain \@added;
    note explain \@deleted;
    if ( !@delta ) {
        is @added => $expected, "$expected files are added";
        ok !@deleted, "nothing should be deleted" or note explain \@deleted;
        @prev_files = @current_files;
        @delta      = @added;

        # all the added files should have their FileInfo
        my @infos = MT::FileInfo->load( { blog_id => $blog_id, file_path => [map {File::Spec->canonpath($_)} @added] } );
        is scalar @infos => scalar @added, "all the added files have their FileInfo";
    }
    else {
        ok !@added, "nothing should be added" or note explain \@added;
        cmp_bag( \@deleted, \@delta, "$expected files are deleted" );
        @prev_files = @current_files;
        @delta      = ();

        # all the deleted files should not have their FileInfo
        my @infos = MT::FileInfo->load( { blog_id => $blog_id, file_path => [map {File::Spec->canonpath($_)} @deleted] } );
        ok !@infos, "all the deleted files do not have their FileInfo"
            or note explain [ map { $_->file_path } @infos ];
    }
    if ( $expected && !@added && !@deleted ) {
        fail "$expected files should be added or deleted";
    }
    if ( !$expected && !@added && !@deleted ) {
        pass "nothing should happen";
    }

    ok !MT::DeleteFileInfo->count, "nothing is left as marked";
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
        {   title  => 'new entry',
            text   => 'body',
            status => MT::EntryStatus::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($entry_diff);

    my @years = uniq map { my ($year) = $_ =~ /site\/archive\/(\d+)/; $year ? $year : () } @delta;
    if (@years == 2) {
        # new year
        $special_case = 1;
    }
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

    my $form = $app->form;
    my ($input)
        = grep { ( $_->{'mt:command'} || '' ) eq 'do-remove-items' }
        $form->find_input( undef, 'submit' );
    my %return_args = (
        __mode  => 'list',
        _type   => $input->{'mt:object-type'},
        blog_id => $input->{'mt:blog-id'},
    );

    $app->post_form_ok(
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
        {   title  => 'another new entry',
            text   => 'body',
            status => MT::EntryStatus::RELEASE(),
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

    $app->post_form_ok( { status => MT::EntryStatus::HOLD(), } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be($entry_diff);

    # extra test for draft
    my $path = MT::Util::archive_file_for($entry, $site, 'Individual');
    my $file = path(File::Spec->catfile($site->archive_path, $path));
    ok !-f $file, "target file $file is gone";
    $file->parent->mkpath;
    $file->spew("test");
    ok -f $file, "target file exists now";

    $app->post_form_ok( { status => MT::EntryStatus::HOLD() } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    ok -f $file, "target file still exists";
    is $file->slurp => "test", "content of the target file is not changed";

    unlink $file;

    diff_should_be(0);
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
        {   title  => 'yet another new entry',
            text   => 'body',
            status => MT::EntryStatus::RELEASE(),
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
        POST  => "/v4/sites/$blog_id/entries",
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
        POST  => "/v4/sites/$blog_id/entries",
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
        PUT   => "/v4/sites/$blog_id/entries/$entry_id",
        entry => { status => 'Draft' },
    );

    run_rpt_if_async();

    diff_should_be($entry_diff);

    # extra test for draft
    my $path = MT::Util::archive_file_for($entry, $site, 'Individual');
    my $file = path(File::Spec->catfile($site->archive_path, $path));
    ok !-f $file, "target file $file is gone";
    $file->parent->mkpath;
    $file->spew("test");
    ok -f $file, "target file exists now";

    $app->api_request_ok(
        PUT   => "/v4/sites/$blog_id/entries/$entry_id",
        entry => { status => 'Draft' },
    );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    ok -f $file, "target file still exists";
    is $file->slurp => "test", "content of the target file is not changed";

    unlink $file;

    diff_should_be(0);
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
        {   title            => 'new entry with the same date',
            text             => 'body',
            authored_on_date => '2018-12-03',
            authored_on_time => '12:11:10',
            category_ids     => "$cat_ruler_id,$cat_eraser_id",
            status           => MT::EntryStatus::RELEASE(),
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

    my $form = $app->form;
    my ($input)
        = grep { ( $_->{'mt:command'} || '' ) eq 'do-remove-items' }
        $form->find_input( undef, 'submit' );
    my %return_args = (
        __mode  => 'list',
        _type   => $input->{'mt:object-type'},
        blog_id => $input->{'mt:blog-id'},
    );

    $app->post_form_ok(
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
        {   title            => 'another new entry with the same date',
            text             => 'body',
            authored_on_date => '2018-12-03',
            authored_on_time => '12:11:10',
            category_ids     => "$cat_ruler_id,$cat_eraser_id",
            status           => MT::EntryStatus::RELEASE(),
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

    $app->post_form_ok( { status => MT::EntryStatus::HOLD(), } );

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
        {   title            => 'yet another new entry with the same date',
            text             => 'body',
            authored_on_date => '2018-12-03',
            authored_on_time => '12:11:10',
            category_ids     => "$cat_ruler_id,$cat_eraser_id",
            status           => MT::EntryStatus::RELEASE(),
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

# different date: more contents are involved
subtest 'create a new content data' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );

    $app->post_form_ok(
        {   data_label                    => 'new content data',
            "date-$cf_date_id"            => '2021-02-01',
            "date-$cf_datetime_id"        => '2021-03-01',
            "time-$cf_datetime_id"        => '12:34:56',
            "category-$cf_same_fruit_id"  => $cat_apple_id,
            "category-$cf_other_fruit_id" => $cat_strawberry_id,
            status                        => MT::ContentStatus::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($content_diff);
};

subtest 'delete the newly-created content data' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'new content data' } );
    my $cd_id = $cd->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
            id              => $cd_id,
        }
    );

    my $form = $app->form;
    my ($input)
        = grep { ( $_->{'mt:command'} || '' ) eq 'do-remove-items' }
        $form->find_input( undef, 'submit' );
    my %return_args = (
        __mode  => 'list',
        _type   => $input->{'mt:object-type'},
        type    => $input->{'mt:subtype'},
        blog_id => $input->{'mt:blog-id'},
    );

    $app->post_form_ok(
        {   __mode      => 'delete',
            return_args => join( '&', map {"$_=$return_args{$_}"} keys %return_args ),
        }
    );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be($content_diff);
};

subtest 'create another new content data' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );

    $app->post_form_ok(
        {   data_label                    => 'another new content data',
            "date-$cf_date_id"            => '2021-02-01',
            "date-$cf_datetime_id"        => '2021-03-01',
            "time-$cf_datetime_id"        => '12:34:56',
            "category-$cf_same_fruit_id"  => $cat_apple_id,
            "category-$cf_other_fruit_id" => $cat_strawberry_id,
            status                        => MT::ContentStatus::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($content_diff);
};

subtest 'unpublish the newly-created content data' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'another new content data' } );
    my $cd_id = $cd->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
            id              => $cd_id,
        }
    );

    $app->post_form_ok( { status => MT::ContentStatus::HOLD(), } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be($content_diff);

    # extra test for draft
    my $path = MT::Util::archive_file_for($cd, $site, 'ContentType');
    my $file = path(File::Spec->catfile($site->archive_path, $path));
    ok !-f $file, "target file $file is gone";
    $file->parent->mkpath;
    $file->spew("test");
    ok -f $file, "target file exists now";

    $app->post_form_ok( { status => MT::ContentStatus::HOLD() } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    ok -f $file, "target file still exists";
    is $file->slurp => "test", "content of the target file is not changed";

    unlink $file;

    diff_should_be(0);
};

subtest 'create yet another new content data' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );

    $app->post_form_ok(
        {   data_label                    => 'yet another new content data',
            "date-$cf_date_id"            => '2021-02-01',
            "date-$cf_datetime_id"        => '2021-03-01',
            "time-$cf_datetime_id"        => '12:34:56',
            "category-$cf_same_fruit_id"  => $cat_apple_id,
            "category-$cf_other_fruit_id" => $cat_strawberry_id,
            status                        => MT::ContentStatus::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($content_diff);
};

subtest 'unpublish the newly-created past content data' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'yet another new content data' } );
    $cd->unpublished_on("20200101000000");
    $cd->save;

    run_rpt();

    diff_should_be($content_diff);
};

subtest 'create a new content data by DataAPI' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    $app->api_request_ok(
        POST         => "/v4/sites/$blog_id/contentTypes/$ct_id/data",
        content_data => {
            label  => 'new content data by DataAPI',
            status => 'Publish',
            data   => [
                { id => $cf_date_id,        data => '2021-02-01' },
                { id => $cf_datetime_id,    data => '2021-03-01' },
                { id => $cf_datetime_id,    data => '12:34:56' },
                { id => $cf_same_fruit_id,  data => [$cat_apple_id] },
                { id => $cf_other_fruit_id, data => [$cat_strawberry_id] },
            ],
        }
    );

    run_rpt_if_async();

    diff_should_be($content_diff);
};

subtest 'delete the newly-created content data by DataAPI' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'new content data by DataAPI' } );
    my $cd_id = $cd->id;

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    $app->api_request_ok( DELETE => "/v4/sites/$blog_id/contentTypes/$ct_id/data/$cd_id", );

    run_rpt_if_async();

    diff_should_be($content_diff);
};

subtest 'create another new content data by DataAPI' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    $app->api_request_ok(
        POST         => "/v4/sites/$blog_id/contentTypes/$ct_id/data",
        content_data => {
            label  => 'another new content data by DataAPI',
            status => 'Publish',
            data   => [
                { id => $cf_date_id,        data => '2021-02-01' },
                { id => $cf_datetime_id,    data => '2021-03-01' },
                { id => $cf_datetime_id,    data => '12:34:56' },
                { id => $cf_same_fruit_id,  data => [$cat_apple_id] },
                { id => $cf_other_fruit_id, data => [$cat_strawberry_id] },
            ],
        }
    );

    run_rpt_if_async();

    diff_should_be($content_diff);
};

subtest 'unpublish the newly-created content data by DataAPI' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'another new content data by DataAPI' } );
    my $cd_id = $cd->id;

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    $app->api_request_ok(
        PUT          => "/v4/sites/$blog_id/contentTypes/$ct_id/data/$cd_id",
        content_data => { status => 'Draft' },
    );

    run_rpt_if_async();

    diff_should_be($content_diff);

    # extra test for draft
    my $path = MT::Util::archive_file_for($cd, $site, 'ContentType');
    my $file = path(File::Spec->catfile($site->archive_path, $path));
    ok !-f $file, "target file $file is gone";
    $file->parent->mkpath;
    $file->spew("test");
    ok -f $file, "target file exists now";

    $app->api_request_ok(
        PUT          => "/v4/sites/$blog_id/contentTypes/$ct_id/data/$cd_id",
        content_data => { status => 'Draft' },
    );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    ok -f $file, "target file still exists";
    is $file->slurp => "test", "content of the target file is not changed";

    unlink $file;

    diff_should_be(0);
};

# same date: less contents are involved
subtest 'create a new content data with the same date' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );

    $app->post_form_ok(
        {   data_label                    => 'new content data with the same date',
            authored_on_date              => '2018-10-31',
            authored_on_time              => '12:34:56',
            "date-$cf_date_id"            => '2019-09-26',
            "date-$cf_datetime_id"        => '2008-11-01',
            "time-$cf_datetime_id"        => '12:34:56',
            "category-$cf_same_fruit_id"  => $cat_apple_id,
            "category-$cf_other_fruit_id" => $cat_orange_id,
            status                        => MT::ContentStatus::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($same_date_content_diff);
};

subtest 'delete the newly-created content data with the same date' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'new content data with the same date' } );
    my $cd_id = $cd->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
            id              => $cd_id,
        }
    );

    my $form = $app->form;
    my ($input)
        = grep { ( $_->{'mt:command'} || '' ) eq 'do-remove-items' }
        $form->find_input( undef, 'submit' );
    my %return_args = (
        __mode  => 'list',
        _type   => $input->{'mt:object-type'},
        type    => $input->{'mt:subtype'},
        blog_id => $input->{'mt:blog-id'},
    );

    $app->post_form_ok(
        {   __mode      => 'delete',
            return_args => join( '&', map {"$_=$return_args{$_}"} keys %return_args ),
        }
    );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be($same_date_content_diff);
};

subtest 'create another new content data with the same date' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );

    $app->post_form_ok(
        {   data_label                    => 'another new content data with the same date',
            authored_on_date              => '2018-10-31',
            authored_on_time              => '12:34:56',
            "date-$cf_date_id"            => '2019-09-26',
            "date-$cf_datetime_id"        => '2008-11-01',
            "time-$cf_datetime_id"        => '12:34:56',
            "category-$cf_same_fruit_id"  => $cat_apple_id,
            "category-$cf_other_fruit_id" => $cat_orange_id,
            status                        => MT::ContentStatus::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($same_date_content_diff);
};

subtest 'unpublish the newly-created content data with the same date' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'another new content data with the same date' } );
    my $cd_id = $cd->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
            id              => $cd_id,
        }
    );

    $app->post_form_ok( { status => MT::ContentStatus::HOLD(), } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be($same_date_content_diff);
};

subtest 'create yet another new content data with the same date' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );

    $app->post_form_ok(
        {   data_label                    => 'yet another new content data with the same date',
            authored_on_date              => '2018-10-31',
            authored_on_time              => '12:34:56',
            "date-$cf_date_id"            => '2019-09-26',
            "date-$cf_datetime_id"        => '2008-11-01',
            "time-$cf_datetime_id"        => '12:34:56',
            "category-$cf_same_fruit_id"  => $cat_apple_id,
            "category-$cf_other_fruit_id" => $cat_orange_id,
            status                        => MT::ContentStatus::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($same_date_content_diff);
};

subtest 'unpublish the newly-created past content data with the same date' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd
        = MT::ContentData->load( { label => 'yet another new content data with the same date' } );
    $cd->unpublished_on("20200101000000");
    $cd->save;

    run_rpt();

    diff_should_be($same_date_content_diff);
};

# ---------------------------------------------------

subtest 'create yet yet another new entry' => sub {
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
        {   title  => 'yet yet another new entry',
            text   => 'body',
            status => MT::EntryStatus::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($entry_datetime_change_diff);
};

subtest 'change authored_on of the newly-created entry' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'yet yet another new entry' } );
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

    my $date     = make_date();
    my $new_date = make_date(time + ONE_YEAR);
    my $year     = $date->year;
    my $new_year = $new_date->year;

    $app->post_form_ok( { "authored_on_date" => $new_date->ymd } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    my @current_files = list_files();
    my $diff          = Array::Diff->diff( \@prev_files, \@current_files );
    my @added         = @{ $diff->added };
    my @deleted       = @{ $diff->deleted };
    note explain \@added;
    note explain \@deleted;
    is @added                      => 9, "9 new files are added";
    is grep( /$new_year/, @added ) => 9, "and all of them belong to the new year";
    is @deleted                    => 9, "9 old files are deleted";
    SKIP: {
        skip 'special case', 1 if $special_case;
        is grep( /$year/, @deleted )   => 9, "and all of them belong to the current year";
    }
    push @delta, @added;
    my %deleted_map = map { $_ => 1 } @deleted;
    @delta      = grep !$deleted_map{$_}, @delta;
    @prev_files = @current_files;
};

subtest 'unpublish the newly-created entry (just to restore the initial state)' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'yet yet another new entry' } );
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

    $app->post_form_ok( { status => MT::EntryStatus::HOLD() } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be($entry_datetime_change_diff);

    cmp_bag( \@prev_files, \@initial_files, "back to the initial state" );

    # extra test for draft
    my $path = MT::Util::archive_file_for($entry, $site, 'Individual');
    my $file = path(File::Spec->catfile($site->archive_path, $path));
    ok !-f $file, "target file $file is gone";
    $file->parent->mkpath;
    $file->spew("test");
    ok -f $file, "target file exists now";

    my $date     = make_date();
    my $new_date = make_date(time + ONE_YEAR * 2);
    my $year     = $date->year;
    my $new_year = $new_date->year;

    $app->post_form_ok( { "authored_on_date" => $new_date->ymd, status => MT::EntryStatus::HOLD() } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    ok -f $file, "target file still exists";
    is $file->slurp => "test", "content of the target file is not changed";

    unlink $file;

    diff_should_be(0);
};

subtest 'create yet yet yet another new entry' => sub {
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
        {   title        => 'yet yet yet another new entry',
            text         => 'body',
            category_ids => "$cat_ruler_id,$cat_eraser_id",
            status       => MT::EntryStatus::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($entry_category_change_diff);
};

subtest 'change category of the newly-created entry' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'yet yet yet another new entry' } );
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

    $app->post_form_ok( { "category_ids" => "$cat_ruler_id,$cat_compass_id" } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    my @current_files = list_files();
    my $diff          = Array::Diff->diff( \@prev_files, \@current_files );
    my @added         = @{ $diff->added };
    my @deleted       = @{ $diff->deleted };
    note explain \@added;
    note explain \@deleted;
    is @added                     => 4, "4 new files are added";
    is grep( /compass/, @added )  => 4, "and all of them belong to the compass category";
    is @deleted                   => 4, "4 old files are deleted";
    is grep( /eraser/, @deleted ) => 4, "and all of them belong to the eraser category";
    push @delta, @added;
    my %deleted_map = map { $_ => 1 } @deleted;
    @delta      = grep !$deleted_map{$_}, @delta;
    @prev_files = @current_files;
};

subtest 'unpublish the newly-created entry (just to restore the initial state)' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'yet yet yet another new entry' } );
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

    $app->post_form_ok( { status => MT::EntryStatus::HOLD() } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be($entry_category_change_diff);

    cmp_bag( \@prev_files, \@initial_files, "back to the initial state" );

    # extra test for draft
    my $path = MT::Util::archive_file_for($entry, $site, 'Individual');
    my $file = path(File::Spec->catfile($site->archive_path, $path));
    ok !-f $file, "target file $file is gone";
    $file->parent->mkpath;
    $file->spew("test");
    ok -f $file, "target file exists now";

    $app->post_form_ok( { "category_ids" => "$cat_eraser_id,$cat_compass_id", status => MT::EntryStatus::HOLD() } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    ok -f $file, "target file still exists";
    is $file->slurp => "test", "content of the target file is not changed";

    unlink $file;

    diff_should_be(0);
};

subtest 'create yet yet another new content data' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );

    $app->post_form_ok(
        {   data_label                    => 'yet yet another new content data',
            "date-$cf_date_id"            => '2021-02-01',
            "date-$cf_datetime_id"        => '2021-03-01',
            "time-$cf_datetime_id"        => '12:34:56',
            "category-$cf_same_fruit_id"  => $cat_apple_id,
            "category-$cf_other_fruit_id" => $cat_strawberry_id,
            status                        => MT::ContentStatus::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($content_diff);
};

subtest 'change authored_on of the newly-created content data' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'yet yet another new content data' } );
    my $cd_id = $cd->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
            id              => $cd_id,
        }
    );

    my $date     = make_date();
    my $new_date = make_date(time + ONE_YEAR);
    my $year     = $date->year;
    my $new_year = $new_date->year;

    $app->post_form_ok( { authored_on_date => $new_date->ymd } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    my @current_files = list_files();
    my $diff          = Array::Diff->diff( \@prev_files, \@current_files );
    my @added         = @{ $diff->added };
    my @deleted       = @{ $diff->deleted };
    note explain \@added;
    note explain \@deleted;
    is @added                      => 13, "13 new files are added";
    is grep( /$new_year/, @added ) => 13, "and all of them belong to the new year";
    is @deleted                    => 13, "13 old files are deleted";
    SKIP: {
        skip 'special case', 1 if $special_case;
        is grep( /$year/, @deleted )   => 13, "and all of them belong to the current year";
    }
    push @delta, @added;
    my %deleted_map = map { $_ => 1 } @deleted;
    @delta      = grep !$deleted_map{$_}, @delta;
    @prev_files = @current_files;
    ok !MT::DeleteFileInfo->count, "nothing is left as marked";
};

subtest 'unpublish the newly-created content data (just to restore the initial state)' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'yet yet another new content data' } );
    my $cd_id = $cd->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
            id              => $cd_id,
        }
    );

    $app->post_form_ok( { status => MT::ContentStatus::HOLD() } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be( $content_category_change_diff + 1 );

    cmp_bag( \@prev_files, \@initial_files, "back to the initial state" );

    # extra test for draft
    my $path = MT::Util::archive_file_for($cd, $site, 'ContentType');
    my $file = path(File::Spec->catfile($site->archive_path, $path));
    ok !-f $file, "target file $file is gone";
    $file->parent->mkpath;
    $file->spew("test");
    ok -f $file, "target file exists now";

    my $date     = make_date();
    my $new_date = make_date(time + ONE_YEAR * 2);
    my $year     = $date->year;
    my $new_year = $new_date->year;

    $app->post_form_ok( { authored_on_date => $new_date->ymd, status => MT::ContentStatus::HOLD() } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    ok -f $file, "target file still exists";
    is $file->slurp => "test", "content of the target file is not changed";

    unlink $file;

    diff_should_be(0);
};

subtest 'create yet yet yet another new content data' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );

    $app->post_form_ok(
        {   data_label                    => 'yet yet yet another new content data',
            "date-$cf_date_id"            => '2021-02-01',
            "date-$cf_datetime_id"        => '2021-03-01',
            "time-$cf_datetime_id"        => '12:34:56',
            "category-$cf_same_fruit_id"  => $cat_apple_id,
            "category-$cf_other_fruit_id" => $cat_strawberry_id,
            status                        => MT::ContentStatus::RELEASE(),
        }
    );
    ok !$app->generic_error, "No errors";

    run_rpt_if_async();

    diff_should_be($content_diff);
};

subtest 'change category of the newly-created content data' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'yet yet yet another new content data' } );
    my $cd_id = $cd->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
            id              => $cd_id,
        }
    );

    $app->post_form_ok( { "category-$cf_same_fruit_id" => $cat_peach_id } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    my @current_files = list_files();
    my $diff          = Array::Diff->diff( \@prev_files, \@current_files );
    my @added         = @{ $diff->added };
    my @deleted       = @{ $diff->deleted };
    note explain \@added;
    note explain \@deleted;
    is @added                    => 4, "4 new files are added";
    is grep( /peach/, @added )   => 4, "and all of them belong to the peach category";
    is @deleted                  => 4, "4 old files are deleted";
    is grep( /apple/, @deleted ) => 4, "and all of them belong to the apple category";
    push @delta, @added;
    my %deleted_map = map { $_ => 1 } @deleted;
    @delta      = grep !$deleted_map{$_}, @delta;
    @prev_files = @current_files;
    ok !MT::DeleteFileInfo->count, "nothing is left as marked";
};

subtest 'unpublish the newly-created content data (just to restore the initial state)' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'yet yet yet another new content data' } );
    my $cd_id = $cd->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author1);
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
            id              => $cd_id,
        }
    );

    $app->post_form_ok( { status => MT::ContentStatus::HOLD() } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    diff_should_be( $content_category_change_diff + 1 );

    cmp_bag( \@prev_files, \@initial_files, "back to the initial state" );

    # extra test for draft
    my $path = MT::Util::archive_file_for($cd, $site, 'ContentType');
    my $file = path(File::Spec->catfile($site->archive_path, $path));
    ok !-f $file, "target file $file is gone";
    $file->parent->mkpath;
    $file->spew("test");
    ok -f $file, "target file exists now";

    $app->post_form_ok( { "category-$cf_same_fruit_id" => $cat_orange_id, status => MT::ContentStatus::HOLD() } );

    ok !$app->generic_error, "No errors" or die $app->generic_error;

    run_rpt_if_async();

    ok -f $file, "target file still exists";
    is $file->slurp => "test", "content of the target file is not changed";

    unlink $file;

    diff_should_be(0);
};

subtest 'create yet yet yet yet another new entry by DataAPI' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    $app->api_request_ok(
        POST  => "/v4/sites/$blog_id/entries",
        entry => {
            title  => 'yet yet yet yet another new entry by DataAPI',
            text   => 'body',
            status => 'Publish',
        }
    );

    run_rpt_if_async();

    diff_should_be($entry_diff);
};

subtest 'change authored_on of the newly-created entry by DataAPI' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'yet yet yet yet another new entry by DataAPI' } );
    my $entry_id = $entry->id;

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    my $date     = make_date();
    my $new_date = make_date(time + ONE_YEAR);
    my $year     = $date->year;
    my $new_year = $new_date->year;

    $app->api_request_ok(
        PUT   => "/v4/sites/$blog_id/entries/$entry_id",
        entry => { date => $new_date->ymd },
    );

    run_rpt_if_async();

    my @current_files = list_files();
    my $diff          = Array::Diff->diff( \@prev_files, \@current_files );
    my @added         = @{ $diff->added };
    my @deleted       = @{ $diff->deleted };
    note explain \@added;
    note explain \@deleted;
    is @added                      => 9, "9 new files are added";
    is grep( /$new_year/, @added ) => 9, "and all of them belong to the new year";
    is @deleted                    => 9, "9 old files are deleted";
    SKIP: {
        skip 'special case', 1 if $special_case;
        is grep( /$year/, @deleted )   => 9, "and all of them belong to the current year";
    }
    push @delta, @added;
    my %deleted_map = map { $_ => 1 } @deleted;
    @delta      = grep !$deleted_map{$_}, @delta;
    @prev_files = @current_files;
};

subtest 'unpublish the newly-created entry (just to restore the initial state)' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $entry = MT::Entry->load( { title => 'yet yet yet yet another new entry by DataAPI' } );
    my $entry_id = $entry->id;

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    $app->api_request_ok(
        PUT   => "/v4/sites/$blog_id/entries/$entry_id",
        entry => { status => 'Draft' },
    );

    run_rpt_if_async();

    diff_should_be($entry_category_change_diff);

    cmp_bag( \@prev_files, \@initial_files, "back to the initial state" );

    # extra test for draft
    my $path = MT::Util::archive_file_for($entry, $site, 'Individual');
    my $file = path(File::Spec->catfile($site->archive_path, $path));
    ok !-f $file, "target file $file is gone";
    $file->parent->mkpath;
    $file->spew("test");
    ok -f $file, "target file exists now";

    my $date     = make_date();
    my $new_date = make_date(time + ONE_YEAR * 2);
    my $year     = $date->year;
    my $new_year = $new_date->year;

    $app->api_request_ok(
        PUT   => "/v4/sites/$blog_id/entries/$entry_id",
        entry => { date => $new_date->ymd, status => 'Draft' },
    );

    run_rpt_if_async();

    ok -f $file, "target file still exists";
    is $file->slurp => "test", "content of the target file is not changed";

    unlink $file;

    diff_should_be(0);
};

subtest 'create yet yet yet yet another new content data by DataAPI' => sub {
    $test_env->clear_mt_cache;
    force_cleanup();

    sleep 1;
    MT->publisher->start_time(time);

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    $app->api_request_ok(
        POST         => "/v4/sites/$blog_id/contentTypes/$ct_id/data",
        content_data => {
            label  => 'yet yet yet yet another new content data by DataAPI',
            status => 'Publish',
            data   => [
                { id => $cf_date_id,        data => '2021-02-01' },
                { id => $cf_datetime_id,    data => '2021-03-01' },
                { id => $cf_datetime_id,    data => '12:34:56' },
                { id => $cf_same_fruit_id,  data => [$cat_apple_id] },
                { id => $cf_other_fruit_id, data => [$cat_strawberry_id] },
            ],
        }
    );

    run_rpt_if_async();

    diff_should_be($content_diff);
};

subtest 'change authored_on of the newly-created content data by DataAPI' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'yet yet yet yet another new content data by DataAPI' } );
    my $cd_id = $cd->id;

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    my $date     = make_date();
    my $new_date = make_date(time + ONE_YEAR);
    my $year     = $date->year;
    my $new_year = $new_date->year;

    $app->api_request_ok(
        PUT          => "/v4/sites/$blog_id/contentTypes/$ct_id/data/$cd_id",
        content_data => { date => $new_date->ymd },
    );

    run_rpt_if_async();

    my @current_files = list_files();
    my $diff          = Array::Diff->diff( \@prev_files, \@current_files );
    my @added         = @{ $diff->added };
    my @deleted       = @{ $diff->deleted };
    note explain \@added;
    note explain \@deleted;
    is @added                      => 13, "13 new files are added";
    is grep( /$new_year/, @added ) => 13, "and all of them belong to the new year";
    is @deleted                    => 13, "13 old files are deleted";
    SKIP: {
        skip 'special case', 1 if $special_case;
        is grep( /$year/, @deleted )   => 13, "and all of them belong to the current year";
    }
    push @delta, @added;
    my %deleted_map = map { $_ => 1 } @deleted;
    @delta      = grep !$deleted_map{$_}, @delta;
    @prev_files = @current_files;
    ok !MT::DeleteFileInfo->count, "nothing is left as marked";
};

subtest 'unpublish the newly-created content data (just to restore the initial state)' => sub {
    $test_env->clear_mt_cache;

    sleep 1;
    MT->publisher->start_time(time);

    ok my $cd = MT::ContentData->load( { label => 'yet yet yet yet another new content data by DataAPI' } );
    my $cd_id = $cd->id;

    my $app = MT::Test::App->new('MT::App::DataAPI');
    $app->login($author1);

    $app->api_request_ok(
        PUT          => "/v4/sites/$blog_id/contentTypes/$ct_id/data/$cd_id",
        content_data => { status => 'Draft' },
    );

    run_rpt_if_async();

    diff_should_be( $content_category_change_diff + 1 );

    cmp_bag( \@prev_files, \@initial_files, "back to the initial state" );

    # extra test for draft
    my $path = MT::Util::archive_file_for($cd, $site, 'ContentType');
    my $file = path(File::Spec->catfile($site->archive_path, $path));
    ok !-f $file, "target file $file is gone";
    $file->parent->mkpath;
    $file->spew("test");
    ok -f $file, "target file exists now";

    my $date     = make_date();
    my $new_date = make_date(time + ONE_YEAR * 2);
    my $year     = $date->year;
    my $new_year = $new_date->year;

    $app->api_request_ok(
        PUT          => "/v4/sites/$blog_id/contentTypes/$ct_id/data/$cd_id",
        content_data => { date => $new_date->ymd, status => 'Draft' },
    );

    run_rpt_if_async();

    ok -f $file, "target file still exists";
    is $file->slurp => "test", "content of the target file is not changed";

    unlink $file;

    diff_should_be(0);
};

done_testing;
