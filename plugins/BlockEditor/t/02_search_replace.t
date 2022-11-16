#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

my $test_data = {
    heading_data => {
        value   => 'heading value',
        html    => '<h1>heading value</h1>',
        type    => 'heading',
        options => { elm => "h1", },
        order   => 1,
    },
    text_data => {
        value => '<p>text value</p>',
        html  => '<p>text value</p>',
        type  => 'text',
        order => 2,
    },
    embed_data => {
        value => '<p>embed value</p>',
        html  => '<p>embed value</p>',
        type  => 'embed',
        order => 3,
    },
    image_data => {
        asset_url => "image.jpg",
        html =>
            '<figure><img src="http://0.0.0.0/test/assets_c/2020/04/image-thumb-autox167-1.png" class="mt-image-none" alt="image alt" title="image title" width="100"><figcaption>image caption</figcaption></figure>',
        options => {
            align   => "none",
            alt     => "image alt",
            caption => "image caption",
            title   => "image title",
            width   => "100"
        },
        type  => 'image',
        order => 4,
        value => "null",
    },
    horizon_data => {
        value => '',
        html  => '<hr>',
        type  => 'horizon',
        order => 5,
    },
};

$ENV{MT_TEST_IGNORE_FIXTURE} = 1;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $ct = MT::Test::Permission->make_content_type(
            blog_id => 1,
            name    => 'test content type',
        );

        my $cf = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'multi line text',
            type            => 'multi_line_text',
        );

        my $fields = [
            {   id        => $cf->id,
                label     => 1,
                name      => $cf->name,
                order     => 1,
                type      => $cf->type,
                unique_id => $cf->unique_id,
            }
        ];
        $ct->fields($fields);
        $ct->save or die $ct->errstr;

        my $blog_editor_data
            = {   'editor-input-content-field-'
                . $cf->id
                . '-blockeditor' => $test_data };
        my $convert_breaks = { $cf->id => 'blockeditor' };
        my $cd             = MT::Test::Permission->make_content_data(
            blog_id           => $ct->blog_id,
            author_id         => 1,
            content_type_id   => $ct->id,
            data              => MT::Serialize->serialize( \$test_data ),
            block_editor_data => MT::Util::to_json($blog_editor_data),
            convert_breaks    => MT::Serialize->serialize( \$convert_breaks ),
        );
    }
);

my $mt = MT->instance;
my $ct = MT::ContentType->load( { name => 'test content type' } );
my $cf = MT::ContentField->load( { name => 'multi line text' } );
my $cd = MT::ContentData->load(
    {   blog_id         => $ct->blog_id,
        author_id       => 1,
        content_type_id => $ct->id,
    }
);
my $admin = MT::Author->load(1);

subtest 'BlockEditor Search' => sub {
    foreach my $field_type ( keys %$test_data ) {
        my %data = %{ $test_data->{$field_type} };
        my $search_value
            = $data{type} eq 'horizon' ? $data{html} : $data{type};
        subtest "Search BlockEditor :" . $data{type} => sub {
            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'search_replace',
                    _type            => 'content_data',
                    blog_id          => 1,
                    is_limited       => 0,
                    do_search        => 1,
                    search           => $search_value
                }
            );
            my $out = delete $app->{__test_output};
            unlike( $out, qr/generic-error/, 'no error' );
            my $id = $cd->id;
            like(
                $out,
                qr/name="id" value="$id"/,
                "ContentData#$id is found"
            );
        }
    }
};

subtest 'BlockEditor Replace' => sub {
    foreach my $field_type ( keys %$test_data ) {
        my %data = %{ $test_data->{$field_type} };
        my $search_value = $data{type} eq 'horizon' ? $data{html} : $data{type};
        my $replace_value = "replace_after_$search_value";
        my @matches = $cd->block_editor_data =~ /$search_value/g;
        my $match_count = scalar(@matches);
        # remove key name and type name.
        $match_count -= 2 if $data{type} ne 'horizon';
        subtest "Replace BlockEditor :" . $data{type} => sub {
            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'search_replace',
                    _type            => 'content_data',
                    blog_id          => 1,
                    is_limited       => 0,
                    do_replace       => 1,
                    replace_ids      => $cd->id,
                    orig_search      => $search_value,
                    replace          => $replace_value
                }
            );
            my $out = delete $app->{__test_output};
            unlike( $out, qr/generic-error/, 'no error' );
            my $id = $cd->id;
            like(
                $out,
                qr/name="id" value="$id"/,
                "ContentData#$id is found"
            );
            # reflesh data
            my $cd_replaced = MT::ContentData->load($id);
            my $blog_editor_data_replaced = $cd_replaced->block_editor_data;
            like(
                $blog_editor_data_replaced,
                qr/$replace_value/,
                "$replace_value is found"
            );
            my @replaced_count = $blog_editor_data_replaced =~ /$replace_value/g;
            is(scalar(@replaced_count), $match_count, "replace count is $match_count");
            
        }
    }
};

done_testing();
