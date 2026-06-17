<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import type * as Listing from "../../@types/listing";
  import ListFilterHeader from "./ListFilterHeader.svelte";

  let {
    context,
    currentFilter,
    isAllpassFilter,
    listActionClient,
    listFilterTopCreateNewFilter,
    listFilterTopUpdate,
  }: {
    context: ListStoreContext;
    currentFilter: Listing.Filter;
    isAllpassFilter: boolean;
    listActionClient: Listing.ListActionClient;
    listFilterTopCreateNewFilter: (filterLabel?: string) => void;
    listFilterTopUpdate: () => void;
  } = $props();

  // svelte-ignore state_referenced_locally
  setContext("listStore", context);
</script>

<ListFilterHeader
  {currentFilter}
  {isAllpassFilter}
  {listActionClient}
  {listFilterTopCreateNewFilter}
  {listFilterTopUpdate}
/>
