import { ContentType } from "../@types/contenttype";
import CreateButton from "./elements/CreateButton.svelte";

type CreateButtonProps = {
  blog_id: string;
  contentTypes: ContentType[];
  open: boolean;
  buttonRef: HTMLElement | null;
};

export const svelteMountCreateButton = ({
  target,
  props,
}: {
  target: HTMLElement;
  props: CreateButtonProps;
}): void => {
  const app = new CreateButton({
    target: target,
    props: props,
  });

  const anchors = target.getElementsByTagName("a");
  anchors[0].addEventListener("click", () => {
    props.open = true;
    app.$set(props);
  });
};
