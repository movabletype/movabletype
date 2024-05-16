<script>
  export let opts;

  function setValues() {
    for (let key in opts.item.args) {
      if (
        typeof opts.item.args[key] != "string" &&
        typeof opts.item.args[key] != "number"
      ) {
        continue;
      }
      const selector = "." + opts.item.type + "-" + key;
      // TODO: fix this.root
      const elements = this.root.querySelectorAll(selector);
      Array.prototype.slice.call(elements).forEach(function (element) {
        if (element.tagName == "INPUT" || element.tagName == "SELECT") {
          element.value = opts.item.args[key];
        } else {
          element.textContent = opts.item.args[key];
        }
      });
    }
  }

  // TODO
  $: {
    opts = opts;
    setValues();
  }
</script>

{@html opts.field}
