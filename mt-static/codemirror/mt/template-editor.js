jQuery(function () {
  var textarea = jQuery("#text");
  if (!textarea.length) return;
  if (textarea.attr("mt:editor") !== "codemirror") return;
  if (typeof CodeMirror === "undefined") return;

  var options = textarea.attr("mt:editor-options") || "";
  var editorParams = {
    lineNumbers: true,
    lineWrapping: false,
    tabMode: "default",
    indentUnit: 0,
    pollForIME: true,
    mode: "text/html",
    viewportMargin: Infinity,
  };
  if (options.match("lang:css")) {
    editorParams.mode = "text/css";
  } else if (options.match("lang:javascript")) {
    editorParams.mode = "text/javascript";
  }

  var editor = CodeMirror.fromTextArea(textarea.get(0), editorParams);

  function syncEditor() {
    var wrapper = editor.getWrapperElement();
    if (jQuery(wrapper).css("display") === "none") {
      editor.setValue(textarea.val());
    } else {
      textarea.val(editor.getValue());
    }
  }

  function setSyntaxHighlight(onOrOff) {
    syncEditor();
    var wrapper = editor.getWrapperElement();
    if (onOrOff === "off") {
      textarea.show();
      jQuery(wrapper).hide();
    } else {
      textarea.hide();
      jQuery(wrapper).show();
    }
    return false;
  }

  var checkbox = jQuery("#code-highlight-switch");
  if (checkbox.length && !checkbox.prop("checked")) {
    setSyntaxHighlight("off");
  }

  checkbox.on("change", function () {
    var syntax = this.checked ? "on" : "off";
    setSyntaxHighlight(syntax);
    if (window.saveTemplatePrefs) window.saveTemplatePrefs(syntax);
    return false;
  });

  jQuery(window).on("pre_autosave", function () {
    syncEditor();
  });

  var controlChars = /[\0-\x08\x0B\x0C\x0E-\x1F\x7F]/g;
  var form = textarea.get(0).form;
  if (form) {
    jQuery(form).on("submit", function () {
      syncEditor();
      var cleaned = editor.getValue().replace(controlChars, "");
      editor.setValue(cleaned);
      textarea.val(cleaned);
    });
  }
});
