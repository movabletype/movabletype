# $Id: 52-ldap.t 2680 2008-07-02 22:21:31Z bchoate $

use strict;
my $number = 15;

use Test::More;

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use MT;
use vars qw( $DB_DIR $T_CFG );
use MT::Test;

my $mt = MT->instance or die MT->errstr;
SKIP: {
if ( !$mt->component('enterprise') ) {
    plan skip_all => "Enterprise pack is not installed";
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
{
# @test create MT object
MT::Test->import( qw(:db :data) );

ok($mt);

# @test create MT::LDAP object
my $ldap = MT::LDAP->new;
ok($ldap);

$ldap->bind_ldap;

my $filter = '(uid=Bob)';
my $attrs = [
               'cn',
               'mail',
               'displayName',
               MT->config->LDAPUserIdAttribute
            ];

# @test search unavailable user
my @ldap_entries = $ldap->search_ldap(
                            filter => $filter,
                            attrs => $attrs);

is($#ldap_entries, 0);

&ldapadd(
    name => 'Bob D',
    email => 'bobd@example.com',
    displayName => 'Dylan',
    uid => 'Bob',
);

# @test search available user
@ldap_entries = $ldap->search_ldap(
                        filter => $filter,
                        attrs => $attrs);

is(@ldap_entries, 1);

# @test valid login
my $res = $ldap->can_login(
    'cn=Bob D,'.$ldap->{base},
    'Bob',
    'password');
ok($res);


# @test invalid login (password invalid)
my $res = $ldap->can_login(
    'cn=Bob D,'.$ldap->{base},
    'Bob',
    'bob');
ok(!$res);


# @test get user dn
my $dn = $ldap->get_dn('Bob');
is($dn, 'cn=Bob D,'.$ldap->{base});

# @test user attribute validation
my $entry = $ldap->get_entry_by_name('Bob', $attrs);

ok($entry);
is($entry->get_value('cn'), 'Bob D');
is($entry->get_value('mail'), 'bobd@example.com');
is($entry->get_value('displayName'), 'Dylan');

my $uuid = $entry->get_value(MT->config->LDAPUserIdAttribute);

# @test user attribute validation
$entry = $ldap->get_entry_by_uuid($uuid, $attrs);

ok($entry);
is($entry->get_value('cn'), 'Bob D');
is($entry->get_value('mail'), 'bobd@example.com');
is($entry->get_value('displayName'), 'Dylan');


$ldap->unbind_ldap;

&ldapdelete( name => 'Bob D' );
}

} # end of skip block

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
    my $ldap = $auth->{ldap};
    _ldapbind($auth, $ldap);
    my $base = $auth->{base};
    my $dn = "cn=$opt{name},$base";
    my $result = $ldap->add( $dn,
                        attr => [
                         $auth->{uid_attr_name} => [$opt{name}],
                         'cn'   => [$opt{name}],
                         'sn'   => $opt{name},
                         'uid'  => $opt{uid},
                         #'userPassword' => ["{CRYPT}kVY9KP1SHbGN2"],
                         'userPassword' => ["{SSHA}P3KrGHWOjo/b+haSXBGGHtJjonkeLgDt"],
                         MT->config->LDAPUserFullNameAttribute => $opt{displayName},
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

1;
