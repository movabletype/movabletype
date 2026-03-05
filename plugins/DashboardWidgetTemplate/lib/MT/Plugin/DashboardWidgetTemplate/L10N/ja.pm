package MT::Plugin::DashboardWidgetTemplate::L10N::ja;

use strict;
use warnings;

use base 'MT::Plugin::DashboardWidgetTemplate::L10N';
use vars qw( %Lexicon );

%Lexicon = (
    'Dashboard Widget'                                                                                                      => 'ダッシュボードウィジェット',
    'Create Dashboard Widget'                                                                                               => 'ダッシュボードウィジェットの作成',
    'This plugin provides the ability to create dashboard widgets from templates.'                                          => 'テンプレートからダッシュボードウィジェットを作成する機能を提供します。',
    'Always Show'                                                                                                           => '常に表示',
    'The widget will be displayed to all users, and the button to delete it from the dashboard will be hidden.'             => 'すべてのユーザーにウィジェットが表示され、ダッシュボードから削除するボタンが非表示になります。',
    "If enabled, it will only appear on the site's dashboard. This widget will not be able to be added to user dashboards." => '有効にするとサイトのダッシュボードのみに表示されます。ユーザーダッシュボードへの追加はできなくなります。',
);

1;
