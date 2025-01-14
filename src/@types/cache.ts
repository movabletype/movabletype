export interface Cache {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    get(key: string): any | null;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    set(key: string, value: any, ttl: number): void;
    delete(key: string): void;
    clear(): void;
  }
