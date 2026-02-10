<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import type * as Listing from "../../@types/listing";
  import ListActions from "./ListActions.svelte";

  let {
    context,
    buttonActions,
    hasPulldownActions,
    listActions,
    listActionClient,
    moreListActions,
    plural,
    singular,
  }: {
    context: ListStoreContext;
    buttonActions: Listing.ButtonActions;
    hasPulldownActions: boolean;
    listActions: Listing.ListActions;
    listActionClient: Listing.ListActionClient;
    moreListActions: Listing.MoreListActions;
    plural: string;
    singular: string;
  } = $props();

  setContext("listStore", context);
</script>

<ListActions
  {buttonActions}
  {hasPulldownActions}
  {listActions}
  {listActionClient}
  {moreListActions}
  {plural}
  {singular}
/>
