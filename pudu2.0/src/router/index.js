import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/home',
    name: 'Home1',
    component: Home
  },
  {
    path: '/robots',
    name: 'Robots',
    component: () => import('../views/Robots.vue')
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/robots/:robotid',
    name: 'Robot',
    component: () => import('../views/Robot.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/Register.vue')
  },
]

const router = new VueRouter({
  routes
})

export default router
