#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;

BEGIN {
    eval 'use Test::Spec; 1'
        or plan skip_all => 'Test::Spec is not installed';
    eval 'use Imager; 1'
        or plan skip_all => 'Imager is not installed';
    plan skip_all => 'Not for Windows now' if $^O eq 'MSWin32';
}

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(

        # to serve actual js libraries
        StaticFilePath => "MT_HOME/mt-static/",

        # ImageMagick 6.90 hangs when it tries to scale
        # the same image again (after the initialization).
        # Version 7.07 works fine. Other three drivers do, too.
        # Because Image::Magick hides its $VERSION in an
        # internal package (Image::Magick::Q16 etc), it's
        # more reliable to depend on something else.
        ImageDriver => 'Imager',

        # UseRiot => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Selenium;
use MT::Test::Fixture;

my $blog_id = 1;

my $before_fields;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $ct = MT::Test::Permission->make_content_type(
        name    => 'test content data',
        blog_id => $blog_id,
    );
    my $cf_single_line_text = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'single line text',
        type            => 'single_line_text',
    );
    my $cf_multi_line_text = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'multi line text',
        type            => 'multi_line_text',
    );
    my $cf_number = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'number',
        type            => 'number',
    );
    my $cf_url = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'url',
        type            => 'url',
    );
    my $cf_embedded_text = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'embedded text',
        type            => 'embedded_text',
    );
    my $cf_datetime = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'date and time',
        type            => 'date_and_time',
    );
    my $cf_date = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'date_only',
        type            => 'date_only',
    );
    my $cf_time = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'time_only',
        type            => 'time_only',
    );
    my $cf_select_box = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'select box',
        type            => 'select_box',
    );
    my $cf_radio = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'radio button',
        type            => 'radio_button',
    );
    my $cf_checkbox = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'checkboxes',
        type            => 'checkboxes',
    );
    my $cf_list = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'list',
        type            => 'list',
    );
    my $cf_table = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'tables',
        type            => 'tables',
    );
    my $cf_tag = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'tags',
        type            => 'tags',
    );
    my $tag1 = MT::Test::Permission->make_tag(name => 'tag1');
    my $tag2 = MT::Test::Permission->make_tag(name => 'tag2');

    my $cf_category = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'categories',
        type            => 'categories',
    );
    my $category_set = MT::Test::Permission->make_category_set(
        blog_id => $ct->blog_id,
        name    => 'test category set',
    );
    my $category1 = MT::Test::Permission->make_category(
        blog_id         => $category_set->blog_id,
        category_set_id => $category_set->id,
        label           => 'category1',
    );
    my $category2 = MT::Test::Permission->make_category(
        blog_id         => $category_set->blog_id,
        category_set_id => $category_set->id,
        label           => 'category2',
    );
    my $cf_image = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'asset_image',
        type            => 'asset_image',
    );
    my $child_ct = MT::Test::Permission->make_content_type(
        name    => 'test child content data',
        blog_id => $blog_id,
    );
    my $cf_ct = MT::Test::Permission->make_content_field(
        blog_id         => $blog_id,
        content_type_id => $ct->id,
        name            => 'content type',
        type            => 'content_type',
    );

    $before_fields = [{
            id        => $cf_single_line_text->id,
            order     => 1,
            type      => $cf_single_line_text->type,
            options   => { label => $cf_single_line_text->name },
            unique_id => $cf_single_line_text->unique_id,
        },
        {
            id      => $cf_multi_line_text->id,
            order   => 2,
            type    => $cf_multi_line_text->type,
            options => {
                label          => $cf_multi_line_text->name,
                full_rich_text => 1,
                input_format   => 'richtext'
            },
            unique_id => $cf_multi_line_text->unique_id,
        },
        {
            id        => $cf_number->id,
            order     => 3,
            type      => $cf_number->type,
            options   => { label => $cf_number->name },
            unique_id => $cf_number->unique_id,
        },
        {
            id        => $cf_url->id,
            order     => 4,
            type      => $cf_url->type,
            options   => { label => $cf_url->name },
            unique_id => $cf_url->unique_id,
        },
        {
            id        => $cf_embedded_text->id,
            order     => 5,
            type      => $cf_embedded_text->type,
            options   => { label => $cf_embedded_text->name },
            unique_id => $cf_embedded_text->unique_id,
        },
        {
            id        => $cf_datetime->id,
            order     => 6,
            type      => $cf_datetime->type,
            options   => { label => $cf_datetime->name },
            unique_id => $cf_datetime->unique_id,
        },
        {
            id        => $cf_date->id,
            order     => 7,
            type      => $cf_date->type,
            options   => { label => $cf_date->name },
            unique_id => $cf_date->unique_id,
        },
        {
            id        => $cf_time->id,
            order     => 8,
            type      => $cf_time->type,
            options   => { label => $cf_time->name },
            unique_id => $cf_time->unique_id,
        },
        {
            id      => $cf_select_box->id,
            order   => 9,
            type    => $cf_select_box->type,
            options => {
                label  => $cf_select_box->name,
                values => [
                    { label => 'abc', value => 1 },
                    { label => 'def', value => 2 },
                    { label => 'ghi', value => 3 },
                ],
            },
            unique_id => $cf_select_box->unique_id,
        },
        {
            id      => $cf_radio->id,
            order   => 10,
            type    => $cf_radio->type,
            options => {
                label  => $cf_radio->name,
                values => [
                    { label => 'abc', value => 1 },
                    { label => 'def', value => 2 },
                    { label => 'ghi', value => 3 },
                ],
            },
            unique_id => $cf_radio->unique_id,
        },
        {
            id      => $cf_checkbox->id,
            order   => 11,
            type    => $cf_checkbox->type,
            options => {
                label  => $cf_checkbox->name,
                values => [
                    { label => 'abc', value => 1 },
                    { label => 'def', value => 2 },
                    { label => 'ghi', value => 3 },
                ],
                multiple => 1,
                max      => 3,
                min      => 1,
            },
            unique_id => $cf_checkbox->unique_id,
        },
        {
            id      => $cf_list->id,
            order   => 12,
            type    => $cf_list->type,
            options => { label => $cf_list->name },
            unique_id => $cf_list->unique_id,
        },
        {
            id      => $cf_table->id,
            order   => 13,
            type    => $cf_table->type,
            options => {
                label        => $cf_table->name,
                initial_rows => 3,
                initial_cols => 3,
            },
            unique_id => $cf_table->unique_id,
        },
        {
            id      => $cf_tag->id,
            order   => 14,
            type    => $cf_tag->type,
            options => {
                label    => $cf_tag->name,
                multiple => 1,
                max      => 5,
                min      => 1,
            },
            unique_id => $cf_tag->unique_id,
        },
        {
            id      => $cf_category->id,
            order   => 15,
            type    => $cf_category->type,
            options => {
                label        => $cf_category->name,
                category_set => $category_set->id,
                multiple     => 1,
                max          => 5,
                min          => 1,
            },
            unique_id => $cf_category->unique_id,
        },
        {
            id      => $cf_image->id,
            order   => 16,
            type    => $cf_image->type,
            options => {
                label    => $cf_image->name,
                multiple => 1,
                max      => 5,
                min      => 1,
            },
            unique_id => $cf_image->unique_id,
        },
        {
            id      => $cf_ct->id,
            order   => 17,
            type    => $cf_ct->type,
            options => {
                label    => $cf_ct->name,
                multiple => 1,
                source   => $child_ct->id,
            },
            unique_id => $cf_ct->unique_id,
        },
    ];
    $ct->fields(MT::Test::Fixture::_fix_fields($before_fields));
    $ct->save or die $ct->errstr;
});

if (!$before_fields) {
    my $ct = MT::ContentType->load({name => 'test content data'});
    $before_fields = $ct->fields;
}

my $author = MT->model('author')->load(1) or die MT->model('author')->errstr;
$author->set_password('Nelson');
$author->save or die $author->errstr;

$test_env->clear_mt_cache;

use Class::Inspector;

subtest 'On Edit Content type ' => sub {
    subtest 'Duplicate Field' => sub {
        my $selenium = MT::Test::Selenium->new($test_env);
        $selenium->visit('/cgi-bin/mt.cgi?__mode=view&blog_id=1&_type=content_type&id=1&username=Melody&password=Nelson');
        $selenium->screenshot_full;
        $selenium->driver->execute_script('jQuery(".mt-contentfield .duplicate-content-field").each(function(){setTimeout(() => jQuery(this).get(0).click())});');
        $selenium->screenshot_full;
        $selenium->driver->execute_script('jQuery("[data-is=\'content-fields\'] button.btn-primary").trigger("click")');
        $selenium->screenshot_full;

        my $ct_new     = MT->model('content_type')->load(1);
        my $fields_new = $ct_new->fields;

        is(scalar(@$fields_new), (scalar(@$before_fields) * 2), 'All fields are duplicated');

        foreach my $field (@$before_fields) {
            my $type   = $field->{type};
            my @fields = grep { $_->{type} eq $type } @$fields_new;
            foreach my $key (keys %{ $fields[0]->{options} }) {

                if ($key ne 'label') {
                    if (ref $fields[0]->{options}->{$key} ne 'ARRAY') {
                        is($fields[0]->{options}->{$key}, $fields[1]->{options}->{$key}, "${type} - ${key} fields are duplicated");
                    } else {
                        is_deeply($fields[0]->{options}->{$key}, $fields[1]->{options}->{$key}, "${type} - ${key} fields are duplicated");
                    }
                } else {
                    like($fields[1]{options}{$key}, qr/Duplicate\s?-\s?$fields[0]->{options}->{$key}/, "${type} - label are duplicated");
                }
            }
        }
    };

    subtest 'Delete Field' => sub {
        my $selenium = MT::Test::Selenium->new($test_env);
        $selenium->visit('/cgi-bin/mt.cgi?__mode=view&blog_id=1&_type=content_type&id=1&username=Melody&password=Nelson');
        $selenium->screenshot_full;

        my $count_script = q{
          return jQuery("#content-fields .mt-contentfield").length;
        };
        my $click_script = q{
          jQuery(".mt-contentfield .delete-content-field:eq(0)").get(0).click();
        };

        subtest 'not delete field' => sub {
            my $length = $selenium->driver->execute_script($count_script);
            $selenium->driver->execute_script($click_script);
            # cancel
            $selenium->driver->dismiss_alert;
            my $length_new = $selenium->driver->execute_script($count_script);
            $selenium->screenshot_full;
            is($length, $length_new, 'not delete field');
        };

        subtest 'delete field' => sub {
            my $length = $selenium->driver->execute_script($count_script);
            $selenium->driver->execute_script($click_script);
            # cancel
            $selenium->driver->accept_alert;
            my $length_new = $selenium->driver->execute_script($count_script);
            $selenium->screenshot_full;
            is(($length - 1), $length_new, 'delete field');
        };
    };
};

done_testing;

