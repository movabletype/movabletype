# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Author;

use strict;

use MT::Summary;    # Holds MT::Summarizable
use base qw( MT::Object MT::Scorable MT::Summarizable );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'                   => 'integer not null auto_increment',
            'name'                 => 'string(255) not null',
            'nickname'             => 'string(255)',
            'password'             => 'string(124) not null',
            'type'                 => 'smallint not null',
            'email'                => 'string(127)',
            'url'                  => 'string(255)',
            'public_key'           => 'text',
            'preferred_language'   => 'string(50)',
            'api_password'         => 'string(60)',
            'remote_auth_username' => 'string(50)',
            'remote_auth_token'    => 'string(50)',
            'entry_prefs'          => 'string(255)',
            'text_format'          => 'string(30)',
            'date_format'          => 'string(30)',
            'status'               => 'integer',
            'external_id'          => 'string(255)',
            'locked_out_time'      => 'integer not null',

            #'last_login' => 'datetime',

            # deprecated; permissions are in MT::Permission only now
            'can_create_blog'  => 'boolean',
            'is_superuser'     => 'boolean',
            'can_view_log'     => 'boolean',
            'auth_type'        => 'string(50)',
            'userpic_asset_id' => 'integer',
            'basename'         => 'string(255)',

         # Deprecated; The hint is not used from 4.25 in the password recovery
            'hint' => 'string(75)',

            # meta properties
            'widgets'                  => 'hash meta',
            'favorite_blogs'           => 'array meta',
            'favorite_websites'        => 'array meta',
            'password_reset'           => 'string meta',
            'password_reset_expires'   => 'string meta',
            'password_reset_return_to' => 'string meta',
            'list_prefs'               => 'hash meta',
            'lockout_recover_salt'     => 'string meta',
        },
        defaults => {
            type            => 1,
            status          => 1,
            date_format     => 'relative',
            locked_out_time => 0,
        },
        indexes => {
            created_on      => 1,
            name            => 1,
            email           => 1,
            type            => 1,
            status          => 1,
            external_id     => 1,
            locked_out_time => 1,
            auth_type_name => { columns => [ 'auth_type', 'name', 'type' ], },
            basename       => 1,
        },
        meta    => 1,
        summary => 1,
        child_classes =>
            [ 'MT::Permission', 'MT::Association', 'MT::Filter' ],
        datasource  => 'author',
        primary_key => 'id',
        audit       => 1,
    }
);

sub class_label {
    MT->translate("User");
}

sub class_label_plural {
    MT->translate("Users");
}

# Valid "type" codes:
sub AUTHOR ()    {1}
sub COMMENTER () {2}

# Commenter statuses
sub APPROVED () {1}
sub BANNED ()   {2}
sub BLOCKED ()  {2}    # alias for BANNED for backward compatibility
sub PENDING ()  {3}

# Author statuses
sub ACTIVE ()   {1}
sub INACTIVE () {2}

#use constant PENDING => 3; # there *is* PENDING status for authors but it's the same name and value.

use Exporter;
*import = \&Exporter::import;
use vars qw(@EXPORT_OK %EXPORT_TAGS);
@EXPORT_OK   = qw(AUTHOR COMMENTER ACTIVE INACTIVE APPROVED BANNED PENDING);
%EXPORT_TAGS = ( constants =>
        [qw(AUTHOR COMMENTER ACTIVE INACTIVE APPROVED BANNED PENDING)] );

sub list_props {
    return {
        name => {
            auto       => 1,
            label      => 'Username',
            display    => 'force',
            order      => 100,
            sub_fields => [
                {   class   => 'userpic',
                    label   => 'Userpic',
                    display => 'optional',
                },
                {   class   => 'user-info',
                    label   => 'User Info',
                    display => 'optional',
                },
            ],
            bulk_html => \&_bulk_author_name_html,
        },
        nickname => {
            auto      => 1,
            label     => 'Display Name',
            display   => 'default',
            order     => 200,
            bulk_html => \&_nickname_bulk_html,
        },
        entry_count => {
            label        => 'Entries',
            filter_label => '__ENTRY_COUNT',
            display      => 'default',
            order        => 300,
            base         => '__virtual.object_count',
            col_class    => 'num',
            count_class  => 'entry',
            count_col    => 'author_id',
            filter_type  => 'author_id',
        },
        comment_count => {
            base         => 'author.entry_count',
            label        => 'Comments',
            filter_label => '__COMMENT_COUNT',
            display      => 'default',
            order        => 400,
            count_class  => 'comment',
            count_col    => 'commenter_id',
            filter_type  => 'commenter_id',
            raw          => sub {
                my ( $prop, $obj ) = @_;
                MT->model( $prop->count_class )
                    ->count( { commenter_id => $obj->id } );
            },
        },
        author_name => {
            base        => '__virtual.author_name',
            label       => 'Created by',
            display     => 'default',
            order       => 500,
            view_filter => [],
        },
        created_on => {
            base  => '__virtual.created_on',
            order => 600,
        },
        modified_on => {
            base  => '__virtual.modified_on',
            order => 700,
        },

        status => {
            base    => '__virtual.single_select',
            display => 'none',
            label   => 'Status',
            col     => 'status',
            terms   => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $val      = $args->{value};
                my %statuses = (
                    active   => ACTIVE(),
                    disabled => INACTIVE(),
                    pending  => PENDING(),
                );
                $val = exists $statuses{$val} ? $statuses{$val} : $val;
                return { status => $val };
            },
            single_select_options => [
                { label => MT->translate('Active'),   value => 'active', },
                { label => MT->translate('Disabled'), value => 'disabled', },
                { label => MT->translate('Pending'),  value => 'pending', },
            ],
        },
        url => {
            auto      => 1,
            display   => 'none',
            label     => 'Website URL',
            html_link => sub {
                my ( $prop, $obj, $app ) = @_;
                return $obj->url;
            },
        },
        privilege => {
            base                  => '__virtual.single_select',
            label                 => 'Privilege',
            display               => 'none',
            singleton             => 0,
            single_select_options => sub {
                my $prop  = shift;
                my $perms = MT->model('permission')->perms_from_registry;
                my @perms
                    = map { { label => $perms->{$_}{label}, value => $_ } }
                    sort { $perms->{$a}{order} <=> $perms->{$b}{order} }
                    grep { $_ =~ /^system/ }
                    keys %$perms;
                \@perms;
            },
            terms => sub {
                my ( $prop, $args, $db_terms, $db_args ) = @_;
                my $priv = $args->{value};
                $priv =~ s/^system\.//;
                $db_args->{join} = MT->model('permission')->join_on(
                    author_id => {
                        blog_id     => 0,
                        permissions => { like => "%'$priv'%" },
                    }
                );
                return;
            },
        },
        email => {
            auto    => 1,
            label   => 'Email Address',
            display => 'none',
        },
        lockout => {
            base    => '__virtual.single_select',
            display => 'none',
            label   => 'Lockout',
            col     => 'lockout',
            terms   => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $val = $args->{value};
                require MT::Lockout;
                my %statuses = (
                    not_locked_out =>
                        { '<' => MT::Lockout::locked_out_user_threshold(), },
                    locked_out =>
                        { '>=' => MT::Lockout::locked_out_user_threshold(), },
                );
                $val = exists $statuses{$val} ? $statuses{$val} : $val;
                return { locked_out_time => $val };
            },
            single_select_options => [
                {   label => MT->translate('Not Locked Out'),
                    value => 'not_locked_out',
                },
                {   label => MT->translate('Locked Out'),
                    value => 'locked_out',
                },
            ],
        },
        id => { view => [] },
    };
}

sub system_filters {
    return {
        enabled => {
            label => 'Enabled Users',
            items =>
                [ { type => 'status', args => { value => 'active' }, }, ],
            order => 100,
        },
        disabled => {
            label => 'Disabled Users',
            items =>
                [ { type => 'status', args => { value => 'disabled' }, }, ],
            order => 200,
        },
        pending => {
            label => 'Pending Users',
            items =>
                [ { type => 'status', args => { value => 'pending' }, }, ],
            order => 300,
        },
        lockedout => {
            label => 'Locked out Users',
            items => [
                { type => 'lockout', args => { value => 'locked_out' }, },
            ],
            order => 400,
        },
    };
}

sub commenter_list_props {
    return {
        name => {
            auto       => 1,
            label      => 'Username',
            display    => 'force',
            order      => 100,
            sub_fields => [
                {   class   => 'userpic',
                    label   => 'Userpic',
                    display => 'optional',
                },
                {   class   => 'user-info',
                    label   => 'User Info',
                    display => 'optional',
                },
            ],
            bulk_html => \&_bulk_author_name_html,
        },
        nickname => {
            base  => 'author.nickname',
            order => 200,
        },
        comment_count => {
            base  => 'author.comment_count',
            order => 300,
        },
        author_name => {
            base  => 'author.author_name',
            order => 400,
        },
        created_on => {
            base  => '__virtual.created_on',
            order => 500,
        },
        modified_on => {
            base  => '__virtual.modified_on',
            order => 600,
        },

        email  => { base => 'author.email' },
        status => {
            base    => '__virtual.single_select',
            display => 'none',
            label   => 'Status',
            col     => 'status',
            terms   => sub {
                my ( $prop, $args, $db_terms, $db_args, $opts ) = @_;
                my $val = $args->{value};
                $db_args->{joins} ||= [];
                my $blog_id
                    = MT->config->SingleCommunity ? 0 : $opts->{blog_ids};
                if ( $val eq 'enabled' ) {
                    push @{ $db_args->{joins} },
                        MT->model('permission')->join_on(
                        undef,
                        {   permissions => { like => '%\'comment\'%', },
                            author_id => \'= author_id',
                            blog_id   => $blog_id,
                        }
                        );
                }
                elsif ( $val eq 'disabled' ) {
                    push @{ $db_args->{joins} },
                        MT->model('permission')->join_on(
                        undef,
                        {   restrictions => { like => '%\'comment\'%', },
                            author_id => \'= author_id',
                            blog_id   => $blog_id,
                        }
                        );
                }
                elsif ( $val eq 'pending' ) {
                    push @{ $db_args->{joins} },
                        MT->model('permission')->join_on(
                        undef,
                        {   permissions  => \'IS NULL',        # FOR-EDITOR',
                            restrictions => \'IS NULL',        # FOR-EDITOR',
                            author_id    => \'= author_id',    # FOR-EDITOR',
                            blog_id      => $blog_id,
                        }
                        );
                }
                return;

            },
            single_select_options => [
                {   label => MT->translate('__COMMENTER_APPROVED'),
                    value => 'enabled',
                },
                { label => MT->translate('Banned'),  value => 'disabled', },
                { label => MT->translate('Pending'), value => 'pending', },
            ],
        },
    };
}

sub commenter_system_filters {
    return {
        enabled => {
            label => 'Enabled Commenters',
            items =>
                [ { type => 'status', args => { value => 'enabled' }, }, ],
            order => 100,
        },
        disabled => {
            label => 'Disabled Commenters',
            items =>
                [ { type => 'status', args => { value => 'disabled' }, }, ],
            order => 200,
        },
        pending => {
            label => 'Pending Commenters',
            items =>
                [ { type => 'status', args => { value => 'pending' }, }, ],
            order => 300,
        },
    };
}

sub member_list_props {
    return {
        name => {
            auto       => 1,
            label      => 'Username',
            display    => 'force',
            bulk_html  => \&_bulk_author_name_html,
            sub_fields => [
                {   class   => 'userpic',
                    label   => 'Userpic',
                    display => 'optional',
                },
                {   class   => 'user-info',
                    label   => 'User Info',
                    display => 'optional',
                },
            ],
            order => 100,
        },
        nickname => {
            label     => 'Display Name',
            auto      => 1,
            bulk_html => \&_nickname_bulk_html,
            order     => 200,
            display   => 'default',
        },
        role => {
            base      => '__virtual.single_select',
            label     => 'Roles',
            order     => 300,
            display   => 'default',
            view_sort => [],
            html      => sub {
                my ( $prop, $obj ) = @_;
                my $blog_id = MT->app->blog->id;
                my @roles   = MT->model('role')->load(
                    undef,
                    {   join => MT->model('association')->join_on(
                            'role_id',
                            {   blog_id   => $blog_id,
                                author_id => $obj->id,
                            },
                        ),
                    },
                );
                return '' unless scalar @roles;
                return '<ul>'
                    . join( '',
                    map          {qq(<li class="role-item">$_</li>)}
                        sort map { MT::Util::encode_html( $_->name ) }
                        @roles )
                    . '</ul>';
            },
            terms => sub {
                my ( $prop, $args, $db_terms, $db_args ) = @_;
                my $terms = {};
                $terms->{blog_id} = MT->app->param('blog_id');
                $terms->{role_id} = $args->{value} if $args->{value};
                $terms->{author_id} = \"= author_id";    # FOR-EDITOR";
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} },
                    MT->model('association')
                    ->join_on( undef, $terms, { unique => 1 } );
                return;
            },
            single_select_options => sub {
                my $prop  = shift;
                my @roles = MT->model('role')->load;
                return [ map { { label => $_->name, value => $_->id } }
                        @roles ];
            },
        },
        entry_count => {
            base        => '__virtual.object_count',
            view        => [ 'blog', 'website' ],
            label       => 'Entries',
            count_class => 'entry',
            count_col   => 'author_id',
            filter_type => 'author_id',
            list_screen => 'entry',
            count_terms => sub {
                my $prop = shift;
                my ($opts) = @_;
                return { blog_id => $opts->{blog_ids} };
            },
            count_args => { unique => 1, },
            order      => 400,
        },
        comment_count => {
            base        => '__virtual.object_count',
            label       => 'Comments',
            count_class => 'comment',
            count_col   => 'commenter_id',
            filter_type => 'commenter_id',
            list_screen => 'comment',
            count_terms => sub {
                my $prop = shift;
                my ($opts) = @_;
                return { blog_id => $opts->{blog_ids} };
            },
            count_args => { unique => 1, },
            order      => 500,
        },
        type => {
            label     => 'Type',
            base      => '__virtual.single_select',
            col       => 'type',
            display   => 'none',
            condition => sub {
                MT->config->SingleCommunity ? 0 : 1;
            },
            single_select_options => [
                { label => MT->translate('MT Users'), value => AUTHOR(), },
                {   label => MT->translate('Commenters'),
                    value => COMMENTER(),
                },
            ],
        },
        status     => { base => 'author.status', },
        created_on => {
            base    => '__virtual.created_on',
            display => 'none',
        },
        modified_on => {
            base    => '__virtual.modified_on',
            display => 'none',
        },
        email => {
            auto    => 1,
            label   => 'Email Address',
            display => 'none',
        },
    };
}

sub member_system_filters {
    return {
        navive_users => {
            label     => 'MT Native Users',
            items     => [ { type => 'type', args => { value => 1 }, }, ],
            condition => sub {
                MT->config->SingleCommunity ? 0 : 1;
            },
            order => 100,
        },
        external_users => {
            label     => 'Externally Authenticated Commenters',
            items     => [ { type => 'type', args => { value => 2 }, }, ],
            condition => sub {
                MT->config->SingleCommunity ? 0 : 1;
            },
            order => 200,
        },
    };
}

sub _bulk_author_name_html {
    my ( $prop, $objs, $app, $opts ) = @_;

    # Load userpics
    my %asset_for_load = map { $_->userpic_asset_id => 1 }
        grep { $_->userpic_asset_id } @$objs;
    my @userpics;
    @userpics
        = MT->model('asset.image')->load( { id => [ keys %asset_for_load ] } )
        if keys %asset_for_load;
    my %userpic = map { $_->id => $_ } @userpics;
    my @results;
    my $mail_icon = MT->static_path . 'images/status_icons/email.gif';
    my $view_icon = MT->static_path . 'images/status_icons/link.gif';

    for my $obj (@$objs) {
        my $userpic_url;
        if ( my $userpic = $userpic{ $obj->userpic_asset_id || 0 } ) {
            ($userpic_url) = $userpic->thumbnail_url(
                Width  => 36,
                Height => 36,
                Square => 1
            );
        }
        else {
            $userpic_url = MT->static_path . 'images/default-userpic-36.jpg';
        }
        my ( $status_img, $status_label );
        if ( MT->config->SingleCommunity ) {
            if ( $obj->type == MT::Author::AUTHOR() ) {
                $status_img
                    = $obj->status == ACTIVE()   ? 'user-enabled.gif'
                    : $obj->status == INACTIVE() ? 'user-disabled.gif'
                    :                              'user-pending.gif';
                $status_label
                    = $obj->status == ACTIVE()   ? 'Enabled'
                    : $obj->status == INACTIVE() ? 'Disabled'
                    :                              'Pending';
            }
            else {
                $status_img
                    = $obj->is_trusted(0) ? 'trusted.gif'
                    : $obj->is_banned(0)  ? 'banned.gif'
                    :                       'authenticated.gif';
                $status_label
                    = $obj->is_trusted(0) ? 'Trusted'
                    : $obj->is_banned(0)  ? 'Banned'
                    :                       'Authenticated';
            }
        }
        else {
            my $blog_id = $opts->{blog_id};
            $status_img
                = $obj->is_trusted($blog_id) ? 'trusted.gif'
                : $obj->is_banned($blog_id)  ? 'banned.gif'
                :                              'authenticated.gif';
            $status_label
                = $obj->is_trusted($blog_id) ? 'Trusted'
                : $obj->is_banned($blog_id)  ? 'Banned'
                :                              'Authenticated';
        }

        $status_img = MT->static_path . 'images/status_icons/' . $status_img;
        my $lc_status_label = lc $status_label;
        my $auth_img        = MT->static_path;
        my $auth_label;
        if ( $obj->auth_type eq 'MT' || $obj->auth_type eq 'LDAP' ) {
            $auth_img .= 'images/comment/mt_logo.png';
            $auth_label = 'Movable Type';
        }
        else {
            my $auth
                = MT->registry( commenter_authenticators => $obj->auth_type );
            $auth_img .= $auth->{logo_small};
            $auth_label = $auth->{label};
            $auth_label = $auth_label->() if ref $auth_label;
        }
        my $lc_auth_label = lc $auth_label;

        my $name = MT::Util::encode_html( $obj->name )
            || '(' . MT->translate('Registered User') . ')';
        my $email = MT::Util::encode_html( $obj->email );
        my $url   = MT::Util::encode_html( $obj->url );
        my $out   = qq{
            <div class="userpic picture small ">
                <img src="$userpic_url" />
                <img alt="$auth_label" src="$auth_img" width="12" height="12" class="icon auth-type" />
            </div>
            <span class="icon status $status_label">
                <img alt="$status_label" src="$status_img" class="status $lc_status_label" />
            </span>
        };

        if ( $app->can_do('edit_authors') || $app->user->id == $obj->id ) {
            my $edit_link = $app->uri(
                mode => 'view',
                args => {
                    _type => $obj->type == MT::Author::AUTHOR()
                    ? 'author'
                    : 'commenter',
                    id      => $obj->id,
                    blog_id => 0,
                },
            );
            $out
                .= qq{<span class="username"><a href="$edit_link">$name</a></span>};
        }
        else {
            $out .= qq{<span class="username">$name</span>};
        }
        if ( $url || $email ) {
            $out .= q{<ul class="user-info description">};
            $out
                .= qq{<li class="user-info-item user-email"><img alt="Email "src="$mail_icon" /> <a href="mailto:$email" title="$email">$email</a></li>}
                if $email;
            $out
                .= qq{<li class="user-info-item user-url"><img alt="URL" src="$view_icon" /> <a href="$url" title="$url">$url</a></li>}
                if $url;
            $out .= q{</ul>};
        }
        push @results, $out;
    }
    return @results;
}

sub _nickname_bulk_html {
    my ( $prop, $objs, $app ) = @_;
    my @results;
    for my $obj (@$objs) {
        my $name = MT::Util::encode_html( $obj->nickname );
        my $out  = qq{
            <span class="displayname">$name</span>
        };
        push @results, $out;
    }
    return @results;
}

sub set_defaults {
    my $auth = shift;
    my $cfg  = MT->config;
    $auth->SUPER::set_defaults(@_);
    $auth->preferred_language( $cfg->DefaultUserLanguage
            || $cfg->DefaultLanguage );
}

sub remove_sessions {
    my $auth = shift;
    return if ( !$auth or !$auth->id );

    require MT::Session;

    if ( MT->config('EnableSessionKeyCompat') ) {
        my $sess_iter = MT::Session->load_iter( { kind => 'US' } );
        my @sess;
        while ( my $sess = $sess_iter->() ) {
            my $id = $sess->get('author_id');
            next unless $id == $auth->id;
            push @sess, $sess;
        }
        $_->remove foreach @sess;
    }

    MT::Session->remove( { kind => 'US', name => $auth->id } );

    return 1;
}

sub remove_failedlogin {
    my $auth = shift;
    return if ( !$auth or !$auth->id );
    require MT::Lockout;
    MT::Lockout->clear_failedlogin($auth);
    return 1;
}

sub set_password {
    my $auth   = shift;
    my ($pass) = @_;
    my @alpha  = ( 'a' .. 'z', 'A' .. 'Z', 0 .. 9 );
    my $salt   = join '', map $alpha[ rand @alpha ], 1 .. 16;
    my $crypt_sha;

    if ( eval { require Digest::SHA } ) {

        # Can use SHA512
        $crypt_sha
            = '$6$' 
            . $salt . '$'
            . Digest::SHA::sha512_base64( $salt . $pass );
    }
    else {

        # Use SHA-1 algorism
        $crypt_sha
            = '{SHA}' 
            . $salt . '$'
            . MT::Util::perl_sha1_digest_hex( $salt . $pass );
    }

    $auth->column( 'password', $crypt_sha );
}

sub is_valid_password {
    my $author = shift;
    my ( $pass, $crypted, $error_ref ) = @_;
    $pass = '' unless length($pass);
    require MT::Auth;
    return MT::Auth->is_valid_password( $author, $pass, $crypted,
        $error_ref );
}

sub is_email_hidden {
    my $auth = shift;
    return 1 unless $auth->email =~ m/@/;
    return ( $auth->email =~ /^[0-9a-f]{40}$/i ) ? 1 : 0;
}

# Existing comments of a user are made visible only if the
# user is coming from "pending" status.

sub set_commenter_perm {
    my $this = shift;
    my ( $blog_id, $action ) = @_;

    if ( MT->config->SingleCommunity ) {
        $blog_id = 0;
    }

    require MT::Permission;
    my %perm_spec = (
        author_id => $this->id(),
        blog_id   => $blog_id
    );
    my $perm = MT::Permission->load( \%perm_spec );
    if ( !$perm ) {
        $perm = MT::Permission->new();
        $perm->set_values( \%perm_spec );
    }
    if ( $action eq 'approve' ) {
        $perm->remove_restrictions('comment');
        $perm->can_comment(1);
    }
    elsif ( ( $action eq 'ban' ) || ( $action eq 'block' ) ) {
        $perm->set_these_restrictions('comment');
        $perm->can_comment(0);
    }
    elsif ( $action eq 'pending' ) {
        $perm->remove_restrictions('comment');
        $perm->can_comment(0);
    }
    $perm->save()
        or return $this->error(
        MT->translate(
            "The approval could not be committed: [_1]",
            $perm->errstr
        )
        );

    return 1;
}

sub commenter_status {
    my $this = shift;
    return APPROVED if $this->is_superuser;
    my ($blog_id) = @_;

    if ( MT->config->SingleCommunity ) {
        $blog_id = 0;
    }

    my $perm = $this->permissions($blog_id);
    if ($perm) {
        return BANNED if $perm->is_restricted('comment');
        return APPROVED
            if $perm->can_comment() || $perm->can_manage_feedback();
    }
    else {
        return PENDING unless MT->config->SingleCommunity;
    }
    return APPROVED
        if MT->config->SingleCommunity
            && ( AUTHOR() == $this->type )
            && $this->is_active();
    return PENDING;
}

sub is_active  { shift->status() == ACTIVE; }
sub is_trusted { shift->commenter_status(@_) == APPROVED; }
sub is_banned  { shift->commenter_status(@_) == BANNED; }
*is_blocked = \&is_banned;
sub is_not_trusted { shift->commenter_status(@_) == PENDING; }
*is_untrusted = \&is_not_trusted;

sub approve {
    my $this = shift;
    my ($blog_id) = @_;
    $this->set_commenter_perm( $blog_id, 'approve' );
}

*trust = \&approve;

sub pending {
    $_[0]->set_commenter_perm( $_[1], 'pending' );
}

sub ban {
    my $this = shift;
    my ($blog_id) = @_;
    $this->set_commenter_perm( $blog_id, 'ban' );
}
*block = \&ban;

sub save {
    my $auth = shift;

    if ( $auth->type == AUTHOR ) {
        if ( !$auth->id ) {

            # New author, undefined API password. Generate one.
            if ( !defined $auth->api_password ) {
                my @pool = ( 'a' .. 'z', 0 .. 9 );
                my $pass = '';
                for ( 1 .. 8 ) { $pass .= $pool[ rand @pool ] }
                $auth->api_password($pass);
            }
        }

        # Generate basename
        unless ( $auth->basename() ) {
            my $basename = MT::Util::make_unique_author_basename($auth);
            $auth->basename($basename);
        }
    }

    my $privs;
    my $privs_found;
    if ( exists $auth->permissions(0)->{changed_cols}->{permissions} ) {
        $privs       = $auth->permissions(0)->permissions;
        $privs_found = 1;
    }

    # delete new user's privilege from cache
    delete MT::Request->instance->{__stash}->{'__perm_author_'}
        unless $auth->id;
    $auth->SUPER::save(@_) or return $auth->error( $auth->errstr );
    if ($privs_found) {
        my $perm = $auth->permissions(0);
        $perm->permissions($privs);
        $perm->save
            or return $auth->error(
            "Error saving permission: " . $perm->errstr );
    }
    1;
}

sub remove {
    my $auth = shift;
    $auth->remove_sessions    if ref $auth;
    $auth->remove_failedlogin if ref $auth;
    $auth->remove_children( { key => 'author_id' } ) or return;
    $auth->SUPER::remove(@_);
}

sub can_edit_entry {
    my $author = shift;
    die unless $author->isa('MT::Author');
    return 1 if $author->is_superuser();
    my ($entry) = @_;
    unless ( ref $entry ) {
        require MT::Entry;
        $entry = MT::Entry->load($entry);
    }
    die if !$entry || !$entry->isa('MT::Entry');
    my $perms = $author->permissions( $entry->blog_id );
    die unless $perms->isa('MT::Permission');
    $perms->can_edit_all_posts
        || ( $perms->can_create_post && $entry->author_id == $author->id );
}

sub is_superuser {
    my $author = shift;
    if (@_) {
        my $perms      = MT->model('permission')->perms_from_registry;
        my $admin_perm = $perms->{'system.administer'};
        $author->permissions(0)->can_administer(@_);
        if ( $_[0] ) {
            my $inherit = $admin_perm->{inherit_from};
            foreach (@$inherit) {
                my $name = $_;
                $name =~ s/^.*\.(.*)$/$1/;
                $name = 'can_' . $name;
                $author->permissions(0)->$name(@_);
            }
        }
    }
    else {
        $author->permissions(0)->can_administer();
    }
}

sub can_create_blog {
    my $author = shift;
    if (@_) {
        $author->permissions(0)->can_create_blog(@_);
    }
    else {
        $author->is_superuser()
            || $author->permissions(0)->can_create_blog(@_);
    }
}

sub can_create_website {
    my $author = shift;
    if (@_) {
        $author->permissions(0)->can_create_website(@_);
    }
    else {
        $author->is_superuser()
            || $author->permissions(0)->can_create_website(@_);
    }
}

sub can_view_log {
    my $author = shift;
    if (@_) {
        $author->permissions(0)->can_view_log(@_);
    }
    else {
        $author->is_superuser()
            || $author->permissions(0)->can_view_log(@_);
    }
}

sub can_manage_plugins {
    my $author = shift;
    if (@_) {
        $author->permissions(0)->can_manage_plugins(@_);
    }
    else {
        $author->is_superuser()
            || $author->permissions(0)->can_manage_plugins(@_);
    }
}

sub can_edit_templates {
    my $author = shift;
    if (@_) {
        $author->permissions(0)->can_edit_templates(@_);
    }
    else {
        $author->is_superuser()
            || $author->permissions(0)->can_edit_templates(@_);
    }
}

sub blog_perm {
    my $author = shift;
    my ($blog_id) = @_;
    $author->permissions($blog_id);
}

sub has_perm {
    my $author    = shift;
    my ($blog_id) = @_;
    my $perm      = $author->permissions($blog_id);
    return $perm->permissions ? 1 : 0;
}

sub permissions {
    my $author  = shift;
    my ($obj)   = @_;
    my $blog_id = $obj;

    my $terms = { author_id => $author->id };
    my $cache_key
        = "__perm_author_" . ( defined( $author->id ) ? $author->id : q() );
    if ($obj) {
        if ( ( ref $obj ) && $obj->isa('MT::Blog') ) {
            $blog_id = $obj->id;
        }
        elsif ($obj) {
            $blog_id = $obj;
            require MT::Blog;
            $obj = MT::Blog->load($blog_id);
        }
        $cache_key .= "_blog_$blog_id";
        $terms->{blog_id} = [ 0, $blog_id ];
    }
    else {
        $terms->{blog_id} = 0;
    }

    require MT::Request;
    my $r = MT::Request->instance;
    my $p = $r->stash($cache_key);
    return $p if $p;

    require MT::Permission;
    my @perm = $author->is_anonymous ? () : MT::Permission->load($terms);
    my $perm;
    if ($obj) {
        if ( @perm == 2 ) {
            if ( !$perm[0]->blog_id ) {
                @perm = reverse @perm;
            }
            ( $perm, my $sys_perm ) = @perm;
            $perm->add_permissions($sys_perm);
        }
        elsif ( @perm == 1 ) {
            $perm = $perm[0];
            if ( !$perm->blog_id ) {
                $perm->blog_id( $obj->id );
                delete $perm->{column_values}{blog_id};
                delete $perm->{changed_cols}{blog_id};
            }
        }
        elsif ( @perm > 2 ) {

            # Condition sometimes caused by saving preferences. BugId:79501
            # Handle by merging permissions and removing all but one
            # Not ideal, but better than dying...
            my ($sys_perm) = grep { !$_->blog_id } @perm;
            my @blog_perms = grep { $_->blog_id }
                sort { $b->modified_on cmp $a->modified_on } @perm;

            my $new_perm = shift @blog_perms;    # take last one saved
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
    }
    else {
        $perm = $perm[0] if @perm;
    }
    unless (@perm) {
        if ( $blog_id || !@_ ) {
            if ( $author->is_superuser() ) {
                $perm = new MT::Permission;
                $perm->author_id( $author->id );
                $perm->set_full_permissions;
            }
        }
    }
    unless ($perm) {
        $perm = new MT::Permission;
        $perm->author_id( $author->id );
        $perm->clear_full_permissions;
    }
    $r->stash( $cache_key, $perm );
    $perm;
}

sub common_blogs
{    # returns the blogs in the form of permission records of $this
    die "This was removed";    # FIXME: this is to catch mistakes
}

sub can_administer {
    my $author = shift;
    return $author->is_superuser(@_);
}

sub entry_prefs {
    my $author = shift;
    my @prefs  = split /,/,
        ( ( @_ ? $_[0] : $author->column('entry_prefs') ) || '' );
    my %prefs;
    foreach (@prefs) {
        my ( $name, $value ) = split /=/, $_, 2;
        $prefs{$name} = $value;
    }
    if (@_) {
        my $pref = '';
        foreach ( keys %prefs ) {
            $pref .= ',' if $pref ne '';
            $pref .= $_ . '=' . $prefs{$_};
        }
        $author->column( 'entry_prefs', $pref );
    }

    # default assignments for author entry preferences
    $prefs{tag_delim} ||= MT->config->DefaultUserTagDelimiter;

    \%prefs;
}

sub role_iter {
    my $author = shift;
    my ( $terms, $args ) = @_;
    require MT::Association;
    require MT::Role;
    my $blog_id = delete $terms->{blog_id};
    my $type;
    if ($blog_id) {
        $type = MT::Association::USER_BLOG_ROLE();
    }
    else {
        $type = MT::Association::USER_ROLE();
    }
    $args->{join} = MT::Association->join_on(
        'role_id',
        {   type      => $type,
            author_id => $author->id,
            $blog_id ? ( blog_id => $blog_id ) : ( blog_id => 0 ),
        }
    );
    MT::Role->load_iter( $terms, $args );
}

sub blog_iter {
    my $author = shift;
    my ( $terms, $args ) = @_;
    my $perm = $author->permissions;
    if ( !$author->is_superuser ) {
        require MT::Permission;
        $args->{join} = MT::Permission->join_on( 'blog_id',
            { author_id => $author->id, } );
    }
    require MT::Blog;
    my $i = MT::Blog->load_iter( $terms, $args );
}

sub group_iter {
    my $author = shift;
    my ( $terms, $args ) = @_;
    my $grp_class = MT->model('group') or return undef;
    require MT::Association;
    $args->{join} = MT::Association->join_on(
        'group_id',
        {   type      => MT::Association::USER_GROUP(),
            author_id => $author->id,
        }
    );
    return $grp_class->load_iter( $terms, $args );
}

sub group_role_iter {
    my $author = shift;
    my ( $terms, $args ) = @_;

    my $grp_class = MT->model('group')
        or return undef;
    my @iters;
    require MT::Association;
    require MT::Role;
    my $blog_id = delete $terms->{blog_id};
    $args->{join} = MT::Association->join_on(
        'role_id',
        {   type => $blog_id
            ? MT::Association::USER_BLOG_ROLE()
            : MT::Association::USER_ROLE(),
            author_id => $author->id,
            $blog_id ? ( blog_id => $blog_id ) : (),
        }
    );
    my $user_iter = MT::Role->load_iter( $terms, $args );
    push @iters, $user_iter if $user_iter;

    my @groups;
    if ( my $group_iter
        = $author->group_iter( { status => MT::Group::ACTIVE() } ) )
    {
        while ( my $g = $group_iter->() ) {
            push @groups, $g->id;
        }
    }
    if (@groups) {
        $args->{join} = MT::Association->join_on(
            'role_id',
            {   type => $blog_id
                ? MT::Association::GROUP_BLOG_ROLE()
                : MT::Association::GROUP_ROLE(),
                group_id => \@groups,
                $blog_id ? ( blog_id => $blog_id ) : (),
            }
        );
        my $group_iter = MT::Role->load_iter( $terms, $args );
        push @iters, $group_iter if $group_iter;
    }
    MT::Util::multi_iter( \@iters );
}

sub add_role {
    my $author = shift;
    my ( $role, $blog ) = @_;
    $author->save unless $author->id;
    $role->save   unless $role->id;
    $blog->save if $blog && !$blog->id;
    require MT::Association;
    MT::Association->link( $author, @_ );
}

sub add_group {
    my $author = shift;
    my ($group) = @_;
    $author->save unless $author->id;
    $group->save  unless $group->id;
    require MT::Association;
    MT::Association->link( $author, @_ );
}

sub remove_role {
    my $author = shift;
    require MT::Association;
    MT::Association->unlink( $author, @_ );
}

sub remove_group {
    my $author = shift;
    require MT::Association;
    MT::Association->unlink( $author, @_ );
}

sub add_default_roles {
    my $author = shift;
    my $def    = MT->config->DefaultAssignments;
    return unless $def;

    my $blog_class = MT->model('blog');
    my $role_class = MT->model('role');

    require MT::Association;
    my @def = split ',', $def;
    while ( my $role_id = shift @def ) {
        my $blog_id = shift @def;
        next unless $role_id && $blog_id;
        my $blog = $blog_class->load($blog_id);
        my $role = $role_class->load($role_id);
        next unless ref $blog && ref $role;
        MT::Association->link( $author => $role => $blog );
    }
}

sub to_hash {
    my $author = shift;
    my $hash   = $author->SUPER::to_hash(@_);
    my $app    = MT->instance;
    my $blog   = $app->blog if $app->can('blog');
    if ($blog) {
        require MT::Permission;
        if (my $perms = MT::Permission->load(
                { author_id => $author->id, blog_id => $blog->id }
            )
            )
        {
            my $perms_hash = $perms->to_hash;
            $hash->{"author.$_"} = $perms_hash->{$_}
                foreach keys %$perms_hash;
        }
    }
    $hash;
}

sub group_count {
    my $author = shift;
    require MT::Association;
    MT::Association->count(
        {   type      => MT::Association::USER_GROUP(),
            author_id => $author->id,
        }
    );
}

sub external_id {
    my $author = shift;
    if (@_) {
        return $author->SUPER::external_id( $author->unpack_external_id(@_) );
    }
    my $value = $author->SUPER::external_id;
    $value = $author->pack_external_id($value) if $value;
}

sub load {
    my $author = shift;
    my ( $terms, $args ) = @_;
    if ( ( ref($terms) eq 'HASH' ) && exists( $terms->{external_id} ) ) {
        $terms->{external_id}
            = $author->unpack_external_id( $terms->{external_id} );
    }
    $author->SUPER::load( $terms, $args );
}

sub load_iter {
    my $author = shift;
    my ( $terms, $args ) = @_;
    if ( ( ref($terms) eq 'HASH' ) && exists( $terms->{external_id} ) ) {
        $terms->{external_id}
            = $author->unpack_external_id( $terms->{external_id} );
    }
    $author->SUPER::load_iter( $terms, $args );
}

sub pack_external_id { return pack( 'H*', $_[1] ); }
sub unpack_external_id { return unpack( 'H*', $_[1] ); }

sub auth_icon_url {
    my $author = shift;
    my ($size) = @_;
    $size ||= 'logo_small';

    my $app         = MT->instance;
    my $static_path = $app->static_path;

    my $auth_type = $author->auth_type;
    return q() unless $auth_type;

    if ( $author->type == MT::Author::AUTHOR() ) {
        return $static_path . 'images/comment/mt_logo.png';
    }

    my $authenticator = MT->commenter_authenticator( $auth_type, force => 1 );
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
        Path => File::Spec->catdir( MT->config->AssetCacheDir, 'userpics' ),
        Format => MT->translate( 'userpic-[_1]-%wx%h%x', $author->id ),
    ) if ref $author;

    my $cfg     = MT->config;
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
    if ( !$asset ) {
        $asset = MT->model('asset.image')->new;
        $asset->file_name('userpic');
    }

    my %thumb_param = $author->userpic_thumbnail_options();
    my $thumb_file  = File::Spec->catfile(
        $asset->thumbnail_path(%thumb_param),
        $asset->thumbnail_filename(%thumb_param),
    );

    return $thumb_file;
}

sub userpic_url {
    my $author = shift;
    my (%param) = @_;

    my $asset = delete $param{Asset};
    if ( !$asset && ref $author ) {
        $asset = $author->userpic;
    }
    return if !$asset;

    my @info
        = $asset->thumbnail_url( $author->userpic_thumbnail_options(), %param,
        );
    if ( ( $info[0] || '' ) !~ m!^https?://! ) {
        my $static_host = MT->instance->static_path;
        if ( $static_host =~ m!^https?://! ) {
            $static_host =~ s!^(https?://[^/]+?)!$1!;
            $info[0] = $static_host . $info[0];
        }
    }
    return wantarray ? @info : $info[0];
}

sub userpic_html {
    my $author = shift;
    my ( $thumb_url, $w, $h ) = $author->userpic_url(@_) or return;
    return unless $thumb_url;
    sprintf q{<img src="%s?%d" width="%d" height="%d" alt="" />},
        MT::Util::encode_html($thumb_url), $author->userpic(@_)->id, $w, $h;
}

sub can_do {
    my $author = shift;
    my ( $action, %opts ) = @_;

    return 1 if $author->is_superuser;

    my $sys_perm = MT->model('permission')
        ->load( { blog_id => 0, author_id => $author->id } );
    my $sys_priv;
    if ($sys_perm) {
        $sys_priv = $sys_perm->can_do($action);
    }
    return $sys_priv if $sys_priv;
    if ( $opts{at_least_one} ) {
        my $perm_iter = MT->model('permission')->load_iter(
            {   author_id => $author->id,
                ( $opts{blog_id} ? ( blog_id => $opts{blog_id} ) : () ),
            }
        );
        while ( my $perm = $perm_iter->() ) {
            my $blog_priv = $perm->can_do($action);
            return $blog_priv if $blog_priv;
        }
    }
    return;
}

sub locked_out {
    my $author = shift;
    require MT::Lockout;
    $author->locked_out_time
        && $author->locked_out_time
        >= MT::Lockout::locked_out_user_threshold();
}

sub anonymous {
    my $class = shift;
    my $obj   = $class->new;
    $obj->set_values(
        {   id     => 0,
            type   => AUTHOR,
            status => ACTIVE,
        }
    );
    $obj;
}

sub is_anonymous {
    my $self = shift;
    $self->id == 0;
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

=head2 $author->remove_sessions()

Remove all sessions that belong to this user

=head2 $author->remove_failedlogin()

Remove all failed-login histories that belong to this user

=head2 $author->is_email_hidden()

Indicate if author's email is hidden. Hidden emails are packed to hexadecimal
strings, should not be displayed to the public, and need to be packed before 
use. To retrive the real email use:

    $email = pack "H*", $author->email();

=head2 $author->entry_prefs([$settings])

Get or set the author entry preferences. $setting, if supplied, should
be a comma-delimited key-value pairs such as "tag_delim=44,size=3"

returns a hashref containing the entry preferences.

=head2 $author->set_commenter_perm($blog_id, $action)

Set commenting permissions, where $action can be 'approve', 'ban' or 'pending'.

=head2 $author->commenter_status($blog_id)

Get the current commenting permissions for this author. returns one of these 
constants: C<MT::Author::BANNED> C<MT::Author::APPROVED> C<MT::Author::PENDING>

=head2 $author->is_trusted($blog_id)

Tests if this author is APPROVED for commenting on this blog

=head2 $author->is_banned($blog_id)

Tests if this author is BANNED form commenting on this blog

=head2 $author->is_not_trusted($blog_id)

Tests if this author is still pending approval for commenting on this blog

=head2 $author->approve($blog_id)

approving the author for commenting

=head2 $author->ban($blog_id)

banning the author from commenting

=head2 $author->pending($blog_id)

setting the author commenting permission to still pending

=head2 $author->is_active()

Tests if the status of this author is ACTIVE

=head2 $author->can_edit_entry($entry)

Test if this author can edit this entry. C<$entry> can by a L<MT::Entry>
object or the ID of such an object.

=head2 $author->can_create_blog([$bool])

check or set author's permission to create blog

=head2 $author->can_create_website([$bool])

check or set author's permission to create a website

=head2 $author->can_view_log([$bool])

check or set author's permission to view the MT activity log

=head2 $author->can_manage_plugins([$bool])

check or set author's permission to manage plugins. (enable, disable, settings...)

=head2 $author->can_edit_templates([$bool])

check or set author's permission to change site's templates

=head2 $author->is_superuser([$bool])

check or set the system-wide administrator status of this author

=head2 $author->can_administer([$bool])

alias for is_superuser

=head2 $author->blog_perm($blog_id)

Get permission object for this author and blog

=head2 $author->has_perm($blog_id)

check if author have any permissions at all

=head2 $author->permissions([$blog])

Return a L<MT::Permission> object for this author and this blog. $blog can
be either a L<MT::Blog> object or an id of a blog. if $blog is not specifiy,
will return the system permissions for this author.

=head2 $author->can_do($action, [ at_least_one => 1, [ blog_id => $blogs ] ])

Search if this user have this permission. if at_least_one is not supplied,
searches only on system permissions. if at_least_one is supplies, and blog_id 
is not supplied, search for this permission in ALL the blogs this author
have permissions in. If blog_id is supplied, then the search is limited to
these blogs. $blogs can be either an ID of a single blog, or an array ref 
for a list of blog ids.

=head2 $author->role_iter($terms, $args)

Returns an iterator for the roles of this author. see L<MT::Object> to learn 
about iterators. if exist C<$terms->{blog_id}>, returns blog roles. otherwise,
return system-wide roles.

aside of C<$terms->{blog_id}>, $terms and $args are passed to 
MT::Role->load_iter

=head2 $author->blog_iter($terms, $args)

Returns an iterator for the blogs of this author. see L<MT::Object> to learn 
about iterators. if author is not superuser, retrive also the permissions 
for each blog

$terms and $args are passed to MT::Blog->load_iter

=head2 $author->group_iter($terms, $args)

Returns an iterator for the groups this author belongs to. see L<MT::Object> 
to learn about iterators.

$terms and $args are passed to the groups handler class's load_iter

=head2 $author->group_role_iter($terms, $args)

Returns an iterator for the groups and roles this author belongs to. 
see L<MT::Object> to learn about iterators. If $terms->{blog_id} is defined,
the function will return the author's roles and groups related to that blog.

$terms and $args are passed to the groups handler class's load_iter

=head2 $author->add_role($role [, $blog])

Add a role to this author. $role should be a MT::Role object, and $blog,
is supplied, should be a MT::Blog object. also, if $blog is supplied, 
the role will be added as related to this blog. otherwise, it will be 
added as system-wide role.

=head2 $author->remove_role($role [, $blog])

The inverse of add_role

=head2 $author->add_group($group)

Add this author to this group. $group should be a C<MT->model('group')> object

=head2 $author->remove_group($group)

The inverse of add_group

=head2 $author->group_count()

Count how many groups this author is associated with

=head2 $author->add_default_roles();

Add the default roles for an author. these are read from the configuration,
under DefaultAssignments attribute, that should be a comma-delimited string
in the format of "role_id,blog_id,role_id,blog_id"

=head2 $author->auth_icon_url([$size])

Returns an icon to show how this commenter is registered to the system - by
MT account, or by external service. (for example, Facebook account, openid 
and such) returns the icon URL, or an empty string if can't find one.

If supplied, $size should contain a string describing the size, such as
'logo' or 'logo_small' (that is the default)

=head2 $author->userpic()

Returns the asset that is this author's user picture, or undef if fails.
Returns a C<MT->model('asset.image')> object

=head2 $author->userpic_file()

Returns the file location of this author's user picture

=head2 $author->userpic_url()

Returns the URL for this author's user picture

If called in scalar context, returns the URL. if called in list context
returns (URL, width, height). returns undef (or an empty list) if the 
picture does not exists.

=head2 $author->userpic_html()

similar to userpic_url, but returns the URL wrapped inside an "img" html tag

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
