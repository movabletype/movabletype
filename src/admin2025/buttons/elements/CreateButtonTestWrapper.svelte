<script lang="ts">
  import CreateButton from "./CreateButton.svelte";

  let {
    blog_id = "1",
    magicToken = "test-magic-token",
    open = $bindable(false),
    anchorRef = $bindable(),
    containerRef = $bindable(),
  }: {
    blog_id?: string;
    magicToken?: string;
    open?: boolean;
    anchorRef?: HTMLElement;
    containerRef?: HTMLElement;
  } = $props();
</script>

<div bind:this={containerRef}>
  <button bind:this={anchorRef}>Create</button>
  <CreateButton {blog_id} {magicToken} bind:open {anchorRef} {containerRef} />
</div>
