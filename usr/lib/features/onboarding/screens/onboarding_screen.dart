import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // State for selections
  String _selectedLanguage = 'pt-PT';
  String _selectedExperience = 'Doméstico';
  String _selectedNationality = 'Portugal';
  String _selectedUnit = 'Métrico';

  final List<Map<String, String>> _languages = [
    {'code': 'en-US', 'label': 'English'},
    {'code': 'pt-PT', 'label': 'Português (Portugal)'},
    {'code': 'pt-BR', 'label': 'Português (Brasil)'},
    {'code': 'es', 'label': 'Español'},
    {'code': 'fr', 'label': 'Français'},
    {'code': 'de', 'label': 'Deutsch'},
  ];

  final List<Map<String, dynamic>> _experienceLevels = [
    {
      'id': 'Iniciante',
      'title': 'Iniciante',
      'desc': 'Estou a aprender o básico.',
      'icon': Icons.egg_outlined
    },
    {
      'id': 'Doméstico',
      'title': 'Doméstico',
      'desc': 'Cozinho regularmente em casa.',
      'icon': Icons.home_outlined
    },
    {
      'id': 'Profissional',
      'title': 'Profissional/Avançado',
      'desc': 'Tenho conhecimentos técnicos avançados.',
      'icon': Icons.restaurant_menu
    },
  ];

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    // TODO: Save preferences to Firestore/Supabase
    // UserPreferences.save(...)
    
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalização'),
        leading: _currentPage > 0 
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
            )
          : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe to enforce selection
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                _buildLanguageStep(),
                _buildExperienceStep(),
                _buildNationalityStep(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                // Progress Indicator
                Expanded(
                  child: Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: index <= _currentPage 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(_currentPage == 2 ? 'Começar' : 'Seguinte'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 1: Language
  Widget _buildLanguageStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Escolha o seu idioma',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Isto define o idioma da interface do App.'),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _languages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lang = _languages[index];
                final isSelected = _selectedLanguage == lang['code'];
                return InkWell(
                  onTap: () => setState(() => _selectedLanguage = lang['code']!),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
                      border: Border.all(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lang['label']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Experience
  Widget _buildExperienceStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nível de Experiência',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Isto ajuda a Chef Albertina IA a adaptar a linguagem das receitas.'),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _experienceLevels.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final level = _experienceLevels[index];
                final isSelected = _selectedExperience == level['id'];
                return InkWell(
                  onTap: () => setState(() => _selectedExperience = level['id']),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
                      border: Border.all(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(level['icon'], color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                level['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                level['desc'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Nationality & Units
  Widget _buildNationalityStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Regionalização',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Defina a sua localização e sistema de medidas preferido.'),
          const SizedBox(height: 32),
          
          // Nationality Dropdown (Mocked)
          DropdownButtonFormField<String>(
            value: _selectedNationality,
            decoration: const InputDecoration(
              labelText: 'Nacionalidade / Região',
              prefixIcon: Icon(Icons.public),
            ),
            items: ['Portugal', 'Brasil', 'USA', 'France', 'Germany', 'Spain']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedNationality = val);
            },
          ),
          
          const SizedBox(height: 24),
          
          // Unit Toggle
          Text(
            'Unidades de Medida',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedUnit = 'Métrico'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedUnit == 'Métrico' ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selectedUnit == 'Métrico' 
                          ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)] 
                          : [],
                      ),
                      child: Center(
                        child: Text(
                          'Métrico (g, ml)',
                          style: TextStyle(
                            fontWeight: _selectedUnit == 'Métrico' ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedUnit = 'Imperial'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedUnit == 'Imperial' ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selectedUnit == 'Imperial' 
                          ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)] 
                          : [],
                      ),
                      child: Center(
                        child: Text(
                          'Imperial (oz, lb)',
                          style: TextStyle(
                            fontWeight: _selectedUnit == 'Imperial' ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
