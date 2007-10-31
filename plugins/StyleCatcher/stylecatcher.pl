# Copyright 2005-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.
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
    description => "<MT_TRANS phrase=\"StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href='http://www.sixapart.com/movabletype/styles'>Movable Type styles</a> page.\">",
    author_name => "Six Apart, Ltd.",
    author_link => "http://www.sixapart.com/",
    l10n_class => 'StyleCatcher::L10N',
    registry => {
        stylecatcher_libraries => {
            'sixapart' => {
                url => 'http://www.sixapart.com/movabletype/styles/library',
                label => 'MT Style Library',
            },
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
