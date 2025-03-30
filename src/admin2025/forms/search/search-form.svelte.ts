import { fetchContentTypes } from "src/utils/fetch-content-types";
import SearchForm from "./SearchForm.svelte";
import { type ContentType } from "src/@types/contenttype";
import { mount } from "svelte";

type SearchFormProps = {
  blogId: string;
  magicToken: string;
  contentTypes?: ContentType[];
};

export interface SearchTab {
  key: string;
  label: string;
}

export function svelteMountSearchForm(
  target: HTMLElement,
  props: SearchFormProps,
): void {
  let searchTabs: SearchTab[] = [];
  if (target.dataset.searchTabsJson) {
    const data = JSON.parse(target.dataset.searchTabsJson);
    if (data.error) {
      target.closest("li[data-is='search-form-button']")?.remove();
      target.remove();
      return;
    }
    if (data.success) {
      searchTabs = data.data;
    }
  }

  const state = $state({
    searchTabs: searchTabs,
    objectType: target.dataset.objectType ?? "",
    contentTypes: props.contentTypes || [],
    isLoading: false,
    ...props,
  });

  mount(SearchForm, {
    target: target,
    props: state,
  });

  const searchFormButton = target.closest(
    "li[data-is='search-form-button']",
  ) as HTMLLIElement;
  searchFormButton.addEventListener(
    "click",
    (event: MouseEvent) => {
      event.preventDefault();
      state.isLoading = true;
      fetchContentTypes({
        blogId: props.blogId,
        magicToken: props.magicToken,
      })
        .then((data) => {
          const contentTypes: ContentType[] = data.contentTypes.filter(
            (contentType) => contentType.can_search === 1,
          );
          state.contentTypes = contentTypes;
          if (state.contentTypes.length > 0 && state.objectType === "") {
            state.objectType = "content_data";
          }
          state.isLoading = false;
        })
        .catch((error) => {
          console.error("Failed to fetch content types:", error);
          state.isLoading = false;
        });
    },
    { once: true },
  );
}
