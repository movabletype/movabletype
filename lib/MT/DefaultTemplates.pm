# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::DefaultTemplates;

use strict;

=pod
Registry storage format for default templates:

default_templates:
    index:
        # The identifier used here never changes for this
        # template. It is also unique.
        main_index:
            filename: (optional; defaults to <identifier>.mtml)
            label: Main Index (auto-translated)
            outfile: (applicable for index templates only)
            rebuild_me: (applicable for index templates only)

=cut

my $loaded = 0;
my $templates;
BEGIN {
    $templates = {
        'index' => {
            'main_index' => {
                label => 'Main Index',
                outfile => 'index.html',
                rebuild_me => 1,
            },
            'archive_index' => {
                label => 'Archive Index',
                outfile => 'archives.html',
                rebuild_me => 1,
            },
            'styles' => {
                label => 'Stylesheet',
                outfile => 'styles.css',
                rebuild_me => 1,
            },
            'javascript' => {
                label => 'JavaScript',
                outfile => 'mt.js',
                rebuild_me => 1,
            },
            'feed_recent' => {
                label => 'Feed - Recent Entries',
                outfile => 'atom.xml',
                rebuild_me => 1,
            },
            'rsd' => {
                label => 'RSD',
                outfile => 'rsd.xml',
                rebuild_me => 1,
            },
        },
        'individual' => {
            'entry' => {
                label => 'Entry',
                mappings => {
                    entry_archive => {
                        archive_type => 'Individual',
                    },
                },
            },
        },
        'page' => {
            'page' => {
                label => 'Page',
                mappings => {
                    page_archive => {
                        archive_type => 'Page',
                    },
                },
            },
        },
        'archive' => {
            'monthly_entry_listing' => {
                label => 'Monthly Entry Listing',
                mappings => {
                    monthly => {
                        archive_type => 'Monthly',
                    },
                },
            },
            'category_entry_listing' => {
                label => 'Category Entry Listing',
                mappings => {
                    category => {
                        archive_type => 'Category',
                    },
                },
            },
        },
        'system' => {
            'comment_response' => {
                label => 'Comment Response',
                description_label => 'Displays error, pending or confirmation message for comments.'
            },
            'comment_preview' => {
                label => 'Comment Preview',
                description_label => 'Displays preview of comment.',
            },
            'dynamic_error' => {
                label => 'Dynamic Error',
                description_label => 'Displays errors for dynamically published templates.',
            },
            'popup_image' => {
                label => 'Popup Image',
                description_label => 'Displays image when user clicks a popup-linked image.',
            },
            'search_results' => {
                label => 'Search Results',
                description_label => 'Displays results of a search.',
            },
        },
        'module' => {
            'banner_header' => {
                label => 'Banner Header',
            },
            'banner_footer' => {
                label => 'Banner Footer',
            },
            'entry_summary' => {
                label => 'Entry Summary',
            },
            'html_head' => {
                label => 'HTML Head',
            },
            'sidebar' => {
                label => 'Sidebar',
            },
            'comments' => {
                label => 'Comments',
            },
            'trackbacks' => {
                label => 'Trackbacks',
            },
        },
        'widget' => {
            'about_this_page' => {
                label => 'About This Page',
            },
            'archive_widgets_group' => {
                label => 'Archive Widgets Group',
            },
            'author_archive_list' => {
                label => 'Author Archives',
            },
            'current_author_monthly_archive_list' => {
                label => 'Current Author Monthly Archives',
            },
            'calendar' => {
                label => 'Calendar',
            },
            'category_archive_list' => {
                label => 'Category Archives',
            },
            'current_category_monthly_archive_list' => {
                label => 'Current Category Monthly Archives',
            },
            'creative_commons' => {
                label => 'Creative Commons',
            },
            'main_index_widgets_group' => {
                label => 'Home Page Widgets Group',
            },
            'monthly_archive_dropdown' => {
                label => 'Monthly Archives Dropdown',
            },
            'monthly_archive_list' => {
                label => 'Monthly Archives',
            },
            'pages_list' => {
                label => 'Page Listing',
            },
            'recent_assets' => {
                label => 'Recent Assets',
            },
            'powered_by' => {
                label => 'Powered By',
            },
            'recent_comments' => {
                label => 'Recent Comments',
            },
            'recent_entries' => {
                label => 'Recent Entries',
            },
            'search' => {
                label => 'Search',
            },
            'signin' => {
                label => 'Sign In',
            },
            'syndication' => {
                label => 'Syndication',
            },
            'tag_cloud' => {
                label => 'Tag Cloud',
            },
            'technorati_search' => {
                label => 'Technorati Search',
            },
            'date_based_author_archives' => {
                label => 'Date-Based Author Archives',
            },
            'date_based_category_archives' => {
                label => 'Date-Based Category Archives',
            },
            'openid' => {
                label => 'OpenID Accepted',
            },
        },
        'widgetset' => {
            '2column_layout_sidebar' => {
                order => 1000,
                label   => '2-column layout - Sidebar',
                widgets => [
                    'Search',
                    'About This Page',
                    'Home Page Widgets Group',
                    'Archive Widgets Group',
                    'Page Listing',
                    'Syndication',
                    'OpenID Accepted',
                    'Powered By',
                ],
            },
            '3column_layout_primary_sidebar' => {
                order => 1000,
                label   => '3-column layout - Primary Sidebar',
                widgets => [
                    'Archive Widgets Group',
                    'Page Listing',
                    'Syndication',
                    'OpenID Accepted',
                    'Powered By',
                ],
            },
            '3column_layout_secondary_sidebar' => {
                order => 1000,
                label   => '3-column layout - Secondary Sidebar',
                widgets => [
                    'Search',
                    'Home Page Widgets Group',
                    'About This Page',
                ],
            },
        },
        'global:module' => {
            'footer-email' => {
                label => 'Mail Footer',
            },
        },
        'global:email' => {
            'comment_throttle' => {
                label => 'Comment throttle',
            },
            'commenter_confirm' => {
                label => 'Commenter Confirm',
            },
            'commenter_notify' => {
                label => 'Commenter Notify',
            },
            'new-comment' => {
                label => 'New Comment',
            },
            'new-ping' => {
                label => 'New Ping',
            },
            'notify-entry' => {
                label => 'Entry Notify',
            },
            'recover-password' => {
                label => 'Password Recovery',
            },
            'verify-subscribe' => {
                label => 'Subscribe Verify',
            },
        },
    };
}

sub core_default_templates {
    return $templates;
}

sub load {
    my $class = shift;
    my ($terms) = @_;
    my $tmpls = $class->templates || [];
    if ($terms) {
        foreach my $key (keys %$terms) {
            @$tmpls = grep { $_->{$key} eq $terms->{$key} } @$tmpls;
        }
    }
    return wantarray ? @$tmpls : (@$tmpls ? $tmpls->[0] : undef);
}

sub templates {
    my $pkg = shift;
    my ($set) = @_;
    require File::Spec;

    # A set of default templates as returned by MT::Component->registry
    # yields an array of hashes.

    my @tmpl_path = $set ? ("template_sets", $set) : ("default_templates");
    my $all_tmpls = MT::Component->registry(@tmpl_path) || [];
    my $weblog_templates_path = MT->config('WeblogTemplatesPath');

    my (%tmpls, %global_tmpls);
    foreach my $def_tmpl (@$all_tmpls) {
        # copy structure, then run filter

        my $tmpl_hash;
        if ($def_tmpl->{templates} && ($def_tmpl->{templates} eq '*')) {
            $tmpl_hash = MT->registry("default_templates");
        }
        else {
            $tmpl_hash = $set ? $def_tmpl->{templates} : $def_tmpl;
        }
        my $plugin = $tmpl_hash->{plugin};

        foreach my $tmpl_set (keys %$tmpl_hash) {
            next unless ref($tmpl_hash->{$tmpl_set}) eq 'HASH';
            foreach my $tmpl_id (keys %{ $tmpl_hash->{$tmpl_set} }) {
                next if $tmpl_id eq 'plugin';
                my $p = $tmpl_hash->{plugin} || $tmpl_hash->{$tmpl_set}{plugin};
                my $base_path = $def_tmpl->{base_path} || $tmpl_hash->{$tmpl_set}{base_path};
                if ($p && $base_path) {
                    $base_path = File::Spec->catdir($p->path, $base_path);
                }
                else {
                    $base_path = $weblog_templates_path;
                }

                my $tmpl = { %{ $tmpl_hash->{$tmpl_set}{$tmpl_id} } };
                my $type = $tmpl_set;
                if ($tmpl_set =~ m/^global:/) {
                    $type =~ s/^global://;
                    $tmpl->{global} = 1;
                }
                $tmpl->{set} = $type; # system, index, archive, etc.
                $tmpl->{order} = 0 unless exists $tmpl->{order};

                $type = 'custom' if $type eq 'module';
                $type = $tmpl_id if $type eq 'system';
                my $name = $tmpl->{label};
                $name = $name->() if ref($name) eq 'CODE';
                $tmpl->{name} = $name;
                $tmpl->{type} = $type;
                $tmpl->{key} = $tmpl_id;
                $tmpl->{identifier} = $tmpl_id;

                if ( exists $tmpl->{widgets} ) {
                    my $widgets = $tmpl->{widgets};
                    my @widgets;
                    foreach my $widget ( @$widgets ) {
                        if ( $plugin ) {
                            push @widgets, $plugin->translate( $widget );
                        }
                        else {
                            push @widgets, MT->translate( $widget );
                        }
                    }
                    $tmpl->{widgets} = \@widgets if @widgets;
                } else {
                    # load template if it hasn't been loaded already
                    if (!exists $tmpl->{text}) {
                        local (*FIN, $/);
                        my $filename = $tmpl->{filename} || ($tmpl_id . '.mtml');
                        my $file = File::Spec->catfile($base_path, $filename);
                        if ((-e $file) && (-r $file)) {
                            open FIN, "<$file"; my $data = <FIN>; close FIN;
                            $tmpl->{text} = $data;
                        } else {
                            $tmpl->{text} = '';
                        }
                    }
                }

                my $local_global_tmpls = $tmpl->{global} ? \%global_tmpls : \%tmpls;
                my $tmpl_key = $type . ":" . $tmpl_id;
                if (exists $local_global_tmpls->{$tmpl_key}) {
                    # allow components/plugins to override core
                    # templates
                    $local_global_tmpls->{$tmpl_key} = $tmpl if $p && ($p->id ne 'core');
                }
                else {
                    $local_global_tmpls->{$tmpl_key} = $tmpl;
                }
            }
        }
    }
    my @tmpls = (values(%tmpls), values(%global_tmpls));
    # sort widgets to process last, since they rely on the widgets to exist first.
    @tmpls = sort _template_sort @tmpls;
    MT->run_callbacks('DefaultTemplateFilter' . ($set ? '.' . $set : ''), \@tmpls);
    return \@tmpls;
}

sub _template_sort {
    if ( $a->{type} eq 'widgetset' ) {
        return 1 unless $b->{type} eq 'widgetset';
    }
    elsif ($b->{type} eq 'widgetset') {
        # a is not a widgetset
        return -1;
    }
    # both a, b == widgetset or both a, b != widgetset
    return $a->{order} <=> $b->{order};
}

1;
__END__

=head1 NAME

MT::DefaultTemplates

=head1 METHODS

=head2 templates()

Return the list of the templates in the WeblogTemplatesPath.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
