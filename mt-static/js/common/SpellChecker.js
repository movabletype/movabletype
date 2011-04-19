/*
Spell Checking Library
$Id: SpellChecker.js 159 2007-04-24 01:05:37Z ydnar $

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


SpellChecker = new Class( Observable, {
    SERVER_DELAY: 500,
    MAX_PENDING_WORDS: 100,
    
    
    init: function() {
        if( defined( this.words ) )
            return;
        arguments.callee.applySuper( this, arguments );
        this.words = {};
        this.pendingWords = [];
        this.timer = null;
    },


    destroy: function() {
        if( this.timer )
            this.timer.stop();
        return arguments.callee.applySuper( this, arguments );
    },
    

    check: function( word ) {
        this.init();
        if( !defined( word ) )
            return;
            
        if( this.words.hasOwnProperty( word ) )
            return (this.words[ word ] instanceof Array)
                ? SpellChecker.INVALID
                : this.words[ word ];
        
        var ignored = this.checkIgnore( word );
        if( defined( ignored ) )
            return ignored;

        this.pendingWords.push( word );
        this.words[ word ] = SpellChecker.PENDING;
        
        if( this.pendingWords.length >= this.MAX_PENDING_WORDS )
            this.getWords();
        else if( !this.timer )
            this.timer = new Timer( this.getIndirectMethod( "getWords" ), this.SERVER_DELAY );
        else
            this.timer.reset( this.SERVER_DELAY );
        
        return SpellChecker.PENDING;
    },


    checkIgnore: function( word ) {
        this.init();
        if( !defined( word ) )
            return;

        if( word.match( /^[+-]?(\d+|((\d*\.\d+)|(\d+\.\d*))+)$/ ) ) // See Case 36394.
            return this.ignore( word );
    },


    suggest: function( word ) {
        this.init();
        if( !defined( word ) )
            return [];
        
        if( this.words.hasOwnProperty( word ) && this.words[ word ] instanceof Array )
            return this.words[ word ];
        return [];
    },


    ignore: function( word ) {
        this.init();
        if( !defined( word ) )
            return;
        
        this.pendingWords.remove( word );
        return this.words[ word ] = SpellChecker.IGNORED;
    },


    /* xxx override this in your subclass */
    getWords: function() {
        if( !this.pendingWords.length || this.request )
            return;

        if( !defined( this.i ) )
            this.i = 0;

        /* xxx marks every other word as invalid (for testing) */
        for( var i = 0; i < this.pendingWords.length; i++ )
            this.words[ this.pendingWords[ i ] ] = this.i++ % 2;

        this.pendingWords = [];
    }

});


extend( SpellChecker, {
    PENDING: -2,
    IGNORED: -1,
    VALID: 0,
    INVALID: 1
} );
