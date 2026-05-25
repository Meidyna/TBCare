import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'konten_edukasi_page.dart';

class DetailArtikelPage extends StatelessWidget {
  final KontenEdukasiModel konten;

  const DetailArtikelPage({super.key, required this.konten});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final topPadding = MediaQuery.of(context).padding.top;
    const double headerContentHeight = 100.0;
    final double headerTotal = topPadding + headerContentHeight;
    const double cardOverlap = 20.0;
    final double cardTopOffset = headerTotal - cardOverlap;

    return Scaffold(
      backgroundColor: AppTheme.mainBackground,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildHeader(context, width, headerTotal, topPadding),
          ),

          Positioned(
            top: cardTopOffset,
            left: 0, right: 0, bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 32),
              child: _buildCardUtama(width),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double width,
      double headerTotal, double topPadding) {
    return Container(
      height: headerTotal,
      width: width,
      padding: EdgeInsets.only(
        top: topPadding + 10,
        left: 4,
        right: width * 0.05,
        bottom: 12,
      ),
      decoration: const BoxDecoration(color: AppTheme.buttonBackground),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: width * 0.02),
          Expanded(
            child: Text(
              konten.judul,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardUtama(double width) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.buttonBackground.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.article_outlined,
                  color: AppTheme.buttonBackground,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      konten.judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.buttonBackground.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        konten.tipe,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.buttonBackground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade100, thickness: 1),
          const SizedBox(height: 12),
          _buildIsiArtikel(width),
        ],
      ),
    );
  }

  Widget _buildIsiArtikel(double width) {
    final isi = (konten.isi != null && konten.isi!.isNotEmpty)
        ? konten.isi!
        : konten.deskripsi;

    final paragrafList = isi.split('\n').map((e) => e.trim()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragrafList.map((baris) {
        if (baris.isEmpty) return const SizedBox(height: 8);

        final bool isBullet = baris.startsWith('•');
        final bool isHeading = !isBullet &&
            !baris.startsWith(RegExp(r'[0-9]')) &&
            baris.endsWith(':');
        final bool isNumbered = baris.startsWith(RegExp(r'[0-9]+\.'));

        if (isHeading) {
          return Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 4),
            child: Text(
              baris,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          );
        } else if (isNumbered) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 2),
            child: Text(
              baris,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          );
        } else if (isBullet) {
          return Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    color: AppTheme.buttonBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Expanded(
                  child: Text(
                    baris.substring(2),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              baris,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}