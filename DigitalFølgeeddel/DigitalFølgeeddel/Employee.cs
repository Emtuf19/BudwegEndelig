using System;
using System.Collections.Generic;
using System.Text;

namespace DigitalFølgeeddel
{
    public class Employee
    {
        //test 123
        public int EmployeeId { get; set; }
        public string EmployeeName { get; set; } = string.Empty;

        public int StationId { get; set; }
        public Station? Station { get; set; }
    }
}
