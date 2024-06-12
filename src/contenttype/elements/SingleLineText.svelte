<script lang="ts">
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";

  export let fieldId: string;
  export let id: string;
  export let isNew: boolean;
  export let label: string;
  export let options: MT.ContentType.Options = {};
</script>

<ContentFieldOptionGroup
  type="single_line_text"
  {fieldId}
  {id}
  {isNew}
  bind:label
  {options}
>
  <ContentFieldOption
    id="single_line_text-min_length"
    label={window.trans("Min Length")}
  >
    <input
      {...{ ref: "min_length" }}
      type="number"
      name="min_length"
      id="single_line_text-min_length"
      class="form-control w-25"
      min="0"
      value={options.min_length || 0}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="single_line_text-max_length"
    label={window.trans("Max Length")}
  >
    <input
      {...{ ref: "max_length" }}
      type="number"
      name="max_length"
      id="single_line_text-max_length"
      class="form-control w-25"
      min="1"
      value={options.max_length || 255}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="single_line_text-initial_value"
    label={window.trans("Initial Value")}
  >
    <input
      {...{ ref: "initial_value" }}
      type="text"
      name="initial_value"
      id="single_line_text-initial_value"
      class="form-control"
      value={options.initial_value}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
