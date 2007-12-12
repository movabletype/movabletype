# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more details, consult 
# your Movable Type license for details.
#
# $Id$

package MT::DefaultTemplates;

use strict;

=start
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
            },
            'rsd' => {
                label => 'RSD',
                outfile => 'rsd.xml',
                rebuild_me => 1,
            },
            'atom' => {
                label => 'Atom',
                outfile => 'atom.xml',
                rebuild_me => 1,
            },
            'rss' => {
                label => 'RSS',
                outfile => 'rss.xml',
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
            'entry_listing' => {
                label => 'Entry Listing',
                mappings => {
                    monthly => {
                        archive_type => 'Monthly',
                    },
                    category_monthly => {
                        archive_type => 'Category-Monthly',
                    },
                    author_monthly => {
                        archive_type => 'Author-Monthly',
                    },
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
            'categories' => {
                label => 'Categories',
            },
            'comment_detail' => {
                label => 'Comment Detail',
            },
            'comment_form' => {
                label => 'Comment Form',
            },
            'comments' => {
                label => 'Comments',
            },
            'entry_detail' => {
                label => 'Entry Detail',
            },
            'entry_summary' => {
                label => 'Entry Summary',
            },
            'entry_metadata' => {
                label => 'Entry Metadata',
            },
            'tags' => {
                label => 'Tags',
            },
            'footer' => {
                label => 'Footer',
            },
            'header' => {
                label => 'Header',
            },
            'sidebar_2col' => {
                label => 'Sidebar - 2 Column Layout',
            },
            'sidebar_3col' => {
                label => 'Sidebar - 3 Column Layout',
            },
            'trackbacks' => {
                label => 'TrackBacks',
            },
            'page_detail' => {
                label => 'Page Detail',
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
                label => 'new Ping',
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

    my %tmpls;
    foreach my $def_tmpl (@$all_tmpls) {
        # copy structure, then run filter

        my $tmpl_hash;
        if ($def_tmpl->{templates} && ($def_tmpl->{templates} eq '*')) {
            $tmpl_hash = MT->registry("default_templates");
        }
        else {
            $tmpl_hash = $set ? $def_tmpl->{templates} : $def_tmpl;
        }

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

                $type = 'custom' if $type eq 'module';
                $type = $tmpl_id if $type eq 'system';
                my $name = $tmpl->{label};
                $name = $name->() if ref($name) eq 'CODE';
                $tmpl->{name} = $name;
                $tmpl->{type} = $type;
                $tmpl->{key} = $tmpl_id;
                $tmpl->{identifier} = $tmpl_id;

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

                if (exists $tmpls{$tmpl_id}) {
                    # allow components/plugins to override core
                    # templates
                    $tmpls{$tmpl_id} = $tmpl if $tmpls{$tmpl_id}->{global} && !$tmpl->{global};
                    $tmpls{$tmpl_id} = $tmpl if $p && ($p->id ne 'core');
                }
                else {
                    $tmpls{$tmpl_id} = $tmpl;
                }
            }
        }
    }
    my @tmpls = values %tmpls;
    MT->run_callbacks('DefaultTemplateFilter' . ($set ? '.' . $set : ''), \@tmpls);
    return \@tmpls;
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
