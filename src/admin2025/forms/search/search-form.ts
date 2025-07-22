import { fetchContentTypes } from "src/utils/fetch-content-types";
import SearchForm from "./SearchForm.svelte";
import { type ContentType } from "src/@types/contenttype";

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
    if (data.success) {
      searchTabs = data.data;
    }
  }

  const searchFormProps = {
    searchTabs: searchTabs,
    objectType: target.dataset.objectType ?? "",
    contentTypes: props.contentTypes || [],
    isLoading: false,
    ...props,
  };

  const app = new SearchForm({
    target: target,
    props: searchFormProps,
  });

  const searchFormButton = target.closest(
    "li[data-is='search-form-button']",
  ) as HTMLLIElement;
  searchFormButton.addEventListener(
    "click",
    (event: MouseEvent) => {
      event.preventDefault();
      searchFormProps.isLoading = true;
      app.$set(searchFormProps);
      fetchContentTypes({
        blogId: props.blogId,
        magicToken: props.magicToken,
      })
        .then((data) => {
          const contentTypes: ContentType[] = data.contentTypes.filter(
            (contentType) => contentType.can_search === 1,
          );
          searchFormProps.contentTypes = contentTypes;
          if (
            searchFormProps.contentTypes.length > 0 &&
            searchFormProps.objectType === ""
          ) {
            searchFormProps.objectType = "content_data";
          }
          searchFormProps.isLoading = false;
          app.$set(searchFormProps);
        })
        .catch((error) => {
          console.error("Failed to fetch content types:", error);
          searchFormProps.isLoading = false;
          app.$set(searchFormProps);
        });
    },
    { once: true },
  );
}
