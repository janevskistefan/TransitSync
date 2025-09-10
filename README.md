# TransitSync

TransitSync is an open-source project designed to centralize transport agency schedules. By making this data accessible via APIs, it allows agencies to easily share crucial, real-time information with riders through popular navigation apps like Google Maps.

> [!IMPORTANT]
> This project is in its early stages of development and is actively seeking contributors.

## Technology Stack
- **Frontend**: React 19 with TypeScript
- **Backend**: Spring Boot with Java 21
- **Database**: PostgreSQL 17

## Project Layout

This is a monorepo that contains all the components necessary for TransitSync.

- `client/`: The frontend application.
- `server/`: The backend application.
- `database/`: Contains the compose.yml file for running the database locally with Docker.
- `schemas/`: A shared directory that acts as a contract registry, used by both the frontend and backend to generate common models.
- `data/`: A temporary directory for holding public transit information, which will be removed in a future update.
- `.github/`: Stores all GitHub Actions workflows for continuous integration and deployment.

## How to Contribute

To contribute, you'll need the following tools:
- JDK 21 (or higher) + Maven
- Docker
- Node.js

## Local Development Setup
Follow these steps to get the full suite running on your machine:

- Start the database:
    - Navigate to the database directory and run `docker compose up -d`. This will start a PostgreSQL container in the background.
- Run the backend:
    - Go to the `server` directory.
    - Run `mvn clean package` to clean the build and compile the code.
    - After the build is complete, execute `java -jar target/transitsync-1.0-SNAPSHOT.jar` to start the backend application.
    - **Tip**: If you're using an IDE like Visual Studio Code or IntelliJ, you can use a Maven plugin to run the `clean` and `package` lifecycles, and then simply run the `TransitSyncApplication` class.
- Run the frontend:
    - Go to the `client` directory.
    - Execute `npm install` to download all required dependencies.
    - Execute `npm run dev` to start the development server.







