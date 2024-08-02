import type * as ContentType from "../@types/contenttype";

import { writable } from "svelte/store";

import ContentFieldTypes from "./ContentFieldTypes";

import ContentFields from "./elements/ContentFields.svelte";

export default class ContentTypeEditor {
  static accessor config: ContentType.ConfigSettings = {};
  static accessor fieldsStore: ContentType.FieldsStore;
  static accessor optionsHtmlParams: ContentType.OptionsHtmlParams = {};
  static accessor opts: ContentType.ContentFieldsOpts;
  static readonly types = ContentFieldTypes;

  static registerCustomType(
    type: string,
    mountFunction: ContentType.CustomContentFieldMountFunction,
  ): void {
    this.types.registerCustomType(type, mountFunction);
  }

  static mount(
    targetSelector: string,
    opts: ContentType.ContentFieldsOpts,
  ): void {
    const target = this.getContentFieldsTarget(targetSelector);

    this.fieldsStore = writable(opts.fields);
    this.opts = opts;

    new ContentFields({
      props: {
        config: this.config,
        fieldsStore: this.fieldsStore,
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
