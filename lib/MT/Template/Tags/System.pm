# Movable Type (r) Open Source (C) 2001-2009 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::Template::Tags::System;

use strict;

use MT;
use MT::Util qw( offset_time_list );
use MT::Request;

{
    my %include_stack;
    my %restricted_include_filenames = (
        'mt-config.cgi' => 1,
        'passwd' => 1
    );

###########################################################################

=head2 IncludeBlock

This tag provides MT with the ability to 'wrap' content with an included
module. This behaves much like the MTInclude tag, but it is a container tag.
The contents of the tag are taken and assigned to a variable (either one
explicitly named with a 'var' attribute, or will default to 'contents').
i.e.:

    <mt:IncludeBlock module="Some Module">
        (do something here)
    </mt:IncludeBlock>

In the "Some Module" template module, you would then have the following
template tag allowing you to reference the contents of the L<IncludeBlock>
tag used to include this "Some Module" template module, like so:

    (header stuff)
    <$mt:Var name="contents"$>
    (footer stuff)

B<Important:> Modules used as IncludeBlocks should never be processed as a Server Side Include or be cached.

+B<Attributes:>

=over 4

=item * var (optional)

Supplies a variable name to use for assigning the contents of the
L<IncludeBlock> tag. If unassigned, the "contents" variable is used.

=back

=for tags templating

=cut

sub _hdlr_include_block {
    my($ctx, $args, $cond) = @_;
    my $name = delete $args->{var} || 'contents';
    # defer the evaluation of the child tokens until used inside
    # the block (so any variables/context changes made in that template
    # affect the contained template code)
    my $tokens = $ctx->stash('tokens');
    local $ctx->{__stash}{vars}{$name} = sub {
        my $builder = $ctx->stash('builder');
        my $html = $builder->build($ctx, $tokens, $cond);
        return $ctx->error($builder->errstr) unless defined $html;
        return $html;
    };
    return $ctx->tag('include', $args, $cond);
}

###########################################################################

=head2 Include

Includes a template module or external file and outputs the result.

B<NOTE:> One and only one of the 'module', 'widget', 'file' and
'identifier' attributes can be specified.

B<Attributes:>

=over 4

=item * module

The name of a template module in the current blog.

=item * widget

The name of the widget in the current blog to include.

=item * file

The path to an external file on the system. The path can be absolute or
relative to the Local Site Path. This file is included at the time your
page is built. It should not be confused with dynamic server side
includes like that found in PHP.

=item * identifier

For selecting Index templates by their unique identifier.

=item * name

For application template use: identifies an application template by
filename to load.

=item * blog_id (optional)

Used to include a template from another blog in the system. Use in
conjunction with the module, widget or identifier attributes.

=item * local (optional)

Forces an Include of a template that exists in the blog that is being
published.

=item * global (optional; default "0")

Forces an Include of a globally defined template even if the
template is also available in the blog currently in context.
(For module, widget and identifier includes.)

=item * ssi (optional; default "0")

If specified, causes the include to be handled as a server-side
include. The value of the 'ssi' attribute determines the type of
include that is produced. Acceptable values are: C<php>, C<asp>,
C<jsp>, C<shtml>. This causes the contents of the include to be
processed and written to a file (stored to the blog's publishing
path, under the 'includes_c' subdirectory). The include tag itself
then returns the include directive appropriate to the 'ssi' type
specified. So, for example:

    <$mt:Include module="Tag Cloud" ssi="php"$>

This would generate the contents for the "Tag Cloud" template module
and write it to a "tag_cloud.php" file. The output of the include
tag would look like this:

    <?php include("/path/to/blog/includes_c/tag_cloud.php") ?>

Suitable for module, widget or identifier includes.

=item * cache (optional; default "0")

Enables caching of the contents of the include. Suitable for module,
widget or identifier includes.

=item * key or cache_key (optional)

Used to cache the template module. Used in conjunction with the 'cache'
attribute. Suitable for module, widget or identifier includes.

=item * ttl (optional)

Specifies the lifetime in seconds of a cached template module. Suitable
for module, widget or identifier includes.

=back

Also, other attributes given to this tag are locally assigned as
variables when invoking the include template.

The contents of the file or module are further evaluated for more Movable
Type template tags.

B<Example:> Including a Widget

    <$mt:Include widget="Search Box"$>

B<Example:> Including a File

    <$mt:Include file="/var/www/html/some-fragment.html"$>

B<Example:> Including a Template Module

    <$mt:Include module="Sidebar - Left Column"$>

B<Example:> Passing Parameters to a Template Module

    <$mt:Include module="Section Header" title="Elsewhere"$>

(from the "Section Header" template module)

    <h2><$mt:Var name="title"$></h2>

=for tags templating

=cut

sub _hdlr_include {
    my ($ctx, $arg, $cond) = @_;

    # Pass through include arguments as variables to included template
    my $vars = $ctx->{__stash}{vars} ||= {};
    my @names = keys %$arg;
    my @var_names;
    push @var_names, lc $_ for @names;
    local @{$vars}{@var_names};
    $vars->{lc($_)} = $arg->{$_} for @names;

    # Run include process
    my $out = $arg->{module}     ? _include_module(@_)
            : $arg->{widget}     ? _include_module(@_)
            : $arg->{identifier} ? _include_module(@_)
            : $arg->{file}       ? _include_file(@_)
            : $arg->{name}       ? _include_name(@_)
            :                      $ctx->error(MT->translate(
                                       'No template to include specified'))
            ;

    return $out;
}

sub _include_module {
    my ($ctx, $arg, $cond) = @_;
    my $tmpl_name = $arg->{module} || $arg->{widget} || $arg->{identifier}
        or return;
    my $name = $arg->{widget} ? 'widget' : $arg->{identifier} ? 'identifier' : 'module';
    my $type = $arg->{widget} ? 'widget' : 'custom';
    if (($type eq 'custom') && ($tmpl_name =~ m/^Widget:/)) {
        # handle old-style widget include references
        $type = 'widget';
        $tmpl_name =~ s/^Widget: ?//;
    }
    my $_stash_blog = $ctx->stash('blog');
    my $blog_id = $arg->{global}
        ? 0
        : defined($arg->{blog_id})
            ? $arg->{blog_id}
            : $_stash_blog
                ? $_stash_blog->id
                : 0;
    $blog_id = $ctx->stash('local_blog_id') if $arg->{local};
    ## Don't know why but hash key has to be encoded
    my $stash_id = Encode::encode_utf8('template_' . $type . '::' . $blog_id . '::' . $tmpl_name);
    return $ctx->error(MT->translate("Recursion attempt on [_1]: [_2]", MT->translate($name), $tmpl_name))
        if $include_stack{$stash_id};
    local $include_stack{$stash_id} = 1;

    my $req = MT::Request->instance;
    my ($tmpl, $tokens);
    if (my $tmpl_data = $req->stash($stash_id)) {
        ($tmpl, $tokens) = @$tmpl_data;
    }
    else {
        my %terms = $arg->{identifier} ? ( identifier => $tmpl_name )
                  :                      ( name => $tmpl_name,
                                           type => $type )
                  ;
        $terms{blog_id} = !exists $arg->{global} ? [ $blog_id, 0 ]
                        : $arg->{global}         ? 0
                        :                          $blog_id
                        ;
        ($tmpl) = MT->model('template')->load(\%terms, {
            sort      => 'blog_id',
            direction => 'descend',
        }) or return $ctx->error(MT->translate(
            "Can't find included template [_1] '[_2]'", MT->translate($name), $tmpl_name ));

        my $cur_tmpl = $ctx->stash('template');
        return $ctx->error(MT->translate("Recursion attempt on [_1]: [_2]", MT->translate($name), $tmpl_name))
            if $cur_tmpl && $cur_tmpl->id && ($cur_tmpl->id == $tmpl->id);

        $req->stash($stash_id, [ $tmpl, undef ]);
    }

    my $blog = $ctx->stash('blog') || MT->model('blog')->load($blog_id);

    my %include_recipe;
    my $use_ssi = $blog && $blog->include_system
        && ($arg->{ssi} || $tmpl->include_with_ssi) ? 1 : 0;
    if ($use_ssi) {
        # disable SSI for templates that are system templates;
        # easiest way to determine this is from the variable
        # space setting.
        if ($ctx->var('system_template')) {
            $use_ssi = 0;
        } else {
            my $extra_path = ($arg->{cache_key} || $arg->{key}) ? $arg->{cache_key} || $arg->{key}
                : $tmpl->cache_path ? $tmpl->cache_path
                    : '';
           %include_recipe = (
                name => $tmpl_name,
                id   => $tmpl->id,
                path => $extra_path,
            );
        }
    }

    # Try to read from cache
    my $cache_expire_type = $tmpl->cache_expire_type || 0;
    my $cache_enabled =
         $blog
      && $blog->include_cache
      && ( ( $arg->{cache} && $arg->{cache} > 0 )
        || $arg->{cache_key}
        || $arg->{key}
        || ( exists $arg->{ttl} )
        || ( $cache_expire_type != 0 ) ) ? 1 : 0;
    my $cache_key =
        ($arg->{cache_key} || $arg->{key})
      ? $arg->{cache_key} || $arg->{key}
      : 'blog::' . $blog_id . '::template_' . $type . '::' . $tmpl_name;
    my $ttl =
      exists $arg->{ttl} ? $arg->{ttl}
          : ( $cache_expire_type == 1 ) ? $tmpl->cache_expire_interval
              : ( $cache_expire_type == 2 ) ? 0
                  :   60 * 60;    # default 60 min.

    if ( $cache_expire_type == 2 ) {
        my @types = split /,/, ($tmpl->cache_expire_event || '');
        if (@types) {
            require MT::Touch;
            if (my $latest = MT::Touch->latest_touch($blog_id, @types)) {
                if ($use_ssi) {
                    # base cache expiration on physical file timestamp
                    my $include_file = $blog->include_path(\%include_recipe);
                    my $fmgr = $blog->file_mgr;
                    my $mtime = $fmgr->file_mod_time($include_file);
                    if ($mtime && (MT::Util::ts2epoch(undef, $latest) > $mtime ) ) {
                        $ttl = 1; # bound to force an update
                    }
                } else {
                    $ttl = time - MT::Util::ts2epoch(undef, $latest);
                }
            }
        }
    }

    my $cache_driver;
    if ($cache_enabled) {
        my $tmpl_mod = $tmpl->modified_on;
        my $tmpl_ts = MT::Util::ts2epoch($tmpl->blog_id ? $tmpl->blog : undef, $tmpl_mod);
        if (($ttl == 0) || (time - $tmpl_ts < $ttl)) {
            $ttl = time - $tmpl_ts;
        }
        require MT::Cache::Negotiate;
        $cache_driver = MT::Cache::Negotiate->new( ttl => $ttl );
        my $cache_value = $cache_driver->get($cache_key);

        if ($cache_value) {
            return $cache_value if !$use_ssi;

            # The template may still be cached from before we were using SSI
            # for this template, so check that it's also on disk.
            my $include_file = $blog->include_path(\%include_recipe);
            if ($blog->file_mgr->exists($include_file)) {
                return $blog->include_statement(\%include_recipe);
            }
        }
    }

    my $builder = $ctx->{__stash}{builder};
    if (!$tokens) {
        # Compile the included template against the includ*ing* template's
        # context.
        $tokens = $builder->compile($ctx, $tmpl->text);
        unless (defined $tokens) {
            $req->cache('build_template', $tmpl);
            return $ctx->error($builder->errstr);
        }
        $tmpl->tokens( $tokens );

        $req->stash($stash_id, [ $tmpl, $tokens ]);
    }

    # Build the included template against the includ*ing* template's context.
    my $ret = $tmpl->build( $ctx, $cond );
    if (!defined $ret) {
        $req->cache('build_template', $tmpl) if $tmpl;
        return $ctx->error("error in $name $tmpl_name: " . $tmpl->errstr);
    }

    if ($cache_enabled) {
        $cache_driver->replace($cache_key, $ret, $ttl);
    }

    if ($use_ssi) {
        my ($include_file, $path, $filename) =
            $blog->include_path(\%include_recipe);
        my $fmgr = $blog->file_mgr;
        if (!$fmgr->exists($path)) {
            if (!$fmgr->mkpath($path)) {
                return $ctx->error(MT->translate("Error making path '[_1]': [_2]",
                    $path, $fmgr->errstr));
            }
        }
        defined($fmgr->put_data($ret, $include_file))
            or return $ctx->error(MT->translate("Writing to '[_1]' failed: [_2]",
                $include_file, $fmgr->errstr));

        MT->upload_file_to_sync(
            url  => $blog->include_url(\%include_recipe),
            file => $include_file,
            blog => $blog,
        );

        my $stat = $blog->include_statement(\%include_recipe);
        return $stat;
    }

    return $ret;
}

sub _include_file {
    my ($ctx, $arg, $cond) = @_;
    my $file = $arg->{file} or return;
    require File::Basename;
    my $base_filename = File::Basename::basename($file);
    if (exists $restricted_include_filenames{lc $base_filename}) {
        return $ctx->error("You cannot include a file with this name: $base_filename");
    }

    my $blog_id = $arg->{blog_id} || $ctx->{__stash}{blog_id} || 0;
    my $stash_id = 'template_file::' . $blog_id . '::' . $file;
    return $ctx->error("Recursion attempt on file: [_1]", $file)
        if $include_stack{$stash_id};
    local $include_stack{$stash_id} = 1;
    my $req = MT::Request->instance;
    my $cref = $req->stash($stash_id);
    my $tokens;
    my $builder = $ctx->{__stash}{builder};
    if ($cref) {
        $tokens = $cref;
    } else {
        my $blog = $ctx->stash('blog');
        if ($blog && $blog->id != $blog_id) {
            $blog = MT::Blog->load($blog_id)
                or return $ctx->error(MT->translate(
                    "Can't find blog for id '[_1]", $blog_id));
        }
        my @paths = ($file);
        push @paths, map { File::Spec->catfile($_, $file) }
            ($blog->site_path, $blog->archive_path)
            if $blog;
        my $path;
        for my $p (@paths) {
            $path = $p, last if -e $p && -r _;
        }
        return $ctx->error(MT->translate(
            "Can't find included file '[_1]'", $file )) unless $path;
        local *FH;
        open FH, $path
            or return $ctx->error(MT->translate(
                "Error opening included file '[_1]': [_2]", $path, $! ));
        my $c;
        local $/; $c = <FH>;
        close FH;
        $tokens = $builder->compile($ctx, $c);
        return $ctx->error($builder->errstr) unless defined $tokens;
        $req->stash($stash_id, $tokens);
    }
    my $ret = $builder->build($ctx, $tokens, $cond);
    return defined($ret) ? $ret : $ctx->error("error in file $file: " . $builder->errstr);
}

sub _include_name {
    my ($ctx, $arg, $cond) = @_;
    my $app_file = $arg->{name};

    # app template include mode
    my $mt = MT->instance;
    local $mt->{component} = $arg->{component} if exists $arg->{component};
    my $stash_id = 'template_file::' . $app_file;
    return $ctx->error(MT->translate("Recursion attempt on file: [_1]", $app_file))
        if $include_stack{$stash_id};
    local $include_stack{$stash_id} = 1;
    my $tmpl = $mt->load_tmpl($app_file);
    if ($tmpl) {
        $tmpl->name($app_file);

        my $tmpl_file = $app_file;
        if ($tmpl_file) {
            $tmpl_file = File::Basename::basename($tmpl_file);
            $tmpl_file =~ s/\.tmpl$//;
            $tmpl_file = '.' . $tmpl_file;
        }
        $mt->run_callbacks('template_param' . $tmpl_file, $mt, $tmpl->param, $tmpl);

        # propagate our context
        local $tmpl->{context} = $ctx;
        my $out = $tmpl->output();
        return $ctx->error($tmpl->errstr) unless defined $out;

        $mt->run_callbacks('template_output' . $tmpl_file, $mt, \$out, $tmpl->param, $tmpl);
        return $out;
    } else {
        return defined $arg->{default} ? $arg->{default} : '';
    }
}
}

###########################################################################

=head2 IfStatic

Returns true if the current publishing context is static publishing,
and false otherwise.

=for tags templating, utility

=cut

###########################################################################

=head2 IfDynamic

Returns true if the current publishing context is dynamic publishing,
and false otherwise.

=for tags templating, utility

=cut

###########################################################################

=head2 Section

A utility block tag that is used to wrap content that can be cached,
or merely manipulated by any of Movable Type's tag modifiers.

B<Attributes:>

=over 4

=item * cache_prefix (optional)

When specified, causes the contents of the section tag to be cached
for some period of time. The 'period' attribute can specify the
cache duration (in seconds), or will use the C<DashboardCachePeriod>
configuration setting as a default (this feature was initially added
to support cacheable portions of the Movable Type Dashboard).

=item * period (optional)

A number in seconds defining the duration to cache the content produced
by the tag. Use in combination with the 'cache_prefix' attribute.

=item * by_blog (optional)

When using the 'cache_prefix' attribute, specifying '1' for this
attribute will cause the content to be cached on a per-blog basis
(otherwise, the default is system-wide).

=item * by_user (optional)

When using the 'cache_prefix' attribute, specifying '1' for this
attribute will cause the content to be cached on a per-user basis
(otherwise, the default is system-wide).

=item * html_tag (optional)

If specified, causes the content of the tag to be enclosed in a
the HTML tag identified. Example:

    <mt:Section html_tag="p">Lorem ipsum...</mt:Section>

Which would output:

    <p>Lorem ipsum...</p>

=item * id (optional)

If specified in combination with the 'html_tag' attribute, this 'id'
is added to the wrapping HTML tag.

=back

=for tags utility, templating

=cut

sub _hdlr_section {
    my($ctx, $args, $cond) = @_;
    my $app = MT->instance;
    my $out;
    my $cache_require;
    my $enc = MT->config->PublishCharset || 'UTF-8';

    # make cache id
    my $cache_id = $args->{cache_prefix} || undef;

    # read timeout. if timeout == 0 then, content is never cached.
    my $timeout = $args->{period};
    $timeout = $app->config('DashboardCachePeriod') if !defined $timeout;
    if (defined $timeout && ($timeout > 0)) {
        if (defined $cache_id) {
            if ($args->{by_blog}) {
                my $blog = $app->blog;
                $cache_id .= ':blog_id=';
                $cache_id .= $blog ? $blog->id : '0';
            }
            if ($args->{by_user}) {
                my $author = $app->user
                    or return $ctx->error(MT->translate(
                        "Can't load user."));
                $cache_id .= ':user_id='.$author->id;
            }

            # try to load from session
            require MT::Session;
            my $sess = MT::Session::get_unexpired_value(
                $timeout,
                { id => $cache_id, kind => 'CO' }); # CO == Cache Object
            if (defined $sess) {
                ## need to decode by hand for blob typed column.
                my $out = Encode::decode( $enc, $sess->data() );
                if ($out) {
                    if (my $wrap_tag = $args->{html_tag}) {
                        my $id = $args->{id};
                        $id = " id=\"$id\"" if $id;
                        $id = '' unless defined $id;
                        $out = "<$wrap_tag$id>" . $out . "</$wrap_tag>";
                    }
                    return $out;
                }
            }
        }

        # load failed (timeout or record not found)
        $cache_require = 1;
    }

    # build content
    defined($out = $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond))
        or return $ctx->error($ctx->stash('builder')->errstr);

    if ($cache_require && (defined $cache_id)) {
        my $sess = MT::Session->load({
            id => $cache_id, kind => 'CO'});
        if ($sess) {
            $sess->remove();
        }
        $sess = MT::Session->new;
        $sess->set_values({ id    => $cache_id,
                            kind  => 'CO',
                            start => time,
                            data  => Encode::encode( $enc, $out) });
        $sess->save();
    }

    if (my $wrap_tag = $args->{html_tag}) {
        my $id = $args->{id};
        $id = " id=\"$id\"" if $id;
        $id = '' unless defined $id;
        $out = "<$wrap_tag$id>" . $out . "</$wrap_tag>";
    }
    return $out;
}

###########################################################################

=head2 Link

Generates the absolute URL to an index template or specific entry in the system.

B<NOTE:> Only one of the 'template' or 'entry_id' attributes can be specified
at a time.

B<Attributes:>

=over 4

=item * template

The index template to which to link. This attribute should be the template's
name, identifier, or outfile.

=item * entry_id

The numeric system ID of the entry.

=item * with_index (optional; default "0")

If not set to 1, remove index filenames (by default, index.html)
from resulting links.

=back

B<Examples:>

    <a href="<mt:Link template="About Page">">My About Page</a>

    <a href="<mt:Link template="main_index">">Blog Home</a>
    
    <a href="<mt:Link entry_id="221">">the entry about my vacation</a>

=for tags archives
=cut

sub _hdlr_link {
    my($ctx, $arg, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $blog_id = $blog->id;
    if (my $tmpl_name = $arg->{template}) {
        require MT::Template;
        my $tmpl = MT::Template->load({ identifier => $tmpl_name,
                type => 'index', blog_id => $blog_id })
            || MT::Template->load({ name => $tmpl_name,
                                        type => 'index',
                                        blog_id => $blog_id })
                || MT::Template->load({ outfile => $tmpl_name,
                                        type => 'index',
                                        blog_id => $blog_id })
            or return $ctx->error(MT->translate(
                "Can't find template '[_1]'", $tmpl_name ));
        my $site_url = $blog->site_url;
        $site_url .= '/' unless $site_url =~ m!/$!;
        my $link = $site_url . $tmpl->outfile;
        $link = MT::Util::strip_index($link, $blog) unless $arg->{with_index};
        $link;
    } elsif (my $entry_id = $arg->{entry_id}) {
        my $entry = MT::Entry->load($entry_id)
            or return $ctx->error(MT->translate(
                "Can't find entry '[_1]'", $entry_id ));
        my $link = $entry->permalink;
        $link = MT::Util::strip_index($link, $blog) unless $arg->{with_index};
        $link;
    }
}

###########################################################################

=head2 Date

Outputs the current date.

B<Attributes:>

=over 4

=item * ts (optional)

If specified, will use the given date as the date to publish. Must be
in the format of "YYYYMMDDhhmmss".

=item * relative (optional)

If specified, will publish the date using a phrase, if the date is
less than a week from the current date. Accepted values are "1", "2", "3"
and "js". The options for "1", "2" and "3" affect the style of the phrase.

=over 4

=item * relative="1"

Supports display of one duration: moments ago; N minutes ago; N hours ago; N days ago. For older dates in the same year, the date is shown as the abbreviated month and day of the month ("Jan 3"). For older dates, the year is added to that ("Jan 3 2005").

=item * relative="2"

Supports display of two durations: less than 1 minute ago; N seconds, N minutes ago; N minutes ago; N hours, N minutes ago; N hours ago; N days, N hours ago; N days ago.

=item * relative="3"

Supports display of two durations: N seconds ago; N seconds, N minutes ago;
N minutes ago; N hours, N minutes ago; N hours ago; N days, N hours ago; N days ago.

=item * relative="js"

When specified, publishes the date using JavaScript, which relies on a
MT JavaScript function 'mtRelativeDate' to format the date.

=back

=item * format (optional)

A string that provides the format in which to publish the date. If
unspecified, the default that is appropriate for the language of the blog
is used (for English, this is "%B %e, %Y %l:%M %p"). The format specifiers
supported are:

=over 4

=item * %Y

The 4-digit year. Example: "1999".

=item * %m

The 2-digit month (zero-padded). Example: for a date in September, this would output "09".

=item * %d

The 2-digit day of the month (zero-padded). Example: "05".

=item * %H

The 2-digit hour of the day (24-hour clock, zero-padded). Example: "18".

=item * %M

The 2-digit minute of the hour (zero-padded). Example: "09".

=item * %S

The 2-digit second of the minute (zero-padded). Example: "04".

=item * %w

The numeric day of the week, in the range C<0>-C<6>, where C<0> is
C<Sunday>. Example: "3".

=item * %j

The numeric day of the year, in the range C<0>-C<365>. Zero-padded to
three digits. Example: "040".

=item * %y

The two-digit year, zero-padded. Example: %y for a date in 2008 would
output "08".

=item * %b

The abbreviated month name. Example: %b for a date in January would
output "Jan".

=item * %B

The full month name. Example: "January".

=item * %a

The abbreviated day of the week. Example: %a for a date on a Monday would
output "Mon".

=item * %A

The full day of the week. Example: "Friday".

=item * %e

The numeric day of the month (space-padded). Example: " 8".

=item * %I

The two-digit hour on a 12-hour clock padded with a zero if applicable.
Example: "04".

=item * %k

The two-digit military time hour padded with a space if applicable.
Example: " 9".

=item * %l

The hour on a 12-hour clock padded with a space if applicable.
Example: " 4".

=back

=item * format_name (optional)

Supports date formatting for particular standards.

=over 4

=item * rfc822

Outputs the date in the format: "%a, %d %b %Y %H:%M:%S Z".

=item * iso8601

Outputs the date in the format: "%Y-%m-%dT%H:%M:%SZ".

=back

=item * utc (optional)

Converts the date into UTC time.

=item * offset_blog_id (optional)

Identifies the ID of the blog to use for adjusting the time to
blog time. Will default to the current blog in context if unset.

=item * language (optional)

Used to force localization of the date to a specific language.
Accepted values: "cz" (Czechoslovakian), "dk" (Scandinavian),
"nl" (Dutch), "en" (English), "fr" (French), "de" (German),
"is" (Icelandic), "ja" (Japanese), "it" (Italian), "no" (Norwegian),
"pl" (Polish), "pt" (Portuguese), "si" (Slovenian), "es" (Spanish),
"fi" (Finnish), "se" (Swedish). Will use the blog's date language
setting as a default.

=back

=cut

sub _hdlr_sys_date {
    my ($ctx, $args) = @_;
    unless ($args->{ts}) {
        my $t = time;
        my @ts = offset_time_list($t, $ctx->stash('blog_id'));
        $args->{ts} = sprintf "%04d%02d%02d%02d%02d%02d",
            $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
    }
    return $ctx->build_date($args);
}

###########################################################################

=head2 AdminScript

Returns the value of the C<AdminScript> configuration setting. The default
for this setting if unassigned is "mt.cgi".

=for tags configuration

=cut

sub _hdlr_admin_script {
    my ($ctx) = @_;
    return $ctx->{config}->AdminScript;
}

###########################################################################

=head2 CommentScript

Returns the value of the C<CommentScript> configuration setting. The
default for this setting if unassigned is "mt-comments.cgi".

=for tags configuration

=cut

sub _hdlr_comment_script {
    my ($ctx) = @_;
    return $ctx->{config}->CommentScript;
}

###########################################################################

=head2 TrackbackScript

Returns the value of the C<TrackbackScript> configuration setting. The
default for this setting if unassigned is "mt-tb.cgi".

=for tags configuration

=cut

sub _hdlr_trackback_script {
    my ($ctx) = @_;
    return $ctx->{config}->TrackbackScript;
}

###########################################################################

=head2 SearchScript

Returns the value of the C<SearchScript> configuration setting. The
default for this setting if unassigned is "mt-search.cgi".

=for tags configuration

=cut

sub _hdlr_search_script {
    my ($ctx) = @_;
    return $ctx->{config}->SearchScript;
}

###########################################################################

=head2 XMLRPCScript

Returns the value of the C<XMLRPCScript> configuration setting. The
default for this setting if unassigned is "mt-xmlrpc.cgi".

=for tags configuration

=cut

sub _hdlr_xmlrpc_script {
    my ($ctx) = @_;
    return $ctx->{config}->XMLRPCScript;
}

###########################################################################

=head2 AtomScript

Returns the value of the C<AtomScript> configuration setting. The
default for this setting if unassigned is "mt-atom.cgi".

=for tags configuration

=cut

sub _hdlr_atom_script {
    my ($ctx) = @_;
    return $ctx->{config}->AtomScript;
}

###########################################################################

=head2 NotifyScript

Returns the value of the C<NotifyScript> configuration setting. The
default for this setting if unassigned is "mt-add-notify.cgi".

=for tags configuration

=cut

sub _hdlr_notify_script {
    my ($ctx) = @_;
    return $ctx->{config}->NotifyScript;
}

###########################################################################

=head2 CGIHost

Returns the domain host from the configuration directive CGIPath. If CGIPath
is defined as a relative path, then the domain is derived from the Site URL
in the blog's "Publishing Settings".

B<Attributes:>

=over 4

=item * exclude_port (optional; default "0")

If set, exclude the port number from the CGIHost.

=back

=for tags configuration

=cut

sub _hdlr_cgi_host {
    my ($ctx, $args, $cond) = @_;
    my $path = $ctx->cgi_path;
    if ($path =~ m!^https?://([^/:]+)(:\d+)?/!) {
        return $args->{exclude_port} ? $1 : $1 . ($2 || '');
    } else {
        return '';
    }
}

###########################################################################

=head2 CGIPath

The value of the C<CGIPath> configuration setting. Example (the output
is guaranteed to end with "/", so appending one prior to a script
name is unnecessary):

    <a href="<$mt:CGIPath$>some-cgi-script.cgi">

=for tags configuration

=cut

sub _hdlr_cgi_path { shift->cgi_path }

###########################################################################

=head2 AdminCGIPath

Returns the value of the C<AdminCGIPath> configuration setting if set. Otherwise, the value of the C<CGIPath> setting is returned.

In the event that the configured path has no domain (ie, "/cgi-bin/"), the active blog's domain will be used.

The path produced by this tag will always have an ending '/', even if one does not exist as configured.

B<Example:>

    <$mt:AdminCGIPath$>

=for tags path, configuration

=cut

sub _hdlr_admin_cgi_path {
    my ($ctx) = @_;
    my $cfg = $ctx->{config};
    my $path = $cfg->AdminCGIPath || $cfg->CGIPath;
    if ($path =~ m!^/!) {
        # relative path, prepend blog domain
        my $blog = $ctx->stash('blog');
        my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
        $path = $blog_domain . $path;
    }
    $path .= '/' unless $path =~ m!/$!;
    return $path;
}

###########################################################################

=head2 CGIRelativeURL

The relative URL (path) extracted from the CGIPath setting in
mt-config.cgi. This is the same as L<CGIPath>, but without any
domain name. This value is guaranteed to end with a "/" character.

=for tags configuration

=cut

sub _hdlr_cgi_relative_url {
    my ($ctx) = @_;
    my $url = $ctx->{config}->CGIPath;
    $url .= '/' unless $url =~ m!/$!;
    if ($url =~ m!^https?://[^/]+(/.*)$!) {
        return $1;
    }
    return $url;
}

###########################################################################

=head2 CGIServerPath

Returns the file path to the directory where Movable Type has been
installed. Any trailing "/" character is removed.

=for tags configuration

=cut

sub _hdlr_cgi_server_path {
    my $path = MT->instance->server_path() || "";
    $path =~ s!/*$!!;
    return $path;
}

###########################################################################

=head2 StaticFilePath

The file path to the directory where Movable Type's static files are
stored (as configured by the C<StaticFilePath> setting, or based on
the location of the MT application files alone). This value is
guaranteed to end with a "/" character.

=for tags configuration

=cut

sub _hdlr_static_file_path {
    my ($ctx) = @_;
    my $cfg = $ctx->{config};
    my $path = $cfg->StaticFilePath;
    if (!$path) {
        $path = MT->instance->{mt_dir};
        $path .= '/' unless $path =~ m!/$!;
        $path .= 'mt-static/';
    }
    $path .= '/' unless $path =~ m!/$!;
    return $path;
}

###########################################################################

=head2 StaticWebPath

The value of the C<StaticWebPath> configuration setting. If this setting
has no domain, the blog domain is added to it. This value is
guaranteed to end with a "/" character.

B<Example:>

    <img src="<$mt:StaticWebPath$>images/powered.gif"
        alt="Powered by MT" />

=for tags configuration

=cut

sub _hdlr_static_path {
    my ($ctx) = @_;
    my $cfg = $ctx->{config};
    my $path = $cfg->StaticWebPath;
    if (!$path) {
        $path = $cfg->CGIPath;
        $path .= '/' unless $path =~ m!/$!;
        $path .= 'mt-static/';
    }
    if ($path =~ m!^/!) {
        # relative path, prepend blog domain
        my $blog = $ctx->stash('blog');
        if ($blog) {
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            $path = $blog_domain . $path;
        }
    }
    $path .= '/' unless $path =~ m!/$!;
    return $path;
}

###########################################################################

=head2 SupportDirectoryURL

The value of the C<SupportDirectoryURL> configuration setting. This value is
guaranteed to end with a "/" character.

=for tags configuration

=cut

sub _hdlr_support_directory_url {
    my ($ctx) = @_;
    return MT->support_directory_url;
}

###########################################################################

=head2 Version

The version number of the Movable Type system.

B<Example:>

    <mt:Version />

=for tags configuration

=cut

sub _hdlr_mt_version {
    require MT;
    MT->version_id;
}

###########################################################################

=head2 ProductName

The Movable Type edition in use.

B<Attributes:>

=over 4

=item * version (optional; default "0")

If specified, also outputs the version (same as L<Version>).

=back

B<Example:>

    <$mt:ProductName$>

for the MTOS edition, this would output:

    Movable Type Open Source

=for tags configuration

=cut

sub _hdlr_product_name {
    my ($ctx, $args, $cond) = @_;
    require MT;
    my $short_name = MT->translate(MT->product_name);
    if ($args->{version}) {
        return MT->translate("[_1] [_2]", $short_name, MT->version_id);
    } else {
        return $short_name;
    }
}

###########################################################################

=head2 PublishCharset

The value of the C<PublishCharset> directive in the system configuration.

B<Example:>

    <$mt:PublishCharset$>

=for tags configuration

=cut

sub _hdlr_publish_charset {
    my ($ctx) = @_;
    return $ctx->{config}->PublishCharset || 'utf-8';
}

###########################################################################

=head2 DefaultLanguage

The value of the C<DefaultLanguage> configuration setting.

B<Example:>

    <$mt:DefaultLanguage$>

This outputs a language code, ie: "en_US", "ja", "de", "es", "fr", "nl" or
other installed language.

=for tags configuration

=cut

sub _hdlr_default_language {
    my ($ctx) = @_;
    return $ctx->{config}->DefaultLanguage || 'en_US';
}

###########################################################################

=head2 ConfigFile

Returns the full file path for the Movable Type configuration file
(mt-config.cgi).

=for tags configuration

=cut

sub _hdlr_config_file {
    return MT->instance->{cfg_file};
}

###########################################################################

=head2 IndexBasename

Outputs the C<IndexBasename> MT configuration setting.

B<Attributes:>

=over 4

=item * extension (optional; default "0")

If specified, will append the blog's configured file extension.

=back

=cut

sub _hdlr_index_basename {
    my ($ctx, $args, $cond) = @_;
    my $name = $ctx->{config}->IndexBasename;
    if (!$args->{extension}) {
        return $name;
    }
    my $blog = $ctx->stash('blog');
    my $ext = $blog->file_extension;
    $ext = '.' . $ext if $ext;
    $name . $ext;
}

###########################################################################

=head2 HTTPContentType

When this tag is used in a dynamically published index template, the value
specified to the type attribute will be returned in the Content-Type HTTP
header sent to web browser. This content is never displayed directly to the
user but is instead used to signal to the browser the data type of the
response.

When this tag is used in a system template, such as the search results
template, mt-search.cgi will use the value specified to "type" attribute and
returns it in Content-Type HTTP header to web browser.

When this tag is used in statically published template, this template tag
outputs nothing.

B<Attributes:>

=over 4

=item * type

A valid HTTP Content-Type value, for example 'application/xml'. Note that you
must not specify charset portion of Content-Type header value in this
attribute. MT will set the portion automatically by using PublishCharset
configuration directive.

=back

B<Example:>

    <$mt:HTTPContentType type="application/xml"$>

=cut

sub _hdlr_http_content_type {
    my($ctx, $args) = @_;
    my $type = $args->{type};
    $ctx->stash('content_type', $type);
    return qq{};
}

###########################################################################

=head2 FileTemplate

Produces a file name and path using the archive file naming specifiers.

B<Attributes:>

=over 4

=item * format

A required attribute that defines the template with a string of specifiers.
The supported specifiers are (B<NOTE:> do not confuse the following
table with the specifiers used for MT date tags. There is no relationship
between these -- any similarities are coincidental. These specifiers are
tuned for publishing filenames and paths for various contexts.)

=over 4

=item * %a

The entry's author's display name passed through the dirify global filter. Example: melody_nelson

=item * %-a

The same as above except using dashes. Example: melody-nelson

=item * %b

For individual archive mappings, this returns the basename of the entry. By
default, this is the first thirty characters of an entry dirified with
underscores. It can be specified by using the basename field on the edit
entry screen. Example: my_summer_vacation

=item * %-b

Same as above but using dashes. Example: my-summer-vacation

=item * %c

The entry's primary category/subcategory path, built using the category
basename field. Example: arts_and_entertainment/tv_and_movies

=item * %-c

Same as above but using dashes. Example: arts-and-entertainment/tv-and-movies

=item * %C

The entry's primary category label passed through the dirify global filter. Example: arts_and_entertainment

=item * %-C

Same as above but using dashes. Example: arts-and-entertainment

=item * %d

2-digit day of the month. Example: 09

=item * %D

3-letter language-dependent abbreviation of the week day. Example: Tue

=item * %e

A numeric entry ID padded with leading zeroes to six digits. Example: 000040

=item * %E

The entry's numeric ID. Example: 40

=item * %f

Archive filename with the specified extension. This can be used instead of
%b or %i and will do the right thing based on the context.
Example: entry_basename.html or index.html

=item * %F

Same as above but without the file extension. Example: filename

=item * %h

2-digit hour on a 24-hour clock with a leading zero if applicable.
Example: 09 for 9am, 16 for 4pm

=item * %H

2-digit hour on a 24-hour clock without a leading zero if applicable.
Example: 9 for 9am, 16 for 4pm

=item * %i

The setting of the IndexBasename configuration directive with the default
file extension appended. Example: index.html

=item * %I

Same as above but without the file extension. Example: index

=item * %j

3-digit day of year, zero-padded. Example: 040

=item * %m

2-digit month, zero-padded. Example: 07

=item * %M

3-letter language-dependent abbreviation of the month. Example: Sep

=item * %n

2-digit minute, zero-padded. Example: 04

=item * %s

2-digit second, zero-padded. Example: 01

=item * %x

File extension with a leading dot (.). If a file extension has not
been specified a blank string is returned. Example: .html

=item * %y

4-digit year. Example: 2005

=item * %Y

2-digit year with zero-padding. Example: 05

=back

=back

B<Example:>

    <$mt:FileTemplate format="%y/%m/%f"$>

=for tags archives

=cut

sub _hdlr_file_template {
    my ($ctx, $args, $cond) = @_;

    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    $at = 'Category' if $ctx->{inside_mt_categories};
    my $format = $args->{format};
    unless ($format) {
        my $archiver = MT->publisher->archiver($at);
        $format = $archiver->default_archive_templates if $archiver;
    }
    return $ctx->error(MT->translate("Unspecified archive template")) unless $format;

    my ($dir, $sep);
    if ($args->{separator}) {
        $dir = "dirify='$args->{separator}'";
        $sep = "separator='$args->{separator}'";
    } else {
        $dir = "dirify='1'";
        $sep = "";
    }
    my %f = (
        'a' => "<MTAuthorBasename $dir>",
        '-a' => "<MTAuthorBasename separator='-'>",
        '_a' => "<MTAuthorBasename separator='_'>",
        'b' => "<MTEntryBasename $sep>",
        '-b' => "<MTEntryBasename separator='-'>",
        '_b' => "<MTEntryBasename separator='_'>",
        'c' => "<MTSubCategoryPath $sep>",
        '-c' => "<MTSubCategoryPath separator='-'>",
        '_c' => "<MTSubCategoryPath separator='_'>",
        'C' => "<MTCategoryBasename $sep>",
        '-C' => "<MTCategoryBasename separator='-'>",
        'd' => "<MTArchiveDate format='%d'>",
        'D' => "<MTArchiveDate format='%e' trim='1'>",
        'e' => "<MTEntryID pad='1'>",
        'E' => "<MTEntryID pad='0'>",
        'f' => "<MTArchiveFile $sep>",
        '-f' => "<MTArchiveFile separator='-'>",
        'F' => "<MTArchiveFile extension='0' $sep>",
        '-F' => "<MTArchiveFile extension='0' separator='-'>",
        'h' => "<MTArchiveDate format='%H'>",
        'H' => "<MTArchiveDate format='%k' trim='1'>",
        'i' => '<MTIndexBasename extension="1">',
        'I' => "<MTIndexBasename>",
        'j' => "<MTArchiveDate format='%j'>",  # 3-digit day of year
        'm' => "<MTArchiveDate format='%m'>",  # 2-digit month
        'M' => "<MTArchiveDate format='%b'>",  # 3-letter month
        'n' => "<MTArchiveDate format='%M'>",  # 2-digit minute
        's' => "<MTArchiveDate format='%S'>",  # 2-digit second
        'x' => "<MTBlogFileExtension>",
        'y' => "<MTArchiveDate format='%Y'>",  # year
        'Y' => "<MTArchiveDate format='%y'>",  # 2-digit year
        'p' => "<mt:PagerBlock><mt:IfCurrentPage><mt:Var name='__value__'></mt:IfCurrentPage></mt:PagerBlock>", # current page number
    );
    $format =~ s!%([_-]?[A-Za-z])!$f{$1}!g if defined $format;
    # now build this template and return result
    my $builder = $ctx->stash('builder');
    my $tok = $builder->compile($ctx, $format);
    return $ctx->error(MT->translate("Error in file template: [_1]", $args->{format}))
        unless defined $tok;
    defined(my $file = $builder->build($ctx, $tok, $cond))
        or return $ctx->error($builder->errstr);
    $file =~ s!/{2,}!/!g;
    $file =~ s!(^/|/$)!!g;
    $file;
}

###########################################################################

=head2 TemplateCreatedOn

Returns the creation date for the template publishing the current file.

B<Example:>

    <$mt:TemplateCreatedOn$>

=for tags date

=for tags templates

=cut

sub _hdlr_template_created_on {
    my($ctx, $args, $cond) = @_;
    my $template = $ctx->stash('template')
        or return $ctx->error(MT->translate("Can't load template"));
    $args->{ts} = $template->created_on;
    $ctx->build_date($args);
}

###########################################################################

=head2 BuildTemplateID

Returns the ID of the template (index, archive or system template) currently
being built.

=cut

sub _hdlr_build_template_id {
    my ($ctx, $args, $cond) = @_;
    my $tmpl = $ctx->stash('template');
    if ($tmpl && $tmpl->id) {
        return $tmpl->id;
    }
    return 0;
}

###########################################################################

=head2 ErrorMessage

This tag is used by the system to display the text of any user error
message. Used in system templates, such as the 'Comment Response' template.

=for tags templating

=cut

sub _hdlr_error_message {
    my ($ctx) = @_;
    my $err = $ctx->stash('error_message');
    defined $err ? $err : '';
}

1;
