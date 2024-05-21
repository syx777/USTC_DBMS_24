import { createRouter, createWebHistory } from 'vue-router';
import Home from '../views/Home.vue';
import StudentList from '../views/StudentList.vue';
import Courses from '../views/Courses.vue';

const routes = [
  { path: '/', name: 'Home', component: Home },
  { path: '/students', name: 'StudentList', component: StudentList },
  { path: '/courses', name: 'Courses', component: Courses }
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
});

export default router;
