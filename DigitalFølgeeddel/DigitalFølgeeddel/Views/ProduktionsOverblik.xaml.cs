using DigitalFølgeeddel;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
namespace DigitalFølgeeddel_WPF
{
    /// <summary>
    /// Interaction logic for ProduktionsOverblik.xaml
    /// </summary>

    public partial class ProduktionsOverblik : Window
    {

        private readonly Controller _controller;
        //Brugt til at sætte søgning op
        private ICollectionView DeliveryNotesView;
        //ObservableCollection er en liste der bruges til data binding med UI i xaml eks. "{Binding WorkOrders}"
        public ObservableCollection<DeliveryNote> DeliveryNotes { get; set; }

        public ProduktionsOverblik()
        {
            InitializeComponent();
            _controller = new Controller();
            DeliveryNotes = new ObservableCollection<DeliveryNote>();

            DataContext = this;

            LoadDeliveryNotes();
            // Setup filtering
            DeliveryNotesView = CollectionViewSource.GetDefaultView(DeliveryNotes);
            DeliveryNotesView.Filter = FilterDeliveryNotes;
        }

        private void LoadDeliveryNotes()
        {
            var noteDatabase = _controller.GetDeliveryNoteWithSteps();

            DeliveryNotes.Clear();

            foreach (var note in noteDatabase)
            {
                DeliveryNotes.Add(note);
            }
        }
        //filter søg
        private bool FilterDeliveryNotes(object obj)
        {
            if (string.IsNullOrWhiteSpace(txtSearch.Text))
                return true;

            if (obj is DeliveryNote note)
            {
                string search = txtSearch.Text.ToLower();

                return note.DeliveryNoteId.ToString().Contains(search)
                    || note.FollowSlipNo.ToString().Contains(search);
            }

            return false;
        }
        private void txtSearch_TextChanged(object sender, TextChangedEventArgs e)
        {
            DeliveryNotesView.Refresh();
        }
        //Return knap
        private void btnRetur_Click(object sender, RoutedEventArgs e)
        {
            var main = new MainWindow();
            main.Show();
            this.Close();
        }
    }    
}