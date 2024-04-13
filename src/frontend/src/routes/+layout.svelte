<script lang="ts">
  import "../app.css";
  import { ModeWatcher, mode } from "mode-watcher";
  import { onNavigate } from '$app/navigation';
  import { loggedIn } from "$lib/data/stores/stores"
  import Footer from "$lib/components/modules/(buyer)/Footer/Footer.svelte";
  import { Toaster } from "$lib/components/ui/sonner";
  import Header from "$lib/components/modules/(buyer)/Header/Header.svelte"

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



<ModeWatcher />
<Toaster />

{#if $loggedIn !== false }
  <Header />
{/if}
<slot />