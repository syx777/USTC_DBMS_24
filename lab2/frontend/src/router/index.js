/* eslint-disable */
import { createRouter, createWebHistory } from 'vue-router';
import Home from '../views/Home.vue';
import StudentList from '../views/StudentList.vue';
import StudentForm from '../views/StudentForm.vue';
import Class from '../views/Class.vue';
import ClassForm from '../views/ClassForm.vue';
import Course from '../views/Course.vue';
import CourseForm from '../views/CourseForm.vue';
import Selection from '../views/Selection.vue';
import Grade from '../views/Grade.vue';

const routes = [
  { path: '/', name: 'Home', component: Home },
  { path: '/students', name: 'StudentList', component: StudentList },
  { path: '/student-form', name: 'StudentForm', component: StudentForm, props: true },
  { path: '/course', name: 'Course', component: Course },
  { path: '/class', name: 'Class', component: Class },
  { path: '/class-form', name: 'ClassForm', component: ClassForm, props: true },
  { path: '/course-form', name: 'CourseForm', component: CourseForm, props: true },
  { path: '/selection', name: 'Selection', component: Selection },
  { path: '/grade', name: 'Grade', component: Grade }
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
  parseQuery: query => query,
  stringifyQuery: query => query,
});

export default router;