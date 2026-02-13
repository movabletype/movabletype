<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  let {
    config: _config,
    field = $bindable(),
    gather = $bindable(),
    id,
    options = $bindable(),
    optionsHtmlParams: _optionsHtmlParams,
  }: ContentType.ContentFieldProps = $props();
</script>

<ContentFieldOptionGroup type="list" bind:field {id} bind:options />
