import { writable } from "svelte/store";

const fields: Array<MT.ContentType.Field> = [];

export const fieldsStore = writable(fields);
