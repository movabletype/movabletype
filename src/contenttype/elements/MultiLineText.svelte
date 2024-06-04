<script>
  import ContentFieldOptionGroup from './ContentFieldOptionGroup.svelte';
  import ContentFieldOption from './ContentFieldOption.svelte';

  export let fieldId;
  export let options;
  export let label;
  export let isNew;

  const type = "multi-line-text";
  const _type = type.replace(/-/g, "_");

  // TODO
  options.input_formats = {};
  <mt:loop name="text_filters">
  options.input_formats['<mt:var name="filter_key" escape="js">'] = '';
  </mt:loop>
  if (options.input_format) {
    options.input_formats[this.options.input_format] = "selected";
  }

  if (isNew) {
    options.full_rich_text = 1;
  }

  if (options.full_rich_text === "0") {
    options.full_rich_text = 0;
  }

  function changeStateFullRichText(e) {
    options.full_rich_text = e.target.checked;
  }
</script> 
<ContentFieldOptionGroup
  type={ type }
  fieldId={ fieldId }
  options={ options }
  bind:labelValue={ label }
  isNew={ isNew }
>
  <svelte:fragment slot="body">
    <ContentFieldOption
        id="{_type}-initial_value"
        label={ trans("Initial Value") }
        showLable={ true }
    >
      <svelte:fragment slot="inside">
          <textarea ref="initial_value" name="initial_value" id="{_type}-initial_value" class="form-control" >{ options.initial_value }</textarea>
      </svelte:fragment>
    </ContentFieldOption>

    <ContentFieldOption
        id="{_type}-input_format"
        label={ trans("Input format") }
        showLable={ true }
    >
      <svelte:fragment slot="inside">
        <select ref="input_format" name="input_format" id="{_type}-input_format" class="custom-select form-control form-select">
<!-- TODO -->
        <mt:loop name="text_filters">
          <option value="<mt:var name="filter_key" escape="html">" selected={ options.input_formats['<mt:var name="filter_key" escape="html">'] }><mt:var name="filter_label" escape="html"></option>
        </mt:loop>
        </select>
      </svelte:fragment>
    </ContentFieldOption>

    <ContentFieldOption
        id="{_type}-full_rich_text"
        label={ trans("Use all rich text decoration buttons") }
        showLabel={ true }
    >
      <svelte:fragment slot="inside">
        <input ref="full_rich_text" type="checkbox" class="mt-switch form-control" id="{_type}-full_rich_text" name="full_rich_text" checked={ options.full_rich_text } on:click={ changeStateFullRichText }><label for="{_type}-full_rich_text" class="form-label"><__trans phrase="Use all rich text decoration buttons"></label>
      </svelte:fragment>
    </ContentFieldOption>

  </svelte:fragment>
</ContentFieldOptionGroup>
