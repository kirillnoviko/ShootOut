import UIKit
import CoreData

enum FilterType2: String, CaseIterable {
    case byCategory = "Sort by Category"
    case bySubcategory = "Sort by Subcategory"
}

class ShootOutVideoViewController: SOTBaseController {

    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var textfieldSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!


    var workouts: [Workout] = []
    var filteredWorkouts: [Workout] = []
    var currentFilter: FilterType2 = .byCategory

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupCollectionView()
        setupSearch()
        loadWorkouts()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FilterCell")
        tableView.isHidden = true
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "VideoTrainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionViewCell")
    }

    func setupSearch() {
        textfieldSearch.delegate = self
        textfieldSearch.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
    }

    func loadWorkouts() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()

        do {
            workouts = try context.fetch(fetchRequest)
            applyFilter(currentFilter)
        } catch let error as NSError {
            print("Failed to fetch workouts: \(error), \(error.userInfo)")
        }
    }

    func applyFilter(_ filter: FilterType2) {
        switch filter {
        case .byCategory:
            filteredWorkouts = workouts.sorted { $0.category ?? "" < $1.category ?? "" }
        case .bySubcategory:
            filteredWorkouts = workouts.sorted { $0.subcategory ?? "" < $1.subcategory ?? "" }
        }
        applySearchFilter() // Учитываем текст поиска
    }

    @objc func searchTextChanged(_ textField: UITextField) {
        applySearchFilter()
    }

    func applySearchFilter() {
        guard let searchText = textfieldSearch.text?.lowercased(), !searchText.isEmpty else {
            collectionView.reloadData() // Показываем все записи, если текст поиска пуст
            return
        }

        // Фильтруем записи по категории или подкатегории
        filteredWorkouts = workouts.filter {
            ($0.category?.lowercased().contains(searchText) ?? false) ||
            ($0.subcategory?.lowercased().contains(searchText) ?? false)
        }
        collectionView.reloadData()
    }

    @IBAction func toggleFilterTable(_ sender: UIButton) {
        tableView.isHidden.toggle()
    }

    @IBAction func goBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension ShootOutVideoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterType2.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        let filter = FilterType2.allCases[indexPath.row]
        cell.textLabel?.text = filter.rawValue
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilter = FilterType2.allCases[indexPath.row]
        currentFilter = selectedFilter
        applyFilter(selectedFilter)
        tableView.isHidden = true
    }
}

extension ShootOutVideoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredWorkouts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as? VideoCollectionViewCell else {
            return UICollectionViewCell()
        }
        let workout = filteredWorkouts[indexPath.row]
        cell.configure(with: workout)
        cell.linkForYuotube.addTarget(self, action: #selector(openYoutubeLink(_:)), for: .touchUpInside)
        cell.linkForYuotube.tag = indexPath.row
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 8, height: 100)
    }

    @objc func openYoutubeLink(_ sender: UIButton) {
        let workout = filteredWorkouts[sender.tag]
        if let urlString = workout.videoLink, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

extension ShootOutVideoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
