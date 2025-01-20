import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subcategoriesCollectionView: UICollectionView!

    weak var delegate: ShootOutBaseExercisesCollectionViewCellDelegate?
    private var subcategories: [Subcategory] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        subcategoriesCollectionView.register(
            UINib(nibName: "SubcategoryCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "SubcategoryCollectionViewCell"
        )
        
        subcategoriesCollectionView.delegate = self
        subcategoriesCollectionView.dataSource = self
    }

    func configure(with title: String, subcategories: [Subcategory]) {
        guard  subcategoriesCollectionView != nil else {
            print("Error: titleLabel or subcategoriesCollectionView is nil")
            return
        }

        titleLabel.text = title
        titleLabel.font = UIFont(name: "Bungee-Regular", size: 24)
        titleLabel.textColor = ThemeManager.shared.textColor
        self.subcategories = subcategories
        subcategoriesCollectionView.reloadData()
    }
}

extension MainCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subcategories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubcategoryCollectionViewCell", for: indexPath) as? SubcategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: subcategories[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/5 - 15)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSubcategory = subcategories[indexPath.row]
      
        delegate?.didSelectSubcategory(selectedSubcategory)
        
    }
}
