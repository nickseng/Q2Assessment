//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace HouseholdDataAccess
{
    using System;
    
    public partial class SP_GetHouseholdByID_Result
    {
        public int ID { get; set; }
        public string Housing_Type { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public string Occupation_Type { get; set; }
        public string Marital_Status { get; set; }
        public string Spouse_Name { get; set; }
        public Nullable<decimal> Annual_Income { get; set; }
        public Nullable<System.DateTime> Date_Of_Birth { get; set; }
    }
}
