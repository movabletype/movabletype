# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Auth::OpenID;
use strict;

use MT::Util qw( decode_url is_valid_email escape_unicode ts2epoch );
use MT::I18N qw( encode_text );

sub NS_OPENID_AX   { "http://openid.net/srv/ax/1.0" }
sub NS_OPENID_SREG { "http://openid.net/extensions/sreg/1.1" }

sub login {
    my $class = shift;
    my ($app) = @_;
    my $q = $app->param;
    return $app->errtrans("Invalid request.")
        unless $q->param('blog_id');
    my $blog = $app->model('blog')->load(scalar $q->param('blog_id'));
    my $identity = $q->param('openid_url');
    if (!$identity &&
        (my $u = $q->param('openid_userid')) && $class->can('url_for_userid')) {
        $identity = $class->url_for_userid($u);
    }
    my $claimed_identity = $class->check_openid($app, $blog, $identity)
        or return $app->error($app->errstr);

    my %params = $class->check_url_params( $app, $blog );

    $class->set_extension_args( $claimed_identity );

    my $check_url = $claimed_identity->check_url(
        %params
    );

    return $app->redirect($check_url);
}

sub handle_sign_in {
    my $class = shift;
    my ($app, $auth_type) = @_;
    my $q = $app->{query};
    my $INTERVAL = 60 * 60 * 24 * 7;

    $auth_type ||= 'OpenID';

    my $blog = $app->model('blog')->load($q->param('blog_id'));
    my $author_class = $app->model('author');

    my $cmntr;
    my $session;

    my %param = $app->param_hash;
    my $csr = $class->get_csr(\%param, $blog) or return 0;

    if(my $setup_url = $csr->user_setup_url( post_grant => 'return' )) {
        return $app->redirect($setup_url);
    } elsif(my $vident = $csr->verified_identity) {
        my $name = $vident->url;
        $cmntr = $author_class->load(
            {
                name => $name,
                type => $author_class->COMMENTER(),
                auth_type => $auth_type,
            }
        );
        if ( $cmntr ) {
            unless ( ( $cmntr->modified_on
                && ( ts2epoch($blog, $cmntr->modified_on) > time - $INTERVAL ) )
              || ( $cmntr->created_on
                && ( ts2epoch($blog, $cmntr->created_on) > time - $INTERVAL ) ) )
            {
                $class->set_commenter_properties($cmntr, $vident);
                $cmntr->save or return 0;
            }
        }
        else {
            $cmntr = $app->make_commenter(
                name        => $name,
                url         => $vident->url,
                auth_type   => $auth_type,
                external_id => _url_hash($vident->url),
            );
            if ($cmntr) {
                $class->set_commenter_properties($cmntr, $vident);
                $cmntr->save or return 0;
            }
        }
        return 0 unless $cmntr;

        # Signature was valid, so create a session, etc.
        $session = $app->make_commenter_session($cmntr);
        unless ($session) {
            $app->error($app->errstr() || $app->translate("Couldn't save the session"));
            return 0;
        }

        if (my $userpic = $cmntr->userpic) {
            my @stat = stat($userpic->file_path());
            my $mtime = $stat[9];
            if ( $mtime > time - $INTERVAL ) {
                # newer than 7 days ago, don't download the userpic
                return $cmntr;
            }
        }

        if ( my $userpic = $class->get_userpicasset($vident) ) {
            $userpic->tags('@userpic');
            $userpic->created_by($cmntr->id);
            $userpic->save;
            if (my $userpic = $cmntr->userpic) {
                # Remove the old userpic thumb so the new userpic's will be generated
                # in its place.
                my $thumb_file = $cmntr->userpic_file();
                my $fmgr = MT::FileMgr->new('Local');
                if ($fmgr->exists($thumb_file)) {
                    $fmgr->delete($thumb_file);
                }

                $userpic->remove;
            }
            $cmntr->userpic_asset_id($userpic->id);
            $cmntr->save;
        }
    } else {
        # If there's no signature, then we trust the cookie.
        my %cookies = $app->cookies();
        my $cookie_name = MT::App::COMMENTER_COOKIE_NAME();
        if ($cookies{$cookie_name}
            && ($session = $cookies{$cookie_name}->value())) 
        {
            require MT::Session;
            my $sess = MT::Session->load({id => $session});
            if ($sess) {
                $cmntr = $author_class->load({name => $sess->name,
                                           type => $author_class->COMMENTER(),
                                           auth_type => $auth_type});
            }
        }
    }
    unless ($cmntr) {
        return 0;
    }
    return $cmntr;
}

sub set_extension_args {
    my $class = shift;
    my ( $claimed_identity ) = @_;
}

sub check_openid {
    my $class = shift;
    my ( $app, $blog, $identity ) = @_;
    my $q = $app->param;

    my %param = $app->param_hash;
    my $csr = $class->get_csr(\%param, $blog);
    unless ( $csr ) {
        $app->errtrans('Could not load Net::OpenID::Consumer.');
        return;
    }

    my $claimed_identity = $csr->claimed_identity($identity);
    unless ( $claimed_identity ) {
        my ($err_code, $err_msg) = ($csr->errcode, $csr->errtext);
        if ($err_code eq 'no_head_tag' || $err_code eq 'no_identity_server' || $err_code eq 'url_gone') {
            $err_msg = $app->translate('The address entered does not appear to be an OpenID');
        }
        elsif ($err_code eq 'empty_url' || $err_code eq 'bogus_url') {
            $err_msg = $app->translate('The text entered does not appear to be a web address');
        }
        elsif ($err_code eq 'url_fetch_error') {
            $err_msg =~ s{ \A Error \s fetching \s URL: \s }{}xms;
            $err_msg = $app->translate('Unable to connect to [_1]: [_2]', $identity, $err_msg);
        }
        return $app->errtrans("Could not verify the OpenID provided: [_1]", $err_msg);
    }
    return $claimed_identity;
}

sub _get_ua {
    return MT->new_ua( { paranoid => 1 } );
}

sub _get_csr {
    my ($params, $blog, $ua) = @_;
    my $secret = MT->config->SecretToken;
    $ua ||= _get_ua();
    return unless $ua;
    require Net::OpenID::Consumer;
    Net::OpenID::Consumer->new(
        ua => $ua,
        args => $params,
        consumer_secret => $secret,
        # debug => sub {
        # }
    );
}

sub get_csr {
    my $class = shift;
    return _get_csr(@_);
}

sub _get_declared_foaf {
    my ($vident) = @_;
    my $req      = MT::Request->instance();
    my $foaf     = $req->stash( 'foaf:' . _url_hash($vident->url) );
    return $foaf if $foaf;

    my $ua = _get_ua() or return '';

    if ( my $foaf_url = $vident->declared_foaf ) {
        my $resp = $ua->get($foaf_url);
        if ( $resp->is_success ) {
            $foaf = $resp->content;
            $req->stash( 'foaf:' . _url_hash($vident->url), $foaf );
            return $foaf;
        }
    }

    q();
}

sub get_nickname {
    my $class = shift;
    my ($vident) = @_;
    _get_nickname(@_);
}

sub _get_nickname {
    my ($vident) = @_;

    ## FOAF
    if ( my $foaf = _get_declared_foaf($vident) ) {
        my $name;

        require XML::XPath;
        my $xml = XML::XPath->new( xml => $foaf );
        $xml->set_namespace('RDF', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#');
        $xml->set_namespace('FOAF', 'http://xmlns.com/foaf/0.1/');
        my ($name_el) = $xml->findnodes('/RDF:RDF/FOAF:Person/FOAF:name');
        ($name_el) = $xml->findnodes('/RDF:RDF/FOAF:Person/FOAF:nick')
            unless $name_el;
        if ($name_el)
        {
            $name = $name_el->string_value;
        }
        $xml->cleanup;

        return MT::I18N::utf8_off($name) if $name;
    }

    ## Atom
    if(my $atom_url = $vident->declared_atom) {
        if (my $ua = _get_ua()) {
            my $resp = $ua->get($atom_url);
            if($resp->is_success) {
                my $name;

                require XML::XPath;
                my $xml = XML::XPath->new( xml => $resp->content );
                if(my ($name_el) = $xml->findnodes('/feed/author/name')) {
                    $name = $name_el->string_value;
                }
                $xml->cleanup;
            
                return MT::I18N::utf8_off($name) if $name;
            }
        }
    }

    return $vident->display ? $vident->display : $vident->url;
}

sub get_email {
    my $class = shift;
    my ( $vident ) = @_;
    return q();
}

sub get_userpicasset {
    my $class = shift;
    my ($vident) = @_;
    my $foaf = _get_declared_foaf($vident);
    return undef unless $foaf;

    require XML::XPath;
    my $xml = XML::XPath->new( xml => $foaf );
    $xml->set_namespace('RDF', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#');
    $xml->set_namespace('FOAF', 'http://xmlns.com/foaf/0.1/');
    my $resource = $xml->getNodeText('/RDF:RDF/FOAF:Person/FOAF:img/@RDF:resource');
    my $url;
    if ($resource) {
        $url = $resource->value();
    }
    $xml->cleanup;
    return undef unless $url;

    return _asset_from_url($url);
}

sub _asset_from_url {
    my ($image_url) = @_;
    my $ua   = _get_ua() or return;
    my $resp = $ua->get($image_url);
    return undef unless $resp->is_success;
    my $image = $resp->content;
    return undef unless $image;
    my $mimetype = $resp->header('Content-Type');
    my $def_ext = {
        'image/jpeg' => '.jpg',
        'image/png'  => '.png',
        'image/gif'  => '.gif'}->{$mimetype};

    require Image::Size;
    my ( $w, $h, $id ) = Image::Size::imgsize(\$image);

    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');

    my $save_path  = '%s/support/uploads/';
    my $local_path =
      File::Spec->catdir( MT->instance->static_file_path, 'support', 'uploads' );
    $local_path =~ s|/$||
      unless $local_path eq '/';    ## OS X doesn't like / at the end in mkdir().
    unless ( $fmgr->exists($local_path) ) {
        $fmgr->mkpath($local_path);
    }
    my $filename = substr($image_url, rindex($image_url, '/'));
    if ( $filename =~ m!\.\.|\0|\|! ) {
        return undef;
    }
    my ($base, $uploaded_path, $ext) = File::Basename::fileparse($filename, '\.[^\.]*');
    $ext = $def_ext if $def_ext;  # trust content type higher than extension

    # Find unique name for the file.
    my $i = 1;
    my $base_copy = $base;
    while ($fmgr->exists(File::Spec->catfile($local_path, $base . $ext))) {
        $base = $base_copy . '_' . $i++;
    }

    my $local_relative = File::Spec->catfile($save_path, $base . $ext);
    my $local = File::Spec->catfile($local_path, $base . $ext);
    $fmgr->put_data( $image, $local, 'upload' );

    require MT::Asset;
    my $asset_pkg = MT::Asset->handler_for_file($local);
    return undef if $asset_pkg ne 'MT::Asset::Image';

    my $asset;
    $asset = $asset_pkg->new();
    $asset->file_path($local_relative);
    $asset->file_name($base.$ext);
    my $ext_copy = $ext;
    $ext_copy =~ s/\.//;
    $asset->file_ext($ext_copy);
    $asset->blog_id(0);

    my $original = $asset->clone;
    my $url = $local_relative;
    $url  =~ s!\\!/!g;
    $asset->url($url);
    $asset->image_width($w);
    $asset->image_height($h);
    $asset->mime_type($mimetype);

    $asset->save
        or return undef;

    MT->run_callbacks(
        'api_upload_file.' . $asset->class,
        File => $local, file => $local,
        Url => $url, url => $url,
        Size => length($image), size => length($image),
        Asset => $asset, asset => $asset,
        Type => $asset->class, type => $asset->class,
    );
    MT->run_callbacks(
        'api_upload_image',
        File => $local, file => $local,
        Url => $url, url => $url,
        Size => length($image), size => length($image),
        Asset => $asset, asset => $asset,
        Height => $h, height => $h,
        Width => $w, width => $w,
        Type => 'image', type => 'image',
        ImageType => $id, image_type => $id,
    );

    $asset;
}

sub _url_hash {
    my ($url) = @_;

    if (eval { require Digest::MD5; 1; }) {
        return Digest::MD5::md5_hex($url);
    }
    return substr $url, 0, 255;
}

sub check_url_params {
    my $class = shift;
    my ( $app, $blog ) = @_;
    my $q = $app->{query};

    my $path = MT->config->CGIPath;
    if ($path =~ m!^/!) {
        # relative path, prepend blog domain
        my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
        $path = $blog_domain . $path;
    }
    $path .= '/' unless $path =~ m!/$!;
    $path .= MT->config->CommentScript;

    my $return_to = $path . '?__mode=handle_sign_in'
        . '&blog_id=' . MT::Util::encode_url($q->param('blog_id'))
        . '&static=' . MT::Util::encode_url($q->param('static'))
        . '&key=' . MT::Util::encode_url($q->param('key'));
    $return_to .= '&entry_id=' . MT::Util::encode_url($q->param('entry_id'))
        if $q->param('entry_id');
    ( trust_root => $path, return_to => $return_to );
}

sub set_commenter_properties {
    my $class = shift;
    my ( $commenter, $vident ) = @_;
    my $nick = $class->get_nickname($vident);
    my $email = $class->get_email($vident);
    $commenter->nickname($nick) if $nick;
    $commenter->email($email) if $email;
}

1;

__END__

=head1 NAME

MT::Auth::OpenID

Movable Type commenter authentication module via OpenID

=head1 METHODS

=head2 login

This method is called from MT::App::Comments::login_external,
to initiate process of logging in to a website other than 
Movable Type itself.  You should not have to modify the
behavior of this method.

=head2 handle_sign_in

This method is called from MT::App::Comments::handle_sign_in
to accept the result of logging in to an external website.
You should not have to modify the behavior of this method.

=head2 url_for_userid

This method is called in login method when it needs to construct
OpenID for the login request.  By default the module accepts
the identifier entered by the user as OpenID, thus does nothing
in this method.

You can inherit this class, create your own authentication
module and override this method to generate OpenID out of
what user entered in the login form, so it can provide more
user friendly way of specifying their OpenID.  See MT::Auth::Vox
and MT::Auth::LiveJournal for examples.

=head2 get_nickname

This method is called in set_commenter_properties method,
in which it tries to grab the user's nickname.  By default,
a user who is authenticated via OpenID has his/her nickname
as the OpenID (thus, URL).  It tends to get ugly when it is
displayed.

By default, this class tries to load FOAF or Atom from
the verified OpenID to see if it is able to get more semantic
information.  If it was able to load the semantic info from
one of them, it uses the information as the user's nickname.

You can inherit this class, create your own authentication
module and override this method to generate more user friendly
nickname for a user from the OpenID that does not support
FOAF or Atom retrieval from the URL.

=head2 get_email

This method is called in set_commenter_properties method.
By default the class returns empty string, but you can inherit
from this class to create your own authentication module,
and overwride this method that grabs user's email address
in a certain way such as SREG or AX.

=head2 set_commenter_properties

This method is called in handle_sign_in method. The method
accepts two arguments; I<$commenter> which is an MT::Author
object that represents the commenter who just logged in,
and I<$vident> which is an Net::OpenID::VerifiedIdentity.

By default the method calls get_username and get_email to
grab user's nickname and email address, and stores those values
to the equivalent property of I<$commenter>.
 
You can inherit this class, create your own authentication
module and inherit this method so your module can grab
more information from the OpenID provider and store them to
I<$commenter>.  Or you can inherit get_nickname and/or
get_email if that is all that your OpenID provider
would return.

=head2 get_userpic_asset

This method is called in handle_sign_in method, in which it
tries to retrieve the user's userpic or avatar.  By default,
the method sees if the FOAF retrieved from OpenID has the URL
for userpic.  If it does, the method downloads the userpic and
saves it as an userpic asset for the user.

You can inherit this class, create your own authentication
module and override this method to associate a userpic to the user.

=head2 check_url_params

This method is called in login method.  This method must return
a hash which is passed to I<Net::OpenID::ClaimedIdentity>::check_url.
Consult I<Net::OpenID::ClaimedIdentity> about what can be specified.
By default, the class specifies trust_root and return_to parameters.

You can inherit this class, create your own authentication
module and override this method to specify more parameters, or
change how to construct trust_root and return_to arguments.

=head2 set_extension_args

You can inherit this method in your own authentication module
and set up any extension properties necessary to I<$claimed_identity>
that is passed to the method, such as AX and/or SREG property
requirements.

By default this method does nothing.

=head2 check_openid

This method calls Net::OpenID::Consumer::claimed_identity and returns
Net::OpenID::ClaimedIdentity object if it is a success, effectively
meaning the URL provided is resolved to be an OpenID.

In other words, you can call this method instead of login method to see
if the given URL can be used as an OpenID.

=head2 get_csr

This method returns Net::OpenID::Consumer object.  By default this class
creates the object and returns, but sometimes the default object
is not enough for some authentication provider.  For example you
may want to remove max_size parameter from the user agent object
it uses, to avoid "range" request.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
