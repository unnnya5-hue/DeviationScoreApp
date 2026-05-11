import Foundation

enum DiagnosisCatalog {
    static let diagnoses: [Diagnosis] = [
        marriage,
        iqLike,
        communication,
        jobChange,
        jobHunting,
        buzz,
        lineReply,
        moneySense,
        lifeSkill,
        mentalRecovery,
        dateSkill,
        friendship,
        fashion,
        cleanRoom,
        procrastination,
        oshiLife,
        travelPlan,
        cooking,
        karaoke,
        crisisAvoidance,
        blackHistory
    ]

    static func diagnosis(id: String) -> Diagnosis? {
        diagnoses.first { $0.id == id }
    }

    private static let commonBands = [
        ScoreBand(id: "starter", minScore: 20, title: "チュートリアル中", comment: "まだ操作確認の段階です。今日の結果は軽いネタとして楽しんで、次の一回で巻き返しましょう。"),
        ScoreBand(id: "standard", minScore: 45, title: "ふつうに強い", comment: "平均ラインをしっかり踏んでいます。目立ちすぎず、でも場面によってはちゃんと勝てるタイプです。"),
        ScoreBand(id: "high", minScore: 58, title: "上位プレイヤー", comment: "なかなか高めの結果です。得意分野として名乗っても、たぶん空気は壊れません。"),
        ScoreBand(id: "legend", minScore: 70, title: "ボス部屋前", comment: "かなり高めです。スクショして自慢したくなるラインまで来ています。")
    ]

    private static let tempoSet = options(
        ("早めに小さく動く", 4),
        ("一度寝かせてから動く", 2),
        ("相手や場の反応を見て動く", 3),
        ("最後にまとめて片づける", 1)
    )

    private static let distanceSet = options(
        ("近すぎない距離を保つ", 4),
        ("熱量があるうちに寄せる", 2),
        ("相手の出方に合わせる", 3),
        ("自分のペースを優先する", 1)
    )

    private static let repairSet = options(
        ("まず状況を整理する", 4),
        ("軽い一言で流れを戻す", 3),
        ("少し時間を置く", 2),
        ("別の話題で上書きする", 1)
    )

    private static let selectSet = options(
        ("候補を3つに絞る", 4),
        ("直感で早めに決める", 2),
        ("詳しい人に聞く", 3),
        ("その場のノリに任せる", 1)
    )

    private static let pressureSet = options(
        ("小分けにして進める", 4),
        ("締切が近いほど集中する", 2),
        ("誰かを巻き込む", 3),
        ("気分が乗るまで待つ", 1)
    )

    private static let moneyActionSet = options(
        ("先に枠だけ決める", 4),
        ("買ってから調整する", 1),
        ("一晩置いて考える", 3),
        ("安い方へ寄せる", 2)
    )

    private static let socialSet = options(
        ("相手の温度を拾う", 4),
        ("自分から空気を作る", 3),
        ("聞き役に回る", 2),
        ("流れが来るまで待つ", 1)
    )

    private static let styleChoiceSet = options(
        ("全体のまとまりを優先する", 4),
        ("目立つ一点を入れる", 3),
        ("無難さを優先する", 2),
        ("その日の気分で決める", 1)
    )

    private static let marriage = Diagnosis(
        id: "marriage",
        title: "婚活偏差値",
        shortTitle: "婚活",
        category: .romance,
        summary: "年齢、年収、生活力、距離感をまるごとネタ採点。",
        estimatedMinutes: 4,
        questions: [
            number("marriage-1", "あなたの年齢は？", unit: "歳", scoring: .range(min: 24, max: 39, zeroBelow: 18, zeroAbove: 58)),
            number("marriage-2", "現在の年収は？", unit: "万円", scoring: .higher(min: 180, max: 850)),
            number("marriage-3", "生活防御資金は何か月分くらいありますか？", unit: "か月", scoring: .range(min: 3, max: 12, zeroBelow: 0, zeroAbove: 36)),
            number("marriage-4", "気になる人への平均返信時間は？", unit: "時間", scoring: .range(min: 0.5, max: 18, zeroBelow: 0, zeroAbove: 96)),
            number("marriage-5", "月に自分磨きへ使う金額は？", unit: "千円", scoring: .range(min: 3, max: 35, zeroBelow: 0, zeroAbove: 120)),
            choice("marriage-6", "初回デートの店選びで近い動きは？", selectSet),
            choice("marriage-7", "相手の返信が半日ないときは？", distanceSet),
            choice("marriage-8", "価値観がズレた話題が出たら？", repairSet),
            choice("marriage-9", "予定変更が起きたときの第一手は？", tempoSet),
            choice("marriage-10", "家事分担の話が出たときは？", socialSet),
            choice("marriage-11", "金銭感覚の違いを感じたら？", moneyActionSet),
            choice("marriage-12", "自分の弱点を聞かれたら？", repairSet),
            choice("marriage-13", "相手の趣味が未知ジャンルだったら？", socialSet),
            choice("marriage-14", "会話が少し止まったときは？", distanceSet),
            choice("marriage-15", "小さなケンカのあとに近い動きは？", repairSet)
        ],
        bands: commonBands
    )

    private static let iqLike = Diagnosis(
        id: "iq-like",
        title: "IQ風クイズ偏差値",
        shortTitle: "IQ風",
        category: .knowledge,
        summary: "計算、規則性、推理っぽさをIQ風に遊ぶ診断。",
        estimatedMinutes: 4,
        questions: [
            number("iq-1", "17 + 28 × 2 = ?", unit: "", scoring: .exact(73)),
            number("iq-2", "144 ÷ 12 + 9 = ?", unit: "", scoring: .exact(21)),
            number("iq-3", "3, 6, 12, 24 の次は？", unit: "", scoring: .exact(48)),
            number("iq-4", "240の15%はいくつ？", unit: "", scoring: .exact(36)),
            number("iq-5", "5本で750円のペン。8本なら何円？", unit: "円", scoring: .exact(1200)),
            number("iq-6", "2, 5, 11, 23 の次は？", unit: "", scoring: .exact(47)),
            number("iq-7", "A=1, C=3, F=6。Jはいくつ？", unit: "", scoring: .exact(10)),
            choice("iq-8", "解けない問題に当たったときは？", pressureSet),
            choice("iq-9", "説明文が長いときの読み方は？", tempoSet),
            choice("iq-10", "選択肢が紛らわしいときは？", selectSet),
            choice("iq-11", "途中で計算が怪しくなったら？", repairSet),
            choice("iq-12", "新しいルールを覚えるときは？", tempoSet),
            choice("iq-13", "答えが直感とズレたときは？", repairSet),
            choice("iq-14", "時間が残り少ないときは？", pressureSet),
            choice("iq-15", "この診断の結果の扱い方は？", distanceSet)
        ],
        bands: commonBands
    )

    private static let communication = Diagnosis(
        id: "communication",
        title: "コミュ力偏差値",
        shortTitle: "コミュ力",
        category: .social,
        summary: "会話、空気感、SNS距離感、沈黙耐性をゲーム判定。",
        estimatedMinutes: 4,
        questions: [
            number("communication-1", "初対面の場で名前を覚えられる人数は？", unit: "人", scoring: .higher(min: 0, max: 7)),
            number("communication-2", "1分で出せる雑談テーマはいくつ？", unit: "個", scoring: .higher(min: 0, max: 8)),
            number("communication-3", "LINEやDMを平均どれくらい寝かせますか？", unit: "時間", scoring: .range(min: 0.5, max: 24, zeroBelow: 0, zeroAbove: 120)),
            number("communication-4", "会話中、自分が話す割合は何%くらい？", unit: "%", scoring: .closest(to: 50, zeroDistance: 45)),
            number("communication-5", "沈黙が続いても平気な秒数は？", unit: "秒", scoring: .range(min: 5, max: 40, zeroBelow: 0, zeroAbove: 180)),
            choice("communication-6", "知らない人が輪に入ったら？", socialSet),
            choice("communication-7", "場が少し重くなったら？", repairSet),
            choice("communication-8", "誘いを断る必要があるときは？", distanceSet),
            choice("communication-9", "相手の話が長くなったら？", socialSet),
            choice("communication-10", "SNSで初めて絡むときは？", distanceSet),
            choice("communication-11", "褒めるタイミングが来たら？", tempoSet),
            choice("communication-12", "自分ばかり話している気がしたら？", repairSet),
            choice("communication-13", "話題が尽きたら？", selectSet),
            choice("communication-14", "相手のテンションが読めないときは？", socialSet),
            choice("communication-15", "グループで意見が割れたら？", repairSet)
        ],
        bands: commonBands
    )

    private static let jobChange = Diagnosis(
        id: "job-change",
        title: "転職偏差値",
        shortTitle: "転職",
        category: .career,
        summary: "職務経歴、準備力、希望条件の現実味をゆるく測定。",
        estimatedMinutes: 4,
        questions: [
            number("job-change-1", "現在の職種経験は何年くらい？", unit: "年", scoring: .range(min: 2, max: 12, zeroBelow: 0, zeroAbove: 30)),
            number("job-change-2", "職務経歴書を最後に更新したのは何か月前？", unit: "か月前", scoring: .lower(min: 0, max: 24)),
            number("job-change-3", "希望年収アップ率は何%くらい？", unit: "%", scoring: .range(min: 5, max: 25, zeroBelow: 0, zeroAbove: 80)),
            number("job-change-4", "1か月で応募できそうな企業数は？", unit: "社", scoring: .range(min: 3, max: 20, zeroBelow: 0, zeroAbove: 60)),
            number("job-change-5", "週にスキル学習へ使える時間は？", unit: "時間", scoring: .higher(min: 0, max: 8)),
            choice("job-change-6", "実績を聞かれたときの出し方は？", selectSet),
            choice("job-change-7", "転職理由を聞かれたら？", repairSet),
            choice("job-change-8", "希望条件が全部は通らなそうなときは？", moneyActionSet),
            choice("job-change-9", "現職の不満が強い時期は？", distanceSet),
            choice("job-change-10", "面接前日の準備は？", pressureSet),
            choice("job-change-11", "業界研究の進め方は？", tempoSet),
            choice("job-change-12", "成果物を見せる場面では？", selectSet),
            choice("job-change-13", "退職交渉を考えるときは？", repairSet),
            choice("job-change-14", "年収以外の条件を見るときは？", moneyActionSet),
            choice("job-change-15", "内定が出た直後は？", distanceSet)
        ],
        bands: commonBands
    )

    private static let jobHunting = Diagnosis(
        id: "job-hunting",
        title: "就職偏差値",
        shortTitle: "就職",
        category: .jobHunt,
        summary: "自己PR、企業研究、面接準備、SPIっぽさを採点。",
        estimatedMinutes: 4,
        questions: [
            number("job-hunting-1", "企業研究した会社数は？", unit: "社", scoring: .higher(min: 0, max: 20)),
            number("job-hunting-2", "模擬面接をした回数は？", unit: "回", scoring: .higher(min: 0, max: 8)),
            number("job-hunting-3", "エントリーシートの下書き数は？", unit: "本", scoring: .higher(min: 0, max: 8)),
            number("job-hunting-4", "自己PRを話す長さは何秒くらい？", unit: "秒", scoring: .closest(to: 60, zeroDistance: 45)),
            number("job-hunting-5", "SPI風: 12 × 8 + 15 = ?", unit: "", scoring: .exact(111)),
            choice("job-hunting-6", "自己PRの組み立て方は？", selectSet),
            choice("job-hunting-7", "志望動機を書くときは？", tempoSet),
            choice("job-hunting-8", "逆質問を用意するときは？", socialSet),
            choice("job-hunting-9", "選考に落ちたあと最初にすることは？", repairSet),
            choice("job-hunting-10", "面接当日の朝は？", pressureSet),
            choice("job-hunting-11", "締切が重なったときは？", pressureSet),
            choice("job-hunting-12", "自己分析で詰まったら？", repairSet),
            choice("job-hunting-13", "ESを誰かに見せるときは？", socialSet),
            choice("job-hunting-14", "第一志望以外の扱いは？", distanceSet),
            choice("job-hunting-15", "緊張が強い面接では？", tempoSet)
        ],
        bands: commonBands
    )

    private static let buzz = Diagnosis(
        id: "buzz",
        title: "バズり偏差値",
        shortTitle: "バズり",
        category: .fun,
        summary: "SNS勘、投稿センス、ネタの初速をミニゲーム化。",
        estimatedMinutes: 4,
        questions: [
            number("buzz-1", "1週間に投稿する回数は？", unit: "回", scoring: .range(min: 1, max: 7, zeroBelow: 0, zeroAbove: 30)),
            number("buzz-2", "最近の投稿のいいね中央値は？", unit: "件", scoring: .higher(min: 0, max: 500)),
            number("buzz-3", "投稿文の平均文字数は？", unit: "文字", scoring: .closest(to: 80, zeroDistance: 120)),
            number("buzz-4", "3分で出せる投稿ネタはいくつ？", unit: "個", scoring: .higher(min: 0, max: 10)),
            number("buzz-5", "1日のSNS時間は？", unit: "時間", scoring: .range(min: 0.5, max: 3, zeroBelow: 0, zeroAbove: 10)),
            choice("buzz-6", "投稿の一文目を決めるときは？", selectSet),
            choice("buzz-7", "ネタを見つけた直後は？", tempoSet),
            choice("buzz-8", "画像の見せ方を迷ったら？", styleChoiceSet),
            choice("buzz-9", "流行ネタに乗るときは？", distanceSet),
            choice("buzz-10", "コメントが伸びてきたら？", socialSet),
            choice("buzz-11", "投稿前に少し不安があるときは？", repairSet),
            choice("buzz-12", "自虐ネタを出すときは？", distanceSet),
            choice("buzz-13", "短い動画の見せ場は？", selectSet),
            choice("buzz-14", "伸びなかった投稿は？", repairSet),
            choice("buzz-15", "バズった翌日は？", distanceSet)
        ],
        bands: commonBands
    )

    private static let lineReply = makeDiagnosis(
        id: "line-reply",
        title: "LINE返信偏差値",
        shortTitle: "返信",
        category: .social,
        summary: "返信速度、既読耐性、文量、スタンプ距離感を測定。",
        numbers: [
            number("line-reply-1", "平均返信時間は？", unit: "時間", scoring: .range(min: 0.2, max: 12, zeroBelow: 0, zeroAbove: 96)),
            number("line-reply-2", "未返信のまま残る件数は？", unit: "件", scoring: .lower(min: 0, max: 12)),
            number("line-reply-3", "1返信の平均文字数は？", unit: "文字", scoring: .closest(to: 45, zeroDistance: 80)),
            number("line-reply-4", "スタンプだけで返す割合は？", unit: "%", scoring: .range(min: 5, max: 35, zeroBelow: 0, zeroAbove: 90)),
            number("line-reply-5", "既読後に考える平均時間は？", unit: "分", scoring: .range(min: 2, max: 120, zeroBelow: 0, zeroAbove: 720))
        ],
        choices: [
            ("相手の温度が低そうなときは？", distanceSet),
            ("話題が終わりかけたら？", repairSet),
            ("長文が来たときは？", socialSet),
            ("深夜に通知に気づいたら？", tempoSet),
            ("返しづらい相談が来たら？", repairSet),
            ("誘いへの返答を迷うときは？", selectSet),
            ("グループLINEが荒れたら？", distanceSet),
            ("既読をつけたあと忘れていたら？", repairSet),
            ("絵文字を入れるか迷ったら？", styleChoiceSet),
            ("返事がそっけなかったと言われたら？", repairSet)
        ]
    )

    private static let moneySense = makeDiagnosis(
        id: "money-sense",
        title: "金銭感覚偏差値",
        shortTitle: "お金",
        category: .money,
        summary: "貯金、自由費、衝動買い、サブスクの扱いを判定。",
        numbers: [
            number("money-sense-1", "毎月の貯金率は？", unit: "%", scoring: .range(min: 10, max: 35, zeroBelow: 0, zeroAbove: 80)),
            number("money-sense-2", "使っているサブスク数は？", unit: "個", scoring: .range(min: 1, max: 6, zeroBelow: 0, zeroAbove: 20)),
            number("money-sense-3", "月の自由費は手取りの何%？", unit: "%", scoring: .range(min: 10, max: 35, zeroBelow: 0, zeroAbove: 90)),
            number("money-sense-4", "月の衝動買い回数は？", unit: "回", scoring: .lower(min: 0, max: 10)),
            number("money-sense-5", "財布やアプリの残高確認頻度は？", unit: "回/週", scoring: .range(min: 1, max: 7, zeroBelow: 0, zeroAbove: 30))
        ],
        choices: [
            ("欲しい物を見つけた直後は？", moneyActionSet),
            ("友人との会計で迷ったら？", socialSet),
            ("セール通知が来たら？", distanceSet),
            ("旅行の予算を組むときは？", selectSet),
            ("給料日の夜は？", moneyActionSet),
            ("大きな買い物の前は？", tempoSet),
            ("割り勘が少しズレたら？", repairSet),
            ("ポイント還元を見たら？", selectSet),
            ("節約が続かないときは？", repairSet),
            ("急な誘いが来たら？", moneyActionSet)
        ]
    )

    private static let lifeSkill = makeDiagnosis(
        id: "life-skill",
        title: "生活力偏差値",
        shortTitle: "生活力",
        category: .life,
        summary: "自炊、掃除、洗濯、睡眠、家計の地力を測定。",
        numbers: [
            number("life-skill-1", "週の自炊回数は？", unit: "回", scoring: .range(min: 2, max: 8, zeroBelow: 0, zeroAbove: 21)),
            number("life-skill-2", "洗濯物を畳まず置く平均日数は？", unit: "日", scoring: .lower(min: 0, max: 7)),
            number("life-skill-3", "平均睡眠時間は？", unit: "時間", scoring: .range(min: 6.5, max: 8.5, zeroBelow: 3, zeroAbove: 12)),
            number("life-skill-4", "冷蔵庫の中身を把握している割合は？", unit: "%", scoring: .higher(min: 0, max: 90)),
            number("life-skill-5", "月の公共料金チェック回数は？", unit: "回", scoring: .range(min: 1, max: 4, zeroBelow: 0, zeroAbove: 12))
        ],
        choices: [
            ("帰宅後に疲れている日は？", tempoSet),
            ("食材が少し余ったら？", selectSet),
            ("掃除のタイミングは？", pressureSet),
            ("朝の準備が詰まったら？", repairSet),
            ("日用品が切れそうなときは？", tempoSet),
            ("予定が多い週の家事は？", pressureSet),
            ("体調が怪しい朝は？", distanceSet),
            ("部屋に人が来る予定が入ったら？", repairSet),
            ("外食が続いたら？", moneyActionSet),
            ("寝る前にスマホが止まらないときは？", distanceSet)
        ]
    )

    private static let mentalRecovery = makeDiagnosis(
        id: "mental-recovery",
        title: "メンタル回復偏差値",
        shortTitle: "回復",
        category: .mental,
        summary: "落ち込みからの復帰、相談、休み方のうまさを測定。",
        numbers: [
            number("mental-recovery-1", "落ち込んだ日の平均回復時間は？", unit: "時間", scoring: .range(min: 2, max: 36, zeroBelow: 0, zeroAbove: 168)),
            number("mental-recovery-2", "相談できる相手は何人？", unit: "人", scoring: .range(min: 1, max: 5, zeroBelow: 0, zeroAbove: 20)),
            number("mental-recovery-3", "週に何回、意識的に休みますか？", unit: "回", scoring: .range(min: 2, max: 7, zeroBelow: 0, zeroAbove: 20)),
            number("mental-recovery-4", "寝る前に悩みを考える時間は？", unit: "分", scoring: .lower(min: 0, max: 90)),
            number("mental-recovery-5", "気分転換の持ちネタ数は？", unit: "個", scoring: .higher(min: 0, max: 8))
        ],
        choices: [
            ("小さく失敗した直後は？", repairSet),
            ("誰かに刺さる言葉を言われたら？", distanceSet),
            ("予定を詰めすぎたと気づいたら？", pressureSet),
            ("眠れない夜は？", repairSet),
            ("SNSで比べてしまったら？", distanceSet),
            ("不安が言語化できないときは？", selectSet),
            ("休む罪悪感があるときは？", moneyActionSet),
            ("朝から重い日は？", tempoSet),
            ("やることが多すぎるときは？", pressureSet),
            ("気持ちが戻りかけたら？", distanceSet)
        ]
    )

    private static let dateSkill = makeDiagnosis(
        id: "date-skill",
        title: "デート偏差値",
        shortTitle: "デート",
        category: .romance,
        summary: "店選び、会話、時間管理、気遣いをゲーム判定。",
        numbers: [
            number("date-skill-1", "待ち合わせ何分前に着くことが多い？", unit: "分前", scoring: .range(min: 3, max: 15, zeroBelow: -20, zeroAbove: 90)),
            number("date-skill-2", "候補のお店を何個出しますか？", unit: "個", scoring: .range(min: 2, max: 5, zeroBelow: 0, zeroAbove: 15)),
            number("date-skill-3", "初回デートの予算は？", unit: "千円", scoring: .range(min: 3, max: 12, zeroBelow: 0, zeroAbove: 40)),
            number("date-skill-4", "移動時間の余白は？", unit: "分", scoring: .range(min: 10, max: 35, zeroBelow: 0, zeroAbove: 120)),
            number("date-skill-5", "会話ネタを事前に考える数は？", unit: "個", scoring: .range(min: 1, max: 5, zeroBelow: 0, zeroAbove: 20))
        ],
        choices: [
            ("相手の好みが曖昧なときは？", selectSet),
            ("沈黙が来たら？", socialSet),
            ("雨予報に変わったら？", repairSet),
            ("会計の空気になったら？", moneyActionSet),
            ("次の予定を聞くタイミングは？", distanceSet),
            ("店が混んでいたら？", repairSet),
            ("相手が疲れていそうなら？", socialSet),
            ("写真を撮るか迷ったら？", distanceSet),
            ("会話が盛り上がりすぎたら？", tempoSet),
            ("帰り際の一言は？", socialSet)
        ]
    )

    private static let friendship = makeDiagnosis(
        id: "friendship",
        title: "友達力偏差値",
        shortTitle: "友達力",
        category: .social,
        summary: "誘い方、聞き上手、距離感、記憶力を測定。",
        numbers: [
            number("friendship-1", "最近1か月で自分から誘った回数は？", unit: "回", scoring: .range(min: 1, max: 8, zeroBelow: 0, zeroAbove: 30)),
            number("friendship-2", "誕生日を覚えている友人数は？", unit: "人", scoring: .higher(min: 0, max: 12)),
            number("friendship-3", "返信を寝かせる平均時間は？", unit: "時間", scoring: .range(min: 0.5, max: 24, zeroBelow: 0, zeroAbove: 120)),
            number("friendship-4", "相談を聞く平均時間は？", unit: "分", scoring: .range(min: 10, max: 90, zeroBelow: 0, zeroAbove: 240)),
            number("friendship-5", "予定調整で出す候補日は？", unit: "日", scoring: .range(min: 2, max: 5, zeroBelow: 0, zeroAbove: 14))
        ],
        choices: [
            ("友達が落ち込んでいそうなときは？", socialSet),
            ("誘いが断られたら？", distanceSet),
            ("グループ内で温度差があるときは？", repairSet),
            ("久しぶりに連絡するときは？", tempoSet),
            ("相談が重めになったら？", distanceSet),
            ("相手の好きなものを見つけたら？", socialSet),
            ("予定が合わない日が続いたら？", repairSet),
            ("冗談が少し滑ったら？", repairSet),
            ("友達の成功報告を聞いたら？", socialSet),
            ("距離が近くなりすぎたと感じたら？", distanceSet)
        ]
    )

    private static let fashion = makeDiagnosis(
        id: "fashion",
        title: "ファッション偏差値",
        shortTitle: "服装",
        category: .style,
        summary: "TPO、清潔感、色合わせ、服への課金感を採点。",
        numbers: [
            number("fashion-1", "月に服へ使う金額は？", unit: "千円", scoring: .range(min: 3, max: 40, zeroBelow: 0, zeroAbove: 150)),
            number("fashion-2", "よく使う色は何色くらい？", unit: "色", scoring: .range(min: 3, max: 7, zeroBelow: 1, zeroAbove: 20)),
            number("fashion-3", "靴を手入れする頻度は？", unit: "回/月", scoring: .range(min: 1, max: 6, zeroBelow: 0, zeroAbove: 20)),
            number("fashion-4", "出かける前に鏡を見る回数は？", unit: "回", scoring: .range(min: 1, max: 4, zeroBelow: 0, zeroAbove: 12)),
            number("fashion-5", "ワードローブの稼働率は？", unit: "%", scoring: .range(min: 45, max: 85, zeroBelow: 0, zeroAbove: 100))
        ],
        choices: [
            ("服を選ぶ最初の基準は？", styleChoiceSet),
            ("初めての場所へ行く日は？", selectSet),
            ("流行アイテムを見つけたら？", distanceSet),
            ("色合わせで迷ったら？", styleChoiceSet),
            ("寝坊した朝の服は？", pressureSet),
            ("褒められた服があるときは？", tempoSet),
            ("買うか迷う服があるときは？", moneyActionSet),
            ("写真を撮る予定の日は？", styleChoiceSet),
            ("雨の日の靴選びは？", repairSet),
            ("似合うと言われた系統は？", selectSet)
        ]
    )

    private static let cleanRoom = makeDiagnosis(
        id: "clean-room",
        title: "部屋きれい偏差値",
        shortTitle: "部屋",
        category: .life,
        summary: "床の可視率、掃除頻度、放置物の勢力図を測定。",
        numbers: [
            number("clean-room-1", "床が見えている割合は？", unit: "%", scoring: .higher(min: 20, max: 95)),
            number("clean-room-2", "掃除機をかける頻度は？", unit: "回/週", scoring: .range(min: 1, max: 4, zeroBelow: 0, zeroAbove: 14)),
            number("clean-room-3", "洗濯物の放置日数は？", unit: "日", scoring: .lower(min: 0, max: 7)),
            number("clean-room-4", "机の上の未処理アイテム数は？", unit: "個", scoring: .lower(min: 0, max: 20)),
            number("clean-room-5", "急な来客に必要な片付け時間は？", unit: "分", scoring: .lower(min: 0, max: 120))
        ],
        choices: [
            ("物の定位置を決めるときは？", selectSet),
            ("片付ける気力がない日は？", pressureSet),
            ("郵便物が溜まったら？", repairSet),
            ("服の収納があふれたら？", moneyActionSet),
            ("掃除道具を買うときは？", selectSet),
            ("水回りが気になったら？", tempoSet),
            ("捨てるか迷う物は？", distanceSet),
            ("模様替えしたくなったら？", styleChoiceSet),
            ("忙しい週の掃除は？", pressureSet),
            ("片付け終わった直後は？", tempoSet)
        ]
    )

    private static let procrastination = Diagnosis(
        id: "procrastination",
        title: "先延ばし偏差値",
        shortTitle: "先延ばし",
        category: .fun,
        summary: "締切、未返信、積みタスクとの付き合い方を測定。",
        estimatedMinutes: 4,
        questions: [
            number("procrastination-1", "締切の何日前に動き始める？", unit: "日前", scoring: .range(min: 2, max: 10, zeroBelow: 0, zeroAbove: 60)),
            number("procrastination-2", "今ある未返信件数は？", unit: "件", scoring: .lower(min: 0, max: 18)),
            number("procrastination-3", "積みタスク数は？", unit: "個", scoring: .lower(min: 0, max: 25)),
            number("procrastination-4", "作業開始までの準備時間は？", unit: "分", scoring: .range(min: 3, max: 25, zeroBelow: 0, zeroAbove: 180)),
            number("procrastination-5", "リマインダーを入れているタスク数は？", unit: "個", scoring: .range(min: 1, max: 10, zeroBelow: 0, zeroAbove: 50)),
            choice("procrastination-6", "やる気が薄い作業の始め方は？", pressureSet),
            choice("procrastination-7", "締切が遠いときは？", tempoSet),
            choice("procrastination-8", "通知が多い日は？", repairSet),
            choice("procrastination-9", "タスクが重く見えるときは？", selectSet),
            choice("procrastination-10", "途中で飽きたら？", distanceSet),
            choice("procrastination-11", "誰かに進捗を聞かれたら？", repairSet),
            choice("procrastination-12", "予定より遅れたら？", pressureSet),
            choice("procrastination-13", "完璧にできなさそうなら？", distanceSet),
            choice("procrastination-14", "作業環境が散らかっていたら？", repairSet),
            choice("procrastination-15", "終わった直後は？", tempoSet)
        ],
        bands: commonBands
    )

    private static let oshiLife = makeDiagnosis(
        id: "oshi-life",
        title: "推し活偏差値",
        shortTitle: "推し活",
        category: .hobby,
        summary: "課金、現場、布教、グッズ管理の熱量を測定。",
        numbers: [
            number("oshi-life-1", "月の推し活予算は？", unit: "千円", scoring: .range(min: 3, max: 50, zeroBelow: 0, zeroAbove: 250)),
            number("oshi-life-2", "年の現場回数は？", unit: "回", scoring: .range(min: 1, max: 15, zeroBelow: 0, zeroAbove: 80)),
            number("oshi-life-3", "未整理グッズ数は？", unit: "個", scoring: .lower(min: 0, max: 80)),
            number("oshi-life-4", "布教できる推しポイント数は？", unit: "個", scoring: .higher(min: 0, max: 10)),
            number("oshi-life-5", "情報チェック頻度は？", unit: "回/日", scoring: .range(min: 1, max: 8, zeroBelow: 0, zeroAbove: 40))
        ],
        choices: [
            ("新グッズ発表直後は？", moneyActionSet),
            ("友達に布教するときは？", socialSet),
            ("チケットが外れたら？", repairSet),
            ("現場前日の準備は？", pressureSet),
            ("推しの炎上っぽい話題を見たら？", distanceSet),
            ("同担と話すときは？", socialSet),
            ("グッズ収納を考えるときは？", selectSet),
            ("供給が多すぎる週は？", pressureSet),
            ("推し変の気配を感じたら？", distanceSet),
            ("ライブ後の余韻は？", tempoSet)
        ]
    )

    private static let travelPlan = makeDiagnosis(
        id: "travel-plan",
        title: "旅行計画偏差値",
        shortTitle: "旅行",
        category: .life,
        summary: "予約力、予算、荷造り、トラブル対応を測定。",
        numbers: [
            number("travel-plan-1", "出発の何日前に宿を取る？", unit: "日前", scoring: .range(min: 7, max: 90, zeroBelow: 0, zeroAbove: 365)),
            number("travel-plan-2", "荷造り開始は出発何時間前？", unit: "時間前", scoring: .range(min: 6, max: 48, zeroBelow: 0, zeroAbove: 240)),
            number("travel-plan-3", "予算の余白は何%取る？", unit: "%", scoring: .range(min: 10, max: 35, zeroBelow: 0, zeroAbove: 100)),
            number("travel-plan-4", "行きたい候補地はいくつ出す？", unit: "個", scoring: .range(min: 3, max: 10, zeroBelow: 0, zeroAbove: 40)),
            number("travel-plan-5", "乗換の余白は何分？", unit: "分", scoring: .range(min: 10, max: 40, zeroBelow: 0, zeroAbove: 180))
        ],
        choices: [
            ("旅先で予定が崩れたら？", repairSet),
            ("同行者と行きたい場所が違ったら？", socialSet),
            ("予約サイトを見る順番は？", selectSet),
            ("荷物が増えすぎたら？", moneyActionSet),
            ("雨予報になったら？", repairSet),
            ("食事場所を決めるときは？", selectSet),
            ("移動中に疲れたら？", distanceSet),
            ("お土産を選ぶときは？", socialSet),
            ("現地で迷ったら？", tempoSet),
            ("帰宅後の写真整理は？", pressureSet)
        ]
    )

    private static let cooking = makeDiagnosis(
        id: "cooking",
        title: "料理偏差値",
        shortTitle: "料理",
        category: .life,
        summary: "自炊頻度、作れる品数、冷蔵庫管理、味付け感覚を測定。",
        numbers: [
            number("cooking-1", "週の自炊回数は？", unit: "回", scoring: .range(min: 2, max: 9, zeroBelow: 0, zeroAbove: 21)),
            number("cooking-2", "レシピなしで作れる品数は？", unit: "品", scoring: .higher(min: 0, max: 12)),
            number("cooking-3", "使い切れず捨てる食材は月に何個？", unit: "個", scoring: .lower(min: 0, max: 12)),
            number("cooking-4", "常備している調味料数は？", unit: "個", scoring: .range(min: 5, max: 16, zeroBelow: 0, zeroAbove: 50)),
            number("cooking-5", "料理にかける平均時間は？", unit: "分", scoring: .range(min: 15, max: 60, zeroBelow: 0, zeroAbove: 180))
        ],
        choices: [
            ("冷蔵庫に半端な食材があるときは？", selectSet),
            ("味が薄かったら？", repairSet),
            ("レシピにない材料が必要なら？", distanceSet),
            ("疲れている日の夕食は？", moneyActionSet),
            ("人に食べてもらう日は？", pressureSet),
            ("買い出し前の動きは？", tempoSet),
            ("作りすぎたら？", repairSet),
            ("新しい料理を試すときは？", selectSet),
            ("洗い物が増えたら？", pressureSet),
            ("盛り付けで迷ったら？", styleChoiceSet)
        ]
    )

    private static let karaoke = makeDiagnosis(
        id: "karaoke",
        title: "カラオケ偏差値",
        shortTitle: "カラオケ",
        category: .hobby,
        summary: "レパートリー、選曲空気読み、盛り上げ力を測定。",
        numbers: [
            number("karaoke-1", "歌える曲数は？", unit: "曲", scoring: .higher(min: 0, max: 60)),
            number("karaoke-2", "キー調整できる曲数は？", unit: "曲", scoring: .higher(min: 0, max: 20)),
            number("karaoke-3", "十八番の平均点は？", unit: "点", scoring: .range(min: 82, max: 96, zeroBelow: 40, zeroAbove: 100)),
            number("karaoke-4", "場を見て選べる曲ジャンル数は？", unit: "種", scoring: .range(min: 3, max: 8, zeroBelow: 0, zeroAbove: 20)),
            number("karaoke-5", "マイクを持つまでの平均待ち曲数は？", unit: "曲", scoring: .range(min: 1, max: 4, zeroBelow: 0, zeroAbove: 12))
        ],
        choices: [
            ("一曲目を任されたら？", selectSet),
            ("知らない曲が続いたら？", socialSet),
            ("盛り上がりが落ちたら？", repairSet),
            ("誰かがバラードを入れたら？", distanceSet),
            ("デュエットに誘われたら？", socialSet),
            ("高音がきつい曲を入れたら？", repairSet),
            ("採点モードの空気になったら？", distanceSet),
            ("順番がなかなか来ないときは？", tempoSet),
            ("最後の一曲を選ぶなら？", selectSet),
            ("歌い終わった人への反応は？", socialSet)
        ]
    )

    private static let crisisAvoidance = makeDiagnosis(
        id: "crisis-avoidance",
        title: "危機回避偏差値",
        shortTitle: "危機回避",
        category: .fun,
        summary: "忘れ物、寝坊、財布紛失、予定管理の守備力を測定。",
        numbers: [
            number("crisis-avoidance-1", "月の忘れ物回数は？", unit: "回", scoring: .lower(min: 0, max: 10)),
            number("crisis-avoidance-2", "アラーム設定数は？", unit: "個", scoring: .range(min: 2, max: 6, zeroBelow: 0, zeroAbove: 20)),
            number("crisis-avoidance-3", "財布や鍵を探す時間は週に何分？", unit: "分", scoring: .lower(min: 0, max: 90)),
            number("crisis-avoidance-4", "予定前の移動余白は？", unit: "分", scoring: .range(min: 10, max: 35, zeroBelow: -20, zeroAbove: 180)),
            number("crisis-avoidance-5", "予備の充電手段はいくつ？", unit: "個", scoring: .range(min: 1, max: 4, zeroBelow: 0, zeroAbove: 12))
        ],
        choices: [
            ("出発前に違和感があったら？", repairSet),
            ("寝坊しかけた朝は？", pressureSet),
            ("電車が遅れたら？", repairSet),
            ("財布が見当たらないときは？", selectSet),
            ("スマホ残量が少ない外出中は？", distanceSet),
            ("忘れ物に途中で気づいたら？", repairSet),
            ("予定が重なっていたら？", pressureSet),
            ("雨具を迷う天気なら？", tempoSet),
            ("知らない場所へ行くときは？", selectSet),
            ("トラブル後の共有は？", socialSet)
        ]
    )

    private static let blackHistory = makeDiagnosis(
        id: "black-history",
        title: "黒歴史耐性偏差値",
        shortTitle: "黒歴史",
        category: .fun,
        summary: "過去投稿、失言リカバリー、自虐の扱いを測定。",
        numbers: [
            number("black-history-1", "消したい過去投稿はいくつ？", unit: "件", scoring: .range(min: 0, max: 20, zeroBelow: 0, zeroAbove: 300)),
            number("black-history-2", "過去の失言を思い出す頻度は？", unit: "回/週", scoring: .lower(min: 0, max: 20)),
            number("black-history-3", "笑い話にできる過去ネタ数は？", unit: "個", scoring: .range(min: 1, max: 8, zeroBelow: 0, zeroAbove: 40)),
            number("black-history-4", "SNSの過去ログ確認頻度は？", unit: "回/月", scoring: .range(min: 0, max: 3, zeroBelow: 0, zeroAbove: 30)),
            number("black-history-5", "気まずさの回復にかかる時間は？", unit: "時間", scoring: .range(min: 1, max: 48, zeroBelow: 0, zeroAbove: 240))
        ],
        choices: [
            ("昔の投稿を見つけたら？", repairSet),
            ("軽くいじられたら？", socialSet),
            ("思い出して眠れない夜は？", distanceSet),
            ("自虐ネタを使うなら？", selectSet),
            ("同じ失敗をしそうな場面では？", repairSet),
            ("誰かの黒歴史を見たら？", socialSet),
            ("消すか残すか迷う投稿は？", distanceSet),
            ("気まずい相手と再会したら？", repairSet),
            ("過去の自分を評価するなら？", distanceSet),
            ("笑い話に変えるタイミングは？", tempoSet)
        ]
    )

    private static func makeDiagnosis(
        id: String,
        title: String,
        shortTitle: String,
        category: DiagnosisCategory,
        summary: String,
        estimatedMinutes: Int = 4,
        numbers: [DiagnosisQuestion],
        choices: [(String, [AnswerOption])]
    ) -> Diagnosis {
        let choiceQuestions = choices.enumerated().map { index, item in
            choice("\(id)-\(index + numbers.count + 1)", item.0, item.1)
        }

        return Diagnosis(
            id: id,
            title: title,
            shortTitle: shortTitle,
            category: category,
            summary: summary,
            estimatedMinutes: estimatedMinutes,
            questions: numbers + choiceQuestions,
            bands: commonBands
        )
    }

    private static func choice(_ id: String, _ text: String, _ options: [AnswerOption]) -> DiagnosisQuestion {
        DiagnosisQuestion(id: id, text: text, input: .choice(options))
    }

    private static func number(
        _ id: String,
        _ text: String,
        unit: String,
        scoring: NumericScoringRule
    ) -> DiagnosisQuestion {
        DiagnosisQuestion(
            id: id,
            text: text,
            input: .number(
                NumericQuestionConfig(
                    placeholder: "",
                    unit: unit,
                    helperText: "",
                    scoring: scoring
                )
            )
        )
    }

    private static func options(_ choices: (String, Int)...) -> [AnswerOption] {
        let ids = ["a", "b", "c", "d"]

        return choices.enumerated().map { index, choice in
            AnswerOption(id: ids[index], text: choice.0, point: choice.1)
        }
    }
}
