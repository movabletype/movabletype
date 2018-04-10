#!/usr/bin/perl

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

use MT::Test;
use MT::Test::Permission;

### Prepare
MT::Test->init_app;

### Make test data
$test_env->prepare_fixture( sub {
    MT::Test->init_db;

    # Sites
    my $site = MT::Test::Permission->make_website( name => 'my website' );
    my $site2 = MT::Test::Permission->make_website( name => 'my second website' );

    # Users
    my $create_user = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    my $create_user2 = MT::Test::Permission->make_author(
        name     => 'kagawa',
        nickname => 'Ichiro Kagawa',
    );

    my $edit_user = MT::Test::Permission->make_author(
        name     => 'ichikawa',
        nickname => 'Jiro Ichikawa',
    );

    my $edit_user2 = MT::Test::Permission->make_author(
        name     => 'kikkawa',
        nickname => 'Jiro Kikkawa',
    );

    my $manage_user = MT::Test::Permission->make_author(
        name     => 'ukawa',
        nickname => 'Saburo Ukawa',
    );

    my $manage_user2 = MT::Test::Permission->make_author(
        name     => 'kumekawa',
        nickname => 'Saburo Kumekawa',
    );

    my $publish_user = MT::Test::Permission->make_author(
        name     => 'egawa',
        nickname => 'Shiro Egawa',
    );

    my $publish_user2 = MT::Test::Permission->make_author(
        name     => 'Kemikawa',
        nickname => 'Shiro Kemikawa',
    );

    my $manage_content_data_user = MT::Test::Permission->make_author(
        name     => 'ogawa',
        nickname => 'Goro Ogawa',
    );

    my $manage_content_data_user2 = MT::Test::Permission->make_author(
        name     => 'koishikawa',
        nickname => 'Goro Koishikawa',
    );

    my $sys_manage_content_data_user = MT::Test::Permission->make_author(
        name     => 'sagawa',
        nickname => 'IChiro Sagawa',
    );

    # Content Type & Content Field & Content Data
    my $content_type = MT::Test::Permission->make_content_type(
        blog_id => $site->id,
        name    => 'test content type',
    );

    my $content_field = MT::Test::Permission->make_content_field(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
        name            => 'single line text',
        type            => 'single_line_text',
    );

    my $field_data = [
        {   id        => $content_field->id,
            order     => 1,
            type      => $content_field->type,
            options   => { label => $content_field->name, },
            unique_id => $content_field->unique_id,
        },
    ];
    $content_type->fields($field_data);
    $content_type->save or die $content_type->errstr;

    my $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site->id,
        author_id       => $create_user->id,
        content_type_id => $content_type->id,
        data            => { $content_field->id => 'test text' },
    );

    my $content_type2 = MT::Test::Permission->make_content_type(
        blog_id => $site2->id,
        name    => 'test content type2',
    );

    my $content_field2 = MT::Test::Permission->make_content_field(
        blog_id         => $content_type2->blog_id,
        content_type_id => $content_type2->id,
        name            => 'single line text2',
        type            => 'single_line_text',
    );

    my $field_data2 = [
        {   id        => $content_field2->id,
            order     => 1,
            type      => $content_field2->type,
            options   => { label => $content_field2->name, },
            unique_id => $content_field2->unique_id,
        },
    ];
    $content_type2->fields($field_data2);
    $content_type2->save or die $content_type2->errstr;

    my $cd2 = MT::Test::Permission->make_content_data(
        blog_id         => $site2->id,
        author_id       => $create_user2->id,
        content_type_id => $content_type2->id,
        data            => { $content_field2->id => 'test text' },
    );

    # Permissions
    my $field_priv = 'content_type:' . $content_type->unique_id . '-content_field:' . $content_field->unique_id;
    my $field_priv2 = 'content_type:' . $content_type2->unique_id . '-content_field:' . $content_field2->unique_id;

    my $create_priv = 'create_content_data:' . $content_type->unique_id;
    my $create_role = MT::Test::Permission->make_role(
        name => 'create_content_data ' .  $content_field->name,
        permissions => "'${create_priv}','${field_priv}'",
    );

    my $create_priv2 = 'create_content_data:' . $content_type2->unique_id;
    my $create_role2 = MT::Test::Permission->make_role(
        name => 'create_content_data ' .  $content_field2->name,
        permissions => "'${create_priv2}','${field_priv2}'",
    );

    my $publish_priv = 'publish_content_data:' . $content_type->unique_id;
    my $publish_role = MT::Test::Permission->make_role(
        name => 'publish_content_data ' .  $content_field->name,
        permissions => "'${publish_priv}','${create_priv}','${field_priv}'",
    );

    my $publish_priv2 = 'publish_content_data:' . $content_type2->unique_id;
    my $publish_role2 = MT::Test::Permission->make_role(
        name => 'publish_content_data ' .  $content_field2->name,
        permissions => "'${publish_priv2}','${create_priv2}','${field_priv2}'",
    );

    my $edit_priv = 'edit_all_content_data:' . $content_type->unique_id;
    my $edit_role = MT::Test::Permission->make_role(
        name => 'edit_all_content_data ' .  $content_field->name,
        permissions => "'${edit_priv}','${field_priv}'",
    );

    my $edit_priv2 = 'edit_all_content_data:' . $content_type2->unique_id;
    my $edit_role2 = MT::Test::Permission->make_role(
        name => 'edit_all_content_data ' .  $content_field2->name,
        permissions => "'${edit_priv2}','${field_priv2}'",
    );


    my $manage_priv = 'manage_content_data:' . $content_type->unique_id;
    my $manage_role = MT::Test::Permission->make_role(
        name => 'manage_content_data ' .  $content_field->name,
        permissions => "'${manage_priv}','${create_priv}','${publish_priv}','${edit_priv}','${field_priv}'",
    );

    my $manage_priv2 = 'manage_content_data:' . $content_type2->unique_id;
    my $manage_role2 = MT::Test::Permission->make_role(
        name => 'manage_content_data ' .  $content_field2->name,
        permissions => "'${manage_priv2}','${create_priv2}','${publish_priv2}','${edit_priv2}','${field_priv2}'",
    );

    my $manage_content_data_role = MT::Test::Permission->make_role(
        name => 'manage_content_data',
        permissions => "'manage_content_data'",
    );

    require MT::Association;
    MT::Association->link( $create_user => $create_role => $site );
    MT::Association->link( $create_user2 => $create_role2 => $site2 );
    MT::Association->link( $edit_user => $edit_role => $site );
    MT::Association->link( $edit_user2 => $edit_role2 => $site2 );
    MT::Association->link( $manage_user => $manage_role => $site );
    MT::Association->link( $manage_user2 => $manage_role2 => $site2 );
    MT::Association->link( $publish_user => $publish_role => $site );
    MT::Association->link( $publish_user2 => $publish_role2 => $site2 );
    MT::Association->link( $manage_content_data_user => $manage_content_data_role => $site );
    MT::Association->link( $manage_content_data_user2 => $manage_content_data_role => $site2 );

    $sys_manage_content_data_user->can_manage_content_data(1);
    $sys_manage_content_data_user->save;
} );

my $admin = MT::Author->load(1);

### Loading test data
my $site = MT::Website->load({ name => 'my website' });
my $site2 = MT::Website->load({ name => 'my second website' });

my $create_user = MT::Author->load({ name => 'aikawa' });
my $create_user2 = MT::Author->load({ name => 'kagawa' });
my $edit_user = MT::Author->load({ name => 'ichikawa' });
my $edit_user2 = MT::Author->load({ name => 'kikkawa' });
my $manage_user = MT::Author->load({ name => 'ukawa' });
my $manage_user2 = MT::Author->load({ name => 'kumekawa' });
my $publish_user = MT::Author->load({ name => 'egawa' });
my $publish_user2 = MT::Author->load({ name => 'kemikawa' });
my $manage_content_data_user = MT::Author->load({ name => 'ogawa' });
my $manage_content_data_user2 = MT::Author->load({ name => 'koishikawa' });
my $sys_manage_content_data_user = MT::Author->load({ name => 'sagawa' });

my $content_type = MT::ContentType->load({ name => 'test content type' });
my $content_type2 = MT::ContentType->load({ name => 'test content type2' });

my $content_field = MT::ContentField->load({ name => 'single line text' });
my $content_field2 = MT::ContentField->load({ name => 'single line text2' });

my $cd = MT::ContentData->load({
    blog_id => $content_type->blog_id,
    content_type_id => $content_type->id,
});
my $cd2 = MT::ContentData->load({
    blog_id => $content_type2->blog_id,
    content_type_id => $content_type2->id,
});

### Run
my ( $app, $out );

# Create new
subtest 'mode = view (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'create by admin' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $create_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'create by permitted user (create)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $publish_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'create by permitted user (publish)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'create by permitted user (manage)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_content_data_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'create by permitted user (manage_all)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_content_data_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'create by permitted user (sys)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $create_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site2->id,
            content_type_id  => $content_type2->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type2->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'create by not permitted user (create)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $publish_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site2->id,
            content_type_id  => $content_type2->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type2->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'create by not permitted user (publish)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site2->id,
            content_type_id  => $content_type2->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type2->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'create by not permitted user (manage)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_content_data_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site2->id,
            content_type_id  => $content_type2->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type2->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'create by non permitted user (manage_all)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $edit_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'create by not permitted user (edit)' );
};

# Save new
subtest 'mode = save (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
            data_label       => 'label',
            status           => 1,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'save new by admin' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $create_user,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
            data_label       => 'label',
            status           => 1,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'save new by permitted user (create)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $publish_user,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
            data_label       => 'label',
            status           => 1,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'save new by permitted user (publish)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_user,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
            data_label       => 'label',
            status           => 1,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'save new by permitted user (manage)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_content_data_user,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
            data_label       => 'label',
            status           => 1,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'save new by permitted user (manage_all)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_content_data_user,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
            data_label       => 'label',
            status           => 1,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'save new by permitted user (manage_sys)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $create_user2,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
            data_label       => 'label',
            status           => 1,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'save new by non permitted user (create)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $publish_user2,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
            data_label       => 'label',
            status           => 1,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'save new by non permitted user (publish)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_user2,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
            data_label       => 'label',
            status           => 1,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'save new by non permitted user (manage)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_content_data_user2,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
            data_label       => 'label',
            status           => 1,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'save new by non permitted user (manage_all)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $edit_user,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_data',
            type             => 'content_data_' . $content_type->id,
            data_label       => 'label',
            status           => 1,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'save new by non permitted user (edit_all)' );

};

done_testing();
