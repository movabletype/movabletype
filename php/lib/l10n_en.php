<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

global $Lexicon;
$Lexicon = array(
	'INDIVIDUAL_ADV' => 'Entry',
	'PAGE_ADV' => 'Page',
	'YEARLY_ADV' => 'Yearly',
	'MONTHLY_ADV' => 'Monthly',
	'DAILY_ADV' => 'Daily',
	'WEEKLY_ADV' => 'Weekly',
	'AUTHOR_ADV' => 'Author',
	'AUTHOR-YEARLY_ADV' => 'Author Yearly',
	'AUTHOR-MONTHLY_ADV' => 'Author Monthly',
	'AUTHOR-DAILY_ADV' => 'Author Daily',
	'AUTHOR-WEEKLY_ADV' => 'Author Weekly',
	'CATEGORY_ADV' => 'Category',
	'CATEGORY-YEARLY_ADV' => 'Category Yearly',
	'CATEGORY-MONTHLY_ADV' => 'Category Monthly',
	'CATEGORY-DAILY_ADV' => 'Category Daily',
	'CATEGORY-WEEKLY_ADV' => 'Category Weekly',
	'CONTENTTYPE_ADV' => 'Content Type',
	'CONTENTTYPE-DAILY_ADV' => 'Content Type Daily',
	'CONTENTTYPE-WEEKLY_ADV' => 'Content Type Weekly',
	'CONTENTTYPE-MONTHLY_ADV' => 'Content Type Monthly',
	'CONTENTTYPE-YEARLY_ADV' => 'Content Type Yearly',
	'CONTENTTYPE-AUTHOR_ADV' => 'Content Type Author',
	'CONTENTTYPE-AUTHOR-YEARLY_ADV' => 'Content Type Author Yearly',
	'CONTENTTYPE-AUTHOR-MONTHLY_ADV' => 'Content Type Author Monthly',
	'CONTENTTYPE-AUTHOR-DAILY_ADV' => 'Content Type Author Daily',
	'CONTENTTYPE-AUTHOR-WEEKLY_ADV' => 'Content Type Author Weekly',
	'CONTENTTYPE-CATEGORY_ADV' => 'Content Type Category',
	'CONTENTTYPE-CATEGORY-YEARLY_ADV' => 'Content Type Category Yearly',
	'CONTENTTYPE-CATEGORY-MONTHLY_ADV' => 'Content Type Category Monthly',
	'CONTENTTYPE-CATEGORY-DAILY_ADV' => 'Content Type Category Daily',
	'CONTENTTYPE-CATEGORY-WEEKLY_ADV' => 'Content Type Category Weekly'
);

function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_ja;
    $l10n_str = isset($Lexicon[$str]) ? $Lexicon[$str] : $str;
    return translate_phrase_param($l10n_str, $params);
}
?>
