# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::EntryStatus;
use strict;
use warnings;

use Exporter 'import';

our @EXPORT_OK = qw(
    HOLD RELEASE REVIEW FUTURE JUNK UNPUBLISH
    status_text status_int status_icon
);
our %EXPORT_TAGS = (
    constants => [qw(HOLD RELEASE FUTURE)],
    all       => [
        qw(
            HOLD RELEASE REVIEW FUTURE JUNK UNPUBLISH
            status_text status_int status_icon
            )
    ]
);

sub HOLD ()     {1}
sub RELEASE ()  {2}
sub REVIEW ()   {3}
sub FUTURE ()   {4}
sub JUNK ()     {5}
sub UNPUBLISH() {6}

sub status_text {
    my $s = $_[0];
          $s == HOLD      ? "Draft"
        : $s == RELEASE   ? "Publish"
        : $s == REVIEW    ? "Review"
        : $s == FUTURE    ? "Future"
        : $s == JUNK      ? "Spam"
        : $s == UNPUBLISH ? "Unpublish"
        :                   '';
}

sub status_int {
    my $s = lc $_[0];    ## Lower-case it so that it's case-insensitive
          $s eq 'draft'     ? HOLD
        : $s eq 'publish'   ? RELEASE
        : $s eq 'review'    ? REVIEW
        : $s eq 'future'    ? FUTURE
        : $s eq 'junk'      ? JUNK
        : $s eq 'spam'      ? JUNK
        : $s eq 'unpublish' ? UNPUBLISH
        :                     undef;
}

sub status_icon {
    my $self                    = shift;
    my $status                  = $self->status;
    my $status_class            = _status_class($status);
    my $status_icon_color_class = _status_icon_color_class($status);
    my $status_icon_id          = _status_icon_id($status);
    my $static_uri              = MT->static_path;
    my $status_class_trans      = MT->translate($status_class);
    return '' unless $status_icon_id;
    return qq{
        <svg role="img" class="mt-icon mt-icon--sm$status_icon_color_class">
          <title>$status_class_trans</title>
          <use xlink:href="${static_uri}images/sprite.svg#$status_icon_id"></use>
        </svg>
    };
}

sub _status_class {
    my $status = $_[0];
    return
          $status == HOLD      ? 'Draft'
        : $status == RELEASE   ? 'Published'
        : $status == REVIEW    ? 'Review'
        : $status == FUTURE    ? 'Future'
        : $status == JUNK      ? 'Junk'
        : $status == UNPUBLISH ? 'Unpublish'
        :                        '';
}

sub _status_icon_id {
    my $status = $_[0];
    return
          $status == HOLD      ? 'ic_draft'
        : $status == RELEASE   ? 'ic_checkbox'
        : $status == REVIEW    ? 'ic_error'
        : $status == FUTURE    ? 'ic_clock'
        : $status == JUNK      ? 'ic_error'
        : $status == UNPUBLISH ? 'ic_stop'
        :                        '';
}

sub _status_icon_color_class {
    my $status = $_[0];
    return
          $status == HOLD      ? ''
        : $status == RELEASE   ? ' mt-icon--success'
        : $status == REVIEW    ? ' mt-icon--warning'
        : $status == FUTURE    ? ' mt-icon--info'
        : $status == JUNK      ? ' mt-icon--warning'
        : $status == UNPUBLISH ? ' mt-icon--danger'
        :                        '';
}

1;
__END__

=head1 NAME

MT::EntryStatus - Movable Type entry status class

=head1 SYNOPSIS

=head2 Use subroutines

    use MT;
    use MT::EntryStatus;

    my $entry = MT->model('entry')->load(1);

    # return status code
    if ( $entry->status == MT::EntryStatus::RELEASE() ) {
        # if $entry is published ...
    } else {
        # if $entry is not published ...
    }

    # get status text from status code
    my $status_text = MT::EntryStatus::status_text(MT::EntryStatus::HOLD());  # 'Draft'

    # get status code from status text
    my $status_code = MT::EntryStatus::status_int('Publish');  # 2

=head2 Export subroutines

    # export all subroutines
    use MT::EntryStatus ':all';

    # export 'HOLD', 'RELEASE' and 'FUTURE'
    use MT::EntryStatus ':constants';

    # export specified subroutines
    use MT::EntryStatus qw( HOLD RELEASE );


=head1 DESCRIPTION

I<MT::EntryStatus> contains subroutines related to entry status.
All subroutines can be exported to other package.

=head1 EXPORT TAGS

=head2 :all

Exports all subroutines.

=head2 :constants

Exports 'HOLD', 'RELEASE' and 'FUTURE'.

=head1 SUBROUTINES

=head2 MT::EntryStatus::HOLD()

Returns entry's status code 1.

=head2 MT::EntryStatus::RELEASE()

Returns entry's status code 2.

=head2 MT::EntryStatus::REVIEW()

Returns entry's status code 3.

=head2 MT::EntryStatus::FUTURE()

Returns entry's status code 4.

=head2 MT::EntryStatus::JUNK()

Returns entry's status code 5.

=head2 MT::EntryStatus::UNPUBLISH()

Returns entry's status code 6.

=head2 MT::Entry::status_text($status_code)

Returns entry's status text of I<$status_code>.

=over 4

=item * HOLD (1)

Returns "Draft"

=item * RELEASE (2)

Returns "Publish"

=item * REVIEW (3)

Returns "Review"

=item * FUTURE (4)

Returns "Future"

=item * JUNK (5)

Returns "Spam"

=item * UNPUBLISH (6)

Returns "Unpublish"

=back

=head2 MT::Entry::status_int($status_text)

Returns entry's status code of I<$status_text>. I<$status_text> is case-insensitive.

=over 4

=item * 'draft'

Returns HOLD (1)

=item * 'publish'

Returns RELEASE (2)

=item * 'review'

Returns REVIEW (3)

=item * 'future'

Returns FUTURE (4)

=item * 'junk' or 'spam'

Returns JUNK (5)

=item * 'unpublish'

Returns UNPUBLISH (6)

=back

=head1 AUTHOR & COPYRIGHTS

Please see the L<MT> manpage for author, copyright, and license information.

=cut
