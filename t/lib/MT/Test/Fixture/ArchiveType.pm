package MT::Test::Fixture::ArchiveType;

use strict;
use warnings;
use MT::Test;
use MT::Test::Fixture;

our %FixtureSpec = (
    author  => [qw/author1 author2/],
    website => [
        {   name         => 'site_for_archive_test',
            theme_id     => 'classic_website',
            site_path    => 'TEST_ROOT/site',
            archive_path => 'TEST_ROOT/site/archive',
        }
    ],
    folder => [
        'folder_oolong_tea',
        'folder_green_tea',
        { label => 'folder_cola',   parent => 'folder_green_tea' },
        { label => 'folder_coffee', parent => 'folder_cola' },
        'folder_water',
    ],
    page => [
        {   basename    => 'page_author1_coffee',
            title       => 'page_author1_coffee',
            author      => 'author1',
            status      => 'publish',
            authored_on => '20181029101112',
            folder      => 'folder_coffee',
        },
        {   basename    => 'page_author1_publish',
            title       => 'page_author1_coffee',
            author      => 'author1',
            status      => 'publish',
            authored_on => '20181029101112',
            folder      => 'folder_coffee',
        },
        {   basename    => 'page_author2_water',
            title       => 'page_author2_water',
            author      => 'author2',
            status      => 'publish',
            authored_on => '20251029101112',
            folder      => 'folder_water',
        },
        {   basename    => 'page_author2_no_folder',
            title       => 'page_author2_no_folder',
            author      => 'author2',
            status      => 'publish',
            authored_on => '20361029101112',
            folder      => '',
        },
        {   basename    => 'page_author1_draft',
            title       => 'page_author1_draft1',
            author      => 'author1',
            status      => 'draft',
            authored_on => '20421029101112',
            folder      => 'folder_cola',
        },
    ],
    category => [
        'cat_clip',
        { label => 'cat_compass', parent => 'cat_clip' },
        { label => 'cat_ruler',   parent => 'cat_compass' },
        'cat_eraser',
        'cat_pencil',
    ],
    entry => [
        {   basename    => 'entry_author1_ruler_eraser',
            title       => 'entry_author1_ruler_eraser',
            author      => 'author1',
            status      => 'publish',
            authored_on => '20181203121110',
            categories  => [qw/cat_ruler cat_eraser/],
        },
        {   basename    => 'entry_author1_ruler_eraser_1',
            title       => 'entry_author1_ruler_eraser',
            author      => 'author1',
            status      => 'publish',
            authored_on => '20181203121110',
            categories  => [qw/cat_ruler cat_eraser/],
        },
        {   basename    => 'entry_author1_compass',
            title       => 'entry_author1_compass',
            author      => 'author1',
            status      => 'publish',
            authored_on => '20171203121110',
            categories  => [qw/cat_compass/],
        },
        {   basename    => 'entry_author2_pencil_eraser',
            title       => 'entry_author2_pencil_eraser',
            author      => 'author2',
            status      => 'publish',
            authored_on => '20161203121110',
            categories  => [qw/cat_pencil cat_eraser/],
        },
        {   basename    => 'entry_author2_no_category',
            title       => 'entry_author2_no_category',
            author      => 'author2',
            status      => 'publish',
            authored_on => '20151203121110',
            categories  => [qw//],
        },
        {   basename    => 'entry_author1_draft',
            title       => 'entry_author1_draft',
            author      => 'author1',
            status      => 'draft',
            authored_on => '20141203121110',
            categories  => [qw/cat_compass cat_ruler/],
        },
    ],
);

our $CachedObjs;

sub fixture_spec { \%FixtureSpec }

sub prepare_fixture {
    my $class = shift;

    MT::Test->init_db;

    my $spec = $class->fixture_spec;

    my $objs = MT::Test::Fixture->prepare($spec);
    $CachedObjs = $objs;

    my $driver = MT::Object->driver;
    $driver->direct_remove('MT::Template');
    $driver->direct_remove('MT::TemplateMap');

    my $blog_id = $objs->{blog_id};
    for my $archive_type ( MT->publisher->archive_types ) {
        my $archiver      = MT->publisher->archiver($archive_type);
        my $tmpl_type     = _template_type($archive_type);
        ( my $archive_type_name = $archive_type ) =~ tr/A-Z-/a-z_/;
        my $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog_id,
            name    => "tmpl_$archive_type_name",
            type    => $tmpl_type,
        );
        my $map = MT::Test::Permission->make_templatemap(
            template_id   => $tmpl->id,
            blog_id       => $blog_id,
            archive_type  => $archive_type,
            file_template => $class->_file_template($archiver),
            is_preferred  => 1,
            build_type    => 1,
        );
    }

    MT->publisher->rebuild( BlogID => $blog_id );
}

sub _template_type {
    my $archive_type = shift;
    return 'individual' if $archive_type eq 'Individual';
    return 'page'       if $archive_type eq 'Page';
    return 'archive';    # and custom?
}

sub _file_template {
    my ( $class, $archiver ) = @_;
    my $prefix = "";
    for my $archive_template ( @{ $archiver->default_archive_templates } ) {
        next unless $archive_template->{default};
        return $prefix . $archive_template->{template};
    }
}

sub template_maps {
    my ( $class, @archive_types ) = @_;

    my $objs    = $class->load_objs;
    my $blog_id = $objs->{blog_id};

    my @maps;
    if (@archive_types) {
        @maps = MT::TemplateMap->load(
            {   blog_id      => $blog_id,
                archive_type => \@archive_types,
            }
        );
    }
    else {
        @maps = MT::TemplateMap->load( { blog_id => $blog_id } );
    }
    @maps;
}

sub load_objs {
    my $class = shift;

    return $CachedObjs if $CachedObjs;

    my $spec = $class->fixture_spec;

    my %objs;
    my @author_names = @{ $spec->{author} };
    my @authors = MT::Author->load( { name => \@author_names } );
    $objs{author} = { map { $_->name => $_ } @authors };
    $objs{author_id} = $authors[0]->id if @authors == 1;

    my @site_names = map { $_->{name} } @{ $spec->{website} };
    my @sites = MT::Website->load( { name => \@site_names } );
    $objs{website} = { map { $_->name => $_ } @sites };

    my @blog_names = map { $_->{name} } @{ $spec->{blog} };
    my @blogs = MT::Blog->load( { name => \@blog_names } );
    $objs{blog} = { map { $_->name => $_ } @blogs };

    my @all_sites = ( @sites, @blogs );
    $objs{blog_id} = $all_sites[0]->id if @all_sites == 1;

    my $blog_id = $objs{blog_id};

    my @category_labels
        = map { ref $_ ? $_->{label} : $_ } @{ $spec->{category} };
    my @entry_categories = MT::Category->load(
        {   blog_id => $blog_id,
            label   => \@category_labels,
        }
    );
    $objs{category} = { map { $_->label => $_ } @entry_categories };

    my @folder_labels
        = map { ref $_ ? $_->{label} : $_ } @{ $spec->{folder} };
    my @folders = MT::Folder->load(
        {   blog_id => $blog_id,
            label   => \@folder_labels,
        }
    );
    $objs{folder} = { map { $_->label => $_ } @folders };

    my @entry_names = map { $_->{basename} } @{ $spec->{entry} };
    my @entries = MT::Entry->load(
        {   blog_id  => $blog_id,
            basename => \@entry_names,
        }
    );
    $objs{entry} = { map { $_->basename => $_ } @entries };

    my @page_names = map { $_->{basename} } @{ $spec->{page} };
    my @pages = MT::Page->load(
        {   blog_id  => $blog_id,
            basename => \@page_names,
        }
    );
    $objs{page} = { map { $_->basename => $_ } @pages };

    $CachedObjs = \%objs;
}

1;
