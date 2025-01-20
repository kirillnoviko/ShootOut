import UIKit
import CoreData
enum TableViewMode {
    case exercises
    case duration
}
class ShootOutWorkoutADDViewController: SOTBaseController , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var viewTextFieldGoal: UIView!
    
    @IBOutlet weak var buttonDateAndTime: UIButton!
    @IBOutlet weak var textFieldGoal: UITextField!
    @IBOutlet weak var buttonSelectDuration: UIButton!
    @IBOutlet weak var buttonSelectExercises: UIButton!
    @IBOutlet weak var viewFieldNameWorkout: UIView!
    @IBOutlet weak var textfiledNameWorkout: UITextField!
    @IBOutlet weak var labelTitle: UILabel!
    
  
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dataPicker: UIDatePicker!
    
    var currentMode: TableViewMode?
    var durations = [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, 195, 210, 225, 240] // Продолжительность в минутах
    var workouts: [Workout] = []
    var selectedExercises: Set<Workout> = []
    var selectedDate: Date?
    var selectedDuration: Int? // Duration in minutes
    override func viewDidLoad() {
         super.viewDidLoad()
        setupDatePicker()
        setupGestureRecognizer()
        setupTableView()

        fetchAllWorkoutSchedules()
        // Остальная часть вашего кода инициализации...
    }

    func fetchAllWorkoutSchedules() -> [WorkoutSchedule] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WorkoutSchedule> = WorkoutSchedule.fetchRequest()

        do {
            let workoutSchedules = try context.fetch(fetchRequest)
            print("Fetched \(workoutSchedules.count) workout schedules.")
            // Дополнительно: печатаем детали каждого расписания, если требуется
            workoutSchedules.forEach { schedule in
                print("Workout Schedule: \(schedule.name ?? "Unnamed"), Date: \(schedule.date?.description ?? "no date"), Duration: \(schedule.duration) minutes")
            }
            return workoutSchedules
        } catch let error as NSError {
            print("Failed to fetch workout schedules: \(error), \(error.userInfo)")
            return []
        }
    }

    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.backgroundColor = UIColor(hex: "3C439B")
        tableView.layer.cornerRadius = 40
        tableView.layer.masksToBounds = true
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.2
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowRadius = 6

        // Установка разделителей
        tableView.separatorColor = .clear
      
        tableView.rowHeight = tableView.frame.height / 9 // Делим высоту таблицы на 8 элементов
        

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
    }

        private func setupGestureRecognizer() {
//            var tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
//            tapGesture.cancelsTouchesInView = false
//            view.addGestureRecognizer(tapGesture)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        }

    @objc private func handleScreenTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        // Проверяем, что касание произошло вне области `optionsTableView`
        if !tableView.isHidden && !tableView.frame.contains(location) {
            // Дополнительная проверка, чтобы убедиться, что касание также не находится в области других интерактивных элементов
            if !buttonSelectDuration.frame.contains(location) && !buttonSelectExercises.frame.contains(location) {
                tableView.isHidden = true
            }
        }
        if dataPicker?.frame.contains(location) == false {
            dataPicker?.isHidden = true
            buttonDateAndTime.isHidden = false
        }
        
    }
//    @objc func viewTapped(gesture: UITapGestureRecognizer) {
//        let location = gesture.location(in: view)
//       
//    }
    @IBAction func selectExercisesPressed(_ sender: UIButton) {
        currentMode = .exercises
        tableView.reloadData()
        tableView.isHidden = false
    }

    @IBAction func selectDurationPressed(_ sender: UIButton) {
        currentMode = .duration
        tableView.reloadData()
        tableView.isHidden = false
    }
            
       
            
            @IBAction func saveWorkoutPressed(_ sender: UIButton) {
                saveWorkoutSchedule()
            }
            
            
            
    
    
    


    @IBAction func selectDateAndTimePressed(_ sender: UIButton) {
        if let datePicker = dataPicker {
            if datePicker.isHidden {
      
                datePicker.isHidden = false
                buttonDateAndTime.isHidden = true
                
            } else {
                // Скрываем datePicker, если он уже показан
                datePicker.isHidden = true
                buttonDateAndTime.isHidden = false
            }
        }
    }

    private func setupDatePicker() {
        dataPicker.isHidden = true
        
        dataPicker?.datePickerMode = .dateAndTime
        dataPicker?.preferredDatePickerStyle = .wheels
        // Создаем toolbar
        dataPicker?.minimumDate = Date()
        dataPicker?.backgroundColor = .white

       
        dataPicker?.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }

    @objc func dateChanged() {
        selectedDate = dataPicker?.date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        buttonDateAndTime.setTitle(formatter.string(from: dataPicker!.date), for: .normal)
    }

    @objc func dismissDatePicker() {
        dataPicker?.isHidden = true
        buttonDateAndTime.isHidden = false
    }


    
    private func showExerciseSelection() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()

        do {
            workouts = try context.fetch(fetchRequest)
            let alertController = UIAlertController(title: "Select Exercises", message: "Choose multiple", preferredStyle: .actionSheet)

            for workout in workouts {
                let isSelected = selectedExercises.contains(workout)
                let action = UIAlertAction(title: workout.subcategory! + (isSelected ? " ✓" : ""), style: .default, handler: { [weak self] _ in
                    guard let self = self else { return }
                    if isSelected {
                        self.selectedExercises.remove(workout)
                    } else {
                        self.selectedExercises.insert(workout)
                    }
                    // Обновление текста кнопки, не переоткрывать alert
                    self.buttonSelectExercises.setTitle("Selected Exercises (\(self.selectedExercises.count))", for: .normal)
                })
                alertController.addAction(action)
            }

            let doneAction = UIAlertAction(title: "Done", style: .cancel, handler: { [weak self] _ in
                self?.buttonSelectExercises.setTitle("Selected Exercises (\(self?.selectedExercises.count ?? 0))", for: .normal)
            })
            alertController.addAction(doneAction)
            present(alertController, animated: true, completion: nil)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    private func showDurationSelection() {
        let alertController = UIAlertController(title: "Select Duration", message: nil, preferredStyle: .actionSheet)
        let durations = [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, 195, 210, 225, 240] // продолжительности в минутах
        for duration in durations {
            let action = UIAlertAction(title: "\(duration) minutes", style: .default, handler: { _ in
                self.selectedDuration = duration
                self.buttonSelectDuration.setTitle("\(duration) minutes", for: .normal)
            })
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    private func saveWorkoutSchedule() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let context = appDelegate.persistentContainer.viewContext


        let workoutSchedule = WorkoutSchedule(context: context)
        workoutSchedule.name = textfiledNameWorkout.text ?? "Default Workout Name"
        workoutSchedule.goal = textFieldGoal.text ?? "Default Workout Name"
        workoutSchedule.date = selectedDate ?? Date()
        workoutSchedule.duration = Int16(selectedDuration ?? 0)

        // Связываем выбранные упражнения с расписанием
        for exercise in selectedExercises {
            workoutSchedule.addToExercises(exercise)
        }

        do {
            try context.save()
            navigateBack()
            print("Workout Schedule saved successfully!")
        } catch let error as NSError {
            print("Failed to save the workout schedule: \(error), \(error.userInfo)")
        }
    }



    @IBAction func goBack(_ sender: Any) {
        navigateBack()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentMode {
            
        case .exercises:
            do {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()

                do {
                    self.workouts = try context.fetch(fetchRequest)
                    
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
                return workouts.count
            }
          
        case .duration:
            return durations.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "Bungee-Regular", size: 24)
        cell.textLabel?.numberOfLines = 1 // Одна строка текста
        cell.backgroundColor = .clear
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
           cell.textLabel?.minimumScaleFactor = 0.5 // Минимальный размер шрифта (50% от оригинального)
        cell.selectionStyle = .none
        // Удаление старых разделителей (чтобы избежать дублирования)
        for subview in cell.contentView.subviews {
            if subview.tag == 100 { // Маркер для кастомного разделителя
                subview.removeFromSuperview()
            }
        }

        // Добавление кастомного разделителя только если это не последняя ячейка
 
        switch currentMode {
        case .exercises:
            let workout = workouts[indexPath.row]
            cell.textLabel?.text = workout.subcategory
            cell.accessoryType = selectedExercises.contains(workout) ? .checkmark : .none
            if indexPath.row < workouts.count - 1 {
                // Используем окончательный размер ячейки
                DispatchQueue.main.async {
                    let separator = UIView(frame: CGRect(
                        x: 0,
                        y: cell.contentView.frame.height - 2,
                        width: cell.contentView.frame.width,
                        height: 2
                    ))
                    separator.backgroundColor = .white
                    separator.tag = 100 // Уникальный идентификатор для кастомного разделителя
                    cell.contentView.addSubview(separator)
                }
            }
        case .duration:
            let duration = durations[indexPath.row]
            cell.textLabel?.text = "\(duration) minutes"
            cell.accessoryType = .none
            if indexPath.row < durations.count - 1 {
                // Используем окончательный размер ячейки
                DispatchQueue.main.async {
                    let separator = UIView(frame: CGRect(
                        x: 0,
                        y: cell.contentView.frame.height - 2,
                        width: cell.contentView.frame.width,
                        height: 2
                    ))
                    separator.backgroundColor = .white
                    separator.tag = 100 // Уникальный идентификатор для кастомного разделителя
                    cell.contentView.addSubview(separator)
                }
            }
        default:
            break
        }
        return cell
        
        
        
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentMode {
        case .exercises:
            let workout = workouts[indexPath.row]
            if selectedExercises.contains(workout) {
                selectedExercises.remove(workout)
            } else {
                selectedExercises.insert(workout)
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        case .duration:
            selectedDuration = durations[indexPath.row]
            buttonSelectDuration.setTitle("\(selectedDuration!) minutes", for: .normal)
            tableView.isHidden = true // Скрываем таблицу после выбора
        default:
            break
        }
    }

}

