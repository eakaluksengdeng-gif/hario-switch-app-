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

// ── Dripper Type ──
enum DripperType { harioSwitch, origami, standard }

extension DripperTypeExt on DripperType {
  String get label {
    switch (this) {
      case DripperType.harioSwitch: return 'Hario Switch';
      case DripperType.origami:     return 'Origami';
      case DripperType.standard:    return 'Standard';
    }
  }
  String get emoji {
    switch (this) {
      case DripperType.harioSwitch: return '⟳';
      case DripperType.origami:     return '✦';
      case DripperType.standard:    return '◎';
    }
  }
}

// ── Data ──
const Map<String, Color> kTagColors = {
  'Hybrid':    Color(0xFF8B7355),
  'Cold':      Color(0xFF4A7B9D),
  'Bright':    Color(0xFFC17A3B),
  'Hot':       Color(0xFFB85C3A),
  'Champion':  Color(0xFF7A6B4E),
  'Balanced':  Color(0xFF5C7A5C),
  'Complex':   Color(0xFF6B5B8A),
  'Aromatic':  Color(0xFF8A6B5B),
  'Sweet':     Color(0xFFB87A5C),
  'Quick':     Color(0xFF5C7A8A),
  'Intense':   Color(0xFF5C4A3A),
  'Light':     Color(0xFF8A9B7A),
  'Simple':    Color(0xFF7A8A8A),
};

class BrewStep {
  // percent ของน้ำที่เท ณ step นี้ (ไม่ใช่ cumulative)
  // เช่น 0.18, 0.34, 0.48 → UI จะ sum ให้เป็น cumulative
  final int time;
  final double percent;
  final String action;
  const BrewStep({required this.time, required this.percent, required this.action});
}

class Recipe {
  final String name;
  final String tag;
  final String desc;
  final DripperType dripper;
  final List<BrewStep> steps;
  const Recipe({
    required this.name,
    required this.tag,
    required this.desc,
    required this.dripper,
    required this.steps,
  });
}

// ─────────────────────────────────────────────
// สูตร Hario Switch (เหมือนเดิม)
// ─────────────────────────────────────────────
const List<Recipe> kRecipes = [
  // ─────────────────────────────────────────────
  // สูตร Hario Switch
  // ─────────────────────────────────────────────
  Recipe(
    name: 'Iced Flash Brew', tag: 'Hybrid', dripper: DripperType.harioSwitch,
    desc: 'ดริปเย็นสไตล์สดใส — ใส่น้ำแข็ง 120g ในเหยือกรอ',
    steps: [
      BrewStep(time: 0,   percent: 0.25, action: 'เปิดสวิตช์ · Bloom'),
      BrewStep(time: 45,  percent: 0.35, action: 'เปิดสวิตช์ · เทรอบ 2'),
      BrewStep(time: 90,  percent: 0.40, action: 'ปิดสวิตช์ · แช่ 30 วิ'),
      BrewStep(time: 120, percent: 0.00, action: 'เปิดสวิตช์ · ลงน้ำแข็ง'),
      BrewStep(time: 180, percent: 0.00, action: '✓ จบ — 3:00'),
    ],
  ),
  Recipe(
    name: 'Iced Full Immersion', tag: 'Cold', dripper: DripperType.harioSwitch,
    desc: 'ดริปเย็นเน้นหวาน — ใส่น้ำแข็ง 150g ในเหยือกรอ',
    steps: [
      BrewStep(time: 0,   percent: 1.00, action: 'ปิดสวิตช์ · เทน้ำร้อนรวด & คน'),
      BrewStep(time: 180, percent: 0.00, action: 'เปิดสวิตช์ · ลงน้ำแข็ง'),
      BrewStep(time: 270, percent: 0.00, action: '✓ จบ — 4:30'),
    ],
  ),
  Recipe(
    name: 'Classic V60', tag: 'Bright', dripper: DripperType.harioSwitch,
    desc: 'รสชาติสว่าง สดใส ดึงกรดผลไม้ออกมาเต็มที่',
    steps: [
      BrewStep(time: 0,  percent: 0.20, action: 'เปิดสวิตช์ · Bloom'),
      BrewStep(time: 45, percent: 0.40, action: 'เทรอบ 2 (วนก้นหอย)'),
      BrewStep(time: 90, percent: 0.40, action: 'เทรอบสุดท้าย'),
      BrewStep(time: 180, percent: 0.00, action: '✓ จบ — 3:00'),
    ],
  ),
  Recipe(
    name: 'Full Immersion', tag: 'Hot', dripper: DripperType.harioSwitch,
    desc: 'บอดี้แน่น หวานฉ่ำ วิธีทำง่ายที่สุด',
    steps: [
      BrewStep(time: 0,   percent: 1.00, action: 'ปิดสวิตช์ · เทรวด & คนเบาๆ'),
      BrewStep(time: 150, percent: 0.00, action: 'เปิดสวิตช์ · ปล่อยน้ำลง'),
      BrewStep(time: 240, percent: 0.00, action: '✓ จบ — 4:00'),
    ],
  ),
  Recipe(
    name: 'Kasuya Hybrid', tag: 'Champion', dripper: DripperType.harioSwitch,
    desc: 'สูตรแชมป์โลก — เปรี้ยวหวานนำ บอดี้ตาม',
    steps: [
      BrewStep(time: 0,   percent: 0.20, action: 'เปิดสวิตช์ · Bloom'),
      BrewStep(time: 45,  percent: 0.20, action: 'เทรอบ 2'),
      BrewStep(time: 75,  percent: 0.60, action: 'ปิดสวิตช์ · แช่'),
      BrewStep(time: 165, percent: 0.00, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
      BrewStep(time: 240, percent: 0.00, action: '✓ จบ — 4:00'),
    ],
  ),
  Recipe(
    name: 'James Hoffmann', tag: 'Balanced', dripper: DripperType.harioSwitch,
    desc: 'สกัดสม่ำเสมอ รสชาติสะอาด บาลานซ์ดี',
    steps: [
      BrewStep(time: 0,   percent: 1.00, action: 'ปิดสวิตช์ · ลงน้ำก่อน ตามด้วยกาแฟ'),
      BrewStep(time: 120, percent: 0.00, action: 'คนเบาๆ ให้ทั่ว'),
      BrewStep(time: 180, percent: 0.00, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
      BrewStep(time: 270, percent: 0.00, action: '✓ จบ — 4:30'),
    ],
  ),
  Recipe(
    name: 'Sprometheus Double', tag: 'Complex', dripper: DripperType.harioSwitch,
    desc: 'แช่ 2 รอบ เพื่อความซับซ้อนของรสชาติ',
    steps: [
      BrewStep(time: 0,   percent: 0.25, action: 'ปิดสวิตช์ · Bloom'),
      BrewStep(time: 30,  percent: 0.00, action: 'เปิดสวิตช์ · ปล่อยทิ้ง'),
      BrewStep(time: 45,  percent: 0.75, action: 'ปิดสวิตช์ · เทที่เหลือแช่'),
      BrewStep(time: 120, percent: 0.00, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
      BrewStep(time: 210, percent: 0.00, action: '✓ จบ — 3:30'),
    ],
  ),
  Recipe(
    name: 'Reverse Hybrid', tag: 'Aromatic', dripper: DripperType.harioSwitch,
    desc: 'ดึงความหอม (Aroma) ออกมาให้สุด',
    steps: [
      BrewStep(time: 0,  percent: 0.25, action: 'ปิดสวิตช์ · Bloom แช่'),
      BrewStep(time: 45, percent: 0.35, action: 'เปิดสวิตช์ · เทรอบ 2'),
      BrewStep(time: 90, percent: 0.40, action: 'เทรอบสุดท้าย (เปิดตลอด)'),
      BrewStep(time: 180, percent: 0.00, action: '✓ จบ — 3:00'),
    ],
  ),
  Recipe(
    name: 'Sweetness Steep', tag: 'Sweet', dripper: DripperType.harioSwitch,
    desc: 'ดึงความหวาน ตัดความฝาดขม',
    steps: [
      BrewStep(time: 0,   percent: 0.50, action: 'ปิดสวิตช์ · แช่ครึ่งแรก'),
      BrewStep(time: 60,  percent: 0.00, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
      BrewStep(time: 75,  percent: 0.50, action: 'ปิดสวิตช์ · แช่ครึ่งหลัง'),
      BrewStep(time: 135, percent: 0.00, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
      BrewStep(time: 210, percent: 0.00, action: '✓ จบ — 3:30'),
    ],
  ),
  Recipe(
    name: 'Single Pour Pro', tag: 'Quick', dripper: DripperType.harioSwitch,
    desc: 'ไหลลื่น ดื่มง่าย สำหรับคนมีเวลาน้อย',
    steps: [
      BrewStep(time: 0,   percent: 1.00, action: 'เปิดสวิตช์ · เทช้าๆ จนครบ'),
      BrewStep(time: 120, percent: 0.00, action: 'รอจนน้ำไหลหมด'),
      BrewStep(time: 180, percent: 0.00, action: '✓ จบ — 3:00'),
    ],
  ),
  Recipe(
    name: 'Coffee Chronicler', tag: 'Balanced', dripper: DripperType.harioSwitch,
    desc: 'ผสมผสานความคลีนและบอดี้อย่างลงตัว',
    steps: [
      BrewStep(time: 0,   percent: 0.25, action: 'เปิดสวิตช์ · Bloom'),
      BrewStep(time: 45,  percent: 0.25, action: 'เทรอบ 2'),
      BrewStep(time: 75,  percent: 0.50, action: 'ปิดสวิตช์ · แช่'),
      BrewStep(time: 135, percent: 0.00, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
      BrewStep(time: 210, percent: 0.00, action: '✓ จบ — 3:30'),
    ],
  ),
  Recipe(
    name: '3-Pour Immersion', tag: 'Intense', dripper: DripperType.harioSwitch,
    desc: 'สกัดเข้มข้น แบ่งแช่ 3 รอบ',
    steps: [
      BrewStep(time: 0,   percent: 0.33, action: 'ปิดสวิตช์ · รอบแรก'),
      BrewStep(time: 45,  percent: 0.00, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
      BrewStep(time: 60,  percent: 0.33, action: 'ปิดสวิตช์ · รอบสอง'),
      BrewStep(time: 105, percent: 0.00, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
      BrewStep(time: 120, percent: 0.34, action: 'ปิดสวิตช์ · รอบสาม'),
      BrewStep(time: 210, percent: 0.00, action: '✓ จบ — 3:30'),
    ],
  ),
  Recipe(
    name: 'Tea-Like Light', tag: 'Light', dripper: DripperType.harioSwitch,
    desc: 'เหมาะกับคั่วอ่อนมาก ให้สัมผัสเหมือนชา',
    steps: [
      BrewStep(time: 0,   percent: 0.20, action: 'เปิดสวิตช์ · Bloom'),
      BrewStep(time: 45,  percent: 0.80, action: 'ปิดสวิตช์ · เทรวด'),
      BrewStep(time: 120, percent: 0.00, action: 'เปิดสวิตช์ · ปล่อยน้ำ'),
      BrewStep(time: 210, percent: 0.00, action: '✓ จบ — 3:30'),
    ],
  ),
  Recipe(
    name: 'Osmotic Flow', tag: 'Simple', dripper: DripperType.harioSwitch,
    desc: 'เทน้ำตรงกลางตลอดเวลา ห้ามวน',
    steps: [
      BrewStep(time: 0,  percent: 0.20, action: 'เปิดสวิตช์ · Bloom'),
      BrewStep(time: 45, percent: 0.80, action: 'เปิดสวิตช์ · เทกลางช้าๆ'),
      BrewStep(time: 150, percent: 0.00, action: '✓ จบ — 2:30'),
    ],
  ),

  // ─────────────────────────────────────────────
  // สูตร Origami
  // ─────────────────────────────────────────────
  Recipe(
    name: 'Origami Classic', tag: 'Bright', dripper: DripperType.origami,
    desc: 'V60 style ผ่าน Origami รสสะอาด สดใส',
    steps: [
      BrewStep(time: 0,   percent: 0.20, action: 'Bloom · วนเบาๆ'),
      BrewStep(time: 45,  percent: 0.40, action: 'เทรอบ 2 วนก้นหอย'),
      BrewStep(time: 90,  percent: 0.40, action: 'เทรอบสุดท้ายช้าๆ'),
      BrewStep(time: 180, percent: 0.00, action: '✓ จบ — 3:00'),
    ],
  ),
  Recipe(
    name: 'Origami 4-Pour', tag: 'Balanced', dripper: DripperType.origami,
    desc: 'แบ่ง 4 รอบ สกัดสม่ำเสมอ ได้บาลานซ์ดี',
    steps: [
      BrewStep(time: 0,   percent: 0.15, action: 'Bloom · หมุนดริปเปอร์'),
      BrewStep(time: 45,  percent: 0.28, action: 'เทรอบ 2'),
      BrewStep(time: 85,  percent: 0.28, action: 'เทรอบ 3'),
      BrewStep(time: 125, percent: 0.29, action: 'เทรอบสุดท้าย'),
      BrewStep(time: 210, percent: 0.00, action: '✓ จบ — 3:30'),
    ],
  ),
  Recipe(
    name: 'Origami Sweet', tag: 'Sweet', dripper: DripperType.origami,
    desc: 'เน้นความหวาน ใช้น้ำอุณหภูมิต่ำลง 88°C',
    steps: [
      BrewStep(time: 0,   percent: 0.20, action: 'Bloom · แช่ไว้'),
      BrewStep(time: 50,  percent: 0.40, action: 'เทรอบ 2 วนช้าๆ'),
      BrewStep(time: 100, percent: 0.40, action: 'เทรอบสุดท้าย'),
      BrewStep(time: 195, percent: 0.00, action: '✓ จบ — 3:15'),
    ],
  ),
  Recipe(
    name: 'Origami Iced', tag: 'Cold', dripper: DripperType.origami,
    desc: 'Flash Brew ผ่าน Origami — ใส่น้ำแข็ง 120g รอ',
    steps: [
      BrewStep(time: 0,  percent: 0.20, action: 'Bloom'),
      BrewStep(time: 45, percent: 0.35, action: 'เทรอบ 2'),
      BrewStep(time: 80, percent: 0.45, action: 'เทรอบสุดท้ายลงน้ำแข็ง'),
      BrewStep(time: 165, percent: 0.00, action: '✓ จบ — 2:45'),
    ],
  ),
  Recipe(
    name: 'Origami Turbo', tag: 'Quick', dripper: DripperType.origami,
    desc: 'เร็วกว่าปกติ ใช้บดหยาบขึ้น Coarser grind',
    steps: [
      BrewStep(time: 0,  percent: 0.25, action: 'Bloom'),
      BrewStep(time: 35, percent: 0.75, action: 'เทรวดเร็วจนครบ'),
      BrewStep(time: 120, percent: 0.00, action: '✓ จบ — 2:00'),
    ],
  ),

  // ─────────────────────────────────────────────
  // สูตร Standard (ดริปเปอร์ธรรมดา ไม่มี switch)
  // ─────────────────────────────────────────────
  Recipe(
    name: 'Standard Classic', tag: 'Bright', dripper: DripperType.standard,
    desc: 'สูตรพื้นฐาน เหมาะกับดริปเปอร์ทุกแบบ',
    steps: [
      BrewStep(time: 0,  percent: 0.20, action: 'Bloom · รอ 30 วิ'),
      BrewStep(time: 30, percent: 0.40, action: 'เทรอบ 2 วนเป็นวงกลม'),
      BrewStep(time: 70, percent: 0.40, action: 'เทรอบสุดท้าย'),
      BrewStep(time: 165, percent: 0.00, action: '✓ จบ — 2:45'),
    ],
  ),
  Recipe(
    name: 'Standard 4-Pour', tag: 'Balanced', dripper: DripperType.standard,
    desc: 'แบ่ง 4 รอบ สกัดสม่ำเสมอ ลด bitter',
    steps: [
      BrewStep(time: 0,   percent: 0.15, action: 'Bloom · รอ 30 วิ'),
      BrewStep(time: 30,  percent: 0.28, action: 'เทรอบ 2'),
      BrewStep(time: 65,  percent: 0.28, action: 'เทรอบ 3'),
      BrewStep(time: 100, percent: 0.29, action: 'เทรอบสุดท้าย'),
      BrewStep(time: 195, percent: 0.00, action: '✓ จบ — 3:15'),
    ],
  ),
  Recipe(
    name: 'Standard Osmotic', tag: 'Simple', dripper: DripperType.standard,
    desc: 'Osmotic Flow — เทตรงกลางช้าๆ ห้ามวน',
    steps: [
      BrewStep(time: 0,  percent: 0.20, action: 'Bloom ตรงกลาง'),
      BrewStep(time: 35, percent: 0.80, action: 'เทกลางช้าๆ ต่อเนื่อง'),
      BrewStep(time: 150, percent: 0.00, action: '✓ จบ — 2:30'),
    ],
  ),
  Recipe(
    name: 'Standard Sweet', tag: 'Sweet', dripper: DripperType.standard,
    desc: 'เน้นหวาน ลดขม ใช้น้ำ 88°C',
    steps: [
      BrewStep(time: 0,   percent: 0.20, action: 'Bloom · รอ 40 วิ'),
      BrewStep(time: 40,  percent: 0.40, action: 'เทรอบ 2 ช้าๆ'),
      BrewStep(time: 90,  percent: 0.40, action: 'เทรอบสุดท้าย'),
      BrewStep(time: 180, percent: 0.00, action: '✓ จบ — 3:00'),
    ],
  ),
  Recipe(
    name: 'Standard Iced', tag: 'Cold', dripper: DripperType.standard,
    desc: 'Flash Brew ดริปเปอร์ธรรมดา — ใส่น้ำแข็ง 120g รอ',
    steps: [
      BrewStep(time: 0,  percent: 0.20, action: 'Bloom'),
      BrewStep(time: 40, percent: 0.35, action: 'เทรอบ 2'),
      BrewStep(time: 80, percent: 0.45, action: 'เทรอบสุดท้ายลงน้ำแข็ง'),
      BrewStep(time: 165, percent: 0.00, action: '✓ จบ — 2:45'),
    ],
  ),
  Recipe(
    name: 'Standard Turbo', tag: 'Quick', dripper: DripperType.standard,
    desc: 'เทเร็ว เสร็จไว ใช้บดหยาบขึ้น',
    steps: [
      BrewStep(time: 0,  percent: 0.25, action: 'Bloom · รอ 20 วิ'),
      BrewStep(time: 20, percent: 0.75, action: 'เทรวดจนครบ'),
      BrewStep(time: 120, percent: 0.00, action: '✓ จบ — 2:00'),
    ],
  ),
];

// ── Helpers ──
String fmtTime(int s) {
  final m = s ~/ 60;
  final sec = s % 60;
  return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
}

/// คำนวณ ml แบบ cumulative ณ index นั้นๆ
/// (รวมทุก step ที่มี percent > 0 จาก 0 ถึง i)
int cumulativeMl(List<BrewStep> steps, int index, int totalWater) {
  double sum = 0;
  for (int i = 0; i <= index; i++) {
    sum += steps[i].percent;
  }
  return (totalWater * sum).round();
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
  DripperType _dripper = DripperType.harioSwitch;

  List<Recipe> get _filtered =>
      kRecipes.where((r) => r.dripper == _dripper).toList();

  Recipe get _currentRecipe {
    final list = _filtered;
    if (_recipeIdx >= list.length) return list.first;
    return list[_recipeIdx];
  }

  void _shuffle() {
    setState(() {
      final list = _filtered;
      if (list.length <= 1) return;
      int next;
      final rng = Random();
      do { next = rng.nextInt(list.length); } while (next == _recipeIdx);
      _recipeIdx = next;
    });
  }

  void _setDripper(DripperType d) {
    setState(() {
      _dripper = d;
      _recipeIdx = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final water = (_coffee * 15).toInt();
    final recipe = _currentRecipe;
    final tagColor = kTagColors[recipe.tag] ?? kBark;
    final filtered = _filtered;

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
                              fontSize: 10, letterSpacing: 3, color: kAsh,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _dripper.label,
                            style: const TextStyle(
                              fontSize: 26, color: kBark,
                              fontWeight: FontWeight.w300, letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${filtered.length} recipes',
                      style: const TextStyle(fontSize: 12, color: kAsh, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const Divider(color: kParchment, height: 1, indent: 28, endIndent: 28),

              // ── Dripper Selector ──
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('DRIPPER', style: TextStyle(fontSize: 10, letterSpacing: 3, color: kAsh)),
                    const SizedBox(height: 10),
                    Row(
                      children: DripperType.values.map((d) {
                        final selected = _dripper == d;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _setDripper(d),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selected ? kEspresso : Colors.transparent,
                                border: Border.all(
                                  color: selected ? kEspresso : kParchment,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    d.emoji,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: selected ? kCream : kAsh,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    d.label,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 9,
                                      letterSpacing: 0.8,
                                      color: selected ? kCream : kAsh,
                                      fontWeight: selected
                                          ? FontWeight.w400
                                          : FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Dose ──
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('DOSE', style: TextStyle(fontSize: 10, letterSpacing: 3, color: kAsh)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
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
                                    fontSize: 56, color: kEspresso,
                                    fontWeight: FontWeight.w300, height: 1,
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
                                    enabledThumbRadius: 8, elevation: 0,
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

              // ── Recipe section header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("TODAY'S RECIPE",
                        style: TextStyle(fontSize: 10, letterSpacing: 3, color: kAsh)),
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
              const SizedBox(height: 8),

              // ── Recipe Tabs (scroll) ──
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 28),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final selected = i == _recipeIdx;
                    return GestureDetector(
                      onTap: () => setState(() => _recipeIdx = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: selected ? kBark : Colors.transparent,
                          border: Border.all(
                            color: selected ? kBark : kParchment,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          filtered[i].name,
                          style: TextStyle(
                            fontSize: 11,
                            color: selected ? kWarmWhite : kAsh,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // ── Recipe Card ──
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.04), end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: Container(
                  key: ValueKey('$_dripper-$_recipeIdx'),
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: tagColor.withOpacity(0.08),
                                border: Border.all(color: tagColor.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                recipe.tag.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9, letterSpacing: 2,
                                  color: tagColor, fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              recipe.name,
                              style: const TextStyle(
                                fontSize: 26, color: kEspresso,
                                fontWeight: FontWeight.w400, height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              recipe.desc,
                              style: const TextStyle(
                                fontSize: 12, color: kAsh, height: 1.6, letterSpacing: 0.2,
                              ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('TIMELINE',
                                    style: TextStyle(fontSize: 9, letterSpacing: 2.5, color: kStone)),
                                Text('TOTAL (ml)',
                                    style: TextStyle(fontSize: 9, letterSpacing: 1.5, color: kStone)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...recipe.steps.asMap().entries.map((entry) {
                              final i = entry.key;
                              final step = entry.value;
                              // cumulative ml ณ step นี้
                              final cumMl = cumulativeMl(recipe.steps, i, water);
                              final hasPour = step.percent > 0;

                              return Column(
                                children: [
                                  const Divider(color: kParchment, height: 1),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      children: [
                                        Text(
                                          fmtTime(step.time),
                                          style: const TextStyle(
                                            fontSize: 14, color: kBark, fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            step.action,
                                            style: const TextStyle(
                                              fontSize: 13, color: kEspresso, height: 1.4,
                                            ),
                                          ),
                                        ),
                                        if (hasPour)
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '$cumMl',
                                                style: const TextStyle(
                                                  fontSize: 16, color: kBark, fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const Text('ml', style: TextStyle(fontSize: 10, color: kStone)),
                                            ],
                                          )
                                        else
                                          const SizedBox(width: 32),
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
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipe.name,
                          style: const TextStyle(
                            fontSize: 24, color: kCream,
                            fontWeight: FontWeight.w300, height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.recipe.dripper.label,
                          style: const TextStyle(fontSize: 11, color: kAsh, letterSpacing: 1),
                        ),
                      ],
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
                      fontSize: 84, color: kWarmWhite,
                      fontWeight: FontWeight.w300, letterSpacing: -1, height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('ELAPSED', style: TextStyle(fontSize: 10, letterSpacing: 3, color: kAsh)),
                ],
              ),
            ),

            const Divider(color: Color(0x12FFFFFF), height: 1, indent: 28, endIndent: 28),

            // ── Steps list ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                itemCount: steps.length,
                itemBuilder: (context, i) {
                  final step = steps[i];
                  final isActive = i == active;
                  final hasPour = step.percent > 0;
                  // cumulative ml สำหรับ timer screen
                  final cumMl = cumulativeMl(steps, i, widget.totalWater);

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
                      ),
                    ),
                    child: Opacity(
                      opacity: isActive ? 1.0 : 0.35,
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 5, height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive ? kAccent : kAsh,
                              boxShadow: isActive
                                  ? [BoxShadow(
                                      color: kAccent.withOpacity(0.3),
                                      blurRadius: 8, spreadRadius: 2,
                                    )]
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            fmtTime(step.time),
                            style: TextStyle(fontSize: 13, color: isActive ? kAccent : kAsh),
                          ),
                          const SizedBox(width: 16),
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
                          // แสดง cumulative ml เฉพาะ step ที่มี pour
                          if (hasPour)
                            Text(
                              '$cumMl ml',
                              style: TextStyle(
                                fontSize: 15,
                                color: isActive ? kAccent : kAsh,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          else
                            const SizedBox(width: 40),
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
                  GestureDetector(
                    onTap: _reset,
                    child: const Text('RESET',
                        style: TextStyle(fontSize: 11, color: kAsh, letterSpacing: 2)),
                  ),
                  GestureDetector(
                    onTap: _toggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _running ? kAccent : Colors.white.withOpacity(0.15),
                          width: 1.5,
                        ),
                        color: _running
                            ? kAccent.withOpacity(0.1)
                            : Colors.white.withOpacity(0.04),
                      ),
                      child: Center(
                        child: _running
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 3, height: 18,
                                    decoration: BoxDecoration(
                                      color: kCream,
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    width: 3, height: 18,
                                    decoration: BoxDecoration(
                                      color: kCream,
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                margin: const EdgeInsets.only(left: 4),
                                child: const Icon(Icons.play_arrow, color: kCream, size: 28),
                              ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('DONE',
                        style: TextStyle(fontSize: 11, color: kAsh, letterSpacing: 2)),
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
