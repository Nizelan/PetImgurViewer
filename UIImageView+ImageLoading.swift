import Foundation
import UIKit

extension UIImageView {
    func loadImage(
        from urlString: String,
        completion: ((Bool) -> Void)? = nil,
        shouldAssignImage: (() -> Bool)?,
        with placeholderImage: UIImage? = UIImage(named: "placeholder")
    ) {
        self.image = placeholderImage; // nil if there was no placeholder provided

        NetworkManager().fetchImage(urlString: urlString) { (image) in
            if let shouldAssignImage = shouldAssignImage {
                if shouldAssignImage() == true {
                    self.image = image
                }
            } else {
                self.image = image
            }

            if let completion = completion {
                completion(image != nil)
            }

        }
    }
}
