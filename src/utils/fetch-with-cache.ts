const CACHE_PREFIX = "movabletype_app_cache_";
const pendingRequests = new Map();

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const getFromLocalStorage = (key: string): any => {
  const item = localStorage.getItem(CACHE_PREFIX + key);
  if (item) {
    try {
      const parsed = JSON.parse(item);
      if (parsed.expiry > Date.now()) {
        return parsed.data;
      } else {
        localStorage.removeItem(CACHE_PREFIX + key);
      }
    } catch {
      console.warn("Failed to parse cached data for key:", key);
    }
  }
  return null;
};

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const saveToLocalStorage = (key: string, data: any, ttl: number): void => {
  const expiry = Date.now() + ttl;
  localStorage.setItem(CACHE_PREFIX + key, JSON.stringify({ data, expiry }));
};

export const fetchWithCache = async ({
  key,
  fetcher,
  ttl = 1000 * 60, // 1min
  noCache = false,
}: {
  key: string;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  fetcher: { (): Promise<any>; (): any };
  ttl?: number;
  noCache?: boolean;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
}): Promise<any> => {
  if (noCache) {
    return fetcher();
  }
  const cached = getFromLocalStorage(key);
  if (cached) {
    return cached;
  }

  if (pendingRequests.has(key)) {
    return pendingRequests.get(key);
  }

  const request = await fetcher()
    .then((data) => {
      saveToLocalStorage(key, data, ttl);
      return data;
    })
    .catch((error) => {
      console.log("Failed to fetch data:", error);
    })
    .finally(() => {
      pendingRequests.delete(key);
    });
  pendingRequests.set(key, request);

  return request;
};

export const clearCache = (key: string): void => {
  localStorage.removeItem(CACHE_PREFIX + key);
  pendingRequests.delete(CACHE_PREFIX + key);
};

export const clearAllCache = (): void => {
  Object.keys(localStorage).forEach((key) => {
    if (key.startsWith(CACHE_PREFIX)) {
      localStorage.removeItem(key);
    }
  });
  pendingRequests.clear();
};
