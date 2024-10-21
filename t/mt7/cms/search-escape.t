#!/usr/bin/perl

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

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::App qw(MT::Test::Role::CMS::Search);
use Test::Deep 'cmp_bag';
use MT::Test::Fixture::SearchReplace;

$test_env->prepare_fixture('search_replace');

my $objs    = MT::Test::Fixture::SearchReplace->load_objs;
my $author  = MT->model('author')->load(1);
my $blog_id = $objs->{blog_id};

subtest 'wildcards in like condition are escaped' => sub {

    my $limit_org = MT->config->CMSSearchLimit;
    $test_env->update_config('CMSSearchLimit', 1);

    my $app   = MT::Test::App->new('MT::App::CMS');
    $app->login($author);

    my @cases = (
        { name => 'underscore (MTC-26724)', titles => ['__',      'test',  'test'] },
        { name => 'percent',                titles => ['100%',    '1000%', '1000%'] },
        { name => 'backslash',              titles => ['b100!%', 'a100%', 'a100%'] },
    );

    for my $case (@cases) {
        subtest $case->{name} => sub {
            my @entries;
            my @titles = @{ $case->{titles} };
            for my $index (0 .. $#titles) {
                push @entries, MT::Test::Permission->make_entry(
                    blog_id     => $blog_id,
                    author_id   => $author->id,
                    title       => $titles[$index],
                    authored_on => '20010101120001' + $index,
                );
            }
            $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
            $app->change_tab('entry');

            $app->search($titles[0], {});
            ok !$app->generic_error, 'no error';
            is_deeply($app->found_titles, [$titles[0]], 'first one is only found');
        };
    }

    $test_env->update_config('CMSSearchLimit', $limit_org);
};

done_testing;
