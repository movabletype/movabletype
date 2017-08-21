use strict;
use warnings;

use Test::More;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw( lib extlib t/lib );
use MT::Test qw( :db );
use MT::Test::Permission;
use File::Basename;

use MT::ContentFieldIndex;
use MT::ContentPublisher;

my $mt   = MT->instance;
my $blog = MT::Test::Permission->make_blog( parent_id => 0, );

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
my $category1 = MT::Test::Permission->make_category(
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
$ct->fields($fields);
$ct->save or die $ct->errstr;

my $author = MT::Test::Permission->make_author(
    name     => 'yishikawa',
    nickname => 'Yuki Ishikawa',
);

my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $ct->id,
    author_id       => $author->id,
    data            => {
        $cf_datetime->id => '20170603180500',
        $cf_category->id => [ $category1->id ],
    },
);

my $tmpl = MT::Test::Permission->make_template( blog_id => $blog->id, name => 'ContentType Test' );
$tmpl->content_type_id( $ct->id );
my $tmpl_archive = MT::Test::Permission->make_template( blog_id => $blog->id, name => 'ContentType Archive Test' );
$tmpl_archive->content_type_id( $ct->id );

my $publisher = MT::ContentPublisher->new( start_time => time() + 10 );

my @suite;
foreach my $prefix ( qw( ContentType ContentType_Author ContentType_Category ) ) {
    foreach my $suffix ( (  '', '-Daily', '-Weekly', '-Monthly', '-Yearly' ) ) {
        my $at = $prefix . $suffix;
        my $map = MT::Test::Permission->make_templatemap(
            template_id  => ( $at eq 'ContentType' ? $tmpl->id : $tmpl_archive->id ),
            blog_id      => $blog->id,
            archive_type => $at,
            cat_field_id => $cf_category->id,
            dt_field_id  => $cf_datetime->id,
        );
        my $archiver = $publisher->archiver($at);
        my $tmpls = $archiver->default_archive_templates;
        my ($default) = grep { $_->{default} } @$tmpls;
        $map->file_template( $default->{template} );
        push @suite, {
            ArchiveType => $at,
            TemplateMap => $map,
            Published   => 1,
        },
    }
}

for my $s (@suite) {
    my $at  = $s->{ArchiveType};
    my $map = $s->{TemplateMap};

    note( 'ArchiveType: ' . $at );

    $blog->archive_type($at);

    my $archiver = $publisher->archiver($at);

    my $category = $archiver->contenttype_based || $archiver->category_based ? $category1 : undef; 
    my $ts;
    if ( $archiver->contenttype_based || $archiver->date_based ) {
        my $dt_field_id = $map->dt_field_id;
        if ($dt_field_id) {
            my $data        = $cd->data;
            $ts = $data->{$dt_field_id};
        }
        else {
            $ts = $cd->authored_on;
        }
    }

    my $does_publish_file = $archiver->does_publish_file(
        {   Blog        => $blog,
            ArchiveType => $at,
            ContentData => $cd,
            Category    => $category,
            Author      => $cd->author,
            Timestamp   => $ts,
            TemplateMap => $map,
        }
    );
    is( $does_publish_file, 1, ref($archiver) . '::does_publish_file' );

    #my $file = File::Spec->catfile( $blog->archive_path, $map->file_template);
    my $file_name = $publisher->archive_file_for( $cd, $blog, $at, $category, $map, $ts, $cd->author );
    my $file = File::Spec->catfile( $blog->archive_path, $file_name );
warn $at;
warn $file;

    unlink $file if -e $file;
    $mt->request->reset;
    if ( $archiver->contenttype_category_based ) {
        $publisher->_rebuild_content_archive_type(
            ContentData => $cd,
            Blog        => $blog,
            Category    => $category,
            ArchiveType => $at,
            Force       => 1,
            TemplateMap => $map,
        );
    }
    elsif ( $archiver->contenttype_author_based ) {
        $publisher->_rebuild_content_archive_type(
            ContentData => $cd,
            Blog        => $blog,
            ArchiveType => $at,
            TemplateMap => $map,
            Force       => 1,
            Author      => $cd->author,
        ) or return;
    }
    else {
        $publisher->_rebuild_content_archive_type(
            ContentData => $cd,
            Blog        => $blog,
            ArchiveType => $at,
            TemplateMap => $map,
            Force       => 1,
        ) or return;
    }
    is( -e $file ? 1 : 0,
        $s->{Published}, 'Rebuild: When a target file does not exists' );

    {
        my $dirname = dirname($file);
        if ( !-d $dirname ) {
            require MT::FileMgr;
            my $fmgr = MT::FileMgr->new('Local');
            $fmgr->mkpath($dirname);
        }

        open my $fh, '>', $file;
        print {$fh} "test";
        close $fh;
    }
    $mt->request->reset;
    $publisher->_rebuild_content_archive_type(
        Blog        => $blog,
        Category    => $category,
        ArchiveType => $at,
        TemplateMap => $map,
        Force       => 1,
    );
    is( -e $file ? 1 : 0,
        $s->{Published}, 'Rebuild: When a target file already exists' );
}

done_testing;
