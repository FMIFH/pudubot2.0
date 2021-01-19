<template>
    <div id="loginUser">
        <form class="loginUser_class" @submit.prevent="loginUser">
            <h2> <label for="newRobot"><strong>Login</strong></label>
            </h2>
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

        <p></p>
        <router-link :to="{ name: 'Register'}">
            Register
        </router-link>
    </div>

</template>

<script>
    import bcrypt from 'bcryptjs'
    import jwt from 'jsonwebtoken'
    
    export default {
        data() {
            return {
                userEmail: '',
                userPassword: '',
                token: localStorage.getItem('access_token') || null
            }
        },

        methods: {
            loginUser: async function() {
                const response = await fetch(process.env.VUE_APP_API + `/rentee?email=eq.${this.userEmail}`);
                const responseJson = await response.json();
                var password = '';
                var renteeid = '';
                var level = ''
                responseJson.forEach(d => {
                    password = d.password;
                    renteeid = d.renteeid;
                    level = d.admin
                });

                let success = await this.comparePasswords(password);
                console.log(success)
                if(success === false){
                    throw 'Erro Login'
                }
                
                const user = {id : renteeid,level : level};
                const accessToken = jwt.sign(user, process.env.VUE_APP_ACCESS_TOKEN_SECRET)
                localStorage.setItem('access_token',accessToken);


                this.$router.push({name: 'Account'});
            },

            comparePasswords: function(password) {
                return new Promise((resolve, reject) => {
                    bcrypt.compare(this.userPassword, password, (err, res) => {
                        if (err) {
                            return reject(err);
                        } else {
                            return resolve(res);
                        }
                    })
                })
            }
        }
    }
</script>


<style>
    .loginUser_class {
        font-family: 'Open Sans Condensed', arial, sans;
        width: 500px;
        padding: 30px;
        background: #FFFFFF;
        margin: 50px auto;
        box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.22);
        -moz-box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.22);
        -webkit-box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.22);

    }

    .loginUser_class h2 {
        background: #2140AD;
        text-transform: uppercase;
        font-family: 'Open Sans Condensed', sans-serif;
        color: #929292;
        font-size: 18px;
        font-weight: 100;
        padding: 20px;
        margin: -30px -30px 30px -30px;
    }

    .loginUser_class textarea,
    .loginUser_class select {
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

    .loginUser_class textarea {
        resize: none;
        overflow: hidden;
    }

    .loginUser_class button {
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

    .loginUser_class button:hover {
        background: linear-gradient(to bottom, #254ddfc7 5%, #254ddf 100%);
        background-color: #254ddfc7;
    }
</style>