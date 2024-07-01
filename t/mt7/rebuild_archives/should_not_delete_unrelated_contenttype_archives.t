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
        DefaultLanguage      => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::Deep;

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;
use MT::ContentStatus;

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
                category     => [qw/cat dog/],
                category_set => { catset => [qw/cat dog hen pig/] },
                entry        => [
                    {   title       => 'first entry',
                        author      => 'author',
                        authored_on => '20120404000000',
                        categories  => [qw/cat dog/],
                    },
                    {   title       => 'second entry',
                        author      => 'author',
                        authored_on => '20130405000000',
                        categories  => [qw/cat dog/],
                    },
                    {   title       => 'third entry',
                        author      => 'author',
                        authored_on => '20130406000000',
                        categories  => [qw/cat dog/],
                    },
                    {   title       => 'fourth entry',
                        author      => 'author',
                        authored_on => '20140407000000',
                        categories  => [qw/cat dog/],
                    },
                ],
                content_type => {
                    ct => [
                        cf_text     => 'single_line_text',
                        cf_category => {
                            type         => 'categories',
                            category_set => 'catset'
                        },
                    ],
                    ct2 => [
                        cf_text     => 'single_line_text',
                        cf_category => {
                            type         => 'categories',
                            category_set => 'catset'
                        },
                    ],
                },
                content_data => {
                    first_cd => {
                        content_type => 'ct',
                        author       => 'author',
                        authored_on  => '20180202000000',
                        label        => 'first_cd',
                        data         => {
                            cf_text     => 'first content data',
                            cf_category => [qw/cat dog/]
                        },
                    },
                    second_cd => {
                        content_type => 'ct',
                        author       => 'author',
                        authored_on  => '20190203000000',
                        label        => 'second_cd',
                        data         => {
                            cf_text     => 'second content data',
                            cf_category => [qw/cat dog/]
                        },
                    },
                    third_cd => {
                        content_type => 'ct',
                        author       => 'author',
                        authored_on  => '20190204000000',
                        label        => 'third_cd',
                        data         => {
                            cf_text     => 'third content data',
                            cf_category => [qw/cat dog/]
                        },
                    },
                    fourth_cd => {
                        content_type => 'ct',
                        author       => 'author',
                        authored_on  => '20200203000000',
                        label        => 'fourth_cd',
                        data         => {
                            cf_text     => 'fourth content data',
                            cf_category => [qw/cat dog/]
                        },
                    },
                    first_cd2 => {
                        content_type => 'ct2',
                        author       => 'author',
                        authored_on  => '20080202000000',
                        label        => 'first_cd2',
                        data         => {
                            cf_text     => 'first content data2',
                            cf_category => [qw/hen pig/]
                        },
                    },
                    second_cd2 => {
                        content_type => 'ct2',
                        author       => 'author',
                        authored_on  => '20090203000000',
                        label        => 'second_cd2',
                        data         => {
                            cf_text     => 'second content data2',
                            cf_category => [qw/hen pig/]
                        },
                    },
                    third_cd2 => {
                        content_type => 'ct2',
                        author       => 'author',
                        authored_on  => '20090204000000',
                        label        => 'third_cd2',
                        data         => {
                            cf_text     => 'third content data2',
                            cf_category => [qw/hen pig/]
                        },
                    },
                    fourth_cd2 => {
                        content_type => 'ct2',
                        author       => 'author',
                        authored_on  => '20100203000000',
                        label        => 'fourth_cd2',
                        data         => {
                            cf_text     => 'fourth content data2',
                            cf_category => [qw/hen pig/]
                        },
                    },
                },
                template => [
                    ## entry
                    (   {   archive_type => 'Individual',
                            name         => "tmpl_individual",
                            text         => <<'TMPL',
Entry <mt:EntryId>: <mt:EntryTitle>
TMPL
                            mapping =>
                                [ { file_template => "entry/%y/%f", }, ],
                        },
                        {   archive_type => 'Yearly',
                            name         => "tmpl_yearly",
                            text         => <<'TMPL',
<mt:Entries>Entry <mt:EntryId>: <mt:EntryTitle>
</mt:Entries>
TMPL
                            mapping => [
                                { file_template => "entry/%y/index.html", },
                            ],
                        },
                        {   archive_type => 'Author',
                            name         => "tmpl_author",
                            text         => <<'TMPL',
<mt:Entries>Entry <mt:EntryId>: <mt:EntryTitle>
</mt:Entries>
TMPL
                            mapping => [
                                { file_template => "entry/%a/index.html", },
                            ],
                        },
                        {   archive_type => 'Author-Yearly',
                            name         => "tmpl_author_yearly",
                            text         => <<'TMPL',
<mt:Entries>Entry <mt:EntryId>: <mt:EntryTitle>
</mt:Entries>
TMPL
                            mapping => [
                                {   file_template => "entry/%a/%y/index.html",
                                },
                            ],
                        },
                        {   archive_type => 'Category',
                            name         => "tmpl_category",
                            text         => <<'TMPL',
<mt:Entries>Entry <mt:EntryId>: <mt:EntryTitle>
</mt:Entries>
TMPL
                            mapping => [
                                { file_template => "entry/%c/index.html", },
                            ],
                        },
                        {   archive_type => 'Category-Yearly',
                            name         => "tmpl_category_yearly",
                            text         => <<'TMPL',
<mt:Entries>Entry <mt:EntryId>: <mt:EntryTitle>
</mt:Entries>
TMPL
                            mapping => [
                                {   file_template => "entry/%c/%y/index.html",
                                },
                            ],
                        },
                    ),
                    ## content data
                    (   map {
                            (   {   archive_type => 'ContentType',
                                    name         => "tmpl_" . $_,
                                    content_type => $_,
                                    text         => <<'TMPL',
Content <mt:ContentId>: <mt:ContentLabel>
TMPL
                                    mapping =>
                                        [ { file_template => "$_/%y/%f", }, ],
                                },
                                {   archive_type => 'ContentType-Yearly',
                                    name         => "tmpl_" . $_ . "_yearly",
                                    content_type => $_,
                                    text         => <<'TMPL',
<mt:Contents>Content <mt:ContentId>: <mt:ContentLabel>
</mt:Contents>
TMPL
                                    mapping => [
                                        {   file_template =>
                                                "$_/%y/index.html",
                                        },
                                    ],
                                },
                                {   archive_type => 'ContentType-Author',
                                    name         => "tmpl_" . $_ . "_author",
                                    content_type => $_,
                                    text         => <<'TMPL',
<mt:Contents>Content <mt:ContentId>: <mt:ContentLabel>
</mt:Contents>
TMPL
                                    mapping => [
                                        {   file_template =>
                                                "$_/%a/index.html",
                                        },
                                    ],
                                },
                                {   archive_type =>
                                        'ContentType-Author-Yearly',
                                    name => "tmpl_" . $_ . "_author_yearly",
                                    content_type => $_,
                                    text         => <<'TMPL',
<mt:Contents>Content <mt:ContentId>: <mt:ContentLabel>
</mt:Contents>
TMPL
                                    mapping => [
                                        {   file_template =>
                                                "$_/%a/%y/index.html",
                                        },
                                    ],
                                },
                                {   archive_type => 'ContentType-Category',
                                    name => "tmpl_" . $_ . "_category",
                                    content_type => $_,
                                    text         => <<'TMPL',
<mt:Contents>Content <mt:ContentId>: <mt:ContentLabel>
</mt:Contents>
TMPL
                                    mapping => [
                                        {   file_template =>
                                                "$_/%c/index.html",
                                            cat_field => 'cf_category'
                                        },
                                    ],
                                },
                                {   archive_type =>
                                        'ContentType-Category-Yearly',
                                    name => "tmpl_" . $_ . "_category_yearly",
                                    content_type => $_,
                                    text         => <<'TMPL',
<mt:Contents>Content <mt:ContentId>: <mt:ContentLabel>
</mt:Contents>
TMPL
                                    mapping => [
                                        {   file_template =>
                                                "$_/%c/%y/index.html",
                                            cat_field => 'cf_category'
                                        },
                                    ],
                                },
                            )
                        } qw/ct ct2/
                    ),
                ],
            }
        );
    }
);

my $author = MT->model('author')->load( { name => 'author' } );
my $blog   = MT->model('blog')->load(   { name => 'my_blog' } );
my $blog_id = $blog->id;

MT->publisher->rebuild(BlogID => $blog_id);

$test_env->utime_r( $blog->archive_path );

sub _dump_fileinfo {
    my $rows = shift;
    for my $finfo ( sort { $a->url cmp $b->url } @$rows ) {
        note sprintf
            "%s (at: %s id: %d cd: %d map: %d tmpl: %d cat: %d start: %s)",
            $finfo->url, $finfo->archive_type, $finfo->id,
            $finfo->cd_id          // 0, $finfo->template_id // 0,
            $finfo->templatemap_id // 0, $finfo->category_id // 0,
            $finfo->startdate      // '';
    }
}

subtest 'MTC-26599: content type' => sub {
    my $cd    = MT->model('content_data')->load( { label => 'second_cd' } );
    my $cd_id = $cd->id;
    my $ct_id = $cd->content_type->id;

    my %map;
    my @atypes = qw(
        ContentType-Yearly
        ContentType-Author-Yearly   ContentType-Author
        ContentType-Category-Yearly ContentType-Category
    );
    for my $at (@atypes) {
        my @rows = MT::FileInfo->load(
            { blog_id => $blog_id, archive_type => $at } );
        for my $row (@rows) {
            my $path = $row->absolute_file_path($blog);
            ok -f $path, $path;
        }
        $map{$at} = \@rows;
    }

    $test_env->clear_mt_cache;

    $test_env->remove_logfile;

    # Delete a content data
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);

    my $res = $app->post(
        {   __mode          => 'itemset_action',
            _type           => 'content_data',
            type            => "content_data_$ct_id",
            action_name     => 'delete',
            blog_id         => $blog_id,
            id              => $cd_id,
            content_type_id => $ct_id,
            return_args =>
                "__mode=list&_type=content_data&blog_id=$blog_id&does_act=1&type=content_data",
        },
    );
    is $res->code => 200;

    if ( ok my $log = $test_env->slurp_logfile ) {
        ok $log !~ /\[ERROR\]/, "no errors";

        ok $log =~ /ct 'second_cd' \(ID:\d\) deleted/, "deletion log";

        my @rebuilt = $log =~ /Rebuilt (\S+)/g;
        for (@rebuilt) {
            s|\\|/|g;
            s!^.+/site/archives/!!;
        }
        cmp_bag \@rebuilt => [
            qw(
                ct/author/index.html
                ct/author/2019/index.html
                ct/cat/index.html
                ct/dog/index.html
                ct/cat/2019/index.html
                ct/dog/2019/index.html
                ct/2019/index.html
                )
            ],
            "rebuilt archives";
    }

    $test_env->ls( $blog->archive_path );

    for my $at ( sort keys %map ) {
        note $at;
        my @rows = MT::FileInfo->load(
            { blog_id => $blog_id, archive_type => $at } );
        is scalar @{ $map{$at} } => scalar @rows, "fileinfo: $at";
        for my $row ( @{ $map{$at} } ) {
            my $path = $row->absolute_file_path($blog);
            ok -f $path, $path;
        }

        _dump_fileinfo( \@rows );
    }
};

subtest 'MTC-26599: entry' => sub {
    my $entry    = MT->model('entry')->load( { title => 'second entry' } );
    my $entry_id = $entry->id;

    my %map;
    my @atypes = qw(
        Yearly
        Author-Yearly   Author
        Category-Yearly Category
    );
    for my $at (@atypes) {
        my @rows = MT::FileInfo->load(
            { blog_id => $blog_id, archive_type => $at } );
        for my $row (@rows) {
            my $path = $row->absolute_file_path($blog);
            ok -f $path, $path;
        }
        $map{$at} = \@rows;
    }

    $test_env->clear_mt_cache;

    $test_env->remove_logfile;

    # Delete an entry
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);

    my $res = $app->post(
        {   __mode      => 'itemset_action',
            _type       => 'entry',
            action_name => 'delete',
            blog_id     => $blog_id,
            id          => $entry_id,
            return_args =>
                "__mode=list&_type=entry&blog_id=$blog_id&does_act=1",
        },
    );
    is $res->code => 200;

    if ( my $log = $test_env->slurp_logfile ) {
        ok $log !~ /\[ERROR\]/, "no errors";

        ok $log =~ /Entry 'second entry' \(ID:\d\) deleted/, "deletion log";

        my @rebuilt = $log =~ /Rebuilt (\S+)/g;
        for (@rebuilt) {
            s|\\|/|g;
            s!^.+/site/archives/!!;
        }
        cmp_bag \@rebuilt => [
            qw(
                entry/author/index.html
                entry/author/2013/index.html
                entry/cat/index.html
                entry/dog/index.html
                entry/cat/2013/index.html
                entry/dog/2013/index.html
                entry/2013/index.html
                )
            ],
            "rebuilt archives";
    }

    $test_env->ls( $blog->archive_path );

    for my $at ( sort keys %map ) {
        note $at;
        my @rows = MT::FileInfo->load(
            { blog_id => $blog_id, archive_type => $at } );
        is scalar @{ $map{$at} } => scalar @rows, "fileinfo: $at";
        for my $row ( @{ $map{$at} } ) {
            my $path = $row->absolute_file_path($blog);
            ok -f $path, $path;
        }
    }
};

done_testing;
