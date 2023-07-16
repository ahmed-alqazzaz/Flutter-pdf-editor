mod pdf_renderer;
mod interface;

pub use interface::pdfium::initialize_pdfium;
pub use crate::api::pdf_renderer::RenderRect;
pub use crate::api::pdf_renderer::PageImage;
pub use crate::api::pdf_renderer::RustPdfRendererError;
pub use crate::api::pdf_renderer::PdfRenderer;
pub use crate::api::interface::pdf_renderer::load_file;
pub use crate::api::interface::pdf_renderer::save_all_pages;
pub use crate::api::interface::pdf_renderer::render_page_by_number;
pub use crate::api::pdf_renderer::Size;
pub use crate::api::interface::pdf_renderer::get_page_size;
use rayon::prelude::*;
pub fn initialize_library(lib_path: String) -> anyhow::Result<()>{
   initialize_pdfium(lib_path)
}
pub fn load_pdf_file(filepath: String) -> anyhow::Result<()>{
   load_file(filepath)
}
pub fn cache_current_file(cache_dir: String) -> anyhow::Result<Vec<(Size, i16)>>{
  save_all_pages(|index| format!("{}/image{}.png", cache_dir, index+1))
}
pub fn render_page( page_number: i16,
    scale_factor: f32,
    render_rect: Option<RenderRect>,
) -> anyhow::Result<PageImage>{
  render_page_by_number(page_number -1, scale_factor, render_rect)
}
pub fn page_size(page_number: i16) -> anyhow::Result<Size>{
  get_page_size(page_number)
}


impl PageImage {
  pub fn rgba_to_bgra(&self) -> Vec<u8> {
      let mut bgra_pixels: Vec<u8> = self.data.to_vec();
  
      bgra_pixels.par_chunks_exact_mut(4).for_each(|pixel| {
          let r = pixel[0];
          let b = pixel[2];
  
          pixel[0] = b;
          pixel[2] = r;
      });
  
      bgra_pixels
  }
}