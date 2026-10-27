#!/usr/bin/env bash
# BizScan 统一验证入口
#
# 用法（macOS 必需；Windows 仅可跑 core 层且需自行安装 Swift 工具链）：
#   scripts/verify.sh                      # 全量：core 单测 + iOS 单测 + UI 测试
#   scripts/verify.sh --scope core         # 只跑 BizScanCore（跨平台）
#   scripts/verify.sh --scope unit         # core + iOS 单元测试
#   scripts/verify.sh --scope ui           # core + UI 测试
#   scripts/verify.sh --change 0001-app-skeleton
#
# 产物：
#   artifacts/verify-<change>-<timestamp>.log
#   artifacts/verify-<change>-<timestamp>.xcresult
#   把结果填写到 docs/verify/<change>.md（模板：docs/verify/TEMPLATE.md）
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

SCOPE="all"
CHANGE="local"
SCHEME="${SCHEME:-BizScan}"
DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 16,OS=18.0}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --scope) SCOPE="$2"; shift 2 ;;
    --change) CHANGE="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,16p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) echo "未知参数: $1" >&2; exit 2 ;;
  esac
done

fail() { echo "✗ $*" >&2; exit 1; }

STAMP="$(date +%Y%m%d-%H%M%S)"
mkdir -p artifacts
LOG="artifacts/verify-${CHANGE}-${STAMP}.log"

echo "== BizScan verify =="
echo "change : $CHANGE"
echo "scope  : $SCOPE"
echo "log    : $LOG"
echo

run_core() {
  command -v swift >/dev/null 2>&1 || fail "未找到 swift，无法运行 BizScanCore 测试。"
  echo "-> swift test (BizScanCore)" | tee -a "$LOG"
  swift test --package-path Packages/BizScanCore 2>&1 | tee -a "$LOG"
}

case "$SCOPE" in
  core)
    run_core
    echo
    echo "✓ BizScanCore 验证完成：$CHANGE"
    exit 0
    ;;
  all|unit|ui) ;;
  *) fail "--scope 只接受 all | core | unit | ui" ;;
esac

[[ "$(uname -s)" == "Darwin" ]] || fail "iOS 层验证必须在 macOS 上运行（core 层请用 --scope core）。"
command -v xcodebuild >/dev/null 2>&1 || fail "未找到 xcodebuild，请安装 Xcode 并执行 xcode-select -s。"
command -v xcodegen >/dev/null 2>&1 || fail "未找到 xcodegen，请执行：brew install xcodegen"

run_core

echo "-> xcodegen generate" | tee -a "$LOG"
xcodegen generate | tee -a "$LOG"

RESULT="artifacts/verify-${CHANGE}-${STAMP}.xcresult"

CASE_ARGS=()
case "$SCOPE" in
  all)  CASE_ARGS=(-only-testing:BizScanTests -only-testing:BizScanUITests) ;;
  unit) CASE_ARGS=(-only-testing:BizScanTests) ;;
  ui)   CASE_ARGS=(-only-testing:BizScanUITests) ;;
esac

echo "-> xcodebuild test (${SCOPE})" | tee -a "$LOG"
set +e
xcodebuild test \
  -project BizScan.xcodeproj \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  -derivedDataPath build/DerivedData \
  -resultBundlePath "$RESULT" \
  "${CASE_ARGS[@]}" \
  CODE_SIGNING_ALLOWED=NO \
  2>&1 | tee -a "$LOG"
STATUS=${PIPESTATUS[0]}
set -e

echo
if [[ $STATUS -eq 0 ]]; then
  echo "✓ 验证通过：$CHANGE"
else
  echo "✗ 验证失败（exit $STATUS）：$CHANGE"
  echo "  日志：$LOG"
fi

cat <<EOF

下一步：
  1. 新建/更新 docs/verify/${CHANGE}.md（模板 docs/verify/TEMPLATE.md）
  2. 逐条填写 Requirement / Scenario 的 PASS / FAIL 与测试方法
  3. 在 README.md 的阶段看板中登记状态与证据链接
  4. 全部通过后执行：openspec archive ${CHANGE}

EOF

exit $STATUS
