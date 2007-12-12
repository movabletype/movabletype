# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Auth::OpenID;
use strict;

use MT::Util qw( decode_url is_valid_email escape_unicode );
use MT::I18N qw( encode_text );

sub login {
    my $class = shift;
    my ($app) = @_;
    my $q = $app->{query};
    return $app->errtrans("Invalid request.")
        unless $q->param('blog_id');
    my $blog = MT::Blog->load(scalar $q->param('blog_id'));
    my %param = $app->param_hash;
    my $csr = _get_csr(\%param, $blog) or return;
    my $identity = $q->param('openid_url');
    if (!$identity &&
        (my $u = $q->param('openid_userid')) && $class->can('url_for_userid')) {
        $identity = $class->url_for_userid($u);
    }
    my $claimed_identity = $csr->claimed_identity($identity)
        or return $app->error($app->translate("Could not discover claimed identity: [_1]", $csr->err));

    my $root = $class->_get_root($blog);
    my $return_to = $app->base . $app->uri . '?__mode=handle_sign_in'
        . '&blog_id=' . $q->param('blog_id')
        . '&static=' . $q->param('static')
        . '&key=' . $q->param('key');
    $return_to .= '&entry_id=' . $q->param('entry_id') if $q->param('entry_id');

    my $check_url = $claimed_identity->check_url(
        return_to => $return_to,
        trust_root => $root,
    );

    return $app->redirect($check_url);
}

sub handle_sign_in {
    my $class = shift;
    my ($app, $auth_type) = @_;
    my $q = $app->{query};

    $auth_type ||= 'OpenID';

    my $blog = MT::Blog->load($q->param('blog_id'));

    my $cmntr;
    my $session;

    my %param = $app->param_hash;
    my $csr = _get_csr(\%param, $blog) or return 0;

    if(my $setup_url = $csr->user_setup_url( post_grant => 'return' )) {
        return $app->redirect($setup_url);
    } elsif(my $vident = $csr->verified_identity) {
        my $name = $vident->url;
        my $nick = $class->get_nickname($vident);

        # Signature was valid, so create a session, etc.
        my $enc = $app->{cfg}->PublishCharset || '';
        my $nick_escaped = escape_unicode($nick);
        $nick = encode_text($nick, 'utf-8', undef);
        $session = $app->_make_commenter_session($app->make_magic_token, q(),
                                                 $name, $nick_escaped, undef, $name);
        unless ($session) {
            $app->error($app->errstr() || $app->translate("Couldn't save the session"));
            return 0;
        }
        $cmntr = $app->_make_commenter(
            email       => q(),
            nickname    => $nick,
            name        => $name,
            url         => $vident->url,
            auth_type   => $auth_type,
            external_id => _url_hash($vident->url),
        );

        if ( my $userpic = $class->get_userpicasset($vident) ) {
            $userpic->tags('@userpic');
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
        if ($cookies{$app->COMMENTER_COOKIE_NAME()}
            && ($session = $cookies{$app->COMMENTER_COOKIE_NAME()}->value())) 
        {
            require MT::Session;
            require MT::Author;
            my $sess = MT::Session->load({id => $session});
            $cmntr = MT::Author->load({name => $sess->name,
                                       type => MT::Author::COMMENTER(),
                                       auth_type => $auth_type});
        }
    }
    unless ($cmntr) {
        return 0;
    }
    return $cmntr;
}

sub _get_ua {
    return MT->new_ua( { paranoid => 1 } );
}

sub _get_csr {
    my ($params, $blog) = @_;
    my $secret = MT->config->SecretToken;
    my $ua = _get_ua() or return;
    require Net::OpenID::Consumer;
    Net::OpenID::Consumer->new(
        ua => $ua,
        args => $params,
        consumer_secret => $secret,
    );
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

sub _get_root {
    my $class = shift;
    my ($blog) = @_;
    my $path = MT->config->CGIPath;
    if ($path =~ m!^/!) {
        # relative path, prepend blog domain
        my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
        $path = $blog_domain . $path;
    }
    $path .= '/' unless $path =~ m!/$!;
    $path;
}

1;
