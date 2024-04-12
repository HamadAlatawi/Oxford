<script lang="ts">
    import { Button } from "$lib/components/ui/button";
    import * as Select from "$lib/components/ui/select";
    import { fullName, loggedIn, registerStore, search } from '$lib/data/stores/stores';
    import Input from '$lib/components/ui/input/input.svelte';
    import { toast } from "svelte-sonner";
    import Card from "$lib/components/modules/(buyer)/Cards/Card/Card.svelte";
    import Sidebar from "$lib/components/modules/(buyer)/Sidebar/Sidebar.svelte";
    import { createPostsIndex, searchPostsIndex, type Result } from "$lib/components/helpers/search";
    import { onMount } from "svelte";

    const frontendCanisterId = import.meta.env.VITE_FRONTEND_CANISTER_ID;

    let searchTerm = 'Search for item...';
	let results: Result[] = []
    let posts : [];

	onMount(async () => {
		posts = await fetch('/search.json').then((res) => res.json())
		createPostsIndex(posts)
		$search = 'ready'
	})


	$: if ($search === 'ready') {
		results = searchPostsIndex(searchTerm)
	}

    function logOut(){
        $loggedIn = false;
        $registerStore = true;
        $fullName = "Null";
    }
</script>

<div class="grid grid-cols-12">
    <div class="col-span-2 border-r-4 border-zinc-300 overflow-hidden">
        <Sidebar />
    </div>
    <div class="col-span-10 grid grid-cols-12 justify-center gap-4 p-5 md:p-8 xl:p-5 2xl:p-40 min-h-screen max-h-screen w-full overflow-scroll">
        {#if !posts}
            <div class="col-span-12 flex h-full w-full justify-center items-center text-7xl">
                Loading Items....
            </div>
        {:else if posts && (searchTerm === "" || searchTerm === "Search for item...")}
            {#each posts as post}
                <div class="col-span-12 md:col-span-6 lg:col-span-3 w-full h-1/6 border-zinc-300 shadow-lg">
                    <Card title={post.title} content={post.content} /> 
                </div>
            {/each}
        {:else if results}
            {#each results as result}
                <div class="col-span-12 md:col-span-6 lg:col-span-3 w-full h-1/6 border-zinc-300 shadow-lg">
                    <Card title={result.title} content={result.content} /> 
                </div>
            {/each}
        {/if}
    </div>
</div>
<footer>
    <nav class="bg-white border-t-4 border-zinc-300
    grid grid-cols-12 lg:grid-cols-12 gap-4 w-full flex-nowrap items-center justify-between py-2 text-stone-500
     hover:text-stone-500 focus:text-stone-700 dark:bg-[#0C0A09] lg:flex-wrap lg:justify-start lg:py-6
    data-te-navbar-ref dark:border-white absolute bottom-0">
        <div class="col-span-10 lg:col-span-3">
          <div class="flex">  
            <div class="ml-2 lg:ml-10">
              <Select.Root>
                  <Select.Trigger class="w-[180px] font-medium">
                    <Select.Value placeholder="Personal Account" />
                  </Select.Trigger>
                  <Select.Content>
                      <p class="text-sm text-center my-3">{$fullName}</p>
                      <hr>
                    <Select.Item value="light">Personal Account</Select.Item>
                    <Select.Item value="dark">Business Account</Select.Item>
                    <hr>
                    <Button class="ghost w-full h-full" on:click={logOut}>Log Out</Button>
                  </Select.Content>
                </Select.Root>
          </div>
          <div class="ml-2 lg:ml-10">
              <Select.Root>
                  <Select.Trigger class="w-[150px] font-medium">
                    <Select.Value placeholder="Deposit Money" />
                  </Select.Trigger>
                  <Select.Content>
                    <Button class="ghost w-full h-full my-2" on:click={() => toast("Added 1000 BTC")}>Deposit 1000 BTC</Button>
                    <Button class="ghost w-full h-full my-2" on:click={() => toast("Added 1000 BTC")}>Deposit 1000 BTC</Button>
                    <Button class="ghost w-full h-full my-2" on:click={() => toast("Added 1000 ICP")}>Deposit 1000 ICP</Button>
                    <Button class="ghost w-full h-full my-2" on:click={() => toast("Added 1000 USD")}>Deposit 1000 USD</Button>
                    <Button class="ghost w-full h-full my-2" on:click={() => toast("Added 1000 EUR")}>Deposit 1000 EUR</Button>
                    <Button class="ghost w-full h-full my-2" on:click={() => toast("Added 1000 BGP")}>Deposit 1000 BGP</Button>
                  </Select.Content>
                </Select.Root>
            </div>
          </div>
        </div>
  
        <!-- Second Column (col-6) -->
        <div class="hidden lg:flex lg:col-span-6 justify-center items-center text-center">
            {#if $search === 'ready'}
              <Input class="rounded-2xl border-2 text-center" placeholder="Search for Item" autocomplete="off" spellcheck="false" type="search" bind:value={searchTerm}/>
            {/if}
        </div>
  
        <!-- Third Column (col-4) -->
        <div class="hidden lg:flex col-span-3 items-end justify-end mr-5">
            <div class="relative">
                <!-- Shopping cart icon -->
                <svg class="w-9 h-9" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path d="M2 3H4.5L6.5 17H17C18.1046 17 19 17.8954 19 19C19 20.1046 18.1046 21 17 21C15.8954 21 15 20.1046 15 19M9 5H21.0001L19.0001 11M18 14H6.07141M11 19C11 20.1046 10.1046 21 9 21C7.89543 21 7 20.1046 7 19C7 17.8954 7.89543 17 9 17C10.1046 17 11 17.8954 11 19Z" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path> </g></svg>
                <!-- Number on top of the cart -->
                <div class="absolute top-0 right-0 flex items-center justify-center w-5 h-5 bg-black text-white text-xs font-semibold rounded-full">3</div>
              </div>
        </div>
  
        <div class="col-span-2 lg:hidden">
          <div>
            <div class="w-6 h-1 my-1 bg-stone-900 dark:bg-white"></div>
            <div class="w-6 h-1 my-1 bg-stone-900 dark:bg-white"></div>
            <div class="w-6 h-1 bg-stone-900 dark:bg-white"></div>
          </div>
        </div>
    </nav>
</footer>