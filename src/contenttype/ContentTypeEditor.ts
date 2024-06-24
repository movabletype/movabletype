import ContentFieldTypes from "./ContentFieldTypes";

import ContentFields from "./elements/ContentFields.svelte";

export default class ContentTypeEditor {
  static accessor config: MT.ContentType.ConfigSettings = {};
  static accessor optionsHtmlParams: MT.ContentType.OptionsHtmlParams = {};
  static accessor opts: MT.ContentType.ContentFieldsOpts;

  static registerCustomType(
    type: string,
    mountFunction: MT.ContentType.CustomContentFieldMountFunction,
  ): void {
    ContentFieldTypes.registerCustomType(type, mountFunction);
  }

  static mount(
    targetSelector: string,
    opts: MT.ContentType.ContentFieldsOpts,
  ): void {
    const target = this.getContentFieldsTarget(targetSelector);
    this.opts = opts;
    new ContentFields({
      props: {
        config: this.config,
        optionsHtmlParams: this.optionsHtmlParams,
        opts: this.opts,
        root: target,
      },
      target: target,
    });
  }

  private static getContentFieldsTarget(selector: string): Element {
    const target = document.querySelector(`[data-is="${selector}"]`);
    if (!target) {
      throw new Error("Target element is not found: " + selector);
    }
    return target;
  }
}
