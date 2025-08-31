# Employee_Hierarchy_Generation
📖 Overview  The Employee Hierarchy SQL Project demonstrates how to build and manage organizational hierarchies using Recursive CTEs and Stored Procedures in SQL. It extracts hierarchical relationships (manager → employee), generates reporting levels, and stores the results in a structured table for easier querying and visualization.

🚀 Key Highlights

🔄 Recursive CTE – Build hierarchical relationships dynamically.

🧑‍💼 Manager → Employee Mapping – Identify direct and indirect reporting chains.

📊 Hierarchy Levels – Assign levels (1 = top-level manager, 2 = direct report, etc.).

✉️ Employee Details – Extract employee names from email IDs.

🗄️ Stored Procedure – Automate hierarchy generation with a single procedure call.

🛠️ Tools & Technologies

Database: MySQL / SQL Server

SQL Concepts: Recursive CTEs, Stored Procedures, Joins, Substring functions

Tables Used:

EMPLOYEE_MASTER → Source table with employee data

Employee_Hierarchy → Output hierarchy table

📂 Project Structure
project/
│── hierarchy_procedure.sql        # SQL script with procedure & CTE  
│── employee_master_table.sql      # Sample employee dataset  
│── employee_hierarchy_output.sql  # Example query outputs  
│── README.md  

▶️ Usage

Import the EMPLOYEE_MASTER table with sample employee data.

Run the script hierarchy_procedure.sql to create the stored procedure.

Call the procedure:

CALL SP_hierarchyF();

Query the Employee_Hierarchy table to explore manager–employee reporting chains.

<img width="1920" height="1080" alt="Screenshot 2025-08-31 132034" src="https://github.com/user-attachments/assets/bae595c7-80f9-467d-9619-c99f5d76d70b" />


🔮 Future Enhancements

Add role-based hierarchy mapping (e.g., Department Heads, Team Leads).

Integrate with Power BI/Tableau for hierarchy visualization.

Automate data refresh for dynamic org charts.

Support multi-level reporting structures with custom rules.

📜 License

This project is licensed under the MIT License – open for use & modification.
