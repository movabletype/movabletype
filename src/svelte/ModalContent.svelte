<script lang="ts">
  import { getModalContext } from "./context";

  let ctx = getModalContext();
  export let close = (): void => {
    ctx.closeModal();
  };
</script>

<div>
  {#if $$slots.title}
    <div class="modal-header">
      <h4 class="modal-title"><slot name="title" /></h4>
      <button
        type="button"
        class="close"
        data-dismiss="modal"
        aria-label="Close"
        on:click={close}
      >
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
  {/if}
  <div class="modal-body">
    <slot name="body" />
  </div>
  <div class="modal-footer">
    <slot name="footer" />
  </div>
</div>
