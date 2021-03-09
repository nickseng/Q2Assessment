
using System.Collections.Generic;
using System.Linq;


namespace Q2Assessment.Models
{
    public class Household
    {
        private int _size = 0;
        private decimal _householdIncome = -1;
        public int ID { get; set; } 
        public string HousingType { get; set; }
        public List<FamilyMember> FamilyMembers { get; set; }
        /// <summary>
        /// readonly value. calculate household size
        /// </summary>
        public int HouseholdSize
        {
            get
            {
                if (_size == 0)
                {
                    if (FamilyMembers != null)
                        _size = FamilyMembers.Count;
                }
                return _size;
            }
            set
            {
                _size = value;
            }
        }

        /// <summary>
        /// readonly value. Used to sum up total income from family members in the household
        /// </summary>
        public decimal HouseholdIncome
        {
            get
            {
                if (_householdIncome == -1)
                    _householdIncome = FamilyMembers.Sum(x => x.AnnualIncome);
                
                return _householdIncome;
            }
            set
            {
                _householdIncome = value;
            }
        }

        public Household()
        {
            FamilyMembers = new List<FamilyMember>();
        }
    }
}