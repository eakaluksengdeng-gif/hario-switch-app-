import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const HarioSwitchApp());
}

// ── Color Palette ──
const Color kCream = Color(0xFFF7F3EE);
const Color kWarmWhite = Color(0xFFFDFBF8);
const Color kParchment = Color(0xFFEDE7DC);
const Color kStone = Color(0xFFC8BFB2);
const Color kAsh = Color(0xFF9B9189);
const Color kEspresso = Color(0xFF2C2420);
const Color kBark = Color(0xFF6B5B4E);
const Color kAccent = Color(0xFFC17A3B);

class HarioSwitchApp extends StatelessWidget {
  const HarioSwitchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hario Switch',
      theme: ThemeData(
        scaffoldBackgroundColor: kCream,
        colorScheme: const ColorScheme.light(
          primary: kEspresso,
          secondary: kAccent,
        ),
        fontFamily: 'Georgia',
        useMaterial3: true,
      ),
      home: const RecipeScreen(),
    );
  }
}

// ── Data ──
const Map<String, Color> kTagColors = {
  'Hybrid': Color(0xFF8B7355),
  'Cold': Color(0xFF4A7B9D),
  'Bright': Color(0xFFC17A3B),
  'Hot': Color(0xFFB85C3A),
  'Champion': Color(0xFF7A6B4E),
  'Balanced': Color(0xFF5C7A5C),
  'Complex': Color(0xFF6B5B8A),
  'Aromatic': Color(0xFF8A6B5B),
  'Sweet': Color(0xFFB87A5C),
  'Quick': Color(0xFF5C7A8A),
  'Intense': Color(0xFF5C4A3A),
  'Light': Color(0xFF8A9B7A),
  'Simple': Color(0xFF7A8A8A),
};

class BrewStep {
  final int time;
  final double percent;
  final String action;
  const BrewStep({required this.time, required this.percent, required this.action});
}

class Recipe {
  final String name;
  final String tag;
  final String desc;
  final List<BrewStep> steps;
  const Recipe({required this.name, required this.tag, required this.desc, required this.steps});
}

const List<Recipe> kRecipes = [
  Recipe(name: 'Iced Flash Brew', tag: 'Hybrid', desc: 'ดริปเย็นสไตล์สดใส — ใส่น้ำแข็ง 120g ในเหยือกรอ', steps: [
    BrewStep(time: 0, percent: 0.25, action: 'เปิดสวิตช์ · Bloom'),
    BrewStep(time: 45, percent: 0.6, action: 'เปิดสวิตช์ · เทรอบ 2'),
    BrewStep(time: 90, percent: 1.0, action: 'ปิดสวิตช์ · แช่ 30 วิ'),
    BrewStep(time: 120, percent: 1.0, action: 'เปิดสวิตช์ · ลงน้ำแข็ง'),
  ]),
  Recipe(name: 'Iced Full Immersion', tag: 'Cold', desc: 'ดริปเย็นเน้นหวาน — ใส่น้ำแข็ง 150g ในเหยือกรอ', steps: [
    BrewStep(time: 0, percent: 1.0, action: 'ปิดสวิตช์ · เทน้ำร้อนรวด & คน'),
    BrewStep(time: 180, percent: 1.0, action: 'เปิดสวิตช์ · ลงน้ำแข็ง'),
  ]),
  Recipe(name: 'Classic V60', tag: 'Bright', desc: 'รสชาติสว่าง สดใส ดึงกรดผลไม้ออกมาเต็มที่', steps: [
    BrewStep(time: 0, percent: 0.2, action: 'เปิดสวิตช์ · Bloom'),
    BrewStep(time: 45, percent: 0.6, action: 'เทรอบ 2 (วนก้นหอย)'),
    BrewStep(time: 90, percent: 1.0, action: 'เทรอบสุดท้าย'),
  ]),
  Recipe(name: 'Full Immersion', tag: 'Hot', desc: 'บอดี้แน่น หวานฉ่ำ วิธีทำง่ายที่สุด', steps: [
    BrewStep(time: 0, percent: 1.0, action: 'ปิดสวิตช์ · เทรวด & คนเบาๆ'),
    BrewStep(time: 150, percent: 1.0, action: 'เปิดสวิตช์ · ปล่อยน้ำลง'),
  ]),
  Recipe(name: 'Kasuya Hybrid', tag: 'Champion', desc: 'สูตรแชมป์โลก — เปรี้ยวหวานนำ บอดี้ตาม', steps: [
    BrewStep(time: 0, percent: 0.2, action: 'เปิดสวิตช์ · Bloom'),
    BrewStep(time: 45, percent: 0.4, action: 'เทรอบ 2'),
    BrewStep(time: 75, percent: 1.0, action: 'ปิดสวิตช์ · แช่'),
    BrewStep(time: 165, percent: 1.0, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
  ]),
  Recipe(name: 'James Hoffmann', tag: 'Balanced', desc: 'สกัดสม่ำเสมอ รสชาติสะอาด บาลานซ์ดี', steps: [
    BrewStep(time: 0, percent: 1.0, action: 'ปิดสวิตช์ · ลงน้ำก่อน ตามด้วยกาแฟ'),
    BrewStep(time: 120, percent: 1.0, action: 'คนเบาๆ ให้ทั่ว'),
    BrewStep(time: 180, percent: 1.0, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
  ]),
  Recipe(name: 'Sprometheus Double', tag: 'Complex', desc: 'แช่ 2 รอบ เพื่อความซับซ้อนของรสชาติ', steps: [
    BrewStep(time: 0, percent: 0.25, action: 'ปิดสวิตช์ · Bloom'),
    BrewStep(time: 30, percent: 0.25, action: 'เปิดสวิตช์ · ปล่อยทิ้ง'),
    BrewStep(time: 45, percent: 1.0, action: 'ปิดสวิตช์ · เทที่เหลือแช่'),
    BrewStep(time: 120, percent: 1.0, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
  ]),
  Recipe(name: 'Reverse Hybrid', tag: 'Aromatic', desc: 'ดึงความหอม (Aroma) ออกมาให้สุด', steps: [
    BrewStep(time: 0, percent: 0.25, action: 'ปิดสวิตช์ · Bloom แช่'),
    BrewStep(time: 45, percent: 0.6, action: 'เปิดสวิตช์ · เทรอบ 2'),
    BrewStep(time: 90, percent: 1.0, action: 'เทรอบสุดท้าย (เปิดตลอด)'),
  ]),
  Recipe(name: 'Sweetness Steep', tag: 'Sweet', desc: 'ดึงความหวาน ตัดความฝาดขม', steps: [
    BrewStep(time: 0, percent: 0.5, action: 'ปิดสวิตช์ · แช่ครึ่งแรก'),
    BrewStep(time: 60, percent: 0.5, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
    BrewStep(time: 75, percent: 1.0, action: 'ปิดสวิตช์ · แช่ครึ่งหลัง'),
    BrewStep(time: 135, percent: 1.0, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
  ]),
  Recipe(name: 'Single Pour Pro', tag: 'Quick', desc: 'ไหลลื่น ดื่มง่าย สำหรับคนมีเวลาน้อย', steps: [
    BrewStep(time: 0, percent: 1.0, action: 'เปิดสวิตช์ · เทช้าๆ จนครบ'),
    BrewStep(time: 120, percent: 1.0, action: 'รอจนน้ำไหลหมด'),
  ]),
  Recipe(name: 'Coffee Chronicler', tag: 'Balanced', desc: 'ผสมผสานความคลีนและบอดี้อย่างลงตัว', steps: [
    BrewStep(time: 0, percent: 0.25, action: 'เปิดสวิตช์ · Bloom'),
    BrewStep(time: 45, percent: 0.5, action: 'เทรอบ 2'),
    BrewStep(time: 75, percent: 1.0, action: 'ปิดสวิตช์ · แช่'),
    BrewStep(time: 135, percent: 1.0, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
  ]),
  Recipe(name: '3-Pour Immersion', tag: 'Intense', desc: 'สกัดเข้มข้น แบ่งแช่ 3 รอบ', steps: [
    BrewStep(time: 0, percent: 0.33, action: 'ปิดสวิตช์ · รอบแรก'),
    BrewStep(time: 45, percent: 0.33, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
    BrewStep(time: 60, percent: 0.66, action: 'ปิดสวิตช์ · รอบสอง'),
    BrewStep(time: 105, percent: 0.66, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
    BrewStep(time: 120, percent: 1.0, action: 'ปิดสวิตช์ · รอบสาม'),
  ]),
  Recipe(name: 'Tea-Like Light', tag: 'Light', desc: 'เหมาะกับคั่วอ่อนมาก ให้สัมผัสเหมือนชา', steps: [
    BrewStep(time: 0, percent: 0.2, action: 'เปิดสวิตช์ · Bloom'),
    BrewStep(time: 45, percent: 1.0, action: 'ปิดสวิตช์ · เทรวด'),
    BrewStep(time: 120, percent: 1.0, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
  ]),
  Recipe(name: 'Osmotic Flow', tag: 'Simple', desc: 'เทน้ำตรงกลางตลอดเวลา ห้ามวน', steps: [
    BrewStep(time: 0, percent: 0.2, action: 'เปิดสวิตช์ · Bloom'),
    BrewStep(time: 45, percent: 1.0, action: 'เปิดสวิตช์ · เทกลางช้าๆ'),
  ]),
];

// ── Helpers ──
String fmtTime(int s) {
  final m = s ~/ 60;
  final sec = s % 60;
  return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
}

// ── Recipe Screen ──
class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);
  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  double _coffee = 15;
  int _recipeIdx = 0;

  void _shuffle() {
    setState(() {
      int next;
      final rng = Random();
      do { next = rng.nextInt(kRecipes.length); } while (next == _recipeIdx);
      _recipeIdx = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final water = (_coffee * 15).toInt();
    final recipe = kRecipes[_recipeIdx];
    final tagColor = kTagColors[recipe.tag] ?? kBark;

    return Scaffold(
      backgroundColor: kCream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BREWING GUIDE',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 3,
                              color: kAsh,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Hario Switch',
                            style: TextStyle(
                              fontSize: 26,
                              color: kBark,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${kRecipes.length} recipes',
                      style: const TextStyle(
                        fontSize: 12,
                        color: kAsh,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: kParchment, height: 1, indent: 28, endIndent: 28),

              // ── Dose ──
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('DOSE', style: TextStyle(fontSize: 10, letterSpacing: 3, color: kAsh)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Number display
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${_coffee.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 56,
                                    color: kEspresso,
                                    fontWeight: FontWeight.w300,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Text('g', style: TextStyle(fontSize: 14, color: kAsh)),
                              ],
                            ),
                            Text(
                              '→ $water ml water',
                              style: const TextStyle(fontSize: 11, color: kStone, letterSpacing: 0.3),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        // Slider
                        Expanded(
                          child: Column(
                            children: [
                              SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 1.5,
                                  activeTrackColor: kBark,
                                  inactiveTrackColor: kParchment,
                                  thumbColor: kWarmWhite,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                    elevation: 0,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                                  overlayColor: kBark.withOpacity(0.1),
                                ),
                                child: Slider(
                                  value: _coffee,
                                  min: 10,
                                  max: 30,
                                  divisions: 20,
                                  onChanged: (v) => setState(() => _coffee = v),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('10g', style: TextStyle(fontSize: 10, color: kStone)),
                                    Text('30g', style: TextStyle(fontSize: 10, color: kStone)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Recipe section ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("TODAY'S RECIPE", style: TextStyle(fontSize: 10, letterSpacing: 3, color: kAsh)),
                    GestureDetector(
                      onTap: _shuffle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: kParchment),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Text('↻ ', style: TextStyle(fontSize: 13, color: kAsh)),
                            Text('Shuffle', style: TextStyle(fontSize: 11, color: kAsh, letterSpacing: 1)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Recipe Card ──
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(anim),
                    child: child,
                  ),
                ),
                child: Container(
                  key: ValueKey(_recipeIdx),
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(
                    color: kWarmWhite,
                    border: Border.all(color: kParchment),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card top
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tag
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: tagColor.withOpacity(0.08),
                                border: Border.all(color: tagColor.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                recipe.tag.toUpperCase(),
                                style: TextStyle(fontSize: 9, letterSpacing: 2, color: tagColor, fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              recipe.name,
                              style: const TextStyle(fontSize: 26, color: kEspresso, fontWeight: FontWeight.w400, height: 1.2),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              recipe.desc,
                              style: const TextStyle(fontSize: 12, color: kAsh, height: 1.6, letterSpacing: 0.2),
                            ),
                          ],
                        ),
                      ),

                      // Steps
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('TIMELINE', style: TextStyle(fontSize: 9, letterSpacing: 2.5, color: kStone)),
                            const SizedBox(height: 10),
                            ...recipe.steps.map((step) {
                              final ml = (water * step.percent).round();
                              return Column(
                                children: [
                                  const Divider(color: kParchment, height: 1),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      children: [
                                        Text(
                                          fmtTime(step.time),
                                          style: const TextStyle(fontSize: 14, color: kBark, fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(step.action, style: const TextStyle(fontSize: 13, color: kEspresso, height: 1.4)),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('$ml', style: const TextStyle(fontSize: 16, color: kBark, fontWeight: FontWeight.w400)),
                                            const Text('ml', style: TextStyle(fontSize: 10, color: kStone)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── CTA ──
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kEspresso,
                      foregroundColor: kCream,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => TimerScreen(recipe: recipe, totalWater: water),
                      ));
                    },
                    child: const Text(
                      'START BREWING',
                      style: TextStyle(fontSize: 12, letterSpacing: 3, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Timer Screen ──
class TimerScreen extends StatefulWidget {
  final Recipe recipe;
  final int totalWater;
  const TimerScreen({Key? key, required this.recipe, required this.totalWater}) : super(key: key);
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _seconds = 0;
  bool _running = false;
  Timer? _timer;

  void _toggle() {
    setState(() => _running = !_running);
    if (_running) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _seconds++);
      });
    } else {
      _timer?.cancel();
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() { _seconds = 0; _running = false; });
  }

  int get _activeStep {
    final steps = widget.recipe.steps;
    for (int i = steps.length - 1; i >= 0; i--) {
      if (_seconds >= steps[i].time) return i;
    }
    return -1;
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final steps = widget.recipe.steps;
    final active = _activeStep;

    return Scaffold(
      backgroundColor: kEspresso,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.recipe.name,
                      style: const TextStyle(
                        fontSize: 24,
                        color: kCream,
                        fontWeight: FontWeight.w300,
                        height: 1.2,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      '← Back',
                      style: TextStyle(fontSize: 11, color: kAsh, letterSpacing: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            // ── Clock ──
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Column(
                children: [
                  Text(
                    fmtTime(_seconds),
                    style: const TextStyle(
                      fontSize: 84,
                      color: kWarmWhite,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -1,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('ELAPSED', style: TextStyle(fontSize: 10, letterSpacing: 3, color: kAsh)),
                ],
              ),
            ),

            // Divider
            const Divider(color: Color(0x12FFFFFF), height: 1, indent: 28, endIndent: 28),

            // ── Steps list ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                itemCount: steps.length,
                itemBuilder: (context, i) {
                  final step = steps[i];
                  final isActive = i == active;
                  final ml = (widget.totalWater * step.percent).round();

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
                    ),
                    child: Opacity(
                      opacity: isActive ? 1.0 : 0.35,
                      child: Row(
                        children: [
                          // Dot
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive ? kAccent : kAsh,
                              boxShadow: isActive ? [BoxShadow(color: kAccent.withOpacity(0.3), blurRadius: 8, spreadRadius: 2)] : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Time
                          Text(
                            fmtTime(step.time),
                            style: TextStyle(fontSize: 13, color: isActive ? kAccent : kAsh),
                          ),
                          const SizedBox(width: 16),
                          // Action
                          Expanded(
                            child: Text(
                              step.action,
                              style: TextStyle(
                                fontSize: 13,
                                color: isActive ? kCream : kStone,
                                fontWeight: isActive ? FontWeight.w400 : FontWeight.w300,
                              ),
                            ),
                          ),
                          // ml
                          Text(
                            '$ml ml',
                            style: TextStyle(
                              fontSize: 15,
                              color: isActive ? kAccent : kAsh,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Controls ──
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Reset
                  GestureDetector(
                    onTap: _reset,
                    child: const Text('RESET', style: TextStyle(fontSize: 11, color: kAsh, letterSpacing: 2)),
                  ),

                  // Play / Pause
                  GestureDetector(
                    onTap: _toggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _running ? kAccent : Colors.white.withOpacity(0.15),
                          width: 1.5,
                        ),
                        color: _running ? kAccent.withOpacity(0.1) : Colors.white.withOpacity(0.04),
                      ),
                      child: Center(
                        child: _running
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(width: 3, height: 18, decoration: BoxDecoration(color: kCream, borderRadius: BorderRadius.circular(1))),
                                  const SizedBox(width: 5),
                                  Container(width: 3, height: 18, decoration: BoxDecoration(color: kCream, borderRadius: BorderRadius.circular(1))),
                                ],
                              )
                            : Container(
                                margin: const EdgeInsets.only(left: 4),
                                child: const Icon(Icons.play_arrow, color: kCream, size: 28),
                              ),
                      ),
                    ),
                  ),

                  // Done
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('DONE', style: TextStyle(fontSize: 11, color: kAsh, letterSpacing: 2)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
