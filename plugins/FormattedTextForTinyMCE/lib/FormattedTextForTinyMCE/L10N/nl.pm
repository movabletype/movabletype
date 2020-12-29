# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedTextForTinyMCE::L10N::nl;

use strict;
use warnings;

use base 'FormattedTextForTinyMCE::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'De "Standaardtekst invoegen" knop toevoegen aan TinyMCE.', # Translate - New

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Kan standaardtekst niet laden.', # Translate - New

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Selecteer een standaardtekst.', # Translate - New
	
## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Standaardtekst invoegen', # Translate - New

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Boilerplate' => 'Standaardtekst', # Translate - New
	'Select Boilerplate' => 'Standaardtekst selecteren', # Translate - New

);

1;
