using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace DigitalFølgeeddel
{
    public class DeliveryNoteRepo
    {

        private readonly string connectionString;

        public DeliveryNoteRepo()
        {
            IConfigurationRoot config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json")
                .Build();

            connectionString = config.GetConnectionString("MyDBConnection");
        }

        // Opret en ny følgeseddel og returner det nye ID
        public int Create(DeliveryNote note)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string sql = @"
            INSERT INTO DeliveryNote (FollowSlipNo)
            OUTPUT INSERTED.DeliveryNoteId
            VALUES (@FollowSlipNo)";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@FollowSlipNo", note.FollowSlipNo);

                    int newId = (int)cmd.ExecuteScalar();
                    return newId;
                }
            }
        }

        // Hent alle følgesedler med deres steps (og tilhørende employee og station)
        public List<DeliveryNote> GetAllWithSteps()
        {
            var notes = new List<DeliveryNote>();
            // Opslagstabeller for at undgå duplikater
            var noteById = new Dictionary<int, DeliveryNote>();
            var stepById = new Dictionary<int, DeliveryNoteStep>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string sql = @"
SELECT 
    dn.DeliveryNoteId, dn.FollowSlipNo,

    s.StepId, s.ArrivalTime, s.FinishTime, s.AntalStart, s.Tilgang, s.AfgangFrem, s.AfgangTilbage, s.Spild, 
    s.DeliveryNoteId AS S_DeliveryNoteId, s.EmployeeId AS S_EmployeeId,

    e.EmployeeId AS E_EmployeeId, e.EmployeeName, e.StationId AS E_StationId,

    st.StationId AS St_StationId, st.StationName
FROM DeliveryNote dn
LEFT JOIN DeliveryNoteStep s ON dn.DeliveryNoteId = s.DeliveryNoteId
LEFT JOIN Employee e ON s.EmployeeId = e.EmployeeId
LEFT JOIN Station st ON e.StationId = st.StationId
ORDER BY dn.DeliveryNoteId, s.StepId;
";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        // --- DeliveryNote ---
                        int dnId = rd.GetInt32(rd.GetOrdinal("DeliveryNoteId"));
                        if (!noteById.TryGetValue(dnId, out var note))
                        {
                            note = new DeliveryNote
                            {
                                DeliveryNoteId = dnId,
                                FollowSlipNo = rd.GetInt32(rd.GetOrdinal("FollowSlipNo")),
                                DeliveryNoteSteps = new List<DeliveryNoteStep>()
                            };
                            noteById[dnId] = note;
                            notes.Add(note);
                        }

                        // --- Step kan være NULL (left join) ---
                        int ordStepId = rd.GetOrdinal("StepId");
                        if (rd.IsDBNull(ordStepId))
                            continue;

                        int stepId = rd.GetInt32(ordStepId);
                        if (!stepById.TryGetValue(stepId, out var step))
                        {
                            // Ordinal-cache (valgfrit, men pænere end at kalde GetOrdinal 10 gange)
                            int ordArrival = rd.GetOrdinal("ArrivalTime");
                            int ordFinish = rd.GetOrdinal("FinishTime");
                            int ordAntalStart = rd.GetOrdinal("AntalStart");
                            int ordTilgang = rd.GetOrdinal("Tilgang");
                            int ordAfgangFrem = rd.GetOrdinal("AfgangFrem");
                            int ordAfgangTilbage = rd.GetOrdinal("AfgangTilbage");
                            int ordSpild = rd.GetOrdinal("Spild");
                            int ordS_DnId = rd.GetOrdinal("S_DeliveryNoteId");
                            int ordS_EmpId = rd.GetOrdinal("S_EmployeeId");

                            step = new DeliveryNoteStep
                            {
                                StepId = stepId,

                                ArrivalTime = rd.IsDBNull(ordArrival) ? (DateTime?)null : rd.GetDateTime(ordArrival),

                                FinishTime = rd.IsDBNull(ordFinish) ? (DateTime?)null : rd.GetDateTime(ordFinish),

                                AntalStart = rd.IsDBNull(ordAntalStart) ? 0 : rd.GetInt32(ordAntalStart),

                                Tilgang = rd.IsDBNull(ordTilgang) ? 0 : rd.GetInt32(ordTilgang),

                                AfgangFrem = rd.IsDBNull(ordAfgangFrem) ? 0 : rd.GetInt32(ordAfgangFrem),

                                AfgangTilbage = rd.IsDBNull(ordAfgangTilbage) ? 0 : rd.GetInt32(ordAfgangTilbage),

                                Spild = rd.IsDBNull(ordSpild) ? 0 : rd.GetInt32(ordSpild),

                                DeliveryNoteId = rd.GetInt32(ordS_DnId),
                                EmployeeId = rd.GetInt32(ordS_EmpId)
                            };

                            // --- Employee (kan være null) ---
                            int ordEId = rd.GetOrdinal("E_EmployeeId");
                            if (!rd.IsDBNull(ordEId))
                            {
                                int ordEName = rd.GetOrdinal("EmployeeName");
                                int ordEStationId = rd.GetOrdinal("E_StationId");

                                var emp = new Employee
                                {
                                    EmployeeId = rd.GetInt32(ordEId),
                                    EmployeeName = rd.IsDBNull(ordEName) ? string.Empty : rd["EmployeeName"]!.ToString()!,
                                    StationId = rd.IsDBNull(ordEStationId) ? 0 : rd.GetInt32(ordEStationId)
                                };

                                // --- Station (kan være null) ---
                                int ordStId = rd.GetOrdinal("St_StationId");
                                if (!rd.IsDBNull(ordStId))
                                {
                                    int ordStName = rd.GetOrdinal("StationName");
                                    emp.Station = new Station
                                    {
                                        StationId = rd.GetInt32(ordStId),
                                        StationName = rd.IsDBNull(ordStName) ? string.Empty : rd["StationName"]!.ToString()!
                                    };
                                }

                                step.Employee = emp;
                            }

                            stepById[stepId] = step;
                            note.DeliveryNoteSteps.Add(step);
                        }
                    }
                }
            }

            return notes;
        }

        // Hent en enkelt følgeseddel med steps (og tilhørende employee og station)
        public DeliveryNote? GetByIdWithSteps(int id)
        {
            DeliveryNote? note = null;
            var stepById = new Dictionary<int, DeliveryNoteStep>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string sql = @"
SELECT 
    dn.DeliveryNoteId, dn.FollowSlipNo,

    s.StepId, s.ArrivalTime, s.FinishTime, s.AntalStart, s.Tilgang, s.AfgangFrem, s.AfgangTilbage, s.Spild, 
    s.DeliveryNoteId AS S_DeliveryNoteId, s.EmployeeId AS S_EmployeeId,

    e.EmployeeId AS E_EmployeeId, e.EmployeeName, e.StationId AS E_StationId,

    st.StationId AS St_StationId, st.StationName
FROM DeliveryNote dn
LEFT JOIN DeliveryNoteStep s ON dn.DeliveryNoteId = s.DeliveryNoteId
LEFT JOIN Employee e ON s.EmployeeId = e.EmployeeId
LEFT JOIN Station st ON e.StationId = st.StationId
WHERE dn.DeliveryNoteId = @id
ORDER BY s.StepId;
";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    var p = cmd.Parameters.Add("@id", SqlDbType.Int);
                    p.Value = id;

                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                        {
                            if (note == null)
                            {
                                note = new DeliveryNote
                                {
                                    DeliveryNoteId = rd.GetInt32(rd.GetOrdinal("DeliveryNoteId")),
                                    FollowSlipNo = rd.GetInt32(rd.GetOrdinal("FollowSlipNo")),
                                    DeliveryNoteSteps = new List<DeliveryNoteStep>()
                                };
                            }

                            int ordStepId = rd.GetOrdinal("StepId");
                            if (rd.IsDBNull(ordStepId))
                                continue;

                            int stepId = rd.GetInt32(ordStepId);
                            if (!stepById.TryGetValue(stepId, out var step))
                            {
                                // Ordinal-cache
                                int ordArrival = rd.GetOrdinal("ArrivalTime");
                                int ordFinish = rd.GetOrdinal("FinishTime");
                                int ordAntalStart = rd.GetOrdinal("AntalStart");
                                int ordTilgang = rd.GetOrdinal("Tilgang");
                                int ordAfgangFrem = rd.GetOrdinal("AfgangFrem");
                                int ordAfgangTilbage = rd.GetOrdinal("AfgangTilbage");
                                int ordSpild = rd.GetOrdinal("Spild");
                                int ordS_DnId = rd.GetOrdinal("S_DeliveryNoteId");
                                int ordS_EmpId = rd.GetOrdinal("S_EmployeeId");

                                step = new DeliveryNoteStep
                                {
                                    StepId = stepId,

                                    ArrivalTime = rd.IsDBNull(ordArrival) ? (DateTime?)null : rd.GetDateTime(ordArrival),

                                    FinishTime = rd.IsDBNull(ordFinish) ? ( DateTime?)null : rd.GetDateTime(ordFinish),

                                    AntalStart = rd.IsDBNull(ordAntalStart) ? 0 : rd.GetInt32(ordAntalStart),

                                    Tilgang = rd.IsDBNull(ordTilgang) ? 0 : rd.GetInt32(ordTilgang),

                                    AfgangFrem = rd.IsDBNull(ordAfgangFrem) ? 0 : rd.GetInt32(ordAfgangFrem),

                                    AfgangTilbage = rd.IsDBNull(ordAfgangTilbage) ? 0 : rd.GetInt32(ordAfgangTilbage),

                                    Spild = rd.IsDBNull(ordSpild) ? 0 : rd.GetInt32(ordSpild),

                                    DeliveryNoteId = rd.GetInt32(ordS_DnId),
                                    EmployeeId = rd.GetInt32(ordS_EmpId)
                                };

                                int ordEId = rd.GetOrdinal("E_EmployeeId");
                                if (!rd.IsDBNull(ordEId))
                                {
                                    int ordEName = rd.GetOrdinal("EmployeeName");
                                    int ordEStationId = rd.GetOrdinal("E_StationId");

                                    var emp = new Employee
                                    {
                                        EmployeeId = rd.GetInt32(ordEId),
                                        EmployeeName = rd.IsDBNull(ordEName) ? string.Empty : rd["EmployeeName"]!.ToString()!,
                                        StationId = rd.IsDBNull(ordEStationId) ? 0 : rd.GetInt32(ordEStationId)
                                    };

                                    int ordStId = rd.GetOrdinal("St_StationId");
                                    if (!rd.IsDBNull(ordStId))
                                    {
                                        int ordStName = rd.GetOrdinal("StationName");
                                        emp.Station = new Station
                                        {
                                            StationId = rd.GetInt32(ordStId),
                                            StationName = rd.IsDBNull(ordStName) ? string.Empty : rd["StationName"]!.ToString()!
                                        };
                                    }

                                    step.Employee = emp;
                                }

                                stepById[stepId] = step;
                                note.DeliveryNoteSteps.Add(step);
                            }
                        }
                    }
                }
            }

            return note;
        }

        // Slet en følgeseddel (og alle steps, pga. cascade delete)
        public bool Delete(int deliveryNoteId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string sql = "DELETE FROM DeliveryNote WHERE DeliveryNoteId = @Id";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", deliveryNoteId);

                    int rowsAffected = cmd.ExecuteNonQuery();
                    return rowsAffected > 0;
                }
            }
        }
    }
}
