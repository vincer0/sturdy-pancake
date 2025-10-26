import { ref } from "vue"

export const useAdvertisements = () => {
    const API_URL = 'http://localhost:3008/api/advertisements';

    const loading = ref(false);

    const createAdvertisement = async (title: string, image: File) => {
        try {
            loading.value = true;
            const formData = new FormData();
            formData.append('title', title);
            formData.append('image', image);

            const response = await fetch(API_URL, {
                method: 'POST',
                body: formData,
            });

            if (!response.ok) {
                throw new Error('Failed to create advertisement');
            }

            const blob = await response.blob();
            const url = window.URL.createObjectURL(blob);

            return { success: true, url };
        } finally {
            loading.value = false;
        }
    };

    return { createAdvertisement, loading };
};