# Blog API

## Requirements

-   Docker
-   Docker Compose

## Getting Started

### 1. Build and Start the Application

Run the following command to build the Docker images and start the services:

```bash
docker-compose up
```

This command will create and migrate the databases automatically. The application will be accessible at `http://localhost:3000`.

### 2. Stopping the Application

To stop the running application and services, you can use:

```bash
docker-compose down
```

This command will stop all services defined in `docker-compose.yml` file.

### 3. Running the Tests

To run the tests, you can execute the following command:

```bash
docker-compose -f docker-compose.test.yml run --rm test

```

This will run the RSpec tests.
