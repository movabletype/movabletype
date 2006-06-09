# $Id$

use Test;
use MT::Util;

BEGIN { plan tests => 7 }

use MT;
MT->set_language('en_US');

ok(MT::Util::iso_dirify("Siegfried & Roy"), "siegfried_roy");
ok(MT::Util::iso_dirify("Cauchy-Schwartz Inequality"), "cauchyschwartz_inequality");
ok(MT::Util::utf8_dirify("Siegfried & Roy"), "siegfried_roy");
ok(MT::Util::utf8_dirify("Cauchy-Schwartz Inequality"), 
   "cauchyschwartz_inequality");

ok(MT::Util::iso_dirify("Some & Something"), 
   MT::Util::utf8_dirify("Some & Something"));

ok(MT::Util::iso_dirify("Cauchy-Schwartz Inequality"), 
   MT::Util::utf8_dirify("Cauchy-Schwartz Inequality"));

ok(MT::Util::utf8_dirify("M\303\272m"), "mum");

