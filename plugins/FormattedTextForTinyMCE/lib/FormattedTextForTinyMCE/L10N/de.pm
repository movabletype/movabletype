package FormattedTextForTinyMCE::L10N::de;

use strict;
use warnings;

use base 'FormattedTextForTinyMCE::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Formatierten Text einfügen', # Translate - New # OK

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Boilerplate' => 'Formatierter Text', # Translate - New # OK
	'Select Boilerplate' => 'Formatierten Text auswählen', # Translate - New # OK	
	
## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => '&#8222;Formatierten Text einfügen&#8220;-Symbol in der TinyMCE-Symbolleiste anzeigen', # Translate - New # OK

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Konnte formatierten Text nicht laden', # Translate - New # OK

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => 'Formatierten Text wählen', # Translate - New # OK

);

1;
