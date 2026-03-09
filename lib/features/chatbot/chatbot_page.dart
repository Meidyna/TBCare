import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════

enum PengirimPesan { user, bot }

class PesanModel {
  final String isi;
  final PengirimPesan pengirim;
  final DateTime waktu;
  final bool isLoading; // true = bubble "sedang mengetik"

  PesanModel({
    required this.isi,
    required this.pengirim,
    required this.waktu,
    this.isLoading = false,
  });
}

// ════════════════════════════════════════════════════════════════
// CHATBOT PAGE
// ════════════════════════════════════════════════════════════════
class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {

  // ── State ────────────────────────────────────────────────────
  final List<PesanModel> _pesanList = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  // ── Pesan sambutan awal bot ──────────────────────────────────
  static const String _pesanSambutan =
      'Halo! Saya asisten virtual TBCare. Saya di sini untuk membantu '
      'Anda dengan informasi tentang Tuberculosis. Ada yang bisa saya bantu?';

  // ── Lifecycle ────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    // Tampilkan pesan sambutan saat halaman dibuka
    _pesanList.add(PesanModel(
      isi: _pesanSambutan,
      pengirim: PengirimPesan.bot,
      waktu: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════════
  // FUNGSI
  // ════════════════════════════════════════════════════════════

  /// Scroll ke paling bawah setelah pesan baru masuk
  void _scrollKeBawah() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Kirim pesan user dan tunggu balasan bot
  Future<void> _kirimPesan() async {
    final teks = _inputController.text.trim();
    if (teks.isEmpty || _isSending) return;

    // Tambah pesan user
    setState(() {
      _pesanList.add(PesanModel(
        isi: teks,
        pengirim: PengirimPesan.user,
        waktu: DateTime.now(),
      ));
      _isSending = true;
      _inputController.clear();
    });
    _scrollKeBawah();

    // Tampilkan bubble "sedang mengetik"
    setState(() {
      _pesanList.add(PesanModel(
        isi: '',
        pengirim: PengirimPesan.bot,
        waktu: DateTime.now(),
        isLoading: true,
      ));
    });
    _scrollKeBawah();

    // ── TODO: Ganti dengan pemanggilan API ──────────────────
    // Contoh integrasi saat API tersedia:
    //
    // try {
    //   final response = await ApiService.kirimPesanChatbot(
    //     pesan: teks,
    //     // Kirim riwayat chat jika API mendukung konteks percakapan:
    //     // riwayat: _pesanList.where((p) => !p.isLoading).map((p) => {
    //     //   'role': p.pengirim == PengirimPesan.user ? 'user' : 'assistant',
    //     //   'content': p.isi,
    //     // }).toList(),
    //   );
    //   _gantiBubbleLoading(response['jawaban']);
    // } catch (e) {
    //   _gantiBubbleLoading('Maaf, terjadi kesalahan. Silakan coba lagi.');
    // }
    //
    // ── Sementara pakai dummy response ─────────────────────
    // TODO: Hapus simulasi ini saat API tersedia
    await Future.delayed(const Duration(seconds: 1));
    _gantiBubbleLoading(
      'Maaf, fitur chatbot sedang dalam pengembangan. '
          'Silakan coba lagi nanti setelah server tersedia.',
    );
  }

  /// Ganti bubble loading dengan jawaban bot
  void _gantiBubbleLoading(String jawaban) {
    setState(() {
      // Hapus bubble loading terakhir
      final idxLoading =
      _pesanList.lastIndexWhere((p) => p.isLoading);
      if (idxLoading != -1) {
        _pesanList[idxLoading] = PesanModel(
          isi: jawaban,
          pengirim: PengirimPesan.bot,
          waktu: DateTime.now(),
        );
      }
      _isSending = false;
    });
    _scrollKeBawah();
  }

  // ════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.mainBackground,
      body: Column(
        children: [

          // ── Header ──────────────────────────────────────────
          _buildHeader(width, topPadding),

          // ── Daftar pesan ────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(
                  width * 0.04, 16, width * 0.04, 8),
              itemCount: _pesanList.length,
              itemBuilder: (context, index) {
                return _buildBubble(_pesanList[index], width);
              },
            ),
          ),

          // ── Disclaimer ──────────────────────────────────────
          _buildDisclaimer(width),

          // ── Input bar ───────────────────────────────────────
          _buildInputBar(width, bottomPadding),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // WIDGET BUILDERS
  // ════════════════════════════════════════════════════════════

  Widget _buildHeader(double width, double topPadding) {
    return Container(
      width: width,
      padding: EdgeInsets.only(
        top: topPadding + 10,
        left: 4,
        right: width * 0.04,
        bottom: 12,
      ),
      decoration: const BoxDecoration(color: AppTheme.buttonBackground),
      child: Row(
        children: [
          // Tombol kembali
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: width * 0.02),

          // Avatar bot
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 10),

          // Nama & status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'TBCare Assistant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.042,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF66FF99),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Bubble pesan — kiri untuk bot, kanan untuk user
  Widget _buildBubble(PesanModel pesan, double width) {
    final isUser = pesan.pengirim == PengirimPesan.user;
    final waktu =
        '${pesan.waktu.hour.toString().padLeft(2, '0')}:'
        '${pesan.waktu.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          // Avatar bot (kiri)
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.buttonBackground.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: AppTheme.buttonBackground,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Bubble
          Column(
            crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: width * 0.68),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isUser
                      ? const Color(0xFFE8824A) // oranye untuk user
                      : Colors.white,           // putih untuk bot
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isUser ? 16 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                // Isi bubble: loading dots atau teks
                child: pesan.isLoading
                    ? _buildLoadingDots()
                    : Text(
                  pesan.isi,
                  style: TextStyle(
                    fontSize: 13,
                    color: isUser ? Colors.white : Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Waktu
              Text(
                waktu,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),

          // Avatar user (kanan)
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFE8824A).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xFFE8824A),
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Animasi tiga titik "sedang mengetik"
  Widget _buildLoadingDots() {
    return SizedBox(
      width: 40,
      height: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          return _AnimatedDot(delay: Duration(milliseconds: i * 200));
        }),
      ),
    );
  }

  /// Disclaimer di atas input bar
  Widget _buildDisclaimer(double width) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              color: Colors.orange.shade600, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Chatbot ini hanya memberikan jawaban dalam konteks '
                  'edukasi bukan sebagai diagnosis',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Input bar di bagian bawah
  Widget _buildInputBar(double width, double bottomPadding) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          width * 0.04, 10, width * 0.04, bottomPadding + 10),
      decoration: BoxDecoration(
        color: AppTheme.mainBackground,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [

          // Field input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: _inputController,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: 13),
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Ketik Pertanyaan Anda...',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400, fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _kirimPesan(),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Tombol kirim
          GestureDetector(
            onTap: _kirimPesan,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _isSending
                    ? Colors.grey.shade300
                    : AppTheme.buttonBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send_rounded,
                color: _isSending ? Colors.grey.shade500 : Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// ANIMATED DOT — titik animasi untuk bubble "sedang mengetik"
// ════════════════════════════════════════════════════════════════
class _AnimatedDot extends StatefulWidget {
  final Duration delay;
  const _AnimatedDot({required this.delay});

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _animation.value),
        child: Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: AppTheme.buttonBackground.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}