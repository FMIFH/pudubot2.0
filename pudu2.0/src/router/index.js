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
  {
    path: '/account',
    name: 'Account',
    component: () => import('../views/Account.vue')
  },
  {
    path: '/rent/:renteeid',
    name: 'Rent',
    component: () => import('../views/Rent.vue')
  },
  {
    path: '/group/:groupid',
    name: 'Group',
    component: () => import('../views/Group.vue')
  },
]

const router = new VueRouter({
  routes
})

export default router
