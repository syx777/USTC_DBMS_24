<template>
  <div class="students">
    <h1>Students</h1>
    <form @submit.prevent="addStudent">
      <input v-model="newStudent.student_id" placeholder="Student-id" required />
      <input v-model="newStudent.name" placeholder="Name" required />
      <input v-model="newStudent.gender" placeholder="Gender" required />
      <input v-model="newStudent.major" placeholder="Major" required />
      <button type="submit">Add Student</button>
    </form>
    <ul>
      <li v-for="student in students" :key="student.student_id">
        {{ student.name }} - {{ student.major }}
        <button @click="editStudent(student)">Edit</button>
        <button @click="deleteStudent(student.student_id)">Delete</button>
      </li>
    </ul>
    <div v-if="editingStudent">
      <h3>Edit Student</h3>
      <form @submit.prevent="updateStudent">
        <input v-model="editingStudent.name" placeholder="Student-id" required />
        <input v-model="editingStudent.name" placeholder="Name" required />
        <input v-model="editingStudent.gender" placeholder="Gender" required />
        <input v-model="editingStudent.major" placeholder="Major" required />
        <button type="submit">Update Student</button>
        <button type="button" @click="cancelEdit">Cancel</button>
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'StudentList',
  data() {
    return {
      students: [],
      newStudent: {
        student_id:'',
        name: '',
        gender: '',
        birth_date: '',
        major: ''
      },
      editingStudent: null
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
    addStudent() {
      axios.post('http://localhost:3001/api/students', this.newStudent)
        .then((response) => {
          console.log('Student added:', response.data); // 添加日志记录
          this.fetchStudents(); // 重新获取学生列表
          this.newStudent = {
            name: '',
            gender: '',
            birth_date: '',
            major: ''
          };
        })
        .catch(error => {
          console.error('Error adding student:', error); // 错误日志
        });
    },
    editStudent(student) {
      this.editingStudent = { ...student };
    },
    updateStudent() {
      axios.put(`http://localhost:3001/api/students/${this.editingStudent.student_id}`, this.editingStudent)
        .then(() => {
          this.fetchStudents(); // 重新获取学生列表
          this.editingStudent = null;
        })
        .catch(error => {
          console.error(error);
        });
    },
    deleteStudent(id) {
      axios.delete(`http://localhost:3001/api/students/${id}`)
        .then(() => {
          this.fetchStudents(); // 重新获取学生列表
        })
        .catch(error => {
          console.error(error);
        });
    },
    cancelEdit() {
      this.editingStudent = null;
    }
  }
};
</script>

<style scoped>
.students {
  padding: 20px;
}

form {
  margin-bottom: 20px;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  margin: 10px 0;
}

button {
  margin-left: 10px;
}
</style>
