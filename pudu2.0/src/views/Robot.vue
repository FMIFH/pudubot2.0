<template>
    <div>
        <Sidebar></Sidebar>
        <div class="container">
        <h1> {{robotid}}</h1>
        <h3> Total Distance: {{robotTotalDistance}}</h3>
        
        <div class="row mt-5" v-if="robotDistanceArray.length > 0">
            <div class="col">
              <h2 class="text-center">Distance</h2>
              <line-chart
                :chartData="robotDistanceArray"
                :options="chartOptions"
                :chartColors="distanceChartColors"
                label="Distance"
              ></line-chart>
            </div>
        </div>
        </div>
    </div>
    
</template>

<script>
import Sidebar from '../components/sidebar.vue';
import LineChart from '../components/LineChart.vue';
import moment from "moment";


export default {
    components: {
        Sidebar,
        LineChart
    },

    data(){
        return{
            api : 'http://microsegur.ddns.net:3006',
            robotid : this.$route.params.robotid,
            robot : {},
            robotTotalDistance : 0,
            robotDistanceArray : [],
            displayRobotDistanceArray : [],
            distanceChartColors: {
                borderColor: "#077187",
                pointBorderColor: "#0E1428",
                pointBackgroundColor: "#AFD6AC",
                backgroundColor: "#74A57F",
                type: "bar",
                barThickness: 30
            },
            robotPositionsArray : [],
            chartOptions: {
                responsive: true,
                maintainAspectRatio: false,
            }

        }
    },
    
    methods: {
        
        getRobots : async function(){
            const response = await fetch(this.api +`/robot?robotid=eq.${this.robotid}`);
            if(response.ok){
                const responseJson = await response.json();
                this.robot = responseJson;          
            }
        },
        
        groupByTime : async function(time){
            const data = {
                "timedis" : time,
                "robot" : this.robotid
            };

            const response = await fetch(this.api +'/rpc/distancepertime',
            {
                headers: {
                        "content-type":"application/json"
                },
                body: JSON.stringify(data),
                method: "POST"
            }
            );
            if(response.ok){
                const responseJson = await response.json();
                responseJson.forEach(d => {
                    const date1 = moment(d.ts).format("DD-MM-YYYY h:mm:ss");
                    this.robotDistanceArray.push({date: date1, total: d.distance});
                    this.robotTotalDistance += d.distance;
                });
                this.robotTotalDistance = Math.round(this.robotTotalDistance);
            }
        }
    },

    mounted() {
        this.getRobots(),
        this.groupByTime("hour");
    }    
}
</script>

<style>

</style>