package MT::Test::Fixture::DataApiSearch;

use strict;
use warnings;
use base 'MT::Test::Fixture::ArchiveType';

our %FixtureSpec = (
    author => [qw/author/],
    blog   => [{
        name          => 'My Site',
        server_offset => 0,
        site_path     => 'TEST_ROOT/site',
        archive_path  => 'TEST_ROOT/site/archive',
    }],
    image => {
        'test.jpg' => {
            id          => 1,
            label       => 'Sample Image 1',
            description => 'Sample photo',
        },
        'test2.jpg' => {
            id          => 2,
            label       => 'Sample Image 2',
            description => 'Sample photo',
            parent      => 'test.jpg',
        },
        'test3.png' => {
            id          => 3,
            label       => 'Sample Image 3',
            description => 'Sample photo',
        },
        'test1000.png' => {
            id          => 1000,
            label       => 'Sample Image 1000',
            description => 'Sample photo',
        },
    },
    tag          => ['tag1', 'tag2', 'tag3', '0', 'tagtext'],
    category_set => {
        'test category set' => [qw/ category1 category2 category3 /],
        'category set 0'    => ['0'],
    },
    content_type => {
        simple_ct => {
            name   => 'simple_ct',
            fields => [
                myfield => { type => 'single_line_text', name => 'myfield' },
            ],
        },
        simple_ct_blog_id1 => {
            name    => 'simple_ct_blog_id1',
            blog_id => 1,                      # First Website
            fields  => [
                myfield => { type => 'single_line_text', name => 'myfield' },
            ],
        },
        pagination => {
            name   => 'pagination',
            fields => [
                myfield => { type => 'single_line_text', name => 'myfield' },
            ],
        },
        content_field => {
            name   => 'content_field',
            fields => [
                mynumber => { type => 'number', name => 'mynumber' },
            ],
        },
        content_field2 => {
            name   => 'content_field2',
            fields => [
                myasset_image => {
                    type    => 'asset_image',
                    name    => 'myasset_image',
                    options => { multiple => 1, max => 2, min => 1 },
                },
            ],
        },
    },
    content_data => {
        simple_cd1 => {
            content_type => 'simple_ct',
            author       => 'author',
            data         => { myfield => 'FOO' },
        },
        simple_cd2 => {
            content_type => 'simple_ct',
            author       => 'author',
            data         => { myfield => 'FOO BAR' },
        },
        simple_cd3 => {
            content_type => 'simple_ct',
            author       => 'author',
            data         => { myfield => 'BAZ YADA' },
        },
        simple_cd4 => {
            blog_id      => 1,                      # First Website
            content_type => 'simple_ct_blog_id1',
            author       => 'author',
            data         => { myfield => 'BAZ' },
        },
        content_field1 => {
            content_type => 'content_field',
            author       => 'author',
            data         => { mynumber => '12345' },
        },
        content_field2 => {
            content_type => 'content_field',
            author       => 'author',
            data         => { mynumber => '12341' },
        },
        content_field3 => {
            content_type => 'content_field',
            author       => 'author',
            data         => { mynumber => '12342' },
        },
        content_field4 => {
            content_type => 'content_field2',
            author       => 'author',
            data         => { myasset_image => ['test.jpg', 'test1000.png'] },
        },
    },
);

sub fixture_spec { \%FixtureSpec }

1;
