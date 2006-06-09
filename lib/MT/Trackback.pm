# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Trackback;
use strict;

use MT::Object;
@MT::Trackback::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer not null',
        'title' => 'string(255)',
        'description' => 'text',
        'rss_file' => 'string(255)',
        'url' => 'string(255)',
        'entry_id' => 'integer not null',
        'category_id' => 'integer not null',
        'is_disabled' => 'boolean',
        'passphrase' => 'string(30)',
    },
    indexes => {
        blog_id => 1,
        entry_id => 1,
        category_id => 1,
        created_on => 1,
    },
    defaults => {
        'entry_id' => 0,
        'category_id' => 0,
        'is_disabled' => 0,
    },
    audit => 1,
    datasource => 'trackback',
    primary_key => 'id',
});

sub remove {
    my $tb = shift;
    require MT::TBPing;
    my @pings = MT::TBPing->load({ tb_id => $tb->id });
    for my $ping (@pings) {
        $ping->remove;
    }
    $tb->SUPER::remove;
}

1;
