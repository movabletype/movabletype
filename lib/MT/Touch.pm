# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Touch;

use strict;
use base qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        id => 'integer not null auto_increment',
        blog_id => 'integer',
        object_type => 'string(255)',
        modified_on => 'datetime',
    },
    indexes => {
        blog_type => {
            columns => ['blog_id', 'object_type', 'modified_on'],
        },
    },
    primary_key => 'id',
    datasource => 'touch',
});

sub latest_touch {
    my $pkg = shift;
    my ($blog_id, @types) = @_;
    my $user = grep 'author', @types;
    my $latest = $pkg->load({ object_type => \@types, blog_id => $blog_id },
        { sort => 'modified_on', direction => 'descend' });
    # Special case for 'user' type, which has no blog_id value
    if ($user) {
        my $user = $pkg->load({ object_type => 'author', blog_id => 0 });
        if ($user) {
            if (!$latest || ($user->modified_on > $latest->modified_on)) {
                $latest = $user;
            }
        }
    }
    return $latest ? $latest->modified_on : undef;
}

sub touch {
    my $pkg = shift;
    my ($blog_id, @types) = @_;
    my ($s,$m,$h,$d,$mo,$y) = gmtime(time);
    my $mod_time = sprintf("%04d%02d%02d%02d%02d%02d",
                           1900+$y, $mo+1, $d, $h, $m, $s);
    foreach my $type (@types) {
        my $rec = $pkg->get_by_key({
            blog_id => ($type eq 'author' ? 0 : $blog_id),
            object_type => $type
        });
        $rec->modified_on( $mod_time );
        $rec->save;
    }
    return $mod_time;
}

1;
