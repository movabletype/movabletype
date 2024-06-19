<script lang="ts">
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  // svelte-ignore unused-export-let
  export let config: MT.ContentType.ConfigSettings;
  export let field: MT.ContentType.Field;
  export let id: string;
  export let options: MT.ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  options.initial_value ??= "";
</script>

<ContentFieldOptionGroup type="embedded-text" bind:field {id} bind:options>
  <ContentFieldOption
    id="embedded_text-initial_value"
    label={window.trans("Initial Value")}
  >
    <!-- "embeddedded" is typo, as same in Riot.js  -->
    <textarea
      {...{ ref: "initial_value" }}
      name="initial_value"
      id="embeddedded_text-initial_value"
      class="form-control"
      bind:value={options.initial_value}
    ></textarea>
  </ContentFieldOption>
</ContentFieldOptionGroup>
