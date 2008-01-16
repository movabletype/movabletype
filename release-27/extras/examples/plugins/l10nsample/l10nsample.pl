# Movable Type (r) Open Source (C) 2005-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Plugin::l10nsample;

use strict;
use base 'MT::Plugin';
use vars qw($VERSION);
$VERSION = '0.01';

my $plugin;
$plugin = MT::Plugin::l10nsample->new({
    name => "<MT_TRANS phrase=\"l10nsample\">",
    version => $VERSION,
    doc_link => "http://www.sixapart.com/",
    description => "<MT_TRANS phrase=\"This description can be localized if there is l10n_class set.\">",
    author_name => "<MT_TRANS phrase=\"Fumiaki Yoshimatsu\">",
    author_link => "http://sixapart.com/",
    l10n_class => 'l10nsample::L10N',
});
MT->add_plugin($plugin);

sub instance { $plugin }

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        applications => {
            cms => {
                page_actions => {
                    entry => {
                        l10nsample => {
                            key => 'plugin:l10n_sample:l10n_sample',
                            label => 'This is localizable',
                            link => 'l10nsample.cgi',
                        },
                    },
                },
            },
        },
    });
}
