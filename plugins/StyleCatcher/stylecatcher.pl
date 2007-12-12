# Movable Type (r) Open Source (C) 2005-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Plugin::StyleCatcher;

use strict;
use base 'MT::Plugin';
our $VERSION = '2.0';

my $plugin;
$plugin = MT::Plugin::StyleCatcher->new({
    id => 'StyleCatcher',
    name => "StyleCatcher",
    version => $VERSION,
    doc_link => "http://www.sixapart.com/movabletype/styles/",
    description => q(<MT_TRANS phrase="StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href='http://www.sixapart.com/movabletype/styles'>Movable Type styles</a> page.">),
    author_name => "Six Apart, Ltd.",
    author_link => "http://www.sixapart.com/",
    l10n_class => 'StyleCatcher::L10N',
    registry => {
        stylecatcher_libraries => {
            'sixapart_mt4' => {
                url => 'http://www.sixapart.com/movabletype/styles/mt4/library',
                label => 'MT 4 Style Library',
                description_label => "A collection of styles compatible with Movable Type 4 default templates.",
                order => 1,
            },
            # 'sixapart_mt3' => {
            #     url => 'http://www.sixapart.com/movabletype/styles/mt3/library',
            #     label => 'MT 3 Style Library',
            #     description_label => "A collection of styles compatible with Movable Type 3.3+ default templates.",
            #     order => 1000,
            # },
        },
        applications => {
            cms => {
                methods => {
                    stylecatcher_theme => '$StyleCatcher::StyleCatcher::CMS::view',
                    stylecatcher_js => '$StyleCatcher::StyleCatcher::CMS::js',
                    stylecatcher_apply => '$StyleCatcher::StyleCatcher::CMS::apply',
                },
                menus => {
                    'design:theme' => {
                        label => 'Styles',
                        order => 200,
                        mode => 'stylecatcher_theme',
                        view => "blog",
                        permission => 'edit_templates',
                    },
                },
            },
        },
    },
});
MT->add_plugin($plugin);

sub instance { $plugin }

1;
