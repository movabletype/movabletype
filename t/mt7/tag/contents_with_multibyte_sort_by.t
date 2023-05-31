use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        StaticWebPath => '/cgi-bin/mt-static/',
    );
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
            data         => {
                cf_text => 'text 2',
            },
        },
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

=== basic
--- template
<mt:Contents content_type="ct"><mt:ContentFields><mt:ContentField><mt:ContentFieldValue>
</mt:ContentField></mt:ContentFields></mt:Contents>
--- expected
text 2
text 1

=== multibyte sort by (ascending order)
--- template
<mt:Contents content_type="ct" sort_by="field:テキスト" sort_order="ascend"><mt:ContentField content_field="テキスト"><mt:ContentFieldValue>
</mt:ContentField></mt:Contents>
--- expected
text 1
text 2

=== multibyte sort by (descending order)
--- template
<mt:Contents content_type="ct" sort_by="field:テキスト" sort_order="descend"><mt:ContentField content_field="テキスト"><mt:ContentFieldValue>
</mt:ContentField></mt:Contents>
--- expected
text 2
text 1
