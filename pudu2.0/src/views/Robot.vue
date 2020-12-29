<template>
    <div>
        <Sidebar></Sidebar>
        <div class="container">
            <h1> {{robotid}}</h1>
            <robotDistanceChart :robotid= "robotid" ></robotDistanceChart>
            <robotPositionsChart :robotid= "robotid" ></robotPositionsChart>
        </div>
    </div>
    
</template>

<script>
import Sidebar from '../components/sidebar.vue';
import robotDistanceChart from '../components/robotDistanceChart.vue'
import robotPositionsChart from '../components/robotPositionsChart.vue'

export default {
    components: {
        Sidebar,
        robotDistanceChart,
        robotPositionsChart
    },

    data(){
        return{
            robotid : this.$route.params.robotid,
        }
    },      
}
</script>

<style>
body {
    margin: 0 !important;
    padding: 0 !important;
    width: 100% !important;
}
.container h1{
    color: #2140AD;
}

.container {
    padding: 0 25px;
}
</style>