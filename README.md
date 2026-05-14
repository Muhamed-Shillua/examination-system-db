# Examination System - Database Design

## Overview

This project represents the database design phase of an Online Examination System.
The system is implemented using SQL Server and follows relational database design principles with normalization up to 3NF.

The database is designed to support academic operations including student management, course enrollment, instructor assignments, exam generation, answer submission, grading, and reporting.

This repository focuses exclusively on the database layer and does not include UI or application logic.

---

## Project Scope

The scope of this project includes:

- Database requirements analysis
- Entity Relationship Diagram (ERD)
- Database schema design
- Stored procedures design
- Business rules definition
- Reporting requirements

---

## Core Features

The database supports the following functionalities:

- Student management and department classification
- Course management and topic organization
- Instructor assignment to courses
- Student enrollment in courses
- Exam creation and question management
- Multiple-choice question structure
- Student answer tracking
- Grade calculation and storage
- Reporting for academic staff

---

## Main Entities

The system is built around the following entities:

- Student
- Department
- Instructor
- Course
- CourseTopic
- Exam
- Question
- Choice
- StudentAnswer
- Grade
- StudentCourse
- InstructorCourse

---

## Database Design Summary

### Relationships

- A Department has many Students
- A Department has many Instructors
- A Department offers many Courses
- A Course has many Topics
- A Course has many Exams
- An Exam has many Questions
- A Question has many Choices

### Many-to-Many Relationships

- Students and Courses are connected through StudentCourse
- Instructors and Courses are connected through InstructorCourse

### Transactional Relationships

- Students submit answers through StudentAnswer
- Grades are linked to Students and Exams

---

## Business Rules

- Each student belongs to one department
- A student can enroll in multiple courses
- An instructor can teach multiple courses
- A course can have multiple instructors
- Each exam contains multiple questions
- Each question contains multiple choices
- Each student can submit only one answer per question
- Duplicate enrollments are not allowed
- Duplicate instructor-course assignments are not allowed

---

## Database Design Principles

- The database is designed using SQL Server
- Primary keys and foreign keys are properly defined
- Composite keys are used for junction tables
- The schema follows Third Normal Form (3NF)
- Referential integrity is enforced across all relationships

---

## Reports

The database supports the following reports using stored procedures:

- Students filtered by department
- Student grades per course
- Instructor courses with student count
- Course topics listing
- Exam questions with choices
- Student answers per exam

---

## Files in This Repository

- ERD.md: Entity Relationship Diagram in Mermaid format
- ERD.png: Visual representation of the ERD
- DATABASE_SCHEMA.sql: SQL table creation scripts
- STORED_PROCEDURES.sql: Database stored procedures
- REQUIREMENTS.md: Full system requirements document
- BUSINESS_RULES.md: Business logic definitions

---

## Technology Stack

- SQL Server
- Relational Database Design
- Stored Procedures
- Normalized Database Structure (3NF)
