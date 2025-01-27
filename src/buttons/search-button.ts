import { ContentType } from "../@types/contenttype";
import SearchButton from "./elements/SearchButton.svelte";

type SearchButtonProps = {
  blogId: string;
  magicToken: string;
  contentTypes: ContentType[];
};

export function svelteMountSearchButton(
  target: Element,
  props: SearchButtonProps,
): void {
  new SearchButton({
    target: target,
    props: props,
  });
}
