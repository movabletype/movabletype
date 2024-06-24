import observable from "@riotjs/observable";

import ContentFields from "./contenttype/elements/ContentFields.svelte";

import { ContentFieldTypes } from "./contenttype/ContentFieldTypes";

class ContentTypeEditor {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  static registerType(type: string, mountFunction: any): void {
    ContentFieldTypes.registerCustomType(type, mountFunction);
  }

  static mount(props: {
    config: MT.ContentType.ConfigSettings;
    optionsHtmlParams: MT.ContentType.OptionsHtmlParams;
    opts: MT.ContentType.ContentFieldsOpts;
  }): void {
    const target = this.getContentFieldsTarget();
    new ContentFields({
      props: {
        ...props,
        root: target,
      },
      target: target,
    });
  }

  private static getContentFieldsTarget(): Element {
    const target = document.querySelector('[data-is="content-fields"]');
    if (!target) {
      throw new Error("Target element is not found");
    }
    return target;
  }
}

export { ContentFieldTypes, ContentTypeEditor, observable };
