import UIKit
import CoreData
import Photos

class ShootOutProfileViewController: SOTBaseController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editlabelYourLevel: UIButton!
    @IBOutlet weak var labelYourLevel: UILabel!
    @IBOutlet weak var editLabelAge: UIButton!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var editLabelHeight: UIButton!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var editLabelKG: UIButton!
    @IBOutlet weak var labelKG: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
 
    @IBOutlet weak var editImageProfile: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var textfieldName: UITextField!
   
    var activeAlert: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
   
    }


 
   
     private func handleImageSelection() {
         let status = PHPhotoLibrary.authorizationStatus()
         switch status {
         case .authorized:
             self.showImagePicker()
         case .notDetermined:
             PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                 if newStatus == .authorized {
                     DispatchQueue.main.async {
                         self?.showImagePicker()
                     }
                 }
             }
         case .denied, .restricted:
             promptForPhotoLibraryAccess()
         default:
             break
         }
     }

    private func promptForPhotoLibraryAccess() {
        let alert = UIAlertController(title: "Access to Photos Required", message: "Access to photos is needed to choose profile pictures. Please allow access in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            self.activeAlert?.dismiss(animated: true) {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.activeAlert = alert
        present(alert, animated: true)
    }

     private func showImagePicker() {
         let imagePicker = UIImagePickerController()
         imagePicker.delegate = self
         imagePicker.sourceType = .photoLibrary
         present(imagePicker, animated: true)
     }

     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         if let selectedImage = info[.originalImage] as? UIImage {
             imageProfile.image = selectedImage
         }
         picker.dismiss(animated: true, completion: nil)
     }

     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         picker.dismiss(animated: true, completion: nil)
     }

    private func saveProfile() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Profile", in: context)!
        let profile = NSManagedObject(entity: entity, insertInto: context)

        profile.setValue(textfieldName.text, forKey: "name")
        profile.setValue(labelKG.text, forKey: "weight")
        profile.setValue(labelHeight.text, forKey: "height")
        profile.setValue(labelAge.text, forKey: "age")
        profile.setValue(labelYourLevel.text, forKey: "level")

        if let image = imageProfile.image {
            if let data = image.pngData(), let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documents.appendingPathComponent("profile_image.png")
                try? data.write(to: fileURL)
                profile.setValue(fileURL.lastPathComponent, forKey: "imageName")
            }
        }

        do {
            try context.save()
        } catch let error as NSError {
            print("Failed to save profile: \(error), \(error.userInfo)")
        }
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let alert = activeAlert {
            alert.dismiss(animated: false, completion: nil)
            activeAlert = nil
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Если алерт открыт, закрываем его
        if let alert = activeAlert {
            alert.dismiss(animated: false, completion: nil)
            activeAlert = nil
        }
    }
    @IBAction func editImageProfileTapped(_ sender: Any) {
        handleImageSelection()
    }
    
        @IBAction func editYourLevelTapped(_ sender: UIButton) {
            showSelectionAlert(for: .level)
        }

        @IBAction func editAgeTapped(_ sender: UIButton) {
            showSelectionAlert(for: .age)
        }

        @IBAction func editHeightTapped(_ sender: UIButton) {
            showSelectionAlert(for: .height)
        }

        @IBAction func editKGTapped(_ sender: UIButton) {
            showSelectionAlert(for: .weight)
        }

        @IBAction func goBackTapped(_ sender: UIButton) {
            saveProfile()
            navigationController?.popViewController(animated: true)
        }

        private func showSelectionAlert(for field: ProfileField) {
            let alert = UIAlertController(title: "Edit \(field.rawValue)", message: nil, preferredStyle: .actionSheet)

            for option in field.options {
                alert.addAction(UIAlertAction(title: option, style: .default, handler: { _ in
                    switch field {
                    case .level:
                        self.labelYourLevel.text = option
                    case .age:
                        self.labelAge.text = option
                    case .height:
                        self.labelHeight.text = option
                    case .weight:
                        self.labelKG.text = option
                    }
                }))
            }

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }


    }

    enum ProfileField: String {
        case level = "Level"
        case age = "Age"
        case height = "Height"
        case weight = "Weight"

        var options: [String] {
            switch self {
            case .level:
                return ["Beginner", "Intermediate", "Advanced"]
            case .age:
                return (18...60).map { "\($0)" }
            case .height:
                return (140...210).map { "\($0)cm" }
            case .weight:
                return (40...150).map { "\($0)kg" }
            }
        }
    }
