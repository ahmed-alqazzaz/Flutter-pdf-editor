use super::*;

static mut PDFIUM: Option<Box<Pdfium>> = None;
static INIT_PDFIUM: Once = Once::new();

pub fn get_pdfium<'statix>() -> anyhow::Result<&'static Box<Pdfium>> {
    unsafe {
        match &PDFIUM {
            Some(pdfium) => Ok(pdfium),
            None => Err(anyhow::anyhow!(
                RustPdfRendererError::PdfIumInitializationFailed(
                    "PDFIUM is not initialized".to_string()
                )
            )),
        }
    }
}

pub fn initialize_pdfium(library_path: String) -> anyhow::Result<()> {
    let library = Some(Box::new(Pdfium::new(
        Pdfium::bind_to_library(&library_path).map_err(|err| {
            anyhow!(RustPdfRendererError::PdfIumInitializationFailed(
                err.to_string()
            ))
        })?,
    )));
    INIT_PDFIUM.call_once(|| unsafe {
        PDFIUM = library;
    });
    Ok(())
}
