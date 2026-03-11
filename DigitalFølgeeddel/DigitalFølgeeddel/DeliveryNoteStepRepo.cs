using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Text;

namespace DigitalFølgeeddel
{
    class DeliveryNoteStepRepo
    {
        private readonly string connectionString;

        public DeliveryNoteStepRepo()
        {
            IConfigurationRoot config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json")
                .Build();

            connectionString = config.GetConnectionString("MyDBConnection");
        }


        public bool Create(DeliveryNoteStep step)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string sql = @"
            INSERT INTO DeliveryNoteStep 
            (ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, 
             AfgangTilbage, Spild, DeliveryNoteId, EmployeeId)
            VALUES
            (@ArrivalTime, @FinishTime, @AntalStart, @Tilgang, @AfgangFrem, 
             @AfgangTilbage, @Spild, @DeliveryNoteId, @EmployeeId)";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@ArrivalTime", (object?)step.ArrivalTime ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@FinishTime", (object?)step.FinishTime ?? DBNull.Value);

                    cmd.Parameters.AddWithValue("@AntalStart", step.AntalStart);
                    cmd.Parameters.AddWithValue("@Tilgang", step.Tilgang);
                    cmd.Parameters.AddWithValue("@AfgangFrem", step.AfgangFrem);
                    cmd.Parameters.AddWithValue("@AfgangTilbage", step.AfgangTilbage);
                    cmd.Parameters.AddWithValue("@Spild", step.Spild);

                    cmd.Parameters.AddWithValue("@DeliveryNoteId", step.DeliveryNoteId);
                    cmd.Parameters.AddWithValue("@EmployeeId", step.EmployeeId);

                    int rows = cmd.ExecuteNonQuery();
                    return rows > 0;
                }
            }
        }


        public DeliveryNoteStep? GetById(int id)
        {
            DeliveryNoteStep? step = null;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string sql = @"
            SELECT StepId, ArrivalTime, FinishTime, AntalStart, Tilgang, 
                   AfgangFrem, AfgangTilbage, Spild,
                   DeliveryNoteId, EmployeeId
            FROM DeliveryNoteStep
            WHERE StepId = @StepId";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@StepId", id);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            step = new DeliveryNoteStep
                            {
                                StepId = reader.GetInt32(reader.GetOrdinal("StepId")),
                                ArrivalTime = reader.IsDBNull(reader.GetOrdinal("ArrivalTime")) ? null : reader.GetDateTime(reader.GetOrdinal("ArrivalTime")),
                                FinishTime = reader.IsDBNull(reader.GetOrdinal("FinishTime")) ? null : reader.GetDateTime(reader.GetOrdinal("FinishTime")),
                                AntalStart = reader.GetInt32(reader.GetOrdinal("AntalStart")),
                                Tilgang = reader.GetInt32(reader.GetOrdinal("Tilgang")),
                                AfgangFrem = reader.GetInt32(reader.GetOrdinal("AfgangFrem")),
                                AfgangTilbage = reader.GetInt32(reader.GetOrdinal("AfgangTilbage")),
                                Spild = reader.GetInt32(reader.GetOrdinal("Spild")),
                                DeliveryNoteId = reader.GetInt32(reader.GetOrdinal("DeliveryNoteId")),
                                EmployeeId = reader.GetInt32(reader.GetOrdinal("EmployeeId"))
                            };
                        }
                    }
                }
            }

            return step;
        }


        public bool Update(DeliveryNoteStep step)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string sql = @"
            UPDATE DeliveryNoteStep
            SET 
                ArrivalTime = @ArrivalTime,
                FinishTime = @FinishTime,
                AntalStart = @AntalStart,
                Tilgang = @Tilgang,
                AfgangFrem = @AfgangFrem,
                AfgangTilbage = @AfgangTilbage,
                Spild = @Spild,
                DeliveryNoteId = @DeliveryNoteId,
                EmployeeId = @EmployeeId
            WHERE StepId = @StepId";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    // PRIMARY KEY
                    cmd.Parameters.AddWithValue("@StepId", step.StepId);

                    // Nullable dates (ArrivalTime + FinishTime)
                    cmd.Parameters.AddWithValue("@ArrivalTime", (object?)step.ArrivalTime ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@FinishTime", (object?)step.FinishTime ?? DBNull.Value);

                    // Integers (always required)
                    cmd.Parameters.AddWithValue("@AntalStart", step.AntalStart);
                    cmd.Parameters.AddWithValue("@Tilgang", step.Tilgang);
                    cmd.Parameters.AddWithValue("@AfgangFrem", step.AfgangFrem);
                    cmd.Parameters.AddWithValue("@AfgangTilbage", step.AfgangTilbage);
                    cmd.Parameters.AddWithValue("@Spild", step.Spild);

                    cmd.Parameters.AddWithValue("@DeliveryNoteId", step.DeliveryNoteId);
                    cmd.Parameters.AddWithValue("@EmployeeId", step.EmployeeId);

                    int rowsAffected = cmd.ExecuteNonQuery();
                    return rowsAffected > 0;
                }
            }
        }

        public bool Delete(int stepId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string sql = "DELETE FROM DeliveryNoteStep WHERE StepId = @Id";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", stepId);

                    int rowsAffected = cmd.ExecuteNonQuery();
                    return rowsAffected > 0;
                }
            }
        }
    }
}
