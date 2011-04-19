/*
Pagination Component
$Id: Pager.js 159 2007-04-24 01:05:37Z ydnar $

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

Pager = new Class( Component, {
    
    initObject: function( element, list, templateName ) {
        arguments.callee.applySuper( this, arguments );

        if ( !templateName )
            throw "Pager requires a template name";
        this.templateName = templateName;
        
        list.addObserver( this );
        this.state = {
            total: 0,
            pages: 1,
            currentPage: 1,
            perPage: 0
        };
    },

    
    listTotal: function( listobj, total, currentPage, perPage, count ) {
        this.state = {
            total: parseInt( total ),
            pages: Math.ceil( total / perPage ),
            currentPage: parseInt( currentPage ),
            perPage: parseInt( perPage ),
            /* items on this page */
            count: parseInt( count )
        };
        this.render();
    },


    render: function() {
        this.element.innerHTML = Template.process( this.templateName, this.state );
    },


    eventClick: function( event ) {
        var command = this.getMouseEventCommand( event );
        if ( !command ) return;

        var m = command.match(/page-(\d+)/);
        if ( m ) {
            this.broadcastToObservers( "pagerPageChange", this, m[ 1 ] );
            //% this sucks on lists in dialogs
            //% window.scrollTo( 0, 0 );
            return event.stop();
        }
    }

});
