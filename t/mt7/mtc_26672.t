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

use File::Find ();

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::ContentStatus;
use MT::Test::App;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    MT::Test::Fixture->prepare({
        author => [qw/author/],
        blog   => [{
            name     => 'my_blog',
            theme_id => 'mont-blanc',
        }],
        content_type => {
            ct  => [cf_text => 'single_line_text',],
            ct2 => [cf_text => 'single_line_text',],
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
        template => [{
                archive_type => 'ContentType-Monthly',
                name         => 'tmpl_ct_monthly',
                content_type => 'ct',
                text         => <<'TMPL',
<mt:Contents>Content <mt:ContentId>: <mt:ContentLabel>
</mt:Contents>
TMPL
                mapping => [{
                        file_template => 'ct/<mt:ArchiveDate format="%Y%m">.html',
                    },
                ],
            },
            {
                archive_type => 'ContentType-Monthly',
                name         => 'tmpl_ct2_monthly',
                content_type => 'ct2',
                text         => <<'TMPL',
<mt:Contents>Content <mt:ContentId>: <mt:ContentLabel>
</mt:Contents>
TMPL
                mapping => [{
                        file_template => 'ct/<mt:ArchiveDate format="%Y%m">_2.html',
                    },
                ],
            },
        ],
    });

    MT->publisher->rebuild;
});

my $author = MT->model('author')->load({ name => 'author' });
my $blog   = MT->model('blog')->load({ name => 'my_blog' });
my $ct2    = MT->model('content_type')->load({ name => 'ct2' });

my $blog_id = $blog->id;
my $ct2_id  = $ct2->id;

subtest 'MTC-26672' => sub {
    my @monthly = MT::FileInfo->load({ blog_id => $blog_id, archive_type => 'ContentType-Monthly' });
    is @monthly => 1, '1 FileInfo';

    # Publish a content data
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);
    $app->post_ok({
        __mode           => 'save_content_data',
        _type            => 'content_data',
        author_id        => $author->id,
        blog_id          => $blog_id,
        return_args      => "__mode=view&_type=content_data&blog_id=$blog_id&content_type_id=$ct2_id",
        save_revision    => 0,
        data_label       => 'first_cd2',
        authored_on_year => '2019',
        authored_on_date => '2019-05-23',
        authored_on_time => '00:00:00',
        basename_manual  => 0,
        status           => MT::ContentStatus::RELEASE(),
        content_type_id  => $ct2_id,
    });

    File::Find::find(
        { wanted => sub { note $File::Find::name }, no_chdir => 1, },
        $blog->archive_path
    );

    # No unrelated files
    @monthly = MT::FileInfo->load({ blog_id => $blog_id, archive_type => 'ContentType-Monthly' });
    is @monthly => 2, "2 FileInfo";
    ok my ($file) = grep /201905_2/, map { $_->file_path } @monthly;
    ok !grep /202002_2/, map { $_->file_path } @monthly;
};

done_testing;
