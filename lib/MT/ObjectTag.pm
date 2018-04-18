# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectTag;

use strict;
use warnings;

use MT::Blog;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'                => 'integer not null auto_increment',
            'blog_id'           => 'integer',
            'object_id'         => 'integer not null',
            'object_datasource' => 'string(50) not null',
            'tag_id'            => 'integer not null',
            'cf_id'             => 'integer not null',
        },
        indexes => {
            object_id         => 1,
            tag_id            => 1,
            object_datasource => 1,

            # For MTTags
            blog_ds_tag =>
                { columns => [ 'blog_id', 'object_datasource', 'tag_id' ], },

            # For tag count
            blog_ds_obj_tag => {
                columns =>
                    [ 'blog_id', 'object_datasource', 'object_id', 'tag_id' ],
            },
        },
        child_of    => 'MT::Blog',
        datasource  => 'objecttag',
        primary_key => 'id',
        cacheable   => 0,
        defaults    => { cf_id => 0, },
    }
);

sub class_label {
    MT->translate("Tag Placement");
}

sub class_label_plural {
    MT->translate("Tag Placements");
}

sub remove {
    my $self = shift;
    if ( ref $self && $self->id && $self->cf_id ) {
        MT->model('content_field_index')->remove(
            {   content_field_id => $self->cf_id,
                content_data_id  => $self->object_id,
            }
            );
        my $content_data
            = MT->model('content_data')->load( $self->object_id );
        if ($content_data) {
            my $data           = $content_data->data;
            my $field_data     = $data->{ $self->cf_id } || [];
            my $new_field_data = [ grep { $_ != $self->tag_id } @$field_data ];
            $data->{ $self->cf_id } = $new_field_data;
            $content_data->data($data);
            $content_data->save;
        }
    }
    $self->SUPER::remove(@_);
}

1;
__END__

=head1 NAME

MT::ObjectTag

=head1 METHODS

=head2 MT::ObjectTag->class_label

Returns the localized descriptive name for this class.

=head2 MT::ObjectTag->class_label_plural

Returns the localized, plural descriptive name for this class.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
