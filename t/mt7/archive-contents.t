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
use File::Basename;

use MT::ContentFieldIndex;
use MT::ContentPublisher;

my $mt = MT->instance;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $blog = MT::Test::Permission->make_blog(
            parent_id => 0,
            name      => 'test blog'
        );

        my $ct = MT::Test::Permission->make_content_type(
            blog_id => $blog->id,
            name    => 'test content type',
        );

        my $cf_datetime = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'date and time',
            type            => 'date_and_time',
        );
        my $cf_category = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'categories',
            type            => 'categories',
        );
        my $category_set = MT::Test::Permission->make_category_set(
            blog_id => $ct->blog_id,
            name    => 'test category set',
        );
        my $category = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => 'category',
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
        $ct->fields($fields);
        $ct->save or die $ct->errstr;

        my $author = MT::Test::Permission->make_author(
            name     => 'yishikawa',
            nickname => 'Yuki Ishikawa',
        );
        my $author2 = MT::Test::Permission->make_author(
            name     => 'myanagida',
            nickname => 'Masahiro Yanagida',
        );

        my $cd = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $ct->id,
            author_id       => $author->id,
            authored_on     => '20170909130530',
            data            => {
                $cf_datetime->id => '20170603180500',
                $cf_category->id => [ $category->id ],
            },
        );
        my $cd1 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $ct->id,
            author_id       => $author->id,
            authored_on     => '20170809130530',
            data            => {
                $cf_datetime->id => '20170603180500',
                $cf_category->id => [ $category->id ],
            },
        );
        my $cd2 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $ct->id,
            author_id       => $author->id,
            authored_on     => '20171009130530',
            data            => {
                $cf_datetime->id => '20170603180500',
                $cf_category->id => [ $category->id ],
            },
        );
        my $cd_no_category_author2 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $ct->id,
            author_id       => $author2->id,
            authored_on     => '20160909130530',
            data            => { $cf_datetime->id => '20180603180500', },
        );

        my $text = "<mt:Contents glue=\",\">test</mt:Contents>";
        my $tmpl = MT::Test::Permission->make_template(
            blog_id         => $blog->id,
            content_type_id => $cd->id,
            name            => 'ContentType Test',
            type            => 'ct',
            text            => $text,
        );
        my $tmpl_archive = MT::Test::Permission->make_template(
            blog_id         => $blog->id,
            content_type_id => $cd->id,
            name            => 'ContentType Archive Test',
            type            => 'ct_archive',
            text            => $text,
        );

        my $ct_dummy = MT::Test::Permission->make_content_type(
            blog_id => $blog->id,
            name    => 'dummy content type',
        );
        $ct_dummy->fields($fields);
        $ct_dummy->save or die $ct->errstr;
        my $cd_dummy = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $ct_dummy->id,
            author_id       => $author->id,
            authored_on     => '20170909130530',
            data            => {
                $cf_datetime->id => '20170603180500',
                $cf_category->id => [ $category->id ],
            },
        );
    }
);

my $blog = MT::Blog->load( { name => 'test blog' } );

my $author = MT::Author->load( { name => 'yishikawa' } );

my $cf_datetime = MT::ContentField->load( { name => 'date and time' } );
my $cf_category = MT::ContentField->load( { name => 'categories' } );

my $ct = MT::ContentType->load( { name => 'test content type' } );

my $category = MT::Category->load(
    { label => 'category', category_set_id => \'> 0' } );

my $cd = MT::ContentData->load(
    {   blog_id         => $blog->id,
        content_type_id => $ct->id,
        author_id       => $author->id,
        authored_on     => '20170909130530',
    }
);

my $tmpl = MT::Template->load( { name => 'ContentType Test' } );
my $tmpl_archive
    = MT::Template->load( { name => 'ContentType Archive Test' } );

my $publisher = MT::ContentPublisher->new( start_time => time() + 10 );

my %html = (
    'ContentType'                  => 'test,test,test,test',
    'ContentType-Daily'            => 'test',
    'ContentType-Weekly'           => 'test',
    'ContentType-Monthly'          => 'test',
    'ContentType-Yearly'           => 'test,test,test',
    'ContentType-Author'           => 'test,test,test',
    'ContentType-Author-Daily'     => 'test',
    'ContentType-Author-Weekly'    => 'test',
    'ContentType-Author-Monthly'   => 'test',
    'ContentType-Author-Yearly'    => 'test,test,test',
    'ContentType-Category'         => 'test,test,test',
    'ContentType-Category-Daily'   => 'test',
    'ContentType-Category-Weekly'  => 'test',
    'ContentType-Category-Monthly' => 'test',
    'ContentType-Category-Yearly'  => 'test,test,test',
);

my @suite;
foreach my $prefix (qw( ContentType ContentType-Author ContentType-Category ))
{
    foreach my $suffix ( ( '', '-Daily', '-Weekly', '-Monthly', '-Yearly' ) )
    {
        my $at  = $prefix . $suffix;
        my $map = MT::Test::Permission->make_templatemap(
            template_id =>
                ( $at eq 'ContentType' ? $tmpl->id : $tmpl_archive->id ),
            blog_id      => $blog->id,
            archive_type => $at,
            cat_field_id => $cf_category->id,
            dt_field_id  => 0,
        );
        my $archiver = $publisher->archiver($at);
        my $tmpls    = $archiver->default_archive_templates;
        my ($default) = grep { $_->{default} } @$tmpls;
        $map->file_template( $default->{template} );
        push @suite,
            {
            ArchiveType => $at,
            Template    => ( $at eq 'ContentType' ? $tmpl : $tmpl_archive ),
            TemplateMap => $map,
            Html        => $html{$at},
            Published   => 1,
            };
    }
}

for my $s (@suite) {
    my $at       = $s->{ArchiveType};
    my $template = $s->{Template};
    my $map      = $s->{TemplateMap};

    note( 'ArchiveType: ' . $at );

    $blog->archive_type($at);
    $blog->save;

    my $archiver = $publisher->archiver($at);

    my $category = $archiver->contenttype_based
        || $archiver->category_based ? $category : undef;
    my $ts;
    if ( $archiver->contenttype_based || $archiver->date_based ) {
        my $dt_field_id = $map->dt_field_id;
        if ($dt_field_id) {
            my $data = $cd->data;
            $ts = $data->{$dt_field_id};
        }
        else {
            $ts = $cd->authored_on;
        }
    }

    my $file_name
        = $publisher->archive_file_for( $cd, $blog, $at, $category, $map,
        $ts, $cd->author );
    my $file = File::Spec->catfile( $blog->archive_path, $file_name );

    unlink $file if -e $file;
    $mt->request->reset;
    if ( $archiver->contenttype_category_based ) {
        $publisher->_rebuild_content_archive_type(
            ContentData => $cd,
            Blog        => $blog,
            ArchiveType => $at,
            TemplateMap => $map,
            TemplateID  => $map->template_id,
            Force       => 1,
            Category    => $category,
        );
    }
    elsif ( $archiver->contenttype_author_based ) {
        $publisher->_rebuild_content_archive_type(
            ContentData => $cd,
            Blog        => $blog,
            ArchiveType => $at,
            TemplateMap => $map,
            TemplateID  => $map->template_id,
            Force       => 1,
            Author      => $cd->author,
        );
    }
    else {
        $publisher->_rebuild_content_archive_type(
            ContentData => $cd,
            Blog        => $blog,
            ArchiveType => $at,
            TemplateMap => $map,
            TemplateID  => $map->template_id,
            Force       => 1,
        );
    }
    my $fmgr = MT::FileMgr->new('Local');
    is( $fmgr->get_data($file),
        $s->{Html}, ref($archiver) . ': Published contents' );
}

done_testing;
