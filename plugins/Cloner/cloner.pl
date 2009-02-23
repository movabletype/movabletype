# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# Blog Cloner plugin for Movable Type
# Author: Brad Choate, Six Apart (http://www.sixapart.com)
# Released under the Artistic and GPLv2 License

package MT::Plugin::Cloner;

use strict;
use MT 4;
use base 'MT::Plugin';
use MT::Util qw( encode_html );
our $VERSION = '2.0';

my $plugin = MT::Plugin::Cloner->new({
    name        => "Blog Cloner",
    version     => $VERSION,
    description => '<MT_TRANS phrase="Clones a blog and all of its contents.">',
    author_name => "Six Apart, Ltd.",
    author_link => 'http://www.sixapart.com/',
    registry => {
        applications => {
            cms => {
                list_actions => {
                    blog => {
                        clone_blog => {
                            label => "Clone Blog",
                            code => \&itemset_clone_blog,
                            permission => 'administer',
                            max => 1,
                            dialog => 1,
                        },
                    },
                },
            },
        },
    },
});

MT->add_plugin($plugin);

sub itemset_clone_blog {
    my $app = shift;
    my $user = $app->user;
    return $app->error($app->translate("Permission denied."))
        unless $user->is_superuser;

    $| = 1;

    # Get blog_id from params and validate
    require MT::Blog;
    my @id = $app->param('id');
    if (!@id) {
        return $app->error($plugin->translate("No blog was selected to clone."));
    }
    if (scalar @id > 1) {
        return $app->error($plugin->translate("This action can only be run for a single blog at a time."));
    }
    my $blog_id = shift @id;
    my $blog = MT::Blog->load($blog_id)
        or return $app->error($plugin->translate("Invalid blog_id"));
    # double escape to survive decode_html in translate_templatized
    my $blog_name = encode_html(encode_html($blog->name, 1), 1);

    # Set up and commence app output
    $app->{no_print_body} = 1;
    $app->send_http_header;
    my $html_head = <<'SCRIPT';
<script type="text/javascript">
function progress(str, id) {
    var el = getByID(id);
    if (el) el.innerHTML = str;
}
</script>
SCRIPT
    $app->print($app->build_page('dialog/header.tmpl', { page_title => $plugin->translate("Clone Blog"), html_head => $html_head }));
    $app->print($plugin->translate_templatized(<<"HTML"));
<h2><__trans phrase="Cloning blog '[_1]'..." params="$blog_name"></h2>

<div class="modal_width" id="dialog-clone-weblog">

<div id="msg-container" style="height: 310px; overflow: scroll; overflow-x: auto">
<ul>
HTML

    my $new_blog;
    eval {
        $new_blog = $blog->clone({
            Children => 1,
            Except => ({ site_path => 1, site_url => 1 }),
            Callback => sub { _progress($app, @_) }
        });
    };
    if (my $err = $@) {
        $app->print($plugin->translate_templatized(qq{<p class="error-message"><MT_TRANS phrase="Error">: $err</p>}));
    } else {
        my $return_url = $app->return_uri;
        my $blog_url = $app->uri(mode => 'dashboard', args => {
            blog_id => $new_blog->id
        });
        my $setting_url = $app->uri(mode => 'view', args => {
            blog_id => $new_blog->id,
            _type => 'blog',
            id => $new_blog->id
        });

        $app->print($plugin->translate_templatized(<<"HTML"));
</ul>
</div>

<p><strong><__trans phrase="Finished! You can <a href=\"javascript:void(0);\" onclick=\"closeDialog('[_1]');\">return to the blog listing</a> or <a href=\"javascript:void(0);\" onclick=\"closeDialog('[_2]');\">configure the Site root and URL of the new blog</a>." params="$return_url%%$setting_url"></strong></p>

<form method="GET">
    <div class="actions-bar">
        <div class="actions-bar-inner pkg actions">
        <button
            onclick="closeDialog('$return_url'); return false"
            type="submit"
            accesskey="x"
            class="primary-button"
            ><__trans phrase="Close"></button>
        </div>
    </div>
</form>

</div>

HTML
    }

    $app->print($app->build_page('dialog/footer.tmpl'));
}

sub _progress {
    my $app = shift;
    my $ids = $app->request('progress_ids') || {};

    my ($str, $id) = @_;
    if ($id && $ids->{$id}) {
        require MT::Util;
        my $str_js = MT::Util::encode_js($str);
        $app->print(qq{<script type="text/javascript">progress('$str_js', '$id');</script>\n});
    } elsif ($id) {
        $ids->{$id} = 1;
        $app->print(qq{<li id="$id">$str</li>\n});
    } else {
        $app->print("<li>$str</li>");
    }

    $app->request('progress_ids', $ids);
}

sub perm_check {
    my $app = MT->instance;
    my $perms = $app->{perms};
    return $perms ? $perms->can_create_blog : $app->user->is_superuser;
}

1;
