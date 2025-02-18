import { ContentType } from "../@types/contenttype";
import SearchButton from "./elements/SearchButton.svelte";

type SearchButtonProps = {
  blogId: string;
  magicToken: string;
  contentTypes: ContentType[];
  open: boolean;
  buttonRef: HTMLElement;
  anchorRef: HTMLElement;
};

export function svelteMountSearchButton(
  target: HTMLElement,
  props: SearchButtonProps,
): void {
  const app = new SearchButton({
    target: target,
    props: props,
  });

  props.anchorRef.addEventListener("click", () => {
    props.open = true;
    app.$set(props);
  });
}
