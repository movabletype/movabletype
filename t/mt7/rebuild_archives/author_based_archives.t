use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
    $ENV{MT_APP}    = 'MT::App::CMS';
}

use MT;
use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    author  => [qw(author1 author2 author3)],
    website => [{
        name         => 'My Site',
        site_path    => 'TEST_ROOT/site',
        archive_path => 'TEST_ROOT/site/archive',
    }],
    entry => [
        map {
            my $author_ct = $_;
            map {
                +{
                    author      => 'author' . $author_ct,
                    website     => 'My Site',
                    title       => "text $_ for author $author_ct",
                    authored_on => (2024 - $author_ct) . '0101' . sprintf('%02d', $_ % 12 + 1) . '0000',
                }
            } (1 .. 100);
        } (1 .. 3)
    ],
    content_type => {
        ct => {
            name   => 'test content type',
            fields => [
                cf_single_line_text => {
                    type => 'single_line_text',
                    name => 'single line text',
                },
            ],
        }
    },
    content_data => {
        map {
            my $author_ct = $_;
            map {
                sprintf('cd%d_for_author%d', $_, $author_ct) => +{
                    content_type => 'ct',
                    author       => 'author' . $author_ct,
                    data         => {
                        cf_single_line_text => "text $_ for author $author_ct",
                    },
                    authored_on => (2024 - $author_ct) . '0101' . sprintf('%02d', $_ % 12 + 1) . '0000',
                }
            } (1 .. 100);
        } (1 .. 3)
    },
    template => [{
            archive_type => 'Author',
            website      => 'My Site',
            name         => 'author_tmpl',
            identifier   => 'author_tmpl',
            text         => <<"TMPL",
<MTEntries><MTEntryTitle>
</MTEntries>
TMPL
            mapping => {
                file_template => 'entry/<$mt:AuthorName$>/%f',
            },
        }, {
            archive_type => 'ContentType-Author',
            website      => 'My Site',
            content_type => 'ct',
            name         => 'ct_author_tmpl',
            identifier   => 'ct_author_tmpl',
            text         => <<"TMPL",
<MTContents><MTContentFields><MTContentField><MTContentFieldLabel>: <MTContentFieldValue></MTContentField></MTContentFields>
</MTContents>
TMPL
            mapping => {
                file_template => 'ct/<$mt:AuthorName$>/%f',
            },
        }
    ],
});

my $blog_id = $objs->{blog_id};
my $admin   = MT::Author->load(1);

my $app = MT::Test::App->new;
$app->login($admin);
$app->get_ok({
    __mode  => 'rebuild_confirm',
    blog_id => $blog_id,
});

$app->post_form_ok();

my @files;
$test_env->ls(sub {
    my $file = shift;
    $file =~ s!\\!/!g if $^O eq 'MSWin32';
    push @files, $file;
});

my $fail = 0;
for my $author (qw(author1 author2 author3)) {
    my $ct_count = grep { m!/archive/ct/$author/! && -f $_ } @files;
    ok $ct_count, "content type author archive file for $author exist" or $fail++;
}
for my $author (qw(author1 author2 author3)) {
    my $entry_count = grep { m!/archive/entry/$author/! && -f $_ } @files;
    ok $entry_count, "entry author archive file for $author exist" or $fail++;
}
note explain \@files if $fail;

done_testing;

