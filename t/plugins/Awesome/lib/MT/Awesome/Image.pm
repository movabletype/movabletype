package MT::Awesome::Image;

use strict;
use warnings;
use base qw( MT::Awesome );

__PACKAGE__->install_properties(
    {   class_type  => 'image',
        column_defs => {
            'width'  => 'integer meta',
            'height' => 'integer meta indexed',
        },
    }
);

1;
