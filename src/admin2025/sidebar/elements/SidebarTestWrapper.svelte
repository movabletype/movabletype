<script lang="ts">
  import Sidebar from "./Sidebar.svelte";

  let {
    buttonRef = $bindable(),
    collapsed = $bindable(false),
    isStored = false,
  }: {
    buttonRef?: HTMLButtonElement;
    collapsed?: boolean;
    isStored?: boolean;
  } = $props();
</script>

<button bind:this={buttonRef}>Toggle Sidebar</button>
<Sidebar bind:buttonRef bind:collapsed {isStored} />
