package MT::Test::Role::CMS::GrantRole;

use Role::Tiny;
use Test::More;
use JSON;
use Web::Query::LibXML;

our $CURRENT_PANEL;

sub open_dialog {
    my ($self, $blog_id) = @_;
    $self->get_ok({
        __mode  => 'dialog_grant_role',
        _type   => 'user',
        type    => $blog_id ? 'website' : 'site',
        blog_id => $blog_id,
        dialog  => 1,
    });
    $CURRENT_PANEL = 'user';
}

sub set_panel {
    my ($self, $name) = @_;
    $CURRENT_PANEL = $name;
}

sub get_json {
    my ($self, $opts) = @_;
    $opts ||= {};
    my $formdata = {
        %$opts,
        __mode      => (scalar $self->{cgi}->param('__mode')),
        magic_token => (scalar $self->{cgi}->param('magic_token')),
        return_args => (scalar $self->{cgi}->param('return_args')),
        blog_id     => (scalar $self->{cgi}->param('blog_id')),
        type        => (scalar $self->{cgi}->param('type')),
        _type        => $CURRENT_PANEL,
        dialog      => 1,
        json        => 1,
    };
    $self->post_ok($formdata);
}

sub get_names_and_pager {
    my ($self) = @_;
    my $json   = JSON::decode_json($self->content);
    my $wq     = Web::Query::LibXML->new($json->{html});
    my @names  = map {
        my $txt = $_;
        $txt =~ s{^\s+|\s+$}{}g;
        $txt;
    } $wq->find('tr td:nth-of-type(2) .panel-label')->text;
    note explain([\@names, $json->{pager}]);
    return (\@names, $json->{pager});
}

sub get_site_tree_and_pager {
    my ($self) = @_;
    my $json   = JSON::decode_json($self->content);
    my $wq     = Web::Query::LibXML->new($json->{html});
    my @names;
    $wq->find('tr td:nth-of-type(2) .panel-label')->each(sub {
        my ($i, $elem) = @_;
        my $name = $elem->text;
        $name =~ s{^\s+|\s+$}{}g;
        push @names, $name;
        push @names, map {
            my $txt = $_;
            $txt =~ s{^\s+|\s+$}{}g;
            $txt;
        } $elem->parent->find('.child-panel-label')->text;
    });
    note explain([\@names, $json->{pager}]);
    return (\@names, $json->{pager});
}

1;
