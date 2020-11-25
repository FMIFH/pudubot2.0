<template>
  <div>

    <Sidebar></Sidebar>

    <div id="loginUser">
      <label for="newRobot"><strong>Login</strong></label>
      <form class="loginUser_class" @submit.prevent="loginUser">
        <div>
          <label for="userEmail">Email</label>
          <textarea id="userEmail" cols="20" rows="1" v-model="userEmail"></textarea>
        </div>
        <div>
          <label for="userPassword">Password</label>
          <textarea id="userPassword" cols="20" rows="1" v-model="userPassword"></textarea>
        </div>
        <button>Submit</button>
      </form>
      <router-link :to="{ name: 'ClientRegister'}"> Register </router-link>

    </div>
  </div>

</template>

<script>
  import Sidebar from '../components/sidebar.vue'
  import bcrypt from 'bcryptjs'

  export default {
    name: 'Home',
    components: {
      Sidebar
    },

    data() {
      return {
        userEmail: '',
        userPassword: '',
        api: 'http://microsegur.ddns.net:3006'
      }
    },

    methods: {
      loginUser: async function () {
        const response = await fetch(this.api + `/rentee?email=eq.${this.userEmail}`);
        const responseJson = await response.json();
        var password = "";
        responseJson.forEach(d => {
          password = d.password;
        });
        console.log(password);
        console.log(this.userPassword);
        bcrypt.compare(this.userPassword, password, function (err, res) {
          if (res === true) {
            console.log("all good");
          } else {
            console.log("wrong password")
          }
        });

      }
    }
  }
</script>

<style>
  form {
    display: flex;
    margin-left: auto;
    margin-right: auto;
    text-align: left;
    flex-direction: column;
    color: #2140AD;
  }

  .loginUser_class {
    width: 50%;
    text-align: center;
  }
</style>