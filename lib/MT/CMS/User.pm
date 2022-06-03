# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::User;

use strict;
use warnings;

use MT::Util
    qw( format_ts relative_date is_valid_email is_url encode_url encode_html );
use MT::Author;

sub edit {
    my $cb = shift;
    my ( $app, $id, $obj, $param ) = @_;

    my $author = $app->user;

    # Load permissions from registry
    my %user_perms;

    if ($id) {

        # TODO: Populate permissions / blogs for this user
        # populate blog_loop, permission_loop
        $param->{user_menu_id}          = $id;
        $param->{is_me}                 = 1 if $id == $author->id;
        $param->{editing_other_profile} = 1
            if !$param->{is_me} && $app->can_do('edit_other_profile');

        $param->{userpic} = $obj->userpic_html( Ts => 1, Lazy => 1 );

        # General permissions...
        my $sys_perms = $obj->permissions(0);
        if ( $sys_perms && $sys_perms->permissions ) {
            my @sys_perms = split( ',', $sys_perms->permissions );
            foreach my $perm (@sys_perms) {
                $perm =~ s/'(.+)'/$1/;
                $user_perms{ 'system.' . $perm } = 1;
            }
        }
        $param->{perm_is_superuser} = $obj->is_superuser;

        require MT::Auth;
        if ( $app->user->is_superuser ) {
            $param->{search_label}      = $app->translate('Users');
            $param->{object_type}       = 'author';
            $param->{can_edit_username} = 1;
        }
        else {
            $param->{search_label} = $app->translate('Entry');
            $param->{object_type}  = 'entry';
        }

        $param->{status_enabled} = $obj->is_active ? 1 : 0;
        $param->{status_pending}
            = $obj->status == MT::Author::PENDING() ? 1 : 0;
        $param->{locked_out} = $obj->locked_out ? 1 : 0;
        if ( $app->user->is_superuser ) {
            $param->{recover_lockout_link}
                = MT::Lockout->recover_lockout_uri( $app, $obj,
                { return_args => $app->make_return_args } );
        }
        $param->{unlocked} = $app->param('unlocked') ? 1 : 0;

        $param->{can_modify_sys_perms} = 1
            if $param->{editing_other_profile}
            && ( $app->user->is_superuser || !$obj->is_superuser );
        $param->{can_modify_password}
            = ( $param->{editing_other_profile} || $param->{is_me} )
            && MT::Auth->password_exists;
        $param->{can_modify_api_password}
            = ( $param->{editing_other_profile} || $param->{is_me} );
        $param->{can_recover_password} = MT::Auth->can_recover_password;
        $param->{languages}
            = MT::I18N::languages_list( $app, $obj->preferred_language )
            unless exists $param->{langauges};
        eval { require MT::Image; MT::Image->new or die; };
        $param->{can_use_userpic} = $@ ? 0 : 1;
        $param->{date_format} = $obj->date_format || 'relative';

        if (    $param->{is_me}
            and ( $obj->column('password') !~ /^\$6\$|{SHA}/ )
            and ( not $param->{error} )
            and lc $app->config->AuthenticationModule eq 'mt' )
        {
            $param->{error} = $app->translate(
                "For improved security, please change your password");
        }
    }
    else {
        if ( $app->config->ExternalUserManagement ) {
            return $app->error( MT->translate('Invalid request') );
        }
        $param->{can_modify_password}       = MT::Auth->password_exists;
        $param->{can_modify_api_password}   = 0;
        $param->{can_recover_password}      = MT::Auth->can_recover_password;
        $param->{perm_can_sign_in_cms}      = 1;
        $param->{perm_can_sign_in_data_api} = 1;
        $param->{can_modify_sys_perms}      = 1;
    }

    # Make permission list
    my $perms = $app->model('permission')->perms_from_registry;
    my @perms;
    my @keys = keys %$perms;
    foreach my $key (@keys) {
        next if $key !~ m/^system./;
        next
            if ( exists( $perms->{$key}->{display} )
            && !$perms->{$key}->{display} );
        my $perm;
        ( $perm->{id} = $key ) =~ s/^system\.//;
        $perm->{id} = 'can_' . $perm->{id};

        my $label
            = 'CODE' eq ref( $perms->{$key}{label} )
            ? $perms->{$key}{label}->()
            : $perms->{$key}{label};

        $perm->{label} = $app->translate($label);
        $perm->{order} = $perms->{$key}->{order};
        $perm->{can_do}
            = $id ? $user_perms{$key} : $param->{ 'perm_' . $perm->{id} };

        if ( exists $perms->{$key}->{inherit_from} ) {
            my @inherit;
            my $inherit_from = $perms->{$key}->{inherit_from};
            if ($inherit_from) {
                my @child;
                foreach (@$inherit_from) {
                    my $child = $_;
                    next unless $child =~ m/^system\./;
                    $child =~ s/^system\.//;
                    push @child, '#can_' . $child;
                }
                $perm->{children} = join ',', @child;
            }
        }

        if ( my $unique_id = $perms->{$key}{content_type_unique_id} ) {
            $perm->{content_type_unique_id} = $unique_id;
        }

        push @perms, $perm;
    }

    @perms = sort { $a->{order} <=> $b->{order} } @perms;
    $param->{'loaded_permissions'} = \@perms;

    $app->add_breadcrumb(
        $app->translate("Users"),
        $app->user->can_manage_users_groups
        ? $app->uri(
            mode => 'list',
            args => { '_type' => 'author', blog_id => 0 }
            )
        : undef
    );
    my $auth_prefs;
    if ($obj) {
        $app->add_breadcrumb( $obj->name );
        $param->{languages}
            = MT::I18N::languages_list( $app, $obj->preferred_language );
        $auth_prefs = $obj->entry_prefs;
    }
    else {
        $app->add_breadcrumb( $app->translate("Create User") );
        $param->{languages}
            = MT::I18N::languages_list( $app,
            $app->config('DefaultUserLanguage') )
            unless ( exists $param->{languages} );
        $auth_prefs = { tag_delim => $app->config->DefaultUserTagDelimiter }
            unless ( exists $param->{'auth_pref_tag_delim'} );
    }
    $param->{text_filters} = $app->load_text_filters(
        $obj ? $obj->text_format : $param->{'text_format'}, 'entry' );
    unless ( exists $param->{'auth_pref_tag_delim'} ) {
        my $delim = chr( $auth_prefs->{tag_delim} );
        if ( $delim eq ',' ) {
            $param->{'auth_pref_tag_delim_comma'} = 1;
        }
        elsif ( $delim eq ' ' ) {
            $param->{'auth_pref_tag_delim_space'} = 1;
        }
        else {
            $param->{'auth_pref_tag_delim_other'} = 1;
        }
        $param->{'auth_pref_tag_delim'} = $delim;
    }
    $param->{'nav_authors'} = 1;
    $param->{active_user_menu} = 'profile';

    $param->{'email_is_blank'} = 1
        if $obj && !$obj->email;
    $param->{'email_is_required'} = $app->config('RequiredUserEmail');

    return 1;
}

sub edit_role {
    my $app = shift;

    $app->validate_param({
        blog_id => [qw/ID/],
        id      => [qw/ID/],
        saved   => [qw/MAYBE_STRING/],
    }) or return;

    return $app->return_to_dashboard( redirect => 1 )
        if $app->param('blog_id');

    return $app->permission_denied()
        unless $app->can_do('create_role');

    my %param  = $_[0] ? %{ $_[0] } : ();
    my $author = $app->user;
    my $id     = $app->param('id');

    require MT::Permission;
    if ( !$app->can_do('edit_role') ) {
        return $app->error( $app->translate("Invalid request.") );
    }

    # Load permissions from registry
    my $perms = $app->model('permission')->perms_from_registry;
    for my $perm ( values %$perms ) {
        $perm->{can_do} = 0;
    }
    my $role;
    require MT::Role;
    if ($id) {
        $role = MT::Role->load($id)
            or return $app->error(
            $app->translate( 'Cannot load role #[_1].', $id ) );

        # $param{is_enabled} = $role->is_active;
        $param{is_enabled}  = 1;
        $param{name}        = $role->name;
        $param{description} = $role->description;
        $param{id}          = $role->id;
        my $creator;
        $creator = MT::Author->load( $role->created_by )
            if $role->created_by;
        $param{created_by} = $creator ? $creator->name : '';

        my $permissions = $role->permissions;
        if ( defined($permissions) && $permissions ) {
            my @perms = split ',', $permissions;
            my @roles = MT::Role->load_same(
                { 'id' => [$id] },
                { not  => { id => 1 } },
                1,    # exact match
                @perms
            );
            my @same_perms;
            for my $other_role (@roles) {
                push @same_perms,
                    {
                    name => $other_role->name,
                    id   => $other_role->id,
                    };
            }
            $param{same_perm_loop} = \@same_perms if @same_perms;

            foreach my $perm (@perms) {
                $perm =~ s/'(.+)'/$1/;
                $perms->{ 'blog.' . $perm }->{can_do} = 1;
            }
        }
        my $assoc_class = $app->model('association');
        my $user_count  = $assoc_class->count(
            {   role_id   => $role->id,
                author_id => [ 1, undef ],
            },
            {   unique     => 'author_id',
                range_incl => { author_id => 1 },
            }
        );
        $param{members} = $user_count;
    }
    else {
        for my $p ( values %$perms ) {
            $p->{can_do} = 0;
        }
    }

    # Make permission list
    my @perms;
    my @keys = keys %$perms;
    foreach my $key (@keys) {
        next if $key !~ m/^blog./;
        next
            if ( exists( $perms->{$key}->{display} )
            && !$perms->{$key}->{display} );
        my $perm;
        ( $perm->{id} = $key ) =~ s/^blog\.//;

        my $label
            = 'CODE' eq ref( $perms->{$key}{label} )
            ? $perms->{$key}{label}->()
            : $perms->{$key}{label};

        $perm->{label} = $app->translate($label);
        $perm->{order} = $perms->{$key}->{order};
        $perm->{group} = $perms->{$key}->{group};
        $perm->{can_do}
            = exists $perms->{$key}->{can_do} ? $perms->{$key}->{can_do} : 0;

        if ( exists $perms->{$key}->{inherit_from} ) {
            my @inherit;
            my $inherit_from = $perms->{$key}->{inherit_from};
            if ($inherit_from) {
                my @child;
                foreach (@$inherit_from) {
                    my $child = $_;
                    $child =~ s/^blog\.//;
                    push @child, '#' . $child;
                }
                $perm->{children} = join ',', @child;
            }
        }

        if ( my $unique_id = $perms->{$key}{content_type_unique_id} ) {
            $perm->{content_type_unique_id} = $unique_id;
        }

        push @perms, $perm;
    }

    @perms = sort { ( $a->{order} || 0 ) <=> ( $b->{order} || 0 ) } @perms;

    $param{'loaded_permissions'} = \@perms;

    my $all_perm_flags = MT::Permission->perms('blog');

    for my $ref (@$all_perm_flags) {
        $param{ 'have_access-' . $ref->[0] }
            = ( $role && $role->has( $ref->[0] ) ) ? 1 : 0;
        $param{ 'prompt-' . $ref->[0] } = $ref->[1];
    }
    $param{saved}          = $app->param('saved');
    $param{nav_privileges} = 1;
    $app->add_breadcrumb(
        $app->translate('Roles'),
        $app->uri(
            mode => 'list',
            args => { '_type' => 'role', blog_id => 0 }
        )
    );
    if ($id) {
        $app->add_breadcrumb( $role->name );
    }
    else {
        $app->add_breadcrumb( $app->translate('Create Role') );
    }
    $param{screen_class}        = "settings-screen edit-role";
    $param{object_type}         = 'role';
    $param{object_label}        = MT::Role->class_label;
    $param{object_label_plural} = MT::Role->class_label_plural;
    $param{search_label}        = $app->translate('Users');
    $app->load_tmpl( 'edit_role.tmpl', \%param );
}

sub can_save_role {
    my ( $eh, $app, $id ) = @_;
    return $app->can_do('save_role');
}

sub can_delete_role {
    my ( $eh, $app, $id ) = @_;
    return $app->can_do('delete_role');
}

sub save_role {
    my $app = shift;
    $app->validate_magic() or return;
    $app->can_do('save_role') or return $app->permission_denied();

    $app->validate_param({
        description => [qw/MAYBE_STRING/],
        id          => [qw/ID/],
        name        => [qw/MAYBE_STRING/],
        permission  => [qw/MAYBE_STRING MULTI/],
    }) or return;

    my $id    = $app->param('id');
    my @perms = $app->multi_param('permission');
    my $role;
    require MT::Role;
    $role = $id ? MT::Role->load($id) : MT::Role->new;
    my $name = $app->param('name') || '';
    $name =~ s/(^\s+|\s+$)//g;
    return $app->errtrans("Role name cannot be blank.")
        if $name eq '';

    my $role_by_name = MT::Role->load( { name => $name } );
    if ( $role_by_name && ( !$id || $role_by_name->id != $id ) ) {
        return $app->errtrans("Another role already exists by that name.");
    }
    if ( !@perms ) {
        return $app->errtrans(
            "You cannot define a role without permissions.");
    }

    my $description = $app->param('description');
    $role->name($name);
    $role->description($description);
    $role->clear_full_permissions;
    $role->set_these_permissions(@perms);
    if ( $role->id ) {
        $role->modified_by( $app->user->id );
    }
    else {
        $role->created_by( $app->user->id );
    }
    $role->save or return $app->error( $role->errstr );

    my $url;
    $url = $app->uri(
        'mode' => 'view',
        args   => { _type => 'role', id => $role->id, saved => 1 }
    );
    $app->redirect($url);
}

sub enable {
    my $app = shift;
    set_object_status( $app, MT::Author::ACTIVE() );
}

sub disable {
    my $app = shift;
    set_object_status( $app, MT::Author::INACTIVE() );
}

sub set_object_status {
    my ( $app, $new_status ) = @_;

    $app->validate_param({
        _type         => [qw/OBJTYPE/],
        all_selected  => [qw/MAYBE_STRING/],
        id            => [qw/ID MULTI/],
        is_power_edit => [qw/MAYBE_STRING/],
    }) or return;

    $app->validate_magic() or return;
    return $app->permission_denied()
        unless $app->user->can_manage_users_groups;
    return $app->error( $app->translate("Invalid request.") )
        if $app->request_method ne 'POST';

    my $type = $app->param('_type') || '';
    return $app->error( $app->translate('Invalid type') )
        unless ( $type eq 'user' )
        || ( $type eq 'author' )
        || ( $type eq 'group' );

    my $class = $app->model($type);
    $app->setup_filtered_ids
        if $app->param('all_selected');

    my @sync;
    my $saved       = 0;
    my $not_enabled = 0;
    for my $id ( $app->multi_param('id') ) {
        next unless $id;    # avoid 'empty' ids
        my $obj = $class->load($id);
        next unless $obj;
        next if ( $obj->id == $app->user->id ) && ( $type eq 'author' );
        next if $new_status == $obj->status;
        next
            if !$app->user->is_superuser
            && ( $type eq 'author' && $obj->is_superuser );

        $obj->status($new_status);
        if ( $type ne 'group' and $new_status == MT::Author::ACTIVE() ) {
            my $eh = MT::ErrorHandler->new;
            if ( !save_filter( $eh, $app, $obj ) ) {
                $app->log(
                    {   message => $app->translate(
                            "User '[_1]' (ID:[_2]) could not be re-enabled by '[_3]'",
                            $obj->name, $obj->id, $app->user->name,
                        ),
                        metadata => $eh->errstr,
                        level    => MT::Log::ERROR(),
                        class    => 'author',
                        category => 'not_enabled',
                    }
                );
                $not_enabled++;
                next;
            }
        }
        $obj->save;
        $saved++;
        if ( $type eq 'author' ) {
            if ( $new_status == MT::Author::ACTIVE() ) {
                push @sync, $obj;
            }
        }
    }
    my $unchanged = 0;
    if (@sync) {
        MT::Auth->synchronize_author( User => \@sync );
        foreach (@sync) {
            if ( $_->status != MT::Author::ACTIVE() ) {
                $unchanged++;
            }
        }
    }
    if ( $saved && ( $saved > $unchanged ) && !$not_enabled ) {
        $app->add_return_arg(
            saved_status => ( $new_status == MT::Author::ACTIVE() )
            ? 'enabled'
            : 'disabled'
        );
    }
    $app->add_return_arg( is_power_edit => 1 )
        if $app->param('is_power_edit');
    $app->add_return_arg( unchanged => $unchanged )
        if $unchanged;
    $app->add_return_arg( not_enabled => $not_enabled )
        if $not_enabled;
    $app->call_return;
}

sub unlock {
    my ($app) = @_;

    $app->validate_param({
        all_selected  => [qw/MAYBE_STRING/],
        id            => [qw/ID MULTI/],
        is_power_edit => [qw/MAYBE_STRING/],
    }) or return;

    require MT::Lockout;

    $app->validate_magic() or return;
    return $app->permission_denied()
        unless $app->user->can_manage_users_groups;
    return $app->error( $app->translate("Invalid request.") )
        if $app->request_method ne 'POST';

    my $class = $app->model('author');
    $app->setup_filtered_ids
        if $app->param('all_selected');

    my @sync;
    my $saved = 0;
    for my $id ( $app->multi_param('id') ) {
        next unless $id;    # avoid 'empty' ids
        my $obj = $class->load($id);
        next unless $obj;

        MT::Lockout->unlock($obj);
        $obj->save;
    }
    $app->add_return_arg( saved_status => 'unlocked', );

    $app->add_return_arg( is_power_edit => 1 )
        if $app->param('is_power_edit');

    $app->call_return;
}

sub recover_lockout {
    my $app     = shift;

    $app->validate_param({
        return_args => [qw/MAYBE_STRING/],
        token       => [qw/MAYBE_STRING/],
        user_id     => [qw/ID/],
    }) or return;

    my $user_id = $app->param('user_id');
    my $token   = $app->param('token');

    my $user = $app->model('author')->load($user_id)
        or return $app->errtrans("Invalid request");

    require MT::Lockout;
    if ( !MT::Lockout->validate_recover_token( $app, $user, $token ) ) {
        return $app->errtrans("Invalid request");
    }

    MT::Lockout->unlock($user);
    $user->save
        or die $user->errstr;

    if ( $app->param('return_args') ) {
        $app->add_return_arg( unlocked => 1 );
        return $app->call_return;
    }

    my $params = {
        author_nickname => $user->nickname,
        author_name     => $user->name,
    };

    if ( $app->isa('MT::App::CMS') ) {
        $params->{author_edit_link} = $app->base
            . $app->uri(
            mode => 'view',
            args => {
                '_type' => 'author',
                'id'    => $user->id,
            },
            );
    }

    $app->{template_dir} = 'cms';
    $app->load_tmpl( 'recover_lockout.tmpl', $params );
}

## DEPRECATED: v6.2
sub upload_userpic {
    my $app = shift;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.8');

    $app->validate_magic() or return;
    return $app->errtrans("Invalid request.")
        if $app->param('blog_id');

    my $user_id = $app->param('user_id');
    my $user    = MT->model('author')->load($user_id)
        or return $app->errtrans("Invalid request.");

    my $appuser = $app->user;
    if (   ( !$appuser->can_manage_users_groups )
        && ( $user->id != $appuser->id ) )
    {
        return $app->permission_denied();
    }

    require MT::CMS::Asset;
    my ( $asset, $bytes )
        = MT::CMS::Asset::_upload_file( $app, @_, require_type => 'image', );
    return if !defined $asset;
    return $asset if !defined $bytes;    # whatever it is

    ## TODO: should this be layered into _upload_file somehow, so we don't
    ## save the asset twice?
    $asset->tags('@userpic');
    $asset->created_by($user_id);
    $asset->save;

    $app->forward( 'asset_userpic',
        { asset => $asset, user_id => $user_id } );
}

sub cfg_system_users {
    my $app = shift;
    my %param;
    if ( $app->param('blog_id') ) {
        return $app->return_to_dashboard( redirect => 1 );
    }

    return $app->permission_denied()
        unless $app->user->is_superuser();
    my $cfg = $app->config;
    $app->add_breadcrumb( $app->translate('User Settings') );
    $param{nav_config} = 1;

    $param{nav_settings} = 1;
    $param{languages}    = MT::I18N::languages_list( $app,
        $app->config('DefaultUserLanguage') );
    my $tag_delim = $app->config('DefaultUserTagDelimiter') || ord(',');
    if ( $tag_delim eq ord(',') ) {
        $tag_delim = 'comma';
    }
    elsif ( $tag_delim eq ord(' ') ) {
        $tag_delim = 'space';
    }
    else {
        $tag_delim = 'comma';
    }
    $param{"tag_delim_$tag_delim"} = 1;

    my @constrains = $app->config('UserPasswordValidation');
    $param{"combo_upper_lower"}
        = grep( { $_ eq 'upperlower' } @constrains ) ? 1 : 0;
    $param{"combo_letter_number"}
        = grep( { $_ eq 'letternumber' } @constrains ) ? 1 : 0;
    $param{"require_special_characters"}
        = grep( { $_ eq 'symbol' } @constrains ) ? 1 : 0;
    $param{"minimum_length"} = $app->config('UserPasswordMinLength');

    ( my $tz = $app->config('DefaultTimezone') ) =~ s![-\.]!_!g;
    $tz =~ s!_00$!!;
    $param{ 'server_offset_' . $tz } = 1;

    $param{system_email_address} = $cfg->EmailAddressMain;
    $param{system_no_email}      = 1 unless $cfg->EmailAddressMain;
    $param{saved}                = $app->param('saved');
    $param{error}                = $app->param('error');
    $param{screen_class}         = "settings-screen system-general-settings";
    my $registration = $cfg->CommenterRegistration;
    if ( $registration->{Allow} ) {
        $param{registration} = 1;
        if ( my $ids = $registration->{Notify} ) {
            my @ids = split ',', $ids;
            my @sysadmins = MT::Author->load(
                {   id   => \@ids,
                    type => MT::Author::AUTHOR()
                },
                {   join => MT::Permission->join_on(
                        'author_id',
                        {   permissions => "\%'administer'\%",
                            blog_id     => '0',
                        },
                        { 'like' => { 'permissions' => 1 } }
                    )
                }
            );
            my @names;
            foreach my $a (@sysadmins) {
                push @names, $a->name . '(' . $a->id . ')';
            }
            $param{notify_user_id} = $ids;
            $param{notify_user_name} = join ',', @names;
        }
    }

    my @readonly_configs
        = qw( CommenterRegistration DefaultTimeZone DefaultUserLanguage DefaultUserTagDelimiter
        UserPasswordValidation UserPasswordMinLength );

    my @config_warnings;
    for my $config_directive (@readonly_configs) {
        if ( $app->config->is_readonly($config_directive) ) {
            push( @config_warnings, $config_directive );

            if ( $config_directive eq 'DefaultUserLanguage' ) {
                $param{default_language_readonly} = 1;
            }
            else {
                my $snake_case = $config_directive;
                $snake_case =~ s/^([A-Z])/\l$1/;
                $snake_case =~ s/([A-Z])/_\l$1/g;
                $param{ $snake_case . '_readonly' } = 1;
            }
        }
    }
    my $config_warning;
    $config_warning = join( ", ", @config_warnings ) if (@config_warnings);

    $param{config_warning} = $app->translate(
        "These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.",
        $config_warning
    ) if $config_warning;

    $app->load_tmpl( 'cfg_system_users.tmpl', \%param );
}

sub save_cfg_system_users {
    my $app = shift;
    $app->validate_magic or return;
    return $app->permission_denied()
        unless $app->user->is_superuser();

    $app->validate_param({
        combo_letter_number         => [qw/MAYBE_STRING/],
        combo_upper_lower           => [qw/MAYBE_STRING/],
        default_language            => [qw/MAYBE_STRING/],
        default_time_zone           => [qw/MAYBE_STRING/],
        default_user_tag_delimiter  => [qw/MAYBE_STRING/],
        minimum_length              => [qw/MAYBE_STRING/],
        new_user_default_website_id => [qw/ID/],
        new_user_theme_id           => [qw/MAYBE_STRING/],
        notify_user_id              => [qw/IDS/],
        registration                => [qw/MAYBE_STRING/],
        require_special_characters  => [qw/MAYBE_STRING/],
    }) or return;

    my $theme_id = $app->param('new_user_theme_id') || '';
    if ($theme_id) {
        require MT::Theme;
        MT::Theme->load($theme_id)
            or return $app->error(
            $app->translate("Invalid ID given for personal blog theme.") );
    }

    my $default_website_id = $app->param('new_user_default_website_id') || '';
    if ( $default_website_id =~ m/^\d+$/ ) {
        require MT::Website;
        MT::Website->load($default_website_id)
            or return $app->error(
            $app->translate(
                "Invalid ID given for personal blog clone location ID.")
            );
    }
    else {
        if ( $default_website_id ne '' ) {
            return $app->error(
                $app->translate(
                    "Invalid ID given for personal blog clone location ID.")
            );
        }
    }

    my $cfg              = $app->config;
    my $tz               = $app->param('default_time_zone');
    my $default_language = $app->param('default_language');
    my $default_user_tag_delimiter
        = $app->param('default_user_tag_delimiter');
    $app->config( 'DefaultTimezone',         $tz,                         1 );
    $app->config( 'DefaultUserLanguage',     $default_language,           1 );
    $app->config( 'DefaultUserTagDelimiter', $default_user_tag_delimiter, 1 );
    my $registration = $cfg->CommenterRegistration;

    if ( my $reg = $app->param('registration') ) {
        $registration->{Allow} = $reg ? 1 : 0;
        $registration->{Notify} = $app->param('notify_user_id');
        $cfg->CommenterRegistration( $registration, 1 );
    }
    elsif ( $registration->{Allow} ) {
        $registration->{Allow} = 0;
        $cfg->CommenterRegistration( $registration, 1 );
    }

    my @constrains;
    $app->config(
        'UserPasswordValidation',
        [   ( $app->param('combo_upper_lower')   ? 'upperlower'   : () ),
            ( $app->param('combo_letter_number') ? 'letternumber' : () ),
            ( $app->param('require_special_characters') ? 'symbol' : () ),
        ],
        1
    );

    if ( 'MT' eq uc $app->config('AuthenticationModule')
        && !$app->config->is_readonly('UserPasswordMinLength') )
    {
        my $pass_min_len = $app->param('minimum_length');
        if (   !$pass_min_len
            or ( $pass_min_len =~ m/\D/ )
            or ( $pass_min_len < 1 ) )
        {
            return $app->errtrans(
                'Minimum password length must be an integer and greater than zero.'
            );
        }
        $app->config( 'UserPasswordMinLength', int $pass_min_len, 1 );
    }

    $cfg->save_config();

    $app->redirect(
        $app->uri(
            'mode' => 'cfg_system_users',
            args   => { saved => 1 },
        )
    );
}

sub remove_user_assoc {
    my $app = shift;
    $app->validate_magic or return;

    $app->validate_param({
        all_selected => [qw/MAYBE_STRING/],
        blog_id      => [qw/ID/],
        id           => [qw/ID MULTI/],
    }) or return;

    my $user = $app->user;
    return $app->permission_denied()
        unless $app->can_do('remove_user_assoc');
    my $can_remove_administrator
        = $app->can_do('remove_administrator_association');

    my $blog_id = $app->param('blog_id');

    $app->setup_filtered_ids
        if $app->param('all_selected');
    my @ids = $app->multi_param('id');
    return $app->errtrans("Invalid request.")
        unless $blog_id && @ids;

    require MT::Association;
    require MT::Permission;
    foreach my $id (@ids) {
        next unless $id;
        my $perm = MT::Permission->load(
            { blog_id => $blog_id, author_id => $id } );
        next
            if !$can_remove_administrator
            && $perm
            && $perm->can_administer_site;

        MT::Association->remove( { blog_id => $blog_id, author_id => $id } );

        # Rebuild permissions because the user may belong to several groups
        $perm->rebuild if $perm;
    }

    $app->add_return_arg( saved => 1 );
    $app->call_return;
}

sub grant_role {
    my $app = shift;

    my $user = $app->user;
    return unless $app->validate_magic;
    my $blogs
        = $app->param('blog')
        || $app->param('website')
        || $app->param('site')
        || '';
    my $authors = $app->param('author') || '';
    my $roles   = $app->param('role')   || '';
    my $author_id = $app->param('author_id');
    my $blog_id   = $app->param('blog_id');
    my $role_id   = $app->param('role_id');

    my @blogs    = split /,/, $blogs;
    my @authors  = split /,/, $authors;
    my @role_ids = split /,/, $roles;

    require MT::Blog;
    require MT::Role;

    push @blogs, $blog_id if $blog_id;
    foreach (@blogs) {
        my $id = $_;
        $id =~ s/\D//g;
        $_ = MT::Blog->load($id);
    }
    @blogs = grep { defined $_ } @blogs;

    my @can_grant_administer = map 1, 1 .. @blogs;
    if ( !$user->can_manage_users_groups ) {
        for ( my $i = 0; $i < scalar(@blogs); $i++ ) {
            my $perm = $user->permissions( $blogs[$i] );
            if ( !$perm->can_do('grant_administer_role') ) {
                $can_grant_administer[$i] = 0;
                if ( !$perm->can_do('grant_role_for_blog') ) {
                    return $app->permission_denied();
                }
            }
        }
    }

    push @role_ids, $role_id if $role_id;
    my @roles = grep { defined $_ }
        map { MT::Role->load($_) }
        map { my $id = $_; $id =~ s/\D//g; $id } @role_ids;

    push @authors, $author_id if $author_id;
    my $add_pseudo_new_user = 0;
    foreach (@authors) {
        my $id = $_;
        if ( $id =~ /PSEUDO/ ) {
            $add_pseudo_new_user = 1;
            next;
        }
        $id =~ s/\D//g;
        $_ = MT::Author->load($id);
    }
    @authors = grep { ref $_ } @authors;
    $app->error(undef);

    my @default_assignments;

    # Load permission which has administer_site
    require MT::Association;
    require MT::Role;
    my @admin_roles = MT::Role->load_by_permission("administer_site");
    my $admin_role;
    foreach my $r (@admin_roles) {
        next if $r->permissions =~ m/\'administer_site\'/;
        $admin_role = $r;
        last;
    }

    # TBD: handle case for associating system roles to users/groups
    foreach my $blog (@blogs) {
        my $can_grant_administer = shift @can_grant_administer;
        foreach my $role (@roles) {
            next
                if ( ( !$can_grant_administer )
                && ( $role->has('administer_site') ) );
            if ($add_pseudo_new_user) {
                push @default_assignments, $role->id . ',' . $blog->id;
            }
            foreach my $ug (@authors) {
                next unless ref $ug;
                MT::Association->link( $ug => $role => $blog );
                if (   $admin_role
                    && $role->has('administer_site')
                    && !$blog->is_blog )
                {
                    my $blogs = $blog->blogs;
                    foreach my $mem_blog (@$blogs) {
                        MT::Association->link(
                            $ug => $admin_role => $mem_blog );
                    }
                }
            }
        }
    }

    if ( $add_pseudo_new_user && @default_assignments ) {
        my @data;
        my @def = split ',', $app->config('DefaultAssignments');
        while ( my $role_id = shift @def ) {
            my $blog_id = shift @def;
            push @data, join( ',', $role_id, $blog_id );
        }
        foreach my $da (@default_assignments) {
            push @data, $da if !grep { $_ eq $da } @data;
        }
        $app->config( 'DefaultAssignments', join( ',', @data ), 1 );
        $app->config->save_config;
    }

    _grant_role_for_group( $app, \@blogs, \@roles )
        if ( $app->model("group")
        && ( $app->param('group') || $app->param('group_id') ) );

    $app->add_return_arg( saved => 1 );
    $app->call_return;
}

sub _grant_role_for_group {
    my $app = shift;
    my ( $blogs, $roles ) = @_;

    my $groups = $app->param('group') || '';
    my $group_id = $app->param('group_id');

    my @groups = split /,/, $groups;
    my $grp_class = $app->model("group");

    push @groups, $group_id if $group_id;
    foreach my $group (@groups) {
        return unless $grp_class;
        my $id = $group;
        $id =~ s/\D//g;
        $group = $grp_class->load($id);
    }
    @groups = grep { ref $_ } @groups;
    $app->error(undef);

    require MT::Association;

    foreach my $blog (@$blogs) {
        foreach my $role (@$roles) {
            foreach my $ug (@groups) {
                MT::Association->link( $ug => $role => $blog );
            }
        }
    }

}

sub dialog_select_author {
    my $app = shift;

    my $blog = $app->blog;
    return $app->errtrans('Invalid request')
        unless $blog;

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        $row->{label}       = $row->{name};
        $row->{description} = $row->{nickname};
    };

    my %hash = $app->param_hash();

    my $entry_type = $app->param('entry_type') || 'entry';
    my $json       = $app->param('json');
    my $multi      = $app->param('multi');
    my $idfield    = $app->param('idfield');
    my $namefield  = $app->param('namefield');

    my @blog_ids;
    if ( !$blog->is_blog && $app->param('include_child') ) {
        my $blogs = $blog->blogs;
        foreach (@$blogs) {
            push @blog_ids, $_->id;
        }
    }
    push @blog_ids, $blog->id;

    if ( !$app->user->can_manage_users_groups ) {
        my @ids;
        @ids = map { $_->id } @{ $blog->blogs }
            if !$blog->is_blog;
        push @ids, $blog->id;
        my $ok;
        foreach (@ids) {
            $ok = 1
                if $app->user->permissions($_)
                ->can_do('open_select_author_dialog');
        }
        return $app->permission_denied
            unless $ok;
    }

    $app->listing(
        {   type  => 'author',
            terms => {
                type   => MT::Author::AUTHOR(),
                status => MT::Author::ACTIVE(),
            },
            args => {
                sort => 'name',
                join => MT::Permission->join_on(
                    'author_id',
                    {   (   $entry_type eq 'page'
                            ? ( permissions => "%\'manage_pages\'%" )
                            : ( permissions => "%\'create_post\'%" )
                        ),
                        blog_id => \@blog_ids,
                    },
                    { 'like' => { 'permissions' => 1 }, unique => 1 }
                ),
            },
            code     => $hasher,
            template => $json ? 'include/listing_panel.tmpl'
            : 'dialog/select_users.tmpl',
            params => {
                (   $entry_type eq 'entry'
                    ? ( dialog_title =>
                            $app->translate("Select a entry author") )
                    : ( dialog_title =>
                            $app->translate("Select a page author") )
                ),
                items_prompt  => $app->translate("Selected author"),
                search_prompt => $app->translate(
                    "Type a username to filter the choices below."),
                panel_label       => $app->translate('Username'),
                panel_description => $app->translate('Display Name'),
                panel_type        => 'author',
                panel_multi       => defined $multi ? $multi : 0,
                panel_searchable  => 1,
                panel_first       => 1,
                panel_last        => 1,
                list_noncron      => 1,
                idfield           => $idfield,
                namefield         => $namefield,
            },
        }
    );
}

sub dialog_select_sysadmin {
    my $app = shift;
    return $app->permission_denied()
        unless $app->user->is_superuser;

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        $row->{label}       = $row->{name};
        $row->{description} = $row->{nickname};
    };

    my $json      = $app->param('json');
    my $multi     = $app->param('multi');
    my $idfield   = $app->param('idfield');
    my $namefield = $app->param('namefield');
    $app->listing(
        {   type  => 'author',
            terms => {
                type   => MT::Author::AUTHOR(),
                status => MT::Author::ACTIVE(),
            },
            args => {
                sort => 'name',
                join => MT::Permission->join_on(
                    'author_id',
                    {   permissions => "\%'administer'\%",
                        blog_id     => '0',
                    },
                    { 'like' => { 'permissions' => 1 } }
                ),
            },
            code     => $hasher,
            template => $json
            ? 'include/listing_panel.tmpl'
            : 'dialog/select_users.tmpl',
            params => {
                dialog_title =>
                    $app->translate("Select a System Administrator"),
                items_prompt =>
                    $app->translate("Selected System Administrator"),
                search_prompt => $app->translate(
                    "Type a username to filter the choices below."),
                panel_label       => $app->translate("System Administrator"),
                panel_description => $app->translate("Name"),
                panel_type        => 'author',
                panel_multi       => defined $multi ? $multi : 0,
                panel_searchable  => 1,
                panel_first       => 1,
                panel_last        => 1,
                list_noncron      => 1,
                idfield           => $idfield,
                namefield         => $namefield,
            },
        }
    );
}

# This mode can be called to service a number of views
# Adding roles->blogs for a user
# Adding roles->blogs for a group
# Adding users->roles->blogs
# Adding groups->roles->blogs
sub dialog_grant_role {
    my $app = shift;

    my $author_id = $app->param('author_id');
    my $blog_id   = $app->param('blog_id');
    my $role_id   = $app->param('role_id');

    my $this_user = $app->user;

PERMCHECK: {
        last PERMCHECK
            if $app->can_do('grant_role_for_all_blogs');
        last PERMCHECK
            if $blog_id
            && $this_user->permissions($blog_id)
            ->can_do('grant_role_for_blog');
        return $app->permission_denied();
    }

    my ( $user, $role );
    if ( $author_id && $author_id ne 'PSEUDO' ) {
        $user = MT::Author->load($author_id);
    }
    if ($role_id) {
        require MT::Role;
        $role = MT::Role->load($role_id);
    }

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        $row->{label} = $row->{name};
        $row->{description} = $row->{nickname} if exists $row->{nickname};
        my $type = $app->param('type') || '';
        if ( $type && $type eq 'site' ) {
            if (   !$app->param('search')
                && UNIVERSAL::isa( $obj, 'MT::Website' )
                && $obj->has_blog() )
            {
                $row->{has_child} = 1;
                my $child_blogs = $obj->blogs();
                my $child_sites = [];
                push @$child_sites,
                    {
                    id          => $_->id,
                    label       => $_->name,
                    description => $_->description
                    } foreach @{$child_blogs};
                $row->{child_obj}       = $child_sites;
                $row->{child_obj_count} = scalar @{$child_blogs};
            }
        }
        $row->{disabled} = 1
            if UNIVERSAL::isa( $obj, 'MT::Role' )
            && $obj->has('administer_site')
            && !$app->can_do('grant_role_for_all_blogs')
            && !$this_user->permissions($blog_id)
            ->can_do('grant_role_for_blog');
        if (   $type
            && $type eq 'blog'
            && UNIVERSAL::isa( $obj, 'MT::Role' )
            && $obj->has('administer_site') )
        {
            $row->{disabled} = 1;
        }
        if (   $type
            && $type eq 'website'
            && UNIVERSAL::isa( $obj, 'MT::Role' )
            && $obj->has('administer_site') )
        {
            $row->{disabled} = 1;
        }
        if ( UNIVERSAL::isa( $obj, 'MT::Author' ) ) {
            if ( $obj->userpic_url ) {
                $row->{icon} = $obj->userpic_url();
            }
            else {
                $row->{icon}
                    = MT->static_path . 'images/icons/ic_user-auth.svg';
            }
        }
        if ( UNIVERSAL::isa( $obj, 'MT::Group' ) ) {
            $row->{icon} = MT->static_path . 'images/icons/ic_group.svg';
        }

        if (UNIVERSAL::isa($obj, 'MT::Blog') && $obj->is_blog()) {
            if (my $parent = $obj->website) {
                # replace row only if the blog has a valid parent
                $row->{has_child} = 1;
                my $child_blogs = [$obj];
                my $child_sites = [];
                foreach (@{$child_blogs}) {
                    push @$child_sites, {
                        id          => $_->id,
                        label       => $_->name,
                        description => $_->description
                    };
                }
                $row->{child_obj}       = $child_sites;
                $row->{child_obj_count} = scalar @{$child_blogs};
                $row->{id}              = $parent->id;
                $row->{label}           = $parent->name;
                $row->{description}     = $parent->description;
            }
        }
    };
    my $pre_build = sub {
        my ($param) = @_;
        my $loop = $param->{object_loop};
        my @has_child_sites    = grep { $_->{has_child}; } @$loop;
        my %has_child_site_ids = map { $_->{id} => 1 } @has_child_sites;
        my @new_object_loop;
        my %seen;
        foreach my $data (@$loop) {

            # If you have has_child, it is created after the search,
            # so remove the retrieved object
            if ( !$data->{has_child} && $has_child_site_ids{$data->{id}} ) {
                next;
            }
            next if $seen{$data->{id}}++;
            push @new_object_loop, $data;
        }
        $param->{object_loop} = \@new_object_loop;
    };

    my $type = $app->param('_type') || '';  # user, author, group, site

    if ( $app->param('search') || $app->param('json') ) {
        my $params = {
            panel_type   => $type,
            list_noncron => 1,
            panel_multi  => 1,
            has_group    => 1,
        };
        if ($type eq 'user') {
            my $author_terms = {
                status => MT::Author::ACTIVE(),
                type   => MT::Author::AUTHOR()
            };
            require MT::Group;
            my $group_terms = { status => MT::Group::ACTIVE() };
            my $no_limit
                = $app->param('no_limit')
                ? 1
                : ( $app->param('search') ? 1 : 0 );
            $app->multi_listing(
                {   args => { sort => 'name' },
                    type         => [ 'group', 'author' ],
                    code         => $hasher,
                    params       => $params,
                    author_terms => $author_terms,
                    group_terms  => $group_terms,
                    template     => 'include/listing_panel.tmpl',
                    $no_limit ? ( no_limit => 1 ) : (),
                }
            );
        }
        else {
            my $terms = {};
            if ($type eq 'author') {
                $terms->{status} = MT::Author::ACTIVE();
                $terms->{type}   = MT::Author::AUTHOR();
            }
            if ($type eq 'group') {
                require MT::Group;
                $terms->{status} = MT::Group::ACTIVE();
            }
            if ($type eq 'site') {
                $terms->{class} = ['website', 'blog'];
            }
            $app->listing(
                {   terms    => $terms,
                    args     => { sort => 'name' },
                    type     => $type,
                    code     => $hasher,
                    params   => $params,
                    template => 'include/listing_panel.tmpl',
                    $type eq 'site'       ? ( pre_build => $pre_build ) : (),
                    $app->param('search') ? ( no_limit  => 1 )          : (),
                }
            );
        }
    }
    else {

        # traditional, full-screen listing
        my $params = {
            ( $author_id || 0 ) eq 'PSEUDO'
            ? ( edit_author_name => $app->translate('(newly created user)'),
                edit_author_id   => 'PSEUDO'
                )
            : $author_id ? (
                edit_author_name => $user->nickname
                ? $user->nickname
                : $user->name,
                edit_author_id => $user->id,
                )
            : (),
            $role_id
            ? ( role_name => $role->name,
                role_id   => $role->id,
                )
            : (),
        };

        my @panels;
        if ( !$role_id ) {
            push @panels, 'role';
        }
        if ( !$blog_id ) {
            my @blogs;
            my $iter = MT::Blog->load_iter( { class => '*' } );
            while ( my $blog = $iter->() ) {
                push @blogs, $blog->id;
            }

            # if only one blog exists, skip the blog selection step.
            if ( @blogs == 1 ) {
                $blog_id = $blogs[0];
            }
            else {
                push @panels, 'blog'
                    if ( $app->param('type')
                    && $app->param('type') eq 'blog' );
                push @panels, 'website'
                    if ( $app->param('type')
                    && $app->param('type') eq 'website' );

                if (   $app->param('type')
                    && $app->param('type') eq 'site' )
                {
                    push @panels, 'site';

                }
            }
        }

        if ( !$author_id ) {
            if ( $type eq 'user' ) {
                unshift @panels, 'author';
            }
        }

        my $panel_info = {
            'site' => {
                panel_title       => $app->translate("Select Site"),
                panel_label       => $app->translate("Site Name"),
                items_prompt      => $app->translate("Sites Selected"),
                panel_description => $app->translate("Description"),
            },
            'author' => {
                panel_title       => $app->translate("Select Users"),
                panel_label       => $app->translate("Username"),
                items_prompt      => $app->translate("Users Selected"),
                panel_description => $app->translate("Name"),
            },
            'role' => {
                panel_title       => $app->translate("Select Roles"),
                panel_label       => $app->translate("Role Name"),
                items_prompt      => $app->translate("Roles Selected"),
                panel_description => $app->translate("Description"),
            },
        };

        $params->{panel_multi}  = 1;
        $params->{blog_id}      = $blog_id;
        $params->{dialog_title} = $app->translate("Grant Permissions");
        $params->{panel_loop}   = [];
        $params->{has_group}    = 1;

        for ( my $i = 0; $i <= $#panels; $i++ ) {
            my $source       = $panels[$i];
            my $panel_params = {
                panel_type => $source,
                %{ $panel_info->{$source} },
                list_noncron     => 1,
                panel_last       => $i == $#panels,
                panel_first      => $i == 0,
                panel_number     => $i + 1,
                panel_total      => $#panels + 1,
                panel_has_steps  => ( $#panels == '0' ? 0 : 1 ),
                panel_searchable => ( $source eq 'role' ? 0 : 1 ),
            };

            # Only show active user/groups.
            my $limit = $app->param('limit') || 25;
            my $terms = {};
            my $args  = {
                sort  => 'name',
                limit => $limit,
            };
            if ( $source eq 'author' ) {
                $terms->{status} = MT::Author::ACTIVE();
                $terms->{type}   = MT::Author::AUTHOR();
            }

            if ( $source eq 'site' ) {
                $terms->{class} = 'website';
            }

            if ( $source eq 'author' ) {
                $panel_params->{panel_title}
                    = $app->translate("Select Groups And Users");
                $panel_params->{items_prompt}
                    = $app->translate("Groups/Users Selected");
                $panel_params->{panel_label}
                    = $app->translate("User/Group Name");
                $panel_params->{panel_description}
                    = $app->translate("Description");

                my $author_terms = {
                    status => MT::Author::ACTIVE(),
                    type   => MT::Author::AUTHOR()
                };
                require MT::Group;
                my $group_terms = { status => MT::Group::ACTIVE() };
                $app->multi_listing(
                    {   no_html      => 1,
                        code         => $hasher,
                        type         => [ 'group', 'author' ],
                        params       => $panel_params,
                        author_terms => $author_terms,
                        group_terms  => $group_terms,
                        args         => $args,
                    }
                );
            }
            else {

                $app->listing(
                    {   no_html => 1,
                        code    => $hasher,
                        type    => $source,
                        params  => $panel_params,
                        terms   => $terms,
                        args    => $args,
                    }
                );
            }
            if (!$panel_params->{object_loop}
                || ( $panel_params->{object_loop}
                    && @{ $panel_params->{object_loop} } < 1 )
                )
            {
                $params->{"missing_$source"} = 1;
                $params->{"missing_data"}    = 1;
            }
            push @{ $params->{panel_loop} }, $panel_params;
        }

        # save the arguments from whence we came...
        $params->{return_args} = $app->return_args;

        if ( $app->param('role_selection') ) {
            $params->{role_selection} = 1;
        }

        $params->{build_compose_menus} = 0;
        $params->{build_user_menus}    = 0;

        $app->load_tmpl( 'dialog/create_association.tmpl', $params );
    }
}

sub dialog_select_assoc_type {
    my $app = shift;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    my $blog_id   = $app->param('blog_id');
    my $this_user = $app->user;
PERMCHECK: {
        last PERMCHECK
            if $app->can_do('grant_role_for_all_blogs');
        last PERMCHECK
            if $blog_id
            && $this_user->permissions($blog_id)
            ->can_do('grant_role_for_blog');
        return $app->permission_denied();
    }

    my $params;

    $params->{return_args} = $app->param('return_args')
        || '__mode=list&_type=association&blog_id=0';

    my $group = MT->registry( 'object_types', 'group' );
    $params->{has_group} = $group ? 1 : 0;

    $app->load_tmpl( 'dialog/select_association_type.tmpl', $params );
}

sub remove_userpic {
    my $app = shift;
    $app->validate_magic() or return;

    $app->validate_param({
        user_id => [qw/ID/],
    }) or return;

    my $user_id = $app->param('user_id');
    my $user    = $app->model('author')->load($user_id)
        or return;

    my $appuser = $app->user;
    if (   ( !$appuser->can_manage_users_groups )
        && ( $user->id != $appuser->id ) )
    {
        return $app->permission_denied();
    }
    if ( $user->userpic_asset_id ) {
        my $old_file = $user->userpic_file();
        my $fmgr     = MT::FileMgr->new('Local');
        if ( $fmgr->exists($old_file) ) {
            $fmgr->delete($old_file);
        }
        $user->userpic_asset_id(0);
        $user->save;
    }
    return 'success';
}

sub can_delete_association {
    my ( $eh, $app, $obj ) = @_;

    my $blog_id = $app->param('blog_id');
    my $user    = $app->user;
    if ( !$user->can_manage_users_groups ) {
        if (   !$blog_id
            || !$user->permissions($blog_id)->can_do('delete_association') )
        {
            return $eh->error( MT->translate("Permission denied.") );
        }
        if ( $obj->author_id == $user->id ) {
            return $eh->error(
                MT->translate("You cannot delete your own association.") );
        }
    }
    1;
}

sub cms_pre_load_filtered_list_assoc {
    my ( $cb, $app, $filter, $opts, $cols ) = @_;
    $filter->append_item( { type => '_type', } );
    if ( !$app->can_do('access_to_any_permission_list') ) {
        $filter->append_item(
            {   type => 'author_id',
                args => {
                    option => 'eq',
                    value  => $app->user->id,
                },
            }
        );
    }
}

sub template_param_list {
    my $cb = shift;
    my ( $app, $param, $tmpl ) = @_;
    return if $app->can_do('access_to_permission_list');
    $param->{use_filters}      = 0;
    $param->{use_actions}      = 0;
    $param->{has_list_actions} = 0;
    my $author_name = $app->user->name;
    $param->{page_title} = MT->translate( q{[_1]'s Associations},
        MT::Util::encode_html($author_name) );
}

sub can_view {
    my ( $eh, $app, $id ) = @_;

    my $author = $app->user;
    return 1 if $author->can_manage_users_groups;
    return $id && ( $app->user->id == $id );
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    my $author = $app->user;
    return 1 if $author->can_manage_users_groups;
    if ($id) {
        return $author->id == $id;
    }
}

sub can_delete_this {
    my ( $eh, $app, $obj, $return_args ) = @_;
    my $user = $app->user;

    return 0 if $user->id == $obj->id;
    return 1 if $user->is_superuser;
    return 1 if $user->can_manage_users_groups && !$obj->is_superuser;

    return 0;
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->can_manage_users_groups;
    if ( !( $obj->created_by && $obj->created_by == $author->id ) ) {
        return $eh->error(
            MT->translate(
                "You have no permission to delete the user [_1].",
                $obj->name
            )
        );
    }
    return 1;
}

sub save_filter {
    my ( $eh, $app, $obj, $original, $opts ) = @_;
    $opts ||= {};
    my $encode_html = sub {
        $opts->{skip_encode_html} ? $_[0] : encode_html( $_[0] );
    };

    my $name = $obj ? $obj->name : $app->param('name');
    my $id   = $obj ? $obj->id   : $app->param('id');
    if ( $name && !$opts->{skip_validate_unique_name} ) {
        require MT::Author;
        my $existing = MT::Author->load(
            {   name => $name,
                type => MT::Author::AUTHOR()
            }
        );
        if ( $existing
            && ( ( $id && $existing->id ne $id ) || !$id ) )
        {
            return $eh->error(
                $app->translate("A user with the same name already exists.")
            );
        }
    }

    my $status = $obj ? $obj->status : $app->param('status');
    return 1 if $status and $status == MT::Author::INACTIVE();

    require MT::Auth;
    my $auth_mode = $app->config('AuthenticationModule');
    my ($pref) = split /\s+/, $auth_mode;

    my $nickname = $obj ? $obj->nickname : $app->param('nickname');

    if ( $pref eq 'MT' ) {
        if ( defined $name ) {
            $name =~ s/(^\s+|\s+$)//g;
            $obj ? $obj->name($name) : $app->param( 'name', $name );
        }
        return $eh->error( $app->translate("User requires username") )
            if ( !length($name) );

        if ( $name =~ m/([<>])/ ) {
            return $eh->error(
                $app->translate(
                    "[_1] contains an invalid character: [_2]",
                    $app->translate("Username"),
                    $encode_html->($1)
                )
            );
        }
    }

    # Display name is required for all auth types; for new users
    # under external auth, the field is not shown, so the value is
    # undefined. Only check requirement if the value is defined.
    if ( defined $nickname ) {
        $nickname =~ s/(^\s+|\s+$)//g;
        $obj
            ? $obj->nickname($nickname)
            : $app->param( 'nickname', $nickname );
        return $eh->error( $app->translate("User requires display name") )
            if ( !length($nickname) );

        if ( $nickname =~ m/([<>])/ ) {
            return $eh->error(
                $app->translate(
                    "[_1] contains an invalid character: [_2]",
                    $app->translate("Display Name"),
                    $encode_html->($1)
                )
            );
        }
    }

    # MT::Auth::MT uses id, pass, pass_verify, old_pass
    my $ori_name = $app->param('name');
    $app->param( 'name', $name );
    require MT::Auth;
    my $error = MT::Auth->sanity_check($app);
    $app->param( 'name', $ori_name );
    if ($error) {
        require MT::Log;
        $app->log(
            {   message  => $error,
                level    => MT::Log::ERROR(),
                class    => 'author',
                category => 'save_author_profile'
            }
        );
        return $eh->error($error);
    }

    return 1 if ( $pref ne 'MT' );

    my $pass     = $app->param('pass');
    my $password = $app->param('password');
    if ( !$id ) {    # it's a new object
        return $eh->error( $app->translate("User requires password") )
            if ( !length( $obj ? $obj->password : $pass ) );
    }

    # Password strength check
    # Why the name of password field is different in each forms...
    if ( $pass || $password ) {
        my $msg = $app->verify_password_strength( $name, $pass );
        return $eh->error($msg) if $msg;
    }

    my $email = $obj ? $obj->email : $app->param('email');
    if ($email) {
        return $eh->error( $app->translate("Email Address is invalid.") )
            unless is_valid_email($email);

        if ( $email =~ m/([<>])/ ) {
            return $eh->error(
                $app->translate(
                    "[_1] contains an invalid character: [_2]",
                    $app->translate("Email Address"),
                    $encode_html->($1)
                )
            );
        }
    }
    elsif ( $app->config('RequiredUserEmail') ) {
        return $eh->error(
            MT->translate("Email Address is required for password reset.") )
            unless is_valid_email($email);
    }

    if ( my $url = $obj ? $obj->url : $app->param('url') ) {
        return $eh->error( MT->translate("URL is invalid.") )
            if !is_url($url) || ( $url =~ m/[<>]/ );
    }

    1;
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    # Authors should only be of type AUTHOR when created from
    # the CMS app; COMMENTERs are created from the Comments app.
    $obj->type( MT::Author::AUTHOR() );

    my $pass = $app->param('pass');
    if ( length($pass) ) {
        $obj->set_password($pass);
    }
    elsif ( !$obj->id ) {
        $obj->password('(none)');
    }

    my ( $delim, $delim2 ) = $app->multi_param('tag_delim');
    $delim ||= $delim2 || '';
    if ( $delim =~ m/comma/i ) {
        $delim = ord(',');
    }
    elsif ( $delim =~ m/space/i ) {
        $delim = ord(' ');
    }
    else {
        $delim = ord(',');
    }
    $obj->entry_prefs("tag_delim=$delim");
    unless ( $obj->id ) {
        $obj->created_by( $app->user->id );
    }
    1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    if ( !$original->id ) {
        $app->log(
            {   message => $app->translate(
                    "User '[_1]' (ID:[_2]) created by '[_3]'",
                    $obj->name, $obj->id, $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'author',
                category => 'new',
            }
        );
        $obj->add_default_roles;

        my $author_id = $obj->id;

        # provision new user with a personal blog
        $app->run_callbacks( 'new_user_provisioning', $obj );
    }
    else {
        if ( $app->user->id == $obj->id ) {
            ## If this is a user editing his/her profile, $id will be
            ## some defined value; if so we should update the user's
            ## cookie to reflect any changes made to username and password.
            ## Otherwise, this is a new user, and we shouldn't update the
            ## cookie.
            $app->user($obj);
            if (   ( $obj->name ne $original->name )
                || ( $app->param('pass') ) )
            {
                $app->start_session();
            }
        }
    }

    if (    $app->user->id eq $obj->id
        and $obj->password ne $original->password )
    {
        my $current_session = $app->session;

        MT::Auth->invalidate_credentials( { app => $app } );
        $app->user($obj);
        $app->start_session( $obj, $current_session->get('remember') || 0 );
    }

    1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {   message => $app->translate(
                "User '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->name, $obj->id, $app->user->name
            ),
            level    => MT::Log::NOTICE(),
            class    => 'author',
            category => 'delete'
        }
    );
}

sub _merge_default_assignments {
    my $app = shift;
    my ( $data, $hasher, $offset, $limit, $type, $id ) = @_;

    my $count      = 0;
    my $role_class = $app->model('role');
    if ( my $def = MT->config->DefaultAssignments ) {
        my @def = split ',', $def;
        while ( my $role_id = shift @def ) {
            my $blog_id = shift @def;
            next unless $role_id && $blog_id;
            next if ( $type eq 'role' ) && ( $id != $role_id );
            next if ( $type eq 'blog' ) && ( $id != $blog_id );
            my $obj = MT::Association->new;
            $obj->role_id($role_id);
            $obj->blog_id($blog_id);
            $obj->id( 'PSEUDO-' . $role_id . '-' . $blog_id );
            my $row = $obj->get_values();
            $hasher->( $obj, $row ) if $hasher;
            $row->{user_id}   = 'PSEUDO';
            $row->{user_name} = MT->translate('(newly created user)');
            $row->{user_nickname}
                = $app->translate(
                'represents a user who will be created afterwards'),
                my $role = $role_class->load($role_id);
            next if !$role;
            $count++;
            my @role_loop = (
                {   role_name    => $role->name,
                    role_id      => $role->id,
                    is_removable => 0,
                }
            );
            $row->{role_loop} = \@role_loop if @role_loop;
            unshift @$data, $row if $count > $offset;
        }
        splice( @$data, $limit );
    }
    return $count;
}

sub build_author_table {
    my $app = shift;
    my (%args) = @_;

    my $i = 1;
    my @author;
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('author');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
    }
    return [] unless $iter;
    my $blog_id = $app->param('blog_id');
    my $param   = $args{param};
    $param->{has_edit_access}  = $app->user->can_manage_users_groups();
    $param->{is_administrator} = $app->user->is_superuser();
    my %entry_count_refs;
    while ( my $author = $iter->() ) {
        my $row = {
            name           => $author->name,
            nickname       => $author->nickname,
            email          => $author->email,
            url            => $author->url,
            status_enabled => $author->is_active,
            status_pending => ( $author->status == MT::Author::PENDING() )
            ? 1
            : 0,
            id          => $author->id,
            entry_count => 0,
            is_me       => ( $app->user->id == $author->id ? 1 : 0 )
        };
        $entry_count_refs{ $author->id } = \$row->{entry_count};
        if ( $author->created_by ) {
            if ( my $parent_author
                = $app->model('author')->load( $author->created_by ) )
            {
                $row->{created_by} = $parent_author->name;
            }
            else {
                $row->{created_by} = $app->translate('(user deleted)');
            }
        }
        $row->{object}          = $author;
        $row->{usertype_author} = 1
            if $author->type == MT::Author::AUTHOR();
        if ( $author->type == MT::Author::COMMENTER() ) {
            $row->{usertype_commenter} = 1;
            $row->{status_trusted}     = 1
                if $blog_id && $author->is_trusted($blog_id);
            if ( $row->{name} =~ m/^[a-f0-9]{32}$/ ) {
                $row->{name} = $row->{nickname} || $row->{url};
            }
        }
        $row->{auth_icon_url} = $author->auth_icon_url;
        push @author, $row;
    }
    return [] unless @author;
    my $type = $app->param('entry_type') || 'entry';
    my $entry_class = $app->model($type);
    my $author_entry_count_iter
        = $entry_class->count_group_by(
        { author_id => [ keys %entry_count_refs ] },
        { group     => ['author_id'] } );
    while ( my ( $count, $author_id ) = $author_entry_count_iter->() ) {
        ${ $entry_count_refs{$author_id} } = $count;
    }
    $param->{author_table}[0]{object_loop} = \@author;

    $app->load_list_actions( 'author', $param->{author_table}[0] );
    $param->{page_actions} = $param->{author_table}[0]{page_actions}
        = $app->page_actions('list_author');
    $param->{object_loop} = $param->{author_table}[0]{object_loop};

    \@author;
}

sub _delete_pseudo_association {
    my $app = shift;
    my ( $pid, $bid ) = @_;
    my $rid;
    if ($pid) {
        ( undef, $rid, $bid ) = split '-', $pid;
    }
    my @newdef;
    if ( my $def = $app->config->DefaultAssignments ) {
        my @def = split ',', $def;
        while ( my $role_id = shift @def ) {
            my $blog_id = shift @def;
            next unless $role_id && $blog_id;
            next
                if ( $rid
                && ( $role_id == $rid )
                && ( $blog_id == $bid ) )
                || ( !defined($rid) && ( $blog_id == $bid ) );
            push @newdef, "$role_id,$blog_id";
        }
    }
    if (@newdef) {
        $app->config( 'DefaultAssignments', join( ',', @newdef ), 1 );
    }
    else {
        $app->config( 'DefaultAssignments', undef, 1 );
    }
    $app->config->save_config;
}

1;
