package MT::Stats::Provider;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( id blog ));

sub new {
    my $class = shift;
    my ( $id, $blog ) = @_;
    my $self = { id => $id, blog => $blog, };
    bless $self, $class;
    $self->init();
    $self;
}

sub init { }

sub snippet {
    q();
}

sub to_resource {
    my $self = shift;
    +{ id => $self->id, };
}

1;
