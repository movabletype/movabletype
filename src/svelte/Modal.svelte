<script lang="ts">
  import type { Snippet } from "svelte";
  import { fade, fly } from "svelte/transition";
  import { quintOut } from "svelte/easing";
  import { setModalContext } from "./context";

  type Props = {
    open: boolean;
    className: string;
    describedby: string;
    labelledby: string;
    onOpen?: () => void;
    onClose?: () => void;
    children?: Snippet;
  };
  let {
    open = $bindable(true),
    className = "",
    describedby = "",
    labelledby = "",
    onOpen,
    onClose,
    children,
  }: Props = $props();

  const modalOpen = (): void => {
    document.body.classList.add("modal-open");
  };
  const modalClose = (): void => {
    document.body.classList.remove("modal-open");
  };

  $effect(() => {
    if (open) {
      modalOpen();
    } else {
      modalClose();
    }
  });

  setModalContext({
    closeModal() {
      open = false;
    },
  });
</script>

{#if open}
  <div
    class="modal show"
    tabindex="-1"
    role="dialog"
    aria-labelledby={labelledby}
    aria-describedby={describedby}
    aria-modal="true"
    onintroend={() => {
      onOpen?.();
    }}
    onoutroend={() => {
      setTimeout(() => {
        onClose?.();
      }, 100);
    }}
    transition:fade
  >
    <div
      class="modal-dialog {className}"
      role="document"
      in:fly={{ y: -50, duration: 300 }}
      out:fly={{ y: -50, duration: 300, easing: quintOut }}
    >
      <div class="modal-content">
        {@render children?.()}
      </div>
    </div>
  </div>
  <div class="modal-backdrop show" transition:fade={{ duration: 150 }}></div>
{/if}

<style>
  .modal {
    display: block;
  }
</style>
