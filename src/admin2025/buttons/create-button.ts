import { ContentType } from "src/@types/contenttype";
import CreateButton from "./elements/CreateButton.svelte";

type CreateButtonProps = {
  blog_id: string;
  magicToken: string;
  contentTypes: ContentType[];
  open: boolean;
  anchorRef: HTMLElement;
  containerRef: HTMLElement | null;
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

  target.addEventListener("click", (event: MouseEvent) => {
    event.preventDefault();
    if (props.anchorRef.classList.contains("open")) {
      props.open = false;
    } else {
      props.open = true;
    }
    app.$set(props);
  });
};
