import SearchForm from "./SearchForm.svelte";

type SearchFormProps = {
  blogId: string;
  magicToken: string;
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

  new SearchForm({
    target: target,
    props: {
      searchTabs: searchTabs,
      objectType: target.dataset.objectType ?? "",
      ...props,
    },
  });
}
