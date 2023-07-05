#[derive(Debug, PartialEq)]
pub enum RustPdfRendererError {
    PdfIumInitializationFailed(String),
    NoFileFound(String),
    InvalidRenderRect(String),
    InvalidTransformationMatrix(String),
    PageRenderFailed(String),
    PageSaveFailed(String),
    PageRetrievalFailed(String),
    PageOutOfRange(i16),

}
impl std::fmt::Display for RustPdfRendererError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        // Implement the Display trait as needed for your error variants
        write!(f, "RustPdfRendererError: {:?}", self)
    }
}

impl std::error::Error for RustPdfRendererError {}
