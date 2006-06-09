# StatWatch - lib/Stats.pm
# Nick O'Neill (http://www.raquo.net/statwatch/)

package Stats;
use strict;

use MT::Object;
@Stats::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    columns => [
        'id', 'blog_id', 'url', 'referrer', 'ip',
    ],
    indexes => {
	ip => 1,
	blog_id => 1,
	created_on => 1,
    },
    audit => 1,
    datasource => 'stats',
    primary_key => 'id',
});

1;
