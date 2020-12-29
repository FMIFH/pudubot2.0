<template>
    <div>

        <form class="registerRent_newRegist" @submit.prevent="registerRent">
            <h2><label for="newUser"><strong>Rent Robots</strong></label></h2>
            <p></p>
            <div>
                <label for="numberRobots">Number Of Robots</label>
                <input type="number" id="numberRobots" name="numberRobots" min="1" value=1 step="1"
                    v-model="numberRobots">
            </div>
            <div>
                <label for="begining">Begining</label>
                <input type="datetime-local" id="begining" name="begining" v-model="beginDate">
            </div>
            <button>Submit</button>

        </form>
        <router-link :to="{ name: 'Account'}">
            Cancel
        </router-link>
    </div>
</template>

<script>

    import moment from 'moment'

    export default {


        data() {
            return {
                renteeid: this.$route.params.renteeid,
                numberRobots: 1,
                beginDate: '',
                free: 0,
            }

        },

        methods: {
            async registerRent() {
                this.freeRobots();
                console.log(this.beginDate);
                var date = new Date(this.beginDate);
                if (this.numberRobots < 1) {
                    alert("You must rent at least 1 robot")
                } else if (date == 'Invalid Date') {
                    alert("Invalid Day")
                } else if (this.numberRobots > this.free) {
                    alert(`We only have ${this.free} robot(s) available`);
                } else {


                    const data = {
                        rentee: this.renteeid,
                        numberrobots: this.numberRobots,
                        begining: date
                    };

                    await fetch(process.env.VUE_APP_API + '/rpc/rent',
                        {
                            headers: {
                                "content-type": "application/json"
                            },
                            body: JSON.stringify(data),
                            method: "POST"
                        });


                    this.$router.push({ name: 'Account' });

                }
            },

            async freeRobots() {
                const response = await fetch(process.env.VUE_APP_API + '/robot?available=eq.true');
                const responseJson = await response.json();
                responseJson.forEach(() => {
                    this.free++;
                });

            }
        },

        mounted() {
            this.freeRobots();
            var todaysDate = moment().format('YYYY-MM-DDTHH:mm');
            //console.log(todaysDate)
           // var year = todaysDate.getFullYear();
           // var month = ("0" + (todaysDate.getMonth() + 1)).slice(-2);
           // var day = ("0" + todaysDate.getDate()).slice(-2);
           // var minDate = (year + "-" + month + "-" + day);

            document.getElementById("begining").setAttribute('min', todaysDate);
            document.getElementById("begining").setAttribute('value', todaysDate);
            this.beginDate = todaysDate;
        }


    }
</script>

<style>
    .registerRent_newRegist {
        font-family: 'Open Sans Condensed', arial, sans;
        width: 500px;
        padding: 30px;
        background: #FFFFFF;
        margin: 50px auto;
        box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.22);
        -moz-box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.22);
        -webkit-box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.22);

    }

    .registerRent_newRegist h2 {
        background: #2140AD;
        text-transform: uppercase;
        font-family: 'Open Sans Condensed', sans-serif;
        color: #929292;
        font-size: 18px;
        font-weight: 100;
        padding: 20px;
        margin: -30px -30px 30px -30px;
    }

    .registerRent_newRegist textarea,
    .registerRent_newRegist input,
    .registerRent_newRegist select {
        box-sizing: border-box;
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        outline: none;
        display: block;
        width: 100%;
        padding: 7px;
        border: none;
        border-bottom: 1px solid #ddd;
        background: transparent;
        margin-bottom: 10px;
        font: 16px Arial, Helvetica, sans-serif;
        height: 45px;
    }

    .registerRent_newRegist textarea {
        resize: none;
        overflow: hidden;
    }

    .registerRent_newRegist button {
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
    }

    .registerRent_newRegist button:hover {
        background: linear-gradient(to bottom, #254ddfc7 5%, #254ddf 100%);
        background-color: #254ddfc7;
    }
</style>