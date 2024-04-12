<script lang="ts">
	import Register from "$lib/components/modules/Register.svelte"
	import { loggedIn } from "$lib/data/stores/stores";
	import { loginStore } from "$lib/data/stores/stores";
	import { registerStore } from "$lib/data/stores/stores";
	import Login from "$lib/components/modules/Login.svelte"
    import Cards from "$lib/components/modules/(buyer)/Cards/Cards.svelte";
</script>

<main>
	{#if $loggedIn == false }
		{#if $registerStore}
			<Register />
		{:else if $loginStore}
			<Login />
		{/if}
	{:else}
		<Cards />
	{/if}
</main>
