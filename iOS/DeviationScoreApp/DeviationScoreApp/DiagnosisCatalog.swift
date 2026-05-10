import Foundation

enum DiagnosisCatalog {
    static let diagnoses: [Diagnosis] = [
        marriage,
        iqLike,
        communication,
        jobChange,
        jobHunting,
        buzz
    ]

    static func diagnosis(id: String) -> Diagnosis? {
        diagnoses.first { $0.id == id }
    }

    private static let agreeSet = [
        AnswerOption(id: "a", text: "かなり当てはまる", point: 4),
        AnswerOption(id: "b", text: "まあ当てはまる", point: 3),
        AnswerOption(id: "c", text: "少しだけ当てはまる", point: 2),
        AnswerOption(id: "d", text: "あまり当てはまらない", point: 0)
    ]

    private static let confidenceSet = [
        AnswerOption(id: "a", text: "余裕でいける", point: 4),
        AnswerOption(id: "b", text: "たぶんいける", point: 3),
        AnswerOption(id: "c", text: "準備すればいける", point: 2),
        AnswerOption(id: "d", text: "かなり怪しい", point: 0)
    ]

    private static let frequencySet = [
        AnswerOption(id: "a", text: "いつもできている", point: 4),
        AnswerOption(id: "b", text: "だいたいできている", point: 3),
        AnswerOption(id: "c", text: "たまにできる", point: 2),
        AnswerOption(id: "d", text: "ほぼできない", point: 0)
    ]

    private static let quizMindSet = [
        AnswerOption(id: "a", text: "答えを見る前に粘る", point: 4),
        AnswerOption(id: "b", text: "少し考えてから見る", point: 3),
        AnswerOption(id: "c", text: "雰囲気で突撃する", point: 2),
        AnswerOption(id: "d", text: "即答えを見る", point: 0)
    ]

    private static let commonBands = [
        ScoreBand(id: "starter", minScore: 20, title: "チュートリアル中", comment: "まだ操作確認の段階です。今日の結果は軽いネタとして楽しんで、次の一回で巻き返しましょう。"),
        ScoreBand(id: "standard", minScore: 45, title: "ふつうに強い", comment: "平均ラインをしっかり踏んでいます。目立ちすぎず、でも場面によってはちゃんと勝てるタイプです。"),
        ScoreBand(id: "high", minScore: 58, title: "上位プレイヤー", comment: "なかなか高めの結果です。得意分野として名乗っても、たぶん空気は壊れません。"),
        ScoreBand(id: "legend", minScore: 70, title: "ボス部屋前", comment: "かなり高めです。スクショして自慢したくなるラインまで来ています。")
    ]

    private static let marriage = Diagnosis(
        id: "marriage",
        title: "婚活偏差値",
        shortTitle: "婚活",
        category: .romance,
        summary: "年齢、年収、生活力、距離感をまるごとネタ採点。",
        estimatedMinutes: 4,
        questions: [
            number("marriage-1", "あなたの年齢は？", placeholder: "29", unit: "歳", helper: "エンタメ用の入力です。年齢だけで決まる診断ではありません。", scoring: .range(min: 24, max: 39, zeroBelow: 18, zeroAbove: 58)),
            number("marriage-2", "現在の年収は？", placeholder: "450", unit: "万円", helper: "生活安定度っぽさをゆるく見ます。もちろんネタ採点です。", scoring: .higher(min: 180, max: 850)),
            number("marriage-3", "生活防御資金は何か月分くらいありますか？", placeholder: "6", unit: "か月", helper: "急な出費への耐性をざっくり測ります。", scoring: .range(min: 3, max: 12, zeroBelow: 0, zeroAbove: 36)),
            number("marriage-4", "気になる人への平均返信時間は？", placeholder: "3", unit: "時間", helper: "早すぎても遅すぎてもゲーム的に少しクセあり扱いです。", scoring: .range(min: 0.5, max: 18, zeroBelow: 0, zeroAbove: 96)),
            choice("marriage-5", "初対面でも相手の話を広げるのは得意だ", agreeSet),
            choice("marriage-6", "予定変更があっても落ち着いて調整できる", agreeSet),
            choice("marriage-7", "家事や生活の分担について話し合うのは苦ではない", agreeSet),
            choice("marriage-8", "お金の使い方はわりと計画的だ", agreeSet),
            choice("marriage-9", "相手の趣味や価値観をすぐ否定しない", agreeSet),
            choice("marriage-10", "返信が遅くても必要以上に不安になりにくい", agreeSet),
            choice("marriage-11", "自分の弱点を軽く言語化できる", agreeSet),
            choice("marriage-12", "清潔感には普段から気を配っている", agreeSet),
            choice("marriage-13", "将来の暮らし方について考えたことがある", agreeSet),
            choice("marriage-14", "相手を楽しませるより、一緒に楽しむことを大事にしたい", agreeSet),
            choice("marriage-15", "ケンカしたあとに自分から歩み寄れる", agreeSet)
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
            number("iq-1", "17 + 28 × 2 = ?", placeholder: "73", unit: "", helper: "掛け算を先に計算します。", scoring: .exact(73)),
            number("iq-2", "144 ÷ 12 + 9 = ?", placeholder: "21", unit: "", helper: "暗算の肩慣らしです。", scoring: .exact(21)),
            number("iq-3", "3, 6, 12, 24 の次は？", placeholder: "48", unit: "", helper: "規則性を見つけて入力してください。", scoring: .exact(48)),
            number("iq-4", "240の15%はいくつ？", placeholder: "36", unit: "", helper: "割合問題です。", scoring: .exact(36)),
            number("iq-5", "5本で750円のペン。8本なら何円？", placeholder: "1200", unit: "円", helper: "単価を出してから計算します。", scoring: .exact(1200)),
            choice("iq-6", "数字や規則性を見ると、つい法則を探してしまう", agreeSet),
            choice("iq-7", "知らない言葉でも文脈から意味を推測するのが好きだ", agreeSet),
            choice("iq-8", "パズルやなぞなぞは答えを見る前に粘りたい", quizMindSet),
            choice("iq-9", "説明を聞くとき、例外や前提条件が気になる", agreeSet),
            choice("iq-10", "複数の情報をまとめて結論を出すのは得意だ", agreeSet),
            choice("iq-11", "暗算や概算でだいたいの数字を出せる", confidenceSet),
            choice("iq-12", "会話の中の矛盾に気づきやすい", agreeSet),
            choice("iq-13", "初めて見るゲームのルールを覚えるのは早い", agreeSet),
            choice("iq-14", "難しい問題ほど少し燃える", agreeSet),
            choice("iq-15", "この診断はIQ検査ではなくネタだと分かっている", agreeSet)
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
            number("communication-1", "初対面の場で名前を覚えられる人数は？", placeholder: "4", unit: "人", helper: "多いほど場を見渡せる扱いです。", scoring: .higher(min: 0, max: 7)),
            number("communication-2", "1分で出せる雑談テーマはいくつ？", placeholder: "5", unit: "個", helper: "天気以外も出せると強めです。", scoring: .higher(min: 0, max: 8)),
            number("communication-3", "LINEやDMを平均どれくらい寝かせますか？", placeholder: "4", unit: "時間", helper: "即レスすぎず放置しすぎず、ほどよい距離感を見ます。", scoring: .range(min: 0.5, max: 24, zeroBelow: 0, zeroAbove: 120)),
            number("communication-4", "会話中、自分が話す割合は何%くらい？", placeholder: "50", unit: "%", helper: "50%に近いほどキャッチボール扱いです。", scoring: .closest(to: 50, zeroDistance: 45)),
            number("communication-5", "沈黙が続いても平気な秒数は？", placeholder: "10", unit: "秒", helper: "少しの沈黙を怖がらない力です。", scoring: .range(min: 5, max: 40, zeroBelow: 0, zeroAbove: 180)),
            choice("communication-6", "相手が話しやすい質問を自然に出せる", agreeSet),
            choice("communication-7", "場の空気が重いとき、軽くほぐす一言を探せる", agreeSet),
            choice("communication-8", "断るときも相手を傷つけにくい言い方を選べる", agreeSet),
            choice("communication-9", "知らない人がいる場でも最低限の会話はできる", agreeSet),
            choice("communication-10", "SNSで距離を詰めすぎないよう意識している", agreeSet),
            choice("communication-11", "相手の表情やテンションの変化に気づくことが多い", agreeSet),
            choice("communication-12", "自分ばかり話していないか時々チェックしている", agreeSet),
            choice("communication-13", "褒めるときは具体的に伝える方だ", agreeSet),
            choice("communication-14", "誘いを断られても必要以上に引きずらない", agreeSet),
            choice("communication-15", "話を盛り上げるより、相手が楽にいられることも大事にできる", agreeSet)
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
            number("job-change-1", "現在の職種経験は何年くらい？", placeholder: "5", unit: "年", helper: "経験の厚みをざっくり見ます。", scoring: .range(min: 2, max: 12, zeroBelow: 0, zeroAbove: 30)),
            number("job-change-2", "職務経歴書を最後に更新したのは何か月前？", placeholder: "2", unit: "か月前", helper: "最近触っているほど準備済み扱いです。", scoring: .lower(min: 0, max: 24)),
            number("job-change-3", "希望年収アップ率は何%くらい？", placeholder: "15", unit: "%", helper: "攻めすぎず弱すぎずの現実味を見ます。", scoring: .range(min: 5, max: 25, zeroBelow: 0, zeroAbove: 80)),
            number("job-change-4", "1か月で応募できそうな企業数は？", placeholder: "8", unit: "社", helper: "行動量のゲーム値です。", scoring: .range(min: 3, max: 20, zeroBelow: 0, zeroAbove: 60)),
            number("job-change-5", "週にスキル学習へ使える時間は？", placeholder: "5", unit: "時間", helper: "少しでも継続できると強いです。", scoring: .higher(min: 0, max: 8)),
            choice("job-change-6", "自分の実績を数字で説明できる", confidenceSet),
            choice("job-change-7", "転職理由を前向きな言葉に変換できる", agreeSet),
            choice("job-change-8", "希望条件に優先順位をつけられる", agreeSet),
            choice("job-change-9", "現職の不満だけで判断しないようにしている", agreeSet),
            choice("job-change-10", "面接で聞かれそうな弱点を準備している", frequencySet),
            choice("job-change-11", "業界や会社のニュースを少し追っている", frequencySet),
            choice("job-change-12", "ポートフォリオや成果物を見せられる", confidenceSet),
            choice("job-change-13", "退職時の引き継ぎまで考えられる", agreeSet),
            choice("job-change-14", "年収以外の働きやすさも見ている", agreeSet),
            choice("job-change-15", "内定が出ても即決せず比較できる", agreeSet)
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
            number("job-hunting-1", "企業研究した会社数は？", placeholder: "12", unit: "社", helper: "広く見ているほど探索力が高めです。", scoring: .higher(min: 0, max: 20)),
            number("job-hunting-2", "模擬面接をした回数は？", placeholder: "3", unit: "回", helper: "本番前の練習量です。", scoring: .higher(min: 0, max: 8)),
            number("job-hunting-3", "エントリーシートの下書き数は？", placeholder: "5", unit: "本", helper: "書いて直した数は地味に効きます。", scoring: .higher(min: 0, max: 8)),
            number("job-hunting-4", "自己PRを話す長さは何秒くらい？", placeholder: "60", unit: "秒", helper: "60秒前後に近いほどまとまり良し扱いです。", scoring: .closest(to: 60, zeroDistance: 45)),
            number("job-hunting-5", "SPI風: 12 × 8 + 15 = ?", placeholder: "111", unit: "", helper: "軽い計算問題です。", scoring: .exact(111)),
            choice("job-hunting-6", "学生時代に力を入れたことを1分で話せる", confidenceSet),
            choice("job-hunting-7", "志望動機を会社ごとに少し変えられる", frequencySet),
            choice("job-hunting-8", "面接で逆質問を2つ以上用意できる", confidenceSet),
            choice("job-hunting-9", "落ちても次の改善点を探せる", agreeSet),
            choice("job-hunting-10", "服装や身だしなみを事前に確認する", frequencySet),
            choice("job-hunting-11", "締切をカレンダーで管理している", frequencySet),
            choice("job-hunting-12", "自己分析の言葉が抽象的すぎない", agreeSet),
            choice("job-hunting-13", "友人や先輩にESを見てもらえる", confidenceSet),
            choice("job-hunting-14", "第一志望以外の選択肢も持っている", agreeSet),
            choice("job-hunting-15", "緊張しても最初のあいさつは出せる", confidenceSet)
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
            number("buzz-1", "1週間に投稿する回数は？", placeholder: "4", unit: "回", helper: "継続感と出しすぎない感じを見ます。", scoring: .range(min: 1, max: 7, zeroBelow: 0, zeroAbove: 30)),
            number("buzz-2", "最近の投稿のいいね中央値は？", placeholder: "80", unit: "件", helper: "規模よりも今の反応値として扱います。", scoring: .higher(min: 0, max: 500)),
            number("buzz-3", "投稿文の平均文字数は？", placeholder: "80", unit: "文字", helper: "短すぎず長すぎず、読み切れる長さを評価します。", scoring: .closest(to: 80, zeroDistance: 120)),
            number("buzz-4", "3分で出せる投稿ネタはいくつ？", placeholder: "6", unit: "個", helper: "ひらめきストックの数です。", scoring: .higher(min: 0, max: 10)),
            number("buzz-5", "1日のSNS時間は？", placeholder: "2", unit: "時間", helper: "見すぎより、使いこなしている感を採点します。", scoring: .range(min: 0.5, max: 3, zeroBelow: 0, zeroAbove: 10)),
            choice("buzz-6", "最初の一文でちょっと気を引くのが得意だ", agreeSet),
            choice("buzz-7", "ネタを見つけたらメモに残す", frequencySet),
            choice("buzz-8", "画像やスクショの見やすさを気にする", frequencySet),
            choice("buzz-9", "流行に乗りつつ、自分の言葉にできる", agreeSet),
            choice("buzz-10", "コメントが来たら空気を読んで返せる", agreeSet),
            choice("buzz-11", "投稿前に誤解されないか一度見る", frequencySet),
            choice("buzz-12", "自虐と悪口の境界線を気にしている", agreeSet),
            choice("buzz-13", "短い動画や画像の見せ場を考えられる", confidenceSet),
            choice("buzz-14", "伸びなかった投稿から学べる", agreeSet),
            choice("buzz-15", "バズりより、また見たいと思われることも大事にする", agreeSet)
        ],
        bands: commonBands
    )

    private static func choice(_ id: String, _ text: String, _ options: [AnswerOption]) -> DiagnosisQuestion {
        DiagnosisQuestion(id: id, text: text, input: .choice(options))
    }

    private static func number(
        _ id: String,
        _ text: String,
        placeholder: String,
        unit: String,
        helper: String,
        scoring: NumericScoringRule
    ) -> DiagnosisQuestion {
        DiagnosisQuestion(
            id: id,
            text: text,
            input: .number(
                NumericQuestionConfig(
                    placeholder: placeholder,
                    unit: unit,
                    helperText: helper,
                    scoring: scoring
                )
            )
        )
    }
}
