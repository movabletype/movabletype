/* 
$Id: Test.js 185 2007-05-04 20:45:03Z ydnar $

Copyright Six Apart, Ltd. All rights reserved.
Redistribution and use in source and binary forms is
subject to the Six Apart JavaScript license:

http://code.sixapart.com/svn/js/trunk/LICENSE.txt
*/


App.singletonConstructor =
Editor.Test = new Class( App, {    
    initComponents: function() {
        arguments.callee.applySuper( this, arguments );
        this.editor = new Editor( "editor" );
        this.addComponent( this.editor );
    },
    
    
    destroyObject: function() {
        this.editor = null;
        this.editorToolbar = null;
        arguments.callee.applySuper( this, arguments );
    }
} );
