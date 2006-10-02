# GoogleSearch plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package MT::Plugin::GoogleSearch;

use strict;
use MT::Plugin;
@MT::Plugin::GoogleSearch::ISA = qw(MT::Plugin);

use MT;
my $plugin = new MT::Plugin::GoogleSearch({
    name => "Google Search",
    version => '1.0',
    description => "<MT_TRANS phrase=\"Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href='http://www.google.com/apis/'>license key.</a>\">",
    author_name => "Six Apart, Ltd.",
    author_link => "http://www.sixapart.com/",
    settings => new MT::PluginSettings([
        ['google_api_key'],
    ]),
    config_template => 'config.tmpl',
    l10n_class => 'GoogleSearch::L10N',
});
MT->add_plugin($plugin);

use MT::Template::Context;
MT::Template::Context->add_container_tag(GoogleSearch => \&_hdlr_google_search);
MT::Template::Context->add_tag(GoogleSearchResult => \&_hdlr_google_search_result);

sub google_api_key {
    my $plugin = shift;
    my ($blog_id) = @_;
    my %plugin_param;

    $plugin->load_config(\%plugin_param, 'blog:'.$blog_id);
    my $key = $plugin_param{google_api_key};
    unless ($key) {
        $plugin->load_config(\%plugin_param, 'system');
        $key = $plugin_param{google_api_key};
    }
    $key;
}

sub load_config {
    my $plugin = shift;
    my ($param, $scope) = @_;

    if ($scope && $scope eq 'system') {
        $plugin->SUPER::load_config(@_);
        return;
    }

    # load blog
    $scope =~ s/.*://; # strip off id, leave identifier
    my $blog = MT::Blog->load($scope);
    $param->{google_api_key} = $blog->google_api_key;
}

sub save_config {
    my $plugin = shift;
    my ($param, $scope) = @_;

    if ($scope && $scope eq 'system') {
        $plugin->SUPER::save_config(@_);
        return;
    }

    # load blog
    $scope =~ s/.*://; # strip off id, leave identifier
    use MT::Blog;
    my $blog = MT::Blog->load($scope);
    $blog->google_api_key($param->{google_api_key});
    $blog->save
        or die $blog->errstr;
}

sub _hdlr_google_search {
    my($ctx, $args, $cond) = @_;
    my $query;
    my $blog = $ctx->stash('blog');
    if ($query = $args->{query}) {
    } elsif (my $url = $args->{related}) {
        $query = 'related:' . ($url eq '1' ? $blog->site_url : $url);
    } elsif ($args->{title}) {
        $query = $ctx->_hdlr_entry_title or return '';
    } elsif ($args->{excerpt}) {
        $query = $ctx->_hdlr_entry_excerpt or return '';
    } elsif ($args->{keywords}) {
        $query = $ctx->_hdlr_entry_keywords or return '';
    }
    $query = $ctx->stash('search_string') unless defined $query;
    if (!defined $query) {
        return $ctx->error($plugin->translate(
            'You used [_1] without a query.', '<MTGoogleSearch>' ));
    }

    my $enc = MT->instance->config('PublishCharset') || undef;
    use utf8;
    $query = MT::I18N::decode_utf8($query, $enc);
    my $key = $plugin->google_api_key($blog->id)
        or return $ctx->error($plugin->translate(
            'You need a Google API key to use [_1]', '<MTGoogleSearch>' ));

    my $max = $args->{results} || 10;
    my $lang = $args->{lang} || 'lang_en';

    require SOAP::Lite;
    require File::Basename;
    ## Look for GoogleSearch.wsdl in the plugin/GoogleSearch directory.
    my $dir = File::Basename::dirname(__FILE__);
    my $wsdl = File::Spec->catfile($dir, 'GoogleSearch.wsdl');
    {
        ## Turn off warnings, because the following can cause a
        ## "subroutine redefined" warning.
        local $^W = 0;
        *SOAP::XMLSchema1999::Deserializer::as_boolean =
        *SOAP::XMLSchemaSOAP1_1::Deserializer::as_boolean =
        \&SOAP::XMLSchema2001::Deserializer::as_boolean;

    }
    my $result;
    eval {
        my $googleSearch = SOAP::Lite -> service("file:" . $wsdl);
        $result = $googleSearch->doGoogleSearch($key, $query, 0, $max,
                                                "false", "", "false",
                                                $lang, "UTF-8", "UTF-8");
    };
    warn $@, return '' if $@;
    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $res = '';
    for my $rec (@{ $result->{resultElements} }) {
        $ctx->stash('google_result', $rec);
        my $out = $builder->build($ctx, $tokens, $cond);
        return $ctx->error( $builder->errstr ) unless defined $out;
        $res .= $out;
    }
    $res;
}

sub _hdlr_google_search_result {
    my($ctx, $args) = @_;
    my $res = $ctx->stash('google_result')
        or return $ctx->error($plugin->translate(
           "You used an [_1] tag outside of the proper context.",
           '<$MTGoogleSearchResult$>' ));
    my $prop = $args->{property} || 'title';
    my $enc = MT->instance->config('PublishCharset') || undef;

    exists $res->{$prop}
        or return $ctx->error($plugin->translate(
            'You used a non-existent property from the result structure.' ));
    MT::I18N::encode_text(MT::I18N::utf8_off($res->{$prop}), 'utf-8', $enc) || '';
}

