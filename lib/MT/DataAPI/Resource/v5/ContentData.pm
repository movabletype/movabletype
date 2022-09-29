# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v5::ContentData;
use strict;
use warnings;

use MT::ContentStatus;
use MT::DataAPI::Resource;
use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [];    # Nothing. Same as v4.
}

sub fields {
    [
        {
            name   => 'author',
            schema => {
                type       => 'object',
                properties => {
                    id          => { type => 'integer' },
                    displayName => { type => 'string' },
                    userpicUrl  => { type => 'string' },
                },
            },
        },
        {
            name        => 'data',
            from_object => sub {
                my ($obj) = @_;
                my $content_type = $obj->content_type;
                my @field_ids = map { $_->{id} } @{ $content_type->fields };
                my @data;
                for my $fid (@field_ids) {
                    my $field = $content_type->get_field($fid) || {};
                    my $options = $field->{options} || {};
                    my $chunk = +{
                        id    => $fid + 0,
                        data  => $obj->data->{$fid},
                        label => $options->{label},
                        type  => $field->{type},
                    };
                    if ($field->{type} eq 'multi_line_text') {
                        my $blob_convert_breaks = MT::Serialize->unserialize($obj->convert_breaks);
                        my $convert_breaks = $$blob_convert_breaks->{$fid};
                        my $app  = MT->instance;
                        my $user = $app->user;
                        if ($user && $user->id) {
                            $chunk->{format} = $convert_breaks;
                        }
                        $chunk->{data} = _apply_text_filters($app, $user, $chunk->{data}, $convert_breaks); 
                    }
                    push @data, $chunk;
                }
                \@data;
            },
            to_object      => sub { },    # Do nothing.
            type_to_object => sub {
                my ( $hashes, $objs ) = @_;
                my $app  = MT->instance;
                my $user = $app->user;

                my %site_perms_cache;

                for my $i ( 0 .. scalar @$objs - 1 ) {
                    my $hash = $hashes->[$i];
                    my $obj  = $objs->[$i];

                    my $hash_data = $hash->{data};
                    $hash_data = [] unless ref $hash_data eq 'ARRAY';
                    my $obj_data              = $obj->data;
                    my $content_type          = $obj->content_type;
                    my $can_edit_content_data = $user->permissions(0)
                        ->can_edit_content_data( $obj, $user );
                    my $site_perms = $site_perms_cache{ $obj->blog_id }
                        ||= $user->permissions( $obj->blog_id );
                    my $field_convert_breaks;
                    if (my $blob_convert_breaks = MT::Serialize->unserialize($obj->convert_breaks)) {
                        $field_convert_breaks = $$blob_convert_breaks;
                    } else {
                        $field_convert_breaks = {};
                    }

                    for my $field ( @{ $content_type->fields } ) {
                        my $field_id = $field->{id};
                        my $options = $field->{options} || {};
                        my ($field_hash_data)
                            = grep { $_->{id} && $_->{id} == $field_id }
                            @$hash_data;
                        my $can_edit_field = $can_edit_content_data
                            || $site_perms->can_do( 'content_type:'
                                . $content_type->unique_id
                                . '-content_field:'
                                . $field->{unique_id} );
                        if (   $field_hash_data
                            && $can_edit_field )
                        {
                            if (exists $field_hash_data->{data}) {
                                $obj_data->{$field_id} = $field_hash_data->{data};
                            }
                            if (exists $field_hash_data->{format}) {
                                my $convert_breaks = $field_hash_data->{format};
                                $obj_data->{"${field_id}_convert_breaks"} = $convert_breaks;
                                $field_convert_breaks->{$field_id} = $convert_breaks;
                            }
                        }
                        elsif ( !defined $obj_data->{$field_id}
                            && defined $options->{initial_value} )
                        {
                            if ( $field->{type}
                                =~ /(?:date|time|date_and_time)/
                                and $options->{initial_value} =~ /(?:^ | $)/ )
                            {
                                # Fix broken initial values (MTC-26262)
                                $options->{initial_value} = undef;
                            }
                            $obj_data->{$field_id}
                                = $options->{initial_value};
                        }
                    }
                    $obj->data($obj_data);
                    if ($field_convert_breaks) {
                        $obj->convert_breaks(MT::Serialize->serialize(\$field_convert_breaks));
                    }
                }
            },
            schema => {
                type  => 'array',
                items => {
                    type       => 'object',
                    properties => {
                        data => {
                            'oneOf' => [
                                { type => 'string' },
                                { type => 'array', items => { type => 'string' } },
                            ],
                        },
                        id    => { type => 'integer' },
                        label => { type => 'string' },
                        type  => { type => 'string' },
                    },
                },
            },
        },
    ];
}

sub _apply_text_filters {
    my ($app, $user, $value, $convert_breaks) = @_;
    if ($user && $user->id && $app->param('no_text_filter') || $app->param('noTextFilter')) {
        return $value;
    }
    if ($convert_breaks) {
        my $ctx = MT::Template::Context->new;
        return MT->apply_text_filters( $value, [$convert_breaks], $ctx );
    }
    return $value;
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v5::ContentData - Movable Type class for resources definitions of the MT::ContentData.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
