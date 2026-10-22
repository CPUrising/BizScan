import Foundation

/// 所有用户可见文案集中在此，便于对照参考 App 后统一修正，而不是散落在 View 里。
enum AppCopy {
    static let appName = "BizScan"
    static let cardHolder = "名片夹"

    static let scanCard = "扫描名片"
    static let importPhoto = "从相册导入"
    static let search = "搜索"
    static let cancel = "取消"
    static let back = "返回"
    static let retake = "重拍"
    static let confirm = "确认"
    static let save = "保存"
    static let edit = "编辑"
    static let delete = "删除"
    static let done = "完成"
    static let next = "下一步"
    static let export = "导出联系人"
    static let exportAll = "导出全部"
    static let rotate = "旋转 90°"

    static let emptyTitle = "还没有名片"
    static let emptyMessage = "扫描或导入一张名片，开始建立你的名片夹。"
    static let unnamedCard = "未命名名片"
    static let searchPlaceholder = "搜索姓名、公司、电话、邮箱"
    static let searchEmpty = "没有找到匹配的名片"
    static let tagsTitle = "标签"
    static let allTags = "全部"
    static let addTag = "新建标签"

    static let permissionTitle = "需要相机权限"
    static let permissionMessage = "请在系统设置中允许 BizScan 使用相机。"
    static let openSettings = "前往设置"

    static let reviewTitle = "确认识别结果"
    static let reviewMessage = "AI 结果可能存在错误，请核对后保存。"
    static let unknownFieldsTitle = "待确认内容"
    static let saveEmptyWarning = "未填写任何字段，仍要保存吗？"

    static let detailTitle = "名片详情"
    static let deleteConfirmTitle = "删除这张名片？"
    static let deleteConfirmMessage = "删除后无法恢复。"
    static let errorTitle = "出错了"

    static let processing = "识别中…"
    static let exportFailed = "导出失败"
}
