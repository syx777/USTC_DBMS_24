<template>
  <div class="students">
    <table>
      <thead>
        <tr>
          <th>学号</th>
          <th>姓名</th>
          <th>性别</th>
          <th>班级</th>
          <th>电话</th>
          <th>照片</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="student in students" :key="student.student_id">
          <td>{{ student.student_id }}</td>
          <td>{{ student.name }}</td>
          <td>{{ student.gender }}</td>
          <td>{{ student.class }}</td>
          <td>{{ student.phone }}</td>
          <td><button @click="showPhoto(student.photo)">查看</button></td>
          <td>
            <button @click="navigateToEditStudent(student)">修改</button>
            <button @click="deleteStudent(student.student_id)">删除</button>
          </td>
        </tr>
      </tbody>
    </table>
    <button class="add-student-button" @click="navigateToAddStudent">添加学生</button>

    <modal v-if="showPhotoModal" @close="showPhotoModal = false">
      <img :src="currentPhoto" alt="Student Photo" />
    </modal>
  </div>
</template>

<script>
import axios from 'axios';
import Modal from '../components/Modal.vue';
import router from '../router';

export default {
  name: 'StudentList',
  components: {
    Modal,
  },
  data() {
    return {
      students: [],
      showPhotoModal: false,
      currentPhoto: null
    };
  },
  created() {
    this.fetchStudents();
  },
  methods: {
    fetchStudents() {
      axios.get('http://localhost:3001/api/students')
        .then(response => {
          this.students = response.data;
        })
        .catch(error => {
          console.error(error);
        });
    },
    showPhoto(photo) {
      this.currentPhoto = photo;
      this.showPhotoModal = true;
    },
    navigateToAddStudent() {
      router.push({ name: 'StudentForm', params: { student: null } });
    },
    navigateToEditStudent(student) {
      console.log('Navigating to edit student:', student);
      router.push({ name: 'StudentForm', params: { student: JSON.stringify(student) } });
    },
    deleteStudent(id) {
      axios.deleteStudent(`http://localhost:3001/api/students/${id}`)
        .then(() => {
          this.fetchStudents();
        })
        .catch(error => {
          console.error(error);
        });
    }
  }
};
</script>

<style scoped>
.students {
  padding: 20px;
}

.add-student-button {
  margin-top: 20px;
  margin-left: 250px;
}

table {
  margin-top: 150px;
  margin-left: 250px;
  width: 80%;
  border-collapse: collapse;
}

th, td {
  border: 1px solid #ddd;
  padding: 8px;
}

th {
  background-color: #f2f2f2;
}

button {
  margin: 5px;
}

.modal img {
  max-width: 100%;
}
</style>
