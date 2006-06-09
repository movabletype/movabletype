# Copyright 2005-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.
#
# $Id$

package MT::Plugin::StyleCatcher;

use strict;
use base 'MT::Plugin';
use vars qw($VERSION);
$VERSION = '1.01';

my $plugin;
$plugin = MT::Plugin::StyleCatcher->new({
    name => "StyleCatcher",
    version => $VERSION,
    doc_link => "http://www.sixapart.com/movabletype/styles/",
    description => "<MT_TRANS phrase=\"StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href='http://www.sixapart.com/movabletype/styles'>Movable Type styles</a> page.\">",
    config_link => "stylecatcher.cgi",
    author_name => "Nick O'Neil, Brad Choate",
    author_link => "http://www.authenticgeek.net/",
    l10n_class => 'StyleCatcher::L10N',
    config_template => \&configuration_template,
    settings => new MT::PluginSettings([
        ['webthemeroot'],
        ['themeroot'],
        ['stylelibrary'],
    ]),
});
MT->add_plugin($plugin);
MT->add_plugin_action('list_template', 'stylecatcher.cgi', 'Select a Design using StyleCatcher');
MT->add_plugin_action('blog','stylecatcher.cgi?', "Select a Design using StyleCatcher");

sub instance { $plugin }

sub configuration_template {
    my $plugin = shift;
    my ($param, $scope) = @_;

    my $intro;
    if ($scope eq 'system') {
        if (!$param->{webthemeroot}) {
            $param->{webthemeroot} = MT->instance->static_path;
            $param->{webthemeroot} =~ s!/$!!;
            $param->{webthemeroot} .= '/themes/';
        }
        $param->{themeroot} ||= File::Spec->catdir(MT->instance->mt_dir, 'mt-static', 'themes');
        $param->{stylelibrary} ||= $StyleCatcher::DEFAULT_STYLE_LIBRARY;
        $intro = q{<MT_TRANS phrase="You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it's own theme paths, it will use these settings. If a blog has it's own theme paths, then the theme will be copied to that location when applied to that weblog.">};
    } else {
        if (my $blog = MT->instance->blog) {
            if (!$param->{webthemeroot}) {
                my $url = $blog->site_url;
                $url =~ s!/$!!;
                $url .= '/themes/';
                $param->{webthemeroot} = $url;
            }
            if (!$param->{themeroot}) {
                my $path = $blog->site_path;
                $path = File::Spec->catdir($path, 'themes');
                $param->{themeroot} = $path;
            }
        }
        $intro = q{<MT_TRANS phrase="Your theme URL and path can be customized for this weblog.">};
    }

    return qq{
<p>
$intro
<MT_TRANS phrase="The paths defined here must physically exist and be writable by the webserver.">
</p>

<div class="setting">
<div class="label"><label for="stycat_webthemeroot"><MT_TRANS phrase="Theme Root URL:"></label></div>
<div class="field">
<input type="text" name="webthemeroot" id="stycat_webthemeroot" value="<TMPL_VAR NAME=WEBTHEMEROOT ESCAPE=HTML>" style="width: 95%" />
</div>
</div>

<div class="setting">
<div class="label"><label for="stycat_themeroot"><MT_TRANS phrase="Theme Root Path:"></label></div>
<div class="field">
<input type="text" name="themeroot" id="stycat_themeroot" value="<TMPL_VAR NAME=THEMEROOT ESCAPE=HTML>" style="width: 95%" />
</div>
</div>

<div class="setting">
<div class="label"><label for="stycat_stylelibrary"><MT_TRANS phrase="Style Library URL:"></label></div>
<div class="field">
<input type="text" name="stylelibrary" id="stycat_stylelibrary" value="<TMPL_VAR NAME=STYLELIBRARY ESCAPE=HTML>" style="width: 95%" />
</div>
</div>
    };
}

sub save_config {
    my $plugin = shift;
    my ($param, $scope) = @_;
    my $themeroot = $param->{themeroot};

    my $app = MT->instance;

    require MT::FileMgr;
    my $filemgr = MT::FileMgr->new('Local')
        or return $app->error(MT::FileMgr->errstr);

    my $base_weblog_path = File::Spec->catfile($plugin->{full_path},
                                               "base-weblog.css");
    my $base_weblog = $filemgr->get_data($base_weblog_path);
    $filemgr->mkpath($param->{themeroot})
        or die $plugin->translate("Unable to create the theme root directory. Error: [_1]", $filemgr->errstr);

    defined($filemgr->put_data($base_weblog,
        File::Spec->catfile($param->{themeroot}, "base-weblog.css")))
        or die $plugin->translate("Unable to write base-weblog.css to themeroot. File Manager gave the error: [_1]. Are you sure your theme root directory is web-server writable?", $filemgr->errstr);

    return $plugin->SUPER::save_config(@_);
}

1;
