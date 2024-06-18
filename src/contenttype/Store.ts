import { writable } from "svelte/store";

export const fieldsStore = writable([] as Array<MT.ContentType.Field>);
