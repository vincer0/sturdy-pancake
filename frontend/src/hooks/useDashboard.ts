import { ref } from "vue"

export const useDashboard = () => {
    const API_URL = 'http://localhost:3008/api/dashboard';

    const loading = ref(false);

    const data = ref<any>(null);

    const getDashboard = async () => {
        loading.value = true;

        const response = await fetch(API_URL);

        loading.value = false;

        if (!response.ok) {
            throw new Error('Failed to fetch dashboard data');
        }

        data.value = await response.json();
        
        return { success: true };
    };

    return { getDashboard, loading, data };
};