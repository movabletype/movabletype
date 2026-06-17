<script lang="ts">
  import { onMount } from "svelte";

  type Props = {
    element: HTMLElement | string;
    event: Event;
    onready?: () => void;
    onmessage?: (e: MessageEvent) => void;
  };
  let { element, event, onready, onmessage }: Props = $props();

  // svelte-ignore state_referenced_locally
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

  let container;
  onMount(() => {
    container.appendChild(element);
    setTimeout(() => {
      element.dispatchEvent(event);
      onready?.();
    }, 0);
  });
</script>

<div bind:this={container} {onmessage}></div>
