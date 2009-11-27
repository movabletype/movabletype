# WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WidgetManager::L10N::ja;

use strict;
use utf8;
use base 'WidgetManager::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager version 1.1; このプラグインは、古いバージョンのWidget ManagerのデータをMovable Typeのコアへ統合してアップグレードするために提供されています。アップグレード以外の機能はありません。最新のMovable Typeへアップグレードし終わった後は、このプラグインを削除してください。',
	'Moving storage of Widget Manager [_2]...' => 'ウィジェット管理[_2]の格納場所を移動しています。...',

);

1;

