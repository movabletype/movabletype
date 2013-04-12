package MT::Stats::Provider;

use strict;
use warnings;

use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( blog ));

sub new {
    my $class  = shift;
    my ($blog) = @_;
    my $self   = { blog => $blog, };
    bless $self, $class;
    $self->init();
    $self;
}

sub init { }

1;
