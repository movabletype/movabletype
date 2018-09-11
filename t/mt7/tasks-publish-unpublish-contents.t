use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $blog = MT::Test::Permission->make_blog(
            parent_id   => 0,
            name        => 'test blog',
            archive_url => 'http://example.com/archives/'
        );

        my $content_type = MT::Test::Permission->make_content_type(
            blog_id => $blog->id,
            name    => 'test content type',
        );

        my $cf_datetime = MT::Test::Permission->make_content_field(
            blog_id         => $content_type->blog_id,
            content_type_id => $content_type->id,
            name            => 'date and time',
            type            => 'date_and_time',
        );
        my $cf_category = MT::Test::Permission->make_content_field(
            blog_id         => $content_type->blog_id,
            content_type_id => $content_type->id,
            name            => 'categories',
            type            => 'categories',
        );
        my $category_set = MT::Test::Permission->make_category_set(
            blog_id => $content_type->blog_id,
            name    => 'test category set',
        );
        my $category = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => 'category1',
        );

        my $fields = [
            {   id        => $cf_datetime->id,
                order     => 6,
                type      => $cf_datetime->type,
                options   => { label => $cf_datetime->name },
                unique_id => $cf_datetime->unique_id,
            },
            {   id      => $cf_category->id,
                order   => 15,
                type    => $cf_category->type,
                options => {
                    label        => $cf_category->name,
                    category_set => $category_set->id,
                    multiple     => 1,
                    max          => 5,
                    min          => 1,
                },
            },
        ];
        $content_type->fields($fields);
        $content_type->save or die $content_type->errstr;

        my $author = MT::Test::Permission->make_author(
            name     => 'yishikawa',
            nickname => 'Yuki Ishikawa',
        );

        my $now = MT::Util::epoch2ts( $blog, time() );

        my $content_data = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type->id,
            author_id       => $author->id,
            authored_on     => $now,
            status          => MT::ContentStatus::FUTURE(),
            data            => {
                $cf_datetime->id => '20170603180500',
                $cf_category->id => [ $category->id ],
            },
        );

        my $tmpl = MT::Test::Permission->make_template(
            blog_id         => $blog->id,
            content_type_id => $content_data->id,
            name            => 'ContentType Test',
            type            => 'ct',
            text            => 'test',
        );
        my $tmpl_archive = MT::Test::Permission->make_template(
            blog_id         => $blog->id,
            content_type_id => $content_data->id,
            name            => 'ContentType Archive Test',
            type            => 'ct_archive',
            text            => 'test',
        );

        my $ct_map = MT::Test::Permission->make_templatemap(
            template_id   => $tmpl->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType',
            file_template => 'contenttype.html',
        );

        my $monthly_map = MT::Test::Permission->make_templatemap(
            template_id   => $tmpl_archive->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType-Monthly',
            cat_field_id  => $cf_category->id,
            file_template => 'monthly.html',
        );

        my $category_map = MT::Test::Permission->make_templatemap(
            template_id   => $tmpl_archive->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType-Category',
            cat_field_id  => $cf_category->id,
            file_template => 'category.html',
        );

        my $author_map = MT::Test::Permission->make_templatemap(
            template_id   => $tmpl_archive->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType-Author',
            file_template => 'author.html',
        );
    }
);

my $blog = MT::Blog->load( { name => 'test blog' } );

my $contenttype_file
    = File::Spec->catfile( $blog->archive_path, 'contenttype.html' );
my $monthly_file = File::Spec->catfile( $blog->archive_path, 'monthly.html' );
my $category_file
    = File::Spec->catfile( $blog->archive_path, 'category.html' );
my $author_file = File::Spec->catfile( $blog->archive_path, 'author.html' );

unlink $contenttype_file if -e $contenttype_file;
unlink $monthly_file     if -e $monthly_file;
unlink $category_file    if -e $category_file;
unlink $author_file      if -e $author_file;

my $future_data = MT::ContentData->load(1);

is( $future_data->status, MT::ContentStatus::FUTURE(),
    'MT::ContentStatus::FUTURE()' );
is( -f $contenttype_file, undef, 'Not exist contenttype.html' );
is( -f $monthly_file,     undef, 'Not exist monthly.html' );
is( -f $category_file,    undef, 'Not exist category.html' );
is( -f $author_file,      undef, 'Not exist author.html' );

MT::Test::_run_tasks( ["FutureContent"] );

my $published_data = MT::ContentData->load(1);

is( $published_data->status,
    MT::ContentStatus::RELEASE(),
    'MT::ContentStatus::RELEASE()'
);
is( -f $contenttype_file, 1, 'Published contenttype.html' );
is( -f $monthly_file,     1, 'Published monthly.html' );
is( -f $category_file,    1, 'Published category.html' );
is( -f $author_file,      1, 'Published author.html' );

$published_data->unpublished_on(time - 1); $published_data->save;

MT::Test::_run_tasks( ["UnpublishingContent"] );

my $unpublished_data = MT::ContentData->load(1);

is( $unpublished_data->status,
    MT::ContentStatus::UNPUBLISH(),
    'MT::ContentStatus::UNPUBLISH()'
);
is( -f $contenttype_file, undef, 'Unpublished contenttype.html' );
is( -f $monthly_file,     undef, 'Unpublished monthly.html' );
is( -f $category_file,    undef, 'Unpublished category.html' );
is( -f $author_file,      undef, 'Unpublished author.html' );

done_testing;
