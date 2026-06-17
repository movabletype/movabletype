<script lang="ts">
  import type { Snippet } from "svelte";
  import { getModalContext } from "./context";

  let ctx = getModalContext();

  type Props = {
    close?: () => void;
    title?: Snippet;
    body?: Snippet;
    footer?: Snippet;
  };
  let { close = () => ctx.closeModal(), title, body, footer }: Props = $props();
</script>

<div>
  {#if title}
    <div class="modal-header">
      <h4 class="modal-title">{@render title()}</h4>
      <button
        type="button"
        class="close"
        data-dismiss="modal"
        aria-label="Close"
        onclick={close}
      >
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
  {/if}
  <div class="modal-body">
    {@render body?.()}
  </div>
  <div class="modal-footer">
    {@render footer?.()}
  </div>
</div>
