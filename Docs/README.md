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

This repository contains the planning phase of the project: the entity relationship
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
  ├── ERD.png                  # Entity Relationship Diagram
  ├── endpoint-plan.md         # Planned API endpoints
  └── schema.sql                # Database creation script
.github/workflows/validate.yml # CI/CD structure validation
README.md
```

## Planning Documents

- [Entity Relationship Diagram](./docs/ERD.png)
- [Endpoint Plan](./docs/endpoint-plan.md)
- [SQL Script](./docs/schema.sql)

## CI/CD

A GitHub Actions workflow runs on every push to validate that the `/docs` folder
exists and contains the required planning files.

**Successful build:**

![CI/CD Green Build](./docs/ci-success-screenshot.png)

<!-- Replace the image above with your actual screenshot once the workflow passes -->

## Video Walkthrough

An unlisted YouTube video walking through the planning documents, ERD decisions,
endpoint plan choices, and a live run of the SQL script in SSMS:

**Video Link:** [Insert YouTube link here]

## How to Run the SQL Script

1. Open SQL Server Management Studio (SSMS).
2. Connect to a clean SQL Server instance.
3. Open `docs/schema.sql`.
4. Execute the script — it will create the database, tables, and sample data.

