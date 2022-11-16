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
$plugin_data->plugin('GoogleAnalytics');
$plugin_data->key('configuration:blog:1');
$plugin_data->data({
  profile_web_property_id => 'UA-xxxxx',
  profile_id => 'Dummy',
  client_id => 'Dummy',
  client_secret => 'Dummy'
});
$plugin_data->save;

my $blog = $app->model('blog')->load(1);
use GoogleAnalytics;
my $pdata = GoogleAnalytics::current_plugindata( $app, $blog );

my $blog_id = 1;

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

done_testing;

__DATA__

=== ga.js
--- template
<mt:StatsSnippet>
--- expected
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-xxxxx']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>

=== gtag
--- template
<mt:StatsSnippet gtag="1">
--- expected
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-xxxxx"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-xxxxx');
</script>