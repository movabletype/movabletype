# Movable Type (r) Open Source (C) 2006-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# WXRImporter plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic and GPLv2 License

package MT::Plugin::WXRImporter;

use strict;
use base qw( MT::Plugin );

my $plugin = new MT::Plugin::WXRImporter({
    name => "WXR Importer",
    version => '1.1',
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
                options => [ 'wp_path', 'mt_site_path', 'mt_extra_path', 'wp_download' ],
                options_template => 'options.tmpl',
                options_param => 'WXRImporter::Import::get_param',
            },
        },
        task_workers => {
            'wxr_importer' => {
                label => "Download WP attachments via HTTP.",
                class => 'WXRImporter::Worker::Downloader',
            },
        },
    });
}

1;
