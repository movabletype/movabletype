package MT::Awesome::Image;

our @ISA = qw( MT::Awesome );

__PACKAGE__->install_properties({
    class_type => 'image',
    column_defs => {
        'width' => 'integer meta',
        'height' => 'integer meta indexed',
    },
});

1;
