# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Plugin::L10N;

use strict;
use base 'MT::L10N';
use vars qw( %Lexicon );

sub maketext {
    my $lh = shift;
    my $str;
    eval { $str = $lh->SUPER::maketext(@_); };
    if ($@) {
        my $mt_lh = MT->language_handle;
        $str = $mt_lh->maketext(@_);
    }
    $str;
}

sub get_handle {
    my $this = shift;
    my ($lang) = @_;
    my $lh;

    # Look up plugin's handle first.  
    # If not available, use system's handle.
    eval { $lh = $this->SUPER::get_handle($lang) ||
        $this->SUPER::get_handle('en_us'); };
    if (!$@ && $lh) {
        return $lh;
    }
    return MT->language_handle;
}

%Lexicon = ();

1;
