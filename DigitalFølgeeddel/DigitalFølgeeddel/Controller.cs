using DigitalFølgeeddel;
using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;

namespace DigitalFølgeeddel
{
    public class Controller
    {
        private readonly DeliveryNoteRepo _deliveryNoteRepo;
        private readonly DeliveryNoteStepRepo _deliveryNoteStepRepo;
        private readonly EmployeeRepo _employeeRepo;
        private readonly StationRepo _stationRepo;

        public Controller()
        {
            _deliveryNoteRepo = new DeliveryNoteRepo();
            _deliveryNoteStepRepo = new DeliveryNoteStepRepo();
            _employeeRepo = new EmployeeRepo();
            _stationRepo = new StationRepo();
        }

        public int CreateDeliveryNoteWithSteps(DeliveryNote note)
        {
            // 1. Opret følgeseddel og få ID'et
            int newNoteId = _deliveryNoteRepo.Create(note);
            // 2. Opret steps
            foreach (var step in note.DeliveryNoteSteps)
            {
                step.DeliveryNoteId = newNoteId;
                _deliveryNoteStepRepo.Create(step);
            }
            return newNoteId;
        }

        public List<DeliveryNote> GetDeliveryNoteWithSteps()
        {
            return _deliveryNoteRepo.GetAllWithSteps();
        }

        public DeliveryNote? GetDeliveryNoteWithStepsById(int id)
        {
            return _deliveryNoteRepo.GetByIdWithSteps(id);
        }

        public bool DeleteDeliveryNoteById(int id)
        {
            bool deleted = _deliveryNoteRepo.Delete(id);
            Console.WriteLine(deleted ? $"Følgeseddel med id {id} og alle tilhørende steps er slettet." : $"Kunne ikke finde følgesedlen med id {id}.");
            //MessageBox.Show("Følgeseddel og alle tilhørende steps er slettet.", "Sletning lykkedes", MessageBoxButtons.OK, MessageBoxImage.Information);
            //Find ud af hvordan man giver brugeren besked i WPF
            return deleted;
        }

        // Create deliverynotestep til en given deliverynote
        public bool AddStepToDeliveryNote(int deliveryNoteId, DeliveryNoteStep newStep)
        {
            // Valider input
            //if (newStep == null) return false;
            //if (deliveryNoteId <= 0) return false;

            //finder først følgeseddel
            //var note = _deliveryNoteRepo.GetByIdWithSteps(deliveryNoteId);
            //if (note == null)
            //{
            //    return false;
            //}

            // Sæt FK til den eksisterende følgeseddel
            newStep.DeliveryNoteId = deliveryNoteId;
            return _deliveryNoteStepRepo.Create(newStep);
        }

        // Get deliverynotestep by id
        public DeliveryNoteStep? GetDeliveryNoteStepById(int id)
        {
            return _deliveryNoteStepRepo.GetById(id);
        }

        // update delivernotestep
        public bool UpdateDeliveryNoteStep(DeliveryNoteStep step)
        {
            return _deliveryNoteStepRepo.Update(step);
        }

        // delete deliverynotestep by id
        public bool DeleteDeliveryNoteStepById(int id)
        {
            bool deleted = _deliveryNoteStepRepo.Delete(id);
            Console.WriteLine(deleted ? $"step {id} blev slettet." : "Kunne ikke finde step");
            return deleted;
        }

        public List<Station> GetAllStations()
        {
            return _stationRepo.GetAll();
        }

        public List<Employee> GetAllEmployees()
        {
            return _employeeRepo.GetAllWithStation();
        }

        public List<Employee> GetEmployeesByStationId(int stationId)
        {
            //var allEmployees = _employeeRepo.GetAllWithStation();
            //return allEmployees.FindAll(e => e.StationId == stationId);
            return _employeeRepo.GetAllWithStation().Where(e => e.StationId == stationId).ToList();
        }
    }
}