# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::TemplateMap::v2;

use strict;
use warnings;

use MT::PublishOption;
use MT::DataAPI::Resource::Template::v2;

sub updatable_fields {
    [   qw(
            archiveType
            fileTemplate
            isPreferred
            buildType
            ),
    ];
}

sub fields {
    [   qw(
            id
            archiveType
            fileTemplate
            ),
        {   name  => 'isPreferred',
            alias => 'is_preferred',
            type  => 'MT::DataAPI::Resource::DataType::Boolean',
        },
        {   name        => 'buildType',
            alias       => 'build_type',
            from_object => sub {
                my ($obj) = @_;
                my $build_type
                    = (
                    exists
                        $MT::DataAPI::Resource::Template::v2::REVERSE_BUILD_TYPE_TABLE{
                        $obj->build_type
                        } )
                    ? $obj->build_type
                    : MT::PublishOption::ONDEMAND();
                return
                    $MT::DataAPI::Resource::Template::v2::REVERSE_BUILD_TYPE_TABLE{
                    $build_type};
            },
            to_object => sub {
                my ($hash) = @_;
                my $build_type
                    = (
                    exists
                        $MT::DataAPI::Resource::Template::v2::BUILD_TYPE_TABLE{
                        $hash->{buildType}
                        } )
                    ? $hash->{buildType}
                    : $MT::DataAPI::Resource::Template::v2::REVERSE_BUILD_TYPE_TABLE{
                    MT::PublishOption::ONDEMAND()
                    };
                return
                    $MT::DataAPI::Resource::Template::v2::BUILD_TYPE_TABLE{
                    $build_type};
            },
        },
        {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;
                my $app = MT->instance;
                return if !$app->can_do('edit_templates');
                $_->{updatable} = 1 for @$hashes;
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::TemplateMap::v2 - Movable Type class for resources definitions of the MT::TemplateMap.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
