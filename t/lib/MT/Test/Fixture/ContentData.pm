package MT::Test::Fixture::ContentData;

use strict;
use warnings;
use base 'MT::Test::Fixture::ArchiveType';

my $invalid_id = 1000;
our %FixtureSpec = (
    author => [qw/author/],
    blog   => [
        {   name          => 'My Site',
            server_offset => 0,
            site_path     => 'TEST_ROOT/site',
            archive_path  => 'TEST_ROOT/site/archive',
        }
    ],
    image => {
        'test.jpg' => {
            label       => 'Sample Image 1',
            description => 'Sample photo',
        },
        'test2.jpg' => {
            label       => 'Sample Image 2',
            description => 'Sample photo',
            parent      => 'test.jpg',
        },
        'test3.png' => {
            label       => 'Sample Image 3',
            description => 'Sample photo',
        },
    },
    tag          => [ 'tag1', 'tag2', 'tag3', '0' ],
    category_set => {
        'test category set' => [qw/ category1 category2 category3 /],
        'category set 0'    => ['0'],
    },
    content_type => {
        ct => {
            name   => 'test content data',
            fields => [
                cf_single_line_text => {
                    type => 'single_line_text',
                    name => 'single line text',
                },
                cf_single_line_text_no_data => {
                    type => 'single_line_text',
                    name => 'single line text no data',
                },
                cf_multi_line_text => {
                    type => 'multi_line_text',
                    name => 'multi line text',
                },
                cf_number => {
                    type => 'number',
                    name => 'number',
                },
                cf_url => {
                    type => 'url',
                    name => 'url',
                },
                cf_embedded_text => {
                    type => 'embedded_text',
                    name => 'embedded text',
                },
                cf_datetime => {
                    type => 'date_and_time',
                    name => 'date and time',
                },
                cf_date => {
                    type => 'date_only',
                    name => 'date_only',
                },
                cf_time => {
                    type => 'time_only',
                    name => 'time_only',
                },
                cf_select_box => {
                    type   => 'select_box',
                    name   => 'select box',
                    values => [
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
                    ],
                },
                cf_radio => {
                    type   => 'radio_button',
                    name   => 'radio button',
                    values => [
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
                    ],
                },
                cf_checkboxes => {
                    type   => 'checkboxes',
                    name   => 'checkboxes',
                    values => [
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
                    ],
                    multiple => 1,
                    max      => 3,
                    min      => 1,
                },
                cf_list => {
                    type => 'list',
                    name => 'list',
                },
                cf_tables => {
                    type         => 'tables',
                    name         => 'tables',
                    initial_rows => 3,
                    initial_cols => 3,
                },
                cf_tags => {
                    type     => 'tags',
                    name     => 'tags',
                    multiple => 1,
                    max      => 5,
                    min      => 1,
                },
                cf_categories => {
                    type         => 'categories',
                    name         => 'categories',
                    category_set => 'test category set',
                    options      => {
                        multiple => 1,
                        max      => 5,
                        min      => 1,
                    },
                },
                cf_image => {
                    type    => 'asset_image',
                    name    => 'asset_image',
                    options => {
                        multiple => 1,
                        max      => 5,
                        min      => 1,
                    },
                },
                cf_image_single => {
                    type    => 'asset_image',
                    name    => 'asset_image_single',
                    options => {
                        multiple => 0,
                        max      => 1,
                        min      => 1,
                    },
                },
                cf_content_type => {
                    type   => 'content_type',
                    name   => 'content type',
                    source => 'ct2',
                },
                cf_text_label => {
                    type => 'text_label',
                    name => 'text label',
                },
            ],
        },
        ct2 => {
            name   => 'Content Type',
            fields => [
                cf_single_line_text => {
                    type => 'single_line_text',
                    name => 'single line text',
                },
                cf_single_line_text_no_data => {
                    type => 'single_line_text',
                    name => 'single line text no data',
                },
                cf_number => {
                    type => 'number',
                    name => 'number',
                },
            ],
        },
        ct_multi => {
            name   => 'test multiple content data',
            fields => [
                cf_single_line_text => {
                    type => 'single_line_text',
                    name => 'single line text',
                },
                cf_single_line_text_no_data => {
                    type => 'single_line_text',
                    name => 'single line text no data',
                },
                cf_multi_line_text => {
                    type => 'multi_line_text',
                    name => 'multi line text',
                },
                cf_number => {
                    type => 'number',
                    name => 'number',
                },
                cf_url => {
                    type => 'url',
                    name => 'url',
                },
                cf_embedded_text => {
                    type => 'embedded_text',
                    name => 'embedded text',
                },
                cf_datetime => {
                    type => 'date_and_time',
                    name => 'date and time',
                },
                cf_date => {
                    type => 'date_only',
                    name => 'date_only',
                },
                cf_time => {
                    type => 'time_only',
                    name => 'time_only',
                },
                cf_select_box => {
                    type   => 'select_box',
                    name   => 'select box',
                    values => [
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
                    ],
                },
                cf_radio => {
                    type   => 'radio_button',
                    name   => 'radio button',
                    values => [
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
                    ],
                },
                cf_checkboxes => {
                    type   => 'checkboxes',
                    name   => 'checkboxes',
                    values => [
                        { label => 'abc', value => 1 },
                        { label => 'def', value => 2 },
                        { label => 'ghi', value => 3 },
                    ],
                    multiple => 1,
                    max      => 3,
                    min      => 1,
                },
                cf_list => {
                    type => 'list',
                    name => 'list',
                },
                cf_tables => {
                    type         => 'tables',
                    name         => 'tables',
                    initial_rows => 3,
                    initial_cols => 3,
                },
                cf_tags => {
                    type     => 'tags',
                    name     => 'tags',
                    multiple => 1,
                    max      => 5,
                    min      => 1,
                },
                cf_categories => {
                    type         => 'categories',
                    name         => 'categories',
                    category_set => 'test category set',
                    options      => {
                        multiple => 1,
                        max      => 5,
                        min      => 1,
                    },
                },
                cf_image => {
                    type    => 'asset_image',
                    name    => 'asset_image',
                    options => {
                        multiple => 1,
                        max      => 5,
                        min      => 1,
                    },
                },
                cf_content_type => {
                    type   => 'content_type',
                    name   => 'content type',
                    source => 'ct2',
                },
            ],
        },
        ## MTC-25873
        ct0 => {
            name   => 'case 0',
            fields => [
                cf_single_line_text0 => {
                    type => 'single_line_text',
                    name => 'single_line_text',
                },
                cf_multi_line_text0 => {
                    type => 'multi_line_text',
                    name => 'multi_line_text',
                },
                cf_number0 => {
                    type => 'number',
                    name => 'number',
                },
                cf_embedded_text0 => {
                    type => 'embedded_text',
                    name => 'embedded_text',
                },
                cf_select_box0 => {
                    type    => 'select_box',
                    name    => 'select_box',
                    options => { values => [ { label => '0', value => 0 } ], },
                },
                cf_radio_button0 => {
                    type    => 'radio_button',
                    name    => 'radio_button',
                    options => {
                        values => [
                            { label => '0', value => 0 },
                            { label => '0', value => 1 },
                            { label => '0', value => 2 },
                        ],
                    },
                },
                cf_checkboxes0 => {
                    type    => 'checkboxes',
                    name    => 'checkboxes',
                    options => {
                        values => [
                            { label => '0', value => 0 },
                            { label => '0', value => 1 },
                            { label => '0', value => 2 },
                        ],
                        multiple => 1,
                        max      => 3,
                        min      => 1,
                    },
                },
                cf_list0 => {
                    type => 'list',
                    name => 'list',
                },
                cf_tables0 => {
                    type    => 'tables',
                    name    => 'tables',
                    options => {
                        initial_rows => 3,
                        initial_cols => 3,
                    },
                },
                cf_tags0 => {
                    type    => 'tags',
                    name    => 'tags',
                    options => {
                        multiple => 0,
                        max      => 5,
                        min      => 1,
                    },
                },
                cf_multi_tags0 => {
                    type    => 'tags',
                    name    => 'multi_tags',
                    options => {
                        multiple => 1,
                        max      => 5,
                        min      => 1,
                    }
                },
                cf_categories0 => {
                    type         => 'categories',
                    name         => 'categories',
                    category_set => 'category set 0',
                    options      => {
                        multiple => 0,
                        max      => 5,
                        min      => 1,
                    },
                },
                cf_multi_categories0 => {
                    type         => 'categories',
                    name         => 'multi_categories',
                    category_set => 'category set 0',
                    options      => {
                        multiple => 1,
                        max      => 5,
                        min      => 1,
                    },
                },
            ],
        },
    },
    content_data => {
        cd => {
            content_type => 'ct',
            author       => 'author',
            data         => {
                cf_single_line_text         => 'test single line text',
                cf_single_line_text_no_data => '',
                cf_multi_line_text          => "test multi line text\naaaaa",
                cf_number                   => '12345',
                cf_url                      => 'https://example.com/~abby',
                cf_embedded_text            => "abc\ndef",
                cf_datetime                 => '20170603180500',
                cf_date                     => '20170605000000',
                cf_time                     => '19700101123456',
                cf_select_box               => [2],
                cf_radio                    => [3],
                cf_checkboxes               => [ 1, 3 ],
                cf_list                     => [ 'aaa', 'bbb', 'ccc' ],
                cf_tables                   => "<tr><td>1</td><td></td><td></td></tr>\n"
                    . "<tr><td></td><td>2</td><td></td></tr>\n"
                    . "<tr><td></td><td></td><td>3</td></tr>",
                cf_tags         => [ 'tag2',      'tag1',      \$invalid_id ],
                cf_categories   => [ 'category2', 'category1', \$invalid_id ],
                cf_image        => [ 'test2.jpg', 'test.jpg',  \$invalid_id ],
                cf_image_single => [ 'test2.jpg' ],
                cf_content_type => [ 'cd2',       \$invalid_id ],
                cf_text_label => '',
            },
        },
        cd2 => {
            content_type => 'ct2',
            author       => 'author',
            data         => {
                cf_single_line_text         => 'test single line text2',
                cf_single_line_text_no_data => '',
                cf_number                   => '12345',
            },
        },
        cd_multi => {
            content_type => 'ct_multi',
            author       => 'author',
            data         => {
                cf_single_line_text         => 'test single line text multi1',
                cf_single_line_text_no_data => '',
                cf_multi_line_text          => "test multi line text\naaaaa",
                cf_number                   => '12345',
                cf_url                      => 'https://example.com/~abby',
                cf_embedded_text            => "abc\ndef",
                cf_datetime                 => '20170603180500',
                cf_date                     => '20170605000000',
                cf_time                     => '19700101123456',
                cf_select_box               => [2],
                cf_radio                    => [3],
                cf_checkboxes               => [ 1, 3 ],
                cf_list                     => [ 'aaa', 'bbb', 'ccc' ],
                cf_tables                   => "<tr><td>1</td><td></td><td></td></tr>\n"
                    . "<tr><td></td><td>2</td><td></td></tr>\n"
                    . "<tr><td></td><td></td><td>3</td></tr>",
                cf_tags         => [ 'tag2',      'tag1',      \$invalid_id ],
                cf_categories   => [ 'category2', 'category1', \$invalid_id ],
                cf_image        => [ 'test2.jpg', 'test.jpg',  \$invalid_id ],
                cf_content_type => [ 'cd2',       \$invalid_id ],
            },
        },
        cd_multi2 => {
            content_type => 'ct_multi',
            author       => 'author',
            data         => {
                cf_single_line_text         => 'test single line text multi2',
                cf_single_line_text_no_data => '',
                cf_multi_line_text          => "test multi line text2\naaaaa",
                cf_number                   => '123456789',
                cf_url                      => 'https://example.jp/~abby',
                cf_embedded_text            => "abc\ndef\nghi",
                cf_datetime                 => '20200603180500',
                cf_date                     => '20200605000000',
                cf_time                     => '19710101123456',
                cf_select_box               => [1],
                cf_radio                    => [2],
                cf_checkboxes               => [2],
                cf_list                     => [ 'aaa', 'bbb', 'ccc', 'ddd' ],
                cf_tables                   => "<tr><td>2-1</td><td></td><td></td></tr>\n"
                    . "<tr><td></td><td>2-2</td><td></td></tr>\n"
                    . "<tr><td></td><td></td><td>2-3</td></tr>",
                cf_tags         => [ 'tag3' ],
                cf_categories   => [ 'category3' ],
                cf_image        => [ 'test2.jpg' ],
                cf_content_type => [ 'cd2' ],
            },
        },
        cd0 => {
            content_type   => 'ct0',
            author         => 'author',
            label          => '0',
            convert_breaks => { cf_multi_line_text0 => 0, },
            data           => {
                cf_single_line_text0 => '0',
                cf_multi_line_text0  => '0',
                cf_number0           => '0',
                cf_embedded_text0    => '0',
                cf_select_box0       => '0',
                cf_radio_button0     => '0',
                cf_checkboxes0       => '0',
                cf_tables0     => "<tr><th>0</th><td>0</td></tr>" . "<tr><td>0</td><td>0</td></tr>",
                cf_tags0       => ['0'],
                cf_categories0 => ['0'],
                cf_multi_tags0 => ['0'],
                cf_multi_categories0 => ['0'],
                cf_list0             => ['0'],
            },
        },
    },
);

sub fixture_spec { \%FixtureSpec }

1;
