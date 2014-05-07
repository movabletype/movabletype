# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package Viewer::L10N::ja;
use strict;
use utf8;
use base qw( Viewer::L10N );

our %Lexicon = (

## lib/MT/App/Viewer.pm
        'Loading blog with ID [_1] failed' => 'ブログ (ID：[_1]) の読み込みに失敗しました',
        'File not found' => 'ファイルが見つかりません',
        'Template publishing failed: [_1]' => 'テンプレートの出力に失敗しました: [_1]',
        'Unknown archive type: [_1]' => 'アーカイブタイプが不明です: [_1]',
        'Cannot load template [_1]' => 'テンプレートを読み込めませんでした [_1]',
        'Archive publishing failed: [_1]' => 'アーカイブの公開に失敗しました: [_1]',
        'Invalid entry ID [_1].' => 'エントリーIDが不正です: [_1]',
        'Entry [_1] was not published.' => '記事 [_1] は公開されていません',
        'Invalid category ID \'[_1]\'' => 'カテゴリのIDが不正です: [_1]',
        'Invalid author ID \'[_1]\'' => 'ユーザーIDが不正です: [_1]',

);

1;
