#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use LWP::Simple;

my $base = 'http://mt.sixapart.com';
my @names = qw( tinsel tribble tribble-ldap mt3.2 gawker );
my $tests = scalar(@names) * 2;

if( ! head($base) ) {
    plan( skip_all => 'Not testing MT staging' );
}
else {
    plan( tests => $tests );
}

SKIP : {
    eval 'use WWW::Mechanize';
    skip( 'WWW::Mechanize required', $tests ) if $@;

    my $m = WWW::Mechanize->new();

    my( $user, $pass ) = ( 'Melody', 'Nelson' );

    for my $name ( @names ) {
        my $url = sprintf '%s/%s/mt.cgi', $base, $name;
        $m->get( $url );
        ok $m->success, "Reached $url";

        $m->submit_form(
            fields => { username => $user, password => $pass },
        );
        if( $name =~ /-ldap/ ) {
            ok $m->content =~ /Invalid login/,
                'Non-LDAP user cannot login';
        }
        else {
            ok not( $m->content =~ /Invalid login/ ),
                "Logged-in as $user/$pass";
        }
    }
}
