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

my $blog_id = 1;

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

        my $ct = MT::Test::Permission->make_content_type(
            name    => 'test content data',
            blog_id => $blog_id,
        );

        my $cf1 = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'single1',
            type            => 'single_line_text',
        );
        my $cf2 = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'single2',
            type            => 'single_line_text',
        );

        my $fields = [
            {   id        => $cf1->id,
                order     => 1,
                type      => $cf1->type,
                options   => { label => $cf1->name },
                unique_id => $cf1->unique_id,
            },
            {   id        => $cf2->id,
                order     => 10,
                type      => $cf2->type,
                options   => { label => $cf2->name },
                unique_id => $cf2->unique_id,
            },
        ];
        $ct->fields($fields);
        $ct->save or die $ct->errstr;

        my $cd = MT::Test::Permission->make_content_data(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            author_id       => 1,
            data            => {
                $cf1->id => 'test1',
                $cf2->id => 'test2',
            },
        );
    }
);

my $cf = MT->model('cf')->load( { name => 'single1' } );
my $ct = MT->model('content_type')->load( $cf->content_type_id );

$vars->{cf_id}         = $cf->id;
$vars->{cf_uid}        = $cf->unique_id;
$vars->{cf_type}       = $cf->type;
$vars->{cf_order}      = $ct->fields->[0]{order};
$vars->{cf_type_label} = 'Single Line Text';

MT::Test::Tag->run_perl_tests($blog_id);

# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentFields with content_field_id
--- template
<mt:Contents content_type="test content data"><mt:ContentFields><mt:ContentFieldsHeader>Header</mt:ContentFieldsHeader>
<mt:if name="content_field_id" eq="[% cf_id %]"><mt:ContentField><mt:var name="__value__"></mt:ContentField><mt:else><mt:var name="content_field_order"></mt:if>
<mt:ContentFieldsFooter>Footer</mt:ContentFieldsFooter></mt:ContentFields></mt:Contents>
--- expected
Header
test1

10
Footer

=== MT::ContentFields with content_field_unique_id
--- template
<mt:Contents content_type="test content data"><mt:ContentFields><mt:ContentFieldsHeader>Header</mt:ContentFieldsHeader>
<mt:if name="content_field_unique_id" eq="[% cf_uid %]"><mt:ContentField><mt:var name="__value__"></mt:ContentField><mt:else><mt:var name="content_field_order"></mt:if>
<mt:ContentFieldsFooter>Footer</mt:ContentFieldsFooter></mt:ContentFields></mt:Contents>
--- expected
Header
test1

10
Footer

=== MT::ContentFields with content_field_type
--- template
<mt:Contents content_type="test content data"><mt:ContentFields><mt:ContentFieldsHeader>Header</mt:ContentFieldsHeader>
<mt:if name="content_field_type" eq="[% cf_type %]"><mt:ContentField><mt:var name="__value__"></mt:ContentField><mt:else><mt:var name="content_field_order"></mt:if>
<mt:ContentFieldsFooter>Footer</mt:ContentFieldsFooter></mt:ContentFields></mt:Contents>
--- expected
Header
test1

test2
Footer

=== MT::ContentFields with content_field_order
--- template
<mt:Contents content_type="test content data"><mt:ContentFields><mt:ContentFieldsHeader>Header</mt:ContentFieldsHeader>
<mt:if name="content_field_order" eq="[% cf_order %]"><mt:ContentField><mt:var name="__value__"></mt:ContentField><mt:else><mt:var name="content_field_order"></mt:if>
<mt:ContentFieldsFooter>Footer</mt:ContentFieldsFooter></mt:ContentFields></mt:Contents>
--- expected
Header
test1

10
Footer

=== MT::ContentFields with content_field_options
--- template
<mt:Contents content_type="test content data"><mt:ContentFields><mt:ContentFieldsHeader>Header</mt:ContentFieldsHeader>
<mt:if name="content_field_options{label}" eq="single1"><mt:ContentField><mt:var name="__value__"></mt:ContentField><mt:else><mt:var name="content_field_order"></mt:if>
<mt:ContentFieldsFooter>Footer</mt:ContentFieldsFooter></mt:ContentFields></mt:Contents>
--- expected
Header
test1

10
Footer

=== MT::ContentFields with content_field_type_label
--- template
<mt:Contents content_type="test content data"><mt:ContentFields><mt:ContentFieldsHeader>Header</mt:ContentFieldsHeader>
<mt:if name="content_field_type_label" eq="[% cf_type_label %]"><mt:ContentField><mt:var name="__value__"></mt:ContentField><mt:else><mt:var name="content_field_order"></mt:if>
<mt:ContentFieldsFooter>Footer</mt:ContentFieldsFooter></mt:ContentFields></mt:Contents>
--- expected
Header
test1

test2
Footer

=== MT::ContentFields with content_field_type_label
--- template
<mt:Contents content_type="test content data"><mt:ContentFields>
<mt:if name="__first__">first</mt:if><mt:if name="__last__">last</mt:if><mt:if name="__odd__">odd</mt:if><mt:if name="__even__">even</mt:if><mt:var name="__counter__">
</mt:ContentFields></mt:Contents>
--- expected
firstodd1

lasteven2
