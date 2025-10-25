<script setup lang="ts">
import { ref } from 'vue';
import AdvertisementForm from './views/AdvertisementForm.vue';
import Dashboard from './views/Dashboard.vue';

const currentView = ref<'form' | 'dashboard'>('form');

const handleSwitchContexts = () => {
  currentView.value = currentView.value === 'form' ? 'dashboard' : 'form';
};

</script>

<template>
    <AdvertisementForm v-if="currentView === 'form'" @switch-context="handleSwitchContexts"/>
    <Dashboard v-else-if="currentView === 'dashboard'" @switch-context="handleSwitchContexts"/>
</template>

<style scoped>
</style>
