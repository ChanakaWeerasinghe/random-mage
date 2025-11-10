import '../core/failure.dart';
import '../core/result.dart';
import '../domain/entities/remote_image.dart';
import 'image_api.dart';
import 'models/remote_image_dto.dart';

class ImageRepository {
  final ImageApi _api;
  const ImageRepository(this._api);

  /// One retry on transient errors, then bubble up.
  Future<Result<RemoteImage>> fetchRandomImage() async {
    try {
      final json = await _api.getRandomImageJson();
      final dto = RemoteImageDto.fromJson(json);
      return Ok(dto.toEntity());
    } catch (e, st) {
      // retry once for network/server-ish failures
      final shouldRetry = e is Failure;
      if (shouldRetry) {
        try {
          final json = await _api.getRandomImageJson();
          final dto = RemoteImageDto.fromJson(json);
          return Ok(dto.toEntity());
        } catch (e2, st2) {
          return Err<RemoteImage>(e2, st2);
        }
      }
      return Err<RemoteImage>(e, st);
    }
  }
}
