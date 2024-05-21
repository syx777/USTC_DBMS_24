<template>
    <header class="app-header">
      <nav>
        <ul>
          <li><router-link to="/">Home</router-link></li>
          <li><router-link to="/students">学生信息</router-link></li>
          <li><router-link to="/awards">奖惩信息</router-link></li>
          <li><router-link to="/courses">课程信息</router-link></li>
        </ul>
      </nav>
    </header>
  </template>
  
  <script>
  export default {
    name: 'AppHeader'
  };
  </script>
  
  <style scoped>
  .app-header {
    background-color:#544ACA;
    padding: 1rem;
    color: white;
  }
  
  nav ul {
    list-style: none;
    padding: 0;
    display: flex;
    justify-content: space-around;
  }
  
  nav li {
    margin: 0 1rem;
  }
  
  nav a {
    color: white;
    text-decoration: none;
  }
  
  nav a:hover {
    text-decoration: underline;
  }
  </style>
  