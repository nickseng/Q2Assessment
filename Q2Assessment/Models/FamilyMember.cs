using System;

namespace Q2Assessment.Models
{
    public class FamilyMember
    {
        private int _age = -1;
        public int ID { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public string MaritalStatus { get; set; }
        public string OccupationType { get; set; }
        public string SpouseName { get; set; }
        public decimal AnnualIncome { get; set; }
        public DateTime DateOfBirth { get; set; }
        
        /// <summary>
        /// readonly value. Used as calculated display value
        /// </summary>
        public int Age
        {
            get
            {
                if (_age == -1)
                {
                    if (DateOfBirth != null && DateOfBirth != DateTime.MinValue)
                    {
                        _age = DateTime.Now.Year - DateOfBirth.Year;

                        if (DateOfBirth.Date > DateTime.Now.AddYears(-_age))
                            _age--;
                    }
                }

                return _age;
            }
            set { _age = value; }
        }

    }
}