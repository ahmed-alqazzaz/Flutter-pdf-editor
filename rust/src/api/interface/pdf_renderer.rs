use super::{*, pdfium::get_pdfium};
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
pub fn save_all_pages<F>(path_generator: F) -> anyhow::Result<()>
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
    renderer.save_all_pages(path_generator)?;
    Ok(())
}
pub fn render_page_by_number(
    page_number: i16,
    scale_factor: f32,
    render_rect: Option<RenderRect>,
) -> anyhow::Result<Vec<u8>> {
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