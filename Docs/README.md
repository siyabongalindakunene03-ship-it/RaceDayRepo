# PROG6212_POE
Repo for parts one, two, and three of the PROG6212 POE 

# RaceDay — PROG6212 POE

## System Description

RaceDay is a full-stack, web-based event management system built for the South
African road running, walking, and cycling community. The platform allows Event
Organisers to create and manage events, categories, and participant results, while
Participants can browse upcoming events, enter events, track their personal
performance history, and prepare for race day using live weather and route
information.

This repository contains the planning phase of the project: the entity-relationship
diagram (ERD), the API endpoint plan, and the SQL script used to build the database
schema.

## Roles

### Event Organiser
Organisers create and manage events (e.g. marathons, cycle tours, park runs), define
categories within each event (e.g. distance, age group), and capture or manage
participant results once an event has taken place.

### Participant
Participants browse upcoming events, enter events of their choice, view their
personal performance history across past events, and check live weather and route
information to prepare for race day.

## Repository Structure

```
/docs
  ├── README.md 
  ├── SectionA_ERD.pdf                  # Entity Relationship Diagram
  ├── SectionB_RaceDay_Endpoint-Plan.pdf         # Planned API endpoints
  └── SectionCRaceDay_SQL_Execution.pdf                # Database creation script
.github/workflows/validate.yml # CI/CD structure validation
README.md
```

## Planning Documents

- [Entity Relationship Diagram](./docs/SectionA_ERD.pdf)
- [Endpoint Plan](./docs/SectionB_RaceDay_Endpoint-Plan.pdf )
- [SQL Script](./docs/SectionC_schema.sql)

## CI/CD

A GitHub Actions workflow runs on every push to validate that the `/docs` folder
exists and contains the required planning files.

**Successful build:**

<img width="1920" height="1061" alt="Screenshot (90)" src="https://github.com/user-attachments/assets/b27ffb03-0f79-4dad-8162-14b4d46bbc1e" />




## Video Walkthrough

An unlisted YouTube video walking through the planning documents, ERD decisions,
endpoint plan choices, and a live run of the SQL script in SSMS:

**Video Link:** [Insert YouTube link here]

## How to Run the SQL Script

1. Open SQL Server Management Studio (SSMS).
2. Connect to a clean SQL Server instance.
3. Open `docs/schema.sql`.
4. Execute the script — it will create the database, tables, and sample data.

