package MT::Test::Fixture::ArchiveType;

use strict;
use warnings;
use MT::Test;
use MT::Test::Fixture;

our %FixtureSpec = (
    author => [qw/author1 author2/],
    website => [
        {   name     => 'site_for_archive_test',
            theme_id => 'mont-blanc',
        }
    ],
    folder => [
        'folder_oolong_tea',
        'folder_green_tea',
        { label => 'folder_cola', parent => 'folder_green_tea' },
        { label => 'folder_coffee', parent => 'folder_cola' },
        'folder_water',
    ],
    page => [
        {
            basename => 'page_author1_coffee',
            title => 'page_author1_coffee',
            author => 'author1',
            status => 'publish',
            authored_on => '20181029101112',
            folder => 'folder_coffee',
        },
        {
            basename => 'page_author1_publish',
            title => 'page_author1_coffee',
            author => 'author1',
            status => 'publish',
            authored_on => '20181029101112',
            folder => 'folder_coffee',
        },
        {
            basename => 'page_author2_water',
            title => 'page_author2_water',
            author => 'author2',
            status => 'publish',
            authored_on => '20251029101112',
            folder => 'folder_water',
        },
        {
            basename => 'page_author2_no_folder',
            title => 'page_author2_no_folder',
            author => 'author2',
            status => 'publish',
            authored_on => '20361029101112',
            folder => '',
        },
        {
            basename => 'page_author1_draft',
            title => 'page_author1_draft1',
            author => 'author1',
            status => 'draft',
            authored_on => '20421029101112',
            folder => 'folder_cola',
        },
    ],
    category => [
        'cat_clip',
        { label => 'cat_compass', parent => 'cat_clip' },
        { label => 'cat_ruler', parent => 'cat_compass' },
        'cat_eraser',
        'cat_pencil',
    ],
    entry => [
        {
            basename => 'entry_author1_ruler_eraser',
            title => 'entry_author1_ruler_eraser',
            author => 'author1',
            status => 'publish',
            authored_on => '20181203121110',
            categories => [qw/cat_ruler cat_eraser/],
        },
        {
            basename => 'entry_author1_ruler_eraser_1',
            title => 'entry_author1_ruler_eraser',
            author => 'author1',
            status => 'publish',
            authored_on => '20181203121110',
            categories => [qw/cat_ruler cat_eraser/],
        },
        {
            basename => 'entry_author1_compass',
            title => 'entry_author1_compass',
            author => 'author1',
            status => 'publish',
            authored_on => '20171203121110',
            categories => [qw/cat_compass/],
        },
        {
            basename => 'entry_author2_pencil_eraser',
            title => 'entry_author2_pencil_eraser',
            author => 'author2',
            status => 'publish',
            authored_on => '20161203121110',
            categories => [qw/cat_pencil cat_eraser/],
        },
        {
            basename => 'entry_author2_no_category',
            title => 'entry_author2_no_category',
            author => 'author2',
            status => 'publish',
            authored_on => '20151203121110',
            categories => [qw//],
        },
        {
            basename => 'entry_author1_draft',
            title => 'entry_author1_draft',
            author => 'author1',
            status => 'draft',
            authored_on => '20141203121110',
            categories => [qw/cat_compass cat_ruler/],
        },
    ],
    category_set => {
        catset_fruit  => [
            'cat_apple',
            'cat_strawberry',
            { label => 'cat_orange', parent => 'cat_strawberry' },
            'cat_peach',
        ],
        catset_animal => [
            'cat_giraffe',
            { label => 'cat_dog', parent => 'cat_giraffe' },
            { label => 'cat_cat', parent => 'cat_dog' },
            'cat_monkey',
            'cat_rabbit',
        ],
    },
    content_type => {
        ct_with_same_catset => [
            cf_same_date               => 'date',
            cf_same_datetime           => 'datetime',
            cf_same_catset_fruit       => {
                type => 'categories',
                category_set => 'catset_fruit',
            },
            cf_same_catset_other_fruit => {
                type => 'categories',
                category_set => 'catset_fruit',
            },
        ],
        ct_with_other_catset => [
            cf_other_date          => 'date',
            cf_other_datetime      => 'datetime',
            cf_other_catset_fruit  => {
                type => 'categories',
                category_set => 'catset_fruit',
            },
            cf_other_catset_animal => {
                type => 'categories',
                category_set => 'catset_animal',
            },
        ],
    },
    content_data => {
        cd_same_apple_orange => {
            content_type => 'ct_with_same_catset',
            author       => 'author1',
            status       => 'publish',
            authored_on  => '20181031000000',
            data         => {
                cf_same_date               => '20190926',
                cf_same_datetime           => '20081101121212',
                cf_same_catset_fruit       => [qw/cat_apple/],
                cf_same_catset_other_fruit => [qw/cat_orange/],
            },
        },
        cd_same_apple_orange_peach => {
            content_type => 'ct_with_same_catset',
            author       => 'author1',
            authored_on  => '20171031000000',
            status       => 'publish',
                data         => {
                cf_same_date               => '20200926',
                cf_same_datetime           => '20061101121212',
                cf_same_catset_fruit       => [qw/cat_apple cat_orange/],
                cf_same_catset_other_fruit => [qw/cat_peach/],
            },
        },
        cd_same_peach => {
            content_type => 'ct_with_same_catset',
            author       => 'author2',
            status       => 'publish',
            authored_on  => '20161031000000',
            data         => {
                cf_same_date               => '20210926',
                cf_same_datetime           => '20041101121212',
                cf_same_catset_fruit       => [qw/cat_peach/],
                cf_same_catset_other_fruit => [qw//],
            },
        },
        cd_same_same_date => {
            content_type => 'ct_with_same_catset',
            author       => 'author1',
            status       => 'publish',
            authored_on  => '20181031000000',
            data         => {
                cf_same_date               => '20200926',
                cf_same_datetime           => '20041101121212',
                cf_same_catset_fruit       => [qw//],
                cf_same_catset_other_fruit => [qw/cat_peach/],
            },
        },
        cd_same_draft => {
            content_type => 'ct_with_same_catset',
            author       => 'author2',
            status       => 'draft',
            authored_on  => '20181031000000',
            data         => {
                cf_same_date               => '20200926',
                cf_same_datetime           => '20041101121212',
                cf_same_catset_fruit       => [qw//],
                cf_same_catset_other_fruit => [qw/cat_peach/],
            },
        },
        cd_other_apple => {
            content_type => 'ct_with_other_catset',
            author       => 'author2',
            authored_on  => '20081101121212',
            status       => 'publish',
            data         => {
                cf_other_date          => '19990831',
                cf_other_datetime      => '20181031000000',
                cf_other_catset_fruit  => [qw/cat_apple/],
                cf_other_catset_animal => [qw//],
            },
        },
        cd_other_apple_orange_dog_cat => {
            content_type => 'ct_with_other_catset',
            author       => 'author2',
            authored_on  => '20061101121212',
            status       => 'publish',
            data         => {
                cf_other_date          => '19980831',
                cf_other_datetime      => '20161031000000',
                cf_other_catset_fruit  => [qw/cat_apple cat_orange/],
                cf_other_catset_animal => [qw/cat_dog cat_cat/],
            },
        },
        cd_other_all_fruit_rabbit => {
            content_type => 'ct_with_other_catset',
            author       => 'author1',
            authored_on  => '20041101121212',
            status       => 'publish',
            data         => {
                cf_other_date         => '19970831',
                cf_other_datetime     => '20181031000000',
                cf_other_catset_fruit => [qw/
                    cat_apple
                    cat_orange
                    cat_peach
                    cat_strawberry
                /],
                cf_other_catset_animal => [qw/cat_rabbit/],
            },
        },
        cd_other_same_date => {
            content_type => 'ct_with_other_catset',
            author       => 'author1',
            authored_on  => '20041101121212',
            status       => 'publish',
            data         => {
                cf_other_date          => '19980831',
                cf_other_datetime      => '20181031000000',
                cf_other_catset_fruit  => [qw//],
                cf_other_catset_animal => [qw/cat_dog cat_rabbit/],
            },
        },
        cd_other_draft => {
            content_type => 'ct_with_other_catset',
            author       => 'author1',
            authored_on  => '20041101121212',
            status       => 'draft',
            data         => {
                cf_other_date          => '19980831',
                cf_other_datetime      => '20181031000000',
                cf_other_catset_fruit  => [qw//],
                cf_other_catset_animal => [qw/cat_dog cat_rabbit/],
            },
        },
    },
);

our $CachedObjs;

sub fixture_spec { \%FixtureSpec }

sub prepare_fixture {
    my $class = shift;

    MT::Test->init_db;

    my $spec = $class->fixture_spec;

    my $objs = MT::Test::Fixture->prepare($spec);
    $CachedObjs = $objs;

    my $blog_id = $objs->{blog_id};
    for my $archive_type ( MT->publisher->archive_types ) {
        my $archiver      = MT->publisher->archiver($archive_type);
        my $tmpl_type     = _template_type($archive_type);
        my $file_template = _file_template($archiver);
        ( my $archive_type_name = $archive_type ) =~ tr/A-Z-/a-z_/;
        if ( $archive_type =~ /^ContentType/ ) {
            for my $ct_item ( values %{ $objs->{content_type} } ) {
                my $ct = $ct_item->{content_type};
                my @fields     = @{ $ct->fields };
                my @dt_fields  = grep { $_->{type} =~ /date/ } @fields;
                my @cat_fields = grep { $_->{type} eq 'categories' } @fields;
                my $tmpl       = MT::Test::Permission->make_template(
                    blog_id         => $blog_id,
                    content_type_id => $ct->id,
                    name => "tmpl_$archive_type_name" . '_' . $ct->name,
                    type => $tmpl_type,
                );
                my $map = MT::Test::Permission->make_templatemap(
                    template_id   => $tmpl->id,
                    blog_id       => $blog_id,
                    archive_type  => $archive_type,
                    file_template => $file_template,
                    is_preferred  => 1,
                    build_type    => 1,
                    cat_field_id  => $cat_fields[0]{id},
                );
            }
        }
        else {
            my $tmpl = MT::Test::Permission->make_template(
                blog_id => $blog_id,
                name    => "tmpl_$archive_type_name",
                type    => $tmpl_type,
            );
            my $map = MT::Test::Permission->make_templatemap(
                template_id   => $tmpl->id,
                blog_id       => $blog_id,
                archive_type  => $archive_type,
                file_template => $file_template,
                is_preferred  => 1,
                build_type    => 1,
            );
        }
    }

    MT->publisher->rebuild( BlogID => $blog_id );
}

sub _template_type {
    my $archive_type = shift;
    return 'individual' if $archive_type eq 'Individual';
    return 'page'       if $archive_type eq 'Page';
    return 'ct'         if $archive_type eq 'ContentType';
    return 'ct_archive' if $archive_type =~ /^ContentType/;
    return 'archive';   # and custom?
}

sub _file_template {
    my $archiver = shift;
    for my $archive_template ( @{ $archiver->default_archive_templates } ) {
        next unless $archive_template->{default};
        return $archive_template->{template};
    }
}

sub template_maps {
    my ($class, @archive_types) = @_;

    my $objs = $class->load_objs;
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
    my @authors = MT::Author->load( { name => \@author_names } );;
    $objs{author} = { map {$_->name => $_} @authors };
    $objs{author_id} = $authors[0]->id if @authors == 1;

    my @site_names = map { $_->{name} } @{ $spec->{website} };
    my @sites = MT::Website->load( { name => \@site_names } );
    $objs{website} = { map { $_->name => $_ } @sites };

    my @blog_names = map { $_->{name} } @{ $spec->{blog} };
    my @blogs = MT::Blog->load( { name => \@blog_names } );
    $objs{blog} = { map {$_->name => $_} @blogs };

    my @all_sites = ( @sites, @blogs );
    $objs{blog_id} = $all_sites[0]->id if @all_sites == 1;

    my $blog_id = $objs{blog_id};

    my @category_set_names = keys %{ $spec->{category_set} };
    my @category_sets = MT::CategorySet->load( {
        blog_id => $blog_id,
        name => \@category_set_names,
    } );

    my %category_set_map = map { $_->id => $_->name } @category_sets;
    my @categories = MT::Category->load( {
        blog_id => $blog_id,
        category_set_id => [ keys %category_set_map ],
    } );

    my %category_map;
    for my $cat (@categories) {
        $category_map{$cat->category_set_id}{$cat->name} = $cat;
    }

    for my $set (@category_sets) {
        $objs{category_set}{$set->name} = {
            category_set => $set,
            category => $category_map{$set->id},
        };
    }

    my @content_type_names = keys %{ $spec->{content_type} };
    my @content_types = MT::ContentType->load( {
        blog_id => $blog_id,
        name => \@content_type_names,
    } );
    my @content_type_ids = map {$_->id => $_} @content_types;

    my @content_fields = MT::ContentField->load( {
        blog_id => $blog_id,
        content_type_id => \@content_type_ids,
    } );

    my %content_field_map;
    for my $cf (@content_fields) {
        $content_field_map{ $cf->content_type_id }{ $cf->name } = $cf;
    }

    for my $ct (@content_types) {
        $objs{content_type}{$ct->name} = {
            content_type => $ct,
            content_field => $content_field_map{ $ct->id },
        };
    }

    my @content_data = MT::ContentData->load( {
        blog_id => $blog_id,
        content_type_id => \@content_type_ids,
    } );
    $objs{content_data} = { map {$_->label => $_} @content_data };

    $CachedObjs = \%objs;
}

1;
