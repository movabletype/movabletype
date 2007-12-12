# $Id$

use strict;
use MT::Author;
use MT;
use strict;
use MT::Auth;

my $number = 25;

use Test::More tests => 25;

use MT;

use vars qw( $DB_DIR $T_CFG );
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use MT::Test qw(:db :data);

SKIP: {
eval "require Net::LDAP;";
if ($@) {
    skip "Net::LDAP is not installed.", $number;
}
eval "require MT::LDAP;";
if ($@) {
    skip "MT::LDAP is not found.  Did you enable Enterprise Pack?", $number;
}

my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;
if (!MT::ConfigMgr->instance->LDAPUserIdAttribute) {
    print "Set LDAPUserIdAttribute directive or this test will fail.\n";
}
if (!MT::ConfigMgr->instance->LDAPGroupIdAttribute) {
    print "Set LDAPGroupIdAttribute directive or this test will fail.\n";
}

&ldapadd_user(
    name => 'Bob D',
    email => 'bobd@example.com',
    displayName => 'Dylan',
);
my ($entry) = &ldapsearch(
                    filter => '(cn=Bob D)',
                    attrs => [MT::ConfigMgr->instance->LDAPUserIdAttribute]
                );

my $author = MT::Author->load({ name => 'Bob D' });
ok($author);
ok($author->is_active);
$author->external_id($entry->get_value(MT::ConfigMgr->instance->LDAPUserIdAttribute));
$author->save;

&ldapadd_group(
    name => 'Group 1',
    members => [ 'Bob D' ],
);
my ($entry) = &ldapsearch(
                    filter => '(cn=Group 1)',
                    attrs => [MT::ConfigMgr->instance->LDAPGroupIdAttribute]
                );

ok(MT::Auth->synchronize_group);

my $group = MT::Group->load({ name => 'Group 1' }, {cached_ok=>0});
is($group->name, 'Group 1');
ok($group->is_active);
is($group->user_count, 1);
my $iter1 = $group->user_iter();
while (my $user = $iter1->()) {
    is($user->name, $author->name);
    is($user->external_id, $author->external_id);
}

&ldapadd_user(
    name => 'Chuck D',
    email => 'chuckd@example.com',
    displayName => 'Chuck',
);
my ($entry2) = &ldapsearch(
                    filter => '(cn=Chuck D)',
                    attrs => [MT::ConfigMgr->instance->LDAPUserIdAttribute]
                );

my $authorC = MT::Author->load({ name => 'Chuck D' });
ok($authorC);
ok($authorC->is_active);
$authorC->external_id($entry2->get_value(MT::ConfigMgr->instance->LDAPUserIdAttribute));
$authorC->save;

&ldapmodify(
    name => 'Group 1',
    newname => 'New Group',
    newnick => 'Group name modified',
    members => [ 'Bob D', 'Chuck D' ],
);

ok(MT::Auth->synchronize_group);

my $groupX = MT::Group->load({ name => 'Group 1' }, {cached_ok=>0});
ok(!$groupX);
my $group2 = MT::Group->load({ name => 'New Group' }, {cached_ok=>0});
is($group2->name, 'New Group');
ok($group2->is_active);
is($group2->user_count, 2);
my $iter2 = $group->user_iter({}, { sort => 'name' });
my $user2 = $iter2->();
is($user2->name, 'Bob D');
my $user3 = $iter2->();
is($user3->name, 'Chuck D');

&ldapmodify(
    name => 'New Group',
    newname => 'New Group',
    newnick => 'Group name modified',
    members => [ 'Chuck D' ],
);

ok(MT::Auth->synchronize_group);

my $group3 = MT::Group->load({ name => 'New Group' }, {cached_ok=>0});
is($group3->user_count, 1);
my $iter3 = $group3->user_iter({}, { sort => 'name' });
my $user3 = $iter3->();
is($user3->name, 'Chuck D');

&ldapdelete( name => 'New Group' );

ok(MT::Auth->synchronize_group);

my $group4 = MT::Group->load({ name => 'New Group' }, {cached_ok=>0});
ok(!$group4); # We remove groups upon synchronization instead of disabling

&ldapadd_group(
    name => 'New Group',
    members => [ 'Bob D' ],
);

ok(MT::Auth->synchronize_group);

SKIP: {
skip "These can't be run with our intensive caching.", 2;
my $group5 = MT::Group->load({ name => 'New Group' }, {cached_ok=>0});
ok($group5);
ok(!$group5->is_active);  ## make sure newly created group with the same name does not re-activate an group.
}

&ldapdelete( name => 'New Group' );
&ldapdelete( name => 'Bob D' );
&ldapdelete( name => 'Chuck D' );
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
    
use MT::Auth;
use MT::Auth::LDAP;

sub ldapadd_user {
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
                         'sn'   => $opt{name},                         
                         MT::ConfigMgr->instance->LDAPUserFullNameAttribute => $opt{displayName},
                         MT::ConfigMgr->instance->LDAPUserEmailAttribute => $opt{email},
                         'objectclass' => ['top', 'person',
                                           'organizationalPerson',
                                           'inetOrgPerson' ],
                       ]
                     );
    $result->code && warn "failed to add entry: ", $result->error ;
    my $mesg = $ldap->unbind;  # take down session
    1;
}

sub ldapadd_group {
    my (%opt) = @_;
    my $auth = MT::LDAP->new;
    my $ldap = $auth->ldap;
    _ldapbind($auth, $ldap);
    my $base = $auth->{base};
    my $dn = "cn=$opt{name},$base";
    my $cfg = MT::ConfigMgr->instance;
    my $result = $ldap->add( $dn,
                        attr => [
                         $cfg->LDAPGroupNameAttribute => [$opt{name}],
                         $cfg->LDAPGroupMemberAttribute => @{$opt{members}},
                         'objectclass' => ['top', 'posixGroup'],
                         'gidNumber' => int(rand(100)),
                       ]
                     );
    $result->code && warn "failed to add entry: ", $result->error ;
    my $mesg = $ldap->unbind;  # take down session
    1;
}

sub ldapmodify {
    my (%opt) = @_;
    my $auth = MT::LDAP->new;
    my $ldap = $auth->ldap;
    my $cfg = MT::ConfigMgr->instance;
    _ldapbind($auth, $ldap);
    my $base = $auth->{base};
    my $dn = "cn=$opt{name},$base";
    my $mesg = $ldap->moddn( $dn, newrdn => "cn=$opt{newname}" );
    $dn = "cn=$opt{newname},$base";
    my $result = $ldap->modify( $dn,
                        changes => [replace => [
                         $cfg->LDAPGroupNameAttribute => [$opt{newname}],
                         #$cfg->LDAPGroupFullNameAttribute => $opt{newnick},
                         $cfg->LDAPGroupMemberAttribute => $opt{members},
                        ]]
                     );
    $result->code && warn "failed to modify entry: ", $result->error ;
    $mesg = $ldap->unbind;  # take down session
    1;
}

sub ldapdelete {
    my (%opt) = @_;
    my $auth = MT::LDAP->new;
    my $ldap = $auth->ldap;
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
    my $ldap = $auth->ldap;
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
