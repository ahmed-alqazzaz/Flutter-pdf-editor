// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.78.0.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

import 'dart:ffi' as ffi;

abstract class Rust {
  Future<void> initializeLibrary({required String libPath, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kInitializeLibraryConstMeta;

  Future<void> loadPdfFile({required String filepath, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kLoadPdfFileConstMeta;

  Future<List<(Size, int)>> cacheCurrentFile(
      {required String cacheDir, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kCacheCurrentFileConstMeta;

  Future<PageImage> renderPage(
      {required int pageNumber,
      required double scaleFactor,
      RenderRect? renderRect,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kRenderPageConstMeta;

  Future<Size> pageSize({required int pageNumber, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kPageSizeConstMeta;
}

class PageImage {
  final Uint8List data;
  final int pixelWidthCount;
  final int pixelHeightCount;
  final int pageNumber;
  final RenderRect renderRect;

  const PageImage({
    required this.data,
    required this.pixelWidthCount,
    required this.pixelHeightCount,
    required this.pageNumber,
    required this.renderRect,
  });
}

class RenderRect {
  final double top;
  final double left;
  final double width;
  final double height;

  const RenderRect({
    required this.top,
    required this.left,
    required this.width,
    required this.height,
  });
}

class Size {
  final int width;
  final int height;

  const Size({
    required this.width,
    required this.height,
  });
}

class RustImpl implements Rust {
  final RustPlatform _platform;
  factory RustImpl(ExternalLibrary dylib) => RustImpl.raw(RustPlatform(dylib));

  /// Only valid on web/WASM platforms.
  factory RustImpl.wasm(FutureOr<WasmModule> module) =>
      RustImpl(module as ExternalLibrary);
  RustImpl.raw(this._platform);
  Future<void> initializeLibrary({required String libPath, dynamic hint}) {
    var arg0 = _platform.api2wire_String(libPath);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_initialize_library(port_, arg0),
      parseSuccessData: _wire2api_unit,
      constMeta: kInitializeLibraryConstMeta,
      argValues: [libPath],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kInitializeLibraryConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "initialize_library",
        argNames: ["libPath"],
      );

  Future<void> loadPdfFile({required String filepath, dynamic hint}) {
    var arg0 = _platform.api2wire_String(filepath);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_load_pdf_file(port_, arg0),
      parseSuccessData: _wire2api_unit,
      constMeta: kLoadPdfFileConstMeta,
      argValues: [filepath],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kLoadPdfFileConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "load_pdf_file",
        argNames: ["filepath"],
      );

  Future<List<(Size, int)>> cacheCurrentFile(
      {required String cacheDir, dynamic hint}) {
    var arg0 = _platform.api2wire_String(cacheDir);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_cache_current_file(port_, arg0),
      parseSuccessData: _wire2api_list___record__size_i16,
      constMeta: kCacheCurrentFileConstMeta,
      argValues: [cacheDir],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kCacheCurrentFileConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "cache_current_file",
        argNames: ["cacheDir"],
      );

  Future<PageImage> renderPage(
      {required int pageNumber,
      required double scaleFactor,
      RenderRect? renderRect,
      dynamic hint}) {
    var arg0 = api2wire_i16(pageNumber);
    var arg1 = api2wire_f32(scaleFactor);
    var arg2 = _platform.api2wire_opt_box_autoadd_render_rect(renderRect);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_render_page(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_page_image,
      constMeta: kRenderPageConstMeta,
      argValues: [pageNumber, scaleFactor, renderRect],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kRenderPageConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "render_page",
        argNames: ["pageNumber", "scaleFactor", "renderRect"],
      );

  Future<Size> pageSize({required int pageNumber, dynamic hint}) {
    var arg0 = api2wire_i16(pageNumber);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_page_size(port_, arg0),
      parseSuccessData: _wire2api_size,
      constMeta: kPageSizeConstMeta,
      argValues: [pageNumber],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kPageSizeConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "page_size",
        argNames: ["pageNumber"],
      );

  void dispose() {
    _platform.dispose();
  }
// Section: wire2api

  (Size, int) _wire2api___record__size_i16(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 2) {
      throw Exception('Expected 2 elements, got ${arr.length}');
    }
    return (
      _wire2api_size(arr[0]),
      _wire2api_i16(arr[1]),
    );
  }

  double _wire2api_f32(dynamic raw) {
    return raw as double;
  }

  int _wire2api_i16(dynamic raw) {
    return raw as int;
  }

  List<(Size, int)> _wire2api_list___record__size_i16(dynamic raw) {
    return (raw as List<dynamic>).map(_wire2api___record__size_i16).toList();
  }

  PageImage _wire2api_page_image(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 5)
      throw Exception('unexpected arr length: expect 5 but see ${arr.length}');
    return PageImage(
      data: _wire2api_uint_8_list(arr[0]),
      pixelWidthCount: _wire2api_u32(arr[1]),
      pixelHeightCount: _wire2api_u32(arr[2]),
      pageNumber: _wire2api_u8(arr[3]),
      renderRect: _wire2api_render_rect(arr[4]),
    );
  }

  RenderRect _wire2api_render_rect(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 4)
      throw Exception('unexpected arr length: expect 4 but see ${arr.length}');
    return RenderRect(
      top: _wire2api_f32(arr[0]),
      left: _wire2api_f32(arr[1]),
      width: _wire2api_f32(arr[2]),
      height: _wire2api_f32(arr[3]),
    );
  }

  Size _wire2api_size(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 2)
      throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
    return Size(
      width: _wire2api_u32(arr[0]),
      height: _wire2api_u32(arr[1]),
    );
  }

  int _wire2api_u32(dynamic raw) {
    return raw as int;
  }

  int _wire2api_u8(dynamic raw) {
    return raw as int;
  }

  Uint8List _wire2api_uint_8_list(dynamic raw) {
    return raw as Uint8List;
  }

  void _wire2api_unit(dynamic raw) {
    return;
  }
}

// Section: api2wire

@protected
double api2wire_f32(double raw) {
  return raw;
}

@protected
int api2wire_i16(int raw) {
  return raw;
}

@protected
int api2wire_u8(int raw) {
  return raw;
}

// Section: finalizer

class RustPlatform extends FlutterRustBridgeBase<RustWire> {
  RustPlatform(ffi.DynamicLibrary dylib) : super(RustWire(dylib));

// Section: api2wire

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_String(String raw) {
    return api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  @protected
  ffi.Pointer<wire_RenderRect> api2wire_box_autoadd_render_rect(
      RenderRect raw) {
    final ptr = inner.new_box_autoadd_render_rect_0();
    _api_fill_to_wire_render_rect(raw, ptr.ref);
    return ptr;
  }

  @protected
  ffi.Pointer<wire_RenderRect> api2wire_opt_box_autoadd_render_rect(
      RenderRect? raw) {
    return raw == null ? ffi.nullptr : api2wire_box_autoadd_render_rect(raw);
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }
// Section: finalizer

// Section: api_fill_to_wire

  void _api_fill_to_wire_box_autoadd_render_rect(
      RenderRect apiObj, ffi.Pointer<wire_RenderRect> wireObj) {
    _api_fill_to_wire_render_rect(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_opt_box_autoadd_render_rect(
      RenderRect? apiObj, ffi.Pointer<wire_RenderRect> wireObj) {
    if (apiObj != null)
      _api_fill_to_wire_box_autoadd_render_rect(apiObj, wireObj);
  }

  void _api_fill_to_wire_render_rect(
      RenderRect apiObj, wire_RenderRect wireObj) {
    wireObj.top = api2wire_f32(apiObj.top);
    wireObj.left = api2wire_f32(apiObj.left);
    wireObj.width = api2wire_f32(apiObj.width);
    wireObj.height = api2wire_f32(apiObj.height);
  }
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint

/// generated by flutter_rust_bridge
class RustWire implements FlutterRustBridgeWireBase {
  @internal
  late final dartApi = DartApiDl(init_frb_dart_api_dl);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  RustWire(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  RustWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void store_dart_post_cobject(
    DartPostCObjectFnType ptr,
  ) {
    return _store_dart_post_cobject(
      ptr,
    );
  }

  late final _store_dart_post_cobjectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(DartPostCObjectFnType)>>(
          'store_dart_post_cobject');
  late final _store_dart_post_cobject = _store_dart_post_cobjectPtr
      .asFunction<void Function(DartPostCObjectFnType)>();

  Object get_dart_object(
    int ptr,
  ) {
    return _get_dart_object(
      ptr,
    );
  }

  late final _get_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Handle Function(ffi.UintPtr)>>(
          'get_dart_object');
  late final _get_dart_object =
      _get_dart_objectPtr.asFunction<Object Function(int)>();

  void drop_dart_object(
    int ptr,
  ) {
    return _drop_dart_object(
      ptr,
    );
  }

  late final _drop_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>(
          'drop_dart_object');
  late final _drop_dart_object =
      _drop_dart_objectPtr.asFunction<void Function(int)>();

  int new_dart_opaque(
    Object handle,
  ) {
    return _new_dart_opaque(
      handle,
    );
  }

  late final _new_dart_opaquePtr =
      _lookup<ffi.NativeFunction<ffi.UintPtr Function(ffi.Handle)>>(
          'new_dart_opaque');
  late final _new_dart_opaque =
      _new_dart_opaquePtr.asFunction<int Function(Object)>();

  int init_frb_dart_api_dl(
    ffi.Pointer<ffi.Void> obj,
  ) {
    return _init_frb_dart_api_dl(
      obj,
    );
  }

  late final _init_frb_dart_api_dlPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Void>)>>(
          'init_frb_dart_api_dl');
  late final _init_frb_dart_api_dl = _init_frb_dart_api_dlPtr
      .asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  void wire_initialize_library(
    int port_,
    ffi.Pointer<wire_uint_8_list> lib_path,
  ) {
    return _wire_initialize_library(
      port_,
      lib_path,
    );
  }

  late final _wire_initialize_libraryPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64,
              ffi.Pointer<wire_uint_8_list>)>>('wire_initialize_library');
  late final _wire_initialize_library = _wire_initialize_libraryPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_load_pdf_file(
    int port_,
    ffi.Pointer<wire_uint_8_list> filepath,
  ) {
    return _wire_load_pdf_file(
      port_,
      filepath,
    );
  }

  late final _wire_load_pdf_filePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>('wire_load_pdf_file');
  late final _wire_load_pdf_file = _wire_load_pdf_filePtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_cache_current_file(
    int port_,
    ffi.Pointer<wire_uint_8_list> cache_dir,
  ) {
    return _wire_cache_current_file(
      port_,
      cache_dir,
    );
  }

  late final _wire_cache_current_filePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64,
              ffi.Pointer<wire_uint_8_list>)>>('wire_cache_current_file');
  late final _wire_cache_current_file = _wire_cache_current_filePtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_render_page(
    int port_,
    int page_number,
    double scale_factor,
    ffi.Pointer<wire_RenderRect> render_rect,
  ) {
    return _wire_render_page(
      port_,
      page_number,
      scale_factor,
      render_rect,
    );
  }

  late final _wire_render_pagePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Int16, ffi.Float,
              ffi.Pointer<wire_RenderRect>)>>('wire_render_page');
  late final _wire_render_page = _wire_render_pagePtr.asFunction<
      void Function(int, int, double, ffi.Pointer<wire_RenderRect>)>();

  void wire_page_size(
    int port_,
    int page_number,
  ) {
    return _wire_page_size(
      port_,
      page_number,
    );
  }

  late final _wire_page_sizePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Int16)>>(
          'wire_page_size');
  late final _wire_page_size =
      _wire_page_sizePtr.asFunction<void Function(int, int)>();

  ffi.Pointer<wire_RenderRect> new_box_autoadd_render_rect_0() {
    return _new_box_autoadd_render_rect_0();
  }

  late final _new_box_autoadd_render_rect_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_RenderRect> Function()>>(
          'new_box_autoadd_render_rect_0');
  late final _new_box_autoadd_render_rect_0 = _new_box_autoadd_render_rect_0Ptr
      .asFunction<ffi.Pointer<wire_RenderRect> Function()>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_uint_8_list> Function(
              ffi.Int32)>>('new_uint_8_list_0');
  late final _new_uint_8_list_0 = _new_uint_8_list_0Ptr
      .asFunction<ffi.Pointer<wire_uint_8_list> Function(int)>();

  void free_WireSyncReturn(
    WireSyncReturn ptr,
  ) {
    return _free_WireSyncReturn(
      ptr,
    );
  }

  late final _free_WireSyncReturnPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturn)>>(
          'free_WireSyncReturn');
  late final _free_WireSyncReturn =
      _free_WireSyncReturnPtr.asFunction<void Function(WireSyncReturn)>();
}

final class _Dart_Handle extends ffi.Opaque {}

final class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_RenderRect extends ffi.Struct {
  @ffi.Float()
  external double top;

  @ffi.Float()
  external double left;

  @ffi.Float()
  external double width;

  @ffi.Float()
  external double height;
}

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Bool Function(DartPort port_id, ffi.Pointer<ffi.Void> message)>>;
typedef DartPort = ffi.Int64;
