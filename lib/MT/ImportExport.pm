# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ImportExport;
use strict;

use Symbol;
use MT::Entry;
use MT::Placement;
use MT::Category;
use base qw( MT::ErrorHandler );
use MT::I18N qw( first_n_text const encode_text );

use vars qw( $SEP $SUB_SEP );
$SEP = ('-' x 8);
$SUB_SEP = ('-' x 5);

sub do_import {
    shift->import_contents(@_);
}

sub import_contents {
    my $class = shift;
    my %param = @_;
    my $iter = $param{Iter};
    my $blog = $param{Blog} or return __PACKAGE__->error(MT->translate("No Blog"));
    my $cb = $param{Callback} || sub { };
    my $encoding = $param{Encoding};

    require MT::Permission;
    require MT::I18N;
    require MT::Tag;

    ## Determine the author as whom we will import the entries.
    my($author, $pass, $parent_author);
    if ($author = $param{ImportAs}) {
#        $cb->("Importing entries as user '", $author->name, "'\n");
    } elsif ($parent_author = $param{ParentAuthor}) {
        require MT::Auth;
        $pass = $param{NewAuthorPassword}
            or return __PACKAGE__->error(MT->translate(
                "You need to provide a password if you are going to " .
                "create new users for each user listed in your blog."))
               if (MT::Auth->password_exists);
    } else {
        return __PACKAGE__->error(MT->translate(
            "Need either ImportAs or ParentAuthor"));
    }
    $cb->("\n");

    my $def_cat_id = $param{DefaultCategoryID};
    my $t_start = $param{title_start};
    my $t_end = $param{title_end};
    my $allow_comments = $blog->allow_comments_default;
    my $allow_pings = $blog->allow_pings_default ? 1 : 0;
    my $convert_breaks = $param{ConvertBreaks};
    $convert_breaks = $blog->convert_paras if $convert_breaks == -1;
    my $def_status = $param{default_status} || $blog->status_default;
    my(%authors, %categories);

    my $blog_id = $blog->id;
    my $author_id = $author->id if $author;

    #-------------

#   $cb->(MT->translate("Importing entries from file '[_1]'", $f) ."\n");
# open FH, $file
#     or return $class->error(MT->translate(
#         "Can't open file '[_1]': [_2]", $file, "$!"));
 
    my $import_result = eval {
        my(%authors, %categories);

        my $entry_excerpt_len = MT::I18N::const('LENGTH_ENTRY_TITLE_FROM_TEXT');

        while (my $stream = $iter->()) {
            my $result = eval {
                local $/ = "\n$SEP\n";
                my $guessed_encoding;
                ENTRY_BLOCK:
                while (<$stream>) {
                    if ($encoding) {
                        if ($encoding eq 'guess') {
                            $guessed_encoding = MT::I18N::guess_encoding($_);
                        } else {
                            $guessed_encoding = $encoding;
                        }
                        $_ = MT::I18N::encode_text($_, $guessed_encoding, undef);
                    }
                    my($meta, @pieces) = split /^$SUB_SEP$/m;
                    next unless $meta && @pieces;

                    ## Create entry object and assign some defaults.
                    my $entry = MT::Entry->new;
                    $entry->blog_id($blog_id);
                    $entry->status($def_status);
                    $entry->allow_comments($allow_comments);
                    $entry->allow_pings($allow_pings);
                    $entry->convert_breaks($convert_breaks);
                    $entry->author_id($author_id) if $author;

                    ## Some users may want to import just their GM comments, having
                    ## already imported their GM entries. We try to match up the
                    ## entries using the created on timestamp, and the import file
                    ## tells us not to import an entry with the meta-tag "NO ENTRY".
                    my $no_save = 0;

                    ## Handle all meta-data: author, category, title, date.
                    my $i = -1;
                    my($primary_cat_id, @placements);
                    my @lines = split /\r?\n/, $meta;
                    META:
                    for my $line (@lines) {
                        $i++;
                        next unless $line;
                        $line =~ s!^\s*!!;
                        $line =~ s!\s*$!!;
                        my($key, $val) = split /\s*:\s*/, $line, 2;
                        if (($key eq 'AUTHOR') && $parent_author) {
                            unless ($author = $authors{$val}) {
                                $author = MT::Author->load({ name => $val });
                            }
                            unless ($author) {
                                $author = MT::Author->new;
                                $author->created_by($parent_author->id);
                                $author->name($val);
                                $author->email('');
                                $author->type(MT::Author::AUTHOR);
                                $author->auth_type(MT->config->AuthenticationModule);
                                if ($pass) {
                                    $author->set_password($pass);
                                } else {
                                    $author->password('(none)');
                                }
                                $cb->(MT->translate("Creating new user ('[_1]')...", $val));
                                if ($author->save) {
                                    $cb->(MT->translate("ok") . "\n");
                                } else {
                                    $cb->(MT->translate("failed") . "\n");
                                    return __PACKAGE__->error(MT->translate(
                                        "Saving user failed: [_1]", $author->errstr));
                                }
                                $authors{$val} = $author;
                                $cb->(MT->translate("Assigning permissions for new user..."));
                                my $perms = MT::Permission->new;
                                $perms->blog_id($blog_id);
                                $perms->author_id($author->id);
                                $perms->can_create_post(1);
                                if ($perms->save) {
                                    $cb->(MT->translate("ok") . "\n");
                                } else {
                                    $cb->(MT->translate("failed") . "\n");
                                    return __PACKAGE__->error(MT->translate(
                                     "Saving permission failed: [_1]", $perms->errstr));
                                }
                            }
                            $author_id = $author->id;
                            $entry->author_id($author->id);
                        } elsif ($key eq 'CATEGORY' || $key eq 'PRIMARY CATEGORY') {
                            if ($val) {
                                my $cat;
                                unless ($cat = $categories{$val}) {
                                    $cat = MT::Category->load({ label => $val,
                                                                blog_id => $blog_id });
                                }
                                unless ($cat) {
                                    $cat = MT::Category->new;
                                    $cat->blog_id($blog_id);
                                    $cat->label($val);
                                    $cat->author_id($entry->author_id);
                                    $cat->parent(0);
                                    $cb->(MT->translate("Creating new category ('[_1]')...", $val));
                                    if ($cat->save) {
                                        $cb->(MT->translate("ok") . "\n");
                                    } else {
                                        $cb->(MT->translate("failed") . "\n");
                                        return __PACKAGE__->error(MT->translate(
                                         "Saving category failed: [_1]", $cat->errstr));
                                    }
                                    $categories{$val} = $cat;
                                }
                                if ($key eq 'CATEGORY') {
                                    push @placements, $cat->id;
                                } else {
                                    $primary_cat_id = $cat->id;
                                }
                            }
                        } elsif ($key eq 'TITLE') {
                            $entry->title($val);
                        } elsif ($key eq 'BASENAME') {
                            $entry->basename($val);
                        } elsif ($key eq 'DATE') {
                            my $date = __PACKAGE__->_convert_date($val) or return;
                            $entry->authored_on($date);
                        } elsif ($key eq 'STATUS') {
                            my $status = MT::Entry::status_int($val)
                                or return __PACKAGE__->error(MT->translate(
                                    "Invalid status value '[_1]'", $val));
                            $entry->status($status);
                        } elsif ($key eq 'TAGS') {
                            if ($val) {
                                $entry->tags(MT::Tag->split(',', $val));
                            }
                        } elsif ($key eq 'ALLOW COMMENTS') {
                            $val = 0 unless $val;
                            $entry->allow_comments($val);
                        } elsif ($key eq 'CONVERT BREAKS') {
                            $val = 0 unless $val;
                            $entry->convert_breaks($val);
                        } elsif ($key eq 'ALLOW PINGS') {
                            $val = 0 unless $val;
                            return __PACKAGE__->error(MT->translate("Invalid allow pings value '[_1]'", $val))
                                unless $val eq 0 || $val eq 1;
                            $entry->allow_pings($val);
                        } elsif ($key eq 'NO ENTRY') {
                            $no_save++;
                        } elsif ($key eq 'START BODY') {
                            ## Special case for backwards-compatibility with old
                            ## export files: if we see START BODY: on a line, we
                            ## gather up the rest of the lines in meta and package
                            ## them for handling below in the non-meta area.
                            @pieces = ("BODY:\n" . join "\n", @lines[$i+1..$#lines]);
                            last META;
                        }
                    }

                    ## If we're not saving this entry (but rather just using it to
                    ## import comments, for example), we need to load the relevant
                    ## entry using the timestamp.
                    if ($no_save) {
                        my $ts = $entry->created_on;
                        $entry = MT::Entry->load({ created_on => $ts,
                            blog_id => $blog_id });
                        if (!$entry) {
                            $cb->(MT->translate("Can't find existing entry with timestamp '[_1]'... skipping comments, and moving on to next entry.", $ts) . "\n");
                            next ENTRY_BLOCK;
                        } else {
                            $cb->(MT->translate("Importing into existing entry [_1] ('[_2]')", $entry->id, $entry->title) . "\n");
                        }
                    }

                    ## Deal with non-meta pieces: entry body, extended entry body,
                    ## comments. We need to hold the list of comments until after
                    ## we have saved the entry, then assign the new entry ID of
                    ## the entry to each comment.
                    my(@comments, @pings);
                    for my $piece (@pieces) {
                        $piece =~ s!^\s*!!;
                        $piece =~ s!\s*$!!;
                        if ($piece =~ s/^BODY:\r?\n//) {
                            $entry->text($piece);
                        }
                        elsif ($piece =~ s/^EXTENDED BODY:\r?\n//) {
                            $entry->text_more($piece);
                        }
                        elsif ($piece =~ s/^EXCERPT:\r?\n//) {
                            $entry->excerpt($piece) if $piece =~ /\S/;
                        }
                        elsif ($piece =~ s/^KEYWORDS:\r?\n//) {
                            $entry->keywords($piece) if $piece =~ /\S/;
                        }
                        elsif ($piece =~ s/^COMMENT:\r?\n//) {
                            ## Comments are: AUTHOR, EMAIL, URL, IP, DATE (in any order),
                            ## then body
                            my $comment = MT::Comment->new
                                or die("Couldn't construct MT::Comment " . 
                                       MT::Comment->errstr);
                            $comment->blog_id($blog_id);
                            $comment->approve;
                            my @lines = split /\r?\n/, $piece;
                            my($i, $body_idx) = (0) x 2;
                            COMMENT:
                            for my $line (@lines) {
                                $line =~ s!^\s*!!;
                                my($key, $val) = split /\s*:\s*/, $line, 2;
                                if ($key eq 'AUTHOR') {
                                    $comment->author($val);
                                } elsif ($key eq 'EMAIL') {
                                    $comment->email($val);
                                } elsif ($key eq 'URL') {
                                    $comment->url($val);
                                } elsif ($key eq 'IP') {
                                    $comment->ip($val);
                                } elsif ($key eq 'DATE') {
                                    my $date = __PACKAGE__->_convert_date($val) or next;
                                    $comment->created_on($date);
                                } else {
                                    ## Now we have reached the body of the comment;
                                    ## everything from here until the end of the
                                    ## array is body.
                                    $body_idx = $i;
                                    last COMMENT;
                                }
                                $i++;
                            }
                            $comment->text( join "\n", @lines[$body_idx..$#lines] );
                            push @comments, $comment;
                        }
                        elsif ($piece =~ s/^PING:\r?\n//) {
                            ## Pings are: TITLE, URL, IP, DATE, BLOG NAME,
                            ## then excerpt
                            require MT::TBPing;
                            my $ping = MT::TBPing->new;
                            $ping->blog_id($blog_id);
                            my @lines = split /\r?\n/, $piece;
                            my($i, $body_idx) = (0) x 2;
                            PING:
                            for my $line (@lines) {
                                $line =~ s!^\s*!!;
                                my($key, $val) = split /\s*:\s*/, $line, 2;
                                if ($key eq 'TITLE') {
                                    $ping->title($val);
                                } elsif ($key eq 'URL') {
                                    $ping->source_url($val);
                                } elsif ($key eq 'IP') {
                                    $ping->ip($val);
                                } elsif ($key eq 'DATE') {
                                    if (my $date = __PACKAGE__->_convert_date($val)) {
                                        $ping->created_on($date);
                                    }
                                } elsif ($key eq 'BLOG NAME') {
                                    $ping->blog_name($val);
                                } else {
                                    ## Now we have reached the ping excerpt;
                                    ## everything from here until the end of the
                                    ## array is body.
                                    $body_idx = $i;
                                    last PING;
                                }
                                $i++;
                            }
                            $ping->excerpt( join "\n", @lines[$body_idx..$#lines] );
                            $ping->approve;
                            push @pings, $ping;
                        }
                    }

                    ## Assign a title if one is not already assigned.
                    if (!defined($entry->title)) {
                        my $body = $entry->text;
                        if ($t_start && $t_end && $body =~
                            s!\Q$t_start\E(.*?)\Q$t_end\E\s*!!s) {
                            (my $title = $1) =~ s/[\r\n]/ /g;
                            $entry->title($title);
                            $entry->text($body);
                        } else {
                            $entry->title( first_n_text($body, $entry_excerpt_len) );
                        }
                    }

                    ## If an entry has comments listed along with it, set
                    ## allow_comments to 1 no matter what the default is.
                    if (@comments && !$entry->allow_comments) {
                        $entry->allow_comments(1);
                    }

                    ## If an entry has TrackBack pings listed along with it,
                    ## set allow_pings to 1 no matter what the default is.
                    if (@pings) {
                        $entry->allow_pings(1);

                        ## If the entry has TrackBack pings, we need to make sure
                        ## that an MT::Trackback object is created. To do that, we
                        ## need to make sure that $entry->save is called.
                        $no_save = 0;
                    }

                    ## Save entry.
                    unless ($no_save) {
                        $cb->(MT->translate("Saving entry ('[_1]')...", $entry->title));
                        if ($entry->save) {
                            $cb->(MT->translate("ok (ID [_1])", $entry->id) . "\n");
                        } else {
                            $cb->(MT->translate("failed") . "\n");
                            return __PACKAGE__->error(MT->translate(
                                "Saving entry failed: [_1]", $entry->errstr));
                        }
                    }

                    ## Save placement.
                    ## If we have no primary category ID (from a PRIMARY CATEGORY
                    ## key), we first look to see if we have any placements from
                    ## CATEGORY tags. If so, we grab the first one and use it as the
                    ## primary placement. If not, we try to use the default category
                    ## ID specified.
                    if (!$primary_cat_id) {
                        if (@placements) {
                            $primary_cat_id = shift @placements;
                        } elsif ($def_cat_id) {
                            $primary_cat_id = $def_cat_id;
                        }
                    } else {
                        ## If a PRIMARY CATEGORY is also specified as a CATEGORY, we
                        ## don't want to add it twice; so we filter it out.
                        @placements = grep { $_ != $primary_cat_id } @placements;
                    }

                    ## So if we have a primary placement from any of the means
                    ## specified above, we add the placement.
                    if ($primary_cat_id) {
                        my $place = MT::Placement->new;
                        $place->is_primary(1);
                        $place->entry_id($entry->id);
                        $place->blog_id($blog_id);
                        $place->category_id($primary_cat_id);
                        $place->save
                            or return __PACKAGE__->error(MT->translate(
                                "Saving placement failed: [_1]", $place->errstr));
                    }

                    ## Now add all of the other, non-primary placements.
                    for my $cat_id (@placements) {
                        my $place = MT::Placement->new;
                        $place->is_primary(0);
                        $place->entry_id($entry->id);
                        $place->blog_id($blog_id);
                        $place->category_id($cat_id);
                        $place->save
                            or return __PACKAGE__->error(MT->translate(
                                "Saving placement failed: [_1]", $place->errstr));
                    }

                    ## Save comments.
                    for my $comment (@comments) {
                        $comment->entry_id($entry->id);
                        $cb->(MT->translate("Creating new comment (from '[_1]')...", $comment->author));
                        if ($comment->save) {
                            $cb->(MT->translate("ok (ID [_1])", $comment->id) . "\n");
                        } else {
                            $cb->(MT->translate("failed") . "\n");
                            return __PACKAGE__->error(MT->translate(
                                "Saving comment failed: [_1]", $comment->errstr));
                        }
                    }

                    ## Save pings.
                    if (@pings) {
                        my $tb = $entry->trackback
                            or return __PACKAGE__->error(MT->translate(
                                "Entry has no MT::Trackback object!"));
                        for my $ping (@pings) {
                            $ping->tb_id($tb->id);
                            $cb->(MT->translate("Creating new ping ('[_1]')...", $ping->title));
                            if ($ping->save) {
                                $cb->(MT->translate("ok (ID [_1])", $ping->id) . "\n");
                            } else {
                                $cb->(MT->translate("failed") . "\n");
                                return __PACKAGE__->error(MT->translate(
                                    "Saving ping failed: [_1]", $ping->errstr));
                            }
                        }
                    }
                }
                1;
            };
            return unless $result;
        }

        __PACKAGE__->errstr ? undef : 1;

    }; # end try block

    $import_result;
}

sub export {
    my $class = shift;
    my($blog, $cb) = @_;
    $cb ||= sub { };

    ## Make sure dates are in English.
    $blog->language('en');

    ## Create template for exporting a single entry
    require MT::Template;
    require MT::Template::Context;
    my $tmpl = MT::Template->new;
    $tmpl->name('Export Template');
    $tmpl->text(<<'TEXT');
AUTHOR: <$MTEntryAuthor strip_linefeeds="1"$>
TITLE: <$MTEntryTitle strip_linefeeds="1"$>
BASENAME: <$MTEntryBasename$>
STATUS: <$MTEntryStatus strip_linefeeds="1"$>
ALLOW COMMENTS: <$MTEntryFlag flag="allow_comments"$>
CONVERT BREAKS: <$MTEntryFlag flag="convert_breaks"$>
ALLOW PINGS: <$MTEntryFlag flag="allow_pings"$><MTIfNonEmpty tag="MTEntryCategory">
PRIMARY CATEGORY: <$MTEntryCategory$></MTIfNonEmpty><MTEntryCategories>
CATEGORY: <$MTCategoryLabel$></MTEntryCategories>
DATE: <$MTEntryDate format="%m/%d/%Y %I:%M:%S %p"$><MTEntryIfTagged>
TAGS: <MTEntryTags include_private="1" glue=","><$MTTagName quote="1"$></MTEntryTags></MTEntryIfTagged>
-----
BODY:
<$MTEntryBody convert_breaks="0"$>
-----
EXTENDED BODY:
<$MTEntryMore convert_breaks="0"$>
-----
EXCERPT:
<$MTEntryExcerpt no_generate="1" convert_breaks="0"$>
-----
KEYWORDS:
<$MTEntryKeywords$>
-----
<MTComments>
COMMENT:
AUTHOR: <$MTCommentAuthor strip_linefeeds="1"$>
EMAIL: <$MTCommentEmail strip_linefeeds="1"$>
IP: <$MTCommentIP strip_linefeeds="1"$>
URL: <$MTCommentURL strip_linefeeds="1"$>
DATE: <$MTCommentDate format="%m/%d/%Y %I:%M:%S %p"$>
<$MTCommentBody convert_breaks="0"$>
-----
</MTComments>
<MTPings>
PING:
TITLE: <$MTPingTitle strip_linefeeds="1"$>
URL: <$MTPingURL strip_linefeeds="1"$>
IP: <$MTPingIP strip_linefeeds="1"$>
BLOG NAME: <$MTPingBlogName strip_linefeeds="1"$>
DATE: <$MTPingDate format="%m/%d/%Y %I:%M:%S %p"$>
<$MTPingExcerpt$>
-----
</MTPings>
--------
TEXT

    my $iter = MT::Entry->load_iter({ blog_id => $blog->id },
        { 'sort' => 'created_on', direction => 'ascend' });

    while (my $entry = $iter->()) {
        my $ctx = MT::Template::Context->new;
        $ctx->stash('entry', $entry);
        $ctx->stash('blog', $blog);
        $ctx->stash('blog_id', $blog->id);
        $tmpl->blog_id($blog->id);
        $ctx->{current_timestamp} = $entry->created_on;
        my $res = $tmpl->build($ctx)
            or return $class->error(MT->translate(
                "Export failed on entry '[_1]': [_2]", $entry->title,
                $tmpl->errstr));
        $cb->($res);
    }
    1;
}

sub _convert_date {
    my $class = shift;
    my($date) = @_;
    my($mo, $d, $y, $h, $m, $s, $ampm) = $date =~
        m!^\s*(\d{1,2})/(\d{1,2})/(\d{2,4}) (\d{1,2}):(\d{1,2}):(\d{1,2})(?:\s(\w{2}))?\s*$!
        or return $class->error(MT->translate(
            "Invalid date format '[_1]'; must be " .
            "'MM/DD/YYYY HH:MM:SS AM|PM' (AM|PM is optional)", $date));
    if ($ampm) {
        if ($ampm eq 'PM' && $h < 12) {
            $h += 12;
        } elsif ($ampm eq 'AM' && $h == 12) {
            $h = 0;
        }
    }
    if (length($y) == 2) {
        $y += 1900;
    }
    sprintf "%04d%02d%02d%02d%02d%02d", $y, $mo, $d, $h, $m, $s;
}

1;
__END__

=head1 NAME

MT::ImportExport

=head1 METHODS

=head2 import_contents(%param)

This complex method imports a blog by... TODO

=head2 do_import(%param)

Adapter method for the old importer to adapt to the new MT::Import style pluggable importer.

=head2 export($blog[, $callback])

Export the I<blog> as a template named "Export Template", with an
optional I<callback>.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
