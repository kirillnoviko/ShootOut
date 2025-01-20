import  UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var imageVideo: UIImageView!
    
    @IBOutlet weak var linkForYuotube: UIButton!
    @IBOutlet weak var subcategory: UILabel!
    
    override func awakeFromNib() {
         super.awakeFromNib()
       
     }
    func configure(with workout: Workout) {
            // Устанавливаем текст категории
            category.text = workout.category ?? "No Category"
            
            // Устанавливаем текст подкатегории
            subcategory.text = workout.subcategory ?? "No Subcategory"
            
            // Устанавливаем изображение, если оно есть
            if let imageName = workout.imageName {
                imageVideo.image = UIImage(named: imageName)
            } else {
                imageVideo.image = UIImage(named: "Dribbling1") // Стандартное изображение
            }
            
            // Устанавливаем ссылку на YouTube
            if let videoLink = workout.videoLink {
                linkForYuotube.setTitle("Watch Video", for: .normal)
                linkForYuotube.isHidden = false
                linkForYuotube.addTarget(self, action: #selector(openYoutubeLink(_:)), for: .touchUpInside)
                linkForYuotube.accessibilityValue = videoLink
            } else {
                linkForYuotube.setTitle("No Video", for: .normal)
                linkForYuotube.isHidden = true
            }
        }
        
        @objc private func openYoutubeLink(_ sender: UIButton) {
            guard let videoLink = sender.accessibilityValue, let url = URL(string: videoLink) else { return }
            UIApplication.shared.open(url)
        }
}
