<script lang="ts">
	import { createActor } from '../../../declarations/backend';
	import { Reload } from "radix-icons-svelte";
    import { Button } from "$lib/components/ui/button"; 
	import Skeleton from '$lib/components/ui/skeleton/skeleton.svelte';

	let input = '';
	let disabled = false;
	let greeting = '';
	let skeleton = false;
	let clicked = false;

	const handleOnSubmit = async () => {
		disabled = true;
		skeleton = true;
		clicked = true;
		greeting = ''
		try {
			// Canister IDs are automatically expanded to .env config - see vite.config.ts
			const canisterId = import.meta.env.VITE_BACKEND_CANISTER_ID;

			// We pass the host instead of using a proxy to support NodeJS >= v17 (ViteJS issue: https://github.com/vitejs/vite/issues/4794)
			const host = import.meta.env.VITE_HOST;

			// Create an actor to interact with the IC for a particular canister ID
			const actor = createActor(canisterId, { agentOptions: { host } });

			// Call the IC
			greeting = await actor.get_p2pkh_address();
		} catch (err: unknown) {
			console.error(err);
		}
		skeleton = false;
		clicked = false;
		disabled = false;
	};
</script>

<svelte:head>
	<title>Home - Donation Engine</title>
	<meta name="description" content="Donation Engine Home Page" />
</svelte:head>

<main class="my-20 grid grid-cols-12 h-screen w-full justify-center">
	<div class="col-span-12 mt-20 text-center">
		<form on:submit={handleOnSubmit}>
			<label for="name" class="text-2xl font-semibold">Get Bitcoin address: &nbsp;</label>
			{#if !clicked}
			<Button variant="outline" class="my-10 h-9 w-32" on:click={handleOnSubmit}>Submit</Button>
			{:else}
				<Button disabled class="my-10 h-9 w-32">
					<Reload class="mr-2 h-4 w-4 animate-spin" />
					Please wait
				</Button>
			{/if}
		</form>
	
		<section class="flex justify-center">
			{#if !greeting && skeleton}
			<Skeleton class="w-[465px] h-[29px] rounded-full" />
			{:else if greeting && !skeleton}
				<p>Your Bitcoin address is: {greeting}</p>
			{/if}
		</section>
	</div>
</main>
