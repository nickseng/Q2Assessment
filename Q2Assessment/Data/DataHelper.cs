using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Q2Assessment.Data
{
    /// <summary>
    /// Helper class that perfoms the actual database operations
    /// Helps to separate the data layer from the logic
    /// </summary>
    public class DataHelper
    {
        private string _connString = null;
        private SqlDataReader _reader = null;
        private SqlConnection _conn = null;
        private SqlCommand _cmd = null;
        private int _createdID = 0;
        private string _message = string.Empty;
        private Dictionary<string, object> _params;


        public DataHelper()
        {
            _connString = ConfigurationManager.AppSettings["ConnectionString"];
            _params = new Dictionary<string, object>();
        }

        #region Properties
        public SqlDataReader Reader
        {
            get
            {
                return _reader;
            }
        }

        public int CreatedID 
        { 
            get
            {
                return _createdID;
            }
        }

        public string Message
        {
            get
            {
                return _message;
            }
        }

        public Dictionary<string,object> Params
        {
            get
            {
                return _params;
            }
        }
        #endregion

        /// <summary>
        /// Executes the sql query/stored procedure
        /// </summary>
        /// <param name="cmdText">query/sp</param>
        /// <param name="cmdType">specifies where this is a standard query, or stored proc</param>
        public void ExecuteSQL(string cmdText, CommandType cmdType)
        {
            ExecuteSQL(cmdText, cmdType,  false);
        }

        /// <summary>
        /// Executes the sql query/stored procedure
        /// </summary>
        /// <param name="cmdText">query/sp</param>
        /// <param name="cmdType">specifies where this is a standard query, or stored proc</param>
        /// <param name="hasOutput">if true, passes the standard output parameters</param>
        public void ExecuteSQL(string cmdText, CommandType cmdType, bool hasOutput)
        {
            try
            {
                _conn = new SqlConnection(_connString);
                _conn.Open();
                _cmd = new SqlCommand(cmdText, _conn);
                _cmd.CommandType = cmdType;

                foreach (var param in Params)
                {
                    _cmd.Parameters.AddWithValue(param.Key, param.Value);
                }

                if (hasOutput)
                {
                    SqlParameter p = new SqlParameter();
                    p.ParameterName = "@CreatedID";
                    p.Direction = ParameterDirection.Output;
                    p.DbType = DbType.Int32;
                    _cmd.Parameters.Add(p);

                    p = new SqlParameter();
                    p.ParameterName = "@Message";
                    p.Direction = ParameterDirection.Output;
                    p.DbType = DbType.String;
                    p.Size = 50;
                    _cmd.Parameters.Add(p);

                }

                _reader = _cmd.ExecuteReader(CommandBehavior.CloseConnection);

                if (hasOutput)
                {
                    _createdID = (_cmd.Parameters["@CreatedID"].Value as int?) ?? 0;
                    _message = _cmd.Parameters["@Message"].Value.ToString();
                }


            }
            catch (Exception ex)
            {
                _createdID = 0;
                _message = ex.Message;
                _conn.Close();
            }
        }




    }
}