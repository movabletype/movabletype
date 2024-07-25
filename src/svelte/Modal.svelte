<script lang="ts">
  import { createEventDispatcher } from "svelte";
  import { fade, fly } from "svelte/transition";
  import { quintOut } from "svelte/easing";
  import { setModalContext } from "./context";

  const dispatch = createEventDispatcher();

  export let open = true;
  export let className = "";
  export let describedby = "";
  export let labelledby = "";

  const modalOpen = (): void => {
    document.body.classList.add("modal-open");
  };
  const modalClose = (): void => {
    document.body.classList.remove("modal-open");
  };

  $: {
    if (open) {
      modalOpen();
    } else {
      modalClose();
    }
  }

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
    on:introend={() => {
      dispatch("open");
    }}
    on:outroend={() => {
      setTimeout(() => {
        dispatch("close");
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
        <slot />
      </div>
    </div>
  </div>
  <div class="modal-backdrop show" transition:fade={{ duration: 150 }} />
{/if}

<style>
  .modal {
    display: block;
  }
</style>
