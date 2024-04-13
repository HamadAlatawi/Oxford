<script lang="ts">
    import { Input } from "$lib/components/ui/input";
    import { Label } from "$lib/components/ui/label/index.js";
    import { Button } from "$lib/components/ui/button";
    import BG from "$lib/images/bg-2.jpg"
    import { loginStore, registerStore } from "$lib/data/stores/stores";

    function loginCheck(){
        $loginStore = true;
        $registerStore = false;
    }
  </script>
  
  <svelte:head>
      <title>Register - DeComm</title>
      <meta name="description" content="Donation Engine Home Page" />
  </svelte:head>

<div class="grid grid-cols-12 min-h-screen max-h-screen w-full">
    <div class="hidden lg:flex lg:col-span-6 w-full h-full bg-black relative">
        <div class="absolute inset-0 bg-cover" style="background-image: url({BG});"></div>
    </div>
    <div class="col-span-12 lg:col-span-6 w-full h-full flex justify-center items-center">
        <div class="absolute right-10 top-10">
            <Button variant="outline" on:click={loginCheck}>Login</Button>
        </div>
        <div class="block text-center">
            <h1 class="font-semibold text-2xl mb-2">Create an account</h1>
            <p class="opacity-75">Enter your fullname to register your account</p>
            <div class="grid w-full max-w-sm items-center gap-1.5 text-start mt-5">
                <Label for="text">Full name</Label>
                <Input type="text" id="fullname" placeholder="Jane Doe" />
                <Button>Register</Button>
            </div>
        </div>
    </div>
</div>