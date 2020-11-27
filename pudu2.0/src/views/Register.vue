<template>
    <div>
        <form class="registerUser_newRegist" @submit="registerUser">
            <h2><label for="newUser"><strong>Register New User</strong></label></h2>
            <p></p>
            <div>
                <label for="newUser_name">Name</label>
                <textarea id="newUser" cols="20" rows="1" v-model="newUserName"></textarea>
            </div>
            <div>
                <label for="newUser_phone">Phone</label>
                <textarea id="newUser" cols="20" rows="1" v-model="newUserPhone"></textarea>
            </div>
            <div>
                <label for="newUser_email">Email</label>
                <textarea id="newUser" cols="20" rows="1" v-model="newUserEmail"></textarea>
            </div>
            <div>
                <label for="newUser_password">Password</label>
                <textarea id="newUser" cols="20" rows="1" v-model="newUserPassword"></textarea>
            </div>

            <button>Submit</button>
        </form>
        <p></p>
        <router-link :to="{ name: 'Login'}">
            Go Back 
       </router-link>
    </div>
</template>

<script>
    import bcrypt from 'bcryptjs'

    export default {
        name: 'Home',
        components: {
        },

        data() {
            return {
                newUserName: '',
                newUserPhone: '',
                newUserEmail: '',
                newUserPassword: '',
            }
        },

        methods: {
            registerUser: async function () {
                if (this.newUserName !== '' &&
                    this.newUserPhone !== '' &&
                    this.newUserEmail !== '' &&
                    this.newUserPassword !== '') {

                    var hashed = bcrypt.hashSync(this.newUserPassword, 10);

                    const data = {
                        "renteename": this.newUserName,
                        "phone": this.newUserPhone,
                        "email": this.newUserEmail,
                        "password": hashed
                    };

                    await fetch(process.env.VUE_APP_API + '/rentee',
                        {
                            headers: {
                                "content-type": "application/json"
                            },
                            body: JSON.stringify(data),
                            method: "POST"
                        })
                        .then(data => { return data.json })
                        .then(res => { console.log(res) })
                        .catch(error => console.log(error));
                    alert("Account Created")
                    this.$router.push({ name: 'Clients' })
                } else {
                    alert("All credencials are mandatory")
                }
            }
        }
    }
</script>

<style>
    .registerUser_newRegist{
	font-family: 'Open Sans Condensed', arial, sans;
	width: 500px;
	padding: 30px;
	background: #FFFFFF;
	margin: 50px auto;
	box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.22);
	-moz-box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.22);
	-webkit-box-shadow:  0px 0px 15px rgba(0, 0, 0, 0.22);

}
.registerUser_newRegist h2{
	background:  #2140AD;
	text-transform: uppercase;
	font-family: 'Open Sans Condensed', sans-serif;
	color: #929292;
	font-size: 18px;
	font-weight: 100;
	padding: 20px;
	margin: -30px -30px 30px -30px;
}

.registerUser_newRegist textarea,
.registerUser_newRegist select 
{
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
.registerUser_newRegist textarea{
	resize:none;
	overflow: hidden;
}
.registerUser_newRegist button{
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
.registerUser_newRegist button:hover {
	background:linear-gradient(to bottom, #254ddfc7 5%, #254ddf 100%);
	background-color:#254ddfc7;
}
</style>