# Academic Exemption Management

ISFCE project that helps students request an exemption based on prior coursework. The submitted application uses Angular, a Spring Boot REST API, H2 and Keycloak. The source repository includes the backend, frontend, tests and PlantUML workflow diagrams. [Application source and local setup](https://github.com/safouanfr-arch/academic-exemption-platform)

## Student workflow

Students can resume a draft, link completed courses to requested teaching units, and upload supporting files or add references. The application shows validation feedback before submission and displays the status of each dossier on the dashboard.

```mermaid
flowchart LR
    A[Open a dossier] --> B[Choose a program section]
    B --> C[Record completed courses]
    C --> D[Link courses to requested units]
    D --> E[Add document references]
    E --> F{Validation}
    F -->|Incomplete| C
    F -->|Complete| G[Submit for review]
```

A unit request can refer to several completed courses. Each completed course can support one unit request within a dossier. Dossier state controls whether students can still edit those links.

## Workflow screenshots

![Completed courses form with a fictional course](completed-courses.png)

![Teaching unit request linked to a completed course](unit-requests.png)

![Document reference form using fictional data](document-references.png)
