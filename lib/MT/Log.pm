# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Log;
use strict;

use constant INFO     => 1;
use constant WARNING  => 2;
use constant ERROR    => 4;
use constant SECURITY => 8;
use constant DEBUG    => 16;

use vars qw(@ISA %Classes);
%Classes = (
    'system' => 'MT::Log',
    'entry' => 'MT::Log::Entry',
    'ping' => 'MT::Log::Ping',
    'comment' => 'MT::Log::Comment',
);

use MT::Object;
@ISA = qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'message' => 'string(255)',
        'ip' => 'string(16)',
        'blog_id' => 'integer not null',
        'author_id' => 'integer',
        'level' => 'integer',
        'class' => 'string(255)',
        'category' => 'string(255)',
        'metadata' => 'string(255)',
    },
    indexes => {
        created_on => 1,
        blog_id => 1,
        level => 1,
        class => 1,
    },
    defaults => {
        blog_id => 0,
    },
    child_of => 'MT::Blog',
    datasource => 'log',
    audit => 1,
    primary_key => 'id',
});

sub new {
    my $pkg = shift;
    my $log = $pkg->SUPER::new(@_);
    if ($pkg eq __PACKAGE__) {
        $log->class('system');
    } else {
        $log->class($pkg);
    }
    $log;
}

sub add_class {
    my $class = shift;
    my ($ident, $package) = @_;
    $Classes{$ident} = $package;
}

{
    my %bad_classes;

    sub set_values {
        my $obj = shift;
        $obj->SUPER::set_values(@_);
        my $pkg = $obj->class;
        $pkg = $Classes{$pkg} if $pkg && exists $Classes{$pkg};
        if ($pkg ne ref($obj)) {
            return $obj if exists $bad_classes{$pkg};
            unless (defined *{$pkg.'::'}) {
                eval "use $pkg;";
                if ($@) {
                    $bad_classes{$pkg} = 1;
                    return $obj if $@;
                }
            }
            $obj = bless $obj, $pkg if $pkg;
        }
        $obj;
    }
}

sub class_description {
    "System";
}

sub format {
    my $log = shift;
    my $style = shift;
    if (defined $style && ($style eq 'atom')) {
        my $atom = shift;
        my $title = $log->message || '';
        $title = substr($title, 0, 50) if length($title) > 50;
        $atom->title($title);
        if ($log->metadata) {
            $atom->content($log->metadata);
        } else {
            $atom->content('<pre>' . $log->message . '</pre>');
        }

        require XML::Atom::Link;
        my $link = XML::Atom::Link->new(Version => 1.0);
        $link->type('text/html');
        $link->rel('alternate');
        $link->href(MT->instance->base . MT->instance->mt_uri(mode => 'view_log', ($log->blog_id ? (args => { blog_id => $log->blog_id }) : ()) ));
        $atom->add_link($link);
    } else {
        if ($log->message =~ m/\r?\n/) {
            return '<pre>' . $log->message . '</pre>';
        }
    }
    undef;
}

sub init {
    my $log = shift;
    $log->SUPER::init(@_);
    my @ts = gmtime(time);
    my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
        $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
    $log->created_on($ts);
    $log->modified_on($ts);
    $log;
}

package MT::Log::Entry;

@MT::Log::Entry::ISA = qw(MT::Log);

sub class_description {
    "Entries";
}

sub format {
    my $log = shift;
    my $style = shift;

    my $id = int($log->metadata);
    require MT::Entry;
    my $entry = MT::Entry->load($id);
    my $msg;
    if ($entry) {
        my $blog = MT::Blog->load($entry->blog_id);
        sub _fmt {
            my ($entry, $blog, $text) = @_;
            $text = '' unless defined $text;
            my $convert_breaks = defined $entry->convert_breaks ?
                $entry->convert_breaks :
                $blog->convert_paras;
            if ($convert_breaks) {
                my $filters = $entry->text_filters;
                push @$filters, '__default__' unless @$filters;
                $text = MT->apply_text_filters($text, $filters);
            }
            $text;
        }
        my $txt = _fmt($entry, $blog, $entry->text) || '';
        $txt .= _fmt($entry, $blog, $entry->text_more) || '';
        # We may want to do some loose sanitization here to prevent
        # any javascript from being emitted...
        $msg = $txt;
    } else {
        $msg = MT->translate('Entry # [_1] not found.', $id);
    }

    if (defined $style && ($style eq 'atom')) {
        my $atom = shift;
        if ($entry) {
            require XML::Atom::Link;
            my $link = XML::Atom::Link->new(Version => 1.0);
            $link->type('text/html');
            $link->rel('alternate');
            $link->href($entry->permalink);
            $atom->add_link($link);

            if (my $author = $entry->author) {
                require XML::Atom::Person;
                my $person = XML::Atom::Person->new(Version => 1.0);
                $person->name($author->name);
                $person->email($author->email);
                $person->uri($author->url);
                $atom->author($person);
            }

            #if (my $cat = $entry->category) {
            #    require XML::Atom::Category;
            #    my $category = XML::Atom::Category->new(Version => 1.0);
            #    $category->term($cat->label);
            #    $atom->category($category);
            #}
        }
        $atom->content($msg);
    }

    $msg;
}

package MT::Log::Comment;

@MT::Log::Comment::ISA = qw(MT::Log);

sub class_description {
    "Comments";
}

sub format {
    my $log = shift;
    my $style = shift;

    my $id = int($log->metadata);
    require MT::Comment;
    require MT::Blog;
    my $cmt = MT::Comment->load($id);
    my $blog = MT::Blog->load($cmt->blog_id) if $cmt;
    my $msg;
    if ($cmt && $blog) {
        require MT::Util;
        my $txt = defined $cmt->text ? $cmt->text : '';
        $txt = MT::Util::munge_comment($txt, $blog);
        my $convert_breaks = $blog->convert_paras_comments;
        $txt = $convert_breaks ?
            MT->apply_text_filters($txt, $blog->comment_text_filters) :
            $txt;
        require MT::Sanitize;
        $txt = MT::Sanitize->sanitize($txt);
        if ($cmt->is_junk) {
            $txt .= "<p><strong>" . MT->translate("Junk Log (Score: [_1])", $cmt->junk_score) . "</strong></p>";
            $txt .= "<pre>" . $cmt->junk_log . "</pre>";
        }
        $msg = $txt;
    } else {
        $msg = MT->translate("Comment # [_1] not found.", $id);
    }

    if (defined $style && ($style eq 'atom')) {
        my $atom = shift;
        if ($cmt) {
            my $e = MT::Entry->load($cmt->entry_id);
            if ($e) {
                require XML::Atom::Link;
                my $link = XML::Atom::Link->new(Version => 1.0);
                $link->type('text/html');
                $link->rel('alternate');
                $link->href($e->permalink . '#c' . $cmt->id);
                $atom->add_link($link);
            }
            require XML::Atom::Person;
            my $person = XML::Atom::Person->new(Version => 1.0);
            $person->name($cmt->author) if ($cmt->author||'') ne '';
            $person->email($cmt->email) if ($cmt->email||'') ne '';
            $person->uri($cmt->url) if ($cmt->url||'') ne '';
            $atom->author($person);
        }
        $atom->content($msg);
    }
    $msg;
}

package MT::Log::Ping;

@MT::Log::Ping::ISA = qw(MT::Log);

sub class_description {
    "TrackBacks";
}

sub format {
    my $log = shift;
    my $style = shift;

    require MT::TBPing;
    my $id = int($log->metadata);
    my $ping = MT::TBPing->load($id);
    my $msg;
    if ($ping) {
        require MT::Sanitize;
        my $txt = MT::Util::html_text_transform(MT::Sanitize->sanitize($ping->excerpt || ''));
        if ($ping->is_junk) {
            $txt .= "<p><strong>" . MT->translate("Junk Log (Score: [_1])", $ping->junk_score ) . "</strong></p>";
            $txt .= "<pre>" . $ping->junk_log . "</pre>";
        }
        $msg = $txt;
    } else {
        $msg = MT->translate("TrackBack # [_1] not found.", $id);
    }
    if (defined $style && ($style eq 'atom')) {
        my $atom = shift;
        if ($ping) {
            require MT::Trackback;
            my $tb = MT::Trackback->load($ping->tb_id);
            if ($tb->entry_id) {
                my $e = MT::Entry->load($tb->entry_id);
                if ($e) {
                    require XML::Atom::Link;
                    my $link = XML::Atom::Link->new(Version => 1.0);
                    $link->type('text/html');
                    $link->rel('alternate');
                    $link->href($e->permalink . '#p' . $ping->id);
                    $atom->add_link($link);
                }
            }
            require XML::Atom::Person;
            my $person = XML::Atom::Person->new(Version => 1.0);
            $person->name($ping->blog_name) if ($ping->blog_name||'') ne '';
            $person->uri($ping->source_url) if ($ping->source_url||'') ne '';
            $atom->author($person);
        }
        $atom->content($msg);
    }
    $msg;
}

1;
__END__

=head1 NAME

MT::Log - Movable Type activity log record

=head1 SYNOPSIS

    use MT::Log;
    my $log = MT::Log->new;
    $log->message('This is a message in the activity log.');
    $log->save
        or die $log->errstr;

=head1 DESCRIPTION

An I<MT::Log> object represents a record in the Movable Type activity log.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Log> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 DATA ACCESS METHODS

The I<MT::Log> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the log record.

=item * message

The log entry.

=item * ip

The IP address related with the message; this is useful, for example, when
the message pertains to a failed login, to determine the IP address of the
user who attempted to log in.

=item * created_on

The timestamp denoting when the log record was created, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=item * modified_on

The timestamp denoting when the log record was last modified, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * created_on

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
