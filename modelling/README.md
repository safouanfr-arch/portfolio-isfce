# Data Modelling and Project Planning

Selected examples based on the ISFCE work in Merise, Looping and GanttProject. The diagrams use generic labels and synthetic data.

## Conceptual to relational model

The parking model links a vehicle and a spot through a visit. Making the visit its own entity stores timestamps and preserves the history after a spot is freed.

```mermaid
erDiagram
    VEHICLE ||--o{ PARKING_VISIT : makes
    PARKING_SPOT ||--o{ PARKING_VISIT : hosts
    VEHICLE {
        int id PK
        string plate UK
    }
    PARKING_SPOT {
        int id PK
        string label UK
    }
    PARKING_VISIT {
        int id PK
        int vehicle_id FK
        int spot_id FK
        datetime entered_at
        datetime left_at
    }
```

The [Firebird lab](../sql/) implements this model. The [exemption case study](../exemptions/) applies similar modelling to dossiers, units and course equivalences.

## Planning dependencies

The coursework schedule broke a web project into requirements, architecture, database and UI design, development and integration. This simplified schedule uses relative phases from that work.

```mermaid
gantt
    title Web project planning exercise
    dateFormat YYYY-MM-DD
    axisFormat %d %b
    section Analysis
    Requirements       :req, 2025-02-03, 4d
    Architecture       :arch, after req, 3d
    section Implementation
    Data model         :data, after arch, 3d
    Interface design   :ui, after arch, 3d
    API                :api, after data, 6d
    Frontend           :front, after ui, 6d
    section Delivery
    Integration        :integ, after api front, 3d
    Acceptance demo    :milestone, after integ, 0d
```
