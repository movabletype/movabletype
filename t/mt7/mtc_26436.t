#!/usr/bin/perl

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

use MT::Test::Tag;
plan tests => 2 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $blog = MT::Test::Permission->make_blog(
            parent_id => 0,
            name      => 'test blog',
        );

        my $category_set = MT::Test::Permission->make_category_set(
            blog_id => $blog->id,
            name    => 'test category set',
        );

        my @categories;
        for my $name (qw/Alice Bob Carol Dan/) {
            push @categories,
                MT::Test::Permission->make_category(
                blog_id         => $blog->id,
                category_set_id => $category_set->id,
                label           => $name,
                );
        }

        my $content_type_01 = MT::Test::Permission->make_content_type(
            blog_id => $blog->id,
            name    => 'test content type 01',
        );

        my $content_type_02 = MT::Test::Permission->make_content_type(
            blog_id => $blog->id,
            name    => 'test content type 02',
        );

        my $cf_category_01 = MT::Test::Permission->make_content_field(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            name            => 'Category Field 01',
            type            => 'categories',
        );

        my $cf_category_02 = MT::Test::Permission->make_content_field(
            blog_id         => $blog->id,
            content_type_id => $content_type_02->id,
            name            => 'Category Field 02',
            type            => 'categories',
        );

        $cf_category_01->related_cat_set_id( $category_set->id );
        $cf_category_01->save;

        $cf_category_02->related_cat_set_id( $category_set->id );
        $cf_category_02->save;

        my $fields_01 = [
            {   id      => $cf_category_01->id,
                order   => 15,
                type    => $cf_category_01->type,
                options => {
                    label        => $cf_category_01->name,
                    category_set => $category_set->id,
                    multiple     => 0,
                },
            },
        ];

        my $fields_02 = [
            {   id      => $cf_category_02->id,
                order   => 15,
                type    => $cf_category_02->type,
                options => {
                    label        => $cf_category_02->name,
                    category_set => $category_set->id,
                    multiple     => 0,
                },
            },
        ];

        $content_type_01->fields($fields_01);
        $content_type_01->save or die $content_type_01->errstr;

        $content_type_02->fields($fields_02);
        $content_type_02->save or die $content_type_02->errstr;

        my $content_data_01 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20201010101010',
            identifier      => 'mtcontent_type-context-test-data-01',
            data            => { $cf_category_01->id => [ $categories[0]->id ], }
        );

        my $content_data_02 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20201010101010',
            identifier      => 'mtcontent_type-context-test-data-02',
            data            => { $cf_category_01->id => [ $categories[1]->id ], }
        );

        my $content_data_03 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_02->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20201010101010',
            identifier      => 'mtcontent_type-context-test-data-03',
            data            => { $cf_category_02->id => [ $categories[2]->id ], }
        );

        my $content_data_04 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_02->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20201010101010',
            identifier      => 'mtcontent_type-context-test-data-04',
            data            => { $cf_category_02->id => [ $categories[3]->id ], }
        );

        my $template_01 = MT::Test::Permission->make_template(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            name            => 'ContentType Test 01',
            type            => 'ct_archive',
            text            => 'test 01',
        );

        my $template_02 = MT::Test::Permission->make_template(
            blog_id         => $blog->id,
            content_type_id => $content_type_02->id,
            name            => 'ContentType Test 02',
            type            => 'ct_archive',
            text            => 'test 02',
        );

        my $map_01 = MT::Test::Permission->make_templatemap(
            template_id   => $template_01->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType-Category',
            file_template => '%-c/%i',
            is_preferred  => 1,
            cat_field_id  => $cf_category_01->id,
        );

        my $map_02 = MT::Test::Permission->make_templatemap(
            template_id   => $template_02->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType-Category',
            file_template => '%-c/%i',
            is_preferred  => 1,
            cat_field_id  => $cf_category_02->id,
        );

        my $fi_01 = MT::Test::Permission->make_fileinfo(
            blog_id        => $blog->id,
            templatemap_id => $map_01->id,
            archive_type   => $map_01->archive_type,
            category_id    => $categories[0]->id,
            url            => lc( $categories[0]->label ) . '/',
        );

        my $fi_02 = MT::Test::Permission->make_fileinfo(
            blog_id        => $blog->id,
            templatemap_id => $map_01->id,
            archive_type   => $map_01->archive_type,
            category_id    => $categories[1]->id,
            url            => lc( $categories[1]->label ) . '/',
        );

        my $fi_03 = MT::Test::Permission->make_fileinfo(
            blog_id        => $blog->id,
            templatemap_id => $map_02->id,
            archive_type   => $map_02->archive_type,
            category_id    => $categories[2]->id,
            url            => lc( $categories[2]->label ) . '/',
        );

        my $fi_04 = MT::Test::Permission->make_fileinfo(
            blog_id        => $blog->id,
            templatemap_id => $map_02->id,
            archive_type   => $map_02->archive_type,
            category_id    => $categories[3]->id,
            url            => lc( $categories[3]->label ) . '/',
        );
    }
);

my $blog = MT::Blog->load( { name => 'test blog' } );

sub _load_objects {
    my ($block)    = @_;
    my $identifier = 'mtcontent_type-context-test-data-0' . $block->cd;
    my ($cd)       = MT->model('cd')->load( { identifier => $identifier } );
    my ($tmpl)
        = MT->model('template')
        ->load( { blog_id => $blog->id, content_type_id => $cd->content_type_id } );
    my ($map)
        = MT->model('templatemap')
        ->load(
        { blog_id => $blog->id, archive_type => 'ContentType-Category', template_id => $tmpl->id }
        );
    my $cf = MT->model('cf')->load( { id => $map->cat_field_id, } );
    return ( $map, $cd, $cf );
}

sub _callback_perl {
    my ( $ctx, $block ) = @_;
    my ( $map, $cd, $cf ) = _load_objects($block);
    my $content_type = MT->model('content_type')->load( { id => $cd->content_type_id } );
    my $category_set = MT->model('category_set')->load( { id => $cf->related_cat_set_id } );
    $ctx->stash( category_set => $category_set );
    $ctx->stash( content      => $cd );
    $ctx->stash( content_type => $content_type );
    $ctx->stash( template_map => $map );
    $ctx->{current_archive_type} = $map->archive_type;
}

sub _callback_php {
    my ($block) = @_;
    my ( $map, $cd, $cf ) = _load_objects($block);
    my ($finfo) = MT::FileInfo->load(
        {   blog_id        => $blog->id,
            templatemap_id => $map->id,
        }
    );
    my $objectcategory  = MT->model('objectcategory')->load( { object_id => $cd->id, } );
    my $category_set_id = $cf->related_cat_set_id;
    return <<"PHP";
require_once('class.mt_fileinfo.php');
\$fileinfo = new FileInfo;
\$fileinfo->Load(@{[$finfo->id]});
\$cd = \$ctx->mt->db()->fetch_content(@{[$cd->id]});
\$category = \$ctx->mt->db()->fetch_category(@{[$objectcategory->category_id]}, $category_set_id, @{[$cf->id]});
\$templates = \$ctx->mt->db()->fetch_templates(
    array(
        'type'            => 'ct_archive',
        'blog_id'         => @{[$blog->id]},
        'content_type_id' => @{[$cd->content_type_id]},
    )
);
\$ctx->stash('template', \$templates[0]);
\$content_type = \$ctx->mt->db()->fetch_content_type(@{[$cd->content_type_id]});
\$category_set = \$ctx->mt->db()->fetch_category_set($category_set_id);
\$ctx->stash('_fileinfo', \$fileinfo);
\$ctx->stash('current_archive_type', \$fileinfo->archive_type);
\$ctx->stash('content', \$cd);
\$ctx->stash('category', \$category);
\$ctx->stash('content_type', \$content_type);
\$ctx->stash('category_set', \$category_set);
PHP
}

MT::Test::Tag->run_perl_tests( $blog->id, \&_callback_perl, 'ContentType-Category' );
MT::Test::Tag->run_php_tests( $blog->id, \&_callback_php, 'ContentType-Category' );

__END__

=== CategoryPrevious and CategoryNext
--- cd chomp
1
--- template
<mt:CategoryPrevious><mt:CategoryLabel>|<mt:CategoryArchiveLink></mt:CategoryPrevious><br>
<mt:CategoryNext><mt:CategoryLabel>|<mt:CategoryArchiveLink></mt:CategoryNext><br>
--- expected
<br>
Bob|/::/nana/nana/archives/bob/<br>

=== CategoryPrevious and CategoryNext
--- cd chomp
2
--- template
<mt:CategoryPrevious><mt:CategoryLabel>|<mt:CategoryArchiveLink></mt:CategoryPrevious><br>
<mt:CategoryNext><mt:CategoryLabel>|<mt:CategoryArchiveLink></mt:CategoryNext><br>
--- expected
Alice|/::/nana/nana/archives/alice/<br>
<br>

=== CategoryPrevious and CategoryNext
--- cd chomp
3
--- template
<mt:CategoryPrevious><mt:CategoryLabel>|<mt:CategoryArchiveLink></mt:CategoryPrevious><br>
<mt:CategoryNext><mt:CategoryLabel>|<mt:CategoryArchiveLink></mt:CategoryNext><br>
--- expected
<br>
Dan|/::/nana/nana/archives/dan/<br>

=== CategoryPrevious and CategoryNext
--- cd chomp
4
--- template
<mt:CategoryPrevious><mt:CategoryLabel>|<mt:CategoryArchiveLink></mt:CategoryPrevious><br>
<mt:CategoryNext><mt:CategoryLabel>|<mt:CategoryArchiveLink></mt:CategoryNext><br>
--- expected
Carol|/::/nana/nana/archives/carol/<br>
<br>

=== ArchivePrevious and ArchiveNext
--- cd chomp
1
--- template
<mt:ArchivePrevious><mt:ArchiveTitle>|<mt:ArchiveLink></mt:ArchivePrevious><br>
<mt:ArchiveNext><mt:ArchiveTitle>|<mt:ArchiveLink></mt:ArchiveNext><br>
--- expected
<br>
Bob|/::/nana/nana/archives/bob/<br>

=== ArchivePrevious and ArchiveNext
--- cd chomp
2
--- template
<mt:ArchivePrevious><mt:ArchiveTitle>|<mt:ArchiveLink></mt:ArchivePrevious><br>
<mt:ArchiveNext><mt:ArchiveTitle>|<mt:ArchiveLink></mt:ArchiveNext><br>
--- expected
Alice|/::/nana/nana/archives/alice/<br>
<br>

=== ArchivePrevious and ArchiveNext
--- cd chomp
3
--- template
<mt:ArchivePrevious><mt:ArchiveTitle>|<mt:ArchiveLink></mt:ArchivePrevious><br>
<mt:ArchiveNext><mt:ArchiveTitle>|<mt:ArchiveLink></mt:ArchiveNext><br>
--- expected
<br>
Dan|/::/nana/nana/archives/dan/<br>

=== ArchivePrevious and ArchiveNext
--- cd chomp
4
--- template
<mt:ArchivePrevious><mt:ArchiveTitle>|<mt:ArchiveLink></mt:ArchivePrevious><br>
<mt:ArchiveNext><mt:ArchiveTitle>|<mt:ArchiveLink></mt:ArchiveNext><br>
--- expected
Carol|/::/nana/nana/archives/carol/<br>
<br>

=== ContentTypeName (related to MTC-26426)
--- cd chomp
1
--- template
<mt:ContentTypeName>
--- expected
test content type 01
