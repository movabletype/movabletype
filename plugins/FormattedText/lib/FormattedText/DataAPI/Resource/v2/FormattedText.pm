# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedText::DataAPI::Resource::v2::FormattedText;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

use FormattedText::App;

sub updatable_fields {
    [   qw(
            label
            text
            description
            ),
    ];
}

sub fields {
    [   qw(
            id
            label
            text
            description
            ),
        {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashs ) = @_;
                my $app = MT->instance;
                my $user = $app->user or return;

                if ( $user->is_superuser ) {
                    $_->{updatable} = 1 for @$hashs;
                    return;
                }

                my %blog_perms;

                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my $obj = $objs->[$i];

                    my $perms;
                    $perms = $blog_perms{ $obj->blog_id }
                        ||= $user->permissions( $obj->blog_id );

                    $hashs->[$i]{updatable}
                        = FormattedText::App::can_edit_formatted_text( $perms,
                        $obj, $user );
                }
            },
        },
        $MT::DataAPI::Resource::Common::fields{blog},
        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{modifiedBy},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
    ];
}

1;

__END__

=head1 NAME

FormattedText::DataAPI::Resource::v2::FormattedText - Movable Type class for resources definitions
of the FormattedText::FormattedText.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
