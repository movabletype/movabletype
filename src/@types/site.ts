export interface Sites {
  count: number;
  page: number;
  pageMax: number;
  sites: Site[];
  error?: Error;
}
export interface Site {
  id: string;
  name: string;
  siteUrl: string;
  parentSiteName: string;
}
