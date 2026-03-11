using System;
using System.Collections.Generic;
using System.Text;

namespace DigitalFølgeeddel
{
    public class DeliveryNoteStep
    {
        public int StepId { get; set; }
        public DateTime? ArrivalTime { get; set; }
        public DateTime? FinishTime { get; set; }
        public int AntalStart { get; set; }
        public int Tilgang { get; set; }
        public int AfgangFrem { get; set; }
        public int AfgangTilbage { get; set; }
        public int Spild { get; set; }

        public int DeliveryNoteId { get; set; }
        public DeliveryNote? DeliveryNote { get; set; }

        public int EmployeeId { get; set; }
        public Employee? Employee { get; set; }

        public bool IsCompleted => FinishTime.HasValue;
        public TimeSpan? Duration => IsCompleted ? FinishTime - ArrivalTime : null;
        public bool IsQuantityBalanced => Tilgang == (AfgangFrem + AfgangTilbage + Spild);
    }
}