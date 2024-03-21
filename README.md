# Prolog Scheduling Project

**Achievement**: This project was awarded a grade of 19,5 out of 20.

## Introduction
This project was developed for the "Logic for Programming" class, utilizing Prolog to reconstruct and manage scheduling and room occupation data efficiently.

## Data Structures
The project utilizes two key files:
- `dados.pl`: Contains facts about events, their associated shifts, and schedules.
- `keywords.pl`: Houses useful keywords like room types and academic programs.

Events are detailed with identifiers, discipline names, types, student counts, and room assignments, while shifts are linked to events with course tags, academic years, and class names.

## Implemented Predicates

### Data Quality
- **eventosSemSalas/1**: Finds events without assigned rooms.
- **eventosSemSalasDiaSemana/2**: Identifies events without rooms on specific weekdays.
- **eventosSemSalasPeriodo/2**: Locates events without rooms during certain periods.

### Simple Queries
- **organizaEventos/3**: Sorts events by period.
- **eventosMenoresQue/2**: Retrieves events shorter than a given duration.
- **eventosMenoresQueBool/2**: Checks if an event's duration falls below a threshold.
- **procuraDisciplinas/2**: Finds disciplines within a course.
- **organizaDisciplinas/3**: Sorts disciplines by semester for a course.
- **horasCurso/4**: Calculates total event hours for a course per year and period.
- **evolucaoHorasCurso/2**: Tracks course hours across periods.

### Critical Room Occupations
Predicates calculate room occupation percentages, highlighting critical over-occupations based on a predefined threshold. 
This includes assessing occupied hours, maximum occupancy, and critical occupancy rates across different room types.

### A Unique Challenge
Addressing a neighbor's request, the project also tackles arranging a dinner seating plan with specific constraints, showcasing Prolog's versatility in solving diverse problems.
