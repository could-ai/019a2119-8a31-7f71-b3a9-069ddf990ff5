import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> services = [
    'Corte de Pelo',
    'Afeitado',
    'Corte de Barba',
    'Lavado de Pelo',
    'Peinado',
  ];

  final List<String> barbers = [
    'Juan',
    'Miguel',
    'Carlos',
    'Luis',
  ];

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedService;
  String? selectedBarber;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _bookAppointment() {
    if (selectedDate != null &&
        selectedTime != null &&
        selectedService != null &&
        selectedBarber != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cita reservada para $selectedService con $selectedBarber el ${DateFormat('yyyy-MM-dd').format(selectedDate!)} a las ${selectedTime!.format(context)}',
          ),
        ),
      );
      // Reset selections
      setState(() {
        selectedDate = null;
        selectedTime = null;
        selectedService = null;
        selectedBarber = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, seleccione barbero, servicio, fecha y hora'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas de Barbería'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Added to prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenido a Nuestra Barbería',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reserve su Cita',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),

              // Barber Selection
              const Text('Seleccione un Barbero:',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedBarber,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                ),
                hint: const Text('Elija un barbero'),
                isExpanded: true,
                items: barbers.map((String barber) {
                  return DropdownMenuItem<String>(
                    value: barber,
                    child: Text(barber),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBarber = newValue;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Service Selection
              const Text('Seleccione un Servicio:',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedService,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                ),
                hint: const Text('Elija un servicio'),
                isExpanded: true,
                items: services.map((String service) {
                  return DropdownMenuItem<String>(
                    value: service,
                    child: Text(service),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedService = newValue;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Date Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate == null
                        ? 'Seleccionar Fecha'
                        : DateFormat('dd-MM-yyyy').format(selectedDate!),
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Elegir Fecha'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Time Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedTime == null
                        ? 'Seleccionar Hora'
                        : selectedTime!.format(context),
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: const Text('Elegir Hora'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Reservar Cita'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
