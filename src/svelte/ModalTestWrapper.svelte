<script lang="ts">
  import Modal from "./Modal.svelte";

  let {
    open = $bindable(true),
    className = "",
    describedby = "",
    labelledby = "",
    content = "Modal Content",
    onopen,
    onclose,
  }: {
    open?: boolean;
    className?: string;
    describedby?: string;
    labelledby?: string;
    content?: string;
    onopen?: () => void;
    onclose?: () => void;
  } = $props();
</script>

<Modal
  bind:open
  {className}
  {describedby}
  {labelledby}
  on:open={onopen}
  on:close={onclose}
>
  <div class="test-content">{content}</div>
</Modal>
