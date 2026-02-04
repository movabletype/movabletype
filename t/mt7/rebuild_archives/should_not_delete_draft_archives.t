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
                category_set => { catset => [qw/cat dog hen pig/] },
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
note explain [MT::Category->load];
    }
);

my $author = MT->model('author')->load( { name => 'author' } );
my $blog   = MT->model('blog')->load(   { name => 'my_blog' } );
my $blog_id = $blog->id;
my $catset = MT->model('category_set')->load( { name => 'catset' } );

my $cat_cat = MT->model('category')->load( { label => 'cat', blog_id => $blog_id, category_set_id => $catset->id } );
my $cat_dog = MT->model('category')->load( { label => 'dog', blog_id => $blog_id, category_set_id => $catset->id } );

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

subtest 'MTC-27376' => sub {
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
            my $path = $row->file_path;
            ok -f $path, $path;
        }
        $map{$at} = \@rows;
    }

    $test_env->clear_mt_cache;

    $test_env->remove_logfile;

    # Add a new draft
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);

    my $res = $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            type            => "content_data_$ct_id",
            blog_id         => $blog_id,
            content_type_id => $ct_id,
        },
    );
    my $form = $app->form;

    my ($content_field_id)  = grep /^content-field/, $form->param;
    my ($category_field_id) = grep /^category/,      $form->param;

    # new draft
    $res = $app->post_form_ok(
        {   data_label         => 'New draft',
            $content_field_id  => 'new draft',
            $category_field_id => $cat_cat->id,
            status             => MT::ContentStatus::HOLD(),
        }
    );
    ok my $new_draft_cd_id = $app->{locations}[-1]->query_param('id');

    if ( ok my $log = $test_env->slurp_logfile ) {
        ok $log !~ /\[ERROR\]/, "no errors";
    }

    $test_env->ls( $blog->archive_path );

    # nothing should be removed
    for my $at ( sort keys %map ) {
        note $at;
        my @rows = MT::FileInfo->load(
            { blog_id => $blog_id, archive_type => $at } );
        is scalar @{ $map{$at} } => scalar @rows, "fileinfo: $at";
        for my $row ( @{ $map{$at} } ) {
            my $path = $row->file_path;
            ok -f $path, $path;
        }
    }

    # update draft
    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            type            => "content_data_$ct_id",
            blog_id         => $blog_id,
            content_type_id => $ct_id,
            id              => $new_draft_cd_id,
        },
    );
    $form = $app->form;

    $res = $app->post_ok( $form->click );


    if ( ok my $log = $test_env->slurp_logfile ) {
        ok $log !~ /\[ERROR\]/, "no errors";
    }

    $test_env->ls( $blog->archive_path );

    # nothing should be removed (again);
    for my $at ( sort keys %map ) {
        note $at;
        my @rows = MT::FileInfo->load(
            { blog_id => $blog_id, archive_type => $at } );
        is scalar @{ $map{$at} } => scalar @rows, "fileinfo: $at";
        for my $row ( @{ $map{$at} } ) {
            my $path = $row->file_path;
            ok -f $path, $path;
        }

#        _dump_fileinfo( \@rows );
    }
};

done_testing;
