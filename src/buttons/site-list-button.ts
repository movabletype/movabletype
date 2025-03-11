import SiteListButton from "./elements/SiteListButton.svelte";

type SiteListButtonProps = {
  magicToken: string;
  limit: number;
  open: boolean;
  oldOverflow: string;
  buttonRef: HTMLElement;
  anchorRef: HTMLElement;
};

export function svelteMountSiteListButton(
  target: HTMLElement,
  props: SiteListButtonProps,
): void {
  const app = new SiteListButton({
    target: target,
    props: props,
  });

  props.anchorRef.addEventListener("click", (event: MouseEvent) => {
    event.preventDefault();
    if (props.anchorRef.classList.contains("open")) {
      props.open = false;
      document.body.style.overflow = props.oldOverflow;
    } else {
      props.open = true;
      props.oldOverflow = document.body.style.overflow;
      document.body.style.overflow = "hidden";
    }
    app.$set(props);
  });
}
