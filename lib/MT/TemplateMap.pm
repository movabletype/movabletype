# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
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

sub class_label {
    return MT->translate("Archive Mapping");
}

sub class_label_plural {
    return MT->translate("Archive Mappings");
}

sub save {
    my $map = shift;
    $map->SUPER::save();
    my $at   = $map->archive_type;
    my $blog = MT->model('blog')->load($map->blog_id);
    my $blog_at   = $blog->archive_type;
    my @ats = map { $_ } 
        grep { $map->archive_type ne $_ }
            split /,/, $blog_at
                if $blog_at ne 'None';
    push @ats, $map->archive_type;
    $blog->archive_type(join ',', @ats);
    $blog->save;
}

sub remove {
    my $map = shift;
    $map->remove_children({ key => 'templatemap_id' });
    my $result = $map->SUPER::remove(@_);
    
    if (ref $map) {
        my $remaining = MT::TemplateMap->load(
          {
            blog_id => $map->blog_id,
            archive_type => $map->archive_type,
            id => [ $map->id ],
          },
          {
            limit => 1,
            not => { id => 1 }
          }
        );
        if ($remaining) {
            $remaining->is_preferred(1);
            $remaining->save;
        }
        else {
            my $blog = MT->model('blog')->load($map->blog_id);
            my $at   = $blog->archive_type;
            if ( $at && $at ne 'None' ) {
                my @newat = map { $_ } grep { $map->archive_type ne $_ } split /,/, $at;
                $blog->archive_type(join ',', @newat);
                $blog->save;
            }
        }
    }
    else {
        my $maps_iter = MT::TemplateMap->count_group_by(
            undef,
            { group => [ 'blog_id', 'archive_type' ] }
        );
        my %ats;
        while ( my ( $count, $blog_id, $at ) = $maps_iter->() ) {
            my $ats = $ats{$blog_id};
            push @$ats, $at if $count > 0;
            $ats{$blog_id} = $ats;
        }
        foreach my $blog_id (keys %ats) {
            my $blog = MT->model('blog')->load($blog_id);
            next unless $blog;
            $blog->archive_type(join ',', @{ $ats{$blog_id} });
            $blog->save;
            for my $at (@{ $ats{$blog_id} }) {
                unless ( __PACKAGE__->count({
                    blog_id => $blog_id, archive_type => $at, is_preferred => 1 
                }) ) {
                    my $remaining = __PACKAGE__->load(
                      {
                        blog_id => $blog_id,
                        archive_type => $at,
                      },
                      {
                        limit => 1,
                      }
                    );
                    if ($remaining) {
                        $remaining->is_preferred(1);
                        $remaining->save;
                    }
                }
            }
        }
    }
    $result;
}

sub prefer {
    my $map = shift;
    my ($prefer) = @_;
    $prefer = (defined($prefer) && $prefer) ? 1 : 0;

    if ($prefer) {
        return 1 if $map->is_preferred;
        my $preferred = MT::TemplateMap->load({
                blog_id => $map->blog_id,
                archive_type => $map->archive_type,
                is_preferred => 1,
            });
        $preferred->is_preferred(0);
        $preferred->save or return $map->error($preferred->errstr);
        $map->is_preferred(1);
        $map->save or return $map->error($map->errstr);
    } else {
        return 1 unless $map->is_preferred;
        if ($map->_prefer_next_map) {
            $map->is_preferred(0);
            $map->save or return $map->error($map->errstr);
        }
    }
}

sub _prefer_next_map {
    my $map = shift;
    my @all = MT::TemplateMap->load({ blog_id => $map->blog_id,
                                      archive_type => $map->archive_type });
    @all = grep { $_->id != $map->id } @all;
    if (@all) {
        $all[0]->is_preferred(1);
        $all[0]->save;
        return 1;
    }
    return 0;
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

=head1 METHODS

=over 4

=item * save()

Saves the object.  It also rearranges blog's archive type.  If the saved
template map is new and there is no other template maps with the same 
archive type has been, the archive type is also added to the blog.

=item * remove()

Removes template maps specified in terms and args (if called as class method)
or the template map (if called as instance method).  It also rearrange blog's
archive types which are used to determine what types of archive will be 
published during rebuild.  If template map is removed and there remains no
template map with the archive type, the archive type is removed from blog's
archive types to be rebuilt.

=item * prefer(boolean)

Set the template map preferred or not, depending on the argument.  If the map
has been preferred and is being unpreferred, and if there are any other 
I<MT::TemplateMap> objects defined for this particular archive type and blog, 
the first of the other objects will be set as the preferred object. 
Its I<is_preferred> flag will be set to true.  If the map is the only 
I<MT::TemplateMap> object for the blog and the archive type, the method does
nothing - the map continues to be preferred.

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

=item * $obj->remove()

When you remove a I<MT::TemplateMap> object using I<MT::TemplateMap::remove>,
if the I<$map> object you are removing has the I<is_preferred> flag set to
true, and if there are any other I<MT::TemplateMap> objects defined for this
particular archive type and blog, the first of the other objects will be
set as the preferred object. Its I<is_preferred> flag will be set to true.

=back

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
