<script lang="ts">
  import SiteListButton from "./SiteListButton.svelte";

  let {
    magicToken = "test-magic-token",
    limit = 50,
    open = $bindable(false),
    anchorRef = $bindable(),
    initialStarredSites = [],
  }: {
    magicToken?: string;
    limit?: number;
    open?: boolean;
    anchorRef?: HTMLElement;
    initialStarredSites?: number[];
  } = $props();
</script>

<button bind:this={anchorRef}>Sites</button>
<SiteListButton
  {magicToken}
  {limit}
  bind:open
  {anchorRef}
  {initialStarredSites}
/>
