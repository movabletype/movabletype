<script lang="ts">
  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";
  import { update } from "../Utils";
  import { mtConfig } from "../Store";

  export let fieldId: string;
  export let id: string;
  export let options: any;
  export let isNew: boolean;
  export let label: string;

  const refs = {
    min_value: {
      value: "",
    },
    max_value: {
      value: "",
    },
  };
  jQuery(document).ready(function () {
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
  <ContentFieldOption id="{type}-min_value" label={window.trans("Min Value")}>
    <input
      {...{ ref: "min_value" }}
      type="number"
      name="min_value"
      id="{type}-min_value"
      class="form-control html5-form w-25"
      value={options?.min_value || $mtConfig.NumberFieldMinValue}
      min={$mtConfig.NumberFieldMinValue || 0}
      max={$mtConfig.NumberFieldMaxValue || 0}
      on:keyup={update}
    />
  </ContentFieldOption>

  <ContentFieldOption id="{type}-max_value" label={window.trans("Max Value")}>
    <input
      {...{ ref: "max_value" }}
      type="number"
      name="max_value"
      id="{type}-max_value"
      class="form-control html5-form w-25"
      value={options?.max_value || $mtConfig.NumberFieldMaxValue}
      min={$mtConfig.NumberFieldMinValue || 0}
      max={$mtConfig.NumberFieldMaxValue || 0}
      on:keyup={update}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="{type}-decimal_places"
    label={window.trans("Number of decimal places")}
  >
    <input
      {...{ ref: "decimal_places" }}
      type="number"
      name="decimal_places"
      id="{type}-decimal_places"
      class="form-control html5-form w-25"
      min="0"
      max={$mtConfig.NumberFieldDecimalPlaces}
      value={options?.decimal_places || 0}
    />
  </ContentFieldOption>

  <ContentFieldOption
    id="{type}-initial_value"
    label={window.trans("Initial Value")}
  >
    <input
      {...{ ref: "initial_value" }}
      type="number"
      name="initial_value"
      id="{type}-initial_value"
      class="form-control html5-form w-25"
      value={options?.initial_value}
      min={refs.min_value.value}
      max={refs.max_value.value}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
