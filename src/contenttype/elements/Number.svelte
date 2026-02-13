<script lang="ts">
  import type * as ContentType from "../../@types/contenttype";

  import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
  import ContentFieldOption from "./ContentFieldOption.svelte";

  let {
    config,
    field = $bindable(),
    gather = $bindable(),
    id,
    options = $bindable(),
    optionsHtmlParams: _optionsHtmlParams,
  }: ContentType.ContentFieldProps = $props();

  let displayOptions = $derived({
    ...options,
    min_value: options.min_value ?? config.NumberFieldMinValue,
    max_value: options.max_value ?? config.NumberFieldMaxValue,
    decimal_places: options.decimal_places ?? 0,
    initial_value: options.initial_value ?? "",
  });

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
      value={displayOptions.min_value}
      min={config.NumberFieldMinValue}
      max={config.NumberFieldMaxValue}
      onchange={(e) => (options.min_value = e.currentTarget.value)}
    />
  </ContentFieldOption>

  <ContentFieldOption id="number-max_value" label={window.trans("Max Value")}>
    <input
      {...{ ref: "max_value" }}
      type="number"
      name="max_value"
      id="number-max_value"
      class="form-control html5-form w-25"
      value={displayOptions.max_value}
      min={config.NumberFieldMinValue}
      max={config.NumberFieldMaxValue}
      onchange={(e) => (options.max_value = e.currentTarget.value)}
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
      value={displayOptions.decimal_places}
      onchange={(e) => {
        options.decimal_places = e.currentTarget.value;
      }}
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
      value={displayOptions.initial_value}
      min={displayOptions.min_value}
      max={displayOptions.max_value}
      onchange={(e) => {
        options.initial_value = e.currentTarget.value;
      }}
    />
  </ContentFieldOption>
</ContentFieldOptionGroup>
