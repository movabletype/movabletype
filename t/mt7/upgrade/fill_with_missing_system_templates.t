use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('themes/missing_cd_search_results/theme.yaml', <<'YAML');
label: missing_cd_search_results
id: missing_cd_search_results
version: 1.0
class: both
elements:
  template_set:
    component: core
    importer: template_set
    name: template set
    data:
      label: missing_cd_search_results
      base_path: templates
      templates:
        system:
          comment_listing:
            label: Comment Listing
          comment_preview:
            label: Comment Preview
          comment_response:
            label: Comment Response
          dynamic_error:
            label: Dynamic Error
          popup_image:
            label: Popup Image
          search_results:
            label: Search Results
YAML

    $test_env->save_file('themes/different_cd_search_results/theme.yaml', <<'YAML');
label: different_cd_search_results
id: different_cd_search_results
version: 1.0
class: both
elements:
  template_set:
    component: core
    importer: template_set
    name: template set
    data:
      label: different_cd_search_results
      base_path: templates
      templates:
        system:
          comment_listing:
            label: Comment Listing
          comment_preview:
            label: Comment Preview
          comment_response:
            label: Comment Response
          dynamic_error:
            label: Dynamic Error
          popup_image:
            label: Popup Image
          search_results:
            label: Search Results
          cd_search_results:
            label: Different Content Data Search Results
YAML
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Upgrade;
use MT::Template;
use Test::Differences;

$test_env->prepare_fixture('db');

my $mt    = MT->instance;
my $admin = MT->model('author')->load(1);

my ($website1, $website2, $website3);
{
    require MT::DefaultTemplates;
    no warnings qw(once redefine);
    local *MT::DefaultTemplates::fill_with_missing_system_templates = sub {};

    $website1 = MT::Test::Permission->make_website(
    name => 'website1',
    theme_id => 'missing_cd_search_results',
);
    $website2 = MT::Test::Permission->make_website(
    name => 'website2',
    theme_id => 'different_cd_search_results',
);
    $website3 = MT::Test::Permission->make_website(
    name => 'website3',
    theme_id => 'classic_website',
);
}

my %templates1 = make_map($website1->id);
my %templates2 = make_map($website2->id);
my %templates3 = make_map($website3->id);

MT::Test::Upgrade->upgrade( from => 7.0053 );

$test_env->clear_mt_cache;

my %new_templates1 = make_map($website1->id);
my %new_templates2 = make_map($website2->id);
my %new_templates3 = make_map($website3->id);

ok !@{$templates1{cd_search_results} || []}, "website1 does not have a cd_search_results template";
is @{$new_templates1{cd_search_results}} => 1, "new website1 does have a cd_search_results template";

is @{$templates2{cd_search_results}} => 1, "website2 does has a cd_search_results template";
is @{$new_templates2{cd_search_results}} => 1, "new websit2 still has a cd_search_results template";
is $templates2{cd_search_results}[0] => $new_templates2{cd_search_results}[0], "text of cd_search_results has not changed";

is @{$templates3{cd_search_results}} => 1, "website3 does has a cd_search_results template";
is @{$new_templates3{cd_search_results}} => 1, "new websit3 still has a cd_search_results template";
is $templates3{cd_search_results}[0] => $new_templates3{cd_search_results}[0], "text of cd_search_results has not changed";

done_testing;

sub make_map {
    my $site_id = shift;
    my @templates = MT::Template->load({ blog_id => $site_id });
    my %map;
    for my $template (@templates) {
        my $text = $template->text;
        my $type = $template->type;
        push @{$map{$type} ||= []}, $text;
    }
    %map;
}
