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
            name:
            label: Main Index
            outfile:
            rebuild_me:

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
                label => 'Stylesheet - Main',
                outfile => 'styles.css',
                rebuild_me => 1,
            },
            'base_theme' => {
                label => 'Stylesheet - Base Theme',
                outfile => 'base_theme.css',
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
            },
        },
        'page' => {
            'page' => {
                label => 'Page',
            },
        },
        'archive' => {
            'entry_listing' => {
                label => 'Entry Listing',
            },
        },
        'system' => {
            'comment_response' => {
                label => 'Comment Response',
                description_label => 'Shown for a comment error, pending or confirmation message.',
            },
            'comment_preview' => {
                label => 'Comment Preview',
                description_label => 'Shown when a commenter previews their comment.',
            },
            'dynamic_error' => {
                label => 'Dynamic Error',
                description_label => 'Shown when an error is encountered on a dynamic blog page.',
            },
            'popup_image' => {
                label => 'Popup Image',
                description_label => 'Shown when a visitor clicks a popup-linked image.',
            },
            'search_results' => {
                label => 'Search Results',
                description_label => 'Shown when a visitor searches the weblog.',
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
    unless ($loaded) {
        require MT::Util;
        require MT;
        use File::Spec;
        my $path = MT->config('WeblogTemplatesPath');
        local (*FIN, $/);
        $/ = undef;
        foreach my $tmpl_set (keys %$templates) {
            foreach my $tmpl_id (keys %{ $templates->{$tmpl_set} }) {
                my $tmpl = $templates->{$tmpl_set}{$tmpl_id};
                my $file = File::Spec->catfile($path, $tmpl_id . '.mtml');
                if ((-e $file) && (-r $file)) {
                    open FIN, "<$file"; my $data = <FIN>; close FIN;
                    $tmpl->{text} = $data;
                } else {
                    $tmpl->{text} = '';
                }
            }
        }
        $loaded = 1;
    }

    my $def_tmpl = MT->registry('default_templates') || {};
    my @tmpls;

    # copy structure, then run filter
    foreach my $tmpl_set (keys %$def_tmpl) {
        foreach my $tmpl_id (keys %{ $def_tmpl->{$tmpl_set} }) {
            next if $tmpl_id eq 'plugin';

            my $tmpl = $def_tmpl->{$tmpl_set}{$tmpl_id};
            my $type = $tmpl_set;
            $type = 'custom' if $tmpl_set eq 'module';
            $type = $tmpl_id if $tmpl_set eq 'system';
            my $name = $tmpl->{label};
            $name = $name->() if ref($name) eq 'CODE';
            $tmpl->{name} = $name;
            $tmpl->{type} = $type;
            $tmpl->{key} = $tmpl_id;
            $tmpl->{identifier} = $tmpl_id;
            push @tmpls, $tmpl;
        }
    }
    MT->run_callbacks('DefaultTemplateFilter', \@tmpls);
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
