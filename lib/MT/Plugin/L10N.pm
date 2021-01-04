# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Plugin::L10N;

use strict;
use warnings;
use base 'MT::L10N';
use vars qw( %Lexicon );

sub init {
    my $lh = shift;
    $lh->SUPER::init(@_);
    $lh->fail_with('mt_fallback');
    return;
}

sub mt_fallback {
    my $lh = shift;
    MT->language_handle->maketext(@_);
}

sub get_handle {
    my $this = shift;
    my ($lang) = @_;
    my $lh;

    # Look up plugin's handle first.
    # If not available, use system's handle.
    eval {
               $lh = $this->SUPER::get_handle($lang)
            || $this->SUPER::get_handle('en_us');
    };
    if ( !$@ && $lh ) {
        return $lh;
    }
    return MT->language_handle;
}

%Lexicon = ();

1;
__END__

=head1 NAME

MT::Plugin::L10N

=head1 METHODS

=head2 init

Initialize with L<MT::L10N/init>.

=head2 mt_fallback(@args)

Call the C<MT-E<gt>language_handle> I<maketext> method.

=head2 get_handle([$lang])

Fetch and return the plugin's I<language_handle> and default to the
C<MT-E<gt>language_handle> if unknown.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
