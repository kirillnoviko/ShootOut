import UIKit

class ShootOutBaseExercisesDetail: SOTBaseController {
    // IBOutlet подключения
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonAddToWorkout: UIButton!
    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var buttonGoVideo: UIButton!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var labelinstructions: UILabel!
    
    // Переменные для хранения данных
    var subcategory: Subcategory?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    private func updateUI() {
        // Проверка, что subcategory не nil
        guard let subcategory = subcategory else {
            return
        }

        // Обновление UI элементов
        titleLabel.text = subcategory.title
        labelDetail.text = subcategory.detail
        labelinstructions.text = subcategory.instructions
    }

    // Конфигурация ViewController с данными подкатегории
    func configure(with subcategory: Subcategory) {
        self.subcategory = subcategory
    }

    // Действия, связанные с кнопками
    @IBAction func tappedAddWorkout(_ sender: Any) {
        
        // Реализация добавления в тренировку
    }
    @IBAction func goBack(_ sender: Any) {
        navigateBack()
        // Возможно, здесь вы хотите закрыть этот ViewController
     
    }
    @IBAction func GoVideo(_ sender: Any) {
        // Переход к видео, связанному с упражнением
    }
}
