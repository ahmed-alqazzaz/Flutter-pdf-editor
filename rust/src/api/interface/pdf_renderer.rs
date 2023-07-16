use super::{pdfium::get_pdfium};
use crate::api::PdfRenderer;
use crate::api::RustPdfRendererError;
use crate::api::RenderRect;
use crate::api::PageImage;
use crate::api::Size;
static mut PDF_RENDERER: Option<Box<PdfRenderer>> = None;


pub fn load_file(pdf_path: String) -> anyhow::Result<()> {
    unsafe {
        PDF_RENDERER = Some(Box::new(PdfRenderer::new(
            &pdf_path.as_str(),
            get_pdfium()?,
        )));
    }
    Ok(())
}
pub fn save_all_pages<F>(path_generator: F) -> anyhow::Result<Vec<(Size, i16)>>
where
    F: Fn(usize) -> String + Sync,
{
    let renderer = unsafe {
        match &PDF_RENDERER {
            Some(pdfium) => Ok(pdfium),
            None => Err(anyhow::anyhow!(RustPdfRendererError::NoFileFound(
                "save all pages: No file has been loaded".to_string()
            ))),
        }
    }?;
    let pages_size = renderer.save_all_pages(path_generator)?;
    Ok(pages_size)
}
pub fn render_page_by_number(
    page_number: i16,
    scale_factor: f32,
    render_rect: Option<RenderRect>,
) -> anyhow::Result<PageImage> {
    let renderer = unsafe {
        match &PDF_RENDERER {
            Some(pdfium) => Ok(pdfium),
            None => Err(anyhow::anyhow!(RustPdfRendererError::NoFileFound(
                "save all pages: No file has been loaded".to_string()
            ))),
        }
    }?;
    renderer.render_page_by_number(page_number, scale_factor, render_rect)
}
pub fn get_page_size(  page_number: i16,)-> anyhow::Result<Size>{
    let renderer = unsafe {
        match &PDF_RENDERER {
            Some(pdfium) => Ok(pdfium),
            None => Err(anyhow::anyhow!(RustPdfRendererError::NoFileFound(
                "save all pages: No file has been loaded".to_string()
            ))),
        }
    }?;
    renderer.get_page_size(page_number)
}