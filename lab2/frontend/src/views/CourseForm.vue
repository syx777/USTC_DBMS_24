<template>
    <div class="course-form">
        <form @submit.prevent="submitForm">
            <table>
                <tbody>
                    <tr>
                        <td><label for="course_id">课程编号</label></td>
                        <td><input v-model="form.course_id" id="course_id" type="text" required /></td>
                    </tr>
                    <tr>
                        <td><label for="teacher_name">授课教师</label></td>
                        <td><input v-model="form.teacher_name" id="teacher_name" type="text" required /></td>
                    </tr>
                    <tr>
                        <td><label for="course_place">授课地点</label></td>
                        <td><input v-model="form.course_place" id="course_place" type="text" required /></td>
                    </tr>
                    <tr>
                        <td><label for="credits">学分</label></td>
                        <td><input v-model="form.credits" id="credits" type="text" required /></td>
                    </tr>
                </tbody>
            </table>
            <div class="button-container">
                <button type="submit">提交</button>
                <button @click="returnCourseList">返回</button>
            </div>
        </form>
    </div>
</template>

<script>
import axios from 'axios';
import router from '../router';

export default {
    name: 'CourseForm',
    data() {
        return {
            form: {
                course_id: '',
                teacher_name: '',
                course_place: '',
                credits: ''
            },
        };
    },
    created() {
        if (this.$route.params.course) {
            try {
                this.course = JSON.parse(this.$route.params.course);
                this.form.course_id = this.course.course_id || '';
                this.form.teacher_name = this.course.teacher_name || '';
                this.form.course_place = this.course.course_place || '';
                this.form.credits= this.course.credits || '';
            } catch (error) {
                console.error('Error parsing course:', error);
            }
        } else {
            console.log('No course found');
            this.course = {};
        }
    },
    methods: {
        returnCourseList() {
            router.push({ name: 'Course' });
        },
        submitForm() {
            const courseId = this.form.course_id;
            console.log('Submitting form:', this.form, courseId)
            if (this.$route.params.course) {
                axios.put(`http://localhost:3001/api/courses/${courseId}`, this.form)
                    .then(() => {
                        router.push({ name: 'Course' });
                    })
                    .catch(error => {
                        console.error(error);
                    });
            } else {
                axios.post('http://localhost:3001/api/courses', this.form)
                    .then(() => {
                        router.push({ name: 'Course' });
                    })
                    .catch(error => {
                        console.error(error);
                    });
            }
        }
    }
};
</script>

<style scoped>
.course-form {
    margin-left: 250px;
    margin-top: 150px;
    width: 50%;
    padding: 20px;
}

.button-container {
    display: flex;
    justify-content: space-between;
}

table {
    width: 100%;
    border-collapse: collapse;
}

td {
    padding: 10px;
    border: 1px solid #ddd;
}

td:first-child {
    width: 30%;
    text-align: right;
    padding-right: 20px;
}

input,
button {
    margin: 5px 0;
    width: 100%;
    padding: 8px;
    box-sizing: border-box;
}
</style>