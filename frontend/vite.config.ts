import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

export default () => {
  return defineConfig({
    server: {
      host: '0.0.0.0',
      port: 3000,
      strictPort: true
    },
    build: {
      outDir: "./public",
    },
    base: "/app/",
    plugins: [vue()],
  });
};
