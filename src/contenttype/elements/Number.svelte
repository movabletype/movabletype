<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";

  export let config: ContentType.ConfigSettings;
  export let field: ContentType.Field;
  // svelte-ignore unused-export-let
  export let gather = null;
  export let id: string;
  export let options: ContentType.Options;
  // svelte-ignore unused-export-let
  export let optionsHtmlParams: ContentType.OptionsHtmlParams;

  options.max_value ??= config.NumberFieldMaxValue;
  options.min_value ??= config.NumberFieldMinValue;
  options.decimal_places ??= 0;
  options.initial_value ??= "";

  // jQuery(document).ready(function () {...}) is deprecated
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
</script>

<ContentFieldOptionGroup type="number" bind:field {id} bind:options>
  <ContentFieldOption id="number-min_value" label={window.trans("Min Value")}>
    <input
      {...{ ref: "min_value" }}
      type="number"
      name="min_value"
      id="number-min_value"
      class="form-control html5-form w-25"
      bind:value={options.min_value}
      min={config.NumberFieldMinValue}
      max={config.NumberFieldMaxValue}
    />
  </ContentFieldOption>

  <ContentFieldOption id="number-max_value" label={window.trans("Max Value")}>
    <input
      {...{ ref: "max_value" }}
      type="number"
      name="max_value"
      id="number-max_value"
      class="form-control html5-form w-25"
      bind:value={options.max_value}
      min={config.NumberFieldMinValue}
      max={config.NumberFieldMaxValue}
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
      max={config.NumberFieldDecimalPlaces}
      bind:value={options.decimal_places}
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
      bind:value={options.initial_value}
      min={options.min_value}
      max={options.max_value}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
