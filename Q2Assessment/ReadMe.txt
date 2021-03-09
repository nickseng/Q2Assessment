1. Setting up the database
	- Create a new database using sql server 
	- Run the CreationScript.sql to initialize and populate the master tables, stored procedures and views
2. Setting up the connection
	- Open up web.config
	- under configuration->appSettings, change the ConnectionString entry to point to the database you've set up above
3. Compile and Run the project. (This can be done using IISExpress)

=================================================================================
REST API
=================================================================================
1. URL : api/household

    Household Entity:
    [
      {
        "ID": 1,
        "HousingType": "HDB",
        "FamilyMembers": [
          {
            "ID": 1,
            "Name": "Jack",
            "Gender": "Male",
            "MaritalStatus": "Married",
            "OccupationType": "Unemployed",
            "SpouseName": "Mary",
            "AnnualIncome": 0,
            "DateOfBirth": "19-07-30T00:00:00",
            "Age": 41
          },
          {
            "ID": 9,
            "Name": "Mary",
            "Gender": "Female",
            "MaritalStatus": "Married",
            "OccupationType": "Employed",
            "SpouseName": "Jack",
            "AnnualIncome": 60000,
            "DateOfBirth": "1978-03-15T00:00:00",
            "Age": 42
          },
          {
            "ID": 18,
            "Name": "Jill",
            "Gender": "Female",
            "MaritalStatus": "Single",
            "OccupationType": "Unemployed",
            "SpouseName": "",
            "AnnualIncome": 0,
            "DateOfBirth": "2015-07-18T00:00:00",
            "Age": 5
          }
        ],
        "HouseholdSize": 3
      }
    ]


2. CRUD operations

    -    GET  : api/household/
	     - returns all households in the database

    -    GET  : api/household/{id}
	    - returns a household with the specified id

    -   POST  : api/household/
        - creates a household with the following parameters
        {
            "HousingType": "HDB"
        }

    -   POST  : api/household/{id}
        - creates a family member and adds it to the household with id = {id}
        {
              "Name": "Mary",
              "Gender": "Female",
              "MaritalStatus": "Single",
              "OccupationType": "Student",
              "SpouseName": "",
              "AnnualIncome": 0,
              "DateOfBirth": "1999-01-25T00:00:00"
        }

    -   DELETE  : api/household/{id}
        - deletes a household with id = {id}

    -   DELETE  : api/household/member/{id}
        - deletes a family member with id = {id}

3. Search Operations
    - GET   : api/household/search?querystring
        -   performs searches for households that matches the criteria in the querystring
       
       Valid query strings:
            Age
            - age
                int value
            - age_operator
                search operator value
            These 2 querystring work together to form a search for a household where a family member matches the age and it's operator

            Household Income (i.e total annual income of all the family members in the household)
            - household_income
                decimal value
            - household_income_operator
                search operator value
            These 2 querystring work together to form a search for a household where the household income matches the household income and it's operator

            Annual Income
            - annual_income
                decimal value
            - annual_income_operator
                search operator value
            These 2 querystring work together to form a search for a household where a family member matches the annual income and it's operator

            Housing Type
            - housing_type
                string value
            - housing_type_operator
                search operator value
            These 2 querystring work together to form a search for a household where the household matches the housing type and it's operator
            The operator only works on equal and not equal. Any other value will be defaulted to Equal

            Household Size (Number of family members in a household)
            - household_size
                int value
            - size_operator
                search operator value
            These 2 querystring work together to form a search for a household where the household matches the household size and it's operator

            Has Married couple
            - has_married_couple
                true or false value
            Searches for household that either contain or not a married couple

            Schemes
            - scheme
                string value
            Predefined scheme that searches uses predefined criteria. For example, scheme=seb will perform a search where household income is less than 150,000 and has a family member younger than 16
            Valid values are "seb", "fts", "eb", "bsg", "ygg". They correspond to "Student Encouragement Bonus", "Family Togetherness Scheme", "Elder Bonus", "Baby Sunshine Grant", "YOLO GST Grant"
            Any values other than the defined ones above will return an empty list
            It's possible to map these schemes in a config file so that more schemes can be predefined.


        Search Operators
            These are a predefined enumerated representation of operators to use with it's corresponding query strings
            Values are:
                1           Less Than (<)
                2           Less Than Or Equal (<=)
                3           Greater Than (>)
                4           Greater Than Equal (>=)
                5           Equal (=)
                6           Not Equal (!=)

            missing search operators, or invalid search operator values will default the operator to Equals (=)


        Sample search query
            - api/household/search?age=12&age_operator=3&housing_type=landed
            This search will return a list of landed households with family members older than 12

            - api/household/search?household_income=200000&household_income_operator=1&has_married_couple="true"
            This search will return a list of households that has a married couple and household income less than $200,000

            - api/household/search?scheme=eb
            This search will return a list of households that qualify for an elder bonus


