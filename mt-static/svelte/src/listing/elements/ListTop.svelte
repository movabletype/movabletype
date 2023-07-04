<script>
import DisplayOptions from "./DisplayOptions.svelte";
import { ListingOpts, ListingStore } from '../ListingStore.ts';

export let opts;
export let store;

ListingOpts.set(opts);
ListingStore.set(store);
</script>

<div>
  <DisplayOptions />
</div>
