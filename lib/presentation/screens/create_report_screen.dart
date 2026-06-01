import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/helpers.dart';

class CreateReportScreen extends ConsumerStatefulWidget {
  const CreateReportScreen({super.key});

  @override
  ConsumerState<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends ConsumerState<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _busLineController = TextEditingController();
  final _busStopController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  int _waitTime = 15;
  String? _selectedSituation;
  bool _isAnonymous = false;
  XFile? _selectedImage;
  bool _isLoading = false;
  
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _busLineController.dispose();
    _busStopController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate() && _selectedSituation != null) {
      setState(() => _isLoading = true);
      
      // TODO: Implementar envio para Supabase
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Helpers.showSnackBar(context, 'Relato enviado com sucesso! +10 pontos');
        context.pop();
      }
      
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fazer Relato'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha
              TextFormField(
                controller: _busLineController,
                decoration: const InputDecoration(
                  labelText: 'Linha do ônibus',
                  prefixIcon: Icon(Icons.directions_bus),
                  hintText: 'Ex: 101, 205, Jardins',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a linha do ônibus';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Ponto
              TextFormField(
                controller: _busStopController,
                decoration: const InputDecoration(
                  labelText: 'Ponto de ônibus',
                  prefixIcon: Icon(Icons.location_on),
                  hintText: 'Ex: Terminal Central, Rua A',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o ponto de ônibus';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Tempo de espera
              const Text(
                'Tempo de espera',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _waitTime.toDouble(),
                      min: 0,
                      max: 60,
                      divisions: 60,
                      activeColor: AppColors.verdeMedio,
                      label: '$_waitTime min',
                      onChanged: (value) {
                        setState(() {
                          _waitTime = value.toInt();
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.verdeMedio.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_waitTime min',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.verdeMedio),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Tipo de ocorrência
              const Text(
                'Tipo de ocorrência',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: AppConstants.situations.map((situation) {
                  final isSelected = _selectedSituation == situation;
                  return FilterChip(
                    label: Text(situation),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSituation = selected ? situation : null;
                      });
                    },
                    selectedColor: AppColors.verdeMedio,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  );
                }).toList(),
              ),
              if (_selectedSituation == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Selecione um tipo de ocorrência',
                    style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),
              
              // Descrição
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              
              // Foto
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_selectedImage!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(
                              'Adicionar foto',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Anônimo
              SwitchListTile(
                title: const Text('Publicar anonimamente'),
                subtitle: Text(
                  'Seu nome não aparecerá no relato',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() {
                    _isAnonymous = value;
                  });
                },
                activeColor: AppColors.verdeMedio,
              ),
              
              const SizedBox(height: 32),
              
              // Botão enviar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitReport,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Enviar Relato'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}