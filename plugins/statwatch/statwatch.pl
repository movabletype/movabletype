# StatWatch - statwatch.pl
# Nick O'Neill (http://www.raquo.net/statwatch/)

# Use <$MTStats$> in your templates to insert javascript to track visitors on that page

package MT::Plugin::Stats;
use strict;

use MT::Template::Context;
use MT::ConfigMgr;
use MT::Plugin;

my $plugin = new MT::Plugin();

$plugin->name("StatWatch");
$plugin->description("Track visitor statistics from your blogs");
$plugin->doc_link("http://www.raquo.net/statwatch/");
$plugin->config_link("statwatch.cgi");

MT->add_plugin($plugin);

MT::Template::Context->add_tag('Stats' => sub{&staturl});

sub staturl {
   my $ctx = shift;
   my $blog = $ctx->stash('blog');

   my $cfg = MT::ConfigMgr->instance;
   my $script = '<script type="text/javascript">
                '.'<!-- 
                '.qq|document.write('<img src="|.$cfg->CGIPath . "plugins/statwatch/statvisit.cgi?blog_id=" . $blog->id.qq|&amp;refer=' + escape(document.referrer) + '&amp;url=' + escape(location.href) + '" width="1" height="1" alt="" /> ');
                |.'// -->'.'
                </script>';
   return $script;
}

1;
