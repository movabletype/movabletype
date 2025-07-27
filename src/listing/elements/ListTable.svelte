<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import ListTableBody from "./ListTableBody.svelte";
  import ListTableHeader from "./ListTableHeader.svelte";

  export let hasListActions: boolean;
  export let hasMobilePulldownActions: boolean;
  export let store: Listing.ListStore;
  export let zeroStateLabel: string;
</script>

<thead data-is="list-table-header">
  <ListTableHeader {hasListActions} {hasMobilePulldownActions} {store} />
</thead>
{#if store.isLoading}
  <tbody>
    <tr>
      <td colspan={store.columns.length + 1}>
        {window.trans("Loading...")}
      </td>
    </tr>
  </tbody>
{:else if store.objects}
  <tbody data-is="list-table-body">
    <ListTableBody
      {hasListActions}
      {hasMobilePulldownActions}
      {store}
      {zeroStateLabel}
    />
  </tbody>
{/if}
