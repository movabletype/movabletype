<script lang="ts">
  import { onMount, createEventDispatcher } from "svelte";

  export let element;
  export let event;

  if (typeof element === "string") {
    const constructor = customElements.get(element);
    if (constructor) {
      element = new constructor();
    } else {
      const html = element;
      element = document.createElement("div");
      element.innerHTML = html;
    }
  }

  let dispatch = createEventDispatcher();

  let container;
  onMount(() => {
    container.appendChild(element);
    setTimeout(() => {
      element.dispatchEvent(event);
      dispatch("ready");
    }, 0);
  });
</script>

<div bind:this={container} on:message />
