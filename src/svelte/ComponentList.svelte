<script lang="ts">
  import type { Snippet } from "svelte";
  import type { UIComponent } from "../ui";
  import HtmlElement from "./HtmlElement.svelte";

  type Props = {
    namespace: string;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    detail: any;
    prepend?: Snippet;
    append?: Snippet;
    onmessage?: (e: MessageEvent) => void;
  };
  let { namespace, detail, prepend, append, onmessage }: Props = $props();

  let components: UIComponent[] = $state([]);
  let readiedCount = 0;

  $effect(() => {
    window.MT.UI.Component.getAll(namespace).then((_components) => {
      components = _components;
    });
  });

  let container: HTMLDivElement;
  const onReady = (): void => {
    if (++readiedCount !== components.length) {
      return;
    }

    if (!container) {
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
  {@render prepend?.()}

  {#each components as c}
    <HtmlElement
      element={c}
      event={new CustomEvent("message", {
        detail,
      })}
      onready={onReady}
      {onmessage}
    />
  {/each}

  {@render append?.()}
</div>
