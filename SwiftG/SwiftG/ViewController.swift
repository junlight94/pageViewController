//
//  ViewController.swift
//  SwiftG
//
//  Created by Junyoung Lee on 2022/03/07.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet var prevBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var pgView: UIView!
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    var currentPage = 0
    
    let viewsList:[UIViewController] = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = storyBoard.instantiateViewController(withIdentifier: "viewController1")
        let vc2 = storyBoard.instantiateViewController(withIdentifier: "viewController2")
        let vc3 = storyBoard.instantiateViewController(withIdentifier: "viewController3")
        
        return [vc1, vc2, vc3]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        //MARK: 앱 실행시 1번째 pageViewController 띄우기
        if let firstvc = viewsList.first{
            //setViewControllers(첫번째화면, direction: .forward(앞으로), .reverse(뒤로), animated: 애니메이션(Bool), completion: nil)
            pageViewController.setViewControllers([firstvc], direction: .forward, animated: true, completion: nil)
        }
        
        //MARK: 처음 화면에서 뒤로가면 안되니까 뒤로가기 버튼 막기 isEnabled = true(활성화), false(비활성화)
        prevBtn.isEnabled = false
        
        //MARK: Main View안에 viewController 붙여넣기
        //pageViewController크기와 Main의 view크기와 맞춰서 addSubView로 main에 있는 view에 넣어준다.
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: pgView.frame.width, height: pgView.frame.height)
        self.pgView.addSubview(pageViewController.view)
    }
    
    @IBAction func prevAction(_ sender: Any) {
        // 지금 페이지 - 1
        let prevPage = currentPage - 1
        //화면 이동 (지금 페이지에서 -1 페이지로 setView 합니다.)
        pageViewController.setViewControllers([viewsList[prevPage]], direction: .reverse, animated: true)
        
        //현재 페이지 잡아주기
        currentPage = pageViewController.viewControllers!.first!.view.tag
        enabledBtn()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        // 지금 페이지 + 1
        let nextPage = currentPage + 1
        //화면 이동 (지금 페이지에서 -1 페이지로 setView 합니다.)
        pageViewController.setViewControllers([viewsList[nextPage]], direction: .forward, animated: true)
        
        //현재 페이지 잡아주기
        currentPage = pageViewController.viewControllers!.first!.view.tag
        enabledBtn()
    }
    
    // 마지막페이지에 next버튼 막기, 첫페이지에 prev버튼 막기, 아니면 true 함수
    func enabledBtn() {
        if currentPage == 0 {
            prevBtn.isEnabled = false
        } else if currentPage == 2 {
            nextBtn.isEnabled = false
        } else {
            nextBtn.isEnabled = true
            prevBtn.isEnabled = true
        }
    }

}
extension ViewController:  UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController,didFinishAnimating finished: Bool,previousViewControllers: [UIViewController],transitionCompleted completed: Bool){
        //지금 페이지
        currentPage = pageViewController.viewControllers!.first!.view.tag
        enabledBtn()
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //다음페이지 이동
        guard let index = viewsList.firstIndex(of: viewController) else {return nil}
        let nextIndex = index + 1
        if nextIndex == viewsList.count { return nil }
        return viewsList[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //이전페이지 이동
        guard let index = viewsList.firstIndex(of: viewController) else {return nil}
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
        return viewsList[previousIndex]
    }
}
