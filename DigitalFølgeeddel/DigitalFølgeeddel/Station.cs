using System;
using System.Collections.Generic;
using System.Text;

namespace DigitalFølgeeddel
{
    public class Station
    {
        public int StationId { get; set; }
        public string StationName { get; set; } = string.Empty;
        public List<Employee> Employees { get; set; } = new();
    }
}
