# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::TemplateMap;
use strict;

use MT::Object;
@MT::TemplateMap::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer not null',
        'template_id' => 'integer not null',
        'archive_type' => 'string(25) not null',
        'file_template' => 'string(255)',
        'is_preferred' => 'boolean',
    },
    indexes => {
        blog_id => 1,
        template_id => 1,
        archive_type => 1,
        is_preferred => 1,
    },
    child_classes => ['MT::FileInfo'],
    datasource => 'templatemap',
    primary_key => 'id',
});

sub remove {
    my $map = shift;
    if ($map->is_preferred) {
        my @all = MT::TemplateMap->load({ blog_id => $map->blog_id,
                                          archive_type => $map->archive_type });
        @all = grep { $_->id != $map->id } @all;
        if (@all) {
            $all[0]->is_preferred(1);
            $all[0]->save;
        }
    }

    $map->remove_children({ key => 'templatemap_id' });
    $map->SUPER::remove;
}

1;
__END__

=head1 NAME

MT::TemplateMap - Movable Type archive-template association record

=head1 SYNOPSIS

    use MT::TemplateMap;
    my $map = MT::TemplateMap->new;
    $map->blog_id($tmpl->blog_id);
    $map->template_id($tmpl->id);
    $map->archive_type('Monthly');
    $map->file_template('<$MTArchiveDate format="%Y/%m/index.html"$>');
    $map->is_preferred(1);
    $map->save
        or die $map->errstr;

=head1 DESCRIPTION

An I<MT::TemplateMap> object represents a single association between an
Archive Template and an archive type for a particular blog. For example, if
you set up a template called C<Date-Based> and assign to the C<Monthly>
archive type in your blog, such an association will be represented by one
I<MT::TemplateMap> object.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::TemplateMap> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 DATA ACCESS METHODS

The I<MT::TemplateMap> object holds the following pieces of data. These
fields can be accessed and set using the standard data access methods
described in the I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the template map record.

=item * blog_id

The numeric ID of the blog with which this template map record is associated.

=item * template_id

The numeric ID of the template.

=item * archive_type

The archive type; should be one of the following values: C<Individual>,
C<Daily>, C<Weekly>, C<Monthly>, or C<Category>.

=item * file_template

The Archive File Template for this particular mapping; this defines the output
files for the pages generated from the template for this archive type,
using standard MT template tags.

=item * is_preferred

A boolean flag specifying whether this particular template is preferred over
any others defined for this archive type. This is used when generating links
to archives of this archive type--the link will always link to the preferred
archive type.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * blog_id

=item * template_id

=item * archive_type

=item * is_preferred

=back

=head1 NOTES

=over 4

=item *

When you remove a I<MT::TemplateMap> object using I<MT::TemplateMap::remove>,
if the I<$map> object you are removing has the I<is_preferred> flag set to
true, and if there are any other I<MT::TemplateMap> objects defined for this
particular archive type and blog, the first of the other objects will be
set as the preferred object. Its I<is_preferred> flag will be set to true.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
