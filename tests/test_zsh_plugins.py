import os
import subprocess
import tempfile
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
LIB = os.path.join(REPO_ROOT, "zsh", "lib_plugins.sh")
WANTED = ["git", "zsh-autosuggestions", "zsh-syntax-highlighting"]


class TestEnsurePlugins(unittest.TestCase):
    def run_ensure(self, zshrc_content):
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, ".zshrc")
            with open(path, "w", encoding="utf-8") as f:
                f.write(zshrc_content)
            subprocess.run(
                ["bash", "-c", f'source "{LIB}"; ensure_plugins "{path}" {" ".join(WANTED)}'],
                check=True,
            )
            with open(path, encoding="utf-8") as f:
                return f.read()

    def plugins_of(self, zshrc_content):
        """用 zsh 實際解析 .zshrc，取得 plugins 陣列的最終內容。"""
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, ".zshrc")
            with open(path, "w", encoding="utf-8") as f:
                f.write(zshrc_content)
            out = subprocess.run(
                ["zsh", "-c", f'source "{path}"; print -l -- $plugins'],
                check=True, capture_output=True, text=True,
            )
            return out.stdout.split()

    def test_no_plugins_line_appends_full_array(self):
        result = self.run_ensure("export FOO=1\n")
        self.assertEqual(self.plugins_of(result), WANTED)

    def test_single_line_adds_missing_only(self):
        result = self.run_ensure("plugins=(git docker)\n")
        self.assertEqual(self.plugins_of(result), ["git", "docker", "zsh-autosuggestions", "zsh-syntax-highlighting"])

    def test_multi_line_is_not_corrupted(self):
        original = "ZSH_THEME=x\nplugins=(\n  git\n  docker\n)\nFOO=tail\n"
        result = self.run_ensure(original)
        self.assertEqual(self.plugins_of(result), ["git", "docker", "zsh-autosuggestions", "zsh-syntax-highlighting"])
        self.assertEqual(result.count("plugins=("), 1)
        self.assertTrue(result.endswith("FOO=tail\n"))

    def test_multi_line_with_comments_keeps_comments(self):
        original = "plugins=(\n  # 版控\n  git\n)\n"
        result = self.run_ensure(original)
        self.assertIn("# 版控", result)
        self.assertEqual(self.plugins_of(result), WANTED)

    def test_idempotent(self):
        once = self.run_ensure("plugins=(\n  git\n)\n")
        twice = self.run_ensure(once)
        self.assertEqual(once, twice)

    def test_comment_mentioning_plugin_does_not_count(self):
        result = self.run_ensure("plugins=(git) # zsh-autosuggestions later\n")
        self.assertEqual(self.plugins_of(result), WANTED)


if __name__ == "__main__":
    unittest.main()
