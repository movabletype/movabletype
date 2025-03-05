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
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;
use Class::Method::Modifiers;

$test_env->prepare_fixture('db');
my $parent      = MT::Test::Permission->make_website(name => 'parent');
my $child       = MT::Test::Permission->make_blog(parent_id => $parent->id, name => 'child');
my $first_site  = MT->model('blog')->load(1);
my $create_post = MT::Test::Permission->make_role(name => 'Create Post', permissions => "'create_post'");
my $admin       = MT->model('author')->load(1);

my $author1 = MT::Test::Permission->make_author(name => 'author1', nickname => 'author(parent_only)');
MT::Association->link($author1 => $create_post => $parent);

my $author2 = MT::Test::Permission->make_author(name => 'author2', nickname => 'author(child_only)');
MT::Association->link($author2 => $create_post => $child);

my $author3 = MT::Test::Permission->make_author(name => 'author3', nickname => 'author(parent_and_child)');
MT::Association->link($author3 => $create_post => $parent);
MT::Association->link($author3 => $create_post => $child);

my $author4 = MT::Test::Permission->make_author(name => 'author4', nickname => 'author(system_template)');
MT::Association->link($author4 => $create_post => $child);
$author4->can_edit_templates(1);
$author4->save();

subtest 'system context' => sub {
    _test_site_list(context => 0, author => $admin,   expected_sites => [$first_site, $parent, $child]);
    _test_site_list(context => 0, author => $author1, expected_sites => [$parent]);
    _test_site_list(context => 0, author => $author2, expected_sites => [$child]);
    _test_site_list(context => 0, author => $author3, expected_sites => [$parent,     $child]);
    _test_site_list(context => 0, author => $author4, expected_sites => [$first_site, $parent, $child]);
};

subtest 'site context' => sub {
    _test_site_list(context => $parent->id, author => $admin, expected_sites => [$child]);
    # _test_site_list(context => $parent->id, author => $author1, expected_sites => []); # parent_only author can't access to child site list
    _test_site_list(context => $parent->id, author => $author2, expected_sites => [$child]);
    _test_site_list(context => $parent->id, author => $author3, expected_sites => [$child]);
    _test_site_list(context => $parent->id, author => $author4, expected_sites => [$child]);
};

sub _test_site_list {
    my %args         = @_;
    my $blog_id      = $args{context};
    my $author       = $args{author};
    my @expected_ids = map { $_->id } @{ $args{expected_sites} };
    my $app          = MT::Test::App->new('MT::App::CMS');

    subtest $author->nickname => sub {

        $app->login($author);
        $app->get_ok({
            __mode     => 'list',
            _type      => $blog_id ? 'blog' : 'website',
            blog_id    => $blog_id,
            sort_by    => 'id',
            sort_order => 'ascend',
        });

        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => $blog_id ? 'blog' : 'website',
            blog_id    => $blog_id,
            columns    => 'name',
            fid        => '_allpass',
        });
        my $json = $app->json;
        is($json->{result}->{count}, scalar @expected_ids, 'right count');
        is_deeply [map { $_->[0] } @{ $json->{result}->{objects} }], \@expected_ids, 'all ids retrieved';
    };
}

done_testing();
