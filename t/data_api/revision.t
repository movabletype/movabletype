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

$test_env->prepare_fixture('db');

use MT::Test::App;
use MT::App::DataAPI;
use MT::Test::Fixture;
use JSON;

$test_env->prepare_fixture('db');

my $admin   = MT::Author->load(1);
my $site    = MT::Website->load(1);
my $site_id = $site->id;
$site->site_path($test_env->root);
$site->save;

my $objs = MT::Test::Fixture->prepare({
    content_type => {
        ct => [
            cf_single_line_text => {
                type => 'single_line_text',
                name => 'single line text',
            },
        ],
    },
    blog_id => $site->id,
});
my $ct    = $objs->{content_type}{ct}{content_type};
my $ct_id = $ct->id;

my $max_version = MT::App::DataAPI->DEFAULT_VERSION;

for my $extra ({}, {save_revision => 1}, {saveRevision => 1}, {save_revision => 0}, {saveRevision => 0}) {
    subtest 'entry' => sub {
    VERSION:
        for my $version (1 .. $max_version) {
            my $moniker = _moniker($version, $extra);

            MT->model('entry:revision')->remove;
            my $app = MT::Test::App->new('DataAPI');
            $app->login($admin);
            my $entry = {
                title => 'Title',
            };
            my $entry_id;
            {
                $test_env->clear_mt_cache;
                my $res = $app->post({ __path_info => "/v$version/sites/$site_id/entries", entry => encode_json($entry), %$extra });
                next VERSION if $res->code == 404;
                $entry_id = decode_json($res->decoded_content)->{id};
                my @revisions = MT->model('entry:revision')->load;
                if ($moniker =~ /0$/) {
                    ok !@revisions, "has no revision ($moniker)";
                } else {
                    ok @revisions == 1, "has a revision ($moniker)";
                }
            }

            {
                $test_env->clear_mt_cache;
                $entry->{title} = 'Modified Title';
                my $res = $app->put({ __path_info => "/v$version/sites/$site_id/entries/$entry_id", entry => encode_json($entry), %$extra });
                next VERSION if $res->code == 404;
                my @revisions = MT->model('entry:revision')->load;
                if ($moniker =~ /0$/) {
                    ok !@revisions, "has no revision ($moniker)";
                } else {
                    ok @revisions == 2, "has a new revision ($moniker)";
                }
            }
        }
    };

    subtest 'page' => sub {
    VERSION:
        for my $version (1 .. $max_version) {
            my $moniker = _moniker($version, $extra);

            MT->model('page:revision')->remove;
            my $app = MT::Test::App->new('DataAPI');
            $app->login($admin);
            my $page = {
                title => 'Title',
            };
            my $page_id;
            {
                $test_env->clear_mt_cache;
                my $res = $app->post({ __path_info => "/v$version/sites/$site_id/pages", page => encode_json($page), %$extra });
                next VERSION if $res->code == 404;
                $page_id = decode_json($res->decoded_content)->{id};
                my @revisions = MT->model('page:revision')->load;
                if ($moniker =~ /0$/) {
                    ok !@revisions, "has no revision ($moniker)";
                } else {
                    ok @revisions == 1, "has a revision ($moniker)";
                }
            }

            {
                $test_env->clear_mt_cache;
                $page->{title} = 'Modified Title';
                my $res = $app->put({ __path_info => "/v$version/sites/$site_id/pages/$page_id", page => encode_json($page), %$extra });
                next VERSION if $res->code == 404;
                my @revisions = MT->model('page:revision')->load;
                if ($moniker =~ /0$/) {
                    ok !@revisions, "has no revision ($moniker)";
                } else {
                    ok @revisions == 2, "has a new revision ($moniker)";
                }
            }
        }
    };

    subtest 'template' => sub {
    VERSION:
        for my $version (1 .. $max_version) {
            my $moniker = _moniker($version, $extra);

            MT->model('template:revision')->remove;
            my $app = MT::Test::App->new('DataAPI');
            $app->login($admin);
            my $template = {
                name => "Test Template $moniker",
                type => 'custom',
            };
            my $template_id;
            {
                $test_env->clear_mt_cache;
                my $res = $app->post({ __path_info => "/v$version/sites/$site_id/templates", template => encode_json($template), %$extra });
                next VERSION if $res->code == 404;
                $template_id = decode_json($res->decoded_content)->{id};
                my @revisions = MT->model('template:revision')->load;
                if ($moniker =~ /0$/) {
                    ok !@revisions, "has no revision ($moniker)";
                } else {
                    ok @revisions == 1, "has a revision ($moniker)";
                }
            }

            {
                $test_env->clear_mt_cache;
                $template->{name} = "Modified Test Template $moniker";
                my $res = $app->put({ __path_info => "/v$version/sites/$site_id/templates/$template_id", template => encode_json($template), %$extra });
                next VERSION if $res->code == 404;
                my @revisions = MT->model('template:revision')->load;
                if ($moniker =~ /0$/) {
                    ok !@revisions, "has no revision ($moniker)";
                } else {
                    ok @revisions == 2, "has a new revision ($moniker)";
                }
            }
        }
    };

    subtest 'content data' => sub {
    VERSION:
        for my $version (1 .. $max_version) {
            my $moniker = _moniker($version, $extra);

            MT->model('cd:revision')->remove;
            my $app = MT::Test::App->new('DataAPI');
            $app->login($admin);
            my $cd = {
                label => "cd $version",
            };
            my $cd_id;
            {
                $test_env->clear_mt_cache;
                my $res = $app->post({ __path_info => "/v$version/sites/$site_id/contentTypes/$ct_id/data", content_data => encode_json($cd), %$extra });
                next VERSION if $res->code == 404;
                $cd_id = decode_json($res->decoded_content)->{id};
                my @revisions = MT->model('cd:revision')->load;
                if ($moniker =~ /0$/) {
                    ok !@revisions, "has no revision ($moniker)";
                } else {
                    ok @revisions == 1, "has a revision ($moniker)";
                }
            }

            {
                $test_env->clear_mt_cache;
                $cd->{label} = "Modified cd $version";
                my $res = $app->put({ __path_info => "/v$version/sites/$site_id/contentTypes/$ct_id/data/$cd_id", content_data => encode_json($cd), %$extra });
                next VERSION if $res->code == 404;
                my @revisions = MT->model('cd:revision')->load;
                if ($moniker =~ /0$/) {
                    ok !@revisions, "has no revision ($moniker)";
                } else {
                    ok @revisions == 2, "has a new revision ($moniker)";
                }
            }
        }
    };
}

done_testing;

sub _moniker {
    my ($version, $extra) = @_;
    my $moniker = "version $version";
    if (%$extra) {
        $moniker .= ", " . join "=", %$extra;
    }
    $moniker;
}
