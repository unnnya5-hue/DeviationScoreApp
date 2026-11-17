import glob, json, os, random, sys


"""tools/diagnosis/source/*.txt から追加診断のレビュー用MDと取り込み用JSONを生成する。

使い方: python3 tools/diagnosis/gen_review.py
"""
HERE = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.join(HERE, "source")
docs_dir = os.path.join(HERE, "..", "..", "docs")
# releases/vX.Y.txt に書かれたIDを「収録済み」として扱う
added = {}
for rel in sorted(glob.glob(os.path.join(HERE, "releases", "*.txt"))):
    for did in open(rel).read().split():
        added[did] = os.path.basename(rel)[:-4]
existing = {d["id"] for d in json.load(open(os.path.join(docs_dir, "diagnosis_questions_editable.json")))}

def num(s):
    v = float(s)
    return int(v) if v.is_integer() else v

def scoring(mode, a):
    base = dict(maxPoint=4, idealMin=None, idealMax=None, target=None, zeroBelow=None, zeroAbove=None)
    if mode == "range":
        base.update(mode="range", idealMin=a[0], idealMax=a[1], zeroBelow=a[2], zeroAbove=a[3])
    elif mode == "higher":
        base.update(mode="higherIsBetter", idealMin=a[0], idealMax=a[1], zeroBelow=a[0], zeroAbove=a[1])
    elif mode == "lower":
        base.update(mode="lowerIsBetter", idealMin=a[0], idealMax=a[1], zeroBelow=a[0], zeroAbove=a[1])
    elif mode == "exact":
        base.update(mode="exact", target=a[0])
    elif mode == "closest":
        base.update(mode="closest", target=a[0], zeroAbove=a[1])
    else:
        raise ValueError(mode)
    return {"mode": base.pop("mode"), **base}

def describe(s):
    m = s["mode"]
    if m == "range":
        return f"範囲型: {s['idealMin']}〜{s['idealMax']}で4点 / {s['zeroBelow']}以下と{s['zeroAbove']}以上が0点目安"
    if m == "higherIsBetter":
        return f"高いほど加点: {s['idealMin']}→0点, {s['idealMax']}以上→4点"
    if m == "lowerIsBetter":
        return f"低いほど加点: {s['idealMin']}以下→4点, {s['idealMax']}以上→0点"
    if m == "exact":
        return f"正解型: {s['target']}で4点 / ±1で減点 / ±3超で0点"
    return f"近いほど加点: 正解{s['target']} / ±{s['zeroAbove']}以上で0点"

diags = []
for path in sorted(glob.glob(os.path.join(src_dir, "*.txt"))):
    cur = None
    for line in open(path, encoding="utf-8"):
        line = line.rstrip("\n")
        if not line.strip():
            continue
        p = line.split("|")
        if line.startswith("# "):
            did, title, short, cat, summary = [x.strip() for x in line[2:].split("|")]
            cur = dict(id=did, title=title, shortTitle=short, category=cat, summary=summary, estimatedMinutes=5, questions=[])
            diags.append(cur)
            continue
        qid = f"{cur['id']}-{len(cur['questions']) + 1}"
        if p[0] == "N":
            text, unit, mode, args = p[1], p[2], p[3], [num(x) for x in p[4:]]
            cur["questions"].append(dict(id=qid, text=text, type="number", unit=unit, scoring=scoring(mode, args), options=None))
        elif p[0] in ("C", "Q"):
            text, opts = p[1], p[2:]
            assert len(opts) == 4, (qid, opts)
            pts = [4, 3, 2, 1] if p[0] == "C" else [4, 1, 1, 1]
            pairs = list(zip(opts, pts))
            random.Random(qid).shuffle(pairs)
            cur["questions"].append(dict(
                id=qid, text=text, type="choice", unit=None, scoring=None, quiz=(p[0] == "Q"),
                options=[dict(id="abcd"[i], text=t, point=pt) for i, (t, pt) in enumerate(pairs)]))
        else:
            raise ValueError(line)

errors = []
ids = [d["id"] for d in diags]
if len(ids) != len(set(ids)):
    errors.append("duplicate ids")
for d in diags:
    qs = d["questions"]
    n = sum(q["type"] == "number" for q in qs)
    if d["id"] in existing:
        errors.append(f"{d['id']}: collides with existing")
    if len(qs) != 16 or n != 5:
        errors.append(f"{d['id']}: {len(qs)} questions / {n} number")
if errors:
    sys.exit("\n".join(errors))

# JSON (same schema as diagnosis_questions_editable.json; drop helper flag)
out = [dict(d, questions=[{k: v for k, v in q.items() if k != "quiz"} for q in d["questions"]]) for d in diags]
with open(os.path.join(docs_dir, "new_diagnosis_questions_editable.json"), "w", encoding="utf-8") as f:
    json.dump(out, f, ensure_ascii=False, indent=2)
    f.write("\n")

# Review markdown
cats = {}
for d in diags:
    cats.setdefault(d["category"], []).append(d["title"])
L = ["# 追加診断 質問レビュー一覧", "",
     "診断の追加状況は `docs/diagnosis_candidates.md` で管理しています。", "",
     "追加候補の診断の問題案です。再インポート用の元データは `docs/new_diagnosis_questions_editable.json` です（既存の `diagnosis_questions_editable.json` と同じ形式）。", "",
     "## 編集時の注意", "",
     "- 構成は既存診断と同じく、1診断16問（数字入力5問＋選択式11問）です。",
     "- 選択肢の `point` は 1〜4 です。正解のあるクイズは正解が4点、不正解が1点です（表では ✅ 印）。",
     "- 選択肢の並び順は、正解の位置が偏らないようにシャッフル済みです。",
     "- 偏差値は高いほど「上手」「強い」側です（例: スマホ依存偏差値は高いほどスマホと上手に付き合えている）。",
     "- メンタル・健康系の診断には、アプリ上で「医学的な診断ではありません」という注記を入れる想定です。", "",
     f"対象診断数: {len(diags)} / 総問題数: {sum(len(d['questions']) for d in diags)}", "",
     "## カテゴリ別一覧", "", "| カテゴリ | 診断 |", "|---|---|"]
for c, ts in cats.items():
    L.append(f"| {c} | {'、'.join(ts)} |")
L.append("")
for i, d in enumerate(diags, 1):
    L += ["", f"## {i}. {d['title']}{' ✅' if d['id'] in added else ''}", "", f"- ID: `{d['id']}`", f"- カテゴリ: {d['category']}", f"- 概要: {d['summary']}", f"- 状態: {('✅ アプリ収録済み（' + added[d['id']] + '）') if d['id'] in added else '📝 問題案のみ（未収録）'}", "",
          "| No | 種別 | 質問ID | 質問文 | 単位 | 採点/選択肢 |", "|---:|---|---|---|---|---|"]
    for j, q in enumerate(d["questions"], 1):
        if q["type"] == "number":
            kind, body = "数字", describe(q["scoring"])
        else:
            kind = "クイズ" if q["quiz"] else "選択"
            body = "<br>".join(
                f"{o['id']}: {o['text']} ({o['point']}点){' ✅' if q['quiz'] and o['point'] == 4 else ''}" for o in q["options"])
        L.append(f"| {j} | {kind} | `{q['id']}` | {q['text']} | {q['unit'] or ''} | {body} |")
with open(os.path.join(docs_dir, "new_diagnosis_questions_review.md"), "w", encoding="utf-8") as f:
    f.write("\n".join(L) + "\n")

print(len(diags), "diagnoses,", sum(len(d["questions"]) for d in diags), "questions")
for c, ts in cats.items():
    print(c, len(ts))
