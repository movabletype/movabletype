# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Author;
use strict;

use MT::Object;
@MT::Author::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'name' => 'string(50) not null',
        'nickname' => 'string(50)',
        'password' => 'string(60) not null',
        'type' => 'smallint not null',
        'email' => 'string(75)',
        'url' => 'string(255)',
        'can_create_blog' => 'boolean',
        'is_superuser' => 'boolean',
        'hint' => 'string(75)',
        'can_view_log' => 'boolean',
        'public_key' => 'text',
        'preferred_language' => 'string(50)',
        'api_password' => 'string(60)',
        'remote_auth_username' => 'string(50)',
        'remote_auth_token' => 'string(50)',
        'entry_prefs' => 'string(255)',
    },
    defaults => {
        type => 1
    },
    indexes => {
        created_on => 1,
        name => 1,
        email => 1,
        type => 1,
    },
    datasource => 'author',
    primary_key => 'id',
    audit => 1,
});

# Valid "type" codes:
use constant AUTHOR => 1;
use constant COMMENTER => 2;

use constant APPROVED => 1;
use constant BANNED => 2;
use constant BLOCKED => 2; # alias for BANNED for backward compatibility
use constant PENDING => 3;

use Exporter;
*import = \&Exporter::import;
use vars qw(@EXPORT_OK %EXPORT_TAGS);
@EXPORT_OK = qw(AUTHOR COMMENTER APPROVED BANNED PENDING);
%EXPORT_TAGS = (constants => [qw(AUTHOR COMMENTER APPROVED BANNED PENDING)]);

sub remove_sessions {
    my $auth = shift;
    require MT::Session;
    my @sess = MT::Session->load({ id => $auth->id, kind => 'US' });
    $_->remove foreach @sess;
}

sub session {
    die "This was removed";        # FIXME: this is to catch mistakes
}

sub magic_token {
    die "there is no magic_token"; # FIXME: this is to catch mistakes
}

sub set_password {
    my $auth = shift;
    my($pass) = @_;
    my @alpha = ('a'..'z', 'A'..'Z', 0..9);
    my $salt = join '', map $alpha[rand @alpha], 1..2;
    $auth->column('password', crypt $pass, $salt);
}

sub is_valid_password {
    my $auth = shift;
    my($pass, $crypted) = @_;
    $pass ||= '';
    my $real_pass = $auth->column('password');
    return $crypted ? $real_pass eq $pass :
                      crypt($pass, $real_pass) eq $real_pass;
}

sub is_email_hidden {
    my $auth = shift;
    return ($auth->email =~ /^[0-9a-f]{40}$/i) ? 1 : 0;
}

# The two permissions can_comment and can_not_comment form the
# three-state "status" variable:
# can_comment   can_not_comment | status
#    0             0            | pending
#    1             0            | approved
#    0             1            | banned

# Existing comments of a user are made visible only if the 
# user is coming from "pending" status.

sub set_commenter_perm {
    my $this = shift;
    my ($blog_id, $action) = @_;
    return $this->error(MT->translate("Can't approve/ban non-COMMENTER author"))
        if ($this->type ne COMMENTER);

    require MT::Permission;
    my %perm_spec = (
        author_id => $this->id(),
        blog_id => $blog_id
    );
    my $perm = MT::Permission->load(\%perm_spec);
    if (!$perm) {
        $perm = MT::Permission->new();
        $perm->set_values(\%perm_spec);
    }
    my $was_pending = !$perm->can_comment() && !$perm->can_not_comment();
    if ($action eq 'approve') {
        $perm->can_comment(1);
        $perm->can_not_comment(0);
    } elsif (($action eq 'ban') || ($action eq 'block')) {
        $perm->can_not_comment(1);
        $perm->can_comment(0);
    } elsif ($action eq 'pending') {
        return if $was_pending && $perm->id; # no need to resave here
        $perm->can_not_comment(0);
        $perm->can_comment(0);
    }
    $perm->save()
        or return $this->error(MT->translate("The approval could not be committed: [_1]", $perm->errstr));

    return 1;
}

sub status {
    my $this = shift;
    my ($blog_id) = @_;
    # TBD: cache the permission record FIXME
    require MT::Permission;
    my $perm = MT::Permission->load({author_id=>$this->id, blog_id=>$blog_id});
    return PENDING if !$perm;
    return BANNED if $perm->can_not_comment();
    return APPROVED if $perm->can_comment();
    return PENDING;
}

sub is_trusted { shift->status(@_) == APPROVED; }
sub is_banned { shift->status(@_) == BANNED; }
*is_blocked = \&is_banned;
sub is_not_trusted { shift->status(@_) == PENDING; }
*is_untrusted = \&is_not_trusted;

sub approve {
    my $this = shift;
    my ($blog_id) = @_;
    $this->set_commenter_perm($blog_id, 'approve');
}

*trust = \&approve;

sub pending {
    $_[0]->set_commenter_perm($_[1], 'pending');
}

sub ban {
    my $this = shift;
    my ($blog_id) = @_;
    $this->set_commenter_perm($blog_id, 'ban');
}
*block = \&ban;

sub save {
    my $auth = shift;

    if ((!$auth->id) && ($auth->type == AUTHOR)) {
        # New author, undefined API password. Generate one.
        if (!defined $auth->api_password) {
            my @pool = ('a'..'z', 0..9);
            my $pass = '';
            for (1..8) { $pass .= $pool[ rand @pool ] }
            $auth->api_password($pass);
        }
    }

    $auth->SUPER::save(@_);
}

sub remove {
    my $auth = shift;
    require MT::Permission;
    ## We need to loop twice over the permissions: first gather, then
    ## remove, so as not to throw our gathering out of whack by removing
    ## while we gather. :)
    my $iter = MT::Permission->load_iter({ author_id => $auth->id });
    my @perms;
    while (my $perms = $iter->()) {
        push @perms, $perms;
    }
    ## The iterator is finished, so we can safely remove.
    for my $perms (@perms) {
        $perms->remove;
    }
    $auth->SUPER::remove;
}

sub blog_perm {
    my $author = shift;
    my $blog_id = shift;
    my $cache = "__perm-" . $blog_id;
    return $author->{$cache} if $author->{$cache};
    my $perm = MT::Permission->load({author_id => $author->id,
                                     blog_id => $blog_id});
    if (!$perm) {
        # Return a fictional permission object; can be queried using
        # same interface
        $perm = MT::Permission->new();
        $perm->author_id($author->id);
        $perm->blog_id($blog_id);
        if ($author->is_superuser) {
            $perm->set_full_permissions();
        } else {
            $perm->role_mask(0);
        }
    }
    return $author->{$cache} = $perm;
}

sub can_edit_entry {
    my $author = shift;
    die unless $author->isa('MT::Author');
    my($entry) = @_;
    unless (ref $entry) {
        require MT::Entry;
        $entry = MT::Entry->load($entry, {cached_ok=>1});
    }
    die unless $entry->isa('MT::Entry');
    my $perms = $author->blog_perm($entry->blog_id);
    die unless $perms->isa('MT::Permission');
    $perms->can_edit_all_posts ||
    ($perms->can_post && $entry->author_id == $author->id);
}

sub can_create_blog {
    my $author = shift;
    $author->is_superuser() || $author->SUPER::can_create_blog(@_);
}

sub can_view_log {
    my $author = shift;
    $author->is_superuser() || $author->SUPER::can_view_log(@_);
}

    # Get the permission records for these two authors that share a blog_id
    # and for which "this" has the can_administer_blog flag.
    # A mythical SQL query for this:
#       select this.blog_id from mt_permission this, mt_permission other
#        where this.author_id = ? and other.author_id = ?
#          and this.blog_id = other.blog_id
#          and this.role_mask & 4096;

sub common_blogs { # returns the blogs in the form of permission records of $this
    my ($this, $other) = @_;
    require MT::Permission;
    my @this_perms = MT::Permission->load({author_id => $this->id});
    my @other_perms = MT::Permission->load({author_id => $other->id});
    my @shared_perms; # will accumulate perms of "this" that pertain to a blog of "other"
    for my $p (@other_perms) {
        push @shared_perms, grep { $_->blog_id == $p->blog_id } @this_perms;
    }
    @shared_perms;
}

sub can_administer {
    my ($this, $other) = @_;
    return grep {$_->can_administer_blog} $this->common_blogs($other);
}

sub entry_prefs {
    my $author = shift;
    my @prefs = split /,/, ($author->column('entry_prefs') || '');
    my %prefs;
    foreach (@prefs) {
        my ($name, $value) = split /=/, $_, 2;
        $prefs{$name} = $value;
    }
    if (@_) {
        %prefs = (%prefs, @_);
        my $pref = '';
        foreach (keys %prefs) {
            $pref .= ',' if $pref ne '';
            $pref .= $_ . '=' . $prefs{$_};
        }
        $author->column('entry_prefs', $pref);
    }

    # default assignments for author entry preferences
    $prefs{tag_delim} ||= ord(',');

    \%prefs;
}

1;
__END__

=head1 NAME

MT::Author - Movable Type author record

=head1 SYNOPSIS

    use MT::Author;
    my $author = MT::Author->new;
    $author->name('Foo Bar');
    $author->set_password('secret');
    $author->save
        or die $author->errstr;

    my $author = MT::Author->load($author_id);

=head1 DESCRIPTION

An I<MT::Author> object represents a user in the Movable Type system. It
contains profile information (name, nickname, email address, etc.), global
permissions settings (blog creation, activity log viewing), and authentication
information (password, public key). It does not contain any per-blog
permissions settings--for those, look at the I<MT::Permission> object.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Author> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

The following methods are unique to the I<MT::Author> interface:

=head2 $author->set_password($pass)

One-way encrypts I<$pass> with a randomly-generated salt, using the Unix
I<crypt> function, and sets the I<password> data field in the I<MT::Author>
object I<$author>.

Because the password is one-way encrypted, there is B<no way> of recovering
the initial password.

=head2 $author->is_valid_password($check_pass)

Tests whether I<$check_pass> is a valid password for the I<MT::Author> object
I<$author> (ie, whether it matches the password originally set using
I<set_password>). This check is done by one-way encrypting I<$check_pass>,
using the same salt used to encrypt the original password, then comparing the
two encrypted strings for equality.

=head1 DATA ACCESS METHODS

The I<MT::Author> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the author.

=item * name

The username of the author. This is the username used to log in to the system.

=item * nickname

The author nickname. This is not displayed anywhere in the system unless you
use a C<E<lt>$MTEntryAuthorNickname$E<gt>> tag.

=item * password

The author's password, one-way encrypted. If you wish to check the validity of
a password, you should use the I<is_valid_password> method, above.

=item * email

The author's email address.

=item * url

The author's homepage URL.

=item * hint

The answer to the question used when recovering the user's password. Currently
this is the birthplace of the author, though this may change in the future.

=item * can_create_blog

A boolean flag specifying whether the author has permission to create a new
blog in the system.

=item * can_view_log

A boolean flag specifying whether the author has permission to view the global
system activity log.

=item * created_by

The author ID of the author who created this author. For the initial author
created by the F<mt-load.cgi> program, this author ID is undefined.

=item * public_key

The author's ASCII-armoured public key, to be used in the future for verifying
incoming email messages.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * name

=item * email

=back

=head1 NOTES

=over 4

=item *

When you remove an author using I<MT::Author::remove>, in addition to removing
the author record, all of the author's permissions (I<MT::Permission> objects)
will be removed, as well.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
