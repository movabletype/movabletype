# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::XMLRPCServer::Util;
use strict;
use Time::Local qw( timegm );
use MT::Util qw( offset_time_list );
use MT::I18N qw( encode_text first_n_text const );

sub mt_new {
    my $cfg = $ENV{MOD_PERL} ?
        Apache->request->dir_config('MTConfig') :
        $MT::XMLRPCServer::MT_DIR . '/mt.cfg';
    my $mt = MT->new( Config => $cfg )
        or die MT::XMLRPCServer::_fault(MT->errstr);
    $main::server->serializer->encoding($mt->config('PublishCharset'));
    $mt;
}

# TBD: Refactor me!
sub iso2ts {
    my($blog, $iso) = @_;
    die MT::XMLRPCServer::_fault(MT->translate("Invalid timestamp format"))
        unless $iso =~ /^(\d{4})(?:-?(\d{2})(?:-?(\d\d?)(?:T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(Z|[+-]\d{2}:\d{2})?)?)?)?/;
    my($y, $mo, $d, $h, $m, $s, $offset) =
    ($1, $2 || 1, $3 || 1, $4 || 0, $5 || 0, $6 || 0, $7);
    if ($offset && !MT::ConfigMgr->instance->IgnoreISOTimezones) {
        $mo--;
        $y -= 1900;
        my $time = timegm($s, $m, $h, $d, $mo, $y);
        ## If it's not already in UTC, first convert to UTC.
        if ($offset ne 'Z') {
            my($sign, $h, $m) = $offset =~ /([+-])(\d{2}):(\d{2})/;
            $offset = $h * 3600 + $m * 60;
            $offset *= -1 if $sign eq '-';
            $time -= $offset;
        }
        ## Now apply the offset for this weblog.
        ($s, $m, $h, $d, $mo, $y) = offset_time_list($time, $blog);
        $mo++;
        $y += 1900;
    }
    sprintf "%04d%02d%02d%02d%02d%02d", $y, $mo, $d, $h, $m, $s;
}

sub ts2iso {
    my ($blog, $ts) = @_;
    my ($yr, $mo, $dy, $hr, $mn, $sc) = unpack('A4A2A2A2A2A2A2', $ts);
    $ts = timegm($sc, $mn, $hr, $dy, $mo, $yr);
    ($sc, $mn, $hr, $dy, $mo, $yr) = offset_time_list($ts, $blog, '-');
    $yr += 1900;
    sprintf("%04d-%02d-%02d %02d:%02d:%02d", $yr, $mo, $dy, $hr, $mn, $sc);
}

package MT::XMLRPCServer;
use strict;

use MT;
use MT::Util qw( first_n_words decode_html start_background_task);
use MT::I18N qw( encode_text first_n_text const );

use MT::ErrorHandler;
BEGIN { @MT::XMLRPCServer::ISA = qw( MT::ErrorHandler ) }

use vars qw( $MT_DIR );

my($HAVE_XML_PARSER);
BEGIN {
    eval { require XML::Parser };
    $HAVE_XML_PARSER = $@ ? 0 : 1;
}

sub _fault {
    SOAP::Fault->faultcode(1)->faultstring([SOAP::Data->type(string => $_[0])]);
}

## This is sort of a hack. XML::Parser automatically makes everything
## UTF-8, and that is causing severe problems with the serialization
## of database records (what happens is this: we construct a string
## consisting of pack('N', length($string)) . $string. If the $string SV
## is flagged as UTF-8, the packed length is then upgraded to UTF-8,
## which turns characters with values greater than 128 into two bytes,
## like v194.129. And so on. This is obviously now what we want, because
## pack produces a series of bytes, not a string that should be mucked
## about with.)
##
## The following subroutine strips the UTF8 flag from a string, thus
## forcing it into a series of bytes. "pack 'C0'" is a magic way of
## forcing the following string to be packed as bytes, not as UTF8.

sub no_utf8 {
    for (@_) {
        next if ref;
        $_ = pack 'C0A*', $_;
    }
}

sub _login {
    my $class = shift;
    my($user, $pass, $blog_id) = @_;
    no_utf8($user, $pass);
    my $mt = MT::XMLRPCServer::Util::mt_new();
    my $enc = $mt->config('PublishCharset');
    $user = encode_text($user, 'utf-8', $enc);
    $pass = encode_text($pass, 'utf-8', $enc);
    require MT::Author;
    my $author = MT::Author->load({ name => $user, type => 1 }) or return;
    die _fault(MT->translate("No web services password assigned.  Please see your author profile to set it.")) unless $author->api_password;
    my $auth = $author->api_password eq $pass;
    $auth ||= crypt($pass, $author->api_password) eq $author->api_password;
    return unless $auth;
    return $author unless $blog_id;
    require MT::Permission;
    my $perms = MT::Permission->load({ author_id => $author->id,
                                       blog_id => $blog_id });
    ($author, $perms);
}

sub _publish {
    my $class = shift;
    my($mt, $entry, $no_ping) = @_;
    require MT::Blog;
    my $blog = MT::Blog->load($entry->blog_id);
    $mt->rebuild_entry( Entry => $entry, Blog => $blog,
                        BuildDependencies => 1 )
        or return $class->error("Rebuild error: " . $mt->errstr);
    unless ($no_ping) {
        $mt->ping_and_save(Blog => $blog, Entry => $entry)
            or return $class->error("Ping error: " . $mt->errstr);
    }
    1;
}

sub newPost {
    my $class = shift;
    my($appkey, $blog_id, $user, $pass, $item, $publish);
    if ($class eq 'blogger') {
        ($appkey, $blog_id, $user, $pass, my($content), $publish) = @_;
        $item->{description} = $content;
    } else {
        ($blog_id, $user, $pass, $item, $publish) = @_;
    }
    die _fault(MT->translate("No blog_id")) unless $blog_id;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    no_utf8($blog_id, values %$item);
    for my $f (qw( title description mt_text_more
                   mt_excerpt mt_keywords mt_tags mt_basename )) {
        next unless defined $item->{$f}; 
        my $enc = $mt->{cfg}->PublishCharset;
        $item->{$f} = encode_text($item->{$f}, 'utf-8', $enc);
        unless ($HAVE_XML_PARSER) {
            $item->{$f} = decode_html($item->{$f});
            $item->{$f} =~ s!&apos;!'!g;  #'
        }
    }
    require MT::Blog;
    my $blog = MT::Blog->load($blog_id)
        or die _fault(MT->translate("Invalid blog ID '[_1]'", $blog_id));
    my($author, $perms) = $class->_login($user, $pass, $blog_id);
    die _fault(MT->translate("Invalid login")) unless $author;
    die _fault(MT->translate("No posting privileges")) unless $perms && $perms->can_post;
    require MT::Entry;
    my $entry = MT::Entry->new;
    my $orig_entry = $entry->clone;
    $entry->blog_id($blog_id);
    $entry->author_id($author->id);

    ## In 2.1 we changed the behavior of the $publish flag. Previously,
    ## it was used to determine the post status. That was a bad idea.
    ## So now entries added through XML-RPC are always set to publish,
    ## *unless* the user has set "NoPublishMeansDraft 1" in mt.cfg, which
    ## enables the old behavior.
    if ($mt->{cfg}->NoPublishMeansDraft) {
        $entry->status($publish ? MT::Entry::RELEASE() : MT::Entry::HOLD());
    } else {
        $entry->status(MT::Entry::RELEASE());
    }
    $entry->allow_comments($blog->allow_comments_default);
    $entry->allow_pings($blog->allow_pings_default);
    $entry->convert_breaks(defined $item->{mt_convert_breaks} ? $item->{mt_convert_breaks} : $blog->convert_paras);
    $entry->allow_comments($item->{mt_allow_comments})
        if exists $item->{mt_allow_comments};
    $entry->title($item->{title} || first_n_text($item->{description}, const('LENGTH_ENTRY_TITLE_FROM_TEXT')));
    $entry->basename($item->{mt_basename}) if $item->{mt_basename};
    $entry->text($item->{description});
    for my $field (qw( allow_pings )) {
        my $val = $item->{"mt_$field"};
        next unless defined $val;
        die _fault(MT->translate("Value for 'mt_[_1]' must be either 0 or 1 (was '[_2]')", $field, $val))
            unless $val == 0 || $val == 1;
        $entry->$field($val);
    }
    $entry->excerpt($item->{mt_excerpt}) if $item->{mt_excerpt};
    $entry->text_more($item->{mt_text_more}) if $item->{mt_text_more};
    $entry->keywords($item->{mt_keywords}) if $item->{mt_keywords};

    if (my $tags = $item->{mt_tags}) {
        require MT::Tag;
        my $tag_delim = chr($author->entry_prefs->{tag_delim});
        my @tags = MT::Tag->split($tag_delim, $tags);
        $entry->set_tags(@tags);
    }
    if (my $urls = $item->{mt_tb_ping_urls}) {
        no_utf8(@$urls);
        $entry->to_ping_urls(join "\n", @$urls);
    }
    if (my $iso = $item->{dateCreated}) {
        $entry->created_on(MT::XMLRPCServer::Util::iso2ts($blog, $iso))
            || die MT::XMLRPCServer::_fault(MT->translate("Invalid timestamp format"));
    }
    $entry->discover_tb_from_entry();

    MT->run_callbacks('APIPreSave.entry', $mt, $entry, $orig_entry)
        || die MT::XMLRPCServer::_fault(MT->translate("PreSave failed [_1]", MT->errstr));

    $entry->save;

    MT->run_callbacks('APIPostSave.entry', $mt, $entry, $orig_entry);

    require MT::Log;
    $mt->log({
        message => $mt->translate("User '[_1]' (user #[_2]) added entry #[_3]", $author->name, $author->id, $entry->id),
        level => MT::Log::INFO(),
        class => 'entry',
        category => 'new',
        metadata => $entry->id
    });

    if ($publish) {
        $class->_publish($mt, $entry) or die _fault($class->errstr);
    }
    delete $ENV{SERVER_SOFTWARE};
    SOAP::Data->type(string => $entry->id);
}

sub editPost {
    my $class = shift;
    my($appkey, $entry_id, $user, $pass, $item, $publish);
    if ($class eq 'blogger') {
        ($appkey, $entry_id, $user, $pass, my($content), $publish) = @_;
        $item->{description} = $content;
    } else {
        ($entry_id, $user, $pass, $item, $publish) = @_;
    }
    die _fault(MT->translate("No entry_id")) unless $entry_id;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    no_utf8(values %$item);
    for my $f (qw( title description mt_text_more
                   mt_excerpt mt_keywords mt_tags mt_basename )) {
        next unless defined $item->{$f}; 
        my $enc = $mt->config('PublishCharset');
        $item->{$f} = encode_text($item->{$f}, 'utf-8', $enc);
        unless ($HAVE_XML_PARSER) {
            $item->{$f} = decode_html($item->{$f});
            $item->{$f} =~ s!&apos;!'!g;  #'
        }
    }
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or die _fault(MT->translate("Invalid entry ID '[_1]'", $entry_id));
    my($author, $perms) = $class->_login($user, $pass, $entry->blog_id);
    die _fault(MT->translate("Invalid login")) unless $author;
    die _fault(MT->translate("Not privileged to edit entry"))
        unless $perms && $perms->can_edit_entry($entry, $author);
    my $orig_entry = $entry->clone;
    $entry->status(MT::Entry::RELEASE()) if $publish;
    $entry->title($item->{title}) if $item->{title};
    $entry->basename($item->{mt_basename}) if defined $item->{mt_basename};
    $entry->text($item->{description});
    $entry->convert_breaks($item->{mt_convert_breaks})
        if exists $item->{mt_convert_breaks};
    $entry->allow_comments($item->{mt_allow_comments})
        if exists $item->{mt_allow_comments};
    for my $field (qw( allow_pings )) {
        my $val = $item->{"mt_$field"};
        next unless defined $val;
        die _fault(MT->translate("Value for 'mt_[_1]' must be either 0 or 1 (was '[_2]')", $field, $val))
            unless $val == 0 || $val == 1;
        $entry->$field($val);
    }
    $entry->excerpt($item->{mt_excerpt}) if defined $item->{mt_excerpt};
    $entry->text_more($item->{mt_text_more}) if defined $item->{mt_text_more};
    $entry->keywords($item->{mt_keywords}) if defined $item->{mt_keywords};
    if (my $tags = $item->{mt_tags}) {
        require MT::Tag;
        my $tag_delim = chr($author->entry_prefs->{tag_delim});
        my @tags = MT::Tag->split($tag_delim, $tags);
        $entry->set_tags(@tags);
    }
    if (my $urls = $item->{mt_tb_ping_urls}) {
        no_utf8(@$urls);
        $entry->to_ping_urls(join "\n", @$urls);
    }
    if (my $iso = $item->{dateCreated}) {
        $entry->created_on(MT::XMLRPCServer::Util::iso2ts($entry->blog_id, $iso))
           || die MT::XMLRPCServer::_fault(MT->translate("Invalid timestamp format"));
    }
    $entry->discover_tb_from_entry();

    MT->run_callbacks('APIPreSave.entry', $mt, $entry, $orig_entry)
        || die MT::XMLRPCServer::_fault(MT->translate("PreSave failed [_1]", MT->errstr));

    $entry->save;

    MT->run_callbacks('APIPostSave.entry', $mt, $entry, $orig_entry);

    if ($publish) {
        $class->_publish($mt, $entry) or die _fault($class->errstr);
    }
    SOAP::Data->type(boolean => 1);
}

sub getUsersBlogs {
    my $class;
    if (UNIVERSAL::isa($_[0] => __PACKAGE__)) {
        $class = shift;
    } else {
        $class = __PACKAGE__;
    }
    my($appkey, $user, $pass) = @_;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my($author) = $class->_login($user, $pass);
    die _fault(MT->translate("Invalid login")) unless $author;
    require MT::Permission;
    require MT::Blog;
    my $iter = MT::Permission->load_iter({ author_id => $author->id });
    my @res;
    while (my $perms = $iter->()) {
        next unless $perms->can_post;
        my $blog = MT::Blog->load($perms->blog_id);
        push @res, { url => SOAP::Data->type(string => $blog->site_url),
                     blogid => SOAP::Data->type(string => $blog->id),
                     blogName => SOAP::Data->type(string => encode_text($blog->name, undef, 'utf-8')) };
    }
    \@res;
}

sub getUserInfo {
    my $class;
    if (UNIVERSAL::isa($_[0] => __PACKAGE__)) {
        $class = shift;
    } else {
        $class = __PACKAGE__;
    }
    my($appkey, $user, $pass) = @_;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my($author) = $class->_login($user, $pass);
    die _fault(MT->translate("Invalid login")) unless $author;
    my($fname, $lname) = map { encode_text($_, undef, 'utf-8') } split /\s+/, $author->name;
    $lname ||= '';
    { userid => SOAP::Data->type(string => $author->id),
      firstname => SOAP::Data->type(string => $fname),
      lastname => SOAP::Data->type(string => $lname),
      nickname => SOAP::Data->type(string => encode_text($author->nickname, undef, 'utf-8')),
      email => SOAP::Data->type(string => $author->email),
      url => SOAP::Data->type(string => $author->url) };
}

sub getRecentPosts {
    my $class = shift;
    my($blog_id, $user, $pass, $num, $titles_only);
    if ($class eq 'blogger') {
        (my($appkey), $blog_id, $user, $pass, $num, $titles_only) = @_;
    } else {
        ($blog_id, $user, $pass, $num, $titles_only) = @_;
    }
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my($author, $perms) = $class->_login($user, $pass, $blog_id);
    die _fault(MT->translate("Invalid login")) unless $author;
    die _fault(MT->translate("No posting privileges")) unless $perms && $perms->can_post;
    require MT::Blog;
    my $blog = MT::Blog->load($blog_id);
    require MT::Entry;
    my $iter = MT::Entry->load_iter({ blog_id => $blog_id },
        { 'sort' => 'created_on',
          direction => 'descend',
          limit => $num });
    my @res;
    while (my $entry = $iter->()) {
        my $co = sprintf "%04d%02d%02dT%02d:%02d:%02d",
            unpack 'A4A2A2A2A2A2', $entry->created_on;
        my $row = { dateCreated => SOAP::Data->type(dateTime => $co),
                    userid => SOAP::Data->type(string => $entry->author_id),
                    postid => SOAP::Data->type(string => $entry->id), };
        if ($class eq 'blogger') {
            $row->{content} = SOAP::Data->type(string => encode_text($entry->text, undef, 'utf-8'));
        } else {
            $row->{title} = SOAP::Data->type(string => encode_text($entry->title, undef, 'utf-8'));
            unless ($titles_only) {
                require MT::Tag;
                my $tag_delim = chr($author->entry_prefs->{tag_delim});
                my $tags = MT::Tag->join($tag_delim, $entry->tags);
                $row->{description} = SOAP::Data->type(string => encode_text($entry->text, undef, 'utf-8'));
                my $link = $entry->permalink;
                $row->{link} = SOAP::Data->type(string => $link);
                $row->{permaLink} = SOAP::Data->type(string => $link),
                $row->{mt_basename} = SOAP::Data->type(string => encode_text($entry->basename, undef, 'utf-8'));
                $row->{mt_allow_comments} = SOAP::Data->type(int => $entry->allow_comments);
                $row->{mt_allow_pings} = SOAP::Data->type(int => $entry->allow_pings);
                $row->{mt_convert_breaks} = SOAP::Data->type(string => $entry->convert_breaks);
                $row->{mt_text_more} = SOAP::Data->type(string => encode_text($entry->text_more, undef, 'utf-8'));
                $row->{mt_excerpt} = SOAP::Data->type(string => encode_text($entry->excerpt, undef, 'utf-8'));
                $row->{mt_keywords} = SOAP::Data->type(string => encode_text($entry->keywords, undef, 'utf-8'));
                $row->{mt_tags} = SOAP::Data->type(string => encode_text($tags, undef, 'utf-8'));
            }
        }
        push @res, $row;
    }
    \@res;
}

sub getRecentPostTitles {
    getRecentPosts(@_, 1);
}

sub deletePost {
    my $class;
    if (UNIVERSAL::isa($_[0] => __PACKAGE__)) {
        $class = shift;
    } else {
        $class = __PACKAGE__;
    }
    my($appkey, $entry_id, $user, $pass, $publish) = @_;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or die _fault(MT->translate("Invalid entry ID '[_1]'", $entry_id));
    my($author, $perms) = $class->_login($user, $pass, $entry->blog_id);
    die _fault(MT->translate("Invalid login")) unless $author;
    die _fault(MT->translate("Not privileged to delete entry"))
        unless $perms && $perms->can_edit_entry($entry, $author);
    $entry->remove;

    $mt->log({
        message => $mt->translate("Entry '[_1]' (entry #[_2]) deleted by '[_3]' (user #[_4]) from xml-rpc", $entry->title, $entry->id, $author->name, $author->id),
        level => MT::Log::INFO(),
        class => 'system',
        category => 'delete' 
   });


    if ($publish) {
        $class->_publish($mt, $entry, 1) or die _fault($class->errstr);
    }
    SOAP::Data->type(boolean => 1);
}

sub getPost {
    my $class = shift;
    my($entry_id, $user, $pass) = @_;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or die _fault(MT->translate("Invalid entry ID '[_1]'", $entry_id));
    my($author, $perms) = $class->_login($user, $pass, $entry->blog_id);
    die _fault(MT->translate("Invalid login")) unless $author;
    die _fault(MT->translate("Not privileged to get entry"))
        unless $perms && $perms->can_edit_entry($entry, $author);
    my $co = sprintf "%04d%02d%02dT%02d:%02d:%02d",
        unpack 'A4A2A2A2A2A2', $entry->created_on;
    require MT::Blog;
    my $blog = MT::Blog->load($entry->blog_id);
    my $link = $entry->permalink;
    require MT::Tag;
    my $delim = chr($author->entry_prefs->{tag_delim});
    my $tags = MT::Tag->join($delim, $entry->tags);
    {
        dateCreated => SOAP::Data->type(dateTime => $co),
        userid => SOAP::Data->type(string => $entry->author_id),
        postid => SOAP::Data->type(string => $entry->id),
        description => SOAP::Data->type(string => encode_text($entry->text, undef, 'utf-8')),
        title => SOAP::Data->type(string => encode_text($entry->title, undef, 'utf-8')),
        mt_basename => SOAP::Data->type(string => encode_text($entry->basename, undef, 'utf-8')),
        link => SOAP::Data->type(string => $link),
        permaLink => SOAP::Data->type(string => $link),
        mt_allow_comments => SOAP::Data->type(int => $entry->allow_comments),
        mt_allow_pings => SOAP::Data->type(int => $entry->allow_pings),
        mt_convert_breaks => SOAP::Data->type(string => $entry->convert_breaks),
        mt_text_more => SOAP::Data->type(string => encode_text($entry->text_more, undef, 'utf-8')),
        mt_excerpt => SOAP::Data->type(string => encode_text($entry->excerpt, undef, 'utf-8')),
        mt_keywords => SOAP::Data->type(string => encode_text($entry->keywords, undef, 'utf-8')),
        mt_tags => SOAP::Data->type(string => encode_text($tags, undef, 'utf-8')),
    }
}

sub supportedMethods {
    [ 'blogger.newPost', 'blogger.editPost', 'blogger.getRecentPosts',
      'blogger.getUsersBlogs', 'blogger.getUserInfo', 'blogger.deletePost',
      'metaWeblog.getPost', 'metaWeblog.newPost', 'metaWeblog.editPost',
      'metaWeblog.getRecentPosts', 'metaWeblog.newMediaObject',
      'mt.getCategoryList', 'mt.setPostCategories', 'mt.getPostCategories',
      'mt.getTrackbackPings', 'mt.supportedTextFilters',
      'mt.getRecentPostTitles', 'mt.publishPost', 'mt.getTagList' ];
}

sub supportedTextFilters {
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my $filters = $mt->all_text_filters;
    my @res;
    for my $filter (keys %$filters) {
        push @res, {
            key => SOAP::Data->type(string => $filter),
            label => SOAP::Data->type(string => $filters->{$filter}{label})
        };
    }
    \@res;
}

## getCategoryList, getPostCategories, and setPostCategories were
## originally written by Daniel Drucker with the assistance of
## Six Apart, then later modified by Six Apart.

sub getCategoryList {
    my $class = shift;
    my($blog_id, $user, $pass) = @_;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my($author, $perms) = $class->_login($user, $pass, $blog_id);
    die _fault(MT->translate("Invalid login")) unless $author;
    die _fault(MT->translate("Author does not have privileges"))
        unless $perms && $perms->can_post;
    require MT::Category;
    my $iter = MT::Category->load_iter({ blog_id => $blog_id });
    my @data;
    while (my $cat = $iter->()) {
        push @data, {
            categoryName => SOAP::Data->type(string => encode_text($cat->label, undef, 'utf-8')),
            categoryId => SOAP::Data->type(string => $cat->id)
        };
    }
    \@data;
}

sub getTagList {
    my $class = shift;
    my($blog_id, $user, $pass) = @_;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my($author, $perms) = $class->_login($user, $pass, $blog_id);
    die _fault(MT->translate("Invalid login")) unless $author;
    die _fault(MT->translate("Author does not have privileges"))
        unless $perms && $perms->can_post;
    require MT::Tag;
    require MT::ObjectTag;
    my $iter = MT::Tag->load_iter(undef, { join => ['MT::ObjectTag', 'tag_id', { blog_id => $blog_id }, { unique => 1 } ] } );
    my @data;
    while (my $tag = $iter->()) {
        push @data, {
            tagName => SOAP::Data->type(string => encode_text($tag->name, undef, 'utf-8')),
            tagId => SOAP::Data->type(string => $tag->id)
        };
    }
    \@data;
}

sub getPostCategories {
    my $class = shift;
    my($entry_id, $user, $pass) = @_;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or die _fault(MT->translate("Invalid entry ID '[_1]'", $entry_id));
    my($author, $perms) = $class->_login($user, $pass, $entry->blog_id);
    die _fault(MT->translate("Invalid login")) unless $author;
    die _fault(MT->translate("No posting privileges")) unless $perms && $perms->can_post;
    my @data;
    my $prim = $entry->category;
    my $cats = $entry->categories;
    for my $cat (@$cats) {
        my $is_primary = $prim && $cat->id == $prim->id ? 1 : 0;
        push @data, {
            categoryName => SOAP::Data->type(string => encode_text($cat->label, undef, 'utf-8')),
            categoryId => SOAP::Data->type(string => $cat->id),
            isPrimary => SOAP::Data->type(boolean => $is_primary),
        };
    }
    \@data;
}

sub setPostCategories {
    my $class = shift;
    my($entry_id, $user, $pass, $cats) = @_;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    require MT::Entry;
    require MT::Placement;
    my $entry = MT::Entry->load($entry_id)
         or die _fault(MT->translate("Invalid entry ID '[_1]'", $entry_id));
    my($author, $perms) = $class->_login($user, $pass, $entry->blog_id);
    die _fault(MT->translate("Invalid login")) unless $author;
    die _fault(MT->translate("Not privileged to set entry categories"))
        unless $perms && $perms->can_edit_entry($entry, $author);
    my @place = MT::Placement->load({ entry_id => $entry_id });
    for my $place (@place) {
         $place->remove;
    }
    ## Keep track of which category is named the primary category.
    ## If the first structure in the array does not have an isPrimary
    ## key, we just make it the primary category; if it does, we use
    ## that flag to determine the primary category.
    my $is_primary = 1;
    for my $cat (@$cats) {
         my $place = MT::Placement->new;
         $place->entry_id($entry_id);
         $place->blog_id($entry->blog_id);
         if (defined $cat->{isPrimary} && $is_primary) {
             $place->is_primary($cat->{isPrimary});
         } else {
             $place->is_primary($is_primary);
         }
         ## If we just set the is_primary flag to 1, we don't want to
         ## make any other categories primary.
         $is_primary = 0 if $place->is_primary;
         $place->category_id($cat->{categoryId});
         $place->save
              or die _fault(MT->translate("Saving placement failed: [_1]", $place->errstr));
    }
    SOAP::Data->type(boolean => 1);
}

sub getTrackbackPings {
    my $class = shift;
    my($entry_id) = @_;
    require MT::Trackback;
    require MT::TBPing;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my $tb = MT::Trackback->load({ entry_id => $entry_id })
        or return [];
    my $iter = MT::TBPing->load_iter({ tb_id => $tb->id });
    my @data;
    while (my $ping = $iter->()) {
        push @data, {
            pingTitle => SOAP::Data->type(string => encode_text($ping->title, undef, 'utf-8')),
            pingURL => SOAP::Data->type(string => $ping->source_url),
            pingIP => SOAP::Data->type(string => $ping->ip),
        };
    }
    \@data;
}

sub publishPost {
    my $class = shift;
    my($entry_id, $user, $pass) = @_;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or die _fault(MT->translate("Invalid entry ID '[_1]'", $entry_id));
    my($author, $perms) = $class->_login($user, $pass, $entry->blog_id);
    die _fault(MT->translate("Invalid login")) unless $author;
    die _fault(MT->translate("Not privileged to edit entry"))
        unless $perms && $perms->can_edit_entry($entry, $author);
    $mt->rebuild_entry( Entry => $entry, BuildDependencies => 1 )
        or die _fault(MT->translate("Publish failed: [_1]", $mt->errstr));
    SOAP::Data->type(boolean => 1);
}

sub runPeriodicTasks {
    my $class = shift;
    my ($user, $pass) = @_;

    my $mt = MT::XMLRPCServer::Util::mt_new();
    my $author = $class->_login($user, $pass);
    die _fault(MT->translate("Invalid login")) unless $author;

    $mt->run_tasks;

    { responseCode => 'success' }
}

sub publishScheduledFuturePosts {
    my $class = shift;
    my ($blog_id, $user, $pass) = @_;

    my $mt = MT::XMLRPCServer::Util::mt_new();
    my $author = $class->_login($user, $pass);
    die _fault(MT->translate("Invalid login")) unless $author;
    my $blog = MT::Blog->load($blog_id);

    my $now = time;
    # Convert $now to user's timezone, which is how future post dates
    # are stored.
    $now = MT::Util::offset_time($now);
    $now = strftime("%Y%m%d%H%M%S", gmtime($now));

    my $iter = MT::Entry->load_iter({
        blog_id => $blog->id,
        status => MT::Entry::FUTURE()},
        {'sort' => 'created_on',
         direction => 'descend'
    });
    my @queue;
    while (my $i = $iter->()) {
        push @queue, $i->id();
    }

    my $changed = 0;
    my $total_changed = 0;
    my @results;
    foreach my $entry_id (@queue) {
        my $entry = MT::Entry->load($entry_id);
        if ($entry->created_on <= $now) {
            $entry->status(MT::Entry::RELEASE());
            $entry->discover_tb_from_entry();
            $entry->save
                or die $entry->errstr;

            start_background_task(sub {
                $mt->rebuild_entry( Entry => $entry, Blog => $blog )
                    or die $mt->errstr;
            });
            $changed++;
            $total_changed++;
        }
    }
    if ($changed) {
        $mt->rebuild_indexes( Blog => $blog )
            or die $mt->errstr;
    }
    { responseCode => 'success', 
      publishedCount => $total_changed,
    };
}

sub getNextScheduled {
    my $class = shift;
    my ($user, $pass) = @_;

    my $mt = MT::XMLRPCServer::Util::mt_new();
    my $author = $class->_login($user, $pass);
    die _fault(MT->translate("Invalid login")) unless $author;

    my $next_scheduled = MT::get_next_sched_post_for_user($author->id());

    { nextScheduledTime => $next_scheduled };
}

sub setRemoteAuthToken {
    my $class = shift;
    my ($user, $pass, $remote_auth_username, $remote_auth_token) = @_;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my($author) = $class->_login($user, $pass);
    die _fault(MT->translate("Invalid login")) unless $author;
    $author->remote_auth_username($remote_auth_username);
    $author->remote_auth_token($remote_auth_token);
    $author->save();
    1;
}

sub newMediaObject {
    my $class = shift;
    my($blog_id, $user, $pass, $file) = @_;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my($author, $perms) = $class->_login($user, $pass, $blog_id);
    die _fault(MT->translate("Invalid login")) unless $author;
    die _fault(MT->translate("Not privileged to upload files"))
        unless $perms && $perms->can_upload;
    require MT::Blog;
    require File::Spec;
    my $blog = MT::Blog->load($blog_id);
    my $fname = $file->{name} or die _fault(MT->translate("No filename provided"));
    if ($fname =~ m!\.\.|\0|\|!) {
        die _fault(MT->translate("Invalid filename '[_1]'", $fname));
    }
    my $local_file = File::Spec->catfile($blog->site_path, $file->{name});
    my $fmgr = $blog->file_mgr;
    my($vol, $path, $name) = File::Spec->splitpath($local_file);
    $path =~ s!/$!! unless $path eq '/';  ## OS X doesn't like / at the end in mkdir().
    unless ($fmgr->exists($path)) {
        $fmgr->mkpath($path)
            or die _fault(MT->translate("Error making path '[_1]': [_2]", $path, $fmgr->errstr));
    }
    defined(my $bytes = $fmgr->put_data($file->{bits}, $local_file, 'upload'))
        or die _fault(MT->translate("Error writing uploaded file: [_1]", $fmgr->errstr));
    my $url = $blog->site_url . $fname;

    MT->run_callbacks('APIUploadFile',
                      File => $local_file, Url => $url,
                      Type => 'file',
                      Blog => $blog);

    { url => SOAP::Data->type(string => $url) };
}

## getTemplate and setTemplate are not applicable in MT's template
## structure, so they are unimplemented (they return a fault).
## We assign it twice to get rid of "setTemplate used only once" warnings.

sub getTemplate {
    die _fault(MT->translate(
        "Template methods are not implemented, due to differences between the Blogger API and the Movable Type API."));
}
*setTemplate = *setTemplate = \&getTemplate;

## The above methods will be called as blogger.newPost, blogger.editPost,
## etc., because we are implementing Blogger's API. Thus, the empty
## subclass.
package blogger;
BEGIN { @blogger::ISA = qw( MT::XMLRPCServer ); }

package metaWeblog;
BEGIN { @metaWeblog::ISA = qw( MT::XMLRPCServer ); }

package mt;
BEGIN { @mt::ISA = qw( MT::XMLRPCServer ); }

1;
__END__

=head1 NAME

MT::XMLRPCServer

=head1 SYNOPSIS

An XMLRPC API interface for communicating with Movable Type.

=head1 CALLBACKS

=over 4

=item APIPreSave.entry

    callback($eh, $mt, $entry, $original_entry)

Called before saving a new or existing entry. If saving a new entry, the
$original_entry will have an unassigned 'id'. This callback is executed
as a filter, so your handler must return 1 to allow the entry to be saved.

=item APIPostSave.entry

    callback($eh, $mt, $entry, $original_entry)

Called after saving a new or existing entry. If saving a new entry, the
$original_entry will have an unassigned 'id'.

=item APIUploadFile

    callback($eh, %params)

This callback is invoked for each file the user uploads to the weblog.
This callback is similar to the CMSUploadFile callback found in
C<MT::App::CMS>.

=head3 Parameters

=over 4

=item File

The full physical file path of the uploaded file.

=item Url

The full URL to the file that has been uploaded.

=item Type

For this callback, this value is currently always 'file'.

=item Blog

The C<MT::Blog> object associated with the newly uploaded file.

=back

=back

=cut