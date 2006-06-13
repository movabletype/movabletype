# GoogleSearch plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package GoogleSearch::L10N::ja;

use strict;
use base 'GoogleSearch::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    'Google API Key:' => 'Google APIキー: ',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.' => 'Google APIを利用する場合は、ここにキーを入力してください。',
    "Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href='http://www.google.com/apis/'>license key.</a>" => "Googleの検索結果を保持するテンプレートタグを追加します。このプラグインを利用するためには<a href='http://www.google.com/apis/'>ライセンスキー</a>が必要です。",
   'You used [_1] without a query.' => '「[_1]」を利用するときは クエリーを指定してください。',
    'You need a Google API key to use [_1]' => '「[_1]」を使うにはGoogle APIキーが必要です。',
    'You used a non-existent property from the result structure.' => '結果に含まれないプロパティを利用しようとしています。',
    
);

1;

