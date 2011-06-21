#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt = MT->instance;

my %entries         = ();
my %entries_to_load = qw(
    entry 1
    disabled_comment_entry 4
);
while ( my ( $key, $id ) = each(%entries_to_load) ) {
    $entries{$key} = MT->model('entry')->load($id);
}

my %comments         = ();
my %comments_to_load = qw(
    comment 2
    mt_account_comment 14
    parent_comment 11
    child_comment 12
    page_comment 13
    entry_comment 6
    not_visible_comment 4
);
while ( my ( $key, $id ) = each(%comments_to_load) ) {
    $comments{$key} = MT->model('comment')->load($id);
}

my %commenters = ();
while ( my ( $key, $comment ) = each(%comments) ) {
    $key =~ s/comment/commenter/;
    $commenters{$key}
        = $comment->commenter_id
        ? MT->model('author')->load( $comment->commenter_id )
        : undef;
}

local $MT::Test::Tags::PRERUN = sub {
    my ($stock) = @_;
    $stock->{$_} = $entries{$_}  for keys(%entries);
    $stock->{$_} = $comments{$_} for keys(%comments);
    $stock->{$_} = $commenters{$_} for keys(%commenters);
};
local $MT::Test::Tags::PRERUN_PHP =
    join('', map({
        '$stock["' . $_ . '"] = $db->fetch_entry(' . $entries{$_}->id . ');'
    } keys(%entries)))
    . 'require_once("class.mt_comment.php");'
    . '$comment  = new Comment;'
    . join('', map({
        '$comments = $comment->Find("comment_id = ' . $comments{$_}->id . '");'
        . '$stock["' . $_ . '"] = $comments[0];'
    } keys(%comments)))
    . join('', map({
        if ( $commenters{$_} ) {
            '$stock["' . $_ . '"] = $db->fetch_author(' . $commenters{$_}->id . ');';
        }
        else {
            '$stock["' . $_ . '"] = null;';
        }
    } keys(%commenters)));


run_tests_by_data();
__DATA__
-
  name: SignOnURL prints the URL to sign on for post comment.
  template: <MTSignOnURL>
  expected: "https://www.typekey.com/t/typekey/login?"

-
  name: TypeKeyToken prints the authentication token.
  template: <MTTypeKeyToken>
  expected: token

-
  name: RemoteSignInLink prints the URL to sign on for post comment.
  template: <MTRemoteSignInLink>
  expected: "https://www.typekey.com/t/typekey/login?&amp;lang=en_US&amp;t=token&amp;v=1.1&amp;_return=http://narnia.na/cgi-bin/mt-comments.cgi%3f__mode=handle_sign_in%26key=TypeKey%26static=0%26entry_id=1"
  stash:
    entry: $entry

-
  name: RemoteSignOutLink prints the URL to sign out for commenter.
  template: <MTRemoteSignOutLink>
  expected: "http://narnia.na/cgi-bin/mt-comments.cgi?__mode=handle_sign_in&amp;static=0&amp;logout=1&amp;entry_id=1"
  stash:
    entry: $entry

-
  name: CommentAuthor prints the display name of the author of the comment.
  template: <MTCommentAuthor>
  expected: John Doe
  stash:
    comment: $comment
    commenter: $commenter

-
  name: CommentBody prints the body of the comment.
  template: <MTCommentBody>
  expected: <p>Comment for entry 5, visible</p>
  stash:
    comment: $comment

-
  name: CommentDate prints the created-time of the comment.
  template: <MTCommentDate>
  expected: "September 12, 2004  6:28 PM"
  stash:
    comment: $comment

-
  name: CommentID prints the ID of the comment.
  template: <MTCommentID>
  expected: 2
  stash:
    comment: $comment

-
  name: CommentEntryID prints the ID of the entry of the comment.
  template: <MTCommentEntryID>
  expected: 5
  stash:
    comment: $comment

-
  name: CommentIP prints the IP address of the commenter.
  template: <MTCommentIP>
  expected: 127.0.0.1
  stash:
    comment: $comment

-
  name: CommentAuthorLink prints the author's link if registered.
  template: <MTCommentAuthorLink>
  expected: |
    <a title="http://chuckd.com/" href="http://chuckd.com/">Chucky Dee</a>
  stash:
    comment: $mt_account_comment

-
  name: CommentAuthorLink doesn't print the author's link if not registered.
  template: <MTCommentAuthorLink>
  expected: |
    John Doe
  stash:
    comment: $comment

-
  name: CommentEmail prints the email address of the commenter.
  template: <MTCommentEmail>
  expected: johnd@doe.com
  stash:
    comment: $comment

-
  name: CommentAuthorIdentity prints the img tag to display icon. (for MT)
  template: <MTCommentAuthorIdentity>
  expected: |
    <a class="commenter-profile" href="http://chuckd.com/"><img alt="" src="http://narnia.na/mt-static/images/comment/mt_logo.png" width="16" height="16" /></a>
  stash:
    comment: $mt_account_comment

-
  name: CommentAuthorIdentity prints the img tag to display icon. (for TypePad)
  template: <MTCommentAuthorIdentity>
  expected: |
    <img alt="" src="http://narnia.na/mt-static/images/comment/typepad_logo.png" width="16" height="16" />
  stash:
    comment: $comment

-
  name: CommentURL prints the URL of the commenter.
  template: <MTCommentURL>
  expected: "http://john.doe.com/"
  stash:
    comment: $comment

-
  name: Comments lists comments of the entry.
  template: |
    <MTComments>
      <MTCommentID>
    </MTComments>
  expected: |
    1
    12
    11
  stash:
    entry: $entry

-
  name: Comments with attributes "sort_by" and "sort_order" sorts and lists comments of the entry.
  template: |
    <MTComments sort_by='id' sort_order='descend'>
      <MTCommentID>
    </MTComments>
  expected: |
    11
    12
    1
  stash:
    entry: $entry

-
  name: Comments lists comments of the entry.
  template: |
    <MTComments>
      <MTCommentsHeader><ul></MTCommentsHeader>
        <li><MTCommentID></li>
      <MTCommentsFooter></ul></MTCommentsFooter>
    </MTComments>
  expected: |
    <ul>
      <li>1</li>
      <li>12</li>
      <li>11</li>
    </ul>
  stash:
    entry: $entry

-
  name: CommentOrderNumber prints the order.
  template: |
    <MTComments lastn="3">
      <MTCommentOrderNumber>
    </MTComments>
  expected: |
    1
    2
    3
  stash:
    entry: $entry

-
  name: CommentEntry creates the entry context for the entry of the comment.
  template: <MTCommentEntry><MTEntryTitle></MTCommentEntry>
  expected: Verse 2
  stash:
    comment: $comment

-
  name: EntryCommentCount prints the number of the comments of the entry.
  template: <MTEntryCommentCount>
  expected: 3
  stash:
    entry: $entry

-
  name: CommentBody prints the body of the comment.
  template: <MTCommentBody sanitize=" ">
  expected: Comment for entry 5, visible
  stash:
    comment: $comment

-
  name: CommentID prints the ID of the comment.
  template: <MTCommentID>
  expected: 2
  stash:
    comment: $comment

-
  name: IfCommentsActive prints inner content if active.
  template: <MTIfCommentsActive>active</MTIfCommentsActive>
  expected: active
  stash:
    entry: $entry

-
  name: IfCommentsAccepted prints inner content if accepted.
  template: <MTIfCommentsAccepted>accepted</MTIfCommentsAccepted>
  expected: accepted
  stash:
    entry: $entry

-
  name: IfCommentsActive doesn't prints inner content if not active.
  template: <MTIfCommentsActive>active</MTIfCommentsActive>
  expected: ''
  stash:
    entry: $disabled_comment_entry

-
  name: IfCommentsAccepted doesn't print inner content if not accepted.
  template: <MTIfCommentsAccepted>accepted</MTIfCommentsAccepted>
  expected: ''
  stash:
    entry: $disabled_comment_entry

-
  name: IfRegistrationNotRequired prints inner content if not requied.
  template: |
    <MTIfRegistrationNotRequired>
      yes
    <MTElse>
      no
    </MTElse>
    </MTIfRegistrationNotRequired>
  expected: no

-
  name: IfRegistrationRequired prints inner content if requied.
  template: |
    <MTIfRegistrationRequired>
      yes
    <MTElse>
      no
    </MTElse>
    </MTIfRegistrationRequired>
  expected: yes

-
  name: BlogIfCommentsOpen prints inner content if comments open.
  template: |
    <MTBlogIfCommentsOpen>
      yes
    <MTElse>
      no
    </MTElse>
    </MTBlogIfCommentsOpen>
  expected: yes

-
  name: IfTypeKeyToken prints inner content if the token has been initialized.
  template: <MTIfTypeKeyToken>tokened</MTIfTypeKeyToken>
  expected: tokened

-
  name: IfCommentsModerated prints inner content if moderated.
  template: <MTIfCommentsModerated>moderated</MTIfCommentsModerated>
  expected: moderated

-
  name: IfRegistrationAllowed prints inner content if allowed.
  template: <MTIfRegistrationAllowed>allowed</MTIfRegistrationAllowed>
  expected: allowed

-
  name: IfNeedEmail prints inner content if needs email.
  template: <MTIfNeedEmail>email needed</MTIfNeedEmail>
  expected: ''

-
  name: IfAllowCommentHTML prints inner content if allowed.
  template: <MTIfAllowCommentHTML>comment html allowed</MTIfAllowCommentHTML>
  expected: comment html allowed

-
  name: IfCommentsAllowed prints inner content if allowed.
  template: <MTIfCommentsAllowed>comments allowed</MTIfCommentsAllowed>
  expected: comments allowed

-
  name: EntryIfAllowComments prints inner content if allowed.
  template: |
    <MTEntryIfAllowComments>
      entry allows comments
    </MTEntryIfAllowComments>
  expected: entry allows comments
  stash:
    entry: $entry

-
  name: EntryIfCommentsOpen prints inner content if open.
  template: |
    <MTEntryIfCommentsOpen>
      entry comments open
    </MTEntryIfCommentsOpen>
  expected: entry comments open
  stash:
    entry: $entry

-
  name: EntryIfAllowComments doesn't prints inner content if not allowed.
  template: |
    <MTEntryIfAllowComments>
      entry allows comments
    </MTEntryIfAllowComments>
  expected: ''
  stash:
    entry: $disabled_comment_entry

-
  name: EntryIfCommentsOpen doesn't prints inner content if not open.
  template: |
    <MTEntryIfCommentsOpen>
      entry comments open
    </MTEntryIfCommentsOpen>
  expected: ''
  stash:
    entry: $disabled_comment_entry

-
  name: IfCommentParent prints inner content if the comment has parent.
  template: |
    <MTIfCommentParent>has parent</MTIfCommentParent>
  expected: |
    has parent
  stash:
    comment: $child_comment

-
  name: IfCommentParent doesn't prints inner content if the comment doesn't have parent.
  template: |
    <MTIfCommentParent>has parent</MTIfCommentParent>
  expected: ''
  stash:
    comment: $comment

-
  name: CommentParent creates the comment context for the parent comment.
  template: |
    <MTCommentParent><MTCommentID></MTCommentParent>
  expected: '11'
  stash:
    comment: $child_comment

-
  name: CommentParent doesn't create the comment context if the comment doesn't have parent.
  template: |
    <MTCommentParent><MTCommentID></MTCommentParent>
  expected: ''
  stash:
    comment: $comment

-
  name: IfCommentReplies prints inner content if the visible child comment exists.
  template: |
    <MTIfCommentReplies>has replies</MTIfCommentReplies>
  expected: |
    has replies
  stash:
    comment: $parent_comment

-
  name: IfCommentReplies doesn't print inner content if the visible child comment doesn't exists.
  template: |
    <MTIfCommentReplies>has replies</MTIfCommentReplies>
  expected: ''
  stash:
    comment: $comment

-
  name: CommentReplies lists reply comments.
  template: |
    <MTCommentReplies>
      <MTCommentsHeader><ul></MTCommentsHeader>
        <li><MTCommentID></li>
      <MTCommentsFooter></ul></MTCommentsFooter>
    </MTCommentReplies>
  expected: |
    <ul>
      <li>12</li>
    </ul>
  stash:
    comment: $parent_comment

-
  name: CommentEntry creates the entry context for the entry of the comment. (for the page comment)
  template: |
    <MTCommentEntry><MTEntryID>:<MTEntryClass></MTCommentEntry>
  expected: |
    23:page
  stash:
    comment: $page_comment

-
  name: CommentEntry creates the entry context for the entry of the comment. (for the entry comment)
  template: |
    <MTCommentEntry><MTEntryID>:<MTEntryClass></MTCommentEntry>
  expected: |
    8:entry
  stash:
    comment: $entry_comment

-
  name: CommentIfModerated prints inner content if moderated.
  template: |
    <MTCommentIfModerated>
      Moderated
    <MTElse>
      NotModerated
    </MTCommentIfModerated>
  expected: Moderated
  stash:
    comment: $comment

-
  name: CommentIfModerated doesn't print inner content if not moderated.
  template: |
    <MTCommentIfModerated>
      Moderated
    <MTElse>
      NotModerated
    </MTCommentIfModerated>
  expected: NotModerated
  stash:
    comment: $not_visible_comment

-
  name: CommentLink prints the URL of the published page of comment.
  template: <MTCommentLink>
  expected: "http://narnia.na/nana/archives/1962/01/verse-2.html#comment-2"
  stash:
    comment: $comment

-
  name: CommentName prints the display name of the author of the comment.
  template: <MTCommentName>
  expected: John Doe
  stash:
    comment: $comment
    commenter: $commenter

-
  name: CommentParentID prints the ID of the parent comment.
  template: <MTCommentParentID>
  expected: '11'
  stash:
    comment: $child_comment

-
  name: CommentParentID doesn't print anything if parent comment doesn't exist.
  template: <MTCommentParentID>
  expected: ''
  stash:
    comment: $comment

-
  name: CommentReplyToLink prints the anchor tag for reply.
  template: |
    <MTCommentReplyToLink>
  expected: |
    <a title="Reply" href="javascript:void(0);" onclick="mtReplyCommentOnClick(2, 'John Doe')">Reply</a>
  stash:
    comment: $comment

-
  name: CommentBlogID prints the blog ID of the comment.
  template: <MTCommentBlogID>
  expected: 1
  stash:
    comment: $comment

-
  name: IfRequireCommentEmails prints inner content if required.
  template: <MTIfRequireCommentEmails>Requied</MTIfRequireCommentEmails>
  expected: ''


######## IfCommentsModerated

######## WebsiteIfCommentsOpen

######## BlogIfCommentsOpen

######## Comments
## lastn
## offset (optional; default "0")
## sort_by (optional)
## sort_order (optional)
## namespace
## min_score
## max_score
## min_rate
## max_rate
## min_count
## max_count

######## CommentsHeader

######## CommentsFooter

######## CommentEntry

######## CommentIfModerated

######## CommentParent

######## CommentReplies

######## IfCommentParent

######## IfCommentReplies

######## IfRegistrationRequired

######## IfRegistrationNotRequired

######## IfRegistrationAllowed
## type (optional)

######## IfTypeKeyToken

######## IfAllowCommentHTML

######## IfCommentsAllowed

######## IfCommentsActive

######## IfCommentsAccepted

######## IfNeedEmail

######## IfRequireCommentEmails

######## EntryIfAllowComments

######## EntryIfCommentsOpen

######## CommentID

######## CommentBlogID

######## CommentEntryID

######## CommentName

######## CommentIP

######## CommentAuthor

######## CommentAuthorLink
## show_email (optional; default "0")
## show_url (optional; default "1")
## new_window (optional; default "0")
## default_name (optional; default "Anonymous")
## no_redirect (optional; default "0")
## nofollowfy (optional)

######## CommentAuthorIdentity

######## CommentEmail
## spam_protect (optional; default "0")

######## CommentLink

######## CommentURL

######## CommentBody
## autolink (optional)
## convert_breaks (optional)
## words (optional)

######## CommentOrderNumber

######## CommentDate

######## CommentParentID
## pad

######## CommentReplyToLink
## label or text (optional)
## onclick (optional)

######## CommentPreviewAuthor

######## CommentPreviewIP

######## CommentPreviewAuthorLink

######## CommentPreviewEmail

######## CommentPreviewURL

######## CommentPreviewBody

######## CommentPreviewDate

######## CommentPreviewState

######## CommentPreviewIsStatic

######## CommentRepliesRecurse

######## WebsiteCommentCount

######## BlogCommentCount

######## EntryCommentCount

######## CategoryCommentCount

######## TypeKeyToken

######## CommentFields

######## RemoteSignInLink

######## RemoteSignOutLink

######## SignInLink

######## SignOutLink

######## SignOnURL

