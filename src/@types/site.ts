export interface Sites {
  count: number;
  page: number;
  pageMax: number;
  sites: Site[];
}
export interface Site {
  id: string;
  name: string;
  siteUrl: string;
  parentSiteName: string;
}
