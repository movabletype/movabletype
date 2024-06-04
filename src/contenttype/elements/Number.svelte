<script>
  import ContentFieldOptionGroup from './ContentFieldOptionGroup.svelte';
  import ContentFieldOption from './ContentFieldOption.svelte';
  import { update } from "../Utils.ts";
  import { mtConfig } from "../Store.ts";

  export let fieldId;
  export let options;
  export let isNew;
  export let label;

  const refs = {
      "min_value": {
          "value": ""
      },
      "max_value": {
          "value": ""
      }
  };
  jQuery(document).ready(function () {
    const minValueOrMaxValueSelector = 'input[id^=number-min_value-field-options-], input[id^=number-max_value-field-options-]';
    jQuery(document).on('keyup', minValueOrMaxValueSelector, function () {
      const matched = this.id.match(/[^\-]+$/);
      if (!matched) return;

      const fieldId = matched[0];
      const initialValueId = '#number-initial_value-field-options-' + fieldId;
      const jqInitialValue = jQuery(initialValueId);
      if (!jqInitialValue.data('mtValidator')) return;

      jqInitialValue.mtValid({ focus: false });
    });
  });

  const type = "number";
</script>

<ContentFieldOptionGroup
  type={ type }
  isNew={ isNew }
  fieldId={ fieldId }
  bind:labelValue={ label }
  options={ options }
>
  <svelte:fragment slot="body">

  <ContentFieldOption
    id="{type}-min_value"
    label={ trans("Min Value") }
    showLabel={ true }
  >
    <svelte:fragment slot="inside">
        <input ref="min_value" type="number" name="min_value" id="{type}-min_value" class="form-control html5-form w-25" value={ options.min_value || $mtConfig.NumberFieldMinValue } min="{ $mtConfig.NumberFieldMinValue || 0 }" max="{ $mtConfig.NumberFieldMaxValue || 0 }" on:keyup={ update }>
    </svelte:fragment>
  </ContentFieldOption>

  <ContentFieldOption
    id="{type}-max_value"
    label={ trans("Max Value") }
    showLabel={ true }
  >
    <svelte:fragment slot="inside">
        <input ref="max_value" type="number" name="max_value" id="{type}-max_value" class="form-control html5-form w-25" value={ options.max_value || $mtConfig.NumberFieldMaxValue } min="{ $mtConfig.NumberFieldMinValue || 0 }" max="{ $mtConfig.NumberFieldMaxValue || 0 }" on:keyup={ update }>
    </svelte:fragment>
  </ContentFieldOption>

  <ContentFieldOption
    id="{type}-decimal_places"
    label={ trans("Number of decimal places") }
    showLabel={ true }
  >
    <svelte:fragment slot="inside">
        <input ref="decimal_places" type="number" name="decimal_places" id="{type}-decimal_places" class="form-control html5-form w-25" min="0" max="{ $mtConfig.NumberFieldDecimalPlaces }" value={ options.decimal_places || 0 } >
    </svelte:fragment>
  </ContentFieldOption>

  <ContentFieldOption
    id="{type}-initial_value"
    label={ trans("Initial Value") }
    showLabel={ true }
  >
    <svelte:fragment slot="inside">
      <input ref="initial_value" type="number" name="initial_value" id="{type}-initial_value" class="form-control html5-form w-25" value={ options.initial_value } min={ refs.min_value.value } max={ refs.max_value.value } />
    </svelte:fragment>
  </ContentFieldOption>

  </svelte:fragment>
</ContentFieldOptionGroup>
