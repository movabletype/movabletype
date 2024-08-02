package MT::Test::Role::WebQuery;

use Role::Tiny;
use Web::Query::LibXML;
use Test::More;

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
    my @elems = eval { $self->wq_find($selector) } or return;
    return wantarray ? (map { $_->text } @elems) : $elems[0]->text;
}

sub header_title {
    my $self = shift;
    _trim( $self->_find_text("title") );
}

sub page_title {
    my $self = shift;
    _trim( $self->_find_text("#page-title") );
}

sub modal_title {
    my $self = shift;
    _trim($self->_find_text(".modal-title"));
}

sub message_text {
    my $self = shift;
    my $message_class = MT->version_number >= 7 ? '.alert' : '.msg';
    if (wantarray) {
        return map { _trim($_) } $self->_find_text($message_class);
    } else {
        return _trim(scalar $self->_find_text($message_class));
    }
}

sub generic_error {
    my $self = shift;
    _trim( $self->_find_text("#generic-error") );
}

sub json_error {
    my $self = shift;
    return '' unless $self->content =~ /\A[\[\{]/;
    my $json = eval { JSON::decode_json($self->content) };
    $json->{error} // '';
}

sub _concatenated_message {
    my $self = shift;
    join "\n", grep { defined $_ && $_ ne '' } $self->message_text, $self->generic_error, $self->json_error;
}

sub _concatenated_error {
    my $self = shift;
    join "\n", grep { defined $_ && $_ ne '' } $self->generic_error, $self->json_error;
}

sub has_permission_error {
    my ($self, $message) = @_;
    my $response = $self->_concatenated_message // '';
    like $response => qr/(?:No permissions|permission denied|you do not have (\w+ )?permission|not implemented)/is, $message || 'has permission error';
}

sub has_no_permission_error {
    my ($self, $message) = @_;
    my $response = $self->_concatenated_message // '';
    unlike $response => qr/(?:No permissions|permission denied|you do not have (\w+ )?permission|not implemented)/is, $message || 'has no permission error';
}

sub has_invalid_request {
    my ($self, $message) = @_;
    my $error = $self->_concatenated_error // '';
    ok $error =~ /Invalid Request/i, $message || 'has invalid request';
}

sub has_no_invalid_request {
    my ($self, $message) = @_;
    my $error = $self->_concatenated_error // '';
    ok $error !~ /Invalid Request/i, $message || 'has no invalid request';
}

1;
