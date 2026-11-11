#!/bin/sh
# Refresh the skill files from jqsp.com (the site is the source of truth).
# English goes to skills/, Chinese to zh-CN/: both languages use the same skill
# names, so they live apart and an installer picks up one language per path.
set -eu
cd "$(dirname "$0")/.."
base="${JQSP_BASE:-https://jqsp.com}"
files="
jqsp-drama/SKILL.md
jqsp-drama/script/SKILL.md
jqsp-drama/characters/SKILL.md
jqsp-drama/scenes-props/SKILL.md
jqsp-drama/voices/SKILL.md
jqsp-drama/storyboard/SKILL.md
jqsp-drama/quick/SKILL.md
jqsp-drama/images/SKILL.md
jqsp-drama/tts/SKILL.md
jqsp-video/SKILL.md
jqsp-video/API.md
jqsp-talking-head/SKILL.md
"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
for f in $files; do
  curl -fsS --create-dirs "$base/skills/en/$f" -o "$tmp/skills/$f"
  curl -fsS --create-dirs "$base/skills/$f" -o "$tmp/zh-CN/$f"
done
# The drama API reference exists in English only and serves both languages.
curl -fsS "$base/skills/jqsp-drama/API.md" -o "$tmp/skills/jqsp-drama/API.md"
cp "$tmp/skills/jqsp-drama/API.md" "$tmp/zh-CN/jqsp-drama/API.md"

# A one-line `description:` containing ": " is not valid YAML for strict
# parsers (skill installers skip the file). Rewrite it as a block scalar; the
# text itself is unchanged.
find "$tmp" -name SKILL.md -exec python3 -c '
import re, sys
for path in sys.argv[1:]:
    text = open(path, encoding="utf-8").read()
    end = text.find("\n---\n", 4)
    if not text.startswith("---\n") or end < 0:
        continue
    lines = []
    for line in text[4:end].split("\n"):
        m = re.match(r"^(name|description): (.*)$", line)
        if m and m.group(2)[:1] not in ("\"", "\x27", ">", "|") and (": " in m.group(2) or " #" in m.group(2)):
            lines += [m.group(1) + ": >-", "  " + m.group(2)]
        else:
            lines.append(line)
    open(path, "w", encoding="utf-8").write("---\n" + "\n".join(lines) + text[end:])
' {} +

rm -rf skills zh-CN
mv "$tmp/skills" skills
mv "$tmp/zh-CN" zh-CN
echo "updated: $(find skills zh-CN -type f | wc -l | tr -d ' ') files"
grep -h -m1 -E "Skill version|技能版本" skills/jqsp-drama/SKILL.md zh-CN/jqsp-drama/SKILL.md
