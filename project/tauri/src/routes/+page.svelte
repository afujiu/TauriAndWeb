<script lang="ts">
  import { bridge } from "$lib/bridge";

  let name = $state("");
  let greetMsg = $state("");

  async function greetHandler(event: Event) {
    event.preventDefault();
    greetMsg = await bridge('greet', { name });
  }
</script>

<main class="container">
  <h1>共有ソース</h1>
  <form class="row" onsubmit={greetHandler}>
    <input id="greet-input" placeholder="Enter a name..." bind:value={name} />
    <button type="submit">Greet</button>
  </form>
  <p>{greetMsg}</p>
</main>

<style>
</style>
