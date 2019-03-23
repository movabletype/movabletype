# Movable Type (r) (C) 2001-2019 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v4::Template;

use strict;
use warnings;
use base 'MT::DataAPI::Resource::v2::Template';

sub updatable_fields {
    my $self   = shift;
    my $fields = $self->SUPER::updatable_fields;
    push @$fields, 'contentTypeID';
    $fields;
}

sub fields {
    my $self   = shift;
    my $fields = $self->SUPER::fields;
    for my $field (@$fields) {
        if ( ref $field eq 'HASH' and $field->{name} eq 'archiveTypes' ) {
            $field->{from_object} = sub {
                my ($obj) = @_;
                my $app = MT->instance;
                my $blog_id  = $obj->blog_id || 0;
                my $obj_type = $obj->type;

                return
                    unless grep { $obj_type eq $_ }
                    qw/ individual page author category archive ct ct_archive /;

                my @maps = $app->model('templatemap')->load(
                    {   blog_id     => $blog_id,
                        template_id => $obj->id,
                    }
                );

                return MT::DataAPI::Resource->from_object( \@maps );
            };
        }
    }
    push @$fields,
        {
        name  => 'contentTypeID',
        alias => 'content_type_id',
        };
    $fields;
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v4::Template - Movable Type class for resources definitions of the MT::Template.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
