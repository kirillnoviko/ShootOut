import UIKit

class SOTBaseController: UIViewController {
    // Навигационный контроллер, используемый всеми наследниками
    var appNavigationController: UINavigationController? {
        return self.navigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Настройка базовых параметров (если нужно)
        configureUI()
    }

    func configureUI() {
        appNavigationController?.setNavigationBarHidden(true, animated: true)
    }

    // Метод для универсальной навигации
    func navigateTo(_ viewController: UIViewController, animated: Bool = true) {
        appNavigationController?.pushViewController(viewController, animated: animated)
    }

    // Метод для возврата назад
    func navigateBack(animated: Bool = true) {
        appNavigationController?.popViewController(animated: animated)
    }
}
