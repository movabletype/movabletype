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

use MT::Test;
use MT::Test::Fixture;

MT::Test->init_app;
$test_env->prepare_fixture('db');

my $website_name = 'tags-asset-website-' . time();
my $super        = 'super';

my $objs = MT::Test::Fixture->prepare(
    {   author  => [ { 'name' => $super }, ],
        website => [
            {   name     => $website_name,
                site_url => 'http://example.com/blog/',
            },
        ],
    }
);

my $author = $objs->{author}{$super};
my $website = $objs->{website}{$website_name};

my $removed_asset = MT::Asset::Image->new;
$removed_asset->blog_id($website->id);
$removed_asset->url($website->site_url . 'removed.jpg');
$removed_asset->file_path(File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'removed.jpg' ));
$removed_asset->file_name('removed.jpg');
$removed_asset->file_ext('jpg');
$removed_asset->image_width(640);
$removed_asset->image_height(480);
$removed_asset->mime_type('image/jpeg');
$removed_asset->label('Image photo');
$removed_asset->created_by($author->id);
$removed_asset->save or die "Couldn't save asset: " . $removed_asset->errstr;

my $file_asset = MT::Asset->new;
$file_asset->blog_id($website->id);
$file_asset->url($website->site_url . 'test.pdf');
$file_asset->file_path(File::Spec->catfile( $ENV{MT_HOME}, "t", 'files', 'test.pdf' ));
$file_asset->file_name('test.pdf');
$file_asset->file_ext('pdf');
$file_asset->mime_type('application/pdf');
$file_asset->label('PDF file');
$file_asset->created_by($author->id);
$file_asset->save or die "Couldn't save asset: " . $file_asset->errstr;

my %vars = (
    REMOVED_ASSET_ID => $removed_asset->id,
    FILE_ASSET_ID    => $file_asset->id,
);

sub var {
    for my $line (@_) {
        for my $key ( keys %vars ) {
            my $value = $vars{$key};
            $line =~ s/$key/$value/g;
        }
    }
    @_;
}

filters {
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
};

MT::Test::Tag->run_perl_tests($website->id);
MT::Test::Tag->run_php_tests($website->id);

__END__

=== MTAssetThumbnailURL for removed file
--- template
<MTAsset id="REMOVED_ASSET_ID">
<$MTAssetURL$>: <$MTAssetThumbnailURL scale="75" _default="blank"$>
</MTAsset>
--- expected
http://example.com/blog/removed.jpg: blank

=== MTAssetThumbnailURL for a PDF file
--- template
<MTAsset id="FILE_ASSET_ID">
<$MTAssetURL$>: <$MTAssetThumbnailURL scale="75" _default="blank"$>
</MTAsset>
--- expected
http://example.com/blog/test.pdf: blank
