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
    private var viewModel: MKScheduleViewModel!
    private let refreshControl = UIRefreshControl()
    private var calendar = Calendar.current
    private var targetMonth: Int = 0
    private var targetYear: Int = 0
    private var isFirstFetchingData = true
    
    required init(viewModel: MKScheduleViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel.delegate = self
        self.targetYear = calendar.component(.year, from: Date())
        self.targetMonth = calendar.component(.month, from: Date())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cpblBlue
        view.addSubview(headerView)
        headerView.addSubview(leftButton)
        headerView.addSubview(monthButton)
        headerView.addSubview(rightButton)
        view.addSubview(tableView)
        
        //refresh control
        refreshControl.tintColor = UIColor.white
        tableView.addSubview(refreshControl)
        
        setupConstraints()
        
        setupCalendarView()
        
        monthButton.addTarget(self, action: #selector(toggleCalendarView), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        
        fetchSchedule()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    private lazy var headerView: MKContainerView = {
        let view = MKContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.separatorInset = UIEdgeInsets.zero
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
        view.setTitle("\(self.targetYear) 年 \(self.targetMonth) 月", for: .normal)
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
        view.appearance.spaceBetweenWeekViews = 1
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.tableFooterView = UIView()
        view.separatorColor = UIColor.gray
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.rowHeight = 100
        view.dataSource = self
        view.delegate = self
        view.register(MKGameTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        view.sectionHeaderHeight = 24
        return view
    }()
}

extension MKScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.allGames[section].model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MKGameTableViewCell
        let model = self.viewModel.allGames[indexPath.section].model[indexPath.row]
        cell.applyCellViewModel(model)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.allGames.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = self.viewModel.allGames[section].date
        dateLabel.textColor = UIColor.cpblBlue
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        return view
    }
}

extension MKScheduleViewController: UITableViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            self.fetchSchedule(forceUpdate: true)
        }
    }
}

extension MKScheduleViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    // MARK: Required methods
    func presentationMode() -> CalendarMode { return .monthView }
    
    func firstWeekday() -> Weekday { return .sunday }
    
    func didShowNextMonthView(_ date: Date) {
        self.setupYearAndMonth(date: date)
    }
    
    func didShowPreviousMonthView(_ date: Date) {
        self.setupYearAndMonth(date: date)
    }
    
    // WIP: didSelectDayView to scroll table view to that date
}

extension MKScheduleViewController: MKScheduleViewModelDelegate {
    func viewModel(_ viewModel: MKScheduleViewModel, didChangeViewMode: MKViewMode) {
        if didChangeViewMode == .loading {
            return
        }
        DispatchQueue.main.sync { [unowned self] in
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            if isFirstFetchingData == true {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: self.viewModel.getNearestDateIndex()), at: .top, animated: true)
                isFirstFetchingData = false
            }
        }
    }
}

private extension MKScheduleViewController {
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { (make) in
            // top offset = logo(56) + offset
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(56 + 16)
            } else {
                make.top.equalToSuperview().offset(56 + 16)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(52)
        }
        
        leftButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        monthButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftButton.snp.right)
            make.right.equalTo(rightButton.snp.left)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(32)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    func setupCalendarView() {
        view.addSubview(calendarMainView)
        calendarMainView.addSubview(menuView)
        calendarMainView.addSubview(calendarView)
        
        calendarMainView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            //calendarView 會自己 layout height,
            //期待 calendarMainView.height >= menuView.height + calendarView.height + offset
            make.height.equalTo(360)
        }
        
        menuView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints { (make) in
            make.top.equalTo(menuView.snp.bottom)
            make.height.equalTo(360)
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
    
    func fetchSchedule(forceUpdate: Bool = false) {
        viewModel.fetchSchedule(atYear: self.targetYear, month: self.targetMonth, forceUpdate: forceUpdate)
    }
    
    @objc func leftAction() {
        self.calendarView.loadPreviousView()
    }
    
    @objc func rightAction() {
        self.calendarView.loadNextView()
    }
    
    func setupYearAndMonth(date: Date) {
        self.targetYear = calendar.component(.year, from: date)
        self.targetMonth = calendar.component(.month, from: date)
        self.monthButton.setTitle("\(self.targetYear) 年 \(self.targetMonth) 月", for: .normal)
        self.fetchSchedule()
    }
}
