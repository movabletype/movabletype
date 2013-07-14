# Movable Type (r) Open Source (C) 2006-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# Original Copyright (c) 2004-2006 David Raynes

package MultiBlog::L10N::ja;

use strict;
use utf8;
use base 'MultiBlog::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

## plugins/MultiBlog/lib/MultiBlog.pm
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'マルチブログの再構築により、てブログ(#[_1])をリストアしています...',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'MTMultiBlogタグは入れ子にできません。',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'mode属性が不正です。loopまたはcontextを指定してください。',

## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'MultiBlogを使うと他のブログのコンテンツを公開したりブログ同士での公開ルールの設定やアクセス制限を行うことができます。',
	'MultiBlog' => 'マルチブログ',
	'Create Trigger' => 'トリガーを作成',
	'Search Weblogs' => 'ブログ検索',
	'When this' => 'トリガー:',
	'(All blogs in this website)' => '(ウェブサイト内のすべてのブログ)',
	'Select to apply this trigger to all blogs in this website.' => 'ウェブサイト内のすべてのブログでトリガーを有効にする。',
	'(All websites and blogs in this system)' => '(システム内のすべてのウェブサイトとブログ)',
	'Select to apply this trigger to all websites and blogs in this system.' => 'システム内のすべてのウェブサイトとブログでトリガーを有効にする。',
	'saves an entry/page' => 'ブログ記事とウェブページの保存時',
	'publishes an entry/page' => 'ブログ記事とウェブページの公開時',
	'publishes a comment' => 'コメントの公開時',
	'publishes a TrackBack' => 'トラックバックの公開時',
	'rebuild indexes.' => 'インデックスを再構築する',
	'rebuild indexes and send pings.' => 'インデックスを再構築して更新pingを送信する',
	'Updating trigger cache of MultiBlog...' => 'トリガーの設定を更新しています...',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => ' ',
	'Trigger' => 'トリガー',
	'Action' => 'アクション',
	'Weblog' => 'ブログ',
	'Content Privacy' => 'コンテンツのセキュリティ',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => '同じMovable Type内の他のブログがこのブログのコンテンツを公開できるかどうかを指定します。この設定はシステムレベルのMultiBlogの構成で指定された既定のアグリゲーションポリシーよりも優先されます。',
	'Use system default' => 'システムの既定値を使用',
	'Allow' => '許可',
	'Disallow' => '許可しない',
	'MTMultiBlog tag default arguments' => 'MTMultiBlogタグの既定の属性:',
	q{Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or 'all' (include_blogs only) are acceptable values.} => q{include_blogs/exclude_blogs属性なしでMTMultiBlogタグを使用できるようにします。カンマで区切ったブログID、または「all」(include_blogs のみ)が指定できます。},
	'Include blogs' => '含めるブログ',
	'Exclude blogs' => '除外するブログ',
	'Rebuild Triggers' => '再構築トリガー',
	'Create Rebuild Trigger' => '再構築トリガーを作成',
	'You have not defined any rebuild triggers.' => '再構築トリガーを設定していません。',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'MultiBlog トリガーの作成',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => '既定のアグリゲーションポリシー',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'ブログをまたがったアグリゲーションが既定で許可されます。個別のブログレベルでのMultiBlogの設定で他のブログからのコンテンツへのアクセスを制限できます。',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'ブログをまたがったアグリゲーションが既定で不許可になります。個別のブログレベルでのMultiBlogの設定で他のブログからのコンテンツへのアクセスを許可することもできます。',

);

1;

