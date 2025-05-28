import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/space.dart';
import '../services/database_service.dart';
import '../widgets/0_app_bar_widgets.dart'; // 변경된 위젯 파일명으로 임포트
import 'space_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Space> spaces = [];
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _nameController = TextEditingController();
  
  // 선택된 공간 유형을 추적하기 위한 변수
  String _selectedType = 'home';
  bool _isLoading = true;

  // 총 물품 개수 계산
  int get totalItemCount {
    return spaces.fold(0, (sum, space) => sum + space.itemCount);
  }

  @override
  void initState() {
    super.initState();
    _loadSpaces();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // 데이터베이스에서 공간 목록 로드
  Future<void> _loadSpaces() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final loadedSpaces = await _databaseService.getSpaces();
      setState(() {
        spaces = loadedSpaces;
        _isLoading = false;
      });
      debugPrint('공간 목록 로드 완료: ${spaces.length}개');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('공간 목록 로드 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('공간 목록을 불러오는 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  // 공간 유형 정의 - Material Icons 사용
  final List<Map<String, dynamic>> _spaceTypes = [
    {
      'value': 'home',
      'label': '집',
      'icon': Icons.home,
      'color': Colors.blue,
    },
    {
      'value': 'office',
      'label': '사무실',
      'icon': Icons.business,
      'color': Colors.amber,
    },
    {
      'value': 'storage',
      'label': '창고',
      'icon': Icons.inventory_2,
      'color': Colors.brown,
    },
    {
      'value': 'other',
      'label': '기타',
      'icon': Icons.apps,
      'color': Colors.purple,
    },
  ];

  // 공간 추가 대화상자 표시
  void _showAddSpaceDialog() {
    // 대화상자에서 사용할 임시 상태 변수
    String selectedTypeInDialog = _selectedType;
    _nameController.clear();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // StatefulBuilder로 감싸서 대화상자 내부 상태 변경이 가능하도록 함
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.grey[50],
              title: const Text('새 공간 추가'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: '공간 이름',
                          hintText: '예시) 우리집, 사무실, 창고',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        autofocus: true,
                      ),
                      const SizedBox(height: 16),
                      const Text('공간 유형', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      // 공간 유형 선택 버튼 그룹
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _spaceTypes.map((type) {
                          final isSelected = selectedTypeInDialog == type['value'];
                          
                          return InkWell(
                            onTap: () {
                              setDialogState(() {
                                selectedTypeInDialog = type['value']!;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 60,
                              height: 70,
                              decoration: BoxDecoration(
                                color: isSelected 
                                  ? (type['color'] as Color).withOpacity(0.1) 
                                  : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected 
                                    ? type['color'] as Color
                                    : Colors.grey[400]!,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    type['icon'] as IconData,
                                    color: isSelected 
                                      ? type['color'] as Color
                                      : Colors.grey[600],
                                    size: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    type['label'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected 
                                        ? type['color'] as Color
                                        : Colors.grey[700],
                                      fontWeight: isSelected 
                                        ? FontWeight.bold 
                                        : FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isNotEmpty) {
                      // 대화상자에서 선택한 유형을 외부 상태로 복사
                      _selectedType = selectedTypeInDialog;
                      // 새 공간 추가 메소드 호출
                      _addNewSpace();
                      Navigator.pop(dialogContext);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('저장'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 새 공간 추가
  void _addNewSpace() async {
    final spaceName = _nameController.text.trim();
    if (spaceName.isEmpty) return;
    
    setState(() {
      _isLoading = true;  // 로딩 상태 활성화
    });
    
    try {
      // UUID 생성
      const uuid = Uuid();
      
      // 새 공간 객체 생성
      final newSpace = Space(
        id: uuid.v4(),
        name: spaceName,
        type: _selectedType,
        level: '1',
        itemCount: 0,
      );
      
      // 데이터베이스에 저장
      await _databaseService.insertSpace(newSpace);
      
      // 목록에 새 공간 추가 및 UI 업데이트
      setState(() {
        spaces.add(newSpace);
        _isLoading = false;
      });
      
      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$spaceName 공간이 추가되었습니다')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('공간 추가 중 오류가 발생했습니다: $e')),
        );
      }
      debugPrint('공간 추가 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 커스텀 앱바 사용
      appBar: SpaceAppBar(
        title: 'AI가 관리하는 나만의 공간',
        totalItemCount: totalItemCount,
        onAddPressed: _showAddSpaceDialog,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '내 공간 목록',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 공간 목록 또는 로딩 표시기
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : spaces.isEmpty
                  ? _buildEmptyState()
                  : Wrap(
                      spacing: 10, // 가로 간격
                      runSpacing: 10, // 세로 간격
                      children: spaces.map((space) => _buildSpaceCard(space)).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // 60x60 크기의 공간 카드 위젯
  Widget _buildSpaceCard(Space space) {
    // 아이콘 및 색상 정의
    IconData iconData;
    Color iconColor;
    
    switch (space.type) {
      case 'home':
        iconData = Icons.home;
        iconColor = Colors.blue;
        break;
      case 'office':
        iconData = Icons.business;
        iconColor = Colors.amber;
        break;
      case 'storage':
        iconData = Icons.inventory_2;
        iconColor = Colors.brown;
        break;
      default:
        iconData = Icons.apps;
        iconColor = Colors.purple;
    }
    
    return GestureDetector(
      onTap: () {
        // 공간 선택 시 동작
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${space.name} 공간을 선택했습니다')),
        );
        
        // 나중에 상세 화면 이동 구현:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpaceDetailScreen(space: space),
          ),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: iconColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 24,
              color: iconColor,
            ),
            Text(
              space.name,
              style: TextStyle(
                fontSize: 10,
                color: iconColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '등록된 공간이 없습니다\n앱바의 + 버튼을 눌러 공간을 추가하세요',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
