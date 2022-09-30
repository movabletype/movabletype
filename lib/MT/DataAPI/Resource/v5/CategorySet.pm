# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v5::CategorySet;
use strict;
use warnings;

use MT::DataAPI::Resource;
use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [];    # Nothing. Same as v4.
}

sub fields {
    [
        {
            name => 'categories',
            schema => {
                type  => 'array',
                items => {
                    type       => 'object',
                    properties => {
                        id       => { type => 'integer' },
                        parent   => { type => 'integer' },
                        label    => { type => 'string' },
                        basename => { type => 'string' },
                    },
                },
            },
        },
        {
            name      => 'contentTypeCount',
            alias     => 'content_type_count',
            bulk_from_object => sub {
                my ($objs, $hashes, $field) = @_;
                my $app      = MT->instance;
                my $ct_count = MT->model('category_set')->ct_count_by_blog($app->blog->id);
                for my $i (0 .. (@$objs - 1)) {
                    my $obj = $objs->[$i];
                    $hashes->[$i]{ $field->{name} } = $ct_count->{ $obj->id } || 0;
                }
            },
            condition => sub {
                my $app  = MT->instance or return;
                my $user = $app->user   or return;
                $user->id ? 1 : 0;
            },
        },
    ];
}

1;
__END__

=head1 NAME

MT::DataAPI::Resource::v5::CategorySet - Movable Type class for resources definitions of the MT::CategorySet.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
