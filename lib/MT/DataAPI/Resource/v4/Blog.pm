# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v4::Blog;

use strict;
use warnings;

use base qw(MT::DataAPI::Resource::v3::Blog);

sub fields {
    my $self   = shift;
    my $fields = $self->SUPER::fields;
    push @$fields, +{
        name        => 'maxRevisionsContentData',
        alias       => 'max_revisions_cd',
        type        => 'MT::DataAPI::Resource::DataType::Integer',
        from_object => sub { $_[0]->max_revisions_cd },
        condition   => \&MT::DataAPI::Resource::v3::Blog::can_view,
    };
    return $fields;
}

sub updatable_fields {
    my $self   = shift;
    my $fields = $self->SUPER::updatable_fields;
    push @$fields, 'maxRevisionsContentData';
    return $fields;
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v4::Blog - Movable Type class for resources definitions of the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
