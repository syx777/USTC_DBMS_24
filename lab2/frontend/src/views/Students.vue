<template>
    <div class="students">
      <h1>Students</h1>
      <!-- Students management UI -->
    </div>
  </template>
  
  <script>
  export default {
    name: 'StudentList',
    data() {
      return {
        students: []
      };
    },
    created() {
      this.fetchStudents();
    },
    methods: {
      fetchStudents() {
        this.$http.get('/api/students')
          .then(response => {
            this.students = response.data;
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
    /* Styles for students management */
  }
  </style>
  