<script lang="ts">
    import { Button } from "$lib/components/ui/button";
    import * as Carousel from "$lib/components/ui/carousel";
    import * as Drawer from "$lib/components/ui/drawer";
    import { toast } from "svelte-sonner";

    export let title : any;
    export let content : any;
    
    export let product = {
      name: title,
      description: content,
      imageSrc: 'https://via.placeholder.com/250',
      imageSrc2: 'https://via.placeholder.com/350',
      // Add more properties as needed
    };
</script>
  
  <div class="max-w-md mx-auto bg-white shadow-md rounded-md overflow-hidden">
    <Carousel.Root>
      <Carousel.Content>
        <Carousel.Item><img class="w-full h-96 object-cover" src={product.imageSrc} alt={product.name} /></Carousel.Item>
        <Carousel.Item><img class="w-full h-96 object-cover" src={product.imageSrc2} alt={product.name} /></Carousel.Item>
        <Carousel.Item><img class="w-full h-96 object-cover" src={product.imageSrc} alt={product.name} /></Carousel.Item>
      </Carousel.Content>
      <Carousel.Previous />
      <Carousel.Next />
    </Carousel.Root>
    <div class="p-4">
      <h2 class="text-xl font-semibold">{@html product.name}</h2>
      <p class="text-gray-600 mb-4">{@html product.description}</p>
      <div class="flex justify-between gap-x-2">
        <Drawer.Root>
          <Drawer.Trigger class="border-2 border-zinc-200 p-1 w-3/5 h-full rounded-md hover:bg-zinc-300 hover:border-zinc-600">More details</Drawer.Trigger>
          <Drawer.Content>
            <div class="mx-auto w-full max-w-sm">
              <Drawer.Header>
                <Drawer.Title>{@html product.name}</Drawer.Title>
                <Drawer.Description>Price</Drawer.Description>
              </Drawer.Header>
              <div class="p-4 pb-0">
                <div class="flex items-center justify-center space-x-2">
                  <div class="flex-1 text-center">
                    <div class="text-7xl font-bold tracking-tighter">
                    </div>
                    <div class="text-[0.70rem] uppercase text-muted-foreground">
                      {@html product.description}
                    </div>
                  </div>
              </div>
              <Drawer.Footer>
                <Button on:click={() => toast("Added " + product.name + " to cart")}>Add to cart</Button>
                <Drawer.Close asChild let:builder>
                  <Button builders={[builder]} variant="outline">Close</Button>
                </Drawer.Close>
              </Drawer.Footer>
            </div>
          </Drawer.Content>
        </Drawer.Root>
        <Button class="w-3/5 h-full" variant="default" on:click={() => toast("Added " + product.name + " to cart")}>Add to cart</Button>
      </div>
    </div>
  </div>
  