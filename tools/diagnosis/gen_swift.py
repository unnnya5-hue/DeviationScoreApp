"""releases/<version>.txt に書いた診断を DiagnosisCatalog.swift に追記し、NEWバッジ対象を差し替える。

使い方: python3 tools/diagnosis/gen_swift.py v1.2
（先に gen_review.py を実行して docs/new_diagnosis_questions_editable.json を最新にしておく）
"""
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
version = sys.argv[1]
json_path = os.path.join(HERE, "..", "..", "docs", "new_diagnosis_questions_editable.json")
swift_path = os.path.join(HERE, "..", "..", "iOS", "DeviationScoreApp", "DeviationScoreApp", "DiagnosisCatalog.swift")
ids = open(os.path.join(HERE, "releases", version + ".txt")).read().split()
data = {d["id"]: d for d in json.load(open(json_path, encoding="utf-8"))}

CAT = {"恋愛": "romance", "知識": "knowledge", "コミュ力": "social", "仕事": "career", "就活": "jobHunt",
       "お金": "money", "生活": "life", "メンタル": "mental", "センス": "style", "趣味": "hobby", "ネタ": "fun"}
BANDS = {"kage-no-mono": "kageNoMonoBands", "isekai": "isekaiBands"}

def lit(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'

def n(v):
    return repr(v) if isinstance(v, float) else str(v)

def rule(s):
    m = s["mode"]
    if m == "range":
        return f".range(min: {n(s['idealMin'])}, max: {n(s['idealMax'])}, zeroBelow: {n(s['zeroBelow'])}, zeroAbove: {n(s['zeroAbove'])})"
    if m == "higherIsBetter":
        return f".higher(min: {n(s['idealMin'])}, max: {n(s['idealMax'])})"
    if m == "lowerIsBetter":
        return f".lower(min: {n(s['idealMin'])}, max: {n(s['idealMax'])})"
    if m == "exact":
        return f".exact({n(s['target'])})"
    return f".closest(to: {n(s['target'])}, zeroDistance: {n(s['zeroAbove'])})"

blocks = []
for did in ids:
    d = data[did]
    qs = []
    for q in d["questions"]:
        if q["type"] == "number":
            qs.append(f"                number({lit(q['id'])}, {lit(q['text'])}, unit: {lit(q['unit'])}, scoring: {rule(q['scoring'])})")
        else:
            opts = ",\n".join(f"                                    ({lit(o['id'])}, {lit(o['text'])}, {o['point']})" for o in q["options"])
            qs.append(f"                choice({lit(q['id'])}, {lit(q['text'])}, options(\n{opts}\n                                ))")
    qs_text = ",\n".join(qs)
    blocks.append(f"""        Diagnosis(
            id: {lit(d['id'])},
            title: {lit(d['title'])},
            shortTitle: {lit(d['shortTitle'])},
            category: .{CAT[d['category']]},
            summary: {lit(d['summary'])},
            estimatedMinutes: {d['estimatedMinutes']},
            questions: [
{qs_text}
            ],
            bands: {BANDS.get(did, 'commonBands')}
        )""")

src = open(swift_path, encoding="utf-8").read()
anchor = "        )\n    ]\n\n    static func diagnosis(id: String)"
assert src.count(anchor) == 1, "anchor not found"
marker = f"        // MARK: - {version} 追加診断（docs/diagnosis_candidates.md で管理）\n"
assert marker not in src, "already inserted"
for did in ids:
    assert f'id: "{did}",' not in src, f"{did} is already in the catalog"
src = src.replace(anchor, "        ),\n" + marker + ",\n".join(blocks) + "\n    ]\n\n    static func diagnosis(id: String)")

new_ids = ", ".join(lit(i) for i in ids)
src, count = re.subn(r"static let newDiagnosisIDs: Set<String> = \[.*\]",
                     f"static let newDiagnosisIDs: Set<String> = [{new_ids}]", src)
assert count == 1, "newDiagnosisIDs not found"
open(swift_path, "w", encoding="utf-8").write(src)
print("inserted", len(ids), "diagnoses")
