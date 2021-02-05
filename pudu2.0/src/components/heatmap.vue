<template>
    <div class="wrapper">
        <div class="heatmapContainerWrapper" id="heatmapContainerWrapper" v-on:click="changeHeatMap">
            <img src="" id="plant">
            <div class="heatmapContainer" id="heatmapContainer">
            </div>
        </div>
        <div class="filediv">
            <input type="file" @change="setplant">
        </div>
        <div v-if="!loaded">
            <input type="checkbox" id="checkbox" v-model="checked">
            <label for="checkbox">Set Origin</label>
        </div>
        <div v-if="!loaded">
            <input type="number" id="height" v-model="height" @change="changeScale">
            <label for="height">Building Length</label>
        </div>
        <div class="transformations" v-if="!loaded">
            <button v-on:click="rotate">Rotate 90º</button>
            <button v-on:click="reflect(0)">Reflect X</button>
            <button v-on:click="reflect(1)">Reflect Y</button>
            <button v-on:click="reset">Reset</button>
            <button v-on:click="save">Save</button>

        </div>
    </div>
</template>

<script>
    import * as d3 from 'd3';
    import * as h337 from 'heatmap.js';

    export default {

        props: {
            groupid: Number
        },

        data() {
            return {
                files: [],
                posData: [],
                drawArray: [],
                heatmap: null,
                checked: false,
                origin: { x: 0, y: 0 },
                scale: 1,
                angle: 0,
                reflectionX: 1,
                reflectionY: 1,
                height: 0,
                loaded: false
            }
        },

        methods: {
            async getData() {
                const data = {
                    "groupi": this.groupid
                };
                const response = await fetch(process.env.VUE_APP_API + '/rpc/grouprobotpositions',
                    {
                        headers: {
                            "content-type": "application/json"
                        },
                        body: JSON.stringify(data),
                        method: "POST"
                    }
                );



                if (response.ok) {
                    const responseJson = await response.json();
                    responseJson.forEach(d => {
                        this.posData.push({ x: d.x, y: d.y, value: d.total });
                    });
                }

            },

            $ready(fn) {
                if (process.env.NODE_ENV === 'production') {
                    return this.$nextTick(fn);
                }

                setTimeout(() => {
                    this.$nextTick(fn);
                }, 1000);
            },

            drawHeat: function () {

                d3.select("#heatmapContainerWrapper")
                    .append("svg")           // append an SVG element to the div
                    .attr("width", 700)
                    .attr("height", 500);
            },

            async setplant(event) {
                var file = event.target.files[0];
                await fetch(/*process.env.VUE_APP_BLUEPRINTAPI*/ + `/blueprint/${this.groupid}`,
                    {
                        headers: {
                            "content-type": "image/png"
                        },
                        body: file,
                        method: "POST"
                    }
                );
                this.loadplant()
            },

            async loadplant() {
                var background = document.getElementById("plant");
                //var source = 'https://' + process.env.VUE_APP_BLUEPRINTAPI + `/blueprint/${this.groupid}`
                background.src = "http://127.0.0.1:8888/blueprint/1"//source;

                var wrapper = document.getElementById("heatmapContainerWrapper");
                console.log(background.naturalHeight)
                wrapper.style.height = background.naturalHeight + "px";
                wrapper.style.width = background.naturalWidth + "px";
            },

            async loadheatmap(){
                const response = await fetch(process.env.VUE_APP_API + `/heatmap?groupid=eq.${this.groupid}`);
                if(response.ok){
                    const responseJson = await response.json();
                    responseJson.forEach(p => {
                        this.groupid = p.groupid;
                        this.origin = {x : p.originx, y : p.originy};
                        this.scale = p.scale;
                        this.angle = p.angle;
                        this.reflectionX = p.reflectionx;
                        this.reflectionY = p.reflectiony;
                        this.height = p.height;
                        this.loaded = true;
                    });
                }
            },

            changePosition(e) {
                if (this.checked) {
                    var div = document.getElementById("heatmapContainerWrapper")

                    var desx = e.pageX - div.offsetLeft;
                    var desy = e.pageY - div.offsetTop;
                    this.origin = { x: desx, y: desy };
                    this.drawHeatMap();
                    this.checked = false;
                }
            },

            changeScale() {
                var img = document.getElementById("plant");
                var imgH = img.naturalHeight;
                this.scale = (imgH / this.height).toFixed(1);
                console.log(this.scale)
                this.drawHeatMap();
                this.checkedScale = false;

            },

            rotate() {
                this.angle += 1 / 2;
                this.drawHeatMap();
            },

            reflect(dir) {
                if (dir == 0) {
                    this.reflectionX = this.reflectionX * -1;
                } else {
                    this.reflectionY = this.reflectionY * -1;
                }
                this.drawHeatMap();
            },

            reset() {
                this.origin = { x: 0, y: 0 };
                this.scale = 1;
                this.angle = 0;
                this.reflectionX = 1;
                this.reflectiony = 1;
                this.height = 0;
                this.drawHeatMap();
            },

            async save() {
                const data = {
                    "groupid": this.groupid,
                    "originx": this.origin.x,
                    "originy": this.origin.y,
                    "scale": parseFloat(this.scale),
                    "angle": this.angle,
                    "reflectionx": this.reflectionX,
                    "reflectiony": this.reflectionY,
                    "height": parseFloat(this.height)
                }

                await fetch(process.env.VUE_APP_API + '/heatmap',
                    {
                        headers: {
                            "content-type": "application/json"
                        },
                        body: JSON.stringify(data),
                        method: "POST"
                    }
                );
            },

            drawHeatMap() {
                this.drawArray = [];
                var x1 = Math.cos(this.angle*Math.PI);
                var x2 = Math.sin(this.angle*Math.PI);
                this.posData.forEach(pos => {
                    var newX = (pos.x * x1 + pos.y * x2) * this.reflectionX * this.scale + this.origin.x;
                    var newY = (pos.x * x2 + pos.y * x1) * this.reflectionY * this.scale + this.origin.y;
                    this.drawArray.push({
                        x: newX,
                        y: newY,
                        value: pos.value
                    });

                });
                var themax = this.drawArray[0].value;
                this.heatmap.setData({
                    max: themax + 1,
                    data: this.drawArray
                });
            },

            changeHeatMap(e) {
                if (this.checked && this.checkedScale) {
                    alert("You may only set one at the time");
                    this.checked = false;
                    this.checkedScale = false;
                }
                this.changeScale(e);
                this.changePosition(e);
            },

        },

        async mounted() {
            await this.getData();
            await this.loadplant();
            await this.loadheatmap();
            this.heatmap = h337.create({
                container: document.getElementById('heatmapContainerWrapper'),
                radius: 10,
            });
            this.drawHeatMap();
        }
    }


</script>

<style>
    .wrapper {
        display: block;
    }

    .filediv {
        padding: 1%
    }

    .heatmapContainerWrapper {
        padding: 0;
        margin: auto;
        background-color: #fff;
    }

    .transformations {
        padding: 1%
    }

    .transformations button {
        -moz-box-shadow: inset 0px 1px 0px 0px #2140AD;
        -webkit-box-shadow: inset 0px 1px 0px 0px #2140AD;
        box-shadow: inset 0px 1px 0px 0px #2140AD;
        background-color: #2140AD;
        border: 1px solid #2140AD;
        display: inline-block;
        cursor: pointer;
        color: #FFFFFF;
        font-family: 'Open Sans Condensed', sans-serif;
        font-size: 14px;
        padding: 8px 18px;
        text-decoration: none;
        text-transform: uppercase;
        width: 10%;

    }

    .transformations button:hover {
        background: linear-gradient(to bottom, #254ddfc7 5%, #254ddf 100%);
        background-color: #254ddfc7;
    }


    .dot {
        height: 25px;
        width: 25px;
        background-color: rgb(0, 26, 255);
        border-radius: 50%;
        display: inline-block;
        z-index: 999;
    }
</style>