# Movable Type (r) (C) 2006-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package GoogleAnalytics::L10N::ja;

use strict;
use warnings;

use base 'GoogleAnalytics::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Google Analyticsからアクセス統計データを取得します。',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'Google アナリティクス APIを利用するのに必要なPerlモジュールのうちいくつかがありません: [_1]',
	'You did not specify a client ID.' => 'Client IDが指定されていません。',
	'You did not specify a code.' => 'codeが指定されていません。',
	'The name of the profile' => 'プロファイル名',
	'The web property ID of the profile' => 'ウェブ プロパティ ID',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting token: [_1]: [_2]' => 'トークンが取得できません: [_1]: [_2]',
	'An error occurred when refreshing access token: [_1]: [_2]' => 'リフレッシュトークンが取得できません: [_1]: [_2]',
	'An error occurred when getting accounts: [_1]: [_2]' => 'アカウントの取得ができません: [_1]: [_2]',
	'An error occurred when getting profiles: [_1]: [_2]' => 'プロファイルの取得ができません: [_1]: [_2]',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => '統計データの取得ができません: [_1]: [_2]',

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'APIエラー',

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'プロファイルを選択してください',

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'Google Analytics' => 'Google Analytics',
	'OAuth2 settings' => 'OAuth2の設定',
	'This [_2] is using the settings of [_1].' => 'この[_2]は、[_1]の設定を利用しています。',
	'Other Google account' => '別のアカウントを利用する',
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Console</a> before selecting profile.} => q{プロファイルを選択するために、<a href="https://cloud.google.com/console" target="_blank">Google Cloud Console</a>でウェブアプリケーション向けのClient IDを作成してください。},
	'Redirect URI of the OAuth2 application' => '承認済みのリダイレクト URI',
	'Client ID of the OAuth2 application' => 'クライアント ID',
	'Client secret of the OAuth2 application' => 'クライアント シークレット',
	'Google Analytics profile' => '使用するGoogle Analyticsのプロファイル',
	'Select Google Analytics profile' => 'Google Analyticsのプロファイルを選択する',
	'(No profile selected)' => '（プロファイルが選択されていません）',
	'Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?' => 'Client IDあるいはClient secretが更新されていますが、プロファイルを選択し直していません。設定を保存してもよろしいですか？',

);

1;
