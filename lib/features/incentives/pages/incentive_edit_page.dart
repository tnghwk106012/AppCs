import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncentiveEditPage extends StatefulWidget {
  final Map<String, dynamic>? data;
  const IncentiveEditPage({Key? key, this.data}) : super(key: key);
  @override
  State<IncentiveEditPage> createState() => _IncentiveEditPageState();
}

class _IncentiveEditPageState extends State<IncentiveEditPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  DateTime? _date;
  late TextEditingController _amountController;
  late TextEditingController _descController;
  late AnimationController _fabController;
  late AnimationController _dateController;
  late Animation<double> _dateAnimation;
  late Animation<double> _fabAnimation;
  
  String selectedCategory = '환자 케이스';
  final List<String> categories = [
    '환자 케이스',
    '팀 미팅',
    '특별 성과',
    '업무 지원',
    '환자 피드백',
    '기타'
  ];

  @override
  void initState() {
    super.initState();
    _date = widget.data?['date'] != null ? DateTime.tryParse(widget.data!['date']) : DateTime.now();
    _amountController = TextEditingController(text: widget.data?['amount']?.toString() ?? '');
    _descController = TextEditingController(text: widget.data?['note'] ?? '');
    
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    
    _dateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _dateAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _dateController, curve: Curves.easeInOut),
    );
    
    _fabAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    _dateController.forward().then((_) => _dateController.reverse());
    
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF5EEAD4),
            surface: Color(0xFF23262F),
            onSurface: Colors.white,
            onPrimary: Colors.black,
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: const Color(0xFF23262F),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  String get dayOfWeek {
    if (_date == null) return '';
    return DateFormat('E', 'ko_KR').format(_date!);
  }

  String get monthYear {
    if (_date == null) return '';
    return DateFormat('yyyy년 MM월', 'ko_KR').format(_date!);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.data != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '성과 편집' : '성과 등록'),
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color(0xFF181A20),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 날짜 선택 카드
              AnimatedBuilder(
                animation: _dateAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _dateAnimation.value,
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF23262F),
                              const Color(0xFF2B3040),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF5EEAD4).withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5EEAD4).withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5EEAD4).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today_rounded,
                                    color: Color(0xFF5EEAD4),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '날짜 선택',
                                        style: TextStyle(
                                          color: Color(0xFF8E95A7),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _date == null
                                            ? '날짜를 선택하세요'
                                            : DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(_date!),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color(0xFF8E95A7),
                                  size: 16,
                                ),
                              ],
                            ),
                            if (_date != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF181A20),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF2B3040),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF5EEAD4).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.event_rounded,
                                        color: Color(0xFF5EEAD4),
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            monthYear,
                                            style: const TextStyle(
                                              color: Color(0xFF8E95A7),
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Text(
                                                DateFormat('dd일', 'ko_KR').format(_date!),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF5EEAD4).withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  dayOfWeek,
                                                  style: const TextStyle(
                                                    color: Color(0xFF5EEAD4),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF5EEAD4).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.today_rounded,
                                        color: Color(0xFF5EEAD4),
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // 카테고리 선택
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF23262F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2B3040),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5EEAD4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.category_rounded,
                            color: Color(0xFF5EEAD4),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '카테고리',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((category) {
                        final isSelected = selectedCategory == category;
                        return GestureDetector(
                          onTap: () => setState(() => selectedCategory = category),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF5EEAD4) : const Color(0xFF2B3040),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF5EEAD4) : const Color(0xFF2B3040),
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.black : const Color(0xFF8E95A7),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 14,
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
              
              // 금액 입력
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF23262F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2B3040),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5EEAD4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.attach_money_rounded,
                            color: Color(0xFF5EEAD4),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '금액',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                          color: Color(0xFF8E95A7),
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        filled: true,
                        fillColor: Color(0xFF23262F),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return '금액을 입력하세요';
                        final n = int.tryParse(v.replaceAll(',', ''));
                        if (n == null || n <= 0) return '유효한 금액을 입력하세요';
                        return null;
                      },
                      onChanged: (v) {
                        final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
                        if (digits.isNotEmpty) {
                          final formatted = NumberFormat('#,###').format(int.parse(digits));
                          if (formatted != v) {
                            _amountController.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(offset: formatted.length),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '원',
                      style: TextStyle(
                        color: Color(0xFF8E95A7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 설명 입력
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF23262F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2B3040),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5EEAD4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.notes_rounded,
                            color: Color(0xFF5EEAD4),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '설명 (선택)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descController,
                      maxLines: 4,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: '성과에 대한 설명을 입력하세요...',
                        hintStyle: TextStyle(
                          color: Color(0xFF8E95A7),
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        filled: true,
                        fillColor: Color(0xFF23262F),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // 저장 버튼
              AnimatedBuilder(
                animation: _fabAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _fabAnimation.value,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5EEAD4),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: const Color(0xFF5EEAD4).withOpacity(0.3),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _fabController.stop();
                            if (mounted) {
                              Navigator.of(context).pop({
                                'date': (_date ?? DateTime.now()).toIso8601String().substring(0, 10),
                                'amount': int.parse(_amountController.text.replaceAll(',', '')),
                                'note': _descController.text.trim().isEmpty ? selectedCategory : _descController.text.trim(),
                              });
                              return;
                            }
                          }
                        },
                        child: Text(
                          isEditing ? '수정' : '등록',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 12),
              
              // 취소 버튼
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF8E95A7),
                    side: const BorderSide(color: Color(0xFF2B3040)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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