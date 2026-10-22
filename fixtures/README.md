# 测试资产约定

本目录存放教师下发的固定测试名片集与 Ground Truth。**全部为合成数据，禁止真实个人信息。**

## 1. 目录结构

```
fixtures/
├─ manifest.json              # 测试集清单与类别标注
├─ reference_test_suite.md    # 教师下发的 T01–T20 原始定义
├─ cards/                     # 名片图片（jpg/png），文件名即 case id
├─ ground_truth/              # 每张名片一个 JSON：<case-id>.json
└─ expected/                  # 期望的 vCard / 导出快照（可选）
```

## 2. 命名规范

- case id：`c001`、`c002`……，与 `manifest.json` 的 `id` 一致。
- 图片：`cards/c001.jpg`；Ground Truth：`ground_truth/c001.json`。
- 一个 case 可以有多张变体图（同一张名片的不同拍摄条件）：`c001-tilt.jpg`、`c001-shadow.jpg`，Ground Truth 仍共用 `c001.json`。

## 3. manifest.json 结构

```json
{
  "datasetVersion": "teacher-2026-01",
  "source": "teacher | synthetic",
  "cases": [
    {
      "id": "c001",
      "images": ["cards/c001.jpg"],
      "language": "zh-Hans" ,
      "orientation": "landscape",
      "condition": ["front", "tilt", "shadow", "complex-background"],
      "expectedDetection": true,
      "notes": "字段缺失：website"
    }
  ]
}
```

字段说明：

| 字段 | 取值 | 用途 |
|---|---|---|
| `language` | `zh-Hans` / `en` / `mixed` | 分组评估 OCR 语言表现 |
| `orientation` | `landscape` / `portrait` | 验证方向校正 |
| `condition` | 见 `要求/01.md` 7.3 八类 | 检测鲁棒性分组 |
| `expectedDetection` | `true` / `false` | 检测失败用例用于验证回退路径 |

## 4. Ground Truth 结构

见 `ground_truth.schema.json`。约定：

- 未出现在名片上的字段**必须省略**或为 `null`，不得写空字符串占位。
- 多值字段使用数组，顺序不影响评分。
- `name` 允许包含称谓（`Dr.`），评分前统一归一化。

## 5. 评估口径

- 字段级评分：先归一化（去首尾空白、全角转半角、号码只留数字、邮箱小写），再判等。
- 虚构字段单独计数：Ground Truth 中不存在、但系统输出了非空值 → 记 `fabricated`，该字段精确率记为 0。
- 置信区间：样本 < 30 时只报告绝对值，不宣称统计显著。
- 报告必须标注数据集来源（教师集 / 自建集）与版本号。

## 6. 接收检查清单

- [ ] 图片数量与 `manifest.json` 一致
- [ ] 每个 case 都有 Ground Truth
- [ ] 无真实手机号/邮箱/住址（正则扫描 `1[3-9]\d{9}` 与真实域名）
- [ ] `sha256` 清单已生成（`scripts/checksum.sh`，后续阶段补充）
