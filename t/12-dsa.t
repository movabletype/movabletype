#!/usr/bin/perl
# $Id: 12-dsa.t 3032 2008-09-05 00:39:59Z bchoate $
use strict;
use warnings;

use lib 't/lib';
use lib 'lib';
use lib 'extlib';

use Test::More tests => 8;

use MT;
use MT::Test;
use MT::Builder;
use MT::Util qw(dsa_verify perl_sha1_digest_hex dec2bin);

use lib 't';

my $msg = 'nina@blues.org::Nina Simone::1072216494';
my $sig = {
    r => "527791435593304577725339030118988880225606145248",
    s => "856186764515774026930421996711007369328400857333",
};
my $dsa_key = {
    p => '11671236708387678327224206536086899180337891539414163231548040398520841845883184000627860280911468857014406210406182985401875818712804278750455023001090753',
    g => '8390523802553664927497849579280285206671739131891639945934584937465879937204060160958306281843225586442674344146773393578506632957361175802992793531760152',
    q => '1096416736263180470838402356096058638299098593011',
    pub_key => '10172504425160158571454141863297493878195176114077274329624884017831109225358009830193460871698707783589128269392033962133593624636454152482919340057145639'
};

is(perl_sha1_digest_hex("abc"),
    'a9993e364706816aba3e25717850c26c9cd0d89d',
    'perl_sha1_digest_hex(abc)'
);
is(perl_sha1_digest_hex('abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq'),
    '84983e441c3bd26ebaae4aa1f95129e5e54670f1',
    'perl_sha1_digest_hex(abcd...)'
);
is(perl_sha1_digest_hex("This is a ::long string:\"\nincluding some f^nk3 ch\rcts\]\n"),
    'a691f6e0777123f70fb8613b0cbd98c0d62dce6b',
    'perl_sha1_digest_hex(This is a ::long string...}'
);
is(perl_sha1_digest_hex(''),
    'da39a3ee5e6b4b0d3255bfef95601890afd80709',
    'perl_sha1_digest_hex()'
);

ok(dsa_verify(Message => $msg, Signature => $sig, Key => $dsa_key),
    'dsa_verify()'
);

if ($@) {
    skip(1, "ERROR: $@");
} else {
    ok(dsa_verify(
            Message => $msg,
            Signature => bless($sig, 'Crypt::DSA::Signature'),
            Key => bless($dsa_key, 'Crypt::DSA::Key')
        ),
        'blessed dsa_verify()'
    );
}

$dsa_key->{g} = 1;

ok(!dsa_verify(
        Message => $msg,
        Signature => bless($sig,'Crypt::DSA::Signature'),
        Key => bless($dsa_key, 'Crypt::DSA::Key')
    ),
    'not(dsa_verify)'
);

# my $dsa_key = bless( {
#     'p' => '11671236708387678327224206536086899180337891539414163231548040398520841845883184000627860280911468857014406210406182985401875818712804278750455023001090753',
#     'g' => '8390523802553664927497849579280285206671739131891639945934584937465879937204060160958306281843225586442674344146773393578506632957361175802992793531760152',
#     'q' => '1096416736263180470838402356096058638299098593011',
#     'pub_key' => '10172504425160158571454141863297493878195176114077274329624884017831109225358009830193460871698707783589128269392033962133593624636454152482919340057145639'
#     }, 'Crypt::DSA::Key' );

# print dsa_verify(Message => 'nina@blues.org::Nina Simone::1072137320',
# 		 Key => $dsa_key,
#  		 Signature => new Crypt::DSA::Signature(
# 		       r => "179524654873292192810669641349818294463683984472",
# 		       s => "32636895355904099107265678275162258563954033951"))
#     ? "verified\n" : "incorrect\n";

# use Math::Pari qw( PARI );
# use Crypt::DSA::Util qw( bitsize bin2mp mod_inverse mod_exp );
# sub verify {
#     my %param = @_;
#     my($key, $dgst, $sig);
#     #croak __PACKAGE__, "->verify: Need a Key" unless 
#     $key = $param{Key};
#     unless ($dgst = $param{Digest}) {
# #        croak __PACKAGE__, "->verify: Need either Message or Digest"
# #            unless $param{Message};
#         $dgst = sha1($param{Message});
#     }
#     #croak __PACKAGE__, "->verify: Need a Signature"
#     #    unless
#     $sig = $param{Signature};
#     my $u2 = mod_inverse($sig->s, $key->q);
#     #print "u2 = $u2\n";
#     my $u1 = bin2mp($dgst);
#     $u1 = ($u1 * $u2) % $key->q;

#     $u2 = ($sig->r * $u2) % $key->q;
#     my $t1 = mod_exp($key->g, $u1, $key->p);
#     my $t2 = mod_exp($key->pub_key, $u2, $key->p);
#     print "pub_key = " . $key->pub_key . "\n";
#     print "u2 = " . $u2 . "\n";
#     print "p = " . $key->p . "\n";
#     print "t2 = $t2\n";
#     $u1 = ($t1 * $t2) % $key->p;
#     $u1 %= $key->q;
#     $u1 == $sig->r;
# }

# print verify(Message => 'nina@blues.org::Nina Simone::1072137320',
# 		   Key => $dsa_key,
# 		   Signature => new Crypt::DSA::Signature(
# 		       r => "179524654873292192810669641349818294463683984472",
# 		       s => "32636895355904099107265678275162258563954033951"))
#     ? "verified\n" : "incorrect\n";

SKIP: {
    my $package = 'Math::Pari';
    eval "use $package qw( PARI )";
    skip("$package not installed: $@", 1) if $@;

    sub mp2bin {
        my($p) = @_;
        $p = PARI($p);
        my $base = PARI(1) << PARI(4*8);
        my $res = '';
        while ($p != 0) {
            my $r = $p % $base;
            $p = ($p-$r) / $base;
            my $buf = pack 'N', $r;
            if ($p == 0) {
                $buf = $r >= 16777216 ? $buf :
                    $r >= 65536 ? substr($buf, -3, 3) :
                    $r >= 256   ? substr($buf, -2, 2) :
                    substr($buf, -1, 1);
            }
            $res = $buf . $res;
        }
        $res;
    }

    my $test = "45625656646468483212118818097681354668381384573545315";
    is(dec2bin($test), mp2bin($test), 'dec2bin');
}
