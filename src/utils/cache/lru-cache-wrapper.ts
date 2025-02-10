import { LRUCache } from "lru-cache";
import { type Cache } from "../../@types/cache";

export class LRUCacheWrapper implements Cache {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  private cache: LRUCache<string, { data: any; expiry: number }>;

  constructor(options?: { ttl?: number }) {
    this.cache = new LRUCache({
      ttl: options?.ttl ?? 1000 * 60, // 1min
      ttlAutopurge: true,
      allowStale: false,
    });
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  get(key: string): any | null {
    const item = this.cache.get(key);
    if (item) {
      if (item.expiry > Date.now()) {
        return item.data;
      } else {
        this.delete(key);
      }
    }
    return null;
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  set(key: string, value: any, ttl: number): void {
    const expiry = Date.now() + ttl;
    this.cache.set(key, { data: value, expiry }, { ttl });
  }

  delete(key: string): void {
    this.cache.delete(key);
  }

  clear(): void {
    this.cache.clear();
  }
}
