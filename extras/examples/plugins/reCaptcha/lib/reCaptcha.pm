# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# reCaptcha plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic and GPLv2 License

package reCaptcha;

use strict;
use warnings;
use base qw(MT::ErrorHandler);

sub form_fields {
    my $self = shift;
    my ($blog_id) = @_;
	
	my $plugin = MT::Plugin::reCaptcha->instance;
    my $config = $plugin->get_config_hash("blog:$blog_id");
    my $publickey = $config->{recaptcha_publickey};
    my $privatekey = $config->{recaptcha_privatekey};
	return q() unless $publickey && $privatekey;

    return <<FORM_FIELD;
<div id="recaptcha_script" style="display:none">
<script type="text/javascript"
   src="http://api.recaptcha.net/challenge?k=$publickey">
</script>

<noscript>
   <iframe src="http://api.recaptcha.net/noscript?k=$publickey"
       height="300" width="500" frameborder="0"></iframe><br>
   <textarea name="recaptcha_challenge_field" rows="3" cols="40">
   </textarea>
   <input type="hidden" name="recaptcha_response_field" 
       value="manual_challenge">
</noscript>
</div>
<script type="text/javascript">
var div = document.getElementById("recaptcha_script");
if (commenter_name) {
    div.style.display = "none";
} else {
    div.style.display = "block";
}
</script>
FORM_FIELD
}

sub validate_captcha {
    my $self = shift;
    my ($app) = @_;
    my $entry_id = $app->param('entry_id')
      or return 0;

    my $entry = $app->model('entry')->load($entry_id)
      or return 0;

    my $blog_id = $entry->blog_id;

    my $config = MT::Plugin::reCaptcha->instance->get_config_hash("blog:$blog_id");
    my $privatekey = $config->{recaptcha_privatekey};
 
    my $challenge = $app->param('recaptcha_challenge_field');
    my $response = $app->param('recaptcha_response_field');
    my $ua = $app->new_ua({ timeout => 15, max_size => undef });
    return 0 unless $ua;

	require HTTP::Request;
    my $req = HTTP::Request->new(POST => 'http://api-verify.recaptcha.net/verify');
    $req->content_type("application/x-www-form-urlencoded");
	require MT::Util;
	my $content = 'privatekey=' . MT::Util::encode_url($privatekey);
	$content .= '&remoteip=' . MT::Util::encode_url($app->remote_ip);
	$content .= '&challenge=' . MT::Util::encode_url($challenge);
	$content .= '&response=' . MT::Util::encode_url($response);
    $req->content($content);
    my $res = $ua->request($req);
    my $c = $res->content;
    if (substr($res->code, 0, 1) eq '2') {
		return 1 if $c =~ /^true\n/;
	}
	0;
}
    
sub generate_captcha {
    #This won't be called since there is no link which requests to "generate_captcha" mode.
    my $self = shift;
    1;
}

1;
