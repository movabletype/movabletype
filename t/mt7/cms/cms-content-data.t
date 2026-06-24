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

subtest 'listing sorting by various content field types' => sub {

    my %test_cases = (
        content_type     => { test_as_label => 1, mock => sub { $_[0] } },
        single_line_text => { test_as_label => 1, mock => sub { 'test' . $_[0] } },
        multi_line_text  => { test_as_label => 1, mock => sub { 'test' . $_[0] } },
        number           => { test_as_label => 1, mock => sub { $_[0] } },
        url              => { test_as_label => 1, mock => sub { qq{http://example.com/} . $_[0] } },
        date_and_time    => { test_as_label => 0, mock => sub { sprintf('2026121212%02d',   $_[0]) } },
        date_only        => { test_as_label => 0, mock => sub { sprintf('202612%02d',       $_[0]) } },
        time_only        => { test_as_label => 0, mock => sub { sprintf('197001011234%02d', $_[0]) } },
        select_box       => { test_as_label => 0, mock => sub { [$_[0], 999999 + $_[0]] } },
        radio_button     => { test_as_label => 0, mock => sub { [$_[0]] } },
        checkboxes       => { test_as_label => 0, mock => sub { [$_[0]] } },
        asset            => { test_as_label => 0, mock => sub { [$_[0]] } },
        asset_audio      => { test_as_label => 0, mock => sub { [$_[0]] } },
        asset_video      => { test_as_label => 0, mock => sub { [$_[0]] } },
        asset_image      => { test_as_label => 0, mock => sub { [$_[0]] } },
        embedded_text    => { test_as_label => 0, mock => sub { 'test' . $_[0] } },
        categories       => { test_as_label => 0, mock => sub { [$_[0]] } },
        tags             => { test_as_label => 0, mock => sub { [$_[0]] } },
        list             => { test_as_label => 0, mock => sub { [$_[0], $_[0], 999999 + $_[0]] } },
        tables           => { test_as_label => 0, mock => sub { '<table>' . $_[0] . '</table>' } },
        # text_label       => { mock => sub { $_[0] } },
    );

    for my $type (sort keys %test_cases) {

        subtest 'type:' . $type => sub {
            my $site = MT::Test::Permission->make_website(name => 'my site with type:' . $type);
            my $ct   = MT::Test::Permission->make_content_type(blog_id => $site->id, name => 'sort_by');
            my $cf1  = MT::Test::Permission->make_content_field(
                blog_id         => $site->id,
                content_type_id => $ct->id,
                type            => $type,
                name            => 'my_text1',
            );
            my $cf2 = MT::Test::Permission->make_content_field(
                blog_id         => $site->id,
                content_type_id => $ct->id,
                type            => $type,
                name            => 'my_text2',
            );
            $ct->fields([{
                    id        => $cf1->id,
                    order     => 1,
                    type      => $cf1->type,
                    label     => 1,
                    name      => $cf1->name,
                    unique_id => $cf1->unique_id,
                    options => {
                        display  => 'force',
                        hint     => '',
                        label    => 1,
                        required => 1,
                    },
                }, {
                    id        => $cf2->id,
                    order     => 1,
                    type      => $cf2->type,
                    label     => 1,
                    name      => $cf2->name,
                    unique_id => $cf2->unique_id,
                    options => {
                        display  => 'force',
                        hint     => '',
                        label    => 1,
                        required => 1,
                    },
                }]);

            $ct->data_label($cf2->unique_id) if $test_cases{$type}{test_as_label};
            $ct->save;

            require MT::CMS::ContentType;
            MT::CMS::ContentType::init_content_type(sub { die }, MT->instance);

            my @cds;
            my $number_of_cd = 10;

            for my $num (1 .. $number_of_cd) {
                require Digest::MD5;
                my $cf_data = $test_cases{$type}{mock}->($num);
                push @cds, MT::Test::Permission->make_content_data(
                    blog_id         => $site->id,
                    content_type_id => $ct->id,
                    label           => Digest::MD5::md5_hex($num) . ':' . $num,
                    data            => { $cf1->id => $cf_data, $cf2->id => $cf_data },
                );
            }

            local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
            my $app = MT::Test::App->new;
            $app->login($admin);

            my %result_ids;
            for my $order ('ascend', 'descend') {
                subtest 'sort order: ' . $order => sub {
                    my $res1 = $app->post_ok({
                        blog_id    => $site->id,
                        __mode     => 'filtered_list',
                        datasource => 'content_data.content_data_' . $ct->id,
                        columns    => 'label',
                        limit      => 50,
                        fid        => '_allpass',
                        'items'    => "[]",
                        sort_by    => 'content_field_' . $cf1->id,
                        sort_order => $order,
                    });

                    my $json1 = MT::Util::from_json($res1->decoded_content);
                    is $json1->{result}{count}, $number_of_cd, 'got right number of content data';
                    is(scalar @{$json1->{result}{objects}}, $number_of_cd, 'got right number of content data');

                    my @ordered_labels1 = map { $_->[0] } @{ $json1->{result}{objects} };
                    note 'ordered ids: ' . join(', ', @ordered_labels1);
                    $result_ids{$order} = \@ordered_labels1;

                    if ($test_cases{$type}{test_as_label}) {
                        subtest 'as a data_label' => sub {
                            my $res2 = $app->post_ok({
                                blog_id    => $site->id,
                                __mode     => 'filtered_list',
                                datasource => 'content_data.content_data_' . $ct->id,
                                columns    => 'label',
                                limit      => 50,
                                fid        => '_allpass',
                                'items'    => "[]",
                                sort_by    => 'label',
                                sort_order => $order,
                            });
                            my $json2 = MT::Util::from_json($res2->decoded_content);
                            is $json2->{result}{count}, $number_of_cd, 'got right number of content data';
                            is(scalar @{$json2->{result}{objects}}, $number_of_cd, 'got right number of content data');

                            my @ordered_labels2 = map { $_->[0] } @{ $json2->{result}{objects} };
                            is_deeply(\@ordered_labels1, \@ordered_labels2, 'same order');
                        };
                    }
                };
            }

            is_deeply $result_ids{ascend}, [reverse(@{ $result_ids{descend} })], 'descend is opposite to ascend';

            $site->remove;
        }
    }
};

done_testing;
