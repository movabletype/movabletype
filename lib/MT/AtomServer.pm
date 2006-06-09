# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::AtomServer;
use strict;

use XML::Atom;
use XML::Atom::Util qw( first textValue );
use base qw( MT::App );
use MIME::Base64 ();
use Digest::SHA1 ();
use MT::Atom;
use MT::Util qw( encode_xml );
use MT::Author;
use MT::I18N qw( encode_text );

use constant NS_SOAP => 'http://schemas.xmlsoap.org/soap/envelope/';
use constant NS_WSSE => 'http://schemas.xmlsoap.org/ws/2002/07/secext';
use constant NS_WSU => 'http://schemas.xmlsoap.org/ws/2002/07/utility';

sub init {
    my $app = shift;
    $app->{no_read_body} = 1
        if $app->request_method eq 'POST' || $app->request_method eq 'PUT';
    $app->SUPER::init(@_) or return $app->error("Initialization failed");
    $app->request_content
        if $app->request_method eq 'POST' || $app->request_method eq 'PUT';
    $app->add_methods(
        handle => \&handle,
    );
    $app->{default_mode} = 'handle';
    $app->{is_admin} = 0;
    $app->{warning_trace} = 0;
    $app;
}

sub handle {
    my $app = shift;
    
    my $out = eval {
        (my $pi = $app->path_info) =~ s!^/!!;
        my($subapp, @args) = split /\//, $pi;
        $app->{param} = {};
        for my $arg (@args) {
            my($k, $v) = split /=/, $arg, 2;
            $app->{param}{$k} = $v;
        }
        if (my $action = $app->get_header('SOAPAction')) {
            $app->{is_soap} = 1;
            $action =~ s/"//g; # "
            my($method) = $action =~ m!/([^/]+)$!;
            $app->request_method($method);
        }
        my $apps = $app->{cfg}->AtomApp;
        if (my $class = $apps->{$subapp}) {
            bless $app, $class;
        }
        my $out = $app->handle_request;
        return unless defined $out;
        if ($app->{is_soap}) {
            $out =~ s!^(<\?xml.*?\?>)!!;
            $out = <<SOAP;
$1
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>$out</soap:Body>
</soap:Envelope>
SOAP
        }
        return $out;
    };
    if ($@) {
        $app->error(500, $@);
        $app->show_error("Internal Error");
    }
    return $out;
}

sub handle_request {
    1;
}

sub error {
    my $app = shift;
    my($code, $msg) = @_;
    return unless ref($app);
    $app->response_code($code);
    $app->response_message($msg);
    $app->SUPER::error($msg);
    return undef;
}

sub show_error {
    my $app = shift;
    my($err) = @_;
    chomp($err = encode_xml($err));
    if ($app->{is_soap}) {
        my $code = $app->response_code;
        if ($code >= 400) {
            $app->response_code(500);
            $app->response_message($err);
        }
        return <<FAULT;
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <soap:Fault>
      <faultcode>$code</faultcode>
      <faultstring>$err</faultstring>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>
FAULT
    } else {
        return <<ERR;
<error>$err</error>
ERR
    }
}

sub get_auth_info {
    my $app = shift;
    my %param;
    if ($app->{is_soap}) {
        my $xml = $app->xml_body;
        my $auth = first($xml, NS_WSSE, 'UsernameToken');
        $param{Username} = textValue($auth, NS_WSSE, 'Username');
        $param{PasswordDigest} = textValue($auth, NS_WSSE, 'Password');
        $param{Nonce} = textValue($auth, NS_WSSE, 'Nonce');
        $param{Created} = textValue($auth, NS_WSU, 'Created');
    } else {
        my $req = $app->get_header('X-WSSE')
            or return $app->auth_failure(401, 'X-WSSE authentication required');
        $req =~ s/^WSSE //;
        my ($profile);
        ($profile, $req) = $req =~ /(\S+),?\s+(.*)/;
        return $app->error(400, "Unsupported WSSE authentication profile") 
            if $profile !~ /\bUsernameToken\b/i;
        for my $i (split /,\s*/, $req) {
            my($k, $v) = split /=/, $i, 2;
            $v =~ s/^"//;
            $v =~ s/"$//;
            $param{$k} = $v;
        }
    }
    \%param;
}

sub authenticate {
    my $app = shift;
    my $auth = $app->get_auth_info
        or return $app->auth_failure(400, "No authentication info");
    for my $f (qw( Username PasswordDigest Nonce Created )) {
        return $app->auth_failure(400, "X-WSSE requires $f")
            unless $auth->{$f};
    }
    require MT::Session;
    my $nonce_record = MT::Session->load($auth->{Nonce});
    
    if ($nonce_record && $nonce_record->id eq $auth->{Nonce}) {
        return $app->auth_failure(403, "Nonce already used");
    }
    $nonce_record = new MT::Session();
    $nonce_record->set_values({
        id => $auth->{Nonce},
        created_on => time,
        kind => 'AN'
    });
    $nonce_record->save();
# xxx Expire sessions on shorter timeout?
    my $enc = $app->config('PublishCharset');
    my $username = encode_text($auth->{Username},undef,$enc);
    my $user = MT::Author->load({ name => $username, type => 1 })
        or return $app->auth_failure(403, 'Invalid login');
    return $app->auth_failure(403, 'Invalid login')
        unless $user->api_password;
    my $created_on_epoch = $app->iso2epoch($auth->{Created});
    if (abs(time - $created_on_epoch) > $app->config('WSSETimeout')) {
        return $app->auth_failure(403, 'X-WSSE UsernameToken timed out');
    }
    $auth->{Nonce} = MIME::Base64::decode_base64($auth->{Nonce});
    my $expected = Digest::SHA1::sha1_base64(
         $auth->{Nonce} . $auth->{Created} . $user->api_password);
    # Some base64 implementors do it wrong and don't put the =
    # padding on the end. This should protect us against that without
    # creating any holes.
    $expected =~ s/=*$//;
    $auth->{PasswordDigest} =~ s/=*$//;
    #print STDERR "expected $expected and got " . $auth->{PasswordDigest} . "\n";
    return $app->auth_failure(403, 'X-WSSE PasswordDigest is incorrect')
        unless $expected eq $auth->{PasswordDigest};
    $app->{user} = $user;
    return 1;
}

sub auth_failure {
    my $app = shift;
    $app->set_header('WWW-Authenticate', 'WSSE profile="UsernameToken"');
    return $app->error(@_);
}

sub xml_body {
    my $app = shift;
    unless (exists $app->{xml_body}) {
        if (LIBXML) {
            my $parser = XML::LibXML->new;
            $app->{xml_body} = $parser->parse_string($app->request_content);
        } else {
            my $xp = XML::XPath->new(xml => $app->request_content);
            $app->{xml_body} = ($xp->find('/')->get_nodelist)[0];
        }
    }
    $app->{xml_body};
}

sub atom_body {
    my $app = shift;
    my $atom;
    if ($app->{is_soap}) {
        my $xml = $app->xml_body;
        $atom = MT::Atom::Entry->new(Elem => first($xml, NS_SOAP, 'Body'))
            or return $app->error(500, MT::Atom::Entry->errstr);
    } else {
        $atom = MT::Atom::Entry->new(Stream => \$app->request_content)
            or return $app->error(500, MT::Atom::Entry->errstr);
    }
    $atom;
}

# $target_zone is expected to be a number of hours from GMT
sub iso2ts {
    my $app = shift;
    my($ts, $target_zone) = @_;
    return unless $ts =~ /^(\d{4})(?:-?(\d{2})(?:-?(\d\d?)(?:T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|([+-]\d{2}:\d{2}))?)?)?)?/;
    my($y, $mo, $d, $h, $m, $s, $zone) =
        ($1, $2 || 1, $3 || 1, $4 || 0, $5 || 0, $6 || 0, $7);
    if ($zone) {
        my ($zh, $zm) = $zone =~ /([+-]\d\d):(\d\d)/;
        use Time::Local qw( timegm );
        my $ts = timegm( $s, $m, $h, $d, $mo - 1, $y - 1900 );
        if ($zone ne 'Z') {
            require MT::DateTime;
            my $tz_secs = MT::DateTime->tz_offset_as_seconds($zone);
            $ts -= $tz_secs;
        }
        if ($target_zone) {
            my $tz_secs = (3600 * int($target_zone) + 
                           60 * abs($target_zone - int($target_zone)));
            $ts += $tz_secs;
        }
        ($s, $m, $h, $d, $mo, $y) = gmtime( $ts );
        $y += 1900; $mo++;
    }
    sprintf("%04d%02d%02d%02d%02d%02d", $y, $mo, $d, $h, $m, $s);
}

sub iso2epoch {
    my $app = shift;
    my($ts) = @_;
    return unless $ts =~ /^(\d{4})(?:-?(\d{2})(?:-?(\d\d?)(?:T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|([+-]\d{2}:\d{2}))?)?)?)?/;
    my($y, $mo, $d, $h, $m, $s, $zone) =
        ($1, $2 || 1, $3 || 1, $4 || 0, $5 || 0, $6 || 0, $7);

    use Time::Local;
    my $dt = timegm($s, $m, $h, $d, $mo-1, $y);
    if ($zone && $zone ne 'Z') {
        require MT::DateTime;
        my $tz_secs = MT::DateTime->tz_offset_as_seconds($zone);
        $dt -= $tz_secs;
    }
    $dt;
}

package MT::AtomServer::Weblog;
use strict;

use XML::Atom;
use XML::Atom::Feed;
use base qw( MT::AtomServer );
use MT::Blog;
use MT::Entry;
use MT::Util qw( encode_xml );
use MT::Permission;
use File::Spec;
use File::Basename;
use MT::I18N qw( encode_text );

use constant NS_CATEGORY => 'http://sixapart.com/atom/category#';
use constant NS_DC => 'http://purl.org/dc/elements/1.1/';
use constant NS_PHOTOS => 'http://sixapart.com/atom/photo#';

sub script { $_[0]->{cfg}->AtomScript . '/weblog' }

sub handle_request {
    my $app = shift;
    $app->authenticate || return;
    if (my $svc = $app->{param}{svc}) {
        if ($svc eq 'upload') {
            return $app->handle_upload;
        } elsif ($svc eq 'categories') {
            return $app->get_categories;
        }
    }
    my $method = $app->request_method;
    if ($method eq 'POST') {
        return $app->new_post;
    } elsif ($method eq 'PUT') {
        return $app->edit_post;
    } elsif ($method eq 'DELETE') {
        return $app->delete_post;
    } elsif ($method eq 'GET') {
        if ($app->{param}{entry_id}) {
            return $app->get_post;
        } elsif ($app->{param}{blog_id}) {
            return $app->get_posts;
        } else {
            return $app->get_weblogs;
        }
    }
}

sub authenticate {
    my $app = shift;

    $app->SUPER::authenticate or return;
    if (my $blog_id = $app->{param}{blog_id}) {
        $app->{blog} = MT::Blog->load($blog_id)
            or return $app->error(400, "Invalid blog ID '$blog_id'");
        $app->{user} 
            or return $app->error(403, "Authenticate");
        if ($app->{user}->is_superuser()) {
            $app->{perms} = new MT::Permission;
            $app->{perms}->blog_id($blog_id);
            $app->{perms}->author_id($app->{user}->id);
            $app->{perms}->can_administer_blog(1);
            return 1;
        }
        my $perms = $app->{perms} = MT::Permission->load({
                    author_id => $app->{user}->id,
                    blog_id => $app->{blog}->id });
        return $app->error(403, "No permissions") unless $perms && $perms->can_post;
    }
    1;
}

sub publish {
    my $app = shift;
    my($entry, $no_ping) = @_;
    my $blog = MT::Blog->load($entry->blog_id);
    $app->rebuild_entry( Entry => $entry, Blog => $blog,
                         BuildDependencies => 1 ) or return;
    unless ($no_ping) {
        $app->ping_and_save( Entry => $entry, Blog => $blog )
            or return;
    }
    1;
}

sub get_weblogs {
    my $app = shift;
    my $user = $app->{user};
    my $iter = $user->is_superuser
        ? MT::Blog->load_iter()
        : MT::Permission->load_iter({ author_id => $user->id });
    my $feed = XML::Atom::Feed->new;
    my $base = $app->base . $app->uri;
    while (my $thing = $iter->()) {
        if ($thing->isa('MT::Permission')) {
            next unless $thing->can_post;
        }
        my $blog = $thing->isa('MT::Blog') ? $thing
            : MT::Blog->load($thing->blog_id);
        my $uri = $base . '/blog_id=' . $blog->id;
        my $blogname = encode_text($blog->name . ' #' . $blog->id, undef, 'utf-8');
        $feed->add_link({ rel => 'service.post', title => $blogname,
                          href => $uri, type => 'application/x.atom+xml' });
        $feed->add_link({ rel => 'service.feed', title => $blogname,
                          href => $uri, type => 'application/x.atom+xml' });
        $feed->add_link({ rel => 'service.upload', title => $blogname,
                          href => $uri . '/svc=upload',
                          type => 'application/x.atom+xml' });
        $feed->add_link({ rel => 'service.categories', title => $blogname,
                          href => $uri . '/svc=categories',
                          type => 'application/x.atom+xml' });
        $feed->add_link({ rel => 'alternate', title => $blogname,
                          href => $blog->site_url,
                          type => 'text/html' });
    }
    $app->response_code(200);
    $app->response_content_type('application/x.atom+xml');
    $feed->as_xml;
}

sub new_post {
    my $app = shift;
    my $atom = $app->atom_body or return $app->error(500, "No body!");
    my $blog = $app->{blog};
    my $user = $app->{user};
    my $enc = $app->config('PublishCharset');
    ## Check for category in dc:subject. We will save it later if
    ## it's present, but we want to give an error now if necessary.
    my($cat);
    if (my $label = $atom->get(NS_DC, 'subject')) {
        my $label_enc = encode_text($label,'utf-8',$enc);
        $cat = MT::Category->load({ blog_id => $blog->id, label => $label_enc })
            or return $app->error(400, "Invalid category '$label'");
    }
    my $entry = MT::Entry->new;
    $entry->blog_id($blog->id);
    $entry->author_id($user->id);
    $entry->status(MT::Entry::RELEASE());
    $entry->allow_comments($blog->allow_comments_default);
    $entry->allow_pings($blog->allow_pings_default);
    $entry->convert_breaks($blog->convert_paras);
    $entry->title(encode_text($atom->title,'utf-8',$enc));
    $entry->text(encode_text($atom->content()->body(),'utf-8',$enc));
    $entry->excerpt(encode_text($atom->summary,'utf-8',$enc));
    if (my $iso = $atom->issued) {
        $entry->created_on(MT::Util::iso2ts($blog, $iso));
    }
## xxx mt/typepad-specific fields
    $entry->discover_tb_from_entry();
    $entry->save or return $app->error(500, $entry->errstr);
    require MT::Log;
    $app->log({
        message => $app->translate("User '[_1]' (user #[_2]) added entry #[_3]", $user->name, $user->id, $entry->id),
        level => MT::Log::INFO(),
        class => 'entry',
        category => 'new',
        metadata => $entry->id
    });
    ## Save category, if present.
    if ($cat) {
        my $place = MT::Placement->new;
        $place->is_primary(1);
        $place->entry_id($entry->id);
        $place->blog_id($blog->id);
        $place->category_id($cat->id);
        $place->save or return $app->error(500, $place->errstr);
    }
    $app->publish($entry);
    $app->response_code(201);
    $app->response_content_type('application/xml');
    $app->set_header('Location', $app->base . $app->uri . '/blog_id=' . $entry->blog_id . '/entry_id=' . $entry->id);
    $atom = MT::Atom::Entry->new_with_entry($entry);
    $atom->as_xml;
}

sub edit_post {
    my $app = shift;
    my $atom = $app->atom_body or return;
    my $blog = $app->{blog};
    my $enc = $app->config('PublishCharset');
    my $entry_id = $app->{param}{entry_id}
        or return $app->error(400, "No entry_id");
    my $entry = MT::Entry->load($entry_id)
        or return $app->error(400, "Invalid entry_id");
    return $app->error(403, "Access denied")
        unless $app->{perms}->can_edit_entry($entry, $app->{user});
    $entry->title(encode_text($atom->title,'utf-8',$enc));
    $entry->text(encode_text($atom->content()->body(),'utf-8',$enc));
    $entry->excerpt(encode_text($atom->summary,'utf-8',$enc));
    if (my $iso = $atom->issued) {
        $entry->created_on($app->iso2ts($iso, $blog->server_offset()));
    }
## xxx mt/typepad-specific fields
    $entry->discover_tb_from_entry();
    $entry->save or return $app->error(500, "Entry not saved");
    $app->publish($entry) or return $app->error(500, "Entry not published");
    $app->response_code(200);
    $app->response_content_type('application/xml');
    $atom = MT::Atom::Entry->new_with_entry($entry);
    $atom->as_xml;
}

sub get_posts {
    my $app = shift;
    my $blog = $app->{blog};
    my %terms = (blog_id => $blog->id);
    my %arg = (sort => 'created_on', direction => 'descend');
    my $Limit = 20;
    $arg{limit} = $Limit + 1;
    $arg{offset} = $app->{param}{offset} || 0;
    my $iter = MT::Entry->load_iter(\%terms, \%arg);
    my $feed = XML::Atom::Feed->new;
    my $uri = $app->base . $app->uri . '/blog_id=' . $blog->id;
    my $blogname = encode_text($blog->name, undef, 'utf-8');
    $feed->add_link({ rel => 'alternate', type => 'text/html',
                      href => $blog->site_url });
    $feed->title($blogname);
    $feed->add_link({ rel => 'service.post', type => 'application/x.atom+xml',
                      href => $uri, title => $blogname });
    $uri .= '/entry_id=';
    while (my $entry = $iter->()) {
        my $e = MT::Atom::Entry->new_with_entry($entry);
        $e->add_link({ rel => 'service.edit', type => 'application/x.atom+xml',
                       href => ($uri . $entry->id), title => encode_text($entry->title, undef,'utf-8') });
        $feed->add_entry($e);
    }
    ## xxx add next/prev links
    $app->response_content_type('application/xml');
    $feed->as_xml;
}

sub get_post {
    my $app = shift;
    my $blog = $app->{blog};
    my $entry_id = $app->{param}{entry_id}
        or return $app->error(400, "No entry_id");
    my $entry = MT::Entry->load($entry_id)
        or return $app->error(400, "Invalid entry_id");
    return $app->error(403, "Access denied")
        unless $app->{perms}->can_edit_entry($entry, $app->{user});
    $app->response_content_type('application/xml');
    my $atom = MT::Atom::Entry->new_with_entry($entry);
    $atom->as_xml;
}

sub delete_post {
    my $app = shift;
    my $blog = $app->{blog};
    my $entry_id = $app->{param}{entry_id}
        or return $app->error(400, "No entry_id");
    my $entry = MT::Entry->load($entry_id)
        or return $app->error(400, "Invalid entry_id");
    return $app->error(403, "Access denied")
        unless $app->{perms}->can_edit_entry($entry, $app->{user});
    $entry->remove
        or return $app->error(500, $entry->errstr);
    $app->publish($entry, 1) or return $app->error(500, $app->errstr);
    '';
}

sub handle_upload {
    my $app = shift;
    my $atom = $app->atom_body or return;
    my $blog = $app->{blog};
    my $user = $app->{user};
    return $app->error(403, "Access denied") unless $app->{perms}->can_upload;
    my $content = $atom->content;
    my $type = $content->type
        or return $app->error(400, "content \@type is required");
    my $fname = $atom->title or return $app->error(400, "title is required");
    $fname = basename($fname);
    return $app->error(400, "Invalid or empty filename")
        if $fname =~ m!/|\.\.|\0|\|!;
    my $local = File::Spec->catfile($blog->site_path, $fname);
    my $fmgr = $blog->file_mgr;
    my($base, $path, $ext) = File::Basename::fileparse($local, '\.[^\.]*');
    my $base_copy = $base;
    my $i = 1;
    while ($fmgr->exists($path . $base . $ext)) {
        $base = $base_copy . '_' . $i++;
    }
    $local = $path . $base . $ext;
    my $data = $content->body;
    $atom = XML::Atom::Entry->new;
    $atom->title($base . $ext);
    defined(my $bytes = $fmgr->put_data($data, $local, 'upload'))
        or return $app->error(500, "Error writing uploaded file");
    my $link = XML::Atom::Link->new;
    $link->type($type);
    $link->rel('alternate');
    $link->href($blog->site_url . $base . $ext);
    $atom->add_link($link);
    $app->response_code(201);
    $app->response_content_type('application/x.atom+xml');
    $atom->as_xml;
}

sub get_categories {
    my $app = shift;
    my $blog = $app->{blog};
    my $iter = MT::Category->load_iter({ blog_id => $blog->id });
    my $doc;
    if (LIBXML) {
        $doc = XML::LibXML::Document->createDocument('1.0', 'utf-8');
        my $root = $doc->createElementNS(NS_CATEGORY, 'categories');
        $doc->setDocumentElement($root);
    } else {
        $doc = XML::XPath::Node::Element->new('categories');
        my $ns = XML::XPath::Node::Namespace->new('#default' => NS_CATEGORY);
        $doc->appendNamespace($ns);
    }
    while (my $cat = $iter->()) {
        my $catlabel = encode_text($cat->label, undef, 'utf-8');
        if (LIBXML) {
            my $elem = $doc->createElementNS(NS_DC, 'subject');
            $doc->getDocumentElement->appendChild($elem);
            $elem->appendChild(XML::LibXML::Text->new($catlabel));
        } else {
            my $elem = XML::XPath::Node::Element->new('subject');
            my $ns = XML::XPath::Node::Namespace->new('#default' => NS_DC);
            $elem->appendNamespace($ns);
            $doc->appendChild($elem);
            $elem->appendChild(XML::XPath::Node::Text->new($catlabel));
        }
    }
    $app->response_code(200);
    $app->response_content_type('application/x.atom+xml');
    if (LIBXML) {
        $doc->toString(1);
    } else {
        return '<?xml version="1.0" encoding="utf-8"?>' . "\n" . $doc->toString;
    }
}

1;
