use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::DataAPI;
use MT::Test::Permission;
use MT::Test::Fixture::ArchiveType;
use File::Path 'remove_tree';

$test_env->prepare_fixture('archive_type');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $objs = MT::Test::Fixture::ArchiveType->load_objs;

my $site_id = $objs->{website}{site_for_archive_test}->id;

my $ct_map = $objs->{content_type}{ct_with_same_catset};
my $cf_map = $ct_map->{content_field};

my $ct           = $ct_map->{content_type};
my $ct_id        = $ct->id;
my $ct_unique_id = $ct->unique_id;

my $cat_map = $objs->{category_set}{catset_fruit}{category};

publish_tests_for_create();

done_testing;

sub publish_tests_for_create {
    test_data_api(
        {   note   => 'publish => 1',
            path   => "/v4/sites/$site_id/contentTypes/$ct_id/data",
            method => 'POST',
            params => {
                content_data => {
                    label => 'publish_true',
                    data  => [
                        {   id   => $cf_map->{cf_same_date}->id,
                            data => '20200228000000',
                        },
                        {   id   => $cf_map->{cf_same_datetime}->id,
                            data => '20210228000000',
                        },
                        {   id   => $cf_map->{cf_same_catset_fruit}->id,
                            data => [ $cat_map->{cat_apple}->id ],
                        },
                        {   id   => $cf_map->{cf_same_catset_other_fruit}->id,
                            data => [ $cat_map->{cat_orange}->id ],
                        },
                    ],
                },
                publish => 1,
            },
            setup => sub {
                my $data = shift;
                my $site = MT::Website->load($site_id);
                remove_tree $site->archive_path;
            },
            complete => sub {
                my ( $data, $body ) = @_;
                require MT::ContentData;
                ok my $cd = MT::ContentData->load(
                    {   content_type_id => $ct_id,
                        label           => 'publish_true',
                    }
                );

                require MT::FileInfo;
                my @fileinfo = MT::FileInfo->load( { cd_id => $cd->id } );
                ok !grep( { !-f $_->file_path } @fileinfo ),
                    'all the published files exist';
            },
        }
    );
    test_data_api(
        {   note   => 'publish => 0',
            path   => "/v4/sites/$site_id/contentTypes/$ct_id/data",
            method => 'POST',
            params => {
                content_data => {
                    label => 'publish_false',
                    data  => [
                        {   id   => $cf_map->{cf_same_date}->id,
                            data => '20200328000000',
                        },
                        {   id   => $cf_map->{cf_same_datetime}->id,
                            data => '20210328000000',
                        },
                        {   id   => $cf_map->{cf_same_catset_fruit}->id,
                            data => [ $cat_map->{cat_apple}->id ],
                        },
                        {   id   => $cf_map->{cf_same_catset_other_fruit}->id,
                            data => [ $cat_map->{cat_orange}->id ],
                        },
                    ],
                },
                publish => 0,
            },
            setup => sub {
                my $data = shift;
                my $site = MT::Website->load($site_id);
                remove_tree $site->archive_path;
            },
            complete => sub {
                my ( $data, $body ) = @_;
                require MT::ContentData;
                ok my $cd = MT::ContentData->load(
                    {   content_type_id => $ct_id,
                        label           => 'publish_false',
                    }
                );

                require MT::FileInfo;
                my @fileinfo = MT::FileInfo->load( { cd_id => $cd->id } );
                ok !grep( { -f $_->file_path } @fileinfo ),
                    'all the published files do not exist';
            },
        }
    );
}
