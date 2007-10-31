# Shared Secret plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package MT::Plugin::SharedSecret;

use strict;
use warnings;

use MT;
use base qw(MT::Plugin);

my $plugin = MT::Plugin::SharedSecret->new({
    name => 'Shared Secret',
    description => 'Replace Captcha with a question of shared secret.',
    author_name => 'Six Apart, Ltd.',
    author_link => 'http://www.movabletype.com/',
    version => '0.1',
});

MT->add_plugin($plugin);
sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        'captcha_providers' => {
            'sixapart_ss' => {
                'label' => 'Shared Secret',
				'class' => 'Shared Secret',
            },
        },
    });
}

1;

