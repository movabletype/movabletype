<script>
  import ListTableHeader from "./ListTableHeader.svelte";
  import ListTableBody from "./ListTableBody.svelte";
  import { ListingStore, ListingOpts } from "../ListingStore.ts";
</script>

<thead>
  <ListTableHeader />
</thead>
{#if $ListingStore.isLoading}
  <tbody>
    <tr>
      <td colspan={$ListingStore.columns.length + 1}>
        {trans("Loading...")}
      </td>
    </tr>
  </tbody>
{:else if !$ListingStore.isLoading && !$ListingStore.objects}
  <tbody>
    <ListTableBody />
  </tbody>
{/if}
