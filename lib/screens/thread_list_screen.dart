import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// 홈: 우체통 화면 (받은/보낸/임시/문집 탭)
class ThreadListScreen extends StatefulWidget {
  const ThreadListScreen({super.key});

  @override
  State<ThreadListScreen> createState() => _ThreadListScreenState();
}

class _ThreadListScreenState extends State<ThreadListScreen>
    with SingleTickerProviderStateMixin {
  int _segment = 0; // 0: 받은, 1: 보낸, 2: 임시, 3: 문집

  // 데모용 데이터
  final _inbox = const [
    {
      'id': 'r1',
      'from': '윤슬',
      'title': '여름 한 구절',
      'status': '도착·미개봉',
    },
    {
      'id': 'r2',
      'from': '별비',
      'title': '밤하늘 소인',
      'status': '도착·개봉',
    },
    {
      'id': 'r3',
      'from': '민호',
      'title': '창밖의 비',
      'status': '도착·미개봉',
    },
  ];

  final _sent = const [
    {'id': 's1', 'to': '윤슬', 'title': '초여름의 안부'},
    {'id': 's2', 'to': '별비', 'title': '유성우 소식'},
    {'id': 's3', 'to': '민호', 'title': '비 오는 날의 노래'},
    {'id': 's4', 'to': '세라', 'title': '작은 산책'},
    {'id': 's5', 'to': '도윤', 'title': '책갈피'},
    {'id': 's6', 'to': '지안', 'title': '겨울 메모'},
    {'id': 's7', 'to': '라온', 'title': '파란 잉크'},
  ];

  final _drafts = const [
    {'id': 'd1', 'to': '윤슬', 'title': '여름의 비밀'},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final inboxCount = _inbox.length;
    final sentCount = _sent.length;
    final draftCount = _drafts.length;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerScrolled) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 96,
            title: innerScrolled ? const Text('우체통') : null,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: '새 편지',
                onPressed: () => context.push('/compose/new'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 12),
              expandedTitleScale: 1.6,
              title: const Text('우체통', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => showSearch(context: context, delegate: _LetterSearchDelegate(_inbox)),
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '상대/제목 검색',
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          // 색상은 테마의 InputDecorationTheme를 따르되, 라이트일 때는 살짝 톤 다운
                          fillColor: isDark ? null : Colors.grey.shade100,
                          enabledBorder: isDark
                              ? null
                              : OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                          focusedBorder: isDark
                              ? null
                              : OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.shade400),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoSlidingSegmentedControl<int>(
                    groupValue: _segment,
                    children: {
                      0: Text('받은($inboxCount)'),
                      1: Text('보낸($sentCount)'),
                      2: Text('임시($draftCount)'),
                      3: const Text('문집'),
                    },
                    onValueChanged: (v) => setState(() => _segment = v ?? 0),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Divider(height: 1)),
        ],
        body: Builder(
          builder: (_) {
            switch (_segment) {
              case 0:
                return _InboxList(items: _inbox);
              case 1:
                return _SentList(items: _sent);
              case 2:
                return _DraftList(items: _drafts);
              default:
                return const _CollectionPlaceholder();
            }
          },
        ),
      ),
    );
  }
}

class _InboxList extends StatelessWidget {
  const _InboxList({required this.items});
  final List<Map<String, Object?>> items;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final it = items[i];
        final opened = (it['status']?.toString().contains('개봉') ?? false);
        return ListTile(
          leading: Icon(
            opened ? Icons.mark_email_read_outlined : Icons.mark_email_unread_outlined,
          ),
          title: Text('${it['from']} — "${it['title']}"'),
          trailing: Icon(Icons.chevron_right, color: isDark ? Colors.white30 : Colors.black26),
          onTap: () => context.push('/letter/${it['id']}'),
        );
      },
    );
  }
}

class _SentList extends StatelessWidget {
  const _SentList({required this.items});
  final List<Map<String, Object?>> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final it = items[i];
        return ListTile(
          leading: const Icon(Icons.outbox_outlined),
          title: Text('→ ${it['to']} — "${it['title']}"'),
        );
      },
    );
  }
}

class _DraftList extends StatelessWidget {
  const _DraftList({required this.items});
  final List<Map<String, Object?>> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final it = items[i];
        return ListTile(
          leading: const Icon(Icons.drafts_outlined),
          title: Text('[임시] → ${it['to']} — "${it['title']}"'),
        );
      },
    );
  }
}

class _CollectionPlaceholder extends StatelessWidget {
  const _CollectionPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('모음집(문집) — 나중에 엮은 인용/엽서 보기'),
    );
  }
}

class _LetterSearchDelegate extends SearchDelegate<String?> {
  _LetterSearchDelegate(this.items);
  final List<Map<String, Object?>> items;

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = query.trim();
    final filtered = q.isEmpty
        ? items
        : items
            .where((e) =>
                (e['from']?.toString().contains(q) ?? false) ||
                (e['title']?.toString().contains(q) ?? false))
            .toList();
    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final it = filtered[i];
        final opened = (it['status']?.toString().contains('개봉') ?? false);
        return ListTile(
          leading: Icon(
            opened ? Icons.mark_email_read_outlined : Icons.mark_email_unread_outlined,
          ),
          title: Text('${it['from']} — "${it['title']}"'),
          trailing: Icon(Icons.chevron_right, color: isDark ? Colors.white30 : Colors.black26),
          onTap: () {
            close(context, it['id'] as String);
            context.push('/letter/${it['id']}');
          },
        );
      },
    );
  }
}
