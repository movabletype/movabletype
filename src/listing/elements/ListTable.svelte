<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import ListTableBody from "./ListTableBody.svelte";
  import ListTableHeader from "./ListTableHeader.svelte";

  type Props = {
    hasListActions: boolean;
    hasMobilePulldownActions: boolean;
    store: Listing.ListStore;
    zeroStateLabel: string;
  };
  let {
    hasListActions,
    hasMobilePulldownActions,
    store,
    zeroStateLabel,
  }: Props = $props();

  let isLoading = $derived(store.isLoading);
  let hasObjects = $derived(!!store.objects && store.objects.length > 0);
  let columnsLength = $derived(store.columns.length);
</script>

<thead data-is="list-table-header">
  <ListTableHeader {hasListActions} {hasMobilePulldownActions} {store} />
</thead>
{#if isLoading}
  <tbody>
    <tr>
      <td colspan={columnsLength + 1}>
        {window.trans("Loading...")}
      </td>
    </tr>
  </tbody>
{:else if hasObjects}
  <tbody data-is="list-table-body">
    <ListTableBody
      {hasListActions}
      {hasMobilePulldownActions}
      {store}
      {zeroStateLabel}
    />
  </tbody>
{/if}
