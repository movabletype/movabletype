# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

use strict;
package MT::WeblogPublisher;

use vars qw(@ISA);
@MT::WeblogPublisher::ISA = qw(MT::ErrorHandler);

use MT::Util qw( archive_file_for start_end_period start_end_day
                 start_end_week start_end_month get_entry );
use File::Basename;

sub new {
    my $class = shift;
    my $this = { @_ };
    require MT::ConfigMgr;
    my $cfg = MT::ConfigMgr->instance;
    if (!exists $this->{NoTempFiles}) {
        $this->{NoTempFiles} = $cfg->NoTempFiles;
    }
    if (!exists $this->{PublishCommenterIcon}) {
        $this->{PublishCommenterIcon} = $cfg->PublishCommenterIcon;
    }
    bless $this, $class;
    $this;
}

sub rebuild {
    my $mt = shift;
    my %param = @_;
    my $blog;
    unless ($blog = $param{Blog}) {
        my $blog_id = $param{BlogID};
        $blog = MT::Blog->load($blog_id, {cached_ok=>1}) or
            return $mt->error(
                MT->translate("Load of blog '[_1]' failed: [_2]",
                    $blog_id, MT::Blog->errstr));
    }
    return 1 if $blog->is_dynamic;
    my $at = $blog->archive_type || '';
    my @at = split /,/, $at;
    if (my $set_at = $param{ArchiveType}) {
        my %at = map { $_ => 1 } @at;
        return $mt->error(
            MT->translate("Archive type '[_1]' is not a chosen archive type",
                $set_at)) unless $at{$set_at};
        @at = ($set_at);
    }
    if (@at) {
        require MT::Entry;
        my %arg = ('sort' => 'created_on', direction => 'descend');
        if ($param{Limit}) {
            $arg{offset} = $param{Offset};
            $arg{limit} = $param{Limit};
        }
        my $pre_iter = MT::Entry->load_iter({ blog_id => $blog->id,
                                       status => MT::Entry::RELEASE() },
                                     \%arg);
        my ($next, $curr);
        my $prev = $pre_iter->();
        my $iter = sub { $next = $curr; $curr = $prev;
            if ($curr) {
                $prev = $pre_iter->();
                $curr->{__next} = $next;
                $curr->{__previous} = $prev;
            }
            $curr;
        };
        my $cb = $param{EntryCallback};
        while (my $entry = $iter->()) {
            if ($cb) {
                $cb->($entry) || $mt->log($cb->errstr());
            }
            for my $at (@at) {
                if ($at eq 'Category') {
                    my $cats = $entry->categories;
                    for my $cat (@$cats) {
                        $mt->_rebuild_entry_archive_type(
                            Entry => $entry, Blog => $blog,
                            Category => $cat, ArchiveType => 'Category',
                            NoStatic => $param{NoStatic},
                        ) or return;
                    }
                } else {
                    $mt->_rebuild_entry_archive_type( Entry => $entry,
                                                      Blog => $blog,
                                                      ArchiveType => $at,
                                                      $param{TemplateID}
                                                       ? (TemplateID =>
                                                           $param{TemplateID})
                                                       : (),
                                                      NoStatic => $param{NoStatic})
                        or return;
                }
            }
        }
    }
    unless ($param{NoIndexes}) {
        $mt->rebuild_indexes( Blog => $blog ) or return;
    }
    if ($mt->{PublishCommenterIcon}) {
        $mt->make_commenter_icon($blog);
    }
    1;
}

sub make_commenter_icon {
    my $mt = shift;
    my $blog = shift;
    if (!UNIVERSAL::isa($blog, 'MT::Blog')) { $blog = shift; }
    my $identity_link_image = $blog->site_path . "/nav-commenters.gif";
    unless (-f $identity_link_image) {
        my $fmgr = $blog->file_mgr;
        unless ($fmgr->exists($blog->site_path)) {
            $fmgr->mkpath($blog->site_path)
                or return MT->trans_error("Error making path '[_1]': [_2]",
                                           $blog->site_path, $fmgr->errstr);
        }
        my $nav_commenters_gif = (q{47494638396116000f00910200504d4b}.
                                  q{ffffffffffff00000021f90401000002}.
                                  q{002c0000000016000f0000022c948fa9}.
                                  q{19e0bf2208b482a866a51723bd75dee1}.
                                  q{70e2f83586837ed773a22fd4ba6cede2}.
                                  q{241c8f7ceff9e95005003b});
        $nav_commenters_gif = pack("H*", $nav_commenters_gif);
        eval {
            if (open(TARGET, ">$identity_link_image")) {
                print TARGET $nav_commenters_gif;
                close TARGET;
            } else {
                MT::log("Couldn't write authenticated commenter icon to " .
                        $identity_link_image);
                die;
            }
        };
    }
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
    my $mt = shift;
    my %param = @_;
    MT->log("rebuild_entry called; args are " . join("; ", keys %param));
    my $entry = $param{Entry} or
        return $mt->error(MT->translate("Parameter '[_1]' is required",
            'Entry'));
    $entry = MT::Entry->load($entry, {cached_ok=>1}) unless ref $entry;
    my $blog;
    unless ($blog = $param{Blog}) {
        my $blog_id = $entry->blog_id;
        $blog = MT::Blog->load($blog_id, {cached_ok=>1}) or
            return $mt->error(MT->translate("Load of blog '[_1]' failed: [_2]",
                $blog_id, MT::Blog->errstr));
    }
    return 1 if $blog->is_dynamic;

    my $at = $blog->archive_type;
    if ($at && $at ne 'None') {
        my @at = split /,/, $at;
        for my $at (@at) {
            if ($at eq 'Category') {
                my $cats = $entry->categories;   # (ancestors => 1)
                for my $cat (@$cats) {
                    $mt->_rebuild_entry_archive_type(
                        Entry => $entry, Blog => $blog,
                        ArchiveType => $at, Category => $cat,
                        NoStatic => $param{NoStatic}
                    ) or return;
                }
            } else {
                $mt->_rebuild_entry_archive_type( Entry => $entry,
                                                  Blog => $blog,
                                                  ArchiveType => $at,
                                                  NoStatic => $param{NoStatic}
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

    return 1 unless $param{BuildDependencies} || $param{BuildIndexes} ||
                    $param{BuildArchives};

    if ($param{BuildDependencies}) {
        ## Rebuild previous and next entry archive pages.
        if (my $prev = $entry->{__previous}) {
            $mt->rebuild_entry( Entry => $prev ) or return;

            ## Rebuild the old previous and next entries, if we have some.
            if ($param{OldPrevious} && 
                               (my $old_prev = MT::Entry->load($param{OldPrevious},
                                                               {cached_ok=>1}))) {
                $mt->rebuild_entry( Entry => $old_prev ) or return;
            }
        }
        if (my $next = $entry->{__next}) {
            $mt->rebuild_entry( Entry => $next ) or return;

            if ($param{OldNext} && (my $old_next = MT::Entry->load($param{OldNext},
                                                                   {cached_ok=>1}))) {
                $mt->rebuild_entry( Entry => $old_next ) or return;
            }
        }
    }

    if ($param{BuildDependencies} || $param{BuildIndexes}) {
        ## Rebuild all indexes, in case this entry is on an index.
        $mt->rebuild_indexes( Blog => $blog ) or return;
    }

    if ($param{BuildDependencies} || $param{BuildArchives}) {
        ## Rebuild previous and next daily, weekly, and monthly archives;
        ## adding a new entry could cause changes to the intra-archive
        ## navigation.
        my %at = map { $_ => 1 } split /,/, $blog->archive_type;
        for my $at (qw( Daily Weekly Monthly )) {
            if ($at{$at}) {
                my @arg = ($entry->created_on, $entry->blog_id, $at);
                if (my $prev_arch = get_entry(@arg, 'previous')) {
                    $mt->_rebuild_entry_archive_type(NoStatic => $param{NoStatic},
                              Entry => $prev_arch,
                              Blog => $blog,
                              ArchiveType => $at) or return;
                }
                if (my $next_arch = get_entry(@arg, 'next')) {
                    $mt->_rebuild_entry_archive_type(NoStatic => $param{NoStatic},
                              Entry => $next_arch,
                              Blog => $blog,
                              ArchiveType => $at) or return;
                }
            }
        }
    }

    1;
}

sub _rebuild_entry_archive_type {
    my $mt = shift;
    my %param = @_;
    my $at = $param{ArchiveType} or
        return $mt->error(MT->translate("Parameter '[_1]' is required",
            'ArchiveType'));
    return 1 if $at eq 'None';
    my $entry = ($param{ArchiveType} ne 'Category') ? ($param{Entry} or
        return $mt->error(MT->translate("Parameter '[_1]' is required",
            'Entry'))) : undef;
    my $blog;
    unless ($blog = $param{Blog}) {
        my $blog_id = $entry->blog_id;
        $blog = MT::Blog->load($blog_id, {cached_ok=>1}) or
            return $mt->error(MT->translate("Load of blog '[_1]' failed: [_2]",
                $blog_id, MT::Blog->errstr));
    }

    ## Load the template-archive-type map entries for this blog and
    ## archive type. We do this before we load the list of entries, because
    ## we will run through the files and check if we even need to rebuild
    ## anything. If there is nothing to rebuild at all for this entry,
    ## we save some time by not loading the list of entries.
    require MT::TemplateMap;
    my @map;
    my $cached_maps = MT->instance->request('__cached_maps') || MT->instance->request('__cached_maps', {});
    if (my $maps = $cached_maps->{$at . $blog->id}) {
        @map = @$maps;
    } else {
        @map = MT::TemplateMap->load({ archive_type => $at,
                                       blog_id => $blog->id,
                                       $param{TemplateID}
                                         ? (template_id => $param{TemplateID})
                                         : ()
                                     });
        $cached_maps->{$at . $blog->id} = \@map;
    }
#     return $mt->trans_error(
#         "You selected the archive type '[_1]', but you did not " .
#         "define a template for this archive type.", $at) unless @map;
    return 1 unless @map;
    my @map_build;

    my $done = MT->instance->request('__published') || MT->instance->request('__published', {});
    for my $map (@map) {
        my $file = archive_file_for($entry, $blog, $at, $param{Category}, $map);
        if (!defined($file)) {
            return $mt->error(MT->translate($blog->errstr()));
        }
        push @map_build, $map unless $done->{$file};
        $map->{__saved_output_file} = $file;
    }
    return 1 unless @map_build;
    @map = @map_build;
    
    my(%cond);
    require MT::Template::Context;
    my $ctx = MT::Template::Context->new;
    $ctx->{current_archive_type} = $at;

    $at ||= "";

    require MT::Promise;
    import MT::Promise qw(delay);

    if ($at eq 'Individual') {
        $ctx->stash('entry', $entry);
        $ctx->{current_timestamp} = $entry->created_on;
        $ctx->{modification_timestamp} = $entry->modified_on;
    } elsif ($at eq 'Daily') {
        my($start, $end) = start_end_day($entry->created_on, $blog);
        $ctx->{current_timestamp} = $start;
        $ctx->{current_timestamp_end} = $end;
        my $entries = sub {
            my @e = MT::Entry->load({ created_on => [ $start, $end ],
                                      blog_id => $blog->id,
                                      status => MT::Entry::RELEASE() },
                                    { range_incl => { created_on => 1 } });
            \@e;
        };
        $ctx->stash('archive_entries', delay($entries));
    } elsif ($at eq 'Weekly') {
        my($start, $end) = start_end_week($entry->created_on, $blog);
        $ctx->{current_timestamp} = $start;
        $ctx->{current_timestamp_end} = $end;
        my $entries = sub {
            my @e = MT::Entry->load({ created_on => [ $start, $end ],
                                      blog_id => $blog->id,
                                      status => MT::Entry::RELEASE() },
                                    { range_incl => { created_on => 1 } });
            \@e;
        };
        $ctx->stash('archive_entries', delay($entries));
    } elsif ($at eq 'Monthly') {
        my($start, $end) = start_end_month($entry->created_on, $blog);
        $ctx->{current_timestamp} = $start;
        $ctx->{current_timestamp_end} = $end;
        my $entries = sub {
            my @e = MT::Entry->load({ created_on => [ $start, $end ],
                                      blog_id => $blog->id,
                                      status => MT::Entry::RELEASE() },
                                    { range_incl => { created_on => 1 } });
            \@e;
        };
        $ctx->stash('archive_entries', delay($entries));
    } elsif ($at eq 'Category') {
        my $cat;
        unless ($cat = $param{Category}) {
            return $mt->error(MT->translate(
                "Building category archives, but no category provided."));
        }
        require MT::Placement;
        $ctx->stash('archive_category', $cat);
        my $entries = sub {
            my @e = MT::Entry->load({ blog_id => $blog->id,
                                      status => MT::Entry::RELEASE() },
                                    { 'join' => [ 'MT::Placement', 'entry_id',
                                      { category_id => $cat->id } ] });
            \@e;
        };
        $ctx->stash('archive_entries', delay($entries));
    }
    
    my $fmgr = $blog->file_mgr;
    my $arch_root = $blog->archive_path;
    return $mt->error(MT->translate("You did not set your Local Archive Path"))
        unless $arch_root;
    
    my ($start, $end) = ($at ne 'Category') ? 
        start_end_period($at, $entry->created_on) : ();
    
    ## For each mapping, we need to rebuild the entries we loaded above in
    ## the particular template map, and write it to the specified archive
    ## file template.
    require MT::Template;
    for my $map (@map) {
        $mt->rebuild_file($blog, $arch_root, $map, $at, $ctx, \%cond,
                          !$param{NoStatic},
                          Category => $param{Category},
                          Entry => $entry,
                          StartDate => $start,
                          ) or return;
        $done->{$map->{__saved_output_file}}++;
    }
    1;
}

sub rebuild_file {
    my $mt = shift;
    my ($blog, $root_path, $map, $at, $ctx, $cond, 
        $build_static, %specifier) = @_;

    my $entry;
    my $start;
    my $category;
    if ($at eq 'Category') {
        $category = $specifier{Category};
        die "Category archive type requires Category parameter"
            unless $specifier{Category};
        $category = MT::Category->load($category, {cached_ok=>1}) 
            unless ref $category;
    } elsif ($at eq 'Individual') {
        $entry = $specifier{Entry};
        $entry = MT::Entry->load($entry, {cached_ok=>1}) if !ref $entry;
        die "Individual archive type requires Entry parameter"
            unless $specifier{Entry};
    } else {
        # Date-based archive type
        $start = $specifier{StartDate};
        die "Date-based archive types require StartDate parameter" 
            unless $specifier{StartDate};
    }
    my $fmgr = $blog->file_mgr;
    
    # Calculate file path and URL for the new entry.
    my $file = File::Spec->catfile($root_path, $map->{__saved_output_file});
    my $url = $blog->archive_url;
    $url .= '/' unless $url =~ m|/$|;
    $url .= $map->{__saved_output_file};

    my $cached_tmpl = MT->instance->request('__cached_templates') || MT->instance->request('__cached_templates', {});
    my $tmpl = $cached_tmpl->{$map->template_id};
    unless ($tmpl) {
        $tmpl = MT::Template->load($map->template_id, {cached_ok=>1});
        if ($cached_tmpl) {
            $cached_tmpl->{$tmpl->id} = $tmpl;
        }
    }
     
    # From Here

    my ($rel_url) = ($url =~ m|^(?:[^:]*\:\/\/)?[^/]*(.*)|);
    $rel_url =~ s|//+|/|g;

    ## Untaint. We have to assume that we can trust the user's setting of
    ## the archive_path, and nothing else is based on user input.
    ($file) = $file =~ /(.+)/s;
     
    my $finfo;
    my $needs_fileinfo = $blog->needs_fileinfo;
    if ($needs_fileinfo) {
        # Clear out all the FileInfo records that might point at the page 
        # we're about to create
        # FYI: if it's an individual entry, we don't use the date as a 
        #      criterion, since this could actually have changed since
        #      the FileInfo was last built. When the date does change, 
        #      the old date-based archive doesn't necessarily get fixed,
        #      but if another comes along it will get corrected
        require MT::FileInfo;
        my @finfos = MT::FileInfo->load({ blog_id => $blog->id,
                                          ($at eq 'Category') ?
                                              (category_id =>
                                               $category->id)
                                              : (),
                                          ($at eq 'Individual') ?
                                              (entry_id => $entry->id) :
                                          (($at ne 'Category') && ($at ne 'Individual')) ?
                                              (startdate => $start) : (),
                                          archive_type => $at,
                                          templatemap_id => $map->id,
                                        });

        if ((scalar @finfos == 1) && ($finfos[0]->file_path eq $file) && (($finfos[0]->url || '') eq $rel_url) && ($finfos[0]->template_id == $map->template_id)) {
            # if the shoe fits, wear it
            $finfo = $finfos[0];
        } else {
            # if the shoe don't fit, remove all shoes and create the perfect shoe
            foreach (@finfos) { $_->remove(); }
            
            $finfo = MT::FileInfo->set_info_for_url($rel_url, $file, $at,
                         { Blog => $blog->id,
                           TemplateMap => $map->id,
                           Template => $map->template_id,
                           ($at eq 'Individual' && $entry)
                               ? (Entry => $entry->id): (),
                           StartDate => $start,
                           ($at eq 'Category' && $category)
                               ? (Category => $category->id) : (),
                         })
                || die "Couldn't create FileInfo because " . MT::FileInfo->errstr();
        }

        # If you rebuild when you've just switched to dynamic pages,
        # we move the file that might be there so that the custom
        # 404 will be triggered.
        if ($tmpl->build_dynamic) {
            rename($finfo->file_path, # is this just $file ?
                   $finfo->file_path . '.static');
            $finfo->virtual(1); $finfo->save();
        }
    }

    return 1 if ($tmpl->build_dynamic);
    return 1 if ($at eq 'Individual' && $entry && $entry->status != MT::Entry::RELEASE());
    if ($finfo) { $finfo->virtual(0); $finfo->save(); }

    return 1 unless ( $build_static &&
         MT->run_callbacks('BuildFileFilter', Context => $ctx,
                           ArchiveType => $at, TemplateMap => $map, 
                           Blog => $blog, Entry => $entry,
                           FileInfo => $finfo, File => $file,
                           Template => $tmpl,
                           PeriodStart => $start, Category => $category));

    my $html = undef;
    $ctx->stash('blog', $blog);
    $html = $tmpl->build($ctx, $cond);
    defined($html) or
        return $mt->error(($category ?
                           MT->translate("Building category '[_1]' failed: [_2]",
                                         $category->id, $tmpl->errstr) :
                           $entry ?
                           MT->translate("Building entry '[_1]' failed: [_2]",
                                         $entry->title, $tmpl->errstr):
                           MT->translate("Building date-based archive '[_1]' failed: [_2]", $at . $start, $tmpl->errstr)));
    my $orig_html = $html;
    MT->run_callbacks('BuildPage', Context => $ctx,
              ArchiveType => $at, TemplateMap => $map,
              Blog => $blog, Entry => $entry, FileInfo => $finfo,
              PeriodStart => $start, Category => $category,
              RawContent => \$orig_html, Content => \$html,
              BuildResult => \$orig_html,
              Template => $tmpl,
              File => $file);
    ## First check whether the content is actually
    ## changed. If not, we won't update the published
    ## file, so as not to modify the mtime.  
    return 1 unless $fmgr->content_is_updated($file, \$html);
    
    ## Determine if we need to build directory structure,
    ## and build it if we do. DirUmask determines
    ## directory permissions.
    require File::Spec;
    my $path = dirname($file);
    $path =~ s!/$!! unless $path eq '/';  ## OS X doesn't like / at the end in mkdir().
    unless ($fmgr->exists($path)) {
        $fmgr->mkpath($path)
            or return $mt->trans_error("Error making path '[_1]': [_2]",
                                       $path, $fmgr->errstr);
    }
    
    ## By default we write all data to temp files, then rename
    ## the temp files to the real files (an atomic
    ## operation). Some users don't like this (requires too
    ## liberal directory permissions). So we have a config
    ## option to turn it off (NoTempFiles).
    my $use_temp_files = !$mt->{NoTempFiles};
    my $temp_file = $use_temp_files ? "$file.new" : $file;
    defined($fmgr->put_data($html, $temp_file))
        or return $mt->trans_error("Writing to '[_1]' failed: [_2]",
                                   $temp_file, $fmgr->errstr);
    if ($use_temp_files) {
        $fmgr->rename($temp_file, $file)
            or return $mt->trans_error("Renaming tempfile '[_1]' failed: [_2]",
                                       $temp_file, $fmgr->errstr);
    }
    MT->run_callbacks('BuildFile', Context => $ctx,
                      ArchiveType => $at, TemplateMap => $map,
                      FileInfo => $finfo, Blog => $blog,
                      Entry => $entry, PeriodStart => $start,
                      RawContent => \$orig_html, Content => \$html,
                      BuildResult => \$orig_html,
                      Template => $tmpl,
                      Category => $category, File => $file);

    1;
}

sub rebuild_indexes {
    my $mt = shift;
    my %param = @_;
    require MT::Template;
    require MT::Template::Context;
    require MT::Entry;
    my $blog;
    unless ($blog = $param{Blog}) {
        my $blog_id = $param{BlogID};
        $blog = MT::Blog->load($blog_id, {cached_ok=>1}) or
            return $mt->error(MT->translate("Load of blog '[_1]' failed: [_2]",
                $blog_id, MT::Blog->errstr));
    }
    my $tmpl = $param{Template};
    unless ($blog) {
        $blog = MT::Blog->load($tmpl->blog_id, {cached_ok=>1});
    }
    return 1 if $blog->is_dynamic;
    my $iter;
    if ($tmpl) {
        my $i = 0;
        $iter = sub { $i++ < 1 ? $tmpl : undef };
    } else {
        $iter = MT::Template->load_iter({ type => 'index',
            blog_id => $blog->id });
    }
    local *FH;
    my $site_root = $blog->site_path;
    return $mt->error(MT->translate("You did not set your Local Site Path"))
        unless $site_root;
    my $fmgr = $blog->file_mgr;
    while (my $tmpl = $iter->()) {
        ## Skip index templates that the user has designated not to be
        ## rebuilt automatically. We need to do the defined-ness check
        ## because we added the flag in 2.01, and for templates saved
        ## before that time, the rebuild_me flag will be undefined. But
        ## we assume that these templates should be rebuilt, since that
        ## was the previous behavior.
        ## Note that dynamic templates do need to be "rebuilt"--the
        ## FileInfo table needs to be maintained.
        if (!$tmpl->build_dynamic && !$param{Force}) {
            next if (defined $tmpl->rebuild_me && !$tmpl->rebuild_me);
        }
        my $file = $tmpl->outfile
            or return $mt->error(MT->translate(
                "Template '[_1]' does not have an Output File.", $tmpl->name));
        my $url = join('/', $blog->site_url, $file);
        unless (File::Spec->file_name_is_absolute($file)) {
            $file = File::Spec->catfile($site_root, $file);
        }
        # Everything from here out is identical with rebuild_file
        my ($rel_url) = ($url =~ m|^(?:[^:]*\:\/\/)?[^/]*(.*)|);
        $rel_url =~ s|//+|/|g;
        ## Untaint. We have to assume that we can trust the user's setting of
        ## the site_path and the template outfile.
        ($file) = $file =~ /(.+)/s;
        my $finfo;
        my $needs_fileinfo = $blog->needs_fileinfo;
        if ($needs_fileinfo) {
            require MT::FileInfo;
            my @finfos = MT::FileInfo->load({blog_id => $tmpl->blog_id,
                                             template_id => $tmpl->id});
            if ((scalar @finfos == 1) && ($finfos[0]->file_path eq $file) && (($finfos[0]->url || '') eq $rel_url)) {
                $finfo = $finfos[0];
            } else {
                foreach ( @finfos ) { $_->remove(); }
                $finfo = MT::FileInfo->set_info_for_url($rel_url, $file, 'index',
                                                        { Blog => $tmpl->blog_id,
                                                          Template => $tmpl->id,
                                                      })
                    || die "Couldn't create FileInfo because " . 
                           MT::FileInfo->errstr;
            }
            if ($tmpl->build_dynamic) {
                rename($file, $file . ".static");
                $finfo->virtual(1); $finfo->save(); #?
            }
        }

        next if ($tmpl->build_dynamic);

        if ($finfo) { $finfo->virtual(0); $finfo->save(); } #?

        my $ctx = MT::Template::Context->new;
        next unless (MT->run_callbacks('BuildFileFilter',
                                           Context => $ctx,
                                           ArchiveType => 'index',
                                           Blog => $blog, FileInfo => $finfo,
                                           Template => $tmpl,
                                           File => $file));
        $ctx->stash('blog', $blog);
        my $html = $tmpl->build($ctx);
        return $mt->error( $tmpl->errstr ) unless defined $html;
        
        my $orig_html = $html;
        MT->run_callbacks('BuildPage', Context => $ctx,
                Blog => $blog, FileInfo => $finfo,
                ArchiveType => 'index',
                RawContent => \$orig_html, Content => \$html,
                BuildResult => \$orig_html,
                Template => $tmpl,
                File => $file);

        ## First check whether the content is actually changed. If not,
        ## we won't update the published file, so as not to modify the mtime.
        next unless $fmgr->content_is_updated($file, \$html);
        
        ## Determine if we need to build directory structure,
        ## and build it if we do. DirUmask determines
        ## directory permissions.
        require File::Spec;
        my $path = dirname($file);
        $path =~ s!/$!! unless $path eq '/';  ## OS X doesn't like / at the end in mkdir().
        unless ($fmgr->exists($path)) {
            $fmgr->mkpath($path)
                or return $mt->trans_error("Error making path '[_1]': [_2]",
                                           $path, $fmgr->errstr);
        }

        ## Update the published file.
        my $use_temp_files = !$mt->{NoTempFiles};
        my $temp_file = $use_temp_files ? "$file.new" : $file;
        defined($fmgr->put_data($html, $temp_file))
            or return $mt->trans_error("Writing to '[_1]' failed: [_2]",
                                       $temp_file, $fmgr->errstr);
        if ($use_temp_files) {
            $fmgr->rename($temp_file, $file)
                or return $mt->trans_error("Renaming tempfile '[_1]' failed: [_2]",
                                           $temp_file, $fmgr->errstr);
        }
        MT->run_callbacks('BuildFile', Context => $ctx,
                          ArchiveType => 'index',
                          FileInfo => $finfo, Blog => $blog,
                          RawContent => \$orig_html, Content => \$html,
                          BuildResult => \$orig_html,
                          Template => $tmpl,
                          File => $file);
    }
    1;
}

sub trans_error {
    my $this = shift;
    return $this->error(MT->translate(@_));
}

sub publish_future_posts {
    my $this = shift;

    require MT::Blog;
    require MT::Entry;
    require MT::Util;
    my $mt = MT->instance;
    my $total_changed = 0;
    for my $blog (MT::Blog->load) {
        my @ts = MT::Util::offset_time_list(time, $blog);
        my $now = sprintf "%04d%02d%02d%02d%02d%02d",
                          $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
        my $iter = MT::Entry->load_iter({blog_id => $blog->id,
                                         status => MT::Entry::FUTURE()},
                                        {'sort' => 'created_on',
                                         direction => 'descend'});
        my @queue;
        while (my $entry = $iter->()) {
            push @queue, $entry->id if $entry->created_on le $now;
        }

        my $changed = 0;
        my @results;
        my %rebuild_queue;
        my %ping_queue;
        foreach my $entry_id (@queue) {
            my $entry = MT::Entry->load($entry_id);
            $entry->status(MT::Entry::RELEASE());
            $entry->save
                or die $entry->errstr;

            $rebuild_queue{$entry->id} = $entry;
            $ping_queue{$entry->id} = 1;
            my $n = $entry->next(1); 
            $rebuild_queue{$n->id} = $n if $n;
            my $p = $entry->previous(1);
            $rebuild_queue{$p->id} = $p if $p;
            $changed++;
            $total_changed++;
        }
        if ($changed) {
            my %rebuilt_okay;
            my $rebuilt;
            eval {
                foreach my $id (keys %rebuild_queue) {
                    my $entry = $rebuild_queue{$id};
                    $mt->rebuild_entry( Entry => $entry, Blog => $blog )
                        or die $mt->errstr;
                    $mt->rebuild_entry( Entry => $entry, Blog => $blog )
                        or die $mt->errstr;
                    $rebuilt_okay{$id} = 1;
                    if ($ping_queue{$id}) {
                        $mt->ping_and_save( Entry => $entry, Blog => $blog );
                    }
                    $rebuilt++;
                }
                $mt->rebuild_indexes( Blog => $blog )
                    or die $mt->errstr;
            };
            if ($@) {
                # a fatal error occured while processing the rebuild
                # step. LOG the error and revert the entry/entries:
                require MT::Log;
                $mt->log({
                    message => $mt->translate("An error occurred while rebuilding to publish scheduled posts: [_1]", $@),
                    class => "system",
                    blog_id => $blog->id,
                    level => MT::Log::ERROR()
                });
                foreach my $id (@queue) {
                    next if exists $rebuilt_okay{$id};
                    my $e = $rebuild_queue{$id};
                    next unless $e;
                    $e->status(MT::Entry::FUTURE());
                    $e->save or die $e->errstr;
                }
            }
        }
    }
    $total_changed > 0 ? 1 : 0;
}

sub remove_entry_archive_file {
    my $mt = shift;
    my %param = @_;

    my $entry = $param{Entry};
    my $at = $param{ArchiveType} || 'Individual';
    my $cat = $param{Category};

    require MT::TemplateMap;
    my $blog = $param{Blog};
    unless ($blog) {
        if ($entry) {
            $blog = $entry->blog;
        } elsif ($cat) {
            require MT::Blog;
            $blog = MT::Blog->load($cat->blog_id);
        }
    }
    my @map = MT::TemplateMap->load({
        archive_type => $at,
        blog_id => $blog->id,
        $param{TemplateID} ? (template_id => $param{TemplateID}) : (),
    });
    return 1 unless @map;

    my $fmgr = $blog->file_mgr;
    my $arch_root = $blog->archive_path;

    require File::Spec;
    for my $map (@map) {
        my $file = archive_file_for($entry, $blog, $at, $cat, $map);
        $file = File::Spec->catfile($arch_root, $file);
        if (!defined($file)) {
            return $mt->error(MT->translate($blog->errstr()));
        }
        $fmgr->delete($file);
    }
    1;
}

1;

__END__

=head1 NAME

MT::WeblogPublisher - A module for expressing weblog templates and
content into a specific URL structure

=head1 SYNOPSIS

    use MT::WeblogPublisher;
    my $pub = MT::WeblogPublisher->new;
    $pub->rebuild(Blog => $blog, ArchiveType => "Individual");

=head1 DESCRIPTION

mmmm mmmm mhmmmm.

=head1 METHODS

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
"this" entry has changed. When the created_on field of an entry is
changed, its new neighbors (Previous and Next) need to be rebuilt as
well as its former neighbors (OldPrevious and OldNext).

=item * NoStatic

When this value is true, it acts as a hint to the rebuilding routine
that static output files need not be rebuilt; the "rebuild" operation
is just to update the bookkeeping that supports dynamic rebuilds.

=back

=head2 $mt->rebuild_file($blog, $archive_root, $map, $archive_type, $ctx, \%cond, $build_static, %specifier)

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

I<%specifier> is a hash that uniquely identifies the specific instance
of the given archive type. That is, for a category archive page it
identifies the category; for a date-based archive page it identifies
which time period is covered by the page; for an individual archive it
identifies the entry. I<%specifier> should contain just one of these
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

=cut