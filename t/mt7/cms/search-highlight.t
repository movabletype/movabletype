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
my $ct_id   = $objs->{content_type}{ct_multi}{content_type}->id;

subtest 'various fields' => sub {
    my $cfs = $objs->{content_type}{ct_multi}{content_field};

    my $cd = MT::Test::Permission->make_content_data(
        authored_on     => '20230612223059',
        blog_id         => $blog_id,
        content_type_id => $ct_id,
        identifier      => "xyz",
        label           => "xyz",
        data            => {
            $cfs->{cf_single_line_text}->id => "xyz xyz",
            $cfs->{cf_multi_line_text}->id  => "xyz\nxyz",
            $cfs->{cf_number}->id           => '9992598785499925987854',
            $cfs->{cf_url}->id              => 'https://example.jp/xyz/xyz',
            $cfs->{cf_embedded_text}->id    => 'xyz \n xyz',
            $cfs->{cf_select_box}->id       => [1,             1,              2],
            $cfs->{cf_radio}->id            => [2,             2,              3],
            $cfs->{cf_checkboxes}->id       => [3,             3,              1],
            $cfs->{cf_list}->id             => ['xyz', 'xyz2', 'unknown'],
            $cfs->{cf_tags}->id             => [
                MT::Test::Permission->make_tag(name => 'xyz1')->id,
                MT::Test::Permission->make_tag(name => 'xyz2')->id,
            ],
            $cfs->{cf_categories}->id       => [
                MT::Test::Permission->make_category(label => 'xyz1')->id,
                MT::Test::Permission->make_category(label => 'xyz2')->id,
            ],
            $cfs->{cf_image}->id            => [ $objs->{image}->{'test2.jpg'}->id ],
        },
    );

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
    $app->change_tab('content_data');
    $app->change_content_type($ct_id);

    subtest 'all fields' => sub {
        $app->search(
            'xyz', {
                is_dateranged      => 1,
                date_time_field_id => 0,
                from               => '20230612223059',
                to                 => '20230612223100',
            });
        is $app->found_highlighted_count, 16;
    };

    $app->search('xyz', { is_limited => 1, search_cols => ['label'] });
    is $app->found_highlighted_count, 1;
    $app->search('xyz', { search_cols => ['identifier'] });
    is $app->found_highlighted_count, 1;
    $app->search('xyz', { search_cols => ['__field:' . $cfs->{cf_single_line_text}->id] });
    is $app->found_highlighted_count, 2;
    $app->search('xyz', { search_cols => ['__field:' . $cfs->{cf_multi_line_text}->id] });
    is $app->found_highlighted_count, 2;
    $app->search('25987854', { search_cols => ['__field:' . $cfs->{cf_number}->id] });
    is $app->found_highlighted_count, 2;
    $app->search('xyz', { search_cols => ['__field:' . $cfs->{cf_url}->id] });
    is $app->found_highlighted_count, 2;
    $app->search('xyz', { search_cols => ['__field:' . $cfs->{cf_embedded_text}->id] });
    is $app->found_highlighted_count, 2;
    $app->search('abc', { search_cols => ['__field:' . $cfs->{cf_select_box}->id] });
    is $app->found_highlighted_count, 2;
    $app->search('def', { search_cols => ['__field:' . $cfs->{cf_radio}->id] });
    is $app->found_highlighted_count, 2;
    $app->search('ghi', { search_cols => ['__field:' . $cfs->{cf_checkboxes}->id] });
    is $app->found_highlighted_count, 2;
    $app->search('xyz', { search_cols => ['__field:' . $cfs->{cf_list}->id] });
    is $app->found_highlighted_count, 2;
    $app->search('xyz', { search_cols => ['__field:' . $cfs->{cf_tags}->id] });
    is $app->found_highlighted_count, 2;
    $app->search('xyz', { search_cols => ['__field:' . $cfs->{cf_categories}->id] });
    is $app->found_highlighted_count, 2;
    $app->search('Sample Image', { search_cols => ['__field:' . $cfs->{cf_image}->id] });
    is $app->found_highlighted_count, 1;
};

done_testing;
