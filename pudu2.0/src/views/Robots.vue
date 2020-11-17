<template>
    <div>
        <Sidebar></Sidebar>
        <ListRobots></ListRobots>
        <Form></Form>
    </div>
</template>

<script>
import Sidebar from '../components/sidebar.vue'
import Form from '../components/RegisterRobot.vue'
import ListRobots from '../components/RobotInfo.vue'

export default {
    name: 'Robot',
    
    components: {
        Sidebar,
        Form,
        ListRobots
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
    color: 2140AD;
    height: 100vh;
    background-image: url("../assets/background.png");
}


</style>