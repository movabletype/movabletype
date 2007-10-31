# Blog Cloner plugin for Movable Type
# Author: Brad Choate, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package MT::Plugin::Cloner;

use strict;

use MT 3.3;
use base 'MT::Plugin';

our $VERSION = '1.4';

my $plugin = MT::Plugin::Cloner->new({
    name        => "Weblog Cloner",
    version     => $VERSION,
    description => "<MT_TRANS phrase=\"Clones a weblog and all of its contents.\">",
    author_name => "Six Apart, Ltd.",
    author_link => 'http://www.sixapart.com/',
    app_itemset_actions => {
        'MT::App::CMS' => {
            'blog' => {
                key => 'plugin:cloner:clone_blog',
                label => 'Clone Weblog',
                code => \&itemset_clone_blog,
                condition => \&perm_check,
                max => 1,
                dialog => 1,
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
        return $app->error($plugin->translate("No weblog was selected to clone."));
    }
    if (scalar @id > 1) {
        return $app->error($plugin->translate("This action can only be run for a single weblog at a time."));
    }
    my $blog_id = shift @id;
    my $blog = MT::Blog->load($blog_id)
        or return $app->error($plugin->translate("Invalid blog_id"));
    my $blog_name = $blog->name;

    # Set up and commence app output
    $app->{no_print_body} = 1;
    $app->send_http_header;
    local $app->{defer_build_page} = 0;
    $app->print($app->build_page('dialog/header.tmpl'));
    $app->print($plugin->translate_templatized(<<"HTML"));
<script type="text/javascript">
function progress(str, id) {
    var el = getByID(id);
    if (el) el.innerHTML = str;
}
</script>

<div class="modal_width dialog" id="dialog-clone-weblog">
<div id="cloning-panel" class="panel">
<h2><span class="weblog-title-highlight"><MT_TRANS phrase="Cloning Weblog">:</span> $blog_name</h2>
<div class="list-data-wrapper list-data">
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
        my $blog_url = $app->uri(mode => 'menu', args => {
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
<div><p class="page-desc"><MT_TRANS phrase="Finished! You can <a href=\"javascript:void(0);\" onclick=\"closeDialog('[_1]');\">return to the weblogs listing</a> or <a href=\"javascript:void(0);\" onclick=\"closeDialog('[_2]');\">configure the Site root and URL of the new weblog</a>." params="$return_url%%$setting_url"></p></div>
<div class="panel-commands">
<input type="button" value="<MT_TRANS phrase="Close">" onclick="closeDialog('$return_url')" />
</div>
</div>
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
