# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Author;

use strict;
use base qw( MT::Object MT::Scorable );

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'name' => 'string(255) not null',
        'nickname' => 'string(255)',
        'password' => 'string(60) not null',
        'type' => 'smallint not null',
        'email' => 'string(75)',
        'url' => 'string(255)',
        'public_key' => 'text',
        'preferred_language' => 'string(50)',
        'api_password' => 'string(60)',
        'remote_auth_username' => 'string(50)',
        'remote_auth_token' => 'string(50)',
        'entry_prefs' => 'string(255)',
        'text_format' => 'string(30)',
        'status' => 'integer',
        'external_id' => 'string(255)',
        #'last_login' => 'datetime',

        # deprecated; permissions are in MT::Permission only now
        'can_create_blog' => 'boolean',
        'is_superuser' => 'boolean',
        'can_view_log' => 'boolean',
        'auth_type' => 'string(50)',
        'userpic_asset_id' => 'integer',
        'basename' => 'string(255)',

        # Deprecated; The hint is not used from 4.25 in the password recovery
        'hint' => 'string(75)',

        # meta properties
        'widgets' => 'hash meta',
        'favorite_blogs' => 'array meta',
        'password_reset' => 'string meta',
        'password_reset_expires' => 'string meta',
        'password_reset_return_to' => 'string meta',
    },
    defaults => {
        type => 1,
        status => 1,
    },
    indexes => {
        created_on => 1,
        name => 1,
        email => 1,
        type => 1,
        status => 1,
        external_id => 1,
        auth_type_name => {
            columns => ['auth_type', 'name', 'type'],
        },
        basename => 1,
    },
    meta => 1,
    child_classes => ['MT::Permission', 'MT::Association'],
    datasource => 'author',
    primary_key => 'id',
    audit => 1,
});

sub class_label {
    MT->translate("User");
}

sub class_label_plural {
    MT->translate("Users");
}

# Valid "type" codes:
sub AUTHOR ()    { 1 }
sub COMMENTER () { 2 }

# Commenter statuses
sub APPROVED () { 1 }
sub BANNED ()   { 2 }
sub BLOCKED ()  { 2 }  # alias for BANNED for backward compatibility
sub PENDING ()  { 3 }

# Author statuses
sub ACTIVE ()   { 1 }
sub INACTIVE () { 2 }
#use constant PENDING => 3; # there *is* PENDING status for authors but it's the same name and value.

use Exporter;
*import = \&Exporter::import;
use vars qw(@EXPORT_OK %EXPORT_TAGS);
@EXPORT_OK = qw(AUTHOR COMMENTER ACTIVE INACTIVE APPROVED BANNED PENDING);
%EXPORT_TAGS = (constants => [qw(AUTHOR COMMENTER ACTIVE INACTIVE APPROVED BANNED PENDING)]);

sub set_defaults {
    my $auth = shift;
    my $cfg = MT->config;
    $auth->SUPER::set_defaults(@_);
    $auth->preferred_language($cfg->DefaultUserLanguage || $cfg->DefaultLanguage);
}

sub remove_sessions {
    my $auth = shift;
    require MT::Session;
    my $sess_iter = MT::Session->load_iter({ kind => 'US' });
    my @sess;
    while (my $sess = $sess_iter->()) {
        my $id = $sess->get('author_id');
        next unless $id == $auth->id;
        push @sess, $sess;
    }
    $_->remove foreach @sess;
}

sub set_password {
    my $auth = shift;
    my($pass) = @_;
    my @alpha = ('a'..'z', 'A'..'Z', 0..9);
    my $salt = join '', map $alpha[rand @alpha], 1..2;
    # FIXME: use something besides 'crypt'
    $auth->column('password', crypt $pass, $salt);
}

sub is_valid_password {
    my $author = shift;
    my($pass, $crypted, $error_ref) = @_;
    $pass ||= '';
    require MT::Auth;
    return MT::Auth->is_valid_password($author, $pass, $crypted, $error_ref);
}

sub is_email_hidden {
    my $auth = shift;
    return 1 unless $auth->email =~ m/@/;
    return ($auth->email =~ /^[0-9a-f]{40}$/i) ? 1 : 0;
}

# Existing comments of a user are made visible only if the 
# user is coming from "pending" status.

sub set_commenter_perm {
    my $this = shift;
    my ($blog_id, $action) = @_;

    if ( MT->config->SingleCommunity ) {
        $blog_id = 0;
    }

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
    if ($action eq 'approve') {
        $perm->remove_restrictions('comment');
        $perm->can_comment(1);
    } elsif (($action eq 'ban') || ($action eq 'block')) {
        $perm->set_these_restrictions('comment');
        $perm->can_comment(0);
    } elsif ($action eq 'pending') {
        $perm->remove_restrictions('comment');
        $perm->can_comment(0);
    }
    $perm->save()
        or return $this->error(MT->translate("The approval could not be committed: [_1]", $perm->errstr));

    return 1;
}

sub commenter_status {
    my $this = shift;
    return APPROVED if $this->is_superuser;
    my ($blog_id) = @_;

    if ( MT->config->SingleCommunity ) {
        $blog_id = 0;
    }

    require MT::Permission;
    my $perm = MT::Permission->load(
        { author_id => $this->id, blog_id => $blog_id } );
    return PENDING if !$perm;
    return BANNED if $perm->is_restricted('comment');
    return APPROVED if $perm->can_comment() || $perm->can_manage_feedback();
    return PENDING;
}

sub is_active { shift->status() == ACTIVE; }
sub is_trusted { shift->commenter_status(@_) == APPROVED; }
sub is_banned { shift->commenter_status(@_) == BANNED; }
*is_blocked = \&is_banned;
sub is_not_trusted { shift->commenter_status(@_) == PENDING; }
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

    if ($auth->type == AUTHOR) {
        if (!$auth->id) {
            # New author, undefined API password. Generate one.
            if (!defined $auth->api_password) {
                my @pool = ('a'..'z', 0..9);
                my $pass = '';
                for (1..8) { $pass .= $pool[ rand @pool ] }
                $auth->api_password($pass);
            }
        }
        # Generate basename
        unless ($auth->basename()) {
            my $basename = MT::Util::make_unique_author_basename($auth);
            $auth->basename($basename);
        }
    }

    my $privs;
    if (exists $auth->permissions(0)->{changed_cols}->{permissions}) {
         $privs = $auth->permissions(0)->permissions;
    }
    # delete new user's privilege from cache
    delete MT::Request->instance->{__stash}->{'__perm_author_'} unless $auth->id;
    $auth->SUPER::save(@_) or return $auth->error($auth->errstr);
    if (defined $privs) {
        my $perm = $auth->permissions(0);
        $perm->permissions($privs);
        $perm->save or return $auth->error("Error saving permission: " . $perm->errstr);
    }
    1;
}

sub remove {
    my $auth = shift;
    $auth->remove_sessions if ref $auth;
    $auth->remove_children({ key => 'author_id' }) or return;
    $auth->SUPER::remove(@_);
}

sub can_edit_entry {
    my $author = shift;
    die unless $author->isa('MT::Author');
    return 1 if $author->is_superuser();
    my($entry) = @_;
    unless (ref $entry) {
        require MT::Entry;
        $entry = MT::Entry->load($entry);
    }
    die if !$entry || !$entry->isa('MT::Entry');
    my $perms = $author->permissions($entry->blog_id);
    die unless $perms->isa('MT::Permission');
    $perms->can_edit_all_posts ||
        ($perms->can_create_post && $entry->author_id == $author->id);
}

sub is_superuser {
    my $author = shift;
    if (@_) {
        $author->permissions(0)->can_administer(@_);
        if ($_[0]) {
            $author->permissions(0)->can_create_blog(@_);
            $author->permissions(0)->can_view_log(@_);
            $author->permissions(0)->can_manage_plugins(@_);
            $author->permissions(0)->can_edit_templates(@_);
        }
    } else {
        $author->permissions(0)->can_administer() ||
            $author->SUPER::is_superuser();
    }
}

sub can_create_blog {
    my $author = shift;
    if (@_) {
        $author->permissions(0)->can_create_blog(@_);
    } else {
        $author->is_superuser() ||
            $author->permissions(0)->can_create_blog(@_);
    }
}

sub can_view_log {
    my $author = shift;
    if (@_) {
        $author->permissions(0)->can_view_log(@_);
    } else {
        $author->is_superuser() ||
            $author->permissions(0)->can_view_log(@_);
    }
}

sub can_manage_plugins {
    my $author = shift;
    if (@_) {
        $author->permissions(0)->can_manage_plugins(@_);
    } else {
        $author->is_superuser() ||
            $author->permissions(0)->can_manage_plugins(@_);
    }
}

sub can_edit_templates {
    my $author = shift;
    if (@_) {
        $author->permissions(0)->can_edit_templates(@_);
    } else {
        $author->is_superuser() ||
            $author->permissions(0)->can_edit_templates(@_);
    }
}

sub blog_perm {
    my $author = shift;
    my ($blog_id) = @_;
    $author->permissions($blog_id);
}

sub permissions {
    my $author = shift;
    my ($obj) = @_;
    my $blog_id = $obj;

    my $terms = { author_id => $author->id };
    my $cache_key = "__perm_author_" . (defined($author->id) ? $author->id : q());
    if ($obj) {
        if ((ref $obj) && $obj->isa('MT::Blog')) {
            $blog_id = $obj->id;
        } elsif ($obj) {
            $blog_id = $obj;
            require MT::Blog;
            $obj = MT::Blog->load($blog_id);
        }
        $cache_key .= "_blog_$blog_id";
        $terms->{blog_id} = [ 0, $blog_id ];
    } else {
        $terms->{blog_id} = 0;
    }

    require MT::Request;
    my $r = MT::Request->instance;
    my $p = $r->stash($cache_key);
    return $p if $p;

    require MT::Permission;
    my @perm = MT::Permission->load($terms);
    my $perm;
    if ($obj) {
        if (@perm == 2) {
            if (!$perm[0]->blog_id) {
                @perm = reverse @perm;
            }
            ($perm, my $sys_perm) = @perm;
            $perm->add_permissions($sys_perm);
        } elsif (@perm == 1) {
            $perm = $perm[0];
            if (!$perm->blog_id) {
                $perm->blog_id($obj->id);
                delete $perm->{column_values}{blog_id};
                delete $perm->{changed_cols}{blog_id};
            }
        } elsif (@perm > 2) {
            # Condition sometimes caused by saving preferences. BugId:79501
            # Handle by merging permissions and removing all but one
            # Not ideal, but better than dying...
            my ($sys_perm) = grep { ! $_->blog_id } @perm;
            my @blog_perms = grep { $_->blog_id } sort { $b->modified_on cmp $a->modified_on } @perm;

            my $new_perm = shift @blog_perms; # take last one saved
            if (@blog_perms) {
                foreach my $more_perms (@blog_perms) {
                    $new_perm->add_permissions($more_perms);
                    $new_perm->add_restrictions($more_perms);
                    $more_perms->remove;
                }
                # save merged permission record
                $new_perm->save;
            }
            $new_perm->add_permissions($sys_perm);
            $new_perm->add_restrictions($sys_perm);
            $perm = $new_perm;
            @perm = ($perm);
        }
    } else {
        $perm = $perm[0] if @perm;
    }
    unless (@perm) {
        if ($blog_id || !@_) {
            if ($author->is_superuser()) {
                $perm = new MT::Permission;
                $perm->author_id($author->id);
                $perm->set_full_permissions;
            }
        }
    }
    unless ($perm) {
        $perm = new MT::Permission;
        $perm->author_id($author->id);
        $perm->clear_full_permissions;
    }
    $r->stash($cache_key, $perm);
    $perm;
}

sub common_blogs { # returns the blogs in the form of permission records of $this
    die "This was removed";        # FIXME: this is to catch mistakes
}
sub can_administer {
    die "This was removed";        # FIXME: this is to catch mistakes
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
    $prefs{tag_delim} ||= MT->config->DefaultUserTagDelimiter;

    \%prefs;
}

sub role_iter {
    my $author = shift;
    my ($terms, $args) = @_;
    require MT::Association;
    require MT::Role;
    my $blog_id = delete $terms->{blog_id};
    my $type;
    if ($blog_id) {
        $type = MT::Association::USER_BLOG_ROLE();
    } else {
        $type = MT::Association::USER_ROLE();
    }
    $args->{join} = MT::Association->join_on('role_id', {
        type => $type,
        author_id => $author->id,
        $blog_id ? (blog_id => $blog_id) : (blog_id => 0),
    });
    MT::Role->load_iter($terms, $args);
}

sub blog_iter {
    my $author = shift;
    my ($terms, $args) = @_;
    my $perm = $author->permissions;
    if (!$author->is_superuser) {
        require MT::Permission;
        $args->{join} = MT::Permission->join_on('blog_id', {
            author_id => $author->id,
        });
    }
    require MT::Blog;
    my $i = MT::Blog->load_iter($terms, $args);
}

sub group_iter {
    my $author = shift;
    my ($terms, $args) = @_;
    my $grp_class = MT->model('group') or return undef;
    require MT::Association;
    $args->{join} = MT::Association->join_on('group_id', {
        type => MT::Association::USER_GROUP(),
        author_id => $author->id,
    });
    return $grp_class->load_iter($terms, $args);
}

sub group_role_iter {
    my $author = shift;
    my ($terms, $args) = @_;

    my $grp_class = MT->model('group')
        or return undef;
    my @iters;
    require MT::Association;
    require MT::Role;
    my $blog_id = delete $terms->{blog_id};
    $args->{join} = MT::Association->join_on('role_id', {
        type => $blog_id ? MT::Association::USER_BLOG_ROLE() : MT::Association::USER_ROLE(),
        author_id => $author->id,
        $blog_id ? (blog_id => $blog_id) : (),
    });
    my $user_iter = MT::Role->load_iter($terms, $args);
    push @iters, $user_iter if $user_iter;

    my @groups;
    if (my $group_iter = $author->group_iter({ status => MT::Group::ACTIVE() })) {
        while (my $g = $group_iter->()) {
            push @groups, $g->id;
        }
    }
    if (@groups) {
        $args->{join} = MT::Association->join_on('role_id', {
            type => $blog_id ? MT::Association::GROUP_BLOG_ROLE() : MT::Association::GROUP_ROLE(),
            group_id => \@groups,
            $blog_id ? (blog_id => $blog_id) : (),
        });
        my $group_iter = MT::Role->load_iter($terms, $args);
        push @iters, $group_iter if $group_iter;
    }
    MT::Util::multi_iter(\@iters);
}

sub add_role {
    my $author = shift;
    my ($role, $blog) = @_;
    $author->save unless $author->id;
    $role->save unless $role->id;
    $blog->save if $blog && !$blog->id;
    require MT::Association;
    MT::Association->link($author, @_);
}

sub add_group {
    my $author = shift;
    my ($group) = @_;
    $author->save unless $author->id;
    $group->save unless $group->id;
    require MT::Association;
    MT::Association->link($author, @_);
}

sub remove_role {
    my $author = shift;
    require MT::Association;
    MT::Association->unlink($author, @_);
}

sub remove_group {
    my $author = shift;
    require MT::Association;
    MT::Association->unlink($author, @_);
}

sub add_default_roles {
    my $author = shift;
    my $def = MT->config->DefaultAssignments;
    return unless $def;

    my $blog_class = MT->model('blog');
    my $role_class = MT->model('role');

    require MT::Association;
    my @def = split ',', $def;
    while (my $role_id = shift @def) {
        my $blog_id = shift @def;
        next unless $role_id && $blog_id;
        my $blog = $blog_class->load($blog_id);
        my $role = $role_class->load($role_id);
        next unless ref $blog && ref $role;
        MT::Association->link($author => $role => $blog);
    }
}

sub to_hash {
    my $author = shift;
    my $hash = $author->SUPER::to_hash(@_);
    my $app = MT->instance;
    my $blog = $app->blog if $app->can('blog');
    if ($blog) {
        require MT::Permission;
        if (my $perms = MT::Permission->load({ author_id => $author->id, blog_id => $blog->id })) {
            my $perms_hash = $perms->to_hash;
            $hash->{"author.$_"} = $perms_hash->{$_} foreach keys %$perms_hash;
        }
    }
    $hash;
}

sub group_count {
    my $author = shift;
    require MT::Association;
    MT::Association->count({
        type => MT::Association::USER_GROUP(),
        author_id => $author->id,
    });
}

sub external_id {
    my $author = shift;
    if (@_) {
        return $author->SUPER::external_id($author->unpack_external_id(@_));
    }
    my $value = $author->SUPER::external_id;
    $value = $author->pack_external_id($value) if $value;
}

sub load {
    my $author = shift;
    my ($terms, $args) = @_;
    if ((ref($terms) eq 'HASH') && exists($terms->{external_id})) {
        $terms->{external_id} = $author->unpack_external_id($terms->{external_id});
    }
    $author->SUPER::load($terms, $args);
}

sub load_iter {
    my $author = shift;
    my ($terms, $args) = @_;
    if ((ref($terms) eq 'HASH') && exists($terms->{external_id})) {
        $terms->{external_id} = $author->unpack_external_id($terms->{external_id});
    }
    $author->SUPER::load_iter($terms, $args);
}

sub pack_external_id { return pack('H*', $_[1]); }
sub unpack_external_id { return unpack('H*', $_[1]); }

sub auth_icon_url {
    my $author = shift;
    my ($size) = @_;
    $size ||= 'logo_small';

    my $app = MT->instance;
    my $static_path = $app->static_path;

    my $auth_type = $author->auth_type;
    return q() unless $auth_type;

    if ( $author->type == MT::Author::AUTHOR() ) {
        return $static_path . 'images/comment/mt_logo.png' ;
    }
    
    my $authenticator = MT->commenter_authenticator( $auth_type );
    return q() unless $authenticator;
    return q() unless exists $authenticator->{$size};

    my $logo = $authenticator->{$size};
    if ( ( $logo !~ m!^https?://! ) || ( $logo !~ m!^/! ) ) {
        $logo = $static_path . $logo;
    }
    return $logo;
}

sub userpic {
    my $author = shift;
    my (%param) = @_;

    my $asset = $param{Asset};
    return $asset if $asset;

    my $asset_id = $author->userpic_asset_id or return;
    require MT::Asset;
    $asset = MT->model('asset.image')->load($asset_id) or return;

    $asset;
}

sub userpic_thumbnail_options {
    my $author = shift;

    # Specify these to put an author's userpic thumbnail in a consistent
    # place whenever userpic_url is called as an instance method on a
    # particular author.
    my %real_userpic_options = (
        Path   => File::Spec->catdir( MT->config->AssetCacheDir, 'userpics' ),
        Format => MT->translate('userpic-[_1]-%wx%h%x', $author->id),
    ) if ref $author;

    my $cfg = MT->config;
    my $max_dim = $cfg->UserpicThumbnailSize;
    my $square  = $cfg->UserpicAllowRect ? 0 : 1;
    return (
        Width  => $max_dim,
        Height => $max_dim,
        Square => $square,
        Type   => 'png',
        %real_userpic_options,
    );
}

sub userpic_file {
    my $author = shift;

    my $asset = $author->userpic;
    if (!$asset) {
        $asset = MT->model('asset.image')->new;
        $asset->file_name('userpic');
    }

    my %thumb_param = $author->userpic_thumbnail_options();
    my $thumb_file = File::Spec->catfile(
        $asset->thumbnail_path(%thumb_param),
        $asset->thumbnail_filename(%thumb_param),
    );

    return $thumb_file;
}

sub userpic_url {
    my $author = shift;
    my (%param) = @_;

    my $asset = delete $param{Asset};
    if (!$asset && ref $author) {
        $asset = $author->userpic;
    }
    return if !$asset;

    my @info = $asset->thumbnail_url(
        $author->userpic_thumbnail_options(),
        %param,
    );
    if (($info[0] || '') !~ m!^https?://!) {
        my $static_host = MT->instance->static_path;
        if ($static_host =~ m!^https?://!) {
            $static_host =~ s!^(https?://[^/]+?)!$1!;
            $info[0] = $static_host . $info[0];
        }
    }
    return wantarray ? @info : $info[0];
}

sub userpic_html {
    my $author = shift;
    my ($thumb_url, $w, $h) = $author->userpic_url(@_) or return;
    return unless $thumb_url;
    sprintf q{<img src="%s?%d" width="%d" height="%d" alt="" />},
      MT::Util::encode_html($thumb_url), $author->userpic(@_)->id, $w, $h;
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

The author nickname (or "display" name). This is the preferred name used for publishing the author's name.

=item * password

The author's password, one-way encrypted. If you wish to check the validity of
a password, you should use the I<is_valid_password> method, above.

=item * type

The type of author record. Currently, MT stores authenticated commenters in the author table. The type column can be one of AUTHOR or COMMENTER (constants defined in this package).

=item * status

A column that defines whether the records of an AUTHOR type are ACTIVE, INACTIVE or PENDING (constants declared in this package). 

=item * commenter_status

This method requires a blog id to be passed as the argument and a value of APPROVED, BANNED or PENDING (constants declared in this package) is returned.

=item * email

The author's email address.

=item * url

The author's homepage URL.

=item * hint

The answer to the question used when recovering the user's password.
The hint is not used from 4.25 in the password recovery.

=item * external_id

A column for holding a value used to synchronize the MT author record with an external record.

=item * can_create_blog

A boolean flag specifying whether the author has permission to create a new
blog in the system.

=item * can_view_log

A boolean flag specifying whether the author has permission to view the global
system activity log.

=item * created_by

The author ID of the author who created this author. If the author was created by a process where no user was logged in to Movable Type, the created_by column will be empty.

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
