package MT::Auth::GoogleOpenId;

use strict;
use base qw( MT::Auth::OpenID );

sub check_url_params {
    my $class = shift;
    my ( $app, $blog ) = @_;
    my %params = $class->SUPER::check_url_params(@_);
    $params{delayed_return} = 1;
    return %params;
}

sub set_extension_args {
    my $class = shift;
    my ( $claimed_identity ) = @_;

    $claimed_identity->set_extension_args(MT::Auth::OpenID::NS_OPENID_AX(), {
        'mode' => 'fetch_request',
        'required' => 'email',
        'type.email' => 'http://schema.openid.net/contact/email',
    });
}

sub get_csr {
    my $class = shift;
    my ($params, $blog) = @_;
    my $ua = MT->new_ua( { paranoid => 1 } );
    delete $ua->{max_size};
    return $class->SUPER::get_csr( $params, $blog, $ua );
}

sub set_commenter_properties {
    my $class = shift;
    my ( $commenter, $vident ) = @_;
    my $fields = $vident->extension_fields(MT::Auth::OpenID::NS_OPENID_AX());
    my $email = $fields->{'value.email'} if exists $fields->{'value.email'};
    my $nick;
    if ( $email =~ /^(.+)\@gmail\.com$/ ) {
        $nick = $1;
    }
    if ( $commenter->url eq $vident->url ) {
        # Google OpenID URL does not represent a web-browseable resource
        $commenter->url(q());
    }
    $commenter->nickname($nick || $vident->url);
    $commenter->email($email || '');
}

1;
__END__
