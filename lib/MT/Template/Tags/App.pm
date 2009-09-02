# Movable Type (r) Open Source (C) 2001-2009 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: App.pm 109193 2009-08-17 06:43:09Z auno $
package MT::Template::Tags::App;

use strict;

use MT;
use MT::Util qw( encode_html encode_url );

###########################################################################

=head2 App:Setting

An application template tag used to display an application form field.

B<Attributes:>

=over 4

=item * id (required)

Each application setting tag requires a unique 'id' attribute. This id
should not be re-used within the template.

=item * required (optional; default "0")

Controls whether the field is displayed with visual cues that the
field is a required field or not.

=item * label

Supplies the label phrase for the setting.

=item * show_label (optional; default "1")

Controls whether the label portion of the setting is shown or not.

=item * shown (optional; default "1")

Controls whether the setting is visible or not. If specified, adds
a "hidden" class to the outermost C<div> tag produced for the
setting.

=item * label_class (optional)

Allows an additional CSS class to be applied to the label of the
setting.

=item * content_class (optional)

Allows an addtional CSS class to be applied to the contents of the
setting.

=item * hint (optional)

Supplies a "hint" phrase that provides inline instruction to the user.
By default, this hint is hidden, unless the 'show_hint' attribute
forces it to display.

=item * show_hint (optional; default "0")

Controls whether the inline help 'hint' label is shown or not.

=item * warning

Supplies a warning message to the user regarding the use of this setting.

=item * show_warning

Controls whether the warning message is shown or not.

=item * help_page

Identifies a specific page of the MT help documentation for this setting.

=item * help_section

Identifies a section name of the MT help documentation for this setting.

=back

B<Example:>

    <mtapp:Setting
        id="name"
        required="1"
        label="Username"
        hint="The username used to login">
            <input type="text" name="name" id="name" value="<$mt:Var name="name" escape="html"$>" />
    </mtapp:setting>

The basic structural output of a setting tag looks like this:

    <div id="ID-field" class="field pkg">
        <div class="field-inner">
            <div class="field-header">
                <label id="ID-label" for="ID">LABEL</label>
            </div>
            <div class="field-content">
                (content of App:Setting tag)
            </div>
        </div>
    </div>

=for tags application

=cut

sub _hdlr_app_setting {
    my ($ctx, $args, $cond) = @_;
    my $id = $args->{id};
    return $ctx->error("'id' attribute missing") unless $id;

    my $label = $args->{label};
    my $show_label = exists $args->{show_label} ? $args->{show_label} : 1;
    my $shown = exists $args->{shown} ? ($args->{shown} ? 1 : 0) : 1;
    my $label_class = $args->{label_class} || "";
    my $content_class = $args->{content_class} || "";
    my $hint = $args->{hint} || "";
    my $show_hint = $args->{show_hint} || 0;
    my $warning = $args->{warning} || "";
    my $show_warning = $args->{show_warning} || 0;
    my $indent = $args->{indent};
    my $help;
    # Formatting for help link, placed at the end of the hint.
    if ($help = $args->{help_page} || "") {
        my $section = $args->{help_section} || '';
        $section = qq{, '$section'} if $section;
        $help = qq{ <a href="javascript:void(0)" onclick="return openManual('$help'$section)" class="help-link">?</a><br />};
    }
    my $label_help = "";
    if ($label && $show_label) {
        # do nothing;
    } else {
        $label = ''; # zero it out, because the user turned it off
    }
    if ($hint && $show_hint) {
        $hint = "\n<div class=\"hint\">$hint$help</div>";
    } else {
        $hint = ''; # hiding hint because it is either empty or should not be shown
    }
    if ($warning && $show_warning) {
        $warning = qq{\n<p><img src="<mt:var name="static_uri">images/status_icons/warning.gif" alt="<__trans phrase="Warning">" width="9" height="9" />
<span class="alert-warning-inline">$warning</span></p>\n};
    } else {
        $warning = ''; # hiding hint because it is either empty or should not be shown
    }
    unless ($label_class) {
        $label_class = 'field-left-label';
    } else {
        $label_class = 'field-' . $label_class;
    }
    my $indent_css = "";
    if ($indent) {
        $indent_css = " style=\"padding-left: ".$indent."px;\""
    }
    # 'Required' indicator plus CSS class
    my $req = $args->{required} ? " *" : "";
    my $req_class = $args->{required} ? " required" : "";

    my $insides = $ctx->slurp($args, $cond);
    # $insides =~ s/^\s*(<textarea)\b/<div class="textarea-wrapper">$1/g;
    # $insides =~ s/(<\/textarea>)\s*$/$1<\/div>/g;

    my $class = $args->{class} || "";
    $class = ($class eq '') ? 'hidden' : $class . ' hidden' unless $shown;

    return $ctx->build(<<"EOT");
<div id="$id-field" class="field$req_class $label_class $class"$indent_css>
    <div class="field-header">
      <label id="$id-label" for="$id">$label$req</label>
    </div>
    <div class="field-content $content_class">
      $insides$hint$warning
    </div>
</div>
EOT
}

###########################################################################

=head2 App:Widget

An application template tag that produces HTML for displaying a MT CMS
dashboard widget. Custom widget templates should utilize this tag to wrap
their widget content.

B<Attributes:>

=over 4

=item * id (optional)

If specified, will be used as the 'id' attribute for the outermost C<div>
tag for the widget. If unspecified, will use the 'widget_id' template
variable instead.

=item * label (required)

The label to display above the widget.

=item * label_link (optional)

If specified, this link will wrap the label for the widget.

=item * label_onclick

If specified, this JavaScript code will be assigned to the 'onclick'
attribute of a link tag wrapping the widget label.

=item * class (optional)

If unspecified, will use the id of the widget. This class is included in the
'class' attribute of the outermost C<div> tag for the widget.

=item * header_action

=item * can_close (optional; default "0")

Identifies whether widget may be closed or not.

=item * tabbed (optional; default "0")

If specified, the widget will be assigned an attribute that gives it
a tabbed interface.

=back

B<Example:>

    <mtapp:Widget class="widget my-widget"
        label="<__trans phrase="All About Me">" can_close="1">
        (contents of widget go here)
    </mtapp:Widget>

=for tags application

=cut

sub _hdlr_app_widget {
    my ($ctx, $args, $cond) = @_;
    my $hosted_widget = $ctx->var('widget_id') ? 1 : 0;
    my $id = $args->{id} || $ctx->var('widget_id') || '';
    my $label = $args->{label};
    my $class = $args->{class} || $id;
    my $label_link = $args->{label_link} || "";
    my $label_onclick = $args->{label_onclick} || "";
    my $header_action = $args->{header_action} || "";
    my $closable = $args->{can_close} ? 1 : 0;
    if ($closable) {
        $header_action = qq{<a title="<__trans phrase="Remove this widget">" onclick="javascript:removeWidget('$id'); return false;" href="javascript:void(0);" class="widget-close-link"><span>close</span></a>};
    }
    my $widget_header = "";
    if ($label_link && $label_onclick) {
        $widget_header = "\n<h3 class=\"widget-label\"><a href=\"$label_link\" onclick=\"$label_onclick\"><span>$label</span></a></h3>";
    } elsif ($label_link) {
        $widget_header = "\n<h3 class=\"widget-label\"><a href=\"$label_link\"><span>$label</span></a></h3>";
    } else {
        $widget_header = "\n<h3 class=\"widget-label\"><span>$label</span></h3>";
    }
    my $token = $ctx->var('magic_token') || '';
    my $scope = $ctx->var('widget_scope') || 'system';
    my $singular = $ctx->var('widget_singular') || '';
    # Make certain widget_id is set
    my $vars = $ctx->{__stash}{vars};
    local $vars->{widget_id} = $id;
    local $vars->{widget_header} = '';
    local $vars->{widget_footer} = '';
    my $app = MT->instance;
    my $blog = $app->can('blog') ? $app->blog : $ctx->stash('blog');
    my $blog_field = $blog ? qq{<input type="hidden" name="blog_id" value="} . $blog->id . q{" />} : "";
    local $vars->{blog_id} = $blog->id if $blog;
    my $insides = $ctx->slurp($args, $cond);
    my $widget_footer = ($ctx->var('widget_footer') || '');
    my $var_header = ($ctx->var('widget_header') || '');
    if ($var_header =~ m/<h3[ >]/i) {
        $widget_header = $var_header;
    } else {
        $widget_header .= $var_header;
    }
    my $corners = $args->{corners} ? '<div class="corners"><b></b><u></u><s></s><i></i></div>' : "";
    my $tabbed = $args->{tabbed} ? ' mt:delegate="tab-container"' : "";
    my $header_class = $tabbed ? 'widget-header-tabs' : '';
    my $return_args = $app->make_return_args;
    $return_args = encode_html( $return_args );
    my $cgi = $app->uri;
    if ($hosted_widget && (!$insides !~ m/<form\s/i)) {
        $insides = <<"EOT";
        <form id="$id-form" method="post" action="$cgi" onsubmit="updateWidget('$id'); return false">
        <input type="hidden" name="__mode" value="update_widget_prefs" />
        <input type="hidden" name="widget_id" value="$id" />
        $blog_field
        <input type="hidden" name="widget_action" value="save" />
        <input type="hidden" name="widget_scope" value="$scope" />
        <input type="hidden" name="widget_singular" value="$singular" />
        <input type="hidden" name="magic_token" value="$token" />
        <input type="hidden" name="return_args" value="$return_args" />
$insides
        </form>
EOT
    }
    return <<"EOT";
<div id="$id" class="widget $class"$tabbed>
        <div class="widget-header $header_class">
                $header_action
                $widget_header
        </div>
        <div class="widget-content">
$insides
        </div>
        <div class="widget-footer">$widget_footer</div>$corners
</div>
EOT
}

###########################################################################

=head2 App:StatusMsg

An application template tag that outputs a MT status message.

B<Attributes:>

=over 4

=item * id (optional)

=item * class (optional; default "info")

=item * rebuild (optional)

Accepted values: "all", "index".

=item * can_close (optional; default "1")

=back

=for tags application

=cut

sub _hdlr_app_statusmsg {
    my ($ctx, $args, $cond) = @_;
    my $id = $args->{id};
    my $class = $args->{class} || 'info';
    my $msg = $ctx->slurp;
    my $rebuild = $args->{rebuild} || '';
    my $blog_id = $ctx->var('blog_id');
    my $blog = $ctx->stash('blog');
    if (!$blog && $blog_id) {
        $blog = MT->model('blog')->load($blog_id);
    }
    $rebuild = '' if $blog && $blog->custom_dynamic_templates eq 'all';
    $rebuild = qq{<__trans phrase="[_1]Publish[_2] your site to see these changes take effect." params="<a href="<mt:var name="mt_url">?__mode=rebuild_confirm&blog_id=<mt:var name="blog_id">" class="mt-rebuild">%%</a>">} if $rebuild eq 'all';
    $rebuild = qq{<__trans phrase="[_1]Publish[_2] your site to see these changes take effect." params="<a href="<mt:var name="mt_url">?__mode=rebuild_confirm&blog_id=<mt:var name="blog_id">&prompt=index" class="mt-rebuild">%%</a>">} if $rebuild eq 'index';
    my $close = '';
    if ($id && ($args->{can_close} || (!exists $args->{can_close}))) {
        $close = qq{<img alt="<__trans phrase="Close">" src="<mt:var name="static_uri">images/icon_close.png" class="mt-close-msg" />};
    }
    $id = defined $id ? qq{ id="$id"} : "";
    $class = defined $class ? qq{msg msg-$class} : "msg";
    return $ctx->build(<<"EOT");
    <div$id class="$class"><p>$msg $rebuild</p>$close</div>
EOT
}

###########################################################################

=head2 App:Listing

This application tag is used in MT application templates to produce
a table listing. It expects an C<object_loop> variable to be available,
or you can use the C<loop> attribute to have it use a different source.

It will output it's contents once for each row of the input array. It
produces markup that is compatible with the MT application templates
and CSS structure, so it is not meant for general blog publishing use.

The C<return_args> variable is recognized and will populate a hidden
field in the produced C<form> tag if available.

The C<blog_id> variable is recognized and will populate a hidden
field in the produced C<form> tag if available.

The C<screen_class> variable is recognized and will force the
C<hide_pager> attribute to 1 if it is set to 'search-replace'.

The C<magic_token> variable is recognized and will populate a hidden
field in the produced C<form> tag if available (or will retrieve
a token from the current application if unset).

The C<view_expanded> variable is recognized and will affect the
class name applied to the table. If assigned, the table tag will
receive a 'expanded' class; otherwise, it is given a 'compact'
class.

The C<listing_header> variable is recognized and will be output
in a C<div> tag (classed with 'listing-header') that appears
at the top of the listing. This is only output when 'actions'
are shown (see 'show_actions' attribute).

The structure of the output from a typical use like this:

    <MTApp:Listing type="entry">
        (contents of one row for table)
    </MTApp:Listing>

produces something like this:

    <div id="entry-listing" class="listing">
        <div class="listing-header">
        </div>
        <form id="entry-listing-form" class="listing-form"
            action="..../mt.cgi" method="post"
            onsubmit="return this['__mode'] ? true : false">
            <input type="hidden" name="__mode" value="" />
            <input type="hidden" name="_type" value="entry" />
            <input type="hidden" name="action_name" value="" />
            <input type="hidden" name="itemset_action_input" value="" />
            <input type="hidden" name="return_args" value="..." />
            <input type="hidden" name="blog_id" value="1" />
            <input type="hidden" name="magic_token" value="abcd" />
            <$MTApp:ActionBar bar_position="top"
                form_id="entry-listing-form"$>
            <table id="entry-listing-table"
                class="entry-listing-table compact" cellspacing="0">

                (contents of tag are placed here)

            </table>
            <$MTApp:ActionBar bar_position="bottom"
                form_id="entry-listing-form"$>
        </form>
    </div>

B<Attributes:>

=over 4

=item * type (optional)

The C<MT::Object> object type the listing is processing. If unset,
will use the contents of the C<object_type> variable.

=item * loop (optional)

The source of data to process. This is an array of hashes, similar
to the kind used with the L<Loop> tag. If unset, the C<object_loop>
variable is used instead.

=item * empty_message (optional)

Used when there are no rows to output for the listing. If not set,
it will process any 'else' block that is available instead, or, failing
that, will output an L<App:StatusMsg> tag saying that no data could be
found.

=item * id (optional)

Used to construct the DOM id for the listing. The outer C<div> tag
will use this value. If unset, it will be assigned C<type-listing> (where
'type' is the object type determined for the listing; see 'type'
attribute).

=item * listing_class (optional)

Provides a custom class name that can be applied to the main
C<div> tag produced (this is in addition to the 'listing' class
that is always applied).

=item * action (optional; default 'script_url' variable)

Supplies the 'action' attribute of the C<form> tag produced.

=item * hide_pager (optional; default '0')

Controls whether the pagination controls are shown or not.
If unspecified, pagination is shown.

=item * show_actions (optional; default '1')

Controls whether the actions associated with the object type
processed are shown or not. If unspecified, actions are shown.

=back

=for tags application

=cut

sub _hdlr_app_listing {
    my ($ctx, $args, $cond) = @_;

    my $type = $args->{type} || $ctx->var('object_type');
    my $class = MT->model($type) if $type;
    my $loop = $args->{loop} || 'object_loop';
    my $loop_obj = $ctx->var($loop);

    unless ((ref($loop_obj) eq 'ARRAY') && (@$loop_obj)) {
        my @else = @{ $ctx->stash('tokens_else') || [] };
        return MT::Template::Context::_hdlr_pass_tokens_else(@_) if @else;
        my $msg = $args->{empty_message} || MT->translate("No [_1] could be found.", $class ? lc($class->class_label_plural) : ($type ? $type : MT->translate("records")));
        return $ctx->build(qq{<mtapp:statusmsg
            id="zero-state"
            class="info zero-state">
            $msg
            </mtapp:statusmsg>});
    }

    my $id = $args->{id} || ($type ? $type . '-listing' : 'listing');
    $id =~ s/:/\-/g; # meta and revision uses colon as a separator
    my $listing_class = $args->{listing_class} || "";
    my $hide_pager = $args->{hide_pager} || 0;
    $hide_pager = 1 if ($ctx->var('screen_class') || '') eq 'search-replace';
    my $show_actions = exists $args->{show_actions} ? $args->{show_actions} : 1;
    my $return_args = $ctx->var('return_args') || '';
    $return_args = encode_html( $return_args );
    $return_args = qq{\n        <input type="hidden" name="return_args" value="$return_args" />} if $return_args;
    my $blog_id = $ctx->var('blog_id') || '';
    $blog_id = qq{\n        <input type="hidden" name="blog_id" value="$blog_id" />} if $blog_id;
    my $token = $ctx->var('magic_token') || MT->app->current_magic;
    my $action = $args->{action} || '<mt:var name="script_url">';
    my $target = ' target="' . $args->{target} . '"' if defined $args->{target};

    my $actions_top = "";
    my $actions_bottom = "";
    my $form_id = "$id-form";
    if ($show_actions) {
        $actions_top = qq{<\$MTApp:ActionBar bar_position="top" hide_pager="$hide_pager" form_id="$form_id"\$>};
        $actions_bottom = qq{<\$MTApp:ActionBar bar_position="bottom" hide_pager="$hide_pager" form_id="$form_id"\$>};
    } else {
        $listing_class .= " hide_actions";
    }

    my $insides;
    {
        local $args->{name} = $loop;
        defined($insides = $ctx->invoke_handler('loop', $args, $cond))
            or return;
    }
    my $listing_header = $ctx->var('listing_header') || '';
    my $view = $ctx->var('view_expanded') ? ' expanded' : ' compact';

    my $table = <<TABLE;
        <table id="$id-table" class="$id-table$view" cellspacing="0">
$insides
        </table>
TABLE

    if ($show_actions) {
        local $ctx->{__stash}{vars}{__contents__} = $table;
        return $ctx->build(<<EOT);
<div id="$id" class="listing $listing_class">
    <div class="listing-header">
        $listing_header
    </div>
    <form id="$form_id" class="listing-form"
        action="$action" method="post" $target
        onsubmit="return this['__mode'] ? true : false">
        <input type="hidden" name="__mode" value="" />
        <input type="hidden" name="_type" value="$type" />
        <input type="hidden" name="action_name" value="" />
        <input type="hidden" name="itemset_action_input" value="" />
$return_args
$blog_id
        <input type="hidden" name="magic_token" value="$token" />
        $actions_top
        <mt:var name="__contents__">
        $actions_bottom
    </form>
</div>
EOT
    }
    else {
        return <<EOT;
<div id="$id" class="listing $listing_class">
        $table
</div>
EOT
    }
}

###########################################################################

=head2 App:SettingGroup

An application template tag used to wrap a number of L<App:Setting> tags.

B<Attributes:>

=over 4

=item * id (required)

A unique identifier for this group of settings.

=item * class (optional)

If specified, applies this CSS class to the C<fieldset> tag produced.

=item * shown (optional; default "1")

Controls whether the C<fieldset> is initially shown or not. If hidden,
a CSS "hidden" class is applied to the C<fieldset> tag.

=back

B<Example:>

    <MTApp:SettingGroup id="foo">
        <MTApp:Setting ...>
        <MTApp:Setting ...>
        <MTApp:Setting ...>
    </MTApp:SettingGroup>

=for tags application

=cut

sub _hdlr_app_setting_group {
    my ($ctx, $args, $cond) = @_;
    my $id = $args->{id};
    return $ctx->error("'id' attribute missing") unless $id;

    my $class = $args->{class} || "";
    my $shown = exists $args->{shown} ? ($args->{shown} ? 1 : 0) : 1;
    $class .= ($class ne '' ? " " : "") . "hidden" unless $shown;
    $class = qq{ class="$class"} if $class ne '';

    my $insides = $ctx->slurp($args, $cond);
    return <<"EOT";
<fieldset id="$id"$class>
    $insides
</fieldset>
EOT
}

###########################################################################

=head2 App:Form

Used for application templates that need to express a standard MT
application form. This produces certain hidden fields that are typically
required by MT application forms.

B<Attributes:>

=over 4

=item * action (optional)

Identifies the URL to submit the form to. If not given, will use
the current application URI.

=item * method (optional; default "POST")

Supplies the C<form> method. "GET" or "POST" are the typical values
for this, but will accept any HTTP-compatible method (ie: "PUT", "DELETE").

=item * object_id (optional)

Populates a hidden 'id' field in the form. If not given, will also use any
'id' template variable defined.

=item * blog_id (optional)

Populates a hidden 'blog_id' field in the form. If not given, will also use
any 'blog_id' template variable defined.

=item * object_type (optional)

Populates a hidden '_type' field in the form. If not given, will also use
any 'type' template variable defined.

=item * id (optional)

Used to form the 'id' element of the HTML C<form> tag. If not specified,
the C<form> tag 'id' element will be assigned TYPE-form, where TYPE is the
determined object_type.

=item * name (optional)

Supplies the C<form> name attribute. If unspecified, will use the C<id>
attribute, if available.

=item * enctype (optional)

If assigned, sets an 'enctype' attribute on the C<form> tag using the value
supplied. This is typically used to create a form that is capable of
uploading files.

=back

B<Example:>

    <mtapp:Form id="update" mode="update_blog_name">
        Blog Name: <input type="text" name="blog_name" />
        <input type="submit" />
    </mtapp:Form>

Producing:

    <form id="update" name="update" action="/cgi-bin/mt.cgi" method="POST">
    <input type="hidden" name="__mode" value="update_blog_name" />
        Blog Name: <input type="text" name="blog_name" />
        <input type="submit" />
    </form>

=for tags application

=cut

sub _hdlr_app_form {
    my ($ctx, $args, $cond) = @_;
    my $app = MT->instance;
    my $action = $args->{action} || $app->uri;
    my $method = $args->{method} || 'POST';
    my @fields;
    my $token = $ctx->var('magic_token');
    my $return = $ctx->var('return_args');
    my $id = $args->{object_id} || $ctx->var('id');
    my $blog_id = $args->{blog_id} || $ctx->var('blog_id');
    my $type = $args->{object_type} || $ctx->var('type');
    my $form_id = $args->{id} || $type . '-form';
    my $form_name = $args->{name} || $args->{id};
    my $enctype = $args->{enctype} ? " enctype=\"" . $args->{enctype} . "\"" : "";
    my $mode = $args->{mode};
    push @fields, qq{<input type="hidden" name="__mode" value="$mode" />}
        if defined $mode;
    push @fields, qq{<input type="hidden" name="_type" value="$type" />}
        if defined $type;
    push @fields, qq{<input type="hidden" name="id" value="$id" />}
        if defined $id;
    push @fields, qq{<input type="hidden" name="blog_id" value="$blog_id" />}
        if defined $blog_id;
    push @fields, qq{<input type="hidden" name="magic_token" value="$token" />}
        if defined $token;
    $return = encode_html($return) if $return;
    push @fields, qq{<input type="hidden" name="return_args" value="$return" />}
        if defined $return;
    my $fields = '';
    $fields = join("\n", @fields) if @fields;
    my $insides = $ctx->slurp($args, $cond);
    return <<"EOT";
<form id="$form_id" name="$form_name" action="$action" method="$method"$enctype>
$fields
    $insides
</form>
EOT
}

###########################################################################

=head2 App:PageActions

An application template tag used to produce an unordered list of actions
for a given listing screen. The actions are drawn from a C<page_actions>
template variable which is an array of hashes.

B<Example:>

    <$mtapp:PageActions$>

=for tags application

=cut

sub _hdlr_app_page_actions {
    my ($ctx, $args, $cond) = @_;
    my $app = MT->instance;
    my $from = $args->{from} || $app->mode;
    my $loop = $ctx->var('page_actions');
    return '' if (ref($loop) ne 'ARRAY') || (! @$loop);
    my $mt = '&amp;magic_token=' . $app->current_magic;
    return $ctx->build(<<EOT, $cond);
    <mtapp:widget
        id="page_actions"
        label="<__trans phrase="Actions">">
                <ul>
        <mt:loop name="page_actions">
            <mt:if name="page">
                    <li class="icon-left icon<mt:unless name="core">-plugin</mt:unless>-action"><a href="<mt:var name="page" escape="html"><mt:if name="page_has_params">&amp;</mt:if>from=$from<mt:if name="id">&amp;id=<mt:var name="id"></mt:if><mt:if name="blog_id">&amp;blog_id=<mt:var name="blog_id"></mt:if>$mt&amp;return_args=<mt:var name="return_args" escape="url">"<mt:if name="continue_prompt"> onclick="return confirm('<mt:var name="continue_prompt" escape="js">');"</mt:if>><mt:var name="label"></a></li>
            <mt:else><mt:if name="link">
                    <li class="icon-left icon<mt:unless name="core">-plugin</mt:unless>-action"><a href="<mt:var name="link" escape="html">&amp;from=$from<mt:if name="id">&amp;id=<mt:var name="id"></mt:if><mt:if name="blog_id">&amp;blog_id=<mt:var name="blog_id"></mt:if>$mt&amp;return_args=<mt:var name="return_args" escape="url">"<mt:if name="continue_prompt"> onclick="return confirm('<mt:var name="continue_prompt" escape="js">');"</mt:if><mt:if name="dialog"> class="mt-open-dialog"</mt:if>><mt:var name="label"></a></li>
            </mt:if></mt:if>
        </mt:loop>
                </ul>
    </mtapp:widget>
EOT
}

###########################################################################

=head2 App:ListFilters

An application template tag used to produce an unordered list of quickfilters
for a given listing screen. The filters are drawn from a C<list_filters>
template variable which is an array of hashes.

B<Example:>

    <$mtapp:ListFilters$>

=cut

sub _hdlr_app_list_filters {
    my ($ctx, $args, $cond) = @_;
    my $app = MT->app;
    my $filters = $ctx->var("list_filters");
    return '' if (ref($filters) ne 'ARRAY') || (! @$filters );
    my $mode = $app->mode;
    my $type = $app->param('_type');
    my $type_param = "";
    $type_param = "&amp;_type=" . encode_url($type) if defined $type;
    return $ctx->build(<<EOT, $cond);
    <mt:loop name="list_filters">
        <mt:if name="__first__">
    <ul>
        </mt:if>
        <mt:if name="key" eq="\$filter_key"><li class="current-filter"><strong><mt:else><li></mt:if><a href="<mt:var name="script_url">?__mode=$mode$type_param<mt:if name="blog_id">&amp;blog_id=<mt:var name="blog_id"></mt:if>&amp;filter_key=<mt:var name="key" escape="url">"><mt:var name="label"></a><mt:if name="key" eq="\$filter_key"></strong></mt:if></li>
    <mt:if name="__last__">
    </ul>
    </mt:if>
    </mt:loop>
EOT
}

###########################################################################

=head2 App:ActionBar

Produces markup for application templates for the strip of actions
for a application listing or edit screen.

B<Attributes:>

=over 4

=item * bar_position (optional; default "top")

Assigns a CSS class name indicating whether the control is above or
below the listing or edit form it is associated with.

=item * hide_pager

Assign either 1 or 0 to control whether the pagination controls are
displayed or not.

=item * form_id

Associates the pagition controls and item action widget with the
given form element.

=back

=for tags application

=cut

sub _hdlr_app_action_bar {
    my ($ctx, $args, $cond) = @_;
    my $pos = $args->{bar_position} || 'top';
    my $form_id = $args->{form_id} ? qq{<mt:setvar name="form_id" value="$args->{form_id}">} : "";
    my $pager = $args->{hide_pager} ? ''
        : qq{\n        <mt:include name="include/pagination.tmpl" bar_position="$pos">};
    my $buttons = $ctx->var('action_buttons') || '';
    return $ctx->build(<<EOT);
$form_id
<div id="actions-bar-$pos" class="actions-bar actions-bar-$pos">
    $pager
    <span class="button-actions actions">$buttons</span>
    <span class="plugin-actions actions">
<mt:include name="include/itemset_action_widget.tmpl">
    </span>
</div>
EOT
}

###########################################################################

=head2 App:Link

Produces a application link to the current script with the mode and
attributes specified.

B<Attributes:>

=over 4

=item * mode

Maps to a '__mode' argument.

=item * type

Maps to a '_type' argument.

=back

B<Example:>

    <$MTApp:Link mode="foo" type="entry" bar="1"$>

produces:

    /cgi-bin/mt/mt.cgi?__mode=foo&_type=entry&bar=1

This tag produces unescaped '&' characters. If you use this tag
in an HTML tag attribute, be sure to add a C<escape="html"> attribute
which will encode these to HTML entities.

=for tags application

=cut

sub _hdlr_app_link {
    my ($ctx, $args, $cond) = @_;
    my $app = MT->instance;

    my %args = %$args;

    # eliminate special '@' argument (and anything other refs that may exist)
    ref($args{$_}) && delete $args{$_} for keys %args;

    # strip off any arguments that are actually global filters
    my $filters = MT->registry('tags', 'modifier');
    exists($filters->{$_}) && delete $args{$_} for keys %args;

    # remap 'type' attribute since we always express this as
    # a '_type' query parameter.
    my $mode = delete $args{mode} or return $ctx->error("mode attribute is required");
    $args{_type} = delete $args{type} if exists $args{type};
    if (exists $args{blog_id} && !($args{blog_id})) {
        delete $args{blog_id};
    } else {
        if (my $blog_id = $ctx->var('blog_id')) {
            $args{blog_id} = $blog_id;
        }
    }
    return $app->uri(mode => $mode, args => \%args);
}

1;
