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
        my $site_01 = MT::Test::Permission->make_website(
            parent_id => 0,
            name      => 'test site 01'
        );

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
    }
);

my $site_01 = MT->model('website')->load( { name => 'test site 01' } );
my $site_02 = MT->model('website')->load( { name => 'test site 02' } );

$vars->{include_blogs} = $site_01->id . ',' . $site_02->id;

MT::Test::Tag->run_perl_tests( $site_01->id );
# MT::Test::Tag->run_php_tests($site_01->id);

__END__

=== mt::Sites mode="loop"
--- template
<mt:Sites include_blogs="[% include_blogs %]" mode="loop"><mt:Contents name="test content data">
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

=== mt::Sites mode="context"
--- template
<mt:Sites include_blogs="[% include_blogs %]" mode="context"><mt:Contents name="test content data">
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

