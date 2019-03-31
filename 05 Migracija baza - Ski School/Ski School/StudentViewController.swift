//
//  StudentViewController.swift
//  Ski School
//
//

import UIKit
import CoreData

class StudentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var students = [Student]()
    var request: NSFetchRequest<Student>!
    var selectedSport: String!
    var managedObjectContext: NSManagedObjectContext!
    var coreData: CoreDataStack! {
        didSet {
            return managedObjectContext = coreData.persistentContainer.viewContext
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        request = Student.fetchRequest()
        selectedSport = "ski"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
    func loadData() {
        students = StudentService.getStudents(selectedSport: selectedSport, managedObjectContext: managedObjectContext)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentSelectionAction(_ sender: UISegmentedControl) {
        selectedSport = sender.titleForSegment(at: sender.selectedSegmentIndex)
        
        loadData()
    }
    
    // MARK: Tableview datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 60
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell") as! StudentTableViewCell
        
        let student = students[indexPath.row]
        cell.studentNameLabel.text = student.name
        cell.studentAgeLabel.text = String(student.age)
        // posle migracije level vise nije pod studentom vec je pod lessonom
//        cell.levelImageView.image = UIImage(named: "circle-\(student.level!).png")

        if let lesson = student.lesson {
            if let level = lesson.level {
                cell.levelImageView.image = UIImage(named: "circle-\(level).png")
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "studentInfoSegue", sender: self)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var student: Student!
        
        let navController = segue.destination as! UINavigationController
        let studentInfoController = navController.topViewController as! StudentInfoTableViewController
        
        if segue.identifier == "studentInfoSegue" {
            let selectedIndexPath = tableView.indexPathForSelectedRow
            student = students[(selectedIndexPath?.row)!]
        }
        else if segue.identifier == "addStudentSegue" {
            // ovde menjam zbog migracije
//            student = Student(context: coreData.persistentContainer.viewContext)
            student = StudentService.new(managedObjectContext: managedObjectContext)
            // ostatak je isti kao pre migracije
            studentInfoController.isNewStudent = true
        }
        
        studentInfoController.coreData = coreData
        studentInfoController.student = student
    }
    

}
