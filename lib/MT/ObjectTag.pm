package MT::ObjectTag;

use strict;

use MT::Blog;
use MT::Object;
@MT::ObjectTag::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer',
        'object_id' => 'integer not null',
        'object_datasource' => 'string(50) not null',
        'tag_id' => 'integer not null',
    },
    indexes => {
        blog_id => 1,
        object_id => 1,
        tag_id => 1,
        object_datasource => 1,
    },
    child_of => 'MT::Blog',
    datasource => 'objecttag',
    primary_key => 'id',
});

1;
