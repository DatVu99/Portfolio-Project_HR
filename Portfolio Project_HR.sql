Select Top 100 * 
From HR_project..HRDataset_v14$

-- Clean data
		-- Duplicate

-- Employee name & ID
						Select employee_name, EmpID, count(Employee_Name)
						From HRDataset_v14$
						Group by Employee_Name, EmpID
						Having count(Employee_Name) > 1

						Select employee_name, EmpID, count(EmpID)
						From HRDataset_v14$
						Group by Employee_Name, EmpID
						Having count(EmpID) > 1
	-- -> No duplicate

--Married status
						Select Distinct(MaritalStatusID), MaritalDesc
						From HRDataset_v14$
					-- -> No duplicate

-- GenderID
						Select Distinct(GenderID), Sex
						From HRDataset_v14$
					-- -> No duplicate

-- Department

						 Select distinct(a.DeptID), b.Department
						 From HR_project..HRDataset_v14$ a
						 Join HR_project..HRDataset_v14$ b
						 on a.DeptID = b.DeptID

	-- Found the Prouduction department & Sofware Engineering have 02 DeptID -> 
		-- Check the Production 
						Select Employee_Name, EmpID, DeptID, Department, ManagerName
						From HR_project..HRDataset_v14$
						where DeptID = 5 or DeptID = 6 --(Production)
						order by DeptID desc

		-- Found a case whose empID = 10311 (Dee.Randy) have the DeptID = 6 but Department is Production (Production has DeptID = 5) 
				-- -> Change to 5 
						Update HRDataset_v14$
						Set DeptID = 5
						where EmpID = 10311
	
				-- -> Check the Software department
			 			Select Employee_Name, EmpID, DeptID, Department
						From HRDataset_v14$
						where DeptID = 1
						order by DeptID desc
			-- A casse whose empID = 10131 (Quinn) habe the DeptID = 1 but Department is Software Engineering (Software Engineering = 4)
				-- -> Check position
						Select Employee_Name, EmpID, DeptID, Department, Position, sex
						From HRDataset_v14$
						where EmpID = 10131
				-- -> He is a software enginneer, change the DeptID = 4
						Update HRDataset_v14$
						Set DeptID = 4
						where EmpID = 10131
				-- -> Re-check
						Select distinct(a.DeptID), b.Department
						From HRDataset_v14$ a
						Join HRDataset_v14$ b
						on a.DeptID = b.DeptID

-- PerfScoreID
					Select PerfScoreID, PerformanceScore
					From HRDataset_v14$
					order by PerformanceScore
				
					Select PerfScoreID, PerformanceScore
					From HRDataset_v14$
					order by PerformanceScore
		
					update HRDataset_v14$
					Set PerfScoreID = 1
					where PerformanceScore = 'PIP'


--Termd
					Select Employee_Name, EmpID, termd, EmploymentStatus, DateofTermination
					From HR_project..HRDataset_v14$
					order by termd


--PositionID
--(need to check duplicate (stuck -> haven't done)
					Select a.PositionID, b.Position, a.employee_Name, a.EmpID
					From HR_project..HRDataset_v14$ a
					join HR_project..HRDataset_v14$ b
					on a.PositionID = b.PositionID
					where a.positionId = b.PositionID and a.position <> b.position

					Select *
					From HR_project..HRDataset_v14$
					where PositionID = 23 or PositionID = 24
					order by PositionID

					Update HR_project..HRDataset_v14$
					set PositionID = 24
					where Position like 'soft%'



-- DOB
					Select Employee_name
							,DOB
							,DATEPART(Year,CURRENT_TIMESTAMP) - DATEPART(year,dob) as age
					From HR_project..HRDataset_v14$
					order by age
					
					Alter table HR_project..HRDataset_v14$
					add Age numeric

					insert into HR_project..HRDataset_v14$ (age)
					Select DATEPART(Year,CURRENT_TIMESTAMP) - DATEPART(year,dob)
					from HR_project



-- Sex
					Select distinct(sex)
					from HR_project..HRDataset_v14$

-- HispanicLatino
					Select distinct(HispanicLatino)
					From HR_project..HRDataset_v14$

--Manager name

					Select t.ManagerID, t.ManagerName, t.Find_duplicate
					From (
							Select d.ManagerID, d.ManagerName,
									ROW_NUMBER () over (partition by d.managername order by d.managerid) as Find_duplicate
								From (
										Select distinct(ManagerID), ManagerName
										From HR_project..HRDataset_v14$) 
										d 
									) 
									t
					Where t.Find_duplicate > 1

			-- -> Find 3 cases have wrong managerID: 
			--		+ Brandon R.leblanc ID = 3 
			--		+ Michael Albert ID = 30
			--		+ Webster Bulter ID = 39

					Select *
					From HR_project..HRDataset_v14$
					Where ManagerName like 'Brandon%'

					Update HR_project..HRDataset_v14$
					Set ManagerID = 1 
					where ManagerName like 'brandon%'


					Select *
					From HR_project..HRDataset_v14$
					Where ManagerName like 'Michael%'

					Update HR_project..HRDataset_v14$
					Set ManagerID = 22
					where ManagerName like 'Michael%'

					Select *
					From HR_project..HRDataset_v14$
					where ManagerName like 'Webster%'
					-- -> Found that there are two managerID for managername 'Webster' 
					--			+ Null - for all active employee
					--			+ 39 - for terminated employee


-- RaceDessc
					Select distinct(racedesc)
					From HR_project..HRDataset_v14$


-- Date of hire & Date of termination
					Select DateofHire, DateofTermination, (cast(DateofTermination as float) - cast(DateofHire as float))/30 as Working_time, TermReason, EmploymentStatus
					From HR_project..HRDataset_v14$
					Where DateofTermination is not null


-- Last_Performance_Review
					Select distinct(year(LastPerformanceReview_Date)) as year_of_performance,
							month(LastPerformanceReview_Date) as month_of_p
					from HR_project..HRDataset_v14$


					Select DateofTermination, TermReason, EmploymentStatus
					From HR_project..HRDataset_v14$
					where DateofTermination is null



----- Create alter table

	--Employee personal Table
	Drop table if exists Employee_Personal_Infor
	Create table Employee_Personal_Infor
				(Employee_Name nvarchar(255)
				,EmpID float
				,MaritalDesc nvarchar(255)
				,Sex nvarchar(255)
				,DOB datetime
				,Citizen nvarchar(255)
				,HispanicLatino nvarchar(255)
				,Racedesc nvarchar(255)
				,Position nvarchar(255)
				,Department nvarchar(255))

	Insert into Employee_Personal_Infor (Employee_Name, EmpID, MaritalDesc, Sex, DOB, Citizen, HispanicLatino, Racedesc, Position, Department)
	Select Employee_Name, EmpID, MaritalDesc, Sex, DOB, CitizenDesc, HispanicLatino, RaceDesc, Position, Department
	From HR_project..HRDataset_v14$

	Select *
	from Employee_Personal_Infor


	-- Create subtable Married
	Drop table if exists Married_Infor
	Create table Married_Infor
			(
			 Married_Status float
			 ,Married_Description nvarchar(255)
			 ,Married_ID float)

	Insert into Married_Infor (Married_Description, Married_Status, Married_ID)
	Select distinct( MaritalDesc), MaritalStatusID, MarriedID
	From HR_project..HRDataset_v14$
	order by MaritalStatusID

	Select * 
	From Married_Infor
	order by Married_Status

	--Create subtable GenderID
	Drop table if exists Gender
	Create table Gender
			(Gender_ID float
			,Gender nvarchar(255))

	Insert into Gender
	Select Distinct(GenderID), Sex
	From HR_project..HRDataset_v14$

	Select *
	From Gender


	--Create subtale Department
	Drop table if exists Department
	Create table Department
				(Department_ID float
				,Department_Discription nvarchar(255))

	Insert into Department
	Select Distinct(DeptID), Department
	From HR_project..HRDataset_v14$

	Select *
	From Department


