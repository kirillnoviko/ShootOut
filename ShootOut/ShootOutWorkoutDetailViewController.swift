import UIKit
import CoreData

class ShootOutWorkoutDetailViewController: UIViewController {
    @IBOutlet weak var statusButton: UIButton!
        @IBOutlet weak var timeLabel: UILabel!
        @IBOutlet weak var dateLabel: UILabel!
        @IBOutlet weak var exercisesLabel: UILabel!
        @IBOutlet weak var goalLabel: UILabel!

        var workoutSchedule: WorkoutSchedule?

        override func viewDidLoad() {
            super.viewDidLoad()
            configureView()
        }

        func configureView() {
            guard let workout = workoutSchedule else { return }
            
            // Устанавливаем статус и цвет кнопки
            if let startDate = workout.date {
                let endDate = startDate.addingTimeInterval(TimeInterval(workout.duration * 60))
                if Date() >= endDate {
                    statusButton.setTitle("Done", for: .normal)
                    statusButton.backgroundColor = UIColor.green
                } else {
                    statusButton.setTitle("Planned", for: .normal)
                    statusButton.backgroundColor = UIColor.yellow
                }
            } else {
                statusButton.setTitle("Planned", for: .normal)
                statusButton.backgroundColor = UIColor.yellow
            }

            // Устанавливаем время начала и окончания
            if let startDate = workout.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a" // Формат времени
                let startTimeString = formatter.string(from: startDate)
                let endDate = startDate.addingTimeInterval(TimeInterval(workout.duration * 60))
                let endTimeString = formatter.string(from: endDate)
                timeLabel.text = "\(startTimeString) - \(endTimeString)"
            } else {
                timeLabel.text = "Time: Not Set"
            }

            // Устанавливаем дату и день недели
            if let startDate = workout.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE, dd.MM.yyyy" // Формат дня недели и даты
                dateLabel.text = formatter.string(from: startDate)
            } else {
                dateLabel.text = "Date: Not Set"
            }

            // Список упражнений
            if let exercises = workout.exercises as? Set<Workout>, !exercises.isEmpty {
                exercisesLabel.text = exercises.map { $0.subcategory ?? "Unnamed Exercise" }.joined(separator: "\n")
            } else {
                exercisesLabel.text = "No Exercises Assigned"
            }

            // Устанавливаем цель
            goalLabel.text = workout.goal ?? "No Goal Set"
        }
    }
