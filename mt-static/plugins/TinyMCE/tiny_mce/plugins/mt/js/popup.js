(function() {
    function import_from_parent(name) {
        window[name] = window.parent[name];
    }
    import_from_parent('trans');
})();
