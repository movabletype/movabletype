# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Plugin::Diagnosis::L10N::ja;
use strict;
use warnings;
use utf8;
use base 'MT::Plugin::Diagnosis::L10N';

our %Lexicon = (
    'Diagnosis'         => '診断',
    'Repair Tasks'      => '修復タスク',
    'Scan Database'     => 'データベースをスキャンする',
    'Database Scanner'  => 'データベーススキャン',
    'Scan'              => 'スキャン',
    'Repair'            => '修復',
    'department'        => '科',
    'description'       => '説明',
    'repair parameters' => '修復パラメータ',
    'error'             => 'エラー',
    'None'              => 'なし',

    'PluginData' => 'プラグインデータ',
    'Revision'   => 'リビジョン',
    'OrphanSite' => 'サイトの親の欠損',

    'Select departments.' => '診療科を選択してください。',
    'Delete revision amount excession.' => 'リビジョンの超過を削除します。',
    'Delete plugindata breakage or duplication.' => 'プラグインデータの破損や重複を削除します。',
    'Delete parent mission sites.' => '親が欠損した子サイトを削除します。',

    'Pending'  => '実行待ち',
    'Started'  => '開始',
    'Finished' => '終了',
    'Aborting' => '中止待ち',
    'Aborted'  => '中止',

    # Scanner
    'Click Scan button to start database scan.'                     => 'スキャンボタンを押してデータベーススキャンを開始します。',
    'Select the repair tasks and repair button to start to repair.' => '修復タスクを選択して修復ボタンを押すと修復が開始されます。',
    'Repair tasks are added.'                                       => '修復タスクが追加されました。',

    # Diagnosis description
    'Excession on site id:[_1]. ([_2]/[_3])' => 'サイトID:[_1] に超過 ([_2]/[_3])',
    '[_1] duplications.'                     => '[_1]件の重複',
    'Breakages.'                             => '破損',
    'Parent is missing for site "[_1]".'     => 'サイト "[_1]" に親の欠損',
);

1;
