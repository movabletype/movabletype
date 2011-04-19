/* 
Calendar Utility
$Id: Calendar.js 259 2008-02-06 05:04:04Z ddavis $

Copyright (c) 2006, Six Apart, Ltd.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above
copyright notice, this list of conditions and the following disclaimer
in the documentation and/or other materials provided with the
distribution.

    * Neither the name of "Six Apart" nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


Calendar = new Class( Transient, {

    msInDay: ( 1000 * 60 * 60 * 24 ),


    initObject: function( element, templateName ) {
        arguments.callee.applySuper( this, arguments );
        this.templateName = templateName;
       
        this.contentElement = DOM.getElement( this.element.id + '-content' );
        if( !this.contentElement )
            this.contentElement = this.element;

        this.timeElement = DOM.getElement( this.element.id + '-time-input' );
        if( !this.timeElement )
            throw "Cannot find time element:" + this.element.id + "-time-input";

        this.dateObject = new Date();
    },
    

    destroyObject: function() {
        this.element = null;
        this.contentElement = null;
        this.timeElement = null;
        this.dateObject = null;
        this.currentDateObject = null;
        arguments.callee.applySuper( this, arguments );
    },

    
    open: function() {
        arguments.callee.applySuper( this, arguments );

        this.dateObject = ( !this.data.date ) ? ( new Date() ) : Date.fromISOString( this.data.date );

        /* we need a current date object so we can do comparisons later for disallowing future dates */
        this.currentDateObject = ( !this.data.currentDate ) ? ( new Date() ) : Date.fromISOString( this.data.currentDate );

        this.disallowFuture = this.data.disallowFuture;

        this.timeElement.value = this.getISOTimeShortString();
        
        this.render();
        this.reflow();
    },
    

    close: function( ok ) {
        var r = !ok ? ok : this.dateObject;
        arguments.callee.callSuper( this, r );
    },


    render: function() {
       this.contentElement.innerHTML = Template.process( this.templateName, { cal: this } ); 
    },
    

    eventClick: function( event ) {
        if( !this.isOpen ) // This keeps unopened calendars from hearing the event and breaking (Case 33303).
            return; 
        var command = this.getMouseEventCommand( event );
        if ( !command )
            return;

        event.stop();
                
        var m;
        var day;
        if ( m = command.match( /setDay-(\d+)/ ) ) {
            day = m[ 1 ];
            command = 'setDay';
        }
        
        switch( command ) {
            
            case "nextMonth":
                this.nextMonth();
                this.render();
                break;
            
            case "prevMonth":
                this.prevMonth();
                this.render();
                break;
            
            case "cancel":
                this.close();
                break;

            case "save":
                this.checkTimeInput();
                this.close( true );
                break;

            case "setDay":
                var resetTime = false;
                if ( this.disallowFuture ) {
                    var dt = this.dateObject.clone();
                    dt.setDate( day );
                    /* detect if they are selecting a future date,
                     * and reset the time
                     */
                    if ( dt > this.currentDateObject ) {
                        dt.setSeconds( 1 );
                        dt.setHours( 0 );
                        dt.setMinutes( 0 );
                        if ( dt > this.currentDateObject )
                            break;
                        else
                            resetTime = true;
                    }
                }
                var d = this.date();
                
                /* no nothing when clicking the same day */
                if ( d == day )
                    break;
                this.date( day );
                
                var es = DOM.getElementsByClassName( this.contentElement, "day-" + d );
                if ( es && es[ 0 ] )
                    DOM.removeClassName( es[ 0 ], "selected" );
                
                es = DOM.getElementsByClassName( this.contentElement, "day-" + day );
                if ( es && es[ 0 ] )
                    DOM.addClassName( es[ 0 ], "selected" );

                if ( resetTime ) {
                    var d = new Date();
                    var hours = d.getHours().toString().pad( 2, "0" );
                    var minutes = d.getMinutes().toString().pad( 2, "0" );
                    var seconds = d.getSeconds().toString().pad( 2, "0" );
                    this.timeElement.value = hours + ":" + minutes + ":" + seconds;
                    this.time( this.timeElement.value );
                }
                    
                break;
        }
    },


    eventBlur: function( event ) {
        if ( event.target !== this.timeElement )
            return;
        
        this.checkTimeInput();
        
        /* time adjustment can change the date, so re-render */
        try { this.render(); } catch ( e ) { };
    },


    checkTimeInput: function() {
        var time = this.timeElement.value;
        
        var m = time.match( /^\d{2}:\d{2}:\d{2}/ );
        if ( !m ) {
            this.timeElement.value = this.time();
            return;
        }
        
        if ( this.disallowFuture ) {
            var dt = this.dateObject.clone();
            this.time( time, dt );
            if ( dt > this.currentDateObject ) {
                this.timeElement.value = this.time();
                return;
            }
        }

        this.timeElement.value = this.time( time );
        
    },
    
    
    eventMouseOver: function( event ) {
        DOM.addClassName( this.element, "hover-over" );
    },


    eventMouseOut: function( event ) {
        DOM.removeClassName( this.element, "hover-over" );
    },


    nextMonthAllowed: function() {
        if ( this.disallowFuture ) {
            var dt = this.dateObject.clone();
            var month = this.month();
            var year = this.year();
            
            if ( month == 11 ) {
                month = 1;
                year++;
            } else
                month++;
            
            dt.setMonth( month );
            dt.setYear( year );
            dt.setDate( 1 );
            
            if ( dt > this.currentDateObject )
                return false;
        }
        
        return true;
    },

    
    nextMonth: function() {
        var m = this.month();
        var y = this.year();
        
        if ( m == 11 ) {
            m = 0;
            y++;
        } else
            m++;
        
        if ( this.disallowFuture ) {
            var dt = this.dateObject.clone();
            dt.setMonth( m );
            dt.setYear( y );
            if ( dt > this.currentDateObject ) {
                dt.setDate( 1 );
                if ( dt > this.currentDateObject ) {
                    return false;
                } else {
                    this.date( 1 );
                }
            }
        }
        
        this.year( y );

        /* if setting the month fails, reset the date to the last day of the month first */
        if ( this.month( m ) != m ) {
            this.date( this.getDaysInMonth( m ) );
            this.month( m );
        }

        return true;
    },


    prevMonth: function() {
        var m = this.month();
        var y = this.year();
        
        if ( m == 0 ) {
            m = 11;
            y--;
        } else
            m--;
        
        this.year( y );
        
        /* if setting the month fails, reset the date to the last day of the month first */
        if ( this.month( m ) != m ) {
            this.date( this.getDaysInMonth( m ) );
            this.month( m );
        }

        return true;
    },


    isToday: function( day ) {
        var dt = this.dateObject.clone();
        dt.setDate( day );
        return ( this.getCurrentISODate() == dt.toISODateString() );
    },
    
    
    isFuture: function( day ) {
        var dt = this.dateObject.clone();
        dt.setDate( day );
        dt.setSeconds( 1 );
        dt.setHours( 0 );
        dt.setMinutes( 0 );
        return ( dt > this.currentDateObject );
    },

    
    getCurrentISODate: function() {
        return this.currentDateObject.toISODateString();
    },


    /* get the calendar date in ISO format */
    getISODate: function() {
        return this.dateObject.toISODateString();
    },
   
 
    /* get the calendar time in ISO format */
    getISOTime: function() {
        return this.dateObject.toISOTimeString();
    },
    
    
    /* used to get a short version for editing */
    getISOTimeShortString: function() {
        var hours = this.dateObject.getHours().toString().pad( 2, "0" );
        var minutes = this.dateObject.getMinutes().toString().pad( 2, "0" );
        var seconds = this.dateObject.getSeconds().toString().pad( 2, "0" );
        return hours + ":" + minutes + ":" + seconds;
    },


    /* get the calendar time and date in ISO format */
    getISOString: function() {
        return this.dateObject.toISOString();
    },


    /* getters and setters */

    /* get/set the month, 0 - 11 */
    month: function( m ) {
        if ( defined( m ) )
            this.dateObject.setMonth( m );

        return this.dateObject.getMonth();
    },


    /* get/set the year, 2006 */
    year: function( year ) {
        if ( year )
            this.dateObject.setFullYear( year );

        return this.dateObject.getFullYear();
    },


    /* get/set the day of month, 1 - 31 */
    date: function( day ) {
        if ( day )
            this.dateObject.setDate( day );

        return this.dateObject.getDate();
    },


    time: function( time, dateobj ) {
        if ( !dateobj )
            dateobj = this.dateObject;
        if ( time ) {
            var m = time.match( /^(\d{2}):(\d{2}):(\d{2})/ );
            if ( !m && m.length > 2 )
                return dateobj.toISOTimeString();

            dateobj.setHours( finiteInt( m[ 1 ], 10 ) );
            dateobj.setMinutes( finiteInt( m[ 2 ], 10 ) );
            dateobj.setSeconds( finiteInt( m[ 3 ], 10 ) );
        }

        return dateobj.toISOTimeString();
    },


    weekStart: function() {
        return Date.strings.localeWeekStart;
    },

    
    /* get the day of the week, 0 sunday - 6 saturday */
    dow: function( opt ) {
        if ( opt )
            log.error( 'Calendar.dow() is only a getter' );

        return this.dateObject.getDay();
    },
    
    
    getDOWFromDay: function( day ) {
        var dt = this.dateObject.clone();
        dt.setDate( day );
        return dt.getDay();
    },

   
    /* get the number of days in the month, year is optional */ 
    getDaysInMonth: function( month, year ) {
        if ( !month )
            month = this.month();

        if ( !year )
            year = this.year();
        
        return 32 - ( new Date( year, month, 32 ) ).getDate();
    },


    getLocaleDayString: function( dow ) {
        return this.dateObject.getLocaleDayString( dow );
    },


    getLocaleDayShortString: function( dow ) {
        return this.dateObject.getLocaleDayShortString( dow );
    },


    getLocaleMonthString: function( month ) {
        return this.dateObject.getLocaleMonthString( month );
    },

    
    getLocaleMonthShortString: function( month ) {
        return this.dateObject.getLocaleMonthShortString( month );
    }
});

/*
 * Calendar JavaScript Template
    <div class="calendar-month">
        <a href="javascript: void 0;" class="left command-prev-month">&laquo;</a>
        [# if ( cal.nextMonthAllowed() ) { #]
        <a href="javascript: void 0;" class="right command-next-month">&raquo;</a>
        [# } #]
        <h1>[#|h cal.getLocaleMonthShortString() #] [#= cal.year() #]</h1>
    </div>
    <ul class="calendar-week">
        [# for ( var i = cal.weekStart(); i <= ( 6 + cal.weekStart() ); i++ ) { #]
            <li>[#|h cal.getLocaleDayShortString( ( cal.weekStart() && i == ( 6 + cal.weekStart() ) ? 0 : i ) ) #]</li>
        [# } #]
    </ul>
    <ul class="calendar-days">
        [#
            var daysInMonth = cal.getDaysInMonth();
            var monthStart = ( cal.getDOWFromDay( 1 ) - cal.weekStart() );
            if ( monthStart == -1 )
                monthStart = 6;
        #]
        [# for ( var i = 0; i < monthStart; i++ ) { #]
            <li>&nbsp;</li>
        [# } #]
        [# for ( var day = 1; day <= daysInMonth; day++ ) { #]
            [# var isFuture = cal.isFuture( day ) ? true : false; #]
            <li class="day-[#= day #][# if ( cal.date() == day ) { #] selected[# } #][# if ( cal.isToday( day ) ) { #] today[# } #][# 
                if ( isFuture ) { #] future[# } #]"
             >[# if ( !( isFuture && cal.disallowFuture ) ) { #]<a href="javascript: void 0;" class="command-set-day-[#= day #]">[#= day #]</a>[# } else { #][#= day #][# } #]</li>
        [# } #]
        [# for ( var i = ( cal.getDOWFromDay( daysInMonth ) - cal.weekStart() ); i < 6; i++ ) {
            if ( i == -i ) 
                break; #]
            <li>&nbsp;</li>
        [# } #]
    </ul>
*/
