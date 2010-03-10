# Movable Type (r) Open Source (C) 2001-2010 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::Template::Tags::Archive;

use strict;

use MT;
use MT::Util qw( archive_file_for );
use MT::Promise qw( delay );

###########################################################################

=head2 Archives

A container tag representing a list of all the enabled archive types in
a blog. This tag exists to facilitate the publication of a Google sitemap
or something of a similar nature.

B<Attributes:>

=over 4

=item * type or archive_type (optional)

Specify a comma-delimited list of archive types to loop over. If you
only wish to publish a list of Individual and Category archives, you
can specify:

    <mt:ArchiveList type="Individual,Category">

=back

B<Example:>

    <mt:Archives>
        <mt:ArchiveList><mt:ArchiveLink>
        </mt:ArchiveList>
    </mt:Archives>

This will publish a link for each archive type you publish (the primary
archive links, at least).

=cut

sub _hdlr_archive_set {
    my($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $at = $args->{type} || $args->{archive_type} || $blog->archive_type;
    return '' if !$at || $at eq 'None';
    my @at = split /,/, $at;
    my $res = '';
    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $old_at = $blog->archive_type_preferred();
    foreach my $type (@at) {
        $blog->archive_type_preferred($type);
        local $ctx->{current_archive_type} = $type;
        defined(my $out = $builder->build($ctx, $tokens, $cond)) or
            return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $blog->archive_type_preferred($old_at);
    $res;
}

###########################################################################

=head2 ArchiveList

A container tag representing a list of all the archive pages of a
certain type.

B<Attributes:>

=over 4

=item * type or archive_type

An optional attribute that specifies the type of archives to list.
Recognized values are "Yearly", "Monthly", "Weekly", "Daily",
"Individual", "Author", "Author-Yearly", "Author-Monthly",
"Author-Weekly", "Author-Daily", "Category", "Category-Yearly",
"Category-Monthly", "Category-Weekly" and "Category-Daily" (and perhaps
others, if custom archive types are provided through third-party
plugins). The default is to list the Preferred Archive Type specified
in the blog settings.

=item * lastn (optional)

An optional attribute that can be used to limit the number of archives
in the list.

=item * sort_order (optional; default "descend")

An optional attribute that specifies the sort order of the archives
in the list. It is effective within any of the date-based and
"Individual or Page" archive types. Recognized values are "ascend" and
"descend".

=back

B<NOTE:> You may produce an archive list of any supported archive type
even if you are not publishing that archive type. However, the
L<ArchiveLink> tag will only work for archive types you are
publishing.

B<Example:>

    <mt:ArchiveList archive_type="Monthly">
        <a href="<$mt:ArchiveLink$>"><$mt:ArchiveTitle$></a>
    </mt:ArchiveList>

Here, we're combining two L<ArchiveList> tags (the inner L<ArchiveList>
tag is bound to the date range of the year in context):

    <mt:ArchiveList type="Yearly" sort_order="ascend">
        <mt:ArchiveListHeader>
        <ul>
        </mt:ArchiveListHeader>
            <li><$mt:ArchiveDate format="%Y"$>
        <mt:ArchiveList type="Monthly" sort_order="ascend">
            <mt:ArchiveListHeader>
                <ul>
            </mt:ArchiveListHeader>
                    <li><$mt:ArchiveDate format="%b"$></li>
            <mt:ArchiveListFooter>
                </ul>
            </mt:ArchiveListFooter>
            </li>
        </mt:ArchiveList>
        <mt:ArchiveListFooter>
        </ul>
        </mt:ArchiveListFooter>
    </mt:ArchiveList>

to publish something like this:

    <ul>
        <li>2006
            <ul>
                <li>Mar</li>
                <li>Apr</li>
                <li>May</li>
            </ul>
        </li>
        <li>2007
            <ul>
                <li>Apr</li>
                <li>Jun</li>
                <li>Dec</li>
            </ul>
        </li>
    </ul>

=cut

sub _hdlr_archives {
    my($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $at = $blog->archive_type;
    return '' if !$at || $at eq 'None';
    my $arg_at;
    if ($arg_at = $args->{type} || $args->{archive_type}) {
        $at = $arg_at;
    } elsif ($blog->archive_type_preferred) {
        $at = $blog->archive_type_preferred;
    } else {
        $at = (split /,/, $at)[0];
    }

    my $archiver = MT->publisher->archiver($at);
    return '' unless $archiver;

    my $save_stamps;
    if (!$ctx->{inside_archive_list} || $ctx->{current_archive_type} && $arg_at && ($ctx->{current_archive_type} eq $arg_at)) {
        $save_stamps = 1;
    }

    local $ctx->{current_archive_type} = $at;
    ## If we are producing a Category archive list, don't bother to
    ## handle it here--instead hand it over to <MTCategories>.
    return $ctx->invoke_handler( 'categories', $args, $cond ) if $at eq 'Category';
    my %args;
    my $sort_order = lc ($args->{sort_order} || '') eq 'ascend' ? 'ascend' : 'descend';
    $args{'sort'} = 'authored_on';
    $args{direction} = $sort_order;

    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $res = '';
    my $i = 0;
    my $n = $args->{lastn};

    my $save_ts;
    my $save_tse;
    my $tmpl = $ctx->stash('template');

    if ( ($tmpl && $tmpl->type eq 'archive')
         && $archiver->date_based)
    {
        my $uncompiled = $ctx->stash('uncompiled') || '';
        if ($uncompiled =~ /<mt:?archivelist>?/i) {
            $save_stamps = 1;
        }
    }

    if ($save_stamps) {
        $save_ts = $ctx->{current_timestamp};
        $save_tse = $ctx->{current_timestamp_end};
        $ctx->{current_timestamp} = undef;
        $ctx->{current_timestamp_end} = undef;
    }

    my $order = $sort_order eq 'ascend' ? 'asc' : 'desc';
    my $group_iter = $archiver->archive_group_iter($ctx, $args);
    return $ctx->error(MT->translate("Group iterator failed."))
        unless defined($group_iter);

    my ($cnt, %curr) = $group_iter->();
    my %save = map { $_ => $ctx->{__stash}{$_} } keys %curr;
    my $vars = $ctx->{__stash}{vars} ||= {};
    while (defined($cnt)) {
        $i++;
        my ($next_cnt, %next) = $group_iter->();
        my $last;
        $last = 1 if $n && ($i >= $n);
        $last = 1 unless defined $next_cnt;

        my ($start, $end);
        if ($archiver->date_based) {
            ($start, $end) = ($curr{'start'}, $curr{'end'});
        } else {
            my $entry = $curr{entries}->[0] if exists($curr{entries});
            ($start, $end) = (ref $entry ? $entry->authored_on : "");
        }
        local $ctx->{current_timestamp} = $start;
        local $ctx->{current_timestamp_end} = $end;
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = $last;
        local $vars->{__even__} = $i % 2 == 0;
        local $vars->{__odd__} = $i % 2 == 1;
        local $vars->{__counter__} = $i;
        local $ctx->{__stash}{archive_count} = $cnt;
        local $ctx->{__stash}{entries} = delay(sub{ 
            $archiver->archive_group_entries($ctx, %curr)
        }) if $archiver->group_based;
        $ctx->{__stash}{$_} = $curr{$_} for keys %curr;
        local $ctx->{inside_archive_list} = 1;

        defined(my $out = $builder->build($ctx, $tokens, { %$cond,
            ArchiveListHeader => $i == 1, ArchiveListFooter => $last }))
            or return $ctx->error( $builder->errstr );
        $res .= $out;
        last if $last;
        ($cnt, %curr) = ($next_cnt, %next);
    }

    $ctx->{__stash}{$_} = $save{$_} for keys %save;
    $ctx->{current_timestamp} = $save_ts if $save_ts;
    $ctx->{current_timestamp_end} = $save_tse if $save_tse;
    $res;
}

###########################################################################

=head2 ArchiveListHeader

The contents of this container tag will be displayed when the first
entry listed by a L<ArchiveList> tag is reached.

=for tags archives

=cut

###########################################################################

=head2 ArchiveListFooter

The contents of this container tag will be displayed when the last
entry listed by a L<ArchiveList> tag is reached.

=for tags archives

=cut

###########################################################################

=head2 ArchivePrevious

A container tag that creates a context to the "previous" archive
relative to the current archive context.

This tag also works with the else tag to produce content if there is no
"previous" archive.

B<Attributes:>

=over 4

=item * type or archive_type (optional)

Specifies the "previous" archive type the context is for. See
the L<ArchiveList> tag for supported values for this attribute.

=back

B<Example:>

    <mt:ArchivePrevious>
      <a href="<$mt:ArchiveLink$>"
        title="<$mt:ArchiveTitle escape="html"$>">Next</a>
    <mt:Else>
       <!-- output when no previous archive is available -->
    </mt:ArchivePrevious>

=for tags archives

=cut

###########################################################################

=head2 ArchiveNext

A container tag that creates a context to the "next" archive relative to
the current archive context.

This tag also works with the else tag to produce content if there is no
"next" archive.

B<Attributes:>

=over 4

=item * type or archive_type (optional)

Specifies the "next" archive type the context is for. See the L<ArchiveList>
tag for supported values for this attribute.

=back

B<Example:>

    <mt:ArchiveNext>
      <a href="<$mt:ArchiveLink$>"
        title="<$mt:ArchiveTitle escape="html"$>">Next</a>
    <mt:Else>
       <!-- output when no next archive is available -->
    </mt:ArchiveNext>

=for tags archives

=cut

## Archives
sub _hdlr_archive_prev_next {
    my($ctx, $args, $cond) = @_;
    my $tag = lc $ctx->stash('tag');
    my $is_prev = $tag eq 'archiveprevious';
    my $res = '';
    my $at = ($args->{type} || $args->{archive_type}) || $ctx->{current_archive_type} || $ctx->{archive_type};
    my $arctype = MT->publisher->archiver($at);
    return '' unless $arctype;

    my $entry;
    if ($arctype->date_based && $arctype->category_based) {
        my $param = {
            ts       => $ctx->{current_timestamp},
            blog_id  => $ctx->stash('blog_id'),
            category => $ctx->stash('archive_category'),
        };
        $entry = $is_prev ? $arctype->previous_archive_entry($param) : $arctype->next_archive_entry($param);
    } elsif ($arctype->date_based && $arctype->author_based) {
        my $param = {
            ts       => $ctx->{current_timestamp},
            blog_id  => $ctx->stash('blog_id'),
            author   => $ctx->stash('author'),
        };
        $entry = $is_prev ? $arctype->previous_archive_entry($param) : $arctype->next_archive_entry($param);
    } elsif ($arctype->category_based) {
        return $is_prev ? $ctx->invoke_handler( 'categoryprevious', $args, $cond )
                        : $ctx->invoke_handler( 'categorynext',     $args, $cond );
    } elsif ($arctype->author_based) {
        if ($is_prev) {
            $ctx->stash('tag', 'AuthorPrevious');
        } else {
            $ctx->stash('tag', 'AuthorNext');
        }
        require MT::Template::Tags::Author;
        return MT::Template::Tags::Author::_hdlr_author_next_prev(@_);
    } elsif ($arctype->entry_based) {
        my $e = $ctx->stash('entry');
        if ($is_prev) {
            $entry = $e->previous(1);
        } else {
            $entry = $e->next(1);
        }
    } else {
        my $ts = $ctx->{current_timestamp}
            or return $ctx->error(MT->translate(
               "You used an [_1] tag without a date context set up.", "MT$tag" ));
        return $ctx->error(MT->translate(
            "[_1] can be used only with Daily, Weekly, or Monthly archives.",
            "<MT$tag>" ))
            unless $arctype->date_based;
        my $param = {
            ts => $ctx->{current_timestamp},
            blog_id => $ctx->stash('blog_id'),
        };
        $entry = $is_prev ? $arctype->previous_archive_entry($param) : $arctype->next_archive_entry($param);
    }
    if ($entry) {
        my $builder = $ctx->stash('builder');
        local $ctx->{__stash}->{entries} = [ $entry ];
        if (my($start, $end) = $arctype->date_range($entry->authored_on)) {
            local $ctx->{current_timestamp} = $start;
            local $ctx->{current_timestamp_end} = $end;
            defined(my $out = $builder->build($ctx, $ctx->stash('tokens'),
                $cond))
                or return $ctx->error( $builder->errstr );
            $res .= $out;
        } else {
            local $ctx->{current_timestamp} = $entry->authored_on;
            local $ctx->{current_timestamp_end} = $entry->authored_on;
            defined(my $out = $builder->build($ctx, $ctx->stash('tokens'),
                $cond))
                or return $ctx->error( $builder->errstr );
            $res .= $out;
        }
    }
    $res;
}

###########################################################################

=head2 IfArchiveType

This tag allows you to conditionalize a section of template code based on
whether the primary template being published is a specific type of archive
template.

B<Attributes:>

=over 4

=item * type

=item * archive_type

The archive type to test for, case-insensitively. See L<ArchiveType> for
acceptable values but note that plugins may also provide others.

=back

If you wanted to include autodiscovery code for a customized Atom feed for
each individual entry (perhaps for tracking comments) you could put this in
your Header module. This would serve up the first link for Individual
archives and the normal feed for all other templates:

    <mt:IfArchiveType type="individual">
        <link rel="alternate" type="application/atom+xml"
            title="Comments Feed"
            href="<$MTFileTemplate format="%y/%m/%-F.xml"$>" />
    <mt:Else>
        <link rel="alternate" type="application/atom+xml"
            title="Recent Entries"
            href="<$MTLink template="feed_recent"$>" />
    </mt:IfArchiveType>

=for tags archives

=cut

sub _hdlr_if_archive_type {
    my ($ctx, $args, $cond) = @_;
    my $cat = $ctx->{current_archive_type} || $ctx->{archive_type} || '';
    my $at = $args->{type} || $args->{archive_type} || '';
    return 0 unless $at && $cat;
    return lc $at eq lc $cat;
}

###########################################################################

=head2 IfArchiveTypeEnabled

A conditional tag used to test whether a specific archive type is
published or not.

B<Attributes:>

=over 4

=item * type or archive_type

Specifies the name of the archive type you wish to check to see if it is enabled.

A list of possible values values for type can be found on the L<ArchiveType>
tag.

=back

B<Example:>

    <mt:IfArchiveTypeEnabled type="Category-Monthly">
        <!-- do something -->
    <mt:Else>
        <!-- do something else -->
    </mt:IfArchiveTypeEnabled>

=for tags archives

=cut

sub _hdlr_archive_type_enabled {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    my $at = ($args->{type} || $args->{archive_type});
    return $blog->has_archive_type($at);
}

###########################################################################

=head2 IndexList

A block tag that builds a list of all available index templates, sorting
them by name.

=cut

sub _hdlr_index_list {
    my ($ctx, $args, $cond) = @_;
    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $iter = MT::Template->load_iter({ type => 'index',
                                         blog_id => $ctx->stash('blog_id') },
                                       { 'sort' => 'name' });
    my $res = '';
    while (my $tmpl = $iter->()) {
        local $ctx->{__stash}{'index'} = $tmpl;
        defined(my $out = $builder->build($ctx, $tokens, $cond)) or
            return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 ArchiveLink

Publishes a link to the archive template for the current archive context.
You may specify an alternate archive type with the "type" attribute to
publish a different archive link.

B<Attributes:>

=over 4

=item * type (optional)

=item * archive_type (optional)

Identifies the specific archive type to generate a link for. If unspecified,
uses the current archive type in context, when publishing an archive
template.

=item * with_index (optional; default "0")

If specified, forces any index filename to be included in the link to
the archive page.

=back

B<Example:>

When publishing an entry archive template, you can use the
following tag to get a link to the appropriate Monthly archive template
relevant to that entry (in other words, if the entry was published in March
2008, the archive link tag would output a permalink for the March 2008
archives).

    <$MTArchiveLink type="Monthly"$>

=cut

sub _hdlr_archive_link {
    my($ctx, $args) = @_;
    my $at = $args->{type}
          || $args->{archive_type}
          || $ctx->{current_archive_type}
          || $ctx->{archive_type};
    return $ctx->invoke_handler('categoryarchivelink', $args)
        if ($at && ('Category' eq $at)) ||
           ($ctx->{current_archive_type} && 'Category' eq $ctx->{current_archive_type});

    my $archiver = MT->publisher->archiver($at);
    return '' unless $archiver;

    my $blog = $ctx->stash('blog');
    my $entry;
    if ($archiver->entry_based) {
        $entry = $ctx->stash('entry');
    }
    my $author = $ctx->stash('author');

    #return $ctx->error(MT->translate(
    #    "You used an [_1] tag outside of the proper context.",
    #    '<$MTArchiveLink$>' ))
    #    unless $ctx->{current_timestamp} || $entry;

    my $cat;
    if ($archiver->category_based) {
        $cat = $ctx->stash('category') || $ctx->stash('archive_category');
    }

    return $ctx->error(MT->translate(
        "You used an [_1] tag for linking into '[_2]' archives, but that archive type is not published.", '<$MTArchiveLink$>', $at))
        unless $blog->has_archive_type($at);

    my $arch = $blog->archive_url;
    $arch = $blog->site_url if $entry && $entry->class eq 'page';
    $arch .= '/' unless $arch =~ m!/$!;
    $arch .= archive_file_for($entry, $blog, $at, $cat, undef,
                              $ctx->{current_timestamp}, $author);
    $arch = MT::Util::strip_index($arch, $blog) unless $args->{with_index};
    return $arch;
}

###########################################################################

=head2 ArchiveTitle

A descriptive title of the current archive. The value returned from this
tag will vary based on the archive type:

=over 4

=item * Category

The label of the category. Note that any HTML tags present in the label
will be removed.

=item * Daily

The date in "Month, Day YYYY" form.

=item * Weekly

The range of dates in the week in "Month, Day YYYY - Month, Day YYYY"

=item * Monthly

The range of dates in the week in "Month YYYY" form.

=item * Individual

The title of the entry. Note that any HTML tags present in the label will
be removed.

= item * Author

The display name of the author. Note that any HTML tags present in the
display name will be removed.

=back

B<Example:>

    <$mt:ArchiveTitle$>

=for tags archives

=cut

sub _hdlr_archive_title {
    my($ctx, $args) = @_;

    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};

    my $archiver = MT->publisher->archiver($at);
    my @entries;
    if ($archiver->entry_based) {
        my $entries = $ctx->stash('entries');
        if (!$entries && (my $e = $ctx->stash('entry'))) {
            push @$entries, $e;
        }
        if ($entries && ref($entries) eq 'ARRAY' && $at) {
            @entries = @$entries;
        } else {
            my $blog = $ctx->stash('blog');
            if (!@entries) {
                ## This situation arises every once in awhile. We have
                ## a date-based archive page, but no entries to go on it--this
                ## might happen, for example, if you have daily archives, and
                ## you post an entry, and then you change the status to draft.
                ## The page will be rebuilt in order to empty it, but in the
                ## process, there won't be any entries in $entries. So, we
                ## build a stub MT::Entry object and set the created_on date
                ## to the current timestamp (start of day/week/month).

                ## But, it's not generally true that draft-izing an entry
                ## erases all of its manifestations. The individual 
                ## archive lingers, for example. --ez
                if ($at && $archiver->date_based()) {
                    my $e = MT::Entry->new;
                    $e->authored_on($ctx->{current_timestamp});
                    @entries = ($e);
                } else {
                    return $ctx->error(MT->translate(
                        "You used an [_1] tag outside of the proper context.",
                        '<$MTArchiveTitle$>' ));
                }
            }
        }
    }
    my $title = (@entries && $entries[0]) ? $archiver->archive_title($ctx, $entries[0])
        : $archiver->archive_title($ctx, $ctx->{current_timestamp});
    defined $title ? $title : '';
}

###########################################################################

=head2 ArchiveType

Publishes the identifier for the current archive type. Typically, one
of "Daily", "Weekly", "Monthly", "Yearly", "Category", "Individual",
"Page", etc.

=cut

sub _hdlr_archive_type {
    my ($ctx, $args, $cond) = @_;

    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    $at = 'Category' if $ctx->{inside_mt_categories};
    defined $at ? $at : '';
}

###########################################################################

=head2 ArchiveLabel

An alias for the L<ArchiveTypeLabel> tag.

B<Notes:>

Deprecated in favor of the more specific tag: L<ArchiveTypeLabel>

=for tags deprecated

=cut

###########################################################################

=head2 ArchiveTypeLabel

A descriptive label of the current archive type.

The value returned from this tag will vary based on the archive type:

Daily, Weekly, Monthly, Yearly, Author, Author Daily, Author Weekly,
Author Monthly, Author Yearly, Category, Category Daily, Category Weekly,
Category Monthly, Category Yearly

B<Example:>

    <$mt:ArchiveTypeLabel$>

Related Tags: L<ArchiveType>

=for tags archives

=cut

sub _hdlr_archive_label {
    my ($ctx, $args, $cond) = @_;

    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    $at = 'Category' if $ctx->{inside_mt_categories};
    return q() unless defined $at;
    my $archiver = MT->publisher->archiver($at);
    my $al = $archiver->archive_label;
    if ( 'CODE' eq ref($al) ) {
        $al = $al->();
    }
    return $al;
}

###########################################################################

=head2 ArchiveCount

This tag will potentially return two different values depending upon the
context in which it is invoked.

If invoked within L<Categories> this tag will behave as if it was an alias
to L<CategoryCount>.

Otherwise it will return the number corresponding to the number of entries
currently in context. For example within any L<Entries> context, this tag
will return the number of entries that that L<Entries> tag corresponds to.

B<Example:>

    <mt:Categories>
        There are <$mt:ArchiveCount$> entries in the <$mt:CategoryLabel$>
        category.
    </mt:Categories>

=for tags count

=cut

sub _hdlr_archive_count {
    my ($ctx, $args, $cond) = @_;
    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    if ($ctx->{inside_mt_categories} && !$archiver->date_based) {
        return $ctx->invoke_handler('categorycount', $args, $cond);
    } elsif (my $count = $ctx->stash('archive_count')) {
        return $ctx->count_format($count, $args);
    }

    my $e = $ctx->stash('entries');
    my @entries = @$e if ref($e) eq 'ARRAY';
    my $count = scalar @entries;
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 ArchiveDate

The starting date of the archive in context. For use with the Monthly, Weekly,
and Daily archive types only. Date format tags may be applied with the format
attribute along with the language attribute. See L<Date> for attributes
that are supported.

=for tags date, archives

=cut

###########################################################################

=head2 ArchiveDateEnd

The ending date of the archive in context. For use with the Monthly, Weekly,
and Daily archive types only. Date format tags may be applied with the format
attribute along with the language attribute. See L<Date> tag for supported
attributes.

B<Attributes:>

=over 4

=item * format (optional)

A string that provides the format in which to publish the date. If
unspecified, the default that is appropriate for the language of the blog
is used (for English, this is "%B %e, %Y %l:%M %p"). See the L<Date>
tag for the supported formats.

=item * language (optional; defaults to blog language)

Forces the date to the format associated with the specified language.

=item * utc (optional; default "0")

Forces the date to UTC time zone.

=item * relative (optional; default "0")

Produces a relative date (relative to current date and time). Suitable for
dynamic publishing (for instance, from PHP or search result templates). If
a relative date cannot be produced (the archive date is sufficiently old),
the 'format' attribute will govern the output of the date.

=back

B<Example:>

    <$mt:ArchiveDateEnd$>

=for tags date

=cut

sub _hdlr_archive_date_end {
    my ($ctx, $args) = @_;
    my $end = $ctx->{current_timestamp_end}
        or return $ctx->error(MT->translate(
            "[_1] can be used only with Daily, Weekly, or Monthly archives.",
            '<$MTArchiveDateEnd$>' ));
    $args->{ts} = $end;
    return $ctx->build_date($args);
}

###########################################################################

=head2 ArchiveFile

The archive filename including file extension for the archive in context. This
can be controlled through the archive mapping section of the blog's Publishing
settings screen.

B<Example:> For the URL http://www.example.com/categories/politics.html, the
L<ArchiveFile> tag would output "politics.html".

B<Attributes:>

=over 4

=item * extension

set to '0' to exclude the file extension (ie, produce "politics" instead of
"politics.html")

=item * separator

set to '-' to force any underscore characters in the filename to dashes

=back

B<Example:>

    <$mt:ArchiveFile$>

=cut

sub _hdlr_archive_file {
    my ($ctx, $args, $cond) = @_;

    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    $at = 'Category' if $ctx->{inside_mt_categories};
    my $archiver = MT->publisher->archiver($at);
    my $f;
    if (!$at || ($archiver->entry_based)) {
        my $e = $ctx->stash('entry');
        return $ctx->error(MT->translate("Could not determine entry")) if !$e;
        $f = $e->basename;
    } else {
        $f = $ctx->stash('_basename') || $ctx->{config}->IndexBasename;
    }
    if (exists $args->{extension} && !$args->{extension}) {
    } else {
        my $blog = $ctx->stash('blog');
        if (my $ext = $blog->file_extension) {
            $f .= '.' . $ext;
        }
    }
    if ($args->{separator}) {
        if ($args->{separator} eq '-') {
            $f =~ s/_/-/g;
        }
    }
    $f;
}

###########################################################################

=head2 IndexLink

Outputs the URL for the current index template in context. Used in
an L<IndexList> tag.

B<Attributes:>

=over 4

=item * with_index (optional; default "0")

If enabled, will retain the "index.html" (or similar index filename)
in the link.

=back

=cut

sub _hdlr_index_link {
    my ($ctx, $args, $cond) = @_;
    my $idx = $ctx->stash('index');
    return '' unless $idx;
    my $blog = $ctx->stash('blog');
    my $path = $blog->site_url;
    $path .= '/' unless $path =~ m!/$!;
    $path .= $idx->outfile;
    $path = MT::Util::strip_index($path, $blog) unless $args->{with_index};
    $path;
}

###########################################################################

=head2 IndexName

Outputs the name for the current index template in context. Used in
an L<IndexList> tag.

=cut

sub _hdlr_index_name {
    my ($ctx, $args, $cond) = @_;
    my $idx = $ctx->stash('index');
    return '' unless $idx;
    $idx->name || '';
}

1;
