# Movable Type (r) Open Source (C) 2005-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: ja.pm 81947 2008-05-28 11:02:59Z fyoshimatsu $

package TypePadAntiSpam::L10N::ja;

use strict;
use base 'TypePadAntiSpam::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

## plugins/TypePadAntiSpam/tmpl/stats_widget.tmpl
	'widget_label_width' => '77',
	'widget_totals_width' => '180',
	'TypePad AntiSpam' => 'TypePad AntiSpam',
	'Spam Blocked' => 'ブロックしたスパム',
	'on this blog' => 'ブログレベル',
	'on this system' => 'システム全体',

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'API Key' => 'APIキー',
	'To enable this plugin, you\'ll need a free TypePad AntiSpam API key. You can <strong>get your free API key at [_1]antispam.typepad.com[_2]</strong>. Once you have your key, return to this page and enter it in the field below.' => 'このプラグインを利用するには、TypePad AntiSpam APIキー(無償)が必要です。APIキーは<strong>[_1]antispam.typepad.com[_2]</strong>から無償で取得できます。取得したら、このページに戻ってキーを入力してください。詳しくは<a href="http://antispam.typepad.jp/info/how-to-get-api-key.html" target="_blank">こちら</a>。',
	'Service Host' => 'サービスのホスト',
	'The default service host for TypePad AntiSpam is api.antispam.typepad.com. You should only change this if you are using a different service that is compatible with the TypePad AntiSpam API.' => 'TypePad AntiSpamの既定のホストはapi.antispam.typepad.comです。TypePad AntiSpam APIと互換性を持つ他のサービスを利用する場合に限って、この設定を変更してください。',

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'スコアの重みづけ',
	'Least Weight' => '緩い',
	'Most Weight' => '厳しい',
	'Comments and TrackBacks receive a junk score between -10 (definitely spam) and +10 (definitely not spam). This setting allows you to control the weight of the TypePad AntiSpam rating relative to other filters you may have installed to help you filter comments and TrackBacks.' => 'コメントおよびトラックバックには-10(間違いなくスパム)から+10(スパムではありえない)までの範囲で点数が付けられます。この設定を変更すると、TypePad AntiSpamによる判定を、インストールされている他のスパムフィルタの判定との関連で高くしたり低くしたりすることで、コメントとトラックバックのスパムフィルタリングの設定を調整できます。',

## plugins/TypePadAntiSpam/TypePadAntiSpam.pl
	'TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."' => '<a href="http://antispam.typepad.jp/" target="_blank">TypePad AntiSpam</a>はSix Apartから無償で提供される、コメントとトラックバックスパムからあなたのブログを守るためのサービスです。TypePad AntiSpamプラグインは、あなたのブログに宛てられたすべてのコメントとトラックバックを、評価のためにサービスに送信し、TypePad AntiSpamがスパムであると判断した場合には、Movable Typeがそれをフィルタリングします。TypePad AntiSpamによる判定に誤りがあった場合は、コメントの一覧画面でそれをスパムにする、あるいはスパムではないと指定すれば、TypePad AntiSpamはそれを学習します。このようなユーザーからのレポートによってTypePad AntiSpamによる評価の精度がさらに高ります。そのため、アイテムをスパムにしたり、スパムから解除する場合には、少し気をつけてください。',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.' => 'これまでのところ、TypePad AntiSpamはこのブログに対するスパムを[quant,_1,件,件]ブロックしました。システム全体では[quant,_1,件,件]ブロックしました。',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.' => 'これまでのところ、TypePad AntiSpamはこのシステム全体に対するスパムを[quant,_1,件,件]ブロックしました。',
	'Failed to verify your TypePad AntiSpam API key: [_1]' => 'TypePad AntiSpam APIキーの検証に失敗しました: [_1]',
	'The TypePad AntiSpam API key provided is invalid.' => '不正なTypePad AntiSpam APIキーです。',

## plugins/TypePadAntiSpam/lib/MT/TypePadAntiSpam.pm
	'API key is a required parameter.' => 'APIキーを設定してください。',

);

1;

