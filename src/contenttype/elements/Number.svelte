<script lang="ts">
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import { configStore } from "../Store";
  import { update } from "../Utils";

  export let fieldId: string;
  export let id: string;
  export let isNew: boolean;
  export let label: string;
  export let options: MT.ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: MT.ContentType.OptionsHtmlParams;

  let maxValue = options.max_value || $configStore.NumberFieldMaxValue;
  let minValue = options.min_value || $configStore.NumberFieldMinValue;

  // jQuery(document).ready(function () {...}) is depcated
  jQuery(function () {
    const minValueOrMaxValueSelector =
      "input[id^=number-min_value-field-options-], input[id^=number-max_value-field-options-]";
    jQuery(document).on("keyup", minValueOrMaxValueSelector, function () {
      const matched = this.id.match(/[^-]+$/);
      if (!matched) return;

      const fieldId = matched[0];
      const initialValueId = "#number-initial_value-field-options-" + fieldId;
      const jqInitialValue = jQuery(initialValueId);
      if (!jqInitialValue.data("mtValidator")) return;

      /* @ts-expect-error : mtValid is undefined */
      jqInitialValue.mtValid({ focus: false });
    });
  });

  const type = "number";
</script>

<ContentFieldOptionGroup {type} {id} {isNew} {fieldId} bind:label {options}>
  <ContentFieldOption id="number-min_value" label={window.trans("Min Value")}>
    <input
      {...{ ref: "min_value" }}
      type="number"
      name="min_value"
      id="number-min_value"
      class="form-control html5-form w-25"
      bind:value={minValue}
      min={$configStore.NumberFieldMinValue || 0}
      max={$configStore.NumberFieldMaxValue || 0}
      on:keyup={update}
    />
  </ContentFieldOption>

  <ContentFieldOption id="number-max_value" label={window.trans("Max Value")}>
    <input
      {...{ ref: "max_value" }}
      type="number"
      name="max_value"
      id="number-max_value"
      class="form-control html5-form w-25"
      bind:value={maxValue}
      min={$configStore.NumberFieldMinValue || 0}
      max={$configStore.NumberFieldMaxValue || 0}
      on:keyup={update}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="number-decimal_places"
    label={window.trans("Number of decimal places")}
  >
    <input
      {...{ ref: "decimal_places" }}
      type="number"
      name="decimal_places"
      id="number-decimal_places"
      class="form-control html5-form w-25"
      min="0"
      max={$configStore.NumberFieldDecimalPlaces}
      value={options.decimal_places || 0}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="number-initial_value"
    label={window.trans("Initial Value")}
  >
    <input
      {...{ ref: "initial_value" }}
      type="number"
      name="initial_value"
      id="number-initial_value"
      class="form-control html5-form w-25"
      value={options.initial_value ?? ""}
      min={minValue}
      max={maxValue}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
