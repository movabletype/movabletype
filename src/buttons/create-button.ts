import { ContentType } from "../@types/contenttype";
import CreateButton from "./elements/CreateButton.svelte";

type CreateButtonProps = {
  blog_id: string;
  contentTypes: ContentType[];
};

export const svelteMountCreateButton = ({
  target,
  props,
}: {
  target: Element;
  props: CreateButtonProps;
}): void => {
  new CreateButton({
    target: target,
    props: props,
  });
};
