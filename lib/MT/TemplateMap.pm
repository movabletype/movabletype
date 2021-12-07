# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::TemplateMap;

use strict;
use warnings;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'             => 'integer not null auto_increment',
            'blog_id'        => 'integer not null',
            'template_id'    => 'integer not null',
            'archive_type'   => 'string(100) not null',
            'file_template'  => 'string(255)',
            'is_preferred'   => 'boolean',
            'build_type'     => 'smallint',
            'build_interval' => 'integer',
            'cat_field_id'   => 'integer',
            'dt_field_id'    => 'integer',
        },
        indexes => {
            blog_id      => 1,
            template_id  => 1,
            archive_type => 1,
            is_preferred => 1,
        },
        defaults      => { 'build_type' => 1, },
        child_classes => ['MT::FileInfo'],
        datasource    => 'templatemap',
        primary_key   => 'id',
        cacheable     => 0,
    }
);

sub class_label {
    return MT->translate("Archive Mapping");
}

sub class_label_plural {
    return MT->translate("Archive Mappings");
}

sub save {
    my $map = shift;
    my $res = $map->SUPER::save();
    return $res unless $res;

    my $at   = $map->archive_type;
    my $blog = MT->model('blog')->load( $map->blog_id )
        or return;
    my $blog_at = $blog->archive_type || '';
    my @ats;
    @ats = map {$_}
        grep { $map->archive_type ne $_ }
        split /,/, $blog_at
        if $blog_at ne 'None';
    push @ats, $map->archive_type;
    my $new_at = join ',', sort @ats;

    if ( $new_at ne $blog_at ) {
        $blog->archive_type($new_at);
        $blog->save;
    }
    return 1;
}

sub remove {
    my $map = shift;
    $map->remove_children( { key => 'templatemap_id' } );
    my $result = $map->SUPER::remove(@_);

    if ( ref $map ) {
        my $terms = {
            blog_id      => $map->blog_id,
            archive_type => $map->archive_type,
            id           => [ $map->id ],
        };
        my $args = {
            limit => 1,
            not   => { id => 1 }
        };
        my $remaining = MT::TemplateMap->load( $terms, $args );
        if ($remaining) {
            if ( $map->_is_for_content_type ) {
                $args->{join} = _generate_join_on_template($map);
                $remaining = MT::TemplateMap->load( $terms, $args );
            }
            $terms->{is_preferred} = 1;
            my $preferred = MT::TemplateMap->load( $terms, $args );
            if ( $remaining && !$preferred ) {
                $remaining->is_preferred(1);
                $remaining->save;
            }
        }
        else {
            my $blog = MT->model('blog')->load( $map->blog_id )
                or return;
            my $at = $blog->archive_type;
            if ( $at && $at ne 'None' ) {
                my @newat
                    = map {$_} grep { $map->archive_type ne $_ } split /,/,
                    $at;
                $blog->archive_type( join ',', @newat );
                $blog->save;
            }
        }
    }
    else {
        my $blog_id;
        if ( $_[0] && $_[0]->{template_id} ) {
            my $tmpl_id;
            if ( ref $_[0]->{template_id} eq 'ARRAY' ) {
                $tmpl_id = $_[0]->{template_id}->[0];
            }
            else {
                $tmpl_id = $_[0]->{template_id};
            }
            my $tmpl = MT::Template->load($tmpl_id);
            if ($tmpl) {
                return $result
                    unless
                    $tmpl->blog_id;    # global template does not have maps
                $blog_id = $tmpl->blog_id;
            }
        }
        elsif ( $_[0] && $_[0]->{blog_id} ) {

            # for cases where we remove with a blog_id parameter
            $blog_id = $_[0]->{blog_id};
        }

        my $maps_iter
            = MT::TemplateMap->count_group_by(
            { ( defined $blog_id ? ( blog_id => $blog_id ) : () ) },
            { group => [ 'blog_id', 'archive_type' ] } );
        my %ats;
        while ( my ( $count, $blog_id, $at ) = $maps_iter->() ) {
            my $ats = $ats{$blog_id};
            push @$ats, $at if $count > 0;
            $ats{$blog_id} = $ats;
        }
        my $iter;
        if ($blog_id) {
            my $blog = MT::Blog->load($blog_id);
            $iter = sub { my $ret = $blog; $blog = undef; $ret; }
        }
        else {
            $iter = MT::Blog->load_iter();
        }
        while ( my $blog = $iter->() ) {
            $blog->archive_type( $ats{ $blog->id }
                ? join ',',
                @{ $ats{ $blog->id } }
                : '' );
            $blog->save;
            for my $at ( @{ $ats{ $blog->id } } ) {
                my $ct_iter
                    = MT->model('content_type')
                    ->load_iter( { blog_id => $blog->id } );
                while ( my $content_type = $ct_iter->() ) {
                    unless (
                        __PACKAGE__->exist(
                            {   blog_id      => $blog->id,
                                archive_type => $at,
                                is_preferred => 1
                            },
                            {   join => MT::Template->join_on(
                                    undef,
                                    {   id => \'= templatemap_template_id',
                                        content_type_id => $content_type->id,
                                    },
                                )
                            }
                        )
                        )
                    {
                        my $remaining = __PACKAGE__->load(
                            {   blog_id      => $blog->id,
                                archive_type => $at,
                            },
                            {   limit => 1,
                                join  => MT::Template->join_on(
                                    undef,
                                    {   id => \'= templatemap_template_id',
                                        content_type_id => $content_type->id,
                                    },
                                )
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
    }
    $result;
}

sub prefer {
    my $map = shift;
    my ($prefer) = @_;
    $prefer = ( defined($prefer) && $prefer ) ? 1 : 0;

    if ($prefer) {
        return 1 if $map->is_preferred;
        my $args
            = $map->_is_for_content_type
            ? { join => _generate_join_on_template($map) }
            : {};
        my $preferred = MT::TemplateMap->load(
            {   blog_id      => $map->blog_id,
                archive_type => $map->archive_type,
                is_preferred => 1,
            },
            $args
        ) or return;
        $preferred->is_preferred(0);
        $preferred->save or return $map->error( $preferred->errstr );
        $map->is_preferred(1);
        $map->save or return $map->error( $map->errstr );
    }
    else {
        return 1 unless $map->is_preferred;
        if ( $map->_prefer_next_map ) {
            $map->is_preferred(0);
            $map->save or return $map->error( $map->errstr );
        }
    }
}

sub _prefer_next_map {
    my $map = shift;
    my $args
        = $map->_is_for_content_type
        ? { join => _generate_join_on_template($map) }
        : {};
    my @all = MT::TemplateMap->load(
        {   blog_id      => $map->blog_id,
            archive_type => $map->archive_type
        },
        $args
    );
    @all = grep { $_->id != $map->id } @all;
    if (@all) {
        $all[0]->is_preferred(1);
        $all[0]->save;
        return 1;
    }
    return 0;
}

sub _generate_join_on_template {
    my $map = shift;
    my $template
        = MT->model('template')
        ->load( { id => $map->template_id, blog_id => $map->blog_id } );
    return MT->model('template')->join_on(
        undef,
        {   id              => \'= templatemap_template_id',
            content_type_id => $template->content_type_id,
        },
    );
}

sub list_props {
    return +{
        id           => { base => '__virtual.id' },
        archive_type => {
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                return +{ archive_type => $args->{value} };
            },
            display => 'none',
        },
        build_type => {
            base                  => '__virtual.single_select',
            display               => 'none',
            single_select_options => sub {
                require MT::DataAPI::Resource::v2::Template;
                my $table
                    = \%MT::DataAPI::Resource::v2::Template::BUILD_TYPE_TABLE;
                my @options = map { +{ text => $_, value => $table->{$_} } }
                    keys %$table;
                return \@options;
            }
                ->(),
        },
        is_preferred => {
            base                  => '__virtual.single_select',
            display               => 'none',
            single_select_options => [
                { value => 0, text => 'False' },
                { value => 1, text => 'True' },
            ],
        },
    };
}

sub dt_field {
    my $self = shift;
    $self->cache_property(
        'dt_field',
        sub {
            return unless $self->_is_for_content_type;
            return unless $self->dt_field_id;
            MT->model('content_field')->load( $self->dt_field_id );
        },
    );
}

sub cat_field {
    my $self = shift;
    $self->cache_property(
        'cat_field',
        sub {
            return unless $self->_is_for_content_type;
            return unless $self->cat_field_id;
            MT->model('content_field')->load( $self->cat_field_id );
        },
    );
}

sub _is_for_content_type {
    my $self = shift;
    $self->archive_type =~ /^ContentType/;
}

sub template {
    my $self = shift;
    $self->cache_property(
        'tempalte',
        sub {
            MT->model('template')->load( $self->template_id || 0 );
        },
    );
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

=item * cat_field_id

MT::ContentField ID related to this mapping's category field.
This is used when this mapping is for Content Type.

=item * dt_field_id

MT::ContentField ID related to this mapping's date & time field.
This is used when this mapping is for Content Type.

=back

=head1 METHODS

=over 4

=item * MT::TemplateMap->class_label()

Returns the localized descriptive name for this class.

=item * MT::TemplateMap->class_label_plural()

Returns the localized, plural descriptive name for this class.

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

=item * dt_field()

Returns MT::ContentField related to this mapping's date & time field.
Returns nothing when dt_field_id is invalid or this mapping is not for Content Type.

=item * cat_field()

Returns MT::ContentField related to this mapping's category field.
Returns nothing when cat_field_id is invalid or this mapping is not for Content Type.

=item * template()

Returns parent MT::Template of this mapping.

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
