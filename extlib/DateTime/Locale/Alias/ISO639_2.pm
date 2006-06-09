#############################################################################################################################
# -*- perl -*-
#
# DateTime::Locale::Alias::ISO639_2
#
# Adds ISO 639 2 language locale id aliases 
#
# Copyright (c) 2003 Richard Evans. All rights reserved.
# This code is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# This code is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# Richard Evans <rich@ridas.com>
#
#############################################################################################################################

package DateTime::Locale::Alias::ISO639_2;

use DateTime::Locale;

sub import
{
    DateTime::Locale->add_aliases
        ( { 'afr'                  => 'af',
            'afr_ZA'               => 'af_ZA',
            'alb'                  => 'sq',
            'alb_AL'               => 'sq_AL',
            'amh'                  => 'am',
            'amh_ET'               => 'am_ET',
            'ara'                  => 'ar',
            'ara_AE'               => 'ar_AE',
            'ara_BH'               => 'ar_BH',
            'ara_DZ'               => 'ar_DZ',
            'ara_EG'               => 'ar_EG',
            'ara_IN'               => 'ar_IN',
            'ara_IQ'               => 'ar_IQ',
            'ara_JO'               => 'ar_JO',
            'ara_KW'               => 'ar_KW',
            'ara_LB'               => 'ar_LB',
            'ara_LY'               => 'ar_LY',
            'ara_MA'               => 'ar_MA',
            'ara_OM'               => 'ar_OM',
            'ara_QA'               => 'ar_QA',
            'ara_SA'               => 'ar_SA',
            'ara_SD'               => 'ar_SD',
            'ara_SY'               => 'ar_SY',
            'ara_TN'               => 'ar_TN',
            'ara_YE'               => 'ar_YE',
            'arm'                  => 'hy',
            'arm_AM'               => 'hy_AM',
            'arm_AM_REVISED'       => 'hy_AM_REVISED',
            'aze'                  => 'az',
            'aze_AZ'               => 'az_AZ',
            'baq'                  => 'eu',
            'baq_ES'               => 'eu_ES',
            'baq_ES_PREEURO'       => 'eu_ES',
            'bel'                  => 'be',
            'bel_BY'               => 'be_BY',
            'ben'                  => 'bn',
            'ben_IN'               => 'bn_IN',
            'bul'                  => 'bg',
            'bul_BG'               => 'bg_BG',
            'cat'                  => 'ca',
            'cat_ES'               => 'ca_ES',
            'cat_ES_PREEURO'       => 'ca_ES',
            'ces'                  => 'cs',
            'ces_CZ'               => 'cs_CZ',
            'chi'                  => 'zh',
            'chi_CN'               => 'zh_CN',
            'chi_HK'               => 'zh_HK',
            'chi_MO'               => 'zh_MO',
            'chi_SG'               => 'zh_SG',
            'chi_TW'               => 'zh_TW',
            'chi_TW_STROKE'        => 'zh_TW_STROKE',
            'cor'                  => 'kw',
            'cor_GB'               => 'kw_GB',
            'cze'                  => 'cs',
            'cze_CZ'               => 'cs_CZ',
            'dan'                  => 'da',
            'dan_DK'               => 'da_DK',
            'deu'                  => 'de',
            'deu_AT'               => 'de_AT',
            'deu_AT_PREEURO'       => 'de_AT',
            'deu_BE'               => 'de_BE',
            'deu_CH'               => 'de_CH',
            'deu_DE'               => 'de_DE',
            'deu_DE_PREEURO'       => 'de_DE',
            'deu_LI'               => 'de_LI',
            'deu_LU'               => 'de_LU',
            'deu_LU_PREEURO'       => 'de_LU',
            'dut'                  => 'nl',
            'dut_BE'               => 'nl_BE',
            'dut_BE_PREEURO'       => 'nl_BE',
            'dut_NL'               => 'nl_NL',
            'dut_NL_PREEURO'       => 'nl_NL',
            # 'dv'                   => 'dv',
            # 'dv_MV'                => 'dv_MV',
            'ell'                  => 'el',
            'ell_GR'               => 'el_GR',
            'ell_GR_PREEURO'       => 'el_GR',
            'eng'                  => 'en',
            'eng_AS'               => 'en_AS',
            'eng_AU'               => 'en_AU',
            'eng_BE'               => 'en_BE',
            'eng_BE_PREEURO'       => 'en_BE',
            'eng_BW'               => 'en_BW',
            'eng_BZ'               => 'en_BZ',
            'eng_CA'               => 'en_CA',
            'eng_GB'               => 'en_GB',
            'eng_GB_EURO'          => 'en_GB',
            'eng_GU'               => 'en_GU',
            'eng_HK'               => 'en_HK',
            'eng_IE'               => 'en_IE',
            'eng_IE_PREEURO'       => 'en_IE',
            'eng_IN'               => 'en_IN',
            'eng_JM'               => 'en_JM',
            'eng_MH'               => 'en_MH',
            'eng_MP'               => 'en_MP',
            'eng_MT'               => 'en_MT',
            'eng_NZ'               => 'en_NZ',
            'eng_PH'               => 'en_PH',
            'eng_SG'               => 'en_SG',
            'eng_TT'               => 'en_TT',
            'eng_UM'               => 'en_UM',
            'eng_US'               => 'en_US',
            'eng_US_POSIX'         => 'en_US_POSIX',
            'eng_VI'               => 'en_VI',
            'eng_ZA'               => 'en_ZA',
            'eng_ZW'               => 'en_ZW',
            'epo'                  => 'eo',
            'est'                  => 'et',
            'est_EE'               => 'et_EE',
            'eus'                  => 'eu',
            'eus_ES'               => 'eu_ES',
            'eus_ES_PREEURO'       => 'eu_ES',
            'fao'                  => 'fo',
            'fao_FO'               => 'fo_FO',
            'fas'                  => 'fa',
            'fas_IR'               => 'fa_IR',
            'fin'                  => 'fi',
            'fin_FI'               => 'fi_FI',
            'fin_FI_PREEURO'       => 'fi_FI',
            'fra'                  => 'fr',
            'fra_BE'               => 'fr_BE',
            'fra_BE_PREEURO'       => 'fr_BE',
            'fra_CA'               => 'fr_CA',
            'fra_CH'               => 'fr_CH',
            'fra_FR'               => 'fr_FR',
            'fra_FR_PREEURO'       => 'fr_FR',
            'fra_LU'               => 'fr_LU',
            'fra_LU_PREEURO'       => 'fr_LU',
            'fra_MC'               => 'fr_MC',
            'fre'                  => 'fr',
            'fre_BE'               => 'fr_BE',
            'fre_BE_PREEURO'       => 'fr_BE',
            'fre_CA'               => 'fr_CA',
            'fre_CH'               => 'fr_CH',
            'fre_FR'               => 'fr_FR',
            'fre_FR_PREEURO'       => 'fr_FR',
            'fre_LU'               => 'fr_LU',
            'fre_LU_PREEURO'       => 'fr_LU',
            'fre_MC'               => 'fr_MC',
            'geo'                  => 'ka',
            'geo_GE'               => 'ka_GE',
            'ger'                  => 'de',
            'ger_AT'               => 'de_AT',
            'ger_AT_PREEURO'       => 'de_AT',
            'ger_BE'               => 'de_BE',
            'ger_CH'               => 'de_CH',
            'ger_DE'               => 'de_DE',
            'ger_DE_PREEURO'       => 'de_DE',
            'ger_LI'               => 'de_LI',
            'ger_LU'               => 'de_LU',
            'ger_LU_PREEURO'       => 'de_LU',
            'gle'                  => 'ga',
            'gle_IE'               => 'ga_IE',
            'gle_IE_PREEURO'       => 'ga_IE',
            'glg'                  => 'gl',
            'glg_ES'               => 'gl_ES',
            'glg_ES_PREEURO'       => 'gl_ES',
            'glv'                  => 'gv',
            'glv_GB'               => 'gv_GB',
            'gre'                  => 'el',
            'gre_GR'               => 'el_GR',
            'gre_GR_PREEURO'       => 'el_GR',
            'guj'                  => 'gu',
            'guj_IN'               => 'gu_IN',
            'heb'                  => 'he',
            'heb_IL'               => 'he_IL',
            'hin'                  => 'hi',
            'hin_IN'               => 'hi_IN',
            'hrv'                  => 'hr',
            'hrv_HR'               => 'hr_HR',
            'hun'                  => 'hu',
            'hun_HU'               => 'hu_HU',
            'hye'                  => 'hy',
            'hye_AM'               => 'hy_AM',
            'hye_AM_REVISED'       => 'hy_AM_REVISED',
            'ice'                  => 'is',
            'ice_IS'               => 'is_IS',
            'ind'                  => 'id',
            'ind_ID'               => 'id_ID',
            'isl'                  => 'is',
            'isl_IS'               => 'is_IS',
            'ita'                  => 'it',
            'ita_CH'               => 'it_CH',
            'ita_IT'               => 'it_IT',
            'ita_IT_PREEURO'       => 'it_IT',
            # 'iw'                   => 'iw',
            # 'iw_IL'                => 'iw_IL',
            'jpn'                  => 'ja',
            'jpn_JP'               => 'ja_JP',
            'kal'                  => 'kl',
            'kal_GL'               => 'kl_GL',
            'kan'                  => 'kn',
            'kan_IN'               => 'kn_IN',
            'kat'                  => 'ka',
            'kat_GE'               => 'ka_GE',
            'kaz'                  => 'kk',
            'kaz_KZ'               => 'kk_KZ',
            'kir'                  => 'ky',
            'kir_KG'               => 'ky_KG',
            'kor'                  => 'ko',
            'kor_KR'               => 'ko_KR',
            'lav'                  => 'lv',
            'lav_LV'               => 'lv_LV',
            'lit'                  => 'lt',
            'lit_LT'               => 'lt_LT',
            'mac'                  => 'mk',
            'mac_MK'               => 'mk_MK',
            'mar'                  => 'mr',
            'mar_IN'               => 'mr_IN',
            'may'                  => 'ms',
            'may_BN'               => 'ms_BN',
            'may_MY'               => 'ms_MY',
            'mkd'                  => 'mk',
            'mkd_MK'               => 'mk_MK',
            'mlt'                  => 'mt',
            'mlt_MT'               => 'mt_MT',
            'mon'                  => 'mn',
            'mon_MN'               => 'mn_MN',
            'msa'                  => 'ms',
            'msa_BN'               => 'ms_BN',
            'msa_MY'               => 'ms_MY',
            'nld'                  => 'nl',
            'nld_BE'               => 'nl_BE',
            'nld_BE_PREEURO'       => 'nl_BE',
            'nld_NL'               => 'nl_NL',
            'nld_NL_PREEURO'       => 'nl_NL',
            'nno'                  => 'nn',
            'nno_NO'               => 'nn_NO',
            'nob'                  => 'nb',
            'nob_NO'               => 'nb_NO',
            'nor'                  => 'no',
            'nor_NO'               => 'no_NO',
            'nor_NO_NY'            => 'no_NO_NY',
            'orm'                  => 'om',
            'orm_ET'               => 'om_ET',
            'orm_KE'               => 'om_KE',
            'pan'                  => 'pa',
            'pan_IN'               => 'pa_IN',
            'per'                  => 'fa',
            'per_IR'               => 'fa_IR',
            'pol'                  => 'pl',
            'pol_PL'               => 'pl_PL',
            'por'                  => 'pt',
            'por_BR'               => 'pt_BR',
            'por_PT'               => 'pt_PT',
            'por_PT_PREEURO'       => 'pt_PT',
            'ron'                  => 'ro',
            'ron_RO'               => 'ro_RO',
            'rum'                  => 'ro',
            'rum_RO'               => 'ro_RO',
            'rus'                  => 'ru',
            'rus_RU'               => 'ru_RU',
            'rus_UA'               => 'ru_UA',
            'san'                  => 'sa',
            'san_IN'               => 'sa_IN',
            'scc'                  => 'sr',
            'scc_YU'               => 'sr_YU',
            'scr'                  => 'hr',
            'scr_HR'               => 'hr_HR',
            # 'sh'                   => 'sh',
            # 'sh_YU'                => 'sh_YU',
            'slk'                  => 'sk',
            'slk_SK'               => 'sk_SK',
            'slo'                  => 'sk',
            'slo_SK'               => 'sk_SK',
            'slv'                  => 'sl',
            'slv_SI'               => 'sl_SI',
            'som'                  => 'so',
            'som_DJ'               => 'so_DJ',
            'som_ET'               => 'so_ET',
            'som_KE'               => 'so_KE',
            'som_SO'               => 'so_SO',
            'spa'                  => 'es',
            'spa_AR'               => 'es_AR',
            'spa_BO'               => 'es_BO',
            'spa_CL'               => 'es_CL',
            'spa_CO'               => 'es_CO',
            'spa_CR'               => 'es_CR',
            'spa_DO'               => 'es_DO',
            'spa_EC'               => 'es_EC',
            'spa_ES'               => 'es_ES',
            'spa_ES_PREEURO'       => 'es_ES',
            'spa_GT'               => 'es_GT',
            'spa_HN'               => 'es_HN',
            'spa_MX'               => 'es_MX',
            'spa_NI'               => 'es_NI',
            'spa_PA'               => 'es_PA',
            'spa_PE'               => 'es_PE',
            'spa_PR'               => 'es_PR',
            'spa_PY'               => 'es_PY',
            'spa_SV'               => 'es_SV',
            'spa_US'               => 'es_US',
            'spa_UY'               => 'es_UY',
            'spa_VE'               => 'es_VE',
            'sqi'                  => 'sq',
            'sqi_AL'               => 'sq_AL',
            'srp'                  => 'sr',
            'srp_YU'               => 'sr_YU',
            'swa'                  => 'sw',
            'swa_KE'               => 'sw_KE',
            'swa_TZ'               => 'sw_TZ',
            'swe'                  => 'sv',
            'swe_FI'               => 'sv_FI',
            'swe_SE'               => 'sv_SE',
            'tam'                  => 'ta',
            'tam_IN'               => 'ta_IN',
            'tat'                  => 'tt',
            'tat_RU'               => 'tt_RU',
            'tel'                  => 'te',
            'tel_IN'               => 'te_IN',
            'tha'                  => 'th',
            'tha_TH'               => 'th_TH',
            # 'ti'                   => 'ti',
            # 'ti_ER'                => 'ti_ER',
            # 'ti_ET'                => 'ti_ET',
            'tur'                  => 'tr',
            'tur_TR'               => 'tr_TR',
            'ukr'                  => 'uk',
            'ukr_UA'               => 'uk_UA',
            'urd'                  => 'ur',
            'urd_PK'               => 'ur_PK',
            'uzb'                  => 'uz',
            'uzb_UZ'               => 'uz_UZ',
            'vie'                  => 'vi',
            'vie_VN'               => 'vi_VN',
            'zho'                  => 'zh',
            'zho_CN'               => 'zh_CN',
            'zho_HK'               => 'zh_HK',
            'zho_MO'               => 'zh_MO',
            'zho_SG'               => 'zh_SG',
            'zho_TW'               => 'zh_TW',
            'zho_TW_STROKE'        => 'zh_TW_STROKE',
          }
        );
}

1;

__END__


=head1 NAME

DateTime::Locale::Alias::ISO639_2 - Adds ISO 639 2 language locale id aliases

=head1 SYNOPSIS

  use DateTime::Locale;
  use DateTime::Locale::Alias::ISO639_2;

  my $loc = DateTime::Locale->load('eng_US');

=head1 DESCRIPTION

Adds the following ISO 639 2 language locale aliases:

 Alias               Maps to
 ==========================

 afr                 af
 afr_ZA              af_ZA
 alb                 sq
 alb_AL              sq_AL
 amh                 am
 amh_ET              am_ET
 ara                 ar
 ara_AE              ar_AE
 ara_BH              ar_BH
 ara_DZ              ar_DZ
 ara_EG              ar_EG
 ara_IN              ar_IN
 ara_IQ              ar_IQ
 ara_JO              ar_JO
 ara_KW              ar_KW
 ara_LB              ar_LB
 ara_LY              ar_LY
 ara_MA              ar_MA
 ara_OM              ar_OM
 ara_QA              ar_QA
 ara_SA              ar_SA
 ara_SD              ar_SD
 ara_SY              ar_SY
 ara_TN              ar_TN
 ara_YE              ar_YE
 arm                 hy
 arm_AM              hy_AM
 arm_AM_REVISED      hy_AM_REVISED
 aze                 az
 aze_AZ              az_AZ
 baq                 eu
 baq_ES              eu_ES
 baq_ES_PREEURO      eu_ES
 bel                 be
 bel_BY              be_BY
 ben                 bn
 ben_IN              bn_IN
 bul                 bg
 bul_BG              bg_BG
 cat                 ca
 cat_ES              ca_ES
 cat_ES_PREEURO      ca_ES
 ces                 cs
 ces_CZ              cs_CZ
 chi                 zh
 chi_CN              zh_CN
 chi_HK              zh_HK
 chi_MO              zh_MO
 chi_SG              zh_SG
 chi_TW              zh_TW
 chi_TW_STROKE       zh_TW_STROKE
 cor                 kw
 cor_GB              kw_GB
 cze                 cs
 cze_CZ              cs_CZ
 dan                 da
 dan_DK              da_DK
 deu                 de
 deu_AT              de_AT
 deu_AT_PREEURO      de_AT
 deu_BE              de_BE
 deu_CH              de_CH
 deu_DE              de_DE
 deu_DE_PREEURO      de_DE
 deu_LI              de_LI
 deu_LU              de_LU
 deu_LU_PREEURO      de_LU
 dut                 nl
 dut_BE              nl_BE
 dut_BE_PREEURO      nl_BE
 dut_NL              nl_NL
 dut_NL_PREEURO      nl_NL
 ell                 el
 ell_GR              el_GR
 ell_GR_PREEURO      el_GR
 eng                 en
 eng_AS              en_AS
 eng_AU              en_AU
 eng_BE              en_BE
 eng_BE_PREEURO      en_BE
 eng_BW              en_BW
 eng_BZ              en_BZ
 eng_CA              en_CA
 eng_GB              en_GB
 eng_GB_EURO         en_GB
 eng_GU              en_GU
 eng_HK              en_HK
 eng_IE              en_IE
 eng_IE_PREEURO      en_IE
 eng_IN              en_IN
 eng_JM              en_JM
 eng_MH              en_MH
 eng_MP              en_MP
 eng_MT              en_MT
 eng_NZ              en_NZ
 eng_PH              en_PH
 eng_SG              en_SG
 eng_TT              en_TT
 eng_UM              en_UM
 eng_US              en_US
 eng_US_POSIX        en_US_POSIX
 eng_VI              en_VI
 eng_ZA              en_ZA
 eng_ZW              en_ZW
 epo                 eo
 est                 et
 est_EE              et_EE
 eus                 eu
 eus_ES              eu_ES
 eus_ES_PREEURO      eu_ES
 fao                 fo
 fao_FO              fo_FO
 fas                 fa
 fas_IR              fa_IR
 fin                 fi
 fin_FI              fi_FI
 fin_FI_PREEURO      fi_FI
 fra                 fr
 fra_BE              fr_BE
 fra_BE_PREEURO      fr_BE
 fra_CA              fr_CA
 fra_CH              fr_CH
 fra_FR              fr_FR
 fra_FR_PREEURO      fr_FR
 fra_LU              fr_LU
 fra_LU_PREEURO      fr_LU
 fra_MC              fr_MC
 fre                 fr
 fre_BE              fr_BE
 fre_BE_PREEURO      fr_BE
 fre_CA              fr_CA
 fre_CH              fr_CH
 fre_FR              fr_FR
 fre_FR_PREEURO      fr_FR
 fre_LU              fr_LU
 fre_LU_PREEURO      fr_LU
 fre_MC              fr_MC
 geo                 ka
 geo_GE              ka_GE
 ger                 de
 ger_AT              de_AT
 ger_AT_PREEURO      de_AT
 ger_BE              de_BE
 ger_CH              de_CH
 ger_DE              de_DE
 ger_DE_PREEURO      de_DE
 ger_LI              de_LI
 ger_LU              de_LU
 ger_LU_PREEURO      de_LU
 gle                 ga
 gle_IE              ga_IE
 gle_IE_PREEURO      ga_IE
 glg                 gl
 glg_ES              gl_ES
 glg_ES_PREEURO      gl_ES
 glv                 gv
 glv_GB              gv_GB
 gre                 el
 gre_GR              el_GR
 gre_GR_PREEURO      el_GR
 guj                 gu
 guj_IN              gu_IN
 heb                 he
 heb_IL              he_IL
 hin                 hi
 hin_IN              hi_IN
 hrv                 hr
 hrv_HR              hr_HR
 hun                 hu
 hun_HU              hu_HU
 hye                 hy
 hye_AM              hy_AM
 hye_AM_REVISED      hy_AM_REVISED
 ice                 is
 ice_IS              is_IS
 ind                 id
 ind_ID              id_ID
 isl                 is
 isl_IS              is_IS
 ita                 it
 ita_CH              it_CH
 ita_IT              it_IT
 ita_IT_PREEURO      it_IT
 jpn                 ja
 jpn_JP              ja_JP
 kal                 kl
 kal_GL              kl_GL
 kan                 kn
 kan_IN              kn_IN
 kat                 ka
 kat_GE              ka_GE
 kaz                 kk
 kaz_KZ              kk_KZ
 kir                 ky
 kir_KG              ky_KG
 kor                 ko
 kor_KR              ko_KR
 lav                 lv
 lav_LV              lv_LV
 lit                 lt
 lit_LT              lt_LT
 mac                 mk
 mac_MK              mk_MK
 mar                 mr
 mar_IN              mr_IN
 may                 ms
 may_BN              ms_BN
 may_MY              ms_MY
 mkd                 mk
 mkd_MK              mk_MK
 mlt                 mt
 mlt_MT              mt_MT
 mon                 mn
 mon_MN              mn_MN
 msa                 ms
 msa_BN              ms_BN
 msa_MY              ms_MY
 nld                 nl
 nld_BE              nl_BE
 nld_BE_PREEURO      nl_BE
 nld_NL              nl_NL
 nld_NL_PREEURO      nl_NL
 nno                 nn
 nno_NO              nn_NO
 nob                 nb
 nob_NO              nb_NO
 nor                 no
 nor_NO              no_NO
 nor_NO_NY           no_NO_NY
 orm                 om
 orm_ET              om_ET
 orm_KE              om_KE
 pan                 pa
 pan_IN              pa_IN
 per                 fa
 per_IR              fa_IR
 pol                 pl
 pol_PL              pl_PL
 por                 pt
 por_BR              pt_BR
 por_PT              pt_PT
 por_PT_PREEURO      pt_PT
 ron                 ro
 ron_RO              ro_RO
 rum                 ro
 rum_RO              ro_RO
 rus                 ru
 rus_RU              ru_RU
 rus_UA              ru_UA
 san                 sa
 san_IN              sa_IN
 scc                 sr
 scc_YU              sr_YU
 scr                 hr
 scr_HR              hr_HR
 slk                 sk
 slk_SK              sk_SK
 slo                 sk
 slo_SK              sk_SK
 slv                 sl
 slv_SI              sl_SI
 som                 so
 som_DJ              so_DJ
 som_ET              so_ET
 som_KE              so_KE
 som_SO              so_SO
 spa                 es
 spa_AR              es_AR
 spa_BO              es_BO
 spa_CL              es_CL
 spa_CO              es_CO
 spa_CR              es_CR
 spa_DO              es_DO
 spa_EC              es_EC
 spa_ES              es_ES
 spa_ES_PREEURO      es_ES
 spa_GT              es_GT
 spa_HN              es_HN
 spa_MX              es_MX
 spa_NI              es_NI
 spa_PA              es_PA
 spa_PE              es_PE
 spa_PR              es_PR
 spa_PY              es_PY
 spa_SV              es_SV
 spa_US              es_US
 spa_UY              es_UY
 spa_VE              es_VE
 sqi                 sq
 sqi_AL              sq_AL
 srp                 sr
 srp_YU              sr_YU
 swa                 sw
 swa_KE              sw_KE
 swa_TZ              sw_TZ
 swe                 sv
 swe_FI              sv_FI
 swe_SE              sv_SE
 tam                 ta
 tam_IN              ta_IN
 tat                 tt
 tat_RU              tt_RU
 tel                 te
 tel_IN              te_IN
 tha                 th
 tha_TH              th_TH
 tur                 tr
 tur_TR              tr_TR
 ukr                 uk
 ukr_UA              uk_UA
 urd                 ur
 urd_PK              ur_PK
 uzb                 uz
 uzb_UZ              uz_UZ
 vie                 vi
 vie_VN              vi_VN
 zho                 zh
 zho_CN              zh_CN
 zho_HK              zh_HK
 zho_MO              zh_MO
 zho_SG              zh_SG
 zho_TW              zh_TW
 zho_TW_STROKE       zh_TW_STROKE

To enable this support, simply add:

 use DateTime::Locale::Alias::ISO639_2;

to your code - that's it.

=head1 SUPPORT

Support for this module is provided via the datetime@perl.org email
list.  See http://lists.perl.org/ for more details.

=head1 AUTHOR

Richard Evans <rich@ridas.com>

=head1 COPYRIGHT

Copyright (c) 2003 Richard Evans. All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<DateTime::Locale>

=cut


