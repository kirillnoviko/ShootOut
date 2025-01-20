import UIKit
import CoreData

class ShootOutMainViewController: SOTBaseController, UITableViewDelegate, UITableViewDataSource {
    var SOTNavigationController: UINavigationController?
    
    @IBOutlet weak var buttonBurger: UIButton!
    
      
    let menuItems = [
        "Workout", "Base of exercises", "Goals and progress", "Video training",
        "Game scenarios", "Trainers", "Entertainment", "Settings"
    ]

 
    @IBOutlet weak var tableView: UITableView!


    @IBOutlet weak var dimmedView: UIView!
    
    override func viewDidLoad() {
          super.viewDidLoad()
          setupTableView()
          setupDimmedView()

                
            // Проверяем, запускалось ли приложение ранее
            if !UserDefaults.standard.bool(forKey: "isDataLoaded") {
                loadInitialData()
                UserDefaults.standard.set(true, forKey: "isDataLoaded")
            }
        
            

        

          tableView.isHidden = true // Таблица скрыта при запуске
      }
    
    private func loadInitialData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Данные для загрузки
        let initialData = [
            ["category": "Dribbling", "subcategory": "Slalom", "shortDescription": "Dribbling the ball around set cones.", "detailDescription": "This exercise helps players improve their ball control and agility by weaving the ball around cones. It emphasizes precise touches, body coordination, and footwork while dribbling.", "intructions": "Set Up: Place cones in a straight line, spaced about 1-2 meters apart.Starting Position: Stand at the starting cone with the ball at your feet. Dribble Through: Use small touches to guide the ball around each cone, alternating feet if possible. Focus: Keep your head up to improve spatial awareness while maintaining control. Complete the Course: Dribble to the last cone and return to the starting position. Repeat: Perform the drill 3-5 times, increasing speed as you gain confidence.", "imageName": "Dribbling1", "videoLink": "https://youtu.be/12qnPEGcedQ?si=1XHDbFrE961oOrpm"],
            ["category": "Dribbling", "subcategory": "Close Touch", "shortDescription": "Quick ball control alternating inner and outer foot touches.",  "detailDescription": "This drill focuses on close ball control using both the inner and outer parts of the feet. It's ideal for building quick reflexes and enhancing precision in tight spaces.", "intructions": "Set Up: Choose a flat, open area with no obstacles. Starting Position: Stand with the ball directly in front of you. Dribbling Motion: Begin tapping the ball lightly between your feet using the inside and outside of each foot. Maintain Speed: Keep the ball close and under control, gradually increasing the pace. Stay Light: Use light touches to avoid losing control of the ball. Time It: Perform the drill for 30-60 seconds, rest, and repeat for 3 sets.",  "imageName": "Dribbling2", "videoLink": "https://youtu.be/Lb7fnryhkiY?si=Afo96IKYcbiLyzUG"],
            ["category": "Dribbling", "subcategory": "Figure Eight", "shortDescription": "Dribbling the ball in an eight shape between two cones.",  "detailDescription": "This exercise improves precision, ball handling, and tight turns by guiding the ball in a figure-eight pattern between two cones.", "intructions": "Set Up: Place two cones about 2-3 meters apart. Starting Position: Position yourself with the ball near one cone. Dribble in a Circle: Move the ball around the first cone in a tight circle using both feet. Switch Direction: Transition to the second cone, creating a figure-eight pattern. Keep Control: Focus on smooth, controlled movements without hitting the cones. Repeat: Continue the figure-eight pattern for 2-3 minutes, increasing speed over time.",  "imageName": "Dribbling3", "videoLink": "https://youtu.be/OcZ_MomtPXY?si=VifGTo-my28yYUf-"],
            ["category": "Dribbling", "subcategory": "Control", "shortDescription": "Dribbling with acceleration and deceleration.",  "detailDescription": "This drill enhances your ability to manage the ball at different speeds, mimicking real-game scenarios that require sudden changes in pace.", "intructions": "Set Up: Mark a 10-15 meter stretch of open space. Starting Position: Begin at one end of the stretch with the ball. Accelerate: Dribble the ball forward quickly, using your laces for long touches. Decelerate: Slow down by switching to small, controlled touches. Repeat Pattern: Alternate between bursts of speed and controlled slowing. Duration: Perform the drill for 3-5 minutes, focusing on smooth transitions.",  "imageName": "Dribbling4", "videoLink": "https://youtu.be/_tHAD1Quyao?si=ilZWjbCPLUPlbSRP"],
            ["category": "Dribbling", "subcategory": "1v1", "shortDescription": "Dribbling past a dummy defender (cone or player).",  "detailDescription": "This exercise simulates game-like conditions where a player must maneuver around a defender. It enhances decision-making, quick movements, and ball control under pressure.", "intructions": "Set Up: Place one cone (or assign a partner) to act as the defender. Starting Position: Stand about 3-5 meters away from the cone/defender with the ball. Approach: Dribble toward the cone at a controlled pace. Maneuver: Use a feint or quick move (e.g., step-over, body feint) to bypass the cone. Accelerate: Once past the cone, increase your speed to maintain control.Repeat: Perform the drill 5-10 times, experimentin",  "imageName": "Dribbling5", "videoLink": "https://youtu.be/0uU7nqi9UqE?si=FuGNRZ5kPU0SSt9y"],
            
            ["category": "Shooting", "subcategory": "Target", "shortDescription": "Shooting at specific targets in the goal.",  "detailDescription": "This exercise focuses on improving shooting accuracy by aiming for specific targets in the goal. It helps develop precision and consistency in finishing.", "intructions": "Set Up: Place small targets (cones, markers, or hanging nets) in different sections of the goal (corners, center, sides). Starting Position: Position yourself 10-15 meters away from the goal with a ball. Aim and Shoot: Focus on a specific target and strike the ball with precision. Reposition: Retrieve the ball, adjust your position, and aim for a different target. Repeat: Perform 10-15 shots, varying angles and distances. Challenge: Use both dominant and non-dominant feet to improve versatility.",  "imageName": "Shooting1", "videoLink": "https://youtu.be/eN2UEirM0cg?si=I-wNuLSUqnYbjGYc"],
            ["category": "Shooting", "subcategory": "Power Shot", "shortDescription": "Practicing powerful shots with proper technique.",  "detailDescription": "This drill emphasizes generating power in your shots while maintaining proper technique. Ideal for situations requiring long-range or high-speed shots.", "intructions": "Set Up: Use a marked area 20-25 meters from the goal.Approach: Place the ball on the ground, take a few steps back for a run-up. Strike: Hit the ball with your laces, keeping your foot firm and your body slightly leaning forward. Follow Through: Allow your kicking leg to follow through after the strike for added power. Evaluate: Observe the power and trajectory; adjust your technique as needed. Repeat: Perform 10-12 powerful shots, alternating angles and positions.",  "imageName": "Shooting2", "videoLink": "https://youtu.be/ipzEbfqAi2Y?si=hzRXysWYgb4PldXM"],
            ["category": "Shooting", "subcategory": "Volley Shots", "shortDescription": "Striking the ball while it’s in the air.",  "detailDescription": "This drill improves timing and technique for volleys, which are critical for converting crosses or bouncing balls into goals.", "intructions": "Set Up: Have a partner, coach, or rebounder provide soft passes or tosses to you.Position: Stand near the edge of the penalty area, ready to receive the ball.Timing: Watch the ball closely as it approaches.Strike: Use your laces or the top of your foot to hit the ball mid-air toward the goal.Control: Focus on accuracy over power at first, aiming for specific sections of the goal.Repeat: Perform 8-10 volleys with different trajectories and angles.",  "imageName": "Shooting3", "videoLink": "https://youtube.com/shorts/XXa0oeuCRgw?si=fYwpoI3xhMnVb5HM"],
            ["category": "Shooting", "subcategory": "Penalty Series", "shortDescription": "Practicing accurate shots from the penalty spot.",  "detailDescription": "This exercise simulates match situations for penalty kicks, enhancing composure, accuracy, and consistency under pressure.", "intructions": "Set Up: Place the ball on the penalty spot, 11 meters from the goal.Prepare: Choose your target in the goal (e.g., bottom corner, top corner).Run-Up: Take a confident approach, focusing on your form.Strike: Hit the ball cleanly with your instep or laces, depending on your target and power.Evaluate: Observe the accuracy and adjust your technique if necessary.Repeat: Take 5-10 penalties, alternating targets. Optionally, simulate match pressure with a goalkeeper.",  "imageName": "Shooting4", "videoLink": "https://youtu.be/2OgC-ECQSdc?si=o49t_YyFAkxr3HCx"],
            ["category": "Shooting", "subcategory": "Turn & Shoot ", "shortDescription": "Quick positioning and shooting on the move.",  "detailDescription": "This drill develops your ability to quickly turn and shoot, simulating real-game situations where time and space are limited.", "intructions": "Set Up: Place a cone or marker 10-15 meters from the goal and have a ball ready. Starting Position: Stand with your back to the goal and the ball at your feet. Turn: Pivot quickly, using one foot to turn while keeping the ball close. Shoot: Strike the ball immediately after turning, aiming for a specific target. Focus: Work on speed, control, and accuracy during the turn and shot. Repeat: Perform 8-12 repetitions, varying your starting position.",  "imageName": "Shooting5", "videoLink": "https://youtu.be/BkalcGgi5SE?si=tbVdo7IL9-hEQPXu"],
          
            ["category": "Stretching", "subcategory": "Leg Stretch ", "shortDescription": "Forward bends to touch toes while sitting.",  "detailDescription": "This stretch improves hamstring flexibility and enhances overall leg mobility. It’s excellent for post-training ", "intructions": "Starting Position: Sit on the floor with your legs extended straight in front of you. Posture: Keep your back straight and feet flexed (toes pointing toward the ceiling). Reach Forward: Slowly bend at the hips and extend your arms toward your toes. Hold the Stretch: Once you feel a gentle stretch in your hamstrings, hold the position for 20-30 seconds. Return: Slowly return to the starting position. Repeat: Perform the stretch 2-3 times, deepening the stretch with each repetition.",  "imageName": "Stretching1", "videoLink": "https://youtube.com/shorts/Ve6KBTkymRQ?si=LmBazDV5FP9TRUQT"],
            ["category": "Stretching", "subcategory": "Back Stretch", "shortDescription": "Cat-cow yoga pose for spinal flexibility.",  "detailDescription": "This dynamic stretch improves spinal flexibility and relieves tension in the back and shoulders.", "intructions": "Starting Position: Get on all fours with your hands directly under your shoulders and knees under your hips. Cat Pose: Arch your back upward, tucking your chin to your chest and pulling your belly button toward your spine. Cow Pose: Inhale, drop your belly toward the floor, lift your head and tailbone, and look upward. Flow: Alternate between Cat and Cow poses slowly, holding each position for 3-5 seconds. Duration: Continue for 8-10 cycles, focusing on smooth and controlled movements.",  "imageName": "Stretching2", "videoLink": "https://youtu.be/fcnv4gyMzf8?si=GvU_Yo6Gg0_3B7oq"],
            ["category": "Stretching", "subcategory": "Hip Flexor", "shortDescription": "Deep lunges with forward bending.",  "detailDescription": "This stretch targets the hip flexors and improves flexibility in the hips and thighs, critical for athletes' mobility.", "intructions": "Starting Position: Start in a lunge position with one foot forward and the opposite knee on the ground. Straighten Posture: Keep your upper body upright and your hands on your front knee. Deepen the Stretch: Gently push your hips forward while keeping your back straight. Optional: Raise your arms overhead and lean slightly backward for a deeper stretch. Hold: Maintain the position for 20-30 seconds, feeling the stretch in your hip flexor. Switch Legs: Alternate legs and repeat the stretch 2-3 times per side.",  "imageName": "Stretching3", "videoLink": "https://youtu.be/DXuStgWuJV8?si=REYZ2Z2DWbKVkhJl"],
            ["category": "Stretching", "subcategory": "Hamstring", "shortDescription": "Forward bends with straight legs.",  "detailDescription": "This stretch focuses on the hamstrings, relieving tightness and improving leg flexibility.", "intructions": "Starting Position: Stand with your feet hip-width apart and knees slightly bent. Bend Forward: Slowly hinge at the hips, lowering your upper body toward the floor while keeping your legs straight. Reach for Your Toes: Extend your arms toward your feet, but don’t force the stretch. Hold: Stay in this position for 20-30 seconds, keeping your neck relaxed. Return: Gradually roll back up to a standing position. Repeat: Perform 2-3 repetitions, trying to go deeper with each stretch.",  "imageName": "Stretching4", "videoLink": "https://youtu.be/kRiudRykGWg?si=NRvUu5VS1yj1JQpO"],
            ["category": "Stretching", "subcategory": "Butterfly ", "shortDescription": "Sitting and pulling feet together to stretch inner thighs.",  "detailDescription": "This stretch improves flexibility in the inner thighs and hips, enhancing range of motion.", "intructions": "Starting Position: Sit on the floor with your knees bent and the soles of your feet pressed together. Posture: Hold your feet with your hands and pull them gently toward your body. Press Down: Use your elbows to gently press your knees toward the floor, feeling the stretch in your inner thighs. Hold: Maintain this position for 20-30 seconds, keeping your back straight. Relax: Release the stretch and repeat 2-3 times.",  "imageName": "Stretching5", "videoLink": "https://youtu.be/4J7kbCmPScQ?si=hBlPrQ74VQnOPyZv"],
          
       
            ["category": "Physical Conditioning", "subcategory": "Sprints  ", "shortDescription": "Short, high-speed runs over a defined distance.",  "detailDescription": "This exercise develops explosive speed, reaction time, and cardiovascular endurance.", "intructions": "Set Up: Mark a distance of 20-30 meters with cones or markers. Starting Position: Begin in a crouched or standing start position at one end of the marked area. Sprint: Run as fast as possible to the opposite end. Recover: Walk back to the starting point to recover. Repetition: Perform 8-10 sprints, resting 20-30 seconds between each. Variation: Gradually increase distance or perform interval sprints with reduced recovery time",  "imageName": "Physical1", "videoLink": "https://youtu.be/2YogM9wXAJg?si=RGrbJCNsermR2ohR"],
            ["category": "Physical Conditioning", "subcategory": "Jumping", "shortDescription": "Vertical jumps with knees raised.",  "detailDescription": "This drill enhances explosive power in the legs and improves coordination.", "intructions": "Starting Position: Stand with feet shoulder-width apart and arms relaxed by your sides. Jump: Jump vertically, bringing your knees as high as possible toward your chest. Land: Land softly on the balls of your feet with knees slightly bent to absorb impact. Repeat: Perform 15-20 jumps in quick succession. Variation: Add arm movements, such as reaching upward, to increase intensity. Repetition: Complete 3-4 sets with 30-60 seconds rest between sets.",  "imageName": "Physical2", "videoLink": "https://youtube.com/shorts/W5jb6qQ8yI0?si=PL29OzXQ6oPWZgOb"],
            ["category": "Physical Conditioning", "subcategory": "PLANK", "shortDescription": "Holding a straight body position on elbows.",  "detailDescription": "This static exercise strengthens the core, back, and shoulders, improving overall stability.", "intructions": "Starting Position: Lie face down on the floor. Place your forearms on the ground and elbows directly under your shoulders. Lift Off: Raise your body off the ground, supporting yourself on your forearms and toes. Alignment: Keep your body straight from head to heels, engaging your core and glutes. Hold: Maintain the position for 20-60 seconds, depending on your fitness level. Rest: Lower your body back to the floor and rest for 30 seconds. Repetition: Perform 3-5 sets, gradually increasing the hold time.",  "imageName": "Physical3", "videoLink": "https://youtu.be/qmw7-IFVZPo?si=3eANrbZu1xDTKSmt"],
            ["category": "Physical Conditioning", "subcategory": "Burpees", "shortDescription": "A full-body workout with jumps and push-ups.",  "detailDescription": "This intense exercise combines strength, endurance, and coordination for a full-body workout.", "intructions": "Starting Position: Stand with feet shoulder-width apart. Squat: Lower your body into a squat and place your hands on the floor. Jump Back: Jump your feet back to assume a push-up position. Push-Up: Perform a push-up (optional for beginners). Jump Forward: Jump your feet back toward your hands. Vertical Jump: Explode upward into a vertical jump with arms extended overhead. Repeat: Perform 8-12 repetitions in quick succession. Rest: Take a 30-60 second break between sets. Complete 3-4 sets.",  "imageName": "Physical4", "videoLink": "https://youtu.be/bAmmbt9IcEU?si=3kfocYkjf9EWd1FP"],
            ["category": "Physical Conditioning", "subcategory": "Leg Raises  ", "shortDescription": "Lifting straight legs while lying on the back to strengthen the core.",  "detailDescription": "This exercise targets the lower abs, improving core strength and stability.", "intructions": "Starting Position: Lie on your back with your legs straight and arms at your sides or under your hips for support. Lift Legs: Keeping your legs straight, raise them slowly until they form a 90-degree angle with your torso. Lower Slowly: Lower your legs back down without letting them touch the floor. Control: Focus on slow, controlled movements to engage the abs fully. Repetition: Perform 12-15 repetitions per set. Rest: Rest for 30 seconds between sets and complete 3-4 sets.",  "imageName": "Physical5", "videoLink": "https://youtu.be/f_O-CzKSSY8?si=yewvsc4XejssOCcJ"],
          
            ["category": "Passing", "subcategory": "Short Passes ", "shortDescription": "Quick and accurate passes over a short distance.",  "detailDescription": "This exercise focuses on accuracy and control in short-range passing, essential for tight-game situations.", "intructions": "Set Up: Pair up with a partner and stand 5-10 meters apart. Starting Position: Position the ball at your feet, with your body facing your partner. Pass: Use the inside of your foot to pass the ball directly to your partner, keeping the ball low and controlled. Receive: Your partner stops the ball and returns the pass in the same manner. Repetition: Continue passing back and forth for 1-2 minutes, focusing on accuracy. Variation: Gradually increase the pace of passing while maintaining control.",  "imageName": "Passing1", "videoLink": "https://youtu.be/jCt5fmYN0w8?si=rFH_KP6Zgp9jrhLd"],
            ["category": "Passing", "subcategory": "Moving Passes", "shortDescription": "Passing while moving with a partner.",  "detailDescription": "This drill improves the ability to pass accurately while moving, mimicking real-game scenarios.", "intructions": "Set Up: Pair up with a partner and stand 10-15 meters apart. Movement: Both players jog slowly parallel to each other. Pass: Pass the ball to your partner using the inside of your foot while continuing to jog. Control: The receiving player stops the ball and passes it back while staying in motion. Repetition: Continue passing for 1-2 minutes, gradually increasing speed. Variation: Change directions or include quick sprints between passes for added intensity.",  "imageName": "Passing2", "videoLink": "https://youtu.be/tlAuB13vGPY?si=SOj1U8FvcqnBq9sg"],
            ["category": "Passing", "subcategory": "Long Passes", "shortDescription": "Practicing long-distance passes.",  "detailDescription": "This exercise develops power and precision in long-range passing, useful for switching play or creating opportunities.", "intructions": "Set Up: Stand 20-30 meters apart from your partner on a flat surface. Positioning: Place the ball slightly in front of you for a clean strike. Strike: Use the laces of your boot to hit the lower half of the ball, aiming for height and distance. Receive: The receiving player traps the ball and returns a long pass. Adjust: Focus on adjusting power and angle to maintain accuracy. Repetition: Perform 8-10 long passes, alternating between feet for practice.",  "imageName": "Passing3", "videoLink": "https://youtu.be/fVX_3AVVDRM?si=J0Pzmxn-qDMS5oaf"],
            ["category": "Passing", "subcategory": "Triangle", "shortDescription": "Passing drills between three players.",  "detailDescription": "This drill enhances spatial awareness, quick decision-making, and passing accuracy.", "intructions": "Set Up: Form a triangle with three players, each standing 5-10 meters apart. Pass: Player 1 passes the ball to Player 2, who controls it and passes to Player 3. Movement: After passing, the player moves to a new position to keep the triangle dynamic. Continue: The sequence repeats, maintaining the triangle's shape and fluidity. Speed: Gradually increase the speed of passes as players get comfortable. Duration: Perform for 3-5 minutes, rotating positions to ensure everyone practices all roles.",  "imageName": "Passing4", "videoLink": "https://youtu.be/eo5j2G0svqM?si=KvxVayygSRWADzHP"],
            ["category": "Passing", "subcategory": "One-Touch", "shortDescription": "Practicing precise one-touch passes.",  "detailDescription": "This exercise focuses on quick decision-making and ball control, vital for fast-paced play.", "intructions": "Set Up: Pair up with a partner and stand 5-10 meters apart. Positioning: Stand on your toes, ready to react to the ball. Pass: Use the inside of your foot to return the ball to your partner with a single touch. Control: Focus on timing and accuracy, ensuring the ball reaches your partner smoothly. Variation: Increase distance or add a moving element for added difficulty. Repetition: Perform for 1-2 minutes, alternating between dominant and non-dominant feet.",  "imageName": "Passing5", "videoLink": "https://youtu.be/Uap21a9Lha0?si=lyzlpTyTsoyoFpuB"],
          
            
            ["category": "Tactical Drills", "subcategory": "PositionING", "shortDescription": "Simulating match situations with specific player roles.",  "detailDescription": "This exercise focuses on spatial awareness, role-specific positioning, and effective teamwork. Players practice maintaining team shape during possession and transitions.", "intructions": "Set Up: Mark an area of the field (e.g., 30x30 meters) with cones and divide it into zones. Assign Roles: Assign players to specific positions based on their in-game roles. Ball Movement: Introduce the ball and encourage players to move it around the zones while maintaining their positions. Transitions: Alternate between offensive and defensive scenarios, prompting players to adapt their positions. Coach Feedback: Provide real-time feedback on positioning, communication, and decision-making. Duration: Practice for 10-15 minutes with variations in the game situation (e.g., overloads or press).",  "imageName": "Tactical1", "videoLink": "https://youtu.be/dhmCwI5vAlE?si=dk4RCU2edXx8ETmT"],
            ["category": "Tactical Drills", "subcategory": "Attack", "shortDescription": "Drills for offensive teamwork and movement.",  "detailDescription": "This drill enhances the coordination and creativity of attacking players, emphasizing quick passes and decisive runs.", "intructions": "Set Up: Arrange attackers, midfielders, and defenders in a half-field setup. Use 4-6 attackers and 3-4 defenders. Scenario Start: Begin with the midfield passing the ball to the attackers. Build-Up: Attackers work together to break through the defense using passes, overlaps, and runs. Finish: The sequence ends with a shot on goal. Rotate Roles: Rotate players between attacking and defending roles every 5 minutes. Duration: Practice for 20 minutes, varying defensive pressure or adding specific objectives (e.g., scoring within a set number of passes).",  "imageName": "Tactical2", "videoLink": "https://youtube.com/shorts/12zr-UoJHFY?si=QC-TIGrzPFBnY-QY"],
            ["category": "Tactical Drills", "subcategory": "Defense 3v2", "shortDescription": "Practicing defense with a numerical disadvantage.",  "detailDescription": "This exercise sharpens defenders’ ability to handle being outnumbered, emphasizing positioning, teamwork, and timely tackles.", "intructions": "Set Up: Create a small playing area (e.g., 20x20 meters) with two goals at opposite ends. Assign Roles: Place three attackers and two defenders in the area. Objective: Attackers aim to score while defenders work together to prevent it. Key Focus: Defenders should communicate, maintain shape, and delay the attackers’ progress. Transition: If defenders regain possession, they can counterattack or clear the ball. Repetition: Rotate players between attacking and defending roles every 5 minutes. Duration: Practice for 15-20 minutes, increasing intensity as players improve.",  "imageName": "Tactical3", "videoLink": "https://youtu.be/cDdCqoFfgL8?si=7W_ygmZoHDneh0Bb"],
            ["category": "Tactical Drills", "subcategory": "Interception", "shortDescription": "Training to steal the ball from opponents.",  "detailDescription": "This drill develops anticipation, timing, and aggressiveness in winning back possession.", "intructions": "Set Up: Mark a small rectangular area (e.g., 15x15 meters). Divide players into two teams (4 vs. 4 or 5 vs. 5). Ball Movement: One team starts with possession and passes the ball around while the other team attempts to intercept. Interception: The defending team focuses on positioning, reading the game, and intercepting passes. Transition: If the defending team wins the ball, they switch to offense. Rotate Roles: Alternate offensive and defensive roles every 5 minutes. Duration: Practice for 15-20 minutes, adding restrictions (e.g., limited touches) to increase difficulty.",  "imageName": "Tactical4", "videoLink": "https://youtu.be/VfEUyqtElBk?si=ZnwUdL2zBreLmOZq"],
            ["category": "Tactical Drills", "subcategory": "Combination", "shortDescription": "Developing complex passing combinations.",  "detailDescription": "This drill builds teamwork and precision in executing planned passing combinations to break through the defense.", "intructions": "Set Up: Arrange players in a designated area (e.g., 30x20 meters) with cones or markers to represent passing routes. Pattern Start: Define a passing pattern, such as a 1-2 pass or overlapping runs. Execution: Players move the ball through the pattern at game speed, focusing on accuracy and timing. Role Changes: Rotate players through different positions in the pattern to ensure everyone practices multiple roles. Game Simulation: Transition to a small-sided game where players apply the combination in real-time situations. Duration: Practice for 20 minutes, increasing complexity by introducing defenders or varying the patterns.",  "imageName": "Tactical5", "videoLink": "https://youtu.be/BSUz23PdGv8?si=8gsoGAeFbo66wGtO"],
          
            ["category": "Balance & Coordination", "subcategory": "One-Leg", "shortDescription": "Maintaining balance with the ball while standing on one leg.",  "detailDescription": "This exercise enhances balance, core strength, and stability, which are crucial for controlling movements during a game.", "intructions": "Starting Position: Stand upright and hold a ball in your hands. Lift One Leg: Raise one leg so that the foot is off the ground, balancing on the other leg. Ball Movement: Slowly move the ball in small circles around your body or hold it out in front of you. Maintain Balance: Engage your core to stay stable. Avoid leaning excessively. Switch Legs: After 30-45 seconds, switch to the other leg. Repetition: Perform 3 sets per leg, increasing the duration as you improve. Variation: Close your eyes or move the ball faster for an added challenge.",  "imageName": "Balance1", "videoLink": ""],
            ["category": "Balance & Coordination", "subcategory": "Ladder", "shortDescription": "Quick steps through a coordination ladder.",  "detailDescription": "This drill improves foot speed, coordination, and agility, simulating rapid directional changes in a game.", "intructions": "Set Up: Lay a coordination ladder flat on the ground. Start Position: Stand at one end of the ladder with your feet shoulder-width apart. Basic Pattern: Step into the first square with your right foot, then your left foot, exiting the square before moving to the next. Rhythm: Maintain a quick but controlled pace, ensuring each step lands in the square. Progression: Introduce more complex patterns (e.g., side steps or crossover steps). Duration: Perform each pattern for 1-2 minutes, resting briefly between repetitions. Variation: Add a ball to dribble alongside the ladder for an advanced challenge.",  "imageName": "Balance2", "videoLink": ""],
            ["category": "Balance & Coordination", "subcategory": "Ball Around", "shortDescription": "Rolling the ball around the waist and legs.",  "detailDescription": "This drill enhances hand-foot coordination and control, useful for developing ball-handling skills.", "intructions": "Starting Position: Stand upright with a ball in your hands. Movement: Roll the ball around your waist in a continuous motion. Progression: Gradually lower the ball, rolling it around your thighs, knees, and ankles. Direction Change: Alternate directions every 10-15 seconds. Add Speed: Increase the speed of the ball movement while maintaining control. Duration: Perform for 2-3 minutes per session. Variation: Try rolling the ball around only one leg or while balancing on one foot.",  "imageName": "Balance3", "videoLink": ""],
            ["category": "Balance & Coordination", "subcategory": "Slalom", "shortDescription": "Running between cones to improve coordination.",  "detailDescription": "This exercise focuses on improving agility and body coordination through rapid directional changes.", "intructions": " Set Up: Arrange cones in a straight line, spaced 1-2 meters apart. Starting Position: Stand at the starting cone, facing the line of cones. Slalom Run: Run through the cones, weaving between them in a zigzag pattern. Focus on Form: Keep your body low, knees bent, and arms moving naturally for balance. Pace: Start slowly to learn the movement, then increase speed as you gain confidence. Repetition: Complete 5-6 runs, resting briefly between each. Variation: Perform the slalom sideways or backward for an added challenge.",  "imageName": "Balance4", "videoLink": ""],
            ["category": "Balance & Coordination", "subcategory": "Hopping", "shortDescription": "Alternating legs to enhance balance and stability.",  "detailDescription": "This drill improves single-leg strength, coordination, and dynamic balance, essential for explosive movements.", "intructions": "Starting Position: Stand upright with feet shoulder-width apart.Hop on One Foot: Lift one leg and hop forward on the other, maintaining balance.Switch Legs: Alternate legs after 5-10 hops or a set distance.Focus on Control: Land softly on the ball of your foot to absorb impact.Repetition: Perform 3 sets of 10 hops per leg.Variation: Incorporate lateral hops or hop in a zigzag pattern for added difficulty.",  "imageName": "Balance5", "videoLink": ""],
            
        ]
        
        // Добавляем данные в Core Data
        for item in initialData {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: context)
            entity.setValue(item["category"], forKey: "category")
            entity.setValue(item["subcategory"], forKey: "subcategory")
            entity.setValue(item["shortDescription"], forKey: "shortDescription2")
            entity.setValue(item["detailDescription"], forKey: "detailDescription")
            entity.setValue(item["intructions"], forKey: "intructions")
            entity.setValue(item["imageName"], forKey: "imageName")
            entity.setValue(item["videoLink"], forKey: "videoLink")
        }
        
        do {
            try context.save()
            print("Initial data successfully loaded into Core Data.")
        } catch {
            print("Failed to save initial data: \(error)")
        }
    }
    
    func setupDimmedView() {
        
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmedView.isHidden = true // Скрыть при запуске
    

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
    
        dimmedView.addGestureRecognizer(tapGesture)
    }

      // Настройка затемненного фона
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(hex: "3C439B")
        tableView.layer.cornerRadius = 40
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.2
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowRadius = 6

        // Установка разделителей
        tableView.separatorColor = .clear
      
        tableView.rowHeight = tableView.frame.height / 9 // Делим высоту таблицы на 8 элементов
        

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
    }

    @IBAction func tappedProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SOTProfileScreenView", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "ShootOutProfileViewController") as! ShootOutProfileViewController
        navigateTo(settingsVC)
    }
    // Показ или скрытие меню
      @IBAction func toggleMenu(_ sender: UIButton) {
          let shouldShowMenu = tableView.isHidden
          tableView.isHidden = !shouldShowMenu
          dimmedView.isHidden = !shouldShowMenu
          
          // Изменение изображения кнопки
            let imageName = shouldShowMenu ? "ImageBurgerDark" : "ImageBurgerOpenDark"
          buttonBurger.setImage(UIImage(named: imageName), for: .normal)
      }

    @objc func hideMenu() {
            tableView.isHidden = true
            dimmedView.isHidden = true
        }
        // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return menuItems.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        // Настройка текста в центре
        cell.textLabel?.text = menuItems[indexPath.row]
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
        if indexPath.row < menuItems.count - 1 {
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



        // MARK: - UITableViewDelegate

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.isHidden = true // Скрыть таблицу
            dimmedView.isHidden = true // Скрыть затемнение

            // Обработчики для перехода на экраны
            switch indexPath.row {
            case 0:
                navigateToScreen1()
            case 1:
                navigateToScreen2()
            case 2:
                navigateToScreen3()
            case 3:
                navigateToScreen4()
            case 4:
                navigateToScreen5()
            case 5:
                navigateToScreen6()
            case 6:
                navigateToScreen7()
            case 7:
                navigateToScreen8()
            default:
                break
            }
        }

        // Навигация на экраны
    func navigateToScreen1() {
        let storyboard = UIStoryboard(name: "SOTWorkoutScreenView", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "ShootOutWorkoutViewController") as! ShootOutWorkoutViewController
        navigateTo(settingsVC)
    }
    func navigateToScreen2() {
        let storyboard = UIStoryboard(name: "SOTBaseExercisesScreenView", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "ShootOutBaseExercisesViewController") as! ShootOutBaseExercisesViewController
        navigateTo(settingsVC)
    }
        func navigateToScreen3() {
            let storyboard = UIStoryboard(name: "SOTGoalsScreenView", bundle: nil)
            let settingsVC = storyboard.instantiateViewController(withIdentifier: "ShootOutVideoViewController") as! ShootOutGoalsViewController
            navigateTo(settingsVC)
        }
        func navigateToScreen4() {
            let storyboard = UIStoryboard(name: "SOTVideoTrainScreenView", bundle: nil)
            let settingsVC = storyboard.instantiateViewController(withIdentifier: "ShootOutVideoViewController") as! ShootOutVideoViewController
            navigateTo(settingsVC)
        }
        func navigateToScreen5() { print("Navigate to Screen 5") }
        func navigateToScreen6() { print("Navigate to Screen 6") }
        func navigateToScreen7() { print("Navigate to Screen 7") }
    func navigateToScreen8() {
        let storyboard = UIStoryboard(name: "SOTSettings", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "ShootOutSettingsViewController") as! ShootOutSettingsViewController
        navigateTo(settingsVC)
        
    }
    


   
    }
// MARK: - UIColor Extension for Hex Support
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(color & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
