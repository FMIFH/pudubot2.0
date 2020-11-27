<template>
    <div class="row mt-6" v-if="robotPositionsArray.length > 0">
        <div class="col">  
          <h2 class="text-center">Positions</h2>
          <dot-chart
            :chartData="robotPositionsArray"
            :options="chartOptions"
            :chartColors="positionChartColors"
            label="position"
            :chartLabels="labels"
          ></dot-chart>
        </div>
    </div>
</template>

<script>
    import DotChart from '../components/DotChart.vue';

    export default {
        components:{
            DotChart
        },

        props:{
            robotid : String
        },
        
        data(){
            return{
                api : 'http://microsegur.ddns.net:3006',
                robotPositionsArray : [],
                positionChartColors: {
                    borderColor: "#9BA0B3",
                    pointBorderColor: "#0E1428",
                    pointBackgroundColor: "#AFD6AC",
                    backgroundColor: "#2B52E0",
                    type: "bubble"
                },
                chartOptions: {
                    responsive: true,
                    maintainAspectRatio: false,
                },
                labels: []
            }
        },

        methods: {   
            getPositions : async function(){
                var minX = 100;
                var maxX = -100;
                const response = await fetch(process.env.VUE_APP_API +`/robotposition?robotid=eq.${this.robotid}`);
                if(response.ok){
                    const responseJson = await response.json();
                    responseJson.forEach(d => {
                        this.robotPositionsArray.push({total: {x :  Math.floor(d.x), y: Math.floor(d.y) , r:3}});
                        if(Math.floor(d.x) < minX){
                            minX = Math.floor(d.x);
                        }
                        if(Math.floor(d.x) > maxX){
                            maxX = Math.floor(d.x);
                        }
                    });
                    for(var i = minX; i <= maxX; i++){
                        this.labels.push(i);
                    }
                }
            }
        },

        mounted() {
            this.getPositions();
        }
    }        
</script>

<style>

</style>