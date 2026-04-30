import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const HarioSwitchApp());
}

class HarioSwitchApp extends StatelessWidget {
  const HarioSwitchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hario Switch Daily',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
      ),
      home: const RecipeScreen(),
    );
  }
}

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  double coffeeGrams = 15.0;
  int currentRecipeIndex = 0;

  final List<Map<String, dynamic>> recipes = [
    {
      "name": "Classic V60 Style",
      "desc": "เน้นรสชาติสว่าง สดใส ดึงกรดผลไม้",
      "steps": [
        {"time": 0, "percent": 0.2, "action": "เปิดสวิตช์ | เท Bloom"},
        {"time": 45, "percent": 0.6, "action": "เทน้ำรอบที่ 2 (วนก้นหอย)"},
        {"time": 90, "percent": 1.0, "action": "เทน้ำรอบสุดท้ายให้ครบ"},
      ]
    },
    {
      "name": "Full Immersion (แช่)",
      "desc": "เน้นบอดี้แน่น หวานฉ่ำ ทำง่ายที่สุด",
      "steps": [
        {"time": 0, "percent": 1.0, "action": "ปิดสวิตช์ | เทน้ำรวดเดียว & คน"},
        {"time": 150, "percent": 1.0, "action": "กดเปิดสวิตช์ ปล่อยน้ำลง"},
      ]
    },
    {
      "name": "Kasuya Hybrid",
      "desc": "สูตรแชมป์โลก: เปรี้ยวหวานนำ บอดี้ตาม",
      "steps": [
        {"time": 0, "percent": 0.2, "action": "เปิดสวิตช์ | เทรอบที่ 1"},
        {"time": 45, "percent": 0.4, "action": "เทรอบที่ 2"},
        {"time": 75, "percent": 1.0, "action": "ปิดสวิตช์ | เทที่เหลือลงไปแช่"},
        {"time": 165, "percent": 1.0, "action": "เปิดสวิตช์ ปล่อยน้ำลง"},
      ]
    },
    {
       "name": "James Hoffmann Style",
       "desc": "สกัดสม่ำเสมอ รสชาติสะอาด บาลานซ์ดี",
       "steps": [
        {"time": 0, "percent": 1.0, "action": "ปิดสวิตช์ | ลงน้ำก่อน ตามด้วยกาแฟ"},
        {"time": 120, "percent": 1.0, "action": "คนเบาๆ ให้ทั่ว"},
        {"time": 180, "percent": 1.0, "action": "เปิดสวิตช์ ปล่อยน้ำลง"},
      ]
    }
  ];

  void refreshRecipe() {
    setState(() {
      currentRecipeIndex = Random().nextInt(recipes.length);
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int secs = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double waterAmount = coffeeGrams * 15;
    var currentRecipe = recipes[currentRecipeIndex];
    
    // 🛠️ FIX: แปลงชนิดข้อมูลให้ชัดเจนป้องกัน Error
    String recipeName = currentRecipe["name"].toString();
    String recipeDesc = currentRecipe["desc"].toString();
    List<dynamic> recipeSteps = currentRecipe["steps"] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Hario Switch Recipes'),
        backgroundColor: Colors.brown[800],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('1. ปรับปริมาณกาแฟ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: coffeeGrams,
                        min: 10,
                        max: 30,
                        divisions: 20,
                        onChanged: (val) => setState(() => coffeeGrams = val),
                      ),
                    ),
                    Text('${coffeeGrams.toInt()}g', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown)),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('2. วิธีทำที่สุ่มได้วันนี้', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: refreshRecipe,
                    icon: const Icon(Icons.refresh, color: Colors.orange),
                    label: const Text('สุ่มใหม่', style: TextStyle(color: Colors.orange)),
                  )
                ],
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipeName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    Text(recipeDesc, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    const Divider(height: 30),
                    const Text('ขั้นตอนการเทน้ำ (Timeline):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    
                    ...recipeSteps.map((step) {
                      // 🛠️ FIX: Cast ตัวคูณ percent ให้เป็น num ก่อนคำนวณ
                      int targetMl = (waterAmount * (step["percent"] as num)).toInt();
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(_formatTime(step["time"] as int), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                            const SizedBox(width: 15),
                            Expanded(child: Text(step["action"].toString())),
                            Text('$targetMl ml', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TimerScreen(
                      recipeName: recipeName,
                      steps: recipeSteps,
                      totalWater: waterAmount.toInt(),
                    )));
                  },
                  child: const Text('เริ่มเข้าสู่โหมดจับเวลา', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------
// หน้าจับเวลา (Timer Screen)
// -----------------------------------------------------
class TimerScreen extends StatefulWidget {
  final String recipeName;
  final List<dynamic> steps;
  final int totalWater;
  const TimerScreen({Key? key, required this.recipeName, required this.steps, required this.totalWater}) : super(key: key);
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _seconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  void _startTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _seconds++);
    });
  }

  void _stopTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() { _seconds = 0; _isRunning = false; });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int secs = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Brewing...'), backgroundColor: Colors.brown[800]),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Text(_formatTime(_seconds), style: const TextStyle(fontSize: 90, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('วินาที : มิลลิลิตร', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: widget.steps.length,
              itemBuilder: (context, index) {
                final step = widget.steps[index];
                // 🛠️ FIX: Cast ชนิดข้อมูลให้คำนวณถูกต้องและไม่ Error
                int targetMl = (widget.totalWater * (step["percent"] as num)).toInt();
                int stepTime = step["time"] as int;
                
                bool isCurrent = false;
                if (index == widget.steps.length - 1) {
                  isCurrent = _seconds >= stepTime;
                } else {
                  int nextStepTime = widget.steps[index+1]["time"] as int;
                  isCurrent = _seconds >= stepTime && _seconds < nextStepTime;
                }
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isCurrent ? Colors.orange[50] : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isCurrent ? Colors.orange : Colors.grey[300]!, width: isCurrent ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Text(_formatTime(stepTime), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isCurrent ? Colors.brown : Colors.grey)),
                      const SizedBox(width: 15),
                      Expanded(child: Text(step["action"].toString(), style: TextStyle(fontSize: 16, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal))),
                      Text('$targetMl ml', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isCurrent ? Colors.blue : Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: _resetTimer, icon: const Icon(Icons.replay, size: 40, color: Colors.grey)),
                FloatingActionButton.large(
                  backgroundColor: _isRunning ? Colors.red : Colors.green,
                  onPressed: _isRunning ? _stopTimer : _startTimer,
                  child: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 50, color: Colors.white),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 40, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
