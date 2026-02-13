import CreateButton from "./elements/CreateButton.svelte";
import { mount } from "svelte";

type CreateButtonProps = {
  blog_id: string;
  magicToken: string;
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
  const app = mount(CreateButton, {
    target: target,
    props: {
      blog_id: props.blog_id,
      magicToken: props.magicToken,
      open: props.open,
      anchorRef: props.anchorRef,
      containerRef: props.containerRef,
    },
  });

  target.addEventListener("click", (event: MouseEvent) => {
    event.preventDefault();
    if (props.anchorRef.classList.contains("open")) {
      app.open = false;
    } else {
      app.open = true;
    }
  });
};
