import { type Cache } from "../@types/cache";

export class CacheManager {
  private cache: Cache;

  constructor({ cache }: { cache: Cache }) {
    this.cache = cache;
  }

  generateCacheKey({
    prefix,
    params,
  }: {
    prefix: string;
    params: Record<string, unknown>;
  }): string {
    const normalizedParams = Object.keys(params)
      .sort()
      .reduce(
        (acc, key) => {
          acc[key] = params[key];
          return acc;
        },
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        {} as Record<string, any>,
      );

    return `${prefix}_${JSON.stringify(normalizedParams)}`;
  }

  async fetchWithCache({
    key,
    fetcher,
    ttl = 1000 * 60, // 1min
    noCache = false,
  }: {
    key: string;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    fetcher: () => Promise<any>;
    ttl?: number;
    noCache?: boolean;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
  }): Promise<any> {
    if (noCache) {
      return fetcher();
    }

    const cached = this.cache.get(key);
    if (cached) {
      return cached;
    }

    const request = fetcher()
      .then((data) => {
        this.cache.set(key, data, ttl);
        return data;
      })
      .catch((error) => {
        console.log("Failed to fetch data:", error);
        return error;
      });

    return request;
  }

  clearCache(key: string): void {
    this.cache.delete(key);
  }

  clearAllCache(): void {
    this.cache.clear();
  }
}
