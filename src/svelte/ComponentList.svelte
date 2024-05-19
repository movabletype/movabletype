<script lang="ts">
  import type { UIComponent } from "../ui";
  import HtmlElement from "./HtmlElement.svelte";
  export let namespace;
  export let detail;
  let components: UIComponent[] = [];
  let readiedCount = 0;
  const componentsPromise = window.MT.UI.Component.getAll(namespace);
  componentsPromise.then((_components) => {
    components = _components;
  });

  let container: HTMLDivElement;
  const onReady = (): void => {
    if (++readiedCount !== components.length) {
      return;
    }

    [...container.childNodes]
      .filter((e): e is HTMLElement => e instanceof HTMLElement)
      .forEach((e: HTMLElement, i) => {
        e.style.order ||= String((i + 1) * 100);
      });
  };
</script>

<div class="d-flex flex-column" bind:this={container}>
  <slot name="prepend" />

  {#each components as c}
    <HtmlElement
      element={c}
      event={new CustomEvent("message", {
        detail,
      })}
      on:ready={onReady}
      on:message
    />
  {/each}

  <slot name="append" />
</div>
