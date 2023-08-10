<script>
import { ListingStore } from "../ListingStore.ts";
</script>

<div>
  { $ListingStore.count == 0 ? 0 : ($ListingStore.limit * ($ListingStore.page-1) + 1) }
  -
  { ($ListingStore.limit * $ListingStore.page) > $ListingStore.count ? $ListingStore.count : ($ListingStore.limit * $ListingStore.page) }
  /
  { $ListingStore.count }
</div>
