import { Sites } from "../@types/site";

export type FetchSitesProps = {
  magicToken: string;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  items: Array<any>;
  page: number;
  limit: number;
};

export const fetchSites = async (props: FetchSitesProps): Promise<Sites> => {
  const fetchParams = {
    __mode: "filtered_list",
    blog_id: "0",
    columns: "name,site_url,parent_website",
    datasource: "website",
    items: JSON.stringify(props.items),
    limit: props.limit,
    magic_token: props.magicToken,
    page: props.page,
    sort_by: "id",
    sort_order: "descend",
  };
  let error;
  let result;
  try {
    result = await jQuery.ajax(window.ScriptURI, {
      type: "POST",
      contentType: "application/x-www-form-urlencoded; charset=utf-8",
      data: fetchParams,
      dataType: "json",
      error: (xmlHttpRequest) => {
        if (xmlHttpRequest.readyState === 0 || xmlHttpRequest.status === 0) {
          error = "possibly unloaded";
        }
      },
    });
  } catch (e) {
    error ??= e;
  }

  if (error || result.error) {
    return {
      count: 0,
      page: 0,
      pageMax: 0,
      sites: [],
    };
  }

  const sites = result.result.objects.map((object) => {
    const name = object[1]
      .replace(/<span[^>]*>.*?<\/span>\s*<a[^>]*>([^<]+)<\/a>/, "$1")
      .trim();
    return {
      id: object[0],
      name: name,
      siteUrl: object[2],
      parentSiteName: object[3],
    };
  });

  return {
    count: Number.parseInt(result.result.count),
    page: Number.parseInt(result.result.page),
    pageMax: Number.parseInt(result.result.page_max),
    sites: sites,
  };
};
