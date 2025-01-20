
import UIKit
import UserNotifications
class ShootOutSettingsViewController: SOTBaseController {
  
   
    @IBOutlet weak var buttonTheme: UIButton!
    @IBOutlet weak var ButtonUnit: UIButton!
    @IBOutlet weak var buttonNotification: UIButton!
    
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var buttonHelp: UIButton!
    @IBOutlet weak var buttonFeedback: UIButton!
    @IBOutlet weak var buttonPrivacy: UIButton!
    
    @IBOutlet  var labelText: [UILabel] = []
    @IBOutlet weak var labelTitle: UILabel!
   

    @IBOutlet weak var labelVersion: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var baseView: UIView!
    
   
    var isNotificationOn = false
    var isThemeOn = false
    var isUnitOn = false
    

    var notificationsEnabled: Bool = false {
           didSet {
               updateButtonTitle()
               saveNotificationState()
           }
       }

       var userDeniedNotification: Bool = false // Флаг для отслеживания отказа пользователя

     
   
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: .themeChanged, object: nil)

        setupTheme()
        updateButtonTitle()

        labelTitle.font = UIFont(name: "Bungee-Regular", size: 32)

        // Настройка текста всех UILabel
        for label in labelText {
            label.font = UIFont(name: "Karla-Regular", size: 24)
        }

        buttonPrivacy.layer.cornerRadius = 12
        buttonFeedback.layer.cornerRadius = 12
        buttonHelp.layer.cornerRadius = 12

        buttonFeedback.titleLabel?.font = UIFont(name: "Bungee-Regular", size: 32)
        buttonPrivacy.titleLabel?.font = UIFont(name: "Bungee-Regular", size: 32)
        buttonHelp.titleLabel?.font = UIFont(name: "Bungee-Regular", size: 32)
        labelVersion.font = UIFont(name: "Karla-Regular", size: 24)

        loadNotificationState()
        checkNotificationAuthorizationStatus()
        setupObservers()
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
     }
    
    // MARK: - Настройка интерфейса
    func setupTheme() {
        // Установка цветов интерфейса в зависимости от текущей темы
        view.backgroundColor = ThemeManager.shared.backgroundColor
        buttonBack.tintColor = ThemeManager.shared.textColor

        buttonFeedback.setTitleColor(ThemeManager.shared.buttonTextColorSettins, for: .normal)
        buttonPrivacy.setTitleColor(ThemeManager.shared.buttonTextColorSettins, for: .normal)

        buttonFeedback.backgroundColor = ThemeManager.shared.buttonBackgroundColorSettins
        buttonPrivacy.backgroundColor = ThemeManager.shared.buttonBackgroundColorSettins
        buttonHelp.backgroundColor = ThemeManager.shared.buttonBackgroundColorSettins

        for label in labelText {
            label.textColor = ThemeManager.shared.textColor
        }

        labelTitle.textColor = ThemeManager.shared.textColor
        labelVersion.textColor = ThemeManager.shared.textColor

        // Обновление изображения кнопки в зависимости от текущей темы
        let imageName = ThemeManager.shared.currentTheme == .light ? "switchTheme" : "switchThemeOFF"
        buttonTheme.setImage(UIImage(named: imageName), for: .normal)
    }


     @objc func updateTheme() {
         UIView.animate(withDuration: 0.3) { [weak self] in
             self?.setupTheme()
         }
     }
    
    
    @IBAction func tappedTheme(_ sender: UIButton) {
        let newTheme: ThemeManager.Theme = ThemeManager.shared.currentTheme == .light ? .dark : .light
        ThemeManager.shared.setTheme(newTheme)

        // Обновляем изображение кнопки
        let imageName = newTheme == .light ? "switchTheme" : "switchThemeOFF"
        buttonTheme.setImage(UIImage(named: imageName), for: .normal)

        // Обновляем интерфейс
        setupTheme()
    }

    @IBAction func tappedBack(_ sender: UIButton) {
        navigateBack()
    }
    // MARK: - Настройка наблюдателей
        func setupObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        }

    

        @objc func appDidBecomeActive() {
            // Проверяем статус разрешений при возвращении в приложение
            checkNotificationAuthorizationStatus()
        }

        // MARK: - Проверка статуса разрешения
        func checkNotificationAuthorizationStatus() {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.getNotificationSettings { settings in
                DispatchQueue.main.async {
                    switch settings.authorizationStatus {
                    case .authorized:
                        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
                        self.userDeniedNotification = false
                    case .denied:
                        self.notificationsEnabled = false
                        self.userDeniedNotification = true
                    default:
                        self.notificationsEnabled = false
                    }
                    self.updateButtonTitle()
                }
            }
        }

        // MARK: - Обработчик нажатия кнопки
        @IBAction func toggleNotifications(_ sender: UIButton) {
            if notificationsEnabled {
                // Уведомления включены, выключаем их
                disableNotifications()
            } else {
                if userDeniedNotification {
                    // Пользователь отказал, предлагаем перейти в настройки
                    redirectToSettings()
                } else {
                    // Пользователь ещё не давал согласия, запрашиваем разрешение
                    requestNotificationAuthorization { granted in
                        if granted {
                            self.enableNotifications()
                        } else {
                            self.userDeniedNotification = true
                            self.notificationsEnabled = false
                        }
                    }
                }
            }
        }

        // MARK: - Запрос разрешений
        func requestNotificationAuthorization(completion: @escaping (Bool) -> Void) {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                DispatchQueue.main.async {
                    if granted {
                        self.enableNotifications()
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }

        // MARK: - Включение уведомлений
        func enableNotifications() {
            scheduleNotifications()
            notificationsEnabled = true
        }

        // MARK: - Выключение уведомлений
        func disableNotifications() {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            notificationsEnabled = false
        }

        // MARK: - Перенаправление в настройки
        func redirectToSettings() {
            let alert = UIAlertController(
                title: "Notifications Disabled",
                message: "To enable notifications, go to Settings and allow notifications for this app.",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)
                }
            })

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }

        // MARK: - Запланировать уведомления
        func scheduleNotifications() {
            let notificationCenter = UNUserNotificationCenter.current()

            // Уведомление 1
            let morningContent = UNMutableNotificationContent()
            morningContent.title = "Morning Workout Reminder"
            morningContent.body = "Time to check your workout schedule for today!"
            morningContent.sound = .default

            var morningTrigger = DateComponents()
            morningTrigger.hour = 8
            let morningRequest = UNNotificationRequest(
                identifier: "morningWorkout",
                content: morningContent,
                trigger: UNCalendarNotificationTrigger(dateMatching: morningTrigger, repeats: true)
            )

            // Уведомление 2
            let eveningContent = UNMutableNotificationContent()
            eveningContent.title = "Evening Workout Reminder"
            eveningContent.body = "Don't forget to check your workout schedule for tomorrow!"
            eveningContent.sound = .default

            var eveningTrigger = DateComponents()
            eveningTrigger.hour = 18
            let eveningRequest = UNNotificationRequest(
                identifier: "eveningWorkout",
                content: eveningContent,
                trigger: UNCalendarNotificationTrigger(dateMatching: eveningTrigger, repeats: true)
            )

            // Добавляем уведомления
            notificationCenter.add(morningRequest)
            notificationCenter.add(eveningRequest)
        }

        // MARK: - Сохранение состояния уведомлений
        func saveNotificationState() {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        }

        // MARK: - Загрузка состояния уведомлений
        func loadNotificationState() {
            notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        }


        // MARK: - Обновление заголовка кнопки
        func updateButtonTitle() {
            let imageName = notificationsEnabled ? "SwitchNotification" : "switchNotificationOFF"
            buttonNotification.setImage(UIImage(named: imageName), for: .normal)
        
        }
    

    





    @IBAction func tappedUnit(_ sender: UIButton) {
        isUnitOn.toggle()
        let imageName = isUnitOn ? "switchUnit" : "switchUnitOFF"
        ButtonUnit.setImage(UIImage(named: imageName), for: .normal)
    }
   
    @IBAction func tappedHelp(_ sender: UIButton) {
        openURL("https://help.example.com")
    }

    @IBAction func tappedFeedback(_ sender: UIButton) {
        openURL("https://feedback.example.com")
    }

    @IBAction func tappedPrivacy(_ sender: UIButton) {
        openURL("https://privacy.example.com")
    }

    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
