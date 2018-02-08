# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
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
	'Failed to resolve IP address for source URL [_1]' => 'ソースURL[_1]の解決に失敗しました。',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'ドメインのIPアドレス「[_2]」と送信元「[_1]」のIPアドレス「[_3]」が合致しないため、「未公開」にします。',
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'ドメインのIPアドレス「[_2]」と送信元「[_1]」のIPアドレス「[_3]」が合致しません',
	'No links are present in feedback' => 'リンクが含まれていない',
	'Number of links exceed junk limit ([_1])' => 'スパム - リンク数超過 (制限値:[_1])',
	'Number of links exceed moderation limit ([_1])' => '保留 - リンク数超過 (制限値:[_1])',
	'Link was previously published (comment id [_1]).' => '公開済みのリンク (コメントID:[_1])',
	'Link was previously published (TrackBack id [_1]).' => '公開済みのリンク (トラックバックID:[_1])',
	'E-mail was previously published (comment id [_1]).' => '公開済みのメールアドレス (コメントID: [_1])',
	'Word Filter match on \'[_1]\': \'[_2]\'.' => '\'[_1]\'がワードフィルタ一致: \'[_2]\'',
	'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'ワードフィルタ\'[_1]\'にマッチしたため公開を保留しました: \'[_2]\'。',
	'domain \'[_1]\' found on service [_2]' => 'ドメイン\'[_1]\'一致(サービス: [_2])',
	'[_1] found on service [_2]' => 'サービス[_2]で[_1]が見つかりました。',

## plugins/spamlookup/spamlookup.pl
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'ブラックリストに対する問い合わせを行うSpamLookupモジュールです。',
	'SpamLookup IP Lookup' => 'SpamLookup IPアドレス検査',
	'SpamLookup Domain Lookup' => 'SpamLookup ドメイン検査',
	'SpamLookup TrackBack Origin' => 'SpamLookup トラックバック元検査',
	'Despam Comments' => 'コメントをスパムから解除する',
	'Despam TrackBacks' => 'トラックバックをスパムから解除する',
	'Despam' => 'スパム解除',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'リンクの数による評価を行うSpamLookupモジュールです。',
	'SpamLookup Link Filter' => 'SpamLookup リンクフィルタ',
	'SpamLookup Link Memory' => 'SpamLookup リンクメモリ',
	'SpamLookup Email Memory' => 'SpamLookup メールメモリ',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'キーワードによるコメントトラックバックの評価を行うSpamLookupモジュールです。',
	'SpamLookup Keyword Filter' => 'SpamLookup キーワードフィルタ',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{LookupsはすべてのコメントとトラックバックについてIPアドレスとハイパーリンクを監視します。コメントやトラックバックの送信元のIPアドレスやドメイン名について、外部のブラックリストサービスに問い合わせを行います。そして、結果に応じて公開を保留するか、またはスパムしてゴミ箱に移動します。また、トラックバックの送信元の確認も実行できます。},
	'IP Address Lookups' => 'IPアドレスのルックアップ',
	'Moderate feedback from blacklisted IP addresses' => 'ブラックリストに含まれるIPアドレスからのコメントとトラックバックの公開を保留する',
	'Junk feedback from blacklisted IP addresses' => 'ブラックリストに含まれるIPアドレスからのコメントとトラックバックをスパムとして報告する',
	'Adjust scoring' => '評価の重みを調整',
	'Score weight:' => '評価の重み',
	'Less' => '以下',
	'More' => '以上',
	'block' => 'ブロック',
	'IP Blacklist Services' => 'IPブラックリストのサービス',
	'Domain Name Lookups' => 'ドメイン名のルックアップ',
	'Moderate feedback containing blacklisted domains' => 'ブラックリストに含まれるドメインからのコメントとトラックバックの公開を保留する',
	'Junk feedback containing blacklisted domains' => 'ブラックリストに含まれるドメインからのコメントとトラックバックをスパムとして報告する',
	'Domain Blacklist Services' => 'ドメインブラックリストのサービス',
	'Advanced TrackBack Lookups' => 'トラックバック送信元の確認',
	'Moderate TrackBacks from suspicious sources' => '疑わしい送信元からのトラックバックの公開を保留する',
	'Junk TrackBacks from suspicious sources' => '疑わしい送信元からのトラックバックをスパムとして報告する',
	'Lookup Whitelist' => 'ホワイトリスト',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => '特定のIPアドレスやドメイン名について問い合わせを行わない場合、下の一覧に追加してください。一行に一つずつ指定します。',

## plugins/spamlookup/tmpl/url_config.tmpl
	'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'リンクフィルタは受信したコメントやトラックバックに含まれるリンクの数を監視します。リンクの多いものを公開保留にしたりスパムにしたりできます。逆に、リンクを含まないものや、すでにブログで公開されているURLへのリンクしか含まないものは、良い評価を受けます。',
	'Link Limits' => 'リンク数の上限',
	'Credit feedback rating when no hyperlinks are present' => 'リンクを含まないコメントトラックバックを好評価する',
	'Moderate when more than' => '公開を保留する基準',
	'link(s) are given' => '個以上のリンクが含まれる場合',
	'Junk when more than' => 'スパムにする基準',
	'Link Memory' => 'リンクメモリ',
	'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'コメントとトラックバックに含まれる&quot;URL&quot;がすでに公開されている場合、好評価します。',
	'Only applied when no other links are present in message of feedback.' => '他にはリンクが含まれていない場合に適用されます。',
	'Exclude URLs from comments published within last [_1] days.' => '過去[_1]日間に公開されたコメントのURLを除外',
	'Email Memory' => 'メールアドレスを記憶',
	'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'すでに公開済みの&quot;メールアドレス&quot;を含むコメントを好評価します。',
	'Exclude Email addresses from comments published within last [_1] days.' => '過去[_1]日間に公開されたコメントからメールアドレスを除外',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => '受信したコメントトラックバックについて、特定のキーワードやドメイン名、パターンを監視します。一致したものについて、公開の保留または、スパム指定を行います。個々のパターンについて、評価値の調整も可能です。',
	'Keywords to Moderate' => '公開を保留するキーワード',
	'Keywords to Junk' => 'スパムにするキーワード',

);

1;
