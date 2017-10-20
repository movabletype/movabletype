use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test qw( :db );
use MT::Test::Permission;
use File::Basename;

use MT::ContentFieldIndex;
use MT::ContentPublisher;

my $mt = MT->instance;
my $blog
    = MT::Test::Permission->make_blog( parent_id => 0, name => 'test blog' );

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
        $cf_category->id => [ $category1->id ],
    },
);
my $cd1 = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $ct->id,
    author_id       => $author->id,
    authored_on     => '20170809130530',
    data            => {
        $cf_datetime->id => '20170603180500',
        $cf_category->id => [ $category1->id ],
    },
);
my $cd2 = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $ct->id,
    author_id       => $author->id,
    authored_on     => '20171009130530',
    data            => {
        $cf_datetime->id => '20170603180500',
        $cf_category->id => [ $category1->id ],
    },
);
my $cd_no_category_author2 = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $ct->id,
    author_id       => $author2->id,
    authored_on     => '20160909130530',
    data            => { $cf_datetime->id => '20180603180500', },
);

my $pre_text = <<PRE;
<\$mt:ArchiveTitle\$>
PRE
my $content_type_text
    = $pre_text . "<mt:ContentNext>\"<mt:ContentID>\"</mt:ContentNext>";
my $text
    = $pre_text
    . "<mt:Contents><mt:ContentNext>\"<mt:ContentID>\"</mt:ContentNext></mt:Contents>";
my $tmpl = MT::Test::Permission->make_template(
    blog_id         => $blog->id,
    content_type_id => $cd->id,
    name            => 'ContentType Test',
    type            => 'ct',
    text            => $content_type_text,
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
        $cf_category->id => [ $category1->id ],
    },
);

my $publisher = MT::ContentPublisher->new( start_time => time() + 10 );

my $contents_html = {
    content_type => "\n\"3\"",
    none_ao      => "\n\"3\"\"1\"",
    none_cf      => "\n\"3\"\"1\"",
    daily_ao     => "\n\"3\"",
    daily_cf     => "\n\"3\"\"1\"",
    weekly_ao    => "\n\"3\"",
    weekly_cf    => "\n\"3\"\"1\"",
    monthly_ao   => "\n\"3\"",
    monthly_cf   => "\n\"3\"\"1\"",
    yearly_ao    => "\n\"3\"\"1\"",
    yearly_cf    => "\n\"3\"\"1\"",
};
my %html = (
    'ContentType' => {
        ao => 'test content type: 1' . $contents_html->{content_type},
        cf => 'test content type: 1' . $contents_html->{content_type},
    },
    'ContentType-Daily' => {
        ao => 'September  9, 2017' . $contents_html->{daily_ao},
        cf => 'June  3, 2017' . $contents_html->{daily_cf},
    },
    'ContentType-Weekly' => {
        ao => 'September  3, 2017 - September  9, 2017'
            . $contents_html->{weekly_ao},
        cf => 'May 28, 2017 - June  3, 2017' . $contents_html->{weekly_cf},
    },
    'ContentType-Monthly' => {
        ao => 'September 2017' . $contents_html->{monthly_ao},
        cf => 'June 2017' . $contents_html->{monthly_cf},
    },
    'ContentType-Yearly' => {
        ao => '2017' . $contents_html->{yearly_ao},
        cf => '2017' . $contents_html->{yearly_cf},
    },
    'ContentType-Author' => {
        ao => 'Yuki Ishikawa' . $contents_html->{none_ao},
        cf => 'Yuki Ishikawa' . $contents_html->{none_cf},
    },
    'ContentType-Author-Daily' => {
        ao => 'Yuki Ishikawa: September  9, 2017'
            . $contents_html->{daily_ao},
        cf => 'Yuki Ishikawa: June  3, 2017' . $contents_html->{daily_cf},
    },
    'ContentType-Author-Weekly' => {
        ao => 'Yuki Ishikawa: September  3, 2017 - September  9, 2017'
            . $contents_html->{weekly_ao},
        cf => 'Yuki Ishikawa: May 28, 2017 - June  3, 2017'
            . $contents_html->{weekly_cf},
    },
    'ContentType-Author-Monthly' => {
        ao => 'Yuki Ishikawa: September 2017' . $contents_html->{monthly_ao},
        cf => 'Yuki Ishikawa: June 2017' . $contents_html->{monthly_cf},
    },
    'ContentType-Author-Yearly' => {
        ao => 'Yuki Ishikawa: 2017' . $contents_html->{yearly_ao},
        cf => 'Yuki Ishikawa: 2017' . $contents_html->{yearly_cf},
    },
    'ContentType-Category' => {
        ao => 'category1' . $contents_html->{none_ao},
        cf => 'category1' . $contents_html->{none_cf},
    },
    'ContentType-Category-Daily' => {
        ao => 'category1: September  9, 2017' . $contents_html->{daily_ao},
        cf => 'category1: June  3, 2017' . $contents_html->{daily_cf},
    },
    'ContentType-Category-Weekly' => {
        ao => 'category1: September  3, 2017 - September  9, 2017'
            . $contents_html->{weekly_ao},
        cf => 'category1: May 28, 2017 - June  3, 2017'
            . $contents_html->{weekly_cf},
    },
    'ContentType-Category-Monthly' => {
        ao => 'category1: September 2017' . $contents_html->{monthly_ao},
        cf => 'category1: June 2017' . $contents_html->{monthly_cf},
    },
    'ContentType-Category-Yearly' => {
        ao => 'category1: 2017' . $contents_html->{yearly_ao},
        cf => 'category1: 2017' . $contents_html->{yearly_cf},
    },
);

my @suite;
foreach my $prefix (qw( ContentType ContentType-Author ContentType-Category ))
{
    foreach my $suffix ( ( '', '-Daily', '-Weekly', '-Monthly', '-Yearly' ) )
    {
        foreach my $dt_field (qw( ao cf )) {
            my $at  = $prefix . $suffix;
            my $map = MT::Test::Permission->make_templatemap(
                template_id =>
                    ( $at eq 'ContentType' ? $tmpl->id : $tmpl_archive->id ),
                blog_id      => $blog->id,
                archive_type => $at,
                cat_field_id => $cf_category->id,
                dt_field_id  => $dt_field eq 'ao' ? 0 : $cf_datetime->id,
            );
            my $archiver = $publisher->archiver($at);
            my $tmpls    = $archiver->default_archive_templates;
            my ($default) = grep { $_->{default} } @$tmpls;
            $map->file_template( $default->{template} );
            my $count
                = $at eq 'ContentType'
                ? 1
                : $at =~ /Daily$/ ? $dt_field eq 'ao'
                    ? 1
                    : 3
                : $at =~ /Weekly$/ ? $dt_field eq 'ao'
                    ? 1
                    : 3
                : $at =~ /AuthorMonthly$/ ? 3
                : $at =~ /Monthly$/       ? $dt_field eq 'ao'
                    ? 1
                    : 3
                : $at =~ /Yearly$/ ? $at =~ /Category/
                    ? 3
                    : $dt_field eq 'ao' ? 3
                : 3
                : 3;
            push @suite,
                {
                ArchiveType => $at,
                Template => ( $at eq 'ContentType' ? $tmpl : $tmpl_archive ),
                TemplateMap => $map,
                Html        => $html{$at}{$dt_field},
                Published   => 1,
                DTField     => $dt_field,
                Count       => $count,
                };
        }
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
        || $archiver->category_based ? $category1 : undef;
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
    is( $does_publish_file, $s->{Count},
        ref($archiver) . '::does_publish_file: ' . $s->{DTField} );

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
    is( -e $file ? 1 : 0,
        $s->{Published}, 'Rebuild: When a target file does not exists' );
    my $fmgr = MT::FileMgr->new('Local');
    is( $fmgr->get_data($file), $s->{Html},
              ref($archiver) . ': '
            . $s->{DTField}
            . ': Published contents: When a target file does not exists' );

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
    is( -e $file ? 1 : 0,
        $s->{Published}, 'Rebuild: When a target file already exists' );
    is( $fmgr->get_data($file), $s->{Html},
              ref($archiver) . ': '
            . $s->{DTField}
            . ': Published contents: When a target file does not exists' );
}

done_testing;
