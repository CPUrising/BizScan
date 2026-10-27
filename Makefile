.PHONY: help project core verify unit ui specs archive clean

help:
	@echo "BizScan 常用命令（macOS；core 可在 Windows 运行）"
	@echo "  make project   生成 BizScan.xcodeproj（XcodeGen）"
	@echo "  make core      只跑 BizScanCore 单元测试（swift test）"
	@echo "  make verify    全量验证：core + 单测 + UI 测试"
	@echo "  make unit      只跑 core + iOS 单元测试"
	@echo "  make ui        只跑 core + UI 测试"
	@echo "  make specs     校验全部 OpenSpec 规范与变更"
	@echo "  make archive CHANGE=<id>  归档已通过验证的变更"
	@echo "  make clean     清理生成物"

project:
	xcodegen generate

core:
	swift test --package-path Packages/BizScanCore

verify:
	bash scripts/verify.sh

unit:
	bash scripts/verify.sh --scope unit

ui:
	bash scripts/verify.sh --scope ui

specs:
	openspec validate --all --strict

archive:
	@test -n "$(CHANGE)" || (echo "用法: make archive CHANGE=<change-id>" && exit 2)
	openspec archive "$(CHANGE)"

clean:
	rm -rf build artifacts BizScan.xcodeproj
