import UIKit
import CoreData

struct Subcategory {
    let titleCategory: String
    let title: String
    let description: String
    let detail: String
    let instructions: String
    let image : String
    let video: String
}


protocol ShootOutBaseExercisesCollectionViewCellDelegate: AnyObject {
    func didSelectSubcategory(_ subcategory: Subcategory)
}
class ShootOutBaseExercisesViewController: SOTBaseController  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewListTableView: UIView!
    @IBOutlet var viewBase: UIView!
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!



    var categoryTitles: [String] = []

    var categories: [String: [Subcategory]] = [:]
      var filteredTitles: [String] = []
      var selectedFilters: Set<String> = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // Измените функцию для загрузки данных
    func loadCategoriesFromCoreData() {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
           do {
               let results = try context.fetch(request)
               for result in results {
                   let category = result.category ?? "Unknown"
                   let subcategory = Subcategory(titleCategory: result.category ?? "No Subcategory",
                                                 title: result.subcategory ?? "No Description",
                                                 description: result.shortDescription2 ?? "No Subcategory",
                                                 detail: result.detailDescription ?? "No Description" ,
                                                 instructions: result.intructions ?? "No Description",
                                                 image: result.imageName ?? "No Subcategory",
                                                 video: result.videoLink ?? "No Description")
                   if categories[category] == nil {
                       categories[category] = []
                   }
                   categories[category]?.append(subcategory)
               }
               categoryTitles = ["All"] + Array(categories.keys).sorted()
               filteredTitles = categoryTitles
           } catch {
               print("Failed to fetch data: \(error)")
           }
           collectionView.reloadData()
    }
    @IBAction func tappedBack(_ sender: Any) {
        navigateBack()
    }
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
        loadCategoriesFromCoreData()
            collectionView.register(
                  UINib(nibName: "MainCollectionViewCell", bundle: nil),
                  forCellWithReuseIdentifier: "MainCollectionViewCell"
              )
            viewBase.backgroundColor = ThemeManager.shared.backgroundColor

        setupTableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self  // Скрыть фильтр при запуске
        viewListTableView.isHidden = true
        searchBar.delegate = self
        // Изначально отображаем все категории
        filteredTitles = Array(categories.keys)
        setupTapGesture()
       
        }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Жест не блокирует другие взаимодействия
       
            view.addGestureRecognizer(tapGesture)
        
    }



//    // MARK: - Закрытие клавиатуры при нажатии Return
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder() // Закрыть клавиатуру
//        return true
//    }

    // MARK: - Обработчик для скрытия клавиатуры
    @objc private func dismissKeyboard(_ gesture: UITapGestureRecognizer) {
        
        view.endEditing(true) // Закрыть клавиатуру
    }
 deinit {
     NotificationCenter.default.removeObserver(self)
 }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
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
    @IBAction func toggleFilterView(_ sender: UIButton) {
        viewListTableView.isHidden.toggle()
    }

    func applyFilter(for category: String?) {
         if let category = category {
             if category == "All" {
                 filteredTitles = Array(categories.keys)
             } else if categories.keys.contains(category) {
                 filteredTitles = [category]
             } else {
                 filteredTitles = [] // Ничего не найдено
             }
         } else {
             filteredTitles = Array(categories.keys)
         }
         collectionView.reloadData()
     }

    }

extension ShootOutBaseExercisesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTitles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryTitle = filteredTitles[indexPath.row]
        let subcategories = categories[categoryTitle] ?? []

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {
            fatalError("Unable to dequeue MainCollectionViewCell. Check Reuse Identifier or nib registration.")
        }

        cell.delegate = self
        cell.configure(with: categoryTitle, subcategories: subcategories)
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension ShootOutBaseExercisesViewController: ShootOutBaseExercisesCollectionViewCellDelegate {
    func didSelectSubcategory(_ subcategory: Subcategory) {
        
        let storyboard = UIStoryboard(name: "SOTBaseExercisesDetailScreenView", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "ShootOutBaseExercisesDetail") as! ShootOutBaseExercisesDetail
        detailVC.configure(with: subcategory)
        navigateTo(detailVC)
        
        }
    }

extension ShootOutBaseExercisesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         let inputText = textField.text ?? ""
         let searchText = inputText.lowercased()

         if searchText.isEmpty {
             applyFilter(for: "All")
         } else {
             let matchedCategories = categories.keys.filter { $0.lowercased().starts(with: searchText) }
             if matchedCategories.isEmpty {
                 filteredTitles = [] // Ничего не найдено
             } else {
                 filteredTitles = matchedCategories
             }
         }

         collectionView.reloadData()
         textField.resignFirstResponder()
  
         return true
     }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let searchText = currentText.lowercased()
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        applyFilter(for: updatedText)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        filteredTitles = Array(categories.keys)
        collectionView.reloadData()
        return true
    }
}
extension ShootOutBaseExercisesViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryTitles.count
    }
    func tableView(_ tableView: UITableView, layout tableViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: tableView.frame.width, height: tableView.frame.height/7 - 8)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        let category = categoryTitles[indexPath.row]
        cell.textLabel?.text = category
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
        if indexPath.row < categoryTitles.count - 1 {
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

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categoryTitles[indexPath.row]
        applyFilter(for: selectedCategory)
        viewListTableView.isHidden = true // Скрываем фильтр после выбора
    }
}





