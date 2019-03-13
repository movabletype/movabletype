#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use Test::Mock::Guard qw/mock_guard/;
use MT::Test::Env;
use MT::App;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PreviewInNewWindow => 0,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

$test_env->prepare_fixture('db');
my $cant_do1 = MT::Test::Permission->make_author(
    email        => 'test@example.com',
    url          => 'http://example.com/',
    api_password => 'cant_do1',
    auth_type    => 'MT',
    created_on   => '19780131074500',
    type         => MT::Author::AUTHOR(),
    is_superuser => 0,
    name         => 'cant_do1'
);
my $cant_do2 = MT::Test::Permission->make_author(
    email        => 'test@example.com',
    url          => 'http://example.com/',
    api_password => 'cant_do2',
    auth_type    => 'MT',
    created_on   => '19780131074500',
    type         => MT::Author::AUTHOR(),
    is_superuser => 0,
    name         => 'cant_do2'
);

my $can_do1 = MT::Test::Permission->make_author(
    email        => 'test@example.com',
    url          => 'http://example.com/',
    api_password => 'can_do1',
    auth_type    => 'MT',
    created_on   => '19780131074500',
    type         => MT::Author::AUTHOR(),
    is_superuser => 0,
    name         => 'can_do1'
);

my $can_do2 = MT::Test::Permission->make_author(
    email        => 'test@example.com',
    url          => 'http://example.com/',
    api_password => 'can_do2',
    auth_type    => 'MT',
    created_on   => '19780131074500',
    type         => MT::Author::AUTHOR(),
    is_superuser => 0,
    name         => 'can_do2'
);

my $blog_id = 1;
my $blog = MT::Blog->load($blog_id);
my $blog2 = MT::Test::Permission->make_blog(name => 'blog 2');

my $admin = MT::Author->load(1);

# Content
my $content_type
    = MT::Test::Permission->make_content_type(blog_id => $blog_id);
my $content_type2
    = MT::Test::Permission->make_content_type(blog_id => $blog2->id);
my $cf = MT::Test::Permission->make_content_field(
    blog_id         => 1,
    content_type_id => $content_type->id,
);

my $cf_multi = MT::Test::Permission->make_content_field(
    blog_id         => 1,
    content_type_id => $content_type->id,
    name            => 'multi',
    type            => 'multi_line_text',
    description     => 'This is a sample multi_line_text field.',
);

my $cf2 = MT::Test::Permission->make_content_field(
    blog_id         => $blog2->id,
    content_type_id => $content_type2->id,
);

$content_type->fields(
    [
        {
            id        => $cf->id,
            name      => $cf->name,
            options   => { label => $cf->name, },
            order     => 1,
            type      => $cf->type,
            unique_id => $cf->unique_id,
        },
        {
            id        => $cf_multi->id,
            name      => $cf_multi->name,
            options   => { label => $cf_multi->name, },
            order     => 1,
            type      => $cf_multi->type,
            unique_id => $cf_multi->unique_id,
        },
    ]
);

$content_type->save or die $content_type->errstr;

$content_type2->fields(
    [
        {
            id        => $cf2->id,
            name      => $cf2->name,
            options   => { label => $cf2->name, },
            order     => 1,
            type      => $cf2->type,
            unique_id => $cf2->unique_id,
        },
    ]
);

$content_type2->save or die $content_type2->errstr;

my $cd1 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $content_type->id,
    label           => 'label',
    data            => { $cf->id => 'multi line text test' },
    identifier      => 'my content data',
    status          => MT::ContentStatus::RELEASE(),
);

my $create_role1 = MT::Test::Permission->make_role(
    name        => 'edit_content_data role1',
    permissions => "'edit_all_content_data'",
);

my $permission_edit = 'edit_all_content_data:' . $cd1->unique_id;
my $create_role2 = MT::Test::Permission->make_role(
    name        => 'edit_content_data role1',
    permissions => "'${permission_edit}'",
);

my $permission_create = 'edit_all_content_data:' . $cd1->unique_id;
my $create_role3 = MT::Test::Permission->make_role(
    name        => 'create_new_content_data role1',
    permissions => "'create_new_content_data'",
);

my $create_role4 = MT::Test::Permission->make_role(
    name        => 'create_new_content_data role2',
    permissions => "'${permission_create}'",
);

MT::Association->link($cant_do1 => $create_role1 => $blog);
MT::Association->link($cant_do2 => $create_role2 => $blog);
MT::Association->link($can_do1 => $create_role3 => $blog);
MT::Association->link($can_do2 => $create_role4 => $blog);

MT->add_callback(
    'cms_edit',
    1, undef,
    sub {
        my ($cb, $app, $obj, $data) = @_;
        if (my $class = ref($obj)) {
            my $ds = $class->datasource;
            my $data;
            $data = MT->model($ds)->load($obj->id);
            my $saved = $data->save;
            ok($saved,
                "saving $class succeeded in callback");
            warn $data->errstr unless $saved;
        }
    }
);

my ($app, $out);

subtest 'There is no parameter $app->blog (unset)' => sub {
    my $ref_parameter = {
        __test_user      => $admin,
        __request_method => 'GET',
        __mode           => 'view_content_data',
        content_type_id  => $content_type->id,
    };
    $app = _run_app('MT::App::CMS', $ref_parameter);
    $out = delete $app->{__test_output};

    ok($out =~ m/Status: 302 Found/, 'status is 302 Found.');
    ok($app->{'redirect'} =~ /__mode=dashboard&redirect=1/, 'redirect url is dashboard.');
};

subtest 'There is no parameter $app->param(content_type_id)' => sub {
    my $ref_parameter = {
        __test_user      => $admin,
        __request_method => 'GET',
        __mode           => 'view_content_data',
        blog_id          => $blog->id,
    };
    $app = _run_app('MT::App::CMS', $ref_parameter);
    $out = delete $app->{__test_output};

    ok($out =~ m/Invalid request\./, 'Error page.');
    ok($out =~ m/<h3 id="page-title" class="mb-5">An error occurred<\/h3>/, 'Error message is "An error occurred."');
};

subtest '$app->param(content_type_id) Not found.' => sub {
    my $ref_parameter = {
        __test_user      => $admin,
        __request_method => 'GET',
        __mode           => 'view_content_data',
        blog_id          => $blog->id,
        content_type_id  => 9999,
    };
    $app = _run_app('MT::App::CMS', $ref_parameter);
    $out = delete $app->{__test_output};

    ok($out =~ m/Invalid request\./, 'Error page.');
    ok($out =~ m/<h3 id="page-title" class="mb-5">An error occurred<\/h3>/, 'Error message is "An error occurred."');
};

subtest 'There is no parameter $app->param(id)' => sub {
    subtest "can't create_new_content_data" => sub {
        my $ref_parameter = {
            __test_user      => $cant_do1,
            __request_method => 'GET',
            __mode           => 'view_content_data',
            blog_id          => $blog->id,
            content_type_id  => $content_type->id,
        };

        $app = _run_app('MT::App::CMS', $ref_parameter);
        $out = delete $app->{__test_output};

        ok($out =~ m/<h3 id="page-title" class="mb-5">An error occurred<\/h3>/, 'Error message is "An error occurred."');
    };

    subtest "can't create_new_content_data_(content_data_id)" => sub {
        my $ref_parameter = {
            __test_user      => $cant_do2,
            __request_method => 'GET',
            __mode           => 'view_content_data',
            blog_id          => $blog->id,
            content_type_id  => $content_type->id,
        };

        $app = _run_app('MT::App::CMS', $ref_parameter);
        $out = delete $app->{__test_output};

        ok($out =~ m/<h3 id="page-title" class="mb-5">An error occurred<\/h3>/, 'Error message is "An error occurred."');
    };

};

subtest 'have $app->param(id)' => sub {
    subtest "can't edit_content_data" => sub {
        my $ref_parameter = {
            __test_user      => $can_do1,
            __request_method => 'GET',
            __mode           => 'view_content_data',
            blog_id          => $blog->id,
            content_type_id  => $content_type->id,
            id               => $cd1->id,
        };

        $app = _run_app('MT::App::CMS', $ref_parameter);
        $out = delete $app->{__test_output};

        ok($out =~ m/<h3 id="page-title" class="mb-5">An error occurred<\/h3>/, 'Error message is "An error occurred."');

    };

    # Don't use $param->{can_create_this}
    # subtest "can edit_content_data and can't create_new_content_data" => sub {
    #     my $mockPermission = mock_guard(
    #         'MT::Permission' => {
    #             can_edit_content_data => sub {1},
    #         },
    #     );
    #
    #     my $ref_parameter = {
    #         __test_user      => $cant_do2,
    #         __request_method => 'GET',
    #         __mode           => 'view_content_data',
    #         blog_id          => $blog->id,
    #         content_type_id  => $content_type->id,
    #         id               => $cd1->id,
    #     };
    #
    #     $app = _run_app('MT::App::CMS', $ref_parameter);
    #     $out = delete $app->{__test_output};
    #     #ok($out !~ /<h3 id="page-title" class="mb-5">An error occurred<\/h3>/, "don't output Error message");
    #     undef $mockPermission;
    # };
};

subtest "content type's blog id not equal this blog id" => sub {
    my $ref_parameter = {
        __test_user      => $admin,
        __request_method => 'GET',
        __mode           => 'view_content_data',
        blog_id          => $blog->id,
        content_type_id  => $content_type2->id,
    };

    $app = _run_app('MT::App::CMS', $ref_parameter);
    $out = delete $app->{__test_output};

    ok($out =~ m/Status: 302 Found/, 'status is 302 Found.');
    ok($app->{'redirect'} =~ /__mode=dashboard&redirect=1/, 'redirect url is dashboard.');
};

subtest "have _recover and don't have reedit" => sub {
    subtest "don't have auto session object" => sub {
        my $mockAppCms = mock_guard(
            'MT::App::CMS' => {
                autosave_session_obj => sub {0},
            },
        );

        my $ref_parameter = {
            __test_user      => $admin,
            __request_method => 'GET',
            __mode           => 'view_content_data',
            blog_id          => $blog->id,
            content_type_id  => $content_type->id,
            _recover         => 1
        };

        $app = _run_app('MT::App::CMS', $ref_parameter);
        my $out = delete $app->{__test_output};

        ok($out, 'create template succeeded.');
        ok($out =~ m/(An error occurred while trying to recover your saved content data\.)/, "out put auto save error message");

        undef $mockAppCms;
    };

    subtest "have auto session object and have session data" => sub {
        my $ref_parameter = {
            __test_user      => $admin,
            __request_method => 'GET',
            __mode           => 'view_content_data',
            blog_id          => $blog->id,
            content_type_id  => $content_type->id,
            _recover         => 1
        };

        my $mockAppCms = mock_guard(
            'MT::App::CMS' => {
                autosave_session_obj => sub {
                    require MT::Session;
                    my $sess_obj = new MT::Session;
                    my $ident = ':blog_id=' . $blog->id . ':content_type_id=' . $content_type->id;
                    $sess_obj->kind('AS');
                    $sess_obj->id($ident);
                    $sess_obj->start(time);

                    return $sess_obj;
                },
            },
        );


        $app = _run_app('MT::App::CMS', $ref_parameter);
        my $out = delete $app->{__test_output};

        ok($out, 'create template succeeded.');
        ok($out =~ m/(You have successfully recovered your saved content data.)/, "out put auto save successfully message");
        undef $mockAppCms;
    };

    # subtest "don't have session data" => sub {
    #
    #     $app = _run_app('MT::App::CMS', $ref_parameter);
    #     my $out = delete $app->{__test_output};
    #
    #     ok($out, 'create template succeeded.');
    #     ok($out =~ m/(An error occurred while trying to recover your saved content data\.)/, "out put auto save error message");
    # };

};

subtest "have reedit parameter" => sub {
    subtest "have serialized_data and It isn't reference" => sub {
        my $serialized_data = '{"' . $cf->id . '":"test1"}';
        my $ref_parameter = {
            __test_user      => $admin,
            __request_method => 'GET',
            __mode           => 'view_content_data',
            blog_id          => $blog->id,
            content_type_id  => $content_type->id,
            reedit           => 1,
            serialized_data  => $serialized_data,
        };

        $app = _run_app('MT::App::CMS', $ref_parameter);
        $out = delete $app->{__test_output};

        ok($out =~ m/(<input type="text".*value="test1")/, ' serialized_data value set success.');
    };

    subtest "have serialized_data and It's HASH" => sub {
        my $ref_parameter = {
            __test_user      => $admin,
            __request_method => 'GET',
            __mode           => 'view_content_data',
            blog_id          => $blog->id,
            content_type_id  => $content_type->id,
            reedit           => 1,
            serialized_data  => {
                $cf->id  => "test2",
            },
        };

        $app = _run_app('MT::App::CMS', $ref_parameter);
        $out = delete $app->{__test_output};

        ok($out =~ m/(<input type="text".*value="test2")/, ' serialized_data value set success.');
    };
};

#MTC-25793 start
subtest 'edit from preview' => sub {
    my $convert_breaks_field_name = 'content-field-' . $cf_multi->id . '_convert_breaks';
    my $ref_parameter = {
        __test_user      => $admin,
        __request_method => 'POST',
        __mode           => 'edit_content_data',
        _type            => 'content_data',
        blog_id          => $blog->id,
        content_type_id  => $content_type->id,
        id               => $cd1->id,
        from_preview     => 1,
        status          => MT::ContentStatus::RELEASE(),
        data_label => 'from preview',
        authored_on_date => '20190304',
        authored_on_time => '00:00:00',
        basename_manual => 0,
        unpublished_on_date=>'20200909',
        unpublished_on_time => '00:00:00',
        $convert_breaks_field_name =>  'markdown',
        reedit => 'reedit',
    };

    $app = _run_app( 'MT::App::CMS', $ref_parameter );
    $out = delete $app->{__test_output};

    ok($out =~ m/<option value="markdown" selected="selected">/, 'parameter setting succeeded.');
    ok($out =~ m/(name="data_label" value="from preview")/, 'Returned parameter setting succeeded.');
};

subtest 'edit by error' => sub {
    my $convert_breaks_field_name = 'content-field-' . $cf_multi->id . '_convert_breaks';
    my $ref_parameter = {
        __test_user                => $admin,
        __request_method           => 'POST',
        __mode                     => 'edit_content_data',
        _type                      => 'content_data',
        blog_id                    => $blog->id,
        content_type_id            => $content_type->id,
        id                         => $cd1->id,
        from_preview               => 1,
        status                     => MT::ContentStatus::RELEASE(),
        data_label                 => 'from preview',
        authored_on_date           => '20190304',
        authored_on_time           => '00:00:00',
        basename_manual            => 0,
        unpublished_on_date        => '20200909',
        unpublished_on_time        => '00:00:00',
        $convert_breaks_field_name => 'markdown',
        reedit                     => 'reedit',
        had_error                  => 1,
        err_msg                    => 'Error Content Data Edit',
    };

    $app = _run_app( 'MT::App::CMS', $ref_parameter );
    $out = delete $app->{__test_output};

    ok($out =~ m/<option value="markdown" selected="selected">/, 'parameter setting succeeded.');
    ok($out =~ m/(name="data_label" value="from preview")/, 'Returned parameter setting succeeded.');

};

subtest 'edit from preview by _convert_breaks value 0' => sub {
    my $convert_breaks_field_name = 'content-field-' . $cf_multi->id . '_convert_breaks';
    my $ref_parameter = {
        __test_user      => $admin,
        __request_method => 'POST',
        __mode           => 'edit_content_data',
        _type            => 'content_data',
        blog_id          => $blog->id,
        content_type_id  => $content_type->id,
        id               => $cd1->id,
        from_preview     => 1,
        status          => MT::ContentStatus::RELEASE(),
        data_label => 'from preview',
        authored_on_date => '20190304',
        authored_on_time => '00:00:00',
        basename_manual => 0,
        unpublished_on_date=>'20200909',
        unpublished_on_time => '00:00:00',
        $convert_breaks_field_name =>  '0',
        reedit => 'reedit',
    };

    $app = _run_app( 'MT::App::CMS', $ref_parameter );
    $out = delete $app->{__test_output};

    ok($out =~ m/<option value="0" selected="selected">/, 'parameter setting succeeded.');
    ok($out =~ m/(name="data_label" value="from preview")/, 'Returned parameter setting succeeded.');
};
#MTC-25793 end

done_testing();
