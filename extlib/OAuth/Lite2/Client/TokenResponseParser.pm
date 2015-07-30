package OAuth::Lite2::Client::TokenResponseParser;

use strict;
use warnings;

use Try::Tiny qw/try catch/;
use OAuth::Lite2::Formatters;
use OAuth::Lite2::Client::Error;
use OAuth::Lite2::Client::Token;

sub new {
    bless {}, $_[0];
}

sub parse {
    my ($self, $http_res) = @_;

    my $formatter =
        OAuth::Lite2::Formatters->get_formatter_by_type(
            $http_res->content_type);

    my $token;

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
            message => sprintf("Response doesn't include 'access_token'")
        ) unless exists $result->{access_token};

        $token = OAuth::Lite2::Client::Token->new($result);

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
    return $token;
}


1;
