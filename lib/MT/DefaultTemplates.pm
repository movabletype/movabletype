# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more details, consult 
# your Movable Type license for details.
#
# $Id$

package MT::DefaultTemplates;

use strict;

my $loaded = 0;
my $templates = [
          {
            'outfile' => 'index.html',
            'name' => 'Main Index',
            'type' => 'index',
            'rebuild_me' => '1'
          },
          {
              'outfile' => 'mtview.php',
              'name' => 'Dynamic Site Bootstrapper',
              'type' => 'index',
              'rebuild_me' => 1,
          },
          {
            'outfile' => 'rsd.xml',
            'name' => 'RSD',
            'type' => 'index',
            'rebuild_me' => '1'
          },
          {
            'outfile' => 'atom.xml',
            'name' => 'Atom Index',
            'type' => 'index',
            'rebuild_me' => '1'
          },
          {
            'outfile' => 'index.xml',
            'name' => 'RSS 2.0 Index',
            'type' => 'index',
            'rebuild_me' => '1'
          },
          {
            'outfile' => 'archives.html',
            'name' => 'Master Archive Index',
            'type' => 'index',
            'rebuild_me' => '1'
          },
          {
            'name' => 'Comment Preview Template',
            'type' => 'comment_preview',
            'rebuild_me' => '0'
          },
          {
            'name' => 'Search Results Template',
            'type' => 'search_template',
            'rebuild_me' => '0'
          },
          {
            'name' => 'Comment Pending Template',
            'type' => 'comment_pending',
            'rebuild_me' => '0'
          },
          {
            'name' => 'Comment Error Template',
            'type' => 'comment_error',
            'rebuild_me' => '0'
          },
          {
            'name' => 'Uploaded Image Popup Template',
            'type' => 'popup_image',
            'rebuild_me' => '0'
          },
          {
            'name' => 'Comment Listing Template',
            'type' => 'comments',
            'rebuild_me' => '0'
          },
          {
            'name' => 'Dynamic Pages Error Template',
            'type' => 'dynamic_error',
            'rebuild_me' => '0'
          },
          {
            'outfile' => 'styles-site.css',
            'name' => 'Stylesheet',
            'type' => 'index',
            'rebuild_me' => '1'
          },
          {
            'name' => 'Date-Based Archive',
            'type' => 'archive',
            'rebuild_me' => '0'
          },
          {
            'name' => 'Category Archive',
            'type' => 'category',
            'rebuild_me' => '0'
          },
          {
            'name' => 'Individual Entry Archive',
            'type' => 'individual',
            'rebuild_me' => '0'
          },
          {
            'name' => 'TrackBack Listing Template',
            'type' => 'pings',
            'rebuild_me' => '0'
          },
          { 'type' => 'index',
            'name' => 'Site JavaScript',
            'outfile' => 'mt-site.js',
            },
        ];

sub templates {
    if (!$loaded) {
        require MT::Util;
        require MT;
        use File::Spec;
        my $path = MT->instance->config('WeblogTemplatesPath');
        local (*FIN, $/);
        $/ = undef;
        foreach my $tmpl (@$templates) {
            my $file = File::Spec->catfile($path, MT::Util::dirify($tmpl->{name}).'.tmpl');
            if ((-e $file) && (-r $file)) {
                open FIN, "<$file"; my $data = <FIN>; close FIN;
                $tmpl->{text} = $data;
            } else {
                $tmpl->{text} = '';
            }
        }
        $loaded = 1;
    }
    # copy structure, then run filter
    my @tmpls;
    push @tmpls, { %$_ } foreach @$templates;
    MT->run_callbacks('DefaultTemplateFilter', \@tmpls);
    \@tmpls;
}

1;
