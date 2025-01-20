import UIKit

class ShootOutLoaderViewController: UIViewController {
    @IBOutlet weak var loaderLabel: UILabel!
    var timer: Timer?
    var dots = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        startLoaderAnimation()
    }

    func startLoaderAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.dots = (self.dots % 3) + 1
            self.loaderLabel.text = "Loading" + String(repeating: ".", count: self.dots)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.timer?.invalidate()
            self.navigateToMainScreen()
        }
    }

    func navigateToMainScreen() {
        if let navController = self.navigationController {
            let storyboard = UIStoryboard(name: "SOTMainScreenView", bundle: nil)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "ShootOutMainViewController") as! ShootOutMainViewController

            // Устанавливаем ShootOutMainViewController как rootViewController
            navController.setViewControllers([mainVC], animated: true)
        }
    }
}
