//
// Created by Joris Van Duyse on 28/12/2023.
//

import SwiftUI

struct PlanetImage: View {
    let planet: PlanetDto

    var body: some View {
        Image(UIImage(named: planet.name) == nil ? "Galaxy" : planet.name)
                .resizable()
                .scaledToFit()
//                .frame(width: 256, height: 256)
//                .cornerRadius(20)
//                .shadow(color: Color.black.opacity(0.2), radius: 4)
//                .padding()
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UIColor {
    var asColor: Color {
        Color(self)
    }
}