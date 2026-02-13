import SearchButton from "./elements/SearchButton.svelte";
import { mount } from "svelte";

type SearchButtonProps = {
  blogId: string;
  magicToken: string;
  open: boolean;
  anchorRef: HTMLElement;
};

export interface SearchTab {
  key: string;
  label: string;
}

export function svelteMountSearchButton(
  target: HTMLElement,
  props: SearchButtonProps,
): void {
  let searchTabs: SearchTab[] = [];
  if (target.dataset.searchTabsJson) {
    const data = JSON.parse(target.dataset.searchTabsJson);
    if (data.error) {
      target.remove();
      return;
    }
    if (data.success) {
      searchTabs = data.data;
    }
  }

  const app = mount(SearchButton, {
    target: target,
    props: {
      searchTabs: searchTabs,
      objectType: target.dataset.objectType ?? "",
      ...props,
    },
  });

  props.anchorRef.addEventListener("click", (event: MouseEvent) => {
    event.preventDefault();
    if (props.anchorRef.classList.contains("open")) {
      app.open = false;
    } else {
      app.open = true;
    }
  });
}
