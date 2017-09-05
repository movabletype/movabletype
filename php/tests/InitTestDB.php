<?php

system('MT_CONFIG=mysql-test.cfg perl -It/lib -Ilib -Iextlib -MMT::Test=:db -E "say \"Initialized test DB.\""');

