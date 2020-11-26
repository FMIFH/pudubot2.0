<template>
  <div>
    <Sidebar></Sidebar>
    <Login></Login>
  </div>
</template>

<script>
  import Sidebar from '../components/sidebar.vue'
  import Login from '../components/LoginClient.vue'


  export default {
    name: 'Home',
    components: {
      Sidebar,
      Login
    }

  }
</script>

<style>

</style>