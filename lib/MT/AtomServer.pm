# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::AtomServer;
use strict;

use MT::I18N qw( encode_text );
use XML::Atom;
use XML::Atom::Util qw( first textValue );
use base qw( MT::App );
use MIME::Base64 ();
use Digest::SHA1 ();
use MT::Atom;
use MT::Util qw( encode_xml );
use MT::Author;

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
        my $apps = $app->config->AtomApp;
        if (my $class = $apps->{$subapp}) {
            eval "require $class;";
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
    if (my $e = $@) {
        $app->error(500, $e);
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
    if ($code && $msg) {
        chomp($msg = encode_xml($msg)); 
        $app->response_code($code);
        $app->response_message($msg);
        $app->response_content_type('text/xml'); 
        $app->response_content("<error>$msg</error>"); 
    }
    elsif ($code) {
        return $app->SUPER::error($code);
    }
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
        or return $app->auth_failure(401, "Unauthorized");
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
        start => time,
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
    return $app->auth_failure(403, 'Invalid login')
        unless $user->is_active;
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

    ## update session so the user will be counted as active
    require MT::Session;
    my $sess_active = MT::Session->load( { kind => 'UA', name => $user->id } );
    if (!$sess_active) {
        $sess_active = MT::Session->new;
        $sess_active->id($app->make_magic_token());
        $sess_active->kind('UA'); # UA == User Activation
        $sess_active->name($user->id);
    }
    $sess_active->start(time);
    $sess_active->save;
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

use MT::I18N qw( encode_text );
use XML::Atom;
use XML::Atom::Feed;
use base qw( MT::AtomServer );
use MT::Blog;
use MT::Entry;
use MT::Util qw( encode_xml format_ts );
use MT::Permission;
use File::Spec;
use File::Basename;

use constant NS_APP => 'http://www.w3.org/2007/app';
use constant NS_DC => 'http://purl.org/dc/elements/1.1/';
use constant NS_TYPEPAD => 'http://sixapart.com/atom/typepad#';

sub script { $_[0]->{cfg}->AtomScript . '/1.0' }

sub atom_content_type   { 'application/atom+xml' }
sub atom_x_content_type { 'application/atom+xml' }

sub edit_link_rel { 'edit' }
sub get_posts_order_field { 'modified_on' }

sub new_feed {
    my $app = shift;
    XML::Atom::Feed->new( Version => 1.0 );
}

sub new_with_entry {
    my $app = shift;
    my ($entry) = @_;
    my $atom = MT::Atom::Entry->new_with_entry( $entry, Version => 1.0 );

    my $mo = MT::Atom::Entry::_create_issued($entry->modified_on, $entry->blog);
    $atom->set(NS_APP(), 'edited', $mo);

    $atom;
}

sub apply_basename {
    my $app = shift;
    my ($entry, $atom) = @_;

    if (my $basename = $app->get_header('Slug')) {
        my $entry_class = ref $entry;
        my $basename_uses = $entry_class->exist({
            blog_id  => $entry->blog_id,
            basename => $basename,
            ($entry->id ? ( id => { op => '!=', value => $entry->id } ) : ()),
        });
        if ($basename_uses) {
            $basename = MT::Util::make_unique_basename($entry);
        }

        $entry->basename($basename);
    }

    $entry;
}

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
        return $app->error(403, "Permission denied.") unless $perms && $perms->can_create_post;
    }
    1;
}

sub publish {
    my $app = shift;
    my($entry, $no_ping) = @_;
    my $blog = MT::Blog->load($entry->blog_id)
        or return;
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
    my $base = $app->base . $app->uri;
    my $enc = $app->config->PublishCharset;

    # TODO: libxml support? XPath should always be available...
    require XML::XPath;
    require XML::XPath::Node::Element;
    require XML::XPath::Node::Namespace;
    require XML::XPath::Node::Text;

    my $doc = XML::XPath::Node::Element->new('service');
    my $app_ns = XML::XPath::Node::Namespace->new('#default' => NS_APP());
    $doc->appendNamespace($app_ns);
    my $atom_ns = XML::XPath::Node::Namespace->new('atom' => 'http://www.w3.org/2005/Atom');
    $doc->appendNamespace($atom_ns);

    while (my $thing = $iter->()) {
        # TODO: provide media collection if author can upload to this blog.
        if ($thing->isa('MT::Permission')) {
            next if !$thing->can_create_post;
        }

        my $blog = $thing->isa('MT::Blog') ? $thing
            : MT::Blog->load($thing->blog_id);
        next unless $blog;
        my $uri = $base . '/blog_id=' . $blog->id;

        my $workspace = XML::XPath::Node::Element->new('workspace');
        $doc->appendChild($workspace);

        my $title = XML::XPath::Node::Element->new('atom:title', 'atom');
        my $blogname = encode_text($blog->name, $enc, 'utf-8');
        $title->appendChild(XML::XPath::Node::Text->new($blogname));
        $workspace->appendChild($title);

        my $entries = XML::XPath::Node::Element->new('collection');
        $entries->appendAttribute(XML::XPath::Node::Attribute->new('href', $uri));
        $workspace->appendChild($entries);

        my $e_title = XML::XPath::Node::Element->new('atom:title', 'atom');
        my $feed_title = encode_text(MT->translate('[_1]: Entries', $blog->name), $enc, 'utf-8');
        $e_title->appendChild(XML::XPath::Node::Text->new($feed_title));
        $entries->appendChild($e_title);

        my $cats = XML::XPath::Node::Element->new('categories');
        $cats->appendAttribute(XML::XPath::Node::Attribute->new('href', $uri . '/svc=categories'));
        $entries->appendChild($cats);
    }
    $app->response_code(200);
    $app->response_content_type('application/atomsvc+xml');
    '<?xml version="1.0" encoding="utf-8"?>' . "\n" .                                                          
        $doc->toString;
}

sub get_categories {
    my $app = shift;
    my $blog = $app->{blog};

    # TODO: libxml support? XPath should always be available...
    require XML::XPath;
    require XML::XPath::Node::Element;
    require XML::XPath::Node::Namespace;
    require XML::XPath::Node::Text;

    my $doc = XML::XPath::Node::Element->new('categories');
    my $app_ns = XML::XPath::Node::Namespace->new('#default' => NS_APP());
    $doc->appendNamespace($app_ns);
    my $atom_ns = XML::XPath::Node::Namespace->new('atom' => 'http://www.w3.org/2005/Atom');
    $doc->appendNamespace($atom_ns);
    $doc->appendAttribute(XML::XPath::Node::Attribute->new('fixed', 'yes'));

    my $iter = MT::Category->load_iter({ blog_id => $blog->id });
    while (my $cat = $iter->()) {
        my $cat_node = XML::XPath::Node::Element->new('atom:category', 'atom');
        $cat_node->appendAttribute(XML::XPath::Node::Attribute->new('term', $cat->label));
        $doc->appendChild($cat_node);
    }

    $app->response_code(200);
    $app->response_content_type('application/atomcat+xml');
    '<?xml version="1.0" encoding="utf-8"?>' . "\n" .                                                          
        $doc->toString;
}

sub new_post {
    my $app = shift;
    my $atom = $app->atom_body or return $app->error(500, "No body!");
    my $blog = $app->{blog};
    my $user = $app->{user};
    my $perms = $app->{perms};
    my $enc = $app->config('PublishCharset');
    ## Check for category in dc:subject. We will save it later if
    ## it's present, but we want to give an error now if necessary.
    my($cat);
    if (my $label = $atom->get(NS_DC, 'subject')) {
        my $label_enc = encode_text($label,'utf-8',$enc);
        $cat = MT::Category->load({ blog_id => $blog->id, label => $label_enc })
            or return $app->error(400, "Invalid category '$label'");
    }

    my $content = $atom->content;
    my $type = $content->type; 
    my $body = encode_text(MT::I18N::utf8_off($content->body),'utf-8',$enc); 
    my $asset;
    if ($type && $type !~ m!^application/.*xml$!) {
        if ($type !~ m!^text/!) {
            $asset = $app->_upload_to_asset or return;
        }
        elsif ($type && $type eq 'text/plain') {
            ## Check for LifeBlog Note & SMS records.
            my $format = $atom->get(NS_DC, 'format');
            if ($format && ($format eq 'Note' || $format eq 'SMS')) {
                $asset = $app->_upload_to_asset or return;
            }
        }
    }
    if ( $atom->get(NS_TYPEPAD, 'standalone') && $asset ) {
        $app->response_code(201);
        $app->response_content_type('application/atom_xml');
        my $a = MT::Atom::Entry->new_with_asset($asset);
        return $a->as_xml; 
    } 

    my $entry = MT::Entry->new;
    my $orig_entry = $entry->clone;
    $entry->blog_id($blog->id);
    $entry->author_id($user->id);
    $entry->created_by($user->id);
    $entry->status($perms->can_publish_post ? MT::Entry::RELEASE() : MT::Entry::HOLD() );
    $entry->allow_comments($blog->allow_comments_default);
    $entry->allow_pings($blog->allow_pings_default);
    $entry->convert_breaks($blog->convert_paras);
    $entry->title(encode_text($atom->title,'utf-8',$enc));
    $entry->text(encode_text(MT::I18N::utf8_off($atom->content()->body()),'utf-8',$enc));
    $entry->excerpt(encode_text($atom->summary,'utf-8',$enc));
    if (my $iso = $atom->issued) {
        my $pub_ts = MT::Util::iso2ts($blog, $iso);
        $entry->authored_on($pub_ts);
        require MT::DateTime;
        if ( 0 < MT::DateTime->compare( blog => $blog,
                a => $pub_ts,
                b => { value => time(), type => 'epoch' } )
           )
        {
            $entry->status(MT::Entry::FUTURE())
        }
    }
## xxx mt/typepad-specific fields
    $app->apply_basename($entry, $atom);
    $entry->discover_tb_from_entry();

    if (my @link = $atom->link) {
        my $i = 0;
        my $img_html = '';
        my $num_links = scalar @link;
        for my $link (@link) {
            next unless $link->rel eq 'related';
            my($asset_id) = $link->href =~ /asset\-(\d+)$/;
            if ($asset_id) {
                require MT::Asset;
                my $a = MT::Asset->load($asset_id);
                next unless $a;
                my $pkg = MT::Asset->handler_for_file($a->file_name);
                my $asset = bless $a, $pkg;
                $img_html .= $asset->as_html({ include => 1 });
            }
        }
        if ($img_html) {
            $img_html .= qq{<br style="clear: left;" />\n\n};
            $entry->text($img_html . $body);
        }
    }

    MT->run_callbacks('api_pre_save.entry', $app, $entry, $orig_entry)
        or return $app->error(500, MT->translate("PreSave failed [_1]", MT->errstr));

    $entry->save or return $app->error(500, $entry->errstr);

    require MT::Log;
    $app->log({
        message => $app->translate("User '[_1]' (user #[_2]) added [lc,_4] #[_3]", $user->name, $user->id, $entry->id, $entry->class_label),
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

    MT->run_callbacks('api_post_save.entry', $app, $entry, $orig_entry);

    $app->publish($entry);
    $app->response_code(201);
    $app->response_content_type('application/atom+xml');
    my $edit_uri = $app->base . $app->uri . '/blog_id=' . $entry->blog_id . '/entry_id=' . $entry->id;
    $app->set_header('Location', $edit_uri);
    $atom = $app->new_with_entry($entry);
    $atom->add_link({ rel => $app->edit_link_rel,
                      href => $edit_uri,
                      type => 'application/atom+xml',  # even in Legacy
                      title => $entry->title });
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
    my $orig_entry = $entry->clone;
    $entry->title(encode_text($atom->title,'utf-8',$enc));
    $entry->text(encode_text(MT::I18N::utf8_off($atom->content()->body()),'utf-8',$enc));
    $entry->excerpt(encode_text($atom->summary,'utf-8',$enc));
    $entry->modified_by($app->{user}->id);
    if (my $iso = $atom->issued) {
        my $pub_ts = MT::Util::iso2ts($blog, $iso);
        $entry->authored_on($pub_ts);
        require MT::DateTime;
        if ( 0 < MT::DateTime->compare( blog => $blog,
                a => $pub_ts,
                b => { value => time(), type => 'epoch' } )
           )
        {
            $entry->status(MT::Entry::FUTURE())
        }
    }
## xxx mt/typepad-specific fields
    $app->apply_basename($entry, $atom);
    $entry->discover_tb_from_entry();

    MT->run_callbacks('api_pre_save.entry', $app, $entry, $orig_entry)
        or return $app->error(500, MT->translate("PreSave failed [_1]", MT->errstr));

    $entry->save or return $app->error(500, "Entry not saved");

    require MT::Log;
    $app->log({
        message => $app->translate("User '[_1]' (user #[_2]) edited [lc,_4] #[_3]", $app->{user}->name, $app->{user}->id, $entry->id, $entry->class_label),
        level => MT::Log::INFO(),
        class => 'entry',
        category => 'new',
        metadata => $entry->id
    });

    MT->run_callbacks('api_post_save.entry', $app, $entry, $orig_entry);

    if ($entry->status == MT::Entry::RELEASE()) {
        $app->publish($entry) or return $app->error(500, "Entry not published");
    }
    $app->response_code(200);
    $app->response_content_type($app->atom_content_type);
    $atom = $app->new_with_entry($entry);
    $atom->as_xml;
}

sub get_posts {
    my $app = shift;
    my $blog = $app->{blog};
    my %terms = (blog_id => $blog->id);
    my %arg = (sort => $app->get_posts_order_field, direction => 'descend');
    $arg{limit}  = $app->{param}{limit}  || 21;
    $arg{offset} = $app->{param}{offset} || 0;
    my $iter = MT::Entry->load_iter(\%terms, \%arg);
    my $feed = $app->new_feed();
    my $uri = $app->base . $app->uri . '/blog_id=' . $blog->id;
    my $blogname = encode_text($blog->name, undef, 'utf-8');
    $feed->add_link({ rel => 'alternate', type => 'text/html',
                      href => $blog->site_url });
    $feed->add_link({ rel => 'self', type => $app->atom_x_content_type,
                      href => $uri });
    $feed->title($blogname);
    # FIXME: move the line to the Legacy class
    if ( !$feed->version || ( $feed->version < 1.0 ) ) {
        $feed->add_link({ rel => 'service.post', type => $app->atom_x_content_type,
                          href => $uri, title => $blogname });
    }
    require URI;
    my $site_uri = URI->new($blog->site_url);
    if ( $site_uri ) {
        my $blog_created = format_ts('%Y-%m-%d', $blog->created_on, $blog, 'en', 0);
        my $id = 'tag:'.$site_uri->host.','.$blog_created.':'.$site_uri->path.'/'.$blog->id;
        $feed->id($id);
    }
    my $latest_date = 0;
    $uri .= '/entry_id=';
    my @entries;
    while (my $entry = $iter->()) {
        my $e = $app->new_with_entry($entry);
        $e->add_link({ rel => $app->edit_link_rel, type => $app->atom_x_content_type,
                       href => ($uri . $entry->id), title => encode_text($entry->title, undef,'utf-8') });
        $e->add_link({ rel => 'replies', type => $app->atom_x_content_type,
                href => $app->base . $app->app_path . $app->config->AtomScript . '/comments/blog_id=' . $blog->id . '/entry_id=' . $entry->id });

        # feed/updated should be added before entries
        # so we postpone adding them until later
        push @entries, $e;
        my $date = $entry->modified_on || $entry->authored_on;
        if ( $latest_date < $date ) {
            $latest_date = $date;
            $feed->updated( $e->updated );
        }
    }
    $feed->add_entry($_) foreach @entries;
    ## xxx add next/prev links
    $app->run_callbacks( 'get_posts', $feed, $blog );
    $app->response_content_type($app->atom_content_type);
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
    $app->response_content_type($app->atom_content_type);
    my $atom = $app->new_with_entry($entry);
    my $uri = $app->base . $app->uri . '/blog_id=' . $blog->id;
    $uri .= '/entry_id=';
    $atom->add_link({ rel => $app->edit_link_rel, type => $app->atom_x_content_type,
        href => ($uri . $entry->id), title => encode_text($entry->title, undef,'utf-8') });
    $atom->add_link({ rel => 'replies', type => $app->atom_x_content_type,
        href => $app->base
            . $app->app_path
            . $app->config->AtomScript
            . '/comments/blog_id=' . $blog->id
            . '/entry_id=' . $entry->id
    });
    $app->run_callbacks( 'get_post', $atom, $entry );
    $app->response_content_type($app->atom_content_type);
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

    # Delete archive file
    $blog = MT::Blog->load($entry->blog_id);
    my %recipe = $app->publisher->rebuild_deleted_entry(
        Entry => $entry,
        Blog  => $blog);

    # Remove object
    $entry->remove
        or return $app->error(500, $entry->errstr);

    # Rebuild archives
    if (%recipe) {
        $app->rebuild_archives(
            Blog             => $blog,
            Recipe           => \%recipe,
        ) or die _fault($app->errstr);
    }

    # Rebuild index files
    if ( $app->config('RebuildAtDelete') ) {
        $app->rebuild_indexes( Blog => $blog )
            or die _fault($app->errstr);
    }

    require MT::Log;
    my $user = $app->{user};
    $app->log({
        message => $app->translate("Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from atom api", $entry->title, $entry->id, $user->name, $user->id, $entry->class_label),
        level => MT::Log::INFO(),
        class => 'system',
        category => 'delete',
    });

    '';
}

sub _upload_to_asset {
    my $app = shift;
    my $atom = $app->atom_body or return;
    my $blog = $app->{blog};
    my $user = $app->{user};
    my %MIME2EXT = (
        'text/plain'         => '.txt',
        'image/jpeg'         => '.jpg',
        'video/3gpp'         => '.3gp',
        'application/x-mpeg' => '.mpg',
        'video/mp4'          => '.mp4',
        'video/quicktime'    => '.mov',
        'audio/mpeg'         => '.mp3',
        'audio/x-wav'        => '.wav',
        'audio/ogg'          => '.ogg',
        'audio/ogg-vorbis'   => '.ogg',
    );

    return $app->error(403, "Access denied") unless $app->{perms}->can_upload;
    my $content = $atom->content;
    my $type = $content->type
        or return $app->error(400, "content \@type is required");
    my $fname = $atom->title or return $app->error(400, "title is required");
    $fname = basename($fname);
    return $app->error(400, "Invalid or empty filename")
        if $fname =~ m!/|\.\.|\0|\|!;

    my $local_relative = File::Spec->catfile('%r', $fname);
    my $local = File::Spec->catfile($blog->site_path, $fname);
    my $fmgr = $blog->file_mgr;
    my($base, $path, $ext) = File::Basename::fileparse($local, '\.[^\.]*');
    $ext = $MIME2EXT{$type} unless $ext;
    my $base_copy = $base;
    my $ext_copy = $ext;
    $ext_copy =~ s/\.//;
    my $i = 1;
    while ($fmgr->exists($path . $base . $ext)) {
        $base = $base_copy . '_' . $i++;
    }
    $local = $path . $base . $ext;
    my $data = $content->body;
    defined(my $bytes = $fmgr->put_data($data, $local, 'upload'))
        or return $app->error(500, "Error writing uploaded file");

    eval { require Image::Size; };
    return $app->error(500, MT->translate("Perl module Image::Size is required to determine width and height of uploaded images.")) if $@;
    my ( $w, $h, $id ) = Image::Size::imgsize($local);

    require MT::Asset;
    my $asset_pkg = MT::Asset->handler_for_file($local);
    my $is_image  = defined($w)
      && defined($h)
      && $asset_pkg->isa('MT::Asset::Image');
    my $asset;
    if (!($asset = $asset_pkg->load(
                { file_path => $local, blog_id => $blog->id })))
    {
        $asset = $asset_pkg->new();
        $asset->file_path($local_relative);
        $asset->file_name($base.$ext);
        $asset->file_ext($ext_copy);
        $asset->blog_id($blog->id);
        $asset->created_by( $user->id );
    }
    else {
        $asset->modified_by( $user->id );
    }
    my $original = $asset->clone;
    my $url = '%r/' . $base . $ext;
    $asset->url($url);
    if ($is_image) {
        $asset->image_width($w);
        $asset->image_height($h);
    }
    $asset->mime_type($type);
    $asset->save;

    MT->run_callbacks(
        'api_upload_file.' . $asset->class,
        File => $local, file => $local,
        Url => $url, url => $url,
        Size => $bytes, size => $bytes,
        Asset => $asset, asset => $asset,
        Type => $asset->class, type => $asset->class,
        Blog => $blog, blog => $blog);
    if ($is_image) {
        MT->run_callbacks(
            'api_upload_image',
            File => $local, file => $local,
            Url => $url, url => $url,
            Size => $bytes, size => $bytes,
            Asset => $asset, asset => $asset,
            Height => $h, height => $h,
            Width => $w, width => $w,
            Type => 'image', type => 'image',
            ImageType => $id, image_type => $id,
            Blog => $blog, blog => $blog);
    }

    $asset;
}

sub handle_upload {
    my $app = shift;
    my $blog = $app->{blog};
    
    my $asset = $app->_upload_to_asset or return;

    my $link = XML::Atom::Link->new;
    $link->type($asset->mime_type);
    $link->rel('alternate');
    $link->href($asset->url);
    my $atom = XML::Atom::Entry->new;
    $atom->title($asset->file_name);
    $atom->add_link($link);
    $app->response_code(201);
    $app->response_content_type('application/x.atom+xml');
    $atom->as_xml;
}

package MT::AtomServer::Weblog::Legacy;
use strict;

use base qw( MT::AtomServer::Weblog );

use MT::I18N qw( encode_text );
use XML::Atom;  # for LIBXML
use XML::Atom::Feed;
use MT::Blog;
use MT::Permission;

use constant NS_CATEGORY => 'http://sixapart.com/atom/category#';
use constant NS_DC => MT::AtomServer::Weblog->NS_DC();

sub script { $_[0]->{cfg}->AtomScript . '/weblog' }

sub atom_content_type   { 'application/xml' }
sub atom_x_content_type { 'application/x.atom+xml' }

sub edit_link_rel { 'service.edit' }
sub get_posts_order_field { 'authored_on' }

sub new_feed {
    my $app = shift;
    XML::Atom::Feed->new();
}

sub new_with_entry {
    my $app = shift;
    my ($entry) = @_;
    MT::Atom::Entry->new_with_entry($entry);
}

sub apply_basename {}

sub get_weblogs {
    my $app = shift;
    my $user = $app->{user};
    my $iter = $user->is_superuser
        ? MT::Blog->load_iter()
        : MT::Permission->load_iter({ author_id => $user->id });
    my $feed = $app->new_feed();
    my $base = $app->base . $app->uri;
    require URI;
    my $uri = URI->new($base);
    if ( $uri ) {
        my $created = MT::Util::format_ts('%Y-%m-%d', $user->created_on, undef, 'en', 0);
        my $id = 'tag:'.$uri->host.','.$created.':'.$uri->path.'/weblogs-'.$user->id;
        $feed->id($id);
    }
    while (my $thing = $iter->()) {
        if ($thing->isa('MT::Permission')) {
            next unless $thing->can_create_post;
        }
        my $blog = $thing->isa('MT::Blog') ? $thing
            : MT::Blog->load($thing->blog_id);
        next unless $blog;
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

package MT::AtomServer::Comments;
use strict;

use base qw( MT::AtomServer::Weblog );
use MT::I18N qw( encode_text );

sub script { $_[0]->{cfg}->AtomScript . '/comments' }

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
#        return $app->new_comment;
    } elsif ($method eq 'PUT') {
#        return $app->edit_comment;
    } elsif ($method eq 'DELETE') {
#        return $app->delete_comment;
    } elsif ($method eq 'GET') {
        if ($app->{param}{comment_id}) {
            return $app->get_comment;
        } elsif ($app->{param}{entry_id}) {
            return $app->get_comments;
        } else {
            return $app->get_blog_comments;
        }
    }
}

sub new_with_comment {
    my $app = shift;
    my ($comment) = @_;
    my $atom = MT::Atom::Entry->new_with_comment( $comment, Version => 1.0 );

    my $mo = MT::Atom::Entry::_create_issued(
        $comment->modified_on || $comment->created_on, $comment->blog);
    $atom->set(MT::AtomServer::Weblog::NS_APP(), 'edited', $mo);

    $atom;
}

sub get_comment {
    my $app = shift;
    my $blog = $app->{blog};
    my $comment_id = $app->{param}{comment_id}
        or return $app->error(400, "No comment_id");
    my $comment = MT::Comment->load($comment_id)
        or return $app->error(400, "Invalid comment_id");
    my $entry = $comment->entry;
    my $uri = $app->base . $app->uri . '/blog_id=' . $blog->id;
    my $c = $app->new_with_comment($comment);
    $c->add_link({ rel => 'self', type => $app->atom_x_content_type,
                   href => $uri . '/comment_id=' . $comment->id });
    # feed/updated should be added before entries
    # so we postpone adding them until later
    $c->set('http://purl.org/syndication/thread/1.0', 'in-reply-to',
        undef,
        { ref => $entry->atom_id,
            type => 'text/html',
            href => $entry->permalink } );
    $app->run_callbacks( 'get_comment', $c, $comment );
    $app->response_content_type($app->atom_content_type);
    $c->as_xml;
}

sub get_blog_comments {
    my $app = shift;
    my $blog = $app->{blog};
    my %terms = (blog_id => $blog->id, visible => 1);
    my %arg = (sort => $app->get_posts_order_field, direction => 'descend');
    $arg{limit}  = $app->{param}{limit}  || 21;
    $arg{offset} = $app->{param}{offset} || 0;

    my $feed = $app->new_feed();
    my $uri = $app->base . $app->uri . '/blog_id=' . $blog->id;
    my $blogname = encode_text($blog->name, undef, 'utf-8');
    $feed->add_link({ rel => 'alternate', type => 'text/html',
                      href => $blog->site_url });
    $feed->add_link({ rel => 'self', type => $app->atom_x_content_type,
                      href => $uri });
    $feed->title($blogname);

    require URI;
    my $site_uri = URI->new($blog->site_url);
    if ( $site_uri ) {
        my $blog_created = MT::Util::format_ts('%Y-%m-%d', $blog->created_on, $blog, 'en', 0);
        my $id = 'tag:'.$site_uri->host.','.$blog_created.':'.$site_uri->path.'/'.$blog->id;
        $feed->id($id);
    }
    $app->_comments_in_atom($feed, \%terms, \%arg);
    $app->run_callbacks( 'get_blog_comments', $feed, $blog );
    ## xxx add next/prev links
    $app->response_content_type($app->atom_content_type);
    $feed->as_xml;
}

sub get_comments {
    my $app = shift;
    my $blog = $app->{blog};
    my $entry_id = $app->{param}{entry_id}
        or return $app->error(400, "No entry_id");
    my $entry = MT::Entry->load($entry_id)
        or return $app->error(400, "Invalid entry_id");
    my %terms = (blog_id => $blog->id, entry_id => $entry->id, visible => 1);
    my %arg = (sort => $app->get_posts_order_field, direction => 'descend');
    $arg{limit}  = $app->{param}{limit}  || 21;
    $arg{offset} = $app->{param}{offset} || 0;

    my $feed = $app->new_feed();
    my $uri = $app->base . $app->uri . '/blog_id=' . $blog->id;
    my $blogname = encode_text($blog->name, undef, 'utf-8');
    $feed->add_link({ rel => 'alternate', type => 'text/html',
                      href => $entry->permalink });
    $feed->add_link({ rel => 'self', type => $app->atom_x_content_type,
                      href => $uri . '/entry_id=' . $entry->id });
    $feed->title($entry->title);
    $feed->id($entry->atom_id . '/comments');
    $app->_comments_in_atom($feed, \%terms, \%arg);
    $app->run_callbacks( 'get_comments', $feed, $entry );
    ## xxx add next/prev links
    $app->response_content_type($app->atom_content_type);
    $feed->as_xml;
}

sub _comments_in_atom {
    my $app = shift;
    my ( $feed, $terms, $args ) = @_;
    require MT::Comment;
    my $iter = MT::Comment->load_iter($terms, $args);
    my $latest_date = 0;
    my @comments;
    while (my $comment = $iter->()) {
        my $c = $app->new_with_comment($comment);
        # feed/updated should be added before entries
        # so we postpone adding them until later
        my $entry = $comment->entry;
        $c->set('http://purl.org/syndication/thread/1.0', 'in-reply-to',
            undef,
            { ref => $entry->atom_id,
              type => 'text/html',
              href => $entry->permalink } );
        push @comments, $c;
        my $date = $comment->modified_on || $comment->created_on;
        if ( $latest_date < $date ) {
            $latest_date = $date;
            $feed->updated( $c->updated );
        }
    }
    $feed->add_entry($_) foreach @comments;
    $feed;
}


1;
__END__

=head1 NAME

MT::AtomServer

=head1 SYNOPSIS

An Atom Publishing API interface for communicating with Movable Type.

=head1 METHODS

=head2 $app->xml_body()

Takes the content posted to the server and parses it into an XML document.
Uses either XML::LibXML or XML::XPath depending on which is available.

=head2 $app->iso2epoch($iso_ts)

Converts C<$iso_ts> in the format of an ISO timestamp into a unix timestamp
(seconds since the epoch).

=head2 $app->init

Initializes the application.

=head2 $app->get_auth_info

Processes the request for WSSE authentication and returns a hash containing:

=over 4

=item * Username

=item * PasswordDigest

=item * Nonce

=item * Created

=back

=head2 $app->handle_request

The implementation of this in I<MT::AtomServer::Weblog> passes the request
to the proper method.

=head2 $app->handle

Wrapper method that determines the proper AtomServer package to pass the
request to.

=head2 $app->iso2ts($iso_ts, $target_zone)

Converts C<$iso_ts> in the format of an ISO timestamp into a MT-compatible
timestamp (YYYYMMDDHHMMSS) for the specified timezone C<$target_zone>.

=head2 $app->atom_body

Processes the request as Atom content and returns an XML::Atom object.

=head2 $app->error($code, $message)

Sends the HTTP headers necessary to relay an error.

=head2 $app->authenticate()

Checks the WSSE authentication with the local MT user database and
confirms the user is authorized to access the resources required by
the request.

=head2 $app->show_error($message)

Returns an XML wrapper for the error response.

=head2 $app->auth_failure($code, $message)

Handles the response in the event of an authentication failure.

=head1 CALLBACKS

=over 4

=item api_pre_save.entry

    callback($eh, $app, $entry, $original_entry)

Called before saving a new or existing entry. If saving a new entry, the
$original_entry will have an unassigned 'id'. This callback is executed
as a filter, so your handler must return 1 to allow the entry to be saved.

=item api_post_save.entry

    callback($eh, $app, $entry, $original_entry)

Called after saving a new or existing entry. If saving a new entry, the
$original_entry will have an unassigned 'id'.

=item get_posts

    callback($eh, $app, $feed, $blog)

Called right before get_posts method returns atom feed response.
I<$feed> is a reference to XML::Atom::Feed object.
I<$blog> is a reference to the requested MT::Blog object.

=item get_post

    callback($eh, $app, $atom_entry, $entry)

Called right before get_post method returns atom entry response.
I<$atom_entry> is a reference to XML::Atom::Entry object.
I<$entry> is a reference to the requested MT::Entry object.

=item get_blog_comments

    callback($eh, $app, $feed, $blog)

Called right before get_blog_comments method returns atom feed response.
I<$feed> is a reference to XML::Atom::Feed object.
I<$blog> is a reference to the requested MT::Blog object.

=item get_comments

    callback($eh, $app, $feed, $entry)

Called right before get_comments method returns atom feed response. 
I<$feed> is a reference to XML::Atom::Feed object.
I<$entry> is a reference to the requested MT::Entry object.

=item get_comment

    callback($eh, $app, $atom_entry, $comment)

Called right before get_comment method returns atom entry response.
I<$atom_entry> is a reference to XML::Atom::Entry object.
I<$comment> is a reference to the requested MT::Comment object.

=back

=cut
