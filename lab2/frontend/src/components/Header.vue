<template>
    <header class="app-header">
      <nav>
        <ul class="nav-list">
          <li class="header-title">学籍管理系统</li>
          <li class="header-welcome">欢迎您,系统管理员！</li>
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
    background-color: #544ACA;
    padding: 2rem;
    color: white;
    margin: 0; /* 移除所有外边距 */
    position: fixed; /* 固定导航栏在页面顶部 */
    top: 0;
    left: 0; /* 确保导航栏紧贴左侧 */
    width: 100%; /* 使导航栏填满页面宽度 */
    box-sizing: border-box; /* 包括边框在内进行计算 */
  }
  
  .nav-list {
    list-style: none;
    padding: 0;
    display: flex;
    text-align: left;
    align-items: center; /* 垂直居中 */
    margin: 0; /* 移除默认外边距 */
  }
  
  .header-title {
    font-weight: bold; /* 黑体 */
    font-size: 2rem; /* 放大字体 */
    margin: 0; /* 去除默认外边距 */
    flex-grow: 1; /* 占据剩余空间 */
  }
  
  .header-welcome {
    font-family: "STXingkai"; /* 华文行楷 */
    font-size: 1.5rem; /* 字号 */
    position: absolute;
    right: 30rem; /* 固定在右侧一定距离 */
    top: 50%; /* 垂直居中 */
    transform: translateY(-50%);
  }
  
  nav a {
    color: white;
    text-decoration: none;
  }
  
  nav a:hover {
    text-decoration: underline;
  }
  </style>
  