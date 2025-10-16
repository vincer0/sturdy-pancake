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
# fullstack-task-2025
