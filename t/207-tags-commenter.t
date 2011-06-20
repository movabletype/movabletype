#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt = MT->instance;

my %comments         = ();
my %comments_to_load = qw(
    comment 2
    trusted_comment 14
    untrusted_comment 1
    entry_author_comment 15
    not_entry_author_comment 14
    not_author_comment 1
    mt_account_comment 14
    typekey_account_comment 2
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
    $stock->{$_} = $comments{$_}   for keys(%comments);
    $stock->{$_} = $commenters{$_} for keys(%commenters);
};
local $MT::Test::Tags::PRERUN_PHP
    = 'require_once("class.mt_comment.php");'
    . '$comment  = new Comment;'
    . join( '', map({
          '$comments = $comment->Find("comment_id = '
        . $comments{$_}->id . '");'
        . '$stock["'
        . $_
        . '"] = $comments[0];';
    } keys(%comments)))
    . join( '', map({
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
  name: CommenterNameThunk prints a javascript to get comment name.
  template: <MTCommenterNameThunk>
  expected: <script type='text/javascript'>var commenter_name = getCookie('commenter_name')</script>

-
  name: CommenterName prints the name of the commenter.
  template: <MTCommenterName>
  expected: 'John Doe'
  stash:
    commenter: $commenter

-
  name: CommenterEmail prints the email address of the commenter.
  template: <MTCommenterEmail>
  expected: 'jdoe@doe.com'
  stash:
    commenter: $commenter

-
  name: CommenterIfTrusted prints inner content if the commenter is trusted.
  template: <MTCommenterIfTrusted>trusted<MTElse>untrusted</MTCommenterIfTrusted>
  expected: 'trusted'
  stash:
    commenter: $trusted_commenter

-
  name: CommenterIfTrusted doesn't print inner content if the commenter isn't trusted.
  template: <MTCommenterIfTrusted>trusted<MTElse>untrusted</MTCommenterIfTrusted>
  expected: 'untrusted'
  stash:
    commenter: $untrusted_commenter

-
  name: IfCommenterTrusted prints inner content if the commenter is trusted.
  template: <MTIfCommenterTrusted>trusted<MTElse>untrusted</MTIfCommenterTrusted>
  expected: 'trusted'
  stash:
    commenter: $trusted_commenter

-
  name: IfCommenterTrusted doesn't print inner content if the commenter isn't trusted.
  template: <MTIfCommenterTrusted>trusted<MTElse>untrusted</MTIfCommenterTrusted>
  expected: 'untrusted'
  stash:
    commenter: $untrusted_commenter

-
  name: IfCommenterIsAuthor prints inner content if the commenter is a author.
  template: <MTIfCommenterIsAuthor>author<MTElse>not author</MTIfCommenterIsAuthor>
  expected: 'author'
  stash:
    commenter: $trusted_commenter

-
  name: IfCommenterIsAuthor doesn't print inner content if the commenter isn't a author.
  template: <MTIfCommenterIsAuthor>author<MTElse>not author</MTIfCommenterIsAuthor>
  expected: 'not author'
  stash:
    commenter: $untrusted_commenter

-
  name: IfCommenterIsEntryAuthor prints inner content if the commenter is the author of the entry.
  template: <MTIfCommenterIsEntryAuthor>author<MTElse>not author</MTIfCommenterIsEntryAuthor>
  expected: 'author'
  stash:
    comment: $entry_author_comment
    commenter: $entry_author_commenter

-
  name: IfCommenterIsEntryAuthor doesn't prints inner content if the commenter isn't the author of the entry.
  template: <MTIfCommenterIsEntryAuthor>author<MTElse>not author</MTIfCommenterIsEntryAuthor>
  expected: 'not author'
  stash:
    comment: $not_entry_author_comment
    commenter: $not_entry_author_commenter

-
  name: CommenterAuthType and CommenterAuthIconURL doesn't print the auth type and icon URL. (for not author)
  template: <MTCommenterAuthType>:<MTCommenterAuthIconURL>
  expected: ':'
  stash:
    commenter: $not_author_commenter

-
  name: CommenterAuthType and CommenterAuthIconURL prints the auth type and icon URL. (for MT)
  template: <MTCommenterAuthType>:<MTCommenterAuthIconURL>
  expected: 'MT:http://narnia.na/mt-static/images/comment/mt_logo.png'
  stash:
    commenter: $mt_account_commenter

-
  name: CommenterAuthType and CommenterAuthIconURL prints the auth type and icon URL. (for TypeKey)
  template: <MTCommenterAuthType>:<MTCommenterAuthIconURL>
  expected: 'TypeKey:http://narnia.na/mt-static/images/comment/typepad_logo.png'
  stash:
    commenter: $typekey_account_commenter

-
  name: UserSessionCookieDomain prints the cookie domain.
  template: <MTUserSessionCookieDomain>
  expected: .narnia.na

-
  name: UserSessionCookieName prints the cookie name.
  template: <MTUserSessionCookieName>
  expected: mt_blog_user

-
  name: UserSessionCookiePath prints the cookie path.
  template: <MTUserSessionCookiePath>
  expected: /

-
  name: UserSessionCookieTimeout prints the cookie timeout.
  template: <MTUserSessionCookieTimeout>
  expected: 14400

-
  name: IfCommenterRegistrationAllowed prints inner content if allowed.
  template: <MTIfCommenterRegistrationAllowed>Allowed</MTIfCommenterRegistrationAllowed>
  expected: Allowed

-
  name: IfExternalUserManagement prints inner content if enabled.
  template: <MTIfExternalUserManagement>External</MTIfExternalUserManagement>
  expected: ''


######## IfExternalUserManagement

######## IfCommenterRegistrationAllowed

######## CommenterIfTrusted

######## IfCommenterTrusted

######## IfCommenterIsAuthor

######## IfCommenterIsEntryAuthor

######## CommenterNameThunk

######## CommenterUsername

######## CommenterName

######## CommenterEmail

######## CommenterAuthType

######## CommenterAuthIconURL

######## CommenterID

######## CommenterURL

######## UserSessionState

######## UserSessionCookieTimeout

######## UserSessionCookiePath

######## UserSessionCookieDomain

######## UserSessionCookieName

