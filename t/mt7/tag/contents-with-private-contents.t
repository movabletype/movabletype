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

use utf8;

use MT::Test::Tag;
use MT::Test::PHP;

plan tests => (1 + 2) * blocks;

use MT;
use MT::Test;
use MT::Test::Fixture;
my $app = MT->instance;

$test_env->prepare_fixture('db');
my $objs = MT::Test::Fixture->prepare({
    website => [{
        name         => 'Test Site',
        site_path    => 'TEST_ROOT/site',
        archive_path => 'TEST_ROOT/site/archive',
    }],
    content_type => {
        ct => {
            fields => [
                cf_text => {
                    type => 'single_line_text',
                    name => 'テキスト',
                },
            ],
        },
        parent => {
            fields => [
                cf_ct => {
                    type   => 'content_type',
                    name   => 'コンテンツタイプ',
                    source => 'ct',
                },
            ],
        },
    },
    content_data => {
        cd => {
            content_type => 'ct',
            data         => {
                cf_text => 'text 1',
            },
        },
        cd2 => {
            content_type => 'ct',
            status       => 'draft',
            data         => {
                cf_text => 'text 2',
            },
        },
        cd3 => {
            content_type => 'ct',
            data         => {
                cf_text => 'text 3',
            },
        },
        cd_parent => {
            content_type => 'parent',
            data         => {
                cf_ct => [qw(cd cd2 cd3)],
            }
        }
    },
});

my $blog_id = $objs->{blog_id};

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== show private data
--- template
<mt:Contents content_type="parent"><mt:ContentFields><mt:ContentField><mt:ContentFieldLabel>: <mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields>
</mt:ContentField></mt:ContentFields></mt:Contents>
--- mt_config
{ HidePrivateRelatedContentData => 0 }
--- expected
コンテンツタイプ: text 1
コンテンツタイプ: text 2
コンテンツタイプ: text 3

=== hide private data
--- template
<mt:Contents content_type="parent"><mt:ContentFields><mt:ContentField><mt:ContentFieldLabel>: <mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields>
</mt:ContentField></mt:ContentFields></mt:Contents>
--- mt_config
{ HidePrivateRelatedContentData => 1 }
--- expected
コンテンツタイプ: text 1
コンテンツタイプ: text 3
