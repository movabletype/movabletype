#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: |-

    * Calendar lists each day of month.
    * CalenderIfBlank prints inner content if current cell isn't a padding cell.
    * CalendarDay prints the day of month.
  template: |
    <MTCalendar month='196501'><MTCalendarIfBlank><MTElse><MTCalendarDay>,</MTCalendarIfBlank></MTCalendar>
  expected: |
    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,

-
  name: CalendarCellNumber prints the current index of the cell in the month.
  template: |
    <MTCalendar month='196501'><MTCalendarCellNumber>,</MTCalendar>
  expected: |
    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,

-
  name: |-

    * CalendarWeekHeader and CalendarWeekFooter prints header and footer of the each week.
    * CalendarIfEntries prints inner content if the entry of the day exists.
    * CalendarIfNoEntries prints inner content if the entry of the day doesn't exists.
  template: |
    <MTCalendar month='196501'>
      <MTCalendarWeekHeader><tr></MTCalendarWeekHeader>
      <MTSection strip="" strip_linefeeds="1"><td>
        <MTCalendarCellNumber>,
        <MTCalendarIfEntries>
          <MTEntries lastn='1'>
            <$MTCalendarDay$>:<$MTEntryPermalink$>
          </MTEntries>
        </MTCalendarIfEntries>
        <MTCalendarIfNoEntries>
          <$MTCalendarDay$>
        </MTCalendarIfNoEntries>
        <MTCalendarIfBlank>&nbsp;</MTCalendarIfBlank>
      </td></MTSection>
      <MTCalendarWeekFooter></tr></MTCalendarWeekFooter>
    </MTCalendar>
  expected: |
    <tr>
    <td>1,&nbsp;</td>
    <td>2,&nbsp;</td>
    <td>3,&nbsp;</td>
    <td>4,&nbsp;</td>
    <td>5,&nbsp;</td>
    <td>6,1</td>
    <td>7,2</td>
    </tr>
    <tr>
    <td>8,3</td>
    <td>9,4</td>
    <td>10,5</td>
    <td>11,6</td>
    <td>12,7</td>
    <td>13,8</td>
    <td>14,9</td>
    </tr>
    <tr>
    <td>15,10</td>
    <td>16,11</td>
    <td>17,12</td>
    <td>18,13</td>
    <td>19,14</td>
    <td>20,15</td>
    <td>21,16</td>
    </tr>
    <tr>
    <td>22,17</td>
    <td>23,18</td>
    <td>24,19</td>
    <td>25,20</td>
    <td>26,21</td>
    <td>27,22</td>
    <td>28,23</td>
    </tr>
    <tr>
    <td>29,24</td>
    <td>30,25</td>
    <td>31,26</td>
    <td>32,27</td>
    <td>33,28</td>
    <td>34,29</td>
    <td>35,30</td>
    </tr>
    <tr>
    <td>36,31:http://narnia.na/nana/archives/1965/01/verse-5.html</td>
    <td>37,&nbsp;</td>
    <td>38,&nbsp;</td>
    <td>39,&nbsp;</td>
    <td>40,&nbsp;</td>
    <td>41,&nbsp;</td>
    <td>42,&nbsp;</td>
    </tr>

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

