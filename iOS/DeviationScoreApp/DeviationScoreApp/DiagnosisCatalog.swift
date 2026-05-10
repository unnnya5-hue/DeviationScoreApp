import Foundation

enum DiagnosisCatalog {
    static let diagnoses: [Diagnosis] = [
        marriage,
        iqLike,
        communication
    ]

    static func diagnosis(id: String) -> Diagnosis? {
        diagnoses.first { $0.id == id }
    }

    private static let answerSet = [
        AnswerOption(id: "a", text: "かなり当てはまる", point: 4),
        AnswerOption(id: "b", text: "まあ当てはまる", point: 3),
        AnswerOption(id: "c", text: "あまり当てはまらない", point: 1),
        AnswerOption(id: "d", text: "全然当てはまらない", point: 0)
    ]

    private static let quizAnswerSet = [
        AnswerOption(id: "a", text: "すぐ分かった", point: 4),
        AnswerOption(id: "b", text: "少し考えて分かった", point: 3),
        AnswerOption(id: "c", text: "勘で選んだ", point: 1),
        AnswerOption(id: "d", text: "今回は見送る", point: 0)
    ]

    private static let commonBands = [
        ScoreBand(id: "starter", minScore: 20, title: "のびしろ枠", comment: "まだまだ伸びる余白がたっぷり。今日の結果は軽いネタとして楽しんでください。"),
        ScoreBand(id: "standard", minScore: 45, title: "平均ど真ん中", comment: "ほどよく普通、でもそれが強い。バランス感覚で勝負できるタイプです。"),
        ScoreBand(id: "high", minScore: 58, title: "なかなか上位勢", comment: "周りから一目置かれる場面がありそう。得意分野として名乗ってもよさげです。"),
        ScoreBand(id: "legend", minScore: 70, title: "界隈エース", comment: "かなり高めの結果です。スクショして自慢したくなるラインに来ています。")
    ]

    private static let marriage = Diagnosis(
        id: "marriage",
        title: "婚活偏差値",
        shortTitle: "婚活",
        category: .romance,
        summary: "恋愛観、生活力、距離感、金銭感覚をゆるく測るネタ診断。",
        estimatedMinutes: 2,
        questions: [
            question("marriage-1", "初対面でも相手の話を広げるのは得意だ", answerSet),
            question("marriage-2", "予定変更があっても落ち着いて調整できる", answerSet),
            question("marriage-3", "家事や生活の分担について話し合うのは苦ではない", answerSet),
            question("marriage-4", "お金の使い方はわりと計画的だ", answerSet),
            question("marriage-5", "相手の趣味や価値観をすぐ否定しない", answerSet),
            question("marriage-6", "返信が遅くても必要以上に不安になりにくい", answerSet),
            question("marriage-7", "自分の弱点を軽く言語化できる", answerSet),
            question("marriage-8", "清潔感には普段から気を配っている", answerSet),
            question("marriage-9", "将来の暮らし方について考えたことがある", answerSet),
            question("marriage-10", "相手を楽しませるより、一緒に楽しむことを大事にしたい", answerSet)
        ],
        bands: commonBands
    )

    private static let iqLike = Diagnosis(
        id: "iq-like",
        title: "IQ風クイズ偏差値",
        shortTitle: "IQ風",
        category: .knowledge,
        summary: "論理、ひらめき、言葉遊びをIQっぽく楽しむクイズ診断。",
        estimatedMinutes: 3,
        questions: [
            question("iq-1", "数字や規則性を見ると、つい法則を探してしまう", answerSet),
            question("iq-2", "知らない言葉でも文脈から意味を推測するのが好きだ", answerSet),
            question("iq-3", "パズルやなぞなぞは答えを見る前に粘りたい", answerSet),
            question("iq-4", "説明を聞くとき、例外や前提条件が気になる", answerSet),
            question("iq-5", "複数の情報をまとめて結論を出すのは得意だ", answerSet),
            question("iq-6", "暗算や概算でだいたいの数字を出せる", answerSet),
            question("iq-7", "会話の中の矛盾に気づきやすい", answerSet),
            question("iq-8", "初めて見るゲームのルールを覚えるのは早い", answerSet),
            question("iq-9", "難しい問題ほど少し燃える", answerSet),
            question("iq-10", "この診断はIQ検査ではなくネタだと分かっている", quizAnswerSet)
        ],
        bands: commonBands
    )

    private static let communication = Diagnosis(
        id: "communication",
        title: "コミュ力偏差値",
        shortTitle: "コミュ力",
        category: .social,
        summary: "会話、空気感、誘い方、断り方、SNSの距離感を測る診断。",
        estimatedMinutes: 2,
        questions: [
            question("communication-1", "相手が話しやすい質問を自然に出せる", answerSet),
            question("communication-2", "場の空気が重いとき、軽くほぐす一言を探せる", answerSet),
            question("communication-3", "断るときも相手を傷つけにくい言い方を選べる", answerSet),
            question("communication-4", "知らない人がいる場でも最低限の会話はできる", answerSet),
            question("communication-5", "SNSで距離を詰めすぎないよう意識している", answerSet),
            question("communication-6", "相手の表情やテンションの変化に気づくことが多い", answerSet),
            question("communication-7", "自分ばかり話していないか時々チェックしている", answerSet),
            question("communication-8", "褒めるときは具体的に伝える方だ", answerSet),
            question("communication-9", "誘いを断られても必要以上に引きずらない", answerSet),
            question("communication-10", "沈黙があってもすぐ焦らない", answerSet)
        ],
        bands: commonBands
    )

    private static func question(_ id: String, _ text: String, _ options: [AnswerOption]) -> DiagnosisQuestion {
        DiagnosisQuestion(id: id, text: text, options: options)
    }
}

