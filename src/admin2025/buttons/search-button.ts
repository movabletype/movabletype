import { ContentType } from "src/@types/contenttype";
import SearchButton from "./elements/SearchButton.svelte";

type SearchButtonProps = {
  blogId: string;
  magicToken: string;
  contentTypes: ContentType[];
  open: boolean;
  buttonRef: HTMLElement;
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
    if (data.success) {
      searchTabs = data.data;
    }
  }

  const app = new SearchButton({
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
      props.open = false;
    } else {
      props.open = true;
    }
    app.$set(props);
  });
}
