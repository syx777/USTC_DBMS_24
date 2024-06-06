<template>
    <div class="Courses">
        <table>
            <thead>
                <tr>
                    <th>课程ID</th>
                    <th>授课教师</th>
                    <th>授课地点</th>
                    <th>学分</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="course in courses" :key="course.course_id">
                    <td>{{ course.course_id }}</td>
                    <td>{{ course.teacher_name }}</td>
                    <td>{{ course.course_place }}</td>
                    <td>{{ course.credits }}</td>
                    <td>
                        <button @click="navigateToEditCourse(course)">修改</button>
                        <button @click="deleteCourse(course.course_id)">删除</button>
                    </td>
                </tr>
            </tbody>
        </table>
        <button class="add-course-button" @click="navigateToAddCourse">添加课程</button>
    </div>
     <div class="search-bar">
        <input type="text" v-model="searchCriteria.course_id" placeholder="课程ID" />
        <input type="text" v-model="searchCriteria.teacher_name" placeholder="授课教师" />
        <input type="text" v-model="searchCriteria.course_place" placeholder="授课地点" />
        <input type="text" v-model="searchCriteria.credits" placeholder="学分" />
        <button @click="searchCourses">查询</button>
    </div>
</template>

<script>
import axios from 'axios';
import router from '../router';

export default {
    name: 'CourseList',
    data() {
        return {
            courses: [],
            searchCriteria: {
                course_id: '',
                teacher_name: '',
                course_place: '',
                credits: ''
            }
        };
    },
    created() {
        this.fetchCourses();
    },
    methods: {
        fetchCourses() {
            axios.get('http://localhost:3001/api/courses')
                .then(response => {
                    console.log(response.data);
                    this.courses = response.data;
                })
                .catch(error => {
                    console.error(error);
                });
        },
        searchCourses() {
            axios.get('http://localhost:3001/api/courses/search', { params: this.searchCriteria })
                .then(response => {
                    this.courses = response.data;
                })
                .catch(error => {
                    console.error(error);
                });
        },
        navigateToAddCourse() {
            router.push({ name: 'CourseForm', params: { course: null } });
        },
        navigateToEditCourse(course) {
            router.push({ name: 'CourseForm', params: { course: JSON.stringify(course) } });
        },
        deleteCourse(id) {
            axios.delete(`http://localhost:3001/api/courses/${id}`)
                .then(() => {
                    this.fetchCourses();
                })
                .catch(error => {
                    console.error(error);
                });
        }
    }
};
</script>

<style scoped>
.courses {
    padding: 20px;
}

.search-bar {
    margin-bottom: 20px;
    margin-left: 250px;
}

.search-bar input {
    margin-right: 10px;
}

.add-course-button {
    margin-top: 20px;
    margin-left: 250px;
}

table {
    margin-top: 150px;
    margin-left: 250px;
    width: 80%;
    border-collapse: collapse;
}

th,
td {
    border: 1px solid #ddd;
    padding: 8px;
}

th {
    background-color: #f2f2f2;
}

button {
    margin: 5px;
}
</style>