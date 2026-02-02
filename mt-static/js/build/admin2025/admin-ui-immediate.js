
(function(l, r) { if (!l || l.getElementById('livereloadscript')) return; r = l.createElement('script'); r.async = 1; r.src = '//' + (self.location.host || 'localhost').split(':')[0] + ':35734/livereload.js?snipver=1'; r.id = 'livereloadscript'; l.getElementsByTagName('head')[0].appendChild(r) })(self.document);
(function () {
    'use strict';

    const sessionName = "collapsed";
    const getCollapsedState = () => {
      const value = sessionStorage.getItem(sessionName);
      return value === "true" ? true : value === "false" ? false : null;
    };
    const setGlobalCollapsedDomAttribute = (collapsed) => {
      if (collapsed) {
        document.documentElement.classList.add("mt-has-primary-navigation-collapsed");
      } else {
        document.documentElement.classList.remove("mt-has-primary-navigation-collapsed");
      }
    };

    var _a;
    setGlobalCollapsedDomAttribute((_a = getCollapsedState()) !== null && _a !== void 0 ? _a : false);

})();
//# sourceMappingURL=admin-ui-immediate.js.map
