<script lang="ts">
  import ListTableBody from "./ListTableBody.svelte";
  import ListTableHeader from "./ListTableHeader.svelte";

  export let hasListActions: boolean;
  export let hasMobilePulldownActions: boolean;
  export let store: ListStore;
  export let zeroStateLabel: string;
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
