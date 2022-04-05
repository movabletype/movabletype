# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Template;

use strict;
use warnings;

use MT::PublishOption;
use MT::DataAPI::Resource;
use MT::DataAPI::Resource::Common;

our %BUILD_TYPE_TABLE = (
    'Do Not Publish' => MT::PublishOption::DISABLED(),    # 0
    'Static'         => MT::PublishOption::ONDEMAND(),    # 1
    'Manual'         => MT::PublishOption::MANUALLY(),    # 2
    'Dynamic'        => MT::PublishOption::DYNAMIC(),     # 3
    'Publish Queue'  => MT::PublishOption::ASYNC(),       # 4
);
our %REVERSE_BUILD_TYPE_TABLE = reverse %BUILD_TYPE_TABLE;

sub updatable_fields {
    [   qw(
            name
            type
            text
            outputFile
            templateType
            linkToFile
            buildType
            ),
    ];
}

sub fields {
    [   qw(
            id
            text
            ),
        {   name      => 'type',
            to_object => sub {
                my ( $hash, $obj ) = @_;
                return if $obj->id;
                return $hash->{type};
            },
        },
        {   name      => 'name',
            to_object => sub {
                my ( $hash, $obj ) = @_;
                return
                    if grep { ( $obj->type || '' ) eq $_ } qw( email backup );
                return $hash->{name};
            },
        },
        {   name        => 'outputFile',
            alias       => 'outfile',
            from_object => sub {
                my ($obj) = @_;
                return if $obj->type ne 'index';
                return $obj->outfile;
            },
            to_object => sub {
                my ( $hash, $obj ) = @_;
                return if $obj->type ne 'index';
                return $hash->{outputFile};
            },
        },
        {   name        => 'templateType',
            alias       => 'identifier',
            from_object => sub {
                my ($obj) = @_;
                return if $obj->type ne 'index';
                return $obj->identifier;
            },
            to_object => sub {
                my ( $hash, $obj ) = @_;
                return if $obj->type ne 'index';
                return $hash->{templateType};
            },
        },
        {   name                => 'linkToFile',
            alias               => 'linked_file',
            from_object_default => '',
        },
        {   name        => 'buildType',
            alias       => 'build_type',
            from_object => sub {
                my ($obj) = @_;
                return if $obj->type ne 'index';

                my $build_type
                    = exists( $REVERSE_BUILD_TYPE_TABLE{ $obj->build_type } )
                    ? $obj->build_type
                    : MT::PublishOption::ONDEMAND();
                return $REVERSE_BUILD_TYPE_TABLE{$build_type};
            },
            to_object => sub {
                my ( $hash, $obj ) = @_;
                return if $obj->type ne 'index';

                my $build_type
                    = exists( $BUILD_TYPE_TABLE{ $hash->{buildType} } )
                    ? $hash->{buildType}
                    : $REVERSE_BUILD_TYPE_TABLE{ MT::PublishOption::ONDEMAND()
                    };
                return $BUILD_TYPE_TABLE{$build_type};
            },
        },
        {   name        => 'archiveTypes',
            from_object => sub {
                my ($obj) = @_;
                my $app = MT->instance;
                my $blog_id = $obj->blog_id || 0;
                my $obj_type = $obj->type;

                if (!(  grep { $obj_type eq $_ }
                        qw/ individual page author category archive /
                    )
                    )
                {
                    return;
                }

                my @maps = $app->model('templatemap')->load(
                    {   blog_id     => $blog_id,
                        template_id => $obj->id,
                    }
                );

                return MT::DataAPI::Resource->from_object( \@maps );
            },
            schema => {
                type  => 'array',
                items => { '$ref' => '#/components/schemas/templatemap' },
            },
        },
        {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;
                my $app  = MT->instance or return;
                my $user = $app->user   or return;

                if ( $user->is_superuser ) {
                    $_->{updatable} = 1 for @$hashes;
                    return;
                }

                my %blog_perms;

                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my $obj = $objs->[$i];

                    my $perms;
                    $perms = $blog_perms{ $obj->blog_id }
                        ||= $user->blog_perm( $obj->blog_id );

                    $hashes->[$i]{updatable} = $perms->can_edit_templates;
                }
            },
        },
        $MT::DataAPI::Resource::Common::fields{blog},
        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedBy},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},

        # WidgetSet's fields.
        {   name        => 'widgets',
            from_object => sub {
                my ($obj) = @_;

                if ( !$obj->type || $obj->type ne 'widgetset' ) {
                    return;
                }

                my @widgets;
                if ( my $modulesets = $obj->modulesets ) {
                    my @widget_ids = split ',', $modulesets;
                    @widgets = MT->model('template')
                        ->load( { id => \@widget_ids, } );
                }

                return MT::DataAPI::Resource->from_object( \@widgets,
                    [qw/ id name /] );
            },
            schema => {
                type  => 'array',
                items => {
                    type       => 'object',
                    properties => {
                        id   => { type => 'integer' },
                        name => { type => 'string' },
                    },
                },
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Template - Movable Type class for resources definitions of the MT::Template.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
