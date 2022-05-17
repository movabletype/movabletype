#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Permission;
use MT::Test::Tag;
$test_env->prepare_fixture('db');

my $app     = MT->instance;
my $plugin_data = $app->model('plugindata')->new;
$plugin_data->plugin('GoogleAnalyticsV4');
$plugin_data->key('configuration:blog:1');
$plugin_data->data({
  profile_web_property_id => 'Dummy',
  profile_id => 'Dummy',
  client_id => 'Dummy',
  client_secret => 'Dummy',
  measurement_id => 'G-xxxxx'
});
$plugin_data->save;

my $blog = $app->model('blog')->load(1);
use GoogleAnalyticsV4;
my $pdata = GoogleAnalyticsV4::current_plugindata( $app, $blog );

my $blog_id = 1;

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

done_testing;

__DATA__

=== ga.js
--- template
<mt:StatsSnippet>
--- expected
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-xxxxx"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-xxxxx');
</script>

=== gtag
--- template
<mt:StatsSnippet gtag="1">
--- expected
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-xxxxx"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-xxxxx');
</script>
