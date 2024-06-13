<script lang="ts">
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  export let fieldId: string;
  export let id: string;
  export let isNew: boolean;
  export let label: string;
  export let options: MT.ContentType.Options;
</script>

<ContentFieldOptionGroup
  type="list"
  {fieldId}
  {id}
  {isNew}
  bind:label
  {options}
/>
