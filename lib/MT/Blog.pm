# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Blog;
use strict;

use MT::FileMgr;
use MT::Util;

use MT::Object;
@MT::Blog::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'name' => 'string(255) not null',
        'description' => 'text',
        'archive_type' => 'string(255)',
        'archive_type_preferred' => 'string(25)',
        'site_path' => 'string(255)',
        'site_url' => 'string(255)',
        'days_on_index' => 'integer',
        'entries_on_index' => 'integer',
        'file_extension' => 'string(10)',
        'email_new_comments' => 'boolean',
        'allow_comment_html' => 'boolean',
        'autolink_urls' => 'boolean',
        'sort_order_posts' => 'string(8)',
        'sort_order_comments' => 'string(8)',
        'allow_comments_default' => 'boolean',
        'server_offset' => 'float',
        'convert_paras' => 'string(30)',
        'convert_paras_comments' => 'string(30)',
        'allow_pings_default' => 'boolean',
        'status_default' => 'smallint',
        'allow_anon_comments' => 'boolean',
        'words_in_excerpt' => 'smallint',
        'moderate_unreg_comments' => 'boolean',
        'moderate_pings' => 'boolean',
        'allow_unreg_comments' => 'boolean',
        'allow_reg_comments' => 'boolean',
        'allow_pings' => 'boolean',
        'manual_approve_commenters' => 'boolean',
        'require_comment_emails' => 'boolean',
        'junk_folder_expiry' => 'integer',
        'ping_weblogs' => 'boolean',
        'mt_update_key' => 'string(30)',
        'language' => 'string(5)',
        'welcome_msg' => 'text',
        'google_api_key' => 'string(32)',
        'email_new_pings' => 'boolean',
        'ping_blogs' => 'boolean',
        'ping_technorati' => 'boolean',
        'ping_others' => 'text',
        'autodiscover_links' => 'boolean',
        'sanitize_spec' => 'string(255)',
        'cc_license' => 'string(255)',
        'is_dynamic' => 'boolean',
        'remote_auth_token' => 'string(50)',
        'children_modified_on' => 'datetime',
        'custom_dynamic_templates' => 'string(25)',
        'junk_score_threshold' => 'float',
        'internal_autodiscovery' => 'boolean',
        'basename_limit' => 'smallint',
## Have to keep these around for use in mt-upgrade.cgi.
        'archive_url' => 'string(255)',
        'archive_path' => 'string(255)',
        'old_style_archive_links' => 'boolean',
        'archive_tmpl_daily' => 'string(255)',
        'archive_tmpl_weekly' => 'string(255)',
        'archive_tmpl_monthly' => 'string(255)',
        'archive_tmpl_category' => 'string(255)',
        'archive_tmpl_individual' => 'string(255)',
    },
    indexes => {
        name => 1,
        children_modified_on => 1,
    },
    defaults => {
        'custom_dynamic_templates' => 'none',
    },
    child_classes => ['MT::Permission', 'MT::Entry',
                      'MT::Template', 'MT::Category',
                      'MT::Notification', 'MT::Log',
                      'MT::PluginData', 'MT::ObjectTag'],
    datasource => 'blog',
    primary_key => 'id',
});

sub set_defaults {
    my $blog = shift;

    $blog->days_on_index(0);
    $blog->entries_on_index(10);
    $blog->words_in_excerpt(40);
    $blog->sort_order_posts('descend');
    $blog->language(MT->config('DefaultLanguage'));
    $blog->sort_order_comments('ascend');
    $blog->file_extension('html');
    $blog->convert_paras(1);
    $blog->allow_unreg_comments(1);
    $blog->allow_reg_comments(1);
    $blog->allow_pings(1);
    $blog->moderate_unreg_comments(MT::Blog::MODERATE_UNTRSTD());
    $blog->moderate_pings(1);
    $blog->require_comment_emails(1);
    $blog->allow_comments_default(1);
    $blog->allow_comment_html(1);
    $blog->autolink_urls(1); 
    $blog->allow_pings_default(1);
    $blog->require_comment_emails(0);
    $blog->convert_paras_comments(1); 
    $blog->email_new_pings(1);
    $blog->email_new_comments(1);
    $blog->sanitize_spec(0);
    $blog->ping_weblogs(0);
    $blog->ping_blogs(0);
    $blog->ping_technorati(0);
    $blog->archive_type('Individual,Monthly,Category');
    $blog->archive_type_preferred('Individual');
    $blog->status_default(1);
    $blog->junk_score_threshold(0);
    $blog->junk_folder_expiry(14); # 14 days
    $blog->custom_dynamic_templates('none');
    $blog->internal_autodiscovery(0);
    $blog->basename_limit(30);
    $blog->server_offset(MT->config('DefaultTimezone') || 0);
    # something far in the future to force dynamic side to read it.
    $blog->children_modified_on('20101231120000');
    $blog;
}

sub needs_fileinfo {
    my $self = shift;
    my $tmpl = $self->custom_dynamic_templates();
    $tmpl && $tmpl ne 'none';
}

sub site_url {
    my $blog = shift;
    if (!@_ && $blog->is_dynamic) {
        my $cfg = MT::ConfigMgr->instance;
        my $path = $cfg->CGIPath;
        $path .= '/' unless $path =~ m!/$!;
        return $path . $cfg->ViewScript . '/' . $blog->id;
    } else {
        return $blog->SUPER::site_url(@_);
    }
}

sub archive_url {
    my $blog = shift;
    if (!@_ && $blog->is_dynamic) {
        $blog->site_url;
    } else {
        $blog->SUPER::archive_url(@_) || $blog->site_url;
    }
}

sub archive_path {
    my $blog = shift;
    $blog->SUPER::archive_path(@_) || $blog->site_path;
}

sub comment_text_filters {
    my $blog = shift;
    my $filters = $blog->convert_paras_comments;
    return [] unless $filters;
    if ($filters eq '1') {
        return [ '__default__' ];
    } else {
        return [ split /\s*,\s*/, $filters ];
    }
}

sub cc_license_url {
    my $cc = $_[0]->cc_license or return '';
    MT::Util::cc_url($cc);
}

sub email_all_comments {
    return $_[0]->email_new_comments == 1;
}

sub email_attn_reqd_comments {
    return $_[0]->email_new_comments == 2;
}

sub email_all_pings {
    return $_[0]->email_new_pings == 1;
}

sub email_attn_reqd_pings {
    return $_[0]->email_new_pings == 2;
}

use constant MODERATE_NONE => 0;
use constant MODERATE_UNAUTHD => 3;
use constant MODERATE_UNTRSTD => 2;
use constant MODERATE_ALL => 1;

sub publish_trusted_commenters {
    !($_[0]->moderate_unreg_comments == MODERATE_ALL);
}

sub publish_authd_untrusted_commenters {
    return $_[0]->moderate_unreg_comments == MODERATE_UNAUTHD
        || $_[0]->moderate_unreg_comments == MODERATE_NONE;
}

sub publish_unauthd_commenters {
    $_[0]->moderate_unreg_comments == MODERATE_NONE;
}

sub file_mgr {
    my $blog = shift;
    unless (exists $blog->{__file_mgr}) {
## xxx need to add remote_host, remote_user, remote_pwd fields
## then pull params from there; if remote_host is defined, we
## assume we are using FTP?
        $blog->{__file_mgr} = MT::FileMgr->new('Local');
    }
    $blog->{__file_mgr};
}

sub remove {
    my $blog = shift;
    $blog->remove_children({ key => 'blog_id'});
    $blog->SUPER::remove;
}

# deprecated: use $blog->remote_auth_token instead
sub effective_remote_auth_token {
    my $blog = shift;
    if (scalar @_) {
        return $blog->remote_auth_token(@_);
    }
    if ($blog->remote_auth_token()) {
        return $blog->remote_auth_token();
    }
    undef;
}

sub accepts_registered_comments {
    $_[0]->allow_reg_comments && $_[0]->effective_remote_auth_token;
}

sub accepts_comments {
    $_[0]->accepts_registered_comments || $_[0]->allow_unreg_comments;
}

sub count_static_templates {
    my $blog = shift;
    my ($archive_type) = @_;
    my $result = 0;
    require MT::TemplateMap;
    my @maps = MT::TemplateMap->load({blog_id => $blog->id,
                                      archive_type => $archive_type});
    return undef unless @maps;
    require MT::Template;
    foreach my $map (@maps) {  
        my $tmpl = MT::Template->load($map->template_id);
        $result++ if !$tmpl->build_dynamic;
    }
    #$result ||= 1 if ($blog->custom_dynamic_templates || '') ne 'custom';
    return $result;
}

sub touch {
    my $blog = shift;
    my ($s,$m,$h,$d,$mo,$y) = localtime(time);
    my $mod_time = sprintf("%04d%02d%02d%02d%02d%02d",
                           1900+$y, $mo+1, $d, $h, $m, $s);
    $blog->children_modified_on($mod_time);
    $mod_time;
}

1;
__END__

=head1 NAME

MT::Blog - Movable Type blog record

=head1 SYNOPSIS

    use MT::Blog;
    my $blog = MT::Blog->load($blog_id);
    $blog->name('Some new name');
    $blog->save
        or die $blog->errstr;

=head1 DESCRIPTION

An I<MT::Blog> object represents a blog in the Movable Type system. It
contains all of the settings, preferences, and configuration for a particular
blog. It does not contain any per-author permissions settings--for those,
look at the I<MT::Permission> object.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Blog> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

The following methods are unique to the I<MT::Blog> interface:

=head2 $blog->file_mgr

Returns the I<MT::FileMgr> object specific to this particular blog.

=head1 DATA ACCESS METHODS

The I<MT::Blog> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the blog.

=item * name

The name of the blog.

=item * description

The blog description.

=item * site_path

The path to the directory containing the blog's output index templates.

=item * site_url

The URL corresponding to the I<site_path>.

=item * archive_path

The path to the directory where the blog's archives are stored.

=item * archive_url

The URL corresponding to the I<archive_path>.

=item * server_offset

A slight misnomer, this is actually the timezone that the B<user> has
selected; the value is the offset from GMT.

=item * archive_type

A comma-separated list of archive types used in this particular blog, where
an archive type is one of the following: C<Individual>, C<Daily>, C<Weekly>,
C<Monthly>, or C<Category>. For example, a blog's I<archive_type> would be
C<Individual,Monthly> if the blog were using C<Individual> and C<Monthly>
archives.

=item * archive_type_preferred

The "preferred" archive type, which is used when constructing a link to the
archive page for a particular archive--if multiple archive types are selected,
for example, the link can only point to one of those archives. The preferred
archive type (which should be one of the archive types set in I<archive_type>,
above) specifies to which archive this link should point (among other things).

=item * days_on_index

The number of days to be displayed on the index.

=item * file_extension

The file extension to be used for archive pages.

=item * email_new_comments

A boolean flag specifying whether authors should be notified of new comments
posted on entries they have written.

=item * allow_comment_html

A boolean flag specifying whether HTML should be allowed in comments. If it
is not allowed, it is automatically stripped before building the page (note
that the content stored in the database is B<not> stripped).

=item * autolink_urls

A boolean flag specifying whether URLs in comments should be turned into
links. Note that this setting is only taken into account if
I<allow_comment_html> is turned off.

=item * sort_order_posts

The default sort order for entries. Valid values are either C<ascend> or
C<descend>.

=item * sort_order_comments

The default sort order for comments. Valid values are either C<ascend> or
C<descend>.

=item * allow_comments_default

The default value for the I<allow_comments> field in the I<MT::Entry> object.

=item * convert_paras

A comma-separated list of text filters to apply to each entry when it
is built.

=item * convert_paras_comments

A comma-separated list of text filters to apply to each comment when it
is built.

=item * status_default

The default value for the I<status> field in the I<MT::Entry> object.

=item * allow_anon_comments 

A boolean flag specifying whether anonymous comments (those posted without
a name or an email address) are allowed.

=item * allow_unreg_comments

A boolean flag specifying whether unregistered comments (those posted
without a validated email/password pair) are allowed.

=item * words_in_excerpt

The number of words in an auto-generated excerpt.

=item * ping_weblogs

A boolean flag specifying whether the system should send an XML-RPC ping to
I<weblogs.com> after an entry is saved.

=item * mt_update_key

The Movable Type Recently Updated Key to be sent to I<movabletype.org> after
an entry is saved.

=item * language

The language for date and time display for this particular blog.

=item * welcome_msg

The welcome message to be displayed on the main Editing Menu for this blog.
Should contain all desired HTML formatting.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * name

=back

=head1 NOTES

=over 4

=item *

When you remove a blog using I<MT::Blog::remove>, in addition to removing the
blog record, all of the entries, notifications, permissions, comments,
templates, and categories in that blog will also be removed.

=item *

Because the system needs to load I<MT::Blog> objects from disk relatively
often during the duration of one request, I<MT::Blog> objects are cached by
the I<MT::Blog::load> object so that each blog only need be loaded once. The
I<MT::Blog> objects are cached in the I<MT::Request> singleton object; note
that this caching B<only occurs> if the blogs are loaded by numeric ID.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
