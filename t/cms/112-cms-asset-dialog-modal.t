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
use MT::Test::App;
use MT::Test::Permission;

$test_env->prepare_fixture('cms/assetdialogmodal');

my $mt    = MT->instance;
my $admin = $mt->model('author')->load(1);
my $blog  = $mt->model('blog')->load(1);

subtest 'dialog_asset_modal' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode      => 'dialog_asset_modal',
        __type      => 'asset',
        edit_field  => 'editor-input-content',
        blog_id     => $blog->id,
        dialog_view => 1,
        filter      => 'class',
        filter_val  => 'image',
        can_multi   => 1,
        dialog      => 1,
    });

    $app->content_like(qr/<option value="file"/,  'has Files in Asset Type select box');
    $app->content_like(qr/<option value="video"/, 'has Videos in Asset Type select box');
    $app->content_like(qr/<option value="audio"/, 'has Audio in Asset Type select box');
    $app->content_like(qr/<option value="image"/, 'has Images in Asset Type select box');
};

subtest 'dialog_asset_modal by Content Designer' => sub {
    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );
    my $content_designer = MT::Role->load({ name => MT->translate('Content Designer') });
    require MT::Association;
    MT::Association->link($aikawa => $content_designer => $blog);
    my $content_type = MT::Test::Permission->make_content_type(blog_id => $blog->id);
    my $asset_field = MT::Test::Permission->make_content_field(
        blog_id         => $blog->id,
        content_type_id => $content_type->id,
        type            => 'asset',
        name            => 'asset',
    );
    $content_type->fields(
        [
            {
                id      => $asset_field->id,
                order   => 1,
                type    => $asset_field->type,
                options => {
                    label        => $asset_field->name,
                    multiple     => 1,
                    allow_upload => 1,
                },
                unique_id => $asset_field->unique_id,
            },
        ]
    );
    $content_type->save;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($aikawa);
    $app->get_ok({
        __mode           => 'list_asset',
        __type           => 'asset',
        blog_id          => $blog->id,
        content_field_id => $asset_field->id,
        dialog_view      => 1,
        dialog           => 1,
        filter           => 'class',
        filter_val       => 'image',
        require_type     => 'image',
        no_insert        => 1,
    });

    my @names;
    $app->wq_find('#content-body-left a.left-menu-item')->each(sub {
        my $name = $_->text;
        $name =~ s/^\s+|\s+$//sg;
        push @names, $name;
    });
    ok !grep(/Upload/, @names), "Upload menu is gone";
    ok grep(/Library/, @names), "Library menu still exists";
};

subtest 'Load images by dialog_list_asset' => sub {
    my $website  = MT->model('website')->load({ name => 'asset dialog website' });
    my $cf_image = MT->model('cf')->load({ name => 'asset_image' });
    my %dialog_list_asset_options = (
        __mode      => 'dialog_list_asset',
        _type       => 'asset',
        offset      => 0,
        dialog_view => 1,
        dialog      => 1,
        json        => 1,
        can_multi   => 0,
        filter      => 'class',
        filter_val  => 'image',
    );

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    my $res = $app->post_ok({
        %dialog_list_asset_options,
        blog_id => $website->id,
    });
    my $json = MT::Util::from_json($res->decoded_content);
    is($json->{pager}{rows}, 2, "Retrieve assets include website and children");

    $res = $app->post_ok({
        %dialog_list_asset_options,
        blog_id    => $website->id,
        edit_field => 'customfield_xx',
    });
    $json = MT::Util::from_json($res->decoded_content);
    is($json->{pager}{rows}, 2, "Retrieve assets include website and children with custom field");

    $res = $app->post_ok({
        %dialog_list_asset_options,
        blog_id          => $website->id,
        content_field_id => $cf_image->id,
    });
    $json = MT::Util::from_json($res->decoded_content);
    is($json->{pager}{rows}, 1, "Retrieve assets include website and children with content field");
};

subtest 'Show dialog edit asset' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'dialog_edit_asset',
        blog_id => $blog->id,
        id      => $newest_asset->id,
    });
};

subtest 'Show dialog edit image' => sub {
    my $newest_asset = MT::Asset->load(
        { class => 'image' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'dialog_edit_image',
        blog_id => $blog->id,
        id      => $newest_asset->id,
    });
};

subtest 'Transform image' => sub {
    my $newest_asset = MT::Asset->load(
        { class => 'image' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'transform_image',
        blog_id => $blog->id,
        id      => $newest_asset->id,
        actions => '[{"resize":{"width":100,"height":100}}]',
    });
};

done_testing;
