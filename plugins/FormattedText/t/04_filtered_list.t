#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
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

$test_env->prepare_fixture('db_data');

my $admin = MT::Author->load(1);

my $website = MT->model('website')->load(1);
$website->set_values({ name => 'First Website', });
$website->save or die $website->errstr;

my $blog = MT::Test::Permission->make_blog(
    name      => 'First Blog',
    parent_id => $website->id,
);

my $ft = MT->model('formatted_text')->new;
$ft->set_values({
    blog_id     => $blog->id,
    label       => 'Blog Boilerplate',
    description => 'Description',
});
$ft->save or die $ft->errstr;

my $website_ft = MT->model('formatted_text')->new;
$website_ft->set_values({
    blog_id     => $website->id,
    label       => 'Website Boilerplate',
    description => 'Description',
});
$website_ft->save or die $website_ft->errstr;

subtest 'Filtered list scope' => sub {
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';

    my @scope_suite = (
        {
            name   => 'system',
            params => { blog_id => 0 },
        },
        {
            name   => 'no blog_id',
            params => {},
        },
        {
            name        => 'website',
            params      => { blog_id => $website->id },
            label       => $website_ft->label,
            other_label => $ft->label,
        },
        {
            name        => 'blog',
            params      => { blog_id => $blog->id },
            label       => $ft->label,
            other_label => $website_ft->label,
        },
    );

    foreach my $scope (@scope_suite) {
        subtest $scope->{name} => sub {
            my $app = MT::Test::App->new;
            $app->login($admin);
            $app->post_ok({
                __mode     => 'filtered_list',
                datasource => 'formatted_text',
                columns    => 'label',
                fid        => '_allpass',
                %{ $scope->{params} },
            });

            if ($scope->{label}) {
                is $app->json_error, '', 'The filtered list is accessible';
                $app->content_like(
                    qr/\Q$scope->{label}\E/,
                    'The boilerplate in this scope is returned'
                );
                $app->content_unlike(
                    qr/\Q$scope->{other_label}\E/,
                    'A boilerplate in another scope is not returned'
                );
            } else {
                is $app->json_error, 'Invalid request',
                    'The filtered list is rejected';
                $app->content_unlike(
                    qr/Blog Boilerplate|Website Boilerplate/,
                    'No boilerplates are returned'
                );
            }
        };
    }
};

done_testing;
