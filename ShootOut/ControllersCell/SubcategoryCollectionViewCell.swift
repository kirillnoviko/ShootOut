import UIKit

class SubcategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!

    @IBOutlet weak var view: UIView!
    func configure(with subcategory: Subcategory) {
        titleLabel.text = subcategory.title
        descriptionLabel.text = subcategory.description
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
 
        titleLabel.font = UIFont(name: "Bungee-Regular", size: 32)
        descriptionLabel.font = UIFont(name: "Karla-Regular", size: 16)
        
    }
}
