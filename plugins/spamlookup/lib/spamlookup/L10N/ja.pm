# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package spamlookup::L10N::ja;

use strict;
use warnings;

use base 'spamlookup::L10N::en_us';
use vars qw( %Lexicon );
%Lexicon = (

## plugins/spamlookup/lib/spamlookup.pm
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'ドメインのIPアドレス「[_2]」と送信元「[_1]」のIPアドレス「[_3]」が合致しません',
	'E-mail was previously published (comment id [_1]).' => '公開済みのメールアドレス (コメントID: [_1])',
	'Failed to resolve IP address for source URL [_1]' => 'ソースURL[_1]の解決に失敗しました。',
	'Link was previously published (TrackBack id [_1]).' => '公開済みのリンク (トラックバックID:[_1])',
	'Link was previously published (comment id [_1]).' => '公開済みのリンク (コメントID:[_1])',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'ドメインのIPアドレス「[_2]」と送信元「[_1]」のIPアドレス「[_3]」が合致しないため、「未公開」にします。',
	'No links are present in feedback' => 'リンクが含まれていない',
	'Number of links exceed junk limit ([_1])' => 'スパム - リンク数超過 (制限値:[_1])',
	'Number of links exceed moderation limit ([_1])' => '保留 - リンク数超過 (制限値:[_1])',
	'[_1] found on service [_2]' => 'サービス[_2]で[_1]が見つかりました。',
	q{Moderating for Word Filter match on '[_1]': '[_2]'.} => q{ワードフィルタ'[_1]'にマッチしたため公開を保留しました: '[_2]'。},
	q{Word Filter match on '[_1]': '[_2]'.} => q{'[_1]'がワードフィルタ一致: '[_2]'},
	q{domain '[_1]' found on service [_2]} => q{ドメイン'[_1]'一致(サービス: [_2])},

## plugins/spamlookup/spamlookup.pl
	'Despam Comments' => 'コメントをスパムから解除する',
	'Despam TrackBacks' => 'トラックバックをスパムから解除する',
	'Despam' => 'スパム解除',
	'SpamLookup Domain Lookup' => 'SpamLookup ドメイン検査',
	'SpamLookup IP Lookup' => 'SpamLookup IPアドレス検査',
	'SpamLookup TrackBack Origin' => 'SpamLookup トラックバック元検査',
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'ブラックリストに対する問い合わせを行うSpamLookupモジュールです。',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup Email Memory' => 'SpamLookup メールメモリ',
	'SpamLookup Link Filter' => 'SpamLookup リンクフィルタ',
	'SpamLookup Link Memory' => 'SpamLookup リンクメモリ',
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'リンクの数による評価を行うSpamLookupモジュールです。',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup Keyword Filter' => 'SpamLookup キーワードフィルタ',
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'キーワードによるコメントトラックバックの評価を行うSpamLookupモジュールです。',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	'Adjust scoring' => '評価の重みを調整',
	'Advanced TrackBack Lookups' => 'トラックバック送信元の確認',
	'Domain Blacklist Services' => 'ドメインブラックリストのサービス',
	'Domain Name Lookups' => 'ドメイン名のルックアップ',
	'IP Address Lookups' => 'IPアドレスのルックアップ',
	'IP Blacklist Services' => 'IPブラックリストのサービス',
	'Junk TrackBacks from suspicious sources' => '疑わしい送信元からのトラックバックをスパムとして報告する',
	'Junk feedback containing blacklisted domains' => 'ブラックリストに含まれるドメインからのコメントとトラックバックをスパムとして報告する',
	'Junk feedback from blacklisted IP addresses' => 'ブラックリストに含まれるIPアドレスからのコメントとトラックバックをスパムとして報告する',
	'Lookup Whitelist' => 'ホワイトリスト',
	'Moderate TrackBacks from suspicious sources' => '疑わしい送信元からのトラックバックの公開を保留する',
	'Moderate feedback containing blacklisted domains' => 'ブラックリストに含まれるドメインからのコメントとトラックバックの公開を保留する',
	'Moderate feedback from blacklisted IP addresses' => 'ブラックリストに含まれるIPアドレスからのコメントとトラックバックの公開を保留する',
	'Off' => '行わない',
	'Score weight:' => '評価の重み',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => '特定のIPアドレスやドメイン名について問い合わせを行わない場合、下の一覧に追加してください。一行に一つずつ指定します。',
	'block' => 'ブロック',
	'none' => 'なし',
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the site's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{LookupsはすべてのコメントとトラックバックについてIPアドレスとハイパーリンクを監視します。コメントやトラックバックの送信元のIPアドレスやドメイン名について、外部のブラックリストサービスに問い合わせを行います。そして、結果に応じて公開を保留するか、またはスパムしてゴミ箱に移動します。また、トラックバックの送信元の確認も実行できます。},

## plugins/spamlookup/tmpl/url_config.tmpl
	'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'コメントとトラックバックに含まれる&quot;URL&quot;がすでに公開されている場合、好評価します。',
	'Credit feedback rating when no hyperlinks are present' => 'リンクを含まないコメントトラックバックを好評価する',
	'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'すでに公開済みの&quot;メールアドレス&quot;を含むコメントを好評価します。',
	'Email Memory' => 'メールアドレスを記憶',
	'Exclude Email addresses from comments published within last [_1] days.' => '過去[_1]日間に公開されたコメントからメールアドレスを除外',
	'Exclude URLs from comments published within last [_1] days.' => '過去[_1]日間に公開されたコメントのURLを除外',
	'Junk when more than' => 'スパムにする基準',
	'Link Limits' => 'リンク数の上限',
	'Link Memory' => 'リンクメモリ',
	'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'リンクフィルタは受信したコメントやトラックバックに含まれるリンクの数を監視します。リンクの多いものを公開保留にしたりスパムにしたりできます。逆に、リンクを含まないものや、すでにブログで公開されているURLへのリンクしか含まないものは、良い評価を受けます。',
	'Moderate when more than' => '公開を保留する基準',
	'Only applied when no other links are present in message of feedback.' => '他にはリンクが含まれていない場合に適用されます。',
	'link(s) are given' => '個以上のリンクが含まれる場合',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => '受信したコメントトラックバックについて、特定のキーワードやドメイン名、パターンを監視します。一致したものについて、公開の保留または、スパム指定を行います。個々のパターンについて、評価値の調整も可能です。',
	'Keywords to Junk' => 'スパムにするキーワード',
	'Keywords to Moderate' => '公開を保留するキーワード',
);

1;
