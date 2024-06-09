/* eslint-disable */
import { createRouter, createWebHistory } from 'vue-router';
import store from '../store'; // 引入 store
import Home from '../views/Home.vue';
import StudentList from '../views/StudentList.vue';
import StudentForm from '../views/StudentForm.vue';
import Class from '../views/Class.vue';
import ClassForm from '../views/ClassForm.vue';
import Course from '../views/Course.vue';
import CourseForm from '../views/CourseForm.vue';
import Selection from '../views/Selection.vue';
import Grade from '../views/Grade.vue';
import Award from '../views/Award.vue';
import AwardForm from '../views/AwardForm.vue';

const routes = [
  { path: '/', name: 'Home', component: Home },
  { path: '/students', name: 'StudentList', component: StudentList, meta: { requiresAuth: true } },
  { path: '/student-form', name: 'StudentForm', component: StudentForm, props: true, meta: { requiresAuth: true } },
  { path: '/course', name: 'Course', component: Course, meta: { requiresAuth: true } },
  { path: '/class', name: 'Class', component: Class, meta: { requiresAuth: true } },
  { path: '/class-form', name: 'ClassForm', component: ClassForm, props: true, meta: { requiresAuth: true } },
  { path: '/course-form', name: 'CourseForm', component: CourseForm, props: true, meta: { requiresAuth: true } },
  { path: '/selection', name: 'Selection', component: Selection, meta: { requiresAuth: true } },
  { path: '/grade', name: 'Grade', component: Grade, meta: { requiresAuth: true } },
  { path: '/award', name: 'Award', component: Award, meta: { requiresAuth: true } },
  { path: '/award-form', name: 'AwardForm', component: AwardForm, props: true, meta: { requiresAuth: true } }
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
  parseQuery: query => query,
  stringifyQuery: query => query,
});

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!store.state.loggedIn) {
      store.dispatch('promptLogin', '请先登录');
      next('/');
    } else {
      next();
    }
  } else {
    next();
  }
});

export default router;
