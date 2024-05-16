<script>
  import ListTableBody from "./ListTableBody.svelte";
  import ListTableHeader from "./ListTableHeader.svelte";

  export let listStore;
  export let opts;
</script>

<thead>
  <ListTableHeader {listStore} {opts} />
</thead>
{#if listStore.isLoading}
  <tbody>
    <tr>
      <td colspan={listStore.columns.length + 1}>
        {window.trans("Loading...")}
      </td>
    </tr>
  </tbody>
{:else if !listStore.isLoading && listStore.objects}
  <tbody>
    <ListTableBody {listStore} {opts} />
  </tbody>
{/if}
