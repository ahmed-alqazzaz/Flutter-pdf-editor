
pub struct PageImage {
    pub data: Vec<u8>,
    pub pixel_width_count: u32,
    pub pixel_height_count: u32,
    pub page_number: u8,
    pub render_rect: RenderRect,
}

impl PageImage {
    pub fn new(data: Vec<u8>, page_number: u8, render_rect: RenderRect, pixel_width_count: u32,
        pixel_height_count: u32) -> Self {
        PageImage {
            data:data,
            page_number: page_number,
            render_rect:render_rect,
            pixel_width_count:pixel_width_count,
            pixel_height_count:pixel_height_count,
        }
    }
}

#[derive(Clone, Copy)]
pub struct RenderRect {
    pub top: f32,
    pub left: f32,
    pub width: f32,
    pub height: f32,
}
impl RenderRect {
    pub fn from_tlwh(top: f32, left: f32, width: f32, height: f32) -> RenderRect {
        RenderRect {
            top,
            left,
            width,
            height,
        }
    }
    pub fn from_tlbr(top: f32, left: f32, bottom: f32, right: f32) -> RenderRect {
        let width = right - left;
        let height = top - bottom;
        RenderRect {
            top,
            left,
            width,
            height,
        }
    }

    pub fn aspect_ratio(&self) -> f32 {
        self.width as f32 / self.height as f32
    }
}
pub struct Size{
    pub width: u32,
    pub height: u32,
}

