# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# Original copyright (c) 2004-2006, Brad Choate and Tobias Hoellrich

package spamlookup;

use strict;
use warnings;
use MT::JunkFilter qw(ABSTAIN);

sub tborigin {
    my $plugin = shift;
    my ($obj) = @_;

    # only filter TrackBack pings...
    return (ABSTAIN) unless UNIVERSAL::isa( $obj, 'MT::TBPing' );

    my @domain = extract_domains( $obj->source_url, 1 );

    my $config = $plugin->get_config_hash( 'blog:' . $obj->blog_id )
        ;    # config($plugin);
    my $pingip = $obj->ip;

    if (domain_or_ip_in_whitelist( \@domain, $pingip, $config->{whitelist} ) )
    {
        return (ABSTAIN);
    }

    my $domain   = $domain[0];
    my $score    = int( $config->{tborigin_weight} ) || 1;
    my $domainip = checkdns($domain);
    if ( !$domainip ) {
        return (
            -1 * $score,
            MT->translate(
                "Failed to resolve IP address for source URL [_1]",
                $obj->source_url
            )
        );
    }

    my @domainip = split /\./, $domainip;
    my @pingip   = split /\./, $pingip;

    my $distance = 4;
    foreach ( 0 .. 3 ) {
        if ( $domainip[$_] == $pingip[$_] ) {
            $distance--;
        }
        else {
            last;
        }
    }

    return (ABSTAIN) if $distance < 3;

    # reverse lookup ip address if we can. if it matches to the
    # domain of the source url, then ABSTAIN.

    my $hostname = reversedns($pingip);
    if ($hostname) {
        if (domain_or_ip_in_whitelist(
                $hostname, undef, $config->{whitelist}
            )
            )
        {
            return (ABSTAIN);
        }
        $domain   = lc $domain;
        $hostname = lc $hostname;
        if ( $domain =~ m/\Q$hostname\E$/ ) {
            return (ABSTAIN);
        }
    }

    # check distance of sender's IP. if it is too far from the
    # source url domain, moderate/junk it.
    if ( $config->{tborigin_mode} == 2 ) {
        $obj->moderate;
        return (
            0,
            MT->translate(
                "Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]",
                $obj->source_url, $domainip, $pingip
            )
        );
    }

    if ( $config->{tborigin_mode} == 1 ) {
        return (
            -1 * $score,
            MT->translate(
                "Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]",
                $obj->source_url, $domainip, $pingip
            )
        );
    }

    return (ABSTAIN);
}

sub urls {
    my $plugin = shift;
    my ($obj) = @_;

    my $config = $plugin->get_config_hash( 'blog:' . $obj->blog_id )
        ;    # config($plugin);

    # URL tests...

    # count URLs...
    my $nurls   = 0;
    my $text    = $obj->all_text;
    my @domains = extract_domains( $text, 0, \$nurls );

    if ( $config->{urlcount_none_mode} ) {
        return (
            int( $config->{urlcount_none_weight} ) || 1,
            MT->translate("No links are present in feedback")
        ) unless $nurls;
    }

    my $domain;
    if ( UNIVERSAL::isa( $obj, 'MT::Comment' ) ) {
        $domain = extract_domains( $obj->url, 1 );
    }
    elsif ( UNIVERSAL::isa( $obj, 'MT::TBPing' ) ) {
        $domain = extract_domains( $obj->source_url, 1 );
    }

    my $pingip = $obj->ip;

    if (domain_or_ip_in_whitelist(
            $nurls == 1 ? $domain : undef,
            $pingip, $config->{whitelist}
        )
        )
    {
        return (ABSTAIN);
    }

    if ( $config->{urlcount_junk_mode} ) {
        if ( $nurls >= $config->{urlcount_junk_limit} ) {
            return (
                -1 * ( int( $config->{urlcount_junk_weight} ) || 1 ),
                MT->translate(
                    "Number of links exceed junk limit ([_1])",
                    $config->{urlcount_junk_limit}
                )
            );
        }
    }

    if ( $config->{urlcount_moderate_mode} ) {
        if ( $nurls >= $config->{urlcount_moderate_limit} ) {
            $obj->moderate;
            return (
                0,
                MT->translate(
                    "Number of links exceed moderation limit ([_1])",
                    $config->{urlcount_moderate_limit}
                )
            );
        }
    }
    return (ABSTAIN);
}

sub link_memory {
    my $plugin = shift;
    my ($obj) = @_;

    my $config = $plugin->get_config_hash( 'blog:' . $obj->blog_id )
        ;    # config($plugin);

    if ( $config->{priorurl_mode} ) {

        # this lookup is only effective on SQL databases since the
        # comment_url column is unindexed.
        if ( !UNIVERSAL::isa( MT::Object->driver, 'MT::ObjectDriver::DBM' ) )
        {
            if ( UNIVERSAL::isa( $obj, 'MT::Comment' ) ) {
                my @textdomains = extract_domains( $obj->text );
                if ( !@textdomains ) {
                    my $url = $obj->url || '';
                    $url =~ s/^\s+|\s+$//gs;
                    if ( $url =~ m!https?://\w+! )
                    {    # valid url requirement...
                        require MT::Comment;
                        my $terms = {
                            url     => $url,
                            blog_id => $obj->blog_id,
                            visible => 1
                        };
                        my $args;
                        if ( $config->{priorurl_greyperiod_mode}
                            && ( my $grey = $config->{priorurl_greyperiod} ) )
                        {
                            my $ts = time;
                            $ts -= $grey * ( 24 * 60 * 60 );
                            require MT::Util;
                            $ts = MT::Util::epoch2ts( $obj->blog_id, $ts );
                            $terms->{created_on} = [ undef, $ts ];
                            $args->{range_incl}{created_on} = 1;
                        }
                        my $c = MT::Comment->load( $terms, $args );
                        if ($c) {
                            return (
                                ( int( $config->{priorurl_weight} ) || 1 ),
                                MT->translate(
                                    "Link was previously published (comment id [_1]).",
                                    $c->id
                                )
                            );
                        }
                    }
                }
            }
            elsif ( UNIVERSAL::isa( $obj, 'MT::TBPing' ) ) {
                my $url = $obj->source_url || '';
                $url =~ s/^\s+|\s+$//gs;
                my $terms = {
                    source_url => $url,
                    blog_id    => $obj->blog_id,
                    visible    => 1
                };
                my $args;
                if ( $config->{priorurl_greyperiod_mode}
                    && ( my $grey = $config->{priorurl_greyperiod} ) )
                {
                    my $ts = time;
                    $ts -= $grey * ( 24 * 60 * 60 );
                    require MT::Util;
                    $ts = MT::Util::epoch2ts( $obj->blog_id, $ts );
                    $terms->{created_on} = [ undef, $ts ];
                    $args->{range_incl}{created_on} = 1;
                }
                my $t = MT::TBPing->load( $terms, $args );
                if ($t) {
                    return (
                        ( int( $config->{priorurl_weight} ) || 1 ),
                        MT->translate(
                            "Link was previously published (TrackBack id [_1]).",
                            $t->id
                        )
                    );
                }
            }
        }
    }
    return (ABSTAIN);
}

sub email_memory {
    my $plugin = shift;
    my ($obj) = @_;

    my $config = $plugin->get_config_hash( 'blog:' . $obj->blog_id );

    if ( $config->{prioremail_mode} ) {

        # this lookup is only effective on SQL databases since the
        # comment_url collumn is unindexed.
        if ( UNIVERSAL::isa( $obj, 'MT::Comment' ) ) {
            my $email = $obj->email;
            $email =~ s/^\s+|\s+$//gs;
            if ( $email =~ m/\w+@\w+/ ) {
                require MT::Comment;
                my $terms = {
                    email   => $email,
                    blog_id => $obj->blog_id,
                    visible => 1
                };
                my $args;
                if ( $config->{prioremail_greyperiod_mode}
                    && ( my $grey = $config->{prioremail_greyperiod} ) )
                {
                    my $ts = time;
                    $ts -= $grey * ( 24 * 60 * 60 );
                    require MT::Util;
                    $ts = MT::Util::epoch2ts( $obj->blog_id, $ts );
                    $terms->{created_on} = [ undef, $ts ];
                    $args->{range_incl}{created_on} = 1;
                }
                my $c = MT::Comment->load( $terms, $args );
                if ($c) {
                    return (
                        ( int( $config->{prioremail_weight} ) || 1 ),
                        MT->translate(
                            "E-mail was previously published (comment id [_1]).",
                            $c->id
                        )
                    );
                }
            }
        }
    }

    return (ABSTAIN);
}

sub wordfilter {
    my $plugin = shift;
    my ($obj) = @_;

    my $config = $plugin->get_config_hash( 'blog:' . $obj->blog_id );

    my $text = '';
    if ( UNIVERSAL::isa( $obj, 'MT::Comment' ) ) {

        # Comment
        $text = join "\n",
            "name:" .  ( $obj->author || '' ),
            "email:" . ( $obj->email  || '' ),
            "url:" .   ( $obj->url    || '' ),
            "text:" .  ( $obj->text   || '' );
    }
    else {

        # TrackBack ping
        $text = join "\n",
            "blog:" .  ( $obj->blog_name  || '' ),
            "title:" . ( $obj->title      || '' ),
            "url:" .   ( $obj->source_url || '' ),
            "text:" .  ( $obj->excerpt    || '' );
    }

    my $decodedtext = decode_entities($text);
    $decodedtext = '' if $text eq $decodedtext;

    if ( $config->{wordlist_junk} ) {
        my @matches = wordlist_match( $text, $config->{wordlist_junk} );
        if ( @matches && $decodedtext ) {
            @matches
                = wordlist_match( $decodedtext, $config->{wordlist_junk} );
        }
        if (@matches) {
            my $total_score = 0;
            my @log;
            foreach (@matches) {
                my ( $patt, $match, $score ) = @$_;
                $total_score += $score;
                push @log,
                    MT->translate( "Word Filter match on '[_1]': '[_2]'.",
                    $patt, $match );
            }
            return ( -1 * ( $total_score || 1 ), \@log );
        }
    }

    if ( $config->{wordlist_moderate} ) {
        my @matches = wordlist_match( $text, $config->{wordlist_moderate} );
        if ( !@matches && $decodedtext ) {
            @matches = wordlist_match( $decodedtext,
                $config->{wordlist_moderate} );
        }
        if (@matches) {
            my @log;
            foreach (@matches) {
                my ( $patt, $match, $score ) = @$_;
                push @log,
                    MT->translate(
                    "Moderating for Word Filter match on '[_1]': '[_2]'.",
                    $patt, $match );
            }
            $obj->moderate;
            return ( 0, \@log );
        }
    }

    return (ABSTAIN);
}

sub domainbl {
    my $plugin = shift;
    my ($obj) = @_;

    my $config = $plugin->get_config_hash( 'blog:' . $obj->blog_id )
        ;    # config($plugin);
    return (ABSTAIN) unless $config->{domainbl_mode};

    my @domainbl_service = split /\s*,?\s+/, $config->{domainbl_service};
    return (ABSTAIN) unless @domainbl_service;

    my $text      = $obj->all_text;
    my @domains   = extract_domains($text);
    my $remote_ip = $obj->ip;

    if (domain_or_ip_in_whitelist(
            \@domains, $remote_ip, $config->{whitelist}
        )
        )
    {
        return (ABSTAIN);
    }

    foreach my $domain (@domains) {
        next if $domain !~ m/\./;  # ignore domain if it is just a single word
        if ( $domain =~ m/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/ ) {
            $domain = "$4.$3.$2.$1";
        }
        foreach my $service (@domainbl_service) {
            $service =~ s/^\.//;
            $service =~ s/^\s+|\s+$//gs;
            if ( checkdns("$domain.$service.") ) {
                my $log
                    = MT->translate( "domain '[_1]' found on service [_2]",
                    $domain, $service );
                if ( $config->{domainbl_mode} == 2 ) {
                    $obj->moderate;
                    return ( 0, $log );
                }
                else {
                    return ( -1 * ( int( $config->{domainbl_weight} ) || 1 ),
                        $log );
                }
            }
        }
    }
    return (ABSTAIN);
}

sub ipbl {
    my $plugin = shift;
    my ($obj) = @_;

    return (ABSTAIN) unless $obj->ip;

    my $config = $plugin->get_config_hash( 'blog:' . $obj->blog_id )
        ;    # config($plugin);
    return (ABSTAIN) unless $config->{ipbl_mode};

    my $remote_ip = $obj->ip;

    if (domain_or_ip_in_whitelist( undef, $remote_ip, $config->{whitelist} ) )
    {
        return (ABSTAIN);
    }

    my ( $a, $b, $c, $d ) = split /\./, $remote_ip;
    return (ABSTAIN) unless $a && $b && $c && $d;

    my @ipbl_service = split /\s*,?\s+/, $config->{ipbl_service};
    return (ABSTAIN) unless @ipbl_service;

    foreach my $service (@ipbl_service) {
        $service =~ s/^\.//;
        $service =~ s/^\s+|\s+$//gs;
        if ( checkdns("$d.$c.$b.$a.$service.") ) {
            my $log = MT->translate( "[_1] found on service [_2]",
                $remote_ip, $service );
            if ( $config->{ipbl_mode} == 2 ) {
                $obj->moderate;
                return ( 0, $log );
            }
            else {
                return ( -1 * ( int( $config->{ipbl_weight} ) || 1 ), $log );
            }
        }
    }
    return (ABSTAIN);
}

## Utility functions... not methods

sub checkdns {
    my ($name) = @_;
    if ( $name =~ m/^\d+\.\d+\.\d+\.\d+$/ ) {
        return $name;
    }
    require MT::Request;
    my $cache = MT::Request->instance->cache('checkdns_cache') || {};
    return $cache->{$name} if exists $cache->{$name};
    my $iaddr = gethostbyname($name);
    return 0 unless $iaddr;
    require Socket;
    my $ip = Socket::inet_ntoa($iaddr);
    $cache->{$name} = $ip;
    MT::Request->instance->cache( 'checkdns_cache', $cache );
    return $ip ? $ip : undef;
}

sub reversedns {
    my ($ip) = @_;
    require MT::Request;
    my $cache = MT::Request->instance->cache('reversedns_cache') || {};
    return $cache->{$ip} if exists $cache->{$ip};
    require Socket;
    my $iaddr = Socket::inet_aton($ip);
    my $name = gethostbyaddr( $iaddr, Socket::AF_INET() );
    return undef unless $name;
    $cache->{$ip} = $name;
    MT::Request->instance->cache( 'reversedns_cache', $cache );
    return $name;
}

sub extract_domains {
    my ( $str, $mode, $total ) = @_;

    $mode ||= 0;

    # unmunge so we can see encoded urls as well
    $str = lc decode_entities($str);
    my @urls;
    my %seen;
    while ( $str
        =~ m!(?:ht(?:tp)?s?:)?//(?:[a-z0-9\-\.\+:]+@)?([a-z0-9\.\-]+)!gi )
    {
        my $domain = $1;
        $domain =~ s/^\s+//s;
        $domain =~ s/\s+$//s;
        $domain =~ s/^www\.//s;
        next unless $domain;
        next unless $domain =~ m/\./;
        my @parts = split /\./, $domain;
        next unless @parts;

        if (   ( $domain =~ m/^\d+\.\d+\.\d+\.\d+$/ )
            || ( $domain =~ m/^\d+$/ ) )
        {
            $$total++ if ( defined($total) );
            next if $seen{$domain};
            $seen{$domain} = 1;
            push @urls, $domain;
            next;
        }
        return $domain if $mode == 1;
        $$total++      if ( defined($total) );
        next           if $seen{$domain};
        if ( $mode == 0 ) {    # default mode, replicate for all subdomains
            my $last = $#parts;
            my $start = length( $parts[$last] ) < 3 ? 2 : 1;
            if ( $start > $last ) {
                $seen{$domain} = 1;
                push @urls, $domain;
            }
            foreach ( my $i = $start; $i <= $last; $i++ ) {
                my $partial = join '.', @parts[ $last - $i .. $last ];
                next if $seen{$partial};
                $seen{$partial} = 1;
                push @urls, $partial;
            }
        }
        else {
            $seen{$domain} = 1;
            push @urls, $domain;
        }
    }

    @urls;
}

sub decode_entities {
    my ($str) = @_;
    if ( eval { require HTML::Entities; 1 } ) {
        return HTML::Entities::decode($str);
    }
    else {

        # yanked from HTML::Entities, since some users don't have the module
        my $c;
        for ($str) {
            s/(&\#(\d+);?)/$2 < 256 ? chr($2) : $1/eg;
            s/(&\#[xX]([0-9a-fA-F]+);?)/$c = hex($2); $c < 256 ? chr($c) : $1/eg;
        }
        $str;
    }
}

sub wordlist_match {
    my ( $text, $patterns ) = @_;

    $text ||= '';
    my @patt = split /[\r\n]+/, $patterns;
    my @matches;
    foreach my $patt (@patt) {
        next if $patt =~ m/^#/;
        my $score = 1;
        if ( $patt =~ m/^(.*?) (\d+(?:\.\d+)?) *$/ ) {
            $patt  = $1;
            $score = $2;
        }
        $patt =~ s/(^ +| +$)//g;
        next if $patt eq '';

        my $re_opt
            = MT::ConfigMgr->instance->DefaultLanguage eq 'ja' ? '' : '\b';
        if ( $patt =~ m!^/! ) {
            my $re = $patt;
            my ($opt) = $re =~ m!/([^/]*)$!;
            $re =~ s!^/!!;
            $re =~ s!/[^/]*$!!;
            if ($opt) {

                # increment any internal backreferences (\1),
                # since we're wrapping the whole expression in
                # a capturing group
                $re =~ s/ \\(\d+) / '\\' . ($1 + 1) /gex;

                $re = '(?' . $opt . ':' . $re . ')';
            }
            $re = eval {qr/($re)/};
            $re = $re_opt . quotemeta($patt) . $re_opt if $@;
            push @matches, [ $patt, $1, int($score) ] if $text =~ m/($re)/;
        }
        else {
            my $re = $re_opt . quotemeta($patt) . $re_opt;
            push @matches, [ $patt, $1, int($score) ] if $text =~ m/($re)/i;
        }
    }
    @matches;
}

sub domain_or_ip_in_whitelist {
    my ( $domain, $ip, $whitelist ) = @_;

    if ( ref $domain eq 'ARRAY' ) {
        my %domains;
        foreach my $domain (@$domain) {
            my @whitelist = split /\r?\n/, $whitelist;
            foreach my $whiteitem (@whitelist) {
                next if $whiteitem =~ m/^#/;
                if ( $whiteitem
                    =~ m/^\d{1,3}\.(?:\d{1,3}\.(?:\d{1,3}\.(?:\d{1,3})?)?)?$/
                    )
                {
                    return 1 if defined $ip && ( $ip =~ m/^\Q$whiteitem\E/ );
                }
                elsif ( $whiteitem =~ m/\w/ ) {
                    next
                        if defined $domain
                        && ( $domain =~ m/\Q$whiteitem\E$/i );
                    $domains{$domain} = 1;
                }
            }
        }
        @$domain = keys %domains;
        return 0;
    }

    $whitelist ||= '';
    my @whitelist = split /\r?\n/, $whitelist;
    foreach my $whiteitem (@whitelist) {
        next if $whiteitem =~ m/^#/;
        if ( $whiteitem
            =~ m/^\d{1,3}\.(?:\d{1,3}\.(?:\d{1,3}\.(?:\d{1,3})?)?)?$/ )
        {
            return 1 if defined $ip && ( $ip =~ m/^\Q$whiteitem\E/ );
        }
        elsif ( $whiteitem =~ m/\w/ ) {
            return 1 if defined $domain && ( $domain =~ m/\Q$whiteitem\E$/i );
        }
    }

    return 0;
}

1;
