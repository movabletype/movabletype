# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Template;

use strict;
use base qw( MT::Object );

use constant NODE => 'MT::Template::Node';

our %TYPES = (
    'index' => 'Index',
    archive => 'Archive',
    category => 'Category Archive',
    individual => 'Individual',
    page => 'Page',
    comments => 'Comment Listing',
    pings => 'Ping Listing',
    comment_preview => 'Comment Preview',
    comment_error => 'Comment Error',
    comment_pending => 'Comment Pending',
    custom => 'Custom',
);

my $resync_to_db;

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer not null',
        'name' => 'string(255) not null',
        'type' => 'string(25) not null',
        'outfile' => 'string(255)',
        'text' => 'text',
        'linked_file' => 'string(255)',
        'linked_file_mtime' => 'string(10)',
        'linked_file_size' => 'integer',
        'rebuild_me' => 'boolean',
        'build_dynamic' => 'boolean',
        'identifier' => 'string(50)',
    },
    indexes => {
        blog_id => 1,
        name => 1,
        type => 1,
        build_dynamic => 1,
        outfile => 1,
        identifier => 1,
    },
    defaults => {
        'rebuild_me' => 1,
        'build_dynamic' => 0,
    },
    meta => 1,
    child_of => 'MT::Blog',
    child_classes => [ 'MT::TemplateMap', 'MT::FileInfo' ],
    audit => 1,
    datasource => 'template',
    primary_key => 'id',
});
__PACKAGE__->install_meta({
    columns => ['last_rebuild_time'],
});
__PACKAGE__->add_trigger('pre_remove' => \&pre_remove_children);

use MT::Builder;
use MT::Blog;
use File::Spec;

sub new {
    my $pkg = shift;
    my (%param) = @_;
    if (my $type = delete $param{type}) {
        if ($type eq 'filename') {
            return $pkg->new_file($param{source}, %param);
        } elsif ($type eq 'scalarref') {
            return $pkg->new_string($param{source}, %param);
        }
    }
    my $tmpl = $pkg->SUPER::new(@_);
    $tmpl->{include_path} = $param{path};
    $tmpl->{include_filter} = $param{filter};
    return $tmpl;
}

sub new_file {
    my $pkg = shift;
    my ($file, %param) = @_;
    my $tmpl = $pkg->new;
    $tmpl->{include_path} = $param{path};
    $tmpl->{include_filter} = $param{filter};
    my $contents = $tmpl->load_file($file);
    if (defined $contents) {
        if ($tmpl->{include_filter}) {
            $tmpl->{include_filter}->(\$contents, $file);
        }
        $tmpl->text($contents);
    }
    return $tmpl;
}

sub new_string {
    my $pkg = shift;
    my ($str, %param) = @_;
        my $tmpl = $pkg->new;
    $tmpl->{include_path} = $param{path};
    $tmpl->{include_filter} = $param{filter};
    if (ref($str) && defined($$str)) {
        if ($tmpl->{include_filter}) {
            $tmpl->{include_filter}->($str);
        }
        $tmpl->text($$str);
    }
    return $tmpl;
}

sub load_file {
    my $tmpl = shift;
    my ($file) = @_;
    unless (File::Spec->file_name_is_absolute($file)) {
        my @paths = @{ $tmpl->{include_path} || [] };
        foreach my $path (@paths) {
            my $test_file = File::Spec->catfile($path, $file);
            $file = $test_file, last if -f $test_file;
        }
    }
    return $tmpl->trans_error("File not found: [_1]", $file) unless -e $file;
    local *FH;
    open FH, $file or return;
    my $c;
    do { local $/; $c = <FH> };
    close FH;
    return $c;
}

sub context {
    my $tmpl = shift;
    require MT::Template::Context;
    my $ctx = $tmpl->{context} ||= MT::Template::Context->new;
    # FIXME: Circular reference... problem?
    $ctx->stash('template', $tmpl);
    return $ctx;
}

sub param {
    my $tmpl = shift;
    my $ctx = $tmpl->context;
    if (@_ == 1) {
        if (ref($_[0]) eq 'HASH') {
            $ctx->var($_, $_[0]->{$_}) for keys %{ $_[0] };
        } else {
            return $ctx->var($_[0]);
        }
    } elsif (@_ == 2) {
        $ctx->var($_[0], $_[1]);
    } else {
        return $ctx->{__stash}{vars};
    }
}

sub clear_params {
    my $tmpl = shift;
    my $ctx = $tmpl->context;
    %{$ctx->{__stash}{vars}} = ();
}

sub build {
    my $tmpl = shift;
    my($ctx, $cond) = @_;
    $ctx ||= $tmpl->context;

    local $ctx->{__stash}{template} = $tmpl;
    my $tokens;
    my $build = MT::Builder->new;
    unless ($tokens = $tmpl->{__tokens}) {
        my $text = $tmpl->text;
        $tokens = $tmpl->{__tokens} = $build->compile($ctx, $text, { uncompiled => 0 }) or
            return $tmpl->error(MT->translate(
                "Parse error in template '[_1]': [_2]",
                $tmpl->name, $build->errstr));
    }
    if (my $blog_id = $tmpl->blog_id) {
        $ctx->stash('blog_id', $blog_id);
        my $blog = $ctx->stash('blog');
        unless ($blog) {
            $blog = MT::Blog->load($blog_id) or
                return $tmpl->error(MT->translate(
                    "Load of blog '[_1]' failed: [_2]", $blog_id, MT::Blog->errstr ));
            $ctx->stash('blog', $blog);
        } else {
            $ctx->stash('blog_id', $blog->id);
        }
        MT->config->TimeOffset($blog->server_offset);
    }
    defined(my $res = $build->build($ctx, $tokens, $cond)) or
        return $tmpl->error(MT->translate(
            "Build error in template '[_1]': [_2]",
            $tmpl->name || $tmpl->{__file}, $build->errstr));
    return $res;
}

sub output {
    my $tmpl = shift;
    my ($param) = @_;
    $tmpl->param($param) if $param;
    return $tmpl->build();
}

sub save {
    my $tmpl = shift;
    my $existing = MT::Template->load({ name => $tmpl->name, blog_id => $tmpl->blog_id });
    if ($existing && (!$tmpl->id || ($tmpl->id && ($existing->id ne $tmpl->id)))
        && ($existing->type eq $tmpl->type)) {
        return $tmpl->error(MT->translate('Template with the same name already exists in this blog.'));
    }
    if ($tmpl->linked_file) {
        $tmpl->_sync_to_disk($tmpl->SUPER::text) or return;
    }
    $tmpl->{needs_db_sync} = 0;
    if ((!$tmpl->id) && (my $blog = $tmpl->blog)) {
        my $dcty = $blog->custom_dynamic_templates;
        if ($dcty eq 'all') {
            if (('index' eq $tmpl->type) || ('archive' eq $tmpl->type) ||
                ('individual' eq $tmpl->type) || ('page' eq $tmpl->type) ||
                    ('category' eq $tmpl->type)) {
                $tmpl->build_dynamic(1);
            }
        } elsif (($dcty eq 'archives') && ('archive' eq $tmpl->type)) {
            $tmpl->build_dynamic(1);
        }
    }
    $tmpl->SUPER::save;
}

sub blog {
    my $this = shift;
    return $this->{__blog} if $this->{__blog};
    return $this->{__blog} = MT::Blog->load($this->blog_id, {cached_ok=>1});
}

sub set_values_internal {
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
                $tmpl->SUPER::set_values_internal(\%local_cols);
                my $sync_text = $tmpl->text();
                if (!defined $sync_text) {
                    $tmpl->text($cols->{text});
                }
                return;
            }
        }
    }
    $tmpl->SUPER::set_values_internal(@_);
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
        $tmpl->reset_tokens;
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
    my $cfg = MT->config;
    if ($cfg->SafeMode) {
        ## Check for a set of extensions that aren't allowed.
        for my $ext (qw( pl pm cgi cfg )) {
            if ($lfile =~ /\.$ext$/i) {
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

sub compile {
    my $tmpl = shift;
    require MT::Builder;
    my $b = new MT::Builder;
    $b->compile($tmpl) or return $tmpl->error($b->errstr);
    return $tmpl->{__tokens};
}

sub reset_tokens {
    my $tmpl = shift;
    $tmpl->{__tokens} = undef;
    $tmpl->{__ids} = undef;
}

sub token_ids {
    my $tmpl = shift;
    if (@_) {
        return $tmpl->{__ids} = shift;
    } else {
        $tmpl->compile unless $tmpl->{__ids};
        return $tmpl->{__ids};
    }
}

sub tokens {
    my $tmpl = shift;
    if (@_) {
        return bless( $tmpl->{__tokens} = shift ), 'MT::Template::Tokens';
    } else {
        return bless( $tmpl->{__tokens} ||= $tmpl->compile ), 'MT::Template::Tokens';
    }
}

sub published_url {
    my $tmpl = shift;

    return undef unless $tmpl->outfile;
    return undef unless ($tmpl->type eq 'index');
    
    my $blog = $tmpl->blog;
    return undef unless $blog;
    my $site_url = $blog->site_url || '';
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
        my $site_path = $blog->site_path || '';
        my $tmpl_path = File::Spec->catfile($site_path, $tmpl->outfile);
        if (-f $tmpl_path) {
            return $url;
        }
    }
    undef;
}

sub pre_remove_children {
    my $tmpl = shift;
    $tmpl->remove_children({ key => 'template_id' });
}

# Some DOM-inspired methods (replicating the interface, so it's more
# familiar to those who know DOM)
sub getElementsByTagName {
    my $tmpl = shift;
    return MT::Template::Tokens::getElementsByTagName($tmpl->tokens, @_);
}

sub getElementsByName {
    my $tmpl = shift;
    return MT::Template::Tokens::getElementsByName($tmpl->tokens, @_);
}

sub getElementById {
    my $tmpl = shift;
    my ($id) = @_;
    if (my $node = $tmpl->token_ids->{$id}) {
        return bless $node, NODE;
    }
    undef;
}

sub createElement {
    my $tmpl = shift;
    my ($tag, $attr) = @_;
    return bless [ $tag, $attr, undef, undef, undef ], NODE;
}

sub insertAfter {
    my $tmpl = shift;
    my ($node1, $node2) = @_;
    my $parent_array = $node1->[5];
    for (my $i = 0; $i < scalar @$parent_array; $i++) {
        if ($parent_array->[$i] == $node1) {
            splice(@$parent_array, $i + 1, 0, $node2);
            return 1;
        }
    }
    return 0;
}

sub insertBefore {
    my $tmpl = shift;
    my ($node1, $node2) = @_;
    my $parent_array = $node1->[5];
    for (my $i = 0; $i < scalar @$parent_array; $i++) {
        if ($parent_array->[$i] == $node1) {
            splice(@$parent_array, $i, 0, $node2);
            return 1;
        }
    }
    return 0;
}

# Alias to perl_function_names for those that may prefer that.
# *get_elements_by_tag_name = \&getElementsByTagName;
# *get_elements_by_name = \&getElementsByName;
# *get_element_by_id = \&getElementById;
# *create_element = \&createElement;

# functionality for individual nodes gathered by DOM-like query operations.

package MT::Template::Tokens;

use strict;

sub getElementsByTagName {
    my ($tokens, $name) = @_;
    my @list;
    $name = lc $name;
    foreach my $t (@$tokens) {
        if (lc $t->[0] eq $name) {
            push @list, $t;
        }
        if ($t->[2]) {
            my $subt = getElementsByTagName($t->[2], $name);
            push @list, @$subt if $subt;
        }
    }
    scalar @list ? \@list : undef;
}

sub getElementsByName {
    my ($tokens, $name) = @_;
    my @list;
    $name = lc $name;
    foreach my $t (@$tokens) {
        if ((ref($t->[1]) eq 'HASH') && (lc ($t->[1]{'name'} || '') eq $name)) {
            push @list, $t;
        }
        if ($t->[2]) {
            my $subt = getElementsByName($t->[2], $name);
            push @list, @$subt if $subt;
        }
    }
    scalar @list ? \@list : undef;
}

package MT::Template::Node;

use strict;

sub innerHTML {
    my $node = shift;
    if (@_) {
        my ($text) = @_;
        $node->[3] = $text;
        my $builder = new MT::Builder;
        my $ctx = MT::Template::Context->new;
        $node->[2] = $builder->compile($ctx, $text);
    }
    return $node->[3];
}

# TBD: what about new nodes that are added with id elements?
sub appendChild {
    my $node = shift;
    my ($new_node) = @_;
    my $nodes = $node->[2] ||= [];
    my $str = $node->[3];
    push @$nodes, $new_node;
    $node->[3] = '' unless defined $node->[3];
    $node->[3] .= $new_node->[3];
}

sub insertAfter {
    my $node1 = shift;
    my ($node2) = @_;
    my $parent_array = $node1->[5];
    for (my $i = 0; $i < scalar @$parent_array; $i++) {
        if ($parent_array->[$i] == $node1) {
            splice(@$parent_array, $i + 1, 0, $node2);
            return 1;
        }
    }
    return 0;
}

sub insertBefore {
    my $node1 = shift;
    my ($node2) = @_;
    my $parent_array = $node1->[5];
    for (my $i = 0; $i < scalar @$parent_array; $i++) {
        if ($parent_array->[$i] == $node1) {
            splice(@$parent_array, $i, 0, $node2);
            return 1;
        }
    }
    return 0;
}

sub removeChild {
    my $node = shift;
}

*inner_html = \&innerHTML;
*append_child = \&appendChild;
*insert_before = \&insertBefore;
*remove_child = \&removeChild;

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

=head2 $tmpl->blog

Returns the I<MT::Blog> object associated with the template.

=head2 $tmpl->save

Saves the template and if linked to a physical file, updates the file.

=head2 $tmpl->remove

Removes the template object and any related objects in I<MT::TemplateMap>
and I<MT::FileInfo>.

=head2 $tmpl->set_values

Updates the values of the C<$tmpl> object. When this is called through
the I<MT::ObjectDriver> classes (upon loading a template object), and if
the template is linked to a file, it will also load the contents of that
file, setting the 'text' property.

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
