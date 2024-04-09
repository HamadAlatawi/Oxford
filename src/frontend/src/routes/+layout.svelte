<script lang="ts">
  import "../app.css";
  import { ModeWatcher, mode } from "mode-watcher";
  import { onNavigate } from '$app/navigation';
  import Header from "$lib/components/ui/Header/Header.svelte";

    onNavigate((navigation) => {
      if (!(document as any).startViewTransition) return;
      return new Promise((resolve) => {
        (document as any).startViewTransition(async () => {
          resolve();
          await navigation.complete;
        });
      });
    });

    
    $: {
        if (typeof document !== 'undefined') {
            document.body.dataset.theme = $mode;
        }
    }
</script>

<Header />

<ModeWatcher />
<slot />