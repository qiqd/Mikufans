import 'package:flutter/material.dart';
import 'package:mikufans/entities/anime.dart';

class AnimeDetailCard extends StatelessWidget {
  final Anime anime;

  const AnimeDetailCard({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题区域
            _buildTitleSection(),

            SizedBox(height: 16),

            // 图片和基本信息
            _buildImageAndInfoSection(),

            SizedBox(height: 16),

            // 简介
            _buildSummarySection(),

            SizedBox(height: 16),

            // 标签
            _buildTagsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (anime.nameCn != null && anime.nameCn!.isNotEmpty)
          Text(
            anime.nameCn!,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        if (anime.name != null && anime.name!.isNotEmpty)
          Text(
            anime.name!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  Widget _buildImageAndInfoSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 番剧图片
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            anime.image,
            width: 120,
            height: 160,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 120,
                height: 160,
                color: Colors.grey[300],
                child: Icon(
                  Icons.image_not_supported,
                  size: 40,
                  color: Colors.grey[600],
                ),
              );
            },
          ),
        ),

        SizedBox(width: 16),

        // 基本信息
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (anime.date != null && anime.date!.isNotEmpty)
                _buildInfoRow('放送日期', anime.date!),
              if (anime.eps != null) _buildInfoRow('剧集总数', '${anime.eps} 集'),
              if (anime.id != null)
                _buildInfoRow('Bangumi ID', anime.id.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[900])),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    if (anime.summary == null || anime.summary!.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('简介', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(anime.summary!, style: TextStyle(fontSize: 14, height: 1.5)),
      ],
    );
  }

  Widget _buildTagsSection() {
    if (anime.metaTags == null || anime.metaTags!.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('标签', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: anime.metaTags!.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: Colors.blue.withOpacity(0.1),
              labelStyle: TextStyle(fontSize: 12, color: Colors.blue),
            );
          }).toList(),
        ),
      ],
    );
  }
}
