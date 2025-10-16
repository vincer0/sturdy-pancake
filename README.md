# fullstack-task-2025

# Setup

Download an example project and follow the `readme.md` file to set up the project. Only Docker is required to get the stack up and running.

---

# Assignment

Create a simple module that receives input from the user (**image** and **text**) and outputs it as a **combined advertisement code**.
The code should consist of **2 files**:

- `index.html`
- `scripts.js`

### index.html
Should contain the HTML part of the built advertisement that embeds the content created by the user, as well as the styles.

### scripts.js
Should contain:
- The logic for displaying the advertisement.
- Tracking of clicks on the image by sending a tracking event to the endpoint.
- Tracking of impressions (advertisement displays).

### Dashboard Endpoint
Prepare an endpoint that presents advertisement data in a simple table (`/dashboard`).

---

# Frontend

You can use any CSS framework of your choice, **or none at all**.
**Do not** use the Laravel Vite setup — instead, use a **standalone Vue application** inside the `frontend` directory.

---

# Tips

Remember that this is a test assignment.
What matters most is to **showcase your knowledge**, not to create a perfect, production-grade application

---

# Project setup

1. Run `make init`
2. Run `make build`
3. Run `make up ARGS="-d"` to start the containers.
4. Run `make setup` to initialize defaults.

Sometimes you may have to wait until mariadb intializes properly. If you get an error on `make setup`, retry it in 5 minutes.

## Development

1. Run `make exec app_bash` to enter application container
2. Run `make exec frontend_bash` to enter frontend container

### HINT

To pass arguments, use ARGS like this:
`make up ARGS="-d"`
`make logs ARGS="app"`
