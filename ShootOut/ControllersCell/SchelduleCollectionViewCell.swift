import  UIKit

class ScheduleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var buttonStatus: UIButton!

    func configure(with schedule: WorkoutSchedule) {
        // Установка названия тренировки
        nameLabel.text = schedule.name

        // Форматирование и отображение времени начала и окончания тренировки
        if let startTime = schedule.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a" // Отображение в 12-часовом формате с AM/PM
            let startTimeString = formatter.string(from: startTime)

            // Расчет времени окончания тренировки
            let duration = Int(schedule.duration) // Преобразуем Int16 в Int
            let endTime = startTime.addingTimeInterval(TimeInterval(duration * 60)) // Умножаем на 60 для перевода в секунды
            let endTimeString = formatter.string(from: endTime)
            timeLabel.text = "\(startTimeString) - \(endTimeString)"

            // Определение статуса тренировки с учетом конечного времени
            let currentTime = Date()
            if endTime <= currentTime {
                // Если текущее время позже или равно времени окончания тренировки
                buttonStatus.setTitle("Done", for: .normal)
                buttonStatus.backgroundColor = UIColor.green
            } else {
                // Если текущее время меньше времени окончания тренировки
                buttonStatus.setTitle("Planned", for: .normal)
                buttonStatus.backgroundColor = UIColor.yellow
            }
        }
    }

}
