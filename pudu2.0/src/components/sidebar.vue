<template>
  <div>
    <div id="mySidebar" class="sidebar">
      <a href="javascript:void(0)" class="closebtn" v-on:click="closeNav()">&times;</a>
      <router-link :to="{name:'Home'}">Home</router-link>
      <router-link :to="{name:'Robots'}">Robots</router-link>
      <router-link :to="{name: 'Clients'}">Clients</router-link>
      <router-link :to="{name:'Dashboards'}">Dashboards</router-link>
    </div>
    
    <div id="main">
      <button class="openbtn" v-on:click="openNav()">&#9776; Open Sidebar</button>
    </div>
  </div>
</template>

<script>
export default {
  data(){
    return {
      width:'0',
      marginLeft:'0'
    }
  },
  computed: {
    computedWidth: function () {
      return this.width;
    },
    computedMArgin: function () {
      return this.marginLeft
    }
  },
  methods: {
    openNav :function() {
      document.getElementById("mySidebar").style.width = "250px";
      document.getElementById("main").style.marginLeft = "250px";
    },

    closeNav :function() {
      document.getElementById("mySidebar").style.width = "0";
      document.getElementById("main").style.marginLeft = "0";
    } 
  }
}
</script>

<style>
/* The sidebar menu */
.sidebar {
  height: 100%; /* 100% Full-height */
  width: 0; /* 0 width - change this with JavaScript */
  position: fixed; /* Stay in place */
  z-index: 1; /* Stay on top */
  top: 0;
  left: 0;
  background-color: #2140AD; /* Black*/
  overflow-x: hidden; /* Disable horizontal scroll */
  padding-top: 60px; /* Place content 60px from the top */
  transition: 0.5s; /* 0.5 second transition effect to slide in the sidebar */
  border-radius: 0px 5px 5px 0px;
}

/* The sidebar links */
.sidebar a {
  padding: 20px 10px 10px 32px;
  text-decoration: none;
  font-size: 25px;
  color: whitesmoke;
  display: block;
  transition: 0.3s;
}

/* When you mouse over the navigation links, change their color */
.sidebar a:hover {
  color: #f1f1f1;
}

/* Position and style the close button (top right corner) */
.sidebar .closebtn {
  position: absolute;
  top: 0;
  right: 25px;
  font-size: 36px;
  margin-left: 50px;
}

/* The button used to open the sidebar */
.openbtn {
  font-size: 20px;
  cursor: pointer;
  background-color: #2140AD;
  color: whitesmoke;
  padding: 10px 15px;
  border: none;
  position:absolute;
  top:0;
  left:0;
  border-radius: 0px 5px 5px 0px;
}

/* Style page content - use this if you want to push the page content to the right when you open the side navigation */
#main {
  transition: margin-left .5s; /* If you want a transition effect */
  padding: 20px;
}

/* On smaller screens, where height is less than 450px, change the style of the sidenav (less padding and a smaller font size) */
@media screen and (max-height: 450px) {
  .sidebar {padding-top: 15px;}
  .sidebar a {font-size: 18px;}
}
</style>