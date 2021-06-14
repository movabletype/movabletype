package MT::Test::Role::WebQuery;

use Role::Tiny;
use Web::Query::LibXML;

sub wq_find {
    my ( $self, $selector ) = @_;
    my $wq = Web::Query::LibXML->new( $self->content );
    $wq->find($selector);
}

sub _trim {
    my $str = shift;
    return '' unless defined $str;
    $str =~ s/\A\s+//s;
    $str =~ s/\s+\z//s;
    $str;
}

sub _find_text {
    my ( $self, $selector ) = @_;
    eval { $self->wq_find($selector)->text };
}

sub page_title {
    my $self = shift;
    _trim( $self->_find_text("#page-title") );
}

sub message_text {
    my $self = shift;
    my $message_class = MT->version_number >= 7 ? '.alert' : '.msg';
    _trim( $self->_find_text($message_class) );
}

sub generic_error {
    my $self = shift;
    _trim( $self->_find_text("#generic-error") );
}

1;
