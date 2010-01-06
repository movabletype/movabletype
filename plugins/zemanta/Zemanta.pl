# Zemanta plugin for Movable Type
# Created by Tomaz Solc <tomaz@zemanta.com> Copyright (c) 2009 Zemanta Ltd.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as
# published by the Free Software Foundation
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

package MT::Plugin::Zemanta;

use strict;

use base qw( MT::Plugin );

my $product;

eval {
	require Zemanta::Pro;
	$product = Zemanta::Pro->new();
};
eval {
	require Zemanta::Basic;
	$product = Zemanta::Basic->new();
} unless( $product );

unless( $product ) {
	die("Can't load either Zemanta::Pro or Zemanta::Basic module: $@");
}

# Versions without "c" are shipped integrated into official MovableType 
# distributions.

# Versions ending with "c" are shipped in standalone packages on 
# movabletype.org (the suffix is added by the build.sh script)
our $VERSION = '0.8';

my $DESCRIPTION = <<END
<p>Zemanta is a powerful authoring assistance tool that will save you time, make your posts more compelling, boost your discoverability by search engines, increase your content's visibility among syndicators, and inspire you to write more informed posts.</p>

<p>It all starts with simple point & click enrichment of your blog posts in real-time, while you type. Zemanta suggests tags, in-text links, photos, videos, maps, slideshows, and related articles from other bloggers and publishers. It can also be used as a research tool and idea generator.</p>

<p>The free version can be personalized (e.g. add your Flickr account, RSS feeds, social networks). The Enterprise version, for professional publishers, can be customized extensively to suit multi-user platforms with full control over the content recommendation pool. Contact our <a href="mailto:sales\@zemanta.com">sales department</a> for more information.</p>
END
;

my %CONFIG = ( (
	description => $DESCRIPTION,
	version     => $VERSION,
	author_name => "Tomaz Solc, Zemanta Ltd.",
	author_link => "http://www.zemanta.com",
	doc_link    => "http://www.zemanta.com/faq/movabletype",
	plugin_link => "http://plugins.movabletype.org/zemanta/",
), %{$product->plugin_config()} ); 

my $plugin = MT::Plugin::Zemanta->new( \%CONFIG,  );

MT->add_plugin($plugin);

if( $MT::VERSION < 4.0 ) {
	MT->add_callback('bigpapi::template::edit_entry', 
			9, $plugin, sub { $plugin->edit_entry_3(@_); } );
	MT->add_callback('bigpapi::template::list_plugin::top', 
			9, $plugin, sub { $plugin->cfg_plugin(@_); } );
}

sub javascript_block {
	my ($api_key, $envelope) = @_;

	my $loader_version;
	if( $MT::VERSION < 5.0 ) {
		$loader_version = "4.x";
	} else {
		$loader_version = "5.x";
	}

	return <<END
<!-- Begin Zemanta scripts -->
<script type="text/javascript">
window.ZemantaGetAPIKey = function () { return "$api_key"; };
window.ZemantaJSONProxy = function () { return "$envelope/json-proxy.cgi"; };
window.ZemantaPluginVersion = function () { return "$VERSION"; };
if( customizable_fields ) {
	customizable_fields.push('zemanta');
}
</script>
<script id="zemanta-loader" type="text/javascript" src="http://fstatic.zemanta.com/plugins/movabletype/$loader_version/loader.js"></script>
<!-- End Zemanta scripts -->
END
}

# Support for "Display options" menu in MT 4.x

sub entry_prefs_enable_zemanta {
	# This depends on the internal representation of the entry_prefs field
	# (see _parse_entry_prefs in MT::App::CMS.pm)
	my ($prefs) = @_;
	my $pos;

	( $prefs, $pos ) = split(/\|/, $prefs);
	my @p = grep { !/^zemanta/ } split(/,/, $prefs);
	unshift(@p, "zemanta");

	return join(',', @p) . ($pos ? "|$pos" : "");
}

sub entry_prefs_first_run {
	my ($param, $blog_id) = @_;

	my $have_default;

	# When we see a blog for the first time, update "Entry preferences"
	# in the database for all authors, plus special author 0 (which
	# is the default for users that haven't modified their
	# "display settings" dialogs).

	my $iter = MT::Permission->load_iter({ blog_id => $blog_id });
	while( my $perm = $iter->() ) {

		my $modified = 0;

		for my $prefs_column ('entry_prefs', 'page_prefs') {
			if( $perm->has_column($prefs_column) ) {
				my $prefs = $perm->$prefs_column;

				# Empty field means default settings are used: don't
				# touch that.
				if( $prefs ) {
					$prefs = entry_prefs_enable_zemanta($prefs);
					$perm->$prefs_column($prefs);
					$modified = 1;
				}
			}
		}

		if( $modified ) {
			$perm->save();
			$have_default = 1 if $perm->author_id == 0;
		}
	}

	# If the default setting for a blog hasn't been modified, there
	# is no entry in the database, instead a hardcoded list of 
	# settings is used (in _parse_entry_prefs)

	unless( $have_default || !$blog_id ) {
		# Since we can't change the hardcoded list,
		# make a new modified default for new blogs.
		#
		# This way Zemanta will also be enabled by default on
		# blogs that were created after installing the plugin.
		#
		# It enables the "basic" default group of settings + Zemanta
		my @perms = MT::Permission->load({ blog_id => $blog_id, author_id => 0 });

		my $perm;
		if( @perms ) {
			$perm = $perms[0];
		} else {
			$perm = MT::Permission->new();
			$perm->author_id(0);
			$perm->blog_id($blog_id);
		}
		for my $prefs_column ('entry_prefs', 'page_prefs') {
			if( $perm->has_column($prefs_column) && !$perm->$prefs_column ) {
				$perm->$prefs_column("zemanta,basic");
			}
		}
		$perm->save();
	}

	# Now that the database has been changed, also change parameters
	# passed to the template for the first run:

	$param->{disp_prefs_show_zemanta} = 1;
	$param->{entry_disp_prefs_show_zemanta} = 1;
	$param->{page_disp_prefs_show_zemanta} = 1;

	my @default_fields = grep { $_->{name} ne "zemanta" } @{$param->{disp_prefs_default_fields}};
	push(@default_fields, { 'name' => 'zemanta' });
	$param->{disp_prefs_default_fields} = \@default_fields;
}

# DOM transformation callbacks for MT 4.x

sub edit_entry {
	my $plugin = shift;
        my ($cb, $app, $param, $tmpl) = @_;

	my $blog = $app->blog;
	my $blog_id = $blog->id;

	my $api_key = $product->get_apikey( $plugin, $blog );
	return unless $api_key;

	# We place our mt:var element right before the header include.
	# This way our Javascript gets appended at the very end of the
	# js_include block.
	my $header_node = $tmpl->getElementById('header_include');
	return unless $header_node;

	$tmpl->insertBefore(
		$tmpl->createElement('var', { 
			name => 'js_include',
			append => 1,
			value => javascript_block($api_key, $plugin->envelope)
		} ),
		$header_node);

	# Enable Zemanta in "Display options" for all blogs and users on first
	# run of the plugin.
	if( $plugin->get_config_value("first_run", "blog:$blog_id") ) {
		entry_prefs_first_run($param, $blog_id);
		$plugin->set_config_value("first_run", "", "blog:$blog_id");
	}

	# Add a <div> tag in the sidebar so loader.js can insert Zemanta widget
	# into it. Hide it if user has disabled Zemanta in "Display Options".
	my $div_class = $param->{disp_prefs_show_zemanta} ? '' : ' class="hidden"';

	$tmpl->insertAfter(
		$tmpl->createElement('var', {
			name => 'related_content', 
			prepend => 1,
			value => "<div id=\"zemanta-field\"$div_class></div>"
		} ),
		$header_node);

	# Add a check-box into the "Display Options" drop-down menu.
	my $disp_prefs_node =	$tmpl->getElementById('metadata_fields') || 	# MT >= 4.26
				$tmpl->getElementById('entry_fields');		# MT 4.21
				
	my $checked = $param->{disp_prefs_show_zemanta} ? ' checked="checked"' : '';

	my $disp_prefs_html = $disp_prefs_node->innerHTML();
	$disp_prefs_html =~ s#</ul>#<li><label><input 	type="checkbox" name="custom_prefs" 
							id="custom-prefs-zemanta"
							value="zemanta"
							onclick="setCustomFields(); return true"
							class="cb"
							$checked/> Zemanta</label></li></ul>#;
	$disp_prefs_node->innerHTML($disp_prefs_html);
}

sub cfg_entry {
	my $plugin = shift;
        my ($cb, $app, $param, $tmpl) = @_;

	my $blog = $app->blog;
	my $blog_id = $blog->id;

	# Fetch an API key
	$product->set_automatic_apikey( $plugin, $blog );
	
	# Enable Zemanta in "Display options" for all blogs and users on first
	# run of the plugin.
	if( $plugin->get_config_value("first_run", "blog:$blog_id") ) {
		entry_prefs_first_run($param, $blog_id);
		$plugin->set_config_value("first_run", "", "blog:$blog_id");
	}

	# Add a check-box into the "Compose Defaults" section
	# under "Entry fields" and "Page Fields" (MT 5.x)

	my $entry_checked = $param->{entry_disp_prefs_show_zemanta} ? ' checked="checked"' : '';

	$tmpl->insertAfter(
		$tmpl->createElement('var', { 
			name => 'entry_fields', 
			append => 1, 
			value => '<li><input type="checkbox" name="entry_custom_prefs" id="entry-prefs-zemanta" value="zemanta" class="cb" ' . $entry_checked . '/> <label for="entry-prefs-zemanta">Zemanta</label></li>'
		} ),
		$tmpl->getElementById('entry_fields') );

	my $page_checked = $param->{page_disp_prefs_show_zemanta} ? ' checked="checked"' : '';

	$tmpl->insertAfter(
		$tmpl->createElement('var', { 
			name => 'page_fields', 
			append => 1, 
			value => '<li><input type="checkbox" name="page_custom_prefs" id="page-prefs-zemanta" value="zemanta" class="cb" ' . $page_checked . '/> <label for="page-prefs-zemanta">Zemanta</label></li>'
		} ),
		$tmpl->getElementById('page_fields') );

	# Add a check-box into the "Default Editor Fields" section (MT 4.x)

	my $old_checked = $param->{disp_prefs_show_zemanta} ? ' checked="checked"' : '';

	$tmpl->insertAfter(
		$tmpl->createElement('var', { 
			name => 'more_fields', 
			append => 1, 
			value => '<li><input type="checkbox" name="custom_prefs" id="custom-prefs-zemanta" value="zemanta" class="cb" ' . $old_checked . '/> <label for="custom-prefs-zemanta">Zemanta</label></li>'
		} ),
		$tmpl->getElementById('more_fields') );
}

sub cfg_plugin {
	my $plugin = shift;
        my ($cb, $app, $param, $tmpl) = @_;

	my $blog = $app->blog;

	# Fetch an API key
	$product->set_automatic_apikey( $plugin, $blog );
}

# BigPAPI template callbacks for MT 3.2

sub edit_entry_3 {
	my $plugin = shift;
        my ($cb, $app, $template) = @_;

	# This is called for each TMPL_INCLUDEd template as well as 
	# edit_entry.tmpl ...
	return unless $$template =~ /<\/head>/i;

	my $blog = $app->blog;

	my $api_key = $product->get_apikey( $plugin, $blog );
	return unless $api_key;

	my $javascript = javascript_block($api_key, $plugin->envelope);

	# Template can include many <head>s nested in TMPL_IFs
	$$template =~ s/<\/head>/$javascript<\/head>/gi;
}

# Overloaded methods

sub load_config {
	my $plugin = shift;

	$plugin->SUPER::load_config(@_);
	$product->load_config($plugin, @_);
}

sub reset_config {
	my $plugin = shift;

	$product->reset_config($plugin, @_);
}

# This method is not called on MT 3.x
sub init_registry {
	my $plugin = shift;
	$plugin->registry({
		callbacks => {
			'MT::App::CMS::template_param.edit_entry' => 
					sub { $plugin->edit_entry(@_); },
			'MT::App::CMS::template_param.cfg_plugin' => 
					sub { $plugin->cfg_plugin(@_); },
			'MT::App::CMS::template_param.cfg_entry' => 
					sub { $plugin->cfg_entry(@_); }
	}
	});
}

1;
