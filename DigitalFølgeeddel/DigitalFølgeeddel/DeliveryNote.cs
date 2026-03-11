using System;
using System.Collections.Generic;
using System.Text;

namespace DigitalFølgeeddel
{
    public class DeliveryNote
    {
        public int DeliveryNoteId { get; set; }
        public int FollowSlipNo { get; set; }

        public List<DeliveryNoteStep> DeliveryNoteSteps { get; set; } = new();
    }
}
