<script setup lang="ts">
import { ref } from 'vue';
import { useAdvertisements } from '../hooks/useAdvertisements';

defineEmits<{
  switchContext: []
}>();

const title = ref<string>('');
const image = ref<File | null>(null);
const downloadLink = ref<string>('');

const { createAdvertisement, loading } = useAdvertisements();

const handleFileInputChange = (event: Event) => {
  const target = event.target as HTMLInputElement;
  if (target.files && target.files.length > 0) {
    image.value = target.files[0];
  }
};

const handleOnSubmit = () => {
  createAdvertisement(title.value, image.value)
    .then((response) => {
      if(response.success) {
        title.value = '';
        image.value = null;
        downloadLink.value = response.url;
      }
  }).catch((error) => {
      console.error('Error creating advertisement:', error);
    });
};

</script>

<template>
  <div class="form-wrapper">
    <h2>Create Advertisement</h2>
    <form class="form" @submit.prevent="handleOnSubmit">
      <div class="form-group text-input">
        <label for="title">Title:</label>
        <input id="title" type="text" v-model="title" required />
      </div>
      <div class="form-group image-upload">
        <label for="image">Upload Image</label>
        <input id="image" type="file" @change="handleFileInputChange" required />
      </div>
      <div>
        <span>Selected file: {{ image ? image.name : 'None Selected!' }}</span>
      </div>
      <div v-if="loading">Uploading...</div>
      <button type="submit" :disabled="loading">Submit</button>
    </form>
    <div v-if="downloadLink">
      <h3>Advertisement Created!</h3>
      <a :href="downloadLink" target="_blank">Download</a>
    </div>
  </div>
  <button class="switch-context" @click="$emit('switchContext')">Go to Dashboard</button>
</template>

<style scoped>
.form-wrapper {
  width: 500px;
  margin: auto;
  padding: 1em;
  border: 1px solid #ccc;
  border-radius: 5px;
  box-sizing: border-box;
}

.form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  width: 100%;
  box-sizing: border-box;
}

.form-group {
  width: 100%;
  display: flex;
}

.form-group.text-input {
  flex-direction: column;
}

.form-group.text-input label {
  margin-bottom: 0.5em;
  text-align: left;
}

.form-group.text-input input[type="text"] {
  flex: 1;
  padding: 12px 8px;
  border: 1px solid #ccc;
  border-radius: 5px;
  
}

.form-group.image-upload {
  position: relative;
}

.form-group.image-upload label {
  flex: 1;
  position: relative;
  display: block;
  background-color: #007bff;
  color: white;
  padding: 0.5em 1em;
  border-radius: 5px;
  cursor: pointer;
  margin: 0;
  z-index: 1;
}

/** invented by me */
.form-group.image-upload input[type="file"] {
  position: absolute;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 1px;
}

.switch-context {
  margin-top: 1em;
}

@media (max-width: 600px) {
  .form-wrapper {
    width: 100%;
  }
}
</style>