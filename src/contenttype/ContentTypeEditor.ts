import ContentFields from "./elements/ContentFields.svelte";

export class ContentTypeEditor {
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
