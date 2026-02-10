<script lang="ts">
  import { setContext } from "svelte";
  import type { ListStoreContext } from "../listStoreContext";
  import ListTableBody from "./ListTableBody.svelte";

  let {
    context,
    hasListActions,
    hasMobilePulldownActions,
    zeroStateLabel,
  }: {
    context: ListStoreContext;
    hasListActions: boolean;
    hasMobilePulldownActions: boolean;
    zeroStateLabel: string;
  } = $props();

  setContext("listStore", context);
</script>

<table>
  <tbody>
    <ListTableBody
      {hasListActions}
      {hasMobilePulldownActions}
      {zeroStateLabel}
    />
  </tbody>
</table>
