mod pdf_renderer;
mod interface;
use image::{ImageBuffer, Rgba};
use interface::pdfium::initialize_pdfium;

pub use std::time::Instant;
pub use interface::RenderRect;
pub use interface::PageImage;
pub use crate::interface::pdf_renderer::*;
pub use crate::interface::pdfium;

pub fn initialize_library(lib_path: String) -> anyhow::Result<()>{
   initialize_pdfium(lib_path)
}
pub fn load_pdf_file(filepath: String) -> anyhow::Result<()>{
   load_file(filepath)
}
pub fn cache_files(cache_dir: String)-> anyhow::Result<()>{
    save_all_pages(|index| format!("{}image{}.png",cache_dir, index))
}
pub fn render_page( page_number: i16,
    scale_factor: f32,
    render_rect: Option<RenderRect>,
) -> anyhow::Result<PageImage>{
  render_page_by_number(page_number, scale_factor, render_rect)
}