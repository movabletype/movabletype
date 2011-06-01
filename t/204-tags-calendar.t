#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 450
  run: 0
  template: "<MTCalendar><MTCalendarWeekHeader month='197801'><tr></MTCalendarWeekHeader><td><MTCalendarCellNumber>,<MTCalendarIfEntries><MTEntries lastn='1'><a href='<$MTEntryPermalink$>'><$MTCalendarDay$></a></MTEntries></MTCalendarIfEntries><MTCalendarIfNoEntries><$MTCalendarDay$></MTCalendarIfNoEntries><MTCalendarIfBlank>&nbsp;</MTCalendarIfBlank></td><MTCalendarWeekFooter></tr></MTCalendarWeekFooter></MTCalendar>', 'e' : '<tr><td>1,&nbsp;</td><td>2,&nbsp;</td><td>3,&nbsp;</td><td>4,&nbsp;</td><td>5,&nbsp;</td><td>6,1</td><td>7,2</td></tr><tr><td>8,3</td><td>9,4</td><td>10,5</td><td>11,6</td><td>12,7</td><td>13,8</td><td>14,9</td></tr><tr><td>15,10</td><td>16,11</td><td>17,12</td><td>18,13</td><td>19,14</td><td>20,15</td><td>21,16</td></tr><tr><td>22,17</td><td>23,18</td><td>24,19</td><td>25,20</td><td>26,21</td><td>27,22</td><td>28,23</td></tr><tr><td>29,24</td><td>30,25</td><td>31,26</td><td>32,27</td><td>33,28</td><td>34,29</td><td>35,30</td></tr>"
  expected: ''


######## Calendar
## month
## category

######## CalendarIfBlank

######## CalendarIfEntries

######## CalendarIfNoEntries

######## CalendarIfToday

######## CalendarWeekHeader

######## CalendarWeekFooter

######## CalendarDay

######## CalendarCellNumber

######## CalendarDate

