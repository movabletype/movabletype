# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Template;
use strict;

use vars qw( %TYPES );
%TYPES = (
    'index' => 'Index',
    archive => 'Archive',
    category => 'Category Archive',
    individual => 'Individual',
    comments => 'Comment Listing',
    pings => 'Ping Listing',
    comment_preview => 'Comment Preview',
    comment_error => 'Comment Error',
    comment_pending => 'Comment Pending',
    custom => 'Custom',
);

my $resync_to_db;

use MT::Object;
@MT::Template::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer not null',
        'name' => 'string(50) not null',
        'type' => 'string(25) not null',
        'outfile' => 'string(255)',
        'text' => 'text',
        'linked_file' => 'string(255)',
        'linked_file_mtime' => 'string(10)',
        'linked_file_size' => 'integer',
        'rebuild_me' => 'boolean',
        'build_dynamic' => 'boolean',
    },
    indexes => {
        blog_id => 1,
        name => 1,
        type => 1,
        build_dynamic => 1,
    },
    defaults => {
        'rebuild_me' => 1,
        'build_dynamic' => 0,
    },
    child_of => 'MT::Blog',
    child_classes => [ 'MT::TemplateMap', 'MT::FileInfo' ],
    audit => 1,
    datasource => 'template',
    primary_key => 'id',
});

use MT::Builder;
use MT::Blog;
use MT::ConfigMgr;
use File::Spec;

sub build {
    my $tmpl = shift;
    my($ctx, $cond) = @_;
    my $tokens;
    my $build = MT::Builder->new;
    unless ($tokens = $tmpl->{__tokens}) {
        my $text = $tmpl->text;
        $tokens = $tmpl->{__tokens} = $build->compile($ctx, $text) or
            return $tmpl->error(MT->translate(
                "Parse error in template '[_1]': [_2]",
                $tmpl->name, $build->errstr));
    }
    my $blog_id = $tmpl->blog_id;   ## ??
    $ctx->stash('blog_id', $blog_id);
    my $blog = $ctx->stash('blog');
    unless ($blog) {
        $blog = MT::Blog->load($blog_id) or
            return $tmpl->error(MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id, MT::Blog->errstr ));
        $ctx->stash('blog', $blog);
    }
    MT::ConfigMgr->instance->TimeOffset($blog->server_offset);
    defined(my $res = $build->build($ctx, $tokens, $cond)) or
        return $tmpl->error(MT->translate(
            "Build error in template '[_1]': [_2]",
            $tmpl->name, $build->errstr));
    $res;
}

sub save {
    my $tmpl = shift;
    if ($tmpl->linked_file) {
        $tmpl->_sync_to_disk($tmpl->SUPER::text) or return;
    }
    $tmpl->{needs_db_sync} = 0;
    $tmpl->SUPER::save;
}

sub blog {
    my $this = shift;
    return $this->{__blog} if $this->{__blog};
    return $this->{__blog} = MT::Blog->load($this->blog_id, {cached_ok=>1});
}

sub set_values {
    my $tmpl = shift;
    my ($cols) = @_;
    if (exists $cols->{text}) {
        # The text column of the MT::Template object can be associated
        # with a physical file. When loading the record data from the
        # database, we should observe whether or not it is in sync with
        # the physical file. This logic handles the case where the
        # record is loaded through the MT::ObjectDriver and should
        # not apply for any other use of $tmpl->set_values, since those
        # should all be explicitly setting the template text.
        my @info = caller();
        if ($info[0] =~ m/^MT::ObjectDriver::/) {
            if ($cols->{linked_file}) {
                my %local_cols = %$cols;
                delete $local_cols{text};
                $tmpl->SUPER::set_values(\%local_cols);
                my $sync_text = $tmpl->text();
                if (!defined $sync_text) {
                    $tmpl->text($cols->{text});
                }
                return;
            }
        }
    }
    $tmpl->SUPER::set_values(@_);
}

sub text {
    my $tmpl = shift;
    my $text = $tmpl->SUPER::text(@_);
    $tmpl->{needs_db_sync} = 0;
    unless (@_) {
        if ($tmpl->linked_file) {
            if (my $res = $tmpl->_sync_from_disk) {
                $text = $res;
                $tmpl->SUPER::text($text);
                ## We used to save the template here; now we don't, because
                ## it causes deadlock (the DB is locked from loading the
                ## template, so saving would try to write-lock it).
                if (!defined $resync_to_db) {
                    $resync_to_db = {};
                    MT->add_callback('TakeDown', 9, undef, \&_resync_to_db);
                }
                $resync_to_db->{$tmpl->id} = $tmpl;
                $tmpl->{needs_db_sync} = 1;
            }
        }
        undef $tmpl->{__tokens}; # reset any cached tokens
    }
    $text;
}

sub _resync_to_db {
    return unless defined $resync_to_db;
    return unless %$resync_to_db;
    foreach my $tmpl_id (keys %$resync_to_db) {
        my $tmpl = $resync_to_db->{$tmpl_id};
        next unless $tmpl->{needs_db_sync};
        $tmpl->save;
    }
    $resync_to_db = {};
}

sub _sync_from_disk {
    my $tmpl = shift;
    my $lfile = $tmpl->linked_file;
    unless (File::Spec->file_name_is_absolute($lfile)) {
        my $blog = MT::Blog->load($tmpl->blog_id);
        $lfile = File::Spec->catfile($blog->site_path, $lfile);
    }
    return unless -e $lfile;
    my($size, $mtime) = (stat _)[7,9];
    return if $size == $tmpl->linked_file_size &&
              $mtime == $tmpl->linked_file_mtime;
    local *FH;
    open FH, $lfile or return;
    my $c; do { local $/; $c = <FH> };
    close FH;
    $tmpl->linked_file_size($size);
    $tmpl->linked_file_mtime($mtime);
    $c;
}

sub _sync_to_disk {
    my $tmpl = shift;
    my($text) = @_;
    my $lfile = $tmpl->linked_file;
    if (MT::ConfigMgr->instance->SafeMode) {
        ## Check for a set of extensions that aren't allowed.
        for my $ext (qw( pl pm cgi cfg )) {
            if ($lfile =~ /\.$ext$/) {
                return $tmpl->error(MT->translate(
                    "You cannot use a [_1] extension for a linked file.",
                    ".$ext"));
            }
        }
    }
    unless (File::Spec->file_name_is_absolute($lfile)) {
        my $blog = MT::Blog->load($tmpl->blog_id);
        $lfile = File::Spec->catfile($blog->site_path, $lfile);
    }
    local *FH;
    ## If the linked file already exists, and there is no template text
    ## (empty textarea, etc.), then we read the template text from the
    ## linked file, assuming that it should not be overwritten. If the
    ## file does not already exist, or if there is template text, assume
    ## that we should update the linked file.
    if (-e $lfile && !$tmpl->SUPER::text) {
        open FH, $lfile or return;
        do { local $/; $tmpl->SUPER::text(<FH>) };
        close FH;
    } else {
        my $cfg = MT::ConfigMgr->instance;
        my $umask = oct $cfg->HTMLUmask;
        my $old = umask($umask);
        ## Untaint. We assume that the user knows what he/she is doing,
        ## and allow anything.
        ($lfile) = $lfile =~ /(.+)/s;
        open FH, ">$lfile" or
            return $tmpl->error(MT->translate(
                "Opening linked file '[_1]' failed: [_2]", $lfile, "$!" ));
        print FH $text;
        close FH;
        umask($old);
    }
    my($size, $mtime) = (stat $lfile)[7,9];
    $tmpl->linked_file_size($size);
    $tmpl->linked_file_mtime($mtime);
    1;
}

sub remove {
    my $tmpl = shift;
    $tmpl->remove_children({ key => 'template_id' });
    $tmpl->SUPER::remove;
}

sub published_url {
    my $tmpl = shift;

    return undef unless $tmpl->outfile;
    return undef unless ($tmpl->type eq 'index');
    
    my $blog = $tmpl->blog;
    my $site_url = $blog->site_url;
    $site_url .= '/' if $site_url !~ m!/$!;
    my $url = $site_url . $tmpl->outfile;

    if ($tmpl->build_dynamic) {
        require MT::FileInfo;
        my @finfos = MT::FileInfo->load({blog_id => $tmpl->blog_id,
                                         template_id => $tmpl->id});
        if (scalar @finfos == 1) {
            return $url;
        }
    } else {
        my $tmpl_path = File::Spec->catfile($blog->site_path, $tmpl->outfile);
        if (-f $tmpl_path) {
            return $url;
        }
    }
    undef;
}

1;
__END__

=head1 NAME

MT::Template - Movable Type template record

=head1 SYNOPSIS

    use MT::Template;
    my $tmpl = MT::Template->load($tmpl_id);
    defined(my $html = $tmpl->build($ctx))
        or die $tmpl->errstr;

    $tmpl->name('New Template name');
    $tmpl->save
        or die $tmpl->errstr;

=head1 DESCRIPTION

An I<MT::Template> object represents a template in the Movable Type system.
It contains the actual template body, along with metadata used for keeping
the template in sync with a linked file, etc. It also contains the
functionality necessary to build an output file from a generic template.

Linking a template to an external file means that any updates to the template
through the Movable Type CMS will be synced automatically to the file on
disk, and vice versa. This allows authors to edit their templates in an
external editor that supports FTP, which is preferable for users who do not
like editing in textareas.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Template> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

The following methods are unique to the I<MT::Template> interface:

=head2 $tmpl->build($ctx [, \%cond ])

Given a context I<$ctx> (an I<MT::Template::Context> object) and an optional
set of conditions \%cond, builds a template into its output form. The
template is first parsed into a list of tokens, then is interpreted/executed
to generate the final output.

If specified, I<\%cond> should be a reference to a hash with MT tag names
(without the leading C<MT>) as the keys, and boolean flags as the values--the
flags specify whether the template interpreter should include any
conditional containers found in the template body.

Returns the output as a scalar string, C<undef> on error. Because the empty
string C<''> and the value C<0> are both valid return values for this method,
you should check specifically for C<undef>:

    defined(my $html = $tmpl->build($ctx))
        or die $tmpl->errstr;

=head2 $tmpl->published_url

Only applicable if the template is an Index Template, this method returns
the url for the page which is the result of building the index template.
If the template is not of type index, or if the index template has not built
yet (if the template is static), or if the index template does not have
corresponding FileInfo record (if the template is dynamic), this method
returns undef.

=head1 DATA ACCESS METHODS

The I<MT::Template> object holds the following pieces of data. These fields
can be accessed and set using the standard data access methods described in
the I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the template.

=item * blog_id

The numeric ID of the blog to which this template belongs.

=item * name

The name of the template. This should be unique on a per-blog basis, because
templates--particularly template modules, which are stored as regular
templates--are included by name, using C<E<lt>MTIncludeE<gt>>.

=item * type

The type of the template. This can be any of the following values: C<index>,
an Index Template; C<archive>, an Archive Template; C<category>, also an
Archive Template; C<individual>, also an Archive Template; C<comments>, a
Comment Listing Template; C<comment_preview>, a Comment Preview Template;
C<comment_error>, a Comment Error Template; C<popup_image>, an Uploaded Image
Popup Template; or C<custom>, a Template Module.

=item * outfile

The name/path of the output file of this template. This is only applicable
if the template is an Index Template.

=item * text

The body of the template, containing the markup and Movable Type template
tags.

If the template is linked to an external file, the body of the template is
automatically synced between this data field and the external file.

=item * rebuild_me

A boolean flag specifying whether or not the index template will be rebuilt
automatically when rebuilding indexes, rebuilding all, or saving a new entry.

=item * linked_file

The name/path of the file to which this template is linked in the filesystem,
if it is linked.

=item * linked_file_mtime

The last modified time of the linked file. This, along with
I<linked_file_size>, is used to determine whether a file has been updated on
disk, and needs to be re-synced.

=item * linked_file_size

The size of the linked file, in bytes. This, along with I<linked_file_mtime>,
is used to determine whether a file has been updated on disk, and needs to
be re-synced.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * blog_id

=item * name

=item * type

=back

=head1 NOTES

=over 4

=item *

When you remove a template using I<MT::Template::remove>, in addition to
removing the template record, all of the I<MT::TemplateMap> objects
associated with this template will be removed.

=item *

If a template is linked to an external file, I<MT::Template::save> will sync
the template body to disk, and I<MT::Template::text> (the data access method
to retrieve the body of the template) will sync the template body from disk.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
