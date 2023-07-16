mod constants;
mod data;
mod errors;

pub use anyhow::anyhow;
pub use constants::*;
pub use data::*;
pub use errors::RustPdfRendererError;
use image::{ImageBuffer, Rgba};
use pdfium_render::prelude::*;
use rayon::prelude::*;
use std::path::Path;
use std::sync::Mutex;

pub struct PdfRenderer<'a> {
    document: PdfDocument<'a>,
    lock: Mutex<()>,
}
impl<'a> PdfRenderer<'a> {
    pub fn new(pdf_path: &str, pdfium: &'static Box<Pdfium>) -> PdfRenderer<'a> {
        let document: PdfDocument<'a> = pdfium
            .load_pdf_from_file(&pdf_path, None)
            .expect("Failed to load PDF document.");

       PdfRenderer {
            document: document,
            lock: Mutex::new(()),
        }
    }

    pub fn save_all_pages<F>(&self, path_generator: F) -> anyhow::Result<Vec<(Size, i16)>>
    where
        F: Fn(usize) -> String + Sync,
    {
        let _lock = self.lock.lock().unwrap();
        let mut saved_pages_size = Vec::new();
        let mut rgba_images = Vec::new();
        for page_number in 0..=self.page_count() - 1 {
            let page = self.get_page_by_number(page_number)?;
            let path = path_generator(page_number as usize);
            saved_pages_size.push((self.get_page_size(page_number)?, page_number));
            if Path::new(&path).exists() {
                continue;
            }

            let transformation_matrix: PdfMatrix =
                self.calculate_transformation_matrix(1.0, page.page_size(), None)?;
            let render_config =
                self.build_render_config(RENDERED_IMAGE_CACHE_WIDTH, transformation_matrix)?;

            let image = self.render_image_rgba(&page, &render_config)?;
            rgba_images.push((image, path));
        }

        rgba_images.par_iter().for_each(|(image, path)| {
            println!("saving {}", &path);
            image
                .save(path)
                .map_err(|err| anyhow!(RustPdfRendererError::PageSaveFailed(err.to_string())))
                .unwrap(); // You can modify error handling here as needed
        });

        Ok(saved_pages_size)
    }


    pub fn render_page_by_number(
        &self,
        page_number: i16,
        scale_factor: f32,
        render_rect: Option<RenderRect>,
    ) -> anyhow::Result<PageImage> {
        let _lock = self.lock.lock().unwrap();
        let page = self.get_page_by_number(page_number)?;
        let transformation_matrix =
            self.calculate_transformation_matrix(scale_factor, page.page_size(), render_rect)?;
        let render_config = self.build_render_config(RENDERED_IMAGE_WIDTH, transformation_matrix)?;
        let rendered_rect = self.calculate_rendered_rect(page.page_size(), transformation_matrix);
        let rendered_image_rgba_data = self.render_image_rgba(&page, &render_config)?; 
        let page_image = PageImage::new(
            rendered_image_rgba_data.to_vec(),
            page_number as u8,
            rendered_rect,
            rendered_image_rgba_data.width(),
            rendered_image_rgba_data.height(),
        );
        Ok(page_image)
    }
}

// helper methods
impl<'a> PdfRenderer<'a> {
    fn render_image_rgba(
        &self,
        page: &PdfPage<'a>,
        render_config: &PdfRenderConfig,
    ) -> anyhow::Result<ImageBuffer<Rgba<u8>, Vec<u8>>> {
        let rendered_page = page
            .render_with_config(render_config)
            .map_err(|err| anyhow!(RustPdfRendererError::PageRenderFailed(err.to_string())))?;

        let image_buffer = rendered_page
            .as_image()
            .as_rgba8()
            .ok_or_else(|| {
                anyhow!(RustPdfRendererError::PageRenderFailed(
                    "Rgba render failed".to_string()
                ))
            })?
            .to_owned();

        Ok(image_buffer)
    }
    fn get_page_by_number(&self, page_number: i16) -> anyhow::Result<PdfPage<'a>> {
        let pages = self.document.pages();

        if page_number < 0 || (page_number as u16) > pages.len() {
            return Err(anyhow!(RustPdfRendererError::PageOutOfRange(page_number)));
        }
        match pages.get(page_number as u16) {
            Ok(page) => Ok(page),
            Err(err) => Err(anyhow!(RustPdfRendererError::PageRetrievalFailed(
                err.to_string()
            ))),
        }
    }

    fn build_render_config(
        &self,
        width: i32,
        transformation_matrix: PdfMatrix,
    ) -> anyhow::Result<PdfRenderConfig> {
        PdfRenderConfig::new()
            .set_target_width(width)
            .rotate_if_landscape(PdfBitmapRotation::Degrees90, true)
            .set_matrix(transformation_matrix)
            .map_err(|err| {
                anyhow!(RustPdfRendererError::InvalidTransformationMatrix(
                    err.to_string()
                ))
            })
    }
    // in case there is a mismatch between the aspect ratio of the
    // pdf page and the requested render aspect ratio,
    // the width and height of the rendered page will
    // be adjusted to main the pdf page aspect ratio
    fn calculate_transformation_matrix(
        &self,
        scale_factor: f32,
        pdf_rect: PdfRect,
        render_rect: Option<RenderRect>,
    ) -> anyhow::Result<PdfMatrix> {
        let aspect_ratio_contrast =
            self.calculate_aspect_ratio_contrast(pdf_rect, render_rect)?;
        let matrix = PdfMatrix {
            a: scale_factor,
            b: 0.0,
            c: 0.0,
            d: scale_factor,
            e: -render_rect.map_or(0.0, |rect| rect.left),
            f: -render_rect.map_or(0.0, |rect| rect.top),
        };
        Ok(matrix)
    }
    fn calculate_aspect_ratio_contrast(
        &self,
        pdf_rect: PdfRect,
        render_rect: Option<RenderRect>,
    ) -> anyhow::Result<f32> {
        if let Some(render_rect) = render_rect {
            let pdf_aspect_ratio = pdf_rect.width().value / pdf_rect.height().value;
            if render_rect.aspect_ratio() >= pdf_aspect_ratio {
                return Ok(render_rect.width / pdf_rect.width().value);
            } else {
                return Ok(render_rect.height / pdf_rect.height().value);
            }
        }
        return Ok(DEFAULT_ASPECT_RATIO_CONTRAST); // Default aspect ratio contrast if render_rect is None
    }
    fn calculate_rendered_rect(
        &self,
        size: PdfRect,
        transformation_matrix: PdfMatrix,
    ) -> RenderRect {
        let (x_zoom, y_zoom) = transformation_matrix.get_scale();
        let x_translation = transformation_matrix.e.abs();
        let y_translation = transformation_matrix.f.abs();
        let render_width = (size.width().value * x_zoom) - x_translation;
        let render_height = (size.height().value * y_zoom) - y_translation;
        RenderRect::from_tlwh(y_translation * y_zoom, x_translation * x_zoom, render_width, render_height)
    }
    fn page_count(&self) -> i16 {
        self.document.pages().len() as i16
    }
    pub fn get_page_size(&self , page_number: i16) -> anyhow::Result<Size>{
        let size = self.get_page_by_number(page_number)?.page_size();
        Ok(
          Size{
          width:size.width().value as u32,
          height:size.height().value as u32,
          }
        )
      }
}
