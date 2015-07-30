package OAuth::Lite2::Client::StateResponseParser;

use strict;
use warnings;

use Try::Tiny qw/try catch/;
use OAuth::Lite2::Formatters;
use OAuth::Lite2::Client::Error;
use OAuth::Lite2::Client::ServerState;

=head1 NAME

OAuth::Lite2::Client::StateResponseParser - Server state response parser

=head1 DESCRIPTION

Server state response parser

=cut

sub new {
    bless {}, $_[0];
}

sub parse {
    my ($self, $http_res) = @_;

    my $formatter =
        OAuth::Lite2::Formatters->get_formatter_by_type(
            $http_res->content_type);

    my $state;

    if ($http_res->is_success) {

        OAuth::Lite2::Client::Error::InvalidResponse->throw(
            message => sprintf(q{Invalid response content-type: %s},
                $http_res->content_type||'')
        ) unless $formatter;

        my $result = try {
            return $formatter->parse($http_res->content);
        } catch {
            OAuth::Lite2::Client::Error::InvalidResponse->throw(
                message => sprintf(q{Invalid response format: %s}, $_),
            );
        };

        OAuth::Lite2::Client::Error::InvalidResponse->throw(
            message => sprintf("Response doesn't include 'server_state'")
        ) unless exists $result->{server_state};

        OAuth::Lite2::Client::Error::InvalidResponse->throw(
            message => sprintf("Response doesn't include 'expires_in'")
        ) unless exists $result->{expires_in};

        $state = OAuth::Lite2::Client::ServerState->new($result);

    } else {

        my $errmsg = $http_res->content || $http_res->status_line;

        if ($formatter && $http_res->content) {
            try {
                my $result = $formatter->parse($http_res->content);
                $errmsg = $result->{error}
                    if exists $result->{error};
            } catch { return };
        }
        OAuth::Lite2::Client::Error::InvalidResponse->throw( message => $errmsg );
    }
    return $state;
}

=head1 AUTHOR

Ryo Ito, E<lt>ritou.06@gmail.comE<gt>

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
