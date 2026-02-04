use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;
use File::Spec;
use utf8;

$test_env->prepare_fixture('db');

my $site_path    = File::Spec->catdir($test_env->root, 'site');
my $archive_path = File::Spec->catdir($test_env->root, 'site/archive');

mkdir $site_path;
mkdir $archive_path;

my $objs = MT::Test::Fixture->prepare({
    author => [qw/author/],
    website => [{
        name                  => 'my_site',
        theme_id              => 'mont-blanc',
        site_path             => $site_path,
        archive_path          => $archive_path,
        publish_empty_archive => 1,
    }],
    category_set => {
        catset_type => [qw/news topic/],
        catset_year => [qw/2015 2016 2017 2018 2019 2020/],
    },
    content_type => {
        ct => [
            cf_title => 'single_line_text',
            cf_category_year => {
                type         => 'categories',
                category_set => 'catset_year',
                options      => { multiple => 1 },
            },
        ],
    },
    content_data => {
        (map {
            ("cd$_" => {
                content_type => 'ct',
                author       => 'author',
                authored_on  => '20200202000000',
                label        => "cd$_",
                identifier   => "cd$_",
                status       => 'publish',
                data         => {
                    cf_title => "cd$_",
                    cf_category_year => [2020, 2015 + $_ % 5],
                },
            })
        } 1..9),
    },
    template => [{
            archive_type => 'ContentType-Category',
            name         => 'tmpl_ct',
            content_type => 'ct',
            text         => <<'TMPL',
<mt:Contents limit="5"><mt:ContentField content_field="cf_title"><mt:ContentFieldValue></mt:ContentField>
</mt:Contents>
TMPL
            mapping      => [{
                file_template => '%-c/%i',
                cat_field     => 'cf_category_year',
                is_preferred  => 1,
            }],
        },
    ],
});

$test_env->clear_mt_cache;

my $admin = MT::Author->load(1);
my $site  = $objs->{website}{my_site};
my $ct    = $objs->{content_type}{ct}{content_type};
my $cd    = $objs->{content_data}{cd1};

MT->publisher->rebuild(BlogID => $site->id);

my ($file) = grep /2020/, $test_env->files;
my $html = do { open my $fh, '<', $file; local $/; <$fh> };
$html =~ s/[\r\n]+/\n/gs;
chomp $html;
is $html => join("\n", qw(cd1 cd2 cd3 cd4 cd5)), "limited correctly";

done_testing;