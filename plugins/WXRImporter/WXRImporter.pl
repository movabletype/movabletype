# WXRImporter plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package MT::Plugin::WXRImporter;

use strict;
use base qw( MT::Plugin );

my $plugin = new MT::Plugin::WXRImporter({
    name => "WXR Importer",
    version => '0.1',
    description => '<MT_TRANS phrase="Import WordPress exported RSS into MT.">',
    author_name => "Six Apart, Ltd.",
    author_link => "http://www.sixapart.com/",
    l10n_class => 'WXRImporter::L10N',
});
MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        'import_formats' => {
            'import_wxr' => {
                label => 'WordPress eXtended RSS (WXR)',
                type => 'WXRImporter::Import',
                handler => 'WXRImporter::Import::import_contents',
                options => [ 'wp_path', 'mt_site_path', 'mt_extra_path' ],
                options_template => 'options.tmpl',
                options_param => 'WXRImporter::Import::get_param',
            },
        },
    });
}

1;
