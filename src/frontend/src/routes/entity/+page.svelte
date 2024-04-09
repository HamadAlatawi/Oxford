<script lang="ts">
	import Slider from '$lib/slider/slider.svelte';
    import { Reload } from "radix-icons-svelte";
    import { Button } from "$lib/components/ui/button";    
    import img1 from '$lib/images/ssPuslZL-1.webp'
    import img2 from '$lib/images/ssPuslZL-1-1.webp'

    let clicked = false;

    const handleOnSubmit = async () => {
		clicked = true;

        setTimeout(() =>{
            clicked = false;
        }, 5000)
	};
</script>

<svelte:head>
	<title>Entities - Donation Engine</title>
	<meta name="description" content="View Donation Engine Entities" />
</svelte:head>

<section class="grid grid-cols-12 relative h-screen flex items-center justify-center">
    <div class="col-span-3"></div>
    <div class="col-span-6 relative h-screen flex mt-5 justify-center w-full">
        <div class="flex flex-col items-center">
            <div class="mt-10 mb-2">
                <p class="text-5xl mb-5">Alejandro Pedro</p>
            </div>
            <picture class="">
                <source media="(min-width: 768px)" srcset="{img2}" width="256" height="256" />
                <img src="{img1}" width="512" height="512" alt="entity" class="w-full h-full object-cover shadow-lg border border-8 border-slate-950"/>
            </picture>
            <div class="my-5">
                <p class="text-base">In the heart of a bustling Latin American city, I, Alejandro, found myself facing a daunting adversary: a brain tumor. At 50 years old, with a family to care for and dreams yet to fulfill, the diagnosis hit me like a thunderbolt.
    
                    As a teacher, I had always believed in the power of education to transform lives. But now, I found myself on a different kind of journey—one filled with uncertainty, fear, and financial strain. The medical treatments drained our resources, leaving us struggling to make ends meet.
                    
                    Yet, amidst the darkness, a glimmer of hope emerged. My community rallied around me, offering support, encouragement, and even financial assistance. Their kindness lifted my spirits and gave me the strength to fight on.
                    
                    With each surgery, chemotherapy session, and radiation treatment, I clung to the belief that I could overcome this obstacle. My family became my rock, their unwavering love and support sustaining me through the darkest days.
                    
                    And as I emerged from the shadow of illness, I realized that my journey was not just about survival—it was about resilience, courage, and the power of community. Today, I stand tall, grateful for every moment, every smile, and every hand that reached out to help me along the way.
                    
                    My battle with a brain tumor was a test of endurance, but it was also a testament to the human spirit's capacity to overcome even the greatest challenges. As I look to the future, I am filled with gratitude for the gift of life and the opportunity to inspire others with my story of hope and perseverance.</p>
            </div>
            <div class="w-full">
                <p class="text-4xl mb-5 font-semibold">Donate</p>
                <p class="text-2xl font-semibold mb-5">Fund Alejandro</p>
                <Slider value={[0]} max={100} step={1} class="mb-10 mx-1"/>
                <p class="text-2xl font-semibold mb-5">Backing the Token</p>
                <Slider value={[0]} max={100} step={1} class="mb-10 mx-1"/>
                <p class="text-2xl font-semibold mb-5">Teacher education and support</p>
                <Slider value={[0]} max={100} step={1} class="mb-10 mx-1"/>
                <p class="text-2xl font-semibold mb-5">Development and future work</p>
                <Slider value={[0]} max={100} step={1} class="mb-10 mx-1"/>
                <p class="text-2xl font-semibold mb-5">Infrastructure</p>
                <Slider value={[0]} max={100} step={1} class="mb-10 mx-1"/>
                <div class="flex justify-end">
                    {#if !clicked}
                        <Button variant="outline" class="my-10 h-9 w-32" on:click={handleOnSubmit}>Donate</Button>
                    {:else}
                        <Button disabled class="my-10 h-9 w-32">
                            <Reload class="mr-2 h-4 w-4 animate-spin" />
                            Please wait
                        </Button>
                    {/if}
                </div>
                
            </div>
        </div>
    </div>
    <div class="col-span-3"></div>
</section>