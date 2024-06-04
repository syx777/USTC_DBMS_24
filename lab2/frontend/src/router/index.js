import { createRouter, createWebHistory } from 'vue-router';
import Home from '../views/Home.vue';
import StudentList from '../views/StudentList.vue';
import StudentForm from '../views/StudentForm.vue';
import Courses from '../views/Courses.vue';

const routes = [
  { path: '/', name: 'Home', component: Home },
  { path: '/students', name: 'StudentList', component: StudentList },
  { path: '/student-form', name: 'StudentForm', component: StudentForm, props: true },
  { path: '/courses', name: 'Courses', component: Courses }
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
  parseQuery: query => query,
  stringifyQuery: query => query,
});

export default router;