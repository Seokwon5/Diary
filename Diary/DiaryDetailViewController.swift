//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 이석원 on 2022/04/19.
//

import UIKit



class DiaryDetailViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()

    }
    
    //일기 상세화면에 저장된 데이터 가져오기
    private func configureView() {
        guard let diary = self.diary else {return}
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
    }

    ////date의 정보를 문자열 형태로 fommater
    private func dateToString(date : Date) -> String {
         let formatter = DateFormatter()
         formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }


    @IBAction func tapDeleteButton(_ sender: UIButton) {
    }
    @IBAction func tapEditButton(_ sender: UIButton) {
    }
}
