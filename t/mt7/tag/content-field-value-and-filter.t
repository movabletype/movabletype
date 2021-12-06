#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => (1 + 2) * blocks;

use MT;
use MT::Test;
use MT::Test::Fixture;
my $app = MT->instance;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        MT::Test::Fixture->prepare(
            {   author => [qw/author/],
                blog   => [
                    {   name  => 'my blog',
                        theme => 'mont-blanc',
                    }
                ],
                content_type => {
                    ct => [
                        cf_multi => {
                            type => 'multi_line_text',
                            name => 'value',
                        }
                    ],
                    ct2 => [
                        cf_content_type => {
                            type   => 'content_type',
                            name   => 'content',
                            source => 'ct',
                        }
                    ],
                },
                content_data => {
                    cd1 => {
                        content_type => 'ct',
                        author       => 'author',
                        label        => 'cd1',
                        data => { cf_multi => '[home](/index.html)', },
                        convert_breaks => { cf_multi => 'markdown', }
                    },
                    cd2 => {
                        content_type => 'ct2',
                        author       => 'author',
                        label        => 'cd2',
                        data         => { cf_content_type => ['cd1'], },
                    },
                },
            }
        );
    }
);

my $blog_id = MT::Blog->load( { name => 'my blog' } )->id;

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

done_testing;

__DATA__

=== FEEDBACK-1493
--- template
<mt:Contents content_type="ct2">
<mt:ContentField content_field="content">
<mt:ContentField content_field="value">
<mt:ContentFieldValue>
</mt:ContentField>
</mt:ContentField>
</mt:Contents>
--- expected
<p><a href="/index.html">home</a></p>
