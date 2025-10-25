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

        const responseParsed = await response.json();

        data.value = responseParsed.data;

        // sort by date descending
        data.value.sort((a: any, b: any) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
        
        return { success: true };
    };

    return { getDashboard, loading, data };
};