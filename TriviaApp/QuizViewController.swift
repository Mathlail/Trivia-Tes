//
//  QuizViewController.swift
//  TriviaApp
//
//  Created by tashya on 2/9/18.
//  Copyright © 2018 InterviewTest. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let imgSize = CGSize(width: 16, height: 16)
        btnClose.setImage(UIImage(named: "close"), for: .normal)
        btnClose.imageEdgeInsets = UIEdgeInsetsMake(btnClose.frame.size.height/2 - imgSize.height/2, btnClose.frame.size.width/2 - imgSize.width/2, btnClose.frame.size.height/2 - imgSize.height/2, btnClose.frame.size.width/2 - imgSize.width/2)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
