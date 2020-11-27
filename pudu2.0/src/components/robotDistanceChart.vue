<template>
    <div>
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
        <div>
            <button v-on:click='groupByTime("minute")'>MINUTE</button>
            <button v-on:click='groupByTime("hour")'>HOUR</button>
            <button v-on:click='groupByTime("day")'>DAY</button>
        </div>
    </div>
</template>

<script>
    import LineChart from '../components/LineChart.vue';
    import moment from "moment";

    export default {
        components:{
            LineChart
        },

        props:{
            robotid : String
        },

        data(){
            return{
                robotTotalDistance : 0,
                robotDistanceArray : [],
                displayRobotDistanceArray : [],
                distanceChartColors: {
                    borderColor: "#9BA0B3",
                    pointBorderColor: "#0E1428",
                    pointBackgroundColor: "#AFD6AC",
                    backgroundColor: "#2B52E0",
                    type: "bar",
                    barThickness: 30
                },
                chartOptions: {
                responsive: true,
                maintainAspectRatio: false,
            }
            }
        },

        methods : {
            groupByTime : async function(time){
                this.robotTotalDistance = 0;
                this.robotDistanceArray = [];
                const data = {
                    "timedis" : time,
                    "robot" : this.robotid
                };

                const response = await fetch(process.env.VUE_APP_API +'/rpc/distancepertime',
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

        mounted (){
            this.groupByTime("hour");
        }

    }
</script>

<style>

</style>