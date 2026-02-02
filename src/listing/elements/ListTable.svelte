<script lang="ts">
  import { getContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";

  import ListTableBody from "./ListTableBody.svelte";
  import ListTableHeader from "./ListTableHeader.svelte";

  type Props = {
    hasListActions: boolean;
    hasMobilePulldownActions: boolean;
    zeroStateLabel: string;
  };
  let { hasListActions, hasMobilePulldownActions, zeroStateLabel }: Props =
    $props();

  const { reactiveStore } = getContext<ListStoreContext>("listStore");
  let isLoading = $derived($reactiveStore.isLoading || false);
  let hasObjects = $derived(
    $reactiveStore.objects && $reactiveStore.objects.length > 0,
  );
  let columnsLength = $derived($reactiveStore.columns.length || 0);
</script>

<thead data-is="list-table-header">
  <ListTableHeader {hasListActions} {hasMobilePulldownActions} />
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
      {zeroStateLabel}
    />
  </tbody>
{/if}
