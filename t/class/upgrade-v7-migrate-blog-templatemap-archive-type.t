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

use MT::Test;
use MT::Test::Permission;
use MT::Upgrade;
use MT::Upgrade::v7;

$MT::Upgrade::App = 'MT';    # to get error string

$test_env->prepare_fixture('db');

# set archive_type to website
my $website = MT->model('website')->load or die;
$website->archive_type('ContentType_Author,ContentType_Author-Daily');
$website->save or die;

# create templatemap
my $templatemap = MT::Test::Permission->make_templatemap(
    blog_id      => $website->id,
    archive_type => 'ContentType_Author-Weekly',
);

# create templatemap with invalid blog_id
my $invalid_blog_id = 10;
die if MT->model('blog')->exist($invalid_blog_id);
my $templatemap_with_invalid_blog_id
    = _create_templatemap( blog_id => $invalid_blog_id );
$templatemap_with_invalid_blog_id->refresh;
die unless $templatemap_with_invalid_blog_id->blog_id == $invalid_blog_id;

# create templatemap without blog_id
my $templatemap_without_blog_id = _create_templatemap( blog_id => 0 );
$templatemap_without_blog_id->refresh;
die unless $templatemap_without_blog_id->blog_id == 0;

# run upgrade function
MT::Upgrade::v7::_v7_migrate_blog_templatemap_archive_type('MT::Upgrade');

# test
ok( !MT->errstr, 'no error occurs' );
$website->refresh;
$templatemap->refresh;
is( $website->archive_type,
    'ContentType-Author,ContentType-Author-Daily,ContentType-Author-Weekly,Individual',
    'archive_type of site is migrated'
);
is( $templatemap->archive_type,
    'ContentType-Author-Weekly', 'archive_type of templatemap is migrated' );

done_testing;

sub _create_templatemap {
    my %args    = @_;
    my $blog_id = $args{blog_id};

    my $templatemap = MT::Test::Permission->make_templatemap(
        archive_type => 'Individual' );
    $templatemap->blog_id($blog_id);
    MT::Object::save($templatemap);    # to set invalid blog_id

    $templatemap;
}

