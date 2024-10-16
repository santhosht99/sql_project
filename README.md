# Famous Paintings & Museum -Data Analysis with SQL

## Project Overview
This project involves solving a series of SQL queries using the **Famous Paintings & Museum** dataset. The goal is to explore and analyze data related to paintings and museums, focusing on various aspects such as pricing, availability, and popularity.

## Dataset Description
The dataset contains information about:
- Paintings
- Museums
- Artists
- Canvas sizes
- Museum hours

### Key Tables
1. **Paintings**: Contains details about various paintings, including their titles, artists, and pricing.
2. **Museums**: Includes information about different museums and their locations.
3. **Artists**: Provides details about the artists who created the paintings.
4. **Canvas Sizes**: Lists the different canvas sizes available.
5. **Museum Hours**: Contains the operating hours for each museum.

## SQL Problems Solved
The following SQL problems were addressed in this project:

1. **Fetch all the paintings which are not displayed on any museums.**
   ```sql
   SELECT * FROM paintings WHERE museum_id IS NULL;
```
