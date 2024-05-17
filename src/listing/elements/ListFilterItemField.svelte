<script>
  export let field;
  export let item;

  let root;

  function setValues() {
    for (let key in item.args) {
      if (
        typeof item.args[key] != "string" &&
        typeof item.args[key] != "number"
      ) {
        continue;
      }
      const selector = "." + item.type + "-" + key;
      // TODO: fix this.root
      const elements = this.root.querySelectorAll(selector);
      Array.prototype.slice.call(elements).forEach(function (element) {
        if (element.tagName == "INPUT" || element.tagName == "SELECT") {
          element.value = item.args[key];
        } else {
          element.textContent = item.args[key];
        }
      });
    }
  }

  setValues();
</script>

{@html field}
