using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace WebApp
{
    public class DataConnection : IDisposable
    {
        protected SqlConnection _conn;

        public DataConnection()
        {
            _conn = new SqlConnection(ConfigurationManager.ConnectionStrings["db"].ConnectionString);
        }

        public void Dispose()
        {
            if (_conn != null && _conn.State == ConnectionState.Open)
                _conn.Close();
        }

        public SqlConnection Session
        {
            get
            {
                if (_conn.State != ConnectionState.Open) _conn.Open();
                return _conn;
            }
        }
    }
}