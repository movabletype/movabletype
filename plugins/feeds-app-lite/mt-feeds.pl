# Copyright 2002-2006 Appnel Internet Solutions, LLC
# This code is distributed with permission by Six Apart

package MT::Plugin::FeedsLite;

use strict;
use base qw( MT::Plugin );

our $VERSION = '1.02';

my $plugin = __PACKAGE__->new;
MT->add_plugin($plugin);

sub instance    { $plugin }
sub id          { 'FeedsAppLite' }
sub key         { __PACKAGE__ }
sub name        { 'Feeds.App Lite' }
sub author_name { 'Appnel Solutions' }
sub author_link { 'http://www.appnel.com/' }
sub plugin_link { '' }
sub version     { $MT::FeedsLite::VERSION }
sub doc_link    { 'docs/index.html' }

sub description {
    return <<DESC;
<MT_TRANS phrase="Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?"> <a href="http://code.appnel.com/feeds-app" target="_blank"><MT_TRANS phrase="Upgrade to Feeds.App"></a>.
DESC
}

sub init {
    my $plugin = shift;
    $plugin->SUPER::init(@_);
    $plugin->{registry} = {
        applications => {
            cms => {
                methods => {
                    feedswidget_start => '$FeedsAppLite::FeedsWidget::CMS::start',
                    feedswidget_select => '$FeedsAppLite::FeedsWidget::CMS::select',
                    feedswidget_config   => '$FeedsAppLite::FeedsWidget::CMS::configuration',
                    feedswidget_save     => '$FeedsAppLite::FeedsWidget::CMS::save',
                },
                page_actions => {
                    list_templates => {
                        'feeds_app_lite' => {
                            label => 'Create a Feed Widget',
                            dialog  => 'feedswidget_start',
                            permission => 'edit_templates',
                        }
                    },
                },
            },
        },
        tags => {
            block => {
                Feed => 'MT::Feeds::Tags::feed',
                FeedEntries => 'MT::Feeds::Tags::entries',
            },
            function => {
                FeedTitle => 'MT::Feeds::Tags::feed_title',
                FeedLink => 'MT::Feeds::Tags::feed_link',
                FeedEntryTitle => 'MT::Feeds::Tags::entry_title',
                FeedEntryLink => 'MT::Feeds::Tags::entry_link',
                FeedInclude => 'MT::Feeds::Tags::include',
            },
        },
    };
}

sub load_config {
    my $plugin = shift;
    my ($param, $scope) = @_;
    $plugin->SUPER::load_config(@_);
    if ($scope =~ m/^blog:(\d+)$/) {
        $param->{blog_id} = $1;
    }
}

1;
