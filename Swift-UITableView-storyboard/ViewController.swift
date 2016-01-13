//
//  ViewController.swift
//  Swift-UITableView-storyboard
//
//  Created by wangfei on 16/1/12.
//  Copyright © 2016年 wanghu. All rights reserved.
//
//
import UIKit
// 打印测试
private enum YJPrintStyle: Int {
    case ConfiguringRowsForTheTableView
    case ManagingAccessoryViews
    case ManagingSelections
    case ModifyingTheHeaderAndFooterOfSections
    case EditingTableRows
    case ReorderingTableRows
    case TrackingTheRemovalOfViews
    case CopyingAndPastingRowContent
    case ManagingTableViewHighlighting
    case ManagingTableViewFocus
    
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func Btn(sender: AnyObject) {
        //进入编辑状态的按钮
        self.tableView.setEditing(!self.tableView.editing, animated: true)
    }
    //数据源
    var data = [[Int]]()
    /// 打印测试
    private var printStyle: YJPrintStyle!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor=UIColor.greenColor();
        self.printStyle = .ManagingTableViewFocus

        //以数组演示,填充相关数据
        var section = [Int]()
        for  _ in 0..<5 {
        section.removeAll()
            for row in 0..<10 {
            section.append(row)
            }
            self.data.append(section)
        }
    }
    /// TableViewDataSource展示
 // MARK: 每一组有几个元素
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return self.data[section].count
    }
    // MARK: - UITableViewDataSource
    // MARK: 有几组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int  {
       
        return self.data.count
    }
    
     // MARK: 生成Cell
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        //方法1中写法
        //if  indexPath.row == 0
       // {
//        let cell = tableView .dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
//            cell.textLabel?.text="\(self.data[indexPath.section][indexPath.row])"
//            return cell
//        } else {
//        let cell = tableView .dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as UITableViewCell
//            return cell
//        }
        //方法第二种写法
        var cell=tableView.dequeueReusableCellWithIdentifier("cell")
        if cell==nil {
        cell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
          cell?.accessoryType = UITableViewCellAccessoryType.DetailButton  
        }
        cell?.textLabel?.text = "\(self.data[indexPath.section][indexPath.row])--\(indexPath.section)"
        if self.printStyle == .ManagingTableViewFocus {
            cell?.focusStyle = UITableViewCellFocusStyle.Custom // 自定义焦点
        }

        return cell
      
    }
    // MARK: 组Header
    // MARK: 组Header
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       // print(__FUNCTION__)
        return "\(section)--Header"
    }
    // MARK: 组Footer
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
       // print(__FUNCTION__)
        return "\(section)--Footer"
    }
    // MARK: 索引
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
      //  print(__FUNCTION__)
        var sectionTitles = [String]()
        for i in 0..<self.data.count {
            sectionTitles.append("\(i)")
        }
        return sectionTitles
    }
    // MARK: 索引对应的组
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        return Int(title) ?? 0
    }
    // MARK: 能否编辑
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    // MARK: 增加和删除
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.data[indexPath.section].removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    // MARK: 能否移动
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
   
        return true
    }
    
    // MARK: 移动cell
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
 
        // 处理源数据
        let sourceData = self.data[sourceIndexPath.section][sourceIndexPath.row]
        self.data[sourceIndexPath.section].removeAtIndex(sourceIndexPath.row)
        self.data[destinationIndexPath.section].insert(sourceData, atIndex: destinationIndexPath.row)
    }
     // MARK: - UITableViewDelegate
    // MARK: - 1. Configuring Rows for the Table View
    // MARK: 预获取行高
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 实现此方法后,显示界面前func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloath不会执行，有助于提升显示效率
        if self.printStyle == .ConfiguringRowsForTheTableView {
            print("\(__FUNCTION__)--\(indexPath)")
        }
        return tableView.estimatedRowHeight
    }
    // MARK: 行缩进
    func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if self.printStyle == .ConfiguringRowsForTheTableView {
            print("\(__FUNCTION__)--\(indexPath)")
        }
        return self.data[indexPath.section][indexPath.row]
    }
    // MARK: 行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.printStyle == .ConfiguringRowsForTheTableView {
            print("\(__FUNCTION__)--\(indexPath)")
        }
        // 默认44
        return tableView.rowHeight
    }
    // MARK: 将要显示行
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if self.printStyle == .ConfiguringRowsForTheTableView {
            print("\(__FUNCTION__)--\(indexPath)")
        }
    }
//    // MARK: - 2. Managing Accessory Views
//    // MARK: 左滑出现的按钮
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        if self.printStyle == .ManagingAccessoryViews {
//            print("\(__FUNCTION__)--\(indexPath)")
//        }
//        var action = [UITableViewRowAction]()
//        let handler: (UITableViewRowAction, NSIndexPath) -> Void = {(action: UITableViewRowAction, indexPath: NSIndexPath) in
//            print("\(indexPath)--\(action.title)")
//        }
//        action.append(UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Default", handler:handler))
//        action.append(UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Destructive", handler:handler))
//        action.append(UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Normal", handler:handler))
//        return action
//    }
    // MARK: 点击cell上的系统按钮
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        //cell?.accessoryType = UITableViewCellAccessoryType.DetailButton
        if self.printStyle == .ManagingAccessoryViews {
            print("\(__FUNCTION__)--\(indexPath)")
        }
    }
    // MARK: - 3. Managing Selections
    // MARK: 将要点击某行
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if self.printStyle == .ManagingSelections {
            print("\(__FUNCTION__)--\(indexPath)")
        }
        // 返回nil代表不能点击
        return indexPath
    }
    
    // MARK: 点击某行
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.printStyle == .ManagingSelections {
            print("\(__FUNCTION__)--\(indexPath)")
        }
    }
    // MARK: 将要删除某行
    func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if self.printStyle == .ManagingSelections {
            print("\(__FUNCTION__)--\(indexPath)")
        }
        // 返回nil代表不能删除
        return indexPath
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: 删除某行
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if self.printStyle == .ManagingSelections {
            print("\(__FUNCTION__)--\(indexPath)")
        }
    }
    
    // MARK: - 4. Modifying the Header and Footer of Sections
    // MARK: 预获取header高
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if self.printStyle == .ModifyingTheHeaderAndFooterOfSections {
            print("\(__FUNCTION__)--\(section)")
        }
        return tableView.estimatedSectionHeaderHeight
    }
    
    // MARK: 预获取footer高
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if self.printStyle == .ModifyingTheHeaderAndFooterOfSections {
            print("\(__FUNCTION__)--\(section)")
        }
        return tableView.estimatedSectionFooterHeight
    }
    
    // MARK: header高
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.printStyle == .ModifyingTheHeaderAndFooterOfSections {
            print("\(__FUNCTION__)--\(section)")
        }
        return tableView.sectionHeaderHeight
    }
    
    // MARK: footer高
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.printStyle == .ModifyingTheHeaderAndFooterOfSections {
            print("\(__FUNCTION__)--\(section)")
        }
        return tableView.sectionFooterHeight
    }
    
    // MARK: 自定义header
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.printStyle == .ModifyingTheHeaderAndFooterOfSections {
            print("\(__FUNCTION__)--\(section)")
        }
      //  let view = UIView(frame: CGRectMake(0, 0, YJUtilScreenSize.screenWidth, tableView.sectionHeaderHeight))
        view.backgroundColor = UIColor.redColor()
        return view
    }
    
    // MARK: 自定义footer
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.printStyle == .ModifyingTheHeaderAndFooterOfSections {
            print("\(__FUNCTION__)--\(section)")
        }
      //  let view = UIView(frame: CGRectMake(0, 0, YJUtilScreenSize.screenWidth, tableView.sectionFooterHeight))
        view.backgroundColor = UIColor.yellowColor()
        return view
    }
    
    // MARK: 将要显示header
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if self.printStyle == .ModifyingTheHeaderAndFooterOfSections {
            print("\(__FUNCTION__)--\(section)")
        }
    }
    
    // MARK: 将要显示footer
    func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if self.printStyle == .ModifyingTheHeaderAndFooterOfSections {
            print("\(__FUNCTION__)--\(section)")
        }
    }
    
    // MARK: - 5. Editing Table Rows
    // MARK: 将要进入编辑模式
    func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        if self.printStyle == .EditingTableRows {
            print("\(__FUNCTION__)--\(indexPath)")
        }
    }
    
    // MARK: 退出编辑模式
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        if self.printStyle == .EditingTableRows {
            print("\(__FUNCTION__)--\(indexPath)")
        }
    }
    
    // MARK: 编辑模式执行的操作
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if self.printStyle == .EditingTableRows {
            print("\(__FUNCTION__)--\(indexPath)")
        }
        return UITableViewCellEditingStyle.Delete
    }
    
    // MARK: 更改默认的删除按钮标题
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        if self.printStyle == .EditingTableRows {
            print("\(__FUNCTION__)--\(indexPath)")
        }
        return "自定义"
    }
    
    // MARK: 编辑模式下表视图背景是否缩进
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.printStyle == .EditingTableRows {
            print("\(__FUNCTION__)--\(indexPath)")
        }
        return true
    }
    
    // MARK: - 6. Reordering Table Rows
    // MARK: 移动cell
    func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if self.printStyle == .ReorderingTableRows {
            print("\(__FUNCTION__)--\(sourceIndexPath)--\(proposedDestinationIndexPath)")
        }
        return proposedDestinationIndexPath
    }
    
    // MARK: - 7. Tracking the Removal of Views
    // MARK: header消失
    func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if self.printStyle == .TrackingTheRemovalOfViews {
            print("\(__FUNCTION__)--\(section)")
        }
    }
    
    // MARK: cell消失
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if self.printStyle == .TrackingTheRemovalOfViews {
            print("\(__FUNCTION__)--\(indexPath)")
        }
    }
    
    // MARK: footer消失
    func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if self.printStyle == .TrackingTheRemovalOfViews {
            print("\(__FUNCTION__)--\(section)")
        }
    }
    // MARK: - 8. Copying and Pasting Row Content
    // 将要显示复制和粘贴板
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.printStyle == .CopyingAndPastingRowContent {
            print("\(__FUNCTION__)--\(indexPath)")
        }
        return true
    }
    
    // 显示复制和粘贴板
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        if self.printStyle == .CopyingAndPastingRowContent {
            print("\(__FUNCTION__)--\(indexPath)")
        }
        return true
    }
    
    // MARK: 点击复制和粘贴板上的按钮
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        if self.printStyle == .CopyingAndPastingRowContent {
            print("\(__FUNCTION__)--\(indexPath)--\(action)--\(sender)")
        }
    }
    
    // MARK: - 9. Managing Table View Highlighting
    // MARK: 点击cell能否进入高亮模式
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.printStyle == .ManagingTableViewHighlighting {
            print("\(__FUNCTION__)--\(indexPath)")
        }
        return true
    }
    
    // MARK: 正式进入高亮模式
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        if self.printStyle == .ManagingTableViewHighlighting {
            print("\(__FUNCTION__)--\(indexPath)")
        }
    }
    
    // MARK: 离开高亮模式
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        if self.printStyle == .ManagingTableViewHighlighting {
            print("\(__FUNCTION__)--\(indexPath)")
        }
    }
    
    // MARK: - 10. Managing Table View Focus
    // MARK: 是否指定路径
    func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.printStyle == .ManagingTableViewFocus {
            print("\(__FUNCTION__)--\(indexPath)")
        }
        return true
    }
    
    // MARK: 是否允许上下文更新
    func tableView(tableView: UITableView, shouldUpdateFocusInContext context: UITableViewFocusUpdateContext) -> Bool {
        if self.printStyle == .ManagingTableViewFocus {
            print("\(__FUNCTION__)--\(context)")
        }
        return true
    }
    
    // MARK: 上下文更新结束
    func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if self.printStyle == .ManagingTableViewFocus {
            print("\(__FUNCTION__)--\(context)")
        }
    }
    
    // MARK: 索引对应的路径
    func indexPathForPreferredFocusedViewInTableView(tableView: UITableView) -> NSIndexPath? {
        if self.printStyle == .ManagingTableViewFocus {
            print("\(__FUNCTION__)")
        }
        return nil
    }
    

}

