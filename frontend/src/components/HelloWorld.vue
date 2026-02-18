<script setup lang="ts">
defineProps<{
  msg: string;
}>();
</script>

<template>
  <div class="greetings">
    <h1 class="green">{{ msg }}</h1>
    <h3>Hooray!</h3>

    <button @click="queryApi">Query API</button>

    <p v-if="apiResult">API Result: {{ apiResult }}</p>
  </div>
</template>

<script lang="ts">
// Some (terrible) code just to show what it looks like to talk to the backend.
export default {
  data(): { apiResult: string | null } {
    return { apiResult: null };
  },
  methods: {
    async queryApi() {
      try {
        const host = import.meta.env.VITE_API_HOST;
        const port = import.meta.env.VITE_API_PORT;
        var res = await fetch(`http://${host}:${port}/hello/from-rust`);
        if (res.ok) {
          this.apiResult = await res.text();
        } else {
          this.apiResult = "Returned not 200";
        }
      } catch (e) {
        this.apiResult = "Error: " + e;
        console.log("Error", e);
      }
    },
  },
};
</script>
