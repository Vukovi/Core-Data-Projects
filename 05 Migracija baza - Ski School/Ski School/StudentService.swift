//
//  StudentService.swift
//  Ski School
//
//

import Foundation
import CoreData

class StudentService {
    static func getStudents(selectedSport: String, managedObjectContext: NSManagedObjectContext) -> [Student] {
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        // 'Invalid keypath level passed to setPropertiesToFetch:'
        // zbog migracije je aplikacija pukla i to na ovom mestu jer je atribut sport u starij bazi bio u entitetu Student, a sada je u entitetu Lesson, tako da moram malo da korigujem upit
//        request.predicate = NSPredicate(format: "sport == %@", selectedSport)
//        request.propertiesToFetch = ["name","age","level"] // odavde uklanjam level iz istog razloga
        request.predicate = NSPredicate(format: "lesson.sport == %@", selectedSport)
        request.propertiesToFetch = ["name","age"]
        
        do {
            let students = try managedObjectContext.fetch(request)
            return students
        }
        catch {
            fatalError()
        }
    }
    
    static func saveStudent(studentData: [String: AnyObject], managedObjectContext: NSManagedObjectContext) {
        
    }
    
    //potrebno mi je zbog migracije baze
    static func new(managedObjectContext: NSManagedObjectContext) -> Student {
        let student = Student(context: managedObjectContext)
        let lesson = Lesson(context: managedObjectContext)
        let instructor = Instructor(context: managedObjectContext)
        
        lesson.instructor = instructor
        student.lesson = lesson
        
        return student
    }
}
