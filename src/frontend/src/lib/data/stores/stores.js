import { writable } from 'svelte/store';

const createWritableStore = (key, startValue) => {
    const { subscribe, set } = writable(startValue);
    
    return {
      subscribe,
      set,
      useLocalStorage: () => {
        const json = localStorage.getItem(key);
        if (json) {
          set(JSON.parse(json));
        }
        
        subscribe(current => {
          localStorage.setItem(key, JSON.stringify(current));
        });
      }
    };
  }

export const loggedIn = createWritableStore(false);

export const registerStore = createWritableStore(true);

export const loginStore = createWritableStore(false);

export const fullName = createWritableStore("");

export const search = writable("loading")