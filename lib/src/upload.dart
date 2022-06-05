part of flutter_uploader;

/// Abstract data structure for storing uploads.
abstract class Upload {
  /// Default constructor which specicies a [url] and [method].
  /// Sub classes may override the method for developer convenience.
  const Upload({
    required this.url,
    required this.method,
    this.headers = const <String, String>{},
    this.contentType,
    this.tag,
    this.allowCellular = true,
    this.progressDivision
  });

  /// Upload link
  final String url;

  /// HTTP method to use for upload (POST,PUT,PATCH)
  final UploadMethod method;

  /// HTTP headers.
  final Map<String, String>? headers;

  /// Data contentType
  final String? contentType;

  /// Name of the upload request (only used on Android)
  final String? tag;

  /// If uploads are allowed to use cellular connections
  /// Defaults to true. If false, uploads will only use wifi connections
  final bool allowCellular;

  /// Must be from 1 to 100
  final int? progressDivision;
}

/// Standard RFC 2388 multipart/form-data upload.
///
/// The platform will generate the boundaries and accompanying information.
class MultipartFormDataUpload extends Upload {
  /// Default constructor which requires either files or data to be set.
  MultipartFormDataUpload({
    required String url,
    UploadMethod method = UploadMethod.POST,
    Map<String, String>? headers,
    String? contentType,
    String? tag,
    this.files,
    this.data,
    bool allowCellular = true,
    int? progressDivision,
  })  : assert(files != null || data != null),
        assert(progressDivision == null || (progressDivision > 0 && progressDivision <= 100)),
        super(
          url: url,
          method: method,
          headers: headers,
          contentType: contentType,
          tag: tag,
          allowCellular: allowCellular,
          progressDivision: progressDivision
        ) {
    // Need to specify either files or data.
    assert(files!.isNotEmpty || data!.isNotEmpty);
  }

  /// files to be uploaded
  final List<FileItem>? files;

  /// additional data. Each entry will be sent as a form field.
  final Map<String, String>? data;
}

/// Also called a binary upload, this represents a upload without any form-encoding applies.
class RawUpload extends Upload {
  /// Default constructor.
  const RawUpload({
    required String url,
    UploadMethod method = UploadMethod.POST,
    Map<String, String>? headers,
    String? tag,
    this.path,
    bool allowCellular = true,
    int? progressDivision,
  }) :  assert(progressDivision == null || (progressDivision > 0 && progressDivision <= 100)),
        super(
          url: url,
          method: method,
          headers: headers,
          tag: tag,
          allowCellular: allowCellular,
          progressDivision: progressDivision
        );

  /// single file to upload
  final String? path;
}
