#![allow(
    non_camel_case_types,
    unused,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::double_parens,
    non_snake_case,
    clippy::too_many_arguments
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.78.0.

use crate::api::*;
use core::panic::UnwindSafe;
use flutter_rust_bridge::*;
use std::ffi::c_void;
use std::sync::Arc;

// Section: imports

// Section: wire functions

fn wire_initialize_library_impl(port_: MessagePort, lib_path: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "initialize_library",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_lib_path = lib_path.wire2api();
            move |task_callback| initialize_library(api_lib_path)
        },
    )
}
fn wire_load_pdf_file_impl(port_: MessagePort, filepath: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "load_pdf_file",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_filepath = filepath.wire2api();
            move |task_callback| load_pdf_file(api_filepath)
        },
    )
}
fn wire_cache_current_file_impl(port_: MessagePort, cache_dir: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "cache_current_file",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_cache_dir = cache_dir.wire2api();
            move |task_callback| cache_current_file(api_cache_dir)
        },
    )
}
fn wire_render_page_impl(
    port_: MessagePort,
    page_number: impl Wire2Api<i16> + UnwindSafe,
    scale_factor: impl Wire2Api<f32> + UnwindSafe,
    render_rect: impl Wire2Api<Option<RenderRect>> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "render_page",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_page_number = page_number.wire2api();
            let api_scale_factor = scale_factor.wire2api();
            let api_render_rect = render_rect.wire2api();
            move |task_callback| render_page(api_page_number, api_scale_factor, api_render_rect)
        },
    )
}
fn wire_page_size_impl(port_: MessagePort, page_number: impl Wire2Api<i16> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "page_size",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_page_number = page_number.wire2api();
            move |task_callback| page_size(api_page_number)
        },
    )
}
fn wire_rgba_to_bgra__method__PageImage_impl(
    port_: MessagePort,
    that: impl Wire2Api<PageImage> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "rgba_to_bgra__method__PageImage",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_that = that.wire2api();
            move |task_callback| Ok(PageImage::rgba_to_bgra(&api_that))
        },
    )
}
// Section: wrapper structs

// Section: static checks

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

pub trait Wire2Api<T> {
    fn wire2api(self) -> T;
}

impl<T, S> Wire2Api<Option<T>> for *mut S
where
    *mut S: Wire2Api<T>,
{
    fn wire2api(self) -> Option<T> {
        (!self.is_null()).then(|| self.wire2api())
    }
}

impl Wire2Api<f32> for f32 {
    fn wire2api(self) -> f32 {
        self
    }
}
impl Wire2Api<i16> for i16 {
    fn wire2api(self) -> i16 {
        self
    }
}

impl Wire2Api<u32> for u32 {
    fn wire2api(self) -> u32 {
        self
    }
}
impl Wire2Api<u8> for u8 {
    fn wire2api(self) -> u8 {
        self
    }
}

// Section: impl IntoDart

impl support::IntoDart for PageImage {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.data.into_dart(),
            self.pixel_width_count.into_dart(),
            self.pixel_height_count.into_dart(),
            self.page_number.into_dart(),
            self.render_rect.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for PageImage {}

impl support::IntoDart for RenderRect {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.top.into_dart(),
            self.left.into_dart(),
            self.width.into_dart(),
            self.height.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for RenderRect {}

impl support::IntoDart for Size {
    fn into_dart(self) -> support::DartAbi {
        vec![self.width.into_dart(), self.height.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for Size {}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

#[cfg(not(target_family = "wasm"))]
#[path = "bridge_generated.io.rs"]
mod io;
#[cfg(not(target_family = "wasm"))]
pub use io::*;
