# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Placement;

use strict;
use warnings;

use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'          => 'integer not null auto_increment',
            'blog_id'     => 'integer not null',
            'entry_id'    => 'integer not null',
            'category_id' => 'integer not null',
            'is_primary'  => 'boolean not null',
        },
        indexes => {
            blog_id     => 1,
            entry_id    => 1,
            category_id => 1,
            is_primary  => 1,
            blog_cat    => { columns => [ 'blog_id', 'category_id' ], },
        },
        datasource  => 'placement',
        primary_key => 'id',
        cacheable   => 0,
    }
);

sub class_label {
    MT->translate("Category Placement");
}

1;
__END__

=head1 NAME

MT::Placement - Movable Type entry-category placement record

=head1 SYNOPSIS

    use MT::Placement;
    my $place = MT::Placement->new;
    $place->entry_id($entry->id);
    $place->blog_id($entry->blog_id);
    $place->category_id($cat->id);
    $place->is_primary(1);
    $place->save
        or die $place->errstr;

=head1 DESCRIPTION

An I<MT::Placement> object represents a single entry-category assignment; in
other words, I<MT::Placement> objects describe the assignment of entries into
categories. Each entry is assigned to one primary category and any number of
secondary categories; an I<MT::Placement> object exists for each such
assignment. An entry's assignment to its primary category is marked as a
primary placement.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Placement> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 DATA ACCESS METHODS

The I<MT::Placement> object holds the following pieces of data. These fields
can be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the placement.

=item * entry_id

The numeric ID of the entry.

=item * category_id

The numeric ID of the category.

=item * is_primary

A boolean flag specifying whether the placement is a "primary" placement, and
hence whether it represents the entry's primary category.

=back

=head1 METHODS

=head2 MT::Placement->class_label

Returns the localized descriptive name for this class.

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * entry_id

=item * category_id

=item * is_primary

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
