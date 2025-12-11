import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = '';
  String _responseText = '';
  bool _isSpeaking = false;
  
  // Supported languages
  final List<Map<String, String>> _languages = [
    {'code': 'en-US', 'name': 'English'},
    {'code': 'hi-IN', 'name': 'Hindi'},
    {'code': 'mr-IN', 'name': 'Marathi'},
    {'code': 'ta-IN', 'name': 'Tamil'},
    {'code': 'te-IN', 'name': 'Telugu'},
    {'code': 'kn-IN', 'name': 'Kannada'},
  ];
  
  String _selectedLanguage = 'en-US';

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  void _initializeTts() async {
    await _flutterTts.setLanguage(_selectedLanguage);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    
    _flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });
    
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => setState(() {
          _isListening = status == stt.SpeechToText.listeningStatus;
        }),
        onError: (error) => print('Speech recognition error: $error'),
      );
      
      if (available) {
        setState(() {
          _isListening = true;
          _spokenText = '';
        });
        
        _speechToText.listen(
          localeId: _selectedLanguage,
          listenOptions: const stt.ListenOptions(
            listenMode: stt.ListenMode.dictation,
            partialResults: true,
            timeout: Duration(seconds: 10),
          ),
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speechToText.stop();
    }
  }

  void _speak(String text) async {
    if (!_isSpeaking) {
      await _flutterTts.speak(text);
    } else {
      _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  void _processQuery(String query) {
    setState(() {
      _spokenText = query;
    });
    
    // Simple rule-based responses for demonstration
    String response = _generateResponse(query);
    setState(() {
      _responseText = response;
    });
    
    // Speak the response
    _speak(response);
  }

  String _generateResponse(String query) {
    String lowerQuery = query.toLowerCase();
    
    // Weather-related queries
    if (lowerQuery.contains('weather') || lowerQuery.contains('rain') || lowerQuery.contains('temperature')) {
      return 'According to the latest forecast, expect partly cloudy skies with a high of 28 degrees Celsius today. There is a 20% chance of rain in the evening.';
    }
    
    // Soil-related queries
    if (lowerQuery.contains('soil') || lowerQuery.contains('ph')) {
      return 'For optimal wheat growth, your soil pH should be between 6.0 and 7.0. Consider adding lime if the pH is below 6.0 or sulfur if it is above 7.0.';
    }
    
    // Irrigation-related queries
    if (lowerQuery.contains('water') || lowerQuery.contains('irrigation')) {
      return 'Based on current soil moisture levels and weather forecast, irrigate your wheat field in the early morning to minimize evaporation losses.';
    }
    
    // Pest-related queries
    if (lowerQuery.contains('pest') || lowerQuery.contains('disease')) {
      return 'Check for signs of aphids or rust on your wheat plants. If detected, consider applying neem oil or consulting the disease detection module for precise identification.';
    }
    
    // Market-related queries
    if (lowerQuery.contains('price') || lowerQuery.contains('market')) {
      return 'Current wheat prices in your region are averaging 2,100 rupees per quintal. Prices are expected to rise by 5% in the next two weeks due to seasonal demand.';
    }
    
    // General greeting
    if (lowerQuery.contains('hello') || lowerQuery.contains('hi') || lowerQuery.contains('hey')) {
      return 'Hello farmer! How can I assist you with your farming activities today? You can ask me about weather, soil, irrigation, pests, or market prices.';
    }
    
    // Default response
    return 'I understand you\'re asking about "$query". For detailed assistance with this topic, I recommend exploring the relevant section in the FARM UP app. Is there anything specific you\'d like to know?';
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
    _initializeTts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Voice Assistant'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Language selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Language',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _languages.map((lang) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(lang['name']!),
                              selected: _selectedLanguage == lang['code'],
                              onSelected: (selected) {
                                if (selected) {
                                  _changeLanguage(lang['code']!);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Voice input section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Voice Input',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _listen,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: _isListening ? Colors.red : Colors.green,
                        child: Icon(
                          _isListening ? Icons.mic_off : Icons.mic,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _isListening ? 'Listening...' : 'Tap microphone to speak',
                      style: TextStyle(
                        fontSize: 16,
                        color: _isListening ? Colors.red : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_spokenText.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'You said: $_spokenText',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Response section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Assistant Response',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _responseText.isEmpty 
                            ? 'Ask me anything about farming!' 
                            : _responseText,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isSpeaking ? Icons.volume_up : Icons.volume_off,
                            color: Colors.green,
                          ),
                          onPressed: _responseText.isEmpty ? null : () => _speak(_responseText),
                        ),
                        const Text('Listen to response'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Quick action buttons
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _processQuery('What is the weather today?'),
                  icon: const Icon(Icons.wb_sunny),
                  label: const Text('Weather'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _processQuery('How is my soil quality?'),
                  icon: const Icon(Icons.grain),
                  label: const Text('Soil Analysis'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _processQuery('When should I irrigate?'),
                  icon: const Icon(Icons.water_damage),
                  label: const Text('Irrigation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _processQuery('Are there any pests?'),
                  icon: const Icon(Icons.biotech),
                  label: const Text('Pests'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _processQuery('What are current prices?'),
                  icon: const Icon(Icons.currency_rupee),
                  label: const Text('Market Prices'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}