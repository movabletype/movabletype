# StatWatch - lib/StatWatchConfig.pm
# Nick O'Neill (http://www.raquo.net/statwatch/)

package StatWatchConfig;
use strict;

use MT::Object;
@StatWatchConfig::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
   columns => [
      'id', 'blog_id', 'last_compile',
      'average_hits', 'average_hits_count',
      'average_uniques', 'average_uniques_count',
      'average_hour', 'average_hour_count',
      'average_feed', 'average_feed_count',
      'feed_url',
   ],
   indexes => {
   blog_id => 1,
	created_on => 1,
   },
      audit => 1,
      datasource => 'statwatchconfig',
      primary_key => 'id',
});

1;
