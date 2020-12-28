<template>
  <div>
    <Sidebar></Sidebar>
    <HomePage></HomePage>
  </div>
</template>

<script>
import HomePage from '../components/HelloWorld.vue'
import Sidebar from '../components/sidebar.vue'

export default {
  name: 'Home',
  components: {
    HomePage,
    Sidebar
  }
}
</script>

<style>
body {    
  margin: 0;
  padding: 0;
  font-family: Verdana, Geneva, Tahoma, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #575963;
  height: 100vh;
  background-image: url("../assets/background.png") !important;
}
</style>  
