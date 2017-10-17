#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
    $ENV{MT_APP}    = 'MT::App::CMS';
}

use MT::Test qw(:app :db :data);
use Test::More qw( no_plan );
use YAML::Tiny;
use File::Spec;
use FindBin qw( $Bin );
use MT;

my $mt = MT->instance;
$mt->user( MT::Author->load(1) );
$mt->config->ThemesDirectory('t/themes');
use_ok( 'MT::Theme', 'use MT::Theme' );

## building test themes.
my $data;
{
    local $/ = undef;
    $data = ( YAML::Tiny::Load(<DATA>) )[0];
}
$mt->component('core')->registry->{themes} = $data;

## create theme instance.
my $theme;
ok( $theme = MT::Theme->load('MyTheme'), 'Load theme instance' );
my $blog;
ok( $blog = MT->model('blog')->load(1) );

my ( $errors, $warnings ) = $theme->validate_versions;
ok( !scalar @$errors );
ok( !scalar @$warnings );

is( $blog->allow_comment_html, 1 );
is( $blog->allow_pings,        1 );

## apply!!
ok( $theme->apply($blog), 'apply theme' );

## prefs was changed by theme.
is( $blog->allow_comment_html, 0 );
is( $blog->allow_pings,        0 );

subtest 'template_set element' => sub {
    ## only applied template set has this.
    my $main_index;
    ok( $main_index = MT->model('template')
            ->load( { blog_id => $blog->id, identifier => 'main_index' } ) );
    is( $main_index->text, "I am MT\nI am MT", 'loaded template' );

    ## and backuped templates exists.
    ok( MT->model('template')
            ->load( { blog_id => $blog->id, type => 'backup' } ) );

    my ( $datetime_field, $categories1_field, $categories2_field );
    subtest 'ct' => sub {
        my $tmpl = MT->model('template')
            ->load( { blog_id => $blog->id, identifier => 'content_type' } );
        ok($tmpl);
        is( $tmpl->text, "content_type.mtml\n" );
        is( MT->model('templatemap')->count( { template_id => $tmpl->id } ),
            6 );

        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType',
                    file_template => '%y/%m/%-f',
                    build_type    => 1,
                    is_preferred  => 0,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType',
                    file_template => '%y/%m/%-b/%i',
                    build_type    => 1,
                    is_preferred  => 1,
                }
            ),
            1
        );
        $datetime_field = MT->model('content_field')->load(
            {   blog_id         => $tmpl->blog_id,
                content_type_id => $tmpl->content_type_id,
                type            => 'date_and_time',
                name            => 'datetime',
            }
        ) or die 'cannot load datetime field';
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType',
                    file_template => '%y/%m/%d/%b/%i',
                    build_type    => 2,
                    is_preferred  => 0,
                    dt_field_id   => $datetime_field->id,
                }
            ),
            1
        );
        $categories1_field = MT->model('content_field')->load(
            {   blog_id         => $tmpl->blog_id,
                content_type_id => $tmpl->content_type_id,
                type            => 'categories',
                name            => 'categories 1',
            }
        ) or die 'cannot load category1 field';
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType',
                    file_template => '%-c/%-f',
                    build_type    => 3,
                    is_preferred  => 0,
                    cat_field_id  => $categories1_field->id,
                }
            ),
            1
        );
        $categories2_field = MT->model('content_field')->load(
            {   blog_id         => $tmpl->blog_id,
                content_type_id => $tmpl->content_type_id,
                type            => 'categories',
                name            => 'categories 2',
            }
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType',
                    file_template => '%y/%m/%-f/%-c',
                    build_type    => 4,
                    is_preferred  => 0,
                    cat_field_id  => $categories2_field->id,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType',
                    file_template => '%m/%-f/%-c',
                    build_type    => 1,
                    is_preferred  => 0,
                    dt_field_id   => $datetime_field->id,
                    cat_field_id  => $categories1_field->id,
                }
            ),
            1
        );
    };

    subtest 'ct_archive' => sub {
        my $tmpl
            = MT->model('template')
            ->load(
            { blog_id => $blog->id, identifier => 'content_type_listing' } );
        ok($tmpl);
        is( $tmpl->text, "content_type_listing.mtml\n" );
        is( MT->model('templatemap')->count( { template_id => $tmpl->id } ),
            15 );

        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Daily',
                    file_template => '%y/%m/%d/%f',
                    build_type    => 1,
                    is_preferred  => 1,
                    dt_field_id   => $datetime_field->id,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Weekly',
                    file_template => '%y/%m/%d-week/%i',
                    build_type    => 2,
                    is_preferred  => 1,
                    dt_field_id   => 0,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Monthly',
                    file_template => '%y/%m/%i',
                    build_type    => 3,
                    is_preferred  => 1,
                    dt_field_id   => $datetime_field->id,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Yearly',
                    file_template => '%y/%i',
                    build_type    => 4,
                    is_preferred  => 1,
                    dt_field_id   => 0,
                }
            ),
            1
        );

        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Author',
                    file_template => 'author/%-a/%f',
                    build_type    => 1,
                    is_preferred  => 0,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Author',
                    file_template => 'author/%a/%f',
                    build_type    => 1,
                    is_preferred  => 1,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Author-Daily',
                    file_template => 'author/%-a/%y/%m/%d/%f',
                    build_type    => 0,
                    is_preferred  => 1,
                    dt_field_id   => $datetime_field->id,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Author-Weekly',
                    file_template => 'author/%-a/%y/%m/%d-week/%f',
                    build_type    => 2,
                    is_preferred  => 1,
                    dt_field_id   => 0,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Author-Monthly',
                    file_template => 'author/%-a/%y/%m/%f',
                    build_type    => 3,
                    dt_field_id   => $datetime_field->id,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Author-Yearly',
                    file_template => 'author/%-a/%y/%f',
                    build_type    => 4,
                    is_preferred  => 1,
                    dt_field_id   => 0,
                }
            ),
            1
        );

        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Category',
                    file_template => '%-c/%i',
                    build_type    => 1,
                    is_preferred  => 1,
                    cat_field_id  => $categories1_field->id,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Category-Daily',
                    file_template => '%-c/%y/%m/%d/%i',
                    build_type    => 0,
                    is_preferred  => 1,
                    dt_field_id   => $datetime_field->id,
                    cat_field_id  => $categories2_field->id,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Category-Weekly',
                    file_template => '%-c/%y/%m/%d-week/%i',
                    build_type    => 2,
                    is_preferred  => 1,
                    dt_field_id   => 0,
                    cat_field_id  => $categories1_field->id,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Category-Monthly',
                    file_template => '%-c/%y/%m/%i',
                    build_type    => 3,
                    dt_field_id   => $datetime_field->id,
                    cat_field_id  => $categories2_field->id,
                }
            ),
            1
        );
        is( MT->model('templatemap')->count(
                {   template_id   => $tmpl->id,
                    archive_type  => 'ContentType-Category-Yearly',
                    file_template => '%-c/%y/%i',
                    build_type    => 4,
                    is_preferred  => 1,
                    dt_field_id   => 0,
                    cat_field_id  => $categories1_field->id,
                }
            ),
            1
        );
    };
};

subtest 'default_category_sets element' => sub {
    my $category_set = MT->model('category_set')
        ->load( { blog_id => $blog->id, name => 'test_category_set' } );
    ok($category_set);
    is( MT->model('category')->count(
            { blog_id => $blog->id, category_set_id => $category_set->id }
        ),
        3
    );
    my $category_a = MT->model('category')->load(
        {   blog_id         => $blog->id,
            category_set_id => $category_set->id,
            label           => 'a'
        }
    );
    my $category_b = MT->model('category')->load(
        {   blog_id         => $blog->id,
            category_set_id => $category_set->id,
            label           => 'b'
        }
    );
    ok($category_a);
    ok($category_b);
    is( $category_a->parent, $category_b->id );
    ok( MT->model('category')->exist(
            {   blog_id         => $blog->id,
                category_set_id => $category_set->id,
                label           => 'c'
            }
        )
    );
};

subtest 'default_content_types element' => sub {
    subtest 'child_content_type' => sub {
        my $child_content_type = MT->model('content_type')->load(
            {   blog_id   => $blog->id,
                name      => 'child_content_type',
                unique_id => ( '1234567890' x 4 ),
            }
        );
        ok( $child_content_type, 'child_content_type is created' );
        is( scalar( @{ $child_content_type->fields } ),
            1, 'child_content_type has 1 field' );
        my $field = $child_content_type->fields->[0];
        is( $field->{type}, 'single_line_text',
            'field type is single_line_text' );
        is( $field->{unique_id},
            ( 'abcdefghij' x 4 ),
            'field unique_id is ok'
        );
        is( $field->{options}{label},
            'single_line_text', 'field label is single_line_text' );
        is( $field->{options}{display},
            'default', 'field display is default' );
    };

    subtest 'test_content_type' => sub {
        my $test_content_type = MT->model('content_type')->load(
            {   blog_id   => $blog->id,
                name      => 'test_content_type',
                unique_id => 'contenttypecontenttypecontenttype1234567',
            }
        );
        ok($test_content_type);
        is( scalar( @{ $test_content_type->fields } ), 24 );

        subtest 'single_line_text field' => sub {
            my $f = $test_content_type->fields->[0];
            is( $f->{options}{label},         'single' );
            is( $f->{options}{description},   'single line text' );
            is( $f->{type},                   'single_line_text' );
            is( $f->{options}{required},      1 );
            is( $f->{options}{display},       'force' );
            is( $f->{options}{max_length},    10 );
            is( $f->{options}{min_length},    5 );
            is( $f->{options}{initial_value}, 'abc' );
        };

        subtest 'multi_line_text field' => sub {
            my $f = $test_content_type->fields->[1];
            is( $f->{options}{label},         'multi' );
            is( $f->{options}{description},   'multi line text' );
            is( $f->{type},                   'multi_line_text' );
            is( $f->{options}{required},      0 );
            is( $f->{options}{display},       'default' );
            is( $f->{options}{initial_value}, "aaa\nbbb\n" );
            is( $f->{options}{input_format},  'markdown' );
        };

        subtest 'number field' => sub {
            my $f = $test_content_type->fields->[2];
            is( $f->{options}{label},          'number' );
            is( $f->{options}{description},    'number 123' );
            is( $f->{type},                    'number' );
            is( $f->{options}{required},       0 );
            is( $f->{options}{display},        'default' );
            is( $f->{options}{min_value},      1 );
            is( $f->{options}{max_value},      10 );
            is( $f->{options}{decimal_places}, 3 );
            is( $f->{options}{initial_value},  345 );
        };

        subtest 'url field' => sub {
            my $f = $test_content_type->fields->[3];
            is( $f->{options}{label},         'url' );
            is( $f->{options}{description},   'This is a URL field.' );
            is( $f->{type},                   'url' );
            is( $f->{options}{required},      1 );
            is( $f->{options}{display},       'optional' );
            is( $f->{options}{initial_value}, 'https://example.com' );
        };

        subtest 'date_and_time field' => sub {
            my $f = $test_content_type->fields->[4];
            is( $f->{options}{label},         'datetime' );
            is( $f->{options}{description},   'datetime field' );
            is( $f->{type},                   'date_and_time' );
            is( $f->{options}{required},      0 );
            is( $f->{options}{display},       'optional' );
            is( $f->{options}{initial_value}, '2017-08-27 11:22:33' );
        };

        subtest 'date_only field' => sub {
            my $f = $test_content_type->fields->[5];
            is( $f->{options}{label},         'date' );
            is( $f->{options}{description},   'date field' );
            is( $f->{type},                   'date_only' );
            is( $f->{options}{required},      1 );
            is( $f->{options}{display},       'default' );
            is( $f->{options}{initial_value}, '2017-08-03' );
        };

        subtest 'time_only field' => sub {
            my $f = $test_content_type->fields->[6];
            is( $f->{options}{label},         'time' );
            is( $f->{options}{description},   'time field' );
            is( $f->{type},                   'time_only' );
            is( $f->{options}{required},      0 );
            is( $f->{options}{display},       'default' );
            is( $f->{options}{initial_value}, '10:20:30' );
        };

        subtest 'select_box field (single)' => sub {
            my $f = $test_content_type->fields->[7];
            is( $f->{options}{label},       'single_select' );
            is( $f->{options}{description}, 'single select field' );
            is( $f->{type},                 'select_box' );
            is( $f->{options}{required},    0 );
            is( $f->{options}{display},     'default' );
            is_deeply(
                $f->{options}{values},
                [   { label => 'a', value => 1, },
                    { label => 'b', value => 2 },
                    { label => 'c', value => 3 },
                ]
            );
            is( $f->{options}{multiple}, 0 );
        };

        subtest 'select_box field (multiple)' => sub {
            my $f = $test_content_type->fields->[8];
            is( $f->{options}{label},       'multiple_select' );
            is( $f->{options}{description}, 'multiple select field' );
            is( $f->{type},                 'select_box' );
            is( $f->{options}{required},    1 );
            is( $f->{options}{display},     'default' );
            is_deeply(
                $f->{options}{values},
                [   { label => 1, value => 'a' },
                    { label => 2, value => 'b' },
                    { label => 3, value => 'c' },
                ]
            );
            is( $f->{options}{multiple}, 1 );
            is( $f->{options}{min},      1 );
            is( $f->{options}{max},      3 );
        };

        subtest 'radio_button field' => sub {
            my $f = $test_content_type->fields->[9];
            is( $f->{options}{label},       'radio' );
            is( $f->{options}{description}, 'radio field' );
            is( $f->{type},                 'radio_button' );
            is( $f->{options}{required},    0 );
            is( $f->{options}{display},     'default' );
            is_deeply(
                $f->{options}{values},
                [   { label => 'aa', value => 1 },
                    { label => 'bb', value => 2 },
                    { label => 'cc', value => 3 },
                ]
            );
        };

        subtest 'checkboxes field (single)' => sub {
            my $f = $test_content_type->fields->[10];
            is( $f->{options}{label},       'single checkbox' );
            is( $f->{options}{description}, 'single checkbox field' );
            is( $f->{type},                 'checkboxes' );
            is( $f->{options}{required},    0 );
            is( $f->{options}{display},     'default' );
            is_deeply(
                $f->{options}{values},
                [   { label => 'a', value => 1 },
                    { label => 'b', value => 2 },
                    { label => 'c', value => 3 },
                    { label => 'd', value => 4 },
                ]
            );
            is( $f->{options}{multiple}, 0 );
        };

        subtest 'checkboxes field (multiple)' => sub {
            my $f = $test_content_type->fields->[11];
            is( $f->{options}{label},       'multiple checkboxes' );
            is( $f->{options}{description}, 'multiple checkboxes field' );
            is( $f->{type},                 'checkboxes' );
            is( $f->{options}{required},    0 );
            is( $f->{options}{display},     'default' );
            is_deeply(
                $f->{options}{values},
                [   { label => 1, value => 'a' },
                    { label => 2, value => 'b' },
                    { label => 3, value => 'c' },
                    { label => 4, value => 'd' },
                ]
            );
            is( $f->{options}{multiple}, 1 );
            is( $f->{options}{min},      1 );
            is( $f->{options}{max},      4 );
        };

        subtest 'asset field' => sub {
            my $f = $test_content_type->fields->[12];
            is( $f->{options}{label},        'asset' );
            is( $f->{options}{description},  'asset field' );
            is( $f->{type},                  'asset' );
            is( $f->{options}{required},     0 );
            is( $f->{options}{display},      'default' );
            is( $f->{options}{multiple},     1 );
            is( $f->{options}{allow_upload}, 1 );
            is( $f->{options}{min},          2 );
            is( $f->{options}{max},          4 );
        };

        subtest 'asset_audio field' => sub {
            my $f = $test_content_type->fields->[13];
            is( $f->{options}{label},        'audio' );
            is( $f->{options}{description},  'audio field' );
            is( $f->{type},                  'asset_audio' );
            is( $f->{options}{required},     1 );
            is( $f->{options}{display},      'none' );
            is( $f->{options}{multiple},     1 );
            is( $f->{options}{allow_upload}, 1 );
            is( $f->{options}{min},          3 );
            is( $f->{options}{max},          5 );
        };

        subtest 'asset_video field' => sub {
            my $f = $test_content_type->fields->[14];
            is( $f->{options}{label},        'video' );
            is( $f->{options}{description},  'video field' );
            is( $f->{type},                  'asset_video' );
            is( $f->{options}{required},     0 );
            is( $f->{options}{display},      'none' );
            is( $f->{options}{multiple},     1 );
            is( $f->{options}{allow_upload}, 0 );
            is( $f->{options}{min},          1 );
            is( $f->{options}{max},          100 );
        };

        subtest 'asset_image field' => sub {
            my $f = $test_content_type->fields->[15];
            is( $f->{options}{label},        'image' );
            is( $f->{options}{description},  'image field' );
            is( $f->{type},                  'asset_image' );
            is( $f->{options}{required},     1 );
            is( $f->{options}{display},      'default' );
            is( $f->{options}{multiple},     0 );
            is( $f->{options}{allow_upload}, 1 );
        };

        subtest 'embedded_text field' => sub {
            my $f = $test_content_type->fields->[16];
            is( $f->{options}{label},         'embedded' );
            is( $f->{options}{description},   'embedded field' );
            is( $f->{type},                   'embedded_text' );
            is( $f->{options}{required},      0 );
            is( $f->{options}{display},       'default' );
            is( $f->{options}{initial_value}, "akasatana\nhamayarawa\n" );
        };

        subtest 'categories field (1)' => sub {
            my $f = $test_content_type->fields->[17];
            is( $f->{options}{label},       'categories 1' );
            is( $f->{options}{description}, 'categories field 1' );
            is( $f->{type},                 'categories' );
            is( $f->{options}{unique_id}, ( 'categories' x 4 ) );
            is( $f->{options}{required},     1 );
            is( $f->{options}{display},      'default' );
            is( $f->{options}{multiple},     1 );
            is( $f->{options}{min},          1 );
            is( $f->{options}{max},          3 );
            is( $f->{options}{category_set}, 1 );
            is( $f->{options}{can_add},      1 );
        };

        subtest 'category field (2)' => sub {
            my $f = $test_content_type->fields->[18];
            is( $f->{options}{label},        'categories 2' );
            is( $f->{options}{description},  'categories field 2' );
            is( $f->{type},                  'categories' );
            is( $f->{options}{required},     1 );
            is( $f->{options}{display},      'optional' );
            is( $f->{options}{multiple},     0 );
            is( $f->{options}{category_set}, 1 );
            is( $f->{options}{can_add},      0 );
        };

        subtest 'tags field' => sub {
            my $f = $test_content_type->fields->[19];
            is( $f->{options}{label},         'tag' );
            is( $f->{options}{description},   'tags field' );
            is( $f->{type},                   'tags' );
            is( $f->{options}{required},      0 );
            is( $f->{options}{display},       'optional' );
            is( $f->{options}{multiple},      1 );
            is( $f->{options}{can_add},       1 );
            is( $f->{options}{min},           2 );
            is( $f->{options}{max},           3 );
            is( $f->{options}{initial_value}, 'abc' );
        };

        subtest 'list field' => sub {
            my $f = $test_content_type->fields->[20];
            is( $f->{options}{label},       'list' );
            is( $f->{options}{description}, 'list field' );
            is( $f->{type},                 'list' );
            is( $f->{options}{required},    1 );
            is( $f->{options}{display},     'default' );
        };

        subtest 'tables field' => sub {
            my $f = $test_content_type->fields->[21];
            is( $f->{options}{label},                  'table' );
            is( $f->{options}{description},            'table field' );
            is( $f->{type},                            'tables' );
            is( $f->{options}{display},                'optional' );
            is( $f->{options}{initial_rows},           3 );
            is( $f->{options}{initial_cols},           4 );
            is( $f->{options}{increase_decrease_rows}, 1 );
            is( $f->{options}{increase_decrease_cols}, 0 );
        };

        subtest 'content_type field' => sub {
            my $f = $test_content_type->fields->[22];
            is( $f->{options}{label},       'content_type_1' );
            is( $f->{options}{description}, 'content type field 1' );
            is( $f->{type},                 'content_type' );
            is( $f->{options}{required},    0 );
            is( $f->{options}{display},     'default' );
            is( $f->{options}{multiple},    1 );
            is( $f->{options}{can_add},     1 );
            is( $f->{options}{min},         5 );
            is( $f->{options}{max},         10 );
            is( $f->{options}{source},      1 );
        };

        subtest 'content_type field (by unique_id)' => sub {
            my $f = $test_content_type->fields->[23];
            is( $f->{options}{label},       'content_type_2' );
            is( $f->{options}{description}, 'content type field 2' );
            is( $f->{type},                 'content_type' );
            is( $f->{options}{unique_id}, ( 'abcd' x 10 ) );
            is( $f->{options}{required}, 1 );
            is( $f->{options}{display},  'optional' );
            is( $f->{options}{multiple}, 0 );
            is( $f->{options}{can_add},  0 );
            is( $f->{options}{source},   1 );
        };
    };
};

## ============================ Tests for loading theme package
## create second theme instance.
my $theme2;
ok( $theme2 = MT::Theme->_load_from_themes_directory('other_theme'),
    'Load from themes directory' );
is( File::Spec->rel2abs( $theme2->path ),
    File::Spec->catdir( $Bin, 'themes/other_theme' ) );
$theme2->apply($blog);
my $atom = MT->model('template')->load(
    {   blog_id => $blog->id,
        type    => 'index',
        name    => 'Atom',
    }
);
is( $atom->text, 'ATOMTEMPLATE BODY FOR TEST' );

__DATA__
MyTheme:
    id: my_theme
    name: my_theme
    label: My Theme
    thumbnail: my_thumbnail.png
    elements:
        template_set:
            component: core
            importer: template_set
            label: Template set
            require: 1
            data:
                label: MyTheme
                base_path: t/theme_templates
                templates:
                    index:
                        main_index:
                            label: Main Index
                            outfile: index.html
                            rebuild_me: 1
                    ct:
                        content_type:
                            label: Content Type
                            content_type: contenttypecontenttypecontenttype1234567
                            mappings:
                                ct:
                                    archive_type: ContentType
                                    file_template: "%y/%m/%-f"
                                    build_type: 1
                                    preferred: 0
                                ct_preferred:
                                    archive_type: ContentType
                                    file_template: "%y/%m/%-b/%i"
                                    build_type: 1
                                ct_datetime:
                                    archive_type: ContentType
                                    file_template: "%y/%m/%d/%b/%i"
                                    build_type: 2
                                    preferred: 0
                                    datetime_field: datetime
                                ct_cat1:
                                    archive_type: ContentType
                                    file_template: "%-c/%-f"
                                    build_type: 3
                                    preferred: 0
                                    category_field: categories 1
                                ct_cat2:
                                    archive_type: ContentType
                                    file_template: "%y/%m/%-f/%-c"
                                    build_type: 4
                                    preferred: 0
                                    category_field: categories 2
                                ct_datetime_cat1:
                                    archive_type: ContentType
                                    file_template: "%m/%-f/%-c"
                                    build_type: 1
                                    preferred: 0
                                    datetime_field: datetime
                                    category_field: categoriescategoriescategoriescategories
                    ct_archive:
                        content_type_listing:
                            label: 'Content Type Listing'
                            content_type: test_content_type
                            mappings:
                                ct_daily:
                                    archive_type: ContentType-Daily
                                    file_template: "%y/%m/%d/%f"
                                    build_type: 1
                                    datetime_field: datetime
                                ct_weekly:
                                    archive_type: ContentType-Weekly
                                    file_template: "%y/%m/%d-week/%i"
                                    build_type: 2
                                ct_monthly:
                                    archive_type: ContentType-Monthly
                                    file_template: "%y/%m/%i"
                                    build_type: 3
                                    datetime_field: datetime
                                ct_yearly:
                                    archive_type: ContentType-Yearly
                                    file_template: "%y/%i"
                                    build_type: 4

                                ct_author:
                                    archive_type: ContentType-Author
                                    file_template: "author/%-a/%f"
                                    build_type: 1
                                    preferred: 0
                                ct_author_preferred:
                                    archive_type: ContentType-Author
                                    file_template: "author/%a/%f"
                                    build_type: 1
                                ct_author_daily:
                                    archive_type: ContentType-Author-Daily
                                    file_template: "author/%-a/%y/%m/%d/%f"
                                    build_type: 0
                                    datetime_field: datetime
                                ct_author_weekly:
                                    archive_type: ContentType-Author-Weekly
                                    file_template: "author/%-a/%y/%m/%d-week/%f"
                                    build_type: 2
                                ct_author_monthly:
                                    archive_type: ContentType-Author-Monthly
                                    file_template: "author/%-a/%y/%m/%f"
                                    build_type: 3
                                    datetime_field: datetime
                                ct_author_yearly:
                                    archive_type: ContentType-Author-Yearly
                                    file_template: "author/%-a/%y/%f"
                                    build_type: 4

                                ct_cat:
                                    archive_type: ContentType-Category
                                    file_template: "%-c/%i"
                                    build_type: 1
                                    category_field: categories 1
                                ct_cat_daily:
                                    archive_type: ContentType-Category-Daily
                                    file_template: "%-c/%y/%m/%d/%i"
                                    build_type: 0
                                    datetime_field: datetime
                                    category_field: categories 2
                                ct_cat_weekly:
                                    archive_type: ContentType-Category-Weekly
                                    file_template: "%-c/%y/%m/%d-week/%i"
                                    build_type: 2
                                    category_field: categories 1
                                ct_cat_monthly:
                                    archive_type: ContentType-Category-Monthly
                                    file_template: "%-c/%y/%m/%i"
                                    build_type: 3
                                    datetime_field: datetime
                                    category_field: abababababababababababababababababababab
                                ct_cat_yearly:
                                    archive_type: ContentType-Category-Yearly
                                    file_template: "%-c/%y/%i"
                                    build_type: 4
                                    category_field: categories 1
        core_configs:
            component: core
            importer: default_prefs
            label: core configs
            require: 0
            data:
                allow_comment_html: 0
                allow_pings: 0
        default_categories:
            component: core
            importer: default_categories
            require: 1
            data:
                foo:
                    label: another_foo
                xxx:
                    label: moge
                    description: category description.
                    children:
                        yyy:
                            label: foobar
                            description: some other category.
        default_category_sets:
            component: core
            importer: default_category_sets
            data:
                test_category_set:
                    name: test_category_set
                    categories:
                        b:
                            label: b
                            children:
                                a:
                                    label: a
                        c:
                            label: c
        default_content_types:
            component: core
            importer: default_content_types
            data:
                - name: child_content_type
                  unique_id: 1234567890123456789012345678901234567890
                  fields:
                      - label: single_line_text
                        type: single_line_text
                        display: default
                        unique_id: abcdefghijabcdefghijabcdefghijabcdefghij
                - name: test_content_type
                  unique_id: contenttypecontenttypecontenttype1234567
                  fields:
                      - label: single
                        description: single line text
                        type: single_line_text
                        required: 1
                        display: force
                        max_length: 10
                        min_length: 5
                        initial_value: abc
                      - label: multi
                        description: multi line text
                        type: multi_line_text
                        required: 0
                        display: default
                        initial_value: |
                            aaa
                            bbb
                        input_format: markdown
                      - label: number
                        description: number 123
                        type: number
                        required: 0
                        display: default
                        min_value: 1
                        max_value: 10
                        decimal_places: 3
                        initial_value: 345
                      - label: url
                        description: This is a URL field.
                        type: url
                        required: 1
                        display: optional
                        initial_value: https://example.com
                      - label: datetime
                        description: datetime field
                        type: date_and_time
                        required: 0
                        display: optional
                        initial_value: 2017-08-27 11:22:33
                      - label: date
                        description: date field
                        type: date_only
                        required: 1
                        display: default
                        initial_value: 2017-08-03
                      - label: time
                        description: time field
                        type: time_only
                        required: 0
                        display: default
                        initial_value: 10:20:30
                      - label: single_select
                        description: single select field
                        type: select_box
                        required: 0
                        display: default
                        values:
                            - label: a
                              value: 1
                            - label: b
                              value: 2
                            - label: c
                              value: 3
                        multiple: 0
                      - label: multiple_select
                        description: multiple select field
                        type: select_box
                        required: 1
                        display: default
                        values:
                            - label: 1
                              value: a
                            - label: 2
                              value: b
                            - label: 3
                              value: c
                        multiple: 1
                        min: 1
                        max: 3
                      - label: radio
                        description: radio field
                        type: radio_button
                        required: 0
                        display: default
                        values:
                            - label: aa
                              value: 1
                            - label: bb
                              value: 2
                            - label: cc
                              value: 3
                      - label: single checkbox
                        description: single checkbox field
                        type: checkboxes
                        required: 0
                        display: default
                        values:
                            - label: a
                              value: 1
                            - label: b
                              value: 2
                            - label: c
                              value: 3
                            - label: d
                              value: 4
                        multiple: 0
                      - label: multiple checkboxes
                        description: multiple checkboxes field
                        type: checkboxes
                        required: 0
                        display: default
                        values:
                            - label: 1
                              value: a
                            - label: 2
                              value: b
                            - label: 3
                              value: c
                            - label: 4
                              value: d
                        multiple: 1
                        min: 1
                        max: 4
                      - label: asset
                        description: asset field
                        type: asset
                        required: 0
                        display: default
                        multiple: 1
                        allow_upload: 1
                        min: 2
                        max: 4
                      - label: audio
                        description: audio field
                        type: asset_audio
                        required: 1
                        display: none
                        multiple: 1
                        allow_upload: 1
                        min: 3
                        max: 5
                      - label: video
                        description: video field
                        type: asset_video
                        required: 0
                        display: none
                        multiple: 1
                        allow_upload: 0
                        min: 1
                        max: 100
                      - label: image
                        description: image field
                        type: asset_image
                        required: 1
                        display: default
                        multiple: 0
                        allow_upload: 1
                      - label: embedded
                        description: embedded field
                        type: embedded_text
                        required: 0
                        display: default
                        initial_value: |
                            akasatana
                            hamayarawa
                      - label: categories 1
                        description: categories field 1
                        type: categories
                        unique_id: categoriescategoriescategoriescategories
                        required: 1
                        display: default
                        multiple: 1
                        min: 1
                        max: 3
                        category_set: test_category_set
                        can_add: 1
                      - label: categories 2
                        description: categories field 2
                        type: categories
                        unique_id: abababababababababababababababababababab
                        required: 1
                        display: optional
                        multiple: 0
                        category_set: test_category_set
                        can_add: 0
                      - label: tag
                        description: tags field
                        type: tags
                        required: 0
                        display: optional
                        multiple: 1
                        can_add: 1
                        min: 2
                        max: 3
                        initial_value: abc
                      - label: list
                        description: list field
                        type: list
                        required: 1
                        display: default
                      - label: table
                        description: table field
                        type: tables
                        display: optional
                        initial_rows: 3
                        initial_cols: 4
                        increase_decrease_rows: 1
                        increase_decrease_cols: 0
                      - label: content_type_1
                        description: content type field 1
                        type: content_type
                        required: 0
                        display: default
                        multiple: 1
                        can_add: 1
                        min: 5
                        max: 10
                        source: child_content_type
                      - label: content_type_2
                        description: content type field 2
                        type: content_type
                        unique_id: abcdabcdabcdabcdabcdabcdabcdabcdabcdabcd
                        required: 1
                        display: optional
                        multiple: 0
                        can_add: 0
                        source: 1234567890123456789012345678901234567890

very_old_theme:
    id: old_theme
    name: OLD Theme
    label: Old theme
    required_components:
        core: 1.0
    optional_components:
        commercial: 2.0
