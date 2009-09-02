# $Id: 51-objectsync.t 3531 2009-03-12 09:11:52Z fumiakiy $
use strict;
my $number = 38;

use Test::More;

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use MT;

use vars qw( $DB_DIR $T_CFG );
use MT::Test;
my $mt = MT->new() or die MT->errstr;

SKIP: {
if ( ! MT->component('enterprise') ) {
    plan skip_all => "Enterprise pack is not installed.";
} else {
    plan tests => $number;
}

eval "require Net::LDAP;";
if ($@) {
    skip "Net::LDAP is not installed.", $number;
}
eval "require MT::LDAP;";
if ($@) {
    skip "MT::LDAP is not found.  Did you enable Enterprise Pack?", $number;
}

if (MT->config->AuthenticationModule ne 'LDAP') {
   skip "AuthenticationModule is not LDAP mode.", $number;
}

require MT::Author;
require MT::Auth;
require MT::LDAP;
MT::Test->import( qw( :db :data ) );

&ldapdelete( name => 'Bob D' );
&ldapdelete( name => 'Axl Rose' );
&ldapdelete( name => 'Chuck D' );
&ldapdelete( name => 'Melody' );

if (!MT->config->LDAPUserIdAttribute) {
    print "Set LDAPUserIdAttribute directive or this test will fail.\n";
}
{
&ldapadd(
    name => 'Bob D',
    email => 'bobd@example.com',
    displayName => 'Dylan',
);
my ($entry) = &ldapsearch(
                    filter => '(cn=Bob D)',
                    attrs => [MT->config->LDAPUserIdAttribute]
                );

my $author = MT::Author->load({ name => 'Bob D' });
ok($author);
ok($author->is_active);
$author->external_id($entry->get_value(MT->config->LDAPUserIdAttribute));
$author->save;

&ldapadd(
    name => 'Chuck D',
    email => 'chuckd@example.com',
    displayName => 'Chuck',
);
my ($entry) = &ldapsearch(
                    filter => '(cn=Chuck D)',
                    attrs => [MT->config->LDAPUserIdAttribute]
                );

my $author0 = MT::Author->load({ name => 'Chuck D' });
ok($author0);
ok($author0->is_active);
$author0->external_id($entry->get_value(MT->config->LDAPUserIdAttribute));
$author0->save;

&ldapadd(
    name => 'Melody',
    email => 'm@example.com',
    displayName => 'Melody Nelson',
);
my ($entry) = &ldapsearch(
                    filter => '(cn=Melody)',
                    attrs => [MT->config->LDAPUserIdAttribute]
                );

my $author00 = MT::Author->load({ name => 'Melody' });
ok($author00);
ok($author00->is_active);
$author00->external_id($entry->get_value(MT->config->LDAPUserIdAttribute));
$author00->save;

ok(0 == MT::Auth->synchronize); # nobody will be synched-updated at this point

my $author2 = MT::Author->load({ name => 'Bob D' }, {cached_ok=>0});
is($author->id, $author2->id);
is($author->name, $author2->name);
is($author->email, $author2->email);
is($author->nickname, $author2->nickname);
is($author->type, $author2->type);
ok($author2->is_active);

&ldapmodify(
    name => 'Bob D',
    newname => 'Axl Rose',
    newemail => 'axl@example.com',
    newnick => 'William Axl Rose'
);

is(MT::Auth->synchronize, 1);

my $authorX = MT::Author->load({ name => 'Bob D' }, {cached_ok=>0});
ok(!$authorX);
my $author3 = MT::Author->load({ name => 'Axl Rose' }, {cached_ok=>0});
ok($author3);
is($author2->id, $author3->id);
is('Axl Rose', $author3->name);
is($author2->email, $author3->email);
is($author2->nickname, $author3->nickname);
is($author3->type, $author2->type);
ok($author3->is_active);

&ldapmodrdn(
    name => 'Axl Rose',
    newsuperior => 'ou=MT',
);

my $cfg = MT->config;
my $ldapurl = $cfg->LDAPAuthURL;

## typo will not make users inactive
$cfg->LDAPAuthURL('ldap://trac.sixapart.jp/dc=typo,dc=sixapart,dc=jp');

ok(!MT::Auth->synchronize);

my $author4 = MT::Author->load({ name => 'Axl Rose' }, {cached_ok=>0});
ok($author4->is_active);
is($author4->external_id, $author3->external_id);

my $author6 = MT::Author->load({ name => 'Chuck D' }, {cached_ok=>0});
ok($author6->is_active);
my $author7 = MT::Author->load({ name => 'Melody' }, {cached_ok=>0});
ok($author7->is_active);

## typo(but some users do exist in the directory) will not make users inactive
## unless there is at lease one sysadmin in the (wrong) hierarchy
my $wrong_url = $ldapurl;
$wrong_url =~ s!(ldap://.+)/(.+)!$1/ou=MT,$2!;
$cfg->LDAPAuthURL($wrong_url);

ok(!MT::Auth->synchronize);

my $author8 = MT::Author->load({ name => 'Axl Rose' }, {cached_ok=>0});
ok($author8->is_active);
is($author8->external_id, $author3->external_id);

my $author9 = MT::Author->load({ name => 'Chuck D' }, {cached_ok=>0});
ok($author9->is_active);
my $author10 = MT::Author->load({ name => 'Melody' }, {cached_ok=>0});
ok($author10->is_active);

&ldapmodrdn( name => 'Axl Rose' );

$cfg->LDAPAuthURL($ldapurl);

&ldapdelete( name => 'Axl Rose' );

ok(MT::Auth->synchronize);

my $author11 = MT::Author->load({ name => 'Axl Rose' }, {cached_ok=>0});
ok(!$author11->is_active);
is($author11->external_id, $author3->external_id);

&ldapadd(
    name => 'Axl Rose',
    email => 'axl@example.com',
    displayName => 'William Axl Rose',
);

ok(0 == MT::Auth->synchronize);  ## this time it does not sync anyone -- synchronize returns 0

my $author5 = MT::Author->load({ name => 'Axl Rose' }, {cached_ok=>0});
ok($author5);
ok(!$author5->is_active);  ## make sure newly created user with the same name does not re-activate an author.

&ldapdelete( name => 'Axl Rose' );
&ldapdelete( name => 'Chuck D' );
&ldapdelete( name => 'Melody' );
}

} # end of SKIP block

sub _ldapbind {
    my ($auth, $ldap) = @_;
    my $res;
    my $base = $auth->{base};
    my $bind_dn = $auth->{bind_dn};
    my $bind_password = $auth->{bind_password};
    my $sasl_mechanism = $auth->{sasl_mechanism};
    my $uid_attr_name = $auth->{uid_attr_name};
    my $filter = $auth->{filter};
    my $scope = $auth->{scope};
    if (!$bind_dn) {
        $res = $ldap->bind;
    } else {
        if ($sasl_mechanism eq 'PLAIN') {
            $res = $ldap->bind($bind_dn, password => $bind_password);
        } else {
            require Authen::SASL;
            my $sasl = Authen::SASL->new(
                mechanism => $sasl_mechanism,
                callback => {
                    pass => $bind_password,
                    user => $bind_dn,
                },
            );
            $res = $ldap->bind($bind_dn, sasl => $sasl);
        }
    }
    1;
}
    
sub ldapadd {
    my (%opt) = @_;
    my $auth = MT::LDAP->new;
    my $ldap = $auth->ldap;
    _ldapbind($auth, $ldap);
    my $base = $auth->{base};
    my $dn = "cn=$opt{name},$base";
    my $result = $ldap->add( $dn,
                        attr => [
                         $auth->{uid_attr_name} => [$opt{name}],
                         'cn'   => [$opt{name}],
                         'sn'   => $opt{displayName},                         
                         MT->config->LDAPUserEmailAttribute => $opt{email},
                         'objectclass' => ['top', 'person',
                                           'organizationalPerson',
                                           'inetOrgPerson' ],
                       ]
                     );
    $result->code && warn "failed to add entry: ", $result->error ;
    my $mesg = $ldap->unbind;  # take down session
    1;
}

sub ldapmodrdn {
    my (%opt) = @_;
    my $auth = MT::LDAP->new;
    my $ldap = $auth->{ldap};
    _ldapbind($auth, $ldap);
    my $base = $auth->{base};
    my $dn = "cn=$opt{name},$base";
    my %param;
    $param{newrdn} = "cn=$opt{name}";
    if (exists $opt{newsuperior}) {
        $param{newsuperior} = "$opt{newsuperior},$base";
    } else {
        my $new = $base;
        $new =~ s!([^,]+),(.+)!$2!;
        $param{newsuperior} = $new;
    }
    my $result = $ldap->moddn( $dn, %param );
    $result->code && warn "failed to change rdn of the entry: ", $result->error ;
    $result = $ldap->unbind;  # take down session
    1;
}

sub ldapmodify {
    my (%opt) = @_;
    my $auth = MT::LDAP->new;
    my $ldap = $auth->{ldap};
    _ldapbind($auth, $ldap);
    my $base = $auth->{base};
    my $dn = "cn=$opt{name},$base";
    my $result = $ldap->moddn( $dn, newrdn => "cn=$opt{newname}", deleteoldrdn => 1 );
    warn $result->error if $result->code;
    $dn = "cn=$opt{newname},$base";
    $result = $ldap->modify( $dn,
                        changes => [replace => [
                         $auth->{uid_attr_name} => [$opt{newname}],
                         'cn'   => $opt{newname},
                         'sn'   => $opt{newname},                         
                         MT->config->LDAPUserEmailAttribute => $opt{newemail},
                        ] ]
                     );
    $result->code && warn "failed to modify entry $opt{name} -> $opt{newname}: ", $result->error ;
    $result = $ldap->unbind;  # take down session
    1;
}

sub ldapdelete {
    my (%opt) = @_;
    my $auth = MT::LDAP->new;
    my $ldap = $auth->{ldap};
    _ldapbind($auth, $ldap);
    my $base = $auth->{base};
    my $dn = "cn=$opt{name},$base";
    my $result = $ldap->delete($dn);
    $result->code && warn "failed to delete entry: ", $result->error ;
    my $mesg = $ldap->unbind;  # take down session
    1;
}

sub ldapsearch {
    my (%opt) = @_;
    my $auth = MT::LDAP->new;
    my $ldap = $auth->{ldap};
    _ldapbind($auth, $ldap);
    my $base = $auth->{base};
    my $res = $ldap->search( 
        base => $base,
        filter => $opt{filter},
        attrs => $opt{attrs},
    );
    $res->entries;
}

1;
