#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
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

use File::Find ();

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;
use File::Path qw(rmtree);

$test_env->prepare_fixture('db');

my $author = MT::Author->load(1);

my $objs = MT::Test::Fixture->prepare({
    website => [{
            name      => 'site1',
            sith_path => 'TEST_ROOT/site1',
        }, {
            name      => 'site2',
            sith_path => 'TEST_ROOT/site2',
        }
    ],
    content_type => {
        ct => {
            website => 'site1',
            fields  => [
                cf_title => 'single_line_text',
                cf_date  => {
                    type    => 'date_only',
                    options => {
                        required => 'required',
                    },
                },
            ],
        },
        ct2 => {
            website => 'site2',
            fields  => [
                cf_title => 'single_line_text',
                cf_date  => {
                    type    => 'date_only',
                    options => {
                        required => 'required',
                    },
                },
            ],
        },
    },
    content_data => {
        cd1 => {
            website      => 'site1',
            content_type => 'ct',
            authored_on  => '20260101000000',
            data         => {
                cf_title => 'cd1',
                cf_date  => '20160101',
            },
        },
        cd2 => {
            website      => 'site1',
            content_type => 'ct',
            authored_on  => '20250101000000',
            data         => {
                cf_title => 'cd2',
                cf_date  => '20150101',
            },
        },
        cd3 => {
            website      => 'site1',
            content_type => 'ct',
            authored_on  => '20240101000000',
            data         => {
                cf_title => 'cd3',
                cf_date  => '20140101',
            },
        },
        cd4 => {
            website      => 'site1',
            content_type => 'ct',
            authored_on  => '20240102000000',
            data         => {
                cf_title => 'cd4',
                cf_date  => '20140102',
            },
        },
        cd2_1 => {
            website      => 'site2',
            content_type => 'ct2',
            authored_on  => '20260101000000',
            data         => {
                cf_title => 'cd2_1',
                cf_date  => '20160101',
            },
        },
        cd2_2 => {
            website      => 'site2',
            content_type => 'ct2',
            authored_on  => '20250101000000',
            data         => {
                cf_title => 'cd2_2',
                cf_date  => '20150101',
            },
        },
        cd2_3 => {
            website      => 'site2',
            content_type => 'ct2',
            authored_on  => '20240101000000',
            data         => {
                cf_title => 'cd2_3',
                cf_date  => '20140101',
            },
        },
        cd2_4 => {
            website      => 'site2',
            content_type => 'ct2',
            authored_on  => '20240102000000',
            data         => {
                cf_title => 'cd2_4',
                cf_date  => '20140102',
            },
        },
    },
    template => [{
            website      => 'site1',
            archive_type => 'ContentType-Yearly',
            content_type => 'ct',
            text         => '<MTContents glue=","><MTContentField name="cf_title"><MTContentFieldValue></MTContentField></MTContents>',
            mapping      => [{
                file_template => 'site1/archive/%y/index.html',
            }],
        }, {
            website      => 'site2',
            archive_type => 'ContentType-Yearly',
            content_type => 'ct2',
            text         => '<MTContents glue=","><MTContentField name="cf_title"><MTContentFieldValue></MTContentField></MTContents>',
            mapping      => [{
                file_template => 'site2/archive/%y/index.html',
                dt_field      => 'cf_date',
            }],
        }
    ],
});

subtest 'Yearly, authored_on' => sub {

    my $blog_id = $objs->{website}{site1}->id;
    my $ct      = $objs->{content_type}{ct}{content_type};
    my $cd      = $objs->{content_data}{cd3};

    MT->publisher->rebuild(BlogID => $blog_id);

    my %texts;
    for my $year (2024 .. 2026) {
        my $file = $test_env->path("site1/archive/$year/index.html");
        ok -f $file, "archive for $year exists";
        $texts{$year} = $test_env->slurp($file);
    }
    note explain \%texts;

    my $app = MT::Test::App->new;
    $app->login($author);
    my $res = $app->get({
        __mode  => 'dashboard',
        blog_id => $blog_id,
    });
    ok !$app->generic_error, "list has no generic error";

    my $link = $app->wq_find('li#menu-content_data div ul li a')->first;
    my $uri  = URI->new($link->attr('href'));
    ok $uri, "link to the list_content_data is found: $uri";

    my $query_param = $uri->query_form_hash;
    $res = $app->get($query_param);
    ok !$app->generic_error, "list has no generic error";

    $res = $app->post({
        %$query_param,
        __mode          => 'itemset_action',
        action_name     => 'delete',
        id              => $cd->id,
        content_type_id => $ct->id,
        return_args     => $uri->query,
    });
    like $app->message_text => qr/The content data has been deleted from the database/, "successfully deleted";
    ok !$app->generic_error, "delete has no generic error";

    for my $year (2024 .. 2026) {
        my $file = $test_env->path("site1/archive/$year/index.html");
        ok -f $file, "archive for $year still exists";
        my $new_text = $test_env->slurp($file);
        if ($year == 2024) {
            isnt $new_text => $texts{$year}, "archive for $year is modified";
            is $new_text => 'cd4', "cd3 is removed from 2024 archive";
        } else {
            is $new_text => $texts{$year}, "archive for $year is not modified";
        }
    }
};

subtest 'Yearly, cf_date' => sub {
    my $blog_id = $objs->{website}{site2}->id;
    my $ct      = $objs->{content_type}{ct2}{content_type};
    my $cd      = $objs->{content_data}{cd2_3};

    MT->publisher->rebuild(BlogID => $blog_id);

    my %texts;
    for my $year (2014 .. 2016) {
        my $file = $test_env->path("site2/archive/$year/index.html");
        ok -f $file, "archive for $year exists";
        $texts{$year} = $test_env->slurp($file);
    }
    note explain \%texts;

    my $app = MT::Test::App->new;
    $app->login($author);
    my $res = $app->get({
        __mode  => 'dashboard',
        blog_id => $blog_id,
    });
    ok !$app->generic_error, "list has no generic error";

    my $link = $app->wq_find('li#menu-content_data div ul li a')->first;
    my $uri  = URI->new($link->attr('href'));
    ok $uri, "link to the list_content_data is found: $uri";

    my $query_param = $uri->query_form_hash;
    $res = $app->get($query_param);
    ok !$app->generic_error, "list has no generic error";

    $res = $app->post({
        %$query_param,
        __mode          => 'itemset_action',
        action_name     => 'delete',
        id              => $cd->id,
        content_type_id => $ct->id,
        return_args     => $uri->query,
    });
    like $app->message_text => qr/The content data has been deleted from the database/, "successfully deleted";
    ok !$app->generic_error, "delete has no generic error";

    for my $year (2014 .. 2016) {
        my $file = $test_env->path("site2/archive/$year/index.html");
        ok -f $file, "archive for $year still exists";
        my $new_text = $test_env->slurp($file);
        if ($year == 2014) {
            isnt $new_text => $texts{$year}, "archive for $year is modified";
            is $new_text => 'cd2_4', "cd2_3 is removed from 2014 archive";
        } else {
            is $new_text => $texts{$year}, "archive for $year is not modified";
        }
    }
};

done_testing;
