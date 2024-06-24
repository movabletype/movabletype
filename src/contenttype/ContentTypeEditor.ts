import { ContentFieldTypes } from "./ContentFieldTypes";

import ContentFields from "./elements/ContentFields.svelte";

export class ContentTypeEditor {
  static accessor config: MT.ContentType.ConfigSettings = {};
  static accessor optionsHtmlParams: MT.ContentType.OptionsHtmlParams = {};

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  static registerCustomType(type: string, mountFunction: any): void {
    ContentFieldTypes.registerCustomType(type, mountFunction);
  }

  static mount(
    targetSelector: string,
    opts: MT.ContentType.ContentFieldsOpts,
  ): void {
    const target = this.getContentFieldsTarget(targetSelector);
    new ContentFields({
      props: {
        config: this.config,
        optionsHtmlParams: this.optionsHtmlParams,
        opts: opts,
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
