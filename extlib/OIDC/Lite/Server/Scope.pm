package OIDC::Lite::Server::Scope;
use strict;
use warnings;

sub optional_scopes{ return qw{profile email address phone offline_access}; }

sub validate_scopes{
    my ($self, $scopes) = @_;

    # if scope includes 'openid' , return true
    return 1 if ($self->is_openid_request($scopes));

    # if scope doesn't include 'openid', other OIDC scope must not be included.
    my %optional_scope_hash;
    $optional_scope_hash{$_}++ foreach $self->optional_scopes;
    foreach my $scope (@$scopes){
	return 0 if exists $optional_scope_hash{$scope};
    }
    return 1;
}

sub is_openid_request{
    my ($self, $scopes) = @_;

    # scopes is array ref
    return 0 unless (ref($scopes) eq 'ARRAY');

    # if it has 'openid', return true.
    my %scope_hash;
    $scope_hash{$_}++ foreach @$scopes;
    return (exists $scope_hash{q{openid}});
}

sub is_required_offline_access{
    my ($self, $scopes) = @_;

    # scopes is array ref
    return 0 unless (ref($scopes) eq 'ARRAY');

    # if it has 'offline_access', return true.
    my %scope_hash;
    $scope_hash{$_}++ foreach @$scopes;
    return (exists $scope_hash{q{offline_access}});
}

sub to_normal_claims{
    my ($self, $scopes) = @_;

    my @claims;
    foreach my $scope (@$scopes){
        push(@claims, qw{sub})
            if($scope eq q{openid});

        push(@claims, qw{name family_name given_name middle_name 
                         nickname preferred_username profile 
                         picture website gender birthdate 
                         zoneinfo locale updated_at})
            if($scope eq q{profile});

        push(@claims, qw(email email_verified))
            if($scope eq q{email});

        push(@claims, qw{address})
            if($scope eq q{address});

        push(@claims, qw{phone_number phone_number_verified})
            if($scope eq q{phone});
    }

    return \@claims;
}

=head1 NAME

OIDC::Lite::Server::Scope - utility class for OpenID Connect Scope

=head1 SYNOPSIS

    use OIDC::Lite::Server::Scope;

    my @scopes = ...

    # if request doesn't inclue 'openid' and include other OIDC scope, return false
    if(OIDC::Lite::Server::Scope->validate_scopes(\@scopes)){
        # valid scopes
    }else{
        # invalid scopes
    }    

    # return OpenID Connect request or not
    if(OIDC::Lite::Server::Scope->is_openid_request(\@scopes)){
        # OpenID Connect Request
        # issue ID Token
    }else{
        # OAuth 2.0 Request
        # don't issue ID Token
    }
    
    # returned normal claims for scopes
    my $claims = OIDC::Lite::Server::Scope->to_normal_claims(\@scopes);

=head1 DESCRIPTION

This is utility class for OpenID Connect scope.

=head1 METHODS

=head2 validate_scopes( $scopes )

If request doesn't inclue 'openid' and include other OIDC scope, return false.
'openid' : true
'not_openid' : true
'openid profile' : true
'profile' : false
'not_openid profile' : false

=head2 is_openid_request( $scopes )

Returns the requested scope is for OpenID Connect or not.

=head2 is_required_offline_access( $scopes )

Returns the requested scope includes 'offline_access' or not.

=head2 to_normal_claims( $req )

Returns normal claims for requested scopes.

=head1 AUTHOR

Ryo Ito, E<lt>ritou.06@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Ryo Ito

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
