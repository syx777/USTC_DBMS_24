/* eslint-disable */
<template>
  <header class="app-menu">
    <nav>
      <div class="menu-header">功能菜单</div>
      <ul>
        <li><router-link to="/students">学籍信息管理</router-link></li>
        <li><router-link to="/class">班级信息管理</router-link></li>
        <li><router-link to="/course">课程信息管理</router-link></li>
        <li><router-link to="/selection">选课信息管理</router-link></li>
        <li><router-link to="/grade">成绩信息管理</router-link></li>
        <li><router-link to="/awards">奖惩信息管理</router-link></li>
      </ul>
    </nav>
  </header>
</template>

<script>
export default {
  name: 'AppMenu'
};
</script>

<style scoped>
.app-menu {
  background-color: white;
  color: #544ACA;
  border-right: 4px solid #aca7e6; /* 添加右边框 */
  border-left: 4px solid #544ACA; /* 添加右边框 */
  margin-top: 6rem;
  height: calc(100vh - 6rem); /* 使导航栏填满页面高度 */
  position: fixed; /* 固定导航栏在页面左侧 */
  top: 0;
  left: 0;
  width: 210px; /* 调整导航栏宽度 */
  padding: 0; /* 移除内部填充 */
  font-size: 1.2rem;
  box-sizing: border-box; /* 包括边框在内进行计算 */
}

.menu-header {
  background: linear-gradient(to bottom, white, #aca7e6); /* 修改这一行 */
  color: #544ACA;
  padding: 1rem;
  margin: 0; /* 移除外边距 */
  box-shadow: 0px 4px 8px 0px rgba(0, 0, 0, 0.2); /* 添加阴影 */
  font-weight: bold;
}

nav ul {
  list-style: none;
  padding: 0;
  margin: 0; /* 移除外边距 */
}

nav li {
  margin: 1rem 0; /* 调整间距以适应垂直布局 */
}

nav a {
  color: #544ACA;
  text-decoration: none;
}

nav a:hover {
  text-decoration: underline;
}
</style>
