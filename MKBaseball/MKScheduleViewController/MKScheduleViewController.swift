//
//  MKScheduleViewController.swift
//  MKBaseball
//
//  Created by Mason Kao on 2018/7/27.
//  Copyright © 2018年 Mission. All rights reserved.
//

import UIKit
import CVCalendar

class MKScheduleViewController: UIViewController {
    
    private let cellReuseIdentifier = "MKScheduleTableViewCell"
    private var isCalendarMainViewAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(stackView)
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(monthButton)
        stackView.addArrangedSubview(rightButton)
        view.addSubview(tableView)
        setupConstraints()
        
        setupCalendarView()
        
        monthButton.addTarget(self, action: #selector(toggleCalendarView), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 0
        return view
    }()
    
    private lazy var leftButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate)
        let filledImage = UIImage(named: "arrow_left_filled")?.withRenderingMode(.alwaysTemplate)
        view.setImage(image, for: .normal)
        view.setImage(filledImage, for: .highlighted)
        view.tintColor = UIColor.cpblBlue
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var monthButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("2018 年 8 月", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        view.titleLabel?.textAlignment = .center
        view.setTitleColor(UIColor.cpblBlue, for: .normal)
        view.setTitleColor(UIColor.gray, for: .highlighted)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var rightButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
        let filledImage = UIImage(named: "arrow_right_filled")?.withRenderingMode(.alwaysTemplate)
        view.setImage(image, for: .normal)
        view.setImage(filledImage, for: .highlighted)
        view.tintColor = UIColor.cpblBlue
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var calendarMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.alpha = 0
        return view
    }()
    
    private lazy var menuView: CVCalendarMenuView = {
        let view = CVCalendarMenuView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.menuViewDelegate = self
        return view
    }()
    
    private lazy var calendarView: CVCalendarView = {
        let view = CVCalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.calendarAppearanceDelegate = self
        view.animatorDelegate = self
        view.calendarDelegate = self
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.tableFooterView = UIView()
        view.separatorColor = UIColor.gray
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.rowHeight = 44
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return view
    }()
}

extension MKScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
}

extension MKScheduleViewController: UITableViewDelegate {
}

extension MKScheduleViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    // MARK: Required methods
    
    func presentationMode() -> CalendarMode { return .monthView }
    
    func firstWeekday() -> Weekday { return .sunday }
    
}

private extension MKScheduleViewController {
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            // top offset = logo(56) + offset
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(56 + 16)
            } else {
                make.top.equalToSuperview().offset(56 + 16)
            }
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
        leftButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(32)
        }
        
        monthButton.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(32)
        }
    }
    
    func setupCalendarView() {
        view.addSubview(calendarMainView)
        calendarMainView.addSubview(menuView)
        calendarMainView.addSubview(calendarView)
        
        calendarMainView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            //calendarView 會自己 layout height,
            //期待 calendarMainView.height >= menuView.height + calendarView.height + offset
            make.height.equalTo(420)
        }
        
        menuView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints { (make) in
            make.top.equalTo(menuView.snp.bottom).offset(4)
            make.height.equalTo(400)
            make.left.right.equalToSuperview()
        }
    }
    
    @objc func toggleCalendarView() {
        UIView.animate(withDuration: 0.3) {
            if self.isCalendarMainViewAppear == false {
                self.calendarMainView.alpha = 1
                self.isCalendarMainViewAppear = true
            } else {
                self.calendarMainView.alpha = 0
                self.isCalendarMainViewAppear = false
            }
        }
    }
}