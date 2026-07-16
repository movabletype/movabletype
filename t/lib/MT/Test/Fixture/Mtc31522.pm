package MT::Test::Fixture::Mtc31522;

use strict;
use warnings;
use base 'MT::Test::Fixture::ArchiveType';

our %FixtureSpec = (
    author  => [qw/author/],
    website => [{
        name         => 'parent_site_for_mtc31522',
        theme_id     => 'mont-blanc',
        site_path    => 'TEST_ROOT/site',
        archive_path => 'TEST_ROOT/site/archive',
    }],
    category_set => {
        catset1 => [qw/a b c/],
        catset2 => [qw/a b c/],
    },
    content_type => {
        ct1 => [
            catfield1 => {
                type         => 'categories',
                category_set => 'catset1',
            },
            catfield2 => {
                type         => 'categories',
                category_set => 'catset2',
            },
        ],
    },
    content_data => {
        data1 => {
            content_type => 'ct1',
            author       => 'author',
            status       => 'publish',
            authored_on  => '20260709000000',
            data         => {
                catfield1 => [qw/b/],
                catfield2 => [],
            },
        },
        data2 => {
            content_type => 'ct1',
            author       => 'author',
            status       => 'publish',
            authored_on  => '20260709000000',
            data         => {
                catfield1 => [],
                catfield2 => [qw/b/],
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

    my $blog_id      = $objs->{blog_id};
    my $archive_type = 'ContentType-Category';
    my $archiver     = MT->publisher->archiver($archive_type);
    my $tmpl_type    = 'ct_archive';
    my $ct           = (values %{ $objs->{content_type} })[0]{content_type};

    for my $i (0, 1) {
        my $tmpl = MT::Test::Permission->make_template(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            name            => 'tmpl' . ($i + 1),
            type            => $tmpl_type,
        );
        my $map = MT::Test::Permission->make_templatemap(
            template_id   => $tmpl->id,
            blog_id       => $blog_id,
            archive_type  => $archive_type,
            file_template => 'tmpl' . ($i + 1) . '/%C.html',
            is_preferred  => 1,
            build_type    => 1,
            cat_field_id  => $ct->fields->[$i]{id},
        );
    }

    $_->refresh for values %{ $objs->{website} };

    MT->publisher->rebuild(BlogID => $blog_id);
}

sub load_objs {
    my $class = shift;

    return $CachedObjs if $CachedObjs;

    $CachedObjs = MT::Test::Fixture->load_objs($class->fixture_spec);
}

1;
