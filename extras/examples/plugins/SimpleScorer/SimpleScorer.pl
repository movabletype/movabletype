# SimpleScorer plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package MT::Plugin::SimpleScorer;

use strict;
use MT::Plugin;
@MT::Plugin::SimpleScorer::ISA = qw(MT::Plugin);

my $plugin = new MT::Plugin::SimpleScorer({
    name => "Simple Scorer",
    version => '0.1',
    description => "<MT_TRANS phrase=\"Scores each entry.\">",
    author_name => "Six Apart, Ltd.",
    author_link => "http://www.sixapart.com/",
    #l10n_class => 'SimpleScorer::L10N',
});
MT->add_plugin($plugin);

sub instance { $plugin }

sub key {
    $plugin->{name};
}
