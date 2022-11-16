# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentPublisher;

use strict;
use warnings;
use base qw( MT::WeblogPublisher );

use MT;
use MT::ArchiveType;
use MT::Category;
use MT::ContentData;
use MT::Util::Log;
use File::Basename;
use File::Spec;
use MT::PublishOption;
use MT::Template;
use MT::TemplateMap;

our %ArchiveTypes;

sub init_archive_types {
    my $types = MT->registry("archive_types") || {};
    my $mt    = MT->instance;
    while ( my ( $type, $typedata ) = each %$types ) {
        if ( 'HASH' eq ref $typedata ) {
            $typedata = MT::ArchiveType->new(%$typedata);
        }
        $ArchiveTypes{$type} = $typedata;
    }
}

sub archive_types {
    init_archive_types(@_) unless %ArchiveTypes;
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

sub core_archive_types {
    return {
        'Yearly'              => 'MT::ArchiveType::Yearly',
        'Monthly'             => 'MT::ArchiveType::Monthly',
        'Weekly'              => 'MT::ArchiveType::Weekly',
        'Individual'          => 'MT::ArchiveType::Individual',
        'Page'                => 'MT::ArchiveType::Page',
        'Daily'               => 'MT::ArchiveType::Daily',
        'Category'            => 'MT::ArchiveType::Category',
        'Author'              => 'MT::ArchiveType::Author',
        'Author-Yearly'       => 'MT::ArchiveType::AuthorYearly',
        'Author-Monthly'      => 'MT::ArchiveType::AuthorMonthly',
        'Author-Weekly'       => 'MT::ArchiveType::AuthorWeekly',
        'Author-Daily'        => 'MT::ArchiveType::AuthorDaily',
        'Category-Yearly'     => 'MT::ArchiveType::CategoryYearly',
        'Category-Monthly'    => 'MT::ArchiveType::CategoryMonthly',
        'Category-Daily'      => 'MT::ArchiveType::CategoryDaily',
        'Category-Weekly'     => 'MT::ArchiveType::CategoryWeekly',
        'ContentType'         => 'MT::ArchiveType::ContentType',
        'ContentType-Yearly'  => 'MT::ArchiveType::ContentTypeYearly',
        'ContentType-Monthly' => 'MT::ArchiveType::ContentTypeMonthly',
        'ContentType-Weekly'  => 'MT::ArchiveType::ContentTypeWeekly',
        'ContentType-Daily'   => 'MT::ArchiveType::ContentTypeDaily',
        'ContentType-Author'  => 'MT::ArchiveType::ContentTypeAuthor',
        'ContentType-Author-Yearly' =>
            'MT::ArchiveType::ContentTypeAuthorYearly',
        'ContentType-Author-Monthly' =>
            'MT::ArchiveType::ContentTypeAuthorMonthly',
        'ContentType-Author-Weekly' =>
            'MT::ArchiveType::ContentTypeAuthorWeekly',
        'ContentType-Author-Daily' =>
            'MT::ArchiveType::ContentTypeAuthorDaily',
        'ContentType-Category' => 'MT::ArchiveType::ContentTypeCategory',
        'ContentType-Category-Yearly' =>
            'MT::ArchiveType::ContentTypeCategoryYearly',
        'ContentType-Category-Monthly' =>
            'MT::ArchiveType::ContentTypeCategoryMonthly',
        'ContentType-Category-Weekly' =>
            'MT::ArchiveType::ContentTypeCategoryWeekly',
        'ContentType-Category-Daily' =>
            'MT::ArchiveType::ContentTypeCategoryDaily',
    };

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

    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->info('--- Start rebuild.');

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

    if (   $param{ArchiveType}
        && ( !$param{ContentType} )
        && ( $param{ArchiveType} eq 'ContentType-Category' ) )
    {
        return $mt->rebuild_content_categories(%param);
    }

    my @entry_at = grep { $_ !~ /^ContentType/ } @at;
    my @ct_at    = grep { $_ =~ /^ContentType/ } @at;
    if (@entry_at) {
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
            for my $at (@entry_at) {
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
    if (@ct_at) {
        my $content_type_id;
        if ( my $template_id = $param{TemplateID} ) {
            my $template = MT->model('template')->load($template_id);
            $content_type_id = $template->content_type_id if $template;
        }
        require MT::ContentData;
        my %arg = ( 'sort' => 'authored_on', direction => 'descend' );
        $arg{offset} = $param{Offset} if $param{Offset};
        $arg{limit}  = $param{Limit}  if $param{Limit};
        my $pre_iter = MT::ContentData->load_iter(
            {   blog_id => $blog->id,
                status  => MT::ContentStatus::RELEASE(),
                (   $content_type_id
                    ? ( content_type_id => $content_type_id )
                    : ()
                ),
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
        my $cb  = $param{ContentCallback};
        my $fcb = $param{FilterCallback};
        while ( my $content_data = $iter->() ) {
            if ($cb) {
                $cb->($content_data)
                    or $mt->log(
                    {   message  => $cb->errstr(),
                        category => 'callback',
                    }
                    );
            }
            if ($fcb) {
                $fcb->($content_data) or last;
            }
            for my $at (@ct_at) {
                my $archiver = $mt->archiver($at);

                # Skip this archive type if the archive type doesn't
                # match the kind of entry we've loaded
                next unless $archiver;

                if ( $archiver->contenttype_author_based ) {
                    $mt->_rebuild_content_archive_type(
                        ContentData => $content_data,
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
                        Author   => $content_data->author,
                    ) or return;
                }
                else {
                    my @cats;
                    if ( $archiver->contenttype_category_based ) {
                        my @cat_cf_ids
                            = map { $_->id } MT::ContentField->load(
                            {   type => 'categories',
                                content_type_id =>
                                    $content_data->content_type_id,
                            },
                            { fetchonly => { id => 1 } },
                            );
                        if (@cat_cf_ids) {
                            @cats = MT::Category->load(
                                {   category_set_id =>
                                        { op => '>', value => 0 }
                                },
                                {   join => MT::ObjectCategory->join_on(
                                        undef,
                                        {   category_id => \'= category_id',
                                            object_ds   => 'content_data',
                                            object_id   => $content_data->id,
                                            cf_id       => \@cat_cf_ids,
                                        },
                                    ),
                                    unique => 1,
                                },
                            );
                        }
                    }
                    else {
                        @cats = (undef);
                    }
                    for my $cat (@cats) {
                        $mt->_rebuild_content_archive_type(
                            ContentData => $content_data,
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
            }
        }
    }
    unless ( $param{NoIndexes} ) {
        $mt->rebuild_indexes( Blog => $blog, NoStatic => $param{NoStatic}, )
            or return;
    }

    $mt->remove_marked_files($blog);

    MT::Util::Log->info('--- End   rebuild.');
    1;
}

sub rebuild_categories {
    my $mt = shift;
    $mt->SUPER::rebuild_categories(@_);
}

sub rebuild_content_categories {
    my $mt    = shift;
    my %param = @_;
    my $blog;

    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->info(' Start rebuild_content_categories.');

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
    $arg{'sort'}    = 'id';
    $arg{direction} = 'ascend';
    $arg{offset}    = $param{Offset} if $param{Offset};
    $arg{limit}     = $param{Limit} if $param{Limit};
    my @caegory_set     = MT::CategorySet->load( { blog_id => $blog->id } );
    my @category_set_id = map { $_->id } @caegory_set;
    my $cat_iter
        = MT::Category->load_iter(
        { blog_id => $blog->id, category_set_id => \@category_set_id },
        \%arg );
    my $fcb = $param{FilterCallback};

    while ( my $cat = $cat_iter->() ) {
        if ($fcb) {
            $fcb->($cat) or last;
        }
        $mt->_rebuild_content_archive_type(
            Blog        => $blog,
            Category    => $cat,
            ArchiveType => 'ContentType-Category',
            $param{TemplateMap}
            ? ( TemplateMap => $param{TemplateMap} )
            : (),
            NoStatic => $param{NoStatic},
            Force    => ( $param{Force} ? 1 : 0 ),
        ) or return;
    }
    MT::Util::Log->info(' End   rebuild_content_categories.');
    1;
}

sub rebuild_authors {
    my $mt = shift;
    $mt->SUPER::rebuild_authors(@_);
}

sub rebuild_deleted_entry {
    my $mt = shift;
    $mt->SUPER::rebuild_deleted_entry(@_);
}

sub rebuild_entry {
    my $mt = shift;
    $mt->SUPER::rebuild_entry(@_);
}

sub rebuild_archives {
    my $mt = shift;
    $mt->SUPER::rebuild_archives(@_);
}

# return hashref
#  key: content_field_id
#  value: categories to be rebuilt
sub _get_categories_for_rebuild {
    my $mt    = shift;
    my %param = @_;

    my $cd            = $param{content_data};
    my $old_cats_json = $param{old_categories};
    my $ct            = $cd->content_type;

    my ( $old_categories, @field_ids );
    if ($old_cats_json) {
        $old_categories
            = eval { MT::Util::from_json($old_cats_json) } || {};
        @field_ids = keys %$old_categories;
    }
    else {
        $old_categories = {};
        @field_ids      = map { $_->{id} } @{ $ct->categories_fields };
    }

    my %categories_for_rebuild;
    for my $field_id (@field_ids) {
        my $field_hash = $ct->get_field($field_id);
        my %rebuild_ids;
        $rebuild_ids{$_} = 1 for @{ $old_categories->{$field_id} || [] };
        $rebuild_ids{$_} = 0 for @{ $cd->data->{$field_id}       || [] };
        if (%rebuild_ids) {
            my @categories = MT->model('category')->load(
                {   id              => [ keys %rebuild_ids ],
                    category_set_id => \'> 0',
                }
            );
            for my $category (@categories) {
                push @{ $categories_for_rebuild{$field_id} ||= [] },
                    [ $category, $rebuild_ids{ $category->id } ];
            }
        }
        else {
            $categories_for_rebuild{$field_id} = [];
        }
    }

    return \%categories_for_rebuild;
}

#   rebuild_content_data
#
# $mt->rebuild_content_data(ContentData => $content_data_id,
#                    Blog => [ $blog | $blog_id ],
#                    [ BuildDependencies => (0 | 1), ]
#                    [ OldPrevious => $old_previous_content_data_id,
#                      OldNext => $old_next_content_data_id, ]
#                    [ NoStatic => (0 | 1), ]
#                    );
sub rebuild_content_data {
    my $mt    = shift;
    my %param = @_;

    my $content_data = $param{ContentData}
        or return $mt->trans_error( "Parameter '[_1]' is required",
        'ContentData' );
    unless ( ref $content_data ) {
        $content_data = MT::ContentData->load($content_data);
    }
    unless ($content_data) {
        return $mt->trans_error( "Parameter '[_1]' is invalid",
            'ContentData' );
    }

    my $blog = $param{Blog} || $content_data->blog
        or return $mt->trans_error( "Load of blog '[_1]' failed",
        $content_data->blog_id );

    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->info('--- Start rebuild_content_data.');

    my $categories_for_rebuild = $mt->_get_categories_for_rebuild(
        content_data   => $content_data,
        old_categories => $param{OldCategories},
    );

    my %cache_maps;

    my $at = $param{PreferredArchiveOnly}
        ? 'ContentType'    # TBD: MTC-25351 $blog->archive_type_preferred
        : $blog->archive_type;
    unless ( defined $at && $at ne '' ) {
        $at = 'ContentType';
    }
    if ( $at && $at ne 'None' ) {
        MT::Util::Log::init();
        my @at = grep { $_ =~ /^ContentType/ } split( ',', $at );
        for my $at (@at) {
            my $archiver = $mt->archiver($at);
            next unless $archiver;    # invalid archive type
            MT::Util::Log->debug(" Rebuilding $at");

            my @maps;
            if ( $param{TemplateMap} ) {
                @maps = ( $param{TemplateMap} );
            }
            else {
                @maps = MT::TemplateMap->load(
                    {   blog_id      => $content_data->blog_id,
                        archive_type => $at,
                    },
                    {   join => MT::Template->join_on(
                            undef,
                            {   id => \'= templatemap_template_id',
                                content_type_id =>
                                    $content_data->content_type_id,
                            },
                        ),
                    },
                );
            }
            $cache_maps{$at} = \@maps;

            if ( $archiver->category_based ) {
                for my $map (@maps) {
                    my @cats = map { @$_ } values %{ $categories_for_rebuild || {} };
                    for my $cat_item (@cats) {
                        my ( $cat, $is_old ) = @$cat_item;
                        MT::Util::Log->debug(
                            " Rebuilding $at (" . $cat->label . ")" );
                        my $content_data_to_use = $content_data;
                        if ($is_old) {
                            $content_data_to_use = $archiver->alternative_content( {
                                ContentData => $content_data,
                                Blog        => $blog,
                                ArchiveType => $at,
                                Category    => $cat,
                                TemplateMap => $map,
                            } ) || $content_data;
                        }
                        $mt->_rebuild_content_archive_type(
                            ContentData => $content_data_to_use,
                            Blog        => $blog,
                            ArchiveType => $at,
                            Category    => $cat,
                            NoStatic    => $param{NoStatic},

                            # Force       => ($param{Force} ? 1 : 0),
                            TemplateMap => $map,
                        ) or return;
                    }
                }
            }
            else {
                for my $map (@maps) {
                    my $cat = _get_primary_category_of_content_data(
                        {   cat_field_id    => $map->cat_field_id,
                            content_data_id => $content_data->id,
                        }
                    );
                    $mt->_rebuild_content_archive_type(
                        ContentData => $content_data,
                        Blog        => $blog,
                        ArchiveType => $at,
                        TemplateMap => $map,
                        NoStatic    => $param{NoStatic},
                        Force       => ( $param{Force} ? 1 : 0 ),
                        Author      => $content_data->author,
                        Category    => $cat,
                    ) or return;
                }
            }
        }
    }

    ## The above will just rebuild the archive pages for this particular
    ## content data. If we want to rebuild all of the content data/archives/indexes
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
        ## Rebuild previous and next content data archive pages.
        if ( my $prev = $content_data->previous(1) ) {
            $mt->rebuild_content_data(
                ContentData          => $prev,
                PreferredArchiveOnly => 1
            ) or return;
            ## Rebuild the old previous and next content data, if we have some.
            if (   $param{OldPrevious}
                && ( $param{OldPrevious} != $prev->id )
                && ( my $old_prev
                    = MT::ContentData->load( $param{OldPrevious} ) )
                )
            {
                $mt->rebuild_content_data(
                    ContentData          => $old_prev,
                    PreferredArchiveOnly => 1
                ) or return;
            }
        }
        if ( my $next = $content_data->next(1) ) {
            $mt->rebuild_content_data(
                ContentData          => $next,
                PreferredArchiveOnly => 1
            ) or return;

            if (   $param{OldNext}
                && ( $param{OldNext} != $next->id )
                && ( my $old_next = MT::ContentData->load( $param{OldNext} ) )
                )
            {
                $mt->rebuild_content_data(
                    ContentData          => $old_next,
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
        my %at    = map { $_ => 1 } split /,/, $blog->archive_type;
        my @db_at = grep {
            my $archiver = $mt->archiver($_);
            $archiver && $archiver->contenttype_date_based
        } $mt->archive_types;
        for my $at (@db_at) {
            if ( $at{$at} ) {
                my $archiver = $mt->archiver($at) or next;

                my @maps;
                if ( $cache_maps{$at} ) {
                    @maps = @{ $cache_maps{$at} };
                }
                else {
                    @maps = MT::TemplateMap->load(
                        {   blog_id      => $content_data->blog_id,
                            archive_type => $at,
                        },
                        {   join => MT::Template->join_on(
                                undef,
                                {   id => \'= templatemap_template_id',
                                    content_type_id =>
                                        $content_data->content_type_id,
                                },
                            ),
                        },
                    );
                    $cache_maps{$at} = \@maps;
                }

                if ( $archiver->category_based ) {

                    for my $map (@maps) {
                        my @cats
                            = @{ $categories_for_rebuild
                                ->{ $map->cat_field_id } || [] };
                        for my $cat_item (@cats) {
                            my ( $cat, $is_old ) = @$cat_item;
                            if (my $prev_arch
                                = $archiver->previous_archive_content_data(
                                    {   category_field_id =>
                                            $map->cat_field_id,
                                        category_id  => $cat->id,
                                        content_data => $content_data,
                                        datetime_field_id =>
                                            $map->dt_field_id,
                                    }
                                )
                                )
                            {
                                $mt->_rebuild_content_archive_type(
                                    NoStatic => $param{NoStatic},

                                    # Force    => ($param{Force} ? 1 : 0),
                                    ContentData => $prev_arch,
                                    Blog        => $blog,
                                    Category    => $cat,
                                    TemplateMap => $map,
                                    ArchiveType => $at
                                ) or return;
                            }
                            if (my $next_arch
                                = $archiver->next_archive_content_data(
                                    {   category_field_id =>
                                            $map->cat_field_id,
                                        category_id  => $cat->id,
                                        content_data => $content_data,
                                        datetime_field_id =>
                                            $map->dt_field_id,
                                    }
                                )
                                )
                            {
                                $mt->_rebuild_content_archive_type(
                                    NoStatic => $param{NoStatic},

                                    # Force    => ($param{Force} ? 1 : 0),
                                    ContentData => $next_arch,
                                    Blog        => $blog,
                                    Category    => $cat,
                                    TemplateMap => $map,
                                    ArchiveType => $at
                                ) or return;
                            }
                        }
                    }
                }
                else {
                    for my $map (@maps) {
                        if (my $prev_arch
                            = $archiver->previous_archive_content_data(
                                {   $archiver->author_based
                                    ? ( author => $content_data->author )
                                    : (),
                                    content_data      => $content_data,
                                    datetime_field_id => $map->dt_field_id,
                                }
                            )
                            )
                        {
                            my $cat = _get_primary_category_of_content_data(
                                {   cat_field_id    => $map->cat_field_id,
                                    content_data_id => $prev_arch->id,
                                }
                            );
                            $mt->_rebuild_content_archive_type(
                                NoStatic => $param{NoStatic},

                                # Force       => ($param{Force} ? 1 : 0),
                                ContentData => $prev_arch,
                                Blog        => $blog,
                                ArchiveType => $at,
                                TemplateMap => $map,
                                Category    => $cat,
                                $archiver->author_based
                                ? ( Author => $content_data->author )
                                : (),
                            ) or return;
                        }
                        if (my $next_arch
                            = $archiver->next_archive_content_data(
                                {   $archiver->author_based
                                    ? ( author => $content_data->author )
                                    : (),
                                    content_data      => $content_data,
                                    datetime_field_id => $map->dt_field_id,
                                }
                            )
                            )
                        {
                            my $cat = _get_primary_category_of_content_data(
                                {   cat_field_id    => $map->cat_field_id,
                                    content_data_id => $next_arch->id,
                                }
                            );
                            $mt->_rebuild_content_archive_type(
                                NoStatic => $param{NoStatic},

                                # Force       => ($param{Force} ? 1 : 0),
                                ContentData => $next_arch,
                                Blog        => $blog,
                                ArchiveType => $at,
                                TemplateMap => $map,
                                Category    => $cat,
                                $archiver->author_based
                                ? ( Author => $content_data->author )
                                : (),
                            ) or return;
                        }
                    }
                }
            }
        }
    }

    MT::Util::Log->info('--- End   rebuild_content_data.');

    1;
}

# move to MT::ContentData?
sub _get_primary_category_of_content_data {
    my ($args) = @_;
    $args ||= {};
    my $cat_field_id = $args->{cat_field_id} or return;
    my $cd_id        = $args->{content_data_id};

    my $obj_category = MT->model('objectcategory')->load(
        {   cf_id      => $cat_field_id,
            is_primary => 1,
            object_ds  => 'content_data',
            object_id  => $cd_id,
        }
    ) or return;
    my $cat = MT->model('category')->load( $obj_category->category_id );
    return $cat;
}

sub rebuild_file {
    my $mt = shift;
    my ( $blog, $root_path, $map, $at, $ctx, $cond, $build_static, %args )
        = @_;
    my $finfo;
    my $archiver = $mt->archiver($at);
    my ( $entry, $start, $end, $category, $author, $content_data );

    if ( $finfo = $args{FileInfo} ) {
        $args{Author}      = $finfo->author_id   if $finfo->author_id;
        $args{Category}    = $finfo->category_id if $finfo->category_id;
        $args{Entry}       = $finfo->entry_id    if $finfo->entry_id;
        $args{ContentData} = $finfo->cd_id       if $finfo->cd_id;
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
    if ( UNIVERSAL::isa( MT->instance, 'MT::App' ) ) {
        my $mod_time = $fmgr->file_mod_time($file);
        if ( $mod_time && $mod_time >= $mt->start_time ) {
            MT::Util::Log->debug( ' Ignored recently rebuilt ' . $file );
            return 1;
        }
    }

    if ( $archiver->category_based || $archiver->contenttype_category_based )
    {
        $category = $args{Category};
        die MT->translate( "[_1] archive type requires [_2] parameter",
            $archiver->archive_label, 'Category' )
            unless $args{Category};
        $category = MT::Category->load($category)
            unless ref $category;
        $ctx->{__stash}{archive_category} = $category;
        if ( $archiver->contenttype_category_based ) {
            $ctx->{__stash}{template_map} = $map;
            my $category_set = MT->model('category_set')
                ->load( $category->category_set_id );
            $ctx->{__stash}{category_set} = $category_set;
        }
    }
    if ( $archiver->entry_based or $args{Entry} ) {
        $entry = $args{Entry};
        die MT->translate( "[_1] archive type requires [_2] parameter",
            $archiver->archive_label, 'Entry' )
            unless $entry;
        require MT::Entry;
        $entry = MT::Entry->load($entry) if !ref $entry;
        if ( $archiver->entry_based ) {
            $ctx->{__stash}{entry} = $entry;
        }
    }
    if ( $archiver->date_based ) {

        # Date-based archive type
        $start = $args{StartDate};
        $end   = $args{EndDate};
        die MT->translate( "[_1] archive type requires [_2] parameter",
            $archiver->archive_label, 'StartDate' )
            unless $args{StartDate};
        $ctx->{__stash}{template_map} = $map
            if $archiver->contenttype_date_based;
    }
    if ( $archiver->author_based ) {

        # author based archive type
        $author = $args{Author};
        die MT->translate( "[_1] archive type requires [_2] parameter",
            $archiver->archive_label, 'Author' )
            unless $args{Author};
        require MT::Author;
        $author = MT::Author->load($author)
            unless ref $author;
        $ctx->{__stash}{author}       = $author;
        $ctx->{__stash}{template_map} = $map
            if $archiver->contenttype_author_based;
    }
    if ( $archiver->contenttype_based
        or ( $archiver->contenttype_group_based and $args{ContentData} ) )
    {
        $content_data = $args{ContentData};
        die MT->translate( "[_1] archive type requires [_2] parameter",
            $archiver->archive_label, 'ContentData' )
            unless $content_data;
        require MT::ContentData;
        $content_data = MT::ContentData->load($content_data)
            if !ref $content_data;
        my $content_type
            = MT::ContentType->load( $content_data->content_type_id );
        $ctx->var( 'content_archive', 1 );
        $ctx->{__stash}{content_type} = $content_type;
        if ( $archiver->contenttype_based ) {
            $ctx->{__stash}{content} = $content_data;
        }
        $ctx->{__stash}{template_map} = $map;
    }
    local $ctx->{current_timestamp}     = $start if $start;
    local $ctx->{current_timestamp_end} = $end   if $end;

    $ctx->{__stash}{blog}          = $blog;
    $ctx->{__stash}{local_blog_id} = $blog->id;

    require MT::FileInfo;

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
        my $any_contenttype_based = (
                   $archiver->contenttype_based
                or $archiver->contenttype_group_based
        );

        my %terms;
        $terms{blog_id}     = $blog->id;
        $terms{category_id} = $category->id
            if $archiver->category_based;
        $terms{author_id} = $author->id
            if $archiver->author_based;
        $terms{entry_id} = $entry->id
            if $archiver->entry_based;
        $terms{startdate} = $start
            if $archiver->date_based
            && ( !$archiver->entry_based )
            && ( !$archiver->contenttype_based );
        $terms{archive_type}   = $at;
        $terms{templatemap_id} = $map->id;
        $terms{cd_id}          = $content_data->id
            if $content_data
            and $archiver->contenttype_based;
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
            MT::Util::Log::init();
            foreach my $fi (@finfos) {
                if ( MT->config('DeleteFilesAfterRebuild') ) {
                    $fi->mark_to_remove( $map->build_type );
                    MT::Util::Log->debug( 'Marked to remove ' . $fi->file_path );
                }
                else {
                    $fi->remove();
                    MT::Util::Log->debug( 'Removed FileInfo for ' . $fi->file_path );
                    if ( MT->config('DeleteFilesAtRebuild') ) {
                        $mt->_delete_archive_file(
                            Blog        => $blog,
                            File        => $fi->file_path,
                            ArchiveType => $at,
                            (   $any_contenttype_based && $content_data
                                ? ( ContentData => $content_data->id )
                                : ()
                            ),
                        );
                    }
                }
            }

            $finfo = MT::FileInfo->set_info_for_url(
                $rel_url, $file, $at,
                {   Blog        => $blog->id,
                    TemplateMap => $map->id,
                    Template    => $tmpl_id,
                    StartDate   => $start,
                    (          $archiver->entry_based
                            && $entry ? ( Entry => $entry->id ) : ()
                    ),
                    (          $archiver->category_based
                            && $category ? ( Category => $category->id ) : ()
                    ),
                    (          $archiver->author_based
                            && $author ? ( Author => $author->id ) : ()
                    ),
                    (   $any_contenttype_based && $content_data
                        ? ( ContentData => $content_data->id )
                        : ()
                    ),
                }
                )
                || die "Couldn't create FileInfo because "
                . MT::FileInfo->errstr();
            MT::Util::Log->debug( 'Created FileInfo for ' . $file );
        }
    }

    if (!$archiver->does_publish_file(
            {   Blog        => $blog,
                ArchiveType => $at,
                Entry       => $entry,
                Category    => $category,
                Author      => $author,
                Timestamp   => $start,
                TemplateMap => $map,
                ( $content_data ? ( ContentData => $content_data ) : () ),
            }
        )
        or ( $entry && $archiver->entry_based && $entry->status != MT::Entry::RELEASE() )
        or (   $content_data
            && $archiver->contenttype_based
            && $content_data->status != MT::ContentStatus::RELEASE() )
        )
    {
        $map->{__saved_but_removed} = 1;
        if ( MT->config->DeleteFilesAfterRebuild ) {
            $finfo->mark_to_remove( $map->build_type );
            MT::Util::Log->debug( 'Marked to remove ' . $finfo->file_path );
        }
        else {
            $finfo->remove();
            MT::Util::Log->debug(
                'Removed (saved-but-not-published) FileInfo for ' . $finfo->file_path );
            if ( MT->config->DeleteFilesAtRebuild ) {
                $mt->_delete_archive_file(
                    Blog        => $blog,
                    File        => $finfo->file_path,
                    ArchiveType => $at
                );
            }
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
            ContentData  => $content_data,
            contentdata  => $content_data,
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

        return 1;
    }
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
            ContentData  => $content_data,
            contentdata  => $content_data,
        )
        )
    {

        if ( $archiver->group_based ) {
            if ( $archiver->contenttype_group_based ) {
                require MT::Promise;
                my $contents
                    = sub { $archiver->archive_group_contents($ctx) };
                $ctx->stash( 'contents', MT::Promise::delay($contents) );
            }
            else {
                require MT::Promise;
                my $entries = sub { $archiver->archive_group_entries($ctx) };
                $ctx->stash( 'entries', MT::Promise::delay($entries) );
            }
        }

        my $html = undef;
        $ctx->stash( 'blog',  $blog );
        $ctx->stash( 'entry', $entry ) if $entry;
        $ctx->stash( '_basename',
            fileparse( $map->{__saved_output_file}, qr/\.[^.]*/ ) );
        $ctx->stash( 'current_mapping_url', $url );

        if ( !$map->is_preferred ) {
            my $category = $ctx->{__stash}{archive_category};
            my $author   = $ctx->{__stash}{author};
            my $obj
                = (    $archiver->contenttype_based
                    || $archiver->contenttype_group_based )
                ? $content_data
                : $entry;
            $ctx->stash(
                'preferred_mapping_url',
                sub {
                    my $file = $mt->archive_file_for( $obj, $blog, $at,
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
                        $category->label,
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
        $html =~ s/\A(?:\s|\x{feff}|\xef\xbb\xbf)+(<(?:\?xml|!DOCTYPE))/$1/s;

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
            file         => $file,
            ContentData  => $content_data,
            contentdata  => $content_data,
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
        my $temp_file      = $use_temp_files ? "$file.new" : $file;
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
            file         => $file,
            ContentData  => $content_data,
            contentdata  => $content_data,
        );
    }
    $timer->mark( "total:rebuild_file[template_id:" . $tmpl->id . "]" )
        if $timer;

    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->info( ' Rebuilt ' . $file );

    1;
}

sub rebuild_indexes {
    my $mt = shift;
    $mt->SUPER::rebuild_indexes(@_);
}

sub rebuild_from_fileinfo {
    my $pub          = shift;
    my ($fi)         = @_;
    my $archive_type = $fi->archive_type;
    if ( $archive_type =~ /^ContentType/ ) {
        $pub->rebuild_content_from_fileinfo(@_);
    }
    else {
        $pub->rebuild_entry_from_fileinfo(@_);
    }
}

sub rebuild_content_from_fileinfo {
    my $pub = shift;
    my ($fi) = @_;

    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->info(' Start rebuild_from_fileinfo.');

    require MT::Blog;
    require MT::ContentData;
    require MT::ContentStatus;
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

    my $template = MT::Template->load( $fi->template_id )
        or return $pub->error(
        MT->translate( 'Cannot load template #[_1].', $fi->template_id ) );
    if ( $at eq 'index' ) {
        $pub->rebuild_indexes(
            BlogID   => $fi->blog_id,
            Template => $template,
            FileInfo => $fi,
            Force    => 1,
        ) or return;
        return 1;
    }

    return 1 if $at eq 'None';

    my ( $start, $end );
    my $blog;
    if ( $fi->blog_id ) {
        $blog = MT::Blog->load( $fi->blog_id )
            or return $pub->error(
            MT->translate( 'Cannot load blog #[_1].', $fi->blog_id ) );
    }
    my $content_data;
    if ( $fi->cd_id ) {
        $content_data = MT::ContentData->load( $fi->cd_id )
            or return $pub->error(
            MT->translate( "Parameter '[_1]' is required", 'ContentData' ) );
    }

    my $map = MT::TemplateMap->load( $fi->templatemap_id );
    if ( $fi->startdate ) {
        my $archiver = $pub->archiver($at);
        if ( ( $start, $end ) = $archiver->date_range( $fi->startdate ) ) {

            # Load Content by Content Data Index
            my $dt_field_id = $map->dt_field_id;

            $content_data = MT::ContentData->load(
                {   blog_id         => $blog->id,
                    content_type_id => $template->content_type_id,
                    status          => MT::ContentStatus::RELEASE(),
                    (   !$dt_field_id ? ( authored_on => [ $start, $end ] )
                        : ()
                    ),
                },
                {   limit => 1,
                    (   !$dt_field_id ? ( range_incl => { authored_on => 1 } )
                        : ()
                    ),
                    ( !$dt_field_id ? ( sort      => 'authored_on' ) : () ),
                    ( !$dt_field_id ? ( direction => 'descend' )     : () ),
                    (   $dt_field_id
                        ? ( join => [
                                'MT::ContentFieldIndex',
                                'content_data_id',
                                {   content_field_id => $dt_field_id,
                                    value_datetime   => [ $start, $end ]
                                },
                                {   sort       => 'value_datetime',
                                    range_incl => { value_datetime => 1 }
                                }
                            ]
                            )
                        : ()
                    ),
                }
                )
                or return $pub->error(
                MT->translate(
                    "Parameter '[_1]' is required", 'ContentData'
                )
                );
        }
    }

    my $cat;
    if ( $fi->category_id ) {
        $cat = MT::Category->load( $fi->category_id );
    }
    my $author;
    if ( $fi->author_id ) {
        $author = MT::Author->load( $fi->author_id );
    }

    ## Load the template-archive-type map entries for this blog and
    ## archive type. We do this before we load the list of entries, because
    ## we will run through the files and check if we even need to rebuild
    ## anything. If there is nothing to rebuild at all for this entry,
    ## we save some time by not loading the list of entries.
    my $file = $pub->archive_file_for( $content_data, $blog, $at, $cat, $map,
        ( $fi->startdate ? $fi->startdate : undef ), $author );
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
        MT->translate("You did not set your site publishing path") )
        unless $arch_root;

    my %cond;
    $pub->rebuild_file( $blog, $arch_root, $map, $at, $ctx, \%cond, 1,
        FileInfo => $fi, )
        or return;
    MT::Util::Log->info(' End   rebuild_from_fileinfo.');

    1;
}

sub _rebuild_content_archive_type {
    my $mt    = shift;
    my %param = @_;

    my $at = $param{ArchiveType}
        or return $mt->error(
        MT->translate( "Parameter '[_1]' is required", 'ArchiveType' ) );
    return 1 if $at eq 'None';
    my $content_data = $param{ContentData};

    ## XXX: shouldn't always raise an error if content data is not defined?
    if (!$content_data
        && (   $param{ArchiveType} ne 'ContentType-Category'
            && $param{ArchiveType} ne 'ContentType-Author'
            && !exists $param{Start}
            && !exists $param{End} )
        )
    {
        return $mt->error( MT->translate( "Parameter '[_1]' is required", 'ContentData' ) );
    }

    my $blog;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $content_data->blog_id;
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
        my $cache_key = join ':',
            (
            $at,
            $blog->id,
            (   $param{ContentData} ? $param{ContentData}->content_type_id
                : 0
            ),
            (     $param{Category} && $param{Category}->category_set_id
                ? $param{Category}->category_set_id
                : 0
            ),
            );
        if ( my $maps = $cached_maps->{$cache_key} ) {
            @map = @$maps;
        }
        else {
            my @joins;
            if ( $param{ContentData} && !$param{TemplateID} ) {
                my $join = MT::Template->join_on(
                    undef,
                    {   'id' => \'= templatemap_template_id',
                        'content_type_id' =>
                            $param{ContentData}->content_type_id,
                    }
                );
                push @joins, $join;
            }
            if ( $param{Category} ) {
                my $join = MT->model('content_field')->join_on(
                    undef,
                    {   id => \'= templatemap_cat_field_id',
                        related_cat_set_id =>
                            $param{Category}->category_set_id || 0,
                    },
                );
                push @joins, $join;
            }
            @map = MT::TemplateMap->load(
                {   archive_type => $at,
                    blog_id      => $blog->id,
                    $param{TemplateID}
                    ? ( template_id => $param{TemplateID} )
                    : ()
                },
                @joins ? { joins => \@joins } : (),
            );
            $cached_maps->{$cache_key} = \@map;
        }
    }
    return 1 unless @map;

    my @map_build;
    my $done = MT->instance->request( '__published:' . $blog->id )
        || MT->instance->request( '__published:' . $blog->id, {} );
    for my $map (@map) {

        # SKIP no relation content data
        if ( $at =~ /^ContentType/ ) {
            my $template = MT->model('template')->load( $map->template_id );
            next
                if $template
                && $content_data
                && $template->content_type_id ne
                $content_data->content_type_id;
        }

        my $ts
            = $content_data
            && $map->dt_field_id ? $content_data->data->{ $map->dt_field_id }
            : exists $param{Timestamp} ? $param{Timestamp}
            :                            undef;

        my $file
            = exists $param{File}
            ? $param{File}
            : $mt->archive_file_for( $content_data, $blog, $at,
            $param{Category}, $map, $ts, $param{Author} );
        if ( !defined($file) ) {
            return $mt->error( MT->translate( $blog->errstr() ) );
        }
        elsif ( $file eq '' ) {

            # np
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
        MT->translate("You did not set your site publishing path") )
        unless $arch_root;

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

        my ( $start, $end );
        if ( exists $param{Start} && exists $param{End} ) {
            $start = $param{Start};
            $end   = $param{End};
        }
        else {
            if ( $archiver->date_based() && $archiver->can('date_range') ) {
                ( $start, $end )
                    = $archiver->date_range(
                    $archiver->target_dt( $content_data, $map ) );
            }
        }

        my $ctx = MT::Template::Context->new;
        $ctx->{current_archive_type} = $at;
        $ctx->{archive_type}         = $at;
        $mt->rebuild_file(
            $blog, $arch_root, $map, $at, $ctx, \my %cond,
            !$param{NoStatic},
            Category    => $param{Category},
            ContentData => $content_data,
            Author      => $param{Author},
            StartDate   => $start,
            EndDate     => $end,
            Force       => $param{Force} ? 1 : 0,
        ) or return;
        $done->{ $map->{__saved_output_file} }++
            unless delete $map->{__saved_but_removed};
    }
    1;
}

{
    my %tokens_cache;

    sub archive_file_cache_key {
        my $mt = shift;
        my ( $obj, $blog, $at, $cat, $map, $timestamp, $author,
            $content_type_id )
            = @_;

        return join ':',
            (
            $obj             ? $obj->id         : '0',
            $blog            ? $blog->id        : '0',
            $at              ? $at              : 'None',
            $cat             ? $cat->id         : '0',
            $map             ? $map->id         : '0',
            $timestamp       ? $timestamp       : '0',
            $author          ? $author->id      : '0',
            $content_type_id ? $content_type_id : '0',
            );
    }

    sub archive_file_for {
        my $mt = shift;
        init_archive_types() unless %ArchiveTypes;

        my ($obj, $blog, $at, $cat, $map, $timestamp, $author, $ct_id) = @_;
        return if $at eq 'None';
        my $archiver = $mt->archiver($at);
        return '' unless $archiver;

        my $file;
        my $cache_file = MT::Request->instance->cache('file');
        unless ($cache_file) {
            MT::Request->instance->cache( 'file', $cache_file = {} );
        }
        my $cache_key = $mt->archive_file_cache_key(@_);
        if ( $file = $cache_file->{$cache_key} ) {
            return $file;
        }

        $map ||= $archiver->get_preferred_map({ blog_id => $blog->id, content_type_id => $ct_id });
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
        local $ctx->{__stash}{entry}            = $obj
            if $obj && ( ref $obj eq 'MT::Entry' || ref $obj eq 'MT::Page' );
        local $ctx->{__stash}{content} = $obj
            if $obj && ref $obj eq 'MT::ContentData';
        local $ctx->{__stash}{content_type} = $obj->content_type
            if $ctx->stash('content');
        local $ctx->{__stash}{author}
            = $author ? $author : $obj ? $obj->author : undef;
        local $ctx->{__stash}{template_map} = $map if $map;

        if ( $obj && !$timestamp ) {
            $timestamp
                = $at =~ /^ContentType/ && $map && $map->dt_field_id
                ? $obj->data->{ $map->dt_field_id }
                : $obj->authored_on();
        }

        my %blog_at = map { $_ => 1 } split /,/, ($blog->archive_type || '');
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

sub remove_content_data_archive_file {
    my $mt    = shift;
    my %param = @_;

    my $content_data = $param{ContentData};
    my $at           = $param{ArchiveType} || 'ContentType';
    my $archiver     = $mt->archiver($at) or return;
    my $author       = $param{Author};
    my $force        = exists $param{Force} ? $param{Force} : 1;
    my $blog         = $param{Blog};
    my $template_id  = $param{TemplateID};

    if ( !$blog && $content_data ) {
        $blog = $content_data->blog;
    }
    return unless $blog;

    my @maps;
    if ($template_id) {
        @maps = MT::TemplateMap->load(
            {   archive_type => $at,
                blog_id      => $blog->id,
                template_id  => $template_id,
            },
        );
    }
    else {
        @maps = MT::TemplateMap->load(
            {   archive_type => $at,
                blog_id      => $blog->id,
            },
            {   join => MT::Template->join_on(
                    undef,
                    {   id              => \'= templatemap_template_id',
                        content_type_id => $content_data->content_type_id,
                    },
                ),
            },
        );
    }
    return 1 unless @maps;

    my $archive_root = $blog->archive_path;

    for my $map (@maps) {
        next if !$force && $map->build_type == MT::PublishOption::ASYNC();

        my $timestamp;
        if ( $archiver->can('target_dt') ) {
            $timestamp = $archiver->target_dt( $content_data, $map );
        }

        my $category_ids = [];
        if ( $archiver->can('target_category_ids') ) {
            $category_ids
                = $archiver->target_category_ids( $content_data, $map );
        }
        my $cat_id = @$category_ids ? $category_ids->[0] : undef;
        my $cat;
        if ($cat_id) {
            $cat = MT->model('category')->load($cat_id)
                or die MT->translate( 'Cannot load catetory. (ID: [_1]',
                $cat_id );
        }

        my $file
            = $mt->archive_file_for( $content_data, $blog, $at, $cat,
            $map, $timestamp, $author );
        $file = File::Spec->catfile( $archive_root, $file );
        if ( !defined $file ) {
            die MT->translate( $blog->errstr );
        }

        require MT::FileInfo;
        my @fileinfos = MT::FileInfo->load(
            {   blog_id   => $blog->id,
                file_path => $file,
            }
        );
        if ( MT->config('DeleteFilesAfterRebuild') ) {
            for my $fi (@fileinfos) {
                $fi->mark_to_remove( $map->build_type );
            }
            MT::Util::Log->debug("Marked to remove $file");
        }
        else {
            for my $fi (@fileinfos) {
                $fi->remove;
            }
            $mt->_delete_archive_file(
                Blog        => $blog,
                File        => $file,
                ArchiveType => $at,
                ContentData => $content_data,
            );
        }
    }
}

sub _delete_archive_file {
    my $mt    = shift;
    my %param = @_;
    $param{Entry} = $param{ContentData} if $param{ContentData};
    $mt->SUPER::_delete_archive_file(%param);
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
    my $entry_id  = $param{Entry};
    my $author_id = $param{Author};
    my $start     = $param{StartDate};
    my $cat_id    = $param{Category};
    my $cd_id     = $param{ContentData};
    my $ct_id     = $param{ContentType};

    require MT::FileInfo;
    my ( $terms, $args );
    $terms = {
        archive_type => $at,
        blog_id      => $blog_id,
        ( $entry_id ? ( entry_id    => $entry_id ) : () ),
        ( $cat_id   ? ( category_id => $cat_id )   : () ),
        ( $start    ? ( startdate   => $start )    : () ),
        ( $cd_id    ? ( cd_id       => $cd_id )    : () ),
    };

    if ($ct_id) {
        $args = {
            join => MT::Template->join_on(
                undef,
                {   id              => \'= fileinfo_template_id',
                    content_type_id => $ct_id,
                },
            ),
        };
    }

    MT::Util::Log::init();
    my @finfo = MT::FileInfo->load( $terms, $args );
    for my $f (@finfo) {
        $f->remove;
        MT::Util::Log->debug( 'Removed FileInfo for ' . $f->file_path );
    }
    1;
}

sub mark_fileinfo {
    my $mt    = shift;
    my %param = @_;
    my $at    = $param{ArchiveType}
        or return $mt->error( MT->translate( "Parameter '[_1]' is required", 'ArchiveType' ) );
    my $blog_id = $param{Blog}
        or return $mt->error( MT->translate( "Parameter '[_1]' is required", 'Blog' ) );
    my $entry_id  = $param{Entry};
    my $author_id = $param{Author};
    my $start     = $param{StartDate};
    my $cat_id    = $param{Category};
    my $cd_id     = $param{ContentData};
    my $ct_id     = $param{ContentType};
    my $map       = $param{TemplateMap};

    require MT::FileInfo;
    my ( $terms, $args );
    $terms = {
        archive_type => $at,
        blog_id      => $blog_id,
        ( $author_id ? ( author_id   => $author_id ) : () ),
        ( $entry_id  ? ( entry_id    => $entry_id )  : () ),
        ( $cat_id    ? ( category_id => $cat_id )    : () ),
        ( $start     ? ( startdate   => $start )     : () ),
        ( $cd_id     ? ( cd_id       => $cd_id )     : () ),
    };

    if ($ct_id) {
        $args = {
            join => MT::Template->join_on(
                undef,
                {   id              => \'= fileinfo_template_id',
                    content_type_id => $ct_id,
                },
            ),
        };
    }

    MT::Util::Log::init();
    my @finfo      = MT::FileInfo->load( $terms, $args );
    my $build_type = $map ? $map->build_type : 0;
    for my $f (@finfo) {
        $f->mark_to_remove($build_type);
        MT::Util::Log->debug( 'Marked to remove ' . $f->file_path );
    }
    1;
}

# rebuild_deleted_content_data
#
# $mt->rebuild_deleted_content_data(
#                    ContentData => $content_data | $content_data_id,
#                    Blog => [ $blog | $blog_id ],
#                    );
sub rebuild_deleted_content_data {
    my $mt           = shift;
    my %param        = @_;
    my $app          = MT->instance;
    my $content_data = $param{ContentData}
        or return $mt->trans_error( "Parameter '[_1]' is required",
        'ContentData' );
    $content_data = MT::ContentData->load($content_data)
        unless ref $content_data;
    return unless $content_data;

    MT::Util::Log::init();

    MT::Util::Log->info('--- Start rebuild_deleted_content_data.');

    my $blog = $param{Blog};
    unless ($blog) {
        $blog = $content_data->blog
            or return $mt->trans_error(
            "Load of blog '[_1]' failed",
            $content_data->blog_id || '(none)'
            );
    }

    my %rebuild_recipe;
    my $at = $blog->archive_type;
    my @at;
    if ( $at && $at ne 'None' ) {
        my @at_orig = split /,/, $at;
        @at = grep { $_ =~ /^ContentType/ } @at_orig;
    }

    if ( $app->config('DeleteFilesAfterRebuild') ) {
        $mt->mark_fileinfo(
            ArchiveType => 'ContentType',
            Blog        => $blog->id,
            ContentData => $content_data->id,
        );
    }
    else {
        # Remove ContentType archive file.
        if ( $app->config('DeleteFilesAtRebuild') ) {
            $mt->remove_content_data_archive_file( ContentData => $content_data );
        }

        # Remove ContentType fileinfo records.
        $mt->remove_fileinfo(
            ArchiveType => 'ContentType',
            Blog        => $blog->id,
            ContentData => $content_data->id,
        );
    }

    for my $at (@at) {
        my $archiver = $mt->archiver($at) or next;

        my $map = MT::TemplateMap->load(
            {   blog_id      => $blog->id,
                archive_type => $at,
            },
            {   join => MT::Template->join_on(
                    undef,
                    {   id              => \'= templatemap_template_id',
                        content_type_id => $content_data->content_type_id,
                    },
                ),
            },
        );

        my ( $start, $end );
        my $target_dt;
        if ( $archiver->date_based && $archiver->can('date_range') ) {
            next unless $map;
            $target_dt = $archiver->target_dt( $content_data, $map );
            ( $start, $end ) = $archiver->date_range($target_dt);
        }

        if ( $archiver->category_based ) {
            next unless $map;
            my $category_ids
                = $archiver->target_category_ids( $content_data, $map );
            for my $cat_id (@$category_ids) {
                my $cat = MT::Category->load($cat_id) or next;
                if (!$archiver->does_publish_file(
                        {   Blog        => $blog,
                            ArchiveType => $at,
                            ContentData => $content_data,
                            Category    => $cat,
                            TemplateMap => $map,
                        }
                    )
                    )
                {
                    if ( MT->config('DeleteFilesAfterRebuild') ) {
                        $mt->mark_fileinfo(
                            ArchiveType => $at,
                            Blog        => $blog->id,
                            Category    => $cat->id,
                            ContentType => $content_data->content_type_id,
                            TemplateMap => $map,
                            (   $archiver->date_based()
                                ? ( StartDate => $start )
                                : ()
                            ),
                        );
                    }
                    else {
                        # Remove archives fileinfo records.
                        $mt->remove_fileinfo(
                            ArchiveType => $at,
                            Blog        => $blog->id,
                            Category    => $cat->id,
                            ContentType => $content_data->content_type_id,
                            TemplateMap => $map,
                            (   $archiver->date_based()
                                ? ( StartDate => $start )
                                : ()
                            ),
                        );

                        if (   $app->config('RebuildAtDelete')
                            && $app->config('DeleteFilesAtRebuild') )
                        {
                            $mt->remove_content_data_archive_file(
                                ContentData => $content_data,
                                ArchiveType => $at,
                                Category    => $cat,
                            );
                        }
                    }
                }
                else {
                    my $new_content_data = $archiver->alternative_content(
                        {   Blog        => $blog,
                            ArchiveType => $at,
                            ContentData => $content_data,
                            Category    => $cat,
                            TemplateMap => $map,
                        }
                    );
                    if ( $app->config('RebuildAtDelete') ) {
                        if ( $archiver->date_based ) {
                            $rebuild_recipe{$at}{ $cat->id }
                                { $start . $end }{'Start'} = $start;
                            $rebuild_recipe{$at}{ $cat->id }
                                { $start . $end }{'End'} = $end;
                            $rebuild_recipe{$at}{ $cat->id }
                                { $start . $end }{'Timestamp'} = $target_dt;
                            $rebuild_recipe{$at}{ $cat->id }
                                { $start . $end }{'ContentData'}
                                = $new_content_data;
                        }
                        else {
                            $rebuild_recipe{$at}{ $cat->id }{id}
                                = $cat->id;
                            $rebuild_recipe{$at}{ $cat->id }{ContentData}
                                = $new_content_data;
                        }
                    }
                }
            }
        }
        else {
            if ( $at eq 'ContentType' ) {
                next unless $app->config('RebuildAtDelete');
                if ( my $prev = $content_data->previous(1) ) {
                    $rebuild_recipe{ContentType}{ $prev->id }{id}
                        = $prev->id;
                }
                if ( my $next = $content_data->next(1) ) {
                    $rebuild_recipe{ContentType}{ $next->id }{id}
                        = $next->id;
                }
            }
            elsif (
                !$archiver->does_publish_file(
                    {   Blog        => $blog,
                        ArchiveType => $at,
                        ContentData => $content_data,
                        TemplateMap => $map,
                        (   $archiver->author_based() ? ( Author => $content_data->author )
                            : ()
                        ),
                        (   $archiver->date_based() ? ( Timestamp => $start )
                            : ()
                        ),
                    }
                )
                )
            {
                if ( $app->config('DeleteFilesAfterRebuild') ) {
                    $mt->mark_fileinfo(
                        ArchiveType => $at,
                        Blog        => $blog->id,
                        ContentType => $content_data->content_type_id,
                        TemplateMap => $map,
                        (   $archiver->author_based() ? ( Author => $content_data->author_id )
                            : ()
                        ),
                        (   $archiver->date_based() ? ( StartDate => $start )
                            : ()
                        ),
                    );
                }
                else {
                    # Remove archives fileinfo records.
                    $mt->remove_fileinfo(
                        ArchiveType => $at,
                        Blog        => $blog->id,
                        ContentType => $content_data->content_type_id,
                        TemplateMap => $map,
                        (   $archiver->author_based() ? ( Author => $content_data->author_id )
                            : ()
                        ),
                        (   $archiver->date_based() ? ( StartDate => $start )
                            : ()
                        ),
                    );

                    if (   $app->config('RebuildAtDelete')
                        && $app->config('DeleteFilesAtRebuild') )
                    {
                        $mt->remove_content_data_archive_file(
                            ContentData => $content_data,
                            ArchiveType => $at,
                        );
                    }
                }
            }
            else {
                next unless $app->config('RebuildAtDelete');
                my $new_content_data = $archiver->alternative_content( {
                        ArchiveType => $at,
                        Blog        => $blog->id,
                        ContentType => $content_data->content_type_id,
                        ContentData => $content_data,
                        TemplateMap => $map,
                        (   $archiver->author_based() ? ( Author => $content_data->author_id )
                            : ()
                        ),
                        (   $archiver->date_based() ? ( StartDate => $start )
                            : ()
                        ),
                } );

                if ( $archiver->author_based && $content_data->author ) {
                    if ( $archiver->date_based ) {
                        $rebuild_recipe{$at}{ $content_data->author->id }
                            { $start . $end }{'Start'} = $start;
                        $rebuild_recipe{$at}{ $content_data->author->id }
                            { $start . $end }{'End'} = $end;
                        $rebuild_recipe{$at}{ $content_data->author->id }
                            { $start . $end }{'Timestamp'} = $target_dt;
                        $rebuild_recipe{$at}{ $content_data->author->id }
                            { $start . $end }{'ContentData'} = $new_content_data;
                    }
                    else {
                        $rebuild_recipe{$at}{ $content_data->author->id }{id}
                            = $content_data->author->id;
                        $rebuild_recipe{$at}{ $content_data->author->id }
                            {ContentData} = $new_content_data;
                    }
                }
                elsif ( $archiver->date_based ) {
                    $rebuild_recipe{$at}{ $start . $end }{'Start'}
                        = $start;
                    $rebuild_recipe{$at}{ $start . $end }{'End'} = $end;
                    $rebuild_recipe{$at}{ $start . $end }{'Timestamp'}
                        = $target_dt;
                    $rebuild_recipe{$at}{ $start . $end }{'ContentData'}
                        = $new_content_data;
                }

                if ( my $prev = $content_data->previous(1) ) {
                    $rebuild_recipe{ContentType}{ $prev->id }{id}
                        = $prev->id;
                }
                if ( my $next = $content_data->next(1) ) {
                    $rebuild_recipe{ContentType}{ $next->id }{id}
                        = $next->id;
                }
            }
        }
    }

    MT::Util::Log->info('--- End   rebuild_deleted_content_data.');

    return %rebuild_recipe;
}

sub publish_future_contents {
    my $this = shift;

    require MT::ContentStatus;
    require MT::Util;
    my $mt            = MT->instance;
    my $total_changed = 0;
    my @sites         = MT->model('blog')->load(
        { class => '*' },
        {   join => MT->model('content_data')->join_on(
                'blog_id',
                { status => MT::ContentStatus::FUTURE(), },
                { unique => 1 }
            )
        }
    );
    foreach my $site (@sites) {

        # Clear cache
        MT->instance->request( '__published:' . $site->id, undef )
            if MT->instance->request( '__published:' . $site->id );

        my @ts  = MT::Util::offset_time_list( time, $site );
        my $now = sprintf "%04d%02d%02d%02d%02d%02d", $ts[5] + 1900,
            $ts[4] + 1,
            @ts[ 3, 2, 1, 0 ];
        my $iter = MT->model('content_data')->load_iter(
            {   blog_id => $site->id,
                status  => MT::ContentStatus::FUTURE(),
            },
            {   'sort'    => 'authored_on',
                direction => 'descend'
            }
        );
        my @queue;
        while ( my $content_data = $iter->() ) {
            push @queue, $content_data->id
                if $content_data->authored_on le $now;
        }

        my $changed = 0;
        my @results;
        my %rebuild_queue;
        foreach my $content_data_id (@queue) {
            my $content_data
                = MT->model('content_data')->load($content_data_id)
                or next;
            my $original = $content_data->clone();
            $content_data->status( MT::ContentStatus::RELEASE() );
            my @ts
                = MT::Util::offset_time_list( time, $content_data->blog_id );
            my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
                $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
            $content_data->modified_on($ts);
            $content_data->save
                or die $content_data->errstr;
            $this->post_scheduled( $content_data, $original,
                MT->translate('Scheduled publishing.') );

            MT->run_callbacks( 'scheduled_content_published', $mt,
                $content_data );

            $rebuild_queue{ $content_data->id } = $content_data;
            my $n = $content_data->next(1);
            $rebuild_queue{ $n->id } = $n if $n;
            my $p = $content_data->previous(1);
            $rebuild_queue{ $p->id } = $p if $p;
            $changed++;
            $total_changed++;

            # Clear cache for site stats dashnoard widget.
            MT::Util::clear_site_stats_widget_cache( $site->id )
                or die translate('Removing stats cache failed.');
        }
        if ($changed) {
            my %rebuilt_okay;
            my $rebuilt;
            eval {
                foreach my $id ( keys %rebuild_queue ) {
                    my $content_data = $rebuild_queue{$id};
                    $mt->rebuild_content_data(
                        ContentData => $content_data,
                        Blog        => $site
                    ) or die $mt->errstr;
                    $rebuilt_okay{$id} = 1;
                    $rebuilt++;
                }
                $mt->rebuild_indexes( Blog => $site )
                    or die $mt->errstr;
            };
            if ( my $err = $@ ) {

                # a fatal error occurred while processing the rebuild
                # step. LOG the error and revert the entry/entries:
                require MT::Log;
                $mt->log(
                    {   message => $mt->translate(
                            "An error occurred while publishing scheduled contents: [_1]",
                            $err
                        ),
                        class    => "publish",
                        category => 'rebuild',
                        blog_id  => $site->id,
                        level    => MT::Log::ERROR()
                    }
                );
                foreach my $id (@queue) {
                    next if exists $rebuilt_okay{$id};
                    my $e = $rebuild_queue{$id};
                    next unless $e;
                    $e->status( MT::ContentStatus::FUTURE() );
                    $e->save or die $e->errstr;
                }
            }
        }
    }
    $total_changed > 0 ? 1 : 0;
}

sub unpublish_past_contents {
    my $app = shift;

    require MT::ContentStatus;
    require MT::Util;
    my $mt            = MT->instance;
    my $total_changed = 0;
    my @sites         = MT->model('website')->load();
    my @blogs         = MT->model('blog')->load();
    push @sites, @blogs;
    foreach my $site (@sites) {

        # Clear cache
        MT->instance->request( '__published:' . $site->id, undef )
            if MT->instance->request( '__published:' . $site->id );

        my @ts  = MT::Util::offset_time_list( time, $site );
        my $now = sprintf "%04d%02d%02d%02d%02d%02d", $ts[5] + 1900,
            $ts[4] + 1,
            @ts[ 3, 2, 1, 0 ];
        my $iter = MT->model('content_data')->load_iter(
            {   blog_id        => $site->id,
                status         => MT::ContentStatus::RELEASE(),
                unpublished_on => [ undef, $now ],
            },
            {   range     => { unpublished_on => 1 },
                'sort'    => 'unpublished_on',
                direction => 'descend',
            }
        );
        my @queue;
        while ( my $content_data = $iter->() ) {
            push @queue, $content_data->id;
        }

        my $changed = 0;
        my @results;
        my %rebuild_queue;
        foreach my $content_data_id (@queue) {
            my $content_data
                = MT->model('content_data')->load($content_data_id)
                or next;
            my $original = $content_data->clone();

            $content_data->status( MT::ContentStatus::UNPUBLISH() );
            my @ts
                = MT::Util::offset_time_list( time, $content_data->blog_id );
            my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
                $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
            $content_data->modified_on($ts);
            $content_data->save
                or die $content_data->errstr;
            $app->post_scheduled( $content_data, $original );

            if ( $mt->config('DeleteFilesAfterRebuild') ) {

                # Marking seems unnecessary here as $content_data is enqueued below
            }
            else {
                # remove file
                if ( $mt->config('DeleteFilesAtRebuild') ) {
                    $app->remove_content_data_archive_file(
                        ContentData => $content_data,
                        ArchiveType => 'ContentType',
                    );
                }
            }

            MT->run_callbacks( 'unpublish_past_contents', $mt,
                $content_data );

            $rebuild_queue{ $content_data->id } = $content_data;
            my $n = $content_data->next(1);
            $rebuild_queue{ $n->id } = $n if $n;
            my $p = $content_data->previous(1);
            $rebuild_queue{ $p->id } = $p if $p;
            $changed++;
            $total_changed++;

            # Clear cache for site stats dashnoard widget.
            MT::Util::clear_site_stats_widget_cache( $site->id )
                or die translate('Removing stats cache failed.');
        }
        if ($changed) {
            my %rebuilt_okay;
            my $rebuilt;
            eval {
                foreach my $id ( keys %rebuild_queue ) {
                    my $content_data = $rebuild_queue{$id};
                    $mt->rebuild_content_data(
                        ContentData => $content_data,
                        Blog        => $site
                    ) or die $mt->errstr;
                    $rebuilt_okay{$id} = 1;
                    $rebuilt++;
                }
                $mt->rebuild_indexes( Blog => $site )
                    or die $mt->errstr;
                $mt->publisher->remove_marked_files($site);
            };
            if ( my $err = $@ ) {

                # a fatal error occurred while processing the rebuild
                # step. LOG the error and revert the entry/entries:
                require MT::Log;
                $mt->log(
                    {   message => $mt->translate(
                            "An error occurred while unpublishing past contents: [_1]",
                            $err
                        ),
                        class    => "unpublish",
                        category => 'rebuild',
                        blog_id  => $site->id,
                        level    => MT::Log::ERROR()
                    }
                );
                foreach my $id (@queue) {
                    next if exists $rebuilt_okay{$id};
                    my $e = $rebuild_queue{$id};
                    next unless $e;
                    $e->status( MT::ContentStatus::RELEASE() );
                    $e->save or die $e->errstr;
                }
            }
        }
    }
    $total_changed > 0 ? 1 : 0;
}

1;
