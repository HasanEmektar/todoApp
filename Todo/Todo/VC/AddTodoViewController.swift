//
//  AddTodoViewController.swift
//  Todo
//
//  Created by Hasan on 2.03.2018.
//  Copyright © 2018 Hasan. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {

    //MARK: Properties
    
    var managedContext: NSManagedObjectContext!
    var todo: Todo?
    
    //MARK: Outlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControler: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)),
            name: .UIKeyboardWillShow,
            object: nil)
        
        textView.becomeFirstResponder()
        
        if let todo = todo{
            textView.text = todo.title
            textView.text = todo.title
            segmentedControler.selectedSegmentIndex = Int(todo.priority)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @objc func keyboardWillShow(with notification: Notification){
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func dismissAndResign() {
        dismiss(animated: true)
        textView.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismissAndResign()
    }
    
    @IBAction func done(_ sender: UIButton) {
        
        guard let title = textView.text, !title.isEmpty else {
            return
        }
        
        if let todo = self.todo{
            todo.title = title
            todo.priority = Int16(segmentedControler.selectedSegmentIndex)
        }else{
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.priority = Int16(segmentedControler.selectedSegmentIndex)
            todo.date = Date()
            
        }

        do{
            try managedContext.save()
            dismissAndResign()
        }catch{
            print("Error: \(error)")
        }
        
    }
}

//Remove text from label when delete button touched

extension AddTodoViewController: UITextViewDelegate
{
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden
        {
            textView.text.removeAll()
            textView.textColor = .white
            
            doneButton.isHidden = false
            //Animate for doneButton
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
