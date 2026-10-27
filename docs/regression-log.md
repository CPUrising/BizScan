# 回归基线

每次验证通过后追加一行。任何一次 change 归档前必须与最近基线对照。

| 日期 | change | 通过用例 | 失败用例 | 跳过 | 证据 |
|---|---|---|---|---|---|
| 2026-10-27 | `0010-toolchain-compile-fixes` | 69 unit（core 62 + iOS 7），无 Txx | 0 | UI 全量（本 change 未改 View） | [verify/0010](verify/0010-toolchain-compile-fixes.md) |
| 2026-10-27 | `0009-acceptance-hardening` | T01,T02,T08,T09,T10,T13,T14,T15,T16,T17,T19(L1),T20(中途退出) + 62 unit + 11 UI | 0 | T03–T07,T11,T12,T18,T19(UI),T20(重拍/空名片)；iOS 单元本轮未跑 | [verify/0009](verify/0009-acceptance-hardening.md) |

| 2026-10-27 | `0013-service-layer-coverage` | T06,T07,T20(旋转/回退) + 62 core + 50 L2（新增 19） | 0 | UI（本轮 `--scope unit`）；T03–T05,T18 真机,T19 分享面板 | [verify/0013](verify/0013-service-layer-coverage.md) |
| 2026-10-27 | `0014-ocr-eval-baseline` | T07 + 评估基线 15 例（虚构字段 0） + 62 core + 50 L2 + 11 UI | 0 | T03–T05,T18 真机,T19 分享面板 | [verify/0014](verify/0014-ocr-eval-baseline.md) |

## 使用规则

1. **基线只增不改**：历史行不得修改，只追加。
2. `通过用例` 记录 Txx 编号与单测数量，例：`T01,T02,T12 + 24 unit`。
3. 失败用例必须链接到 `docs/verify/<change>.md` 的偏差编号。
4. 归档前若失败数 > 基线，必须说明原因并新开修复 change。
