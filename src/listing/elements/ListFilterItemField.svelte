<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import { afterUpdate } from "svelte";

  export let field: string;
  export let parentDiv: HTMLDivElement | undefined;
  export let item: Listing.Item;

  afterUpdate(() => {
    setValues();
  });

  const setValues = (): void => {
    if (!parentDiv) {
      return;
    }

    for (let key in item.args) {
      if (
        typeof item.args[key] !== "string" &&
        typeof item.args[key] !== "number"
      ) {
        continue;
      }
      const selector = "." + item.type + "-" + key;
      const elements = parentDiv.querySelectorAll(selector);
      Array.prototype.slice.call(elements).forEach(function (element) {
        if (element.tagName === "INPUT" || element.tagName === "SELECT") {
          element.value = item.args[key];
        } else {
          element.textContent = item.args[key];
        }
      });
    }
  };
</script>

{@html field}
