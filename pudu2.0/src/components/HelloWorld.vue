<template>
  <div class="hello">
    <img alt="MCS logo" class="img1" src="../assets/logo2.png">  
    <h1>Welcome To Microsegur Pudubot Aplication</h1>
    <img alt ="img2" class="img2" src="../assets/pudubot.jpg">
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1 {
  color: navy;
}

.img2 {
  border-radius: 8px;
  height: 50vh;
}
</style>
