# sql-db-project
Relational MySQL database for a news web app with advanced queries, triggers, and procedures.

# News Web Application Database (MySQL)

## Overview
This project is a relational database designed for a news web application.
It supports publishing and categorizing articles, managing users and authors,
handling interactions (comments, likes, bookmarks), and generating statistical insights.
An ER diagram is included to visualize entity relationships.

## Core Features
- Structured relational schema with clearly defined primary and foreign keys
- Support for articles, authors, categories, tags, and media content
- User interactions: likes, bookmarks, views, notifications
- Moderation system with banned users and moderator payments
- Statistical queries for popularity and engagement analysis
- Triggers and stored procedures for automated logic

### Main Entities
- Users
- Authors
- Articles
- Categories
- Tags
- Comments
- Moderators
- Payments

## SQL Structure
- `news.sql`  
  Contains the full database schema, including:
  - CREATE TABLE statements
  - Foreign key constraints
  - Triggers
  - Stored procedure

- `news_queries.sql`  
  Contains example queries demonstrating:
  - Filtering with WHERE
  - Aggregations with GROUP BY
  - INNER and OUTER JOINs
  - Subqueries
  - JOINs combined with aggregate functions

## Example Queries
The project includes queries such as:
- Retrieving users based on name conditions
- Counting comments per article
- Listing authors by category
- Displaying tags including those without associated articles
- Finding the most active author
- Calculating average article views per category

## Triggers
The database includes triggers that automate core behavior:
- Automatically incrementing article view counts
- Updating user interest levels when articles are liked
- Increasing interest levels when articles are bookmarked

These triggers help simulate real application logic directly at the database level.

## Stored Procedure
A stored procedure (`pay_moderators`) demonstrates the use of cursors:
- Iterates through all moderators
- Calculates monthly payments
- Applies bonuses based on moderation activity
- Prevents duplicate payments within the same month

## Technologies Used
- MySQL
- SQL (DDL, DML, triggers, procedures)
- ER modeling

## How to Run
1. Create a new MySQL database
2. Execute `news.sql` to create tables, triggers, and procedures
3. (Optional) Insert sample data
4. Run queries from `news_queries.sql`

## What This Project Demonstrates
- Practical relational database design
- Writing readable and maintainable SQL
- Use of advanced SQL features (triggers, cursors, procedures)
- Translating application requirements into a structured data model
