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

  props.anchorRef.addEventListener("click", () => {
    props.open = true;
    props.oldOverflow = document.body.style.overflow;
    app.$set(props);
    document.body.style.overflow = "hidden";
  });
}
