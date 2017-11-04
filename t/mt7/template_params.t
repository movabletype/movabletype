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

use MT::Test;
use MT::Test::Permission;
use File::Basename;

use MT::ContentFieldIndex;
use MT::ContentPublisher;

my $mt = MT->instance;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

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
    my $plain_category = MT::Test::Permission->make_category(
        blog_id         => $category_set->blog_id,
        category_set_id => 0,
        label           => 'plain_category',
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

    my $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $author->id,
        title     => 'my entry',
    );
    $entry->attach_categories($plain_category);

    my $page = MT::Test::Permission->make_page(
        blog_id => $blog->id,
        title   => 'my page',
    );

    my $text = '';
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
        $text .=
            $param eq 'archive_class'
            ? "<mt:if name=\"$param\"><mt:var name=\"$param\">,</mt:if>"
            : "<mt:if name=\"$param\">$param,</mt:if>";
    }

    my $tmpl_entry = MT::Test::Permission->make_template(
        blog_id => $blog->id,
        name    => 'Entry Test',
        type    => 'individual',
        text    => $text,
    );
    my $tmpl_entry_archive = MT::Test::Permission->make_template(
        blog_id => $blog->id,
        name    => 'Entry Archive Test',
        type    => 'archive',
        text    => $text,
    );
    my $tmpl_page = MT::Test::Permission->make_template(
        blog_id => $blog->id,
        name    => 'Page Test',
        type    => 'page',
        text    => $text,
    );
    my $tmpl_ct = MT::Test::Permission->make_template(
        blog_id         => $blog->id,
        content_type_id => $content_data->id,
        name            => 'ContentType Test',
        type            => 'ct',
        text            => $text,
    );
    my $tmpl_ct_archive = MT::Test::Permission->make_template(
        blog_id         => $blog->id,
        content_type_id => $content_data->id,
        name            => 'ContentType Archive Test',
        type            => 'ct_archive',
        text            => $text,
    );
});

my $blog = MT::Blog->load( { name => 'test blog' } );

my $content_type = MT::ContentType->load( { name => 'test content type' } );

my $cf_category = MT::ContentField->load( { name => 'categories' } );
my $category = MT::Category->load( { label => 'category' } );
my $plain_category = MT::Category->load( { label => 'plain_category' } );

my $author = MT::Author->load( { name => 'yishikawa' } );

my $content_data = MT::ContentData->load(
    {
        blog_id         => $blog->id,
        content_type_id => $content_type->id,
        author_id       => $author->id,
        authored_on     => '2017-09-09 13:05:30',
    }
);

my $entry = MT::Entry->load( { title => 'my entry' } );
my $page  = MT::Page->load( { title => 'my page' } );

my $publisher = MT::ContentPublisher->new( start_time => time() + 10 );

my %html = (
    'Page' =>
        'archive_template,page_archive,page_template,feedback_template,page-archive,',
    'Individual' =>
        'archive_template,entry_archive,entry_template,feedback_template,entry-archive,',
    'Daily' =>
        'archive_template,archive_listing,datebased_archive,datebased_only_archive,datebased_daily_archive,datebased-daily-archive,',
    'Weekly' =>
        'archive_template,archive_listing,datebased_archive,datebased_only_archive,datebased_weekly_archive,datebased-weekly-archive,',
    'Monthly' =>
        'archive_template,archive_listing,datebased_archive,datebased_only_archive,datebased_monthly_archive,datebased-monthly-archive,',
    'Yearly' =>
        'archive_template,archive_listing,datebased_archive,datebased_only_archive,datebased_yearly_archive,datebased-yearly-archive,',
    'Author' =>
        'archive_template,archive_listing,author_archive,author_based_archive,author-archive,',
    'Author-Daily' =>
        'archive_template,archive_listing,datebased_archive,author_based_archive,author_daily_archive,author-daily-archive,',
    'Author-Weekly' =>
        'archive_template,archive_listing,datebased_archive,author_based_archive,author_weekly_archive,author-weekly-archive,',
    'Author-Monthly' =>
        'archive_template,archive_listing,datebased_archive,author_based_archive,author_monthly_archive,author-monthly-archive,',
    'Author-Yearly' =>
        'archive_template,archive_listing,datebased_archive,author_based_archive,author_yearly_archive,author-yearly-archive,',
    'Category' =>
        'archive_template,archive_listing,category_archive,category_based_archive,category-archive,',
    'Category-Daily' =>
        'archive_template,archive_listing,datebased_archive,category_based_archive,category_daily_archive,category-daily-archive,',
    'Category-Weekly' =>
        'archive_template,archive_listing,datebased_archive,category_based_archive,category_weekly_archive,category-weekly-archive,',
    'Category-Monthly' =>
        'archive_template,archive_listing,datebased_archive,category_based_archive,category_monthly_archive,category-monthly-archive,',
    'Category-Yearly' =>
        'archive_template,archive_listing,datebased_archive,category_based_archive,category_yearly_archive,category-yearly-archive,',
    'ContentType' =>
        'archive_template,archive_listing,contenttype-archive,contenttype_archive,',
    'ContentType-Daily' =>
        'archive_template,archive_listing,datebased_archive,datebased_only_archive,datebased_daily_archive,contenttype-datebased-daily-archive,contenttype_archive_listing,',
    'ContentType-Weekly' =>
        'archive_template,archive_listing,datebased_archive,datebased_only_archive,datebased_weekly_archive,contenttype-datebased-weekly-archive,contenttype_archive_listing,',
    'ContentType-Monthly' =>
        'archive_template,archive_listing,datebased_archive,datebased_only_archive,datebased_monthly_archive,contenttype-datebased-monthly-archive,contenttype_archive_listing,',
    'ContentType-Yearly' =>
        'archive_template,archive_listing,datebased_archive,datebased_only_archive,datebased_yearly_archive,contenttype-datebased-yearly-archive,contenttype_archive_listing,',
    'ContentType-Author' =>
        'archive_template,archive_listing,author_archive,author_based_archive,contenttype-author-archive,contenttype_archive_listing,',
    'ContentType-Author-Daily' =>
        'archive_template,archive_listing,datebased_archive,author_based_archive,author_daily_archive,contenttype-author-daily-archive,contenttype_archive_listing,',
    'ContentType-Author-Weekly' =>
        'archive_template,archive_listing,datebased_archive,author_based_archive,author_weekly_archive,contenttype-author-weekly-archive,contenttype_archive_listing,',
    'ContentType-Author-Monthly' =>
        'archive_template,archive_listing,datebased_archive,author_based_archive,author_monthly_archive,contenttype-author-monthly-archive,contenttype_archive_listing,',
    'ContentType-Author-Yearly' =>
        'archive_template,archive_listing,datebased_archive,author_based_archive,author_yearly_archive,contenttype-author-yearly-archive,contenttype_archive_listing,',
    'ContentType-Category' =>
        'archive_template,archive_listing,category_archive,category_based_archive,contenttype-category-archive,contenttype_archive_listing,',
    'ContentType-Category-Daily' =>
        'archive_template,archive_listing,datebased_archive,category_based_archive,category_daily_archive,contenttype-category-daily-archive,contenttype_archive_listing,',
    'ContentType-Category-Weekly' =>
        'archive_template,archive_listing,datebased_archive,category_based_archive,category_weekly_archive,contenttype-category-weekly-archive,contenttype_archive_listing,',
    'ContentType-Category-Monthly' =>
        'archive_template,archive_listing,datebased_archive,category_based_archive,category_monthly_archive,contenttype-category-monthly-archive,contenttype_archive_listing,',
    'ContentType-Category-Yearly' =>
        'archive_template,archive_listing,datebased_archive,category_based_archive,category_yearly_archive,contenttype-category-yearly-archive,contenttype_archive_listing,',
);

my $tmpl_entry = MT::Template->load( { name => 'Entry Test' } );
my $tmpl_entry_archive = MT::Template->load( { name => 'Entry Archive Test' } );

my $tmpl_page = MT::Template->load( { name => 'Page Test' } );

my $tmpl_ct   = MT::Template->load( { name => 'ContentType Test' } );
my $tmpl_ct_archive = MT::Template->load( { name => 'ContentType Archive Test' } );

my @suite;
foreach my $prefix (
    qw( Page Individual Author Category ContentType ContentType-Author ContentType-Category )
    )
{
    foreach my $suffix ( ( '', 'Daily', 'Weekly', 'Monthly', 'Yearly' ) ) {
        next if $prefix eq 'Page' && $suffix;
        my $at
            = $suffix eq ''           ? $prefix
            : $prefix eq 'Individual' ? $suffix
            :                           $prefix . '-' . $suffix;
        my $map = MT::Test::Permission->make_templatemap(
            template_id => (
                  $at eq 'Page'          ? $tmpl_page->id
                : $at eq 'Individual'    ? $tmpl_entry->id
                : $at eq 'ContentType'   ? $tmpl_ct->id
                : $at =~ /^ContentType-/ ? $tmpl_ct_archive->id
                :                          $tmpl_entry_archive->id
            ),
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
            Template    => (
                  $at eq 'Page'          ? $tmpl_page
                : $at eq 'Individual'    ? $tmpl_entry
                : $at eq 'ContentType'   ? $tmpl_ct
                : $at =~ /^ContentType-/ ? $tmpl_ct_archive
                :                          $tmpl_entry_archive
            ),
            TemplateMap => $map,
            Html        => $html{$at},
            Published   => 1,
            };
        print "'$at' => '$html{$at}',\n";
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
        = $at eq 'Page'
        ? $publisher->archive_file_for( $page, $blog, $at, undef,
        $map, $page->authored_on, $page->author )
        : $at eq 'Individual' || $at !~ /^ContentType/
        ? $publisher->archive_file_for( $entry, $blog, $at,
        $plain_category, $map, $entry->authored_on, $entry->author )
        : $publisher->archive_file_for( $content_data, $blog, $at,
        $category, $map, $content_data->authored_on,
        $content_data->author );
    my $arch_root = $at eq 'Page' ? $blog->site_path : $blog->archive_path;
    my $file = File::Spec->catfile( $arch_root, $file_name );

    unlink $file if -e $file;
    $mt->request->reset;
    if ( $at eq 'Individual' || $at !~ /^ContentType/ ) {
        my $obj = $at eq 'Page' ? $page : $entry;
        $publisher->_rebuild_entry_archive_type(
            Entry       => $obj,
            Blog        => $blog,
            ArchiveType => $at,
            TemplateMap => $map,
            TemplateID  => $map->template_id,
            Force       => 1,
            ( $at eq 'Page' ? () : ( Category => $plain_category ) ),
            Author => $obj->author,
        );
    }
    else {
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
    }
    is( -e $file ? 1 : 0,
        $s->{Published}, 'Rebuild: When a target file does not exists' );
    my $fmgr = MT::FileMgr->new('Local');
    is( $fmgr->get_data($file), $s->{Html},
        ref($archiver) . ': '
            . ': Published contents: When a target file does not exists' );
}

done_testing;
