import UIKit
import CoreData

struct Record {
    var date: Date
    var name: String
}
enum FilterType: String, CaseIterable {
    case all = "All"
    case future = "Future"
    case completed = "Completed"
}
class ShootOutWorkoutViewController: SOTBaseController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var tableFilter: UITableView!
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var collectionViewSchedule: UICollectionView!
    @IBOutlet weak var collectionViewDate: UICollectionView!
    let dates = [Date().addingTimeInterval(3 * -86400), Date().addingTimeInterval(2 * -86400), Date().addingTimeInterval(-86400), Date(), Date().addingTimeInterval(86400), Date().addingTimeInterval(2 * 86400), Date().addingTimeInterval(3 * 86400)] // Пример данных для отображения
        
    var filteredData: [WorkoutSchedule] = [] // Это данные для отображения, отфильтрованные по дате
    var selectedDate: Date? = Date() // Это выбранная дата
     
    @IBAction func addWokout(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SOTWorkoutADDScreenView", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "ShootOutWorkoutADDViewController") as! ShootOutWorkoutADDViewController
        navigateTo(settingsVC)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настроить UICollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionViewDate.collectionViewLayout = layout
        collectionViewDate.dataSource = self
        collectionViewDate.delegate = self
        collectionViewDate.backgroundColor = .clear
        collectionViewDate.register(
              UINib(nibName: "CellDateWorkout", bundle: nil),
              forCellWithReuseIdentifier: "CellDateWorkout"
          )
        
        
        
        selectedDate = dates[3]
        loadAndFilterRecords(for: selectedDate ?? Date())
        // Фильтруем записи по выбранной дате
//        filteredData = getRecords(for: selectedDate)
        
        // Обновляем коллекцию
        collectionViewDate.reloadData()
       
        collectionViewSchedule.register(
              UINib(nibName: "CellForScheldule", bundle: nil),
              forCellWithReuseIdentifier: "ScheduleCollectionViewCell"
          )
        collectionViewSchedule.dataSource = self
        collectionViewSchedule.delegate = self
        collectionViewSchedule.backgroundColor = .clear
        collectionViewSchedule.reloadData()
        
        tableFilter.delegate = self
            tableFilter.dataSource = self
            tableFilter.isHidden = true
            tableFilter.register(UITableViewCell.self, forCellReuseIdentifier: "FilterCell")

        
    }
    @IBAction func toggleFilterTable(_ sender: UIButton) {
        tableFilter.isHidden.toggle()
    }
    func applyFilter(_ filter: FilterType) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WorkoutSchedule> = WorkoutSchedule.fetchRequest()

        do {
            let allSchedules = try context.fetch(fetchRequest)
            let currentTime = Date()
            let selectedDateWithoutTime = Calendar.current.startOfDay(for: selectedDate ?? Date()) // Убираем время

            switch filter {
            case .all:
                // Отображаем все записи для выбранной даты
                filteredData = allSchedules.filter {
                    guard let workoutDate = $0.date else { return false }
                    let workoutDateWithoutTime = Calendar.current.startOfDay(for: workoutDate)
                    return workoutDateWithoutTime == selectedDateWithoutTime
                }
            case .future:
                // Отображаем записи для выбранной даты, которые еще не завершились
                filteredData = allSchedules.filter {
                    guard let workoutDate = $0.date else { return false }
                    let workoutDateWithoutTime = Calendar.current.startOfDay(for: workoutDate)
                    let endTime = workoutDate.addingTimeInterval(TimeInterval($0.duration * 60))
                    return workoutDateWithoutTime == selectedDateWithoutTime && endTime > currentTime
                }
            case .completed:
                // Отображаем записи для выбранной даты, которые уже завершились
                filteredData = allSchedules.filter {
                    guard let workoutDate = $0.date else { return false }
                    let workoutDateWithoutTime = Calendar.current.startOfDay(for: workoutDate)
                    let endTime = workoutDate.addingTimeInterval(TimeInterval($0.duration * 60))
                    return workoutDateWithoutTime == selectedDateWithoutTime && endTime <= currentTime
                }
            }

            collectionViewSchedule.reloadData()
        } catch let error as NSError {
            print("Failed to fetch workout schedules: \(error), \(error.userInfo)")
        }
    }

    func loadAndFilterRecords(for selectedDate: Date) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WorkoutSchedule> = WorkoutSchedule.fetchRequest()

        // Форматируем даты для сравнения без учета времени
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        do {
            let allSchedules = try context.fetch(fetchRequest)
            filteredData = allSchedules.filter {
                guard let workoutDate = $0.date else { return false }
                return dateFormatter.string(from: workoutDate) == dateFormatter.string(from: selectedDate)
            }
            collectionViewSchedule.reloadData()
        } catch let error as NSError {
            print("Failed to fetch workout schedules: \(error), \(error.userInfo)")
        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewSchedule {
            return filteredData.count
        } else {
            return 7 // Для collectionViewDate
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
     
        
        
        if collectionView == collectionViewSchedule {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCollectionViewCell", for: indexPath) as? ScheduleCollectionViewCell else {
                 return UICollectionViewCell()
             }
             let record = filteredData[indexPath.row]
             cell.configure(with: record)
             return cell
         } else {
             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellDateWorkout", for: indexPath) as? CellDateWorkout else {
                 return UICollectionViewCell()
             }
             let date = dates[indexPath.row]
             if date == selectedDate {
                
                 cell.contentView.layer.cornerRadius = 10
                 cell.contentView.layer.masksToBounds = true
                 cell.contentView.backgroundColor = UIColor.hex(0x397EB4) // Цвет для выделенной ячейки
                   } else {
                       cell.contentView.backgroundColor = .clear // Обычный цвет
                   }
             cell.configure(with: date)
             return cell
         }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewSchedule {
            // Получаем выбранный объект
               let selectedWorkout = filteredData[indexPath.item]

               // Инициализируем контроллер с подробностями
               let storyboard = UIStoryboard(name: "SOTWorkoutDetailScreenView", bundle: nil) // Замените "Main" на имя вашего Storyboard
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "ShootOutWorkoutDetailViewController") as? ShootOutWorkoutDetailViewController{
                detailVC.workoutSchedule = selectedWorkout
                navigateTo(detailVC)
            }

        }else{
            selectedDate = dates[indexPath.item]
            loadAndFilterRecords(for: selectedDate ?? Date())
            collectionViewDate.reloadData()
        }
     
    }
    // Настройка размера ячеек (если нужно изменить размер)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewDate.frame.width / 7 - 8 , height: 57 )
    }
    
  

  
}
extension ShootOutWorkoutViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        let filter = FilterType.allCases[indexPath.row]
        cell.textLabel?.text = filter.rawValue
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilter = FilterType.allCases[indexPath.row]
        applyFilter(selectedFilter) // Применяем фильтр
        tableFilter.isHidden = true // Скрываем таблицу
    }
}


class CellDateWorkout: UICollectionViewCell {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(with date: Date) {
        let dateFormatter = DateFormatter()
        
        // Настроим формат для дня недели (первая буква)
        dateFormatter.dateFormat = "E" // 'E' - короткая версия дня недели
        let dayOfWeek = dateFormatter.string(from: date).prefix(1).uppercased() // Первая буква дня недели
        
        // Настроим формат для числа
        dateFormatter.dateFormat = "d" // 'd' - день месяца
        let dayNumber = dateFormatter.string(from: date)
        
        
        viewBackground.layer.cornerRadius = 10
        viewBackground.layer.masksToBounds = true
        // Устанавливаем текст в метки
        dayLabel.text = dayOfWeek
        dateLabel.text = dayNumber
    }
}
