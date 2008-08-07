# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ArchiveType::Individual;

use strict;
use base qw( MT::ArchiveType );

sub name {
    return 'Individual';
}

sub archive_label {
    return MT->translate("INDIVIDUAL_ADV");
}

sub template_params {
    return {
        entry_archive     => 1,
        archive_template  => 1,
        entry_template    => 1,
        feedback_template => 1,
        archive_class     => "entry-archive",
    };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $entry     = $ctx->{__stash}{entry};

    my $file;
    Carp::confess("archive_file_for Individual archive needs an entry")
      unless $entry;
    if ($file_tmpl) {
        $ctx->{current_timestamp} = $entry->authored_on;
    }
    else {
        my $basename = $entry->basename();
        $basename ||= dirify( $entry->title() );
        $file = sprintf( "%04d/%02d/%s",
            unpack( 'A4A2', $entry->authored_on ), $basename );
    }
    $file;
}

sub archive_title {
    my $obj = shift;
    $_[1]->title;
}

sub archive_group_iter {
    my $obj = shift;
    my ( $ctx, $args ) = @_;

    my $order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';

    my $blog_id = $ctx->stash('blog')->id;
    require MT::Entry;
    my $iter = MT::Entry->load_iter(
        {
            blog_id => $blog_id,
            status  => MT::Entry::RELEASE()
        },
        {
            'sort'    => 'authored_on',
            direction => $order,
            $args->{lastn} ? ( limit => $args->{lastn} ) : ()
        }
    );
    return sub {
        while ( my $entry = $iter->() ) {
            return ( 1, entries => [$entry], entry => $entry );
        }
        undef;
      }
}

sub dynamic_template {
    'entry/<$MTEntryID$>';
}

sub default_archive_templates {
    return [
        {
            label    => MT->translate('yyyy/mm/entry-basename.html'),
            template => '%y/%m/%-f',
            default  => 1
        },
        {
            label    => MT->translate('yyyy/mm/entry_basename.html'),
            template => '%y/%m/%f'
        },
        {
            label => MT->translate('yyyy/mm/entry-basename/index.html'),
            template => '%y/%m/%-b/%i'
        },
        {
            label => MT->translate('yyyy/mm/entry_basename/index.html'),
            template => '%y/%m/%b/%i'
        },
        {
            label    => MT->translate('yyyy/mm/dd/entry-basename.html'),
            template => '%y/%m/%d/%-f'
        },
        {
            label    => MT->translate('yyyy/mm/dd/entry_basename.html'),
            template => '%y/%m/%d/%f'
        },
        {
            label =>
              MT->translate('yyyy/mm/dd/entry-basename/index.html'),
            template => '%y/%m/%d/%-b/%i'
        },
        {
            label =>
              MT->translate('yyyy/mm/dd/entry_basename/index.html'),
            template => '%y/%m/%d/%b/%i'
        },
        {
            label => MT->translate(
                'category/sub-category/entry-basename.html'),
            template => '%-c/%-f'
        },
        {
            label => MT->translate(
                'category/sub-category/entry-basename/index.html'),
            template => '%-c/%-b/%i'
        },
        {
            label => MT->translate(
                'category/sub_category/entry_basename.html'),
            template => '%c/%f'
        },
        {
            label => MT->translate(
                'category/sub_category/entry_basename/index.html'),
            template => '%c/%b/%i'
        },
    ];
}

1;
