using System;
using System.Collections.Generic;
using System.Linq;
using Q2Assessment.Data;

namespace Q2Assessment.Models
{
    /// <summary>
    /// Wrapper around a household list
    /// Also includes helper methods to perfom operations on the household list
    /// </summary>
    public class Households
    {
        private DataHelper helper;
        public List<Household> HouseholdList { get; }

        public Households()
        {
            HouseholdList = new List<Household>();
        }

        /// <summary>
        /// returns all households and their corresponding family member
        /// </summary>
        public void GetAllHouseholds()
        {
            helper = new DataHelper();
            helper.ExecuteSQL("Select * FROM VW_AllHouseholds", System.Data.CommandType.Text);

            PopulateHousehold();
        }

        /// <summary>
        /// Gets a specific household by it's id
        /// </summary>
        /// <param name="ID"></param>
        public void GetHouseholdByID(int ID)
        {
            helper = new DataHelper();
            helper.Params.Add("@HouseholdID", ID);

            helper.ExecuteSQL("SP_GetHouseholdByID", System.Data.CommandType.StoredProcedure);

            PopulateHousehold();
        }

        /// <summary>
        /// creates a household
        /// </summary>
        /// <param name="model">Household entity to insert into db</param>
        /// <param name="result">message</param>
        /// <returns>created id</returns>
        public int CreateHousehold(Household model, out string result)
        {
            helper = new DataHelper();
            helper.Params.Add("@HousingType", model.HousingType);

            helper.ExecuteSQL("SP_CreateHousehold", System.Data.CommandType.StoredProcedure, true);

            result = helper.Message;
            return helper.CreatedID;
        }


        /// <summary>
        /// Creates a family member, and adds it into an existing household
        /// </summary>
        /// <param name="HouseholdID">ID of the household to add to</param>
        /// <param name="member">FamilyMember entity to insert into db</param>
        /// <param name="result">message</param>
        /// <returns>created id</returns>
        public int AddFamilyMember(int HouseholdID, FamilyMember member, out string result)
        {
            helper = new DataHelper();
            helper.Params.Add("@HouseholdID", HouseholdID);
            helper.Params.Add("@Name", member.Name);
            helper.Params.Add("@Gender", member.Gender);
            helper.Params.Add("@MaritalStatus", member.MaritalStatus);
            helper.Params.Add("@OccupationType", member.OccupationType);
            helper.Params.Add("@SpouseName", member.SpouseName);
            helper.Params.Add("@AnnualIncome", member.AnnualIncome);
            helper.Params.Add("@DateOfBirth", member.DateOfBirth);

            helper.ExecuteSQL("SP_AddFamilyMemberToHousehold", System.Data.CommandType.StoredProcedure, true);

            result = helper.Message;

            return helper.CreatedID;
        }
        //only use after executesql is called

        /// <summary>
        /// Performs search/filter based on the search parameters
        /// </summary>
        /// <param name="searchParams">Search parameters</param>
        /// <returns>List of households that matches the parameters given</returns>
        public List<Household> PerformSearches(HouseholdSearches searchParams)
        {
            GetAllHouseholds();
            var result = HouseholdList;

            //if scheme exists, ignore every other parameter and use a predetermined parameter
            if (searchParams.Scheme != null)
            {
                HouseholdSearches newParams = new HouseholdSearches();
                switch (searchParams.Scheme.ToLower())
                {
                    case "seb":
                        newParams.Household_Income = "150000";
                        newParams.Household_Income_Operator = SearchOperator.LessThan;
                        newParams.Age = "16";
                        newParams.Age_Operator = SearchOperator.LessThan;
                        break;
                    case "fts":
                        newParams.Age = "18";
                        newParams.Age_Operator = SearchOperator.LessThan;
                        newParams.Has_Married_Couple = "true";
                        break;
                    case "eb":
                        newParams.Housing_Type = "hdb";
                        newParams.Housing_Type_Operator = SearchOperator.Equal;
                        newParams.Age = "50";
                        newParams.Age_Operator = SearchOperator.GreaterThan;
                        break;
                    case "bsg":
                        newParams.Age = "5";
                        newParams.Age_Operator = SearchOperator.LessThan;
                        break;
                    case "ygg":
                        newParams.Housing_Type = "hdb";
                        newParams.Housing_Type_Operator = SearchOperator.Equal;
                        newParams.Annual_Income = "100000";
                        newParams.Annual_Income_Operator = SearchOperator.LessThan;
                        break;
                    default: //invalid scheme, return no records
                        return new List<Household>();

                }
                searchParams = newParams;

            }

            if (searchParams.Age != null)
            {
                if (int.TryParse(searchParams.Age, out int age))
                {
                    result = FilterByAge(age, (SearchOperator)searchParams.Age_Operator, result);
                }
            }

            if (searchParams.Housing_Type != null)
            {
                result = FilterByHousingType(searchParams.Housing_Type, (SearchOperator)searchParams.Housing_Type_Operator, result);
            }

            if (searchParams.Household_Income != null)
            {
                if (decimal.TryParse(searchParams.Household_Income, out decimal income))
                {
                    result = FilterByHouseholdIncome(income, (SearchOperator)searchParams.Household_Income_Operator, result);
                }
            }

            if(searchParams.Annual_Income != null)
            {
                if (decimal.TryParse(searchParams.Annual_Income, out decimal income))
                {
                    result = FilterByAnnualIncome(income, (SearchOperator)searchParams.Annual_Income_Operator, result);
                }
                
            }

            if (searchParams.Household_Size != null)
            {
                if (int.TryParse(searchParams.Household_Size, out int size))
                {
                    result = FilterByHouseholdSize(size, (SearchOperator)searchParams.Size_Operator, result);
                }
            }

            if (searchParams.Has_Married_Couple != null)
            {
                if (bool.TryParse(searchParams.Has_Married_Couple, out bool hasMarriedCouple))
                {
                    result = FilterByMarriedCouple(hasMarriedCouple, result);
                }
            }

            return result;

        }

        /// <summary>
        /// Deletes a household 
        /// </summary>
        /// <param name="ID">ID of the household to delete</param>
        /// <param name="result">message</param>
        /// <returns></returns>
        public int DeleteHousehold(int ID, out string result)
        {
            helper = new DataHelper();
            helper.Params.Add("@HouseholdID", ID);

            helper.ExecuteSQL("SP_DeleteHousehold", System.Data.CommandType.StoredProcedure, true);
            result = helper.Message;

            return helper.CreatedID;
        }

        /// <summary>
        /// Deletes a family member
        /// </summary>
        /// <param name="ID">ID of the family member to delete</param>
        /// <param name="result">message</param>
        /// <returns></returns>
        public int DeleteFamilyMember(int ID, out string result)
        {
            helper = new DataHelper();
            helper.Params.Add("@MemberID", ID);

            helper.ExecuteSQL("SP_DeleteFamilyMember", System.Data.CommandType.StoredProcedure, true);
            result = helper.Message;

            return helper.CreatedID;
        }

        /// <summary>
        /// Populates the Household list based on the query performed.
        /// </summary>
        private void PopulateHousehold()
        {
            Household household;
            FamilyMember member;
            using (System.Data.SqlClient.SqlDataReader reader = helper.Reader)
            {
                while (reader.Read())
                {
                    household = HouseholdList.Where(x => x.ID == (int)reader["ID"]).FirstOrDefault();
                    if (household == null)
                    {
                        household = new Household();
                        household.ID = (int)reader["ID"];
                        HouseholdList.Add(household);
                    }

                    household.HousingType = reader["Housing TYpe"].ToString();

                    member = new FamilyMember();
                    member.ID = (reader["Member ID"] as int?) ?? 0;
                    if (member.ID != 0)
                    {
                        member.Name = reader["Name"].ToString();
                        member.Gender = reader["Gender"].ToString();
                        member.MaritalStatus = reader["Marital Status"].ToString();
                        member.OccupationType = reader["Occupation Type"].ToString();
                        member.SpouseName = reader["Spouse Name"].ToString();
                        member.AnnualIncome = (reader["Annual Income"] as decimal?) ?? 0;
                        member.DateOfBirth = (reader["Date of Birth"] as DateTime?) ?? DateTime.MinValue;


                        household.FamilyMembers.Add(member);
                    }
                }
            }
        }


        private List<Household> FilterByAge(int age, SearchOperator oper, List<Household> lst)
        {
            List<Household> result;

            switch (oper)
            {
                case SearchOperator.GreaterThan:
                    result = lst.Where(x => x.FamilyMembers.Any(f => f.Age > age)).ToList();
                    break;
                case SearchOperator.GreaterThanOrEqual:
                    result = lst.Where(x => x.FamilyMembers.Any(f => f.Age >= age)).ToList();
                    break;
                case SearchOperator.LessThan:
                    result = lst.Where(x => x.FamilyMembers.Any(f => f.Age < age)).ToList();
                    break;
                case SearchOperator.LessThanOrEqual:
                    result = lst.Where(x => x.FamilyMembers.Any(f => f.Age <= age)).ToList();
                    break;
                case SearchOperator.NotEqual:
                    result = lst.Where(x => x.FamilyMembers.Any(f => f.Age != age)).ToList();
                    break;
                default: //defaults to Equals
                    result = lst.Where(x => x.FamilyMembers.Any(f => f.Age == age)).ToList();
                    break;

            }



            return result;
        }

        //Housing Type only filters by equal or not equal
        private List<Household> FilterByHousingType(string housingType, SearchOperator oper, List<Household> lst)
        {
            List<Household> result;


            switch (oper)
            {
                case SearchOperator.NotEqual:
                    result = lst.Where(x => x.HousingType != housingType).ToList();
                    break;
                default: //defaults to equal
                    result = lst.Where(x => x.HousingType.ToLower() == housingType.ToLower()).ToList();
                    break;
            }

            return result;

        }

        private List<Household> FilterByAnnualIncome(decimal income, SearchOperator oper, List<Household> lst)
        {
            List<Household> result;

            switch (oper)
            {
                case SearchOperator.GreaterThan:
                    result = lst.Where(x => x.FamilyMembers.Any(f => f.AnnualIncome > income)).ToList();
                    break;
                case SearchOperator.GreaterThanOrEqual:
                    result = lst.Where(x => x.FamilyMembers.Any(f => f.AnnualIncome >= income)).ToList();
                    break;
                case SearchOperator.LessThan:
                    result = lst.Where(x => x.FamilyMembers.Any(f => f.AnnualIncome < income)).ToList();
                    break;
                case SearchOperator.LessThanOrEqual:
                    result = lst.Where(x => x.FamilyMembers.Any(f => f.AnnualIncome <= income)).ToList();
                    break;
                case SearchOperator.NotEqual:
                    result = lst.Where(x => x.FamilyMembers.Any(f => f.AnnualIncome != income)).ToList();
                    break;
                default: //defaults to Equals
                    result = lst.Where(x => x.FamilyMembers.Any(f => f.AnnualIncome == income)).ToList();
                    break;
            }

            return result;
        }

        private List<Household> FilterByHouseholdIncome(decimal income, SearchOperator oper, List<Household> lst)
        {
            List<Household> result;

            switch (oper)
            {
                case SearchOperator.GreaterThan:
                    result = lst.Where(x => x.HouseholdIncome > income).ToList();
                    break;
                case SearchOperator.GreaterThanOrEqual:
                    result = lst.Where(x => x.HouseholdIncome >= income).ToList();
                    break;
                case SearchOperator.LessThan:
                    result = lst.Where(x => x.HouseholdIncome < income).ToList();
                    break;
                case SearchOperator.LessThanOrEqual:
                    result = lst.Where(x => x.HouseholdIncome <= income).ToList();
                    break;
                case SearchOperator.NotEqual:
                    result = lst.Where(x => x.HouseholdIncome != income).ToList();
                    break;
                default: //defaults to Equals
                    result = lst.Where(x => x.HouseholdIncome == income).ToList();
                    break;
            }

            return result;
        }

        private List<Household> FilterByHouseholdSize(int size, SearchOperator oper, List<Household> lst)
        {
            List<Household> result;

            switch (oper)
            {
                case SearchOperator.GreaterThan:
                    result = lst.Where(x => x.HouseholdSize > size).ToList();
                    break;
                case SearchOperator.GreaterThanOrEqual:
                    result = lst.Where(x => x.HouseholdSize >= size).ToList();
                    break;
                case SearchOperator.LessThan:
                    result = lst.Where(x => x.HouseholdSize < size).ToList();
                    break;
                case SearchOperator.LessThanOrEqual:
                    result = lst.Where(x => x.HouseholdSize <= size).ToList();
                    break;
                case SearchOperator.NotEqual:
                    result = lst.Where(x => x.HouseholdSize != size).ToList();
                    break;
                default: //defaults to Equals
                    result = lst.Where(x => x.HouseholdSize == size).ToList();
                    break;
            }

            return result;
        }

        private List<Household> FilterByMarriedCouple(bool hasMarriedCouple, List<Household> lst)
        {
            List<Household> result = lst;

            if (hasMarriedCouple)
            {
                result = lst.Where(x => x.FamilyMembers.Any(f => f.MaritalStatus.ToLower() == "married" && f.SpouseName != null)).ToList();
            }
            else
            {
                result = lst.Where(x => x.FamilyMembers.All(f => f.MaritalStatus.ToLower() != "married")).ToList();
            }

            return result;
        }
    }

    /// <summary>
    /// Entity to hold the search parameters
    /// </summary>
    public class HouseholdSearches
    {
        public string Age { get; set; }
        public SearchOperator Age_Operator { get; set; }

        public string Household_Income { get; set; }

        public SearchOperator Household_Income_Operator { get; set; }

        public string Annual_Income { get; set; }
        public SearchOperator Annual_Income_Operator { get; set; }
        public string Housing_Type { get; set; }

        public SearchOperator Housing_Type_Operator { get; set; }

        public string Household_Size { get; set; }

        public SearchOperator Size_Operator { get; set; }

        public string Has_Married_Couple { get; set; }

        public string Scheme { get; set; }
    }

    /// <summary>
    /// Enum of search operators
    /// </summary>
    public enum SearchOperator
    {
        LessThan = 1,
        LessThanOrEqual,
        GreaterThan,
        GreaterThanOrEqual,
        Equal,
        NotEqual
    }


}