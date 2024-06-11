<!-- ErrorNotification.vue -->
<template>
    <div v-if="visible" class="error-notification">
        <p>{{ message }}</p>
        <button @click="close">关闭</button>
    </div>
</template>

<script>
export default {
    props: ['message'],
    data() {
        return {
            visible: true,
        };
    },
    methods: {
        close() {
            this.visible = false;
            this.$emit('close');
        },
    },
};
</script>

<style scoped>
.error-notification {
    position: fixed;
    top: 20px;
    right: 20px;
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
    padding: 10px;
    border-radius: 5px;
}
</style>