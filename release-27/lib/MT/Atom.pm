# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Atom;
use strict;

package MT::Atom::Entry;
use MT::I18N qw( encode_text );
use base qw( XML::Atom::Entry );

sub _create_issued {
    my ($ts, $blog) = @_;
    my @co_list = unpack 'A4A2A2A2A2A2', $ts;
    my $co = sprintf "%04d-%02d-%02dT%02d:%02d:%02d", @co_list;
    my $epoch = Time::Local::timegm($co_list[5], $co_list[4], $co_list[3],
                                    $co_list[2], $co_list[1]-1, $co_list[0]);
    my $so = $blog->server_offset;
    $so += 1 if (localtime $epoch)[8];
    $so = sprintf("%s%02d:%02d", $so < 0 ? '-' : '+', 
                  abs(int $so), abs($so - int $so)*60);
    $co .= $so;
}

sub new_with_entry {
    my $class = shift;
    my($entry, %param) = @_;
    my $rfc_compat = $param{Version} && $param{Version} eq '1';

    my $atom = $class->new(%param);
    $atom->title(encode_text($entry->title, undef, 'utf-8'));
    $atom->summary(encode_text($entry->excerpt, undef, 'utf-8'));
    $atom->content(encode_text($entry->text, undef, 'utf-8'));
    # Old Atom API gets application/xhtml+xml for compatibility -- but why
    # do we say it's that when all we're guaranteed is it's an opaque blob
    # of text? So use 'html' for new RFC compatible output.
    $atom->content->type($rfc_compat ? 'html' : 'application/xhtml+xml');

    my $mt_author = MT::Author->load($entry->author_id);
    my $atom_author = new XML::Atom::Person(%param);
    $atom_author->name(encode_text($mt_author->nickname, undef, 'utf-8'));
    $atom_author->email($mt_author->email) if $mt_author->email;
    my $author_url_field = $rfc_compat ? 'uri' : 'url';
    $atom_author->$author_url_field($mt_author->url) if $mt_author->url;
    $atom->author($atom_author);

    for my $cat (@{ $entry->categories }) {
        my $atom_cat = XML::Atom::Category->new(%param);
        $atom_cat->term($cat->label);
        $atom->add_category($atom_cat);
    }

    my $blog = MT::Blog->load($entry->blog_id);
    my $co = _create_issued($entry->authored_on, $blog);
    $atom->issued($co);
    $atom->add_link({ rel => 'alternate', type => 'text/html',
                      href => $entry->permalink });
    my ($host) = $blog->site_url =~ m!^https?://([^/:]+)(:\d+)?/!;

    $atom->id($entry->atom_id);
    #$atom->draft('true') if $entry->status != MT::Entry::RELEASE();

    $atom;
}

sub new_with_asset { 
    my $class = shift; 
    my($asset, %param) = @_; 
    my $atom = $class->new(%param); 
    $atom->title($asset->label); 
    $atom->summary($asset->description);
    my $blog = MT::Blog->load($asset->blog_id);
    $atom->issued(_create_issued($asset->created_on, $blog)); 
    $atom->add_link({ rel => 'alternate', type => $asset->mime_type, 
                      href => $asset->url, title => $asset->label }); 
    my ($host) = $blog->site_url =~ m!^https?://([^/:]+)(:\d+)?/!;
    $atom->id('tag:' . $host . ':asset-' . $asset->id);
    return $atom; 
} 

1;
__END__

=head1 NAME

MT::Atom

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
