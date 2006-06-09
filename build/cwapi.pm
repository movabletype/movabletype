# $Id$

## xxx issues with weblogs API:
## error handling
## is "array of categories" array of labels, or of structs?
## categories.edit has no category ID
## templates.* should use template IDs?
## what about $publish flag? in 'options' struct?

my($HAVE_XML_PARSER);
BEGIN {
    eval { require XML::Parser };
    $HAVE_XML_PARSER = $@ ? 0 : 1;
}

## Common Weblogs API support

*weblogs::user::login = \&MT::XMLRPC::Methods::login;
*weblogs::user::getBlogNames = \&MT::XMLRPC::Methods::get_blogs;

*weblogs::posts::new = \&MT::XMLRPC::Methods::new_post;
*weblogs::posts::edit = \&MT::XMLRPC::Methods::edit_post;
*weblogs::posts::delete = \&MT::XMLRPC::Methods::delete_post;
*weblogs::posts::count = \&MT::XMLRPC::Methods::count_posts;
*weblogs::posts::getAll = \&MT::XMLRPC::Methods::get_posts;
*weblogs::posts::get = \&MT::XMLRPC::Methods::get_posts;

## Blogger API support

*blogger::newPost = \&MT::XMLRPC::Methods::new_post;
*blogger::editPost = \&MT::XMLRPC::Methods::edit_post;
*blogger::deletePost = \&MT::XMLRPC::Methods::delete_post;
*blogger::getUsersBlogs = \&MT::XMLRPC::Methods::get_blogs;
*blogger::getUserInfo = \&MT::XMLRPC::Methods::login;

## getTemplate and setTemplate are not applicable in MT's template
## structure, so they are unimplemented (they return a fault).
## We assign it twice to get rid of "setTemplate used only once" warnings.

*blogger::getTemplate = sub {
    die "Template methods are not implemented, due to differences between " .
        "the Blogger API and the Movable Type API.\n";
};
*blogger::setTemplate = \&getTemplate;


package MT::XMLRPC::Helpers;
use strict;

sub _login {
    my $class = shift;
    my($user, $pass, $blog_id) = @_;
    require MT::Author;
    my $author = MT::Author->load({ name => $user }) or return;
    $author->is_valid_password($pass) or return;
    return $author unless $blog_id;
    require MT::Permission;
    my $perms = MT::Permission->load({ author_id => $author->id,
                                       blog_id => $blog_id });
    ($author, $perms);
}

sub _publish {
    my $class = shift;
    my($mt, $entry) = @_;
    require MT::Blog;
    my $blog = MT::Blog->load($entry->blog_id);
    $mt->rebuild_entry( Entry => $entry, Blog => $blog,
                        BuildDependencies => 1 )
        or return $class->error("Rebuild error: " . $mt->errstr);
    $mt->ping(Blog => $blog)
        or return $class->error("Ping error: " . $mt->errstr);
    1;
}

sub no_utf8 {
    for (@_) {
        next if !defined $_;
        $_ = pack 'C0A*', $_;
    }
}

package MT::XMLRPC::Methods;
use strict;

use MT::Util qw( decode_html first_n_words );
use MT;

sub login {
    my $class = shift;
    my $is_blogger = $class =~ /^blogger/;
    my($appkey, $user, $pass) = @_;
    my $mt = MT->new;
    my $author = MT::XMLRPC::Helpers->_login($user, $pass)
        or die "Invalid login\n";
    if ($is_blogger) {
        my($fname, $lname) = split /\s+/, $author->name;
        return { userid    => SOAP::Data->type(string => $author->id),
                 firstname => SOAP::Data->type(string => $fname),
                 lastname  => SOAP::Data->type(string => $lname),
                 nickname  => SOAP::Data->type(string => $author->nickname),
                 email     => SOAP::Data->type(string => $author->email),
                 url       => SOAP::Data->type(string => $author->url) };
    } else {
        return { username => SOAP::Data->type(string => $author->name),
                 userID   => SOAP::Data->type('int'  => $author->id),
                 url      => SOAP::Data->type(string => $author->url),
                 email    => SOAP::Data->type(string => $author->email) };
    }
}

sub get_blogs {
    my $class = shift;
    my $is_blogger = $class =~ /^blogger/;
    my($appkey, $user, $pass) = @_;
    my $mt = MT->new;
    my $author = MT::XMLRPC::Helpers->_login($user, $pass)
        or die "Invalid login\n";
    require MT::Permission;
    require MT::Blog;
    my $iter = MT::Permission->load_iter({ author_id => $author->id });
    my @res;
    my $id_key = $is_blogger ? 'blogid' : 'blogID';
    while (my $perms = $iter->()) {
        next unless $perms->can_post;
        my $blog = MT::Blog->load($perms->blog_id);
        push @res, { $id_key  => SOAP::Data->type(string => $blog->id),
                     blogName => SOAP::Data->type(string => $blog->name),
                     url      => SOAP::Data->type(string => $blog->site_url) };
    }
    \@res;
}

sub new_post {
    my $class = shift;
    my $is_blogger = $class =~ /^blogger/;
    my($appkey, $user, $pass, $blog_id, $content,
       $cats, $title, $publish, $opt);
    if ($is_blogger) {
        ($appkey, $blog_id, $user, $pass, $content, $publish) = @_;
    } else {
        ($appkey, $user, $pass, $blog_id, $content, $cats, $title, $opt) = @_;
    }
    MT::XMLRPC::Helpers::no_utf8($blog_id, $content, $title);
    unless ($HAVE_XML_PARSER) {
        $content = decode_html($content);
        $title = decode_html($title);
    }
    my $mt = MT->new;
    require MT::Blog;
    my $blog = MT::Blog->load($blog_id)
        or die "Invalid blog ID '$blog_id'\n";
    my($author, $perms) = MT::XMLRPC::Helpers->_login($user, $pass, $blog_id);
    die "Invalid login\n" unless $author;
    die "No posting privileges\n" unless $perms && $perms->can_post;
    require MT::Entry;
    my $entry = MT::Entry->new;
    $entry->blog_id($blog_id);
    $entry->author_id($author->id);
## xxx handle categories
    $entry->status($blog->status_default);
    $entry->convert_breaks($blog->convert_paras);
    $entry->allow_comments($blog->allow_comments_default);
    $entry->title($title || first_n_words($content, 5));
    $entry->text($content);
    $entry->save;
    if ($publish) {
        MT::XMLRPC::Helpers->_publish($mt, $entry)
            or die MT::XMLRPC::Helpers->errstr;
    }
    if ($is_blogger) {
        return SOAP::Data->type(string => $entry->id);
    } else {
        return SOAP::Data->type('int' => $entry->id);
    }
}

sub edit_post {
    my $class = shift;
    my $is_blogger = $class =~ /^blogger/;
    my($appkey, $user, $pass, $blog_id, $entry_id, $content,
       $cats, $title, $publish, $opt);
    if ($is_blogger) {
        ($appkey, $entry_id, $user, $pass, $content, $publish) = @_;
    } else {
        ($appkey, $user, $pass, $blog_id, $entry_id, $content, $cats,
         $title, $opt) = @_;
    }
    MT::XMLRPC::Helpers::no_utf8($blog_id, $content, $title);
    unless ($HAVE_XML_PARSER) {
        $content = decode_html($content);
        $title = decode_html($title);
    }
    my $mt = MT->new;
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or die "Invalid entry ID '$entry_id'\n";
    my($author, $perms) =
        MT::XMLRPC::Helpers->_login($user, $pass, $entry->blog_id);
    die "Invalid login\n" unless $author;
    die "Not privileged to edit entry\n"
        unless $perms && $perms->can_post ||
        ($perms->can_edit_all_posts && $entry->author_id == $author->id);
    $entry->status(MT::Entry::RELEASE()) if $publish;
## xxx handle categories
    $entry->title($title) if $title;
    $entry->text($content);
    $entry->save;
    if ($publish) {
        MT::XMLRPC::Helpers->_publish($mt, $entry)
            or die MT::XMLRPC::Helpers->errstr;
    }
    SOAP::Data->type(boolean => 1);
}

sub delete_post {
    my $class = shift;
    my $is_blogger = $class =~ /^blogger/;
    my($appkey, $user, $pass, $blog_id, $entry_id, $publish);
    if ($is_blogger) {
        ($appkey, $entry_id, $user, $pass, $publish) = @_;
    } else {
        ($appkey, $user, $pass, $blog_id, $entry_id) = @_;
    }
    my $mt = MT->new;
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or die "Invalid entry ID '$entry_id'\n";
    my($author, $perms) =
        MT::XMLRPC->_login($user, $pass, $entry->blog_id);
    die "Invalid login\n" unless $author;
    die "Not privileged to delete entry\n"
        unless $perms && $perms->can_post ||
        ($perms->can_edit_all_posts && $entry->author_id == $author->id);
    $entry->remove;
    if ($publish) {
        MT::XMLRPC::Helpers->_publish($mt, $entry)
            or die MT::XMLRPC::Helpers->errstr;
    }
    SOAP::Data->type(boolean => 1);
}

sub count_posts {
    my $class = shift;
    my($appkey, $user, $pass, $blog_id) = @_;
    require MT::Blog;
    my $blog = MT::Blog->load($blog_id)
        or die "Invalid blog ID '$blog_id'\n";
    my($author, $perms) = MT::XMLRPC->_login($user, $pass, $blog_id);
    die "Invalid login\n" unless $author;
    die "Not privileged to post to blog\n" unless $perms->can_post;
    require MT::Entry;
    my $count = MT::Entry->count({ blog_id => $blog_id });
    SOAP::Data->type('int' => $count);
}

sub get_posts {
    my $class = shift;
    my $is_blogger = $class =~ /^blogger/;
    my($appkey, $user, $pass, $blog_id, $limit, $offset);
    if ($is_blogger) {
        ($appkey, $blog_id, $user, $pass, $limit) = @_;
    } else {
        ($appkey, $user, $pass, $blog_id, $limit, $offset) = @_;
    }
    my $mt = MT->new;
    my($author, $perms) = MT::XMLRPC::Helpers->_login($user, $pass, $blog_id);
    die "Invalid login\n" unless $author;
    die "No posting privileges\n" unless $perms && $perms->can_post;
    require MT::Entry;
    my %arg = ('sort' => 'created_on', direction => 'descend');
    if ($limit) {
        $arg{limit} = $limit;
        $arg{offset} = $offset if $offset;
    }
    my $iter = MT::Entry->load_iter({ blog_id => $blog_id }, \%arg);
    my @res;
    my $mk_row;
    if ($is_blogger) {
        $mk_row = sub { {
            dateCreated => SOAP::Data->type(dateTime => $_[0]),
            userid      => SOAP::Data->type(userid => $_[1]),
            postid      => SOAP::Data->type(string => $_[2]),
            content     => SOAP::Data->type(string => $_[3]),
        } };
    } else {
        $mk_row = sub { {
            postID       => SOAP::Data->type('int' => $_[2]),
            'time'       => SOAP::Data->type(dateTime => $_[0]),
            subject      => SOAP::Data->type(string => $_[4]),
            post         => SOAP::Data->type(string => $_[3]),
            num_comments => SOAP::Data->type('int' => $_[5]),
        } };
    }
    if (!$is_blogger) {
        require MT::Comment;
    }
    while (my $entry = $iter->()) {
        my $co = sprintf "%04d%02d%02dT%02d:%02d:%02d",
            unpack 'A4A2A2A2A2A2', $entry->created_on;
        my @arg = ($co, $entry->author_id, $entry->id, $entry->text);
        if (!$is_blogger) {
## xxx need to handle categories
            push @arg, $entry->title;
            my $count = MT::Comment->count({ entry_id => $entry->id });
            push @arg, $count;
        }
        my $row = $mk_row->(@arg);
        push @res, $row;
    }
    \@res;
}

sub get_categories {
    my $class = shift;
    my($appkey, $user, $pass, $blog_id) = @_;
    my $mt = MT->new;
    my($author, $perms) = MT::XMLRPC::Helpers->_login($user, $pass, $blog_id);
    die "Invalid login\n" unless $author;
    die "No posting privileges\n" unless $perms && $perms->can_post;
    require MT::Category;
    my $iter = MT::Category->load_iter({ blog_id => $blog_id });
    my @res;
    while (my $cat = $iter->()) {
        push @res, {
            catID   => SOAP::Data->type('int' => $cat->id),
            catName => SOAP::Data->type(string => $cat->label)
        };
    }
    \@res;
}

sub new_category {
    my $class = shift;
    my($appkey, $user, $pass, $blog_id, $label, $opt) = @_;
    MT::XMLRPC::Helpers::no_utf8($blog_id, $label);
    my $mt = MT->new;
    my($author, $perms) = MT::XMLRPC::Helpers->_login($user, $pass, $blog_id);
    die "Invalid login\n" unless $author;
    die "No category editing privileges\n"
        unless $perms && $perms->can_edit_categories;
    require MT::Category;
    my $cat = MT::Category->new;
    $cat->blog_id($blog_id);
    $cat->label($label);
    $cat->author_id($author->id);
    $cat->save;
    SOAP::Data->type('int' => $cat->id);
}

sub edit_category {
    my $class = shift;
    my($appkey, $user, $pass, $blog_id, $label, $opt) = @_;
    MT::XMLRPC::Helpers::no_utf8($blog_id, $label);
    my $mt = MT->new;
    my($author, $perms) = MT::XMLRPC::Helpers->_login($user, $pass, $blog_id);
    die "Invalid login\n" unless $author;
    die "No category editing privileges\n"
        unless $perms && $perms->can_edit_categories;
    require MT::Category;
    my $cat = MT::Category->new;
    $cat->blog_id($blog_id);
    $cat->label($label);
    $cat->author_id($author->id);
    $cat->save;
    SOAP::Data->type('int' => $cat->id);
}

1;
