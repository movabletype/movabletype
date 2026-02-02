<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  let {
    config,
    field = $bindable(),
    gather = $bindable(null),
    id,
    options = $bindable(),
    optionsHtmlParams,
  } : ContentType.ContentFieldProps = $props();
</script>

<ContentFieldOptionGroup type="list" bind:field {id} bind:options />
