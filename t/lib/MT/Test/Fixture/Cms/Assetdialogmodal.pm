package MT::Test::Fixture::Cms::Assetdialogmodal;
use strict;
use warnings;
use base 'MT::Test::Fixture';

use MT::Test::Image;
use File::Basename qw( basename );
use File::Spec;

sub prepare_fixture {
    my $self = shift;

    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(
        name      => 'asset dialog website',
        site_path => $ENV{MT_TEST_ROOT},
    );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'asset dialog blog',
    );

    # Content Type
    my $ct = MT::Test::Permission->make_content_type(
        name    => 'content type 1',
        blog_id => $website->id,
    );

    # Content Field
    my $cf_image = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'asset_image',
        type            => 'asset_image',
    );

    # Image
    my ($guard, $jpg_file) = MT::Test::Image->tempfile(
        DIR    => $website->site_path,
        SUFFIX => '.jpg',
    );
    close $guard;
    my $basename = basename($jpg_file);
    my $pic1 = MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => $website->id,
        file_name    => $basename,
        file_path    => File::Spec->catfile('%r', $basename),
        file_ext     => 'jpg',
        label        => 'Sample Image 1',
        description  => 'Sample Image 1',
    );
    my $pic2 = MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => $blog->id,
        file_name    => $basename,
        file_path    => File::Spec->catfile('%r', $basename),
        file_ext     => 'jpg',
        label        => 'Sample Image 2',
        description  => 'Sample Image 2',
    );
}

1;
