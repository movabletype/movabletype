<script lang="ts">
  import SearchButton from "./SearchButton.svelte";
  import type { SearchTab } from "../search-button";

  let {
    blogId = "1",
    magicToken = "test-magic-token",
    open = $bindable(false),
    anchorRef = $bindable(),
    searchTabs = [
      { key: "entry", label: "Entry" },
      { key: "page", label: "Page" },
      { key: "content_data", label: "Content Data" },
    ] as SearchTab[],
    objectType = $bindable("entry"),
  }: {
    blogId?: string;
    magicToken?: string;
    open?: boolean;
    anchorRef?: HTMLElement;
    searchTabs?: SearchTab[];
    objectType?: string;
  } = $props();
</script>

<button bind:this={anchorRef}>Search</button>
<SearchButton
  {blogId}
  {magicToken}
  bind:open
  {anchorRef}
  {searchTabs}
  bind:objectType
/>
