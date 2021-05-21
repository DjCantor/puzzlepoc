import UIKit

extension UIImage {
    /**
        Cuts the shape of the Bézier path from the image, makes the rest transparent and then crops the image to the size of the shape's bounds
     */
    func imageByApplyingClippingBezierPath(_ path: UIBezierPath) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        path.addClip()
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let maskedImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        context.restoreGState()
        UIGraphicsEndImageContext()
        let croppedImage = UIImage(cgImage: maskedImage.cgImage!.cropping(to: path.bounds)!)
        return croppedImage
    }

    /**
            Cuts a transparent shape of the given Bézier path from the image, keeps original size
     */
    func complementer_clip(_ path: UIBezierPath) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        draw(at: .zero)
        context.addPath(path.cgPath)
        context.setBlendMode(.clear)
        context.setFillColor(UIColor.clear.cgColor)
        context.fillPath()
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        context.restoreGState()
        UIGraphicsEndImageContext()
        return capturedImage

    }

    func blackAndWhite() -> UIImage {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
        currentFilter!.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgImage = context.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgImage!)
        return processedImage
    }
}
