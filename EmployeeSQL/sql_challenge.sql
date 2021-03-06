-- sql-challenge, assignment 09
-- steps are listed below in comments

-- Use the information you have to create a table schema for each of the six CSV files. 
	-- Remember to specify data types, primary keys, foreign keys, and other constraints.
CREATE TABLE "departments" (
    "dept_no" VARCHAR NOT NULL PRIMARY KEY,
    "dept_name" VARCHAR(255)   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL PRIMARY KEY,
    "birth_date" VARCHAR(255)   NOT NULL,
    "first_name" VARCHAR(255)   NOT NULL,
    "last_name" VARCHAR(255)   NOT NULL,
    "gender" VARCHAR(20)   NOT NULL,
    "hire_date" VARCHAR(255)   NOT NULL
);

CREATE TABLE "dept_emp" (
	"emp_no" INTEGER NOT NULL,
	"dept_no" VARCHAR NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    "from_date" VARCHAR(255)   NOT NULL,
    "to_date" VARCHAR(255)   NOT NULL
);

CREATE TABLE "dept_manager" (
	"dept_no" VARCHAR NOT NULL,
	"emp_no" INTEGER NOT NULL,
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    "from_date" VARCHAR(255)   NOT NULL,
    "to_date" VARCHAR(255)   NOT NULL
);

CREATE TABLE "salaries" (
	"emp_no" INTEGER NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    "salary" MONEY   NOT NULL,
    "from_date" VARCHAR(255)   NOT NULL,
    "to_date" VARCHAR(255)   NOT NULL
);

CREATE TABLE "titles" (
	"emp_no" INTEGER NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    "title" VARCHAR(255)   NOT NULL,
    "from_date" VARCHAR(255)   NOT NULL,
    "to_date" VARCHAR(255)   NOT NULL
);

--* Import each CSV file into the corresponding SQL table.

-- Once you have a complete database, do the following:

	-- List the following details of each employee: 
		-- employee number, last name, first name, gender, and salary.
		
SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary
FROM employees AS e
LEFT JOIN salaries AS s ON e.emp_no = s.emp_no
ORDER BY e.emp_no;

	-- List employees who were hired in 1986.
	
SELECT * FROM employees AS e
WHERE e.hire_date LIKE '1986%';

	-- List the manager of each department with the following information: 
		--department number, department name, the manager's employee number, last name, first name, and start and end employment dates.

SELECT d_m.dept_no, d.dept_name, d_m.emp_no, e.last_name, e.first_name, d_m.from_date as "start_date", d_m.to_date as "end_date"
FROM dept_manager AS d_m
LEFT JOIN departments AS d ON d_m.dept_no = d.dept_no
LEFT JOIN employees AS e ON d_m.emp_no = e.emp_no
ORDER BY d_m.dept_no;

	-- List the department of each employee with the following information: 
		-- employee number, last name, first name, and department name.
		
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
LEFT JOIN dept_emp AS d_e ON e.emp_no = d_e.emp_no
LEFT JOIN departments AS d ON d_e.dept_no = d.dept_no
ORDER BY e.emp_no;

	-- List all employees whose first name is "Hercules" and last names begin with "B."
	
SELECT * FROM employees AS e
WHERE e.first_name = 'Hercules'
AND e.last_name LIKE 'B%';

	-- List all employees in the Sales department, 
		-- including their employee number, last name, first name, and department name.
		
-- The below method is using subqueries to solve the Sales department question.
	-- SELECT * FROM employees AS e
	-- WHERE e.emp_no IN (
	-- 	SELECT d_e.emp_no FROM dept_emp AS d_e WHERE d_e.dept_no = (
	-- 		SELECT d.dept_no FROM departments AS d WHERE d.dept_name = 'Sales'
	-- 	)
	-- );
-- The below method is using JOIN to solve the Sales department question.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
LEFT JOIN dept_emp AS d_e ON e.emp_no = d_e.emp_no
LEFT JOIN departments AS d ON d_e.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'
ORDER BY e.emp_no;

	-- List all employees in the Sales and Development departments, 
		-- including their employee number, last name, first name, and department name.
		
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
LEFT JOIN dept_emp AS d_e ON e.emp_no = d_e.emp_no
LEFT JOIN departments AS d ON d_e.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development'
ORDER BY e.emp_no;

	-- In descending order, list the frequency count of employee last names, 
		-- i.e., how many employees share each last name.
		
SELECT e.last_name, COUNT(*)
FROM employees AS e
GROUP BY e.last_name
ORDER BY COUNT DESC;




-- Search ID Number for Easter Egg; displays all columns:
SELECT * FROM employees AS e
LEFT JOIN salaries AS s ON s.emp_no = e.emp_no
LEFT JOIN dept_emp AS d_e ON d_e.emp_no = e.emp_no
LEFT JOIN departments AS d ON d.dept_no = d_e.dept_no
WHERE e.emp_no = '499942';


-- Analysis: I feel as though April Foolsday should have the birth date 4/1/1963, do the following to amend:
	-- UPDATE employees SET birth_date = '1963-04-01' WHERE first_name = 'April' AND last_name = 'Foolsday';
