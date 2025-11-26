import type * as ContentType from "../@types/contenttype";

import { writable } from "svelte/store";

import ContentFieldTypes from "./ContentFieldTypes";

import ContentFields from "./elements/ContentFields.svelte";

import CustomElementField from "./elements/CustomElementField.svelte";

import "./MtContentFieldOption";

class CustomElementFieldBase extends HTMLElement {
  options: ContentType.Options = {};
  connectedCallback(): void {
    this.options = JSON.parse(this.getAttribute("data-options") || "{}");
  }
  disconnectedCallback(): void {}
}

export default class ContentTypeEditor {
  static accessor config: ContentType.ConfigSettings = {};
  static accessor fieldsStore: ContentType.FieldsStore;
  static accessor optionsHtmlParams: ContentType.OptionsHtmlParams = {};
  static accessor opts: ContentType.ContentFieldsOpts;
  static readonly types = ContentFieldTypes;
  static readonly CustomElementFieldBase = CustomElementFieldBase;

  static registerCustomType(
    type: string,
    mountFunction:
      | ContentType.CustomContentFieldMountFunction
      | typeof CustomElementFieldBase,
  ): void {
    if (mountFunction.prototype instanceof CustomElementFieldBase) {
      const customElement = `mt-content-type-custom-type-${type}`;
      customElements.define(
        customElement,
        mountFunction as typeof CustomElementFieldBase,
      );
      mountFunction = (props, target) => {
        let options: ContentType.Options;
        const customElementField = new CustomElementField({
          props: {
            ...props,
            type,
            customElement,
            updateOptions: (_options: ContentType.Options) => {
              options = _options;
            },
          },
          target: target,
        });
        return {
          component: customElementField,
          gather: () => {
            return options;
          },
          destroy: () => {
            customElementField.$destroy();
          },
        };
      };
    }
    this.types.registerCustomType(
      type,
      mountFunction as ContentType.CustomContentFieldMountFunction,
    );
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
