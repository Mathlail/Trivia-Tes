//
//  QuizViewController.swift
//  TriviaApp
//
//  Created by tashya on 2/9/18.
//  Copyright © 2018 InterviewTest. All rights reserved.
//

import UIKit
import Alamofire
import GameplayKit


class QuestionCell: UICollectionViewCell {
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    
    override func awakeFromNib() {
        let buttons = [btnA, btnB, btnC, btnD]
        for btn in buttons {
            btn?.layer.borderWidth = 2
            let view = UIView(frame: CGRect(x: 7, y: 7, width: 30, height: 30))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            label.center = CGPoint(x: 30/2, y: 15)
            if btn == btnA {
                label.text = "A"
            } else if btn == btnB {
                label.text = "B"
            } else if btn == btnC {
                label.text = "C"
            } else {
                label.text = "D"
            }
            label.textAlignment = .center
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 0.5 * view.frame.height
            view.backgroundColor = UIColor.white
            view.addSubview(label)
            btn?.addSubview(view)
            btn?.layer.masksToBounds = true
            btn?.layer.cornerRadius = 0.2 * (btn?.frame.height)!
        }
    }
    
}

class QuizViewController: UIViewController {
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblQuestionNumber: UILabel!
    @IBOutlet weak var lblRightAnswer: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn11: UIButton!
    @IBOutlet weak var btn12: UIButton!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var btn13: UIButton!
    @IBOutlet weak var btn14: UIButton!
    @IBOutlet weak var btn15: UIButton!
    @IBOutlet weak var btn16: UIButton!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var btn17: UIButton!
    @IBOutlet weak var btn18: UIButton!
    @IBOutlet weak var btn19: UIButton!
    @IBOutlet weak var btn20: UIButton!
    
    var data: NSDictionary?
    var dataQuestion: NSArray?
    var allChoice = [NSArray]()
    var shuffledAnswer: NSArray?
    var strAnswer: String?
    var question = [Int: [String]]()
    var id: Int?
    var score = 0
    var page = 1
    var strCategory: String?
    var list = [Int]()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataQuestion(id: id!)
        lblTitle.text = strCategory!
        roundButton()
        let imgSize = CGSize(width: 16, height: 16)
        btnClose.setImage(UIImage(named: "close"), for: .normal)
        btnClose.imageEdgeInsets = UIEdgeInsetsMake(btnClose.frame.size.height/2 - imgSize.height/2, btnClose.frame.size.width/2 - imgSize.width/2, btnClose.frame.size.height/2 - imgSize.height/2, btnClose.frame.size.width/2 - imgSize.width/2)
        
    }
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectAnswer(_ sender: UIButton) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        let answer = findAnswer(data: self.dataQuestion!, page: currentPage)
        if currentPage == 0 {
            var btnSoal1 = [btn1,btn2,btn3,btn4]
            btnSoal1[answer]?.backgroundColor = UIColor.green
            if sender.tag != answer {
                sender.backgroundColor = UIColor.red
            }
        }
        countScore(tag: sender.tag, idxAnswer: answer)
    }
    
    func countScore(tag: Int, idxAnswer: Int){
        if tag == idxAnswer {
            score += 1
            lblRightAnswer.text = "\(score) Right Answers"
        }
    }
    
    func getDataQuestion(id: Int){
        self.disableInteraction(true)
            Alamofire.request("https://opentdb.com/api.php?amount=20&category=\(id)&type=multiple").responseJSON { (response) in
                switch response.result {
                case .success( _):
                    if let json = response.result.value {
                        self.data = json as? NSDictionary
    //                    print("JSON: \(String(describing: json))")
                        self.dataQuestion = self.data!["results"] as? NSArray
                        self.getQuestion()
                        if let count = self.dataQuestion?.count, count > 0 {
                            for i in 0..<count {
                                let dataChoice = self.dataQuestion![i] as! NSDictionary
                                var answer = dataChoice["incorrect_answers"] as! NSArray
                                let correct = dataChoice["correct_answer"]
                                let all = answer.adding(correct!)
                                answer = all as NSArray
                                self.allChoice.append(answer)
                            }
                        }
                        self.getMultipleChoice()
                        self.disableInteraction(false)
                        print("=====\(String(describing: self.allChoice))")
                    }
                case .failure(let error):
                self.showAlertMessage(titleStr: "", messageStr: error.localizedDescription, completion: { (true) in
                self.disableInteraction(false)
                })
            }
        }

    }
    
    func disableInteraction(_ loading: Bool){
        if loading {
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        UIApplication.shared.endIgnoringInteractionEvents()
        self.activityIndicator.stopAnimating()
    }
    
    func getQuestion(){
        for i in 0...4 {
            let dict = dataQuestion![i] as! NSDictionary
            let lbl = self.value(forKey: "lbl\(i+1)") as! UILabel
            let text = dict["question"] as? String
            lbl.text = text
        }
    }
    
    func getMultipleChoice(){
        for i in 0..<allChoice.count {
            for j in 0...3 {
                if i == 0 {
                    let arrayChoice = allChoice[i]
                    let btn = self.value(forKey: "btn\(j+1)") as! UIButton
                    btn.setTitle(("\(arrayChoice[j])"), for: .normal)
                }
                if i == 1 {
                    let arrayChoice = allChoice[i]
                    let btn = self.value(forKey: "btn\(j+5)") as! UIButton
                    btn.setTitle(("\(arrayChoice[j])"), for: .normal)
                }
                if i == 2 {
                    let arrayChoice = allChoice[i]
                    let btn = self.value(forKey: "btn\(j+9)") as! UIButton
                    btn.setTitle(("\(arrayChoice[j])"), for: .normal)
                }
                if i == 3 {
                    let arrayChoice = allChoice[i]
                    let btn = self.value(forKey: "btn\(j+13)") as! UIButton
                    btn.setTitle(("\(arrayChoice[j])"), for: .normal)
                }
                if i == 4 {
                    let arrayChoice = allChoice[i]
                    let btn = self.value(forKey: "btn\(j+17)") as! UIButton
                    btn.setTitle(("\(arrayChoice[j])"), for: .normal)
                }
            }
        }
    }
    

    @IBAction func nextQuestion(_ sender: UIButton) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let page = Int(ceil(x/w))
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page + 1)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: true)
        numberQuestions(page)

    }
    
    func numberQuestions(_ page: Int) {
        if page + 1 < allChoice.count {
            lblQuestionNumber.text = "Question no. \((page + 1) + 1)"
        }
    }
    
    func findAnswer(data: NSArray, page: Int) -> Int {
        var idxAnswer = 0
        let dict = data[page] as! NSDictionary
        let correct = dict["correct_answer"] as! String
        print(correct)
        let all = allChoice[page]
        for (idx, value) in all.enumerated(){
            if value as! String == correct {
                print("++++++++\(idx)")
                idxAnswer = idx
            }
        }
        return idxAnswer
    }
    
    func roundButton(){
        for i in 1...20{
            let btn = self.value(forKey: "btn\(i)") as! UIButton
            btn.layer.borderWidth = 2
            let view = UIView(frame: CGRect(x: 7, y: 7, width: 30, height: 30))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            label.center = CGPoint(x: 30/2, y: 15)
            if i < 5 {
                if btn == btn1 {
                    label.text = "A"
                }
                if btn == btn2 {
                    label.text = "B"
                }
                if btn == btn3 {
                    label.text = "C"
                }
                if btn == btn4 {
                    label.text = "D"
                }
            }
            
            if i >= 5 && i <= 8 {
                if btn == btn5 {
                    label.text = "A"
                }
                if btn == btn6 {
                    label.text = "B"
                }
                if btn == btn7 {
                    label.text = "C"
                }
                if btn == btn8 {
                    label.text = "D"
                }
            }
            
            if i >= 9 && i <= 12 {
                if btn == btn9 {
                    label.text = "A"
                }
                if btn == btn10 {
                    label.text = "B"
                }
                if btn == btn11 {
                    label.text = "C"
                }
                if btn == btn12 {
                    label.text = "D"
                }
            }
            
            if i >= 13 && i <= 16 {
                if btn == btn13 {
                    label.text = "A"
                }
                if btn == btn14 {
                    label.text = "B"
                }
                if btn == btn15 {
                    label.text = "C"
                }
                if btn == btn16 {
                    label.text = "D"
                }
            }
            
            if i >= 17 && i <= 20 {
                if btn == btn17 {
                    label.text = "A"
                }
                if btn == btn18 {
                    label.text = "B"
                }
                if btn == btn19 {
                    label.text = "C"
                }
                if btn == btn20 {
                    label.text = "D"
                }
            }
            label.textAlignment = .center
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 0.5 * view.frame.height
            view.backgroundColor = UIColor.white
            view.addSubview(label)
            btn.addSubview(view)
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 0.2 * (btn.frame.height)
        }
    }

}
