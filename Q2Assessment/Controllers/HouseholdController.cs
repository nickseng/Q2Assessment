using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Q2Assessment.Models;

namespace Q2Assessment.Controllers
{
    public class HouseholdController : ApiController
    {
        private Households _households = new Households();
        // GET api/<controller>
        public IEnumerable<Household> Get()
        {
            _households.GetAllHouseholds();
            return _households.HouseholdList ;
        }

        // GET api/<controller>/5
        public HttpResponseMessage Get(int id)
        {
            _households.GetHouseholdByID(id);

            if (_households.HouseholdList.Exists(x => x.ID == id))
            {
                return Request.CreateResponse(HttpStatusCode.OK, _households.HouseholdList);                
            }

            return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Format("Household id: {0} was not found", id));
        }


        [HttpGet]
        [Route("api/household/search")]
        public HttpResponseMessage Search([FromUri] HouseholdSearches query)
        {
            if (query == null)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "Invalid query strings");
            }

            var res = _households.PerformSearches(query);

            return Request.CreateResponse(HttpStatusCode.OK, res);
        }

        // POST api/<controller>
        public HttpResponseMessage Post([FromBody] Household value)
        {
            if (value == null)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "Invalid Household");
            }

            if (string.IsNullOrEmpty(value?.HousingType))
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest,"Housing Type cannot be blank");
            }

            //create new household  
            string result;
            int id = _households.CreateHousehold(value,out result);
            value.ID = id;
            if (id == 0)
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, result);
            else
                return Request.CreateResponse(HttpStatusCode.Created, value);
        }

        //POST api/<controller>/5
        public HttpResponseMessage Post(int id, FamilyMember value)
        {
            string result;

            if (value == null)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "Invalid Family Member");
            }

            int createdID = _households.AddFamilyMember(id, value, out result);
            value.ID = createdID;

            if (createdID == 0)
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, result);
            else
                return Request.CreateResponse(HttpStatusCode.Created, value);
        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<controller>/5
        public HttpResponseMessage Delete(int id)
        {
            string result;
            int deletedID = _households.DeleteHousehold(id, out result);

            if (deletedID == 0)
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, result);
            else
                return Request.CreateResponse(HttpStatusCode.OK, result);
        }
        [HttpDelete]
        [Route("api/household/member/{id}")]
        public HttpResponseMessage DeleteFamilyMember(int id)
        {
            string result;
            int deletedID = _households.DeleteFamilyMember(id, out result);

            if (deletedID == 0)
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, result);
            else
                return Request.CreateResponse(HttpStatusCode.OK, result);

        }


        #region Searches
      
        #endregion
    }
}