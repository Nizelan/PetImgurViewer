import Foundation
import UIKit

extension UIImageView {
    func loadImage(
        from urlString: String, completion: ((Bool) -> Void)? = nil,
        with placeholderImage: UIImage? = UIImage(named: "placeholder")
    ) {
        self.image = placeholderImage; // nil if there was no placeholder provided

        NetworkManager().fetchImage(urlString: urlString) { (image) in
            self.image = image

            if let completion = completion {
                completion(image != nil)
            }
        }
    }
}
