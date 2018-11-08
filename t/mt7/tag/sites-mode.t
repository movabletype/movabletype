#!/usr/bin/perl

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

use MT::Test::Tag;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $vars = {};

sub var {
    for my $line (@_) {
        for my $key ( keys %{$vars} ) {
            my $replace = quotemeta "[% ${key} %]";
            my $value   = $vars->{$key};
            $line =~ s/$replace/$value/g;
        }
    }
    @_;
}

filters {
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        # Site 1
        #my $site_01 = MT::Test::Permission->make_website(
        #    parent_id => 0,
        #    name      => 'test site 01'
        #);
        my $site_01 = MT->model('website')->load(1);
        $site_01->parent_id(0);
        $site_01->name('test site 01');
        $site_01->save;

        my $ct_01 = MT::Test::Permission->make_content_type(
            name    => 'test content data',
            blog_id => $site_01->id,
        );
        my $cf_single_line_text_01
            = MT::Test::Permission->make_content_field(
            blog_id         => $ct_01->blog_id,
            content_type_id => $ct_01->id,
            name            => 'single line text 01',
            type            => 'single_line_text',
            );
        my $fields_01 = [
            {   id        => $cf_single_line_text_01->id,
                order     => 1,
                type      => $cf_single_line_text_01->type,
                options   => { label => $cf_single_line_text_01->name },
                unique_id => $cf_single_line_text_01->unique_id,
            },
        ];
        $ct_01->fields($fields_01);
        $ct_01->save or die $ct_01->errstr;
        my $count_01 = 1;

        for ( 1 .. 5 ) {
            MT::Test::Permission->make_content_data(
                blog_id         => $site_01->id,
                content_type_id => $ct_01->id,
                data            => {
                    $cf_single_line_text_01->id => 'test single line text '
                        . $count_01,
                },
            );
            $count_01++;
        }

        # Site 2
        my $site_02 = MT::Test::Permission->make_website(
            parent_id => 0,
            name      => 'test site 02'
        );

        my $ct_02 = MT::Test::Permission->make_content_type(
            name    => 'test content data',
            blog_id => $site_02->id,
        );
        my $cf_single_line_text_02
            = MT::Test::Permission->make_content_field(
            blog_id         => $ct_02->blog_id,
            content_type_id => $ct_02->id,
            name            => 'single line text 02',
            type            => 'single_line_text',
            );
        my $fields_02 = [
            {   id        => $cf_single_line_text_02->id,
                order     => 1,
                type      => $cf_single_line_text_02->type,
                options   => { label => $cf_single_line_text_02->name },
                unique_id => $cf_single_line_text_02->unique_id,
            },
        ];
        $ct_02->fields($fields_02);
        $ct_02->save or die $ct_02->errstr;
        my $count_02 = 6;

        for ( 1 .. 5 ) {
            MT::Test::Permission->make_content_data(
                blog_id         => $site_02->id,
                content_type_id => $ct_02->id,
                data            => {
                    $cf_single_line_text_02->id => 'test single line text '
                        . $count_02,
                },
            );
            $count_02++;
        }

        # Blog 1
        my $blog_01 = MT::Test::Permission->make_blog(
            parent_id => 1,
            name      => 'test blog 01'
        );

        my $ct_03 = MT::Test::Permission->make_content_type(
            name    => 'test content data',
            blog_id => $blog_01->id,
        );
        my $cf_single_line_text_03
            = MT::Test::Permission->make_content_field(
            blog_id         => $ct_03->blog_id,
            content_type_id => $ct_03->id,
            name            => 'single line text 03',
            type            => 'single_line_text',
            );
        my $fields_03 = [
            {   id        => $cf_single_line_text_03->id,
                order     => 1,
                type      => $cf_single_line_text_03->type,
                options   => { label => $cf_single_line_text_03->name },
                unique_id => $cf_single_line_text_03->unique_id,
            },
        ];
        $ct_03->fields($fields_03);
        $ct_03->save or die $ct_03->errstr;
        my $count_03 = 11;

        for ( 1 .. 5 ) {
            MT::Test::Permission->make_content_data(
                blog_id         => $blog_01->id,
                content_type_id => $ct_03->id,
                data            => {
                    $cf_single_line_text_03->id => 'test single line text '
                        . $count_03,
                },
            );
            $count_03++;
        }

        # Blog 2
        my $blog_02 = MT::Test::Permission->make_blog(
            parent => 2,
            name   => 'test blog 02'
        );

        my $ct_04 = MT::Test::Permission->make_content_type(
            name    => 'test content data',
            blog_id => $blog_02->id,
        );
        my $cf_single_line_text_04
            = MT::Test::Permission->make_content_field(
            blog_id         => $ct_04->blog_id,
            content_type_id => $ct_04->id,
            name            => 'single line text 04',
            type            => 'single_line_text',
            );
        my $fields_04 = [
            {   id        => $cf_single_line_text_04->id,
                order     => 1,
                type      => $cf_single_line_text_04->type,
                options   => { label => $cf_single_line_text_04->name },
                unique_id => $cf_single_line_text_04->unique_id,
            },
        ];
        $ct_04->fields($fields_04);
        $ct_04->save or die $ct_04->errstr;
        my $count_04 = 16;

        for ( 1 .. 5 ) {
            MT::Test::Permission->make_content_data(
                blog_id         => $blog_02->id,
                content_type_id => $ct_04->id,
                data            => {
                    $cf_single_line_text_04->id => 'test single line text '
                        . $count_04,
                },
            );
            $count_04++;
        }
    }
);

my $site_01 = MT->model('website')->load( { name => 'test site 01' } );
my $site_02 = MT->model('website')->load( { name => 'test site 02' } );
my $blog_01 = MT->model('blog')->load( { name => 'test blog 01' } );
my $blog_02 = MT->model('blog')->load( { name => 'test blog 02' } );

$vars->{include_sites} = $site_01->id . ',' . $site_02->id;
$vars->{include_blogs} = $blog_01->id . ',' . $blog_02->id;
$vars->{site_01_id}    = $site_01->id;
$vars->{site_02_id}    = $site_02->id;
$vars->{blog_01_id}    = $blog_01->id;
$vars->{blog_02_id}    = $blog_02->id;

MT::Test::Tag->run_perl_tests( $site_01->id );

# MT::Test::Tag->run_php_tests($site_01->id);

__END__

=== mt:Sites mode="loop"
--- template
<mt:Sites include_sites="[% include_sites %]" mode="loop"><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:Sites>
--- expected
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1
test single line text 10
test single line text 9
test single line text 8
test single line text 7
test single line text 6

=== mt:Sites mode="context"
--- template
<mt:Sites include_sites="[% include_sites %]" mode="context"><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:Sites>
--- expected
test single line text 10
test single line text 9
test single line text 8
test single line text 7
test single line text 6
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1

=== mt:ChildSites mode="loop"
--- template
<mt:ChildSites include_sites="[% include_blogs %]" mode="loop"><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:ChildSites>
--- expected
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16

=== mt:ChildSites mode="context"
--- template
<mt:ChildSites include_sites="[% include_blogs %]" mode="context"><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:ChildSites>
--- expected
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11

=== mt:MultiBlog mode="loop"
--- template
<mt:MultiBlog include_sites="[% include_sites %]" mode="loop"><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:MultiBlog>
--- expected
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1
test single line text 10
test single line text 9
test single line text 8
test single line text 7
test single line text 6

=== mt::MultiBlog mode="context"
--- template
<mt:MultiBlog include_sites="[% include_sites %]" mode="context"><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:MultiBlog>
--- expected
test single line text 10
test single line text 9
test single line text 8
test single line text 7
test single line text 6
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1

=== mt:SitesLocalSite
--- template
<mt:Sites blog_id="[% site_02_id %]"><mt:SitesLocalSite><mt:SiteID></mt:SitesLocalSite></mt:Sites>
--- expected
[% site_01_id %]

=== mt:SitesIfLocalSite
--- template
<mt:Sites><mt:SitesIfLocalSite><mt:SiteID></mt:SitesIfLocalSite></mt:Sites>
--- expected
[% site_01_id %]

=== mt:MultiBlogLocalBlog
--- template
<mt:MultiBlog blog_id="[% site_02_id %]"><mt:MultiBlogLocalBlog><mt:BlogID></mt:MultiBlogLocalBlog></mt:MultiBlog>
--- expected
[% site_01_id %]

=== mt:MultiBlogIfLocalBlog
--- template
<mt:MultiBlog><mt:MultiBlogIfLocalBlog><mt:BlogID></mt:MultiBlogIfLocalBlog></mt:MultiBlog>
--- expected
[% site_01_id %]

=== mt:ChildSites in mt:Sites no mode
--- template
<mt:Sites><mt:ChildSites><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:ChildSites></mt:Sites>
--- expected
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16

=== mt:Sites nested and no mode
--- template
<mt:Sites><mt:Sites><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:Sites></mt:Sites>
--- expected
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1
test single line text 10
test single line text 9
test single line text 8
test single line text 7
test single line text 6
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1
test single line text 10
test single line text 9
test single line text 8
test single line text 7
test single line text 6

=== mt:ChildSites nested and no mode
--- template
<mt:ChildSites><mt:ChildSites><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:ChildSites></mt:ChildSites>
--- expected
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16

=== mt:ChildSites in mt:Sites mode="loop"
--- template
<mt:Sites><mt:ChildSites mode="loop"><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:ChildSites></mt:Sites>
--- expected
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16

=== mt:Sites nested and mode="loop"
--- template
<mt:Sites><mt:Sites mode="loop"><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:Sites></mt:Sites>
--- expected
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1
test single line text 10
test single line text 9
test single line text 8
test single line text 7
test single line text 6
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1
test single line text 10
test single line text 9
test single line text 8
test single line text 7
test single line text 6

=== mt:ChildSites nested and mode="loop"
--- template
<mt:ChildSites><mt:ChildSites mode="loop"><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:ChildSites></mt:ChildSites>
--- expected
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16

=== mt:ChildSites in mt:Sites mode="context"
--- template
<mt:Sites><mt:ChildSites mode="context"><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:ChildSites></mt:Sites>
--- expected
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1
test single line text 10
test single line text 9
test single line text 8
test single line text 7
test single line text 6

=== mt:Sites nested and mode="context"
--- template
<mt:Sites><mt:Sites mode="context"><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:Sites></mt:Sites>
--- expected
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1
test single line text 10
test single line text 9
test single line text 8
test single line text 7
test single line text 6

=== mt:ChildSites nested and mode="context"
--- template
<mt:ChildSites><mt:ChildSites mode="context"><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:ChildSites></mt:ChildSites>
--- expected
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16

=== mt:ChildSites in mt:Sites mode="context"
--- template
<mt:Sites mode="context"><mt:ChildSites><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:ChildSites></mt:Sites>
--- expected
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16

=== mt:Sites nested and mode="context"
--- template
<mt:Sites mode="context"><mt:Sites><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:Sites></mt:Sites>
--- expected
test single line text 5
test single line text 4
test single line text 3
test single line text 2
test single line text 1
test single line text 10
test single line text 9
test single line text 8
test single line text 7
test single line text 6

=== mt:ChildSites nested and mode="context"
--- template
<mt:ChildSites mode="context"><mt:ChildSites><mt:Contents content_type="test content data">
<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents></mt:ChildSites></mt:ChildSites>
--- expected
test single line text 15
test single line text 14
test single line text 13
test single line text 12
test single line text 11
test single line text 20
test single line text 19
test single line text 18
test single line text 17
test single line text 16

