use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_initialize_library(port_: i64, lib_path: *mut wire_uint_8_list) {
    wire_initialize_library_impl(port_, lib_path)
}

#[no_mangle]
pub extern "C" fn wire_load_pdf_file(port_: i64, filepath: *mut wire_uint_8_list) {
    wire_load_pdf_file_impl(port_, filepath)
}

#[no_mangle]
pub extern "C" fn wire_cache_current_file(port_: i64, cache_dir: *mut wire_uint_8_list) {
    wire_cache_current_file_impl(port_, cache_dir)
}

#[no_mangle]
pub extern "C" fn wire_render_page(
    port_: i64,
    page_number: i16,
    scale_factor: f32,
    render_rect: *mut wire_RenderRect,
) {
    wire_render_page_impl(port_, page_number, scale_factor, render_rect)
}

#[no_mangle]
pub extern "C" fn wire_page_size(port_: i64, page_number: i16) {
    wire_page_size_impl(port_, page_number)
}

#[no_mangle]
pub extern "C" fn wire_rgba_to_bgra__method__PageImage(port_: i64, that: *mut wire_PageImage) {
    wire_rgba_to_bgra__method__PageImage_impl(port_, that)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_page_image_0() -> *mut wire_PageImage {
    support::new_leak_box_ptr(wire_PageImage::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_render_rect_0() -> *mut wire_RenderRect {
    support::new_leak_box_ptr(wire_RenderRect::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}
impl Wire2Api<PageImage> for *mut wire_PageImage {
    fn wire2api(self) -> PageImage {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<PageImage>::wire2api(*wrap).into()
    }
}
impl Wire2Api<RenderRect> for *mut wire_RenderRect {
    fn wire2api(self) -> RenderRect {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<RenderRect>::wire2api(*wrap).into()
    }
}

impl Wire2Api<PageImage> for wire_PageImage {
    fn wire2api(self) -> PageImage {
        PageImage {
            data: self.data.wire2api(),
            pixel_width_count: self.pixel_width_count.wire2api(),
            pixel_height_count: self.pixel_height_count.wire2api(),
            page_number: self.page_number.wire2api(),
            render_rect: self.render_rect.wire2api(),
        }
    }
}
impl Wire2Api<RenderRect> for wire_RenderRect {
    fn wire2api(self) -> RenderRect {
        RenderRect {
            top: self.top.wire2api(),
            left: self.left.wire2api(),
            width: self.width.wire2api(),
            height: self.height.wire2api(),
        }
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_PageImage {
    data: *mut wire_uint_8_list,
    pixel_width_count: u32,
    pixel_height_count: u32,
    page_number: u8,
    render_rect: wire_RenderRect,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_RenderRect {
    top: f32,
    left: f32,
    width: f32,
    height: f32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_PageImage {
    fn new_with_null_ptr() -> Self {
        Self {
            data: core::ptr::null_mut(),
            pixel_width_count: Default::default(),
            pixel_height_count: Default::default(),
            page_number: Default::default(),
            render_rect: Default::default(),
        }
    }
}

impl Default for wire_PageImage {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_RenderRect {
    fn new_with_null_ptr() -> Self {
        Self {
            top: Default::default(),
            left: Default::default(),
            width: Default::default(),
            height: Default::default(),
        }
    }
}

impl Default for wire_RenderRect {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
