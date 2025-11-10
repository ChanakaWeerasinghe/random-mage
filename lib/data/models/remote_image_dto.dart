
import '../../../domain/entities/remote_image.dart';

class RemoteImageDto {
  final String url;
  const RemoteImageDto({required this.url});

  factory RemoteImageDto.fromJson(Map<String, dynamic> json) {
    final raw = (json['url'] as String?)?.trim();
    if (raw == null || raw.isEmpty) {
      throw FormatException('Missing or empty "url" in response');
    }
    return RemoteImageDto(url: raw);
  }

  RemoteImage toEntity() => RemoteImage(url: url);
}
