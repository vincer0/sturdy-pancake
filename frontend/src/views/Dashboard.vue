<script setup lang="ts">
import { onMounted, ref } from "vue"
import { useDashboard } from '../hooks/useDashboard';

defineEmits<{
  switchContext: []
}>();

const { getDashboard, loading, data } = useDashboard();

const errorMessage = ref<string>('');

onMounted(() => {
    errorMessage.value = '';
    getDashboard().catch((error: Error) => {
        errorMessage.value = error.message;
    });
});

const handleRefreshTable = () => {
    errorMessage.value = '';
    getDashboard().catch((error: Error) => {
        errorMessage.value = error.message;
    });
};

</script>

<template>
    <div class="dashboard">
        <h2>Dashboard</h2>
        <div class="buttons-wrapper">
            <button @click="handleRefreshTable" :disabled="loading">Refresh Dashboard</button>
            <button @click="$emit('switchContext')">Go to Form</button>
        </div>
        <p class="error-message" v-if="errorMessage">{{ errorMessage }}</p>
        <p class="loading" v-if="loading">Loading</p>
        <div v-if="data" class="data-table">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Leads</th>
                        <th>Visits</th>
                        <th>Created At</th>
                        <th>Image</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="ad in data" :key="ad.id">
                        <td>{{ ad.id }}</td>
                        <td>{{ ad.title }}</td>
                        <td>{{ ad.leads }}</td>
                        <td>{{ ad.visits }}</td>
                        <td>{{ new Date(ad.created_at).toLocaleString() }}</td>
                        <td><img :src="ad.image" alt="ad image here" class="ad-image"></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<style scoped>
div.dashboard {
    display: flex;
    flex-direction: column;
    align-items: center;
}
.data-table {
    max-width: 500px;
    margin: 1rem 0;
    display: grid;
    place-items: center;
}

.data-table table {
    width: 100%;
    padding: 1rem;
    border-collapse: collapse;
    border: 1px solid #646cff;
}

.data-table th, .data-table td {
    padding: 0.5rem;
    text-align: center;
    border: 1px solid #646cff;
}

.buttons-wrapper {
    display: flex;
    gap: 1rem;
    margin-bottom: 1rem;
}

img.ad-image {
    max-width: 150px;
    height: auto;
}

@media (max-width: 600px) {
    .data-table {
        max-width: 100%;
    }

    .buttons-wrapper {
        flex-direction: column;
    }
}
</style>
