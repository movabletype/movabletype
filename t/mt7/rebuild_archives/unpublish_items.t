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
}

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;
use MT::EntryStatus;
use MT::ContentStatus;
use File::stat;

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
                entry => [
                    {   title       => 'first_entry',
                        author      => 'author',
                        authored_on => '20200101000000',
                        status      => 'publish',
                    },
                    {   title       => 'second_entry',
                        author      => 'author',
                        authored_on => '20200102000000',
                        status      => 'publish',
                    },
                ],
                content_type => { ct => [ cf_text => 'single_line_text', ], },
                content_data => {
                    first_cd => {
                        content_type => 'ct',
                        author       => 'author',
                        authored_on  => '20200202000000',
                        label        => 'first_cd',
                        data         => { cf_text => 'first content data', },
                    },
                    second_cd => {
                        content_type => 'ct',
                        author       => 'author',
                        authored_on  => '20200203000000',
                        label        => 'second_cd',
                        data         => { cf_text => 'second content data', },
                    },
                },
                template => [
                    {   archive_type => 'Monthly',
                        name         => 'tmpl_monthly',
                        text         => <<'TMPL',
<mt:Entries>Entry <mt:EntryId>: <mt:EntryTitle>
</mt:Entries>
TMPL
                        mapping =>
                            [ { file_template => '%y/%m/index.html', }, ],
                    },
                    {   archive_type => 'Individual',
                        name         => 'tmpl_individual',
                        text         => <<'TMPL',
<mt:EntryTitle>
TMPL
                        mapping => [ { file_template => '%y/%m/%-f', }, ],
                    },
                    {   archive_type => 'ContentType-Monthly',
                        name         => 'tmpl_ct_monthly',
                        content_type => 'ct',
                        text         => <<'TMPL',
<mt:Contents>Content <mt:ContentId>: <mt:ContentLabel>
</mt:Contents>
TMPL
                        mapping =>
                            [ { file_template => 'ct/%y/%m/index.html', }, ],
                    },
                    {   archive_type => 'ContentType',
                        name         => 'tmpl_ct',
                        content_type => 'ct',
                        text         => <<'TMPL',
<mt:ContentLabel>
TMPL
                        mapping => [ { file_template => 'ct/%y/%m/%-f', }, ],
                    },
                ],
            }
        );
    }
);

my $author = MT->model('author')->load( { name => 'author' } );
my $blog   = MT->model('blog')->load(   { name => 'my_blog' } );
my $blog_id      = $blog->id;
my $first_entry  = MT->model('entry')->load( { title => 'first_entry' } );
my $second_entry = MT->model('entry')->load( { title => 'second_entry' } );
my $first_cd     = MT->model('cd')->load( { label => 'first_cd' } );
my $second_cd    = MT->model('cd')->load( { label => 'second_cd' } );

MT->publisher->rebuild(BlogID => $blog_id);

$test_env->utime_r( $blog->archive_path );
$test_env->ls( $blog->archive_path );

sub _year { substr( shift, 0, 4 ); }
sub _date { join '-', unpack 'A4A2A2', substr( shift, 0, 8 ); }
sub _time { join ':', unpack 'A2A2A2', substr( shift, 8, 6 ); }

sub _slurp {
    my $file = shift;
    open my $fh, '<', $file or die $!;
    local $/;
    my $html = <$fh>;
    $html =~ s/\n$//s;
    $html;
}

subtest 'MTC-26550: entries' => sub {
    my $entry = $first_entry;

    # Two entries are published
    my @individuals = MT::FileInfo->load(
        { blog_id => $blog_id, archive_type => 'Individual' } );
    is @individuals => 2, "2 FileInfo";
    my ($entry_file)
        = ( grep { $_->entry_id == $entry->id } @individuals )[0]->file_path;
    ok -f $entry_file, "$entry_file exists";

    my @monthly = MT::FileInfo->load(
        { blog_id => $blog_id, archive_type => 'Monthly' } );
    is @monthly => 1, "1 FileInfo";
    my $file = $monthly[0]->file_path;
    ok -f $file, "$file exists";
    my $html = _slurp($file);
    is $html => "Entry 2: second_entry\nEntry 1: first_entry\n",
        "expected archive";
    my $mtime = stat($file)->mtime;

    # Unpublish an entry
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);

    $app->post(
        {   __mode           => 'save_entry',
            _type            => 'entry',
            author_id        => $author->id,
            blog_id          => $blog_id,
            return_args      => "__mode=view&_type=entry&blog_id=$blog_id",
            allow_comments   => 0,
            save_revision    => $entry->revision,
            title            => $entry->title,
            convert_breaks   => $entry->convert_breaks,
            text             => $entry->text,
            text_more        => $entry->text_more,
            status           => MT::EntryStatus::HOLD(),
            authored_on_date => _date( $entry->authored_on ),
            authored_on_time => _time( $entry->authored_on ),
            basename         => $entry->basename,
            id               => $entry->id,
        },
    );

    ok !-f $entry_file, "$entry_file is gone";
    ok -f $file,        "$file exists";
    $html = _slurp($file);
    is $html    => "Entry 2: second_entry\n", "expected archive";
    isnt $mtime => stat($file)->mtime, "mtime should change";

    # Republish the entry
    $app->post(
        {   __mode           => 'save_entry',
            _type            => 'entry',
            author_id        => $author->id,
            blog_id          => $blog_id,
            return_args      => "__mode=view&_type=entry&blog_id=$blog_id",
            allow_comments   => 0,
            save_revision    => $entry->revision,
            title            => $entry->title,
            convert_breaks   => $entry->convert_breaks,
            text             => $entry->text,
            text_more        => $entry->text_more,
            status           => MT::EntryStatus::RELEASE(),
            authored_on_date => _date( $entry->authored_on ),
            authored_on_time => _time( $entry->authored_on ),
            basename         => $entry->basename,
            id               => $entry->id,
        },
    );

    ok -f $entry_file, "$entry_file exists";
    ok -f $file,       "$file exists";
    $html = _slurp($file);
    is $html => "Entry 2: second_entry\nEntry 1: first_entry\n",
        "expected archive";
    isnt $mtime => stat($file)->mtime, "mtime should change";
};

subtest 'MTC-26550: content data' => sub {
    my $cd      = $first_cd;
    my $cd_id   = $cd->id;
    my $ct_id   = $cd->content_type->id;
    my $cd_data = $cd->data;

    # Two content data are published
    my @cds = MT::FileInfo->load(
        { blog_id => $blog_id, archive_type => 'ContentType' } );
    is @cds => 2, "2 FileInfo";
    my ($cd_file) = ( grep { $_->cd_id == $cd->id } @cds )[0]->file_path;
    ok -f $cd_file, "$cd_file exists";

    my @monthly = MT::FileInfo->load(
        { blog_id => $blog_id, archive_type => 'ContentType-Monthly' } );
    is @monthly => 1, "1 FileInfo";
    my $file = $monthly[0]->file_path;
    ok -f $file, "$file exists";
    my $html = _slurp($file);
    is $html => "Content 2: second_cd\nContent 1: first_cd\n",
        "expected archive";
    my $mtime = stat($file)->mtime;

    # Unpublish a content data
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);

    $app->post(
        {   __mode    => 'save_content_data',
            _type     => 'content_data',
            author_id => $author->id,
            blog_id   => $blog_id,
            return_args =>
                "__mode=view&_type=content_data&blog_id=$blog_id&content_type_id=$ct_id&id=$cd_id",
            save_revision    => $cd->revision,
            data_label       => $cd->label,
            authored_on_year => _year( $cd->authored_on ),
            authored_on_date => _date( $cd->authored_on ),
            authored_on_time => _time( $cd->authored_on ),
            identifier       => $cd->identifier,
            basename_manual  => 0,
            old_status       => $cd->status,
            status           => MT::ContentStatus::HOLD(),
            content_type_id  => $ct_id,
            id               => $cd_id,
        },
    );

    ok !-f $cd_file, "$cd_file is gone";
    ok -f $file,     "$file exists";
    $html = _slurp($file);
    is $html    => "Content 2: second_cd\n", "expected archive";
    isnt $mtime => stat($file)->mtime, "mtime should change";

    # Republish the content data
    $app->post(
        {   __mode    => 'save_content_data',
            _type     => 'content_data',
            author_id => $author->id,
            blog_id   => $blog_id,
            return_args =>
                "__mode=view&_type=content_data&blog_id=$blog_id&content_type_id=$ct_id&id=$cd_id",
            save_revision    => $cd->revision,
            data_label       => $cd->label,
            authored_on_year => _year( $cd->authored_on ),
            authored_on_date => _date( $cd->authored_on ),
            authored_on_time => _time( $cd->authored_on ),
            identifier       => $cd->identifier,
            basename_manual  => 0,
            old_status       => $cd->status,
            status           => MT::ContentStatus::RELEASE(),
            content_type_id  => $ct_id,
            id               => $cd_id,
        },
    );

    ok -f $cd_file, "$cd_file exists";
    ok -f $file,    "$file exists";
    $html = _slurp($file);
    is $html => "Content 2: second_cd\nContent 1: first_cd\n",
        "expected archive";
    isnt $mtime => stat($file)->mtime, "mtime should change";
};

done_testing;
