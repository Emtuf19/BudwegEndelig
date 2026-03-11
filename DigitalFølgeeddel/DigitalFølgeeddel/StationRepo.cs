using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Configuration.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace DigitalFølgeeddel
{
    public class StationRepo
    {

        private readonly string connectionString;

        public StationRepo()
        {
            IConfigurationRoot config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json")
                .Build();

            connectionString = config.GetConnectionString("MyDBConnection");
        }

        // GET ALL
        public List<Station> GetAll()
        {
            List<Station> stations = new List<Station>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                string sql = "SELECT StationId, StationName FROM Stations";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        Station s = new Station
                        {
                            StationId = (int)rd["StationId"],
                            StationName = rd["StationName"].ToString()!
                        };

                        stations.Add(s);
                    }
                }
            }
            return stations;
        }

        // GET BY ID
        public Station? GetById(int id)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                string sql = "SELECT StationId, StationName FROM Stations WHERE StationId = @id";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@id", id);

                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        if (rd.Read())
                        {
                            return new Station
                            {
                                StationId = (int)rd["StationId"],
                                StationName = rd["StationName"].ToString()!
                            };
                        }
                    }
                }
            }
            return null; // fandtes ikke
        }
    }
}
