<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  let {
    field = $bindable(),
    gather = $bindable(),
    id,
    options = $bindable(),
  }: ContentType.ContentFieldProps = $props();
</script>

<ContentFieldOptionGroup type="list" bind:field {id} bind:options />
