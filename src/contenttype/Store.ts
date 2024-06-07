import { writable } from "svelte/store";

const fields: Array<MT.ContentType.Field> = [];

export const cfields = writable(fields);
export const mtConfig = writable({});
