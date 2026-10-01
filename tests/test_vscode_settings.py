import os
import json
import tempfile
import unittest
import sys

# Ensure repository root is in python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from vscode.configure_settings import update_settings, configure_vscode_settings


class TestVSCodeSettings(unittest.TestCase):
    def setUp(self):
        self.test_dir = tempfile.TemporaryDirectory()
        self.settings_file = os.path.join(self.test_dir.name, "settings.json")

    def tearDown(self):
        self.test_dir.cleanup()

    def test_update_settings_creates_file_if_not_exists(self):
        result = update_settings(self.settings_file, {"editor.fontSize": 14})
        self.assertTrue(result)
        self.assertTrue(os.path.exists(self.settings_file))
        with open(self.settings_file, "r", encoding="utf-8") as f:
            data = json.load(f)
        self.assertEqual(data.get("editor.fontSize"), 14)

    def test_update_settings_preserves_existing_keys(self):
        initial_data = {
            "terminal.integrated.fontFamily": "MesloLGS NF",
            "workbench.colorTheme": "Winter is Coming"
        }
        with open(self.settings_file, "w", encoding="utf-8") as f:
            json.dump(initial_data, f, indent=4)

        result = update_settings(self.settings_file, {"editor.fontSize": 14})
        self.assertTrue(result)

        with open(self.settings_file, "r", encoding="utf-8") as f:
            data = json.load(f)

        self.assertEqual(data.get("editor.fontSize"), 14)
        self.assertEqual(data.get("terminal.integrated.fontFamily"), "MesloLGS NF")
        self.assertEqual(data.get("workbench.colorTheme"), "Winter is Coming")

    def test_update_settings_modifies_existing_font_size(self):
        initial_data = {
            "editor.fontSize": 12,
            "terminal.integrated.fontFamily": "MesloLGS NF"
        }
        with open(self.settings_file, "w", encoding="utf-8") as f:
            json.dump(initial_data, f, indent=4)

        result = update_settings(self.settings_file, {"editor.fontSize": 14})
        self.assertTrue(result)

        with open(self.settings_file, "r", encoding="utf-8") as f:
            data = json.load(f)

        self.assertEqual(data.get("editor.fontSize"), 14)
        self.assertEqual(data.get("terminal.integrated.fontFamily"), "MesloLGS NF")

    def test_update_settings_returns_false_and_preserves_corrupted_file(self):
        corrupt_content = '{\n  "editor.fontSize": 12,\n  INVALID_JSON\n}'
        with open(self.settings_file, "w", encoding="utf-8") as f:
            f.write(corrupt_content)

        result = update_settings(self.settings_file, {"editor.fontSize": 14})
        self.assertFalse(result)

        # Confirm file was not overwritten
        with open(self.settings_file, "r", encoding="utf-8") as f:
            content = f.read()
        self.assertEqual(content, corrupt_content)

    def test_configure_vscode_settings_custom_paths(self):
        file2 = os.path.join(self.test_dir.name, "settings_insiders.json")
        res = configure_vscode_settings(font_size=16, paths=[self.settings_file, file2])
        self.assertEqual(res, {self.settings_file: True, file2: True})

        with open(self.settings_file, "r", encoding="utf-8") as f:
            data = json.load(f)
        self.assertEqual(data.get("editor.fontSize"), 16)
        self.assertEqual(data.get("window.zoomLevel"), 1)

        with open(file2, "r", encoding="utf-8") as f:
            data = json.load(f)
        self.assertEqual(data.get("editor.fontSize"), 16)
        self.assertEqual(data.get("window.zoomLevel"), 1)

    def test_configure_vscode_settings_custom_zoom_level(self):
        res = configure_vscode_settings(font_size=15, zoom_level=2, paths=[self.settings_file])
        self.assertEqual(res, {self.settings_file: True})

        with open(self.settings_file, "r", encoding="utf-8") as f:
            data = json.load(f)
        self.assertEqual(data.get("editor.fontSize"), 15)
        self.assertEqual(data.get("window.zoomLevel"), 2)


if __name__ == "__main__":
    unittest.main()
