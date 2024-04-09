<script>
    import { page } from '$app/stores'
    import { goto } from '$app/navigation';
    import { Button } from "$lib/components/ui/button";
    import { setMode, resetMode } from "mode-watcher";
    import { Separator } from "$lib/components/ui/separator";
    import * as DropdownMenu from "$lib/components/ui/dropdown-menu";
    import { Sun, Moon } from "radix-icons-svelte";

    const frontendCanisterId = import.meta.env.VITE_FRONTEND_CANISTER_ID;


    function Entity() {
        goto('/entity?canisterId=' + frontendCanisterId);
    }

    function Transaction() {
        goto('/transaction?canisterId=' + frontendCanisterId);
    }

    function goHome(){
    goto('/?canisterId=' + frontendCanisterId)
    }
</script>

<header>
    <nav class="border-b-stone-900 bg-white lg:border-stone-900 border-b-[8px]
    grid grid-cols-12 lg:grid-cols-12 gap-4 flex w-full flex-nowrap items-center justify-between bg-white py-2 text-stone-500
     hover:text-stone-500 focus:text-stone-700 dark:bg-[#0C0A09] lg:flex-wrap lg:justify-start lg:py-6
    data-te-navbar-ref dark:border-white">
        <div class="col-span-10 lg:col-span-3">
            <!-- Header -->
            <div class="ml-2 lg:ml-10">
                <a class="text-2xl 2xL:text-4xl font-semibold text-stone-800 dark:text-stone-200" href="#">Donation Engine</a>
            </div>
        </div>
  
        <!-- Second Column (col-6) -->
        <div class="hidden lg:flex lg:col-span-6 justify-center items-center text-center">
            <!-- Links -->
            <div class="!visible mt-2 hidden items-center lg:mt-0 lg:!flex lg:basis-auto" id="navbarSupportedContent2" data-te-collapse-item>
                <ul class="list-style-none mr-auto flex flex-col pl-0 lg:mt-1 lg:flex-row gap-x-6" data-te-navbar-nav-ref>
                    <!-- Home link -->
                    <li data-te-nav-item-ref>
                        <a class="active text-lg font-semibold disabled:text-black/30 lg:px-2 [&.active]:text-black/90 dark:[&.active]:text-stone-400" aria-current="page" href="/?canisterId={frontendCanisterId}" on:click={goHome} data-te-nav-link-ref>Home</a>
                    </li>
                    <Separator orientation="vertical" />
                    <!-- Transaction link -->
                    <li data-te-nav-item-ref>
                      <a class="p-0 text-lg font-semibold text-stone-500 transition duration-200 hover:text-stone-700 hover:ease-in-out focus:text-stone-700 disabled:text-black/30 motion-reduce:transition-none dark:text-stone-200 dark:hover:text-stone-400 dark:focus:text-stone-400 lg:px-2 [&.active]:text-black/90 dark:[&.active]:text-stone-400" href="/transaction?canisterId={frontendCanisterId}" on:click={Transaction} data-te-nav-link-ref>Transactions</a>
                    </li>
                    <Separator orientation="vertical" />
                    <!-- Features link -->
                    <li data-te-nav-item-ref>
                        <a class="p-0 text-lg font-semibold text-stone-500 transition duration-200 hover:text-stone-700 hover:ease-in-out focus:text-stone-700 disabled:text-black/30 motion-reduce:transition-none dark:text-stone-200 dark:hover:text-stone-400 dark:focus:text-stone-400 lg:px-2 [&.active]:text-black/90 dark:[&.active]:text-stone-400" href="/entity?canisterId={frontendCanisterId}" on:click={Entity} data-te-nav-link-ref>Entity</a>
                    </li>
                    <Separator orientation="vertical" />
                    <li data-te-nav-item-ref>
                      <a class="p-0 text-lg font-semibold text-stone-500 transition duration-200 hover:text-stone-700 hover:ease-in-out focus:text-stone-700 disabled:text-black/30 motion-reduce:transition-none dark:text-stone-200 dark:hover:text-stone-400 dark:focus:text-stone-400 lg:px-2 [&.active]:text-black/90 dark:[&.active]:text-stone-400 hover:cursor-pointer" data-te-nav-link-ref>Learn More</a>
                    </li>
                </ul>
            </div>
        </div>
  
        <!-- Third Column (col-4) -->
        <div class="hidden lg:flex col-span-3 items-end justify-end mr-5">
          <!-- Dropdown Menu -->
          <DropdownMenu.Root>
              <DropdownMenu.Trigger asChild let:builder>
                  <Button builders={[builder]} variant="outline" size="icon">
                      <Sun class="h-[1.2rem] w-[1.2rem] rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
                      <Moon class="absolute h-[1.2rem] w-[1.2rem] rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
                      <span class="sr-only">Toggle theme</span>
                  </Button>
              </DropdownMenu.Trigger>
              <DropdownMenu.Content align="end">
                  <DropdownMenu.Item on:click={() => setMode("light")}>Light</DropdownMenu.Item>
                  <DropdownMenu.Item on:click={() => setMode("dark")}>Dark</DropdownMenu.Item>
                  <DropdownMenu.Item on:click={() => resetMode()}>System</DropdownMenu.Item>
              </DropdownMenu.Content>
          </DropdownMenu.Root>
  
          <Separator orientation="vertical" />
  
          <Button class="mx-5">Donate</Button>
        </div>
  
        <div class="col-span-2 lg:hidden">
          <div>
            <div class="w-6 h-1 my-1 bg-stone-900 dark:bg-white"></div>
            <div class="w-6 h-1 my-1 bg-stone-900 dark:bg-white"></div>
            <div class="w-6 h-1 bg-stone-900 dark:bg-white"></div>
          </div>
        </div>
    </nav>
</header>

<style>
	header {
		display: flex;
		justify-content: space-between;
		view-transition-name: header;
	}
</style>