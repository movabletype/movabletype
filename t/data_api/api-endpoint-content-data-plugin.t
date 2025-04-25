use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More;
use MT::Test::Env;
use MT::Test::Util::Plugin;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
        PluginPath => [qw(
            MT_HOME/plugins
            MT_HOME/t/plugins
            TEST_ROOT/plugins
        )]
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    MT::Test::Util::Plugin->write(
        ContentDataFilterTest => {
            'config.yaml' => {
                yaml => <<'YAML',
callbacks:
  data_api_pre_load_filtered_list.content_data: |
    sub {
      my ($cb, $app, $filter, $options) = @_;

      my ( $site, $content_type ) = MT::DataAPI::Endpoint::Common::context_objects($app, $app->current_endpoint);
      my $fields = $content_type->fields;
      for my $field (@$fields) {
          my $key = 'content_field_' . $field->{id};
          my $value = $app->param($key);
          next unless defined($value);
          $filter->append_item({
              'type' => $key,
              'args' => {
                  'string' => $value,
                  'option' => 'contains',
              }
          });
      }
    }
YAML
            },
        },
    );
}

use MT::Test;
use MT::Test::DataAPI;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

use MT::ContentStatus;

my $user = MT->model('author')->load(1);
$user->email('melody@example.com');
$user->save;

$app->user($user);

my $site_id = 1;

my $content_type
    = MT::Test::Permission->make_content_type( blog_id => $site_id );
my $content_type_id = $content_type->id;

my $single_field = MT::Test::Permission->make_content_field(
    blog_id         => $content_type->blog_id,
    content_type_id => $content_type->id,
    name            => 'single',
    type            => 'single_line_text',
);
my $field_id = $single_field->id;

my $fields = [
    {   id        => $single_field->id,
        order     => 1,
        type      => $single_field->type,
        options   => { label => $single_field->name },
        unique_id => $single_field->unique_id,
    }
];
$content_type->fields($fields);
$content_type->save or die $content_type->errstr;

my $cd_release_sixapart = MT::Test::Permission->make_content_data(
    blog_id         => $site_id,
    content_type_id => $content_type_id,
    status          => MT::ContentStatus::RELEASE(),
    data            => { $single_field->id => 'sixapart', },
    created_on      => '20180605121212',
    modified_on     => '20180605121212',
);

my $cd_release_movabletype = MT::Test::Permission->make_content_data(
    blog_id         => $site_id,
    content_type_id => $content_type_id,
    status          => MT::ContentStatus::RELEASE(),
    data            => { $single_field->id => 'movabletype', },
    created_on      => '20180605121213',
    modified_on     => '20180605121213',
);

my $cd_hold_sixapart = MT::Test::Permission->make_content_data(
    blog_id         => $site_id,
    content_type_id => $content_type_id,
    status          => MT::ContentStatus::HOLD(),
    data            => { $single_field->id => 'sixapart', },
);

my $cd_hold_movabletype = MT::Test::Permission->make_content_data(
    blog_id         => $site_id,
    content_type_id => $content_type_id,
    status          => MT::ContentStatus::HOLD(),
    data            => { $single_field->id => 'movabletype', },
);

MT->request->reset;
MT::CMS::ContentType::init_content_type(sub { die }, $app);

test_data_api(
    {   note   => 'without queries',
        path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
        method => 'GET',
        author_id => 0,
        result => sub {
            +{  totalResults => 2,
                items => MT::DataAPI::Resource->from_object( [$cd_release_movabletype, $cd_release_sixapart] ),
            };
        },
    }
);

test_data_api(
    {   note   => 'with queries',
        path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
        params => { "content_field_$field_id" => 'sixapart', },
        method => 'GET',
        author_id => 0,
        result => sub {
            +{  totalResults => 1,
                items => MT::DataAPI::Resource->from_object( [$cd_release_sixapart] ),
            };
        },
    }
);

done_testing;
