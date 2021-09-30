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
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(name => 'my website',);

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'my blog',
    );

    my $blog_id = $blog->id;

    # Preview
    my $ct_without_archive = MT::Test::Permission->make_content_type(
        blog_id => $blog_id,
        name    => 'ct without ct archive',
    );

    my $ct_with_archive = MT::Test::Permission->make_content_type(
        blog_id => $blog_id,
        name    => 'ct with ct archive',
    );
    my $ct_archive = MT::Test::Permission->make_template(
        blog_id         => $ct_with_archive->blog_id,
        content_type_id => $ct_with_archive->id,
        name            => 'Content Type with content_type archive',
        type            => 'ct',
    );
    MT::Test::Permission->make_templatemap(
        blog_id       => $ct_archive->blog_id,
        template_id   => $ct_archive->id,
        archive_type  => 'ContentType',
        file_template => 'author/%-a/%-f',
        is_preferred  => 1,
    );

    # List
    my @tags;
    for my $name ('foo', 'bar', 'baz') {
        my $tag = MT::Test::Permission->make_tag(name => $name);
        push @tags, $tag;
    }

    my $content_type = MT::Test::Permission->make_content_type(
        blog_id => $blog_id,
        name    => 'test ct',
    );
    my $tags_field = MT::Test::Permission->make_content_field(
        blog_id         => $blog_id,
        content_type_id => $content_type->id,
        type            => 'tags',
    );
    $content_type->fields([{
        id      => $tags_field->id,
        order   => 1,
        type    => $tags_field->type,
        options => {
            label    => $tags_field->name,
            multiple => 1,
        },
        unique_id => $tags_field->unique_id,
    }]);
    $content_type->save or die $content_type->errstr;

    my $content_data = MT::Test::Permission->make_content_data(
        blog_id         => $blog_id,
        content_type_id => $content_type->id,
        label           => 'test cd',
        data            => { $tags_field->id => [map { $_->id } @tags] },
    );
});

# clear cache in MT::ContentType->load_all
MT->request->reset;

my $admin              = MT->model('author')->load(1) or die MT->model('author')->errstr;
my $ct_without_archive = MT->model('content_type')->load({ name => 'ct without ct archive' });
my $ct_with_archive    = MT->model('content_type')->load({ name => 'ct with ct archive' });
my $content_type       = MT->model('content_type')->load({ name => 'test ct' });

subtest 'preview without content_type archive' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode          => 'preview_content_data',
        _type           => 'content_data',
        blog_id         => $ct_without_archive->blog_id,
        content_type_id => $ct_without_archive->id,
    });

    ok(!$app->generic_error, 'No error occurred');
};

subtest 'preview with content_type archive' => sub {
    my $app = MT::Test::App->new(app_class => 'MT::App::CMS', no_redirect => 1);
    $app->login($admin);
    my $res = $app->post_ok({
        __mode          => 'preview_content_data',
        _type           => 'content_data',
        blog_id         => $ct_with_archive->blog_id,
        content_type_id => $ct_with_archive->id,
    });

    ok($res->is_redirect, 'Redirected');
    ok !$app->last_location->query_param('permission');
    ok !$app->last_location->query_param('dashboard');
    ok(!$app->generic_error, 'No error occurred');
};

subtest 'listing with tags_field filter' => sub {
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    my $res = $app->post_ok({
        'blog_id'    => $content_type->blog_id,
        '__mode'     => 'filtered_list',
        'datasource' => 'content_data.content_data_' . $content_type->id,
        'columns'    => 'label',
        'items'      => '"[{\\"args\\":{\\"string\\":\\"foo\\",\\"option\\":\\"equal\\"},\\"type\\":\\"tags_field\\"}]"'
    });

    my $json = MT::Util::from_json($res->decoded_content);
    ok($json->{result}{count} == 1, 'match filter: count = 1');
    like(
        $json->{result}{objects}[0][1],
        qr/test cd/, 'match filter: keyword is included'
    );

    $res = $app->post_ok({
        'blog_id'    => $content_type->blog_id,
        '__mode'     => 'filtered_list',
        'datasource' => 'content_data.content_data_' . $content_type->id,
        'columns'    => 'label',
        'items'      => '"[{\\"args\\":{\\"string\\":\\"gagaga\\",\\"option\\":\\"equal\\"},\\"type\\":\\"tags_field\\"}]"'
    });

    $json = MT::Util::from_json($res->decoded_content);
    ok($json->{result}{count} == 0, 'unmatch filter: count = 0');
    unlike(
        $json->{result}{objects}[0][1],
        qr/test cd/, 'unmatch filter: keyword is not included'
    );
};

# https://movabletype.atlassian.net/browse/MTC-26597
subtest 'remove content_data related to invalid content_field from' => sub {
    my $blog_id   = $content_type->blog_id;
    my $remove_ct = MT::Test::Permission->make_content_type(
        blog_id => $blog_id,
        name    => 'content type to be removed',
    );
    MT::Test::Permission->make_content_field(
        blog_id                 => $blog_id,
        content_type_id         => undef,
        name                    => 'missing content field',
        related_content_type_id => $remove_ct->id,
        type                    => 'content_type',
    );

    my $return_args         = "__mode=list&blog_id=$blog_id&_type=content_type&does_act=1";
    my $encoded_return_args = quotemeta $return_args;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode      => 'itemset_action',
        _type       => 'content_type',
        action_name => 'delete',
        blog_id     => $blog_id,
        return_args => $return_args,
        id          => $remove_ct->id,
    });

    ok !$app->generic_error, 'no error message is showed';
    is(
        MT->model('content_type')->load($remove_ct->id),
        undef, 'content_type has been removed'
    );
};

done_testing;

