#!/usr/bin/env python3
"""
VS Code / VS Code Insiders Settings Configuration Script.

Safely merges configuration options into settings.json without overwriting existing preferences.
"""

import argparse
import json
import os
import sys
from typing import Dict, List, Optional


def get_target_settings_paths() -> List[str]:
    """Return standard settings.json paths for VS Code and VS Code Insiders on macOS."""
    return [
        os.path.expanduser("~/Library/Application Support/Code/User/settings.json"),
        os.path.expanduser("~/Library/Application Support/Code - Insiders/User/settings.json"),
    ]


def update_settings(file_path: str, new_settings: Dict[str, object]) -> bool:
    """Safely merge new_settings into the target settings.json file."""
    dir_name = os.path.dirname(file_path)
    if dir_name:
        os.makedirs(dir_name, exist_ok=True)

    settings: Dict[str, object] = {}
    if os.path.exists(file_path):
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read().strip()
                if content:
                    settings = json.loads(content)
        except Exception as e:
            print(f"[!] 讀取現有設定檔失敗 ({file_path}): {e}", file=sys.stderr)
            return False

    settings.update(new_settings)

    try:
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(settings, f, indent=4, ensure_ascii=False)
            f.write("\n")
        return True
    except Exception as e:
        print(f"[!] 寫入設定檔失敗 ({file_path}): {e}", file=sys.stderr)
        return False


def configure_vscode_settings(
    font_size: int = 13,
    zoom_level: int = 1,
    paths: Optional[List[str]] = None,
) -> Dict[str, bool]:
    """Configure font size and related settings for all detected VS Code variants."""
    target_paths = paths if paths is not None else get_target_settings_paths()
    results: Dict[str, bool] = {}

    settings_to_apply = {
        "editor.fontSize": font_size,
        "window.zoomLevel": zoom_level,
    }

    for path in target_paths:
        dir_name = os.path.dirname(path)
        # 僅在對應 Application Support 目錄存在時，才執行寫入，避免無端建立幽靈目錄
        # 若是手動指定的自訂路徑，則直接處理
        if paths is not None or os.path.exists(dir_name):
            success = update_settings(path, settings_to_apply)
            results[path] = success
            if success:
                print(f"[✓] 已成功配置 {path} (editor.fontSize = {font_size}, window.zoomLevel = {zoom_level})")
            else:
                print(f"[!] 配置失敗: {path}", file=sys.stderr)
        else:
            print(f"[*] 未偵測到對應目錄，略過: {path}")

    return results


def main() -> int:
    parser = argparse.ArgumentParser(description="配置 VS Code 與 VS Code Insiders 的 settings.json")
    parser.add_argument(
        "--font-size",
        type=int,
        default=13,
        help="編輯器字型大小 (預設為 13)",
    )
    parser.add_argument(
        "--zoom-level",
        type=int,
        default=1,
        help="視窗縮放比例 (預設為 1)",
    )
    args = parser.parse_args()

    print("====================================================")
    print("      VS Code / VS Code Insiders Settings Setup     ")
    print("====================================================")
    print(f"[*] 設定項目: editor.fontSize = {args.font_size}")
    print(f"[*] 設定項目: window.zoomLevel = {args.zoom_level}")

    results = configure_vscode_settings(font_size=args.font_size, zoom_level=args.zoom_level)
    if any(results.values()):
        print("[✓] VS Code 設定檔更新完成！")
        return 0
    else:
        print("[!] 未有任何設定檔被更新（可能尚未安裝 VS Code）。")
        return 0


if __name__ == "__main__":
    sys.exit(main())
