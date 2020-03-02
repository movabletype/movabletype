package MT::Test::Role::WebQuery;

use Role::Tiny;
use Web::Query;

sub wq_find {
    my ( $self, $selector ) = @_;
    my $wq = Web::Query->new( $self->content );
    $wq->find($selector);
}

sub _trim {
    my $str = shift;
    return '' unless defined $str;
    $str =~ s/\A\s+//s;
    $str =~ s/\s+\z//s;
    $str;
}

sub page_title {
    my $self = shift;
    _trim( $self->wq_find("#page-title")->text );
}

sub message_text {
    my $self = shift;
    my $message_class = MT->version_number >= 7 ? '.alert' : '.msg';
    _trim( $self->wq_find($message_class)->text );
}

sub generic_error {
    my $self = shift;
    _trim( $self->wq_find("#generic-error")->text );
}

1;
