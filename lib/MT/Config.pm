# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Config;
use strict;
use warnings;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'   => 'integer not null auto_increment',
            'data' => 'text',
        },
        primary_key => 'id',
        datasource  => 'config',
    }
);

sub class_label {
    MT->translate("Configuration");
}

sub class_label_plural {
    MT->translate("Configuration");
}

1;
__END__

=head1 NAME

MT::Config - Installation-wide configuration data.

=head1 METHODS

=head2 MT::Config->class_label

Returns the localized descriptive name for this class.

=head2 MT::Config->class_label_plural

Returns the localized, plural descriptive name for this class.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
