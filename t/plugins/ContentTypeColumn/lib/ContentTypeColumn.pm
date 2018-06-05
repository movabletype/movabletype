package ContentTypeColumn;
use strict;
use warnings;

sub cb_init_app {
    my $reg = MT->component('core')->registry('list_properties');
    for my $key ( grep {/^content_data\./} keys %$reg ) {
        my $value = $reg->{$key};
        $value->{random} = _list_prop_for_random();
    }
}

sub cb_pre_save {
    my ( $cb, $obj, $orig ) = @_;
    $obj->random( int rand(10) );
    1;
}

sub _list_prop_for_random {
    {   base    => '__virtual.integer',
        col     => 'random',
        display => 'force',
        label   => 'Random',
        raw     => sub {
            my ( $prop, $obj ) = @_;
            $obj->random // -1;
        },
    };
}

1;

