# This software is licensed under the MIT License.
# 
# Copyright (c) 2009 Andrey Serebryakov

package MT::Auth::Yandex;
use strict;

use base qw( MT::Auth::OpenID );

#sub url_for_userid {
#	my $class = shift;
#	my ($uid) = @_;
#	return "http://$uid.ya.ru/";
#};

sub get_nickname {
	my $class = shift;
	my ($vident) = @_;
	
	my $url = $vident->url;
	if ( $url =~ m(^http://([^\.]+)\.ya\.ru\/$) ) {
		return $1;
	}
	elsif ( $url =~ m(^http://openid.yandex.ru/(.+)$) ) {
		return $1;
	}
	return $class->SUPER::get_nickname(@_);
}

sub commenter_auth_params {
	my ( $key, $blog_id, $entry_id, $static ) = @_;
	my $params = {
		blog_id => $blog_id,
		static  => $static,
	};
	$params->{entry_id} = $entry_id if defined $entry_id;
	return $params;
}
sub openid_commenter_condition {
	eval "require Digest::SHA1;";
	return $@ ? 0 : 1;
}

1;
