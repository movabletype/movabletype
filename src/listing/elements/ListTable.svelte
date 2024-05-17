<script>
  import ListTableBody from "./ListTableBody.svelte";
  import ListTableHeader from "./ListTableHeader.svelte";

  export let hasListActions;
  export let hasMobilePulldownActions;
  export let store;
  export let zeroStateLabel;
</script>

<thead>
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
{:else if !store.isLoading && store.objects}
  <tbody>
    <ListTableBody
      {hasListActions}
      {hasMobilePulldownActions}
      {store}
      {zeroStateLabel}
    />
  </tbody>
{/if}
