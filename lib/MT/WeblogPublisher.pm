# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::WeblogPublisher;

use strict;
use base qw( MT::ErrorHandler Exporter );
our @EXPORT = qw(ArchiveFileTemplate ArchiveType);

use MT::ArchiveType;
use File::Basename;

our %ArchiveTypes;

sub ArchiveFileTemplate {
    my %param = @_;
    \%param;
}

sub ArchiveType {
    new MT::ArchiveType(@_);
}

sub new {
    my $class = shift;
    my $this  = {@_};
    my $cfg   = MT->config;
    if ( !exists $this->{start_time} ) {
        $this->{start_time} = time;
    }
    if ( !exists $this->{NoTempFiles} ) {
        $this->{NoTempFiles} = $cfg->NoTempFiles;
    }
    if ( !exists $this->{PublishCommenterIcon} ) {
        $this->{PublishCommenterIcon} = $cfg->PublishCommenterIcon;
    }
    bless $this, $class;
    $this->init();
    $this;
}

sub init_archive_types {
    my $types = MT->registry("archive_types") || {};
    my $mt = MT->instance;
    while ( my ( $type, $typedata ) = each %$types ) {
        if ( 'HASH' eq ref $typedata ) {
            $typedata = MT::ArchiveType->new(%$typedata);
        }
        $ArchiveTypes{$type} = $typedata;
    }
}

sub archive_types {
    init_archive_types() unless %ArchiveTypes;
    keys %ArchiveTypes;
}

sub archiver {
    my $mt = shift;
    my ($at) = @_;
    init_archive_types() unless %ArchiveTypes;
    my $archiver = $at ? $ArchiveTypes{$at} : undef;
    if ( $archiver && !ref($archiver) ) {

        # A package name-- load package and instantiate Archiver object
        if ( $archiver =~ m/::/ ) {
            eval("require $archiver; 1;");
            die "Invalid archive type package '$archiver': $@"
                if $@;    # fatal error here
            my $inst = $archiver->new();
            $archiver = $ArchiveTypes{$at} = $inst;
        }
    }
    return $archiver;
}

sub init {
    init_archive_types() unless %ArchiveTypes;
}

sub core_archive_types {
    return {
        'Yearly'           => 'MT::ArchiveType::Yearly',
        'Monthly'          => 'MT::ArchiveType::Monthly',
        'Weekly'           => 'MT::ArchiveType::Weekly',
        'Individual'       => 'MT::ArchiveType::Individual',
        'Page'             => 'MT::ArchiveType::Page',
        'Daily'            => 'MT::ArchiveType::Daily',
        'Category'         => 'MT::ArchiveType::Category',
        'Author'           => 'MT::ArchiveType::Author',
        'Author-Yearly'    => 'MT::ArchiveType::AuthorYearly',
        'Author-Monthly'   => 'MT::ArchiveType::AuthorMonthly',
        'Author-Weekly'    => 'MT::ArchiveType::AuthorWeekly',
        'Author-Daily'     => 'MT::ArchiveType::AuthorDaily',
        'Category-Yearly'  => 'MT::ArchiveType::CategoryYearly',
        'Category-Monthly' => 'MT::ArchiveType::CategoryMonthly',
        'Category-Daily'   => 'MT::ArchiveType::CategoryDaily',
        'Category-Weekly'  => 'MT::ArchiveType::CategoryWeekly',
    };

}

sub start_time {
    my $pub = shift;
    $pub->{start_time} = shift if @_;
    return $pub->{start_time};
}

sub rebuild {
    my $mt    = shift;
    my %param = @_;
    my $blog;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $param{BlogID};
        $blog = MT::Blog->load($blog_id)
            or return $mt->error(
            MT->translate(
                "Loading of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
            );
    }
    return 1 if $blog->is_dynamic;
    my $at = $blog->archive_type || '';
    my @at = split /,/, $at;
    my $entry_class;
    if ( my $set_at = $param{ArchiveType} ) {
        my %at = map { $_ => 1 } @at;
        return $mt->error(
            MT->translate(
                "Archive type '[_1]' is not a chosen archive type", $set_at
            )
        ) unless $at{$set_at};

        @at = ($set_at);
        my $archiver = $mt->archiver($set_at);
        $entry_class = $archiver->entry_class || "entry";
    }
    else {
        $entry_class = '*';
    }

    if (   $param{ArchiveType}
        && ( !$param{Entry} )
        && ( $param{ArchiveType} eq 'Category' ) )
    {

        # Pass to full category rebuild
        return $mt->rebuild_categories(%param);
    }

    if (   $param{ArchiveType}
        && ( !$param{Author} )
        && ( $param{ArchiveType} eq 'Author' ) )
    {
        return $mt->rebuild_authors(%param);
    }

    if (@at) {
        require MT::Entry;
        my %arg = ( 'sort' => 'authored_on', direction => 'descend' );
        $arg{offset} = $param{Offset} if $param{Offset};
        $arg{limit}  = $param{Limit}  if $param{Limit};
        my $pre_iter = MT::Entry->load_iter(
            {   blog_id => $blog->id,
                class   => $entry_class,
                status  => MT::Entry::RELEASE()
            },
            \%arg
        );
        my ( $next, $curr );
        my $prev = $pre_iter->();
        my $iter = sub {
            ( $next, $curr ) = ( $curr, $prev );
            if ($curr) {
                $prev = $pre_iter->();
            }
            $curr;
        };
        my $cb  = $param{EntryCallback};
        my $fcb = $param{FilterCallback};
        while ( my $entry = $iter->() ) {
            if ($cb) {
                $cb->($entry)
                    or $mt->log(
                    {   message  => $cb->errstr(),
                        category => 'callback',
                    }
                    );
            }
            if ($fcb) {
                $fcb->($entry) or last;
            }
            for my $at (@at) {
                my $archiver = $mt->archiver($at);

                # Skip this archive type if the archive type doesn't
                # match the kind of entry we've loaded
                next unless $archiver;
                next if $entry->class ne $archiver->entry_class;
                if ( $archiver->category_based ) {
                    my $cats = $entry->categories;
                CATEGORY: for my $cat (@$cats) {
                        next CATEGORY
                            if $archiver->category_class ne $cat->class_type;
                        $mt->_rebuild_entry_archive_type(
                            Entry       => $entry,
                            Blog        => $blog,
                            Category    => $cat,
                            ArchiveType => $at,
                            NoStatic    => $param{NoStatic},
                            Force       => ( $param{Force} ? 1 : 0 ),
                            $param{TemplateMap}
                            ? ( TemplateMap => $param{TemplateMap} )
                            : (),
                            $param{TemplateID}
                            ? ( TemplateID =>
                                    $param{TemplateID} )
                            : (),
                        ) or return;
                    }
                }
                elsif ( $archiver->author_based ) {
                    if ( $entry->author ) {
                        $mt->_rebuild_entry_archive_type(
                            Entry       => $entry,
                            Blog        => $blog,
                            ArchiveType => $at,
                            $param{TemplateMap}
                            ? ( TemplateMap => $param{TemplateMap} )
                            : (),
                            $param{TemplateID}
                            ? ( TemplateID =>
                                    $param{TemplateID} )
                            : (),
                            NoStatic => $param{NoStatic},
                            Force    => ( $param{Force} ? 1 : 0 ),
                            Author   => $entry->author,
                        ) or return;
                    }
                }
                else {
                    $mt->_rebuild_entry_archive_type(
                        Entry       => $entry,
                        Blog        => $blog,
                        ArchiveType => $at,
                        $param{TemplateMap}
                        ? ( TemplateMap => $param{TemplateMap} )
                        : (),
                        $param{TemplateID}
                        ? ( TemplateID =>
                                $param{TemplateID} )
                        : (),
                        NoStatic => $param{NoStatic},
                        Force    => ( $param{Force} ? 1 : 0 ),
                    ) or return;
                }
            }
        }
    }
    unless ( $param{NoIndexes} ) {
        $mt->rebuild_indexes( Blog => $blog, NoStatic => $param{NoStatic}, )
            or return;
    }
    1;
}

sub rebuild_categories {
    my $mt    = shift;
    my %param = @_;
    my $blog;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $param{BlogID};
        $blog = MT::Blog->load($blog_id)
            or return $mt->error(
            MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
            );
    }
    my %arg;
    $arg{'sort'} = 'id';
    $arg{direction} = 'ascend';
    $arg{offset} = $param{Offset} if $param{Offset};
    $arg{limit}  = $param{Limit}  if $param{Limit};
    my $cat_iter = MT::Category->load_iter( { blog_id => $blog->id }, \%arg );
    my $fcb = $param{FilterCallback};

    while ( my $cat = $cat_iter->() ) {
        if ($fcb) {
            $fcb->($cat) or last;
        }
        $mt->_rebuild_entry_archive_type(
            Blog        => $blog,
            Category    => $cat,
            ArchiveType => 'Category',
            $param{TemplateMap}
            ? ( TemplateMap => $param{TemplateMap} )
            : (),
            NoStatic => $param{NoStatic},
            Force    => ( $param{Force} ? 1 : 0 ),
        ) or return;
    }
    1;
}

sub rebuild_authors {
    my $mt    = shift;
    my %param = @_;
    my $blog;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $param{BlogID};
        $blog = MT::Blog->load($blog_id)
            or return $mt->error(
            MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
            );
    }
    my %arg;
    $arg{'sort'} = 'id';
    $arg{direction} = 'ascend';
    $arg{offset} = $param{Offset} if $param{Offset};
    $arg{limit}  = $param{Limit}  if $param{Limit};
    $arg{unique} = 1;
    my %terms;
    $terms{status} = MT::Author::ACTIVE();
    require MT::Entry;
    $arg{join} = MT::Entry->join_on(
        'author_id',
        {   blog_id => $blog->id,
            class   => 'entry',
            status  => MT::Entry::RELEASE()
        },
        { unique => 1 }
    );
    my $auth_iter = MT::Author->load_iter( \%terms, \%arg );
    my $fcb = $param{FilterCallback};

    while ( my $a = $auth_iter->() ) {
        if ($fcb) {
            $fcb->($a) or last;
        }
        $mt->_rebuild_entry_archive_type(
            Blog        => $blog,
            Author      => $a,
            ArchiveType => 'Author',
            $param{TemplateMap}
            ? ( TemplateMap => $param{TemplateMap} )
            : (),
            NoStatic => $param{NoStatic},
            Force    => ( $param{Force} ? 1 : 0 ),
        ) or return;
    }
    1;
}

sub remove_fileinfo {
    my $mt    = shift;
    my %param = @_;
    my $at    = $param{ArchiveType}
        or return $mt->error(
        MT->translate( "Parameter '[_1]' is required", 'ArchiveType' ) );
    my $blog_id = $param{Blog}
        or return $mt->error(
        MT->translate( "Parameter '[_1]' is required", 'Blog' ) );
    my $entry_id = $param{Entry}, my $author_id = $param{Author};
    my $start    = $param{StartDate};
    my $cat_id   = $param{Category};

    require MT::FileInfo;
    my @finfo = MT::FileInfo->load(
        {   archive_type => $at,
            blog_id      => $blog_id,
            ( $entry_id ? ( entry_id    => $entry_id ) : () ),
            ( $cat_id   ? ( category_id => $cat_id )   : () ),
            ( $start    ? ( startdate   => $start )    : () ),
        }
    );

    for my $f (@finfo) {
        $f->remove;
    }
    1;
}

# rebuild_deleted_entry
#
# $mt->rebuild_deleted_entry(
#                    Entry => $entry | $entry_id,
#                    Blog => [ $blog | $blog_id ],
#                    );
sub rebuild_deleted_entry {
    my $mt    = shift;
    my $app   = MT->instance;
    my %param = @_;
    my $entry = $param{Entry}
        or return $mt->error(
        MT->translate( "Parameter '[_1]' is required", 'Entry' ) );
    require MT::Entry;
    $entry = MT::Entry->load($entry) unless ref $entry;
    return unless $entry;

    my $blog;
    unless ( $blog = $param{Blog} ) {
        require MT::Blog;
        my $blog_id = $entry->blog_id;
        $blog = MT::Blog->load($blog_id)
            or return $mt->error(
            MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
            );
    }

    my %rebuild_recipe;
    my $at = $blog->archive_type;
    my @at;
    if ( $at && $at ne 'None' ) {
        my @at_orig = split( /,/, $at );
        @at = grep { $_ ne 'Individual' && $_ ne 'Page' } @at_orig;
    }

    # Remove Individual archive file.
    if ( $app->config('DeleteFilesAtRebuild') ) {
        $mt->remove_entry_archive_file( Entry => $entry, );
    }

    # Remove Individual fileinfo records.
    $mt->remove_fileinfo(
        ArchiveType => 'Individual',
        Blog        => $blog->id,
        Entry       => $entry->id
    );

    require MT::Util;
    for my $at (@at) {
        my $archiver = $mt->archiver($at);
        next unless $archiver;

        my ( $start, $end ) = $archiver->date_range( $entry->authored_on )
            if $archiver->date_based() && $archiver->can('date_range');

        # Remove archive file if archive file has not entries.
        if ( $archiver->category_based() ) {
            my $categories = $entry->categories();
            for my $cat (@$categories) {
                if (( $archiver->can('archive_entries_count') )
                    && ($archiver->archive_entries_count( $blog, $at, $entry,
                            $cat ) == 1
                    )
                    )
                {
                    $mt->remove_fileinfo(
                        ArchiveType => $at,
                        Blog        => $blog->id,
                        Category    => $cat->id,
                        (   $archiver->date_based()
                            ? ( startdate => $start )
                            : ()
                        ),
                    );
                    if ( $app->config('DeleteFilesAtRebuild') ) {
                        $mt->remove_entry_archive_file(
                            Entry       => $entry,
                            ArchiveType => $at,
                            Category    => $cat,
                        );
                    }
                }
                else {
                    if ( $app->config('RebuildAtDelete') ) {
                        if ( $archiver->date_based() ) {
                            $rebuild_recipe{$at}{ $cat->id }{ $start . $end }
                                {'Start'} = $start;
                            $rebuild_recipe{$at}{ $cat->id }{ $start . $end }
                                {'End'} = $end;
                            $rebuild_recipe{$at}{ $cat->id }{ $start . $end }
                                {'Timestamp'} = $entry->authored_on;
                        }
                        else {
                            $rebuild_recipe{$at}{ $cat->id }{id} = $cat->id;
                        }
                    }
                }
            }
        }
        else {
            if (( $archiver->can('archive_entries_count') )
                && ( $archiver->archive_entries_count( $blog, $at, $entry )
                    == 1 )
                )
            {

                # Remove archives fileinfo records.
                $mt->remove_fileinfo(
                    ArchiveType => $at,
                    Blog        => $blog->id,
                    (   $archiver->author_based()
                            && $entry->author_id
                        ? ( author_id => $entry->author_id )
                        : ()
                    ),
                    (   $archiver->date_based() ? ( startdate => $start ) : ()
                    ),
                );
                if ( $app->config('DeleteFilesAtRebuild') ) {
                    $mt->remove_entry_archive_file(
                        Entry       => $entry,
                        ArchiveType => $at
                    );
                }
            }
            else {
                if ( $app->config('RebuildAtDelete') ) {
                    if ( $archiver->author_based() && $entry->author_id ) {
                        if ( $archiver->date_based() ) {
                            $rebuild_recipe{$at}{ $entry->author->id }
                                { $start . $end }{'Start'} = $start;
                            $rebuild_recipe{$at}{ $entry->author->id }
                                { $start . $end }{'End'} = $end;
                            $rebuild_recipe{$at}{ $entry->author->id }
                                { $start . $end }{'Timestamp'}
                                = $entry->authored_on;
                        }
                        else {
                            $rebuild_recipe{$at}{ $entry->author->id }{id}
                                = $entry->author->id;
                        }
                    }
                    elsif ( $archiver->date_based() ) {
                        $rebuild_recipe{$at}{ $start . $end }{'Start'}
                            = $start;
                        $rebuild_recipe{$at}{ $start . $end }{'End'} = $end;
                        $rebuild_recipe{$at}{ $start . $end }{'Timestamp'}
                            = $entry->authored_on;
                    }
                    if ( my $prev = $entry->previous(1) ) {
                        $rebuild_recipe{Individual}{ $prev->id }{id}
                            = $prev->id;
                    }
                    if ( my $next = $entry->next(1) ) {
                        $rebuild_recipe{Individual}{ $next->id }{id}
                            = $next->id;
                    }
                }
            }
        }
    }

    return %rebuild_recipe;
}

#   rebuild_entry
#
# $mt->rebuild_entry(Entry => $entry_id,
#                    Blog => [ $blog | $blog_id ],
#                    [ BuildDependencies => (0 | 1), ]
#                    [ OldPrevious => $old_previous_entry_id,
#                      OldNext => $old_next_entry_id, ]
#                    [ NoStatic => (0 | 1), ]
#                    );
sub rebuild_entry {
    my $mt    = shift;
    my %param = @_;
    my $entry = $param{Entry}
        or return $mt->error(
        MT->translate( "Parameter '[_1]' is required", 'Entry' ) );
    require MT::Entry;
    $entry = MT::Entry->load($entry) unless ref $entry;
    return unless $entry;
    my $blog;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $entry->blog_id;
        $blog = MT::Blog->load($blog_id)
            or return $mt->error(
            MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
            );
    }
    return 1 if $blog->is_dynamic;

    my $categories_for_rebuild;
    if ( my $ids = $param{OldCategories} ) {
        my %new_ids = map { $_->id => 1 } @{$entry->categories};
        my @old_ids = grep { !$new_ids{$_} } split( ',', $ids );

        if (@old_ids) {
            push( @$categories_for_rebuild,
                MT::Category->load( { id => \@old_ids } ) );
        }
        push @$categories_for_rebuild, ( map { $_ } @{$entry->categories} );
    }

    my $at
        = $param{PreferredArchiveOnly} ? $blog->archive_type_preferred
        : $entry->is_entry             ? $blog->archive_type
        :                                'Page';
    if ( $at && $at ne 'None' ) {
        my @at = split /,/, $at;
        for my $at (@at) {
            my $archiver = $mt->archiver($at);
            next unless $archiver;    # invalid archive type
            next if $entry->class ne $archiver->entry_class;
            if ( $archiver->category_based ) {
                for my $cat (@$categories_for_rebuild) {
                    $mt->_rebuild_entry_archive_type(
                        Entry       => $entry,
                        Blog        => $blog,
                        ArchiveType => $at,
                        Category    => $cat,
                        NoStatic    => $param{NoStatic},

                        # Force       => ($param{Force} ? 1 : 0),
                        $param{TemplateMap}
                        ? ( TemplateMap => $param{TemplateMap} )
                        : (),
                    ) or return;
                }
            }
            else {
                $mt->_rebuild_entry_archive_type(
                    Entry       => $entry,
                    Blog        => $blog,
                    ArchiveType => $at,
                    $param{TemplateMap}
                    ? ( TemplateMap => $param{TemplateMap} )
                    : (),
                    NoStatic => $param{NoStatic},
                    Force    => ( $param{Force} ? 1 : 0 ),
                    Author   => $entry->author,
                ) or return;
            }
        }
    }

    ## The above will just rebuild the archive pages for this particular
    ## entry. If we want to rebuild all of the entries/archives/indexes
    ## on which this entry could be featured etc., however, we need to
    ## rebuild all of the entry's dependencies. Note that all of these
    ## are not *necessarily* dependencies, depending on the usage of tags,
    ## etc. There is not a good way to determine exact dependencies; it is
    ## easier to just rebuild, rebuild, rebuild.

    return 1
        unless $param{BuildDependencies}
            || $param{BuildIndexes}
            || $param{BuildArchives};

    if ( $param{BuildDependencies} ) {
        ## Rebuild previous and next entry archive pages.
        if ( my $prev = $entry->previous(1) ) {
            $mt->rebuild_entry( Entry => $prev, PreferredArchiveOnly => 1 )
                or return;
            ## Rebuild the old previous and next entries, if we have some.
            if (   $param{OldPrevious}
                && ( $param{OldPrevious} != $prev->id )
                && ( my $old_prev = MT::Entry->load( $param{OldPrevious} ) ) )
            {
                $mt->rebuild_entry(
                    Entry                => $old_prev,
                    PreferredArchiveOnly => 1
                ) or return;
            }
        }
        if ( my $next = $entry->next(1) ) {
            $mt->rebuild_entry( Entry => $next, PreferredArchiveOnly => 1 )
                or return;

            if (   $param{OldNext}
                && ( $param{OldNext} != $next->id )
                && ( my $old_next = MT::Entry->load( $param{OldNext} ) ) )
            {
                $mt->rebuild_entry(
                    Entry                => $old_next,
                    PreferredArchiveOnly => 1
                ) or return;
            }
        }
    }

    if ( $param{BuildDependencies} || $param{BuildIndexes} ) {
        ## Rebuild all indexes, in case this entry is on an index.
        if ( !( exists $param{BuildIndexes} ) || $param{BuildIndexes} ) {
            $mt->rebuild_indexes( Blog => $blog ) or return;
        }
    }

    if ( $param{BuildDependencies} || $param{BuildArchives} ) {
        ## Rebuild previous and next daily, weekly, and monthly archives;
        ## adding a new entry could cause changes to the intra-archive
        ## navigation.
        my %at = map { $_ => 1 } split /,/, $blog->archive_type;
        my @db_at = grep {
            my $archiver = $mt->archiver($_);
            $archiver && $archiver->date_based
        } $mt->archive_types;
        for my $at (@db_at) {
            if ( $at{$at} ) {
                my $archiver = $mt->archiver($at);
                if ( $archiver->category_based ) {
                    for my $cat (@$categories_for_rebuild) {
                        if (my $prev_arch = $archiver->previous_archive_entry(
                                {   entry    => $entry,
                                    category => $cat,
                                }
                            )
                            )
                        {
                            $mt->_rebuild_entry_archive_type(
                                NoStatic => $param{NoStatic},

                                # Force    => ($param{Force} ? 1 : 0),
                                Entry    => $prev_arch,
                                Blog     => $blog,
                                Category => $cat,
                                $param{TemplateMap}
                                ? ( TemplateMap => $param{TemplateMap} )
                                : (),
                                ArchiveType => $at
                            ) or return;
                        }
                        if (my $next_arch = $archiver->next_archive_entry(
                                {   entry    => $entry,
                                    category => $cat,
                                }
                            )
                            )
                        {
                            $mt->_rebuild_entry_archive_type(
                                NoStatic => $param{NoStatic},

                                # Force    => ($param{Force} ? 1 : 0),
                                Entry    => $next_arch,
                                Blog     => $blog,
                                Category => $cat,
                                $param{TemplateMap}
                                ? ( TemplateMap => $param{TemplateMap} )
                                : (),
                                ArchiveType => $at
                            ) or return;
                        }
                    }
                }
                else {
                    if (my $prev_arch = $archiver->previous_archive_entry(
                            {   entry => $entry,
                                $archiver->author_based
                                ? ( author => $entry->author )
                                : (),
                            }
                        )
                        )
                    {
                        $mt->_rebuild_entry_archive_type(
                            NoStatic => $param{NoStatic},

                            # Force       => ($param{Force} ? 1 : 0),
                            Entry       => $prev_arch,
                            Blog        => $blog,
                            ArchiveType => $at,
                            $param{TemplateMap}
                            ? ( TemplateMap => $param{TemplateMap} )
                            : (),
                            $archiver->author_based
                            ? ( Author => $entry->author )
                            : (),
                        ) or return;
                    }
                    if (my $next_arch = $archiver->next_archive_entry(
                            {   entry => $entry,
                                $archiver->author_based
                                ? ( author => $entry->author )
                                : (),
                            }
                        )
                        )
                    {
                        $mt->_rebuild_entry_archive_type(
                            NoStatic => $param{NoStatic},

                            # Force       => ($param{Force} ? 1 : 0),
                            Entry       => $next_arch,
                            Blog        => $blog,
                            ArchiveType => $at,
                            $param{TemplateMap}
                            ? ( TemplateMap => $param{TemplateMap} )
                            : (),
                            $archiver->author_based
                            ? ( Author => $entry->author )
                            : (),
                        ) or return;
                    }
                }
            }
        }
    }

    1;
}

### Recipe hash
### {ArchiveType} - {Category-id} - {Date key} - {Start}
###                                            - {End}
###                                            - {Timestamp}
###               - {Author-id}   - {Date key} - {Start}
###                                            - {End}
###                                            - {Timestamp}
###               - {Date key}    - {Start}
###                               - {End}
###                               - {Timestamp}
###               - {entry-id}    - {id}
###
sub rebuild_archives {
    my $mt    = shift;
    my %param = @_;
    my $blog  = $param{Blog}
        or return $mt->error(
        MT->translate( "Parameter '[_1]' is required", 'Blog' ) );
    return 1 if $blog->is_dynamic;

    my $recipe = $param{Recipe}
        or return $mt->error(
        MT->translate( "Parameter '[_1]' is required", 'Recipe' ) );

    for my $at ( keys %$recipe ) {
        my $archiver = $mt->archiver($at);
        next unless $archiver;

        if ( $archiver->category_based() ) {
            require MT::Category;
            for my $cat_id ( keys %{ $recipe->{$at} } ) {
                my $cat = MT::Category->load($cat_id)
                    or next;
                if ( $archiver->date_based() ) {
                    for my $key ( keys %{ $recipe->{$at}->{$cat_id} } ) {
                        $mt->_rebuild_entry_archive_type(
                            NoStatic    => 0,
                            Force       => ( $param{Force} ? 1 : 0 ),
                            Blog        => $blog,
                            Category    => $cat,
                            ArchiveType => $at,
                            Start =>
                                $recipe->{$at}->{$cat_id}->{$key}->{Start},
                            End => $recipe->{$at}->{$cat_id}->{$key}->{End},
                            Timestamp => $recipe->{$at}->{$cat_id}->{$key}
                                ->{Timestamp},
                        ) or return;
                    }
                }
                else {
                    $mt->_rebuild_entry_archive_type(
                        NoStatic    => 0,
                        Force       => ( $param{Force} ? 1 : 0 ),
                        Blog        => $blog,
                        Category    => $cat,
                        ArchiveType => $at,
                    ) or return;
                }
            }
        }
        elsif ( $archiver->author_based() ) {
            require MT::Author;
            for my $auth_id ( keys %{ $recipe->{$at} } ) {
                my $author = MT::Author->load($auth_id)
                    or next;
                if ( $archiver->date_based() ) {
                    for my $key ( keys %{ $recipe->{$at}->{$auth_id} } ) {
                        $mt->_rebuild_entry_archive_type(
                            NoStatic    => 0,
                            Force       => ( $param{Force} ? 1 : 0 ),
                            Blog        => $blog,
                            Author      => $author,
                            ArchiveType => $at,
                            Start =>
                                $recipe->{$at}->{$auth_id}->{$key}->{Start},
                            End => $recipe->{$at}->{$auth_id}->{$key}->{End},
                            Timestamp => $recipe->{$at}->{$auth_id}->{$key}
                                ->{Timestamp},
                        ) or return;
                    }
                }
                else {
                    $mt->_rebuild_entry_archive_type(
                        NoStatic    => 0,
                        Force       => ( $param{Force} ? 1 : 0 ),
                        Blog        => $blog,
                        Author      => $author,
                        ArchiveType => $at,
                    ) or return;
                }
            }
        }
        elsif ( $archiver->date_based() ) {
            for my $key ( keys %{ $recipe->{$at} } ) {
                $mt->_rebuild_entry_archive_type(
                    NoStatic    => 0,
                    Force       => ( $param{Force} ? 1 : 0 ),
                    Blog        => $blog,
                    ArchiveType => $at,
                    Start       => $recipe->{$at}->{$key}->{Start},
                    End         => $recipe->{$at}->{$key}->{End},
                    Timestamp   => $recipe->{$at}->{$key}->{Timestamp},
                ) or return;
            }
        }
        else {
            require MT::Entry;
            for my $entry_id ( keys %{ $recipe->{$at} } ) {
                my $entry = MT::Entry->load($entry_id)
                    or next;
                $mt->_rebuild_entry_archive_type(
                    NoStatic    => 0,
                    Force       => ( $param{Force} ? 1 : 0 ),
                    Entry       => $entry,
                    Blog        => $blog,
                    ArchiveType => $at,
                ) or return;
            }
        }
    }

    1;
}

sub _rebuild_entry_archive_type {
    my $mt    = shift;
    my %param = @_;

    my $at = $param{ArchiveType}
        or return $mt->error(
        MT->translate( "Parameter '[_1]' is required", 'ArchiveType' ) );
    return 1 if $at eq 'None';
    my $entry
        = (    $param{ArchiveType} ne 'Category'
            && $param{ArchiveType} ne 'Author'
            && !exists $param{Start}
            && !exists $param{End} )
        ? (
        $param{Entry}
            or return $mt->error(
            MT->translate( "Parameter '[_1]' is required", 'Entry' )
            )
        )
        : undef;

    my $blog;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $entry->blog_id;
        $blog = MT::Blog->load($blog_id)
            or return $mt->error(
            MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
            );
    }

    ## Load the template-archive-type map entries for this blog and
    ## archive type. We do this before we load the list of entries, because
    ## we will run through the files and check if we even need to rebuild
    ## anything. If there is nothing to rebuild at all for this entry,
    ## we save some time by not loading the list of entries.
    require MT::TemplateMap;
    my @map;
    if ( $param{TemplateMap} ) {
        @map = ( $param{TemplateMap} );
    }
    else {
        my $cached_maps = MT->instance->request('__cached_maps')
            || MT->instance->request( '__cached_maps', {} );
        if ( my $maps = $cached_maps->{ $at . $blog->id } ) {
            @map = @$maps;
        }
        else {
            @map = MT::TemplateMap->load(
                {   archive_type => $at,
                    blog_id      => $blog->id,
                    $param{TemplateID}
                    ? ( template_id => $param{TemplateID} )
                    : ()
                }
            );
            $cached_maps->{ $at . $blog->id } = \@map;
        }
    }
    return 1 unless @map;

    my @map_build;
    my $done = MT->instance->request( '__published:' . $blog->id )
        || MT->instance->request( '__published:' . $blog->id, {} );
    for my $map (@map) {
        my $ts = exists $param{Timestamp} ? $param{Timestamp} : undef;
        my $file
            = exists $param{File}
            ? $param{File}
            : $mt->archive_file_for( $entry, $blog, $at, $param{Category},
            $map, $ts, $param{Author} );
        if ( $file eq '' ) {

            # np
        }
        elsif ( !defined($file) ) {
            return $mt->error( MT->translate( $blog->errstr() ) );
        }
        else {
            push @map_build, $map unless $done->{$file};
            $map->{__saved_output_file} = $file;
        }
    }
    return 1 unless @map_build;
    @map = @map_build;

    $at ||= "";

    my $archiver = $mt->archiver($at);
    return unless $archiver;

    # Special handling for pages-- they are always published to the
    # 'site' path instead of the 'archive' path, which is reserved for blog
    # content.
    my $arch_root
        = ( $at eq 'Page' ) ? $blog->site_path : $blog->archive_path;
    return $mt->error(
        MT->translate("You did not set your blog publishing path") )
        unless $arch_root;

    my ( $start, $end );
    if ( exists $param{Start} && exists $param{End} ) {
        $start = $param{Start};
        $end   = $param{End};
    }
    else {
        if ( $archiver->date_based() && $archiver->can('date_range') ) {
            ( $start, $end ) = $archiver->date_range( $entry->authored_on );
        }
    }

    ## For each mapping, we need to rebuild the entries we loaded above in
    ## the particular template map, and write it to the specified archive
    ## file template.
    require MT::Template;
    require MT::Template::Context;
    require MT::PublishOption;

    my $force = $param{Force};
    for my $map (@map) {
        next unless $map->build_type;    # ignore disabled template maps
        next if $map->build_type == MT::PublishOption::MANUALLY() && !$force;

        my $ctx = MT::Template::Context->new;
        $ctx->{current_archive_type} = $at;
        $ctx->{archive_type}         = $at;
        $mt->rebuild_file(
            $blog, $arch_root, $map, $at, $ctx, \my %cond,
            !$param{NoStatic},
            Category  => $param{Category},
            Entry     => $entry,
            Author    => $param{Author},
            StartDate => $start,
            EndDate   => $end,
            Force     => $param{Force} ? 1 : 0,
        ) or return;
        $done->{ $map->{__saved_output_file} }++;
    }
    1;
}

sub rebuild_file {
    my $mt = shift;
    my ( $blog, $root_path, $map, $at, $ctx, $cond, $build_static, %args )
        = @_;
    my $finfo;
    my $archiver = $mt->archiver($at);
    my ( $entry, $start, $end, $category, $author );

    if ( $finfo = $args{FileInfo} ) {
        $args{Author}   = $finfo->author_id   if $finfo->author_id;
        $args{Category} = $finfo->category_id if $finfo->category_id;
        $args{Entry}    = $finfo->entry_id    if $finfo->entry_id;
        $map ||= MT::TemplateMap->load( $finfo->templatemap_id );
        $at  ||= $finfo->archive_type;
        if ( $finfo->startdate ) {
            if ( ( $start, $end )
                = $archiver->date_range( $finfo->startdate ) )
            {
                $args{StartDate} = $start;
                $args{EndDate}   = $end;
            }
        }
    }

    # Calculate file path and URL for the new entry.
    my $file = File::Spec->catfile( $root_path, $map->{__saved_output_file} );

    ## Untaint. We have to assume that we can trust the user's setting of
    ## the archive_path, and nothing else is based on user input.
    ($file) = $file =~ /(.+)/s;

    # compare file modification time to start of build process. if it
    # is greater than the start_time, then we shouldn't need to build this
    # file again
    my $fmgr = $blog->file_mgr;
    if ( my $mod_time = $fmgr->file_mod_time($file) ) {
        return 1 if $mod_time >= $mt->start_time;
    }

    if ( $archiver->category_based ) {
        $category = $args{Category};
        die "Category archive type requires Category parameter"
            unless $args{Category};
        $category = MT::Category->load($category)
            unless ref $category;
        $ctx->var( 'category_archive', 1 );
        $ctx->{__stash}{archive_category} = $category;
    }
    if ( $archiver->entry_based ) {
        $entry = $args{Entry};
        die "$at archive type requires Entry parameter"
            unless $entry;
        require MT::Entry;
        $entry = MT::Entry->load($entry) if !ref $entry;
        $ctx->var( 'entry_archive', 1 );
        $ctx->{__stash}{entry} = $entry;
    }
    if ( $archiver->date_based ) {

        # Date-based archive type
        $start = $args{StartDate};
        $end   = $args{EndDate};
        Carp::confess("Date-based archive types require StartDate parameter")
            unless $args{StartDate};
        $ctx->var( 'datebased_archive', 1 );
    }
    if ( $archiver->author_based ) {

        # author based archive type
        $author = $args{Author};
        die "Author-based archive type requires Author parameter"
            unless $args{Author};
        require MT::Author;
        $author = MT::Author->load($author)
            unless ref $author;
        $ctx->var( 'author_archive', 1 );
        $ctx->{__stash}{author} = $author;
    }
    local $ctx->{current_timestamp}     = $start if $start;
    local $ctx->{current_timestamp_end} = $end   if $end;

    $ctx->{__stash}{blog}          = $blog;
    $ctx->{__stash}{local_blog_id} = $blog->id;

    require MT::FileInfo;

# This kind of testing should be done at the time we save a post,
# not during publishing!!!
# if ($archiver->entry_based) {
#     my $fcount = MT::FileInfo->count({
#         blog_id => $blog->id,
#         entry_id => $entry->id,
#         file_path => $file},
#         { not => { entry_id => 1 } });
#     die MT->translate('The same archive file exists. You should change the basename or the archive path. ([_1])', $file) if $fcount > 0;
# }

    my $base_url = $blog->archive_url;
    $base_url = $blog->site_url
        if $archiver->entry_based && $archiver->entry_class eq 'page';
    $base_url .= '/' unless $base_url =~ m|/$|;
    my $url = $base_url . $map->{__saved_output_file};
    $url =~ s{(?<!:)//+}{/}g;

    my $tmpl_id = $map->template_id;

    # template specific for this entry (or page, as the case may be)
    if ( $entry && $entry->template_id ) {

        # allow entry to override *if* we're publishing an individual
        # page, and this is the 'preferred' one...
        if ( $archiver->entry_based ) {
            if ( $map->is_preferred ) {
                $tmpl_id = $entry->template_id;
            }
        }
    }

    my $tmpl = MT::Template->load($tmpl_id);
    return 1 if $tmpl->type eq 'backup';
    $tmpl->context($ctx);

    # From Here
    if ( my $tmpl_param = $archiver->template_params ) {
        $tmpl->param($tmpl_param);
    }

    my ($rel_url) = ( $url =~ m|^(?:[^:]*\:\/\/)?[^/]*(.*)| );

    # Clear out all the FileInfo records that might point at the page
    # we're about to create
    # FYI: if it's an individual entry, we don't use the date as a
    #      criterion, since this could actually have changed since
    #      the FileInfo was last built. When the date does change,
    #      the old date-based archive doesn't necessarily get fixed,
    #      but if another comes along it will get corrected
    unless ($finfo) {
        my %terms;
        $terms{blog_id}     = $blog->id;
        $terms{category_id} = $category->id if $archiver->category_based;
        $terms{author_id}   = $author->id if $archiver->author_based;
        $terms{entry_id}    = $entry->id if $archiver->entry_based;
        $terms{startdate}   = $start
            if $archiver->date_based && ( !$archiver->entry_based );
        $terms{archive_type}   = $at;
        $terms{templatemap_id} = $map->id;
        my @finfos = MT::FileInfo->load( \%terms );

        if (   ( scalar @finfos == 1 )
            && ( $finfos[0]->file_path eq $file )
            && ( ( $finfos[0]->url || '' ) eq $rel_url )
            && ( $finfos[0]->template_id == $tmpl_id ) )
        {

            # if the shoe fits, wear it
            $finfo = $finfos[0];
        }
        else {

         # if the shoe don't fit, remove all shoes and create the perfect shoe
            foreach (@finfos) { $_->remove(); }

            $finfo = MT::FileInfo->set_info_for_url(
                $rel_url, $file, $at,
                {   Blog        => $blog->id,
                    TemplateMap => $map->id,
                    Template    => $tmpl_id,
                    ( $archiver->entry_based && $entry )
                    ? ( Entry => $entry->id )
                    : (),
                    StartDate => $start,
                    ( $archiver->category_based && $category )
                    ? ( Category => $category->id )
                    : (),
                    ( $archiver->author_based ) ? ( Author => $author->id )
                    : (),
                }
                )
                || die "Couldn't create FileInfo because "
                . MT::FileInfo->errstr();
        }
    }

    if (!$archiver->does_publish_file(
            {   Blog        => $blog,
                ArchiveType => $at,
                Entry       => $entry,
                Category    => $category,
            }
        )
        )
    {
        $finfo->remove();
        if ( MT->config->DeleteFilesAtRebuild ) {
            $mt->_delete_archive_file(
                Blog        => $blog,
                File        => $finfo->file_path,
                ArchiveType => $at
            );
        }

        return 1;
    }

    # If you rebuild when you've just switched to dynamic pages,
    # we move the file that might be there so that the custom
    # 404 will be triggered.
    require MT::PublishOption;
    if ( $map->build_type == MT::PublishOption::DYNAMIC() ) {
        MT->run_callbacks(
            'build_dynamic',
            Context      => $ctx,
            context      => $ctx,
            ArchiveType  => $at,
            archive_type => $at,
            TemplateMap  => $map,
            template_map => $map,
            Blog         => $blog,
            blog         => $blog,
            Entry        => $entry,
            entry        => $entry,
            FileInfo     => $finfo,
            file_info    => $finfo,
            File         => $file,
            file         => $file,
            Template     => $tmpl,
            template     => $tmpl,
            PeriodStart  => $start,
            period_start => $start,
            Category     => $category,
            category     => $category,
        );

        rename(
            $finfo->file_path,    # is this just $file ?
            $finfo->file_path . '.static'
        );

        ## If the FileInfo is set to static, flip it to virtual.
        if ( !$finfo->virtual ) {
            $finfo->virtual(1);
            $finfo->save();
        }
    }

    return 1 if ( $map->build_type == MT::PublishOption::DYNAMIC() );
    return 1 if ( $entry && $entry->status != MT::Entry::RELEASE() );
    return 1 unless ( $map->build_type );

    my $timer = MT->get_timer;
    if ($timer) {
        $timer->pause_partial;
    }
    local $timer->{elapsed} = 0 if $timer;

    if ($build_static
        && MT->run_callbacks(
            'build_file_filter',
            Context      => $ctx,
            context      => $ctx,
            ArchiveType  => $at,
            archive_type => $at,
            TemplateMap  => $map,
            template_map => $map,
            Blog         => $blog,
            blog         => $blog,
            Entry        => $entry,
            entry        => $entry,
            FileInfo     => $finfo,
            file_info    => $finfo,
            File         => $file,
            file         => $file,
            Template     => $tmpl,
            template     => $tmpl,
            PeriodStart  => $start,
            period_start => $start,
            Category     => $category,
            category     => $category,
            force        => ( $args{Force} ? 1 : 0 ),
        )
        )
    {

        if ( $archiver->group_based ) {
            require MT::Promise;
            my $entries = sub { $archiver->archive_group_entries($ctx) };
            $ctx->stash( 'entries', MT::Promise::delay($entries) );
        }

        my $html = undef;
        $ctx->stash( 'blog', $blog );
        $ctx->stash( 'entry', $entry ) if $entry;
        $ctx->stash( '_basename',
            fileparse( $map->{__saved_output_file}, qr/\.[^.]*/ ) );
        $ctx->stash( 'current_mapping_url', $url );

        if ( !$map->is_preferred ) {
            my $category = $ctx->{__stash}{archive_category};
            my $author   = $ctx->{__stash}{author};
            $ctx->stash(
                'preferred_mapping_url',
                sub {
                    my $file = $mt->archive_file_for( $entry, $blog, $at,
                        $category, undef, $start, $author );
                    my $url = $base_url . $file;
                    $url =~ s{(?<!:)//+}{/}g;
                    $url;
                }
            );
        }

        require MT::Request;
        MT::Request->instance->cache( 'build_template', $tmpl );

        $html = $tmpl->build( $ctx, $cond );
        unless ( defined($html) ) {
            $timer->unpause if $timer;
            return $mt->error(
                (   $category ? MT->translate(
                        "An error occurred publishing [_1] '[_2]': [_3]",
                        lc( $category->class_label ),
                        $category->id,
                        $tmpl->errstr
                        )
                    : $entry ? MT->translate(
                        "An error occurred publishing [_1] '[_2]': [_3]",
                        lc( $entry->class_label ),
                        $entry->title,
                        $tmpl->errstr
                        )
                    : MT->translate(
                        "An error occurred publishing date-based archive '[_1]': [_2]",
                        $at . $start,
                        $tmpl->errstr
                    )
                )
            );
        }

        # Some browsers throw you to quirks mode if the doctype isn't
        # up front and leading whitespace makes a feed invalid.
        $html =~ s/\A\s+(<(?:\?xml|!DOCTYPE))/$1/s;

        my $orig_html = $html;
        MT->run_callbacks(
            'build_page',
            Context      => $ctx,
            context      => $ctx,
            ArchiveType  => $at,
            archive_type => $at,
            TemplateMap  => $map,
            template_map => $map,
            Blog         => $blog,
            blog         => $blog,
            Entry        => $entry,
            entry        => $entry,
            FileInfo     => $finfo,
            file_info    => $finfo,
            PeriodStart  => $start,
            period_start => $start,
            Category     => $category,
            category     => $category,
            RawContent   => \$orig_html,
            raw_content  => \$orig_html,
            Content      => \$html,
            content      => \$html,
            BuildResult  => \$orig_html,
            build_result => \$orig_html,
            Template     => $tmpl,
            template     => $tmpl,
            File         => $file,
            file         => $file
        );
        ## First check whether the content is actually
        ## changed. If not, we won't update the published
        ## file, so as not to modify the mtime.
        unless ( $fmgr->content_is_updated( $file, \$html ) ) {
            $timer->unpause if $timer;
            return 1;
        }

        ## Determine if we need to build directory structure,
        ## and build it if we do. DirUmask determines
        ## directory permissions.
        require File::Spec;
        my $path = dirname($file);
        $path =~ s!/$!!
            unless $path eq '/'; ## OS X doesn't like / at the end in mkdir().
        unless ( $fmgr->exists($path) ) {
            if ( !$fmgr->mkpath($path) ) {
                $timer->unpause if $timer;
                return $mt->trans_error( "Error making path '[_1]': [_2]",
                    $path, $fmgr->errstr );
            }
        }

        ## By default we write all data to temp files, then rename
        ## the temp files to the real files (an atomic
        ## operation). Some users don't like this (requires too
        ## liberal directory permissions). So we have a config
        ## option to turn it off (NoTempFiles).
        my $use_temp_files = !$mt->{NoTempFiles};
        my $temp_file = $use_temp_files ? "$file.new" : $file;
        unless ( defined $fmgr->put_data( $html, $temp_file ) ) {
            $timer->unpause if $timer;
            return $mt->trans_error( "Writing to '[_1]' failed: [_2]",
                $temp_file, $fmgr->errstr );
        }
        if ($use_temp_files) {
            if ( !$fmgr->rename( $temp_file, $file ) ) {
                $timer->unpause if $timer;
                return $mt->trans_error(
                    "Renaming tempfile '[_1]' failed: [_2]",
                    $temp_file, $fmgr->errstr );
            }
        }
        MT->run_callbacks(
            'build_file',
            Context      => $ctx,
            context      => $ctx,
            ArchiveType  => $at,
            archive_type => $at,
            TemplateMap  => $map,
            template_map => $map,
            FileInfo     => $finfo,
            file_info    => $finfo,
            Blog         => $blog,
            blog         => $blog,
            Entry        => $entry,
            entry        => $entry,
            PeriodStart  => $start,
            period_start => $start,
            RawContent   => \$orig_html,
            raw_content  => \$orig_html,
            Content      => \$html,
            content      => \$html,
            BuildResult  => \$orig_html,
            build_result => \$orig_html,
            Template     => $tmpl,
            template     => $tmpl,
            Category     => $category,
            category     => $category,
            File         => $file,
            file         => $file
        );
    }
    $timer->mark( "total:rebuild_file[template_id:" . $tmpl->id . "]" )
        if $timer;
    1;
}

sub rebuild_indexes {
    my $mt    = shift;
    my %param = @_;
    require MT::Template;
    require MT::Template::Context;
    require MT::Entry;

    my $blog;
    $blog = $param{Blog}
        if defined $param{Blog};
    if ( !$blog && defined $param{BlogID} ) {
        my $blog_id = $param{BlogID};
        $blog = MT::Blog->load($blog_id)
            or return $mt->error(
            MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
            );
    }
    my $tmpl = $param{Template};
    if ( $tmpl && ( !$blog || $blog->id != $tmpl->blog_id ) ) {
        $blog = MT::Blog->load( $tmpl->blog_id );
    }

    return $mt->error(
        MT->translate("Blog, BlogID or Template param must be specified.") )
        unless $blog;

    return 1 if $blog->is_dynamic;
    my $iter;
    if ($tmpl) {
        my $i = 0;
        $iter = sub { $i++ < 1 ? $tmpl : undef };
    }
    else {
        $iter = MT::Template->load_iter(
            {   type    => 'index',
                blog_id => $blog->id
            }
        );
    }
    my $force = $param{Force};

    local *FH;
    my $site_root = $blog->site_path;
    return $mt->error(
        MT->translate("You did not set your blog publishing path") )
        unless $site_root;
    my $fmgr = $blog->file_mgr;
    while ( my $tmpl = $iter->() ) {
        ## Skip index templates that the user has designated not to be
        ## rebuilt automatically. We need to do the defined-ness check
        ## because we added the flag in 2.01, and for templates saved
        ## before that time, the rebuild_me flag will be undefined. But
        ## we assume that these templates should be rebuilt, since that
        ## was the previous behavior.
        ## Note that dynamic templates do need to be "rebuilt"--the
        ## FileInfo table needs to be maintained.
        if ( !$tmpl->build_dynamic && !$force ) {
            next if ( defined $tmpl->rebuild_me && !$tmpl->rebuild_me );
        }
        next if ( defined $tmpl->build_type && !$tmpl->build_type );

        my $file = $tmpl->outfile;
        $file = '' unless defined $file;
        if ( $tmpl->build_dynamic && ( $file eq '' ) ) {
            next;
        }
        return $mt->error(
            MT->translate(
                "Template '[_1]' does not have an Output File.",
                $tmpl->name
            )
        ) unless $file ne '';
        my $url = join( '/', $blog->site_url, $file );
        $url =~ s{(?<!:)//+}{/}g;
        unless ( File::Spec->file_name_is_absolute($file) ) {
            $file = File::Spec->catfile( $site_root, $file );
        }

        # Everything from here out is identical with rebuild_file
        my ($rel_url) = ( $url =~ m|^(?:[^:]*\:\/\/)?[^/]*(.*)| );
        ## Untaint. We have to assume that we can trust the user's setting of
        ## the site_path and the template outfile.
        ($file) = $file =~ /(.+)/s;
        my $finfo = $param{FileInfo};    # available for single template calls
        unless ($finfo) {
            require MT::FileInfo;
            my @finfos = MT::FileInfo->load(
                {   blog_id     => $tmpl->blog_id,
                    template_id => $tmpl->id
                }
            );
            if (   ( scalar @finfos == 1 )
                && ( $finfos[0]->file_path eq $file )
                && ( ( $finfos[0]->url || '' ) eq $rel_url ) )
            {
                $finfo = $finfos[0];
            }
            else {
                foreach (@finfos) { $_->remove(); }
                $finfo = MT::FileInfo->set_info_for_url(
                    $rel_url, $file, 'index',
                    {   Blog     => $tmpl->blog_id,
                        Template => $tmpl->id,
                    }
                    )
                    || die "Couldn't create FileInfo because "
                    . MT::FileInfo->errstr;
            }
        }
        my $ctx = MT::Template::Context->new;
        if ( $tmpl->build_dynamic ) {
            MT->run_callbacks(
                'build_dynamic',
                Context      => $ctx,
                context      => $ctx,
                ArchiveType  => 'index',
                archive_type => 'index',
                Blog         => $blog,
                blog         => $blog,
                FileInfo     => $finfo,
                file_info    => $finfo,
                File         => $file,
                file         => $file,
                Template     => $tmpl,
                template     => $tmpl,
            );

            rename( $file, $file . ".static" );

            ## If the FileInfo is set to static, flip it to virtual.
            if ( !$finfo->virtual ) {
                $finfo->virtual(1);
                $finfo->save();
            }
        }

        next if ( $tmpl->build_dynamic );
        next unless ( $tmpl->build_type );
        next if $param{NoStatic};

        ## We're not building dynamically, so if the FileInfo is currently
        ## set as dynamic (virtual), change it to static.
        if ( $finfo && $finfo->virtual ) {
            $finfo->virtual(0);
            $finfo->save();
        }

        my $timer = MT->get_timer;
        if ($timer) {
            $timer->pause_partial;
        }
        local $timer->{elapsed} = 0 if $timer;

        next
            unless (
            MT->run_callbacks(
                'build_file_filter',
                Context      => $ctx,
                context      => $ctx,
                ArchiveType  => 'index',
                archive_type => 'index',
                Blog         => $blog,
                blog         => $blog,
                FileInfo     => $finfo,
                file_info    => $finfo,
                Template     => $tmpl,
                template     => $tmpl,
                File         => $file,
                file         => $file,
                force        => $force,
            )
            );
        $ctx->stash( 'blog',                $blog );
        $ctx->stash( 'current_mapping_url', $url );

        require MT::Request;
        MT::Request->instance->cache( 'build_template', $tmpl );

        my $html = $tmpl->build($ctx);
        unless ( defined $html ) {
            $timer->unpause if $timer;
            return $mt->error( $tmpl->errstr );
        }

        # Some browsers throw you to quirks mode if the doctype isn't
        # up front and leading whitespace makes a feed invalid.
        $html =~ s/\A\s+(<(?:\?xml|!DOCTYPE))/$1/s;

        my $orig_html = $html;
        MT->run_callbacks(
            'build_page',
            Context      => $ctx,
            context      => $ctx,
            Blog         => $blog,
            blog         => $blog,
            FileInfo     => $finfo,
            file_info    => $finfo,
            ArchiveType  => 'index',
            archive_type => 'index',
            RawContent   => \$orig_html,
            raw_content  => \$orig_html,
            Content      => \$html,
            content      => \$html,
            BuildResult  => \$orig_html,
            build_result => \$orig_html,
            Template     => $tmpl,
            template     => $tmpl,
            File         => $file,
            file         => $file
        );

        ## First check whether the content is actually changed. If not,
        ## we won't update the published file, so as not to modify the mtime.
        next unless $fmgr->content_is_updated( $file, \$html );

        ## Determine if we need to build directory structure,
        ## and build it if we do. DirUmask determines
        ## directory permissions.
        require File::Spec;
        my $path = dirname($file);
        $path =~ s!/$!!
            unless $path eq '/'; ## OS X doesn't like / at the end in mkdir().
        unless ( $fmgr->exists($path) ) {
            if ( !$fmgr->mkpath($path) ) {
                $timer->unpause if $timer;
                return $mt->trans_error( "Error making path '[_1]': [_2]",
                    $path, $fmgr->errstr );
            }
        }

        ## Update the published file.
        my $use_temp_files = !$mt->{NoTempFiles};
        my $temp_file = $use_temp_files ? "$file.new" : $file;
        unless ( defined( $fmgr->put_data( $html, $temp_file ) ) ) {
            $timer->unpause if $timer;
            return $mt->trans_error( "Writing to '[_1]' failed: [_2]",
                $temp_file, $fmgr->errstr );
        }
        if ($use_temp_files) {
            if ( !$fmgr->rename( $temp_file, $file ) ) {
                $timer->unpause if $timer;
                return $mt->trans_error(
                    "Renaming tempfile '[_1]' failed: [_2]",
                    $temp_file, $fmgr->errstr );
            }
        }
        MT->run_callbacks(
            'build_file',
            Context      => $ctx,
            context      => $ctx,
            ArchiveType  => 'index',
            archive_type => 'index',
            FileInfo     => $finfo,
            file_info    => $finfo,
            Blog         => $blog,
            blog         => $blog,
            RawContent   => \$orig_html,
            raw_content  => \$orig_html,
            Content      => \$html,
            content      => \$html,
            BuildResult  => \$orig_html,
            build_result => \$orig_html,
            Template     => $tmpl,
            template     => $tmpl,
            File         => $file,
            file         => $file
        );

        $timer->mark( "total:rebuild_indexes[template_id:"
                . $tmpl->id
                . ";file:$file]" )
            if $timer;
    }
    1;
}

sub rebuild_from_fileinfo {
    my $pub = shift;
    my ($fi) = @_;

    require MT::Blog;
    require MT::Entry;
    require MT::Category;
    require MT::Template;
    require MT::TemplateMap;
    require MT::Template::Context;

    my $at = $fi->archive_type
        or return $pub->error(
        MT->translate( "Parameter '[_1]' is required", 'ArchiveType' ) );

    # callback for custom archive types
    return
        unless MT->run_callbacks(
        'build_archive_filter',
        archive_type => $at,
        file_info    => $fi
        );

    if ( $at eq 'index' ) {
        $pub->rebuild_indexes(
            BlogID   => $fi->blog_id,
            Template => MT::Template->load( $fi->template_id ),
            FileInfo => $fi,
            Force    => 1,
        ) or return;
        return 1;
    }

    return 1 if $at eq 'None';

    my ( $start, $end );
    my $blog = MT::Blog->load( $fi->blog_id )
        if $fi->blog_id;
    my $entry = MT::Entry->load( $fi->entry_id )
        or return $pub->error(
        MT->translate( "Parameter '[_1]' is required", 'Entry' ) )
        if $fi->entry_id;
    if ( $fi->startdate ) {
        my $archiver = $pub->archiver($at);

        if ( ( $start, $end ) = $archiver->date_range( $fi->startdate ) ) {
            $entry = MT::Entry->load( { authored_on => [ $start, $end ] },
                { range_incl => { authored_on => 1 }, limit => 1 } )
                or return $pub->error(
                MT->translate( "Parameter '[_1]' is required", 'Entry' ) );
        }
    }
    my $cat = MT::Category->load( $fi->category_id )
        if $fi->category_id;
    my $author = MT::Author->load( $fi->author_id )
        if $fi->author_id;

    ## Load the template-archive-type map entries for this blog and
    ## archive type. We do this before we load the list of entries, because
    ## we will run through the files and check if we even need to rebuild
    ## anything. If there is nothing to rebuild at all for this entry,
    ## we save some time by not loading the list of entries.
    my $map  = MT::TemplateMap->load( $fi->templatemap_id );
    my $file = $pub->archive_file_for( $entry, $blog, $at, $cat, $map, undef,
        $author );
    if ( !defined($file) ) {
        return $pub->error( $blog->errstr() );
    }
    $map->{__saved_output_file} = $file;

    my $ctx = MT::Template::Context->new;
    $ctx->{current_archive_type} = $at;
    if ( $start && $end ) {
        $ctx->{current_timestamp}     = $start;
        $ctx->{current_timestamp_end} = $end;
    }

    my $arch_root
        = ( $at eq 'Page' ) ? $blog->site_path : $blog->archive_path;
    return $pub->error(
        MT->translate("You did not set your blog publishing path") )
        unless $arch_root;

    my %cond;
    $pub->rebuild_file( $blog, $arch_root, $map, $at, $ctx, \%cond, 1,
        FileInfo => $fi, )
        or return;

    1;
}

sub trans_error {
    my $this = shift;
    return $this->error( MT->translate(@_) );
}

sub publish_future_posts {
    my $this = shift;

    require MT::Blog;
    require MT::Entry;
    require MT::Util;
    my $mt            = MT->instance;
    my $total_changed = 0;
    my @blogs         = MT::Blog->load(
        { class => '*' },
        {   join => MT::Entry->join_on(
                'blog_id',
                { status => MT::Entry::FUTURE(), },
                { unique => 1 }
            )
        }
    );
    foreach my $blog (@blogs) {
        my @ts = MT::Util::offset_time_list( time, $blog );
        my $now = sprintf "%04d%02d%02d%02d%02d%02d", $ts[5] + 1900,
            $ts[4] + 1,
            @ts[ 3, 2, 1, 0 ];
        my $iter = MT::Entry->load_iter(
            {   blog_id => $blog->id,
                status  => MT::Entry::FUTURE(),
                class   => '*'
            },
            {   'sort'    => 'authored_on',
                direction => 'descend'
            }
        );
        my @queue;
        while ( my $entry = $iter->() ) {
            push @queue, $entry->id if $entry->authored_on le $now;
        }

        my $changed = 0;
        my @results;
        my %rebuild_queue;
        my %ping_queue;
        foreach my $entry_id (@queue) {
            my $entry = MT::Entry->load($entry_id)
                or next;
            $entry->status( MT::Entry::RELEASE() );
            $entry->save
                or die $entry->errstr;

            MT->run_callbacks( 'scheduled_post_published', $mt, $entry );

            $rebuild_queue{ $entry->id } = $entry;
            $ping_queue{ $entry->id }    = 1;
            my $n = $entry->next(1);
            $rebuild_queue{ $n->id } = $n if $n;
            my $p = $entry->previous(1);
            $rebuild_queue{ $p->id } = $p if $p;
            $changed++;
            $total_changed++;
        }
        if ($changed) {
            my %rebuilt_okay;
            my $rebuilt;
            eval {
                foreach my $id ( keys %rebuild_queue )
                {
                    my $entry = $rebuild_queue{$id};
                    $mt->rebuild_entry( Entry => $entry, Blog => $blog )
                        or die $mt->errstr;
                    $rebuilt_okay{$id} = 1;
                    if ( $ping_queue{$id} ) {
                        $mt->ping_and_save( Entry => $entry, Blog => $blog );
                    }
                    $rebuilt++;
                }
                $mt->rebuild_indexes( Blog => $blog )
                    or die $mt->errstr;
            };
            if ( my $err = $@ ) {

                # a fatal error occured while processing the rebuild
                # step. LOG the error and revert the entry/entries:
                require MT::Log;
                $mt->log(
                    {   message => $mt->translate(
                            "An error occurred while publishing scheduled entries: [_1]",
                            $err
                        ),
                        class    => "publish",
                        category => 'rebuild',
                        blog_id  => $blog->id,
                        level    => MT::Log::ERROR()
                    }
                );
                foreach my $id (@queue) {
                    next if exists $rebuilt_okay{$id};
                    my $e = $rebuild_queue{$id};
                    next unless $e;
                    $e->status( MT::Entry::FUTURE() );
                    $e->save or die $e->errstr;
                }
            }
        }
    }
    $total_changed > 0 ? 1 : 0;
}

sub remove_entry_archive_file {
    my $mt    = shift;
    my %param = @_;

    my $entry = $param{Entry};
    my $at    = $param{ArchiveType} || 'Individual';
    my $cat   = $param{Category};
    my $auth  = $param{Author};

    require MT::TemplateMap;
    my $blog = $param{Blog};
    unless ($blog) {
        if ($entry) {
            $blog = $entry->blog;
        }
        elsif ($cat) {
            require MT::Blog;
            $blog = MT::Blog->load( $cat->blog_id )
                or return;
        }
    }
    my @map = MT::TemplateMap->load(
        {   archive_type => $at,
            blog_id      => $blog->id,
            $param{TemplateID} ? ( template_id => $param{TemplateID} ) : (),
        }
    );
    return 1 unless @map;

    my $arch_root
        = ( $at eq 'Page' ) ? $blog->site_path : $blog->archive_path;

    require File::Spec;
    for my $map (@map) {
        my $file
            = $mt->archive_file_for( $entry, $blog, $at, $cat, $map, undef,
            $auth );
        $file = File::Spec->catfile( $arch_root, $file );
        if ( !defined($file) ) {
            die MT->translate( $blog->errstr() );
            return $mt->error( MT->translate( $blog->errstr() ) );
        }

        $mt->_delete_archive_file(
            Blog        => $blog,
            File        => $file,
            ArchiveType => $at,
            Entry       => $entry,
        );
    }
    1;
}

sub _delete_archive_file {
    my $mt    = shift;
    my %param = @_;
    my ( $blog, $file, $at, $entry )
        = map { $param{$_} } qw(Blog File ArchiveType Entry);
    my $fmgr = $blog->file_mgr;

    MT->run_callbacks( 'pre_delete_archive_file', $file, $at, $entry );

    $fmgr->delete($file);

    MT->run_callbacks( 'post_delete_archive_file', $file, $at, $entry );
}

##
## archive_file_for takes an entry to determine the timestamps,
## but if the entry is not available it uses the time_start
## and time_end values
##
{
    my %tokens_cache;

    sub archive_file_for {
        my $mt = shift;
        init_archive_types() unless %ArchiveTypes;

        my ( $entry, $blog, $at, $cat, $map, $timestamp, $author ) = @_;
        return if $at eq 'None';
        my $archiver = $mt->archiver($at);
        return '' unless $archiver;

        my $file;
        my $cache_file = MT::Request->instance->cache('file');
        unless ($cache_file) {
            MT::Request->instance->cache( 'file', $cache_file = {} );
        }
        my $cache_key = join ':',
            (
            $entry     ? $entry->id  : '0',
            $blog      ? $blog->id   : '0',
            $at        ? $at         : 'None',
            $cat       ? $cat->id    : '0',
            $map       ? $map->id    : '0',
            $timestamp ? $timestamp  : '0',
            $author    ? $author->id : '0'
            );
        if ( $file = $cache_file->{$cache_key} ) {
            return $file;
        }

        if ( $blog->is_dynamic ) {
            require MT::TemplateMap;
            $map = MT::TemplateMap->new;
            $map->file_template( $archiver->dynamic_template );
        }
        unless ($map) {
            my $cache_map = MT::Request->instance->cache('maps');
            unless ($cache_map) {
                MT::Request->instance->cache( 'maps', $cache_map = {} );
            }
            unless ( $map = $cache_map->{ $blog->id . $at } ) {
                require MT::TemplateMap;
                $map = MT::TemplateMap->load(
                    {   blog_id      => $blog->id,
                        archive_type => $at,
                        is_preferred => 1
                    }
                );
                $cache_map->{ $blog->id . $at } = $map if $map;
            }
        }
        my $file_tmpl;
        $file_tmpl = $map->file_template if $map;
        unless ($file_tmpl) {
            if ( my $tmpls = $archiver->default_archive_templates ) {
                my ($default) = grep { $_->{default} } @$tmpls;
                $file_tmpl = $default->{template} if $default;
            }
        }
        $file_tmpl ||= '';
        my ($ctx);
        if ( $file_tmpl =~ m/\%[_-]?[A-Za-z]/ ) {
            if ( $file_tmpl =~ m/<\$?MT/i ) {
                $file_tmpl
                    =~ s!(<\$?MT[^>]+?>)|(%[_-]?[A-Za-z])!$1 ? $1 : '<MTFileTemplate format="'. $2 . '">'!gie;
            }
            else {
                $file_tmpl = qq{<MTFileTemplate format="$file_tmpl">};
            }
        }
        if ($file_tmpl) {
            require MT::Template::Context;
            $ctx = MT::Template::Context->new;
            $ctx->stash( 'blog', $blog );
        }
        local $ctx->{__stash}{category}         = $cat if $cat;
        local $ctx->{__stash}{archive_category} = $cat if $cat;
        $timestamp = $entry->authored_on() if $entry;
        local $ctx->{__stash}{entry} = $entry if $entry;
        local $ctx->{__stash}{author}
            = $author ? $author : $entry ? $entry->author : undef;

        my %blog_at = map { $_ => 1 } split /,/, $blog->archive_type;
        return '' unless $blog_at{$at};

        $file = $archiver->archive_file(
            $ctx,
            Timestamp => $timestamp,
            Template  => $file_tmpl
        );
        if ( $file_tmpl && !$file ) {
            local $ctx->{archive_type} = $at;
            require MT::Builder;
            my $build  = MT::Builder->new;
            my $tokens = $tokens_cache{$file_tmpl}
                ||= $build->compile( $ctx, $file_tmpl )
                or return $blog->error( $build->errstr() );
            defined( $file = $build->build( $ctx, $tokens ) )
                or return $blog->error( $build->errstr() );
        }
        else {
            my $ext = $blog->file_extension;
            $file .= '.' . $ext if $ext;
        }
        $cache_file->{$cache_key} = $file;
        $file;
    }
}

# Adds an element to the rebuild queue when the plugin is enabled.
sub queue_build_file_filter {
    my $mt = shift;
    my ( $cb, %args ) = @_;

    my $fi = $args{file_info};
    return 1 if $fi->{from_queue};

    require MT::PublishOption;
    my $throttle = MT::PublishOption::get_throttle($fi);

    # Prevent building of disabled templates if they get this far
    return 0 if $throttle->{type} == MT::PublishOption::DISABLED();

    # Check for 'force' flag for 'manual' publish option, which
    # forces the template to build; used for 'rebuild' list actions
    # and publish site operations
    if ( $throttle->{type} == MT::PublishOption::MANUALLY() ) {
        return $args{force} ? 1 : 0;
    }

    # From here on, we're committed to publishing this file via TheSchwartz
    return 1 if $throttle->{type} != MT::PublishOption::ASYNC();

    return 1 if $args{force};    # if async, but force is used, publish

    require MT::TheSchwartz;
    require TheSchwartz::Job;
    my $job = TheSchwartz::Job->new();
    $job->funcname('MT::Worker::Publish');
    $job->uniqkey( $fi->id );

    my $priority = 0;

    my $at = $fi->archive_type || '';

    # Default priority assignment....
    if ( ( $at eq 'Individual' ) || ( $at eq 'Page' ) ) {
        require MT::TemplateMap;
        my $map = MT::TemplateMap->load( $fi->templatemap_id );

        # Individual/Page archive pages that are the 'permalink' pages
        # should have highest build priority.
        if ( $map && $map->is_preferred ) {
            $priority = 10;
        }
        else {
            $priority = 5;
        }
    }
    elsif ( $at eq 'index' ) {

        # Index pages are second in priority, if they are named 'index'
        # or 'default'
        if ( $fi->file_path =~ m!/(index|default|atom|feed)!i ) {
            $priority = 9;
        }
        else {
            $priority = 8;
        }
    }
    elsif ( $at =~ m/Category|Author/ ) {
        $priority = 1;
    }
    elsif ( $at =~ m/Yearly/ ) {
        $priority = 1;
    }
    elsif ( $at =~ m/Monthly/ ) {
        $priority = 2;
    }
    elsif ( $at =~ m/Weekly/ ) {
        $priority = 3;
    }
    elsif ( $at =~ m/Daily/ ) {
        $priority = 4;
    }

    $job->priority($priority);
    $job->coalesce( ( $fi->blog_id || 0 ) . ':' 
            . $$ . ':'
            . $priority . ':'
            . ( time - ( time % 10 ) ) );

    MT::TheSchwartz->insert($job);

    return 0;
}

1;

__END__

=head1 NAME

MT::WeblogPublisher - Express weblog templates and content into a specific URL structure

=head1 SYNOPSIS

    use MT::WeblogPublisher;
    my $pub = MT::WeblogPublisher->new;
    $pub->rebuild(Blog => $blog, ArchiveType => "Individual");

=head1 METHODS

=head2 MT::WeblogPublisher->new()

Return a new C<MT::WeblogPublisher>. Additionally, call
L<MT::ConfigMgr/instance> and set the I<NoTempFiles> and
I<PublishCommenterIcon> attributes, if not already set.

=head2 $mt->rebuild( %args )

Rebuilds your entire blog, indexes and archives; or some subset of your blog,
as specified in the arguments.

I<%args> can contain:

=over 4

=item * Blog

An I<MT::Blog> object corresponding to the blog that you would like to
rebuild.

Either this or C<BlogID> is required.

=item * BlogID

The ID of the blog that you would like to rebuild.

Either this or C<Blog> is required.

=item * ArchiveType

The archive type that you would like to rebuild. This should be one of
the following string values: C<Individual>, C<Daily>, C<Weekly>,
C<Monthly>, or C<Category>.

This argument is optional; if not provided, all archive types will be rebuilt.

=item * EntryCallback

A callback that will be called for each entry that is rebuilt. If provided,
the value should be a subroutine reference; the subroutine will be handed
the I<MT::Entry> object for the entry that is about to be rebuilt. You could
use this to keep a running log of which entry is being rebuilt, for example:

    $mt->rebuild(
              BlogID => $blog_id,
              EntryCallback => sub { print $_[0]->title, "\n" },
          );

Or to provide a status indicator:

    use MT::Entry;
    my $total = MT::Entry->count({ blog_id => $blog_id });
    my $i = 0;
    local $| = 1;
    $mt->rebuild(
              BlogID => $blog_id,
              EntryCallback => sub { printf "%d/%d\r", ++$i, $total },
          );
    print "\n";

This argument is optional; by default no callbacks are executed.

=item * NoIndexes

By default I<rebuild> will rebuild the index templates after rebuilding all
of the entries; if you do not want to rebuild the index templates, set the
value for this argument to a true value.

This argument is optional.

=item * Limit

Limit the number of entries to be rebuilt to the last C<N> entries in the
blog. For example, if you set this to C<20> and do not provide an offset (see
L<Offset>, below), the 20 most recent entries in the blog will be rebuilt.

This is only useful if you are rebuilding C<Individual> archives.

This argument is optional; by default all entries will be rebuilt.

=item * Offset

When used with C<Limit>, specifies the entry at which to start rebuilding
your individual entry archives. For example, if you set this to C<10>, and
set a C<Limit> of C<5> (see L<Limit>, above), entries 10-14 (inclusive) will
be rebuilt. The offset starts at C<0>, and the ordering is reverse
chronological.

This is only useful if you are rebuilding C<Individual> archives, and if you
are using C<Limit>.

This argument is optional; by default all entries will be rebuilt, starting
at the first entry.

=back

=head2 $mt->rebuild_entry( %args )

Rebuilds a particular entry in your blog (and its dependencies, if specified).

I<%args> can contain:

=over 4

=item * Entry

An I<MT::Entry> object corresponding to the object you would like to rebuild.

This argument is required.

=item * Blog

An I<MT::Blog> object corresponding to the blog to which the I<Entry> belongs.

This argument is optional; if not provided, the I<MT::Blog> object will be
loaded in I<rebuild_entry> from the I<$entry-E<gt>blog_id> column of the
I<MT::Entry> object passed in. If you already have the I<MT::Blog> object
loaded, however, it makes sense to pass it in yourself, as it will skip one
small step in I<rebuild_entry> (loading the object).

=item * BuildDependencies

Saving an entry can have effects on other entries; so after saving, it is
often necessary to rebuild other entries, to reflect the changes onto all
of the affected archive pages, indexes, etc.

If you supply this parameter with a true value, I<rebuild_indexes> will
rebuild: the archives for the next and previous entries, chronologically;
all of the index templates; the archives for the next and previous daily,
weekly, and monthly archives.

=item * Previous, Next, OldPrevious, OldNext

These values identify entries which may need to be updated now that
"this" entry has changed. When the authored_on field of an entry is
changed, its new neighbors (Previous and Next) need to be rebuilt as
well as its former neighbors (OldPrevious and OldNext).

=item * NoStatic

When this value is true, it acts as a hint to the rebuilding routine
that static output files need not be rebuilt; the "rebuild" operation
is just to update the bookkeeping that supports dynamic rebuilds.

=back

=head2 $mt->rebuild_file($blog, $archive_root, $map, $archive_type, $ctx, \%cond, $build_static, %args)

Method responsible for building a single archive page from a template and
writing it to the file management layer.

I<$blog> refers to the target weblog. I<$archive_root> is the target archive
path to publish the file. I<$map> is a L<MT::TemplateMap> object that
relates to publishing the file. I<$archive_type> is one of "Daily",
"Weekly", "Monthly", "Category" or "Individual". I<$ctx> is a handle to
the L<MT::Template::Context> object to use to build the file. I<\%cond>
is a hashref to conditional arguments used to drive the build process.
I<$build_static> is a boolean flag that controls whether static files are
created (otherwise, the records necessary for serving dynamic pages are
created and that is all).

I<%args> is a hash that uniquely identifies the specific instance
of the given archive type. That is, for a category archive page it
identifies the category; for a date-based archive page it identifies
which time period is covered by the page; for an individual archive it
identifies the entry. I<%args> should contain just one of these
keys:

=over 4

=item * Category

A category ID or L<MT::Category> instance of the category archive page to
be built.

=item * Entry

An entry ID or L<MT::Entry> instance of the entry archive page to be
built.

=item * StartDate

The starting timestamp of the date-based archive to be built.

=back

=head2 $mt->rebuild_indexes( %args )

Rebuilds all of the index templates in your blog, or just one, if you use
the I<Template> argument (below). Only rebuilds templates that are set to
be rebuilt automatically, unless you use the I<Force> (below).

I<%args> can contain:

=over 4

=item * Blog

An I<MT::Blog> object corresponding to the blog whose indexes you would like
to rebuild.

Either this or C<BlogID> is required.

=item * BlogID

The ID of the blog whose indexes you would like to rebuild.

Either this or C<Blog> is required.

=item * Template

An I<MT::Template> object specifying the index template to rebuild; if you use
this argument, I<only> this index template will be rebuilt.

Note that if the template that you specify here is set to not rebuild
automatically, you I<must> specify the I<Force> argument in order to force it
to be rebuilt.

=item * Force

A boolean flag specifying whether or not to rebuild index templates who have
been marked not to be rebuilt automatically.

The default is C<0> (do not rebuild such templates).

=back

=head2 $mt->trans_error

Call L<MT/translate>.

=head2 $mt->remove_entry_archive_file(%param)

Delete the archive files for an entry based on the following
parameters.  One of a I<Blog>, I<Entry> or I<Category> are required.

=over 4

=item * Blog
=item * Entry
=item * Category
=item * ArchiveType (Default 'Individual')
=item * TemplateID

=back

=head2 $mt->rebuild_categories(%param)

Rebuild category archives based on the following parameters:

=over 4

=item * Blog
=item * BlogID
=item * Limit
=item * Offset
=item * Limit
=item * NoStatic

=back

=head2 $mt->publish_future_posts

Build and publish all scheduled entries with a I<authored_on> timestamp
that is less than the current time.

=head1 CALLBACKS

=over 4

=item BuildFileFilter

This filter is called when Movable Type wants to rebuild a file, but
before doing so. This gives plugins the chance to determine whether a
file should actually be rebuild in particular situations.

A BuildFileFilter callback routine is called as follows:

    sub build_file_filter($eh, %args)
    {
        ...
        return $boolean;
    }

As with other callback funcions, the first parameter is an
C<MT::ErrorHandler> object. This can be used by the callback to
propagate an error message to the surrounding context.

The C<%args> parameters identify the page to be built. See
L<MT::FileInfo> for more information on how a page is determined by
these parameters. Elements in C<%args> are as follows:

=over 4

=item C<Context>

Holds the template context that has been constructed for building (see
C<MT::Template::Context>).

=item C<ArchiveType> 

The archive type of the file, usually one of C<'Index'>,
C<'Individual'>, C<'Category'>, C<'Daily'>, C<'Monthly'>, or
C<'Weekly'>.

=item C<Templatemap>

An C<MT::TemplateMap> object; this singles out which template is being
built, and the filesystem path of the file to be written.

=item C<Blog>

The C<MT::Blog> object representing the blog whose pages are being
rebuilt.

=item C<Entry>

In the case of an individual archive page, this points to the
C<MT::Entry> object whose page is being rebuilt. In the case of an
archive page other than an individual page, this parameter is not
necessarily undefined. It is best to rely on the C<$at> parameter to
determine whether a single entry is on deck to be built.

=item C<PeriodStart> 

In the case of a date-based archive page, this is a timestamp at the
beginning of the period from which entries will be included on this
page, in Movable Type's standard 14-digit "timestamp" format. For
example, if the page is a Daily archive for April 17, 1796, this value
would be 17960417000000. If the page were a Monthly archive for March,
2003, C<$start> would be 20030301000000. Again, this parameter may be
defined even when the page on deck is not a date-based archive page.

=item C<Category>

In the case of a Category archive, this parameter identifies the
category which will be built on the page.

=item C<FileInfo>

If defined, an L<MT::FileInfo> object which contains information about the
file. See L<MT::FileInfo> for more information about what a C<MT::FileInfo>
contains. Chief amongst all the members of C<MT::FileInfo>, for these
purposes, will be the C<virtual> member. This is a boolean value which will be
false if a page was actually created on disk for this "page," and false if no
page was created (because the corresponding template is set to be
built dynamically).

It is possible for the FileInfo parameter to be undefined, namely if the blog has not been configured to publish anything dynamically, or if the
installation is using a data driver that does not support dynamic publishing.

=back

=item BuildPage

BuildPage callbacks are invoked just after a page has been built, but
before the content has been written to the file system.

    sub build_page($eh, %args)
    {
    }

The parameters given are include those sent to the BuildFileFilter callback.
In addition, the following parameters are also given:

=over 4

=item C<Content>

This is a scalar reference to the content that will eventually be
published.

=item C<BuildResult> / (or C<RawContent>, deprecated)

This is a scalar reference to the content originally produced by building
the page. This value is provided mainly for reference; modifications to it
will be ignored.

=back

=item BuildFile

BuildFile callbacks are invoked just after a file has been built.

    sub build_file($eh, %args)
    {
    }

Parameters in %args are as with BuildPage.

=back

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
