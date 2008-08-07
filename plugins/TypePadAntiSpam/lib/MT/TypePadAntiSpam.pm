# MT::TypePadAntiSpam, (C) 2008 Six Apart, Ltd.
# Based on Akismet plugin by Tim Appnel
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: TypePadAntiSpam.pm 81617 2008-05-23 20:11:13Z bchoate $

package MT::TypePadAntiSpam;

use strict;
use base qw( MT::ErrorHandler );

use Storable;
use LWP::UserAgent;
use Carp qw( croak );

our $VERSION      = '1.0';
our $API_VERSION  = '1.1';
our $SERVICE_HOST = 'api.antispam.typepad.com';

sub check       { shift->_typepadantispam('comment-check', 1, @_) }
sub submit_spam { shift->_typepadantispam('submit-spam',   0, @_) }
sub submit_ham  { shift->_typepadantispam('submit-ham',    0, @_) }

sub verify {
    my ($class, $key, $url) = @_;
    return $class->error("API key is a required parameter.")
      unless $key;
    return $class->error("The URL of the site is a required parameter.")
      unless $url;
    my $agent = $class->_get_agent;
    my $r =
    $agent->post("http://$SERVICE_HOST/$API_VERSION/verify-key",
        {key => $key, blog => $url});

    # Could be more RESTful in that status code should indicate success
    # or failure not a string in the content of the response.
    my $res = MT::TypePadAntiSpam::Response->new;
    $res->http_response($r);
    $res->http_status($r->code);
    $res->status($r->is_success && $r->content =~ /valid/i ? 1 : 0);
    $res;
}

#--- internals

my $num_dumped = 0;
sub _typepadantispam {
    my ($class, $meth, $is_true, $sig, $key) = @_;
    unless ($key) {
        my $plugin = MT::Plugin::TypePadAntiSpam->instance;
        # print STDERR "DEBUG: processing\n" if MT->config->DebugMode;
        return $class->error(
            $plugin->translate("API key is a required parameter.")
        );
    }
    my $agent = $class->_get_agent;
    my $r =
    $agent->post("http://$key.$SERVICE_HOST/$API_VERSION/$meth", [%ENV, %$sig]);
    my $res = MT::TypePadAntiSpam::Response->new;
    $res->http_response($r);
    $res->http_status($r->code);
    my $status = 0;
    if ($r->is_success) {
        $status = $is_true ? $r->content =~ /false/i : 1;
    }
    $res->status($status);    # 1 (true) means valid api key or not spam.
    $res;
}

our $AGENT;
sub _get_agent {
    my $class = shift;
    return $AGENT if $AGENT;
    $AGENT = MT->new_ua;
    $AGENT->agent(join '/', $class, $class->VERSION);
    $AGENT->timeout(10);
    $AGENT;
}

package MT::TypePadAntiSpam::Signature;
use base qw( Class::Accessor::Fast );
MT::TypePadAntiSpam::Signature->mk_accessors(
    qw( blog user_ip user_agent referrer permalink comment_type
      comment_author comment_author_email comment_author_url
      comment_content article_date )
);

package MT::TypePadAntiSpam::Response;
use base qw( Class::Accessor::Fast );
MT::TypePadAntiSpam::Response->mk_accessors(qw( status http_status http_response ));

1;
