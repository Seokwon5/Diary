//
//  ViewController.swift
//  Diary
//
//  Created by 이석원 on 2022/04/12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]() {
        didSet {
            self.saveDiaryList() //userDefaults에 저장됨.
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadDiaryList()
    }
    
    //collectionView 속성 설정
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self
        }
    }
    
    //데이터를 저장하는 메소드
    private func saveDiaryList() {
        let date = self.diaryList.map {
            [
                "title": $0.title,
                "contents": $0.contents,
                "date":$0.date,
                "isStar":$0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: "diaryList")
    }
    
    //userDefaults에 저장된 데이터를 불러오는 메소드
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data  = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else {return} //딕셔너리 배열형태로 타입캐스팅, 타입캐스팅 실패하면 nil이 되므로 옵셔널 바인딩.
        self.diaryList = data.compactMap { //불러온 데이터를 diarylist에 넣어줌
            guard let title = $0["title"] as? String else {return nil}
            guard let contents = $0["contents"] as? String else {return nil}
            guard let date = $0["date"] as? Date else {return nil}
            guard let isStar = $0["isStar"] as? Bool else {return nil}
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }
        self.diaryList = self.diaryList.sorted(by: { //날짜가 최신순으로 저장
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    //date의 정보를 문자열 형태로 fommater
    private func dateToString(date : Date) -> String {
         let formatter = DateFormatter()
         formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
 
extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else {return UICollectionViewCell() }
        let diary = diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
    }
}

//각 일기를 선택했을 때 detailView로 이동할 수 있도록
extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else {return}
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController : WriteDiaryViewDelegate {
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
        self.collectionView.reloadData()
        self.diaryList = self.diaryList.sorted(by: {  //날짜가 최신순으로 저장
            $0.date.compare($1.date) == .orderedDescending
        })
    }
}




