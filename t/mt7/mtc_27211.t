use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Fixture;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        MT::Test::Fixture->prepare(
            {   author => [qw/author/],
                blog   => [
                    {   name     => 'my_blog',
                        theme_id => 'mont-blanc',
                    }
                ],
                content_type => {
                    ct  => [ cf_text => 'single_line_text', ],
                },
                content_data => {
                    first_cd => {
                        content_type => 'ct',
                        author       => 'author',
                        authored_on  => '20200202000000',
                        label        => 'first_cd',
                        data         => { cf_text => 'first content data', },
                    },
                },
                template => [
                    {   archive_type => 'ContentType',
                        name         => 'tmpl_ct',
                        content_type => 'ct',
                        text         => <<'TMPL',
<mt:CanonicalURL>
TMPL
                        mapping => [
                            {   file_template =>
                                    '%y/%m/%d/%f',
                                is_preferred => 1,
                            },
                            {   file_template =>
                                    'author/%-a/%-f',
                            },
                        ],
                    },
                ],
            }
        );
    }
);

subtest 'MTC-27211' => sub {
    my $blog = MT::Blog->load({name => 'my_blog'});
    eval {
        MT->publisher->rebuild(BlogID => $blog->id);
    };
    my $err = $@;
    ok !$err, 'No errors on Content Type Archive with multiple archive mappings';
};

done_testing;
