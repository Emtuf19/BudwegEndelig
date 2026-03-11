using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace DigitalFølgeeddel
{
    public class EmployeeRepo
    {

        private readonly string connectionString;

        public EmployeeRepo()
        {
            IConfigurationRoot config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json")
                .Build();

            connectionString = config.GetConnectionString("MyDBConnection");
        }


        public List<Employee> GetAllWithStation()
        {
            List<Employee> employees = new List<Employee>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string sql = @"
                SELECT e.EmployeeId, e.EmployeeName, e.StationId,
                       s.StationId AS S_StationId, s.StationName AS S_StationName
                FROM Employees e
                INNER JOIN Stations s ON e.StationId = s.StationId
                ORDER BY s.StationName, e.EmployeeName";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        var emp = new Employee
                        {
                            EmployeeId = rd.GetInt32(rd.GetOrdinal("EmployeeId")),
                            EmployeeName = rd["EmployeeName"]?.ToString() ?? string.Empty,
                            StationId = rd.GetInt32(rd.GetOrdinal("StationId")),
                            Station = new Station
                            {
                                StationId = rd.GetInt32(rd.GetOrdinal("S_StationId")),
                                StationName = rd["S_StationName"]?.ToString() ?? string.Empty
                            }
                        };
                        employees.Add(emp);
                    }
                }
            }

            return employees;
        }


        public Employee? GetByIdWithStation(int id)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string sql = @"
                SELECT e.EmployeeId, e.EmployeeName, e.StationId,
                       s.StationId AS S_StationId, s.StationName AS S_StationName
                FROM Employees e
                INNER JOIN Stations s ON e.StationId = s.StationId
                WHERE e.EmployeeId = @id";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    var p = cmd.Parameters.Add("@id", SqlDbType.Int);
                    p.Value = id;

                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        if (rd.Read())
                        {
                            return new Employee
                            {
                                EmployeeId = rd.GetInt32(rd.GetOrdinal("EmployeeId")),
                                EmployeeName = rd["EmployeeName"]?.ToString() ?? string.Empty,
                                StationId = rd.GetInt32(rd.GetOrdinal("StationId")),
                                Station = new Station
                                {
                                    StationId = rd.GetInt32(rd.GetOrdinal("S_StationId")),
                                    StationName = rd["S_StationName"]?.ToString() ?? string.Empty
                                }
                            };
                        }
                    }
                }
            }

            return null;
        }
    }
}
