package MT::Test::Role::Wight;

use Role::Tiny;
use Test::More ();

# The following methods are just to keep compatibility with Test::Wight

sub visit {
    my ( $self, $path_query ) = @_;
    my $url = $self->{base_url}->clone;
    $url->path_query($path_query);
    $self->driver->get( $url->as_string );
    $self->{content} = $self->driver->get_page_source;
    $self;
}

sub find {
    my ( $self, $selector ) = @_;
    my $element = eval { $self->driver->find_element($selector); };
    Test::More::diag $@ if $@;
    $self->{_element} = $element;
    $self;
}

sub value {
    my $self = shift;
    my $element = $self->{_element} or return;
    $element->get_value;
}

sub attribute {
    my ( $self, $attr ) = @_;
    my $element = $self->{_element} or return;
    $element->get_attribute($attr);
}

sub set {
    my ( $self, $value ) = @_;
    my $element = $self->{_element} or return;
    $element->clear;
    $element->send_keys("$value");
}

1;
