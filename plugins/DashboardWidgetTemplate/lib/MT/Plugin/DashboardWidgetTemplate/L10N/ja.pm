package MT::Plugin::DashboardWidgetTemplate::L10N::ja;

use strict;
use warnings;

use base 'MT::Plugin::DashboardWidgetTemplate::L10N';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/DashboardWidgetTemplate/config.yaml
	'This plugin provides the ability to create dashboard widgets from templates.' => 'テンプレートからダッシュボードウィジェットを作成する機能を提供します。',

## plugins/DashboardWidgetTemplate/lib/MT/Plugin/DashboardWidgetTemplate.pm
	'Create Dashboard Widget' => 'ダッシュボードウィジェットの作成',
	'Dashboard Widget' => 'ダッシュボードウィジェット',
	'No Name' => '名前なし',

## plugins/DashboardWidgetTemplate/tmpl/dashboard_widget_template_edit_template_options.tmpl
	'Always Show' => '常に表示',
	'On' => '有効にする',
	'The widget will be displayed to all users, and the button to delete it from the dashboard will be hidden.' => 'すべてのユーザーにウィジェットが表示され、ダッシュボードから削除するボタンが非表示になります。',
	q{If enabled, it will only appear on the site's dashboard. This widget will not be able to be added to user dashboards.} => q{有効にするとサイトのダッシュボードのみに表示されます。ユーザーダッシュボードへの追加はできなくなります。},
);

1;
