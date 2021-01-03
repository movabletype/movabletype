# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Touch;

use strict;
use warnings;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            id          => 'integer not null auto_increment',
            blog_id     => 'integer',
            object_type => 'string(255)',
            modified_on => 'datetime',
        },
        indexes => {
            blog_type =>
                { columns => [ 'blog_id', 'object_type', 'modified_on' ], },
        },
        primary_key => 'id',
        datasource  => 'touch',
        cacheable   => 0,
    }
);

sub latest_touch {
    my $pkg = shift;
    my ( $blog_id, @types ) = @_;
    my $user = grep { $_ eq 'author' } @types;
    my $latest = $pkg->load(
        { object_type => \@types,       blog_id   => $blog_id },
        { sort        => 'modified_on', direction => 'descend' }
    );

    # Special case for 'user' type, which has no blog_id value
    if ($user) {
        my $user = $pkg->load( { object_type => 'author', blog_id => 0 } );
        if ($user) {
            if ( !$latest || ( $user->modified_on > $latest->modified_on ) ) {
                $latest = $user;
            }
        }
    }
    return $latest ? $latest->modified_on : undef;
}

sub touch {
    my $pkg = shift;
    my ( $blog_id, @types ) = @_;
    my ( $s, $m, $h, $d, $mo, $y ) = gmtime(time);
    my $mod_time = sprintf( "%04d%02d%02d%02d%02d%02d",
        1900 + $y, $mo + 1, $d, $h, $m, $s );
    foreach my $type (@types) {
        my $rec = $pkg->get_by_key(
            {   blog_id => ( $type eq 'author' ? 0 : $blog_id ),
                object_type => $type
            }
        );
        $rec->modified_on($mod_time);
        $rec->save;
    }
    return $mod_time;
}

1;
__END__

=head1 NAME

MT::Touch - Object class for recording object type modification times

=head1 SYNOPSIS

    # record that an entry object was modified for blog # $blog_id
    use MT::Touch;
    MT::Touch->touch( $blog_id, 'entry');

    my $ts = MT::Touch->latest_touch($blog_id, 'entry');

=head1 DESCRIPTION

This module is used to store and retrieve the last modification timestamp
for any registered object type. This is primarily utilized by the
module caching layer of Movable Type, where caches can expire based on
changes to entries, pages, categories, etc. Timestamps stored to the
'modified_on' column are in UTC time.

=head1 METHODS

=head2 MT::Touch->touch( $blog_id, @types )

Records a MT::Touch object for each type given, for the blog ID specified.
For non-blog objects, feel free to pass a '0' for blog_id.

=head2 MT::Touch->latest_touch( $blog_id, @types )

Returns the ltest timestamp recorded for any of the object types requested
for the blog ID specified. The timestamp is returned (YYYYMMDDHHMISS format),
in UTC time. If no touches exist, C<undef> is the return value.

=cut
