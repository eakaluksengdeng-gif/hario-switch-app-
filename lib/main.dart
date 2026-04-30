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

  // ☕ อัปเดตฐานข้อมูลเป็น 14 สูตร (เพิ่ม Drip on Ice แบบละเอียด)
  final List<Map<String, dynamic>> recipes = [
    {
      "name": "1. Iced Flash Brew (Hybrid)",
      "desc": "ดริปเย็นสไตล์สดใส: ใส่น้ำแข็ง 120g ในเหยือกรอ",
      "imageUrl": "https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?q=80&w=400&auto=format&fit=crop",
      "steps": [
        {"time": 0, "percent": 0.25, "action": "เปิดสวิตช์ | เท Bloom"},
        {"time": 45, "percent": 0.6, "action": "เปิดสวิตช์ | เทน้ำรอบที่ 2"},
        {"time": 90, "percent": 1.0, "action": "ปิดสวิตช์ | เทที่เหลือแช่ 30 วิ"},
        {"time": 120, "percent": 1.0, "action": "เปิดสวิตช์ ปล่อยลงน้ำแข็ง"},
      ]
    },
    {
      "name": "2. Iced Full Immersion",
      "desc": "ดริปเย็นเน้นหวาน: ใส่น้ำแข็ง 150g ในเหยือกรอ",
      "imageUrl": "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?q=80&w=400&auto=format&fit=crop",
      "steps": [
        {"time": 0, "percent": 1.0, "action": "ปิดสวิตช์ | เทน้ำร้อนรวดเดียว & คน"},
        {"time": 180, "percent": 1.0, "action": "เปิดสวิตช์ ปล่อยลงน้ำแข็ง"},
      ]
    },
    {
      "name": "3. Classic V60 Style",
      "desc": "เน้นรสชาติสว่าง สดใส ดึงกรดผลไม้",
      "imageUrl": "https://images.unsplash.com/photo-1579992357154-faf4bfe95b3d?q=80&w=400&auto=format&fit=crop",
      "steps": [
        {"time": 0, "percent": 0.2, "action": "เปิดสวิตช์ | เท Bloom"},
        {"time": 45, "percent": 0.6, "action": "เทน้ำรอบที่ 2 (วนก้นหอย)"},
        {"time": 90, "percent": 1.0, "action": "เทน้ำรอบสุดท้ายให้ครบ"},
      ]
    },
    {
      "name": "4. Full Immersion (Hot)",
      "desc": "เน้นบอดี้แน่น หวานฉ่ำ ทำง่ายที่สุด",
      "imageUrl": "https://images.unsplash.com/photo-1510526019777-6f6f966f9a0d?q=80&w=400&auto=format&fit=crop",
      "steps": [
        {"time": 0, "percent": 1.0, "action": "ปิดสวิตช์ | เทน้ำรวดเดียว & คนเบาๆ"},
        {"time": 150, "percent": 1.0, "action": "กดเปิดสวิตช์ ปล่อยน้ำลง"},
      ]
    },
    {
      "name": "5. Kasuya Hybrid",
      "desc": "สูตรแชมป์โลก: เปรี้ยวหวานนำ บอดี้ตาม",
      "imageUrl": "https://images.unsplash.com/photo-1594917632616-29b6f8498f39?q=80&w=400&auto=format&fit=crop",
      "steps": [
        {"time": 0, "percent": 0.2, "action": "เปิดสวิตช์ | เท Bloom"},
        {"time": 45, "percent": 0.4, "action": "เทน้ำรอบที่ 2"},
        {"time": 75, "percent": 1.0, "action": "ปิดสวิตช์ | เทที่เหลือลงไปแช่"},
        {"time": 165, "percent": 1.0, "action": "เปิดสวิตช์ ปล่อยน้ำลง"},
      ]
    },
    {
       "name": "6. James Hoffmann Style",
       "desc": "สกัดสม่ำเสมอ รสชาติสะอาด บาลานซ์ดี",
       "imageUrl": "https://images.unsplash.com/photo-1497935586351-b67a49e012bf?q=80&w=400&auto=format&fit=crop",
       "steps": [
        {"time": 0, "percent": 1.0, "action": "ปิดสวิตช์ | ลงน้ำก่อน ตามด้วยผงกาแฟ"},
        {"time": 120, "percent": 1.0, "action": "คนเบาๆ ให้ทั่วถึง"},
        {"time": 180, "percent": 1.0, "action": "เปิดสวิตช์ ปล่อยน้ำลง"},
      ]
    },
    {
       "name": "7. Sprometheus Double",
       "desc": "แช่ 2 รอบเพื่อความซับซ้อนของรสชาติ",
       "imageUrl": "https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400&auto=format&fit=crop",
       "steps": [
        {"time": 0, "percent": 0.25, "action": "ปิดสวิตช์ | เทน้ำ Bloom"},
        {"time": 30, "percent": 0.25, "action": "เปิดสวิตช์ ปล่อยน้ำทิ้ง"},
        {"time": 45, "percent": 1.0, "action": "ปิดสวิตช์ | เทที่เหลือแช่"},
        {"time": 120, "percent": 1.0, "action": "เปิดสวิตช์ ปล่อยน้ำลง"},
      ]
    },
    {
       "name": "8. Reverse Hybrid",
       "desc": "ดึงความหอม (Aroma) ออกมาให้สุด",
       "imageUrl": "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=400&auto=format&fit=crop",
       "steps": [
        {"time": 0, "percent": 0.25, "action": "ปิดสวิตช์ | เทน้ำ Bloom แช่"},
        {"time": 45, "percent": 0.6, "action": "เปิดสวิตช์ | เทน้ำรอบที่ 2"},
        {"time": 90, "percent": 1.0, "action": "เทน้ำรอบสุดท้าย (เปิดสวิตช์ตลอด)"},
      ]
    },
    {
       "name": "9. The Sweetness Steep",
       "desc": "เน้นดึงความหวาน ตัดความฝาดขม",
       "imageUrl": "https://images.unsplash.com/photo-1559525839-b184a4d698c7?q=80&w=400&auto=format&fit=crop",
       "steps": [
        {"time": 0, "percent": 0.5, "action": "ปิดสวิตช์ | เทน้ำแช่ครึ่งแรก"},
        {"time": 60, "percent": 0.5, "action": "เปิดสวิตช์ ปล่อยน้ำลง"},
        {"time": 75, "percent": 1.0, "action": "ปิดสวิตช์ | เทน้ำแช่ครึ่งหลัง"},
        {"time": 135, "percent": 1.0, "action": "เปิดสวิตช์ ปล่อยน้ำลง"},
      ]
    },
    {
       "name": "10. Single Pour Pro",
       "desc": "ไหลลื่น ดื่มง่าย สำหรับคนมีเวลาน้อย",
       "imageUrl": "https://images.unsplash.com/photo-1521302080334-4bebac2763a6?q=80&w=400&auto=format&fit=crop",
       "steps": [
        {"time": 0, "percent": 1.0, "action": "เปิดสวิตช์ | เทน้ำให้ครบอย่างช้าๆ"},
        {"time": 120, "percent": 1.0, "action": "รอจนน้ำไหลหมด"},
      ]
    },
    {
       "name": "11. Coffee Chronicler",
       "desc": "ผสมผสานความคลีนและบอดี้อย่างลงตัว",
       "imageUrl": "https://images.unsplash.com/photo-1607513835698-b8ce77a845af?q=80&w=400&auto=format&fit=crop",
       "steps": [
        {"time": 0, "percent": 0.25, "action": "เปิดสวิตช์ | เท Bloom"},
        {"time": 45, "percent": 0.5, "action": "เทน้ำรอบที่ 2"},
        {"time": 75, "percent": 1.0, "action": "ปิดสวิตช์ | เทครึ่งหลังลงแช่"},
        {"time": 135, "percent": 1.0, "action": "เปิดสวิตช์ ปล่อยน้ำลง"},
      ]
    },
    {
       "name": "12. 3-Pour Immersion",
       "desc": "สกัดแบบเข้มข้น แบ่งแช่ 3 รอบ",
       "imageUrl": "https://images.unsplash.com/photo-1498804103079-a6351b050096?q=80&w=400&auto=format&fit=crop",
       "steps": [
        {"time": 0, "percent": 0.33, "action": "ปิดสวิตช์ | เทน้ำรอบแรก"},
        {"time": 45, "percent": 0.33, "action": "เปิดสวิตช์ ปล่อยน้ำลง"},
        {"time": 60, "percent": 0.66, "action": "ปิดสวิตช์ | เทรอบสอง"},
        {"time": 105, "percent": 0.66, "action": "เปิดสวิตช์ ปล่อยน้ำลง"},
        {"time": 120, "percent": 1.0, "action": "ปิดสวิตช์ | เทรอบสาม"},
      ]
    },
    {
       "name": "13. Tea-Like Light",
       "desc": "เหมาะกับคั่วอ่อนมาก ให้สัมผัสเหมือนชา",
       "imageUrl": "https://images.unsplash.com/photo-1495474472201-4ddb749cf1d5?q=80&w=400&auto=format&fit=crop",
       "steps": [
        {"time": 0, "percent": 0.2, "action": "เปิดสวิตช์ | เท Bloom"},
        {"time": 45, "percent": 1.0, "action": "ปิดสวิตช์ | เทรวดเดียวจนครบ"},
        {"time": 120, "percent": 1.0, "action": "เปิดสวิตช์ ปล่อยน้ำลง"},
      ]
    },
    {
       "name": "14. Osmotic Flow Simple",
       "desc": "เทน้ำตรงกลางตลอดเวลา ห้ามวน",
       "imageUrl": "https://images.unsplash.com/photo-1544787210-282aa065bd41?q=80&w=400&auto=format&fit=crop",
       "steps": [
        {"time": 0, "percent": 0.2, "action": "เปิดสวิตช์ | เท Bloom"},
        {"time": 45, "percent": 1.0, "action": "เปิดสวิตช์ | เทตรงกลางช้าๆ จนครบ"},
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
    
    String recipeName = currentRecipe["name"].toString();
    String recipeDesc = currentRecipe["desc"].toString();
    String imageUrl = currentRecipe["imageUrl"].toString();
    List<dynamic> recipeSteps = currentRecipe["steps"] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Hario Switch (14 Recipes)'),
        backgroundColor: Colors.brown[800],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('1. ปรับปริมาณผงกาแฟ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  const Text('2. วิธีทำวันนี้', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    const SizedBox(height: 15),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(height: 160, color: Colors.grey[300], child: const Icon(Icons.coffee, size: 80, color: Colors.grey)),
                      ),
                    ),
                    
                    const Divider(height: 30),
                    const Text('ขั้นตอน (Timeline):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    
                    ...recipeSteps.map((step) {
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
                      imageUrl: imageUrl,
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

class TimerScreen extends StatefulWidget {
  final String recipeName;
  final List<dynamic> steps;
  final int totalWater;
  final String imageUrl;
  const TimerScreen({Key? key, required this.recipeName, required this.steps, required this.totalWater, required this.imageUrl}) : super(key: key);
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
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  widget.imageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(width: 90, height: 90, color: Colors.grey[300], child: const Icon(Icons.coffee, size: 50, color: Colors.grey)),
                ),
              ),
              const SizedBox(width: 20),
              Text(_formatTime(_seconds), style: const TextStyle(fontSize: 85, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: widget.steps.length,
              itemBuilder: (context, index) {
                final step = widget.steps[index];
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
