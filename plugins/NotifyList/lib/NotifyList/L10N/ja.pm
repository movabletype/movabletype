# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package NotifyList::L10N::ja;
use strict;
use utf8;
use base qw( NotifyList::L10N::en_us );

our %Lexicon = (

## lib/MT/App/NotifyList.pm
        'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'blog_idパラメータを指定してください。詳細はユーザーガイドを参照してくだ
さい。',
        'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'redirectパラメータが不正です。ブログの
ドメインと一致するパスを指定するように管理者に通知してください。',
        'The email address \'[_1]\' is already in the notification list for this weblog.' => 'メールアドレス([_1])はすでに登録されています。',
        'Please verify your email to subscribe' => '登録するメールアドレスを確認してください。',
        '_NOTIFY_REQUIRE_CONFIRMATION' => '[_1]にメールを送信しました。メールアドレスを認証するため、メールの内容に従って登録を完了してください。',
        'The address [_1] was not subscribed.' => '[_1]は登録されていません。',
        'The address [_1] has been unsubscribed.' => '[_1]の登録を解除しました。',

## lib/MT/DefaultTemplates.pm
        'Subscribe Verify' => '購読の確認',

## default_templates/verify-subscribe.mtml
        'Thank you for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => '[_1]のアップデート通知にご登録いただきありがとう>ございました。以下のリンクから登録を完了させてください。',
        'If the link is not clickable, just copy and paste it into your browser.' => 'リンクをクリックできない場合は、お使いのウェブブラウザに貼り付けてください。',

);

1;
