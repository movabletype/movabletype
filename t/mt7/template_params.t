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

my $mt = MT->instance;
my $blog
    = MT::Test::Permission->make_blog( parent_id => 0, name => 'test blog' );

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
$content_type->fields($fields);
$content_type->save or die $content_type->errstr;

my $author = MT::Test::Permission->make_author(
    name     => 'yishikawa',
    nickname => 'Yuki Ishikawa',
);

my $content_data = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $content_type->id,
    author_id       => $author->id,
    authored_on     => '20170909130530',
    data            => {
        $cf_datetime->id => '20170603180500',
        $cf_category->id => [ $category->id ],
    },
);

my $publisher = MT::ContentPublisher->new( start_time => time() + 10 );

my $text = '';
my %html;
foreach my $param (
    qw/
    archive_template
    archive_listing
    datebased_archive
    entry_archive
    entry_template
    page_archive
    page_template
    feedback_template
    datebased_only_archive
    datebased_daily_archive
    datebased_weekly_archive
    datebased_monthly_archive
    datebased_yearly_archive
    author_archive
    author_based_archive
    author_daily_archive
    author_weekly_archive
    author_monthly_archive
    author_yearly_archive
    category_archive
    category_based_archive
    category_daily_archive
    category_weekly_archive
    category_monthly_archive
    category_yearly_archive
    archive_class
    contenttype_archive
    contenttype_archive_listing
    /
    )
{
    $text .= "<mt:if name=\"$param\">$param</mt:if>";

    foreach
        my $prefix (qw( ContentType ContentType-Author ContentType-Category ))
    {
        foreach
            my $suffix ( ( '', '-Daily', '-Weekly', '-Monthly', '-Yearly' ) )
        {
            my $at       = $prefix . $suffix;
            my $archiver = $publisher->archiver($at);
            $html{$at} .= $param if $archiver->template_params->{$param};
        }
    }
}

my $tmpl = MT::Test::Permission->make_template(
    blog_id         => $blog->id,
    content_type_id => $content_data->id,
    name            => 'ContentType Test',
    type            => 'ct',
    text            => $text,
);
my $tmpl_archive = MT::Test::Permission->make_template(
    blog_id         => $blog->id,
    content_type_id => $content_data->id,
    name            => 'ContentType Archive Test',
    type            => 'ct_archive',
    text            => $text,
);

my @suite;
foreach my $prefix (qw( ContentType ContentType-Author ContentType-Category ))
{
    foreach my $suffix ( ( '', '-Daily', '-Weekly', '-Monthly', '-Yearly' ) )
    {
        #foreach my $dt_field (qw( ao cf )) {
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

        #}
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

    my $file_name
        = $publisher->archive_file_for( $content_data, $blog, $at, $category,
        $map, $content_data->authored_on,
        $content_data->author );
    my $file = File::Spec->catfile( $blog->archive_path, $file_name );

    unlink $file if -e $file;
    $mt->request->reset;
    $publisher->_rebuild_content_archive_type(
        ContentData => $content_data,
        Blog        => $blog,
        ArchiveType => $at,
        TemplateMap => $map,
        TemplateID  => $map->template_id,
        Force       => 1,
        Category    => $category,
        Author      => $content_data->author,
    );
    is( -e $file ? 1 : 0,
        $s->{Published}, 'Rebuild: When a target file does not exists' );
    my $fmgr = MT::FileMgr->new('Local');
    is( $fmgr->get_data($file), $s->{Html},
        ref($archiver) . ': '
            . ': Published contents: When a target file does not exists' );
}

done_testing;
